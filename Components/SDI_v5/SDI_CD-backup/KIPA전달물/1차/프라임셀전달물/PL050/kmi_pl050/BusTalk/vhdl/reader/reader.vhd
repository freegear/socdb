-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1998 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- 
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
-- 
-- File Name           : reader.vhd,v 
-- File Revision       : 1.2 
-- 
-- Release Information : PL050-REL1v1 
-- 
-- -----------------------------------------------------------------------------
-- Purpose             : To look at the get line requests and drive the packets
--                       out at the correct time. Get line requests are issued
--                       from blocks when all elements in it are idle. The
--                       request stays high until idle once more.
--                       When the apb block requests a line, the assumption is
--                       that all vr commands have finished and therefore the
--                       next line will be a Bus command. However, when the VR
--                       block requests a line, it does not mean that the next
--                       line is a VR command - it could be APB and in this case
--                       the line is buffered until apb_get_line = g_get.
--                       Buffering is also required in the case that an apb line
--                       is read and there are no vr commands to execute in that
--                       cycle. The reader must look at the next line to see
--                       whether it is VR. If it isn't, it will be buffered.
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;

library Std_DevelopersKit;
use     std_developerskit.std_IOpak.all;

library reader;
use     reader.readline.all;

entity reader is
   generic(
          INFILE : string;
          tclkl  : time;
          tclkh  : time
          );          
 port
    (
     BCLK           : in std_logic;
     apb_get_line   : in T_get;
     vr_get_line    : in T_get;
     apb_packet     : out T_apb;
     vr_packet      : out T_vrbus;
     res_packet     : out T_res;
     pcyc_sel       : out T_cycle;
     vcyc_sel       : out T_cyclebus;
     rcyc_sel       : out T_cycle;
     postatI        : out std_logic 
    );
end reader;


architecture pslave of reader is

  file iINFILE        : ascii_text is in INFILE;

  signal I_CLK        : std_logic;

  -- These flags are set in the low phase and read in the high phase
  -- to indicate which lines have to be driven
  
  signal apb_stored   : boolean   := FALSE;
  signal vr_stored    : T_boolbus :=  (others => FALSE);
  signal res_stored   : boolean   := FALSE;
  
  -- These w_ signals are for IPC as write storage
  
  signal w_apb_packet : T_apb;
  signal w_vr_packet  : T_vrbus;
  signal w_res_packet : T_res;
  signal w_pcyc_sel   : T_cycle;
  signal w_vcyc_sel   : T_cyclebus;
  signal w_rcyc_sel   : T_cycle;

  signal test_end     : boolean := FALSE;
  
