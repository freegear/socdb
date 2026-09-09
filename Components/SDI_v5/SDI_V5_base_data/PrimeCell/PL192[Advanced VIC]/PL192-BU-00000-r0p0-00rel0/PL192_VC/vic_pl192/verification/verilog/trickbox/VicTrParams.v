// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : VicTrParams.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Trickbox Parameter definitions
//
// --=========================================================================--

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define WAITSTATES  10
// No of Wait States inserted for higher latency register accesses

// -----------------------------------------------------------------------------
// HRESP value definitions
// -----------------------------------------------------------------------------
`define TR_H_OKAY  2'b00

// -----------------------------------------------------------------------------
// HREADYOUT value definitions
// -----------------------------------------------------------------------------
`define TR_H_READY 1'b1
`define TR_H_WAIT  1'b0

// -----------------------------------------------------------------------------
// VIC Trickbox Functional registers' address constant definitions
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Mirrored Registers
// Writes to these registers should be performed using
// the VIC Base address + offset.
// Reads to these registers should be performed using
// the Trickbox Base address + offset.
// -----------------------------------------------------------------------------
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

`define VICTRSWPRITYMASKADDR  10'b0000001001
// VICTrSwPriMask at offset 0x024

`define VICTRVECTPLDSYPLVL  10'b0000001010
// VICTrVectPriDsy at offset 0x028

`define VICTRVECTADADDR       10'b1111000000
// VicTrVectAddr at offset 0xF00

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

`define VICTRVECTAD16ADDR     10'b0001010000
// VicTrVectAddr16 at offset 0x140

`define VICTRVECTAD17ADDR     10'b0001010001
// VicTrVectAddr17 at offset 0x144

`define VICTRVECTAD18ADDR     10'b0001010010
// VicTrVectAddr18 at offset 0x148

`define VICTRVECTAD19ADDR     10'b0001010011
// VicTrVectAddr19 at offset 0x14C

`define VICTRVECTAD20ADDR     10'b0001010100
// VicTrVectAddr20 at offset 0x150

`define VICTRVECTAD21ADDR     10'b0001010101
// VicTrVectAddr21 at offset 0x154

`define VICTRVECTAD22ADDR     10'b0001010110
// VicTrVectAddr22 at offset 0x158

`define VICTRVECTAD23ADDR     10'b0001010111
// VicTrVectAddr23 at offset 0x15C

`define VICTRVECTAD24ADDR     10'b0001011000
// VicTrVectAddr24 at offset 0x160

`define VICTRVECTAD25ADDR     10'b0001011001
// VicTrVectAddr25 at offset 0x164

`define VICTRVECTAD26ADDR     10'b0001011010
// VicTrVectAddr26 at offset 0x168

`define VICTRVECTAD27ADDR     10'b0001011011
// VicTrVectAddr27 at offset 0x16C

`define VICTRVECTAD28ADDR     10'b0001011100
// VicTrVectAddr28 at offset 0x170

`define VICTRVECTAD29ADDR     10'b0001011101
// VicTrVectAddr29 at offset 0x174

`define VICTRVECTAD30ADDR     10'b0001011110
// VicTrVectAddr30 at offset 0x178

`define VICTRVECTAD31ADDR     10'b0001011111
// VicTrVectAddr31 at offset 0x17C

`define VICTRVECTPL0PLVL      10'b0010000000
// VicTrVectPrity0 at offset 0x200

`define VICTRVECTPL1PLVL      10'b0010000001
// VicTrVectPrity1 at offset 0x204

`define VICTRVECTPL2PLVL      10'b0010000010
// VicTrVectPrity2 at offset 0x208

`define VICTRVECTPL3PLVL      10'b0010000011
// VicTrVectPrity3 at offset 0x20C

`define VICTRVECTPL4PLVL      10'b0010000100
// VicTrVectPrity4 at offset 0x210

`define VICTRVECTPL5PLVL      10'b0010000101
// VicTrVectPrity5 at offset 0x214

`define VICTRVECTPL6PLVL      10'b0010000110
// VicTrVectPrity6 at offset 0x218

`define VICTRVECTPL7PLVL      10'b0010000111
// VicTrVectPrity7 at offset 0x21C

