--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: capcitor.vhd
--
-- Description: 
--	Place holder for a Capacitor. Doesn't actually do anything...
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: cap1206.vhd,v $
-- Revision 1.1  1996/11/11 19:50:21  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity cap1206 is
  port (plus  : inout std_logic:='Z';  -- If it's a polarized, cap, then this is the +
        minus : inout std_logic:='Z');
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of plus  : SIGNAL is "1";
attribute PIN_NUMBER of minus : SIGNAL is "2";
attribute package_type : string;
attribute package_type of cap1206 : ENTITY is "cap@1206";
end cap1206;

architecture behavioral of cap1206 is
begin
end behavioral;
