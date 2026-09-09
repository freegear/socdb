// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SmcParams.v.rca
// File Revision          : 1.20
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           The `defines used in the SMC system is defined in this block.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------
// AHB HRESP `define definitions
// -----------------------------------------------------------------------------
`define H_OKAY  2'b00
`define H_ERROR 2'b01

// -----------------------------------------------------------------------------
// AHB HTRANS `define definitions
// -----------------------------------------------------------------------------
`define T_IDLE   2'b00
`define T_BUSY   2'b01
`define T_NONSEQ 2'b10
`define T_SEQ    2'b11

// -----------------------------------------------------------------------------
// AHB HBURST type `define definitions
// -----------------------------------------------------------------------------
`define SINGLE 3'b000
`define INCR   3'b001
`define WRAP4  3'b010
`define INCR4  3'b011
`define WRAP8  3'b100
`define INCR8  3'b101
`define WRAP16 3'b110
`define INCR16 3'b111

// -----------------------------------------------------------------------------
// SMC Control register's address `define definitions
// -----------------------------------------------------------------------------
`define HADDR_SMBIDCYR0   10'b0000000000
// SMBIDCYR0 at offset 0x000

`define HADDR_SMBWST1R0   10'b0000000001
// SMBWST1R0 at offset 0x004

`define HADDR_SMBWST2R0   10'b0000000010
// SMBWST2R0 at offset 0x008

`define HADDR_SMBWSTOENR0 10'b0000000011
// SMBWSTOENR0 at offset 0x00C

`define HADDR_SMBWSTWENR0 10'b0000000100
// SMBWSTWENR0 at offset 0x010

`define HADDR_SMBCR0      10'b0000000101
// SMBCR0 at offset 0x014

`define HADDR_SMBSR0      10'b0000000110
// SMBSR0 at offset 0x018

`define HADDR_SMBIDCYR1   10'b0000000111
// SMBIDCYR1 at offset 0x01C

`define HADDR_SMBWST1R1   10'b0000001000
// SMBWST1R1 at offset 0x020

`define HADDR_SMBWST2R1   10'b0000001001
// SMBWST2R1 at offset 0x024

`define HADDR_SMBWSTOENR1 10'b0000001010
// SMBWSTOENR1 at offset 0x028

`define HADDR_SMBWSTWENR1 10'b0000001011
// SMBWSTWENR1 at offset 0x02C

`define HADDR_SMBCR1      10'b0000001100
// SMBCR1 at offset 0x030

`define HADDR_SMBSR1      10'b0000001101
// SMBSR1 at offset 0x034

`define HADDR_SMBIDCYR2   10'b0000001110
// SMBIDCYR2 at offset 0x038

`define HADDR_SMBWST1R2   10'b0000001111
// SMBWST1R2 at offset 0x03C

`define HADDR_SMBWST2R2   10'b0000010000
// SMBWST2R2 at offset 0x040

`define HADDR_SMBWSTOENR2 10'b0000010001
// SMBWSTOENR2 at offset 0x044

`define HADDR_SMBWSTWENR2 10'b0000010010
// SMBWSTWENR2 at offset 0x048

`define HADDR_SMBCR2      10'b0000010011
// SMBCR2 at offset 0x04C

`define HADDR_SMBSR2      10'b0000010100
// SMBSR2 at offset 0x050

`define HADDR_SMBIDCYR3   10'b0000010101
// SMBIDCYR3 at offset 0x054

`define HADDR_SMBWST1R3   10'b0000010110
// SMBWST1R3 at offset 0x058

`define HADDR_SMBWST2R3   10'b0000010111
// SMBWST2R3 at offset 0x05C

`define HADDR_SMBWSTOENR3 10'b0000011000
// SMBWSTOENR3 at offset 0x060

`define HADDR_SMBWSTWENR3 10'b0000011001
// SMBWSTWENR3 at offset 0x064

`define HADDR_SMBCR3      10'b0000011010
// SMBCR3 at offset 0x068

`define HADDR_SMBSR3      10'b0000011011
// SMBSR3 at offset 0x06C

`define HADDR_SMBIDCYR4   10'b0000011100
// SMBIDCYR4 at offset 0x070

`define HADDR_SMBWST1R4   10'b0000011101
// SMBWST1R4 at offset 0x074

`define HADDR_SMBWST2R4   10'b0000011110
// SMBWST2R4 at offset 0x078

`define HADDR_SMBWSTOENR4 10'b0000011111
// SMBWSTOENR4 at offset 0x07C

`define HADDR_SMBWSTWENR4 10'b0000100000
// SMBWSTWENR4 at offset 0x080

`define HADDR_SMBCR4      10'b0000100001
// SMBCR4 at offset 0x084

