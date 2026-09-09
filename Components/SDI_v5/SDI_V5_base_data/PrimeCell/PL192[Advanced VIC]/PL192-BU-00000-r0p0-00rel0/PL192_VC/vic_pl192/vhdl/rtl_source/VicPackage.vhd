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
-- File Name              : VicPackage.vhd.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Vectored Interrupt Controller Parameter definitions and functions
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


-- -----------------------------------------------------------------------------
--
--                              VicPackage
--                              ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This file contains the parameters and constants definitions for the
-- submodules and some common functions used in the Vic.
--
-- -----------------------------------------------------------------------------

package VicPackage is

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- HADDR declarations
-- -----------------------------------------------------------------------------

constant HADDR_VICVECTADDR0 : std_logic_vector(9 downto 0) := "0001000000";
-- VICVectAddr0 register Offset

constant HADDR_VICVECTADDR1 : std_logic_vector(9 downto 0) := "0001000001";
-- VICVectAddr1 register Offset

constant HADDR_VICVECTADDR2 : std_logic_vector(9 downto 0) := "0001000010";
-- VICVectAddr2 register Offset

constant HADDR_VICVECTADDR3 : std_logic_vector(9 downto 0) := "0001000011";
-- VICVectAddr3 register Offset

constant HADDR_VICVECTADDR4 : std_logic_vector(9 downto 0) := "0001000100";
-- VICVectAddr4 register Offset

constant HADDR_VICVECTADDR5 : std_logic_vector(9 downto 0) := "0001000101";
-- VICVectAddr5 register Offset

constant HADDR_VICVECTADDR6 : std_logic_vector(9 downto 0) := "0001000110";
-- VICVectAddr6 register Offset

constant HADDR_VICVECTADDR7 : std_logic_vector(9 downto 0) := "0001000111";
-- VICVectAddr7 register Offset

constant HADDR_VICVECTADDR8 : std_logic_vector(9 downto 0) := "0001001000";
-- VICVectAddr8 register Offset

constant HADDR_VICVECTADDR9 : std_logic_vector(9 downto 0) := "0001001001";
-- VICVectAddr9 register Offset

constant HADDR_VICVECTADDR10 : std_logic_vector(9 downto 0) := "0001001010";
-- VICVectAddr10 register Offset

constant HADDR_VICVECTADDR11 : std_logic_vector(9 downto 0) := "0001001011";
-- VICVectAddr11 register Offset

constant HADDR_VICVECTADDR12 : std_logic_vector(9 downto 0) := "0001001100";
-- VICVectAddr12 register Offset

constant HADDR_VICVECTADDR13 : std_logic_vector(9 downto 0) := "0001001101";
-- VICVectAddr13 register Offset

constant HADDR_VICVECTADDR14 : std_logic_vector(9 downto 0) := "0001001110";
-- VICVectAddr14 register Offset

constant HADDR_VICVECTADDR15 : std_logic_vector(9 downto 0) := "0001001111";
-- VICVectAddr15 register Offset

constant HADDR_VICVECTADDR16 : std_logic_vector(9 downto 0) := "0001010000";
-- VICVectAddr16 register Offset

constant HADDR_VICVECTADDR17 : std_logic_vector(9 downto 0) := "0001010001";
-- VICVectAddr17 register Offset

constant HADDR_VICVECTADDR18 : std_logic_vector(9 downto 0) := "0001010010";
-- VICVectAddr18 register Offset

constant HADDR_VICVECTADDR19 : std_logic_vector(9 downto 0) := "0001010011";
-- VICVectAddr19 register Offset

constant HADDR_VICVECTADDR20 : std_logic_vector(9 downto 0) := "0001010100";
-- VICVectAddr20 register Offset

constant HADDR_VICVECTADDR21 : std_logic_vector(9 downto 0) := "0001010101";
-- VICVectAddr21 register Offset

constant HADDR_VICVECTADDR22 : std_logic_vector(9 downto 0) := "0001010110";
-- VICVectAddr22 register Offset

constant HADDR_VICVECTADDR23 : std_logic_vector(9 downto 0) := "0001010111";
-- VICVectAddr23 register Offset

constant HADDR_VICVECTADDR24 : std_logic_vector(9 downto 0) := "0001011000";
-- VICVectAddr24 register Offset

