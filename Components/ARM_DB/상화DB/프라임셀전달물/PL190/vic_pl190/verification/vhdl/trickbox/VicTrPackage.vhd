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
-- File Name              : VicTrPackage.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Trickbox Parameter definitions
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;

package VicTrPackage is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant WAITSTATES : integer := 10;
-- No of Wait States inserted for higher latency register accesses

-- ---------------------------------------------------------------------
-- HRESP value definitions
-- ---------------------------------------------------------------------
constant TR_H_OKAY  : std_logic_vector(1 downto 0) := "00";

-- ---------------------------------------------------------------------
-- HREADYOUT value definitions
-- ---------------------------------------------------------------------
constant TR_H_READY : std_logic := '1';
constant TR_H_WAIT  : std_logic := '0';

-- ---------------------------------------------------------------------
-- VIC Trickbox Functional registers' address constant definitions
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Mirrored Registers
-- Writes to these registers should be performed using
-- the VIC Base address + offset.
-- Reads to these registers should be performed using
-- the Trickbox Base address + offset.
-- ---------------------------------------------------------------------
constant VICTRINTSELECTADDR    : std_logic_vector(11 downto 2)
                               := "0000000011";
-- VICTrIntSelect at offset 0x00C

constant VICTRINTENABLEADDR    : std_logic_vector(11 downto 2)
                               := "0000000100";
-- VICTrIntEnable at offset 0x010

constant VICTRINTENCLEARADDR   : std_logic_vector(11 downto 2)
                               := "0000000101";
-- VICTrIntEnClear at offset 0x014

constant VICTRSOFTINTADDR      : std_logic_vector(11 downto 2)
                               := "0000000110";
-- VICTrSoftInt at offset 0x018

constant VICTRSOFTINTCLEARADDR : std_logic_vector(11 downto 2)
                               := "0000000111";
-- VICTrSoftIntClear at offset 0x01C

constant VICTRPROTECTIONADDR   : std_logic_vector(11 downto 2)
                               := "0000001000";
-- VICTrProtection at offset 0x020

constant VICTRVECTADADDR       : std_logic_vector(11 downto 2)
                               := "0000001100";
-- VICTrVectAddr at offset 0x030

constant VICTRDEFVECTADADDR    : std_logic_vector(11 downto 2)
                               := "0000001101";
-- VICTrDefVectAddr at offset 0x034

constant VICTRVECTAD0ADDR      : std_logic_vector(11 downto 2)
                               := "0001000000";
-- VICTrVectAddr0 at offset 0x100

constant VICTRVECTAD1ADDR      : std_logic_vector(11 downto 2)
                               := "0001000001";
-- VICTrVectAddr1 at offset 0x104

constant VICTRVECTAD2ADDR      : std_logic_vector(11 downto 2)
                               := "0001000010";
-- VICTrVectAddr2 at offset 0x108

constant VICTRVECTAD3ADDR      : std_logic_vector(11 downto 2)
                               := "0001000011";
-- VICTrVectAddr3 at offset 0x10C

constant VICTRVECTAD4ADDR      : std_logic_vector(11 downto 2)
                               := "0001000100";
-- VICTrVectAddr4 at offset 0x110

constant VICTRVECTAD5ADDR      : std_logic_vector(11 downto 2)
                               := "0001000101";
-- VICTrVectAddr5 at offset 0x114

constant VICTRVECTAD6ADDR      : std_logic_vector(11 downto 2)
                               := "0001000110";
-- VICTrVectAddr6 at offset 0x118

constant VICTRVECTAD7ADDR      : std_logic_vector(11 downto 2)
                               := "0001000111";
-- VICTrVectAddr7 at offset 0x11C

constant VICTRVECTAD8ADDR      : std_logic_vector(11 downto 2)
                               := "0001001000";
-- VICTrVectAddr8 at offset 0x120

constant VICTRVECTAD9ADDR      : std_logic_vector(11 downto 2)
                               := "0001001001";
-- VICTrVectAddr9 at offset 0x124

constant VICTRVECTAD10ADDR     : std_logic_vector(11 downto 2)
                               := "0001001010";
-- VICTrVectAddr10 at offset 0x128

constant VICTRVECTAD11ADDR     : std_logic_vector(11 downto 2)
                               := "0001001011";
-- VICTrVectAddr11 at offset 0x12C

constant VICTRVECTAD12ADDR     : std_logic_vector(11 downto 2)
                               := "0001001100";
-- VICTrVectAddr12 at offset 0x130

constant VICTRVECTAD13ADDR     : std_logic_vector(11 downto 2)
                               := "0001001101";
-- VICTrVectAddr13 at offset 0x134

constant VICTRVECTAD14ADDR     : std_logic_vector(11 downto 2)
                               := "0001001110";