begin

    I_CLK <= BCLK after read_setup_delay;

  -- The read process does the clever scheduling.  It shouldn't be neccessary
  -- to change any of this when porting to other test benches. (!)
  
  read : process (I_CLK)
    
    -- variables for use in readline procedure
    
    variable v_cyc_sel    : T_cycle;
    variable v_apb_packet : T_apb;
    variable v_vr_packet  : T_vr;
    variable v_res_packet : T_res;
    
    -- buffer variables

    variable b_cyc_sel     : T_cycle;
    variable b_vcyc_sel    : T_cycle;
    variable b_apb_packet  : T_apb;
    variable b_vr_packet   : T_vr;

    variable apb_buffered  : boolean := FALSE;
    variable end_buffered  : boolean := FALSE;
    variable vr_buffered   : boolean := FALSE;

    variable vr_stored_var : T_boolbus := (others => FALSE);

     variable stored_delay : T_int := 1;

  begin
    if (I_CLK = '0') then

      for i in 0 to 7 loop
      if vr_stored(i) then vr_stored(i) <= FALSE;
      end if;
      end loop;

      if apb_stored then apb_stored <= FALSE;
      end if;
      
      if res_stored then res_stored <= FALSE;
      end if;

      if (apb_get_line = g_get) then
        if end_buffered then
          v_cyc_sel     := c_end;
        elsif not apb_buffered then
          readline(iINFILE,v_apb_packet,v_vr_packet,v_res_packet,v_cyc_sel);
        else 
          v_apb_packet  := b_apb_packet;
          v_cyc_sel     := b_cyc_sel;
          apb_buffered  := FALSE;
        end if;

        if vr_buffered then
          w_vr_packet(b_vr_packet.vregno)   <= b_vr_packet;
          vr_stored(b_vr_packet.vregno)     <= TRUE;
          vr_stored_var(b_vr_packet.vregno) := TRUE;
          w_vcyc_sel(b_vr_packet.vregno)    <= b_vcyc_sel;
          vr_buffered  := FALSE;
        else
          for i in 0 to 7 loop
          vr_stored_var(i) := FALSE;
          end loop;
        end if;

        case v_cyc_sel is

          when c_pnw | c_psw | c_pnr | c_psr | c_pi | c_po  =>
            w_apb_packet  <= v_apb_packet;
            w_pcyc_sel <= v_cyc_sel;
            apb_stored <= TRUE;
            
            loop
            readline(iINFILE,v_apb_packet,v_vr_packet,v_res_packet,v_cyc_sel);

            case v_cyc_sel is
              when c_pnw | c_psw | c_pnr | c_psr | c_pi | c_po   =>
                b_apb_packet := v_apb_packet;
                b_cyc_sel    := v_cyc_sel;
                apb_buffered := TRUE;
                stored_delay := 1;
                exit;
              when c_vr | c_vw =>
                if  (not vr_stored_var(v_vr_packet.vregno)) and 
                     v_vr_packet.delay = stored_delay then
                  w_vr_packet(v_vr_packet.vregno)   <= v_vr_packet;
                  vr_stored(v_vr_packet.vregno)     <= TRUE;
                  vr_stored_var(v_vr_packet.vregno) := TRUE;
                  stored_delay                      := v_vr_packet.delay;
                  w_vcyc_sel(v_vr_packet.vregno)    <= v_cyc_sel;
                else
                  b_vr_packet                      := v_vr_packet;
                  b_vcyc_sel                       := v_cyc_sel;
                  vr_buffered                      := TRUE;
                  stored_delay                     := v_vr_packet.delay;
                  for i in 0 to 7 loop
                  vr_stored_var(i) := FALSE;
                  end loop;
                  exit;
                end if;
              when c_res =>
                w_rcyc_sel   <= v_cyc_sel;
                w_res_packet <= v_res_packet;
                res_stored   <= TRUE;
              when c_end =>
                end_buffered  := TRUE;
                exit;
              when others =>
                null;
                exit;
            end case;

            end loop;

          when c_end =>
            test_end <= TRUE;

          when others =>
            null;

        end case;

    elsif vr_get_line = g_get then

        if vr_buffered then
          w_vr_packet(b_vr_packet.vregno)   <= b_vr_packet;
          vr_stored(b_vr_packet.vregno)     <= TRUE;
          vr_stored_var(b_vr_packet.vregno) := TRUE;
          w_vcyc_sel(b_vr_packet.vregno)    <= b_vcyc_sel;
          vr_buffered                       := FALSE;
        end if;

        if not apb_buffered then
          loop
          readline(iINFILE,v_apb_packet,v_vr_packet,v_res_packet,v_cyc_sel);

          case v_cyc_sel is
            when c_pnw | c_psw | c_pnr | c_psr | c_pi =>
              b_apb_packet := v_apb_packet;
              b_cyc_sel    := v_cyc_sel;
              apb_buffered := TRUE;
              stored_delay := 1;
             exit;
            when c_vr | c_vw =>
              if (not vr_stored_var(v_vr_packet.vregno)) and
                  v_vr_packet.delay = stored_delay  then
                w_vr_packet(v_vr_packet.vregno)   <= v_vr_packet;
                vr_stored(v_vr_packet.vregno)     <= TRUE;
                vr_stored_var(v_vr_packet.vregno) := TRUE;
                stored_delay                      := v_vr_packet.delay;
                w_vcyc_sel(v_vr_packet.vregno)    <= v_cyc_sel;
              else
                b_vr_packet                      := v_vr_packet;
                b_vcyc_sel                       := v_cyc_sel;
                vr_buffered                      := TRUE;
                stored_delay                     := v_vr_packet.delay;
                for i in 0 to 7 loop
                vr_stored_var(i) := FALSE;
                end loop;
                exit;
              end if;
            when c_res =>
              w_rcyc_sel   <= v_cyc_sel;
              w_res_packet <= v_res_packet;
              res_stored   <= TRUE;
            when c_end =>
              test_end      <= TRUE;
              exit;
            when others =>
              null;
              exit;
          end case;
          end loop;
        end if;
      end if;
    end if;
  end process;

  -- This drive process looks at the stored flags and then drives the w_
  -- signals onto the output in the high phase of BCLK.
  -- Note that info is only reliably sampled in the first high phase
  -- since the cycle select signals will go to idle in the low phase.

  drive : process(BCLK)
  begin
    if rising_edge(BCLK) then
      if apb_stored then        
        apb_packet <= w_apb_packet;
        pcyc_sel <= w_pcyc_sel;
        if (w_pcyc_sel /= c_po)   then 
          postatI <= '0'; -- indicates that the command is not a poll command.
        else
          postatI <= '1'; -- indicates that the command is a poll command.
        end if;
      else
        pcyc_sel <= c_idle;
      end if;

      if res_stored then
        res_packet <= w_res_packet;
        rcyc_sel   <= w_rcyc_sel;
      else
        rcyc_sel <= c_idle;
      end if;

      for i in 0 to 7 loop
      if vr_stored(i) then
        vr_packet(i)   <= w_vr_packet(i);
        vcyc_sel(i)    <= w_vcyc_sel(i);
      else
        vcyc_sel(i)    <= c_idle;
      end if;
      end loop;

    elsif falling_edge(BCLK) then
      for i in 0 to 7 loop
        vcyc_sel(i) <= c_idle;
      end loop;
      pcyc_sel    <= c_idle;
      rcyc_sel    <= c_idle;
    end if;
   
  end process;

  finish : process
  begin
   wait until test_end;
   wait for tclkl + tclkh;         
   assert false report "End of test" severity failure;
  end process;

end pslave;

-- --================================= End ===================================--
