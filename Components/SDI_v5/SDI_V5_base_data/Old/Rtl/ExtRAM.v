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
// File Name           : ExtRAM.v,v
// File Revision       : 1.4
//
// Release Information : ADK_REL1v1
//
// ----------------------------------------------------------------------------
// Purpose             : External memory, 32K x 8 EPROM.
//                       This is a behavioral Verilog model, and not
//                       representative of a real on-chip SRAM.
//                       Loads data from file specified in Memory.v
// --========================================================================--
`timescale 1ns/1ps

module ExtRAM (A, CSn, WEn, OEn, DQ);

  input [14:0] A;   // External memory address
  inout  [7:0] DQ;  // External memory data I/O
  input        CSn; // Chip enable
  input        WEn; // Write enable
  input        OEn; // Output enable

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// This section is used to set the size of the memory that is used.
// If the memory depth is changed, then the address bus A must be able to
//  address the whole memory.

  `define RAMDEPTH 32 // Memory depth in Kbytes

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire [14:0] A;
  wire  [7:0] DQ;
  wire        CSn;
  wire        WEn;
  wire        OEn;

// Internal Signals
  reg   [7:0] Ram [0:((`RAMDEPTH * 1024) - 1)]; // Memory register array
  reg         PosedgeWEn;                       // Rising edge of write enable
  reg  [14:0] ALat;                             // Latched address during writes
  reg   [7:0] TRIDQ;                            // Tri-state data out

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Write enable rising edge detection
//------------------------------------------------------------------------------
// Sets the signal on the rising edge of the write enable line when the chip
//  select line is asserted (LOW).

  always @(posedge WEn) // Detects the rising edge of WEn
  begin
    if (~CSn)
      PosedgeWEn = 1'b1;
    else
      PosedgeWEn = 1'b0;
  end

//------------------------------------------------------------------------------
// Read from memory
//------------------------------------------------------------------------------
// During a read the memory is accessed and driven onto the data bus.

  always @(CSn or WEn or OEn or A or PosedgeWEn)
  begin
    if (~CSn & ~OEn & WEn)
      TRIDQ = Ram[A];

//------------------------------------------------------------------------------
// Write to memory
//------------------------------------------------------------------------------
// During the first part of a write, the address is latched.
// At the end of the write, the current value of the data bus is stored using
//  the latched address.
// The data bus output is tristated to allow the write data to be driven without
//  clashing.

    else if (~CSn & ~WEn)
    begin
      ALat  = A;     // Latch address at start of write
      TRIDQ = 8'hzz;
    end

    else if (PosedgeWEn)
    begin
      Ram[ALat]  = DQ;
      PosedgeWEn = #1 1'b0; // Delay added so that shows up on waveform view
    end

//------------------------------------------------------------------------------
// Tri-state driver for data bus
//------------------------------------------------------------------------------
// When no reads or writes are being performed, the data bus is tristated.

    else
      TRIDQ = 8'hzz;
  end

// A 2 ns delay has been added to create a more realistic memory model, and to
//  ensure that data reads from memory do not violate the data input hold time
//  on the system ARM CPU.
// This delay value may need changing depending on the clock frequency of the
//  system.

  assign #2 DQ = TRIDQ;


endmodule

// --================================= End ===================================--
