-- Entity:                      at27lv040a_90
-- SOMA file:                   ../../denali/at27lv040a_90.soma
-- Initial contents file:       ../../at27lv040a_90.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY at27lv040a_90 IS
GENERIC (
    memory_spec: string := "../../denali/at27lv040a_90.soma";
    init_file:   string := "../../at27lv040a_90.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(18 downto 0);
    cebar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    o     : inout STD_LOGIC_VECTOR(7 downto 0)
);
END at27lv040a_90;

ARCHITECTURE behavior of at27lv040a_90 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "promInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
