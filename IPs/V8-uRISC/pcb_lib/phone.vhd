--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: phone.vhd
--
-- Description: 
--	Entity for a stereo audio phone connector.
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: phone.vhd,v $
-- Revision 1.2  1998/04/06 23:50:58  eric
-- Corrected the pinout.
--
-- Revision 1.1  1996/11/11 19:57:34  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity phone is
  port (ring   : inout std_logic:='Z';	-- right
        tip    : inout std_logic:='Z';	-- left
        shield : inout std_logic:='Z');
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of tip   : SIGNAL is "2";
attribute PIN_NUMBER of ring  : SIGNAL is "5";
attribute PIN_NUMBER of shield: SIGNAL is "1";
attribute package_type : string;
attribute package_type of phone : ENTITY is "PHONE@PHONEJACK";
end phone;

architecture behavioral of phone is
begin
end behavioral;
