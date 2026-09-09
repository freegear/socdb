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
-- File Name              : VicTrPackage.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Trickbox Parameter definitions
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;

package VicTrPackage is

-- ----------------------------------------------------------------------------
-- Constant declarations
-- ----------------------------------------------------------------------------
constant WAITSTATES : integer := 10;
-- No of Wait States inserted for higher latency register accesses

-- ----------------------------------------------------------------------------
-- HRESP value definitions
-- ----------------------------------------------------------------------------
constant TR_H_OKAY  : std_logic_vector(1 downto 0) := "00";

-- ----------------------------------------------------------------------------
-- HREADYOUT value definitions
-- ----------------------------------------------------------------------------
constant TR_H_READY : std_logic := '1';
constant TR_H_WAIT  : std_logic := '0';

-- ----------------------------------------------------------------------------
-- VIC Trickbox Functional registers' address constant definitions
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Mirrored Registers
-- Writes to these registers should be performed using
-- the VIC Base address + offset.
-- Reads to these registers should be performed using
-- the Trickbox Base address + offset.
-- -----------------------------------------------------------------------------
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

constant VICTRSWPRITYMASKADDR  : std_logic_vector(11 downto 2)
                               := "0000001001";
-- VICTrSwPriMask at offset 0x024

constant VICTRVECTPLDSYPLVL    : std_logic_vector(11 downto 2)
                               := "0000001010";
-- VICTrVectPriDsy at offset 0x028

constant VICTRVECTADADDR       : std_logic_vector(11 downto 2)
                               := "1111000000";
-- VICTrVectAddr at offset 0xF00

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

constant VICTRVECTAD16ADDR     : std_logic_vector(11 downto 2)
                               := "0001010000";
-- VicTrVectAddr16 at offset 0x140

constant VICTRVECTAD17ADDR     : std_logic_vector(11 downto 2)
                               := "0001010001";
-- VicTrVectAddr17 at offset 0x144

constant VICTRVECTAD18ADDR     : std_logic_vector(11 downto 2)
                               := "0001010010";
-- VicTrVectAddr18 at offset 0x148

constant VICTRVECTAD19ADDR     : std_logic_vector(11 downto 2)
                               := "0001010011";
-- VicTrVectAddr19 at offset 0x14C

constant VICTRVECTAD20ADDR     : std_logic_vector(11 downto 2)
                               := "0001010100";
-- VicTrVectAddr20 at offset 0x150

constant VICTRVECTAD21ADDR     : std_logic_vector(11 downto 2)
                               := "0001010101";
-- VicTrVectAddr21 at offset 0x154

constant VICTRVECTAD22ADDR     : std_logic_vector(11 downto 2)
                               := "0001010110";
-- VicTrVectAddr22 at offset 0x158

constant VICTRVECTAD23ADDR     : std_logic_vector(11 downto 2)
                               := "0001010111";
-- VicTrVectAddr23 at offset 0x15C

constant VICTRVECTAD24ADDR     : std_logic_vector(11 downto 2)
                               := "0001011000";
-- VicTrVectAddr24 at offset 0x160

constant VICTRVECTAD25ADDR     : std_logic_vector(11 downto 2)
                               := "0001011001";
-- VicTrVectAddr25 at offset 0x164

constant VICTRVECTAD26ADDR     : std_logic_vector(11 downto 2)
                               := "0001011010";
-- VicTrVectAddr26 at offset 0x168

constant VICTRVECTAD27ADDR     : std_logic_vector(11 downto 2)
                               := "0001011011";
-- VicTrVectAddr27 at offset 0x16C
   
constant VICTRVECTAD28ADDR     : std_logic_vector(11 downto 2)
                               := "0001011100";
-- VicTrVectAddr28 at offset 0x170

constant VICTRVECTAD29ADDR     : std_logic_vector(11 downto 2)
                               := "0001011101";
-- VicTrVectAddr29 at offset 0x174

