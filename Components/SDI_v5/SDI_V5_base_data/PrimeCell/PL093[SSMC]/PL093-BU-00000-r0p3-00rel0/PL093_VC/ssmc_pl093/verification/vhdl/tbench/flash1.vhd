-- Entity:                      flash1
-- SOMA file:                   smc_pl092/verification/denali/flash1.spc
-- Initial contents file:       smc_pl092/verification/denali/flash1.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY flash1 IS
GENERIC (
    memory_spec: string := "../../denali/flash1.spc";
    init_file:   string := "../../denali/flash1.dat"
);
PORT (
    address : in    STD_LOGIC_VECTOR(21 downto 0);
    Data    : inout STD_LOGIC_VECTOR(15 downto 0);
    nCS     : in    STD_LOGIC;
    nOE     : in    STD_LOGIC;
    nWE     : in    STD_LOGIC
);
END flash1;

ARCHITECTURE behavior of flash1 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "flashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
