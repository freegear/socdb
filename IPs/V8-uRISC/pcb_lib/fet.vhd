--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: fet.vhd
--
-- Description: 
--	Entity for a FET transistor
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: fet.vhd,v $
-- Revision 1.1  1996/11/11 19:56:01  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity fet is
  port (g : in std_logic:='Z';
        d : inout std_logic:='Z';
        s : inout std_logic:='Z');
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of g : SIGNAL is "1";
attribute PIN_NUMBER of s : SIGNAL is "2";
attribute PIN_NUMBER of d : SIGNAL is "3";
attribute package_type : string;
attribute package_type of fet : ENTITY is "fet@DIP4";
end fet;

architecture behavioral of fet is
begin
end behavioral;
