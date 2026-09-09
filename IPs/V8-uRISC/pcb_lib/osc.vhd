-----------------------------------------------------------------------------
--
-- Description: VHDL model of a crystal oscillator 
--
-----------------------------------------------------------------------------
-- $Log: osc.vhd,v $
-- Revision 1.5  1999/04/22 13:28:33  eric
-- Added the tristate enable for test vector generation.
-- Makes it easy to turn off the clock and then drive the
-- clock via TCL in the simulator.
--
-- Revision 1.4  1997/03/21 03:07:24  chris
-- oops... back to 12Mhz.
--
-- Revision 1.3  1997/03/21  01:55:31  chris
-- Crystal freq is now 48Mhz.
--
-- Revision 1.2  1996/11/06  15:57:23  eric
-- *** empty log message ***
--
-- Revision 1.1  1995/12/31  17:33:32  eric
-- Initial revision
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration

ENTITY osc IS

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
attribute package_type of osc : ENTITY is "OSC@OSC";

END osc;             

ARCHITECTURE behavioral of osc is
CONSTANT half_period : TIME := 42 ns;	-- 1/2 of the period
SIGNAL powerup : std_logic;
SIGNAL toggle  : std_logic;
BEGIN
  toggle <= NOT toggle AND powerup AFTER half_period;
  osc_out <= toggle when to_x01(enb)='1' else 'Z';

init:PROCESS
BEGIN
  powerup <= '0';
  WAIT FOR  (half_period * 2);
  powerup <= '1';
  WAIT;	-- forever.
END PROCESS init;

END behavioral;
