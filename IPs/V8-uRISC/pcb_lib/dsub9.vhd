--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: dsub9.vhd
--
-- Description:
--	Entity for a 9 pin D-SUB supply connector.
-- 	Typically used for RS232 connector.
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: dsub9.vhd,v $
-- Revision 1.2  1997/10/15 13:18:58  chris
-- Recoded connector to pass signals between assemblies.
--
-- Revision 1.1  1996/11/11  19:56:21  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity dsub9 is
  port (pin1 : inout std_logic:='Z';
        pin2 : inout std_logic:='Z';
        pin3 : inout std_logic:='Z';
        pin4 : inout std_logic:='Z';
        pin5 : inout std_logic:='Z';
        pin6 : inout std_logic:='Z';
        pin7 : inout std_logic:='Z';
        pin8 : inout std_logic:='Z';
        pin9 : inout std_logic:='Z';
        contact1 : inout std_logic:='Z';
        contact2 : inout std_logic:='Z';
        contact3 : inout std_logic:='Z';
        contact4 : inout std_logic:='Z';
        contact5 : inout std_logic:='Z';
        contact6 : inout std_logic:='Z';
        contact7 : inout std_logic:='Z';
        contact8 : inout std_logic:='Z';
        contact9 : inout std_logic:='Z');
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of pin1 : SIGNAL is "1";
attribute PIN_NUMBER of pin2 : SIGNAL is "2";
attribute PIN_NUMBER of pin3 : SIGNAL is "3";
attribute PIN_NUMBER of pin4 : SIGNAL is "4";
attribute PIN_NUMBER of pin5 : SIGNAL is "5";
attribute PIN_NUMBER of pin6 : SIGNAL is "6";
attribute PIN_NUMBER of pin7 : SIGNAL is "7";
attribute PIN_NUMBER of pin8 : SIGNAL is "8";
attribute PIN_NUMBER of pin9 : SIGNAL is "9";
attribute PIN_NUMBER of contact1 : SIGNAL is " ";
attribute PIN_NUMBER of contact2 : SIGNAL is " ";
attribute PIN_NUMBER of contact3 : SIGNAL is " ";
attribute PIN_NUMBER of contact4 : SIGNAL is " ";
attribute PIN_NUMBER of contact5 : SIGNAL is " ";
attribute PIN_NUMBER of contact6 : SIGNAL is " ";
attribute PIN_NUMBER of contact7 : SIGNAL is " ";
attribute PIN_NUMBER of contact8 : SIGNAL is " ";
attribute PIN_NUMBER of contact9 : SIGNAL is " ";
attribute package_type : string;
attribute package_type of dsub9 : ENTITY is "DSUB9@DSUB9";
end dsub9;

architecture structural of dsub9 is

COMPONENT con_pin 	------------------------------ENTITY--------------------
  port (pin : inout std_logic:='Z';
        contact : inout std_logic:='Z'
        );
END COMPONENT;

signal off    :  std_logic_vector(1 TO 9) := (Others => '0');
 signal settle :  std_logic_vector(1 TO 9) := (Others => '0');
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

con_pin7: con_pin
  port map (
  pin       => pin7,   -- 
  contact   => contact7);-- 

con_pin8: con_pin
  port map (
  pin       => pin8,   -- 
  contact   => contact8);-- 

con_pin9: con_pin
  port map (
  pin       => pin9,   -- 
  contact   => contact9);-- 
    
end structural;
