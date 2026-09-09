--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: pwr_conn.vhd
--
-- Description: 
--	Entity for a 5 pin round DIN power supply connector.
--
--          -----        +----+
--         /  U  \      /     /\
--        /       \    /     |  |        Pinout
--        |3     1|   /      |  |   <--- Looking at the connector
--        | 5   4 |   |      |  |	    from this direction
--         \  2  /    |       \/
--          -----    -+-------+--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: pwr_conn.vhd,v $
-- Revision 1.2  1997/02/14 18:57:25  eric
-- Added diagram of connector.
--
-- Revision 1.1  1996/11/11 19:57:34  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity pwr_conn is
  port (pin1 : out std_logic;
        pin2 : out std_logic;
        pin3 : out std_logic;
        pin4 : out std_logic;
        pin5 : out std_logic);
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of pin1 : SIGNAL is "1";
attribute PIN_NUMBER of pin2 : SIGNAL is "2";
attribute PIN_NUMBER of pin3 : SIGNAL is "3";
attribute PIN_NUMBER of pin4 : SIGNAL is "4";
attribute PIN_NUMBER of pin5 : SIGNAL is "5";
attribute package_type : string;
attribute package_type of pwr_conn : ENTITY is "PWR_CONN@DIN5";
end pwr_conn;

architecture behavioral of pwr_conn is
begin
-- typically pins 3 and 5 are power and the others are gnd...
pin1 <= '0';
pin2 <= '0';
pin3 <= '1';
pin4 <= '0';
pin5 <= '1';
end behavioral;
