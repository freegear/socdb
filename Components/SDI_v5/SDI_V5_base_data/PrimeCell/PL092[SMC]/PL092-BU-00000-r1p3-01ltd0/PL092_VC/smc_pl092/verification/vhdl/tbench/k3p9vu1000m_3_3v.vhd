-- Entity:                      k3p9vu1000m_3_3v
-- SOMA file:                   ../../denali/k3p9vu1000m_3_3v.soma
-- Initial contents file:       ../../denali/k3p9vu1000m_3_3v.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY k3p9vu1000m_3_3v IS
GENERIC (
    memory_spec: string := "../../denali/k3p9vu1000m_3_3v.soma";
    init_file:   string := "../../denali/k3p9vu1000m_3_3v.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(22 downto 0);
    cebar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    q     : inout STD_LOGIC_VECTOR(15 downto 0);
    bhe   : in    STD_LOGIC
);
END k3p9vu1000m_3_3v;

ARCHITECTURE behavior of k3p9vu1000m_3_3v is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "promInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
