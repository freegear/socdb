--------------------------------------------------------------------------------
-- Copyright 1997 VAutomation Inc. Nashua NH HTTP://WWW.VAutomation.com
-- ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: vjtagtst.vhd
-- Revision: $Name: REV9910 $
-- Description:  This file implements a behavioral JTAG master controller with
-- test procedures to test the vjtag TAP controller, and the v8_deice data
-- registers and major functional units.
--
-- The JTAG TAP controller state machine goes thru the following states:
--   The value shown next to each transition indicates that state of
--   TMS at the rising edge of TCK.
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


--------------------------------------------------------------------------------
-- Revision History
-- $Log: vjtagtst.vhd,v $
-- Revision 1.7  1999/12/16 17:00:22  mark
-- * removed 'TYPE BYTE_ARRAY' use of INTEGER RANGE <>. This
--   won't translate into Verilog.  Replaced with 1 TO 256.
--
-- Revision 1.6  1999/03/31 22:54:10  gregg
-- Doubled the TCK_PERIOD to 1320 ns to support low speed.
--
-- Revision 1.5  1998/11/16 20:05:52  chris
-- Doubled the TCK_PERIOD to 660 ns.
--
-- Revision 1.4  1998/09/21 18:41:11  chris
-- Added some wires to support verilog.
--
-- Revision 1.3  1998/09/02 13:57:29  chris
-- Moved the procedure comment blocks so that they would stay with the code
-- through translation to verilog.
--
-- Revision 1.2  1998/09/01 14:51:36  chris
-- Made changes to support translation to verilog.
-- Revised port list to support DDB9 connector on the IPS_PCB.
-- Added test for the BYPASS instruction and the BYPASS register.
-- Changed the processor restart at the end of the test to reset the
-- processor instead of jut branching the PC to 0x0000.
--
-- Revision 1.1  1998/08/26 13:24:54  chris
-- Initial revision
--
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY vjtagtst IS
  PORT (
        dsub9_M_J4_1 : inout std_logic;                             
        dsub9_M_J4_2 : inout std_logic;    -- connects to slave TCK 
        dsub9_M_J4_3 : inout std_logic;    -- connects to slave TMS 
        dsub9_M_J4_4 : inout std_logic;                             
        dsub9_M_J4_5 : inout std_logic;                             
        dsub9_M_J4_6 : inout std_logic;                             
        dsub9_M_J4_7 : inout std_logic;    -- connects to slave TDI 
        dsub9_M_J4_8 : inout std_logic;    -- connects to slave TDO 
        dsub9_M_J4_9 : inout std_logic);                            

END vjtagtst;


ARCHITECTURE empty OF vjtagtst IS
  BEGIN
        dsub9_M_J4_1 <= 'Z';                             
        dsub9_M_J4_2 <= 'Z';    -- connects to slave TCK 
        dsub9_M_J4_3 <= 'Z';    -- connects to slave TMS 
        dsub9_M_J4_4 <= 'Z';                             
        dsub9_M_J4_5 <= 'Z';                             
        dsub9_M_J4_6 <= 'Z';                             
        dsub9_M_J4_7 <= 'Z';    -- connects to slave TDI 
        dsub9_M_J4_8 <= 'Z';    -- connects to slave TDO 
        dsub9_M_J4_9 <= 'Z';                            
  END empty;
  
ARCHITECTURE behav OF vjtagtst IS

TYPE BYTE_ARRAY IS ARRAY (1 TO 256) OF STD_LOGIC_VECTOR(7 DOWNTO 0);

TYPE TAP_STATE IS (TEST_RESET, RUN_TEST, SEL_DR_SCAN, CAPTURE_DR, SHIFT_DR,
                EXIT1_DR, PAUSE_DR, EXIT2_DR, UPDATE_DR, SEL_IR_SCAN,
                CAPTURE_IR, SHIFT_IR, EXIT1_IR, PAUSE_IR, EXIT2_IR, UPDATE_IR);

CONSTANT RAM_SCRATCH_START:    integer := 16#0300#;  -- Area of RAM used by test.
CONSTANT TCK_PERIOD       :    time    := 1320 ns;    -- TCK clock period should
                                                     -- not be less than cpu
                                                     -- period * 4

 -- The V8 DEICE (DEbugger In Circuit Emulator) has the following instructions.
