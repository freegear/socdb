-- Entity:                      at27lv040a_15
-- SOMA file:                   ../../denali/at27lv040a_15.soma
-- Initial contents file:       ../../denali/at27lv040a_15.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY at27lv040a_15 IS
GENERIC (
    memory_spec: string := "../../denali/at27lv040a_15.soma";
    init_file:   string := "../../denali/at27lv040a_15.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(18 downto 0);
    cebar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    o     : inout STD_LOGIC_VECTOR(7 downto 0)
);
END at27lv040a_15;

ARCHITECTURE behavior of at27lv040a_15 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "promInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
