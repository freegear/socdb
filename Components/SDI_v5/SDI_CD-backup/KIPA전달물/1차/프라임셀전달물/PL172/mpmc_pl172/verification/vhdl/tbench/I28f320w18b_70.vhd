-- Entity:                      I28f320w18b_70
-- SOMA file:                   ../../denali/I28f320w18b_70.soma
-- Initial contents file:       ../../denali/I28f320w18b_70.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY I28f320w18b_70 IS
GENERIC (
    memory_spec: string := "../../denali/I28f320w18b_70.soma";
    init_file:   string := "../../denali/I28f320w18b_70.dat"
);
PORT (
    a        : in    STD_LOGIC_VECTOR(20 downto 0);
    dq       : inout STD_LOGIC_VECTOR(15 downto 0);
    cebar    : in    STD_LOGIC;
    oebar    : in    STD_LOGIC;
    webar    : in    STD_LOGIC;
    wpbar    : in    STD_LOGIC;
    resetbar : in    STD_LOGIC;
    clk      : in    STD_LOGIC;
    advbar   : in    STD_LOGIC;
    waitbar  : out   STD_LOGIC;
    vpp      : in    STD_LOGIC
);
END I28f320w18b_70;

ARCHITECTURE behavior of I28f320w18b_70 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "flashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
