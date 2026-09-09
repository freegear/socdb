--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: swdip8.vhd
--
-- Description: 
--	VHDL entity declaration for a DIP switch.
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: swdip8.vhd,v $
-- Revision 1.1  1996/11/11 20:49:35  eric
-- Initial revision
--
-- Revision 1.60  1996/05/22  23:30:57  gregg
-- PCB first pass
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity swdip8 is
  port (a1 : in  std_logic;  -- a1 input
        a2 : in  std_logic;  -- a2 input
        a3 : in  std_logic;  -- a3 input
        a4 : in  std_logic;  -- a4 input
        a5 : in  std_logic;  -- a5 input
        a6 : in  std_logic;  -- a6 input
        a7 : in  std_logic;  -- a7 input
        a8 : in  std_logic;  -- a8 input
        b1 : in  std_logic;  -- b1 input
        b2 : in  std_logic;  -- b2 input
        b3 : in  std_logic;  -- b3 input
        b4 : in  std_logic;  -- b4 input
        b5 : in  std_logic;  -- b5 input
        b6 : in  std_logic;  -- b6 input
        b7 : in  std_logic;  -- b7 input
        b8 : in  std_logic); -- b8 input

attribute pin_number : string;
attribute pin_number of a1 : signal is "1";
attribute pin_number of a2 : signal is "2";
attribute pin_number of a3 : signal is "3";
attribute pin_number of a4 : signal is "4";
attribute pin_number of a5 : signal is "5";
attribute pin_number of a6 : signal is "6";
attribute pin_number of a7 : signal is "7";
attribute pin_number of a8 : signal is "8";

attribute pin_number of b1 : signal is "16";
attribute pin_number of b2 : signal is "15";
attribute pin_number of b3 : signal is "14";
attribute pin_number of b4 : signal is "13";
attribute pin_number of b5 : signal is "12";
attribute pin_number of b6 : signal is "11";
attribute pin_number of b7 : signal is "10";
attribute pin_number of b8 : signal is "9";
attribute package_type : string;
attribute package_type of swdip8 : ENTITY is "SW@DIP16";
end swdip8;

architecture behavioral of swdip8 is
begin
-- empty => don't do anything...
end behavioral;
