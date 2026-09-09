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
-- File-Name     : I2S_CONTROLLER.VHD
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
--  LCM_TEST -----> I2S_LCM_CONFIG -----> <I2S_CONTROLLER>
--   (TOP)
--
-----------------------------------------------------------------------
-- PS) This file is Component File of LCM_TEST.VHD
-----------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY I2S_CONTROLLER IS
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
END I2S_CONTROLLER;

ARCHITECTURE I2S OF I2S_CONTROLLER IS
---------------------------------------------------------
-- 			CODE HERE
---------------------------------------------------------
	CONSTANT CLK_Freq : INTEGER := 25000000;
	CONSTANT I2S_Freq : INTEGER := 10000;
---------------------------------------------------------
	SIGNAL mI2S_CLK_DIV : INTEGER RANGE 0 TO 65536;
	SIGNAL mI2S_CLK : STD_LOGIC;
	SIGNAL mSEN : STD_LOGIC;
	SIGNAL mSDATA : STD_LOGIC;
	SIGNAL mSCLK : STD_LOGIC;
	SIGNAL mACK : STD_LOGIC;
	SIGNAL mST : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN
	PROCESS( iCLK, iRST )
	BEGIN
		IF ( iRST = '0' ) THEN
			mI2S_CLK <= '0';
			mI2S_CLK_DIV <= 0;
		ELSIF RISING_EDGE(iCLK) THEN
			IF ( mI2S_CLK_DIV < ( CLK_FREQ / I2S_FREQ )) THEN
				mI2S_CLK_DIV <= mI2S_CLK_DIV + 1;
			ELSE
				mI2S_CLK_DIV <= 0;
				mI2S_CLK <= NOT mI2S_CLK;
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS( mI2S_CLK, iRST )
	BEGIN
		IF (iRST='0') THEN
			mSEN <= '1';
			mSCLK <= '0';
			mSDATA <= 'Z';
			mACK <= '0';
			mST <= "00000";
		ELSIF FALLING_EDGE(mI2S_CLK) THEN
			IF ( iSTR='1' ) THEN
				IF (mST < "10001") THEN
					mST <= mST + 1;
					IF ( mST="00000" ) THEN
						mSEN <= '0';
						mSCLK <= '1';
					ELSIF ( mST="01000" ) THEN
						mACK <= I2S_DATA;
					ELSIF (mST="10000") AND ( mSCLK ='1') THEN
						mSEN <= '1';
						mSCLK <= '0';
					END IF;
					
					IF ( mST < "10000" ) THEN
						CASE mST IS
							WHEN "00000"  => mSDATA <= iDATA(15);
							WHEN "00001"  => mSDATA <= iDATA(14);
							WHEN "00010"  => mSDATA <= iDATA(13);
							WHEN "00011"  => mSDATA <= iDATA(12);
							WHEN "00100"  => mSDATA <= iDATA(11);
							WHEN "00101"  => mSDATA <= iDATA(10);
							WHEN "00110"  => mSDATA <= iDATA(9);
							WHEN "00111"  => mSDATA <= iDATA(8);
							WHEN "01000"  => mSDATA <= iDATA(7);
							WHEN "01001"  => mSDATA <= iDATA(6);
							WHEN "01010" => mSDATA <= iDATA(5); 
							WHEN "01011" => mSDATA <= iDATA(4);
							WHEN "01100" => mSDATA <= iDATA(3);
							WHEN "01101" => mSDATA <= iDATA(2);
							WHEN "01110" => mSDATA <= iDATA(1);
							WHEN "01111" => mSDATA <= iDATA(0);
							WHEN OTHERS => mSDATA <= mSDATA;
						END CASE;
					END IF;	
				ELSE
					mSEN <= '1';
					mSCLK <= '0';
					mSDATA <= 'Z';
					mACK <= '0';
					mST <= ( OTHERS => '0');
				END IF;  --OPERATION RANGE(mST)
			END IF;     --iSTR LATCH-BLOCK
		END IF;			--END FF-BLOCK
	END PROCESS;
	
	oACK <= mACK;
	oRDY <= '1' WHEN (mST=17) ELSE '0';
	I2S_EN <= mSEN;
	I2S_CLK <= mSCLK AND mI2S_CLK;
	
	I2S_DATA <= 'Z' WHEN (mST=8) ELSE
	            'Z' WHEN (mST=17)ELSE
	            mSDATA ;
	            
	oCLK <= mI2S_CLK;
	
END I2S;
		    
					
	
	
	
	
			