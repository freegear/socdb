//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name          : MuxP2B.v,v
//  File Revision      : 1.11
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose            : Central mux - signals from peripherals to bridge.
//                        Stand-alone module to allow ease of removal if an
//                        alternative interconnection scheme is to be used.
//  --========================================================================--

`timescale 1ns/1ps

module MuxP2B 
  (
   // Inputs to the Mux
   PSELS0,
   PSELS1,
   PSELS2,
   PSELS3,
   PSELS4,
   PSELS5,
   PSELS6,
   PSELS7,
   PSELS8,
   PSELS9,
   PSELS10,
   PSELS11,
   PSELS12,
   PSELS13,
   PSELS14,
   PSELS15,

   PRDATAS0,
   PRDATAS1,
   PRDATAS2,
   PRDATAS3,
   PRDATAS4,
   PRDATAS5,
   PRDATAS6,
   PRDATAS7,
   PRDATAS8,
   PRDATAS9,
   PRDATAS10,
   PRDATAS11,
   PRDATAS12,
   PRDATAS13,
   PRDATAS14,
   PRDATAS15,

   // Output from the Mux  
   PRDATA);


  input PSELS0;
  input PSELS1;
  input PSELS2;
  input PSELS3;
  input PSELS4;
  input PSELS5;
  input PSELS6;
  input PSELS7;
  input PSELS8;
  input PSELS9;
  input PSELS10;
  input PSELS11;
  input PSELS12;
  input PSELS13;
  input PSELS14;
  input PSELS15;

  input [31:0] PRDATAS0;
  input [31:0] PRDATAS1;
  input [31:0] PRDATAS2;
  input [31:0] PRDATAS3;
  input [31:0] PRDATAS4;
  input [31:0] PRDATAS5;
  input [31:0] PRDATAS6;
  input [31:0] PRDATAS7;
  input [31:0] PRDATAS8;
  input [31:0] PRDATAS9;
  input [31:0] PRDATAS10;
  input [31:0] PRDATAS11;
  input [31:0] PRDATAS12;
  input [31:0] PRDATAS13;
  input [31:0] PRDATAS14;
  input [31:0] PRDATAS15;
    
  output [31:0] PRDATA;

//
// Block Overview
//
//   The Peripheral to Bridge Multiplexor is used to connect the read data 
// output of each APB Slave to the APB Bridge module, using the PSELx signals 
// to select the required data source. 
//
// The Peripheral to Bridge Multiplexor module has a 32-bit wide data path. 
// It is constructed from a parallel arrangement of 32 multiplexors, each 
// taking 16 inputs.
//

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// PselBus encoding. This must be extended if more than sixteen APB peripherals
//  are used in the system.

  `define PSEL_S0  16'b0000000000000001
  `define PSEL_S1  16'b0000000000000010
  `define PSEL_S2  16'b0000000000000100
  `define PSEL_S3  16'b0000000000001000
  `define PSEL_S4  16'b0000000000010000
  `define PSEL_S5  16'b0000000000100000
  `define PSEL_S6  16'b0000000001000000
  `define PSEL_S7  16'b0000000010000000
  `define PSEL_S8  16'b0000000100000000
  `define PSEL_S9  16'b0000001000000000
  `define PSEL_S10 16'b0000010000000000
  `define PSEL_S11 16'b0000100000000000
  `define PSEL_S12 16'b0001000000000000
  `define PSEL_S13 16'b0010000000000000
  `define PSEL_S14 16'b0100000000000000
  `define PSEL_S15 16'b1000000000000000


//------------------------------------------------------------------------------
// Signal declaration
//------------------------------------------------------------------------------
     
// Input/Output Signals
  wire        PSELS0;
  wire        PSELS1;
  wire        PSELS2;
  wire        PSELS3;
  wire        PSELS4;
  wire        PSELS5;
  wire        PSELS6;
  wire        PSELS7;
  wire        PSELS8;
  wire        PSELS9;
  wire        PSELS10;
  wire        PSELS11;
  wire        PSELS12;
  wire        PSELS13;
  wire        PSELS14;
  wire        PSELS15;
  wire [31:0] PRDATAS0;
  wire [31:0] PRDATAS1;
  wire [31:0] PRDATAS2;
  wire [31:0] PRDATAS3;
  wire [31:0] PRDATAS4;
  wire [31:0] PRDATAS5;
  wire [31:0] PRDATAS6;
  wire [31:0] PRDATAS7;
  wire [31:0] PRDATAS8;
  wire [31:0] PRDATAS9;
  wire [31:0] PRDATAS10;
  wire [31:0] PRDATAS11;
  wire [31:0] PRDATAS12;
  wire [31:0] PRDATAS13;
  wire [31:0] PRDATAS14;
  wire [31:0] PRDATAS15;

  reg  [31:0] PRDATA;

// Internal Signals
  wire [15:0] PselBus;  // PSEL input bus


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// PSEL bus
//------------------------------------------------------------------------------
// The internal PSEL bus is made up of the individual PSEL inputs.

   assign PselBus = {PSELS15,
                     PSELS14,
                     PSELS13,
                     PSELS12,
                     PSELS11,
                     PSELS10,
                     PSELS9,
                     PSELS8,
                     PSELS7,
                     PSELS6,
                     PSELS5,
                     PSELS4,
                     PSELS3,
                     PSELS2,
                     PSELS1,
                     PSELS0};

//------------------------------------------------------------------------------
// Multiplexers
//------------------------------------------------------------------------------
// Multiplexers controlling read data from peripherals to the bridge.

// This module only needs to be as wide as the widest peripheral read data bus,
//  but in this default system it is set to the full 32 bits.
// The default all zeros case is not strictly required, but may aid debugging by
//  ensuring that the read data bus is zero when no peripherals are being
//  accessed.

  always @ (PselBus or PRDATAS0 or PRDATAS1 or PRDATAS2 or
            PRDATAS3 or PRDATAS4 or PRDATAS5 or PRDATAS6 or
            PRDATAS7 or PRDATAS8 or PRDATAS9 or PRDATAS10 or
            PRDATAS11 or PRDATAS12 or PRDATAS13 or PRDATAS14 or
            PRDATAS15)
    begin : p_PRDATAComb
      case (PselBus)
        `PSEL_S0 : 
          PRDATA = PRDATAS0;

        `PSEL_S1 : 
          PRDATA = PRDATAS1;

        `PSEL_S2 : 
          PRDATA = PRDATAS2;

        `PSEL_S3 : 
          PRDATA = PRDATAS3;

        `PSEL_S4 : 
          PRDATA = PRDATAS4;

        `PSEL_S5 : 
          PRDATA = PRDATAS5;

        `PSEL_S6 : 
          PRDATA = PRDATAS6;

        `PSEL_S7 : 
          PRDATA = PRDATAS7;

        `PSEL_S8 : 
          PRDATA = PRDATAS8;

        `PSEL_S9 : 
          PRDATA = PRDATAS9;

        `PSEL_S10 : 
          PRDATA = PRDATAS10;

        `PSEL_S11 : 
          PRDATA = PRDATAS11;

        `PSEL_S12 : 
          PRDATA = PRDATAS12;

        `PSEL_S13 : 
          PRDATA = PRDATAS13;

        `PSEL_S14 : 
          PRDATA = PRDATAS14;

        `PSEL_S15 : 
          PRDATA = PRDATAS15;

        default: 
          PRDATA = {4'b0000,4'b0000,4'b0000,4'b0000,
                    4'b0000,4'b0000,4'b0000,4'b0000};

      endcase
    end 


endmodule

// --================================= End ===================================--

