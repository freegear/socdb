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
// File Name              : VicParams.v.rca
// File Revision          : 1.12
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Vectored Interrupt Controller Parameter definitions and functions
//
// --=========================================================================--

// -----------------------------------------------------------------------------
//
//                             VicParams
//                             =========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This file contains the parameters and constants definitions for the
// submodules and some common functions used in the Vic.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// HADDR declarations
// -----------------------------------------------------------------------------

`define HADDR_VICVECTADDR0 10'b0001000000
// VICVectAddr0 register Offset

`define HADDR_VICVECTADDR1 10'b0001000001
// VICVectAddr1 register Offset

`define HADDR_VICVECTADDR2 10'b0001000010
// VICVectAddr2 register Offset

`define HADDR_VICVECTADDR3 10'b0001000011
// VICVectAddr3 register Offset

`define HADDR_VICVECTADDR4 10'b0001000100
// VICVectAddr4 register Offset

`define HADDR_VICVECTADDR5 10'b0001000101
// VICVectAddr5 register Offset

`define HADDR_VICVECTADDR6 10'b0001000110
// VICVectAddr6 register Offset

`define HADDR_VICVECTADDR7 10'b0001000111
// VICVectAddr7 register Offset

`define HADDR_VICVECTADDR8 10'b0001001000
// VICVectAddr8 register Offset

`define HADDR_VICVECTADDR9 10'b0001001001
// VICVectAddr9 register Offset

`define HADDR_VICVECTADDR10 10'b0001001010
// VICVectAddr10 register Offset

`define HADDR_VICVECTADDR11 10'b0001001011
// VICVectAddr11 register Offset

`define HADDR_VICVECTADDR12 10'b0001001100
// VICVectAddr12 register Offset

`define HADDR_VICVECTADDR13 10'b0001001101
// VICVectAddr13 register Offset

`define HADDR_VICVECTADDR14 10'b0001001110
// VICVectAddr14 register Offset

`define HADDR_VICVECTADDR15 10'b0001001111
// VICVectAddr15 register Offset

`define HADDR_VICVECTADDR16 10'b0001010000
// VICVectAddr16 register Offset

`define HADDR_VICVECTADDR17 10'b0001010001
// VICVectAddr17 register Offset

`define HADDR_VICVECTADDR18 10'b0001010010
// VICVectAddr18 register Offset

`define HADDR_VICVECTADDR19 10'b0001010011
// VICVectAddr19 register Offset

`define HADDR_VICVECTADDR20 10'b0001010100
// VICVectAddr20 register Offset

`define HADDR_VICVECTADDR21 10'b0001010101
// VICVectAddr21 register Offset

`define HADDR_VICVECTADDR22 10'b0001010110
// VICVectAddr22 register Offset

`define HADDR_VICVECTADDR23 10'b0001010111
// VICVectAddr23 register Offset

`define HADDR_VICVECTADDR24 10'b0001011000
// VICVectAddr24 register Offset

`define HADDR_VICVECTADDR25 10'b0001011001
// VICVectAddr25 register Offset

`define HADDR_VICVECTADDR26 10'b0001011010
// VICVectAddr26 register Offset

`define HADDR_VICVECTADDR27 10'b0001011011
// VICVectAddr27 register Offset

`define HADDR_VICVECTADDR28 10'b0001011100
// VICVectAddr28 register Offset

`define HADDR_VICVECTADDR29 10'b0001011101
// VICVectAddr29 register Offset

`define HADDR_VICVECTADDR30 10'b0001011110
// VICVectAddr30 register Offset

`define HADDR_VICVECTADDR31 10'b0001011111
// VICVectAddr31 register Offset

`define HADDR_VICPRIORITY0 10'b0010000000
// VICVECTPRIORITY0 register Offset

`define HADDR_VICPRIORITY1 10'b0010000001
// VICVECTPRIORITY1 register Offset

