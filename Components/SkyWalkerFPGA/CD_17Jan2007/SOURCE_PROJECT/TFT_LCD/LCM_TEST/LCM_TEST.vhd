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
-- Major Functions: TFT-LCD TEST(LCM TEST)
--
-- --------------------------------------------------------------------
--
-- Revision History :
-- --------------------------------------------------------------------
--   Ver  :| Author            :| Mod. Date :| Changes Made:
--   V2.0 :| TAE-JIN KIM       :| 06/12/18  :| Initial Revision
-- --------------------------------------------------------------------
-- Project Informain
-- Project Name  : LCM_TEST
-- Top-File Name : LCM_TEST
-- File-Name     : LCM_TEST.VHD
-- --------------------------------------------------------------------
--                             TOP-POLY 3'6" TFT-LCD PANEL
--  -------------|                |------------------|
--               | LCD_SIGNALS    |                  |
--               |-------/------->|                  |
--      FPGA     |                |                  |
--               | I2S-BUS SIGNAL |                  |
--               |<------/------->|                  |
-- --------------|                |------------------|
--                            
-- Defual Display : At 1SEC [All Display RED/GREEN/BLUE]
--
-- USER SWITCH
-- S6 : Vertical COLOR-BAR
-- S7 : Horizontal COLOR-BAR
-- S8 : GRAY ( Display 50% )
-- S9 : WHITE ( Display 100% )
-----------------------------------------------------------------------
-- COMPONENT TREE
--
--  LCM_TEST -----> I2S_LCM_CONFIG -----> I2S_CONTROLLER
--   (TOP)
--
-----------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY LCM_TEST IS
	PORT ( CLK, nRST : IN STD_LOGIC;
		nPORST : IN STD_LOGIC;
	--DISPLAY MODE SELECT
		USER_SW  : IN STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	--TFT-LCD CONTROLL SIGNAL		
		LCD_D    : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		LCD_CLK  : OUT STD_LOGIC;
		LCD_HSYNC : OUT STD_LOGIC;
		LCD_VSYNC : OUT STD_LOGIC;
		LCD_ENAB : OUT STD_LOGIC;
		LCD_SCL : OUT STD_LOGIC;
		LCD_SDA : INOUT STD_LOGIC;
		LCD_SCEN : OUT STD_LOGIC);
END LCM_TEST;

ARCHITECTURE RTL OF LCM_TEST IS
--I2S BUF INTERFACE COMPONENT
	COMPONENT I2S_LCM_CONFIG
		PORT ( iCLK : IN STD_LOGIC;
		       iRST_N : IN STD_LOGIC;
	       
		       I2S_SCLK : OUT STD_LOGIC;
		       I2S_SDAT : INOUT STD_LOGIC;
		       I2S_SCEN : OUT STD_LOGIC);
	END COMPONENT;
--Horizontal SYNC period
	CONSTANT H_SYNC_CYC : INTEGER := 1; --3;
	CONSTANT H_SYNC_BACK : INTEGER := 151;
	CONSTANT H_SYNC_ACT : INTEGER := 960;
	CONSTANT H_SYNC_FRONT : INTEGER := 59;
	CONSTANT H_SYNC_TOTAL : INTEGER := 1171;
--Vertical SYNC period	
	CONSTANT V_SYNC_CYC : INTEGER := 1; --2;
	CONSTANT V_SYNC_BACK : INTEGER := 13;
	CONSTANT V_SYNC_ACT : INTEGER := 240;
	CONSTANT V_SYNC_FRONT : INTEGER := 8;
	CONSTANT V_SYNC_TOTAL : INTEGER := 262; 
--Horizontal SYNC & COUNTER	
	SIGNAL oVGA_H_SYNC : STD_LOGIC;
	SIGNAL H_CNT : INTEGER RANGE 0 TO 1171;
--Vertical SYNC & COUNTER	
	SIGNAL oVGA_V_SYNC : STD_LOGIC;
	SIGNAL V_CNT : INTEGER RANGE 0 TO 262;
--System Synchnouse RESET SIGNAL		
	SIGNAL RST : STD_LOGIC;
	SIGNAL OP : STD_LOGIC;
--COLOR ENABLE	
	SIGNAL RED_EN, GREEN_EN, BLUE_EN : STD_LOGIC;
