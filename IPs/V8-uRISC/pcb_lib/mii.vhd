--------------------------------------------------------------------------------
-- Copyright 1997 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: mii.vhd
--
-- Description: 
--	Entity for a 40 pin .050 D-SUB 10mbs ethernet MII connector.
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: mii.vhd,v $
-- Revision 1.3  1997/10/15 13:21:26  chris
-- Recoded the connector to pass signals between assemblies.
--
-- Revision 1.2  1997/03/11  21:25:43  eric
-- fixed pinout errors.
--
-- Revision 1.1  1997/02/14 19:00:33  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity mii is
  port (pin1 : inout std_logic:='Z';	-- +5V
        pin2 : inout std_logic:='Z';	-- MDIO
        pin3 : inout std_logic:='Z';	-- MDC
        pin4 : inout std_logic:='Z';	-- RXD(3)
        pin5 : inout std_logic:='Z';	-- RXD(2)
        pin6 : inout std_logic:='Z';	-- RXD(1)
        pin7 : inout std_logic:='Z';	-- RXD(0)
        pin8 : inout std_logic:='Z';	-- RX_DV
        pin9 : inout std_logic:='Z';	-- RX_CLK
        pin10 : inout std_logic:='Z';	-- RX_ERR
        pin11 : inout std_logic:='Z';	-- TX_ERR
        pin12 : inout std_logic:='Z';	-- TX_CLK
        pin13 : inout std_logic:='Z';	-- TX_EN
        pin14 : inout std_logic:='Z';	-- TXD(0)
        pin15 : inout std_logic:='Z';	-- TXD(1)
        pin16 : inout std_logic:='Z';	-- TXD(2)
        pin17 : inout std_logic:='Z';	-- TXD(3)
        pin18 : inout std_logic:='Z';	-- COL
        pin19 : inout std_logic:='Z';	-- CRS
        pin20 : inout std_logic:='Z';	-- +5V
        pin21 : inout std_logic:='Z';	-- +5V
        pin22 : inout std_logic:='Z';	-- pin 22-39 are all GND
        pin23 : inout std_logic:='Z';
        pin24 : inout std_logic:='Z';
        pin25 : inout std_logic:='Z';
        pin26 : inout std_logic:='Z';
        pin27 : inout std_logic:='Z';
        pin28 : inout std_logic:='Z';
        pin29 : inout std_logic:='Z';
        pin30 : inout std_logic:='Z';
        pin31 : inout std_logic:='Z';
        pin32 : inout std_logic:='Z';
        pin33 : inout std_logic:='Z';
        pin34 : inout std_logic:='Z';
        pin35 : inout std_logic:='Z';
        pin36 : inout std_logic:='Z';
        pin37 : inout std_logic:='Z';
        pin38 : inout std_logic:='Z';
        pin39 : inout std_logic:='Z';
        pin40 : inout std_logic:='Z';	-- +5V
        contact1 : inout std_logic:='Z';        -- +5V
        contact2 : inout std_logic:='Z';	-- MDIO
        contact3 : inout std_logic:='Z';	-- MDC
        contact4 : inout std_logic:='Z';	-- RXD(3)
        contact5 : inout std_logic:='Z';	-- RXD(2)
        contact6 : inout std_logic:='Z';	-- RXD(1)
        contact7 : inout std_logic:='Z';	-- RXD(0)
        contact8 : inout std_logic:='Z';	-- RX_DV
        contact9 : inout std_logic:='Z';	-- RX_CLK
        contact10 : inout std_logic:='Z';	-- RX_ERR
        contact11 : inout std_logic:='Z';	-- TX_ERR
        contact12 : inout std_logic:='Z';	-- TX_CLK
        contact13 : inout std_logic:='Z';	-- TX_EN
        contact14 : inout std_logic:='Z';	-- TXD(0)
        contact15 : inout std_logic:='Z';	-- TXD(1)
        contact16 : inout std_logic:='Z';	-- TXD(2)
        contact17 : inout std_logic:='Z';	-- TXD(3)
        contact18 : inout std_logic:='Z';	-- COL
        contact19 : inout std_logic:='Z';	-- CRS
        contact20 : inout std_logic:='Z';	-- +5V
        contact21 : inout std_logic:='Z';	-- +5V
        contact22 : inout std_logic:='Z';	-- contact 22-39 are all GND
        contact23 : inout std_logic:='Z';
        contact24 : inout std_logic:='Z';
        contact25 : inout std_logic:='Z';
        contact26 : inout std_logic:='Z';
        contact27 : inout std_logic:='Z';
        contact28 : inout std_logic:='Z';
        contact29 : inout std_logic:='Z';
        contact30 : inout std_logic:='Z';
        contact31 : inout std_logic:='Z';
        contact32 : inout std_logic:='Z';
        contact33 : inout std_logic:='Z';
        contact34 : inout std_logic:='Z';
        contact35 : inout std_logic:='Z';
        contact36 : inout std_logic:='Z';
        contact37 : inout std_logic:='Z';
        contact38 : inout std_logic:='Z';
        contact39 : inout std_logic:='Z';
        contact40 : inout std_logic:='Z');	-- +5V
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
attribute PIN_NUMBER of pin26 : SIGNAL is "26";
attribute PIN_NUMBER of pin27 : SIGNAL is "27";
attribute PIN_NUMBER of pin28 : SIGNAL is "28";
attribute PIN_NUMBER of pin29 : SIGNAL is "29";
attribute PIN_NUMBER of pin30 : SIGNAL is "30";
attribute PIN_NUMBER of pin31 : SIGNAL is "31";
attribute PIN_NUMBER of pin32 : SIGNAL is "32";
attribute PIN_NUMBER of pin33 : SIGNAL is "33";
attribute PIN_NUMBER of pin34 : SIGNAL is "34";
attribute PIN_NUMBER of pin35 : SIGNAL is "35";
attribute PIN_NUMBER of pin36 : SIGNAL is "36";
attribute PIN_NUMBER of pin37 : SIGNAL is "37";
attribute PIN_NUMBER of pin38 : SIGNAL is "38";
attribute PIN_NUMBER of pin39 : SIGNAL is "39";
attribute PIN_NUMBER of pin40 : SIGNAL is "40";

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
attribute PIN_NUMBER of contact26 : SIGNAL is " ";
attribute PIN_NUMBER of contact27 : SIGNAL is " ";
attribute PIN_NUMBER of contact28 : SIGNAL is " ";
attribute PIN_NUMBER of contact29 : SIGNAL is " ";
attribute PIN_NUMBER of contact30 : SIGNAL is " ";
attribute PIN_NUMBER of contact31 : SIGNAL is " ";
attribute PIN_NUMBER of contact32 : SIGNAL is " ";
attribute PIN_NUMBER of contact33 : SIGNAL is " ";
attribute PIN_NUMBER of contact34 : SIGNAL is " ";
attribute PIN_NUMBER of contact35 : SIGNAL is " ";
attribute PIN_NUMBER of contact36 : SIGNAL is " ";
attribute PIN_NUMBER of contact37 : SIGNAL is " ";
attribute PIN_NUMBER of contact38 : SIGNAL is " ";
attribute PIN_NUMBER of contact39 : SIGNAL is " ";
attribute PIN_NUMBER of contact40 : SIGNAL is " ";
attribute package_type : string;
attribute package_type of mii : ENTITY is "MII@DSUB40_050";
end mii;

