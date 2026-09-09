// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : VicTrParams.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL190-REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           Trickbox Parameter definitions
//
// --=================================================================--

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
`define WAITSTATES  10
// No of Wait States inserted for higher latency register accesses

// ---------------------------------------------------------------------
// HRESP value definitions
// ---------------------------------------------------------------------
`define TR_H_OKAY  2'b00

// ---------------------------------------------------------------------
// HREADYOUT value definitions
// ---------------------------------------------------------------------
`define TR_H_READY 1'b1
`define TR_H_WAIT  1'b0

// ---------------------------------------------------------------------
// VIC Trickbox Functional registers' address constant definitions
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Mirrored Registers
// Writes to these registers should be performed using
// the VIC Base address + offset.
// Reads to these registers should be performed using
// the Trickbox Base address + offset.
// ---------------------------------------------------------------------
`define VICTRINTSELECTADDR    10'b0000000011
// VicTrIntSelect at offset 0x00C

`define VICTRINTENABLEADDR    10'b0000000100
// VicTrIntEnable at offset 0x010

`define VICTRINTENCLEARADDR   10'b0000000101
// VicTrIntEnClear at offset 0x014

`define VICTRSOFTINTADDR      10'b0000000110
// VicTrSoftInt at offset 0x018

`define VICTRSOFTINTCLEARADDR 10'b0000000111
// VicTrSoftIntClear at offset 0x01C

`define VICTRPROTECTIONADDR   10'b0000001000
// VicTrProtection at offset 0x020

`define VICTRVECTADADDR       10'b0000001100
// VicTrVectAddr at offset 0x030

`define VICTRDEFVECTADADDR    10'b0000001101
// VicTrDefVectAddr at offset 0x034

`define VICTRVECTAD0ADDR      10'b0001000000
// VicTrVectAddr0 at offset 0x100

`define VICTRVECTAD1ADDR      10'b0001000001
// VicTrVectAddr1 at offset 0x104

`define VICTRVECTAD2ADDR      10'b0001000010
// VicTrVectAddr2 at offset 0x108

`define VICTRVECTAD3ADDR      10'b0001000011
// VicTrVectAddr3 at offset 0x10C

`define VICTRVECTAD4ADDR      10'b0001000100
// VicTrVectAddr4 at offset 0x110

`define VICTRVECTAD5ADDR      10'b0001000101
// VicTrVectAddr5 at offset 0x114

`define VICTRVECTAD6ADDR      10'b0001000110
// VicTrVectAddr6 at offset 0x118

`define VICTRVECTAD7ADDR      10'b0001000111
// VicTrVectAddr7 at offset 0x11C

`define VICTRVECTAD8ADDR      10'b0001001000
// VicTrVectAddr8 at offset 0x120

`define VICTRVECTAD9ADDR      10'b0001001001
// VicTrVectAddr9 at offset 0x124

`define VICTRVECTAD10ADDR     10'b0001001010
// VicTrVectAddr10 at offset 0x128

`define VICTRVECTAD11ADDR     10'b0001001011
// VicTrVectAddr11 at offset 0x12C

`define VICTRVECTAD12ADDR     10'b0001001100
// VicTrVectAddr12 at offset 0x130

`define VICTRVECTAD13ADDR     10'b0001001101
// VicTrVectAddr13 at offset 0x134

`define VICTRVECTAD14ADDR     10'b0001001110
// VicTrVectAddr14 at offset 0x138

`define VICTRVECTAD15ADDR     10'b0001001111
// VicTrVectAddr15 at offset 0x13C

`define VICTRVECTCNTL0ADDR    10'b0010000000
// VicTrVectCntl0 at offset 0x200

`define VICTRVECTCNTL1ADDR    10'b0010000001
// VicTrVectCntl1 at offset 0x204

`define VICTRVECTCNTL2ADDR    10'b0010000010
// VicTrVectCntl2 at offset 0x208

`define VICTRVECTCNTL3ADDR    10'b0010000011
// VicTrVectCntl3 at offset 0x20C

`define VICTRVECTCNTL4ADDR    10'b0010000100
// VicTrVectCntl4 at offset 0x210

`define VICTRVECTCNTL5ADDR    10'b0010000101
// VicTrVectCntl5 at offset 0x214

`define VICTRVECTCNTL6ADDR    10'b0010000110
// VicTrVectCntl6 at offset 0x218

`define VICTRVECTCNTL7ADDR    10'b0010000111
// VicTrVectCntl7 at offset 0x21C

`define VICTRVECTCNTL8ADDR    10'b0010001000
// VicTrVectCntl8 at offset 0x220

`define VICTRVECTCNTL9ADDR    10'b0010001001
// VicTrVectCntl9 at offset 0x224

`define VICTRVECTCNTL10ADDR   10'b0010001010
// VicTrVectCntl10 at offset 0x228

`define VICTRVECTCNTL11ADDR   10'b0010001011
// VicTrVectCntl11 at offset 0x22C

`define VICTRVECTCNTL12ADDR   10'b0010001100
// VicTrVectCntl12 at offset 0x230

`define VICTRVECTCNTL13ADDR   10'b0010001101
// VicTrVectCntl13 at offset 0x234

`define VICTRVECTCNTL14ADDR   10'b0010001110
// VicTrVectCntl14 at offset 0x238

`define VICTRVECTCNTL15ADDR   10'b0010001111
// VicTrVectCntl15 at offset 0x23C

`define VICTRWAITACCESSADDR   10'b0000001110
// VICTr dummy register accessible with Non-Zero wait states 
// at offset 0x038

// ---------------------------------------------------------------------
// Trickbox-specific Registers (Offset is specified with respect to
// the Trickbox Base address)
// ---------------------------------------------------------------------
`define VICTRTCRADDR          10'b0000000000
// VICTrTCR at offset 0x000

`define VICTRINTSOURCEADDR    10'b0000000001
// VicTrIntSource at offset 0x004

`define VICTRINTSTATUSADDR    10'b0000000010
// VicTrStatus at offset 0x008

`define VICTRVECTADOUTADDR    10'b0000001001
// VicTrVectAddrOut at offset 0x024

`define VICTRINTINADDR        10'b0000001010
// VicTrIntIn at offset 0x0028

`define VICTRVECTADINADDR     10'b0000001011
// VicTrVectAddrIn at offset 0x02C

// --============================== End ==============================--
