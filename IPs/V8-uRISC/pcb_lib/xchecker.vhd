--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: xchecker.vhd
--
-- Description: 
--	VHDL entity for the Xilinx XChecker cable.
--	Only used for PCB generation...
--
-- Top View of the hole pattern:
-- .1 in spacing, dual row header
--              +-----+
--              |A1 B1|
--              |A2 B2| A3 and B4 are key pins on the connector.
--              |   B3| Include the holes, but the pin has to be cut
--              |A4   | after the header is soldered in.
--              |A5 B4|
--              |A6 B5|
--              |A7 B6|
--              |A8 B8|
--              |A9 B9|
--              +-----+

--------------------------------------------------------------------------------
-- Revision History
-- $Log: xchecker.vhd,v $
-- Revision 1.1  1996/11/11 19:50:21  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity xchecker is	-- a double row of .1 spacing pins.
  port (power : in std_logic;
        ground: in std_logic;
	-- then a space
        cclk	: inout std_logic:='Z';
        done	: inout std_logic:='Z'; -- labeled D/P	-- be sure to pullup!
        din	: inout std_logic:='Z';
        prog_n	: inout std_logic:='Z';	-- be sure to pullup!
        init_n	: inout std_logic:='Z';	-- be sure to pullup!
        rst	: inout std_logic:='Z';
	-- second row...
        rt	: inout std_logic:='Z';
        rd	: inout std_logic:='Z';
        trig	: inout std_logic:='Z';
	-- then a space
        tdi	: inout std_logic:='Z';
        tck	: inout std_logic:='Z';
        tms	: inout std_logic:='Z';
        clki	: inout std_logic:='Z';
        clko	: inout std_logic:='Z');
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of power	: SIGNAL is "A1";
attribute PIN_NUMBER of ground 	: SIGNAL is "A2";
attribute PIN_NUMBER of cclk 	: SIGNAL is "A4";
attribute PIN_NUMBER of done 	: SIGNAL is "A5";
attribute PIN_NUMBER of din 	: SIGNAL is "A6";
attribute PIN_NUMBER of prog_n 	: SIGNAL is "A7";
attribute PIN_NUMBER of init_n	: SIGNAL is "A8";
attribute PIN_NUMBER of rst 	: SIGNAL is "A9";
attribute PIN_NUMBER of rt 	: SIGNAL is "B1";
attribute PIN_NUMBER of rd 	: SIGNAL is "B2";
attribute PIN_NUMBER of trig 	: SIGNAL is "B3";
attribute PIN_NUMBER of tdi 	: SIGNAL is "B5";
attribute PIN_NUMBER of tck 	: SIGNAL is "B6";
attribute PIN_NUMBER of tms 	: SIGNAL is "B7";
attribute PIN_NUMBER of clki 	: SIGNAL is "B8";
attribute PIN_NUMBER of clko 	: SIGNAL is "B9";
attribute package_type : string;
attribute package_type of xchecker : ENTITY is "XCHECKER@DRHDR18";
end xchecker;

architecture behavioral of xchecker is
begin
end behavioral;
