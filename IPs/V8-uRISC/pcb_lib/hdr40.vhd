--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: hdr40.vhd
--
-- Description: 
--	VHDL entity for a 40 pin dual row .1 center  connector.
-- 	This connector is typically used for connection to an HP logic analyzer
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
--  |35 36|
--  |37 38|
--  |39 40|
--  +-----+
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: hdr40.vhd,v $
-- Revision 1.2  1998/04/02 16:12:20  eric
-- Fixed a typo...
--
-- Revision 1.1  1998/03/26  00:57:41  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity hdr40 is	-- a dual row of 20 .1 spacing pins.
  port (pin1	: inout std_logic := 'Z';	-- NC
        pin2	: inout std_logic := 'Z'; -- all even pins are ground
        pin3	: inout std_logic := 'Z'; -- CLK
        pin4	: inout std_logic := 'Z';
        pin5	: inout std_logic := 'Z'; -- NC - Keying pin
        pin6	: inout std_logic := 'Z'; -- PRIMARY GROUND!!!
        pin7	: inout std_logic := 'Z'; -- Channel 15
        pin8	: inout std_logic := 'Z';
        pin9	: inout std_logic := 'Z'; -- 14
        pin10	: inout std_logic := 'Z';
        pin11	: inout std_logic := 'Z'; -- 13
        pin12	: inout std_logic := 'Z';
        pin13	: inout std_logic := 'Z'; -- 12 
        pin14	: inout std_logic := 'Z';
        pin15	: inout std_logic := 'Z'; -- 11
        pin16	: inout std_logic := 'Z';
        pin17	: inout std_logic := 'Z'; -- 10
        pin18	: inout std_logic := 'Z';
        pin19	: inout std_logic := 'Z'; -- 9
        pin20	: inout std_logic := 'Z';
        pin21	: inout std_logic := 'Z'; -- 8
        pin22	: inout std_logic := 'Z';
        pin23	: inout std_logic := 'Z'; -- 7
        pin24	: inout std_logic := 'Z';
        pin25	: inout std_logic := 'Z'; -- 6
        pin26	: inout std_logic := 'Z';
        pin27	: inout std_logic := 'Z'; -- 5
        pin28	: inout std_logic := 'Z';
        pin29	: inout std_logic := 'Z'; -- 4
        pin30	: inout std_logic := 'Z';
        pin31	: inout std_logic := 'Z'; -- 3
        pin32	: inout std_logic := 'Z';
        pin33	: inout std_logic := 'Z'; -- 2 
        pin34	: inout std_logic := 'Z';
        pin35	: inout std_logic := 'Z'; -- 1
        pin36	: inout std_logic := 'Z';
        pin37	: inout std_logic := 'Z'; -- Channel 0 (always LSB of a bus here)
        pin38	: inout std_logic := 'Z';
        pin39	: inout std_logic := 'Z'; -- NC 
        pin40	: inout std_logic := 'Z');
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
attribute PIN_NUMBER of pin21 	: SIGNAL is "21";
attribute PIN_NUMBER of pin22 	: SIGNAL is "22";
attribute PIN_NUMBER of pin23 	: SIGNAL is "23";
attribute PIN_NUMBER of pin24 	: SIGNAL is "24";
attribute PIN_NUMBER of pin25 	: SIGNAL is "25";
attribute PIN_NUMBER of pin26 	: SIGNAL is "26";
attribute PIN_NUMBER of pin27 	: SIGNAL is "27";
attribute PIN_NUMBER of pin28 	: SIGNAL is "28";
attribute PIN_NUMBER of pin29 	: SIGNAL is "29";
attribute PIN_NUMBER of pin30 	: SIGNAL is "30";
attribute PIN_NUMBER of pin31 	: SIGNAL is "31";
attribute PIN_NUMBER of pin32 	: SIGNAL is "32";
attribute PIN_NUMBER of pin33 	: SIGNAL is "33";
attribute PIN_NUMBER of pin34 	: SIGNAL is "34";
attribute PIN_NUMBER of pin35 	: SIGNAL is "35";
attribute PIN_NUMBER of pin36 	: SIGNAL is "36";
attribute PIN_NUMBER of pin37 	: SIGNAL is "37";
attribute PIN_NUMBER of pin38 	: SIGNAL is "38";
attribute PIN_NUMBER of pin39 	: SIGNAL is "39";
attribute PIN_NUMBER of pin40 	: SIGNAL is "40";

ATTRIBUTE package_type: STRING;
ATTRIBUTE package_type OF hdr40 : ENTITY is "HDR40@HDR40";
end hdr40;

architecture behavioral of hdr40 is
begin
-- empty => don't do anything...
end behavioral;
