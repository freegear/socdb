// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcParams.v.rca
// File Revision          : 1.10
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           The constants used in the SSMC system is defined in this block.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------
// Zero fill for register reads to return zeros in unused bit positions
// -----------------------------------------------------------------------------
`define ZEROFILL             32'b00000000000000000000000000000000

// -----------------------------------------------------------------------------
// AHB HRESP constant definitions
// -----------------------------------------------------------------------------
`define HRESP_OKAY           2'b00
`define HRESP_ERROR          2'b01

// -----------------------------------------------------------------------------
// AHB HTRANS constant definitions
// -----------------------------------------------------------------------------
`define HTRANS_IDLE          2'b00
`define HTRANS_BUSY          2'b01
`define HTRANS_NSEQ          2'b10
`define HTRANS_SEQ           2'b11

// -----------------------------------------------------------------------------
// AHB HBURST type constant definitions
// -----------------------------------------------------------------------------
`define HBURST_SINGLE        3'b000
`define HBURST_INCR          3'b001
`define HBURST_WRAP4         3'b010
`define HBURST_INCR4         3'b011
`define HBURST_WRAP8         3'b100
`define HBURST_INCR8         3'b101
`define HBURST_WRAP16        3'b110
`define HBURST_INCR16        3'b111

// -----------------------------------------------------------------------------
// AHB HSIZE constant definitions
// -----------------------------------------------------------------------------
`define HSIZE_BYTE           3'b000
`define HSIZE_HWORD          3'b001
`define HSIZE_WORD           3'b010

// -----------------------------------------------------------------------------
// Memory size constant definitions
// -----------------------------------------------------------------------------
`define MEM_BYTE           2'b00
`define MEM_HWORD          2'b01
`define MEM_WORD           2'b10

// -----------------------------------------------------------------------------
// Memory Burst constant definitions
// -----------------------------------------------------------------------------
`define FOUR_TXR           2'b00
`define EIGHT_TXR          2'b01
`define SIXTEEN_TXR        2'b10
`define CONTINUOUS         2'b11

// -----------------------------------------------------------------------------
// SSMC Control register's address constant definitions
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Bank0 Registers
// -----------------------------------------------------------------------------
`define HADDR_SMBIDCYR0      10'b0000000000
// SMBIDCYR0 at offset 0x000

`define HADDR_SMBWSTRDR0     10'b0000000001
// SMBWSTRDR0 at offset 0x004

`define HADDR_SMBWSTWRR0     10'b0000000010
// SMBWSTWRR0 at offset 0x008

`define HADDR_SMBWSTOENR0    10'b0000000011
// SMBWSTOENR0 at offset 0x00C

`define HADDR_SMBWSTWENR0    10'b0000000100
// SMBWSTWENR0 at offset 0x010

`define HADDR_SMBCR0         10'b0000000101
// SMBCR0 at offset 0x014

`define HADDR_SMBSR0         10'b0000000110
// SMBSR0 at offset 0x018

`define HADDR_SMBWSTBRDR0    10'b0000000111
// SMBWSTBRDR0 at offset 0x01C

// -----------------------------------------------------------------------------
// Bank1 Registers
// -----------------------------------------------------------------------------
`define HADDR_SMBIDCYR1      10'b0000001000
// SMBIDCYR1 at offset 0x020

`define HADDR_SMBWSTRDR1     10'b0000001001
// SMBWSTRDR1 at offset 0x024

`define HADDR_SMBWSTWRR1     10'b0000001010
// SMBWSTWRR1 at offset 0x028

`define HADDR_SMBWSTOENR1    10'b0000001011
// SMBWSTOENR1 at offset 0x02C

`define HADDR_SMBWSTWENR1    10'b0000001100
// SMBWSTWENR1 at offset 0x030

`define HADDR_SMBCR1         10'b0000001101
// SMBCR1 at offset 0x034

`define HADDR_SMBSR1         10'b0000001110
// SMBSR1 at offset 0x038

`define HADDR_SMBWSTBRDR1    10'b0000001111
// SMBWSTBRDR1 at offset 0x03C

// -----------------------------------------------------------------------------
// Bank2 Registers
// -----------------------------------------------------------------------------
`define HADDR_SMBIDCYR2      10'b0000010000
// SMBIDCYR2 at offset 0x040

`define HADDR_SMBWSTRDR2     10'b0000010001
// SMBWSTRDR2 at offset 0x044

`define HADDR_SMBWSTWRR2     10'b0000010010
// SMBWSTWRR2 at offset 0x048

`define HADDR_SMBWSTOENR2    10'b0000010011
// SMBWSTOENR2 at offset 0x04C

`define HADDR_SMBWSTWENR2    10'b0000010100
// SMBWSTWENR2 at offset 0x050

`define HADDR_SMBCR2         10'b0000010101
// SMBCR2 at offset 0x054

`define HADDR_SMBSR2         10'b0000010110
// SMBSR2 at offset 0x058

