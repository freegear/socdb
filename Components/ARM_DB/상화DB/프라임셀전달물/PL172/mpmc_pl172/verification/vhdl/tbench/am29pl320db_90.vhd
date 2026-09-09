-- Entity:                      am29pl320db_90
-- SOMA file:                   ../../denali/am29pl320db_90.soma
-- Initial contents file:       ../../am29pl320db_90.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY am29pl320db_90 IS
GENERIC (
    memory_spec: string := "../../denali/am29pl320db_90.soma";
    init_file:   string := "../../am29pl320db_90.dat"
);
PORT (
    a       : in    STD_LOGIC_VECTOR(19 downto 0);
    dq      : inout STD_LOGIC_VECTOR(31 downto 0);
    cebar   : in    STD_LOGIC;
    oebar   : in    STD_LOGIC;
    webar   : in    STD_LOGIC;
    wpbar   : in    STD_LOGIC;
    wordbar : in    STD_LOGIC;
    acc     : in    STD_LOGIC
);
END am29pl320db_90;

ARCHITECTURE behavior of am29pl320db_90 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "flashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
