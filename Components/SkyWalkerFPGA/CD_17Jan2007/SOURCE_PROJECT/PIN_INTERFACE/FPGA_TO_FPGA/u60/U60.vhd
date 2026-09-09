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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY U60 IS
	GENERIC( MAX : INTEGER := 446;
		 USER_SW_TYPE : STD_LOGIC:='1' );	
	PORT ( CLK, nRST : IN STD_LOGIC;
			PORST : IN STD_LOGIC;
			 USER_SW  : IN STD_LOGIC;
		
			 FPGA_CON : IN STD_LOGIC_VECTOR( MAX DOWNTO 0 );
			 FPGA_EN  : OUT STD_LOGIC;
		
				LED    : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 );
			 SEG_DATA : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			 SEG_COMM : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 ));
END U60;

ARCHITECTURE TOP_LEVEL OF U60 IS
	COMPONENT FPGA_INTERFACE
		GENERIC( n : INTEGER := 446;
			 USER_SW_TYPE : STD_LOGIC:='1' );
		PORT ( CLK, nRST : IN STD_LOGIC;
		--USER-CHECK SWITCH
			USER_SW : IN STD_LOGIC;
		--U51 TO U60 : INTERFACE SIGNAL	
		 FPGA_CON_IN : IN STD_LOGIC_VECTOR( n DOWNTO 0 );
		--COUNTER-SIGNAL	       
			PIN_CLK    : OUT STD_LOGIC;
			ERR_CLK    : OUT STD_LOGIC;
		--PROCESSING COMPLETE SIGNAL		
			END_SIG    : OUT STD_LOGIC;
		--MONITORING DATA
			MODE : OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );		
		--U51 LATCH-SIGNAL
			U51_EN     : OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT SEG_BLOCK
		PORT( CLK, nRST : IN STD_LOGIC;
			PIN_CLK : IN STD_LOGIC;
			CHK_CLK : IN STD_LOGIC;
			
			MODE_SIG : IN STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			CMPL_SIG : IN STD_LOGIC;		
		
			STATE_LED : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 );
			 SEG_D   : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			 SEG_C   : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 ));
	END COMPONENT;		
	
	SIGNAL PIN_CLK, CHK_CLK : STD_LOGIC;
--PROGRAM STATE SIGNAL	
	SIGNAL MODE_SIG : STD_LOGIC_VECTOR( 1 DOWNTO 0 );
--PROGRAM COMPLETE SIGNAL	
	SIGNAL COMPLETE_SIG : STD_LOGIC;
--SYNCHNOUSE RESET SIGNAL	
	SIGNAL RST : STD_LOGIC;
	
BEGIN
	RST <= nRST;-- AND PORST;
	U1 : FPGA_INTERFACE GENERIC MAP ( MAX, USER_SW_TYPE )
			    PORT MAP ( CLK, RST,
			    		USER_SW, FPGA_CON,
			    		PIN_CLK, CHK_CLK,
			    		COMPLETE_SIG, MODE_SIG, FPGA_EN );
	U2 : SEG_BLOCK PORT MAP ( CLK, RST,
				  PIN_CLK, CHK_CLK,
				  MODE_SIG, COMPLETE_SIG,
				  LED,
				  SEG_DATA,
				  SEG_COMM );
END TOP_LEVEL;
	