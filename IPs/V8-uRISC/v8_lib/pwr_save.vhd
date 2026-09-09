----------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH
-- HTTP://WWW.VAutomation.com ALL RIGHTS RESERVED. This software is
-- provided under license and contains proprietary and confidential
-- material which is the property of VAutomation Inc.
--
-- File: pwr_save.vhd
-- Revision: $Name: REV9910 $
-- Gate Count:  400 gates
-- Description:
--      This logic provides four power saving modes of operation.
--      All of the modes are entered by programming the registers.
--      All of the low power modes are exitied when any of the QUIET
--      signals changes from it's default state to an active state.
--
--  REST mode:
--      In REST mode, the REST output is active. REST is normally
--      connected to the wait-state generator of the uP (READY on the
--      V8) and causes an infinite wait-state to be generated. This
--      halts the uP which reduces power consumption. All clocks
--      continue to run so timers, UARTs and other peripherals can
--      wake up the uP.
--
--  SLEEP mode:
--
--      In SLEEP mode, the clock to the entire chip is gated off. This
--      typically stops the clock to the entire chip. UARTs and Timers
--      will no longer function so only external logic will wake the
--      processor. The oscillator continues to run as do several
--      Flip-Flops which are external to this modeule. This is a
--      reliable low-power mode as the oscillator continues to run and
--      is stable. Typically saves another 10-15%.
--
--  GLO_TRI mode:
--
--      GLO_TRI mode requires support from the IO cell level of the
--      target chip. This mode causes all IO cells to go into tristate
--      mode which in turn reduces current drain further. Care must be
--      take to NOT tristate the oscillator signals and that all
--      important external signals have pullup or pulldowns to insure
--      external devices are also deactivated. Typically this mode is
--      entered in addition to one of the other three modes.
--
--  STOP_OSC mode:
--
--      STOP_OSC mode also requires external support. If a crystal
--      oscillator IO cell is used, this signal will gate the feedback
--      (or output) cell which in turn stops the oscillator. This is
--      the lowest power consumption mode and should be at the lowest
--      CMOS leakage levels (IE: nanoamps). Care must be taken when
--      restarting the oscillator to wait until it has stabilized
--      before allowing the microprocessor to begin operating. You
--      shouls always set the SLEEP bit along with the STOP_OSC bit as
--      the SLEEP bit will gate the clock for a few clocks while the
--      oscillator is starting up.
--
-- Register Definition:
--
-- addr Name    R/W Description
--  0   CONTROL R/W Control register
--                  [0]=rest        halt the microprocessor (clocks run)
--                  [1]=sleep       stop clock (oscillator runs 3 DFFS) 
--                  [2]=GlobalTri   Tristate all IO cells
--                  [3]=stop_osc    stop the oscillator
--  1   STATUS  R   Current status of the QUIET signals
--  2   POLRTY  R/W Polarity of the inactive state of the QUIET signals.
--  3   ENABLE  R/W Enabled QUIET inputs.
--
--  Typically, when software decides it's time to go to sleep, it will
--  read the status register and decide if the QUIET signals are in
--  their desired state. Write the value read from the STATUS register
--  into the POLRTY register. This sets the current value of the QUIET
--  signals to be the "quiet" state. Write the ENABLE register with
--  the bits that you want to wake-up on being a one, all other bits
--  should be zero. Finally, write the CONTROL register with a one in
--  the sleep mode selected. For maximum power reduction, typically
--  you'll want to set the GLO_TRI and STOP_OSC mode bits. Typically
--  REST mode is used as in your applications "idle loop" when it is
--  waiting for something to process. SLEEP mode is typically used
--  when fine control over the oscilator is not available or you need
--  to wake up quickly and cannot wait for the oscillator to
--  stabilize.
-- 
-- Limitations:         !!!!!!!! NOTE !!!!!!!
--      This module REQUIRES support from external logic. At a
--      minimum, 3 flip-flops with async resets and a 2 input gate
--      must be provided at a level outside of this module. Typically
--      these gates are implemented at the IO CELL level of the ASIC
--      so that you can have full control over them.
--
-- Typical Implementation:
--      Typically the GLO_TRI signal is simply added as a term to all
--      tristate enables of all output pins. When GLO_TRI=1, all IOs
--      are tristate.
--
--      REST is simply added as a term to any wait state generator to
--      the processor which will hold it in an infinite wait state.
--      Stop the processor when REST=1.
--
--      SLEEP must be synchronized to the oscillator clock! This is
--      CRITICAL! SLEEP is ASYNCHRONOUS on wake-up! You MUST
--      synchronize this signal at least twice before gating it with
--      the clock.
--      Reccommended circuit:                            ____
--            +-----+     +-----+           +-----+   \   \
--   SLEEP ---> DFF >-----> DFF >--- ... ---> DFF >---->   \
--            |     |     |     |           |     |    |OR  >---CLK2BUF
--   OSC_CLK-->     |   -->     |         -->     |  -->   /
--            +--O--+     +--O--+           +-----+   /___/
--               |           |
--   RESET_N-----+-----------+
--
--      The first two DFFs synchronize the de-assertion of SLEEP
--      (falling edge). At least the first DFF MUST be asynchronously
--      reset by the external reset signal. Without this it is very
--      unlikely you will have anything but Xes in your gate-level
--      simulations. The last DFF insures a clean transition on the
--      clock. Note that it should not be asynchronously reset.
--      Additional DFFs can also be placed in this path. These will
--      provide additional stages of settling of the oscillator when
--      STOP_OSC mode is used. These stages will prevent a potentially
--      wild clock from propagating thoughout the chip while the
--      oscillator is starting up. If your oscillator has particulary
--      poor startup behavior, you may even want to put a small
--      counter here. Note that these flops run directly on the clock
--      from the oscillator! The do NOT run on the clock from the
--      global clock buffer. CLK2BUF is the signal that drives the
--      global clock buffer. The output of the chain of DFFs is ORed
--      with the clock from the oscillator. This will stop the clock
--      high.
--
--      STOP_OSC is typically wired directly to an enable pin on your
--      crystal oscillator IO cell. The oscillator should stop when
--      STOP_OSC=1. STOP_OSC will go low asynchronously but that
--      should be OK as the only signal it should drive is the enable
--      for the oscillator. SLEEP mode should ALWAYS be used at the
--      same time as STOP_OSC. This will give the oscillator at least
--      a few clocks to settle.

