--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: hdr10.vhd
--
-- Description: 
--	VHDL entity for a 10 pin dual row .1 center  connector.
-- 	This connector is typically used for connection to an Altera BitBlaster.
--
-- PCB Diagram Top View looking down onto a male connector:
--  +-----+
--  | 1  2|
--  | 3  4|
--  | 5  6|
--  | 7  8|
--  | 9 10|
--  +-----+
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: hdr10.vhd,v $
-- Revision 1.1  1998/04/02 15:40:50  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity hdr10 is	-- a dual row of 20 .1 spacing pins.
  port (pin1	: inout std_logic := 'Z'; -- DCL -- Altera BitBlaster signals
        pin2	: inout std_logic := 'Z'; -- GND
        pin3	: inout std_logic := 'Z'; -- CONF_DONE
        pin4	: inout std_logic := 'Z'; -- VCC (use +5v even on 3.3v parts)
        pin5	: inout std_logic := 'Z'; -- nCONFIG
        pin6	: inout std_logic := 'Z'; -- NC
        pin7	: inout std_logic := 'Z'; -- nSTATUS
        pin8	: inout std_logic := 'Z'; -- NC
        pin9	: inout std_logic := 'Z'; -- DATA0
        pin10	: inout std_logic := 'Z'); -- GND
attribute PIN_NUMBER : string;
TYPE string_array IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF CHARACTER;
attribute ARRAY_PIN_NUMBER : string_array;
attribute PIN_NUMBER of pin1 	: SIGNAL is "1";
attribute PIN_NUMBER of pin2 	: SIGNAL is "2";
attribute PIN_NUMBER of pin3 	: SIGNAL is "3";
attribute PIN_NUMBER of pin4 	: SIGNAL is "4";
attribute PIN_NUMBER of pin5 	: SIGNAL is "5";
attribute PIN_NUMBER of pin6 	: SIGNAL is "6";
attribute PIN_NUMBER of pin7 	: SIGNAL is "7";
attribute PIN_NUMBER of pin8 	: SIGNAL is "8";
attribute PIN_NUMBER of pin9 	: SIGNAL is "9";
attribute PIN_NUMBER of pin10 	: SIGNAL is "10";
ATTRIBUTE package_type: STRING;
ATTRIBUTE package_type OF hdr10 : ENTITY is "HDR10@HDR10";
end hdr10;

architecture behavioral of hdr10 is
begin
-- empty => don't do anything...
end behavioral;