CONSTANT DEICE_EXTEST     : std_logic_vector(7 downto 0) := "00000000"; -- 00
CONSTANT DEICE_STOP       : std_logic_vector(7 downto 0) := "00010001"; -- 11
CONSTANT DEICE_RUN        : std_logic_vector(7 downto 0) := "00100001"; -- 21
CONSTANT DEICE_ENB_BKPT   : std_logic_vector(7 downto 0) := "00110001"; -- 31
CONSTANT DEICE_STATUS     : std_logic_vector(7 downto 0) := "01000001"; -- 41
CONSTANT DEICE_ONE_OP     : std_logic_vector(7 downto 0) := "01010001"; -- 51
CONSTANT DEICE_ONE_CLK    : std_logic_vector(7 downto 0) := "01100001"; -- 61
CONSTANT DEICE_OP_ADDDR   : std_logic_vector(7 downto 0) := "01110001"; -- 71
CONSTANT DEICE_ADDDR      : std_logic_vector(7 downto 0) := "10000001"; -- 81
CONSTANT DEICE_DATA       : std_logic_vector(7 downto 0) := "10010001"; -- 91
CONSTANT DEICE_CTL        : std_logic_vector(7 downto 0) := "10100001"; -- A1
CONSTANT DEICE_BOUND      : std_logic_vector(7 downto 0) := "10110001"; -- B1
CONSTANT DEICE_BREAKPT    : std_logic_vector(7 downto 0) := "11000001"; -- C1
CONSTANT DEICE_MEM_WRITE  : std_logic_vector(7 downto 0) := "00000101"; -- 05
CONSTANT DEICE_MEM_READ   : std_logic_vector(7 downto 0) := "00010101"; -- 15
CONSTANT DEICE_APPLY      : std_logic_vector(7 downto 0) := "01000101"; -- 45
CONSTANT DEICE_APPLY_V8   : std_logic_vector(7 downto 0) := "01010101"; -- 55
CONSTANT DEICE_APPLY_EXT  : std_logic_vector(7 downto 0) := "01100101"; -- 65
CONSTANT DEICE_BYPASS     : std_logic_vector(7 downto 0) := "11111111"; -- FF

COMPONENT dsub9
  port (pin1 : inout std_logic;
        pin2 : inout std_logic;
        pin3 : inout std_logic;
        pin4 : inout std_logic;
        pin5 : inout std_logic;
        pin6 : inout std_logic;
        pin7 : inout std_logic;
        pin8 : inout std_logic;
        pin9 : inout std_logic;
        contact1 : inout std_logic;
        contact2 : inout std_logic;
        contact3 : inout std_logic;
        contact4 : inout std_logic;
        contact5 : inout std_logic;
        contact6 : inout std_logic;
        contact7 : inout std_logic;
        contact8 : inout std_logic;
        contact9 : inout std_logic);

END COMPONENT;

SIGNAL tck    	  : std_logic; 	-- clock input
SIGNAL trst_n 	  : std_logic;	-- optional async reset active low
SIGNAL tms   	  : std_logic;	-- Test Mode Select
SIGNAL tdo   	  : std_logic;	-- Test Data Out
SIGNAL tdi   	  : std_logic;	-- Test Data In
SIGNAL tck_enable : std_logic := '0';    -- TCK enable control signal.
SIGNAL intended_tap_display : TAP_STATE; -- debugging display signal

SIGNAL tck_sig 	  : std_logic; 	-- clock output wire
SIGNAL tms_sig 	  : std_logic; 	-- tms control output wire
SIGNAL tdo_sig 	  : std_logic; 	-- test data output wire

BEGIN
tck_sig <= tck;
tms_sig <= tms;
tdo_sig <= tdo;

J1: dsub9 port map ( 	        -------- The JTAG connector is a 9 pin D---
	pin1 => OPEN,
        pin2 => tck_sig,	-- connects to slave TCK
        pin3 => tms_sig,	-- connects to slave TMS
        pin4 => OPEN,
        pin5 => OPEN,
        pin6 => OPEN,
        pin7 => tdo_sig,	-- connects to slave TDI
        pin8 => tdi,	-- connects to slave TDO
        pin9 => OPEN,
        contact1 => dsub9_M_J4_1,                            
        contact2 => dsub9_M_J4_2,    -- connects to slave TCK
        contact3 => dsub9_M_J4_3,    -- connects to slave TMS
        contact4 => dsub9_M_J4_4,                            
        contact5 => dsub9_M_J4_5,                            
        contact6 => dsub9_M_J4_6,                            
        contact7 => dsub9_M_J4_7,    -- connects to slave TDI
        contact8 => dsub9_M_J4_8,    -- connects to slave TDO
        contact9 => dsub9_M_J4_9);                            

main_test: PROCESS

VARIABLE data_reg : std_logic_vector(55 downto 0); -- Packet data
VARIABLE instruction_reg : std_logic_vector(7 downto  0); -- Packet data
VARIABLE mem_data : BYTE_ARRAY;
VARIABLE breakpoint_mask , breakpoint_reg : std_logic_vector(55 downto 0);
VARIABLE address                          : std_logic_vector(15 downto 0);
VARIABLE data_in,data_out, ctl, psr, int  : std_logic_vector(7 downto 0);

