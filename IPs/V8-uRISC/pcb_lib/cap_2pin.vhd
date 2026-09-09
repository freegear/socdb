--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: cap_2pin.vhd
--
-- Description: 
--	Place holder for a Capacitor. Doesn't actually do anything...
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: cap_2pin.vhd,v $
-- Revision 1.1  1997/01/28 22:13:25  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity cap_2pin is
  port (plus  : inout std_logic;  -- If it's a polarized, cap, then this is the +
        minus : inout std_logic);
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of plus  : SIGNAL is "1";
attribute PIN_NUMBER of minus : SIGNAL is "2";
attribute package_type : string;
attribute package_type of cap_2pin : ENTITY is "cap_2pin@cap_2pin";
end cap_2pin;

architecture behavioral of cap_2pin is
begin
plus <= 'Z';
minus <= 'Z';
end behavioral;
