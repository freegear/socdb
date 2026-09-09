-- Entity:                      sram3
-- SOMA file:                   smc_pl092/verification/denali/sram3.spc
-- Initial contents file:       smc_pl092/verification/denali/sram3.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY sram3 IS
GENERIC (
    memory_spec: string := "../../denali/sram3.spc";
    init_file:   string := "../../denali/sram3.dat"
);
PORT (
    address : in    STD_LOGIC_VECTOR(15 downto 0);
    nCS     : in    STD_LOGIC;
    nWE     : in    STD_LOGIC;
    nOE     : in    STD_LOGIC;
    nBLS    : in    STD_LOGIC_VECTOR(1 downto 0);
    Data    : inout STD_LOGIC_VECTOR(15 downto 0)
);
END sram3;

ARCHITECTURE behavior of sram3 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