`define HADDR_VICPRIORITY2 10'b0010000010
// VICVECTPRIORITY2 register Offset

`define HADDR_VICPRIORITY3 10'b0010000011
// VICVECTPRIORITY3 register Offset

`define HADDR_VICPRIORITY4 10'b0010000100
// VICVECTPRIORITY4 register Offset

`define HADDR_VICPRIORITY5 10'b0010000101
// VICVECTPRIORITY5 register Offset

`define HADDR_VICPRIORITY6 10'b0010000110
// VICVECTPRIORITY6 register Offset

`define HADDR_VICPRIORITY7 10'b0010000111
// VICVECTPRIORITY7 register Offset

`define HADDR_VICPRIORITY8 10'b0010001000
// VICVECTPRIORITY8 register Offset

`define HADDR_VICPRIORITY9 10'b0010001001
// VICVECTPRIORITY9 register Offset

`define HADDR_VICPRIORITY10 10'b0010001010
// VICVECTPRIORITY10 register Offset

`define HADDR_VICPRIORITY11 10'b0010001011
// VICVECTPRIORITY11 register Offset

`define HADDR_VICPRIORITY12 10'b0010001100
// VICVECTPRIORITY12 register Offset

`define HADDR_VICPRIORITY13 10'b0010001101
// VICVECTPRIORITY13 register Offset

`define HADDR_VICPRIORITY14 10'b0010001110
// VICVECTPRIORITY14 register Offset

`define HADDR_VICPRIORITY15 10'b0010001111
// VICVECTPRIORITY15 register Offset

`define HADDR_VICPRIORITY16 10'b0010010000
// VICVECTPRIORITY16 register Offset

`define HADDR_VICPRIORITY17 10'b0010010001
// VICVECTPRIORITY17 register Offset

`define HADDR_VICPRIORITY18 10'b0010010010
// VICVECTPRIORITY18 register Offset

`define HADDR_VICPRIORITY19 10'b0010010011
// VICVECTPRIORITY19 register Offset

`define HADDR_VICPRIORITY20 10'b0010010100
// VICVECTPRIORITY20 register Offset

`define HADDR_VICPRIORITY21 10'b0010010101
// VICVECTPRIORITY21 register Offset

`define HADDR_VICPRIORITY22 10'b0010010110
// VICVECTPRIORITY22 register Offset

`define HADDR_VICPRIORITY23 10'b0010010111
// VICVECTPRIORITY23 register Offset

`define HADDR_VICPRIORITY24 10'b0010011000
// VICVECTPRIORITY24 register Offset

`define HADDR_VICPRIORITY25 10'b0010011001
// VICVECTPRIORITY25 register Offset

`define HADDR_VICPRIORITY26 10'b0010011010
// VICVECTPRIORITY26 register Offset

`define HADDR_VICPRIORITY27 10'b0010011011
// VICVECTPRIORITY27 register Offset

`define HADDR_VICPRIORITY28 10'b0010011100
// VICVECTPRIORITY28 register Offset

`define HADDR_VICPRIORITY29 10'b0010011101
// VICVECTPRIORITY29 register Offset

`define HADDR_VICPRIORITY30 10'b0010011110
// VICVECTPRIORITY30 register Offset

`define HADDR_VICPRIORITY31 10'b0010011111
// VICVECTPRIORITY31 register Offset


`define HADDR_VICIRQSTATUS 10'b0000000000
// VICIRQSTATUS register Offset

`define HADDR_VICFIQSTATUS 10'b0000000001
// VICFIQSTATUS register Offset

`define HADDR_VICRAWINTR 10'b0000000010
// VICRAWINTR register Offset

`define HADDR_VICINTSELECT 10'b0000000011
// VICINTSELECT register Offset

`define HADDR_VICINTENABLE 10'b0000000100
// VICINTENABLE register Offset

`define HADDR_VICINTENCLEAR 10'b0000000101
// VICINTENCLEAR register Offset

