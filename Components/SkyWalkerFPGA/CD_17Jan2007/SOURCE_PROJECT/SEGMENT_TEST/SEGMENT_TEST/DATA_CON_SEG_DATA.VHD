-- --------------------------------------------------------------------
-- Copyright (c) 2006 by You-Will Inc. 
-- --------------------------------------------------------------------
--           
--                     You-Will Inc
--                     978-8, Yeongtong-Dong, Yeongtong-Gu
--                     Suwon-City, Gyeonggi-Do, 443-812 Korea
--                     email: niosii@you-will.co.kr
--
-- --------------------------------------------------------------------
--
-- Major Functions: SEGMENT_TEST
--
-- ---------------------------------------------------------------------
--
-- Revision History :
-- --------------------------------------------------------------------
--   Ver  :| Author            :| Mod. Date :| Changes Made:
--   V1.0 :| TAE-JIN KIM       :| 06/12/18  :| Initial Revision
-- --------------------------------------------------------------------
-- Project Informain
-- Project Name  : SEGMENT_TEST
-- Top-File Name : SEGMENT_TEST
-- File-Name     : DATA_CON_SEG_DATA.VHD
-----------------------------------------------------------------------
-- CONVERTING 4BIT BINARY-DATA to 8BIT SEGMENT-DATA
-----------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY DATA_CON_SEG_DATA IS
    PORT ( DATA_IN : IN STD_LOGIC_VECTOR( 3 DOWNTO 0 );
           DATA_OUT : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 ));
END DATA_CON_SEG_DATA;

ARCHITECTURE RTL OF DATA_CON_SEG_DATA IS
    CONSTANT SEG0 : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"3F";
    CONSTANT SEG1 : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"06";
    CONSTANT SEG2 : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"5B";
    CONSTANT SEG3 : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"4F";
    CONSTANT SEG4 : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"66";
    CONSTANT SEG5 : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"6D";
    CONSTANT SEG6 : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"7D";
    CONSTANT SEG7 : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"07";
    CONSTANT SEG8 : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"7F";
    CONSTANT SEG9 : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"67";
    CONSTANT SEG_OFF : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"00";
BEGIN

    WITH DATA_IN SELECT
    DATA_OUT <= SEG0 WHEN ("0000"),
                SEG1 WHEN ("0001"),
                SEG2 WHEN ("0010"),
                SEG3 WHEN ("0011"),
                SEG4 WHEN ("0100"),
                SEG5 WHEN ("0101"),
                SEG6 WHEN ("0110"),
                SEG7 WHEN ("0111"),
                SEG8 WHEN ("1000"),
                SEG9 WHEN ("1001"),
                SEG_OFF WHEN OTHERS;

END RTL;