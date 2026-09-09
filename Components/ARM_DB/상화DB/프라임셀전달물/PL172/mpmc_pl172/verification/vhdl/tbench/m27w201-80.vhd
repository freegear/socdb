-- Entity:                      m27w201_80
-- SOMA file:                   ../../denali/m27w201-80.soma
-- Initial contents file:       ../../denali/m27w201_80.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY m27w201_80 IS
GENERIC (
    memory_spec: string := "../../denali/m27w201-80.soma";
    init_file:   string := "../../denali/m27w201_80.dat"
);
PORT (
    a    : in    STD_LOGIC_VECTOR(17 downto 0);
    ebar : in    STD_LOGIC;
    gbar : in    STD_LOGIC;
    q    : inout STD_LOGIC_VECTOR(7 downto 0)
);
END m27w201_80;

ARCHITECTURE behavior of m27w201_80 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "promInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
