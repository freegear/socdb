// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdConfig.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//  Purpose : This file contains the FIFO depth and read/write pointer width
//            definition for the DMA FIFO
//
// --=========================================================================--

// ----------------------------------------------------------------------------
// DMA Fifo depth. this is configurable like 8,16,32,64 etc.
// the minimum value of the depth should be 8.
// ----------------------------------------------------------------------------

`define FIFO_DEPTH  5'b10000

// ----------------------------------------------------------------------------
// DMA fifo read/write pointer width. This is log FIFO_DEPTH base 2.
// ----------------------------------------------------------------------------

`define PTR_SIZE 4

// ----------------------------------------------------------------------------
// DMA Fifo type. For D-flipflop based FIFO set FIFO_TYPE = 1 (FIFO write on 
// each HCLK). For TPRAM based FIFO set FIFO_TYPE = 0 (FIFO write on every
// three HCLK).
// ----------------------------------------------------------------------------

`define FIFO_TYPE  1'b1

// ----------------------------------------------------------------------------
// FIFO RAM write pulse width. this has to be properly configured if the DMA 
// fifo uses TPRAM. 
// for 1 HCLK period set FIFO_WRITE_PW = 4'b1000
// for 2 HCLK period set FIFO_WRITE_PW = 4'b0100
// for 3 HCLK period set FIFO_WRITE_PW = 4'b0010
// 
// ----------------------------------------------------------------------------

`define FIFO_WRITE_PW  4'b1000

// ----------------------------------------------------------------------------
// if this is set to 1'b1 the read cycle is stretched by 1 HCLK for Palette RAM 
// and Fifo RAM from AHB side
// ----------------------------------------------------------------------------

`define PAL_RAM_READ_STRTCH 1'b1