--COLOR-COUNTER	
	SIGNAL MOD_3 : STD_LOGIC_VECTOR( 1 DOWNTO 0 );
--COLOR-DATA[R,G,B]
	SIGNAL Tmp_DATA : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
--COLOR-SELECT
	SIGNAL MSEL : STD_LOGIC_VECTOR( 1 DOWNTO 0 );   
	SIGNAL MSEL_T : STD_LOGIC_VECTOR( 1 DOWNTO 0 );
--COLOR-SELECT(Defualt mode)
	SIGNAL VAR_SIG : STD_LOGIC_VECTOR( 1 DOWNTO 0 );
BEGIN

RST <= nRST AND OP;
LCD_CLK <= '0' WHEN (RST='0') ELSE (NOT CLK);
LCD_HSYNC <= oVGA_H_SYNC WHEN (RST='1') ELSE '0';
LCD_VSYNC <= oVGA_V_SYNC WHEN (RST='1') ELSE '0';
LCD_ENAB <= '1';	
	
	PROCESS(CLK, nRST)
		VARIABLE CNT : INTEGER RANGE 0 TO 12500000;
	BEGIN
		IF nRST='0' THEN
			OP <= '0';
			CNT := 0;
		ELSIF RISING_EDGE(CLK) THEN
			IF CNT=12500000 THEN
				CNT := 0;
				OP <= '1';
			ELSE
				CNT := CNT + 1;
			END IF;
		END IF;
	END PROCESS;
--//////////////////////////////////////////////////////////
-- 
------------------------------------------------------------
--       ------\ /------\ /------\ /------\ /-----
-- DATA    R    X   G    X    B   X   R    X  .....
--       ------/ \------/ \------/ \------/ \-----
--
--	      |---|    |---|    |---|    |---|    |---|
-- PCLK  |   |    |   |    |   |    |   |    |   |
--     --|   |----|   |----|   |----|   |----|   |--
--
-----------------------------------------------------------
--       MSEL     MSEL     MSEL     MSEL     .....
--       [01]     [00]     [10]     [01]     .....
------------------------------------------------------------
--///////////////////////////////////////////////////////////
PROCESS( CLK, nRST )
BEGIN
	IF nRST='0' THEN
		LCD_D <= ( OTHERS => '1' );
	ELSIF RISING_EDGE(CLK) THEN
		CASE USER_SW IS
		--VERTICAL COLOR BAR
			WHEN "0001" => 	IF (MOD_3=MSEL) THEN
						LCD_D <= Tmp_DATA;
					ELSE
						LCD_D <= X"00";
					END IF;
		--HORIZONTAL COLOR BAR
			WHEN "0010" => 	IF (MOD_3=mSEL_T) THEN
										LCD_D <= Tmp_DATA;
									ELSE
										LCD_D <= X"00";
									END IF;
		--GRAY ALL DISPLAY(50%)
			WHEN "0100" =>  LCD_D <= X"7F";
		--WHITE ALL DISPLAY(100%)
			WHEN "1000" =>  LCD_D <= X"FF";
		--COLOR ALL DISPLAY
			WHEN OTHERS => IF (VAR_SIG=MOD_3) THEN
									LCD_D <= Tmp_DATA;
								ELSE
									LCD_D <= X"00";
								END IF;
		END CASE;
	END IF;
END PROCESS;

------------------------------------------
-- VARIABLE-COLOR (ALL DISPLAY)
------------------------------------------
PROCESS( CLK, nRST )
	VARIABLE CNT : INTEGER RANGE 0 TO 12500000;
BEGIN
	IF nRST='0' THEN
		CNT := 0;
		VAR_SIG <= "00";
	ELSIF RISING_EDGE(CLK) THEN
		IF CNT=12500000 THEN
			CNT := 0;
				IF (VAR_SIG="10") THEN
					VAR_SIG <= "00";
				ELSE
					VAR_SIG <= VAR_SIG + 1;
				END IF;
		ELSE
			CNT := CNT + 1;
		END IF;
	END IF;
END PROCESS;	