constant HADDR_VICVECTADDR25 : std_logic_vector(9 downto 0) := "0001011001";
-- VICVectAddr25 register Offset

constant HADDR_VICVECTADDR26 : std_logic_vector(9 downto 0) := "0001011010";
-- VICVectAddr26 register Offset

constant HADDR_VICVECTADDR27 : std_logic_vector(9 downto 0) := "0001011011";
-- VICVectAddr27 register Offset

constant HADDR_VICVECTADDR28 : std_logic_vector(9 downto 0) := "0001011100";
-- VICVectAddr28 register Offset

constant HADDR_VICVECTADDR29 : std_logic_vector(9 downto 0) := "0001011101";
-- VICVectAddr29 register Offset

constant HADDR_VICVECTADDR30 : std_logic_vector(9 downto 0) := "0001011110";
-- VICVectAddr30 register Offset

constant HADDR_VICVECTADDR31 : std_logic_vector(9 downto 0) := "0001011111";
-- VICVectAddr31 register Offset

constant HADDR_VICPRIORITY0 : std_logic_vector(9 downto 0) := "0010000000";
-- VICVECTPRIORITY0 register Offset

constant HADDR_VICPRIORITY1 : std_logic_vector(9 downto 0) := "0010000001";
-- VICVECTPRIORITY1 register Offset

constant HADDR_VICPRIORITY2 : std_logic_vector(9 downto 0) := "0010000010";
-- VICVECTPRIORITY2 register Offset

constant HADDR_VICPRIORITY3 : std_logic_vector(9 downto 0) := "0010000011";
-- VICVECTPRIORITY3 register Offset

constant HADDR_VICPRIORITY4 : std_logic_vector(9 downto 0) := "0010000100";
-- VICVECTPRIORITY4 register Offset

constant HADDR_VICPRIORITY5 : std_logic_vector(9 downto 0) := "0010000101";
-- VICVECTPRIORITY5 register Offset

constant HADDR_VICPRIORITY6 : std_logic_vector(9 downto 0) := "0010000110";
-- VICVECTPRIORITY6 register Offset

constant HADDR_VICPRIORITY7 : std_logic_vector(9 downto 0) := "0010000111";
-- VICVECTPRIORITY7 register Offset

constant HADDR_VICPRIORITY8 : std_logic_vector(9 downto 0) := "0010001000";
-- VICVECTPRIORITY8 register Offset

constant HADDR_VICPRIORITY9 : std_logic_vector(9 downto 0) := "0010001001";
-- VICVECTPRIORITY9 register Offset

constant HADDR_VICPRIORITY10 : std_logic_vector(9 downto 0) := "0010001010";
-- VICVECTPRIORITY10 register Offset

constant HADDR_VICPRIORITY11 : std_logic_vector(9 downto 0) := "0010001011";
-- VICVECTPRIORITY11 register Offset

constant HADDR_VICPRIORITY12 : std_logic_vector(9 downto 0) := "0010001100";
-- VICVECTPRIORITY12 register Offset

constant HADDR_VICPRIORITY13 : std_logic_vector(9 downto 0) := "0010001101";
-- VICVECTPRIORITY13 register Offset

constant HADDR_VICPRIORITY14 : std_logic_vector(9 downto 0) := "0010001110";
-- VICVECTPRIORITY14 register Offset

constant HADDR_VICPRIORITY15 : std_logic_vector(9 downto 0) := "0010001111";
-- VICVECTPRIORITY15 register Offset

constant HADDR_VICPRIORITY16 : std_logic_vector(9 downto 0) := "0010010000";
-- VICVECTPRIORITY16 register Offset

constant HADDR_VICPRIORITY17 : std_logic_vector(9 downto 0) := "0010010001";
-- VICVECTPRIORITY17 register Offset

constant HADDR_VICPRIORITY18 : std_logic_vector(9 downto 0) := "0010010010";
-- VICVECTPRIORITY18 register Offset

constant HADDR_VICPRIORITY19 : std_logic_vector(9 downto 0) := "0010010011";
-- VICVECTPRIORITY19 register Offset

constant HADDR_VICPRIORITY20 : std_logic_vector(9 downto 0) := "0010010100";
-- VICVECTPRIORITY20 register Offset

constant HADDR_VICPRIORITY21 : std_logic_vector(9 downto 0) := "0010010101";
-- VICVECTPRIORITY21 register Offset

