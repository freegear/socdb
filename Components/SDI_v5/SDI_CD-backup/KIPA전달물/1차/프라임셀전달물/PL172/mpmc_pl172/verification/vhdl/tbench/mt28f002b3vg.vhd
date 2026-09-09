-- Entity:                      mt28f002b3vg
-- SOMA file:                   ./../denali/mt28f002b3vg.soma
-- Initial contents file:       ../../denali/mt28f002b3vg.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY mt28f002b3vg IS
GENERIC (
    memory_spec: string := "./../denali/mt28f002b3vg.soma";
    init_file:   string := "../../denali/mt28f002b3vg.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(17 downto 0);
    dq    : inout STD_LOGIC_VECTOR(7 downto 0);
    cebar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    webar : in    STD_LOGIC;
    wpbar : in    STD_LOGIC;
    rpbar : in    STD_LOGIC
);
END mt28f002b3vg;

ARCHITECTURE behavior of mt28f002b3vg is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "flashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
