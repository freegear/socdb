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
-- Major Functions: VIDEO ENCODER
--                 (GENERATE COMPOSITE SYNC) * HD & S-VHS & RCA PORT
--
-- ---------------------------------------------------------------------
--
-- Referance : 
--
-- --------------------------------------------------------------------
-- Revision History :
-- --------------------------------------------------------------------
--   Ver  :| Author            :| Mod. Date :| Changes Made:
--   V3.0 :| TAE-JIN KIM       :| 06/12/26  :| Initial Revision
-- --------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ENCODER IS
    PORT ( CLK_25 : IN STD_LOGIC;
	        nRST   : IN STD_LOGIC;
			  
--//////////////////////////////////////////////////
--// HD VIDEO
            HD_OUT_B  : OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				HD_OUT_G  : OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				HD_OUT_R  : OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				
				HD_OUT_SYNC : OUT STD_LOGIC;
				HD_OUT_BLANK : OUT STD_LOGIC;
				
				HD_OUT_CLOCK : OUT STD_LOGIC;
--//COMPOSITE & S-VIDEO
            LCD_R : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
            LCD_G : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
            LCD_B : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				LCD_SPARE : OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
				
				LCD_CLK : OUT STD_LOGIC;
				VID_OUT_BLANK : OUT STD_LOGIC;
				VID_OUT_SYNC : OUT STD_LOGIC);
END ENCODER;

ARCHITECTURE RTL OF ENCODER IS
--DEVICE CONTROLL SIGNAL
    SIGNAL nBLANK : STD_LOGIC;
	 SIGNAL nSYNC  : STD_LOGIC;
--SYNC-COUNT
    SIGNAL VCNT : INTEGER RANGE 0 TO 263;
	 SIGNAL HCNT : INTEGER RANGE 0 TO 350;
--SYNC_CLOCK
    SIGNAL SCLK : STD_LOGIC;
--SYNC-SIGNAL
    SIGNAL COM_SYNC : STD_LOGIC;

BEGIN
    VID_OUT_SYNC <= '1';
	 VID_OUT_BLANK <= '1';
	 LCD_CLK <= NOT SCLK;
	 
	 HD_OUT_SYNC <= nSYNC;
	 HD_OUT_BLANK <= nBLANK;
	 HD_OUT_CLOCK <= NOT SCLK;

--<HD>
	 HD_OUT_R <= ( OTHERS => '1' );
	 HD_OUT_G <= ( OTHERS => '1' );
	 HD_OUT_B <= ( OTHERS => '1' );

--//////////////////////////////////////////////	 
--<COMPOSITE>
 --RED	 
	 LCD_R <= ( OTHERS => '1' );
	 LCD_SPARE( 1 DOWNTO 0 ) <= ( OTHERS => '1' );
 --GREEN
	 LCD_G <= ( OTHERS => '1' );
	 LCD_SPARE( 3 DOWNTO 2 ) <= ( OTHERS => '1' );
 --BLUE
	 LCD_B <= ( OTHERS => '1' );
	 LCD_SPARE( 5 DOWNTO 4 ) <= ( OTHERS => '1' );
--//////////////////////////////////////////////	 

    PROCESS( CLK_25, nRST )
	     VARIABLE CNT : STD_LOGIC;
	 BEGIN
	     IF (nRST='0') THEN
		      CNT := '0';
				SCLK <= '0';
		  ELSIF RISING_EDGE(CLK_25) THEN
		      IF CNT='1' THEN
				    CNT := '0';
					 SCLK <= NOT SCLK;
				ELSE
				    CNT := '1';
			   END IF;
		  END IF;
	END PROCESS;
	
    PROCESS( SCLK, nRST )
    BEGIN	
        IF (nRST='0') THEN
            HCNT <= 0;
        ELSIF RISING_EDGE(SCLK) THEN
            IF (HCNT < 350) THEN
				    HCNT <= HCNT + 1;
				ELSE
				    HCNT <= 0;
				END IF;
			END IF;
		END PROCESS;
		
		PROCESS( SCLK, nRST )
		BEGIN
		    IF (nRST='0') THEN
              VCNT <= 0;
          ELSIF RISING_EDGE(SCLK) THEN
              IF (VCNT < 263) THEN
				      VCNT <= VCNT + 1;
				  ELSE
				      VCNT <= 0;
				  END IF;
			  END IF;
		END PROCESS;
		
      PROCESS( HCNT, VCNT )
		BEGIN
		    IF ((VCNT=0)OR(VCNT=1)OR(VCNT=2)OR
			    (VCNT=6)OR(VCNT=7)OR(VCNT=8)) THEN
				     IF ((HCNT<16) OR ((HCNT>175) AND (HCNT<191))) THEN
					      COM_SYNC <= '0';
					  ELSE
					      COM_SYNC <= '1';
					  END IF;
			 ELSIF ((VCNT>=3) AND (VCNT<=5)) THEN
			       IF ((HCNT<25) OR ((HCNT>175) AND (HCNT<201))) THEN
					     COM_SYNC <= '1';
					 ELSE
					     COM_SYNC <= '0';
					 END IF;
			 ELSE
			      IF (HCNT<25) THEN
					    COM_SYNC <= '0';
					ELSE
					    COM_SYNC <= '1';
					END IF;
			END IF;
		END PROCESS;

      
		nSYNC <= COM_SYNC;
		
		nBLANK <= '0' WHEN (VCNT < 21) ELSE
		          '0' WHEN (HCNT < 50 ) OR ( HCNT > 342 ) ELSE
					 '1';
END RTL;
		