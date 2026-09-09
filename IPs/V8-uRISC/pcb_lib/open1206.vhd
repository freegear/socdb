--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: open1206.vhd
--
-- Description:
--	Functional VHDL model for a weak unidirectional resistor. Note that this
--	model does not have bi-directional ports.
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: open1206.vhd,v $
-- Revision 1.1  1997/03/21 12:57:37  chris
-- Initial revision
--
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity open1206 is
  port (a : in    std_logic;  -- a input
        z : inout std_logic); -- z output
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of a : SIGNAL is "1";
attribute PIN_NUMBER of z : SIGNAL is "2";
attribute package_type : string;
attribute package_type of open1206 : ENTITY is "res@1206";
end open1206;

architecture behavioral of open1206 is
  
begin

  z <= 'Z';

end behavioral;
