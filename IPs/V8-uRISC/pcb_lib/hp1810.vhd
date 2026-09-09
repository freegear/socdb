--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: hp1810.vhd
--
-- Description: 
--  VHDL entity for a series resistor networks for HP logic analyer connectors.
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: hp1810.vhd,v $
-- Revision 1.1  1998/04/02 16:07:05  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity hp1810 is
  port (pin1	: in std_logic;	-- is connected to pin 18
        pin2	: in std_logic;
        pin3	: in std_logic;
        pin4	: in std_logic;
        pin5	: in std_logic;
        pin6	: in std_logic;
        pin7	: in std_logic;
        pin8	: in std_logic; -- is connected to pin 11
        pin9	: in std_logic; -- is connected to pin 10
        pin10	: in std_logic;
        pin11	: in std_logic;
        pin12	: in std_logic;
        pin13	: in std_logic;
        pin14	: in std_logic;
        pin15	: in std_logic;
        pin16	: in std_logic;
        pin17	: in std_logic;
        pin18	: in std_logic);
attribute PIN_NUMBER : string;
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

ATTRIBUTE package_type: STRING;
ATTRIBUTE package_type OF hp1810 : ENTITY is "HP1810@DIP18";
end hp1810;

architecture behavioral of hp1810 is
begin
-- empty => don't do anything...
end behavioral;
