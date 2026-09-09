--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: induct.vhd
--
-- Description: 
--	Place holder for an Inductor. Doesn't actually do anything...
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: induct.vhd,v $
-- Revision 1.3  1997/03/21 20:06:38  chris
-- Tristated outputs to prevent U state in simulation.
--
-- Revision 1.2  1997/02/14  18:57:56  eric
-- improved package_type attribute.
--
-- Revision 1.1  1996/11/11 19:55:50  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity induct is
  port (pin1 : inout std_logic := 'Z';
        pin2 : inout std_logic := 'Z');
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of pin1 : SIGNAL is "1";
attribute PIN_NUMBER of pin2 : SIGNAL is "2";
attribute package_type : string;
attribute package_type of induct : ENTITY is "induct@2pin_induct_500_240";
-- the package type is for a Delevan 4922 series inductor
end induct;

architecture behavioral of induct is
begin
end behavioral;
