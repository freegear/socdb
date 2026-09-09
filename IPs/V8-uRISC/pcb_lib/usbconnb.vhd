--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: usbconna.vhd
--
-- Description: 
--	Entity for a series B USB connector.
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: usbconnb.vhd,v $
-- Revision 1.2  1997/10/15 13:22:22  chris
-- Recoded connector to pass signals between assemblies.
--
-- Revision 1.1  1996/11/11 19:56:58  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity usbconnb is
  port (pin1 : inout std_logic:='Z';
        pin2 : inout std_logic:='Z';
        pin3 : inout std_logic:='Z';
        pin4 : inout std_logic:='Z';
        contact1 : inout std_logic:='Z';
        contact2 : inout std_logic:='Z';
        contact3 : inout std_logic:='Z';
        contact4 : inout std_logic:='Z');
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of pin1 : SIGNAL is "1";
attribute PIN_NUMBER of pin2 : SIGNAL is "2";
attribute PIN_NUMBER of pin3 : SIGNAL is "3";
attribute PIN_NUMBER of pin4 : SIGNAL is "4";
attribute PIN_NUMBER of contact1 : SIGNAL is " ";
attribute PIN_NUMBER of contact2 : SIGNAL is " ";
attribute PIN_NUMBER of contact3 : SIGNAL is " ";
attribute PIN_NUMBER of contact4 : SIGNAL is " ";
attribute package_type : string;
attribute package_type of usbconnb : ENTITY is "USBCONNB@CON4B";
end usbconnb;

architecture structural of usbconnb is

COMPONENT con_pin 	------------------------------ENTITY--------------------
  port (pin : inout std_logic:='Z';
        contact : inout std_logic:='Z'
        );
END COMPONENT;

begin

con_pin1: con_pin
  port map (
  pin       => pin1,   -- 
  contact   => contact1);-- 

con_pin2: con_pin
  port map (
  pin       => pin2,   -- 
  contact   => contact2);-- 

con_pin3: con_pin
  port map (
  pin       => pin3,   -- 
  contact   => contact3);-- 

con_pin4: con_pin
  port map (
  pin       => pin4,   -- 
  contact   => contact4);-- 

end structural;
