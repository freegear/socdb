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
-- Major Functions: SEGMENT_TEST
--
-- ---------------------------------------------------------------------
--
-- Revision History :
-- --------------------------------------------------------------------
--   Ver  :| Author            :| Mod. Date :| Changes Made:
--   V2.0 :| TAE-JIN KIM       :| 06/12/18  :| Initial Revision
-- --------------------------------------------------------------------
-- Project Informain
-- Project Name  : SEGMENT_TEST
-- Top-File Name : SEGMENT_TEST
-- File-Name     : SEGMENT_TEST.VHD
-----------------------------------------------------------------------
-- COMPONENT TREE
--
--  SEGMENT_TEST --+--> Freq_DIV           * Freqeuncy Division
--   (TOP)         |--> DATA_CON_SEG_DATA  * DATA-CONVERT
--
-----------------------------------------------------------------------
-- SEGMENT COUNTING TEST
-----------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY SEGMENT_TEST IS
    PORT ( CLOCK  : IN STD_LOGIC;
           nRESET : IN STD_LOGIC;

           SEG_DATA : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
           SEG_COM  : OUT STD_LOGIC_VECTOR( 0 TO 3 ));
END SEGMENT_TEST;

ARCHITECTURE RTL OF SEGMENT_TEST IS

    CONSTANT CLK_Freq : INTEGER := 25000000;
    CONSTANT SEG_Freq : INTEGER := 4;
    CONSTANT COM_Freq : INTEGER := 200;

--4BIT BINARY DATA to SEGMENT DATA(8BIT
    COMPONENT DATA_CON_SEG_DATA
        PORT ( DATA_IN : IN STD_LOGIC_VECTOR( 3 DOWNTO 0 );
               DATA_OUT : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 ));
    END COMPONENT;

    COMPONENT Freq_DIV
        GENERIC ( CLK_Freq  : INTEGER := 25000000;
                  CLK_Req : INTEGER := 200 );
        PORT ( CLK_IN : IN STD_LOGIC;
               CLK_OUT : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL SEG_0_COUNT : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
    SIGNAL SEG_1_COUNT : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
    SIGNAL SEG_2_COUNT : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
    SIGNAL SEG_3_COUNT : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
    SIGNAL SEG_1_EN,
           SEG_2_EN,
           SEG_3_EN : STD_LOGIC;

    SIGNAL COM_SIG : STD_LOGIC_VECTOR( 3 DOWNTO 0 );

    SIGNAL SEL_DATA : STD_LOGIC_VECTOR( 3 DOWNTO 0 );

    SIGNAL SEG_CLK : STD_LOGIC;
    SIGNAL COM_CLK : STD_LOGIC;

BEGIN
-- COMPONENT MAPPING ---------------------------------------------
    U0 : Freq_DIV GENERIC MAP ( CLK_Freq, SEG_Freq )
                  PORT MAP ( CLOCK, SEG_CLK );

    U1 : Freq_DIV GENERIC MAP ( CLK_Freq, COM_Freq )
                  PORT MAP ( CLOCK, COM_CLK );

    U3 : DATA_CON_SEG_DATA PORT MAP ( DATA_IN  => SEL_DATA,
                                      DATA_OUT => SEG_DATA);

    SEG_COM <= COM_SIG;
-- COUNTERS  ----------------------------------------------------
    PROCESS( SEG_CLK, nRESET )
    BEGIN
        IF ( nRESET='0' ) THEN
            SEG_0_COUNT <= ( OTHERS => '0' );
        ELSIF RISING_EDGE(SEG_CLK) THEN
            IF (SEG_0_COUNT="1001") THEN
                SEG_0_COUNT <= ( OTHERS => '0' );
            ELSE
                SEG_0_COUNT <= SEG_0_COUNT + 1;
            END IF;
        END IF;
    END PROCESS;

    SEG_1_EN <= '1' WHEN ( SEG_0_COUNT="1001" ) ELSE '0';

    PROCESS( SEG_CLK, nRESET )
    BEGIN
        IF ( nRESET='0' ) THEN
            SEG_1_COUNT <= ( OTHERS => '0' );
        ELSIF RISING_EDGE(SEG_CLK) THEN
            IF (SEG_1_EN='1') THEN
                IF (SEG_1_COUNT="1001") THEN
                    SEG_1_COUNT <= ( OTHERS => '0' );
                ELSE
                    SEG_1_COUNT <= SEG_1_COUNT + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    SEG_2_EN <= '1' WHEN ( SEG_1_COUNT="1001" ) ELSE '0';

    PROCESS( SEG_CLK, nRESET )
    BEGIN
        IF ( nRESET='0' ) THEN
            SEG_2_COUNT <= ( OTHERS => '0' );
        ELSIF RISING_EDGE(SEG_CLK) THEN
            IF ((SEG_2_EN='1')AND(SEG_1_EN='1')) THEN
                IF (SEG_2_COUNT="1001") THEN
                    SEG_2_COUNT <= ( OTHERS => '0' );
                ELSE
                    SEG_2_COUNT <= SEG_2_COUNT + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    SEG_3_EN <= '1' WHEN ( SEG_2_COUNT="1001" ) ELSE '0';
            
    PROCESS( SEG_CLK, nRESET )
    BEGIN
        IF ( nRESET='0' ) THEN
            SEG_3_COUNT <= ( OTHERS => '0' );
        ELSIF RISING_EDGE(SEG_CLK) THEN
            IF ((SEG_3_EN='1')AND(SEG_2_EN='1')AND(SEG_1_EN='1')) THEN
                IF (SEG_3_COUNT="1001") THEN
                    SEG_3_COUNT <= ( OTHERS => '0' );
                ELSE
                    SEG_3_COUNT <= SEG_3_COUNT + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
-- SEGMENT COMMON(-) SCANNING -----------------------------------------------
    PROCESS( COM_CLK, nRESET )
    BEGIN
        IF ( nRESET='0') THEN
             COM_SIG <= ( OTHERS => '0' );
        ELSIF RISING_EDGE(COM_CLK) THEN
            IF (COM_SIG="0000") THEN
                COM_SIG <= "1110";
            ELSE
                COM_SIG <= COM_SIG( 2 DOWNTO 0 ) & COM_SIG(3);
            END IF;
        END IF;
    END PROCESS;
-- DISPLAY DATA SELECT -------------------------------------------------------
    WITH COM_SIG SELECT
    SEL_DATA <= SEG_0_COUNT WHEN ("1110"),
                SEG_1_COUNT WHEN ("1101"),
                SEG_2_COUNT WHEN ("1011"),
                SEG_3_COUNT WHEN ("0111"),
                ( OTHERS => '1' ) WHEN OTHERS;
------------------------------------------------------------------------------
END RTL;


















