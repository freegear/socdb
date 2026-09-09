-- Entity:                      hm5225325f_b60
-- SOMA file:                   ../../denali/hm5225325f_b60.soma
-- Initial contents file:       ../../denali/hm5225325f_b60.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY hm5225325f_b60 IS
GENERIC (
    memory_spec: string := "../../denali/hm5225325f_b60.soma";
    init_file:   string := "../../denali/hm5225325f_b60.dat"
);
PORT (
    a      : in    STD_LOGIC_VECTOR(13 downto 0);
    rasbar : in    STD_LOGIC;
    casbar : in    STD_LOGIC;
    webar  : in    STD_LOGIC;
    csbar  : in    STD_LOGIC;
    dqm    : in    STD_LOGIC_VECTOR(3 downto 0);
    clk    : in    STD_LOGIC;
    cke    : in    STD_LOGIC;
    dq     : inout STD_LOGIC_VECTOR(31 downto 0)
);
END hm5225325f_b60;

ARCHITECTURE behavior of hm5225325f_b60 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sdramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
