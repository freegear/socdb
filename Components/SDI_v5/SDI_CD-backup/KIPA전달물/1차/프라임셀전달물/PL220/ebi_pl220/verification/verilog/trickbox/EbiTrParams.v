// --=========================================================================//
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------------//
// Version and Release Control Information:
//
// File Name              : EbiTrParams.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
//
// ---------------------------------------------------------------------------//
// Purpose :
//           All constants needs to be change in the tricbox design are
//           declared here
//
// --=========================================================================//

`timescale 1ns/1ps

// ---------------------------------------------------------------------------//

// ---------------------------------------------------------------------------//
//
//                               EbiTrParams
//                               ===========
//
// ---------------------------------------------------------------------------//

// ---------------------------------------------------------------------------//
// Constant declarations
// ---------------------------------------------------------------------------//

// ---------------------------------------------------------------------------//
// Definitions for different AHB HTRANS transactions
// ---------------------------------------------------------------------------//
`define HTRANS_IDLE      2'b00
// Master IDLE respone

`define HTRANS_BUSY      2'b01
// Master BUSY respone

// ---------------------------------------------------------------------------//
// Definitions for different AHB HRESP responses
// ---------------------------------------------------------------------------//
`define HRESP_OKAY       2'b00
// Slave OKAY respone

`define HRESP_ERROR      2'b01
// Slave ERROR respone

// ---------------------------------------------------------------------------//
// Definitions for different AHB HSIZE transactions
// ---------------------------------------------------------------------------//
`define HSIZE_WORD       3'b010
// 32-bit operation

// ---------------------------------------------------------------------------//
// Definitions for different AHB HBURST transactions
// ---------------------------------------------------------------------------//
`define HBURST_INCR      3'b001
// Undefined length burst

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define TRUE             1'b1

`define FALSE            1'b0

// --================================= End ===================================//
