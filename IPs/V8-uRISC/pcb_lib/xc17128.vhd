-----------------------------------------------------------------------------
--
-- Description: VHDL entity of a Xilinx Xc17128 serial EEPROM for PCB generations
--
-- When programming PROMs, ALWAYS program RESET active low!
-----------------------------------------------------------------------------
-- $Log: xc17128.vhd,v $
-- Revision 1.1  1996/11/11 19:56:47  eric
-- Initial revision
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration

ENTITY xc17128 IS
  PORT (SIGNAL data	: INOUT  std_logic;	-- to the First FPGAs DIN pin
	SIGNAL clk	: IN  std_logic;	-- CCLK
	SIGNAL reset_oe	: IN  std_logic;	-- PROG_N (reset is active low)
	SIGNAL ce_n	: IN  std_logic;	-- DONE_N
	SIGNAL ceo_n	: OUT std_logic;	-- To the next xc17128 CE_N
	SIGNAL vpp	: IN  std_logic;	-- MUST be connected to VCC!!!
	SIGNAL pwr	: IN  std_logic;
	SIGNAL gnds	: IN  std_logic);
attribute pin_number : string;
attribute pin_number of data 	: SIGNAL is "1";
attribute pin_number of clk 	: SIGNAL is "2";
attribute pin_number of reset_oe: SIGNAL is "3";
attribute pin_number of ce_n 	: SIGNAL is "4";
attribute pin_number of gnds 	: SIGNAL is "5";
attribute pin_number of ceo_n 	: SIGNAL is "6";
attribute pin_number of vpp 	: SIGNAL is "7";
attribute pin_number of pwr 	: SIGNAL is "8";

attribute package_type : STRING;
attribute package_type of xc17128 : ENTITY is "XCPROM@DIP8";

END xc17128;             

ARCHITECTURE behavioral of xc17128 is
BEGIN
  data <= 'Z';
END behavioral;
