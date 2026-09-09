--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: usbadual.vhd
--
-- Description: 
--	Entity for a dual stacked series A USB connector.
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: usbadual.vhd,v $
-- Revision 1.1  1998/04/01 17:36:43  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity usbadual is
  port (pin1 : inout std_logic:='Z';
        pin2 : inout std_logic:='Z';
        pin3 : inout std_logic:='Z';
        pin4 : inout std_logic:='Z';
        pin5 : inout std_logic:='Z';
        pin6 : inout std_logic:='Z';
        pin7 : inout std_logic:='Z';
        pin8 : inout std_logic:='Z';
        contact1 : inout std_logic:='Z';
        contact2 : inout std_logic:='Z';
        contact3 : inout std_logic:='Z';
        contact4 : inout std_logic:='Z';
        contact5 : inout std_logic:='Z';
        contact6 : inout std_logic:='Z';
        contact7 : inout std_logic:='Z';
        contact8 : inout std_logic:='Z');
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of pin1 : SIGNAL is "1";
attribute PIN_NUMBER of pin2 : SIGNAL is "2";
attribute PIN_NUMBER of pin3 : SIGNAL is "3";
attribute PIN_NUMBER of pin4 : SIGNAL is "4";
attribute PIN_NUMBER of pin5 : SIGNAL is "5";
attribute PIN_NUMBER of pin6 : SIGNAL is "6";
attribute PIN_NUMBER of pin7 : SIGNAL is "7";
attribute PIN_NUMBER of pin8 : SIGNAL is "8";
attribute PIN_NUMBER of contact1 : SIGNAL is " ";
attribute PIN_NUMBER of contact2 : SIGNAL is " ";
attribute PIN_NUMBER of contact3 : SIGNAL is " ";
attribute PIN_NUMBER of contact4 : SIGNAL is " ";
attribute PIN_NUMBER of contact5 : SIGNAL is " ";
attribute PIN_NUMBER of contact6 : SIGNAL is " ";
attribute PIN_NUMBER of contact7 : SIGNAL is " ";
attribute PIN_NUMBER of contact8 : SIGNAL is " ";
attribute package_type : string;
attribute package_type of usbadual : ENTITY is "USBADUAL@CON8A";
end usbadual;

architecture structural of usbadual is

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

con_pin5: con_pin
  port map (
  pin       => pin5,
  contact   => contact5);

con_pin6: con_pin
  port map (
  pin       => pin6, 
  contact   => contact6);

con_pin7: con_pin
  port map (
  pin       => pin7,  
  contact   => contact7);

con_pin8: con_pin
  port map (
  pin       => pin8,  
  contact   => contact8);

end structural;
