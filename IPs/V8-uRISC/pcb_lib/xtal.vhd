--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: xtal.vhd
--
-- Description: 
--	Crude Functional VHDL model for a crystal.
--

--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity xtal is
  port (a : in  std_logic;  -- a input
        z : out std_logic); -- z output
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of a : SIGNAL is "1";
attribute PIN_NUMBER of z : SIGNAL is "2";
attribute package_type : string;
attribute package_type of xtal : ENTITY is "xtal@xtal";
end xtal;

architecture behavioral of xtal is
begin
  z <= a AFTER 100 ns;
end behavioral;
