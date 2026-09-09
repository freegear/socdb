-- Entity:                      hm5212165f_75a
-- SOMA file:                   ../../denali/hm5212165f_75a.soma
-- Initial contents file:       ../../denali/hm521165f_75a.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY hm5212165f_75a IS
GENERIC (
    memory_spec: string := "../../denali/hm5212165f_75a.soma";
    init_file:   string := "../../denali/hm521165f_75a.dat"
);
PORT (
    a      : in    STD_LOGIC_VECTOR(13 downto 0);
    rasbar : in    STD_LOGIC;
    casbar : in    STD_LOGIC;
    webar  : in    STD_LOGIC;
    csbar  : in    STD_LOGIC;
    dqm    : in    STD_LOGIC_VECTOR(1 downto 0);
    clk    : in    STD_LOGIC;
    cke    : in    STD_LOGIC;
    dq     : inout STD_LOGIC_VECTOR(15 downto 0)
);
END hm5212165f_75a;

ARCHITECTURE behavior of hm5212165f_75a is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sdramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
