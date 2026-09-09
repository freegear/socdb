--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: res1206.vhd
--
-- Description:
--	Functional VHDL model for a weak unidirectional resistor. Note that this
--	model does not have bi-directional ports.
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: res1206.vhd,v $
-- Revision 1.2  1997/02/07 20:00:17  chris
-- Recoded the resistor to serve as a weak pull up.
--
-- Revision 1.1  1996/07/07  13:28:50  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity res1206 is
  port (a : in    std_logic;  -- a input
        z : inout std_logic); -- z output
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of a : SIGNAL is "1";
attribute PIN_NUMBER of z : SIGNAL is "2";
attribute package_type : string;
attribute package_type of res1206 : ENTITY is "res@1206";
end res1206;

architecture behavioral of res1206 is
  
  signal drive_z  : std_logic := 'Z'; 
  signal drive_on : std_logic := '1';
  signal fight    : std_logic := '0';
  
begin

  z <= transport drive_z after 1 ns;
  drive_z <= 'L' when a = '0' AND drive_on = '1' else -- Pulldown
             'H' when a = '1' AND drive_on = '1' else -- Pullup
             'Z';                                     -- Open

  fight    <= '1' when z = 'W' else '0';

  drive_on <= '1' when (drive_on = '1' AND not fight = '1') or z = 'Z' else
              '0';
end behavioral;
