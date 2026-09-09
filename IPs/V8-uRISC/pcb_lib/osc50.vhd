-----------------------------------------------------------------------------
--
-- Description: VHDL model of a crystal oscillator 
--
-----------------------------------------------------------------------------
-- $Log: osc50.vhd,v $
-- Revision 1.3  1997/03/21 02:55:04  chris
-- *** empty log message ***
--
-- Revision 1.2  1997/03/21  02:53:49  chris
-- fixed entity name.
--
-- Revision 1.1  1997/03/21  02:50:16  chris
-- Initial revision
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration

ENTITY osc50 IS

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
attribute package_type of osc50 : ENTITY is "OSC@OSC";

END osc50;             

ARCHITECTURE behavioral of osc50 is
CONSTANT half_period : TIME := 10 ns;	-- 1/2 of the period
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