PROCEDURE jtag_reset
  IS

  VARIABLE jr_i : integer;

  BEGIN
--------------------------------------------------------------------------------
--
-- Procedure: jtag_reset
--
-- Parameters:  None
--
-- Description: This procedure will transmit a series of tcks with TMS low to
-- insure that the slave JTAG TAP is in the test reset state when complete.
--
--
--------------------------------------------------------------------------------


    tms <= '1';
    for jr_i IN 1 TO 5 LOOP
      wait until tck'event AND tck = '0'; --  on falling edge tck
    END LOOP;
    intended_tap_display <= TEST_RESET;
  END jtag_reset;

PROCEDURE jtag_run_test
  IS

  BEGIN
--------------------------------------------------------------------------------
--
-- Procedure: jtag_run_test
--
-- Parameters:  None
--
-- Description: This procedure will transmit a series of tcks with TMS low to
-- insure that the slave JTAG TAP is in the test run state.  The scan instruction
-- register and scan data register commands assume that the slave tap starts in
-- the jtag_run_test state
--
--
--------------------------------------------------------------------------------

    jtag_reset;

    tms <= '0';
    intended_tap_display <= RUN_TEST;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    wait until tck'event AND tck = '0'; --  on falling edge tck

  END jtag_run_test;

PROCEDURE scan_instruction_reg(
    VARIABLE data   : INOUT std_logic_vector(7 downto 0); -- data bit to scanned
    CONSTANT length : IN    integer        -- length of register
  ) IS

  VARIABLE sir_i : integer;

  BEGIN
--------------------------------------------------------------------------------
--
-- Procedure: scan_instruction_reg
--
-- Parameters:
--              Length     : length of the instruction register.
--              Data       : intruction value to be shifted.
--
-- Description: This procedure will transmit a series of tcks with TMS low to
-- insure that the slave JTAG TAP is in the test run state.  The scan instruction
-- register and scan data register commands assume that the slave tap starts in
-- the jtag_run_test state
--
--
--------------------------------------------------------------------------------

    -- move the slave TAP from run test to SHIFT IR

    tms <= '1';  intended_tap_display <= SEL_DR_SCAN;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    tms <= '1';  intended_tap_display <= SEL_IR_SCAN;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    tms <= '0';  intended_tap_display <= CAPTURE_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    tms <= '0';  intended_tap_display <= SHIFT_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck

    -- shift the instruction register scan chain out
    FOR sir_i in 0 to length-2 LOOP
      tdo <= data(sir_i);
      tms <= '0';  intended_tap_display <= SHIFT_IR;
      wait until tck'event AND tck = '0'; --  on falling edge tck
    END LOOP;
   tdo <= data(length - 1);

    -- move the slave TAP back to the run test state
    tms <= '1';  intended_tap_display <= EXIT1_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    tdo <= 'Z';
    tms <= '1';  intended_tap_display <= UPDATE_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    tms <= '0';  intended_tap_display <= RUN_TEST;
    wait until tck'event AND tck = '0'; --  on falling edge tck

  END scan_instruction_reg;


PROCEDURE scan_data_reg(
    VARIABLE data   : INOUT std_logic_vector(55 downto 0); -- data bit to scanned
    CONSTANT length : IN    integer                        -- length of register
  ) IS

  VARIABLE sdr_i : integer;

  BEGIN
--------------------------------------------------------------------------------
--
-- Procedure: scan_data_reg
--
-- Parameters:
--              Length     : length of the data register.
--              Data       : data value to be shifted.
--
-- Description: This procedure will transmit a series of tcks with TMS low to
-- insure that the slave JTAG TAP is in the test run state.  The scan instruction
-- register and scan data register commands assume that the slave tap starts in
-- the jtag_run_test state
--
--
--------------------------------------------------------------------------------

    -- move the slave TAP from run test to SHIFT IR
    tms <= '1';  intended_tap_display <= SEL_DR_SCAN;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    tms <= '0';  intended_tap_display <= CAPTURE_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    tms <= '0';  intended_tap_display <= SHIFT_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck

    -- shift the instruction register scan chain out
    FOR sdr_i in 0 to length-2 LOOP
      tdo <= data(sdr_i);
      tms <= '0';  intended_tap_display <= SHIFT_DR;
      wait until tck'event AND tck = '0'; --  on falling edge tck
      data(sdr_i) := tdi;
    END LOOP;
    tdo <= data(length - 1);

    -- move the slave TAP back to the run test state
    tms <= '1';  intended_tap_display <= EXIT1_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    data(length - 1) := tdi;
    tdo <= 'Z';
    tms <= '1';  intended_tap_display <= UPDATE_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    tms <= '0';  intended_tap_display <= RUN_TEST;
    wait until tck'event AND tck = '0'; --  on falling edge tck

  END scan_data_reg;

