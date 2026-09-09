-- Entity:                      mt48lc2m32lffc_8
-- SOMA file:                   ../../denali/mt48lc2m32lffc_8.soma
-- Initial contents file:       ../../denali/mt48lc2m32lffc_8.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY mt48lc2m32lffc_8 IS
GENERIC (
    memory_spec: string := "../../denali/mt48lc2m32lffc_8.soma";
    init_file:   string := "../../denali/mt48lc2m32lffc_8.dat"
);
PORT (
    a      : in    STD_LOGIC_VECTOR(10 downto 0);
    rasbar : in    STD_LOGIC;
    casbar : in    STD_LOGIC;
    webar  : in    STD_LOGIC;
    csbar  : in    STD_LOGIC;
    dqm    : in    STD_LOGIC_VECTOR(3 downto 0);
    clk    : in    STD_LOGIC;
    cke    : in    STD_LOGIC;
    dq     : inout STD_LOGIC_VECTOR(31 downto 0);
    ba     : in    STD_LOGIC_VECTOR(1 downto 0)
);
END mt48lc2m32lffc_8;

ARCHITECTURE behavior of mt48lc2m32lffc_8 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sdramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
