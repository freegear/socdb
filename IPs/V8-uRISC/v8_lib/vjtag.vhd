----------------------------------------------------------------------
-- Copyright 1997 VAutomation Inc. Nashua NH
-- HTTP://WWW.VAutomation.com ALL RIGHTS RESERVED. This software is
-- provided under license and contains proprietary and confidential
-- material which is the property of VAutomation Inc.
--
-- File: vjtag.vhd      Gate Count: 113 gates
-- Revision: $Name: REV9910 $
-- Description:
--
-- 1149.1 JTAG TAP controller as described in the IEEE 1149.1-1990
-- specification page 5-14.
--
-- Only the TAP controller (state machine), the bypass Flop and the
-- negative edge flop for TDO are provided by this module. The
-- instruction register and all scan logic must be added external to
-- this core.
--
-- All flops clock on the rising edge of CLK, NOT TCK!!! CLK is the CPU
-- clock which allows the jtag debug logic to operate 100% synchronously
-- with the CPU. This makes synthesis and automatic scan test insertion
-- much easier as we only have one clock. As a result, TCK is sampled
-- and the state machine transitions on edge detections. This results
-- in 2-3 cpu CLKs of delay for each edge. Thus, TCK must be 1/8th of
-- the CPU clock frequency or less.
--
-- This design is 100% synchronous. Even reset is synchronous. This is
-- consistent with good ASIC design practices rather than exactly
-- duplicating the logic as described in the spec.
--
-- The JTAG TAP controller state machine goes thru the following
-- states: The value shown next to each transition indicates that
-- state of TMS at the rising edge of TCK.
--
--
--  +>TEST_RESET<---------------------------------------+
--  |1|   |0                                            |
--  +-+   |                                             |
--        v   1                 1                   1   |
--  +>RUN_TEST-+---->SEL_DR_SCAN-------->SEL_IR_SCAN----+
--  |0|   ^    ^         |0                  |0
--  +-+   |    |    1    v              1    v
--        |    |   +-CAPTURE_DR        +-CAPTURE_IR
--        |    |   |     |0            |     |0
--        |    |   |     v             |     v
--        |    | +-->SHIFT_DR<+      +-->SHIFT_IR<+
--        |    | | |     |1 |0|      | |     |1 |0|
--        |    | | |     v  +-+      | |     v  +-+
--        |    | | +>EXIT1_DR---+    | +>EXIT1_IR---+
--        |    | |       |0     |1   |       |0     |1
--        |    | |       v      |    |       v      |
--        |    | |   PAUSE_DR<+ |    |   PAUSE_IR<+ |
--        |    | |       |1 |0| |    |       |1 |0| |
--        |    | |  0    v  +-+ |    |  0    v  +-+ |
--        |    | +---EXIT2_DR   |    +---EXIT2_IR   |
--        |    |         |1     |            |1     |
--        |    |         v      |            v      |
--        |    |     UPDATE_DR<-+        UPDATE_IR<-+
--        |    |       |1  |0              |1  |0
--        |    +-------+-------------------+   |
--        |                |                   |
--        +----------------+-------------------+
--
--
-- State values and a very brief description. See the spec for more
-- detail.
-- TEST_RESET   1111 F Test Logic is disabled.
-- RUN_TEST     1100 C Run the test in the INSTruction register.
-- SEL_DR_SCAN  0111 7 Temporary state.
-- CAPTURE_DR   0110 6 Capture data in the register indicated by INST.
-- SHIFT_DR     0010 2 Shift the data register.
-- EXIT1_DR     0001 1 Temporary state.
-- PAUSE_DR     0011 3 Do nothing.
-- EXIT2_DR     0000 0 Temporary state.
-- UPDATE_DR    0101 5 Load parallel regs with data in the shift reg
-- SEL_IR_SCAN  0100 4 Temporary state.
-- CAPTURE_IR   1110 E Capture data in the INST register.
-- SHIFT_IR     1010 A Shift the INST register.
-- EXIT1_IR     1001 9 Temporary state.
-- PAUSE_IR     1011 B Do nothing.
-- EXIT2_IR     1000 8 Temporary state.
-- UPDATE_IR    1101 D Load parallel regs with data in the shift reg
--
-- Instructions:
-- name         value           description
-- BYPASS       11111111        Bypass instruction (value set by 1149)
-- EXTEST       00000000        Execute test (value set by 1149)
-- All other instructions must be decoded by external logic.
--
-- Note that two architectures are provided (in different files in
-- Verilog). The EMPTY architecture is provided to allow easy removal
-- of the logic when needed. Simply select the desired architecutre in
-- a VHDL configuration statement or in Verilog just read in the
-- desired file.


