-------------------------------------------------------------------------------
-- Copyright 1995 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: max241e.vhd
-- Description:
-- 	Crude model of the Maxim 241e RS232 driver
-- t1in is assumed to be TX data and is converted to ascii and printed on STDOUT
--
-- Signals ending in _n are active low.

--------------Revision History--------------------------------------------------
-- $Log: max241e.vhd,v $
-- Revision 1.5  1997/10/29 15:37:58  eric
-- added to_x01 so pulldowns work.
--
-- Revision 1.4  1997/10/25 01:30:43  eric
-- removed unused packages to ease verilog translation.
--
-- Revision 1.3  1997/10/15 13:20:44  chris
-- Removed terminal emulation function and added signal passing.
--
-- Revision 1.2  1997/09/03 15:06:58  eric
-- added printing and data file commands.
--
-- Revision 1.1  1996/11/11 19:55:55  eric
-- Initial revision
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;	-- we use the IEEE standard 1164 logic types.

ENTITY max241e IS	------------------------------ENTITY--------------------
  port (
	r1in   : in  std_logic; -- RS232 input
	r2in   : in  std_logic;
	r3in   : in  std_logic;
	r4in   : in  std_logic;
	r5in   : in  std_logic;
	r1out  : out std_logic; -- TTL outputs
	r2out  : out std_logic;
	r3out  : out std_logic;
	r4out  : out std_logic;
	r5out  : out std_logic;
	t1in   : in  std_logic; -- TTL input to RS232
	t2in   : in  std_logic;
	t3in   : in  std_logic;
	t4in   : in  std_logic;
	t1out  : out std_logic; -- RS232 output
	t2out  : out std_logic;
	t3out  : out std_logic;
	t4out  : out std_logic;
	shdn   : in  std_logic; -- shutdown
	en_n   : in  std_logic; -- tristate enable
	-- analog pins
	c1p    : in  std_logic;	-- connect a 1.0uf to c1m
	c1m    : in  std_logic;
	c2p    : in  std_logic; -- connect a 1.0uf to c2m
	c2m    : in  std_logic;
	vp     : in  std_logic; -- connect 1.0 uf to both of these.
	vm     : in  std_logic);

-- pinout is for the 28 pin wide SO
TYPE string_array IS ARRAY (natural range <>, natural range <>) OF CHARACTER;

attribute pin_number : string;
attribute array_pin_number : string_array;
attribute pin_number of t3out 	: SIGNAL is "1";
attribute pin_number of t1out 	: SIGNAL is "2";
attribute pin_number of t2out	: SIGNAL is "3";
attribute pin_number of r2in 	: SIGNAL is "4";
attribute pin_number of r2out 	: SIGNAL is "5";
attribute pin_number of t2in 	: SIGNAL is "6";
attribute pin_number of t1in 	: SIGNAL is "7";
attribute pin_number of r1out 	: SIGNAL is "8";
attribute pin_number of r1in 	: SIGNAL is "9";
attribute pin_number of c1p	: SIGNAL is "12";
attribute pin_number of vp	: SIGNAL is "13";
attribute pin_number of c1m	: SIGNAL is "14";
attribute pin_number of c2p	: SIGNAL is "15";
attribute pin_number of c2m	: SIGNAL is "16";
attribute pin_number of vm	: SIGNAL is "17";
attribute pin_number of r5in	: SIGNAL is "18";
attribute pin_number of r5out	: SIGNAL is "19";
attribute pin_number of t3in	: SIGNAL is "20";
attribute pin_number of t4in	: SIGNAL is "21";
attribute pin_number of r4out	: SIGNAL is "22";
attribute pin_number of r4in	: SIGNAL is "23";
attribute pin_number of en_n	: SIGNAL is "24";
attribute pin_number of shdn	: SIGNAL is "25";
attribute pin_number of r3out	: SIGNAL is "26";
attribute pin_number of r3in	: SIGNAL is "27";
attribute pin_number of t4out	: SIGNAL is "28";

attribute VCC_PINS : STRING;
attribute GND_PINS : STRING;
attribute VCC_PINS of max241e : ENTITY is "11";
attribute GND_PINS of max241e : ENTITY is "10";
attribute package_type : STRING;
attribute package_type of max241e : ENTITY is "max241e@SO28";
END max241e;

ARCHITECTURE behav of max241e is ------------------ARCHITECTURE---------------
BEGIN
  
  r1out  <= NOT r1in WHEN to_x01(en_n) = '0' ELSE 'Z';
  r2out  <= NOT r2in WHEN to_x01(en_n) = '0' ELSE 'Z';
  r3out  <= NOT r3in WHEN to_x01(en_n) = '0' ELSE 'Z';
  r4out  <= NOT r4in WHEN to_x01(en_n) = '0' ELSE 'Z';
  r5out  <= NOT r5in WHEN to_x01(en_n) = '0' ELSE 'Z';

  t1out <= NOT t1in;
  t2out <= NOT t2in;
  t3out <= NOT t3in;
  t4out <= NOT t4in;
        
END behav;
