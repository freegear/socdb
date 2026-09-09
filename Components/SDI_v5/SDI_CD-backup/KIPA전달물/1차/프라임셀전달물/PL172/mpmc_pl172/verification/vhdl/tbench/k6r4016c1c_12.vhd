-- Entity:                      k6r4016c1c_12
-- SOMA file:                   ../..//denali/k6r4016c1c_12.soma
-- Initial contents file:       ../../denali/k6r4016c1c_12.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY k6r4016c1c_12 IS
GENERIC (
    memory_spec: string := "../..//denali/k6r4016c1c_12.soma";
    init_file:   string := "../../denali/k6r4016c1c_12.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(17 downto 0);
    webar : in    STD_LOGIC;
    csbar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    bbar  : in    STD_LOGIC_VECTOR(1 downto 0);
    io    : inout STD_LOGIC_VECTOR(15 downto 0)
);
END k6r4016c1c_12;

ARCHITECTURE behavior of k6r4016c1c_12 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