constant VICTRVECTAD30ADDR     : std_logic_vector(11 downto 2)
                               := "0001011110";
-- VicTrVectAddr30 at offset 0x178

constant VICTRVECTAD31ADDR     : std_logic_vector(11 downto 2)
                               := "0001011111";
-- VicTrVectAddr31 at offset 0x17C

constant VICTRVECTPL0PLVL      : std_logic_vector(11 downto 2)
                               := "0010000000";
-- VICTrVectPrity0 at offset 0x200

constant VICTRVECTPL1PLVL      : std_logic_vector(11 downto 2)
                               := "0010000001";
-- VICTrVectPrity1 at offset 0x204

constant VICTRVECTPL2PLVL      : std_logic_vector(11 downto 2)
                               := "0010000010";
-- VICTrVectPrity2 at offset 0x208

constant VICTRVECTPL3PLVL      : std_logic_vector(11 downto 2)
                               := "0010000011";
-- VICTrVectPrity3 at offset 0x20C

constant VICTRVECTPL4PLVL      : std_logic_vector(11 downto 2)
                               := "0010000100";
-- VICTrVectPrity4 at offset 0x210

constant VICTRVECTPL5PLVL      : std_logic_vector(11 downto 2)
                               := "0010000101";
-- VICTrVectPrity5 at offset 0x214

constant VICTRVECTPL6PLVL      : std_logic_vector(11 downto 2)
                               := "0010000110";
-- VICTrVectPrity6 at offset 0x218

constant VICTRVECTPL7PLVL      : std_logic_vector(11 downto 2)
                               := "0010000111";
-- VICTrVectPrity7 at offset 0x21C

constant VICTRVECTPL8PLVL      : std_logic_vector(11 downto 2)
                               := "0010001000";
-- VICTrVectPrity8 at offset 0x220

constant VICTRVECTPL9PLVL      : std_logic_vector(11 downto 2)
                               := "0010001001";
-- VICTrVectPrity9 at offset 0x224

constant VICTRVECTPL10PLVL     : std_logic_vector(11 downto 2)
                               := "0010001010";
-- VICTrVectPrity10 at offset 0x228

constant VICTRVECTPL11PLVL     : std_logic_vector(11 downto 2)
                               := "0010001011";
-- VICTrVectPrity11 at offset 0x22C

constant VICTRVECTPL12PLVL     : std_logic_vector(11 downto 2)
                               := "0010001100";
-- VICTrVectPrity12 at offset 0x230

constant VICTRVECTPL13PLVL     : std_logic_vector(11 downto 2)
                               := "0010001101";
-- VICTrVectPrity13 at offset 0x234

constant VICTRVECTPL14PLVL     : std_logic_vector(11 downto 2)
                               := "0010001110";
-- VICTrVectPrity14 at offset 0x238

constant VICTRVECTPL15PLVL     : std_logic_vector(11 downto 2)
                               := "0010001111";
-- VICTrVectPrity15 at offset 0x23C

constant VICTRVECTPL16PLVL     : std_logic_vector(11 downto 2)
                               := "0010010000";
-- VicTrVectPrity16 at offset 0x240

constant VICTRVECTPL17PLVL     : std_logic_vector(11 downto 2)
                               := "0010010001";
-- VicTrVectPrity17 at offset 0x244

constant VICTRVECTPL18PLVL     : std_logic_vector(11 downto 2)
                               := "0010010010";
-- VicTrVectPrity18 at offset 0x248

constant VICTRVECTPL19PLVL     : std_logic_vector(11 downto 2)
                               := "0010010011";
-- VicTrVectPrity19 at offset 0x24C

constant VICTRVECTPL20PLVL     : std_logic_vector(11 downto 2)
                               := "0010010100";
-- VicTrVectPrity20 at offset 0x250

constant VICTRVECTPL21PLVL     : std_logic_vector(11 downto 2)
                               := "0010010101";
-- VicTrVectPrity21 at offset 0x254

