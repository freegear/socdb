// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : MpmcTrParams.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           All constants needs to be change in the tricbox design are
//           declared here
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
//                               MpmcTrParams
//                               ============
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define MemDeep          2048
// Determines the size of memory array

`define AddWrHoldTime    4
// Address hold time with respect to the rising edge (finishing end) of write

`define AddWrSetupTime   3
// Address setup time with respect to the falling edge of (starting edge) write

`define DataWrHoldTime   4
// Data hold time with respect to the rising edge (finishing end) of write

`define DataWrSetupTime  3
// Data hold time with respect to the rising edge (finishing end) of write

`define DelayTime        3
// Error window in time calculations

`define TRUE             1'b1

`define FALSE            1'b0

// -----------------------------------------------------------------------------
// Peripheral Address range Definations for AHB 1
// -----------------------------------------------------------------------------
`define MPMC00LOWADDRRANGE  32'h00000000

`define MPMC01LOWADDRRANGE  32'h10000000

`define MPMC02LOWADDRRANGE  32'h20000000

`define MPMC03LOWADDRRANGE  32'h30000000

`define MPMC04LOWADDRRANGE  32'h40000000

`define MPMC05LOWADDRRANGE  32'h50000000

`define MPMC06LOWADDRRANGE  32'h60000000

`define MPMC07LOWADDRRANGE  32'h70000000

`define MCTR0LOWADDRRANGE  32'hC0000000

`define MPMC10LOWADDRRANGE  32'h00000000

`define MPMC11LOWADDRRANGE  32'h10000000

`define MPMC12LOWADDRRANGE  32'h20000000

`define MPMC13LOWADDRRANGE  32'h30000000

`define MPMC14LOWADDRRANGE  32'h40000000

`define MPMC15LOWADDRRANGE  32'h50000000

`define MPMC16LOWADDRRANGE  32'h60000000

`define MPMC17LOWADDRRANGE  32'h70000000

`define MCTR1LOWADDRRANGE  32'hC0000000

`define MPMC20LOWADDRRANGE  32'h00000000

`define MPMC21LOWADDRRANGE  32'h10000000

`define MPMC22LOWADDRRANGE  32'h20000000

`define MPMC23LOWADDRRANGE  32'h30000000

`define MPMC24LOWADDRRANGE  32'h40000000

`define MPMC25LOWADDRRANGE  32'h50000000

`define MPMC26LOWADDRRANGE  32'h60000000

`define MPMC27LOWADDRRANGE  32'h70000000

`define MCTR2LOWADDRRANGE  32'hC0000000

`define MPMC00HIGHADDRRANGE 32'h0FFFFFFF

`define MPMC01HIGHADDRRANGE 32'h1FFFFFFF

`define MPMC02HIGHADDRRANGE 32'h2FFFFFFF

`define MPMC03HIGHADDRRANGE 32'h3FFFFFFF

`define MPMC04HIGHADDRRANGE 32'h4FFFFFFF

`define MPMC05HIGHADDRRANGE 32'h5FFFFFFF

`define MPMC06HIGHADDRRANGE 32'h6FFFFFFF

`define MPMC07HIGHADDRRANGE 32'h7FFFFFFF

`define MCTR0HIGHADDRRANGE 32'hFFFFFFFF

`define MPMC10HIGHADDRRANGE 32'h0FFFFFFF

`define MPMC11HIGHADDRRANGE 32'h1FFFFFFF

`define MPMC12HIGHADDRRANGE 32'h2FFFFFFF

`define MPMC13HIGHADDRRANGE 32'h3FFFFFFF

`define MPMC14HIGHADDRRANGE 32'h4FFFFFFF

`define MPMC15HIGHADDRRANGE 32'h5FFFFFFF

`define MPMC16HIGHADDRRANGE 32'h6FFFFFFF

`define MPMC17HIGHADDRRANGE 32'h7FFFFFFF

`define MCTR1HIGHADDRRANGE 32'hFFFFFFFF

`define MPMC20HIGHADDRRANGE 32'h0FFFFFFF

`define MPMC21HIGHADDRRANGE 32'h1FFFFFFF

`define MPMC22HIGHADDRRANGE 32'h2FFFFFFF

`define MPMC23HIGHADDRRANGE 32'h3FFFFFFF

`define MPMC24HIGHADDRRANGE 32'h4FFFFFFF

`define MPMC25HIGHADDRRANGE 32'h5FFFFFFF

`define MPMC26HIGHADDRRANGE 32'h6FFFFFFF

`define MPMC27HIGHADDRRANGE 32'h7FFFFFFF

`define MCTR2HIGHADDRRANGE 32'hFFFFFFFF

// -----------------------------------------------------------------------------
// Definitions for different AHB HTRANS transactions
// -----------------------------------------------------------------------------
`define HTRANS_IDLE      2'b00
// Master IDLE respone

`define HTRANS_BUSY      2'b01
// Master BUSY respone

// -----------------------------------------------------------------------------
// Definitions for different AHB HRESP responses
// -----------------------------------------------------------------------------
`define HRESP_OKAY       2'b00
// Slave OKAY respone

`define HRESP_ERROR      2'b01
// Slave ERROR respone

// -----------------------------------------------------------------------------
// Definitions for different AHB HSIZE transactions
// -----------------------------------------------------------------------------
`define HSIZE_WORD       3'b010
// 32-bit operation

// -----------------------------------------------------------------------------
// Definitions for different AHB HBURST transactions
// -----------------------------------------------------------------------------
`define HBURST_INCR      3'b001
// Undefined length burst

// --================================= End ===================================--
