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
-- P.S ) This file is COMPONENT-file of U60(FPGA_to_FPGA_interface)
-----------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY SEG_COUNT IS
	PORT ( CLK, nRST : IN STD_LOGIC;
	       SEG2,
	       SEG1,
	       SEG0 : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 ));
END SEG_COUNT;

 ARCHITECTURE BEHAVIORAL OF SEG_COUNT IS
	SIGNAL CNT2, CNT1, CNT0 : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL EN1, EN2, EN3 : STD_LOGIC;
BEGIN

	SEG2 <= CNT2;
	SEG1 <= CNT1;
	SEG0 <= CNT0;
	
	PROCESS( CLK, nRST)
	BEGIN
		IF nRST='0' THEN
			CNT0 <= ( OTHERS => '0' );
		ELSIF RISING_EDGE(CLK) THEN
			IF CNT0="1001" THEN
				CNT0 <= ( OTHERS => '0' );
			ELSE
				CNT0 <= CNT0 + 1;
			END IF;
		END IF;
	END PROCESS;
	
	EN1 <= '1' WHEN ( CNT0="1001" ) ELSE '0';
	
	PROCESS( CLK, nRST )
	BEGIN
		IF nRST='0' THEN
			CNT1 <= ( OTHERS => '0' );
		ELSIF RISING_EDGE(CLK) THEN
			IF EN1='1' THEN
				IF CNT1="1001" THEN
					CNT1 <= "0000";
				ELSE
					CNT1 <= CNT1 + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	EN2 <= '1' WHEN ( CNT1="1001" ) ELSE '0';
	EN3 <= EN2 AND EN1;
	
	PROCESS( CLK, nRST )
	BEGIN
		IF nRST='0' THEN
			CNT2 <= ( OTHERS => '0' );
		ELSIF RISING_EDGE(CLK) THEN
			IF EN3='1' THEN
				IF CNT2="1001" THEN
					CNT2 <= ( OTHERS => '0' );
				ELSE
					CNT2 <= CNT2 + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END BEHAVIORAL;
