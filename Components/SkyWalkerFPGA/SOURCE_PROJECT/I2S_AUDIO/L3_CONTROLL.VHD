LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY L3_CONTROLLER IS
    PORT ( CLOCK : IN STD_LOGIC;
           nRESET : IN STD_LOGIC;
           L3_SCLK : OUT STD_LOGIC;
           L3_SDAT : INOUT STD_LOGIC;
           L3_MODE : OUT STD_LOGIC);
END L3_CONTROLLER;

ARCHITECTURE RTL OF L3_CONTROLLER IS
    CONSTANT LUT_SIZE : INTEGER := 18;
    
    SIGNAL LUT_DATA   : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
    SIGNAL SD_DATA    : STD_LOGIC_VECTOR( 15 DOWNTO 0 );
    SIGNAL SD_DATA1   : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
    SIGNAL SD_COUNTER : INTEGER RANGE 0 TO 63;
    SIGNAL SDO : STD_LOGIC;
    
    SIGNAL LUT_INDEX  : INTEGER RANGE 0 TO 31;
    
    CONSTANT STATUS_0 : INTEGER := 0;
    CONSTANT STATUS_1 : INTEGER := 1;
    CONSTANT STATUS_2 : INTEGER := 2;    
    CONSTANT DATA_0   : INTEGER := 3;
    CONSTANT DATA_1   : INTEGER := 4;
    CONSTANT DATA_2   : INTEGER := 5;
    CONSTANT DATA_3   : INTEGER := 6;
    CONSTANT DATA_4   : INTEGER := 7;
    CONSTANT DATA_5   : INTEGER := 8;
    CONSTANT DATA_6   : INTEGER := 9;
    CONSTANT DATA_7   : INTEGER := 10;
    CONSTANT DATA_8   : INTEGER := 11;
    CONSTANT DATA_9   : INTEGER := 12;
    CONSTANT DATA_10   : INTEGER := 13;
    CONSTANT DATA_11   : INTEGER := 14;
    CONSTANT DATA_12   : INTEGER := 15;
    CONSTANT DATA_13   : INTEGER := 16;
    CONSTANT DATA_14   : INTEGER := 17;
    
    
    CONSTANT Freq_CLK : INTEGER := 50000000;
    CONSTANT Freq_L3  : INTEGER := 20000;
    SIGNAL L3_DIV_CLK : INTEGER RANGE 0 TO 50000000;
    SIGNAL L3_CTRL_CLK : STD_LOGIC;
    
    SIGNAL SD_COUNTER_CTRL : STD_LOGIC;
    
    SIGNAL L3_EN : STD_LOGIC;
    SIGNAL L3_CK : STD_LOGIC;
    SIGNAL L3_DA : STd_LOGIC;
