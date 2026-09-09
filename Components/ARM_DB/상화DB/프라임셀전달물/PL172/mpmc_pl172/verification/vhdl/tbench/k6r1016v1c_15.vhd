-- Entity:                      k6r1016v1c_15
-- SOMA file:                   ../../denali/k6r1016v1c_15.soma
-- Initial contents file:       ../../denali/k6r1016v1c_15.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY k6r1016v1c_15 IS
GENERIC (
    memory_spec: string := "../../denali/k6r1016v1c_15.soma";
    init_file:   string := "../../denali/k6r1016v1c_15.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(15 downto 0);
    webar : in    STD_LOGIC;
    csbar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    bebar : in    STD_LOGIC_VECTOR(1 downto 0);
    io    : inout STD_LOGIC_VECTOR(15 downto 0)
);
END k6r1016v1c_15;

ARCHITECTURE behavior of k6r1016v1c_15 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