----------------------------------------------------------------------
-- Revision History
-- $Log: vjtag.vhd,v $
-- Revision 1.13  1999/10/07 17:22:47  mark
-- uncommented out the EMPTY architecture
--
-- Revision 1.12  1999/09/13 20:10:47  eric
-- No logic changes - more RMM updates.
--
-- Revision 1.11  1999/08/25 21:41:14  scott
-- Cleaned up code to shorten width in compliance with RMM
--
-- Revision 1.10  1999/08/24 18:57:03  scott
-- Modified the code to use std_ulogic(_vector) and IEEE numeric_std
-- package
--
-- Revision 1.9  1999/03/19 22:14:04  eric
-- Improved the style for synopsys SYNCHRONOUS reset on all flops.
--
-- Revision 1.8  1999/02/09 13:50:08  monika
-- Made all registers synchronous to processor clock
--
-- Revision 1.1  1999/01/28 19:34:42  monika
-- Initial revision
--
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- USE ieee.std_logic_arith.ALL;

entity vjtag is
  port(
    tck       : in  std_ulogic;  -- clock input
    trst_n    : in  std_ulogic;  -- optional async reset active low
    tms       : in  std_ulogic;  -- Test Mode Select
    tdi       : in  std_ulogic;  -- Test Data In
    tdo       : out std_ulogic;  -- Test Data Out
    tdo_enb   : out std_ulogic;  -- Test Data Out tristate enable
    -- internal connections
    clk       : in  std_ulogic;  -- Internal clock
    tdo_mux   : in  std_ulogic;  -- TDO before the negative edge flop
    bypass    : in  std_ulogic;  -- JTAG instruction=BYPASS
    tdi_r1    : out std_ulogic;  -- TDI flopped on TCK.
    tck_rise  : out std_ulogic;  -- tck rate clock enable
    captureDR : out std_ulogic;  -- JTAG state=CAPTURE_DR
    shiftDR   : out std_ulogic;  -- JTAG state=SHIFT_DR
    updateDR  : out std_ulogic;  -- JTAG state=UPDATE_DR
    captureIR : out std_ulogic;  -- JTAG state=CAPTURE_IR
    shiftIR   : out std_ulogic;  -- JTAG state=SHIFT_IR
    updateIR  : out std_ulogic   -- JTAG state=UPDATE_IR
    );
end vjtag;

ARCHITECTURE empty OF vjtag IS
BEGIN
  tdo                 <= '0';
  tdo_enb     <= '0';
  tdi_r1       <= '0';
  tck_rise      <= '0';
  captureDR   <= '0';
  shiftDR     <= '0';
  updateDR    <= '0';
  captureIR   <= '0';
  shiftIR     <= '0';
  updateIR    <= '0';
END empty;

architecture rtl of vjtag is
  signal state       : std_ulogic_vector(3 downto 0);  -- current state
  -- next state bits
  signal a_nxt       : std_ulogic;
  signal b_nxt       : std_ulogic;
  signal c_nxt       : std_ulogic;
  signal d_nxt       : std_ulogic;
  signal a, b, c, d  : std_ulogic; -- current state in 1149 spec names
  signal tdi_f_local : std_ulogic; -- local version
  signal tdo_enb_nxt   : std_ulogic; -- D input to TDO_ENB flop
  signal tdo_nxt       : std_ulogic; -- D input to TDO flop
  signal itck_rise   : std_ulogic;
  signal tck_fall    : std_ulogic;
  -- The following line is used when translating to Verilog...
  -- synopsys sync_set_reset "trst_n"
  signal tck_r1, tck_r2, tck_r3 : std_ulogic;
  attribute sync_set_reset : string;      -- required for synopsys
  attribute sync_set_reset of trst_n : signal is "true";
  -- required for synopsys


  -- The following provides you with a convenient waveform that
  -- displays the current state of the TAP controller when viewed in a
  -- simulation waveform.
  type JTAG_STATE is
    (exit2_dr, exit1_dr, shift_dr, pause_dr, sel_ir_scan,
     update_dr, capture_dr, sel_dr_scan, exit2_ir, exit1_ir,
     shift_ir, pause_ir, run_test, update_ir, capture_ir, test_reset);
