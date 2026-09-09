//  --------------------------------------------------------------------
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999, 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  --------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : $RCS: $
//  File Revision          : 1.5
//
//  Release Information    : PrimeCell(TM)-PL170-REL2v2
//
//  --------------------------------------------------------------------
//
//  --------------------------------------------------------------------
//  Purpose       : This module implements the behavioural TrickBox for
//                  the  SDRAM Controller.
//  --------------------------------------------------------------------

`timescale 1ns/1ps

module SdramTrick (
                       HCLK,
                       HRESETn,
                       HSIZE,
                       HBURST,
                       HTRANS,
                       HWRITE,
                       HSEL,
                       HREADYIn,
                       SREFAck,
                       CKE,
                       nRAS,
                       nCAS,
                       nCS,
                       nWE,
                       ExtBusReq,
                       AddrOut,
                       HADDR,
                       HWDATA,

                       nPOR,
                       ExtBusGnt,
                       SREFReq,
                       HREADYOut,
                       HRESP,
                       HRDATA,
                       BIGENDIAN
                      );

// Include Parameter File
`include "SdramTrDefs.v"

parameter Width = `BusWidth;

input               HCLK;      // AHB Clock Input
input               HRESETn;   // AHB Reset Input
input         [2:0] HSIZE;     // AHB BSIZE
input         [2:0] HBURST;    // AHB BURST type
input         [1:0] HTRANS;  // AHB transfer type (IDLE,BUSY,SEQ,NONSEQ)
input               HWRITE;  // AHB Access Type Indicator (Read/Write)
input               HSEL;    // AHB Slave Select Line
input               HREADYIn;  // AHB Bus Free Input
input               ExtBusReq; // Bus Request driven by the UUT
input               SREFAck;   // Self Refresh Acknowledge from the UUT
input         [3:0] CKE;       // CKE driven by the UUT
input               nRAS;      // RAS driven by the UUT
input               nCAS;      // CAS driven by the UUT
input         [3:0] nCS;       // CS driven by the UUT
input               nWE;       // WE driven by the UUT
input        [13:0] AddrOut;   // ADDR driven by the UUT
input [`ADDWIDTH:0] HADDR;     // AHB Address Bus
input   [Width-1:0] HWDATA;    // AHB Input Data Bus

output              nPOR;      // Power On Reset Pin
output              SREFReq;   // Self Refresh Request
output              ExtBusGnt; // Bus Grant output to the UUT
output        [1:0] HRESP;     // AHB Slave Response
output              HREADYOut; // AHB Slave Ready Response
output  [Width-1:0] HRDATA;    // Output Data Bus to the AHB
output              BIGENDIAN; // set endian mode of peripheral

