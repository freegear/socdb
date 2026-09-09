-- Entity:                      k4s643232c_60
-- SOMA file:                   ../../denali/k4s643232c_60.soma
-- Initial contents file:       ../../denali/k4s643232c_60.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY k4s643232c_60 IS
GENERIC (
    memory_spec: string := "../../denali/k4s643232c_60.soma";
    init_file:   string := "../../denali/k4s643232c_60.dat"
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
    ba     : in    STD_LOGIC_VECTOR(1 downto 0);
    dq     : inout STD_LOGIC_VECTOR(31 downto 0)
);
END k4s643232c_60;

ARCHITECTURE behavior of k4s643232c_60 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sdramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
