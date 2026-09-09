-- Entity:                      mt48lc16m8a2_75
-- SOMA file:                   ../../denali/mt48lc16m8a2_75.soma
-- Initial contents file:       ../../denali/mt48lc16m8a2_75.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY mt48lc16m8a2_75 IS
GENERIC (
    memory_spec: string := "../../denali/mt48lc16m8a2_75.soma";
    init_file:   string := "../../denali/mt48lc16m8a2_75.dat"
);
PORT (
    a      : in    STD_LOGIC_VECTOR(11 downto 0);
    rasbar : in    STD_LOGIC;
    casbar : in    STD_LOGIC;
    webar  : in    STD_LOGIC;
    csbar  : in    STD_LOGIC;
    dqm    : in    STD_LOGIC;
    clk    : in    STD_LOGIC;
    cke    : in    STD_LOGIC;
    dq     : inout STD_LOGIC_VECTOR(7 downto 0);
    ba     : in    STD_LOGIC_VECTOR(1 downto 0)
);
END mt48lc16m8a2_75;

ARCHITECTURE behavior of mt48lc16m8a2_75 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sdramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
