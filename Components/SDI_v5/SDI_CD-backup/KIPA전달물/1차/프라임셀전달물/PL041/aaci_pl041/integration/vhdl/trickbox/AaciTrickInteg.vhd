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
-- File Name              : AaciTrickInteg.vhd.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Trickbox to check the integration of AACI in a larger chip.
--
-- --=================================================================--
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
 
-- --------------------------------------------------------------------
entity AaciTrickInteg is
  port (
-- Inputs
        AACISDATAOUT     : in    std_logic; -- AACI Serial data o/p
        AACIRESET        : in    std_logic; -- AACIRESET o/p port
        AACISYNC         : in    std_logic; -- AACISYNC o/p port

-- Outputs
        AACIBITCLK       : out   std_logic; -- AACI Serial clock input
        AACISDATAIN      : out   std_logic  -- AACI Serial data input
       );
end AaciTrickInteg;
 
-- ---------------------------------------------------------------------
--
--                             AaciTrickInteg
--                             ==============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
--    This module is a simple trickbox used for integrating the AACI on
--  a larger chip. This trickbox gives a loopback facility for primary
--  input/output signals.
--
-- ---------------------------------------------------------------------
 
-- --========================= ARCHITECTURE ==========================--
 
architecture behavioural of AaciTrickInteg is
 
-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------
 
-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal iBITCLK          : std_logic := '0';
-- Internal BITCLK

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
 
AACIBITCLK       <= iBITCLK; 
AACISDATAIN      <= AACISDATAOUT or AACIRESET or AACISYNC; 

-- ---------------------------------------------------------------------
-- BITCLK generation
-- ---------------------------------------------------------------------
p_BITCLKGenSeq: process (iBITCLK)
begin
  if (iBITCLK = '1') then
    iBITCLK <= '0' after 40 ns;
  else
    iBITCLK <= '1' after 40 ns;
  end if;
end process p_BITCLKGenSeq;

end behavioural;
 
-- --============================== End ==============================--
