-- Entity:                      k6t8016c3m_70
-- SOMA file:                   ../../denali/k6t8016c3m_70.soma
-- Initial contents file:       ../../denali/k6t8016c3m_70.dat

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY k6t8016c3m_70 IS
GENERIC (
    memory_spec: string := "../../denali/k6t8016c3m_70.soma";
    init_file:   string := "../../denali/k6t8016c3m_70.dat"
);
PORT (
    a     : in    STD_LOGIC_VECTOR(18 downto 0);
    webar : in    STD_LOGIC;
    csbar : in    STD_LOGIC;
    oebar : in    STD_LOGIC;
    bbar  : in    STD_LOGIC_VECTOR(1 downto 0);
    io    : inout STD_LOGIC_VECTOR(15 downto 0)
);
END k6t8016c3m_70;

ARCHITECTURE behavior of k6t8016c3m_70 is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "sramInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
