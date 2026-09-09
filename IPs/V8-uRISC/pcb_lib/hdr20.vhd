--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: hdr20.vhd
--
-- Description: 
--	VHDL entity for a 20 pin dual row .1 center  connector.
-- 	This connector is typically used for connection to an HP logic analyzer
--	Thru HP Part Number 01650-63203.
--
-- PCB Diagram Top View looking down onto a male connector:
--  +-----+
--  | 1  2|
--  | 3  4|
--  | 5  6|
--  | ... |
-- ++     |
-- +      |
-- ++     |
--  | ... |
--  |15 16|
--  |17 18|
--  |19 20|
--  +-----+
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: hdr20.vhd,v $
-- Revision 1.1  1998/09/03 19:00:28  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity hdr20 is	-- a dual row of 20 .1 spacing pins.
  port (pin1	: inout std_logic := 'Z'; -- +5V
        pin2	: inout std_logic := 'Z'; -- CLK2
        pin3	: inout std_logic := 'Z'; -- CLK1
        pin4	: inout std_logic := 'Z'; -- D15
        pin5	: inout std_logic := 'Z'; -- D14
        pin6	: inout std_logic := 'Z'; -- D13
        pin7	: inout std_logic := 'Z'; -- D12
        pin8	: inout std_logic := 'Z'; -- D11
        pin9	: inout std_logic := 'Z'; -- D10
        pin10	: inout std_logic := 'Z';
        pin11	: inout std_logic := 'Z'; -- D8
        pin12	: inout std_logic := 'Z';
        pin13	: inout std_logic := 'Z'; -- D6
        pin14	: inout std_logic := 'Z';
        pin15	: inout std_logic := 'Z'; -- D4
        pin16	: inout std_logic := 'Z';
        pin17	: inout std_logic := 'Z'; -- D2
        pin18	: inout std_logic := 'Z'; -- D1
        pin19	: inout std_logic := 'Z'; -- D0
        pin20	: inout std_logic := 'Z'); -- GND
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
attribute PIN_NUMBER of pin11 	: SIGNAL is "11";
attribute PIN_NUMBER of pin12 	: SIGNAL is "12";
attribute PIN_NUMBER of pin13 	: SIGNAL is "13";
attribute PIN_NUMBER of pin14 	: SIGNAL is "14";
attribute PIN_NUMBER of pin15 	: SIGNAL is "15";
attribute PIN_NUMBER of pin16 	: SIGNAL is "16";
attribute PIN_NUMBER of pin17 	: SIGNAL is "17";
attribute PIN_NUMBER of pin18 	: SIGNAL is "18";
attribute PIN_NUMBER of pin19 	: SIGNAL is "19";
attribute PIN_NUMBER of pin20 	: SIGNAL is "20";

ATTRIBUTE package_type: STRING;
ATTRIBUTE package_type OF hdr20 : ENTITY is "HDR20@HDR20";
end hdr20;

architecture behavioral of hdr20 is
begin
-- empty => don't do anything...
end behavioral;
