
`timescale 1ns/1ps

module AHBMuxS2M (
// Inputs
                  HCLK,
                  HRESETn,

                  HREADYIn,

                  HSEL_USB,
                  HSEL_DMA,
                  HSEL_IRC,
                  HREADY_USB,
                  HREADY_DMA,
                  HREADY_IRC,
                  HREADYDefault,
                  HRESP_USB,
                  HRESP_DMA,
                  HRESP_IRC,
                  HRESPDefault,
                  HRDATA_USB,
                  HRDATA_DMA,
                  HRDATA_IRC,
// Outputs
                  HREADYOut,
                  HRESP,
                  HRDATA
                  );

// Inputs
input             HCLK;          // system bus clock
input             HRESETn;       // reset input (active low)

input             HREADYIn;      // hready in

input             HSEL_USB;      // AHB peripheral select - USB
input             HSEL_DMA;      // AHB peripheral select - DMA
input             HSEL_IRC;      // AHB peripheral select - Interrupt Controller

input             HREADY_USB;    // hready from USB
input             HREADY_DMA;    // hready from DMA
input             HREADY_IRC;    // hready from Interrupt Controller
input             HREADYDefault; // hready from default slave (in decoder)

input    [1:0]    HRESP_USB;     // hresponse from USB
input    [1:0]    HRESP_DMA;     // hresponse from DMA
input    [1:0]    HRESP_IRC;     // hresponse from Interrupt Controller
input    [1:0]    HRESPDefault;  // hresponse from default slave

input   [31:0]    HRDATA_USB;    // read data bus from USB
input   [31:0]    HRDATA_DMA;    // read data bus from DMA
input   [31:0]    HRDATA_IRC;    // read data bus from Interrupt Controller

// Outputs
output            HREADYOut;     // muxed hready out
output   [1:0]    HRESP;         // muxed response out
output  [31:0]    HRDATA;        // muxed read data bus out to master(s)

// Inputs
wire              HCLK;          // system bus clock
wire              HRESETn;       // reset input (active low)
wire              HSEL_USB;      // AHB peripheral select - USB
wire              HSEL_DMA;      // AHB peripheral select - DMA
wire              HSEL_IRC;      // AHB peripheral select - Interrupt Controller
wire              HREADY_USB;    // hready from USB
wire              HREADY_DMA;    // hready from DMA
wire              HREADY_IRC;    // hready from Interrupt Controller
wire              HREADYDefault; // hready from default slave (in decoder)
wire     [1:0]    HRESP_USB;     // hresponse from USB
wire     [1:0]    HRESP_DMA;     // hresponse from DMA
wire     [1:0]    HRESP_IRC;     // hresponse from Interrupt Controller
wire     [1:0]    HRESPDefault;  // hresponse from default slave
wire              HREADYIn;      // hready in
wire    [31:0]    HRDATA_USB;    // read data bus from USB
wire    [31:0]    HRDATA_DMA;    // read data bus from DMA
wire    [31:0]    HRDATA_IRC;    // read data bus from Interrupt Controller

// Outputs
wire              HREADYOut;     // muxed hready out
wire     [1:0]    HRESP;         // muxed response out
wire    [31:0]    HRDATA;        // muxed read data bus out to master(s)

// -----------------------------------------------------------------------------
//
//                                  AHBMuxS2M
//                                  =========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// Central multiplexor - signals from slaves to masters
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire     iHREADY;
// Internal HREADY used as HSEL register enable

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg      SelUSB;
// Select signal

reg      SelDMA;
// Selecct SSRAM

reg      SelIRC;
// Selecct SSRAM

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// HSEL registers
// Registered HSEL outputs are needed to control the slave output multiplexors,
// as the multiplexors must be switched in the cycle after the HSEL signals
// have been driven.
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_HSELSeq
  if (HRESETn == 1'b0)
    begin
      SelUSB  <= 1'b0;
      SelDMA   <= 1'b0;
      SelIRC   <= 1'b0;
    end
  else
    if (HREADYIn == 1'b1)
      begin
        SelUSB <= HSEL_USB;
        SelDMA  <= HSEL_DMA;
        SelIRC  <= HSEL_IRC;
      end
end // p_HSELSeq

// -----------------------------------------------------------------------------
// multiplexors controlling read data and responses from slaves to masters.
// -----------------------------------------------------------------------------
assign HRDATA           = (SelUSB == 1'b1) ? HRDATA_USB  : 
                          (SelDMA == 1'b1) ? HRDATA_DMA  : 
                          (SelIRC == 1'b1) ? HRDATA_IRC  : 
                          32'h00000000;

assign iHREADY          = (SelUSB == 1'b1) ? HREADY_USB  : 
						  (SelDMA == 1'b1) ? HREADY_DMA  : 
						  (SelIRC == 1'b1) ? HREADY_IRC  : 
					  	  HREADYDefault;

assign HREADYOut        = iHREADY;

assign HRESP            = (SelUSB == 1'b1) ? HRESP_USB   : 
                          (SelDMA == 1'b1) ? HRESP_DMA   : 
                          (SelIRC == 1'b1) ? HRESP_IRC   : 
                          HRESPDefault;

endmodule

// --================================== End ==================================--
