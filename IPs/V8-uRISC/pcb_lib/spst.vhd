-----------------------------------------------------------------------------
--
-- Description: VHDL model of a Single Pole, Single Throw push button switch.
--
-----------------------------------------------------------------------------
-- $Log: spst.vhd,v $
-- Revision 1.6  1999/04/01 20:48:28  eric
-- Corrected syntax for conversion to verilog.
--
-- Revision 1.5  1999/03/31 12:53:23  gregg
-- Modified sw_out operation to reset low-speed clock divide
--
-- Revision 1.4  1997/12/04 17:24:02  eric
-- legal VHDL now!
--
-- Revision 1.3  1997/12/04 17:14:55  eric
-- improved verilog version.
--
-- Revision 1.2  1997/12/04 16:30:59  eric
-- Modified so it will translate to verilog.
--
-- Revision 1.1  1996/11/11 19:55:33  eric
-- Initial revision
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

ENTITY spst IS
  PORT (SIGNAL sw_out: out std_logic;	-- output
	SIGNAL sw_in : IN  std_logic);  -- input
attribute pin_number : string;
attribute pin_number of sw_out 	: SIGNAL is "1";
attribute pin_number of sw_in 	: SIGNAL is "2";
attribute package_type : string;
attribute package_type of spst : ENTITY is "spst@2pin";
END spst;             

ARCHITECTURE behavioral of spst is
BEGIN
PROCESS BEGIN
  WAIT ON sw_in;
  -- Allow sw_out to be high for 2 cycles of clock this allows the 
  -- clock divider circuit to properly reset in low-speed mod.
  sw_out <= not sw_in;
  WAIT FOR 50 ns;
  sw_out <= sw_in;	-- normally connect to gnd to drive low
  WAIT FOR 1000 ns;
  sw_out <= 'Z'; -- models a reset switch on powerup
END PROCESS;
END behavioral;
