--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: mic.vhd
--
-- Description: 
--	Entity for a tiny microphone - Panasonic WM54BT
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: mic.vhd,v $
-- Revision 1.1  1998/04/01 15:36:01  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity mic is
  port (pin1 : inout std_logic:='Z';
        pin2 : inout std_logic:='Z');
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of pin1 : SIGNAL is "1";
attribute PIN_NUMBER of pin2 : SIGNAL is "2";
attribute package_type : string;
attribute package_type of mic : ENTITY is "MIC@WM54BT";
end mic;

architecture behavioral of mic is
begin
end behavioral;
