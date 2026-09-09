-- Entity:                      k4s561632a_75
-- SOMA file:                   ../../denali/k4s561632a_75.soma
-- Initial contents file:       ../../denali/k4s561632a_75.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY k4s561632a_75 IS
GENERIC (
    memory_spec: string := "../../denali/k4s561632a_75.soma";
    init_file:   string := "../../denali/k4s561632a_75.dat"
);
PORT (
    a      : in    STD_LOGIC_VECTOR(12 downto 0);
    rasbar : in    STD_LOGIC;
    casbar : in    STD_LOGIC;
    webar  : in    STD_LOGIC;
    csbar  : in    STD_LOGIC;
    dqm    : in    STD_LOGIC_VECTOR(1 downto 0);
    clk    : in    STD_LOGIC;
    cke    : in    STD_LOGIC;
    dq     : inout STD_LOGIC_VECTOR(15 downto 0);
    ba     : in    STD_LOGIC_VECTOR(1 downto 0)
);
END k4s561632a_75;

ARCHITECTURE behavior of k4s561632a_75 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sdramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
