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
-- Major Functions: ETHERNET PIN CONNECTION TEST
--
-- ---------------------------------------------------------------------
--
-- Referance : 
--
-- --------------------------------------------------------------------
-- Revision History :
-- --------------------------------------------------------------------
--   Ver  :| Author            :| Mod. Date :| Changes Made:
--   V1.0 :| TAE-JIN KIM       :| 06/12/27  :| Initial Revision
-- --------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ETHERNET IS
    PORT( CLOCK : IN STD_LOGIC;
          nRESET : IN STD_LOGIC;
          
          ETH_PHY_DIO : OUT STD_LOGIC;
          ETH_PHY_DCLK : OUT STD_LOGIC;
          ETH_PHY_TXCLK : OUT STD_LOGIC;
          ETH_PHY_TXEN  : OUT STD_LOGIC;
          ETH_PHY_TXD0  : OUT STD_LOGIC;
          ETH_PHY_TXD1  : OUT STD_LOGIC;
          ETH_PHY_TXD2  : OUT STD_LOGIC;
          ETH_PHY_TXD3  : OUT STD_LOGIC;
          
          ETH_PHY_RXCLK : OUT STD_LOGIC;
          ETH_PHY_DV    : OUT STD_LOGIC;
          ETH_PHY_CRS   : OUT STD_LOGIC;
          ETH_PHY_RXERR : OUT STD_LOGIC;
          ETH_PHY_CD    : OUT STD_LOGIC;
          ETH_PHY_RXD0  : OUT STD_LOGIC;
          ETH_PHY_RXD1  : OUT STD_LOGIC;
          ETH_PHY_RXD2  : OUT STD_LOGIC;
          ETH_PHY_RXD3  : OUT STD_LOGIC;
          ETH_PHY_nRESET : OUT STD_LOGIC;
          ETH_PHY_INT : OUT STD_LOGIC);
END ETHERNET;

ARCHITECTURE RTL OF ETHERNET IS
    SIGNAL ETH_CONNEC_COUNT : STD_LOGIC_VECTOR( 19 DOWNTO 0 );
BEGIN
    PROCESS( CLOCK, nRESET )
    BEGIN
        IF (nRESET='0') THEN
            ETH_CONNEC_COUNT <= ( OTHERS => '0' );
        ELSIF RISING_EDGE(CLOCK) THEN
            ETH_CONNEC_COUNT <= ETH_CONNEC_COUNT + 1;
        END IF;
    END PROCESS;

    ETH_PHY_DIO <= ETH_CONNEC_COUNT(19);
    ETH_PHY_DCLK <= ETH_CONNEC_COUNT(18);
    ETH_PHY_TXCLK <= ETH_CONNEC_COUNT(17);
    ETH_PHY_TXEN <= ETH_CONNEC_COUNT(16);
    ETH_PHY_TXD0 <= ETH_CONNEC_COUNT(15);
    ETH_PHY_TXD1 <= ETH_CONNEC_COUNT(14);
    ETH_PHY_TXD2 <= ETH_CONNEC_COUNT(13);
    ETH_PHY_TXD3 <= ETH_CONNEC_COUNT(12);
          
    ETH_PHY_RXCLK <= ETH_CONNEC_COUNT(11);
    ETH_PHY_DV <= ETH_CONNEC_COUNT(10);
    ETH_PHY_CRS <= ETH_CONNEC_COUNT(9);
    ETH_PHY_RXERR <= ETH_CONNEC_COUNT(8);
    ETH_PHY_CD <= ETH_CONNEC_COUNT(7);
    ETH_PHY_RXD0 <= ETH_CONNEC_COUNT(6);
    ETH_PHY_RXD1 <= ETH_CONNEC_COUNT(5); 
    ETH_PHY_RXD2 <= ETH_CONNEC_COUNT(4);
    ETH_PHY_RXD3 <= ETH_CONNEC_COUNT(3);
    ETH_PHY_nRESET <= ETH_CONNEC_COUNT(1);
    ETH_PHY_INT <= ETH_CONNEC_COUNT(0);
    
END RTL;