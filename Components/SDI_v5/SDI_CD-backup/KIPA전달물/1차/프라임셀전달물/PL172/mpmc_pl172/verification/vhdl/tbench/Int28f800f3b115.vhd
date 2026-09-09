-- Entity:                      Int28f800f3b115
-- SOMA file:                   ../../denali/Int28f800f3b115.soma
-- Initial contents file:       Int28f800f3b115.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY Int28f800f3b115 IS
GENERIC (
    memory_spec: string := "../../denali/Int28f800f3b115.soma";
    init_file:   string := "Int28f800f3b115.dat"
);
PORT (
    a       : in    STD_LOGIC_VECTOR(18 downto 0);
    dq      : inout STD_LOGIC_VECTOR(15 downto 0);
    cebar   : in    STD_LOGIC;
    oebar   : in    STD_LOGIC;
    webar   : in    STD_LOGIC;
    wpbar   : in    STD_LOGIC;
    rstbar  : in    STD_LOGIC;
    clk     : in    STD_LOGIC;
    advbar  : in    STD_LOGIC;
    waitbar : out   STD_LOGIC
);
END Int28f800f3b115;

ARCHITECTURE behavior of Int28f800f3b115 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "flashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
