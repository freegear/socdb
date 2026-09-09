-- Entity:                      mt5c2568_12
-- SOMA file:                   ../../denali/mt5c2568-12.soma
-- Initial contents file:       ../../denali/mt5c2568_12.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY mt5c2568_12 IS
GENERIC (
    memory_spec: string := "../../denali/mt5c2568-12.soma";
    init_file:   string := "../../denali/mt5c2568_12.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(14 downto 0);
    cebar : in    STD_LOGIC;
    webar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    dq    : inout STD_LOGIC_VECTOR(7 downto 0)
);
END mt5c2568_12;

ARCHITECTURE behavior of mt5c2568_12 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
