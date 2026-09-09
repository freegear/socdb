--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: plcc20th.vhd
--
-- Description: 
--	VHDL entity for a 20 pin PLCC thru hole socket.
-- 	This connector is typically used for Altera EPC1 PROMS
--
-- DIGIKEY part number ED80000 - $1.11
-- Mill-Max part number 540-99-020-24-000000
--
--           3  2  1 20 19
--          4/-----------|18
--          5|           |17
--	    6|           |16
--	    7|           |15
--	    8|-----------|14
--	     9 10 11 12 13
--------------------------------------------------------------------------------
-- Revision History
-- $Log: plcc20th.vhd,v $
-- Revision 1.1  1998/09/04 13:02:39  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity plcc20th is	-- 
  port (pin1	: inout std_logic := 'Z'; -- TDO - Altera EPC1 pinout
        pin2	: inout std_logic := 'Z'; -- DATA
        pin3	: inout std_logic := 'Z'; -- TCK
        pin4	: inout std_logic := 'Z'; -- DCLK
        pin5	: inout std_logic := 'Z'; -- VCC5
        pin6	: inout std_logic := 'Z'; -- NC
        pin7	: inout std_logic := 'Z'; -- NC
        pin8	: inout std_logic := 'Z'; -- OE
        pin9	: inout std_logic := 'Z'; -- nCS
        pin10	: inout std_logic := 'Z'; -- GND
        pin11	: inout std_logic := 'Z'; -- TDI
        pin12	: inout std_logic := 'Z'; -- nCASC
        pin13	: inout std_logic := 'Z'; -- nINIT/CONF
        pin14	: inout std_logic := 'Z'; -- VPP5
        pin15	: inout std_logic := 'Z'; -- NC
        pin16	: inout std_logic := 'Z'; -- NC
        pin17	: inout std_logic := 'Z'; -- NC
        pin18	: inout std_logic := 'Z'; -- VPP
        pin19	: inout std_logic := 'Z'; -- TMS
        pin20	: inout std_logic := 'Z'); -- VCC
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
ATTRIBUTE package_type OF plcc20th : ENTITY is "PLCC20TH@PLCC20TH";
end plcc20th;

architecture behavioral of plcc20th is
begin
-- empty => don't do anything...
end behavioral;
