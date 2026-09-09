--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: pwr_5v.vhd
--
-- Description: 
--	Entity for a 3 pin 2.1mm power connector
--	 CUI/Stack PJ-202A
--------------------------------------------------------------------------------
-- Revision History
-- $Log: pwr_5v.vhd,v $
-- Revision 1.1  1998/03/27 14:45:30  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity pwr_5v is
  port (pin1 : out std_logic;
        pin2 : out std_logic;
        pin3 : out std_logic);
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of pin1 : SIGNAL is "1";
attribute PIN_NUMBER of pin2 : SIGNAL is "2";
attribute PIN_NUMBER of pin3 : SIGNAL is "3";
attribute package_type : string;
attribute package_type of pwr_5v : ENTITY is "PWR_5V@THREE_PIN";
end pwr_5v;

architecture behavioral of pwr_5v is
begin
pin1 <= '1';	-- center conductor
pin2 <= '0';
pin3 <= '0';
end behavioral;