PROCEDURE jtag_bist
  IS

  VARIABLE jb_i : integer;

  BEGIN
--------------------------------------------------------------------------------
--
-- Procedure: jtag_bist
--
-- Parameters:  None
--
-- Description: Check the integrity of the slave JTAG TAP, instruction register
-- and data regisers.
--
--
--------------------------------------------------------------------------------


    jtag_reset;                     -- reset the slave TAP

    tms <= '1';  intended_tap_display <= RUN_TEST;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';                     -- wait for 2 clocks in the RUN_TEST state
    for jb_i IN 1 TO 2 LOOP
      wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;
    END LOOP;

    ---------------------------------------------------------------------------
    -- Test the Instruction register and the IR states in the TAP
    ---------------------------------------------------------------------------

    tms <= '1';     intended_tap_display <= SEL_DR_SCAN;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;
    tms <= '1';     intended_tap_display <= SEL_IR_SCAN;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;
    tms <= '0';     intended_tap_display <= CAPTURE_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= EXIT1_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= PAUSE_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= EXIT2_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= SHIFT_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tdo <= '0';
    tms <= '0';     intended_tap_display <= SHIFT_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '1' REPORT "First IR bit is not one" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= SHIFT_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '0' REPORT "Second IR bit is not zero" SEVERITY FAILURE;

    tdo <= '0';                     -- Fill the rest of the IR with zeros
    tms <= '0';     intended_tap_display <= SHIFT_IR;
    for jb_i IN 1 TO 6 LOOP
      wait until tck'event AND tck = '0'; --  on falling edge tck
    END LOOP;

    tms <= '1';     intended_tap_display <= EXIT1_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '0' REPORT "TDI Expected 0" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= PAUSE_IR;
    tdo <= '1';
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= PAUSE_IR;
    for jb_i IN 1 TO 6 LOOP
      wait until tck'event AND tck = '0'; --  on falling edge tck
      ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;
    END LOOP;

    tms <= '1';     intended_tap_display <= EXIT2_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= SHIFT_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tdo <= '1';                     -- Fill the IR with ones while shifting out
                                    -- zeros
    tms <= '0';     intended_tap_display <= SHIFT_IR;
    for jb_i IN 1 TO 8 LOOP
      wait until tck'event AND tck = '0'; --  on falling edge tck
      ASSERT tdi = '0' REPORT "TDI Expected 0" SEVERITY FAILURE;
    END LOOP;

    tms <= '1';     intended_tap_display <= EXIT1_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '1' REPORT "TDI Expected 1" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= PAUSE_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= EXIT2_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= UPDATE_IR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= RUN_TEST;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    -- The instruction register is left in the bypass state

    ---------------------------------------------------------------------------
    -- Test the Bypass register.
    ---------------------------------------------------------------------------
    tms <= '1';     intended_tap_display <= SEL_DR_SCAN;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;
    tms <= '0';     intended_tap_display <= CAPTURE_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= SHIFT_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tdo <= '1';
    tms <= '0';     intended_tap_display <= SHIFT_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck

    tdo <= '1';
    tms <= '0';     intended_tap_display <= SHIFT_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '1' REPORT "TDI Expected 1" SEVERITY FAILURE;

    tdo <= '0';
    tms <= '0';     intended_tap_display <= SHIFT_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '1' REPORT "TDI Expected 1" SEVERITY FAILURE;

    tdo <= '1';
    tms <= '0';     intended_tap_display <= SHIFT_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '0' REPORT "TDI Expected 0" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= EXIT1_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '1' REPORT "TDI Expected 1" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= UPDATE_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= RUN_TEST;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;


   ----------------------------------------------------------------------------
   -- Test the Break point register and the DR states in the TAP
   ----------------------------------------------------------------------------

    -- select the breakpoint mask data register scan chain
    instruction_reg := DEICE_BREAKPT;
    scan_instruction_reg(instruction_reg,8);

    tms <= '1';     intended_tap_display <= SEL_DR_SCAN;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;
    tms <= '0';     intended_tap_display <= CAPTURE_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= EXIT1_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= PAUSE_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= EXIT2_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= SHIFT_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= SHIFT_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    tdo <= '0';

    tdo <= '0';                     -- Fill the DR with zeros
    tms <= '0';     intended_tap_display <= SHIFT_DR;
    for jb_i IN 1 TO 56 LOOP
      wait until tck'event AND tck = '0'; --  on falling edge tck
    END LOOP;

    tms <= '1';     intended_tap_display <= EXIT1_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '0' REPORT "TDI Expected 0" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= PAUSE_DR;
    tdo <= '1';
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= PAUSE_DR;
    for jb_i IN 1 TO 6 LOOP
      wait until tck'event AND tck = '0'; --  on falling edge tck
      ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;
    END LOOP;

    tms <= '1';     intended_tap_display <= EXIT2_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= SHIFT_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tdo <= '1';                     -- Fill the DR with ones while shifting out
                                    -- zeros
    tms <= '0';     intended_tap_display <= SHIFT_DR;
    for jb_i IN 1 TO 56 LOOP
      wait until tck'event AND tck = '0'; --  on falling edge tck
      ASSERT tdi = '0' REPORT "TDI Expected 0" SEVERITY FAILURE;
    END LOOP;

    tms <= '1';     intended_tap_display <= EXIT1_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '1' REPORT "TDI Expected 1" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= PAUSE_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= EXIT2_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= UPDATE_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= RUN_TEST;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    ---------------------------------------------------------------------------
    -- Test the slave CTL Data register
    ---------------------------------------------------------------------------

    -- select the control data register scan chain
    instruction_reg := DEICE_CTL;
    scan_instruction_reg(instruction_reg,8);

    tms <= '1';     intended_tap_display <= SEL_DR_SCAN;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;
    tms <= '0';     intended_tap_display <= CAPTURE_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= EXIT1_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= PAUSE_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= EXIT2_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= SHIFT_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tdo <= '1';                     -- Shift a "101" pattern into the DR
    tms <= '0';                     -- Stay in SHIFT DR  state
    wait until tck'event AND tck = '0'; --  on falling edge tck

    tdo <= '0';
    tms <= '0';                     -- Stay in SHIFT DR  state
    wait until tck'event AND tck = '0'; --  on falling edge tck

    tdo <= '1';
    tms <= '0';                     -- Stay in SHIFT DR  state
    wait until tck'event AND tck = '0'; --  on falling edge tck

    tdo <= '0';                     -- Fill the rest of DR with zeros
    tms <= '0';                     -- Stay in SHIFT DR  state
    for jb_i IN 1 TO 53 LOOP
      wait until tck'event AND tck = '0'; --  on falling edge tck
    END LOOP;

    tms <= '0';                     -- Stay in SHIFT DR  state
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '1' REPORT "TDI Expected 1" SEVERITY FAILURE;

    tms <= '0';                     -- Stay in SHIFT DR  state
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '0' REPORT "TDI Expected 0" SEVERITY FAILURE;

    tms <= '0';                     -- Stay in SHIFT DR  state
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '1' REPORT "TDI Expected 1" SEVERITY FAILURE;

    tms <= '0';                     -- Stay in SHIFT DR  state
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '0' REPORT "TDI Expected 0" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= EXIT1_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = '0' REPORT "TDI Expected 0" SEVERITY FAILURE;

    tms <= '1';     intended_tap_display <= UPDATE_DR;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

    tms <= '0';     intended_tap_display <= RUN_TEST;
    wait until tck'event AND tck = '0'; --  on falling edge tck
    ASSERT tdi = 'Z' REPORT "TDO is not Z when not shifting" SEVERITY FAILURE;

  END jtag_bist;

