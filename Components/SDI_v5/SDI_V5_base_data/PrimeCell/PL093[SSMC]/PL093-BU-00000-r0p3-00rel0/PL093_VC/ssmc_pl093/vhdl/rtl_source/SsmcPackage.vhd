-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SsmcPackage.vhd.rca
-- File Revision          : 1.11
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           The constants used in the SSMC system is defined in this block.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


package SsmcPackage is

-- -----------------------------------------------------------------------------
-- Zero fill for register reads to return zeros in unused bit positions
-- -----------------------------------------------------------------------------
constant ZEROFILL             : std_logic_vector(31 downto 0)
                              := "00000000000000000000000000000000";

-- -----------------------------------------------------------------------------
-- AHB HRESP constant definitions
-- -----------------------------------------------------------------------------
constant HRESP_OKAY           : std_logic_vector(1 downto 0) := "00";
constant HRESP_ERROR          : std_logic_vector(1 downto 0) := "01";

-- -----------------------------------------------------------------------------
-- AHB HTRANS constant definitions
-- -----------------------------------------------------------------------------
constant HTRANS_IDLE          : std_logic_vector(1 downto 0) := "00";
constant HTRANS_BUSY          : std_logic_vector(1 downto 0) := "01";
constant HTRANS_NSEQ          : std_logic_vector(1 downto 0) := "10";
constant HTRANS_SEQ           : std_logic_vector(1 downto 0) := "11";

-- -----------------------------------------------------------------------------
-- AHB HBURST type constant definitions
-- -----------------------------------------------------------------------------
constant HBURST_SINGLE        : std_logic_vector(2 downto 0) := "000";
constant HBURST_INCR          : std_logic_vector(2 downto 0) := "001";
constant HBURST_WRAP4         : std_logic_vector(2 downto 0) := "010";
constant HBURST_INCR4         : std_logic_vector(2 downto 0) := "011";
constant HBURST_WRAP8         : std_logic_vector(2 downto 0) := "100";
constant HBURST_INCR8         : std_logic_vector(2 downto 0) := "101";
constant HBURST_WRAP16        : std_logic_vector(2 downto 0) := "110";
constant HBURST_INCR16        : std_logic_vector(2 downto 0) := "111";

-- -----------------------------------------------------------------------------
-- AHB HSIZE constant definitions
-- -----------------------------------------------------------------------------
constant HSIZE_BYTE           : std_logic_vector(2 downto 0) := "000";
constant HSIZE_HWORD          : std_logic_vector(2 downto 0) := "001";
constant HSIZE_WORD           : std_logic_vector(2 downto 0) := "010";

-- -----------------------------------------------------------------------------
-- Memory size constant definitions
-- -----------------------------------------------------------------------------
constant MEM_BYTE           : std_logic_vector(1 downto 0) := "00";
constant MEM_HWORD          : std_logic_vector(1 downto 0) := "01";
constant MEM_WORD           : std_logic_vector(1 downto 0) := "10";

-- -----------------------------------------------------------------------------
-- Memory Burst constant definitions
-- -----------------------------------------------------------------------------
constant FOUR_TXR           : std_logic_vector(1 downto 0) := "00";
constant EIGHT_TXR          : std_logic_vector(1 downto 0) := "01";
constant SIXTEEN_TXR        : std_logic_vector(1 downto 0) := "10";
constant CONTINUOUS         : std_logic_vector(1 downto 0) := "11";

-- -----------------------------------------------------------------------------
-- SSMC Control register's address constant definitions
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Bank0 Registers
-- -----------------------------------------------------------------------------
constant HADDR_SMBIDCYR0      : std_logic_vector(11 downto 2) := "0000000000";
-- SMBIDCYR0 at offset 0x000

constant HADDR_SMBWSTRDR0     : std_logic_vector(11 downto 2) := "0000000001";
-- SMBWSTRDR0 at offset 0x004

constant HADDR_SMBWSTWRR0     : std_logic_vector(11 downto 2) := "0000000010";
-- SMBWSTWRR0 at offset 0x008

