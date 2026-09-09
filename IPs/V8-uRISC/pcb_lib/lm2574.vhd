-----------------------------------------------------------------------------
--
-- File: lm2574.vhd
--
-- Description: entity for a DC-DC switcher
--
-- Copyright 1995 VAutomation Inc. Nashua NH. All rights reserved.
-- VAutomation Inc. 20 Trafalgar Sq. Nashua NH 03063 (603)882-2282.
-- This software is provided under license and contains proprietary
-- and confidential material which is the property of VAutomation Inc.
--
-----------------------------------------------------------------------------
-- $Log: lm2574.vhd,v $
-- Revision 1.1  1996/11/11 19:50:21  eric
-- Initial revision
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

----------------- Entity declaration ---------------------------------

ENTITY lm2574 IS
  PORT (SIGNAL feedbk: IN std_logic;  -- feedback pin
        SIGNAL siggnd: IN std_logic;  -- gnd
        SIGNAL off   : IN std_logic;  -- 1=off, 0=on
        SIGNAL pwrgnd: IN std_logic;  -- gnd
        SIGNAL vin   : IN std_logic;  -- vin = 5-45Volts
        SIGNAL vout  : OUT std_logic);-- vout

ATTRIBUTE pin_number : string;
ATTRIBUTE package_type: STRING;
ATTRIBUTE package_type OF lm2574 : ENTITY is "LM2574@DIP8";
ATTRIBUTE pin_number of feedbk : signal is "1";
ATTRIBUTE pin_number of siggnd : signal is "2";
ATTRIBUTE pin_number of off    : signal is "3";
ATTRIBUTE pin_number of pwrgnd : signal is "4";
ATTRIBUTE pin_number of vin    : signal is "5";
ATTRIBUTE pin_number of vout   : signal is "7";

END lm2574;

ARCHITECTURE behavioral of lm2574 is	---------------------Architecture-----
BEGIN
-- empty
end behavioral;
