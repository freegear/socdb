-- Entity:                      hm5257805b_a6
-- SOMA file:                   ../../denali/hm5257805b_a6.soma
-- Initial contents file:       ../../denali/hm5257805b_a6.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY hm5257805b_a6 IS
GENERIC (
    memory_spec: string := "../../denali/hm5257805b_a6.soma";
    init_file:   string := "../../denali/hm5257805b_a6.dat"
);
PORT (
    a      : in    STD_LOGIC_VECTOR(12 downto 0);
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
END hm5257805b_a6;

ARCHITECTURE behavior of hm5257805b_a6 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sdramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