`define HADDR_SMBWSTBRDR2    10'b0000010111
// SMBWSTBRDR2 at offset 0x05C

// -----------------------------------------------------------------------------
// Bank3 Registers
// -----------------------------------------------------------------------------
`define HADDR_SMBIDCYR3      10'b0000011000
// SMBIDCYR3 at offset 0x060

`define HADDR_SMBWSTRDR3     10'b0000011001
// SMBWSTRDR3 at offset 0x064

`define HADDR_SMBWSTWRR3     10'b0000011010
// SMBWSTWRR3 at offset 0x068

`define HADDR_SMBWSTOENR3    10'b0000011011
// SMBWSTOENR3 at offset 0x06C

`define HADDR_SMBWSTWENR3    10'b0000011100
// SMBWSTWENR3 at offset 0x070

`define HADDR_SMBCR3         10'b0000011101
// SMBCR3 at offset 0x074

`define HADDR_SMBSR3         10'b0000011110
// SMBSR3 at offset 0x078

`define HADDR_SMBWSTBRDR3    10'b0000011111
// SMBWSTBRDR3 at offset 0x07C

// -----------------------------------------------------------------------------
// Bank4 Registers
// -----------------------------------------------------------------------------
`define HADDR_SMBIDCYR4      10'b0000100000
// SMBIDCYR4 at offset 0x080

`define HADDR_SMBWSTRDR4     10'b0000100001
// SMBWSTRDR4 at offset 0x084

`define HADDR_SMBWSTWRR4     10'b0000100010
// SMBWSTWRR4 at offset 0x088

`define HADDR_SMBWSTOENR4    10'b0000100011
// SMBWSTOENR4 at offset 0x08C

`define HADDR_SMBWSTWENR4    10'b0000100100
// SMBWSTWENR4 at offset 0x090

`define HADDR_SMBCR4         10'b0000100101
// SMBCR4 at offset 0x094

`define HADDR_SMBSR4         10'b0000100110
// SMBSR4 at offset 0x098

`define HADDR_SMBWSTBRDR4    10'b0000100111
// SMBWSTBRDR4 at offset 0x09C

// -----------------------------------------------------------------------------
// Bank5 Registers
// -----------------------------------------------------------------------------
`define HADDR_SMBIDCYR5      10'b0000101000
// SMBIDCYR5 at offset 0x0A0

`define HADDR_SMBWSTRDR5     10'b0000101001
// SMBWSTRDR5 at offset 0x0A4

`define HADDR_SMBWSTWRR5     10'b0000101010
// SMBWSTWRR5 at offset 0x0A8

`define HADDR_SMBWSTOENR5    10'b0000101011
// SMBWSTOENR5 at offset 0x0AC

`define HADDR_SMBWSTWENR5    10'b0000101100
// SMBWSTWENR5 at offset 0x0B0

`define HADDR_SMBCR5         10'b0000101101
// SMBCR5 at offset 0x0B4

`define HADDR_SMBSR5         10'b0000101110
// SMBSR5 at offset 0x0B8

`define HADDR_SMBWSTBRDR5    10'b0000101111
// SMBWSTBRDR5 at offset 0x0BC

// -----------------------------------------------------------------------------
// Bank6 Registers
// -----------------------------------------------------------------------------
`define HADDR_SMBIDCYR6      10'b0000110000
// SMBIDCYR6 at offset 0x0C0

`define HADDR_SMBWSTRDR6     10'b0000110001
// SMBWSTRDR6 at offset 0x0C4

`define HADDR_SMBWSTWRR6     10'b0000110010
// SMBWSTWRR6 at offset 0x0C8

`define HADDR_SMBWSTOENR6    10'b0000110011
// SMBWSTOENR6 at offset 0x0CC

`define HADDR_SMBWSTWENR6    10'b0000110100
// SMBWSTWENR6 at offset 0x0D0

`define HADDR_SMBCR6         10'b0000110101
// SMBCR6 at offset 0x0D4

`define HADDR_SMBSR6         10'b0000110110
// SMBSR6 at offset 0x0D8

`define HADDR_SMBWSTBRDR6    10'b0000110111
// SMBWSTBRDR6 at offset 0x0DC

// -----------------------------------------------------------------------------
// Bank7 Registers
// -----------------------------------------------------------------------------
`define HADDR_SMBIDCYR7      10'b0000111000
// SMBIDCYR7 at offset 0x0E0

`define HADDR_SMBWSTRDR7     10'b0000111001
// SMBWSTRDR7 at offset 0x0E4

`define HADDR_SMBWSTWRR7     10'b0000111010
// SMBWSTWRR7 at offset 0x0E8

`define HADDR_SMBWSTOENR7    10'b0000111011
// SMBWSTOENR7 at offset 0x0EC

`define HADDR_SMBWSTWENR7    10'b0000111100
// SMBWSTWENR7 at offset 0x0F0

`define HADDR_SMBCR7         10'b0000111101
// SMBCR7 at offset 0x0F4

`define HADDR_SMBSR7         10'b0000111110
// SMBSR7 at offset 0x0F8

