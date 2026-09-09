--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: led.vhd
--
-- Description: 
--	Functional VHDL model for a Light Emitting Diode.
--	For PCB generation use only.
--
--                |\  |
--                | \ |
--     Anode -----|  >|---->Cathode
--                | / |
--                |/  |

--------------------------------------------------------------------------------
-- Revision History
-- $Log: led.vhd,v $
-- Revision 1.1  1996/11/11 19:55:58  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity led is
  port (anode   : in  std_logic;
        cathode : in std_logic);
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of anode   : SIGNAL is "1";
attribute PIN_NUMBER of cathode : SIGNAL is "2";
attribute package_type : string;
attribute package_type of led : ENTITY is "LED@2PINLED";
end led;

architecture behavioral of led is

begin
-- Empty
end behavioral;
