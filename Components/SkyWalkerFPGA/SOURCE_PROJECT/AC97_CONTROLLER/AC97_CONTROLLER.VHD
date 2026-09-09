LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY AC97_CONTROLLER IS
    PORT ( CLOCK_54 : IN STD_LOGIC;
           CLOCK_50 : IN STD_LOGIC;
           
            nRESET  : IN STD_LOGIC;
            
            AC97_nRESET : OUT STD_LOGIC;
            
            AC97_DATA_O : OUT STD_LOGIC;
            AC97_DATA_I : IN STD_LOGIC;
				SW, SW1 : IN STD_LOGIC;
            
            AC97_SYNC   : OUT STD_LOGIC;
            AC97_BIT_CLK : IN STD_LOGIC);
END AC97_CONTROLLER;

ARCHITECTURE RTL OF AC97_CONTROLLER IS
--AC97 DATA-FORMAT (SLOT-STATE)
    TYPE STATE IS ( IDLE, 
                    SLOT0, SLOT1, SLOT2, SLOT3, SLOT4, SLOT5,
                    SLOT6, SLOT7, SLOT8, SLOT9, SLOT10, SLOT11, SLOT12);
    SIGNAL SLOT_STATE : STATE;
    
    SIGNAL SLOT_DATA_COUNTER : INTEGER RANGE 0 TO 20;
    SIGNAL SLOT_DATA : STD_LOGIC_VECTOR( 19 DOWNTO 0 );
	 CONSTANT SLOT_DATA1 : STD_LOGIC_VECTOR( 19 DOWNTO 0 ):=X"FFFFF";
	 
    SIGNAL AC97_CLOCK : STD_LOGIC;
BEGIN
---------------------------------------------------------------------------
    AC97_nRESET <= nRESET;
---------------------------------------------------------------------------
    PROCESS( CLOCK_54, nRESET )
	 BEGIN
	     IF (nRESET='0') THEN
		      AC97_CLOCK <= '0';
	     ELSIF RISING_EDGE(CLOCK_54) THEN
            AC97_CLOCK <= AC97_BIT_CLK;
	     END IF;
    END PROCESS;
---------------------------------------------------------------------------
    PROCESS( AC97_CLOCK, nRESET )
    BEGIN
        IF (nRESET='0') THEN
            SLOT_STATE <= IDLE;
            SLOT_DATA_COUNTER <= 0;
            AC97_DATA_O <= 'Z';
        ELSIF RISING_EDGE(AC97_CLOCK) THEN
            CASE SLOT_STATE IS
                WHEN IDLE => SLOT_STATE <= SLOT0;
                WHEN SLOT0 => IF (SLOT_DATA_COUNTER=15) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT1;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE--IF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN SLOT1 => IF (SLOT_DATA_COUNTER=19) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT2;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(19);                                      
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(18);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(17);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(16);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=15) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=16) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=17) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN SLOT2 => IF (SLOT_DATA_COUNTER=19) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT3;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(19);                                      
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(18);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(17);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(16);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=15) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=16) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=17) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN SLOT3 => IF (SLOT_DATA_COUNTER=19) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT4;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(19);                                      
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(18);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(17);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(16);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=15) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=16) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=17) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN SLOT4 => IF (SLOT_DATA_COUNTER=19) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT5;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(19);                                      
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(18);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(17);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(16);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=15) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=16) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=17) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN SLOT5 => IF (SLOT_DATA_COUNTER=19) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT6;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(19);                                      
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(18);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(17);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(16);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=15) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=16) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=17) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN SLOT6 => IF (SLOT_DATA_COUNTER=19) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT7;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(19);                                      
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(18);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(17);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(16);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=15) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=16) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=17) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN SLOT7 => IF (SLOT_DATA_COUNTER=19) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT8;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(19);                                      
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(18);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(17);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(16);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=15) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=16) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=17) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN SLOT8 => IF (SLOT_DATA_COUNTER=19) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT9;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(19);                                      
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(18);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(17);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(16);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=15) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=16) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=17) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN SLOT9 => IF (SLOT_DATA_COUNTER=19) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT10;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(19);                                      
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(18);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(17);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(16);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=15) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=16) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=17) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN SLOT10 => IF (SLOT_DATA_COUNTER=19) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT11;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(19);                                      
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(18);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(17);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(16);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=15) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=16) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=17) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN SLOT11 => IF (SLOT_DATA_COUNTER=19) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT12;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(19);                                      
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(18);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(17);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(16);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=15) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=16) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=17) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN SLOT12 => IF (SLOT_DATA_COUNTER=19) THEN
                                  SLOT_DATA_COUNTER <= 0;
                                  AC97_DATA_O <= SLOT_DATA(0);
                                  SLOT_STATE <= SLOT0;
                              ELSE                                  
                                  IF (SLOT_DATA_COUNTER=0) THEN
                                      AC97_DATA_O <= SLOT_DATA(19);                                      
                                  ELSIF (SLOT_DATA_COUNTER=1) THEN
                                      AC97_DATA_O <= SLOT_DATA(18);
                                  ELSIF (SLOT_DATA_COUNTER=2) THEN
                                      AC97_DATA_O <= SLOT_DATA(17);
                                  ELSIF (SLOT_DATA_COUNTER=3) THEN
                                      AC97_DATA_O <= SLOT_DATA(16);
                                  ELSIF (SLOT_DATA_COUNTER=4) THEN
                                      AC97_DATA_O <= SLOT_DATA(15);
                                  ELSIF (SLOT_DATA_COUNTER=5) THEN
                                      AC97_DATA_O <= SLOT_DATA(14);
                                  ELSIF (SLOT_DATA_COUNTER=6) THEN
                                      AC97_DATA_O <= SLOT_DATA(13);
                                  ELSIF (SLOT_DATA_COUNTER=7) THEN
                                      AC97_DATA_O <= SLOT_DATA(12);
                                  ELSIF (SLOT_DATA_COUNTER=8) THEN
                                      AC97_DATA_O <= SLOT_DATA(11);
                                  ELSIF (SLOT_DATA_COUNTER=9) THEN
                                      AC97_DATA_O <= SLOT_DATA(10);
                                  ELSIF (SLOT_DATA_COUNTER=10) THEN
                                      AC97_DATA_O <= SLOT_DATA(9);
                                  ELSIF (SLOT_DATA_COUNTER=11) THEN
                                      AC97_DATA_O <= SLOT_DATA(8);
                                  ELSIF (SLOT_DATA_COUNTER=12) THEN
                                      AC97_DATA_O <= SLOT_DATA(7);
                                  ELSIF (SLOT_DATA_COUNTER=13) THEN
                                      AC97_DATA_O <= SLOT_DATA(6);
                                  ELSIF (SLOT_DATA_COUNTER=14) THEN
                                      AC97_DATA_O <= SLOT_DATA(5);
                                  ELSIF (SLOT_DATA_COUNTER=15) THEN
                                      AC97_DATA_O <= SLOT_DATA(4);
                                  ELSIF (SLOT_DATA_COUNTER=16) THEN
                                      AC97_DATA_O <= SLOT_DATA(3);
                                  ELSIF (SLOT_DATA_COUNTER=17) THEN
                                      AC97_DATA_O <= SLOT_DATA(2);
                                  ELSE
                                      AC97_DATA_O <= SLOT_DATA(1);
                                  END IF;
                                      SLOT_DATA_COUNTER <= SLOT_DATA_COUNTER + 1;
                              END IF;
                WHEN OTHERS => NULL;
            END CASE;
        END IF;
    END PROCESS;
