--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: fuse.vhd
--
-- Description: 
--	Place holder for an fuse. Doesn't actually do anything...
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: fuse.vhd,v $
-- Revision 1.1  1996/11/11 19:57:20  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity fuse is
  port (pin1 : inout std_logic;
        pin2 : inout std_logic);
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of pin1 : SIGNAL is "1";
attribute PIN_NUMBER of pin2 : SIGNAL is "2";
attribute package_type : string;
attribute package_type of fuse : ENTITY is "fuse@smd2";
end fuse;

architecture behavioral of fuse is
begin
end behavioral;
