-- Entity:                      sram2
-- SOMA file:                   ../../denali/sram2.spc
-- Initial contents file:       

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY km68v1002c_20 IS
GENERIC (
    memory_spec: string := "../../denali/km68v1002c_20.soma";
    init_file:   string := ""
);
PORT (
    a     : in    STD_LOGIC_VECTOR(16 downto 0);
    csbar : in    STD_LOGIC;
    webar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    io    : inout STD_LOGIC_VECTOR(7 downto 0)
);
END km68v1002c_20;

ARCHITECTURE behavior of km68v1002c_20 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
