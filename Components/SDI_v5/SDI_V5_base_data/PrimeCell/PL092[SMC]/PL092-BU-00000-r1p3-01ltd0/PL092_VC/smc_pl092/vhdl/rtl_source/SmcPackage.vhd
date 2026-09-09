-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SmcPackage.vhd.rca
-- File Revision          : 1.22
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           The constants used in the SMC system is defined in this block.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


package SmcPackage is

-- -----------------------------------------------------------------------------
-- Zero fill for register reads to return zeros in unused bit positions
-- -----------------------------------------------------------------------------
constant ZEROFILL             : std_logic_vector(31 downto 0)
                              := "00000000000000000000000000000000";

-- -----------------------------------------------------------------------------
-- AHB HRESP constant definitions
-- -----------------------------------------------------------------------------
constant H_OKAY               : std_logic_vector(1 downto 0) := "00";
constant H_ERROR              : std_logic_vector(1 downto 0) := "01";

-- -----------------------------------------------------------------------------
-- AHB HTRANS constant definitions
-- -----------------------------------------------------------------------------
constant T_IDLE               : std_logic_vector(1 downto 0) := "00";
constant T_BUSY               : std_logic_vector(1 downto 0) := "01";
constant T_NONSEQ             : std_logic_vector(1 downto 0) := "10";
constant T_SEQ                : std_logic_vector(1 downto 0) := "11";

-- -----------------------------------------------------------------------------
-- AHB HBURST type constant definitions
-- -----------------------------------------------------------------------------
constant SINGLE               : std_logic_vector(2 downto 0) := "000";
constant INCR                 : std_logic_vector(2 downto 0) := "001";
constant WRAP4                : std_logic_vector(2 downto 0) := "010";
constant INCR4                : std_logic_vector(2 downto 0) := "011";
constant WRAP8                : std_logic_vector(2 downto 0) := "100";
constant INCR8                : std_logic_vector(2 downto 0) := "101";
constant WRAP16               : std_logic_vector(2 downto 0) := "110";
constant INCR16               : std_logic_vector(2 downto 0) := "111";

-- -----------------------------------------------------------------------------
-- SMC Control register's address constant definitions
-- -----------------------------------------------------------------------------
constant HADDR_SMBIDCYR0             : std_logic_vector(11 downto 2)
                                     := "0000000000";
-- SMBIDCYR0 at offset 0x000

constant HADDR_SMBWST1R0             : std_logic_vector(11 downto 2)
                                     := "0000000001";
-- SMBWST1R0 at offset 0x004

constant HADDR_SMBWST2R0             : std_logic_vector(11 downto 2)
                                     := "0000000010";
-- SMBWST2R0 at offset 0x008

constant HADDR_SMBWSTOENR0           : std_logic_vector(11 downto 2)
                                     := "0000000011";
-- SMBWSTOENR0 at offset 0x00C

constant HADDR_SMBWSTWENR0           : std_logic_vector(11 downto 2)
                                     := "0000000100";
-- SMBWSTWENR0 at offset 0x010

constant HADDR_SMBCR0                : std_logic_vector(11 downto 2)
                                     := "0000000101";
-- SMBCR0 at offset 0x014

constant HADDR_SMBSR0                : std_logic_vector(11 downto 2)
                                     := "0000000110";
-- SMBSR0 at offset 0x018

constant HADDR_SMBIDCYR1             : std_logic_vector(11 downto 2)
                                     := "0000000111";
-- SMBIDCYR1 at offset 0x01C

constant HADDR_SMBWST1R1             : std_logic_vector(11 downto 2)
                                     := "0000001000";
-- SMBWST1R1 at offset 0x020

constant HADDR_SMBWST2R1             : std_logic_vector(11 downto 2)
                                     := "0000001001";
-- SMBWST2R1 at offset 0x024

constant HADDR_SMBWSTOENR1           : std_logic_vector(11 downto 2)
                                     := "0000001010";
-- SMBWSTOENR1 at offset 0x028

constant HADDR_SMBWSTWENR1           : std_logic_vector(11 downto 2)
                                     := "0000001011";
-- SMBWSTWENR1 at offset 0x02C

constant HADDR_SMBCR1                : std_logic_vector(11 downto 2)
                                     := "0000001100";
-- SMBCR1 at offset 0x030

constant HADDR_SMBSR1                : std_logic_vector(11 downto 2)
                                     := "0000001101";
-- SMBSR1 at offset 0x034

constant HADDR_SMBIDCYR2             : std_logic_vector(11 downto 2)
                                     := "0000001110";
-- SMBIDCYR2 at offset 0x038

constant HADDR_SMBWST1R2             : std_logic_vector(11 downto 2)
                                     := "0000001111";
-- SMBWST1R2 at offset 0x03C

constant HADDR_SMBWST2R2             : std_logic_vector(11 downto 2)
                                     := "0000010000";
