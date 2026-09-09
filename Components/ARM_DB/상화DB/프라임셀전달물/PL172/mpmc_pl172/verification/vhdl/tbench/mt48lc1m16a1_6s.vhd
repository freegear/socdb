-- Entity:                      mt48lc1m16a1_6s
-- SOMA file:                   ../../denali/mt48lc1m16a1_6s.soma
-- Initial contents file:       ../../denali/mt48lc1m16a1_6s.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY mt48lc1m16a1_6s IS
GENERIC (
    memory_spec: string := "../../denali/mt48lc1m16a1_6s.soma";
    init_file:   string := "../../denali/mt48lc1m16a1_6s.dat"
);
PORT (
    a      : in    STD_LOGIC_VECTOR(10 downto 0);
    rasbar : in    STD_LOGIC;
    casbar : in    STD_LOGIC;
    webar  : in    STD_LOGIC;
    csbar  : in    STD_LOGIC;
    dqm    : in    STD_LOGIC_VECTOR(1 downto 0);
    clk    : in    STD_LOGIC;
    cke    : in    STD_LOGIC;
    dq     : inout STD_LOGIC_VECTOR(15 downto 0);
    ba     : in    STD_LOGIC
);
END mt48lc1m16a1_6s;

ARCHITECTURE behavior of mt48lc1m16a1_6s is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sdramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
