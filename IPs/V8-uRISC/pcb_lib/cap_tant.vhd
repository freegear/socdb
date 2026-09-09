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
-- $Log: cap_tant.vhd,v $
-- Revision 1.3  1997/09/29 18:58:17  chris
-- *** empty log message ***
--
-- Revision 1.2  1997/03/21 20:03:43  chris
-- Added logic 1 output to the plus terminal of the cap.
--
-- Revision 1.1  1996/11/11  19:57:09  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity cap_tant is
  port (plus  : inout std_logic;  -- If it's a polarized, cap, then this is the +
        minus : inout std_logic);
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of plus  : SIGNAL is "1";
attribute PIN_NUMBER of minus : SIGNAL is "2";
attribute package_type : string;
attribute package_type of cap_tant : ENTITY is "cap_tant@smd2cap";
end cap_tant;

architecture behavioral of cap_tant is
begin
plus <= '1';
minus <= 'Z';
end behavioral;
