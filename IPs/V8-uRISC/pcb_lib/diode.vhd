--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: diode.vhd
--
-- Description: 
--	VHDL shell of a diode for PCB generation use only.
--
--                |\  |
--                | \ |
--     Anode -----|  >|---->Cathode
--                | / |
--                |/  |

--------------------------------------------------------------------------------
-- Revision History
-- $Log: diode.vhd,v $
-- Revision 1.1  1996/11/11 19:57:34  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity diode is
  port (anode   : in  std_logic;
        cathode : in std_logic);
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of anode   : SIGNAL is "1";
attribute PIN_NUMBER of cathode : SIGNAL is "2";
attribute package_type : string;
attribute package_type of diode : ENTITY is "DIODE@MELF";
end diode;

architecture behavioral of diode is

begin
-- Empty
end behavioral;