-----------------------------------------
-- GENERATED COLOR-BAR DATA( VERTICAL )
-----------------------------------------
MSEL <= "01" WHEN ( V_CNT < 94 ) ELSE
		  "10" WHEN (( V_CNT >=94 ) AND (V_CNT<174)) ELSE
		  "00";
PROCESS( CLK, nRST )
BEGIN
	IF ( nRST='0' ) THEN
		MOD_3 <= "00";
		Tmp_DATA <= X"00";	
	ELSIF RISING_EDGE(CLK) THEN
		IF ( H_CNT > H_SYNC_BACK ) AND ( H_CNT < (H_SYNC_TOTAL-H_SYNC_FRONT)) THEN
			IF ( MOD_3 < "10" ) THEN
				MOD_3 <= MOD_3 + 1;
			ELSE
				MOD_3 <= "00";
				Tmp_DATA <= X"FF";
			END IF;
		ELSE
			MOD_3 <= "00";
			Tmp_DATA <= X"00";
		END IF;
	END IF;
END PROCESS;	 
 
-----------------------------------------
-- GENERATED COLOR-BAR DATA( HORIZONTAL )
-----------------------------------------
PROCESS( H_CNT, V_CNT )
BEGIN
	IF (V_CNT < 47) THEN
		IF (H_CNT<390) THEN
			mSEL_T <= "00";
		ELSIF (H_CNT >=390 ) AND (H_CNT < 790) THEN
			mSEL_T <= "01";
		ELSE
			mSEL_T <= "10";
		END IF;		
	ELSIF (V_CNT >= 94) AND ( V_CNT < 141 ) THEN
		IF (H_CNT<390) THEN
			mSEL_T <= "00";
		ELSIF (H_CNT >=390 ) AND (H_CNT < 790) THEN
			mSEL_T <= "01";
		ELSE
			mSEL_T <= "10";
		END IF;
	ELSIF (V_CNT >=188 ) AND (V_CNT < 235) THEN
		IF (H_CNT<390) THEN
			mSEL_T <= "00";
		ELSIF (H_CNT >=390 ) AND (H_CNT < 790) THEN
			mSEL_T <= "01";
		ELSE
			mSEL_T <= "10";
		END IF;
	ELSIF (V_CNT >= 282) AND (V_CNT < 329) THEN
		IF (H_CNT<390) THEN
			mSEL_T <= "00";
		ELSIF (H_CNT >=390 ) AND (H_CNT < 790) THEN
			mSEL_T <= "01";
		ELSE
			mSEL_T <= "10";
		END IF;
	ELSE
		mSEL_T <= "11";
	END IF;
END PROCESS;
		
----------------------------------------
-- GENERATE V-SYNC & H-SYNC
----------------------------------------

	PROCESS( CLK, RST )
	BEGIN
		IF ( RST = '0' ) THEN
			H_CNT <= 0;
			oVGA_H_SYNC <= '0';
		ELSIF RISING_EDGE(CLK) THEN
			IF ( H_CNT < H_SYNC_TOTAL ) THEN
				H_CNT <=  H_CNT + 1;
			ELSE
				H_CNT <= 0;
			END IF;
			
			IF (H_CNT < H_SYNC_CYC ) THEN
				oVGA_H_SYNC <= '0';
			ELSE
				oVGA_H_SYNC <= '1';
			END IF;
			
		END IF;
	END PROCESS;
			

	PROCESS( CLK, RST )
	BEGIN
		IF ( RST='0' ) THEN
			V_CNT <= 0;
			oVGA_V_SYNC <= '0';
		ELSIF RISING_EDGE(CLK) THEN
			IF ( H_CNT=0 ) THEN
				IF ( V_CNT < V_SYNC_TOTAL ) THEN
					V_CNT <= V_CNT + 1;
				ELSE
					V_CNT <= 0;
				END IF;
				
				IF (V_CNT < V_SYNC_CYC) THEN
					oVGA_V_SYNC <= '0';
				ELSE
					oVGA_V_SYNC <= '1';
				END IF;
				
			END IF;
		END IF;
	END PROCESS;

--// I2S BUS INTERFACE PORT MAP  /////////////////////////////////////////	
	U1 : I2S_LCM_CONFIG PORT MAP ( CLK,	RST, LCD_SCL, LCD_SDA, LCD_SCEN );	
	
END RTL;				