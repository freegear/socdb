------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : GpioTrickInteg.vhd.rca
--  File Revision          : 1.1 
--  
--  Release Information    : PrimeCell(TM)-PL061-REL1v0
--  
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Purpose : This module is the Integration test VHDL trickbox.
-- 
--           Its purpose is to check the integration of the GPIO PL061
--           in a larger chip in order to verify that all of its pins
--           are correctly connected. Integration Vectors allow the
--           user to verify that the GPIO has been wired into the
--           system correctly
--
--           The Gpio trickbox module performs the following functions:
--           - Generates the input signals for the GPIN(7:0) pins
--             of the GPIO as a XOR logical operation of the GPIO
--             output lines nGPEN(7:0) and GPOUT(7:0).
--
------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

entity GpioTrickInteg is
  port (
    -- Inputs
    nGPEN   : in   std_logic_vector(7 downto 0); -- GPIO o/p enables
    GPOUT   : in   std_logic_vector(7 downto 0); -- GPIO outputs
    -- Output
    GPIN    : out  std_logic_vector(7 downto 0)  -- GPIO inputs
    );
end GpioTrickInteg
    ;

-- ---------------------------------------------------------------------
--
--                             GpioTrickInteg
--                             ==============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
-- The external input to the GPIO is generated in this module.
-- Inputs to the GPIO are controlled via the GPIO outputs
-- nGPEN(7:0) and GPOUT(7:0).
--
--===========================ARCHITECTURE=============================--

architecture synth of GpioTrickInteg is
    
------------------------------------------------------------------------
-- Signal declarations
------------------------------------------------------------------------

------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
------------------------------------------------------------------------

begin
   
------------------------------------------------------------------------
-- The inputs to the GPIO Alt. Funct. Output are controlled via writes
-- to the GTAOUTR register
--                 ________
-- nGPEN[7:0] >---\\       \
--                || XOR    -----  
-- GPOUT[7:0] >---//_______/     |
--                               |
-- GPIN[7:0]  <------------------
--
--
-- XOR
-- --------------------------------
-- nGPEN[i]   GPOUT[i]   |  GPIN[i]
-- --------------------------------
--     0         0       |    0
--     0         1       |    1
--     1         0       |    1
--     1         1       |    0
-- --------------------------------
------------------------------------------------------------------------

GPIN  <= (nGPEN xor GPOUT);

end synth;
