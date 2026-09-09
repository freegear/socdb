// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : CLTrAHBIf.v.rca
//  File Revision          : 1.3
//
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//
//  ----------------------------------------------------------------------------

//  ----------------------------------------------------------------------------
//  Purpose : CLCD Trickbox Bus AHB Interface
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module CLTrAHBIf (
             // Inputs
               // AHB Inputs
               HCLK,
               HRESETN,
               HADDR,
               HTRANS,
               HWRITE,
               HSEL,
               HSELCom,
               HSIZE,
               HBURST,
               HWDATA,
               HREADYIn,

               // Other Inputs
               CLTrRDATA,
               Delay,

             // Outputs
               // AHB Outputs
               HRDATA,
               HREADYOut,
               HRESP,

               // Other Outputs
               CLTrWRITE,
               CLTrWDATA,
               CLTrRegSel,
               DelayRegSel,
               CLTrControlSel,
               CLTrTiming0Sel,
               CLTrTiming1Sel,
               CLTrTiming2Sel,
               CLTrTiming3Sel,
               CLTrUPBASESel,
               CLTrLPBASESel,
               CLTrPalSel,
               CLTrPalAddr
            );
 
input             HCLK;           // AHB Bus Clock
input             HRESETN;        // AHB Reset
input  [9:2]      HADDR;          // AHB Address Bus
input  [1:0]      HTRANS;         // AHB Transfer Type
input             HWRITE;         // AHB Transfer Direction
input             HSEL;           // AHB Slave Sel
input             HSELCom;        // AHB Common Registers Select
input  [2:0]      HSIZE;          // AHB Transfer Size
input  [2:0]      HBURST;         // AHB Burst Type
input  [31:0]     HWDATA;         // AHB Write Data Bus
input             HREADYIn;       // AHB Global Transfer Done
input  [31:0]     CLTrRDATA;      // CLCD Trickbox Read  Data
input  [31:0]     Delay;          // CLCD Trickbox delay counter value

output [31:0]     HRDATA;         // AHB Read  Data Bus
output            HREADYOut;      // AHB TrickBox Transfer Done
output [1:0]      HRESP;          // AHB transfer Response
output            CLTrWRITE;      // CLCD Trickbox Write 
output [31:0]     CLTrWDATA;      // CLCD Trickbox Write Data
output            CLTrRegSel;     // CLCD Trickbox Register Select
output            DelayRegSel;    // Trickbox delay Register Select
output            CLTrControlSel; // CLCD Trickbox Control Reg Select
output            CLTrTiming0Sel; // CLCD Trickbox Timing 0 Reg Select
output            CLTrTiming1Sel; // CLCD Trickbox Timing 1 Reg Select
output            CLTrTiming2Sel; // CLCD Trickbox Timing 2 Reg Select
output            CLTrTiming3Sel; // CLCD Trickbox Timing 3 Reg Select
output            CLTrUPBASESel;  // CLCD Trickbox Upper Panel Base Select
output            CLTrLPBASESel;  // CLCD Trickbox Lower Panel Base Select
output            CLTrPalSel;     // CLCD Trickbox Palette Select
output [6:0]      CLTrPalAddr;    // CLCD Trickbox Palette Offset Address 

