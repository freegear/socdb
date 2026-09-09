--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: at1241mf.vhd
--
-- Description:
--	VHDL entity for the AT&TI 1241MF differential line receiver.
--      Only used for PCB generation.
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: at1241mf.vhd,v $
-- Revision 1.1  1996/11/11 19:55:47  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity at1241mf is
  port (
	ai_n       : in  std_logic;     -- Port A negative input
	ai         : in  std_logic;     -- Port A positive input
        ao         : out std_logic;     -- Port A output (ttl)
	bi_n       : in  std_logic;     -- Port B negative input
	bi         : in  std_logic;     -- Port B positive input
        bo         : out std_logic;     -- Port B output (ttl)
	ci_n       : in  std_logic;     -- Port C negative input
	ci         : in  std_logic;     -- Port C positive input
        co         : out std_logic;     -- Port C output (ttl)
	di_n       : in  std_logic;     -- Port D negative input
	di         : in  std_logic;     -- Port D positive input
        do         : out std_logic;     -- Port D output (ttl)
	e_n        : in  std_logic;     -- Output enable active low (ttl)
	e          : in  std_logic      -- Output enable active high (ttl)
      );

attribute pin_number : string;

attribute package_type : string;
attribute package_type of at1241mf : ENTITY is "at1241mf@SOIC16";

-- TI Att1241mfSSOP56 power and ground pin assignments
attribute GND_pins : string;
attribute VCC_pins : string;

	--Analog and digital grounds combined
attribute GND_pins of at1241mf : entity is ("8 ");

attribute VCC_pins of at1241mf : entity is ("16 ");

-- I/O pin assignments
attribute pin_number of ai_n       : signal is  "1 ";
attribute pin_number of ai         : signal is  "2 ";
attribute pin_number of ao         : signal is  "3 ";
attribute pin_number of e          : signal is  "4 ";
attribute pin_number of co         : signal is  "5 ";
attribute pin_number of ci         : signal is  "6 ";
attribute pin_number of ci_n       : signal is  "7 ";
-- A GND					 8
attribute pin_number of di_n       : signal is  "9 ";
attribute pin_number of di         : signal is  "10 ";
attribute pin_number of do         : signal is  "11";
attribute pin_number of e_n        : signal is  "12";
attribute pin_number of bo         : signal is  "13";
attribute pin_number of bi         : signal is  "14";
attribute pin_number of bi_n       : signal is  "15";
-- VCC					         16
end at1241mf;

architecture behavioral of at1241mf is

begin
-- empty
end;
