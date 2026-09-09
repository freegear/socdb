-- Entity:                      28f6408W30B70_flash
-- SOMA file:                   /h/qureshi/armssmc/ssmc_pl093/verification/denali/28f6408W30B70_flash.spc
-- Initial contents file:       

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY S_28f6408W30B70_flash IS
GENERIC (
    memory_spec: string := "../../denali/28f6408W30B70_flash.spc";
    init_file:   string := ""
);
PORT (
    a        : in    STD_LOGIC_VECTOR(21 downto 0);
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
END S_28f6408W30B70_flash;

ARCHITECTURE behavior of S_28f6408W30B70_flash is
  attribute foreign: string;
  attribute foreign of behavior: architecture is "flashInitMTI $DENALI/denali.so"; 
BEGIN
END behavior;
