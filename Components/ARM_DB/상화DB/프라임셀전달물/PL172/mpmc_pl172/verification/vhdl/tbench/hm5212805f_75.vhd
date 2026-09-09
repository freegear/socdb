-- Entity:                      hm5212805f_75
-- SOMA file:                   ../../denali/hm5212805f_75.soma
-- Initial contents file:       ../../denali/hm5212805f_75.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY hm5212805f_75 IS
GENERIC (
    memory_spec: string := "../../denali/hm5212805f_75.soma";
    init_file:   string := "../../denali/hm5212805f_75.dat"
);
PORT (
    a      : in    STD_LOGIC_VECTOR(13 downto 0);
    rasbar : in    STD_LOGIC;
    casbar : in    STD_LOGIC;
    webar  : in    STD_LOGIC;
    csbar  : in    STD_LOGIC;
    dqm    : in    STD_LOGIC;
    clk    : in    STD_LOGIC;
    cke    : in    STD_LOGIC;
    dq     : inout STD_LOGIC_VECTOR(7 downto 0)
);
END hm5212805f_75;

ARCHITECTURE behavior of hm5212805f_75 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sdramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
