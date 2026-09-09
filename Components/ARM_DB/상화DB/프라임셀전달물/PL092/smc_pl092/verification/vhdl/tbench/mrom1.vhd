-- Entity:                      mrom1
-- SOMA file:                   smc_pl092/verification/denali/mrom1.spc
-- Initial contents file:       smc_pl092/verification/denali/mrom1.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY mrom1 IS
GENERIC (
    memory_spec: string := "../../denali/mrom1.spc";
    init_file:   string := "../../denali/mrom1.dat"
);
PORT (
    address : in    STD_LOGIC_VECTOR(18 downto 0);
    nCS     : in    STD_LOGIC;
    nOE     : in    STD_LOGIC;
    Data    : inout STD_LOGIC_VECTOR(31 downto 0);
    nWRD    : in    STD_LOGIC
);
END mrom1;

ARCHITECTURE behavior of mrom1 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "promInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