`define HADDR_VICSOFTINT 10'b0000000110
// VICSOFTINT register Offset

`define HADDR_VICSOFTINTCLEAR 10'b0000000111
// VICSOFTINTCLEAR register Offset

`define HADDR_VICPROTECTION 10'b0000001000
// VICPROTECTION register Offset

`define HADDR_VICSWPRIORITYMASK 10'b0000001001
// VICSWPRIORITYMASK register Offset

`define HADDR_VICSWPRIORITYDAISY 10'b0000001010
// VICSWPRIORITYDAISY register Offset

`define HADDR_VICITCR 10'b0011000000
// VICITCR register Offset

`define HADDR_VICITIP1 10'b0011000001
// VICITIP1 register Offset

`define HADDR_VICITIP2 10'b0011000010
// VICITIP2 register Offset

`define HADDR_VICITOP1 10'b0011000011
// VICITOP1 register Offset

`define HADDR_VICITOP2 10'b0011000100
// VICITOP2 register Offset

`define HADDR_VICINTSSTATUS 10'b0011000101
// VICINTSSTATUS register Offset

`define HADDR_VICINTSSTATUSCLEAR 10'b0011000110
// VICINTSSTATUSCLEAR register Offset

`define HADDR_VICPERIPHID0 10'b1111111000
// VICPERIPHID0 register Offset

`define HADDR_VICPERIPHID1 10'b1111111001
// VICPERIPHID1 register Offset

`define HADDR_VICPERIPHID2 10'b1111111010
// VICPERIPHID2 register Offset

`define HADDR_VICPERIPHID3 10'b1111111011
// VICPERIPHID3 register Offset

`define HADDR_VICPCELLID0 10'b1111111100
// VICPCELLID0 register Offset

`define HADDR_VICPCELLID1 10'b1111111101
// VICPCELLID1 register Offset

`define HADDR_VICPCELLID2 10'b1111111110
// VICPCELLID2 register Offset

`define HADDR_VICPCELLID3 10'b1111111111
// VICPCELLID3 register Offset

`define HADDR_VICADDRESS 10'b1111000000
// VICADDRESS register Offset

// -----------------------------------------------------------------------------
// Values of the peripheral ID and PrimeCell ID
// -----------------------------------------------------------------------------

`define PERIPHID0 8'b10010010
// Peripheral Identification bits 7:0

`define PERIPHID1 8'b00010001
// Peripheral Identification bits 15:8

`define PERIPHID2 4'b0100
// Peripheral Identification bits 23:16

`define PERIPHID3 8'b00000000
// Peripheral Identification bits 31:24

`define PCELLID0 8'b00001101
// PrimeCell Identification bits 7:0

`define PCELLID1 8'b11110000
// PrimeCell Identification bits 15:8

`define PCELLID2 8'b00000101
// PrimeCell Identification bits 23:16

`define PCELLID3 8'b10110001
// PrimeCell Identification bits 31:24

// -----------------------------------------------------------------------------
// Constant declaration
// -----------------------------------------------------------------------------
`define ZERO33 33'b000000000000000000000000000000000

`define ZERO32 32'b00000000000000000000000000000000

`define TIELOW28 28'b0000000000000000000000000000

`define TIELOW24 24'b000000000000000000000000

`define TIELOW16 16'b0000000000000000

// -----------------------------------------------------------------------------
// Constant values of sixteen priority encoder
// -----------------------------------------------------------------------------
`define CFG0 4'b0000

`define CFG1 4'b0001

`define CFG2 4'b0010

`define CFG3 4'b0011

`define CFG4 4'b0100

`define CFG5 4'b0101

`define CFG6 4'b0110

`define CFG7 4'b0111

`define CFG8 4'b1000

`define CFG9 4'b1001

`define CFG10 4'b1010

`define CFG11 4'b1011

`define CFG12 4'b1100

`define CFG13 4'b1101

`define CFG14 4'b1110

`define CFG15 4'b1111
// --================================== End ==================================--