`define HADDR_SMBSR4      10'b0000100010
// SMBSR4 at offset 0x088

`define HADDR_SMBIDCYR5   10'b0000100011
// SMBIDCYR5 at offset 0x08C

`define HADDR_SMBWST1R5   10'b0000100100
// SMBWST1R5 at offset 0x090

`define HADDR_SMBWST2R5   10'b0000100101
// SMBWST2R5 at offset 0x094

`define HADDR_SMBWSTOENR5 10'b0000100110
// SMBWSTOENR5 at offset 0x098

`define HADDR_SMBWSTWENR5 10'b0000100111
// SMBWSTWENR5 at offset 0x09C

`define HADDR_SMBCR5      10'b0000101000
// SMBCR5 at offset 0x0A0

`define HADDR_SMBSR5      10'b0000101001
// SMBSR5 at offset 0x0A4

`define HADDR_SMBIDCYR6   10'b0000101010
// SMBIDCYR6 at offset 0x0A8

`define HADDR_SMBWST1R6   10'b0000101011
// SMBWST1R6 at offset 0x0AC

`define HADDR_SMBWST2R6   10'b0000101100
// SMBWST2R6 at offset 0x0B0

`define HADDR_SMBWSTOENR6 10'b0000101101
// SMBWSTOENR6 at offset 0x0B4

`define HADDR_SMBWSTWENR6 10'b0000101110
// SMBWSTWENR6 at offset 0x0B8

`define HADDR_SMBCR6      10'b0000101111
// SMBCR6 at offset 0x0BC

`define HADDR_SMBSR6      10'b0000110000
// SMBSR6 at offset 0x0C0

`define HADDR_SMBIDCYR7   10'b0000110001
// SMBIDCYR7 at offset 0x0C4

`define HADDR_SMBWST1R7   10'b0000110010
// SMBWST1R7 at offset 0x0C8

`define HADDR_SMBWST2R7   10'b0000110011
// SMBWST2R7 at offset 0x0CC

`define HADDR_SMBWSTOENR7 10'b0000110100
// SMBWSTOENR7 at offset 0x0D0

`define HADDR_SMBWSTWENR7 10'b0000110101
// SMBWSTWENR7 at offset 0x0D4

`define HADDR_SMBCR7      10'b0000110110
// SMBCR7 at offset 0x0D8

`define HADDR_SMBSR7      10'b0000110111
// SMBSR7 at offset 0x0DC

`define HADDR_SMBEWS      10'b0000111000
// SMBEWS at offset 0x0E0

// -----------------------------------------------------------------------------
// SMC Identification register's address `define definitions
// -----------------------------------------------------------------------------
`define HADDR_SMCPeriphID0 10'b1111111000
// SMCPeriphID0 at offset 0xFE0

`define HADDR_SMCPeriphID1 10'b1111111001
// SMCPeriphID1 at offset 0xFE4

`define HADDR_SMCPeriphID2 10'b1111111010
// SMCPeriphID2 at offset 0xFE8

`define HADDR_SMCPeriphID3 10'b1111111011
// SMCPeriphID3 at offset 0xFEC

`define HADDR_SMCPCellID0  10'b1111111100
// SMCPCellID0 at offset 0xFF0

`define HADDR_SMCPCellID1  10'b1111111101
// SMCPCellID1 at offset 0xFF4

`define HADDR_SMCPCellID2  10'b1111111110
// SMCPCellID2 at offset 0xFF8

`define HADDR_SMCPCellID3  10'b1111111111
// SMCPCellID3 at offset 0xFFC

// -----------------------------------------------------------------------------
// SMC Transfer Control State machine's state definition `defines.
// -----------------------------------------------------------------------------
`define ST_TSM_IDLE     4'b0000
// Idle State

`define ST_TSM_BUFWR    4'b0001
// Internal Buffer Write State

`define ST_TSM_WENCNT   4'b0010
// Write Enable Count State

`define ST_TSM_MEMWR    4'b0011
// Memory Write State

`define ST_TSM_SEQWR    4'b0100
// Sequential Write State

`define ST_TSM_TURNARND 4'b0101
// Turn Around State

`define ST_TSM_OENCNT   4'b0110
// Output Enable Count State

`define ST_TSM_MEMRD    4'b0111
// Memory Read State

`define ST_TSM_AHBRD    4'b1111
// AHB Bus Read State

// -----------------------------------------------------------------------------
// Timer State Machines's State definition
// -----------------------------------------------------------------------------
`define ST_TW_IDLE     2'b00
// Timer Idle State

`define ST_TW_COUNT    2'b01
// Timer Count State

`define ST_TW_EXTWAIT  2'b11
// External Wait State where the SMC is controlled by SMWAIT

// --=========================================================================--