constant HADDR_SMBWSTOENR0    : std_logic_vector(11 downto 2) := "0000000011";
-- SMBWSTOENR0 at offset 0x00C

constant HADDR_SMBWSTWENR0    : std_logic_vector(11 downto 2) := "0000000100";
-- SMBWSTWENR0 at offset 0x010

constant HADDR_SMBCR0         : std_logic_vector(11 downto 2) := "0000000101";
-- SMBCR0 at offset 0x014

constant HADDR_SMBSR0         : std_logic_vector(11 downto 2) := "0000000110";
-- SMBSR0 at offset 0x018

constant HADDR_SMBWSTBRDR0    : std_logic_vector(11 downto 2) := "0000000111";
-- SMBWSTBRDR0 at offset 0x01C

-- -----------------------------------------------------------------------------
-- Bank1 Registers
-- -----------------------------------------------------------------------------
constant HADDR_SMBIDCYR1      : std_logic_vector(11 downto 2) := "0000001000";
-- SMBIDCYR1 at offset 0x020

constant HADDR_SMBWSTRDR1     : std_logic_vector(11 downto 2) := "0000001001";
-- SMBWSTRDR1 at offset 0x024

constant HADDR_SMBWSTWRR1     : std_logic_vector(11 downto 2) := "0000001010";
-- SMBWSTWRR1 at offset 0x028

constant HADDR_SMBWSTOENR1    : std_logic_vector(11 downto 2) := "0000001011";
-- SMBWSTOENR1 at offset 0x02C

constant HADDR_SMBWSTWENR1    : std_logic_vector(11 downto 2) := "0000001100";
-- SMBWSTWENR1 at offset 0x030

constant HADDR_SMBCR1         : std_logic_vector(11 downto 2) := "0000001101";
-- SMBCR1 at offset 0x034

constant HADDR_SMBSR1         : std_logic_vector(11 downto 2) := "0000001110";
-- SMBSR1 at offset 0x038

constant HADDR_SMBWSTBRDR1    : std_logic_vector(11 downto 2) := "0000001111";
-- SMBWSTBRDR1 at offset 0x03C

-- -----------------------------------------------------------------------------
-- Bank2 Registers
-- -----------------------------------------------------------------------------
constant HADDR_SMBIDCYR2      : std_logic_vector(11 downto 2) := "0000010000";
-- SMBIDCYR2 at offset 0x040

constant HADDR_SMBWSTRDR2     : std_logic_vector(11 downto 2) := "0000010001";
-- SMBWSTRDR2 at offset 0x044

constant HADDR_SMBWSTWRR2     : std_logic_vector(11 downto 2) := "0000010010";
-- SMBWSTWRR2 at offset 0x048

constant HADDR_SMBWSTOENR2    : std_logic_vector(11 downto 2) := "0000010011";
-- SMBWSTOENR2 at offset 0x04C

constant HADDR_SMBWSTWENR2    : std_logic_vector(11 downto 2) := "0000010100";
-- SMBWSTWENR2 at offset 0x050

constant HADDR_SMBCR2         : std_logic_vector(11 downto 2) := "0000010101";
-- SMBCR2 at offset 0x054

constant HADDR_SMBSR2         : std_logic_vector(11 downto 2) := "0000010110";
-- SMBSR2 at offset 0x058

constant HADDR_SMBWSTBRDR2    : std_logic_vector(11 downto 2) := "0000010111";
-- SMBWSTBRDR2 at offset 0x05C

-- -----------------------------------------------------------------------------
-- Bank3 Registers
-- -----------------------------------------------------------------------------
constant HADDR_SMBIDCYR3      : std_logic_vector(11 downto 2) := "0000011000";
-- SMBIDCYR3 at offset 0x060

constant HADDR_SMBWSTRDR3     : std_logic_vector(11 downto 2) := "0000011001";
-- SMBWSTRDR3 at offset 0x064

constant HADDR_SMBWSTWRR3     : std_logic_vector(11 downto 2) := "0000011010";
-- SMBWSTWRR3 at offset 0x068

constant HADDR_SMBWSTOENR3    : std_logic_vector(11 downto 2) := "0000011011";
-- SMBWSTOENR3 at offset 0x06C