`define VICTRVECTPL8PLVL      10'b0010001000
// VicTrVectPrity8 at offset 0x220

`define VICTRVECTPL9PLVL      10'b0010001001
// VicTrVectPrity9 at offset 0x224

`define VICTRVECTPL10PLVL     10'b0010001010
// VicTrVectPrity10 at offset 0x228

`define VICTRVECTPL11PLVL     10'b0010001011
// VicTrVectPrity11 at offset 0x22C

`define VICTRVECTPL12PLVL     10'b0010001100
// VicTrVectPrity12 at offset 0x230

`define VICTRVECTPL13PLVL     10'b0010001101
// VicTrVectPrity13 at offset 0x234

`define VICTRVECTPL14PLVL     10'b0010001110
// VicTrVectPrity14 at offset 0x238

`define VICTRVECTPL15PLVL     10'b0010001111
// VicTrVectPrity15 at offset 0x23C

`define VICTRVECTPL16PLVL     10'b0010010000
// VicTrVectPrity16 at offset 0x240

`define VICTRVECTPL17PLVL     10'b0010010001
// VicTrVectPrity17 at offset 0x244

`define VICTRVECTPL18PLVL     10'b0010010010
// VicTrVectPrity18 at offset 0x248

`define VICTRVECTPL19PLVL     10'b0010010011
// VicTrVectPrity19 at offset 0x24C

`define VICTRVECTPL20PLVL     10'b0010010100
// VicTrVectPrity20 at offset 0x250

`define VICTRVECTPL21PLVL     10'b0010010101
// VicTrVectPrity21 at offset 0x254

`define VICTRVECTPL22PLVL     10'b0010010110
// VicTrVectPrity22 at offset 0x258

`define VICTRVECTPL23PLVL     10'b0010010111
// VicTrVectPrity23 at offset 0x25C

`define VICTRVECTPL24PLVL     10'b0010011000
// VicTrVectPrity24 at offset 0x260

`define VICTRVECTPL25PLVL     10'b0010011001
// VicTrVectPrity25 at offset 0x264

`define VICTRVECTPL26PLVL     10'b0010011010
// VicTrVectPrity26 at offset 0x268

`define VICTRVECTPL27PLVL     10'b0010011011
// VicTrVectPrity27 at offset 0x26C

`define VICTRVECTPL28PLVL     10'b0010011100
// VicTrVectPrity28 at offset 0x270

`define VICTRVECTPL29PLVL     10'b0010011101
// VicTrVectPrity29 at offset 0x274

`define VICTRVECTPL30PLVL     10'b0010011110
// VicTrVectPrity30 at offset 0x278

`define VICTRVECTPL31PLVL     10'b0010011111
// VicTrVectPrity31 at offset 0x27C

`define VICTRWAITACCESSADDR   10'b0000001110
// VICTr dummy register accessible with Non-Zero wait states 
// at offset 0x038

// -----------------------------------------------------------------------------
// Trickbox-specific Registers (Offset is specified with respect to
// the Trickbox Base address)
// -----------------------------------------------------------------------------
`define VICTRTCRADDR          10'b0000010100
// VICTrTCR at offset 0x050

`define VICTRINTSOURCEADDR    10'b0000010101
// VicTrIntSource at offset 0x054

`define VICTRINTSTATUSADDR    10'b0000010110
// VicTrStatus at offset 0x058

`define VICTRVECTADOUTADDR    10'b0000010111
// VicTrVectAddrOut at offset 0x05C

`define VICTRINTINADDR        10'b0000011000
// VicTrIntIn at offset 0x0060

`define VICTRINTINREGADDR     10'b0000011001
// VicTrIntInReg at offset 0x0064

`define VICTRVECTADINADDR     10'b0000011010
// VicTrVectAddrIn at offset 0x068

`define VICTRSYNCADDR         10'b0000011011
// VicTrSync at offset 0x06C

`define VICTRACKCNTADDR       10'b0000011101
// VicTrVectAddrIn at offset 0x074

// --=============================== End =====================================--
