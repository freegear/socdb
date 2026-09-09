-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- 
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
-- 
-- File Name           : buscyc_drivers.vhd.rca
-- File Revision       : 1.1 
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-REL1v6
-- 
-- ---------------------------------------------------------------------
-- Purpose : 
--           This instantiates an APB cycle driver for each cycle
--           type i.e. PSW, PSR, PNW, PNR, PI and PO. It multiplexes
--           the output - the APB getline will only say 'get' when
--           all drivers are idle. The line driver select lines are
--           driven according to their timing .
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;
use     common.funcs.all;

entity buscyc_drivers is
  generic(
          Verbosity : boolean
         );
  port
    (
       PCLK         : in std_logic;
       PRESETn      : in std_logic;
       cyc_sel      : in T_cycle;
       apb_packet   : in T_apb;
       postatO      : in std_logic;
       postatI      : in std_logic;
       apb_get_line : out T_get;
       PADDR_sel    : out T_a_drv_sel;
       PWDATA_sel   : out T_d_drv_sel;
       PSEL_sel     : out T_a_drv_sel;
       PWRITE_sel   : out T_a_drv_sel;
       PENABLE_sel  : out T_t_drv_sel;
       cyc_count    : out T_int
       );
end buscyc_drivers;

architecture behavioural of buscyc_drivers is
    
  component countdown
  port(
       PCLK       : in std_logic;
       Val        : in T_int;
       last       : out T_int
       );
  end component;

  signal Val     : T_int := 0;
  signal last    : T_int := 0;
  signal i_cyc_count : T_int;

  signal a_state      : T_a_drv_sel := a_idle; --  for PADDR, PWr
  signal t_state      : T_t_drv_sel := en_ph1; --      PENABLE
  signal s_state      : T_a_drv_sel := a_idle; --      PSEL 
  signal d_state      : T_d_drv_sel := d_idle; --      PWDATA 
  signal next_state   : T_t_drv_sel := en_ph1; --      PENABLE 
  signal i_state      : T_a_drv_sel := a_idle; 
                                       --  special state for PI counting

begin 

  u_countdown : countdown 
  port map ( 
       PCLK       => PCLK, 
       Val        => Val,
       last       => last
    );  

  -- here the select lines are assigned according to their timing
  
  PADDR_sel   <= a_state;
  PWRITE_sel  <= a_state;
  PENABLE_sel <= t_state;
  PSEL_sel    <= s_state;
  PWDATA_sel  <= d_state;

      i_cyc_count    <= (apb_packet.num_cyc - last + 1) when PCLK = '0'
                                                                    else
                        i_cyc_count;
 
      cyc_count  <= i_cyc_count;

--  Load num_cyc into counter

  loader : process (cyc_sel, PCLK, postatO)
  begin
    if (cyc_sel = c_psr or cyc_sel = c_psw
      or cyc_sel = c_pnr or cyc_sel = c_pnw or cyc_sel = c_po or
    (cyc_sel = c_idle and postatI ='1' and last = 1 and 
                                                rising_edge(PCLK))) then
      Val <= 2;
    elsif (cyc_sel = c_idle and last = 1 and postatO'event and 
           postatO = '0') then
      Val <= 1;
    elsif cyc_sel = c_pi then
      Val <= apb_packet.num_cyc;
    else
      Val <= 0;
    end if;
  end process;

 --  PI idle cycle timing
  --  Cannot use just a_state to determine when next apb packet is 
  -- required because the PI command does not drive an address. So 
  -- a new signal i_state is added.
  i_timing : process (last,i_state,cyc_sel,PCLK)
  begin
    if (i_state = a_idle) and (cyc_sel = c_pi) then
      i_state <= a_addr;
    elsif (a_state = a_addr) and (last = 1) and rising_edge(PCLK) then
      i_state <= a_idle;
    end if;
  end process;
  
 --  PADDR_sel and PWrite timing
  a_timing : process (last,a_state,cyc_sel,PCLK,PRESETn)
  begin
    if (PRESETn = '0') then
      a_state <= a_idle;
    elsif (a_state = a_idle) and
      (cyc_sel = c_psr or cyc_sel = c_psw
       or cyc_sel = c_pnr or cyc_sel = c_pnw or cyc_sel = c_po or 
       (postatI ='1' and (cyc_sel = c_idle)) ) then
      a_state <= a_addr;
    elsif ((a_state = a_addr) and (last = 1) and rising_edge(PCLK)) then
      a_state <= a_idle;
    end if;
  end process;

 --  PSEL timing
  s_timing : process (last,s_state,cyc_sel,PCLK,PRESETn)
  begin
    if (PRESETn = '0') then
      s_state <= a_idle;
    elsif ((s_state = a_idle) and ((cyc_sel /= c_idle) or 
           (postatI ='1' and (cyc_sel = c_idle)))) then
      s_state <= a_addr;
    elsif ((s_state = a_addr) and (last = 1) and rising_edge(PCLK)) then
      s_state <= a_idle;
    end if;
  end process;