constant HADDR_VICPRIORITY22 : std_logic_vector(9 downto 0) := "0010010110";
-- VICVECTPRIORITY22 register Offset

constant HADDR_VICPRIORITY23 : std_logic_vector(9 downto 0) := "0010010111";
-- VICVECTPRIORITY23 register Offset

constant HADDR_VICPRIORITY24 : std_logic_vector(9 downto 0) := "0010011000";
-- VICVECTPRIORITY24 register Offset

constant HADDR_VICPRIORITY25 : std_logic_vector(9 downto 0) := "0010011001";
-- VICVECTPRIORITY25 register Offset

constant HADDR_VICPRIORITY26 : std_logic_vector(9 downto 0) := "0010011010";
-- VICVECTPRIORITY26 register Offset

constant HADDR_VICPRIORITY27 : std_logic_vector(9 downto 0) := "0010011011";
-- VICVECTPRIORITY27 register Offset

constant HADDR_VICPRIORITY28 : std_logic_vector(9 downto 0) := "0010011100";
-- VICVECTPRIORITY28 register Offset

constant HADDR_VICPRIORITY29 : std_logic_vector(9 downto 0) := "0010011101";
-- VICVECTPRIORITY29 register Offset

constant HADDR_VICPRIORITY30 : std_logic_vector(9 downto 0) := "0010011110";
-- VICVECTPRIORITY30 register Offset

constant HADDR_VICPRIORITY31 : std_logic_vector(9 downto 0) := "0010011111";
-- VICVECTPRIORITY31 register Offset


constant HADDR_VICIRQSTATUS : std_logic_vector(9 downto 0) := "0000000000";
-- VICIRQSTATUS register Offset

constant HADDR_VICFIQSTATUS : std_logic_vector(9 downto 0) := "0000000001";
-- VICFIQSTATUS register Offset

constant HADDR_VICRAWINTR : std_logic_vector(9 downto 0) := "0000000010";
-- VICRAWINTR register Offset

constant HADDR_VICINTSELECT : std_logic_vector(9 downto 0) := "0000000011";
-- VICINTSELECT register Offset

constant HADDR_VICINTENABLE : std_logic_vector(9 downto 0) := "0000000100";
-- VICINTENABLE register Offset

constant HADDR_VICINTENCLEAR : std_logic_vector(9 downto 0) := "0000000101";
-- VICINTENCLEAR register Offset

constant HADDR_VICSOFTINT : std_logic_vector(9 downto 0) := "0000000110";
-- VICSOFTINT register Offset

constant HADDR_VICSOFTINTCLEAR : std_logic_vector(9 downto 0) := "0000000111";
-- VICSOFTINTCLEAR register Offset

constant HADDR_VICPROTECTION : std_logic_vector(9 downto 0) := "0000001000";
-- VICPROTECTION register Offset

constant HADDR_VICSWPRIORITYMASK : std_logic_vector(9 downto 0)
                                   := "0000001001";
-- VICSWPRIORITYMASK register Offset

constant HADDR_VICSWPRIORITYDAISY : std_logic_vector(9 downto 0)
                                    := "0000001010";
-- VICSWPRIORITYDAISY register Offset

constant HADDR_VICITCR : std_logic_vector(9 downto 0) := "0011000000";
-- VICITCR register Offset

constant HADDR_VICITIP1 : std_logic_vector(9 downto 0) := "0011000001";
-- VICITIP1 register Offset

constant HADDR_VICITIP2 : std_logic_vector(9 downto 0) := "0011000010";
-- VICITIP2 register Offset

constant HADDR_VICITOP1 : std_logic_vector(9 downto 0) := "0011000011";
-- VICITOP1 register Offset

constant HADDR_VICITOP2 : std_logic_vector(9 downto 0) := "0011000100";
-- VICITOP2 register Offset

constant HADDR_VICINTSSTATUS : std_logic_vector(9 downto 0) := "0011000101";
-- VICINTSSTATUS register Offset

constant HADDR_VICINTSSTATUSCLEAR : std_logic_vector(9 downto 0)
                                    := "0011000110";
-- VICINTSSTATUSCLEAR register Offset

constant HADDR_VICADDRESS : std_logic_vector(9 downto 0) := "1111000000";
-- VICADDRESS register Offset

