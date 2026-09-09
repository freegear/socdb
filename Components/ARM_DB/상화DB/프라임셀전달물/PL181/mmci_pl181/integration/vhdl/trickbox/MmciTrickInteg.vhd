-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MmciTrickInteg.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Trickbox to check the integration of MMCI in a larger chip.
--
-- --=================================================================--
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
 
-- ----------------------------------------------------------------------------
entity MmciTrickInteg is
  port (
-- Inputs
        MMCICLKOUT        : in    std_logic; -- MMCI Clock output
        MMCIPWR           : in    std_logic; -- Power supply enable
        MMCIROD           : in    std_logic; -- Open-drain resistor
                                             -- enable
        MMCIVDD           : in    std_logic_vector(3 downto 0);
                                             -- Power supply o/p voltage
-- Outputs
        MMCIFBCLK         : out   std_logic; -- MMCI fed back clock
        MMCIORMUX         : out   std_logic  -- ORed output
       );
end MmciTrickInteg;
 
-- -----------------------------------------------------------------------------
--
--                             MmciTrickInteg
--                             =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--    This module is a simple trickbox used for integrating the MMCI on
--    a larger chip. This trickbox gives a loopback facility for few
--    input/output signals.
--    MMCICLKOUT is looped back onto MMCIFBCLK after a delay of a ns.
--    This models the skew between MMCIFBCLK and MMCICLKOUT.
--    MMCIDAT can take the value of ORing MMCIPWR and MMCIVDD[3:0] or 
--    MMCICMD.Similarly MMCICMD can take the value of ORing MMCIPWR 
--    and MMCIVDD[3:0] or MMCIDAT.
-- -----------------------------------------------------------------------------
 
-- --========================= ARCHITECTURE ==================================--
 
architecture behavioural of MmciTrickInteg is
 
-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
   signal MMCIOROUTPUT     : std_logic; -- ORed output   
-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------
 
begin
 
-- -----------------------------------------------------------------------------
-- Model the skew between MMCICLKOUT and MMCIFBCLK
-- -----------------------------------------------------------------------------
MMCIFBCLK             <= MMCICLKOUT after 3 ns; 
-- -----------------------------------------------------------------------------
-- Generation of the MMCIOROUTPUT output
-- -----------------------------------------------------------------------------
MMCIOROUTPUT         <= (MMCIVDD(0) or MMCIVDD(1) or MMCIVDD(2) or 
                        MMCIVDD(3)  or MMCIPWR);

-- -----------------------------------------------------------------------------
-- Generation of MMCIORMUX output
-- -----------------------------------------------------------------------------
MMCIORMUX            <= MMCIOROUTPUT when (MMCIROD ='1') 
                     else
                        'Z';
end behavioural;
 
-- --============================== End ======================================--