PROCEDURE stop_processor
   IS

  BEGIN
--------------------------------------------------------------------------------
--
-- Procedure: stop_processor
--
-- Parameters:  NONE
--
-- Description: This procedure writes a stop command to the Instruction
-- register in the JTAG slave.
--
-- This procedure assumes that the TAP is in the run_test state.
--
--
--------------------------------------------------------------------------------

    instruction_reg := DEICE_STOP;
    scan_instruction_reg(instruction_reg,8);

  END stop_processor;

PROCEDURE reset_processor
   IS

  BEGIN
--------------------------------------------------------------------------------
--
-- Procedure: reset_processor
--
-- Parameters:  NONE
--
-- Description: This procedure resets the processor core.  It does not effect
-- state of the deice core.
--
-- This procedure assumes that the TAP is in the run_test state.
--
--
--------------------------------------------------------------------------------

    instruction_reg := DEICE_CTL;   -- enable the ctl scan chain
    scan_instruction_reg(instruction_reg,8);

    
    address  := "00000000" & "00000000";
    data_in  := "00000000";
    data_out := "00000000";
    ctl      := "00011000";              -- assert reset and ready
    psr      := "00000000";
    int      := "00000000";
    data_reg := address & data_in & data_out & ctl & psr & int;
    scan_data_reg(data_reg, 56);

     -- Apply the reset for 3 clocks
    instruction_reg := DEICE_APPLY_V8;   -- clock the data into the V8
    scan_instruction_reg(instruction_reg,8);
    instruction_reg := DEICE_APPLY_V8;   -- clock the data into the V8
    scan_instruction_reg(instruction_reg,8);
    instruction_reg := DEICE_APPLY_V8;   -- clock the data into the V8

  END reset_processor;

PROCEDURE write_memory(
                       VARIABLE address  : std_logic_vector(15 downto 0);
                       CONSTANT length   : integer
   ) IS

  VARIABLE wm_i : integer;
  VARIABLE wm_address : std_logic_vector(15 downto 0);

  BEGIN
