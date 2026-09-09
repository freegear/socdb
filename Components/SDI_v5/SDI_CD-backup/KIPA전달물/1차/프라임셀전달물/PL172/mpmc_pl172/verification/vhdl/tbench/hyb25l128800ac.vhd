-- Entity:                      hyb25l128800ac
-- SOMA file:                   ../../denali/hyb25l128800ac.soma
-- Initial contents file:       ../../denali/hyb25l128800ac.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY hyb25l128800ac IS
GENERIC (
    memory_spec: string := "../../denali/hyb25l128800ac.soma";
    init_file:   string := "../../denali/hyb25l128800ac.dat"
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
    ba     : in    STD_LOGIC_VECTOR(1 downto 0);
    dq     : inout STD_LOGIC_VECTOR(7 downto 0)
);
END hyb25l128800ac;

ARCHITECTURE behavior of hyb25l128800ac is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sdramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
