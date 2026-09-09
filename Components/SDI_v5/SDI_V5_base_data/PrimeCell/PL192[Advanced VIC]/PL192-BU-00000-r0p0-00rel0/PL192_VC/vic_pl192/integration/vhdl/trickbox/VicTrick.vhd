-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : VicTrick.vhd.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Top level of the VIC Trickbox.
--
-- --=========================================================================--


library IEEE;
use     IEEE.std_logic_1164.all;

-- -----------------------------------------------------------------------------

entity VicTrick is
  port (
-- Inputs
        VICIRQ           : in    std_logic;
        VICFIQ           : in    std_logic;
        VICVECTADDROUT   : in    std_logic_vector(31 downto 0);
-- Outputs
        VICFIQINREG      : out   std_logic;
        VICIRQINREG      : out   std_logic;
        VICINTSOURCE     : out   std_logic_vector(31 downto 0)
       );
end VicTrick;

-- -----------------------------------------------------------------------------
--
--                              VicTrick
--                              ========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Timing Parameters of Trickbox
--------------------------------------------------------------------------------

architecture behaviour of VicTrick is
-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------
begin
  VICINTSOURCE <= not(VICVECTADDROUT);
  VICFIQINREG <= not(VICFIQ);
  VICIRQINREG <= not(VICIRQ);

end behaviour;
-- --================================== End ==================================--