// -----------------------------------------------------------------------------
//                             CLTrAHBIf
//                             =========
// -----------------------------------------------------------------------------
// Overview
// ========
// This module is to interface with AHB Bus to talk to AHB Slave Testbench.
// This module includes :
// - Latching Block of Address & Control Signals
// - Generation of HRESP, HREADYOut, HRDATA Block
// - Address Decode Block
// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define CLTrTime0   8'h00
`define CLTrTime1   8'h01
`define CLTrTime2   8'h02
`define CLTrTime3   8'h03
`define CLTrUPBase  8'h04
`define CLTrLPBase  8'h05
`define CLTrCtrl    8'h07
`define CLTrPal     8'b1xxxxxxx
`define DelayReg    8'h01
`define CLTrReg     8'h00 
 
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire              HCLK;           // (module input)
wire              HRESETN;        // (module input)
wire   [9:2]      HADDR;          // (module input)
wire   [1:0]      HTRANS;         // (module input)
wire              HWRITE;         // (module input)
wire              HSEL;           // (module input)
wire              HSELCom;        // (module input)
wire   [2:0]      HSIZE;          // (module input)
wire   [2:0]      HBURST;         // (module input)
wire   [31:0]     HWDATA;         // (module input)
wire              HREADYIn;       // (module input)
wire   [31:0]     HRDATA;         // (module output)
wire              HREADYOut;      // (module output)
wire    [1:0]     HRESP;          // (module output)
wire              CLTrWRITE;      // (module input)
wire   [31:0]     CLTrWDATA;      // (module output)
wire   [31:0]     CLTrRDATA;      // (module input)

// -----------------------------------------------------------------------------
// Reg declarations
// -----------------------------------------------------------------------------
reg     [9:2]     iHADDR;
reg               iHWRITE;
reg     [1:0]     iHTRANS;
reg               iHSEL;
reg               iHSELCom;
reg               CLTrControlSel;
reg               CLTrTiming0Sel;
reg               CLTrTiming1Sel;
reg               CLTrTiming2Sel;
reg               CLTrTiming3Sel;
reg               CLTrUPBASESel;
reg               CLTrLPBASESel;
reg               CLTrPalSel;
reg     [6:0]     CLTrPalAddr;
reg               CLTrRegSel;
reg               DelayRegSel;
 
// -----------------------------------------------------------------------------
// Main body of code
// =================
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Latching of Address & Control Signals.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETN)
begin : p_LatchSeq
  if (HRESETN == 1'b0)
    begin
      iHADDR     <= 8'b0;
      iHSEL      <= 1'b0;
      iHSELCom   <= 1'b0;
      iHWRITE    <= 1'b0;
      iHTRANS    <= 2'b0;
    end
  else if (HREADYIn)
    begin
      iHSEL      <= HSEL;
      iHSELCom   <= HSELCom;
      if (HSEL || HSELCom)
        begin
          iHADDR     <= HADDR;
          iHWRITE    <= HWRITE;
          iHTRANS    <= HTRANS;
        end
    end
end
 
// -----------------------------------------------------------------------------
// CLCD HREADYOut Signal Generation:
// When the slave is selected i.e. HSEL is high HREADYOut will be high.
// -----------------------------------------------------------------------------
assign HREADYOut = !(iHSEL & (Delay != 32'b0));
 
// -----------------------------------------------------------------------------
// CLCD HRESP Signal Generation:  Will be always OKAY.
// -----------------------------------------------------------------------------
assign HRESP     = 2'b0;
 
// -----------------------------------------------------------------------------
// CLCD Write Signal to CLCD Trickbox RegBlock
// -----------------------------------------------------------------------------
assign CLTrWRITE = (iHSEL || iHSELCom) && iHWRITE;
 
// -----------------------------------------------------------------------------
// CLCD Register Write Data
// -----------------------------------------------------------------------------
assign CLTrWDATA = HWDATA;
 
// -----------------------------------------------------------------------------
// CLCD Register Read  Data
// -----------------------------------------------------------------------------
assign HRDATA   = CLTrRDATA;
// -----------------------------------------------------------------------------
// Trickbox  Register Address Decode
// -----------------------------------------------------------------------------
always @(iHSEL or iHTRANS or iHADDR)
begin : p_Decodetrick
  // Default Values
  CLTrRegSel = 1'b0;
  DelayRegSel = 1'b0;
  if (iHSEL && iHTRANS[1]) begin
    casex (iHADDR)
      `CLTrReg : CLTrRegSel = 1'b1;
      `DelayReg: DelayRegSel = 1'b1;
    endcase
  end
end

 
// -----------------------------------------------------------------------------
// CLCD Register Address Decode
// -----------------------------------------------------------------------------
always @(iHSELCom or iHTRANS or iHADDR)
begin : p_DecodeComb
  // Default Values
  CLTrControlSel = 1'b0;
  CLTrTiming0Sel = 1'b0;
  CLTrTiming1Sel = 1'b0;
  CLTrTiming2Sel = 1'b0;
  CLTrTiming3Sel = 1'b0;
  CLTrUPBASESel  = 1'b0;
  CLTrLPBASESel  = 1'b0;
  CLTrPalSel     = 1'b0;
  CLTrPalAddr    = 7'b0;
  if (iHSELCom && iHTRANS[1]) begin
    casex (iHADDR)
      `CLTrCtrl   : CLTrControlSel = 1'b1;
      `CLTrTime0  : CLTrTiming0Sel = 1'b1;
      `CLTrTime1  : CLTrTiming1Sel = 1'b1;
      `CLTrTime2  : CLTrTiming2Sel = 1'b1;
      `CLTrTime3  : CLTrTiming3Sel = 1'b1;
      `CLTrUPBase : CLTrUPBASESel  = 1'b1;
      `CLTrLPBase : CLTrLPBASESel  = 1'b1;
      `CLTrPal    : begin
                      CLTrPalSel     = 1'b1;
                      CLTrPalAddr    = iHADDR[8:2];
                    end
    endcase
  end
end
 
endmodule
 
// --================================== End ==================================--