constant HADDR_VICPERIPHID0 : std_logic_vector(9 downto 0) := "1111111000";
-- VICPERIPHID0 register Offset

constant HADDR_VICPERIPHID1 : std_logic_vector(9 downto 0) := "1111111001";
-- VICPERIPHID1 register Offset

constant HADDR_VICPERIPHID2 : std_logic_vector(9 downto 0) := "1111111010";
-- VICPERIPHID2 register Offset

constant HADDR_VICPERIPHID3 : std_logic_vector(9 downto 0) := "1111111011";
-- VICPERIPHID3 register Offset

constant HADDR_VICPCELLID0 : std_logic_vector(9 downto 0) := "1111111100";
-- VICPCELLID0 register Offset

constant HADDR_VICPCELLID1 : std_logic_vector(9 downto 0) := "1111111101";
-- VICPCELLID1 register Offset

constant HADDR_VICPCELLID2 : std_logic_vector(9 downto 0) := "1111111110";
-- VICPCELLID2 register Offset

constant HADDR_VICPCELLID3 : std_logic_vector(9 downto 0) := "1111111111";
-- VICPCELLID3 register Offset

-- -----------------------------------------------------------------------------
-- Values of the peripheral ID and PrimeCell ID
-- -----------------------------------------------------------------------------

constant PERIPHID0 : std_logic_vector(7 downto 0) := "10010010";
-- Peripheral Identification bits 7:0

constant PERIPHID1 : std_logic_vector(7 downto 0) := "00010001";
-- Peripheral Identification bits 15:8

constant PERIPHID2 : std_logic_vector(3 downto 0) := "0100";
-- Peripheral Identification bits 23:16

constant PERIPHID3 : std_logic_vector(7 downto 0) := "00000000";
-- Peripheral Identification bits 31:24

constant PCELLID0 : std_logic_vector(7 downto 0) := "00001101";
-- PrimeCell Identification bits 7:0

constant PCELLID1 : std_logic_vector(7 downto 0) := "11110000";
-- PrimeCell Identification bits 15:8

constant PCELLID2 : std_logic_vector(7 downto 0) := "00000101";
-- PrimeCell Identification bits 23:16

constant PCELLID3 : std_logic_vector(7 downto 0) := "10110001";
-- PrimeCell Identification bits 31:24

-- -----------------------------------------------------------------------------
-- Constant declaration
-- -----------------------------------------------------------------------------
constant ZERO33 : std_logic_vector(32 downto 0)
                  := "000000000000000000000000000000000";

constant ZERO32 : std_logic_vector(31 downto 0)
                  := "00000000000000000000000000000000";

constant TIELOW28 : std_logic_vector(27 downto 0)
                    := "0000000000000000000000000000";

constant TIELOW24 : std_logic_vector(23 downto 0)
                    := "000000000000000000000000";

constant TIELOW16 : std_logic_vector(15 downto 0) := "0000000000000000";

-- -----------------------------------------------------------------------------
-- Constant values of sixteen priority encoder
-- -----------------------------------------------------------------------------
constant CFG0 : std_logic_vector(3 downto 0) := "0000";

constant CFG1 : std_logic_vector(3 downto 0) := "0001";

constant CFG2 : std_logic_vector(3 downto 0) := "0010";

constant CFG3 : std_logic_vector(3 downto 0) := "0011";

constant CFG4 : std_logic_vector(3 downto 0) := "0100";

constant CFG5 : std_logic_vector(3 downto 0) := "0101";

constant CFG6 : std_logic_vector(3 downto 0) := "0110";

constant CFG7 : std_logic_vector(3 downto 0) := "0111";

constant CFG8 : std_logic_vector(3 downto 0) := "1000";

constant CFG9 : std_logic_vector(3 downto 0) := "1001";

constant CFG10 : std_logic_vector(3 downto 0) := "1010";

constant CFG11 : std_logic_vector(3 downto 0) := "1011";

constant CFG12 : std_logic_vector(3 downto 0) := "1100";

constant CFG13 : std_logic_vector(3 downto 0) := "1101";

constant CFG14 : std_logic_vector(3 downto 0) := "1110";

constant CFG15 : std_logic_vector(3 downto 0) := "1111";
-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------
end VicPackage;

-- --=============================== BODY ====================================--

package body VicPackage is
end VicPackage;

-- --==================================== End ================================--
