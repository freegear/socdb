-- Entity:                      sst37vf020_90
-- SOMA file:                   ../../denali/sst37vf020_90.soma
-- Initial contents file:       ../../denali/sst37vf020_90.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY sst37vf020_90 IS
GENERIC (
    memory_spec: string := "../../denali/sst37vf020_90.soma";
    init_file:   string := "../../denali/sst37vf020_90.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(17 downto 0);
    cebar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    dq    : inout STD_LOGIC_VECTOR(7 downto 0)
);
END sst37vf020_90;

ARCHITECTURE behavior of sst37vf020_90 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "promInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
