// --========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1998-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name           : ExtROM.v,v
// File Revision       : 1.4
//
// Release Information : ADK_REL1v1
//
// ----------------------------------------------------------------------------
// Purpose             : External memory, 16K x 8 EPROM.
//                       This is a behavioral Verilog model, and not
//                       representative of a real on-chip EPROM.
//                       Loads data from file specified in Memory.vhd.
// --========================================================================--
`timescale 1ns/1ps

module ExtROM (A, CEn, OEn, Q);

  input  [13:0] A;   // External memory address
  output  [7:0] Q;   // External memory data out
  input         CEn; // Chip enable
  input         OEn; // Output enable

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// This section is used to set the size of the memory that is used.
// If the memory depth is changed, then the address bus A must be able to
//  address the whole memory.

  `define ROMDEPTH 16 // Memory depth in Kbytes

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire [13:0] A;   // External memory address
  wire  [7:0] Q;   // External memory data out
  wire        CEn; // Chip enable
  wire        OEn; // Output enable

// Internal Signals
  reg [7:0] Rom [0:((`ROMDEPTH * 1024) - 1)]; // Memory register array
  reg [7:0] QInt;                                // Output data value

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Read from memory
//------------------------------------------------------------------------------
// During a read the memory is accessed and then driven onto the data bus.

  always @(CEn or OEn or A)
  begin
    if (~CEn & ~OEn)
      QInt = Rom[A];

//------------------------------------------------------------------------------
// Tri-state driver for data bus
//------------------------------------------------------------------------------
// When no reads are being performed, the data bus is tristated.

    else
      QInt = 8'hzz;
  end

// A 2 ns delay has been added to create a more realistic memory model, and to
//  ensure that data reads from memory do not violate the data input hold time
//  on the system ARM CPU.
// This delay value may need changing depending on the clock frequency of the
//  system.

  assign #2 Q = QInt;

endmodule

// --================================= End ===================================--
