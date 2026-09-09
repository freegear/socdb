-----------------------------------------------------------------------------
--
-- File: RAM4mx4.VHD
--
-- Description: crude simulation model of a 4mx4 DRAM
--
-- Copyright 1995 VAutomation Inc. Nashua NH. All rights reserved.
-- VAutomation Inc. 20 Trafalgar Sq. Nashua NH 03063 (603)882-2282.
-- This software is provided under license and contains proprietary
-- and confidential material which is the property of VAutomation Inc.
--
-----------------------------------------------------------------------------
-- $Log: ram4mx4.vhd,v $
-- Revision 1.3  1997/03/21 19:45:36  eric
-- Updated to the 26 pin 300mil pinout.
--
-- Revision 1.2  1997/02/14 18:58:34  eric
-- improved package_type attribute.
--
-- Revision 1.1  1996/11/11  19:56:47  eric
-- Initial revision
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

----------------- Entity declaration ---------------------------------

ENTITY ram4mx4 IS
  PORT (SIGNAL addr:  IN    std_logic_vector(10 DOWNTO 0); -- Address
        SIGNAL data:  INOUT std_logic_vector(3 DOWNTO 0) := "ZZZZ"; -- Data I/O port
        SIGNAL ras_n: IN    std_logic;
        SIGNAL cas_n: IN    std_logic;
        SIGNAL oe_n:  IN    std_logic;
        SIGNAL we_n:  IN    std_logic);
-- pinout is for a Toshiba TC5117400BSJ SOJ26
TYPE string_array IS ARRAY (natural range <>, natural range <>) OF CHARACTER;
attribute pin_number : string;
attribute array_pin_number : string_array;
attribute array_pin_number of addr : SIGNAL is ("8 ","21","19","18","17","16","15","12","11","10","9 ");
attribute array_pin_number of data : SIGNAL is ("25","24","3 ","2 ");
attribute pin_number of ras_n: SIGNAL is "5";
attribute pin_number of cas_n: SIGNAL is "23";
attribute pin_number of oe_n : SIGNAL is "22";
attribute pin_number of we_n : SIGNAL is "4";
attribute VCC_PINS : STRING_array;
attribute GND_PINS : STRING_array;
attribute VCC_PINS of ram4mx4 : ENTITY is ("1 ","13");
attribute GND_PINS of ram4mx4 : ENTITY is ("14","26");
attribute package_type : STRING;
attribute package_type of ram4mx4 : ENTITY is "TC5117400@SOJ26_P_300C";
END ram4mx4;

ARCHITECTURE behavioral of ram4mx4 is	---------------------Architecture-----
BEGIN
end behavioral;
