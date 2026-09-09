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
-- Major Functions: Freq_DIV
--
-- ---------------------------------------------------------------------
--
-- Revision History :
-- --------------------------------------------------------------------
--   Ver  :| Author            :| Mod. Date :| Changes Made:
--   V1.0 :| TAE-JIN KIM       :| 06/12/18  :| Initial Revision
-- --------------------------------------------------------------------
-- Project Informain
-- Project Name  : <COMPONENT>
-- Top-File Name : <COMPONENT>
-- File-Name     : Freq_DIV.VHD
-----------------------------------------------------------------------
-- Frequency Division File
-----------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Freq_DIV IS
        GENERIC ( CLK_Freq  : INTEGER := 25000000;
                  CLK_Req : INTEGER := 200 );
        PORT ( CLK_IN : IN STD_LOGIC;
               CLK_OUT : OUT STD_LOGIC);
END Freq_DIV;

-----------------------------------------------------------------------
--
--                  CLOCK_in(input)
--   --------------------------------------------  = <COUNTER VALUE>
--     CLOCK_out(output) X 2 (LOW & HIGH period)
--
-- * COUNTER VALUE IS MAXIMUM-RAGE OF DIV-COUNTER
-----------------------------------------------------------------------


ARCHITECTURE RTL OF Freq_DIV IS
    CONSTANT CLK_DIV : INTEGER := (CLK_Req*2);

    SIGNAL CLK_DIV_CNT : INTEGER RANGE 0 TO CLK_Freq;
    SIGNAL DIV_CTRL_CLK : STD_LOGIC;
BEGIN
    PROCESS( CLK_IN )
    BEGIN
        IF RISING_EDGE(CLK_IN) THEN
            IF (CLK_DIV_CNT < (CLK_Freq/CLK_DIV)) THEN
                CLK_DIV_CNT <= CLK_DIV_CNT + 1;
            ELSE
                CLK_DIV_CNT <= 0;
                DIV_CTRL_CLK <= NOT DIV_CTRL_CLK;
            END IF;
        END IF;
    END PROCESS;
    
    CLK_OUT <= DIV_CTRL_CLK;

END RTL;

            