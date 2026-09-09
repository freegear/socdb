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
// File Name              : VicParams.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL190-REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           System Parameter definitions
//
// --=================================================================--

// ---------------------------------------------------------------------
// AHB HRESP constant definitions
// ---------------------------------------------------------------------
`define H_OKAY  2'b00
`define H_ERROR 2'b01

// ---------------------------------------------------------------------
// AHB HREADYOUT constant definitions
// ---------------------------------------------------------------------
`define H_WAIT  1'b0
`define H_READY 1'b1

// ---------------------------------------------------------------------
// VIC Functional registers' address constant definitions
// ---------------------------------------------------------------------
`define HADDR_VICIRQSTATUS     10'b0000000000
// VICIRQStatus at offset 0x000

`define HADDR_VICFIQSTATUS     10'b0000000001
// VICFIQStatus at offset 0x004

`define HADDR_VICRAWINTR       10'b0000000010
// VICRawIntr at offset 0x008

`define HADDR_VICINTSELECT     10'b0000000011
// VICIntSelect at offset 0x00C

`define HADDR_VICINTENABLE     10'b0000000100
// VICIntEnable at offset 0x010

`define HADDR_VICINTENCLEAR    10'b0000000101
// VICIntEnClear at offset 0x014

`define HADDR_VICSOFTINT       10'b0000000110
// VICSoftInt at offset 0x018

`define HADDR_VICSOFTINTCLEAR  10'b0000000111
// VICSoftIntClear at offset 0x01C

`define HADDR_VICPROTECTION    10'b0000001000
// VICProtection at offset 0x020

`define HADDR_VICVECTADDR      10'b0000001100
// VICVectAddr at offset 0x030

`define HADDR_VICDEFVECTADDR   10'b0000001101
// VICDefVectAddr at offset 0x034

`define HADDR_VICVECTADDR0     10'b0001000000
// VICVectAddr0 at offset 0x100

`define HADDR_VICVECTADDR1     10'b0001000001
// VICVectAddr1 at offset 0x104

`define HADDR_VICVECTADDR2     10'b0001000010
// VICVectAddr2 at offset 0x108

`define HADDR_VICVECTADDR3     10'b0001000011
// VICVectAddr3 at offset 0x10C

`define HADDR_VICVECTADDR4     10'b0001000100
// VICVectAddr4 at offset 0x110

`define HADDR_VICVECTADDR5     10'b0001000101
// VICVectAddr5 at offset 0x114

`define HADDR_VICVECTADDR6     10'b0001000110
// VICVectAddr6 at offset 0x118

`define HADDR_VICVECTADDR7     10'b0001000111
// VICVectAddr7 at offset 0x11C

`define HADDR_VICVECTADDR8     10'b0001001000
// VICVectAddr8 at offset 0x120

`define HADDR_VICVECTADDR9     10'b0001001001
// VICVectAddr9 at offset 0x124

`define HADDR_VICVECTADDR10    10'b0001001010
// VICVectAddr10 at offset 0x128

`define HADDR_VICVECTADDR11    10'b0001001011
// VICVectAddr11 at offset 0x12C

`define HADDR_VICVECTADDR12    10'b0001001100
// VICVectAddr12 at offset 0x130

`define HADDR_VICVECTADDR13    10'b0001001101
// VICVectAddr13 at offset 0x134

`define HADDR_VICVECTADDR14    10'b0001001110
// VICVectAddr14 at offset 0x138

`define HADDR_VICVECTADDR15    10'b0001001111
// VICVectAddr15 at offset 0x13C

`define HADDR_VICVECTCNTL0     10'b0010000000
// VICVectCntl0 at offset 0x200

`define HADDR_VICVECTCNTL1     10'b0010000001
// VICVectCntl1 at offset 0x204

`define HADDR_VICVECTCNTL2     10'b0010000010
// VICVectCntl2 at offset 0x208

`define HADDR_VICVECTCNTL3     10'b0010000011
// VICVectCntl3 at offset 0x20C

`define HADDR_VICVECTCNTL4     10'b0010000100
// VICVectCntl4 at offset 0x210

`define HADDR_VICVECTCNTL5     10'b0010000101
// VICVectCntl5 at offset 0x214

`define HADDR_VICVECTCNTL6     10'b0010000110
// VICVectCntl6 at offset 0x218

`define HADDR_VICVECTCNTL7     10'b0010000111
// VICVectCntl7 at offset 0x21C

`define HADDR_VICVECTCNTL8     10'b0010001000
// VICVectCntl8 at offset 0x220

`define HADDR_VICVECTCNTL9     10'b0010001001
// VICVectCntl9 at offset 0x224

`define HADDR_VICVECTCNTL10    10'b0010001010
// VICVectCntl10 at offset 0x228

`define HADDR_VICVECTCNTL11    10'b0010001011
// VICVectCntl11 at offset 0x22C

`define HADDR_VICVECTCNTL12    10'b0010001100
// VICVectCntl12 at offset 0x230

`define HADDR_VICVECTCNTL13    10'b0010001101
// VICVectCntl13 at offset 0x234

`define HADDR_VICVECTCNTL14    10'b0010001110
// VICVectCntl14 at offset 0x238

`define HADDR_VICVECTCNTL15    10'b0010001111
// VICVectCntl15 at offset 0x23C

// ---------------------------------------------------------------------
// VIC test registers' address constant definitions
// ---------------------------------------------------------------------
`define HADDR_VICITCR          10'b0011000000
// VICITCR at offset 0x300

`define HADDR_VICITIP1         10'b0011000001
// VICITIP1 at offset 0x304

`define HADDR_VICITIP2         10'b0011000010
// VICITIP2 at offset 0x308

`define HADDR_VICITOP1         10'b0011000011
// VICITOP1 at offset 0x30C

`define HADDR_VICITOP2         10'b0011000100
// VICITOP2 at offset 0x310

// ---------------------------------------------------------------------
// Identification registers' address constant definitions
// ---------------------------------------------------------------------
`define HADDR_VICPERIPHID0     10'b1111111000
// VICPeriphID0 at offset 0xFE0

`define HADDR_VICPERIPHID1     10'b1111111001
// VICPeriphID1 at offset 0xFE4

`define HADDR_VICPERIPHID2     10'b1111111010
// VICPeriphID2 at offset 0xFE8

`define HADDR_VICPERIPHID3     10'b1111111011
// VICPeriphID3 at offset 0xFEC

`define HADDR_VICPCELLID0      10'b1111111100
// VICPCellID0 at offset 0xFF0

`define HADDR_VICPCELLID1      10'b1111111101
// VICPCellID1 at offset 0xFF4

`define HADDR_VICPCELLID2      10'b1111111110
// VICPCellID2 at offset 0xFF8

`define HADDR_VICPCELLID3      10'b1111111111
// VICPCellID3 at offset 0xFFC

// --================================== End ==========================--
