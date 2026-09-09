-----------------------------------------------------------------------------
--
-- File: ldo_reg.vhd
--
-- Description: entity for a low Drop Out Regulator
--	Specifically this is the pinout for a Zetex ZLDO330.
--
-- Copyright 1998 VAutomation Inc. Nashua NH. All rights reserved.
-- VAutomation Inc. 20 Trafalgar Sq. Nashua NH 03063 (603)882-2282.
-- This software is provided under license and contains proprietary
-- and confidential material which is the property of VAutomation Inc.
--
-----------------------------------------------------------------------------
-- $Log: ldo_reg.vhd,v $
-- Revision 1.3  1998/04/16 14:51:56  eric
-- changed the package type as it is not a standard SO8.
--
-- Revision 1.2  1998/03/26 15:39:26  eric
-- Fixed the direction of some of the IOs so you can leave them unconnected.
--
-- Revision 1.1  1998/03/25 19:33:16  eric
-- Initial revision
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

----------------- Entity declaration ---------------------------------

ENTITY ldo_reg IS
  PORT (SIGNAL lbf	: OUT std_logic;  -- low battery flag
        SIGNAL sc	: IN  std_logic;  -- Shutdown Control (tie to gnd)
        SIGNAL vin   	: IN  std_logic;  -- Vin = 5-30V
        SIGNAL nc	: OUT std_logic;  -- No-Connect
        SIGNAL vout   	: OUT std_logic;  -- Vout = 3.3V @ 300ma
        SIGNAL dc   	: OUT std_logic;  -- Do Not Connect
        SIGNAL gnd   	: IN  std_logic;  -- ground
        SIGNAL spg  	: IN  std_logic); -- Shaping (10pF to vout required)

ATTRIBUTE pin_number : string;
ATTRIBUTE package_type: STRING;
ATTRIBUTE package_type OF ldo_reg : ENTITY is "ZLDO330@SO8_130MIL";
ATTRIBUTE pin_number of lbf   : signal is "1";
ATTRIBUTE pin_number of sc    : signal is "2";
ATTRIBUTE pin_number of vin   : signal is "3";
ATTRIBUTE pin_number of nc    : signal is "4";
ATTRIBUTE pin_number of vout  : signal is "5";
ATTRIBUTE pin_number of dc    : signal is "6";
ATTRIBUTE pin_number of gnd   : signal is "7";
ATTRIBUTE pin_number of spg   : signal is "8";

END ldo_reg;

ARCHITECTURE behavioral of ldo_reg is	---------------------Architecture-----
BEGIN
  vout <= vin when sc='0' else '0';	-- when SC is low, the regulator is on.
end behavioral;