--------------------------------------------------------------------------------
--
-- Procedure: write_memory
--
-- Parameters:  address  -- the start address in memory
--              length   -- number of bytes to write.
--
-- Globals      mem_data     -- and array of bytes to be written
-- Description: This procedure writes an array of bytes to memory starting address.
--
-- This procedure assumes that the TAP is in the run_test state.
--
--
--------------------------------------------------------------------------------

    wm_address := address;

    stop_processor;                      --  stop the processor

    -- select the data register scan chain
    instruction_reg := DEICE_DATA;
    scan_instruction_reg(instruction_reg,8);

    -- for each data byte
    FOR wm_i IN 1 TO length LOOP

      -- assign the address and the data
      data_reg(31 downto 16) := wm_address;
      data_reg(15 downto  8) := mem_data(wm_i);
      data_reg( 7 downto  0) := mem_data(wm_i);

      -- scan in the address and data
      scan_data_reg(data_reg, 32);

      -- write the data to memory.
      instruction_reg := DEICE_MEM_WRITE;
      scan_instruction_reg(instruction_reg,8);

      wm_address := unsigned(wm_address) + 1;

    END LOOP;

  END write_memory;

PROCEDURE read_memory(
                       VARIABLE address  : std_logic_vector(15 downto 0);
                       CONSTANT length   : integer
   ) IS

  VARIABLE rm_i : integer;
  VARIABLE rm_address : std_logic_vector(15 downto 0);

  BEGIN
--------------------------------------------------------------------------------
--
-- Procedure: read_memory
--
-- Parameters:  address  -- the start address in memory
--              length   -- number of bytes to read.
--
-- Globals      mem_data     -- and array of bytes to be read
-- Description: This procedure writes an array of bytes to memory starting address.
--
-- This procedure assumes that the TAP is in the run_test state.
--
--
--------------------------------------------------------------------------------

    rm_address := address;

    stop_processor;                      --  stop the processor

    -- select the data register scan chain
    instruction_reg := DEICE_DATA;
    scan_instruction_reg(instruction_reg,8);

    -- assign the address and the data
    data_reg(31 downto 16) := rm_address;
    data_reg(15 downto  8) := "00000000";
    data_reg( 7 downto  0) := "00000000";

    -- scan in the address and data
    scan_data_reg(data_reg, 32);

    -- for each data byte
    FOR rm_i IN 1 TO length LOOP

      -- read the data from memory.
      instruction_reg := DEICE_MEM_READ;
      scan_instruction_reg(instruction_reg,8);

      rm_address := unsigned(rm_address) + 1;

      -- assign the address and the data
      data_reg(31 downto 16) := rm_address;
      data_reg(15 downto  8) := "00000000";
      data_reg( 7 downto  0) := "00000000";

      -- scan in the address and data
      scan_data_reg(data_reg, 32);

      mem_data(rm_i) := data_reg(15 downto 8);


    END LOOP;

  END read_memory;

PROCEDURE set_breakpoint(
       CONSTANT break_vector : std_logic_vector(55 downto 0);
       CONSTANT break_mask   : std_logic_vector(55 downto 0)
   ) IS

  BEGIN
--------------------------------------------------------------------------------
--
-- Procedure: set breakpoint
--
-- Parameters:  break_vector  -- the bit values to break on
--              break_mask    -- the bit mask for the break vector
--
-- Globals      instruction_reg   -- instruction scan vector
--              data_reg          -- data scan vector
-- Description: This procedure writes the breakpoint register and the
-- breakpoint mask register. then enable the break point.
--
-- This procedure assumes that the TAP is in the run_test state.
--
--
--------------------------------------------------------------------------------


    stop_processor;                      --  stop the processor

    -- select the breakpoint mask data register scan chain
    instruction_reg := DEICE_BREAKPT;
    scan_instruction_reg(instruction_reg,8);

    data_reg := break_mask;
    scan_data_reg(data_reg, 56);

    -- select the control chain and scan in break point value
    instruction_reg := DEICE_CTL;
    scan_instruction_reg(instruction_reg,8);

    data_reg := break_vector;
    scan_data_reg(data_reg, 56);

    -- enable the breakpoint register
    instruction_reg := DEICE_ENB_BKPT;
    scan_instruction_reg(instruction_reg,8);

  END set_breakpoint;

PROCEDURE set_pc(
       CONSTANT address_in : std_logic_vector(15 downto 0)
   ) IS

  VARIABLE op_fetch   : std_logic; -- Opcode fetch bit of the CTL scan chain
  VARIABLE address_tmp : std_logic_vector(15 downto 0);

  BEGIN