---------------------------------------------------------------------------
    PROCESS( SLOT_STATE, SLOT_DATA_COUNTER, SW1 )
    BEGIN
	     IF SW1='0' THEN
            IF ((SLOT_STATE = SLOT12) AND (SLOT_DATA_COUNTER=19)) THEN
                AC97_SYNC <= '1';
            ELSIF ((SLOT_STATE=SLOT0) AND (SLOT_DATA_COUNTER<15)) THEN
                AC97_SYNC <= '1';
            ELSE
                AC97_SYNC <= '0';
            END IF;
		  ELSE
		      AC97_SYNC <= '0';
		  END IF;
    END PROCESS;
---------------------------------------------------------------------------
    PROCESS( SLOT_STATE, nRESET, SW )
    BEGIN
        IF (nRESET='0') THEN
            SLOT_DATA <= ( OTHERS => '0' );
        ELSIF (SW='0') THEN
            CASE SLOT_STATE IS
                WHEN SLOT0  => SLOT_DATA <= X"9BF30";  --SLOT-0
                WHEN SLOT1  => SLOT_DATA <= X"00000";  --SLOT-1
                WHEN SLOT2  => SLOT_DATA <= X"FFFFF";  --SLOT-2
-- PLAY-BACK						  
                WHEN SLOT3  => SLOT_DATA <= X"04100";  --SLOT-3
                WHEN SLOT4  => SLOT_DATA <= X"0605F";  --SLOT-4
 
                WHEN SLOT5  => SLOT_DATA <= SLOT_DATA1;  --SLOT-5
                WHEN SLOT6  => SLOT_DATA <= SLOT_DATA1;  --SLOT-6
                WHEN SLOT7  => SLOT_DATA <= SLOT_DATA1;  --SLOT-7
                WHEN SLOT8  => SLOT_DATA <= SLOT_DATA1;  --SLOT-8
                WHEN SLOT9  => SLOT_DATA <= SLOT_DATA1;  --SLOT-9
                WHEN SLOT10 => SLOT_DATA <= SLOT_DATA1;  --SLOT-10
                WHEN SLOT11 => SLOT_DATA <= SLOT_DATA1;  --SLOT-11
--------------------------------------------------------------------------						  
                WHEN SLOT12 => SLOT_DATA <= X"00000";  --SLOT-12
                WHEN OTHERS => SLOT_DATA <= ( OTHERS => '0');
            END CASE;
        ELSE
            SLOT_DATA <= ( OTHERS => '0' );
        END IF;
    END PROCESS;
	 
END RTL;