--  PWDATA timing
  d_timing : process (last,d_state,cyc_sel,PCLK,PRESETn)
  begin
    if (PRESETn = '0') then
      d_state <= d_reset;
    elsif (PRESETn = '1') and d_state = d_reset then
        d_state <= d_idle;    
    elsif (d_state = d_idle) and (cyc_sel = c_psr  or cyc_sel = c_po or 
          (cyc_sel = c_idle and postatO = '1' ) ) then 
      d_state <= dr_idle;
    elsif (d_state = d_idle) and (cyc_sel = c_pnr) then 
      d_state <= d_idle;
    elsif (d_state = d_idle) and (cyc_sel = c_psw or cyc_sel = c_pnw) 
                                                                    then
      d_state <= d_write;      
    elsif (d_state = dr_idle) and rising_edge(PCLK) then 
      d_state <= d_read;
    elsif ((last = 1) and rising_edge(PCLK)) then
      d_state <= d_idle;
    end if;
  end process;
  
 --  PENABLE timing
  t_timing : process (PRESETn,t_state,cyc_sel,PCLK)
  begin

    if (PRESETn = '0') then
      t_state <= en_ph1;
      next_state <= en_ph1;
    else
      if PCLK'event then
        t_state <= next_state;
      end if;

      if PCLK = '1' then 
        if  (cyc_sel = c_pnr or cyc_sel = c_psr
              or cyc_sel = c_pnw or cyc_sel = c_psw or cyc_sel = c_po 
              or (cyc_sel= c_idle and postatO = '1')) and 
                                                  t_state = en_ph1  then
            next_state <= en_ph2;
        end if;
        if t_state = en_ph3 then
          next_state <= en_ph4;
        end if;
      end if;
         
      if PCLK = '0' then
        case t_state is
          when en_ph2 =>
            next_state <= en_ph3;
          when en_ph4 =>
            next_state <= en_ph1;
          when others =>
            null;
        end case;
      end if;
    end if;
    
  end process;

  line_output : process (last, a_state, postatO, cyc_sel)
  begin
    if ((last = 1) or ( (a_state = a_idle) and (i_state = a_idle))) then
      if (postatI /= '1' or falling_edge(postatO) or postatO /= '1') 
                                                                    then
        apb_get_line <= g_get; -- apb_get_line goes to g_get at the end
                               -- of a Poll command execution or when 
                               -- all the drivers are in idle state.
      end if;
    else
      apb_get_line <= g_idle;
    end if;
  end process;

  report_cyc : process (cyc_sel)
  begin
    if (cyc_sel /= c_idle) and Verbosity then
      ReportP_Cycle(cyc_sel, apb_packet.exp, apb_packet.mask, 
                     apb_packet.addr, apb_packet.data, apb_packet.tag, 
                     apb_packet.num_cyc);
    end if;
  end process;

end behavioural;

-- --============================= End ===============================--
