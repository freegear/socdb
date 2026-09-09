--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: zeroohm.vhd
--
-- Description: 
--	Place holder for a 2 pin zero ohm resistor with 2 .1 pins.
--	This component should have a surface etch that can be cut 
--	connecting the two posts that can then be jumpered when necessary.
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: zeroohm.vhd,v $
-- Revision 1.1  1998/09/18 18:43:57  chris
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity zeroohm is
  port (pin1 : in std_logic;
        pin2 : out std_logic);
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of pin1  : SIGNAL is "1";
attribute PIN_NUMBER of pin2 : SIGNAL is "2";
attribute package_type : string;
attribute package_type of zeroohm : ENTITY is "zeroohm@2pins";
end zeroohm;

architecture behavioral of zeroohm is
begin
pin2 <= pin1;
end behavioral;