constant HADDR_SMBWSTWENR3    : std_logic_vector(11 downto 2) := "0000011100";
-- SMBWSTWENR3 at offset 0x070

constant HADDR_SMBCR3         : std_logic_vector(11 downto 2) := "0000011101";
-- SMBCR3 at offset 0x074

constant HADDR_SMBSR3         : std_logic_vector(11 downto 2) := "0000011110";
-- SMBSR3 at offset 0x078

constant HADDR_SMBWSTBRDR3    : std_logic_vector(11 downto 2) := "0000011111";
-- SMBWSTBRDR3 at offset 0x07C

-- -----------------------------------------------------------------------------
-- Bank4 Registers
-- -----------------------------------------------------------------------------
constant HADDR_SMBIDCYR4      : std_logic_vector(11 downto 2) := "0000100000";
-- SMBIDCYR4 at offset 0x080

constant HADDR_SMBWSTRDR4     : std_logic_vector(11 downto 2) := "0000100001";
-- SMBWSTRDR4 at offset 0x084

constant HADDR_SMBWSTWRR4     : std_logic_vector(11 downto 2) := "0000100010";
-- SMBWSTWRR4 at offset 0x088

constant HADDR_SMBWSTOENR4    : std_logic_vector(11 downto 2) := "0000100011";
-- SMBWSTOENR4 at offset 0x08C

constant HADDR_SMBWSTWENR4    : std_logic_vector(11 downto 2) := "0000100100";
-- SMBWSTWENR4 at offset 0x090

constant HADDR_SMBCR4         : std_logic_vector(11 downto 2) := "0000100101";
-- SMBCR4 at offset 0x094

constant HADDR_SMBSR4         : std_logic_vector(11 downto 2) := "0000100110";
-- SMBSR4 at offset 0x098

constant HADDR_SMBWSTBRDR4    : std_logic_vector(11 downto 2) := "0000100111";
-- SMBWSTBRDR4 at offset 0x09C

-- -----------------------------------------------------------------------------
-- Bank5 Registers
-- -----------------------------------------------------------------------------
constant HADDR_SMBIDCYR5      : std_logic_vector(11 downto 2) := "0000101000";
-- SMBIDCYR5 at offset 0x0A0

constant HADDR_SMBWSTRDR5     : std_logic_vector(11 downto 2) := "0000101001";
-- SMBWSTRDR5 at offset 0x0A4

constant HADDR_SMBWSTWRR5     : std_logic_vector(11 downto 2) := "0000101010";
-- SMBWSTWRR5 at offset 0x0A8

constant HADDR_SMBWSTOENR5    : std_logic_vector(11 downto 2) := "0000101011";
-- SMBWSTOENR5 at offset 0x0AC

constant HADDR_SMBWSTWENR5    : std_logic_vector(11 downto 2) := "0000101100";
-- SMBWSTWENR5 at offset 0x0B0

constant HADDR_SMBCR5         : std_logic_vector(11 downto 2) := "0000101101";
-- SMBCR5 at offset 0x0B4

constant HADDR_SMBSR5         : std_logic_vector(11 downto 2) := "0000101110";
-- SMBSR5 at offset 0x0B8

constant HADDR_SMBWSTBRDR5    : std_logic_vector(11 downto 2) := "0000101111";
-- SMBWSTBRDR5 at offset 0x0BC

-- -----------------------------------------------------------------------------
-- Bank6 Registers
-- -----------------------------------------------------------------------------
constant HADDR_SMBIDCYR6      : std_logic_vector(11 downto 2) := "0000110000";
-- SMBIDCYR6 at offset 0x0C0

constant HADDR_SMBWSTRDR6     : std_logic_vector(11 downto 2) := "0000110001";
-- SMBWSTRDR6 at offset 0x0C4

constant HADDR_SMBWSTWRR6     : std_logic_vector(11 downto 2) := "0000110010";
-- SMBWSTWRR6 at offset 0x0C8

constant HADDR_SMBWSTOENR6    : std_logic_vector(11 downto 2) := "0000110011";
-- SMBWSTOENR6 at offset 0x0CC

