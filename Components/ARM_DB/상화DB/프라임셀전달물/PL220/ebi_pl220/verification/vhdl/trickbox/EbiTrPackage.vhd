-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : EbiTrPackage.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           All constants needs to be change in the tricbox design are
--           declared here
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;

-- -----------------------------------------------------------------------------

package EbiTrPackage is

-- -----------------------------------------------------------------------------
--
--                               EbiTrPackage
--                               ============
--
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Definitions for different AHB HTRANS transactions
-- -----------------------------------------------------------------------------
constant HTRANS_IDLE      : std_logic_vector(1 downto 0) := "00";
-- Master IDLE respone

constant HTRANS_BUSY      : std_logic_vector(1 downto 0) := "01";
-- Master BUSY respone

-- -----------------------------------------------------------------------------
-- Definitions for different AHB HRESP responses
-- -----------------------------------------------------------------------------
constant HRESP_OKAY       : std_logic_vector(1 downto 0) := "00";
-- Slave OKAY respone

constant HRESP_ERROR      : std_logic_vector(1 downto 0) := "01";
-- Slave ERROR respone

-- -----------------------------------------------------------------------------
-- Definitions for different AHB HSIZE transactions
-- -----------------------------------------------------------------------------
constant HSIZE_WORD       : std_logic_vector(2 downto 0) := "010";
-- 32-bit operation

-- -----------------------------------------------------------------------------
-- Definitions for different AHB HBURST transactions
-- -----------------------------------------------------------------------------
constant HBURST_INCR      : std_logic_vector(2 downto 0) := "001";
-- Undefined length burst

end EbiTrPackage;

-- --================================= End ===================================--
