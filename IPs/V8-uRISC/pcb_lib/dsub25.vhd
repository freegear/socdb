--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: dsub25.vhd
--
-- Description: 
--	Entity for a 25 pin D-SUB supply connector.
-- 	Typically used for a PC parallel port or RS232 connector.
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: dsub25.vhd,v $
-- Revision 1.2  1997/10/15 13:18:22  chris
-- Recoded connector to pass signals beteen assemblies.
--
-- Revision 1.1  1996/11/11  19:56:21  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity dsub25 is
  port (pin1 : inout std_logic:='Z';
        pin2 : inout std_logic:='Z';
        pin3 : inout std_logic:='Z';
        pin4 : inout std_logic:='Z';
        pin5 : inout std_logic:='Z';
        pin6 : inout std_logic:='Z';
        pin7 : inout std_logic:='Z';
        pin8 : inout std_logic:='Z';
        pin9 : inout std_logic:='Z';
        pin10 : inout std_logic:='Z';
        pin11 : inout std_logic:='Z';
        pin12 : inout std_logic:='Z';
        pin13 : inout std_logic:='Z';
        pin14 : inout std_logic:='Z';
        pin15 : inout std_logic:='Z';
        pin16 : inout std_logic:='Z';
        pin17 : inout std_logic:='Z';
        pin18 : inout std_logic:='Z';
        pin19 : inout std_logic:='Z';
        pin20 : inout std_logic:='Z';
        pin21 : inout std_logic:='Z';
        pin22 : inout std_logic:='Z';
        pin23 : inout std_logic:='Z';
        pin24 : inout std_logic:='Z';
        pin25 : inout std_logic:='Z';
        contact1 : inout std_logic:='Z';        
        contact2 : inout std_logic:='Z';	
        contact3 : inout std_logic:='Z';	
        contact4 : inout std_logic:='Z';	
        contact5 : inout std_logic:='Z';	
        contact6 : inout std_logic:='Z';	
        contact7 : inout std_logic:='Z';	
        contact8 : inout std_logic:='Z';	
        contact9 : inout std_logic:='Z';	
        contact10 : inout std_logic:='Z';	
        contact11 : inout std_logic:='Z';	
        contact12 : inout std_logic:='Z';	
        contact13 : inout std_logic:='Z';	
        contact14 : inout std_logic:='Z';	
        contact15 : inout std_logic:='Z';	
        contact16 : inout std_logic:='Z';	
        contact17 : inout std_logic:='Z';	
        contact18 : inout std_logic:='Z';	
        contact19 : inout std_logic:='Z';	
        contact20 : inout std_logic:='Z';	
        contact21 : inout std_logic:='Z';	
        contact22 : inout std_logic:='Z';	
        contact23 : inout std_logic:='Z';
        contact24 : inout std_logic:='Z';
        contact25 : inout std_logic:='Z');
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of pin1  : SIGNAL is "1";
attribute PIN_NUMBER of pin2  : SIGNAL is "2";
attribute PIN_NUMBER of pin3  : SIGNAL is "3";
attribute PIN_NUMBER of pin4  : SIGNAL is "4";
attribute PIN_NUMBER of pin5  : SIGNAL is "5";
attribute PIN_NUMBER of pin6  : SIGNAL is "6";
attribute PIN_NUMBER of pin7  : SIGNAL is "7";
attribute PIN_NUMBER of pin8  : SIGNAL is "8";
attribute PIN_NUMBER of pin9  : SIGNAL is "9";
attribute PIN_NUMBER of pin10 : SIGNAL is "10";
attribute PIN_NUMBER of pin11 : SIGNAL is "11";
attribute PIN_NUMBER of pin12 : SIGNAL is "12";
attribute PIN_NUMBER of pin13 : SIGNAL is "13";
attribute PIN_NUMBER of pin14 : SIGNAL is "14";
attribute PIN_NUMBER of pin15 : SIGNAL is "15";
attribute PIN_NUMBER of pin16 : SIGNAL is "16";
attribute PIN_NUMBER of pin17 : SIGNAL is "17";
attribute PIN_NUMBER of pin18 : SIGNAL is "18";
attribute PIN_NUMBER of pin19 : SIGNAL is "19";
attribute PIN_NUMBER of pin20 : SIGNAL is "20";
attribute PIN_NUMBER of pin21 : SIGNAL is "21";
attribute PIN_NUMBER of pin22 : SIGNAL is "22";
attribute PIN_NUMBER of pin23 : SIGNAL is "23";
attribute PIN_NUMBER of pin24 : SIGNAL is "24";
attribute PIN_NUMBER of pin25 : SIGNAL is "25";