constant VICTRVECTPL22PLVL     : std_logic_vector(11 downto 2)
                               := "0010010110";
-- VicTrVectPrity22 at offset 0x258

constant VICTRVECTPL23PLVL     : std_logic_vector(11 downto 2)
                               := "0010010111";
-- VicTrVectPrity23 at offset 0x25C

constant VICTRVECTPL24PLVL     : std_logic_vector(11 downto 2)
                               := "0010011000";
-- VicTrVectPrity24 at offset 0x260

constant VICTRVECTPL25PLVL     : std_logic_vector(11 downto 2)
                               := "0010011001";
-- VicTrVectPrity25 at offset 0x264

constant VICTRVECTPL26PLVL     : std_logic_vector(11 downto 2)
                               := "0010011010";
-- VicTrVectPrity26 at offset 0x268

constant VICTRVECTPL27PLVL     : std_logic_vector(11 downto 2)
                               := "0010011011";
-- VicTrVectPrity27 at offset 0x26C
   
constant VICTRVECTPL28PLVL     : std_logic_vector(11 downto 2)
                               := "0010011100";
-- VicTrVectPrity28 at offset 0x270

constant VICTRVECTPL29PLVL     : std_logic_vector(11 downto 2)
                               := "0010011101";
-- VicTrVectPrity29 at offset 0x274

constant VICTRVECTPL30PLVL     : std_logic_vector(11 downto 2)
                               := "0010011110";
-- VicTrVectPrity30 at offset 0x278

constant VICTRVECTPL31PLVL     : std_logic_vector(11 downto 2)
                               := "0010011111";
-- VicTrVectPrity31 at offset 0x27C

constant VICTRWAITACCESSADDR   : std_logic_vector(11 downto 2)
                               := "0000001110";
-- VicTrVectPrity31 at offset 0x038

-- -----------------------------------------------------------------------------
-- Trickbox-specific Registers (Offset is specified with respect to
-- the Trickbox Base address)
-- -----------------------------------------------------------------------------
constant VICTRTCRADDR          : std_logic_vector(11 downto 2)
                               := "0000010100";
-- VICTrTCR at offset 0x050

constant VICTRINTSOURCEADDR    : std_logic_vector(11 downto 2)
                               := "0000010101";
-- VICTrIntSource at offset 0x054

constant VICTRINTSTATUSADDR    : std_logic_vector(11 downto 2)
                               := "0000000010";
-- VICTrStatus at offset 0x058

constant VICTRVECTADOUTADDR    : std_logic_vector(11 downto 2)
                               := "0000010111";
-- VICTrVectAddrOut at offset 0x05C

constant VICTRINTINADDR        : std_logic_vector(11 downto 2)
                               := "0000011000";
-- VICTrIntIn at offset 0x0060

constant VICTRINTINREGADDR     : std_logic_vector(11 downto 2)
                               := "0000011001";
-- VICTrIntInReg at offset 0x0064

constant VICTRVECTADINADDR     : std_logic_vector(11 downto 2)
                               := "0000011010";
-- VICTrVectAddrIn at offset 0x068

constant VICTRSYNCADDR         : std_logic_vector(11 downto 2)
                               := "0000011011";
-- VICTrVectAddrIn at offset 0x06C

constant VICTRACKCNTADDR       : std_logic_vector(11 downto 2)
                               := "0000011101";
-- VICTrVectAddrIn at offset 0x074


-- -----------------------------------------------------------------------------
-- 0x55555555 for WaitStReg read to return
-- -----------------------------------------------------------------------------
constant Data5                 : std_logic_vector(31 downto 0)
                               := "01010101010101010101010101010101";

-- -----------------------------------------------------------------------------
-- Zero fill for register reads to return zeros in unused bit positions
-- -----------------------------------------------------------------------------
constant ZEROFILL              : std_logic_vector(31 downto 0)
                               := "00000000000000000000000000000000";

end VicTrPackage;

-- --================================== End ==================================--
