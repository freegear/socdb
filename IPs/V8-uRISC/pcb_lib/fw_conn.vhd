--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: fw_conn.vhd
--
-- Description: 
--	Entity for a IEEE 1394 FireWire connector.
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: fw_conn.vhd,v $
-- Revision 1.3  1997/10/15 13:20:04  chris
-- Recoded connector to pass signals between assemblies.
--
-- Revision 1.2  1997/02/13 13:32:16  chris
-- corrected pin assignment attributes.
--
-- Revision 1.1  1996/11/11  19:56:05  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity fw_conn is
  port (pin1 : inout std_logic:='Z';     -- vp +8 to +40V
        pin2 : inout std_logic:='Z';     -- vg Ground
        pin3 : inout std_logic:='Z';     -- tpb_n
        pin4 : inout std_logic:='Z';     -- tpb  
        pin5 : inout std_logic:='Z';     -- tpa_n
        pin6 : inout std_logic:='Z';     -- tpa
        contact1 : inout std_logic:='Z'; 
        contact2 : inout std_logic:='Z';
        contact3 : inout std_logic:='Z';
        contact4 : inout std_logic:='Z';
        contact5 : inout std_logic:='Z';
        contact6 : inout std_logic:='Z');

attribute PIN_NUMBER : string;
attribute PIN_NUMBER of pin1 : SIGNAL is "1";
attribute PIN_NUMBER of pin2 : SIGNAL is "2";
attribute PIN_NUMBER of pin3 : SIGNAL is "3";
attribute PIN_NUMBER of pin4 : SIGNAL is "4";
attribute PIN_NUMBER of pin5 : SIGNAL is "5";
attribute PIN_NUMBER of pin6 : SIGNAL is "6";
attribute PIN_NUMBER of contact1 : SIGNAL is " ";
attribute PIN_NUMBER of contact2 : SIGNAL is " ";
attribute PIN_NUMBER of contact3 : SIGNAL is " ";
attribute PIN_NUMBER of contact4 : SIGNAL is " ";
attribute PIN_NUMBER of contact5 : SIGNAL is " ";
attribute PIN_NUMBER of contact6 : SIGNAL is " ";
attribute package_type : string;
attribute package_type of fw_conn : ENTITY is "FW_CONN@FW_CONN";
end fw_conn;

architecture structural of fw_conn is

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
  pin       => pin5,   -- 
  contact   => contact5);-- 

con_pin6: con_pin
  port map (
  pin       => pin6,   -- 
  contact   => contact6);-- 

end structural;
