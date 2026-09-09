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
-- Major Functions: FPGA to FPGA interface 
--
-----------------------------------------------------------------------
--
-- Referance : 
--
-- --------------------------------------------------------------------
--
-- Revision History :
-- --------------------------------------------------------------------
--   Ver  :| Author            :| Mod. Date :| Changes Made:
--   V2.0 :| TAE-JIN KIM       :| 06/12/18  :| Initial Revision
-- --------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY U51 IS
	PORT ( CLK, nRST : IN STD_LOGIC;
		    PORST : IN STD_LOGIC;
			 FPGA_CON : OUT STD_LOGIC_VECTOR( 446 DOWNTO 0 );
			 FPGA_EN  : IN STD_LOGIC);
END U51;

ARCHITECTURE BEHAVIORAL OF U51 IS
	SIGNAL FPGA_BUF : STD_LOGIC_VECTOR( 446 DOWNTO 0 );
	SIGNAL RESET : STD_LOGIC;
BEGIN
	RESET <= nRST;-- AND PORST;
	PROCESS( CLK, RESET )
	BEGIN
		IF RESET='0' THEN
			FPGA_BUF( 446 DOWNTO 1 ) <= ( OTHERS => '0' );
			FPGA_BUF(0) <= '1';
		ELSIF RISING_EDGE(CLK) THEN
			IF (FPGA_EN='1') THEN
				FPGA_BUF <= FPGA_BUF(445 DOWNTO 0 ) & '0';	
			END IF;
		END IF;
	END PROCESS;
	
	FPGA_CON <= FPGA_BUF;

END BEHAVIORAL;		