----------------------------------------------------------------------
-- Revision History
-- $Log: pwr_save.vhd,v $
-- Revision 1.10  1999/09/13 20:02:25  eric
-- No logic changes - just more RMM cleanups.
--
-- Revision 1.9  1999/08/25 21:20:55  scott
-- Cleaned up code to shorten width in compliance with RMM
--
-- Revision 1.8  1999/08/24 20:55:52  scott
-- Modified the code to use std_ulogic(_vector) and IEEE numeric_std
-- package
--
-- Revision 1.7  1999/08/24 16:05:30  chris
-- Changed entity style to accomidate vhdl2v rev2.8b14.
--
-- Revision 1.6  1999/04/20 21:24:43  mark
-- added 'empty' architecture
--
-- Revision 1.5  1999/03/19 22:14:47  eric
-- Changed to fully sync logic. Moved the 3 async flops to the top level
-- so they can be easily manipulated by the user.
--
-- Revision 1.4  1998/10/22 21:09:49  eric
-- Corrected the address of the enable and polarity registers to match
-- the doc.
--
-- Revision 1.3  1998/05/31 03:02:01  eric
-- corrected the polarity for control(1)
--
-- Revision 1.2  1998/05/29 20:07:24  eric
-- Forgot to include reset in the sensitivity list.
--
-- Revision 1.1  1998/05/27  01:02:12  eric
-- Initial revision
--
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwr_save is
  port (
    clk      : in  std_ulogic; -- uP clock
    reset    : in  std_ulogic; -- reset
    addr     : in  std_ulogic_vector( 1 downto 0); -- address
    chip_sel : in  std_ulogic; -- Chip select 
    datain   : in  std_ulogic_vector(7 downto 0); -- DATA bus in
    dataout  : out std_ulogic_vector(7 downto 0); -- DATA bus out
    write    : in  std_ulogic; -- uP write 
    quiet    : in  std_ulogic_vector(7 downto 0);
    -- Change on these restarts clock
    rest     : out std_ulogic; -- stop the uP
    sleep    : out std_ulogic; -- stop the clock
    glo_tri  : out std_ulogic; -- Global Tristate enable
    stop_osc : out std_ulogic  -- stop the oscillator
    );
end pwr_save;

architecture empty of pwr_save is ----- ARCHITECTURE empty -----
begin
  rest     <= '0';
  glo_tri  <= '0';
  sleep    <= '0';
  stop_osc <= '0';
  dataout  <= (others => '0');
end empty;

architecture rtl of pwr_save is
  signal enable   : std_ulogic_vector(7 downto 0);
  -- enable specific bits
  signal polarity : std_ulogic_vector(7 downto 0);  -- select polarity
  signal control  : std_ulogic_vector(3 downto 0);  -- control register
  signal all_quiet,all_quiet_r1,all_quiet_R2 : std_ulogic;
  -- quiet signals are inactive

begin

  rest <= control(0);   -- stop the uP. Note that REST
                        -- is fully synchonous.

  sleep <= control(1) and all_quiet;    -- stop the clock.

  glo_tri <= control(2) and all_quiet;  -- tristate all IOs.

  stop_osc <= control(3) and all_quiet; -- stop the oscillator
                                        -- -> very tricky!

  regs_proc: process(clk)    -- create the microprocessor
                        -- interface registers------
  begin
    if (clk'event and clk='1') then
      if (reset='1') then
        control  <= "0000";     -- sync reset
        enable   <= "00000000";
        polarity <= "00000000";
      else
        if (all_quiet_r2='0') then
          control <= "0000";	-- clear the stop signals
                                -- when it's time to run
        elsif (addr="00" and write='1' and chip_sel='1') then
          control <= datain(3 downto 0);
        end if;
        if (addr="10" and write='1' and chip_sel='1') then
          polarity <= datain;
        end if;
        if (addr="11" and write='1' and chip_sel='1') then
          enable <= datain;
        end if;
      end if;
      all_quiet_r2 <= all_quiet_r1; -- synchronizing flops
      all_quiet_r1 <= all_quiet;
    end if;
  end process;

  with addr select
    dataout <= ---------------- data out multiplexor-----------
               "0000" & control when "00",
               quiet            when "01",
               polarity         when "10",
               enable           when "11",
               "XXXXXXXX"       when others;

  -- the next line does all of the real work... the QUIET signals are
  -- XORed with the polarity signals and then gated with the enable
  -- signal. All 8 signals are then gated together to create the
  -- ALL_QUIET signal which is a one when all 8 QUIET signals are at
  -- the same state as the polarity register and that have their
  -- respective enable bit set.

  all_quiet <= '1' when ((polarity xor quiet) and enable) = "00000000"
               else '0';

end rtl;
