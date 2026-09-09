-----------------------------------------------------------------------------
--
-- Description: VHDL model of a crystal oscillator 
--
-----------------------------------------------------------------------------
-- $Log: osc100.vhd,v $
-- Revision 1.2  1997/10/25 01:36:45  eric
-- changed from DOS CRLF to Unix LF.
--
-- Revision 1.1  1997/02/10 12:36:29  chris
-- Initial revision
--
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration

ENTITY osc100 IS

-- Define osc signals

  PORT (SIGNAL osc_out: out  std_logic;	-- output
	SIGNAL enb:	IN  std_logic; -- NC on most oscillators
	SIGNAL pwr:	IN std_logic;
	SIGNAL gnds:	IN std_logic);
attribute pin_number : string;
attribute pin_number of enb 	: SIGNAL is "1";
attribute pin_number of gnds	: SIGNAL is "4";
attribute pin_number of osc_out : SIGNAL is "5";
attribute pin_number of pwr 	: SIGNAL is "8";
attribute package_type : string;
attribute package_type of osc100 : ENTITY is "OSC@OSC";

END osc100;             

ARCHITECTURE behavioral of osc100 is
CONSTANT half_period : TIME := 5 ns;	-- 1/2 of the period
SIGNAL powerup : std_logic;
SIGNAL toggle  : std_logic;
BEGIN
  toggle <= NOT toggle AND powerup AFTER half_period;
  osc_out <= toggle;

init:PROCESS
BEGIN
  powerup <= '0';
  WAIT FOR  (half_period * 2);
  powerup <= '1';
  WAIT;	-- forever.
END PROCESS init;

END behavioral;
