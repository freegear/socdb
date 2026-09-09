-- Entity:                      x28c256_15
-- SOMA file:                   ../../denali/x28c256_15.soma
-- Initial contents file:       ../../denali/x28c256_15.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY x28c256_15 IS
GENERIC (
    memory_spec: string := "../../denali/x28c256_15.soma";
    init_file:   string := "../../denali/x28c256_15.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(14 downto 0);
    cebar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    webar : in    STD_LOGIC;
    io    : inout STD_LOGIC_VECTOR(7 downto 0)
);
END x28c256_15;

ARCHITECTURE behavior of x28c256_15 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "promInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
