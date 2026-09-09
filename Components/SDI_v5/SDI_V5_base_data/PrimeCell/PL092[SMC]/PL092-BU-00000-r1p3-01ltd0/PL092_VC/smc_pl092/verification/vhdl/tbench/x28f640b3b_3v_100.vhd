-- Entity:                      flash1
-- SOMA file:                   ../../denali/flash1.spc
-- Initial contents file:       

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY x28f640b3b_3v_100 IS
GENERIC (
    memory_spec: string := "../../denali/x28f640b3b_3v_100.soma";
    init_file:   string := "../../denali/x28f640b3b_3v_100.dat"
);
PORT (
    address : in    STD_LOGIC_VECTOR(21 downto 0);
    data    : inout STD_LOGIC_VECTOR(15 downto 0);
    cebar   : in    STD_LOGIC;
    oebar   : in    STD_LOGIC;
    webar   : in    STD_LOGIC;
    wpbar   : in    STD_LOGIC;
    rpbar   : in    STD_LOGIC
);
END x28f640b3b_3v_100;

ARCHITECTURE behavior of x28f640b3b_3v_100 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "flashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
