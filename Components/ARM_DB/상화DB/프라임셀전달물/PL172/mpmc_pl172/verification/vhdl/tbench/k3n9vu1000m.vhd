-- Entity:                      k3n9vu1000m
-- SOMA file:                   ../../denali/k3n9vu1000m.soma
-- Initial contents file:       ../../denali/k3n9vu1000m.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY k3n9vu1000m IS
GENERIC (
    memory_spec: string := "../../denali/k3n9vu1000m.soma";
    init_file:   string := "../../denali/k3n9vu1000m.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(22 downto 0);
    cebar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    q     : inout STD_LOGIC_VECTOR(15 downto 0);
    bhe   : in    STD_LOGIC
);
END k3n9vu1000m;

ARCHITECTURE behavior of k3n9vu1000m is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "promInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
