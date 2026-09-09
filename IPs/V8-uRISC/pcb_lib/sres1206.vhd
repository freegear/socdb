--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: sres1206.vhd
--
-- Description:
--	Functional VHDL model for a bi-directional series resistor.
--      This resistor assumes that one side of the resistor is connected
--	to a CMOS signal without and resistors. Thus, that side will
--	only have values of 0,1 or Z. We then pass 0,1,Z or H or L.
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: sres1206.vhd,v $
-- Revision 1.3  1997/03/21 20:15:21  chris
-- Changed package type back to res@1206.
--
-- Revision 1.2  1997/03/03  14:43:26  eric
-- Removed the table and changed to behavioral so it will pass 0 and 1.
--
-- Revision 1.1  1997/02/07 20:15:18  chris
-- Initial revision
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity sres1206 is
  port (a : inout std_logic := 'Z';  -- a input
        b : inout std_logic := 'Z'); -- b output
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of a : SIGNAL is "1";
attribute PIN_NUMBER of b : SIGNAL is "2";
attribute package_type : string;
attribute package_type of sres1206 : ENTITY is "res@1206";
end sres1206;


architecture behavioral of sres1206 is
  
  signal a_to_b  : std_logic := '0'; 
  signal b_to_a  : std_logic := '0'; 

begin

-- we delay 1 ns to eliminate races and glitches
a <= b after 1 ns when a_to_b = '1' else 'Z';
b <= a after 1 ns when b_to_a = '1' else 'Z';

-- The concept here is that if we see and X or W then we're driving data
-- in the wrong direction so we need to shut off our driver.
-- Then, once we see a Z on one side and something else on the other,
-- it wells us which way to drive. We then stay that way until we see
-- an X or W.
PROCESS
begin
  WAIT ON a , b;
  if (a='X' OR a='W' OR b='Z') then	-- we want to release this side.
	a_to_b <= '0';
  elsif ((a='Z' and (b='1' or b='0' or b='H' or b='L')) OR
        ((a='H' OR a='L') and (b='1' or b='0'))) then
	a_to_b <= '1';
  end if;
  if (b='X' OR b='W' OR a='Z') then -- release
	b_to_a <= '0';
  elsif ((b='Z' and (a='1' or a='0' or a='H' or a='L')) OR
        ((b='H' OR b='L') and (a='1' or a='0'))) then -- drive
	b_to_a <= '1';
  elsif (a_to_b='1') then
	b_to_a <= '0';
  end if;
end process;

END behavioral;