architecture structural of mii is
  
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

con_pin26: con_pin
  port map (
  pin       => pin26,   -- 
  contact   => contact26);-- 

con_pin27: con_pin
  port map (
  pin       => pin27,   -- 
  contact   => contact27);-- 

con_pin28: con_pin
  port map (
  pin       => pin28,   -- 
  contact   => contact28);-- 

con_pin29: con_pin
  port map (
  pin       => pin29,   -- 
  contact   => contact29);-- 
    
con_pin30: con_pin
  port map (
  pin       => pin30,   -- 
  contact   => contact30);-- 
    
con_pin31: con_pin
  port map (
  pin       => pin31,   -- 
  contact   => contact31);-- 

con_pin32: con_pin
  port map (
  pin       => pin32,   -- 
  contact   => contact32);-- 

con_pin33: con_pin
  port map (
  pin       => pin33,   -- 
  contact   => contact33);-- 

con_pin34: con_pin
  port map (
  pin       => pin34,   -- 
  contact   => contact34);-- 

con_pin35: con_pin
  port map (
  pin       => pin35,   -- 
  contact   => contact35);-- 

con_pin36: con_pin
  port map (
  pin       => pin36,   -- 
  contact   => contact36);-- 

con_pin37: con_pin
  port map (
  pin       => pin37,   -- 
  contact   => contact37);-- 

con_pin38: con_pin
  port map (
  pin       => pin38,   -- 
  contact   => contact38);-- 

con_pin39: con_pin
  port map (
  pin       => pin39,   -- 
  contact   => contact39);-- 
    
con_pin40: con_pin
  port map (
  pin       => pin40,   -- 
  contact   => contact40);-- 
    
end structural;

