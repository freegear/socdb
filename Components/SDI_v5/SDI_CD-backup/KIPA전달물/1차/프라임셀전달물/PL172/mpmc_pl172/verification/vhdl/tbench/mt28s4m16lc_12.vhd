-- Entity:                      mt28s4m16lc_12
-- SOMA file:                   ../../denali/mt28s4m16lc-12.soma
-- Initial contents file:       ../../denali/mt28s4m16lc_12.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY mt28s4m16lc_12 IS
GENERIC (
    memory_spec: string := "../../denali/mt28s4m16lc-12.soma";
    init_file:   string := "../../denali/mt28s4m16lc_12.dat"
);
PORT (
    clk     : in    STD_LOGIC;
    cke     : in    STD_LOGIC;
    csbar   : in    STD_LOGIC;
    rasbar  : in    STD_LOGIC;
    casbar  : in    STD_LOGIC;
    webar   : in    STD_LOGIC;
    dqm     : in    STD_LOGIC_VECTOR(1 downto 0);
    address : in    STD_LOGIC_VECTOR(11 downto 0);
    data    : inout STD_LOGIC_VECTOR(15 downto 0);
    rpbar   : in    STD_LOGIC;
    ba      : in    STD_LOGIC_VECTOR(1 downto 0)
);
END mt28s4m16lc_12;

ARCHITECTURE behavior of mt28s4m16lc_12 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sflashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
