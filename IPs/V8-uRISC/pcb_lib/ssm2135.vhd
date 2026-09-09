-------------------------------------------------------------------------------
-- Copyright 1995 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: ssm2135.vhd
-- Description:
-- 	Crude model of the Analog Devices SSM2135 dual OP AMP.
--
-- Signals ending in _n are active low.
--------------Revision History--------------------------------------------------
-- $Log: ssm2135.vhd,v $
-- Revision 1.1  1996/11/11 19:56:47  eric
-- Initial revision
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;	-- we use the IEEE standard 1164 logic types.

ENTITY ssm2135 IS	------------------------------ENTITY--------------------
  port (
        ina_n   : in  std_logic;
        ina     : in  std_logic;
        outa    : out std_logic;
        inb_n   : in  std_logic;
        inb     : in  std_logic;
        outb    : out std_logic;
        gnds    : in  std_logic;
        pwr     : in  std_logic);

attribute pin_number : string;
ATTRIBUTE package_type: STRING;
ATTRIBUTE package_type OF ssm2135 : ENTITY is "SSM2135@SO8";
-- pinout is for the 8 pin SOIC
attribute pin_number of outa  : signal is "1";
attribute pin_number of ina_n : signal is "2";
attribute pin_number of ina   : signal is "3";
attribute pin_number of gnds  : signal is "4";
attribute pin_number of inb   : signal is "5";
attribute pin_number of inb_n : signal is "6";
attribute pin_number of outb  : signal is "7";
attribute pin_number of pwr   : signal is "8";
END ssm2135;

ARCHITECTURE behavioral of ssm2135 is -----------------Architecture-----------
BEGIN
-- empty
END behavioral;