-- VICTrVectAddr14 at offset 0x138

constant VICTRVECTAD15ADDR     : std_logic_vector(11 downto 2)
                               := "0001001111";
-- VICTrVectAddr15 at offset 0x13C

constant VICTRVECTCNTL0ADDR    : std_logic_vector(11 downto 2)
                               := "0010000000";
-- VICTrVectCntl0 at offset 0x200

constant VICTRVECTCNTL1ADDR    : std_logic_vector(11 downto 2)
                               := "0010000001";
-- VICTrVectCntl1 at offset 0x204

constant VICTRVECTCNTL2ADDR    : std_logic_vector(11 downto 2)
                               := "0010000010";
-- VICTrVectCntl2 at offset 0x208

constant VICTRVECTCNTL3ADDR    : std_logic_vector(11 downto 2)
                               := "0010000011";
-- VICTrVectCntl3 at offset 0x20C

constant VICTRVECTCNTL4ADDR    : std_logic_vector(11 downto 2)
                               := "0010000100";
-- VICTrVectCntl4 at offset 0x210

constant VICTRVECTCNTL5ADDR    : std_logic_vector(11 downto 2)
                               := "0010000101";
-- VICTrVectCntl5 at offset 0x214

constant VICTRVECTCNTL6ADDR    : std_logic_vector(11 downto 2)
                               := "0010000110";
-- VICTrVectCntl6 at offset 0x218

constant VICTRVECTCNTL7ADDR    : std_logic_vector(11 downto 2)
                               := "0010000111";
-- VICTrVectCntl7 at offset 0x21C

constant VICTRVECTCNTL8ADDR    : std_logic_vector(11 downto 2)
                               := "0010001000";
-- VICTrVectCntl8 at offset 0x220

constant VICTRVECTCNTL9ADDR    : std_logic_vector(11 downto 2)
                               := "0010001001";
-- VICTrVectCntl9 at offset 0x224

constant VICTRVECTCNTL10ADDR   : std_logic_vector(11 downto 2)
                               := "0010001010";
-- VICTrVectCntl10 at offset 0x228

constant VICTRVECTCNTL11ADDR   : std_logic_vector(11 downto 2)
                               := "0010001011";
-- VICTrVectCntl11 at offset 0x22C

constant VICTRVECTCNTL12ADDR   : std_logic_vector(11 downto 2)
                               := "0010001100";
-- VICTrVectCntl12 at offset 0x230

constant VICTRVECTCNTL13ADDR   : std_logic_vector(11 downto 2)
                               := "0010001101";
-- VICTrVectCntl13 at offset 0x234

constant VICTRVECTCNTL14ADDR   : std_logic_vector(11 downto 2)
                               := "0010001110";
-- VICTrVectCntl14 at offset 0x238

constant VICTRVECTCNTL15ADDR   : std_logic_vector(11 downto 2)
                               := "0010001111";
-- VICTrVectCntl15 at offset 0x23C

-- ---------------------------------------------------------------------
-- Trickbox-specific Registers (Offset is specified with respect to
-- the Trickbox Base address)
-- ---------------------------------------------------------------------
constant VICTRTCRADDR          : std_logic_vector(11 downto 2)
                               := "0000000000";
-- VICTrTCR at offset 0x000

constant VICTRINTSOURCEADDR    : std_logic_vector(11 downto 2)
                               := "0000000001";
-- VICTrIntSource at offset 0x004

constant VICTRINTSTATUSADDR    : std_logic_vector(11 downto 2)
                               := "0000000010";
-- VICTrStatus at offset 0x008

constant VICTRVECTADOUTADDR    : std_logic_vector(11 downto 2)
                               := "0000001001";
-- VICTrVectAddrOut at offset 0x024

constant VICTRINTINADDR        : std_logic_vector(11 downto 2)
                               := "0000001010";
-- VICTrIntIn at offset 0x0028

constant VICTRVECTADINADDR     : std_logic_vector(11 downto 2)
                               := "0000001011";
-- VICTrVectAddrIn at offset 0x02C

constant VICTRWAITACCESSADDR   : std_logic_vector(11 downto 2)
                               := "0000001110";
-- VICTr dummy register accessible with Non-Zero wait states 
-- at offset 0x038

-- ---------------------------------------------------------------------
-- 0x55555555 for WaitStReg read to return
-- ---------------------------------------------------------------------
constant Data5                 : std_logic_vector(31 downto 0)
                               := "01010101010101010101010101010101";

-- ---------------------------------------------------------------------
-- Zero fill for register reads to return zeros in unused bit positions
-- ---------------------------------------------------------------------
constant ZEROFILL              : std_logic_vector(31 downto 0)
                               := "00000000000000000000000000000000";

end VicTrPackage;

-- --============================== End ==============================--
