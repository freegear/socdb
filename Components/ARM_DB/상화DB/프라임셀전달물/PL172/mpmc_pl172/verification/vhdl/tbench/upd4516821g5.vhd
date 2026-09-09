-- Entity:                      upd4516821g5
-- SOMA file:                   ../../denali/upd4516821g5.soma
-- Initial contents file:       ../../denali/upd4516821g5.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY upd4516821g5 IS
GENERIC (
    memory_spec: string := "../../denali/upd4516821g5.soma";
    init_file:   string := "../../denali/upd4516821g5.dat"
);
PORT (
    a      : in    STD_LOGIC_VECTOR(11 downto 0);
    rasbar : in    STD_LOGIC;
    casbar : in    STD_LOGIC;
    webar  : in    STD_LOGIC;
    csbar  : in    STD_LOGIC;
    dqm    : in    STD_LOGIC_VECTOR(1 downto 0);
    clk    : in    STD_LOGIC;
    cke    : in    STD_LOGIC;
    dq     : inout STD_LOGIC_VECTOR(7 downto 0)
);
END upd4516821g5;

ARCHITECTURE behavior of upd4516821g5 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sdramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
