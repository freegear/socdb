-- Entity:                      mt28f002b3vg_9b
-- SOMA file:                   ../../denali/mt28f002b3vg_9b.soma
-- Initial contents file:       ../../mt28f002b3vg_9b.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY mt28f002b3vg_9b IS
GENERIC (
    memory_spec: string := "../../denali/mt28f002b3vg_9b.soma";
    init_file:   string := "../../mt28f002b3vg_9b.dat"
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
END mt28f002b3vg_9b;

ARCHITECTURE behavior of mt28f002b3vg_9b is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "flashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
