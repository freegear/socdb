
//  ----------------------------------------------------------------------------
//  Purpose             : Static Memory Interface system memory
//                        An off-chip environment which incorporates a static
//                        memory and a BOOT ROM.
//  --========================================================================--
`timescale 1ns/1ps

module Memory (XA, XCSN, XWEN, XOEN, XD);

  input [30:0] XA;   // External address bus
  inout [31:0] XD;   // External data bus
  input  [3:0] XCSN; // External chip enable
  input  [3:0] XWEN; // External write enable
  input        XOEN; // External output enable


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire [30:0] XA;   // External address bus
  wire [31:0] XD;   // External data bus
  wire  [3:0] XCSN; // External chip enable
  wire  [3:0] XWEN; // External write enable
  wire        XOEN; // External output enable

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// CSN0 - Word-wide Static RAM 1
//------------------------------------------------------------------------------
// This bank of memory mapped at 0x00000000 is loaded with the contents of the
//  specified '.dat' files. The boot code will normally be copied into this RAM
//  as a function of the boot-loader software, prior to the remap process. It
//  is therefore a valid shortcut to specify the ROM initialisation data here.
// Note that in the example system the first 1K of this 128K SRAM bank is
//  masked by the internal memory in the EASY chip (only after remap).

endmodule

// --================================= End ===================================--
