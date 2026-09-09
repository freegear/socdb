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
-- Major Functions: U60(LED-TEST)
--
-- ---------------------------------------------------------------------
--
-- Revision History :
-- --------------------------------------------------------------------
--   Ver  :| Author            :| Mod. Date :| Changes Made:
--   V1.0 :| TAE-JIN KIM       :| 06/12/18  :| Initial Revision
-- --------------------------------------------------------------------
-- Project Informain
-- Project Name  : U60
-- SUB-PROJECT   : U60
-- Top-File Name : U60
-- File-Name     : U60.VHD
-------------------------------------------------------------------------
-- Sequence
--
--            LED[3]    LED[2]    LED[1]    LED[0]
--  1'CLK     LED_OFF   LED_OFF   LED_OFF   LED_ON
--  2'CLK     LED_OFF   LED_OFF   LED_ON    LED_OFF
--  3'CLK     LED_OFF   LED_ON    LED_OFF   LED_OFF
--  4'CLK     LED_ON    LED_OFF   LED_OFF   LED_OFF
--  5'CLK     LED_OFF   LED_ON    LED_OFF   LED_OFF
--  6'CLK     LED_OFF   LED_OFF   LED_ON    LED_OFF
--  7'CLK     LED_OFF   LED_OFF   LED_OFF   LED_ON
--  RESET     LED_OFF   LED_OFF   LED_OFF   LED_OFF
--  
-------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity U60 is
    Generic ( LED_SPEED_Freq : INTEGER := 16;
	           CLK_Freq        : INTEGER := 25000000);
    Port ( CLOCK : in  STD_LOGIC;
           nRESET : in  STD_LOGIC;
           LED : out  STD_LOGIC_VECTOR (3 downto 0));
end U60;

architecture Behavioral of U60 is
    
    CONSTANT COUNT_SIZE : INTEGER := LED_SPEED_Freq * 2;
	 SIGNAL CLK_DIV_COUNT : INTEGER RANGE 0 TO CLK_Freq;
	 SIGNAL DIV_CTRL_CLK  : STD_LOGIC;
	 
	 SIGNAL LED_BUFFER : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	 
	 SIGNAL LED_MODE_DELAY : INTEGER RANGE 0 TO 21;
	 SIGNAL LED_MODE       : STD_LOGIC;
	 SIGNAL DELAY          : INTEGER RANGE 0 TO 5;
begin

    LED <= LED_BUFFER;

--OPERATING SPEED SETTING
    PROCESS( CLOCK, nRESET )
	 BEGIN
	     IF (nRESET='0') THEN
		      CLK_DIV_COUNT <= 0;
				DIV_CTRL_CLK <= '0';
		  ELSIF RISING_EDGE(CLOCK) THEN
		      IF (CLK_DIV_COUNT < (CLK_Freq/COUNT_SIZE)) THEN
				    CLK_DIV_COUNT <= CLK_DIV_COUNT + 1;
			   ELSE
				    CLK_DIV_COUNT <= 0;
					 DIV_CTRL_CLK <= NOT DIV_CTRL_CLK;
			   END IF;
		  END IF;
	 END PROCESS;
--OPERATION SETTING
    PROCESS( DIV_CTRL_CLK, nRESET )
	     VARIABLE LED_MODE_COUNT : INTEGER RANGE 0 TO 7;

	 BEGIN
	     IF (nRESET='0') THEN
		      LED_MODE_COUNT := 0;
				LED_BUFFER <= "1111";
				LED_MODE_DELAY <= 0;
				DELAY <= 0;
		  ELSIF RISING_EDGE(DIV_CTRL_CLK) THEN
		      IF (LED_MODE_DELAY < 20) THEN
    		       IF (LED_MODE='0') THEN
		              CASE LED_MODE_COUNT IS
                        WHEN 1 => LED_MODE_COUNT := 2;
                                  LED_BUFFER <= "1110";
                        WHEN 2 => LED_MODE_COUNT := 3;
                                  LED_BUFFER <= "1101";
                        WHEN 3 => LED_MODE_COUNT := 4;
                                  LED_BUFFER <= "1011";
                        WHEN 4 => LED_MODE_COUNT := 5;
                                  LED_BUFFER <= "0111";
                        WHEN 5 => LED_MODE_COUNT := 6;
                                  LED_BUFFER <= "1011";
                        WHEN 6 => LED_MODE_COUNT := 1;
                                  LED_BUFFER <= "1101";
							    			 LED_MODE_DELAY <= LED_MODE_DELAY + 1;
                        WHEN OTHERS => LED_MODE_COUNT := 1;
                                       LED_BUFFER <= "1111";
			           END CASE;
				    ELSE
					     IF (DELAY=5) THEN
    						   DELAY <= 0;
				            CASE LED_MODE_COUNT IS
                            WHEN 1 => LED_MODE_COUNT := 2;
                                      LED_BUFFER <= "1110";
                            WHEN 2 => LED_MODE_COUNT := 3;
                                      LED_BUFFER <= "1101";
                            WHEN 3 => LED_MODE_COUNT := 4;
                                      LED_BUFFER <= "1011";
                            WHEN 4 => LED_MODE_COUNT := 5;
                                      LED_BUFFER <= "0111";
                            WHEN 5 => LED_MODE_COUNT := 6;
                                      LED_BUFFER <= "1011";
                            WHEN 6 => LED_MODE_COUNT := 1;
                                      LED_BUFFER <= "1101";
      			    						  LED_MODE_DELAY <= LED_MODE_DELAY + 1;
                            WHEN OTHERS => LED_MODE_COUNT := 1;
                                       LED_BUFFER <= "1111";
			               END CASE;
								
						  ELSE
						      DELAY <= DELAY + 1;
                    END IF;
				    END IF;
		      ELSE
		          LED_MODE_DELAY <= 0;
            END IF;
		  END IF;
    END PROCESS;
	 
	 LED_MODE <= '0' WHEN (LED_MODE_DELAY <10 ) ELSE '1';
	 
	 
end Behavioral;