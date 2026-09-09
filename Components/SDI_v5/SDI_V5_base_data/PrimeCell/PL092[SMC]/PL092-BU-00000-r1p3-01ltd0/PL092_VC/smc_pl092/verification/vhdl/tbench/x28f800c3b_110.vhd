-- Entity:                      flash2
-- SOMA file:                   ../../denali/flash2.spc
-- Initial contents file:       

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY x28f800c3b_110 IS
GENERIC (
    memory_spec: string := "../../denali/x28f800c3b_110.soma";
    init_file:   string := "../../denali/x28f800c3b_110.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(18 downto 0);
    dq    : inout STD_LOGIC_VECTOR(15 downto 0);
    cebar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    webar : in    STD_LOGIC;
    wpbar : in    STD_LOGIC;
    rpbar : in    STD_LOGIC
);
END x28f800c3b_110;

ARCHITECTURE behavior of x28f800c3b_110 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "flashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