--------------------------------------------------------------------------------
--
-- Procedure: set pc
--
-- Parameters:  address    -- the address to set the pc to
--
-- Globals      instruction_reg   -- instruction scan vector
--              data_reg          -- data scan vector
-- Description: This procedure writes jumps the processor to a particular
-- address.
--
-- This procedure assumes that the TAP is in the run_test state.
--
--------------------------------------------------------------------------------

    address_tmp := address_in;
    stop_processor;

    instruction_reg := DEICE_CTL;           -- enable the ctl scan chain
    scan_instruction_reg(instruction_reg,8);

    -- step the processor untill the op fetch bit set
    address  := "00000000" & "00000000";
    data_in  := "00000000";
    data_out := "00000000";
    ctl      := "00001000";              -- assert ready
    psr      := "00000000";
    int      := "00000000";
    data_reg := address & data_in & data_out & ctl & psr & int;
    scan_data_reg(data_reg, 56);

    op_fetch := data_reg(16);            -- check the op fetch bit

    WHILE op_fetch = '0' LOOP
      instruction_reg := DEICE_ONE_CLK;    -- advance the processor one clock
      scan_instruction_reg(instruction_reg,8);

      instruction_reg := DEICE_CTL;           -- enable the ctl scan chain
      scan_instruction_reg(instruction_reg,8);

      address  := "00000000" & "00000000";
      data_in  := "00000000";
      data_out := "00000000";
      ctl      := "00001000";              -- assert ready
      psr      := "00000000";
      int      := "00000000";
      data_reg(55 downto 0) := address & data_in & data_out & ctl & psr & int;
      scan_data_reg(data_reg, 56);

      op_fetch := data_reg(16);          -- check the op fetch bit

    END LOOP;
    -- when the op_fetch bit is set the processor is ready to load an instruction

    address  := "00000000" & "00000000";
    data_in  := conv_std_logic_vector(16#bc#,8); --  the jump instruction
    data_out := "00000000";
    ctl      := "00001000";
    psr      := "00000000";
    int      := "00000000";
    data_reg(55 downto 0) := address & data_in & data_out & ctl & psr & int;
    scan_data_reg(data_reg, 56);
    instruction_reg := DEICE_APPLY_V8;   -- clock the data into the V8
    scan_instruction_reg(instruction_reg,8);


    data_in  := address_tmp(7 downto 0);     --  jump address low
    data_reg(55 downto 0) := address & data_in & data_out & ctl & psr & int;
    scan_data_reg(data_reg, 56);
    instruction_reg := DEICE_APPLY_V8;   -- clock the data into the V8
    scan_instruction_reg(instruction_reg,8);


    data_in  := address_tmp(15 downto 8);    --  jump address high
    data_reg(55 downto 0) := address & data_in & data_out& ctl & psr & int;
    scan_data_reg(data_reg, 56);
    instruction_reg := DEICE_APPLY_V8;   -- clock the data into the V8
    scan_instruction_reg(instruction_reg,8);


  END set_pc;

PROCEDURE read_pc(
       VARIABLE address : INOUT std_logic_vector(15 downto 0)
   ) IS
  VARIABLE op_fetch : std_logic; -- Opcod fetch bit of the CTL scan chain
  BEGIN
--------------------------------------------------------------------------------
--
-- Procedure: read pc
--
-- Parameters:  address    -- the address read from the pc
--
-- Globals      instruction_reg   -- instruction scan vector
--              data_reg          -- data scan vector
-- Description: This procedure reads processor to program counter
--
-- This procedure assumes that the TAP is in the run_test state.
--
--------------------------------------------------------------------------------


    stop_processor;

    instruction_reg := DEICE_CTL;           -- enable the ctl scan chain
    scan_instruction_reg(instruction_reg,8);

    address  := "00000000" & "00000000";
    data_in  := "00000000";
    data_out := "00000000";
    ctl      := "00001000";              -- assert ready
    psr      := "00000000";
    int      := "00000000";
    data_reg := address & data_in & data_out & ctl & psr & int;
    scan_data_reg(data_reg, 56);

    op_fetch := data_reg(16);            -- check the op fetch bit

    WHILE op_fetch = '0' LOOP
      instruction_reg := DEICE_ONE_CLK;    -- advance the processor one clock
      scan_instruction_reg(instruction_reg,8);

      instruction_reg := DEICE_CTL;           -- enable the ctl scan chain
      scan_instruction_reg(instruction_reg,8);

      address  := "00000000" & "00000000";
      data_in  := "00000000";
      data_out := "00000000";
      ctl      := "00001000";              -- assert ready
      psr      := "00000000";
      int      := "00000000";
      data_reg(55 downto 0) := address & data_in & data_out & ctl & psr & int;
      scan_data_reg(data_reg, 56);

      op_fetch := data_reg(16);          -- check the op fetch bit

    END LOOP;
    -- when the op_fetch bit is set the PC is the address in the ctl chain
    address := data_reg(55 downto 40);

  END read_pc;

begin -- main_test process;

  WAIT FOR 2500 ns;                      -- wait for the reset to deassert

  tck_enable <= '1';                     -- start the test clock
  jtag_reset;                            -- restet the slave TAP
  jtag_run_test;                         -- move the slave TAP to run_test

  jtag_bist;                             -- run basic tests on the slave TAP
                                         -- controller.

  -- write a small program to memory.

  mem_data(1) := conv_std_logic_vector(16#bb#,8); -- V8 NOP instruction
  mem_data(2) := conv_std_logic_vector(16#bb#,8); -- V8 NOP instruction
  mem_data(3) := conv_std_logic_vector(16#bb#,8); -- V8 NOP instruction
  mem_data(4) := conv_std_logic_vector(16#bb#,8); -- V8 NOP instruction
  mem_data(5) := conv_std_logic_vector(16#69#,8); -- V8 CLR CARRY instruction
  mem_data(6) := conv_std_logic_vector(16#91#,8); -- V8 BR NOT CARRY instruction
  mem_data(7) := conv_std_logic_vector(16#FE#,8); --      Offset -2
  mem_data(8) := conv_std_logic_vector(16#57#,8); -- Coverage data values
  mem_data(9) := conv_std_logic_vector(16#a8#,8); -- Coverage data values

  address := conv_std_logic_vector(RAM_SCRATCH_START,16);

  write_memory(address,9);

  -- read back the memory to see that it wrote correctly
  address := conv_std_logic_vector(RAM_SCRATCH_START+3,16);
  read_memory(address,6);

  ASSERT mem_data(1) = conv_std_logic_vector(16#bb#,8) REPORT
    "JTAG write / read test failure" SEVERITY FAILURE;
  ASSERT mem_data(2) = conv_std_logic_vector(16#69#,8) REPORT
    "JTAG write / read test failure" SEVERITY FAILURE;
  ASSERT mem_data(3) = conv_std_logic_vector(16#91#,8) REPORT
    "JTAG write / read test failure" SEVERITY FAILURE;
  ASSERT mem_data(4) = conv_std_logic_vector(16#FE#,8) REPORT
    "JTAG write / read test failure" SEVERITY FAILURE;
  ASSERT mem_data(5) = conv_std_logic_vector(16#57#,8) REPORT
    "JTAG write / read test failure" SEVERITY FAILURE;
  ASSERT mem_data(6) = conv_std_logic_vector(16#a8#,8) REPORT
    "JTAG write / read test failure" SEVERITY FAILURE;

  -- jump the processor to the start of the downloaded code
  address  := conv_std_logic_vector(RAM_SCRATCH_START,16);
  set_pc(address);

  -- set a break point mask register to stop the processor on address match
  address  := conv_std_logic_vector(16#ffff#,16);
  data_in  := "00000000";
  data_out := "00000000";
  ctl      := "00000000";
  psr      := "00000000";
  int      := "00000000";
  breakpoint_mask := address & data_in & data_out & ctl & psr & int;

  -- set the break point vector address to 3 instruction into the code loop
  address  := conv_std_logic_vector((RAM_SCRATCH_START+3),16);
  data_in  := "00000000";
  data_out := "00000000";
  ctl      := "00001000";                --  assert ready
  psr      := "00000000";
  int      := "00000000";
  breakpoint_reg := address & data_in & data_out & ctl & psr & int;

  set_breakpoint(breakpoint_reg,breakpoint_mask);

  -- run the processor up to the breakpoint.
  instruction_reg := DEICE_RUN;   -- restat the V8
  scan_instruction_reg(instruction_reg,8);

  -- wait for the processor to reach the break point
  wait FOR 5000 ns;      -- it shouldn't take long 5 us

  read_pc(address);

  ASSERT address = conv_std_logic_vector(RAM_SCRATCH_START+3,16) REPORT
    "Processor did not break at expected address."
    SEVERITY FAILURE;

  ASSERT false REPORT "JTAG and DEICE testing completed successfully." SEVERITY NOTE;
  ASSERT false REPORT "Restarting processor from Address 0x0000" SEVERITY NOTE;

  -- restart the processor from address 0

  reset_processor;                       -- reset the V8  processor core

  instruction_reg := DEICE_RUN;          -- restat the V8
  scan_instruction_reg(instruction_reg,8);

  tck_enable <= '0';                     --  turn off the scan clock

  wait;                                  --  Sleep this process for the
                                         --  remainder of the the simulation.
end PROCESS main_test;


tck_gen: PROCESS
  BEGIN

    wait for TCK_PERIOD / 2;
    tck <= '1';
    wait for TCK_PERIOD / 2;
    if tck_enable = '1' then
      tck <= '0';
    end IF;

  END PROCESS tck_gen;

END behav;

