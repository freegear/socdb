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
// File Name              : MuxP2B.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
//
// ---------------------------------------------------------------------
// Purpose :
//           Central mux - signals from peripherals to bridge.
//           Stand-alone module to allow ease of removal if an
//           alternative interconnection scheme is to be used.
//
// --=================================================================--

`timescale 1ns/1ps

module MuxP2B (PSELUUT, PSELRPC, PRDATAUUT, PRDATARPC, PRDATA);

  input         PSELUUT;
  input         PSELRPC;

  input  [31:0] PRDATAUUT;
  input  [31:0] PRDATARPC;

  output [31:0] PRDATA;

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
// PselReg encoding. This must be extended if more than eight APB
// peripherals are used in the system.

  `define PSEL_UUT 8'b00000001
  `define PSEL_RPC 8'b00000010

// ---------------------------------------------------------------------
// Signal declaration
// ---------------------------------------------------------------------
  wire [7:0] PselBus; // PSEL input bus

  reg [31:0] PRDATA;  // Registered output signal

// ---------------------------------------------------------------------
// Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// PSEL bus
// ---------------------------------------------------------------------
// The internal PSEL bus is made up of the PSEL inputs and extra
// padding for the bits that are not used.

  assign PselBus = {6'b000000,
                    PSELRPC,
                    PSELUUT};

// ---------------------------------------------------------------------
// Multiplexers
// ---------------------------------------------------------------------
// Multiplexers controlling read data from peripherals to the bridge.

// This module only needs to be as wide as the widest peripheral read
// data bus, but in this default system it is set to the full 32 bits.
// The default all zeros case is not strictly required, but may aid
// debugging by ensuring that the read data bus is zero when no
// peripherals are being accessed.

  always @(PselBus or PRDATAUUT or PRDATARPC)
  begin
    case (PselBus)
      `PSEL_UUT : PRDATA = PRDATAUUT;
      `PSEL_RPC : PRDATA = PRDATARPC;
      default   : PRDATA = 32'h0000_0000;
    endcase
  end

endmodule

// --============================== End ==============================--