//  --------------------------------------------------------------------
//
//                           SdramTrick
//                           ==========
//
//  --------------------------------------------------------------------
//  Overview
//  ========
//
//  This Module implements the SDRAM controller Behavioural trickbox.
//  The trickbox has an AHB Slave interface to provide access to the
//  internal Registers.
//  This module instantiates the following modules:
//  - SdramTrSnp      - Snooper module which tracks commands issued to
//                       the Devices.
//  - SdramTrBusGnt   - Controls the Bus Request to Bus Grant delay.
//  - SdramTrSigCheck - Module to check validity of command sequences
//                       issued by the controller.
//  --------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire Declarations
// ---------------------------------------------------------------------
wire                  HCLK;
wire                  HRESETn;
wire            [2:0] HSIZE;
wire            [2:0] HBURST;
wire            [1:0] HTRANS;
wire                  HWRITE;
wire                  HSEL;
wire                  HREADYIn;
wire                  ExtBusReq;
wire                  SREFAck;
wire            [3:0] CKE;
wire                  nRAS;
wire                  nCAS;
wire            [3:0] nCS;
wire                  nWE;
wire           [13:0] AddrOut;
wire    [`ADDWIDTH:0] HADDR;
wire      [Width-1:0] HWDATA;

wire                  ExtBusGnt;
wire      [Width-1:0] HRDATA;

 wire  [Width-1:0] DOut;
 wire  [Width-1:0] DIn;
 wire       [14:0] NextMASTERCTRL;   // D-Input for MASTERCTRL Regsister
 wire              MASTERCTRLSel;    // MASTERCTRL Register Select
 wire              NextMASTERCTRLWr; // D-Input for MASTERCTRLWr
 wire              NextMASTERCTRLRd; // D-Input for MASTERCTRLRd
 wire              HTRANSValid;      // Valid transfer type for Trickbox
 wire              POR;              // Power on Reset bit of MASTERCTRL
 wire              SREFBit;          // Self Refresh Request Bit
 wire              BIGENDIAN;        // BIG ENDIAN bit of MASTERCTRL
 wire              NextDataWrite;
 wire              ModeBit;          // Mode Select Signal
 wire              NextReadSel;
 wire              NextWriteSel;
 wire              NextRead;
 wire              nReset;
 wire       [16:0] SnpDIn;
 wire              NextSnpRd;
 wire              NextSnpWr;
 wire              NextSnpClr;
 wire              NextSupREFBit;
 wire              NextSupALLBit;
 wire              NextSnpEn;
 wire       [31:0] SnpDOut;
 wire  [Width-1:0] ZEROFILL;           // Contains ZERO Data

//----------------------------------------------------------------------
// Constant declarations
//----------------------------------------------------------------------
`define IDLE                 2'b00
// Master IDLE respone

`define BUSY                 2'b01
// Master BUSY respone

`define NONSEQ               2'b10
// Master NONSEQ respone

`define SEQ                  2'b11
// Master SEQ respone

`define OKAY                 2'b00
// Slave OKAY respone

`define ERROR                2'b01
// Slave ERROR respone

`define WORD                 3'b010
// 32-bit operation

`define DWORD                3'b011
// 64-bit operation

`define INCR                 3'b001
// Undefined length burst

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
 reg                  NextSREFReq;    // D-Input for SREFReq
 reg           [14:0] MASTERCTRL;     // MASTERCTRL Register
 reg                  MASTERCTRLWr;   // Write Enable Pin to MASTERCTRL
 reg                  MASTERCTRLRd;   // Read Enable for MASTERCTRLRd
 reg    [`ADDWIDTH:0] LatchHADDR;     // Latched HADDR
 reg            [1:0] HRESP;
 reg                  HREADYOut;
 reg                  DataWrite;
 reg                  ReadSel;
 reg                  WriteSel;
 reg                  Read;
 reg                  SnpRd;
 reg                  SnpWr;
 reg                  SnpClr;
 reg                  SupREFBit;
 reg                  SupALLBit;
 reg                  SnpEn;
 reg                  SREFReq;
 reg                  nPOR;

// ---------------------------------------------------------------------
// Main Verilog Code
// =================
// ---------------------------------------------------------------------

assign nReset = nPOR & HRESETn;

//  --------------------------------------------------------------------
//  This block instantiates the snooper and the signal checker
//  --------------------------------------------------------------------
SdramTrSnp uSdramTrSnp    (
                .HCLK       (HCLK),
                .nReset     (nReset),
                .FifoIn     (SnpDIn),
                .ChipSelect (nCS) ,
                .FifoClear  (SnpClr),
                .FifoEn     (SnpEn),
                .ReadEn     (NextSnpRd),
                .ModeBit    (ModeBit),
                .FifoOut    (SnpDOut),
                .SupREFBit  (SupREFBit),
                .SupALL     (SupALLBit)
                );

 SdramTrBusGnt uSdramTrBusGnt     (
                   .HCLK            (HCLK),
                   .nReset          (nReset),
                   .ExtBusReq       (ExtBusReq),
                   .BusGntMode      (MASTERCTRL[8]),
                   .BusGntHigh      (MASTERCTRL[9]),
                   .BusGntClk       (MASTERCTRL[14:10]),

                   .ExtBusGnt       (ExtBusGnt)
                  );

 SdramTrSigCheck uSdramTrSigCheck (
                   .HCLK            (HCLK),
                   .HRESETn         (HRESETn),
                   .nPOR            (nPOR),
                   .ReadSel         (ReadSel),
                   .WriteSel        (WriteSel),
                   .DIn             (DIn[31:0]),
                   .CKE             (CKE),
                   .nRAS            (nRAS),
                   .nCAS            (nCAS),
                   .nCS             (nCS),
                   .nWE             (nWE),
                   .A10             (AddrOut[10]),
                   .A5              (AddrOut[5]),
                   .A6              (AddrOut[6]),

                   .DOut            (DOut[31:0]),
                   .ModeBit         (ModeBit)
                  );

 assign HTRANSValid = HTRANS[1] & HREADYIn;

 assign ZEROFILL = 0;
 assign SnpDIn = {nRAS, nCAS, nWE, AddrOut};

//----------------------------------------------------------------------
// This process generate the bus response required for an AHB slave.
// The trickbox is designed for an HBURST of INCR type and an HSIZE of
// 32-bit  or 64-bit. So this process will generate an ERROR response
// when the master  try to access it in some other mode. Also it display
// an error message to the output. Trickbox always provides a ZERO wait
// state OKAY response for IDLE and BUSY HTRANS of the master.
//----------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SlaveRespSeq
  if (HRESETn == 1'b0)
    begin
      HRESP          = `OKAY;
      HREADYOut      = 1'b0;
      LatchHADDR     = `ADDWIDTH'h000;
    end
  else
    begin
      if ((HRESP == `ERROR) && (HREADYIn == 1'b0) && (HSEL == 1'b1))
        begin
          HRESP         = `ERROR;
          HREADYOut     = 1'b1;
        end
      else if (((HTRANS == `IDLE) || (HTRANS == `BUSY))
                && (HSEL == 1'b1) && (HREADYIn == 1'b1))
        begin
          HRESP         = `OKAY;
          HREADYOut     = 1'b1;
        end
      else if ((HSEL == 1'b1) && (HREADYIn == 1'b1))
        begin
          if ((HBURST == `INCR) && ((HSIZE == `WORD)
               || (HSIZE == `DWORD)))
            begin
              HREADYOut   = 1'b1;
              LatchHADDR  = HADDR;
              HRESP       = `OKAY;
            end
          else
            begin
              HRESP       = `ERROR;
              HREADYOut   = 1'b0;
              $display($time, "Error Response from the trickbox slave");
            end
        end
      else
        begin
          HRESP         = `OKAY;
          HREADYOut     = 1'b0;
        end
    end
end // p_SlaveRespSeq;

// ---------------------------------------------------------------------
// SnpClr and SnpEn Generation
// ---------------------------------------------------------------------
 assign NextSnpEn     = SnpWr ? HWDATA[0] : SnpEn;
 assign NextSnpClr    = SnpWr ? HWDATA[1] : 1'b0;
 assign NextSupREFBit = SnpWr ? HWDATA[2] : SupREFBit;
 assign NextSupALLBit = SnpWr ? HWDATA[3] : SupALLBit;

 always @(posedge HCLK or negedge nReset)
 begin : p_SnpSetSeq
   if (~nReset)
     begin
       SnpClr    <= 1'b0;
       SnpEn     <= 1'b0;
       SupREFBit <= 1'b0;
       SupALLBit <= 1'b0;
     end
   else
     begin
       SnpClr    <= NextSnpClr;
       SnpEn     <= NextSnpEn;
       SupREFBit <= NextSupREFBit;
       SupALLBit <= NextSupALLBit;
     end
 end // p_SnpSetSeq

// ---------------------------------------------------------------------
// SREFReq Generation
// ---------------------------------------------------------------------
 assign SREFBit = MASTERCTRL[0];

 always @(SREFBit or SREFAck or SREFReq)
 begin : p_SREFComb
    if (SREFAck)
      NextSREFReq = SREFBit;
    else
      NextSREFReq = SREFBit ? 1'b1: SREFReq;
 end // p_SREFComb

 always @(posedge HCLK or negedge nReset)
 begin : p_SREFSeq
    if (nReset == 1'b0)
      SREFReq <= 1'b0;
    else
      SREFReq <= NextSREFReq;
 end // p_SREFSeq

// ---------------------------------------------------------------------
// nPOR Generation
// ---------------------------------------------------------------------
 assign POR = MASTERCTRL[1];

 always @(posedge HCLK or posedge POR)
 begin : p_nPORSeq
    if (POR)
      nPOR <= #`PORDelay 1'b0;
    else
      nPOR <= 1'b1;
 end // p_nPORSeq

// ---------------------------------------------------------------------
// BIGENDIAN Generation
// ---------------------------------------------------------------------
 assign BIGENDIAN = MASTERCTRL[2];

// ---------------------------------------------------------------------
// SnpRd and SnpWr Generation
//
// Whenever there is request to access the location, these pins are
// asserted depending on the condition of HWRITE pin.
// ---------------------------------------------------------------------
 assign NextSnpWr = (Width == 32) ?
                       HSEL & (HADDR == 'h200) & HWRITE & HTRANSValid :
                       HSEL & (HADDR == 'h400) & HWRITE & HTRANSValid;

 assign NextSnpRd = (Width == 32) ?
                       HSEL & (HADDR == 'h200) & ~HWRITE & HTRANSValid :
                       HSEL & (HADDR == 'h400) & ~HWRITE & HTRANSValid;

 always @(posedge HCLK or negedge HRESETn)
 begin : p_SnpWrSeq
    if (HRESETn == 1'b0)
       SnpWr <= 1'b0;
    else
       SnpWr <= NextSnpWr;
 end // p_SnpWrSeq

 always @(posedge HCLK or negedge HRESETn)
 begin : p_SnpRdSeq
    if (HRESETn == 1'b0)
       SnpRd <= 1'b0;
    else
       SnpRd <= NextSnpRd;
 end // p_SnpRdSeq

// ---------------------------------------------------------------------
// ReadSel and WriteSel
//
// Whenever there is request to access the location zero, these pins are
// asserted depending on the condition of HWRITE pin.
// ---------------------------------------------------------------------
 assign NextWriteSel = (Width == 32) ?
                      HSEL & (HADDR == 'h100) & HWRITE & HTRANSValid :
                      HSEL & (HADDR == 'h200) & HWRITE & HTRANSValid;

 assign NextReadSel = (Width == 32) ?
                      HSEL & (HADDR == 'h100) & ~HWRITE & HTRANSValid :
                      HSEL & (HADDR == 'h200) & ~HWRITE & HTRANSValid;

 always @(posedge HCLK or negedge HRESETn)
 begin : p_WriteSelSeq
    if (HRESETn == 1'b0)
       WriteSel <= 1'b0;
    else
       WriteSel <= NextWriteSel;
 end // p_WriteSelSeq

 always @(posedge HCLK or negedge HRESETn)
 begin : p_ReadSelSeq
    if(HRESETn == 1'b0)
       ReadSel <= 1'b0;
    else
       ReadSel <= NextReadSel;
 end // p_ReadSelSeq

//  --------------------------------------------------------------------
//  DataWrite Generation
//
//  --------------------------------------------------------------------
 assign NextDataWrite = HWRITE & HSEL & HTRANSValid;
 assign NextRead = (~HWRITE) & (HADDR == 'h100) & HTRANSValid;

 always @(posedge HCLK or negedge HRESETn)
 begin : p_ReadSeq
   if(HRESETn == 1'b0)
     begin
       Read      <= 1'b0;
       DataWrite <= 1'b0;
     end
   else
     begin
       Read      <= NextRead;
       DataWrite <= NextDataWrite;
     end
 end // p_ReadSeq

//  --------------------------------------------------------------------
//  MASTERCTRLWr and MASTERCTRLRd Generation
//
//  Whenever there is request to access the location zero, these pins
//  are asserted depending on the condition of HWRITE pin.
//  --------------------------------------------------------------------

 assign MASTERCTRLSel = HSEL & (HADDR == 'h000) & HTRANSValid;

 assign NextMASTERCTRLWr = MASTERCTRLSel & HWRITE;
 assign NextMASTERCTRLRd = MASTERCTRLSel & (~HWRITE);

 always @(posedge HCLK or negedge HRESETn)
 begin : p_MASTERCTRLWrSeq
    if (HRESETn == 1'b0)
       MASTERCTRLWr <= 1'b0;
    else
       MASTERCTRLWr <= NextMASTERCTRLWr;
 end // p_MASTERCTRLWrSeq

 always @(posedge HCLK or negedge HRESETn)
 begin : p_MASTERCTRLRdSeq
   if (HRESETn == 1'b0)
      MASTERCTRLRd <= 1'b0;
    else
      MASTERCTRLRd <= NextMASTERCTRLRd;
 end // p_MASTERCTRLRdSeq

// ---------------------------------------------------------------------
// MASTERCTRL Register Assignments
// ---------------------------------------------------------------------
 assign NextMASTERCTRL = MASTERCTRLWr ? HWDATA[14:0] : MASTERCTRL;

 always @(posedge HCLK or negedge HRESETn)
 begin : p_MASTERCTRLSeq
    if(HRESETn == 1'b0)
       MASTERCTRL <= 14'b00;
    else
       MASTERCTRL <= NextMASTERCTRL;
 end // p_MASTERCTRLSeq

// ---------------------------------------------------------------------
// MASTERCTRL Read Output to HRDATA
// ---------------------------------------------------------------------
assign HRDATA = (MASTERCTRLRd) ? {ZEROFILL[Width-1:15], MASTERCTRL}    :
                (Read)    ? DOut                                       :
                (SnpRd) ? (Width == 32 ? SnpDOut                       :
                                {ZEROFILL[Width-1:Width-32],SnpDOut})  :
                (Width == 32 ) ? 32'h00000000                          :
                                64'h0000000000000000;

assign DIn = DataWrite ? HWDATA : 'h00000000;

endmodule

// --============================== End ==============================--