attribute PIN_NUMBER of contact1  : SIGNAL is " ";
attribute PIN_NUMBER of contact2  : SIGNAL is " ";
attribute PIN_NUMBER of contact3  : SIGNAL is " ";
attribute PIN_NUMBER of contact4  : SIGNAL is " ";
attribute PIN_NUMBER of contact5  : SIGNAL is " ";
attribute PIN_NUMBER of contact6  : SIGNAL is " ";
attribute PIN_NUMBER of contact7  : SIGNAL is " ";
attribute PIN_NUMBER of contact8  : SIGNAL is " ";
attribute PIN_NUMBER of contact9  : SIGNAL is " ";
attribute PIN_NUMBER of contact10 : SIGNAL is " ";
attribute PIN_NUMBER of contact11 : SIGNAL is " ";
attribute PIN_NUMBER of contact12 : SIGNAL is " ";
attribute PIN_NUMBER of contact13 : SIGNAL is " ";
attribute PIN_NUMBER of contact14 : SIGNAL is " ";
attribute PIN_NUMBER of contact15 : SIGNAL is " ";
attribute PIN_NUMBER of contact16 : SIGNAL is " ";
attribute PIN_NUMBER of contact17 : SIGNAL is " ";
attribute PIN_NUMBER of contact18 : SIGNAL is " ";
attribute PIN_NUMBER of contact19 : SIGNAL is " ";
attribute PIN_NUMBER of contact20 : SIGNAL is " ";
attribute PIN_NUMBER of contact21 : SIGNAL is " ";
attribute PIN_NUMBER of contact22 : SIGNAL is " ";
attribute PIN_NUMBER of contact23 : SIGNAL is " ";
attribute PIN_NUMBER of contact24 : SIGNAL is " ";
attribute PIN_NUMBER of contact25 : SIGNAL is " ";
attribute package_type : string;
attribute package_type of dsub25 : ENTITY is "DSUB25@DSUB25";
end dsub25;

architecture structural of dsub25 is
  
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
    
con_pin10: con_pin
  port map (
  pin       => pin10,   -- 
  contact   => contact10);-- 
    
con_pin11: con_pin
  port map (
  pin       => pin11,   -- 
  contact   => contact11);-- 

con_pin12: con_pin
  port map (
  pin       => pin12,   -- 
  contact   => contact12);-- 

con_pin13: con_pin
  port map (
  pin       => pin13,   -- 
  contact   => contact13);-- 

con_pin14: con_pin
  port map (
  pin       => pin14,   -- 
  contact   => contact14);-- 

con_pin15: con_pin
  port map (
  pin       => pin15,   -- 
  contact   => contact15);-- 

con_pin16: con_pin
  port map (
  pin       => pin16,   -- 
  contact   => contact16);-- 

con_pin17: con_pin
  port map (
  pin       => pin17,   -- 
  contact   => contact17);-- 

con_pin18: con_pin
  port map (
  pin       => pin18,   -- 
  contact   => contact18);-- 

con_pin19: con_pin
  port map (
  pin       => pin19,   -- 
  contact   => contact19);-- 
    
con_pin20: con_pin
  port map (
  pin       => pin20,   -- 
  contact   => contact20);-- 
    
con_pin21: con_pin
  port map (
  pin       => pin21,   -- 
  contact   => contact21);-- 

con_pin22: con_pin
  port map (
  pin       => pin22,   -- 
  contact   => contact22);-- 

con_pin23: con_pin
  port map (
  pin       => pin23,   -- 
  contact   => contact23);-- 

con_pin24: con_pin
  port map (
  pin       => pin24,   -- 
  contact   => contact24);-- 

con_pin25: con_pin
  port map (
  pin       => pin25,   -- 
  contact   => contact25);-- 
    
end structural;