`define HADDR_SMBWSTBRDR7    10'b0000111111
// SMBWSTBRDR7 at offset 0x0FC

// -----------------------------------------------------------------------------
// Status, Control and Test Register's address constant definitions
// -----------------------------------------------------------------------------
`define HADDR_SMSR           10'b0010000000
// SSMCSR at offset 0x200

`define HADDR_SMCR           10'b0010000001
// SSMCCR at offset 0x204

`define HADDR_SMITCR         10'b0010000010
// SSMCITCR at offset 0x208

`define HADDR_SMITIP         10'b0010000011
// SSMCITIP at offset 0x20C

`define HADDR_SMITOP         10'b0010000100
// SSMCITOP at offset 0x210

`define HADDR_SMDLL          10'b0010000101
// SSMCITOP at offset 0x214

// -----------------------------------------------------------------------------
// SSMC Identification register's address constant definitions
// -----------------------------------------------------------------------------
`define HADDR_SSMCPERIPHID0  10'b1111111000
// SSMCPeriphID0 at offset 0xFE0

`define HADDR_SSMCPERIPHID1  10'b1111111001
// SSMCPeriphID1 at offset 0xFE4

`define HADDR_SSMCPERIPHID2  10'b1111111010
// SSMCPeriphID2 at offset 0xFE8

`define HADDR_SSMCPERIPHID3  10'b1111111011
// SSMCPeriphID3 at offset 0xFEC

`define HADDR_SSMCPCELLID0   10'b1111111100
// SSMCPCellID0 at offset 0xFF0

`define HADDR_SSMCPCELLID1   10'b1111111101
// SSMCPCellID1 at offset 0xFF4

`define HADDR_SSMCPCELLID2   10'b1111111110
// SSMCPCellID2 at offset 0xFF8

`define HADDR_SSMCPCELLID3   10'b1111111111
// SSMCPCellID3 at offset 0xFFC


// -----------------------------------------------------------------------------
// SSMC AHB Register Slave  Control SM's state definition constants.
// -----------------------------------------------------------------------------
`define ST_REG_NOT_SEL       4'b0001
// Idle State for Register accesses SM

`define ST_REG_WRITE         4'b0010
// Write State for Register accesses SM

`define ST_REG_READ          4'b0100
// Read State for Register accesses SM

`define ST_REG_ERROR         4'b1000
// Error State for Register accesses SM

// -----------------------------------------------------------------------------
// SSMC AHB Register Slave  Control SM's state definition constants.
// -----------------------------------------------------------------------------
`define ST_MEM_NOT_SEL       5'b00001
// SM enters this state when this slave is not selected

`define ST_MEM_IDLE_RESP     5'b00010
// SM enters this state when Master comes with BUSY or IDLE access

`define ST_MEM_WRITE         5'b00100
// SM enters this state when Master comes with NSEQ or SEQ Write access

`define ST_MEM_READ          5'b01000
// SM enters this state when Master comes with NSEQ or SEQ Read access

`define ST_MEM_ERROR         5'b10000
// SM enters this state when Master comes with Error access

// -----------------------------------------------------------------------------
// SSMC Memory TSM state definition constants.
// -----------------------------------------------------------------------------
`define ST_NO_REQ            11'b00000000001
// SM enters this state when there is no Memory access request

`define ST_READ              11'b00000000010
// SM enters this state when there is Memory read access request

`define ST_BURST_READ        11'b00000000100
// SM enters this state when there is Burst Memory read access request

`define ST_WRITE             11'b00000001000
// SM enters this state when there is Memory write access request

`define ST_BURST_WRITE       11'b00000010000
// SM enters this state when there is Burst Memory write access request

`define ST_TURNAROUND        11'b00000100000
// SM enters this state when Turnaround has to be performed

`define ST_WAIT_TXRONBUS     11'b00001000000
// SM enters this state when decision has to be taken on next pipelined access

`define ST_MEM_DEGRANTED     11'b00010000000
// SM enters this state when Controller loses the Memory Bus Grant

`define ST_WAIT_ASSERTED     11'b00100000000
// SM enters this state when Wait is asserted for wait enabled access

`define ST_WAIT_DEASSERTED   11'b01000000000
// SM enters this state when Wait is de-asserted for wait enabled access

`define ST_CANCEL_WAIT       11'b10000000000
// SM enters this state when Wait transfer is cancelled for wait enabled access

// -----------------------------------------------------------------------------
// Memory Bank Select decode's
// -----------------------------------------------------------------------------
`define BANK0                8'b00000001
// Memory Bank0 Selected

`define BANK1                8'b00000010
// Memory Bank1 Selected

`define BANK2                8'b00000100
// Memory Bank2 Selected

`define BANK3                8'b00001000
// Memory Bank3 Selected

`define BANK4                8'b00010000
// Memory Bank4 Selected

`define BANK5                8'b00100000
// Memory Bank5 Selected

`define BANK6                8'b01000000
// Memory Bank6 Selected

`define BANK7                8'b10000000
// Memory Bank7 Selected

// --============================== End ======================================--