BEGIN

    PROCESS( CLOCK, nRESET )
    BEGIN
        IF (nRESET='0') THEN
            L3_CTRL_CLK <= '0';
            L3_DIV_CLK <= 0;
        ELSIF RISING_EDGE(CLOCK) THEN
            IF (L3_DIV_CLK < ( Freq_CLK/Freq_L3 )) THEN
                L3_DIV_CLK <= L3_DIV_CLK + 1;
            ELSE
                L3_DIV_CLK <= 0;
                L3_CTRL_CLK <= NOT L3_CTRL_CLK;
            END IF;
        END IF;
    END PROCESS;
	 
	 L3_SCLK <= L3_CTRL_CLK WHEN (L3_CK='0') ELSE '1';
	 L3_MODE <= L3_EN;
	 L3_SDAT <= SDO;

    PROCESS( L3_CTRL_CLK, nRESET )
    BEGIN
        IF (nRESET='0') THEN
            SD_COUNTER <= 0;
        ELSIF RISING_EDGE(L3_CTRL_CLK) THEN
            IF (SD_COUNTER_CTRL='0') THEN
                SD_COUNTER <= 0;
            ELSIF (SD_COUNTER < 63 ) THEN
                SD_COUNTER <= SD_COUNTER + 1;
            END IF;
        END IF;
    END PROCESS;

    PROCESS( L3_CTRL_CLK, nRESET )
    BEGIN
        IF (nRESET='0') THEN
            LUT_INDEX <= 0;
            SD_COUNTER_CTRL <= '0';
            L3_EN <= '1';
            L3_CK <= '1';
            SDO <= '1';
        ELSIF RISING_EDGE(L3_CTRL_CLK) THEN
            IF ( LUT_INDEX < LUT_SIZE ) THEN
                CASE SD_COUNTER IS
                    WHEN  0 => SD_COUNTER_CTRL <= '1';
                               IF (LUT_INDEX < DATA_0) THEN
                                   SD_DATA <= (X"16" & LUT_DATA);
                               ELSIF (LUT_INDEX < DATA_3 ) THEN
                                   SD_DATA <= (X"15" & LUT_DATA);
                               ELSE
                                   SD_DATA <= (X"14" & LUT_DATA);
                               END IF;
           --// ADDRESS-MODE
                    WHEN  1 => L3_EN <= '0';  
                    WHEN  2 => SDO <= SD_DATA(8);   L3_CK <= '0';
                    WHEN  3 => SDO <= SD_DATA(9);
                    WHEN  4 => SDO <= SD_DATA(10);
                    WHEN  5 => SDO <= SD_DATA(11);
                    WHEN  6 => SDO <= SD_DATA(12);
                    WHEN  7 => SDO <= SD_DATA(13);
                    WHEN  8 => SDO <= SD_DATA(14);
                    WHEN  9 => SDO <= SD_DATA(15);   L3_CK <= '1';
                    WHEN 10 => SDO <= '1';   L3_EN <= '1';
            --// DATA-MODE
                    WHEN 13 => L3_EN <= '1';
                    WHEN 14 => SDO <= SD_DATA(0);   L3_CK <= '0';
                    WHEN 15 => SDO <= SD_DATA(1);
                    WHEN 16 => SDO <= SD_DATA(2);
                    WHEN 17 => SDO <= SD_DATA(3);
                    WHEN 18 => SDO <= SD_DATA(4);
                    WHEN 19 => SDO <= SD_DATA(5);
                    WHEN 20 => SDO <= SD_DATA(6);
                    WHEN 21 => SDO <= SD_DATA(7);    L3_CK <= '1';
                    WHEN 22 => IF (LUT_INDEX > DATA_2 ) THEN
                                   SDO <= '1';    LUT_INDEX <= LUT_INDEX + 1;
                               ELSE
                                   SD_COUNTER_CTRL <= '0';
                                   SDO <= '1';    LUT_INDEX <= LUT_INDEX + 1;
                               END IF;
                    WHEN 23 => L3_EN <= '0';  SD_DATA1 <= LUT_DATA;
                    WHEN 24 => L3_EN <= '1';
                    WHEN 25 => SDO <= SD_DATA1(0); L3_CK <= '0';
                    WHEN 26 => SDO <= SD_DATA1(1);
                    WHEN 27 => SDO <= SD_DATA1(2);
                    WHEN 28 => SDO <= SD_DATA1(3);
                    WHEN 29 => SDO <= SD_DATA1(4);
                    WHEN 30 => SDO <= SD_DATA1(5);
                    WHEN 31 => SDO <= SD_DATA1(6);
                    WHEN 32 => SDO <= SD_DATA1(7);
                    WHEN 33 => SDO <= '1';
                               SD_COUNTER_CTRL <= '0';
                               LUT_INDEX <= LUT_INDEX + 1;
                    WHEN OTHERS => NULL;
                 END CASE;
				 ELSE
				     SDO <= '1';
					  L3_CK <= '1';
					  L3_EN <= '1';
					  LUT_INDEX <= 0;
             END IF;
         END IF;
     END PROCESS;

    PROCESS( LUT_INDEX )
    BEGIN
        CASE LUT_INDEX IS
        --//STATUS-MODE ADDRESS
            WHEN STATUS_0 => LUT_DATA <= X"40";
            --// X"40" STATE-MODE
            --// RESET
            WHEN STATUS_1 => LUT_DATA <= X"30";
            --// NO RESET, SYSTEM_CLOCK(NOT USED), No DC-filtering, DATA-input format(I2S-BUS)
            WHEN STATUS_2 => LUT_DATA <= X"83";
            --// GAIN OF DAC(0dB), GAIN OF ADC(0dB), Polarity of ADC(non-inverting), Polarity of DAC(non-inverting)
            --// Double Speed Setting(sigle speed playback), Power control setting(ADC:ON, DAC:ON)
        --//DATA0 ( DIRECT CONTROL )
            WHEN  DATA_0  => LUT_DATA <= X"00";
            --//Volume control : 0 [dB]
            WHEN  DATA_1  => LUT_DATA <= X"40";
            --//Bass boost( FLAT : 0 [dB], MIN : 0 [dB], MAX : 0 [dB] )
            --//Treble ( FLAT : 0 [db], MIN : 0 [dB], MAX : 0 [dB] )
            WHEN  DATA_2  => LUT_DATA <= X"C0";
            --// Peak detection position ( after tone features )
            --// De-emphasis ( no de-emphasis )
            --// Mute ( no mute )
            --// Mode filter( FLAT )
        --//DATA1 ( EXTENDED CONTROL )
        
            WHEN DATA_3 => LUT_DATA <= X"C0";
            WHEN DATA_4 => LUT_DATA <= X"E0";
            --// Mixer gain control CH1 = 0 [dB] 
            
            WHEN DATA_5 => LUT_DATA <= X"C1";
            WHEN DATA_6 => LUT_DATA <= X"E0";
            --// Mixer gate control CH2 = 0 [dB]
            
            WHEN DATA_7 => LUT_DATA <= X"C2";
            WHEN DATA_8 => LUT_DATA <= X"E5";
            --// MIC sensitivity = 0 [dB]
            --// Mixer mode = input channel 1 select( input channel 2 off )
            WHEN DATA_9 => LUT_DATA <= X"C4";
            WHEN DATA_10 => LUT_DATA <= X"E2";
            --// AGC control = disable AGC, 
            WHEN DATA_11 => LUT_DATA <= X"C5";
            WHEN DATA_12 => LUT_DATA <= X"E6";
            --//input channel 2 amplifier gain = 0 [dB]
            WHEN DATA_13 => LUT_DATA <= X"C6";
            WHEN DATA_14 => LUT_DATA <= X"E0";
            --// AGC time constant  : ATTACK TIME[ms] = 11, DECAY TIME[ns] = 100;
            --// ACG output LEVEL = -9 [dB FS]
            WHEN OTHERS => LUT_DATA <= ( OTHERS => '1' );
        END CASE;
    END PROCESS;
    
END RTL;
            
               
            