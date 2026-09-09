-- Entity:                      mt28f004b5_8b_et
-- SOMA file:                   ../../denali/mt28f004b5_8b_et.soma
-- Initial contents file:       ../../denali/mt28f004b5_8b_et.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY mt28f004b5_8b_et IS
GENERIC (
    memory_spec: string := "../../denali/mt28f004b5_8b_et.soma";
    init_file:   string := "../../denali/mt28f004b5_8b_et.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(18 downto 0);
    dq    : inout STD_LOGIC_VECTOR(7 downto 0);
    cebar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    webar : in    STD_LOGIC;
    wpbar : in    STD_LOGIC;
    rpbar : in    STD_LOGIC
);
END mt28f004b5_8b_et;

ARCHITECTURE behavior of mt28f004b5_8b_et is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "flashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
