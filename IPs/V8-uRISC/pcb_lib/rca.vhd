--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: rca.vhd
--
-- Description: 
--	Entity for a RCA audio phono connector.
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: rca.vhd,v $
-- Revision 1.1  1998/04/02 01:23:38  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity rca is
  port (tip    : inout std_logic:='Z';
        shield : inout std_logic:='Z');
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of tip   : SIGNAL is "1";
attribute PIN_NUMBER of shield: SIGNAL is "2";
attribute package_type : string;
attribute package_type of rca : ENTITY is "RCA@RCA_90";
end rca;

architecture behavioral of rca is
begin
end behavioral;
