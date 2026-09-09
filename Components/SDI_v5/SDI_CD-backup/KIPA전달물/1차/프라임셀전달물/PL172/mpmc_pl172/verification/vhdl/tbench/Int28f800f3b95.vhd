-- Entity:                      Int28f800f3b95
-- SOMA file:                   ../../denali/Int28f800f3b95.soma
-- Initial contents file:       ../../denali/Int28f800f3b95.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY Int28f800f3b95 IS
GENERIC (
    memory_spec: string := "../../denali/Int28f800f3b95.soma";
    init_file:   string := "../../denali/Int28f800f3b95.dat"
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
END Int28f800f3b95;

ARCHITECTURE behavior of Int28f800f3b95 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "flashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
