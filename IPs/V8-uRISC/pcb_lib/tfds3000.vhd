--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: tfds3000.vhd
--
-- Description: 
--	VHDL entity for the Temic Semiconductors IrDA SIR Integrated
--      transceiver. Only used for PCB generation.
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: tfds3000.vhd,v $
-- Revision 1.1  1996/11/11 19:57:34  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity tfds3000 is
  port (ired_c : inout std_logic;  -- IRED cathode, normally leave this OPEN
        rxd    : out std_logic;  -- Receive data
        pwr    : in  std_logic;  -- Vcc range (3 to 5.5 V)
        gnds   : in  std_logic;  -- Ground
        sd     : in  std_logic;  -- Shut down
        txd    : in  std_logic;  -- Transmit data
        ired_a : in  std_logic); -- IRED anode

type string_array is array (natural range <>, natural range <>) of character;

attribute pin_number : string;

attribute package_type : string;
attribute package_type of tfds3000 : ENTITY is "tfds3000@temic8";

-- I/O pin assignments
attribute pin_number of ired_c : signal is "1";
attribute pin_number of rxd    : signal is "2";
attribute pin_number of pwr    : signal is "3";
attribute pin_number of gnds   : signal is "4";
attribute pin_number of sd     : signal is "6";
attribute pin_number of txd    : signal is "7";
attribute pin_number of ired_a : signal is "8";

end tfds3000;

architecture behavioral of tfds3000 is

begin
-- empty
end;
