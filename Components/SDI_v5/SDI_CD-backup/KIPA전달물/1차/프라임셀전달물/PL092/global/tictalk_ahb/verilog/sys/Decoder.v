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
// File Name              : Decoder.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
//
// ---------------------------------------------------------------------
// Purpose :
//           Provides the HSELx module select outputs to the AHB
//           system slaves, and controls the read data multiplexer.
//           This module is specific to a particular implementation
//
// --=================================================================--

`timescale 1ns/1ps

module Decoder (HRESETn, HADDR, Remap, HSELIntMem, HSELExtMem, HSELUUT,
                HSELAPBif, HSELArmTest, HSELDefault);

  input        HRESETn;
  input [31:0] HADDR;

  input        Remap;

  output       HSELIntMem;  // Internal Memory
  output       HSELExtMem;  // External Memory
  output       HSELUUT;     // AHB UUT
  output       HSELAPBif;   // APB Peripherals
  output       HSELArmTest; // ARM Test
  output       HSELDefault; // Default Slave

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
// Registered output signals
  reg HSELDefault;
  reg HSELArmTest;
  reg HSELAPBif;
  reg HSELUUT;
  reg HSELExtMem;
  reg HSELIntMem;

// ---------------------------------------------------------------------
// Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// AHB address decoding for slave selection and read data multiplexer
// control
// ---------------------------------------------------------------------
// Address decoding of HADDR is performed continuously.
// Address map is:
//
// 0x00000000 - 0x000003FF Internal RAM (1 bank)  (Remap HIGH)
// 0x00000400 - 0x1FFFFFFF External RAM (2 banks) (Remap HIGH)
// 0x00000000 - 0x3FFFFFFF External RAM (2 banks) (Remap LOW)
// 0x20000000 - 0x2FFFFFFF Tube
// 0x30000000 - 0x3FFFFFFF External ROM (1 bank)
// 0x40000000 - 0x5FFFFFFF AHB Unit Under Test
// 0x60000000 - 0x7FFFFFFF Undefined (Default Slave)
// 0x80000000 - 0xBFFFFFFF APB Peripherals
// 0xC0000000 - 0xDFFFFFFF ARM Core Test Interface
// 0xE0000000 - 0xFFFFFFFF Undefined (Default Slave)

  always @(HRESETn or HADDR or Remap)
  begin
    HSELIntMem = 1'b0;
    HSELExtMem = 1'b0;
    HSELUUT    = 1'b0;
    HSELAPBif  = 1'b0;
    HSELArmTest = 1'b0;
    HSELDefault = 1'b0;

    if (!HRESETn)
      HSELDefault = 1'b1;            // Reset (Default Slave)
    else if ((HADDR[31:10] == 22'b0000000000000000000000 && Remap))
      HSELIntMem = 1'b1;             // Internal Memory
    else if (HADDR[31:30] == 2'b00)
      HSELExtMem = 1'b1;             // External Memory + Tube
    else if (HADDR[31:29] == 3'b010)
      HSELUUT = 1'b1;                // AHB Unit Under Test
    else if (HADDR[31:30] == 2'b10)
      HSELAPBif = 1'b1;              // APB Peripherals
    else if (HADDR[31:29] == 3'b110)
      HSELArmTest = 1'b1;            // ARM Core Test Interface
    else
      HSELDefault = 1'b1;            // Undefined (Default Slave)
  end

endmodule

// --============================== End ==============================--
