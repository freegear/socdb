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
-- Major Functions: EXPANSION IO TEST
--
-- ---------------------------------------------------------------------
--
-- Referance : 
--
-- --------------------------------------------------------------------
-- Revision History :
-- --------------------------------------------------------------------
--   Ver  :| Author            :| Mod. Date :| Changes Made:
--   V1.0 :| TAE-JIN KIM       :| 06/12/27  :| Initial Revision
-- --------------------------------------------------------------------
-- 
-- PIN xx0 : division-2 of input-clock
-- PIN xx1 : division-4 of input-clock
-- PIN xx2 : division-8 of input-clock
-- PIN xx3 : division-16 of input-clock
-- PIN xx4 : division-32 of input-clock
-- PIN xx5 : division-64 of input-clock
-- PIN xx6 : division-128 of input-clock
-- PIN xx7 : division-256 of input-clock
-- PIN xx8 : division-512 of input-clock
-- PIN xx9 : division-1024 of input-clock
--
-- ---------------------------------------------------------------------



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY EXP_SOCKET IS
    PORT ( CLK : IN STD_LOGIC;
           nRST : IN STD_LOGIC;
           
           EXP_IO : OUT STD_LOGIC_VECTOR( 173 DOWNTO 0 );
			  LED    : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 ));
END EXP_SOCKET;

ARCHITECTURE RTL OF EXP_SOCKET IS
    SIGNAL EXP_CNT : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	 SIGNAL CK : STD_LOGIC;
BEGIN
    PROCESS( CLK, nRST )
	 BEGIN
	     IF (nRST='0') THEN
		      CK <= '0';
		  ELSIF RISING_EDGE(CLK) THEN
		      CK <= NOT CK;
		  END IF;
	 END PROCESS;
	 
    PROCESS( CK, nRST )
    BEGIN
        IF (nRST='0') THEN
           EXP_CNT <= ( OTHERS => '0');
        ELSIF RISING_EDGE(CK) THEN
           EXP_CNT <= EXP_CNT + 1;
        END IF;
   END PROCESS;
   
   EXP_IO( 9 DOWNTO 0 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 19 DOWNTO 10 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 29 DOWNTO 20 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 39 DOWNTO 30 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 49 DOWNTO 40 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 59 DOWNTO 50 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 69 DOWNTO 60 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 79 DOWNTO 70 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 89 DOWNTO 80 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 99 DOWNTO 90 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 109 DOWNTO 100 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 119 DOWNTO 110 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 129 DOWNTO 120 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 139 DOWNTO 130 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 149 DOWNTO 140 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 159 DOWNTO 150 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 169 DOWNTO 160 ) <= EXP_CNT(9 DOWNTO 0 );
	EXP_IO( 173 DOWNTO 170 ) <= EXP_CNT(3 DOWNTO 0 );
	
	LED <= EXP_CNT( 9 DOWNTO 6 );	
END RTL;