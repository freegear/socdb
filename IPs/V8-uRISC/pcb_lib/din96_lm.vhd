--------------------------------------------------------------------------------
-- Copyright 1995 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File:  din96_lm.vhd
--
-- Description:
-- 	This file defines the 96-pin din connectors used on the VAutomation
--      logic module.
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: din96_lm.vhd,v $
-- Revision 1.4  1997/01/28 22:46:17  chris
-- Added package type attribute.
--
-- Revision 1.3  1997/01/23 21:00:55  chris
-- changed port types from in to inout.
--
-- Revision 1.2  1997/01/23 18:53:27  chris
-- Changed the names of the clk pins to reflect the connector pin numbers.
--
-- Revision 1.1  1997/01/16 19:43:50  chris
-- Initial revision
--
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY  din96_lm IS
  PORT (
        a	: INOUT std_logic_vector(1 TO 32) := (OTHERS => 'Z');
        c       : INOUT std_logic_vector(1 TO 32) := (OTHERS => 'Z');
        clk_b8  : INOUT std_logic := 'Z';
        clk_b16 : INOUT std_logic := 'Z';
        clk_b24 : INOUT std_logic := 'Z'
       );

TYPE string_array IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF CHARACTER;

ATTRIBUTE pin_number: STRING;
ATTRIBUTE array_pin_number:  STRING_ARRAY;
ATTRIBUTE VCC_pins:  STRING_ARRAY;
ATTRIBUTE GND_pins:  STRING_ARRAY;

ATTRIBUTE GND_pins OF din96_lm: ENTITY IS ("B9 ","B10","B11","B12","B13","B14","B15",
                                           "B25","B26","B27","B28","B29","B30","B31","B32"
                                           );
ATTRIBUTE VCC_pins OF din96_lm: ENTITY IS ("B1 ","B2 ","B3 ","B4 ","B5 ","B6 ","B7 ",
                                           "B17","B18","B19","B20","B21","B22","B23"
                                           );


ATTRIBUTE array_pin_number OF a : SIGNAL IS ("A1 ","A2 ","A3 ","A4 ","A5 ","A6 ","A7 ","A8 ",
                                             "A9 ","A10","A11","A12","A13","A14","A15","A16",
                                             "A17","A18","A19","A20","A21","A22","A23","A24",
                                             "A25","A26","A27","A28","A29","A30","A31","A32"
                                            );

ATTRIBUTE array_pin_number OF c : SIGNAL IS ("C1 ","C2 ","C3 ","C4 ","C5 ","C6 ","C7 ","C8 ",
                                             "C9 ","C10","C11","C12","C13","C14","C15","C16",
                                             "C17","C18","C19","C20","C21","C22","C23","C24",
                                             "C25","C26","C27","C28","C29","C30","C31","C32"
                                            );

ATTRIBUTE pin_number OF clk_b8  : SIGNAL IS "B8";
ATTRIBUTE pin_number OF clk_b16 : SIGNAL IS "B16";
ATTRIBUTE pin_number OF clk_b24 : SIGNAL IS "B24";

ATTRIBUTE package_type: STRING;
ATTRIBUTE package_type OF din96_lm : ENTITY is "DIN96@DIN96";

END din96_lm;                            -- ENTITY


ARCHITECTURE behavioral OF din96_lm IS
BEGIN
-- empty => don't do anything...
END behavioral;
