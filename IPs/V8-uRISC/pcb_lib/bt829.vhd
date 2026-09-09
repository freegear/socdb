-------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: bt829.vhd
-- Description:
-- 	Entity for a BT829 video decoder for PCB design purposes.
--
-- Signals ending in _n are active low.
--------------Revision History--------------------------------------------------
-- $Log: bt829.vhd,v $
-- Revision 1.1  1998/04/02 01:26:49  eric
-- Initial revision
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;	-- we use the IEEE standard 1164 logic types.

ENTITY	bt829	IS --------------------ENTITY-------------------------------
  PORT ( -- digital video stream interface
	vd	: OUT std_logic_vector(15 downto 0) := (others => 'Z'); -- video data
	qclk	: out std_logic := 'Z'; -- video data on rising edge
	active	: out std_logic := 'Z';
	ccvalid	: out std_logic := 'Z';
	cbflag	: out std_logic := 'Z';
	dvalid	: out std_logic := 'Z';
	field	: out std_logic := 'Z';
	hreset_n: out std_logic := 'Z';
	oe_n	: in std_logic;
	vactive	: out std_logic := 'Z';
	vreset_n: out std_logic := 'Z';
	-- clocks and misc interface
	clkx1	: out std_logic := 'Z';
	clkx2	: out std_logic := 'Z';
	numxtal	: in std_logic;
	pwrdn	: in std_logic;
	xt0i	: inout std_logic := 'Z';
	xt0o	: inout std_logic := 'Z';
	xt1i	: inout std_logic := 'Z';
	xt1o	: inout std_logic := 'Z';
	-- I2C bus interface
	i2ccs	: in std_logic;
	scl	: in std_logic;
	sda	: inout std_logic := 'Z';
	rst_n	: in std_logic;
	-- JTAG interface
	tck	: in std_logic;
	tdi	: in std_logic;
	tdo	: out std_logic := 'Z';
	tms	: in std_logic;
	trst_n	: in std_logic;
	-- analog interface
	agccap	: inout std_logic := 'Z';
	cabias	: inout std_logic := 'Z';
	ccbias	: inout std_logic := 'Z';
	cin	: in std_logic;
	clevel	: in std_logic;
	cref_p	: in std_logic;
	cref_m	: in std_logic;
	mux_0	: in std_logic;
	mux_1	: in std_logic;
	mux_2	: in std_logic;
	muxout	: out std_logic := 'Z';
	syncdet	: in std_logic;
	yabias	: inout std_logic := 'Z';
	ycbias	: inout std_logic := 'Z';
	yin	: in std_logic;
	yref_p	: in std_logic;
	yref_m	: in std_logic;
	refout	: out std_logic := 'Z');
-- pinout is for the 100 pin pqfp
TYPE string_array IS ARRAY (natural range <>, natural range <>) OF CHARACTER;

attribute pin_number : string;
attribute array_pin_number : string_array;
attribute array_pin_number of vd	: SIGNAL is 
	("2 ","3 ","4 ","5 ","6 ","7 ","8 ","9 ",
	 "22","23","24","25","26","27","28","29");
attribute pin_number of xt0i	: SIGNAL is "12";
attribute pin_number of xt0o	: SIGNAL is "13";
attribute pin_number of i2ccs	: SIGNAL is "14";
attribute pin_number of rst_n	: SIGNAL is "15";
attribute pin_number of xt1i	: SIGNAL is "16";
attribute pin_number of xt1o	: SIGNAL is "17";
attribute pin_number of sda	: SIGNAL is "18";
attribute pin_number of scl	: SIGNAL is "19";
attribute pin_number of tdo	: SIGNAL is "32";
attribute pin_number of tck	: SIGNAL is "34";
attribute pin_number of trst_n	: SIGNAL is "35";
attribute pin_number of tms	: SIGNAL is "36";
attribute pin_number of tdi	: SIGNAL is "37";
attribute pin_number of agccap	: SIGNAL is "41";
attribute pin_number of refout	: SIGNAL is "43";
attribute pin_number of mux_2	: SIGNAL is "45";
attribute pin_number of ycbias	: SIGNAL is "46";
attribute pin_number of yref_p	: SIGNAL is "49";
attribute pin_number of yabias	: SIGNAL is "51";
attribute pin_number of yin	: SIGNAL is "52";
attribute pin_number of muxout	: SIGNAL is "53";
attribute pin_number of mux_0	: SIGNAL is "55";
attribute pin_number of mux_1	: SIGNAL is "57";
attribute pin_number of syncdet	: SIGNAL is "59";
attribute pin_number of yref_m	: SIGNAL is "62";
attribute pin_number of cref_p	: SIGNAL is "64";
attribute pin_number of cin	: SIGNAL is "67";
attribute pin_number of ccbias	: SIGNAL is "69";
attribute pin_number of cabias	: SIGNAL is "70";
attribute pin_number of cref_m	: SIGNAL is "73";
attribute pin_number of clevel	: SIGNAL is "74";
attribute pin_number of field	: SIGNAL is "78";
attribute pin_number of vreset_n	: SIGNAL is "79";
attribute pin_number of numxtal	: SIGNAL is "80";
attribute pin_number of hreset_n	: SIGNAL is "82";
attribute pin_number of active	: SIGNAL is "83";
attribute pin_number of dvalid	: SIGNAL is "84";
attribute pin_number of vactive	: SIGNAL is "86";
attribute pin_number of ccvalid	: SIGNAL is "87";
attribute pin_number of cbflag	: SIGNAL is "89";
attribute pin_number of pwrdn	: SIGNAL is "91";
attribute pin_number of qclk	: SIGNAL is "94";
attribute pin_number of clkx1	: SIGNAL is "97";
attribute pin_number of oe_n	: SIGNAL is "98";
attribute pin_number of clkx2	: SIGNAL is "99";

attribute VCC_PINS : string_array;
attribute GND_PINS : string_array;
attribute VCC_PINS of bt829 : ENTITY is ("1 ","10","20","30","38","44","48","60","65","72","76","88","92","96","40");
attribute GND_PINS of bt829 : ENTITY is ("11 ","21 ","31 ","33 ","39 ","47 ","54 ","56 ","58 ","66 ","71 ","75 ","77 ","81 ","85 ","90 ","93 ","95 ","100","42 ");
attribute package_type : STRING;
attribute package_type of bt829 : ENTITY is "BT829@PQFP100_20mmx14mm";
END bt829;

ARCHITECTURE behav of bt829 is ----------------Architecture----------------
BEGIN
end behav;

