// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
//  File Name              : SsmcTrParams.v.rca
//  File Revision          : 1.7
//
//  Release Information    : PrimeCell(TM)-PL093-r0p1-00ltd0
//
//------------------------------------------------------------------------------
// Purpose :
//           All constants needs to be change in the tricbox design are
//           declared here
//
// --=========================================================================--

//------------------------------------------------------------------------------
//
//                               SsmcTrParams
//                               ===========
//
//------------------------------------------------------------------------------

`define MemDeep          2048
// Determines the size of memory array

`define AddWrHoldTime    0
// Address hold time with respect to the rising edge(finishing end) of write

`define AddWrSetupTime   0
// Address setup time with respect to the falling edge of(starting edge) write

`define DataWrHoldTime   0
// Data hold time with respect to the rising edge(finishing end)  of write

`define DataWrSetupTime  0
// Data hold time with respect to the rising edge(finishing end)  of write

`define DelayTime        3
// Error window in time calculations

// --================================= End ===================================--
