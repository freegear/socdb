-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : UartTrIntLB.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL011-REL1v3
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Trickbox to check the integration of UART in a larger chip.
--
-- --=================================================================--
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
 
-- --------------------------------------------------------------------
entity UartTrIntLB is
  port (
-- Inputs
        UARTTXD  	: in   std_logic;	-- UART Transmit line
        nSIROUT	        : in   std_logic;	-- SiR Transmit line
        nUARTOut2	: in   std_logic;	-- Modem Out2
        nUARTOut1	: in   std_logic;	-- Modem Out1
        nUARTRTS	: in   std_logic;	-- Modem RTS
        nUARTDTR	: in   std_logic;	-- Modem DTR

-- Outputs
        UARTRXD 	: out    std_logic;	-- UART Receive input
        SIRIN   	: out    std_logic;	-- SiR receive input
        nUARTCTS	: out    std_logic;	-- Modem CTS
        nUARTDCD	: out    std_logic;	-- Modem DCD
        nUARTDSR	: out    std_logic;	-- Modem DSR
        nUARTRI 	: out    std_logic	-- Modem RI
       );
end UartTrIntLB;

-- ---------------------------------------------------------------------
--
--                             UartTrIntLB
--                             ===========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
--    This module is a simple trickbox used for integrating the UART on
--  a larger chip. This trickbox gives a loopback facility for few
--  input/output signals.
--
-- ---------------------------------------------------------------------
 
-- --========================= ARCHITECTURE ==========================--
 
architecture structural of UartTrIntLB is
 
-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------
 
-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
 
-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------
 
-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------
 
begin
  
  UARTRXD      <= UARTTXD;
  SIRIN        <= nSIROUT;
  nUARTCTS     <= nUARTRTS;
  nUARTDCD     <= nUARTOut1;
  nUARTDSR     <= nUARTDTR;
  nUARTRI      <= nUARTOut2;
    
       
        	
end structural;
 
-- --============================== End ==============================--
        	
        	
