-- Entity:                      sram4
-- SOMA file:                   smc_pl092/verification/denali/sram4.spc
-- Initial contents file:       smc_pl092/verification/denali/sram4.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY sram4 IS
GENERIC (
    memory_spec: string := "../../denali/sram4.spc";
    init_file:   string := "../../denali/sram4.dat"
);
PORT (
    address : in    STD_LOGIC_VECTOR(16 downto 0);
    nCS     : in    STD_LOGIC;
    nWE     : in    STD_LOGIC;
    nOE     : in    STD_LOGIC;
    Data    : inout STD_LOGIC_VECTOR(7 downto 0)
);
END sram4;

ARCHITECTURE behavior of sram4 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