constant HADDR_SMBWSTWENR6    : std_logic_vector(11 downto 2) := "0000110100";
-- SMBWSTWENR6 at offset 0x0D0

constant HADDR_SMBCR6         : std_logic_vector(11 downto 2) := "0000110101";
-- SMBCR6 at offset 0x0D4

constant HADDR_SMBSR6         : std_logic_vector(11 downto 2) := "0000110110";
-- SMBSR6 at offset 0x0D8

constant HADDR_SMBWSTBRDR6    : std_logic_vector(11 downto 2) := "0000110111";
-- SMBWSTBRDR6 at offset 0x0DC

-- -----------------------------------------------------------------------------
-- Bank7 Registers
-- -----------------------------------------------------------------------------
constant HADDR_SMBIDCYR7      : std_logic_vector(11 downto 2) := "0000111000";
-- SMBIDCYR7 at offset 0x0E0

constant HADDR_SMBWSTRDR7     : std_logic_vector(11 downto 2) := "0000111001";
-- SMBWSTRDR7 at offset 0x0E4

constant HADDR_SMBWSTWRR7     : std_logic_vector(11 downto 2) := "0000111010";
-- SMBWSTWRR7 at offset 0x0E8

constant HADDR_SMBWSTOENR7    : std_logic_vector(11 downto 2) := "0000111011";
-- SMBWSTOENR7 at offset 0x0EC

constant HADDR_SMBWSTWENR7    : std_logic_vector(11 downto 2) := "0000111100";
-- SMBWSTWENR7 at offset 0x0F0

constant HADDR_SMBCR7         : std_logic_vector(11 downto 2) := "0000111101";
-- SMBCR7 at offset 0x0F4

constant HADDR_SMBSR7         : std_logic_vector(11 downto 2) := "0000111110";
-- SMBSR7 at offset 0x0F8

constant HADDR_SMBWSTBRDR7    : std_logic_vector(11 downto 2) := "0000111111";
-- SMBWSTBRDR7 at offset 0x0FC

-- -----------------------------------------------------------------------------
-- Status, Control and Test Register's address constant definitions
-- -----------------------------------------------------------------------------
constant HADDR_SMSR           : std_logic_vector(11 downto 2) := "0010000000";
-- SSMCSR at offset 0x200

constant HADDR_SMCR           : std_logic_vector(11 downto 2) := "0010000001";
-- SSMCCR at offset 0x204

constant HADDR_SMITCR         : std_logic_vector(11 downto 2) := "0010000010";
-- SSMCITCR at offset 0x208

constant HADDR_SMITIP         : std_logic_vector(11 downto 2) := "0010000011";
-- SSMCITIP at offset 0x20C

constant HADDR_SMITOP         : std_logic_vector(11 downto 2) := "0010000100";
-- SSMCITOP at offset 0x210

constant HADDR_SMDLL          : std_logic_vector(11 downto 2) := "0010000101";
-- SSMCITOP at offset 0x214

-- -----------------------------------------------------------------------------
-- SSMC Identification register's address constant definitions
-- -----------------------------------------------------------------------------
constant HADDR_SSMCPERIPHID0  : std_logic_vector(11 downto 2) := "1111111000";
-- SSMCPeriphID0 at offset 0xFE0

constant HADDR_SSMCPERIPHID1  : std_logic_vector(11 downto 2) := "1111111001";
-- SSMCPeriphID1 at offset 0xFE4

constant HADDR_SSMCPERIPHID2  : std_logic_vector(11 downto 2) := "1111111010";
-- SSMCPeriphID2 at offset 0xFE8

constant HADDR_SSMCPERIPHID3  : std_logic_vector(11 downto 2) := "1111111011";
-- SSMCPeriphID3 at offset 0xFEC

constant HADDR_SSMCPCELLID0   : std_logic_vector(11 downto 2) := "1111111100";
-- SSMCPCellID0 at offset 0xFF0

constant HADDR_SSMCPCELLID1   : std_logic_vector(11 downto 2) := "1111111101";
-- SSMCPCellID1 at offset 0xFF4