--  signal state_enum : JTAG_STATE; -- for easier debugging in
                                  -- waveform displays

begin

  -- next state logic directly from page 5-14 of the
  -- IEEE 1149.1-1990 spec
  a_nxt <= (not tms and not c and a) or
            (tms and not b) or
            (tms and not a) or
            (tms and d and c);
  b_nxt <= (not tms and b and not a) or
            (not tms and not c) or
            (not tms and not d and b) or
            (not tms and not d and not a) or
            (tms and c and not b) or
            (tms and d and c and a);
  c_nxt <= (c and not b) or
            (c and a) or
            (tms and not b);
  d_nxt <= (d and not c) or
            (d and b) or
            (not tms and c and not b) or
            (not d and c and not b and not a);

  a <= state(0); -- map the state variable to the individual signals
  b <= state(1); -- as they are described in the spec.
  c <= state(2);
  d <= state(3);

  tdo_enb_nxt <= '1' when state="0010" or state="1010"
               -- shiftIR or shiftDR
               else '0';

  captureIR <= '1' when state="1110" else '0';
  shiftIR   <= '1' when state="1010" else '0';
  updateIR  <= '1' when state="1101" else '0';
  captureDR <= '1' when state="0110" else '0';
  shiftDR   <= '1' when state="0010" else '0';
  updateDR  <= '1' when state="0101" else '0';

  -- Mux for the TDO output (before the negative edge flop) mux in the
  -- BYPASS flop when shifting data and the instruction is BYPASS.
  tdo_nxt <= tdi_f_local when bypass='1' and state="0010" else
           tdo_mux;

  tdi_r1 <= tdi_f_local; -- drive the port

  -- make a register tck to synchronize it to the internal clock, and
  -- generate a clock enable to enable the internal clock at the rate
  -- of tck
  rtck_proc : process(clk)
  begin
    if clk'event and clk='1' then
      tck_r3 <= tck_r2;
      tck_r2 <= tck_r1;	-- synchronizers for edge detection
      tck_r1 <= tck;
    end if;
  end process;
  tck_rise  <= itck_rise;
  itck_rise <= tck_r2 and not tck_r3;
  tck_fall  <= not tck_r2 and tck_r3;

  sm_proc: process(clk)	-----------Create the flop flops
  begin
    -- create the 4 STATE bits of the TAP controller
    if (clk'event and clk='1') then	-- state register
      if (trst_n='0') then 	-- sync reset
        state <= "1111";
      elsif itck_rise='1' then
        state <= d_nxt & c_nxt & b_nxt & a_nxt;
      end if;
    end if;
  end process;

  elr_proc: process(clk)	-----------Create the flop flops
  begin
    -- create the bypass flop
    if (clk'event and clk='1') then
      if (trst_n='0') then	-- sync reset
        tdi_f_local <= '0';
      elsif itck_rise='1' then
        tdi_f_local <= tdi;
      end if;
    end if;
  end process;

  gjr_proc: process(clk)	-----------Create the flop flops
  begin
    if (clk'event and clk='1') then
      if (trst_n='0') then -- sync reset
        tdo <= '0';
        tdo_enb <= '0';
      elsif tck_fall='1' then
        tdo <= tdo_nxt;
        tdo_enb <= tdo_enb_nxt;
      end if;
    end if;
  end process;

  -- Remove the following line if your synthesizer doesn't like it.
  -- It is only for debugging and is not connected to anything so the
  -- synthesizer should just ignore it.
  -- state_enum <= JTAG_STATE'val(CONV_INTEGER(UNSIGNED(state)));

end rtl;
