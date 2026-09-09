-- Entity:                      mt28f400b5sg_8t
-- SOMA file:                   ../../denali/mt28f400b5sg_8t.soma
-- Initial contents file:       ../../denali/mt28f400b5sg_8t.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY mt28f400b5sg_8t IS
GENERIC (
    memory_spec: string := "../../denali/mt28f400b5sg_8t.soma";
    init_file:   string := "../../denali/mt28f400b5sg_8t.dat"
);
PORT (
    a       : in    STD_LOGIC_VECTOR(17 downto 0);
    dq      : inout STD_LOGIC_VECTOR(15 downto 0);
    cebar   : in    STD_LOGIC;
    oebar   : in    STD_LOGIC;
    webar   : in    STD_LOGIC;
    wpbar   : in    STD_LOGIC;
    rpbar   : in    STD_LOGIC;
    bytebar : in    STD_LOGIC
);
END mt28f400b5sg_8t;

ARCHITECTURE behavior of mt28f400b5sg_8t is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "flashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