constant HADDR_SSMCPCELLID2   : std_logic_vector(11 downto 2) := "1111111110";
-- SSMCPCellID2 at offset 0xFF8

constant HADDR_SSMCPCELLID3   : std_logic_vector(11 downto 2) := "1111111111";
-- SSMCPCellID3 at offset 0xFFC


-- -----------------------------------------------------------------------------
-- SSMC AHB Register Slave  Control SM's state definition constants.
-- -----------------------------------------------------------------------------
constant ST_REG_NOT_SEL       : std_logic_vector := "0001";
-- Idle State for Register accesses SM

constant ST_REG_WRITE         : std_logic_vector := "0010";
-- Write State for Register accesses SM

constant ST_REG_READ          : std_logic_vector := "0100";
-- Read State for Register accesses SM

constant ST_REG_ERROR         : std_logic_vector := "1000";
-- Error State for Register accesses SM

-- -----------------------------------------------------------------------------
-- SSMC AHB Register Slave  Control SM's state definition constants.
-- -----------------------------------------------------------------------------
constant ST_MEM_NOT_SEL       : std_logic_vector := "00001";
-- SM enters this state when this slave is not selected

constant ST_MEM_IDLE_RESP     : std_logic_vector := "00010";
-- SM enters this state when Master comes with BUSY or IDLE access

constant ST_MEM_WRITE         : std_logic_vector := "00100";
-- SM enters this state when Master comes with NSEQ or SEQ Write access

constant ST_MEM_READ          : std_logic_vector := "01000";
-- SM enters this state when Master comes with NSEQ or SEQ Read access

constant ST_MEM_ERROR         : std_logic_vector := "10000";
-- SM enters this state when Master comes with Error access

-- -----------------------------------------------------------------------------
-- SSMC Memory TSM state definition constants.
-- -----------------------------------------------------------------------------
constant ST_NO_REQ            : std_logic_vector := "00000000001";
-- SM enters this state when there is no Memory access request

constant ST_READ              : std_logic_vector := "00000000010";
-- SM enters this state when there is Memory read access request

constant ST_BURST_READ        : std_logic_vector := "00000000100";
-- SM enters this state when there is Burst Memory read access request

constant ST_WRITE             : std_logic_vector := "00000001000";
-- SM enters this state when there is Memory write access request

constant ST_BURST_WRITE       : std_logic_vector := "00000010000";
-- SM enters this state when there is Burst Memory write access request

constant ST_TURNAROUND        : std_logic_vector := "00000100000";
-- SM enters this state when Turnaround has to be performed

constant ST_WAIT_TXRONBUS     : std_logic_vector := "00001000000";
-- SM enters this state when decision has to be taken on next pipelined access

constant ST_MEM_DEGRANTED     : std_logic_vector := "00010000000";
-- SM enters this state when Controller loses the Memory Bus Grant

constant ST_WAIT_ASSERTED     : std_logic_vector := "00100000000";
-- SM enters this state when Wait is asserted for wait enabled access

constant ST_WAIT_DEASSERTED   : std_logic_vector := "01000000000";
-- SM enters this state when Wait is de-asserted for wait enabled access

constant ST_CANCEL_WAIT       : std_logic_vector := "10000000000";
-- SM enters this state when Wait transfer is cancelled for wait enabled access

-- -----------------------------------------------------------------------------
-- Memory Bank Select decode's
-- -----------------------------------------------------------------------------
constant BANK0                : std_logic_vector := "00000001";
-- Memory Bank0 Selected

constant BANK1                : std_logic_vector := "00000010";
-- Memory Bank1 Selected

constant BANK2                : std_logic_vector := "00000100";
-- Memory Bank2 Selected

constant BANK3                : std_logic_vector := "00001000";
-- Memory Bank3 Selected

constant BANK4                : std_logic_vector := "00010000";
-- Memory Bank4 Selected

constant BANK5                : std_logic_vector := "00100000";
-- Memory Bank5 Selected

constant BANK6                : std_logic_vector := "01000000";
-- Memory Bank6 Selected

constant BANK7                : std_logic_vector := "10000000";
-- Memory Bank7 Selected

end SsmcPackage;

-- --============================== End ======================================--
