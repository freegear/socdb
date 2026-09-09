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
-- File-Name     : I2S_LCM_CONFIG.VHD
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
-----------------------------------------------------------------------
-- COMPONENT TREE
--
--  LCM_TEST -----> <I2S_LCM_CONFIG> -----> I2S_CONTROLLER
--   (TOP)
--
-----------------------------------------------------------------------
-- PS) This file is Component File of LCM_TEST.VHD
-----------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY I2S_LCM_CONFIG IS
	PORT ( iCLK : IN STD_LOGIC;
	       iRST_N : IN STD_LOGIC;
	       
	       I2S_SCLK : OUT STD_LOGIC;
	       I2S_SDAT : INOUT STD_LOGIC;
	       I2S_SCEN : OUT STD_LOGIC);
END I2S_LCM_CONFIG;

ARCHITECTURE I2S OF I2S_LCM_CONFIG IS
	COMPONENT I2S_CONTROLLER
		PORT ( iCLK : IN STD_LOGIC;
		       iRST : IN STD_LOGIC;
		       iDATA : IN STD_LOGIC_VECTOR( 15 DOWNTO 0 );
		       iSTR : IN STD_LOGIC;
		       oACK : OUT STD_LOGIC;
		       oRDY : OUT STD_LOGIC;
		       oCLK : OUT STD_LOGIC;
		       I2S_EN : OUT STD_LOGIC;
		       I2S_DATA : INOUT STD_LOGIC;
		       I2S_CLK : OUT STD_LOGIC);
	END COMPONENT;
	
	SIGNAL mI2S_RDY : STD_LOGIC;
	SIGNAL mI2S_ACK : STD_LOGIC;
	SIGNAL mI2S_CLK : STD_LOGIC;
	SIGNAL mI2S_DATA : STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL LUT_DATA : STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL LUT_INDEX : STD_LOGIC_VECTOR( 5 DOWNTO 0 );--INTEGER RANGE 0 TO 63;
	SIGNAL mSetup_ST : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL mI2S_STR : STD_LOGIC;
	CONSTANT LUT_SIZE : INTEGER := 8;
BEGIN
	U1 : I2S_CONTROLLER PORT MAP ( iCLK, iRST_N, 
				       mI2S_DATA,
				       mI2S_STR,
				       mI2S_ACK,
				       mI2S_RDY,
				       mI2S_CLK,
				       I2S_SCEN,
				       I2S_SDAT,
				       I2S_SCLK);
						 
						 
	PROCESS( mI2S_CLK, iRST_N )
	BEGIN
		IF iRST_N='0' THEN
			LUT_INDEX <= ( OTHERS => '0' );
			mSetup_ST <= ( OTHERS => '0' );
			mI2S_STR <= '0';
		ELSIF RISING_EDGE(mI2S_CLK) THEN
			IF (LUT_INDEX < LUT_SIZE ) THEN
				CASE  mSetup_ST IS
					WHEN "0000" => mI2S_DATA <= LUT_DATA;
										mI2S_STR <= '1';
										mSetup_ST <= "0001";
					WHEN "0001" => IF (mI2S_RDY='1') THEN
											IF (mI2S_ACK='1') THEN
												mSetup_ST <= "0010";
											ELSE
												mSetup_ST <= "0000";
												mI2S_STR <= '0';
											END IF;
										END IF;
					WHEN "0010" => LUT_INDEX <= LUT_INDEX + 1;
										mSetup_ST <= "0000";
					WHEN OTHERS => LUT_INDEX <= LUT_INDEX;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	
	WITH LUT_INDEX SELECT
		LUT_DATA <= "000010" & "00" & "00000010" WHEN "000000",
						"000011" & "00" & "00000001" WHEN "000001",
						"000100" & "00" & "00111111" WHEN "000010",
						"001001" & "00" & "00100000" WHEN "000011",
						"010000" & "00" & "00111111" WHEN "000100",
						"010001" & "00" & "00111111" WHEN "000101",
						"010010" & "00" & "00101111" WHEN "000110",
						"010011" & "00" & "00101111" WHEN "000111",
						( OTHERS => '0' ) WHEN OTHERS;
END I2S;
		
		
					