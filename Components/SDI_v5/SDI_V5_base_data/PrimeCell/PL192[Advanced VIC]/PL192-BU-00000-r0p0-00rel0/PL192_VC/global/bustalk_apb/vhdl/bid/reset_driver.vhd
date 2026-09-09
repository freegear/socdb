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
-- File Name           : reset_driver.vhd.rca 
-- File Revision       : 1.1 
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-r8p0-00rel0 
-- 
-- ---------------------------------------------------------------------
-- Purpose  : 
--            PRESETn signal driver To drive PRESETn line low on the 
--            correct phase and hold it low for the defined time. 
--            It gets the phase info in the first delay high phase and 
--            uses it in the last delay cycle to start timing the reset
--            length. To drive the PRESETn line driver with r_drv timing
--            (idle, delay,reset). This is a vr type cycle but onto an 
--            ASB line. The timing of the r_drv signal is shown below
--            for one delay, high phase drive, one reset cycle
--                          _   _   _   _
--                  __/ \_/ \_/ \_/ \__  CLK
--                  __<S>______________  RES_SEL
--                  __<DDDDDXRRR>______  STATE
--
--            There are two counters instanced herein, one for delay
--            and the other for num_cyc
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;
use     common.funcs.all;

entity reset_driver is
  generic(
          Verbosity : boolean;
          tclkl     : time;
          tisnres   : time;
          tihnres   : time;
          reset_del : time
         );
  port(
       res_sel    : in T_cycle;
       PCLK       : in std_logic;
       res_packet : in T_res;
       PRESETn    : out std_logic
       );
end reset_driver;

architecture behavioural of reset_driver is

component countdown
  port(
       PCLK       : in std_logic;
       Val        : in T_int;
       last       : out T_int
       );
  end component;

  signal Val_delay  : T_int := 0;
  signal Val_reset  : T_int := 0;
  signal last_delay : T_int := 0;
  signal last_reset : T_int := 0;
  signal r_state    : T_reset := r_idle;

  signal i_nres : std_logic := '1';

begin

  PRESETn <= i_nres; 

  -- This process loads the counters with the timing values. Note that
  -- the delay counter is loaded with an incremented value because
  -- a delay of 0 is equivalent to a cycle of 1, etc.
  
  loader : process (res_sel,last_delay,r_state)
    variable i_num_cyc : T_int;
  begin 
    if (res_sel = c_res) then
      Val_delay <= res_packet.delay + 1;
      i_num_cyc := res_packet.num_cyc;
    elsif (r_state = r_res) and (last_delay = 1) then
      Val_reset <= i_num_cyc;
    else
      Val_reset <= 0;
      Val_delay <= 0;
    end if;
  end process;

  -- This process changes the state (example shown at top of file) with
  -- info. from the timers.
  
  timing : process (res_sel,last_reset,last_delay,r_state)
  begin
    if (res_sel = c_res) and (r_state = r_idle) then
      r_state <= r_del;
    elsif (r_state = r_del) and 
      (last_delay'event and last_delay = 1) then
      r_state <= r_res;
    elsif (r_state = r_res) and (last_reset'event and last_reset = 1) 
                                                                    then
      r_state <= r_idle;
    end if;
  end process;
  
  line_driver : process (r_state, PCLK, i_nres)
    variable i_phase : T_line; -- holds which phase of PCLK reset is 
                               -- driven low
  begin
  if r_state'event and (r_state = r_del) then
    i_phase := res_packet.phase; -- on entering delay state, store phase
                                 -- info. 
  elsif (r_state = r_res) and ((PCLK = i_phase) or (i_nres = '0')) then
    i_nres <= '0' after reset_del; -- if in the correct phase drive 
                                   -- reset low
  elsif i_nres = '0' then
    i_nres <= '1' after (tihnres);
  else
    i_nres <= '1' after (Tclkl - Tisnres - Tihnres); 
                                   -- else drive it high
  end if;
  end process;

-- The following process prints out status change information of the 
-- reset signal at the time it occurs in the low PCLK phase of the 
-- previous cycle.

  report_res : process (i_nres)
  begin
      if Verbosity then
      ReportReset(i_nres);
      end if;
  end process;
   
  u_countdown_delay : countdown
    port map(
         PCLK      => PCLK,
         Val       => Val_delay,
         last      => last_delay
         );

  u_countdown_reset : countdown
    port map(
         PCLK      => PCLK,
         Val       => Val_reset,
         last      => last_reset
         );
  
end behavioural;

-- --============================= End ===============================--