-- SMBWST2R2 at offset 0x040

constant HADDR_SMBWSTOENR2           : std_logic_vector(11 downto 2)
                                     := "0000010001";
-- SMBWSTOENR2 at offset 0x044

constant HADDR_SMBWSTWENR2           : std_logic_vector(11 downto 2)
                                     := "0000010010";
-- SMBWSTWENR2 at offset 0x048

constant HADDR_SMBCR2                : std_logic_vector(11 downto 2)
                                     := "0000010011";
-- SMBCR2 at offset 0x04C

constant HADDR_SMBSR2                : std_logic_vector(11 downto 2)
                                     := "0000010100";
-- SMBSR2 at offset 0x050

constant HADDR_SMBIDCYR3             : std_logic_vector(11 downto 2)
                                     := "0000010101";
-- SMBIDCYR3 at offset 0x054

constant HADDR_SMBWST1R3             : std_logic_vector(11 downto 2)
                                     := "0000010110";
-- SMBWST1R3 at offset 0x058

constant HADDR_SMBWST2R3             : std_logic_vector(11 downto 2)
                                     := "0000010111";
-- SMBWST2R3 at offset 0x05C

constant HADDR_SMBWSTOENR3           : std_logic_vector(11 downto 2)
                                     := "0000011000";
-- SMBWSTOENR3 at offset 0x060

constant HADDR_SMBWSTWENR3           : std_logic_vector(11 downto 2)
                                     := "0000011001";
-- SMBWSTWENR3 at offset 0x064

constant HADDR_SMBCR3                : std_logic_vector(11 downto 2)
                                     := "0000011010";
-- SMBCR3 at offset 0x068

constant HADDR_SMBSR3                : std_logic_vector(11 downto 2)
                                     := "0000011011";
-- SMBSR3 at offset 0x06C

constant HADDR_SMBIDCYR4             : std_logic_vector(11 downto 2)
                                     := "0000011100";
-- SMBIDCYR4 at offset 0x070

constant HADDR_SMBWST1R4             : std_logic_vector(11 downto 2)
                                     := "0000011101";
-- SMBWST1R4 at offset 0x074

constant HADDR_SMBWST2R4             : std_logic_vector(11 downto 2)
                                     := "0000011110";
-- SMBWST2R4 at offset 0x078

constant HADDR_SMBWSTOENR4           : std_logic_vector(11 downto 2)
                                     := "0000011111";
-- SMBWSTOENR4 at offset 0x07C

constant HADDR_SMBWSTWENR4           : std_logic_vector(11 downto 2)
                                     := "0000100000";
-- SMBWSTWENR4 at offset 0x080

constant HADDR_SMBCR4                : std_logic_vector(11 downto 2)
                                     := "0000100001";
-- SMBCR4 at offset 0x084

constant HADDR_SMBSR4                : std_logic_vector(11 downto 2)
                                     := "0000100010";
-- SMBSR4 at offset 0x088

constant HADDR_SMBIDCYR5             : std_logic_vector(11 downto 2)
                                     := "0000100011";
-- SMBIDCYR5 at offset 0x08C

constant HADDR_SMBWST1R5             : std_logic_vector(11 downto 2)
                                     := "0000100100";
-- SMBWST1R5 at offset 0x090

constant HADDR_SMBWST2R5             : std_logic_vector(11 downto 2)
                                     := "0000100101";
-- SMBWST2R5 at offset 0x094

constant HADDR_SMBWSTOENR5           : std_logic_vector(11 downto 2)
                                     := "0000100110";
-- SMBWSTOENR5 at offset 0x098

constant HADDR_SMBWSTWENR5           : std_logic_vector(11 downto 2)
                                     := "0000100111";
-- SMBWSTWENR5 at offset 0x09C

constant HADDR_SMBCR5                : std_logic_vector(11 downto 2)
                                     := "0000101000";
-- SMBCR5 at offset 0x0A0

constant HADDR_SMBSR5                : std_logic_vector(11 downto 2)
                                     := "0000101001";
-- SMBSR5 at offset 0x0A4

constant HADDR_SMBIDCYR6             : std_logic_vector(11 downto 2)
                                     := "0000101010";
-- SMBIDCYR6 at offset 0x0A8

constant HADDR_SMBWST1R6             : std_logic_vector(11 downto 2)
                                     := "0000101011";
-- SMBWST1R6 at offset 0x0AC

constant HADDR_SMBWST2R6             : std_logic_vector(11 downto 2)
                                     := "0000101100";
-- SMBWST2R6 at offset 0x0B0

constant HADDR_SMBWSTOENR6           : std_logic_vector(11 downto 2)
                                     := "0000101101";
-- SMBWSTOENR6 at offset 0x0B4

constant HADDR_SMBWSTWENR6           : std_logic_vector(11 downto 2)
                                     := "0000101110";
