-- Entity:                      mrom2
-- SOMA file:                   smc_pl092/verification/denali/mrom2.spc
-- Initial contents file:       smc_pl092/verification/denali/mrom2.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY mrom2 IS
GENERIC (
    memory_spec: string := "../../denali/mrom2.spc";
    init_file:   string := "../../denali/mrom2.dat"
);
PORT (
    address : in    STD_LOGIC_VECTOR(19 downto 0);
    nCS     : in    STD_LOGIC;
    nOE     : in    STD_LOGIC;
    Data    : inout STD_LOGIC_VECTOR(31 downto 0);
    nWRD    : in    STD_LOGIC
);
END mrom2;

ARCHITECTURE behavior of mrom2 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "promInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
