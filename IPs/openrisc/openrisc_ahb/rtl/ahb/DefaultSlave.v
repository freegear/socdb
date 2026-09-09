// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : DefaultSlave.v,v
// File Revision       : 1.6
// 
// Release Information : ADK_REL1v1
// 
// -----------------------------------------------------------------------------
// Purpose             : Default slave used to drive the slave response signals
//                       when there are no other slaves selected.
// --=========================================================================--

`timescale 1ns/1ps

module DefaultSlave 
  (
   // Common AHB signals
   HCLK, 
   HRESETn,

   // Transfer type (AHB Control bus signal)
   HTRANS,

   // Select line for this slave
   HSEL,

   // HREADY from slave in current data cycle
   HREADY,

   // Response from this slave (AHB Control bus signals)
   HREADYOUT, 
   HRESP
   );
 
  input        HCLK;
  input        HRESETn;
  input [1:0]  HTRANS;
  input        HSEL;
  input        HREADY;
  output       HREADYOUT;
  output [1:0] HRESP;
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// HTRANS transfer type signal encoding
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11
 
// HRESP transfer response signal encoding
  `define RSP_OKAY  2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11
 
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire       HCLK;
  wire       HRESETn;
  wire [1:0] HTRANS;
  wire       HSEL;
  wire       HREADY;
  wire       HREADYOUT;

  reg  [1:0] HRESP;      // Registered output signal

// Internal Signals
  wire       Invalid;    // Set during invalid transfer
  wire       HreadyNext; // Controls generation of HREADYOUT output
  reg        iHREADYOUT; // HREADYOUT register
  wire [1:0] HrespNext;  // Generated response
 

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Invalid transfer detection
//------------------------------------------------------------------------------
// Set HIGH during the address phase of an invalid transfer, and is used to
//  control the generation of the response outputs.

  assign Invalid = ((HREADY == 1'b1 && HSEL == 1'b1 &&
                     (HTRANS == `TRN_NONSEQ || HTRANS == `TRN_SEQ)) ? 1'b1 :
                   1'b0);

//------------------------------------------------------------------------------
// Default slave output drivers
//------------------------------------------------------------------------------
// When an undefined area of the memory map is accessed, or an invalid address
//  is driven onto the address bus, the default slave outputs are selected and
//  passed to the current bus master.

// For the two cycle error response, HREADY is set LOW during the first cycle
//  and HIGH during the second cycle.

  assign HreadyNext = (iHREADYOUT == 1'b0 ? 1'b1 :
                      (Invalid == 1'b1 ? 1'b0 :
                      1'b1));

  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if ((!HRESETn))
        iHREADYOUT <= 1'b1;
      else
        iHREADYOUT <= HreadyNext;
    end
 
  assign HREADYOUT = iHREADYOUT;

// An OKAY response is generated for IDLE or BUSY transfers to undefined
//  locations, but a two cycle ERROR response is generated if a non-sequential
//  or sequential transfer is attempted.

  assign HrespNext = (Invalid == 1'b1 ? `RSP_ERROR : `RSP_OKAY);

  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if ((!HRESETn))
        HRESP <= `RSP_OKAY;
      else
        begin
          if (iHREADYOUT)
            HRESP <= HrespNext;
        end
    end


endmodule

// --================================= End ===================================--