-- SMBWSTWENR6 at offset 0x0B8

constant HADDR_SMBCR6                : std_logic_vector(11 downto 2)
                                     := "0000101111";
-- SMBCR6 at offset 0x0BC

constant HADDR_SMBSR6                : std_logic_vector(11 downto 2)
                                     := "0000110000";
-- SMBSR6 at offset 0x0C0

constant HADDR_SMBIDCYR7             : std_logic_vector(11 downto 2)
                                     := "0000110001";
-- SMBIDCYR7 at offset 0x0C4

constant HADDR_SMBWST1R7             : std_logic_vector(11 downto 2)
                                     := "0000110010";
-- SMBWST1R7 at offset 0x0C8

constant HADDR_SMBWST2R7             : std_logic_vector(11 downto 2)
                                     := "0000110011";
-- SMBWST2R7 at offset 0x0CC

constant HADDR_SMBWSTOENR7           : std_logic_vector(11 downto 2)
                                     := "0000110100";
-- SMBWSTOENR7 at offset 0x0D0

constant HADDR_SMBWSTWENR7           : std_logic_vector(11 downto 2)
                                     := "0000110101";
-- SMBWSTWENR7 at offset 0x0D4

constant HADDR_SMBCR7                : std_logic_vector(11 downto 2)
                                     := "0000110110";
-- SMBCR7 at offset 0x0D8

constant HADDR_SMBSR7                : std_logic_vector(11 downto 2)
                                     := "0000110111";
-- SMBSR7 at offset 0x0DC

constant HADDR_SMBEWS                : std_logic_vector(11 downto 2)
                                     := "0000111000";
-- SMBEWS at offset 0x0E0

-- -----------------------------------------------------------------------------
-- SMC Identification register's address constant definitions
-- -----------------------------------------------------------------------------
constant HADDR_SMCPeriphID0          : std_logic_vector(11 downto 2)
                                     := "1111111000";
-- SMCPeriphID0 at offset 0xFE0

constant HADDR_SMCPeriphID1          : std_logic_vector(11 downto 2)
                                     := "1111111001";
-- SMCPeriphID1 at offset 0xFE4

constant HADDR_SMCPeriphID2          : std_logic_vector(11 downto 2)
                                     := "1111111010";
-- SMCPeriphID2 at offset 0xFE8

constant HADDR_SMCPeriphID3          : std_logic_vector(11 downto 2)
                                     := "1111111011";
-- SMCPeriphID3 at offset 0xFEC

constant HADDR_SMCPCellID0           : std_logic_vector(11 downto 2)
                                     := "1111111100";
-- SMCPCellID0 at offset 0xFF0

constant HADDR_SMCPCellID1           : std_logic_vector(11 downto 2)
                                     := "1111111101";
-- SMCPCellID1 at offset 0xFF4

constant HADDR_SMCPCellID2           : std_logic_vector(11 downto 2)
                                     := "1111111110";
-- SMCPCellID2 at offset 0xFF8

constant HADDR_SMCPCellID3           : std_logic_vector(11 downto 2)
                                     := "1111111111";
-- SMCPCellID3 at offset 0xFFC

-- -----------------------------------------------------------------------------
-- SMC Transfer Control State machine's state definition constants.
-- -----------------------------------------------------------------------------
constant ST_TSM_IDLE      : std_logic_vector(3 downto 0) := "0000";
-- Idle State

constant ST_TSM_BUFWR     : std_logic_vector(3 downto 0) := "0001";
-- Internal Buffer Write State

constant ST_TSM_WENCNT    : std_logic_vector(3 downto 0) := "0010";
-- Write Enable Count State

constant ST_TSM_MEMWR     : std_logic_vector(3 downto 0) := "0011";
-- Memory Write State

constant ST_TSM_SEQWR     : std_logic_vector(3 downto 0) := "0100";
-- Sequential Write State

constant ST_TSM_TURNARND  : std_logic_vector(3 downto 0) := "0101";
-- Turn Around State

constant ST_TSM_OENCNT    : std_logic_vector(3 downto 0) := "0110";
-- Output Enable Count State

constant ST_TSM_MEMRD     : std_logic_vector(3 downto 0) := "0111";
-- Memory Read State

constant ST_TSM_AHBRD     : std_logic_vector(3 downto 0) := "1111";
-- AHB Bus Read State

-- -----------------------------------------------------------------------------
-- Timer State Machines's State definition
-- -----------------------------------------------------------------------------
constant ST_TW_IDLE       : std_logic_vector(1 downto 0) := "00";
-- Timer Idle State

constant ST_TW_COUNT      : std_logic_vector(1 downto 0) := "01";
-- Timer Count State

constant ST_TW_EXTWAIT    : std_logic_vector(1 downto 0) := "11";
-- External Wait State where the SMC is controlled by SMWAIT

end SmcPackage;

-- --============================== End ======================================--
