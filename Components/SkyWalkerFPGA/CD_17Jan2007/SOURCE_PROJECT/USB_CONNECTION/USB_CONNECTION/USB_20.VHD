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
-- Major Functions: USB2.0 PHY PIN CONNECTION TEST
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

ENTITY USB_20 IS
    PORT ( CLOCK_50 : IN STD_LOGIC;
            nRESET  : IN STD_LOGIC;
            
           USB_DATA : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
           USB_OPM  : OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );
           
           USB_LS   : OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );
           
           USB_IDDIG : OUT STD_LOGIC;
           USB_IDPULLUP : OUT STD_LOGIC;
           USB_HOSTDISC : OUT STD_LOGIC;
           USB_DMPD     : OUT STD_LOGIC;
           USB_DPPD     : OUT STD_LOGIC;
           
           USB_SESSEND  : OUT STD_LOGIC;
           USB_SESSVALID : OUT STD_LOGIC;
           
           USB_XCVR0 : OUT STD_LOGIC;
           USB_XCVR1 : OUT STD_LOGIC;
           USB_TERM  : OUT STD_LOGIC;
           
           USB_RESET : OUT STD_LOGIC;
           USB_nSUSPEND : OUT STD_LOGIC;
           
           USB_VBUSVALID : OUT STD_LOGIC;
           USB_CHRGVBUS  : OUT STD_LOGIC;
           USB_DISCHRGVBUS : OUT STD_LOGIC;
           
           USB_TXREADY : OUT STD_LOGIC;
           USB_TXVALID : OUT STD_LOGIC;
			  
			  USB_RXVALID : OUT STD_LOGIC;
			  USB_RXACTIVE : OUT STD_LOGIC;
			  USB_RXERROR : OUT STD_LOGIC;
			  
			  USB_CLKOUT : OUT STD_LOGIC);
END USB_20;

ARCHITECTURE RTL OF USB_20 IS
    SIGNAL CLK_BUFFER : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
BEGIN
    PROCESS( CLOCK_50, nRESET )
    BEGIN
        IF (nRESET='0') THEN
            CLK_BUFFER <= ( OTHERS => '0' );
        ELSIF RISING_EDGE(CLOCK_50) THEN
            CLK_BUFFER <= CLK_BUFFER + 1;
        END IF;
    END PROCESS;
    
    USB_DATA <= CLK_BUFFER;
    USB_OPM  <= CLK_BUFFER( 1 DOWNTO 0 );
           
    USB_LS   <= CLK_BUFFER( 3 DOWNTO 2 ); 
           
    USB_IDDIG <= CLK_BUFFER(4);
    USB_IDPULLUP <= CLK_BUFFER(5);
    USB_HOSTDISC <= CLK_BUFFER(6);
    USB_DMPD     <= CLK_BUFFER(7);
    USB_DPPD     <= CLK_BUFFER(0);
           
    USB_SESSEND  <= CLK_BUFFER(1);
    USB_SESSVALID <= CLK_BUFFER(2);
           
    USB_XCVR0 <= CLK_BUFFER(3);
    USB_XCVR1 <= CLK_BUFFER(4);
    USB_TERM  <= CLK_BUFFER(5);
           
    USB_RESET <= CLK_BUFFER(6);
    USB_nSUSPEND <= CLK_BUFFER(7);
           
    USB_VBUSVALID <= CLK_BUFFER(0);
    USB_CHRGVBUS  <= CLK_BUFFER(1);
    USB_DISCHRGVBUS <= CLK_BUFFER(2);
           
    USB_TXREADY <= CLK_BUFFER(3);
    USB_TXVALID <= CLK_BUFFER(4);
	 
	 USB_RXVALID <= CLK_BUFFER(3);
    USB_RXACTIVE <= CLK_BUFFER(2);
    USB_RXERROR <= CLK_BUFFER(1);
			  
    USB_CLKOUT <= CLK_BUFFER(0);
    
END RTL;
    