// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacTrickInteg.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is the top level of the Dmac.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrickInteg (
// Inputs
                       // Clock and reset
                       HCLK,
                       HRESETn,
                       // AHB slave signals
                       HSELDMACTr,
                       HWRITE,
                       HTRANS,
                       HADDR,
                       HSIZE,
                       HREADYIN,
                       HREADYINM,
                       HWDATA,
                       // AHB master signals
                       HBUSREQDMAM,
                       HLOCKDMAM,
                       HTRANSM,
                       HADDRM,
                       HSIZEM,
                       HBURSTM,
                       HPROTM,
                       HWRITEM,
                       HWDATAM,
// Outputs
                       // AHB master signals
                       HREADYOUT,
                       HRESP,
                       HRDATA,
                       HGRANTDMAM,
                       HRESPM,
                       HREADYOUTM,
                       HRDATAM
                       );

// Inputs

// Clock and reset
input         HCLK;         // AHB clock
input         HRESETn;      // AHB reset

// AHB slave signals
input         HSELDMACTr;   // Trickbox Select from AHB3
input         HWRITE;       // Transfer direction
input         HTRANS;       // Type of transfer on AHB Only HTRANS(1) of the
                            // slave AHB should connect
input  [20:2] HADDR;        // AHB address bus
input   [2:0] HSIZE;        // The width of the transfer on AHB3
input         HREADYIN;     // Transfer done response on AHB3
input         HREADYINM;    // Transfer done response on AHB
input  [31:0] HWDATA;       // AHB slave write data

// AHB master signals
input         HBUSREQDMAM;  // Bus request signal to the AHB arbiter 
input         HLOCKDMAM;    // Indicates locked-burst request on AHB 
input   [1:0] HTRANSM;      // Type of transfer on AHB
input  [31:0] HADDRM;       // AHB address bus
input   [2:0] HSIZEM;       // Width of transfer on AHB
input   [2:0] HBURSTM;      // Burst length on AHB
input   [3:0] HPROTM;       // Protection information on AHB
input         HWRITEM;      // Transfer direction on AHB
input  [31:0] HWDATAM;      // Write data on AHB

// Outputs

// AHB master signals
output        HREADYOUT;    // Transfer done response for AHB3
output  [1:0] HRESP;        // Transfer response for AHB3
output [31:0] HRDATA;       // Read Data for AHB 3
output        HGRANTDMAM;   // AHB bus grant for master
output  [1:0] HRESPM;       // Transfer response for AHB
output        HREADYOUTM;   // Transfer done response for AHB
output [31:0] HRDATAM;      // Read Data for AHB Master




// Inputs

// Clock and reset
  wire        HCLK;         // AHB clock
  wire        HRESETn;      // AHB reset

// AHB slave signals
  wire        HSELDMACTr;   // Trickbox Select from AHB3
  wire        HWRITE;       // Transfer direction
  wire        HTRANS;       // Type of transfer on AHB Only HTRANS(1) of the
                            // slave AHB should connect
  wire [20:2] HADDR;        // AHB address bus
  wire  [2:0] HSIZE;        // The width of the transfer on AHB3
  wire        HREADYIN;     // Transfer done response on AHB3
  wire        HREADYINM;    // Transfer done response on AHB
  wire [31:0] HWDATA;       // AHB slave write data

// AHB master signals
  wire        HBUSREQDMAM;  // Bus request signal to the AHB arbiter 
  wire        HLOCKDMAM;    // Indicates locked-burst request on AHB 
  wire  [1:0] HTRANSM;      // Type of transfer on AHB
  wire [31:0] HADDRM;       // AHB address bus
  wire  [2:0] HSIZEM;       // Width of transfer on AHB
  wire  [2:0] HBURSTM;      // Burst length on AHB
  wire  [3:0] HPROTM;       // Protection information on AHB
  wire        HWRITEM;      // Transfer direction on AHB
  wire [31:0] HWDATAM;      // Write data on AHB

// Outputs

// AHB master signals
  wire        HREADYOUT;    // Transfer done response for AHB3
  wire  [1:0] HRESP;        // Transfer response for AHB3
  wire [31:0] HRDATA;       // Read Data for AHB 3
  wire        HGRANTDMAM;   // AHB bus grant for master
  wire  [1:0] HRESPM;       // Transfer response for AHB
  wire        HREADYOUTM;   // Transfer done response for AHB
  wire [31:0] HRDATAM;      // Read Data for AHB Master


// -----------------------------------------------------------------------------
//
//                              DmacTrickInteg
//                              ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the Trickbox. This block instantiates the
// following functional sub-blocks in the trickbox.
//      - DmacTrMem
//      - DmacTrAhbArb
//
// -----------------------------------------------------------------------------


// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define SLAVEADDRLB       2
// Lower bit of Slave address used by memory or peripheral module.

`define SLAVEADDRHB       9
// Higher bit of Slave address used by memory or peripheral module.

`define MASTERADDRLB      0
// Lower bit of Slave address used by memory or peripheral module.

`define MASTERADDRHB      26
// Higher bit of Slave address used by memory or peripheral module.

// ----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire                         [1:0] HTRANSInt;
wire                        [17:0] ReqConfig;

// Memory Module1 signal
wire                               HSELREGuM0;
wire                               HREADYOUTuM0;
wire                         [1:0] HRESPuM0;
wire                        [31:0] HRDATAuM0;
wire                               HSELMEMuM0;
wire                               HREADYOUTMuM0;
wire                         [1:0] HRESPMuM0;
wire                        [31:0] HRDATAMuM0;

// Register declarations
// ---------------------------------------------------------------------
reg                         [31:0] iHRDATAM;
reg                          [1:0] iHRESPM;
reg                                iHREADYOUTM;

reg                                iHREADYOUT;
reg                         [31:0] iHRDATA;
reg                          [1:0] iHRESP;

reg  [`MASTERADDRHB:`MASTERADDRLB] HADDRMuM0;
reg                                HWRITEMuM0;
reg                          [1:0] HTRANSMuM0;
reg                          [2:0] HSIZEMuM0;
reg                          [2:0] HBURSTMuM0;
reg                         [31:0] HWDATAMuM0;
reg                                HREADYINMuM0;
reg                                RegSyncMem0;

reg                                SyncMem0;

reg                                NxtRegSyncMem0;

reg                                NxtSyncMem0;

// -----------------------------------------------------------------------------
// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------
 
 
assign HTRANSInt        = {HTRANS, 1'b0};

assign HSELREGuM0       = ((HADDR[20:16] == 5'b00001) && (HSELDMACTr == 1'b1))
                            ? 1'b1 : 1'b0;

assign HSELMEMuM0       = 1'b1;

// -----------------------------------------------------------------------------
// Instantiation of Memory module 1
// -----------------------------------------------------------------------------
DmacTrMem uM0DmacTrMem (
        .HCLK           (HCLK),
        .HRESETn        (HRESETn),
        .HADDR          (HADDR[`SLAVEADDRHB : `SLAVEADDRLB]),
        .HSELREG        (HSELREGuM0),
        .HWRITE         (HWRITE),
        .HTRANS         (HTRANSInt),
        .HSIZE          (HSIZE),
        .HWDATA         (HWDATA),
        .HREADYIN       (HREADYIN),
        .HREADYOUT      (HREADYOUTuM0),
        .HRESP          (HRESPuM0),
        .HRDATA         (HRDATAuM0),
        .HADDRM         (HADDRMuM0[`MASTERADDRHB:`MASTERADDRLB]),
        .HSELMEM        (HSELMEMuM0),
        .HWRITEM        (HWRITEMuM0),
        .HTRANSM        (HTRANSMuM0),
        .HBURSTM        (HBURSTMuM0),
        .HSIZEM         (HSIZEMuM0),
        .HWDATAM        (HWDATAMuM0),
        .HREADYINM      (HREADYINMuM0),
        .HREADYOUTM     (HREADYOUTMuM0),
        .HRESPM         (HRESPMuM0),
        .HRDATAM        (HRDATAMuM0)
           );

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Instantiation of AHB arbiter for AHB 
// -----------------------------------------------------------------------------
DmacTrAhbArb u2DmacTrAhbArb (
        .HCLK           (HCLK),
        .HRESETn        (HRESETn),
        .HREADYINM      (HREADYINM),
        .HBUSREQDMAM    (HBUSREQDMAM),
        .HBURSTM        (HBURSTM),
        .HLOCKDMAM      (HLOCKDMAM),
        .HGRANTDMAM     (HGRANTDMAM)
           );

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Control Information Latching Block 
// -----------------------------------------------------------------------------
always @(ReqConfig or HSELMEMuM0 or HADDRM or HWRITEM or HSIZEM or HBURSTM or 
         HTRANSM or HREADYINM or SyncMem0) 
begin : p_ControlInfoComb
  NxtSyncMem0      = SyncMem0;
  if (HSELMEMuM0 == 1'b1)
    begin
      HADDRMuM0        = HADDRM[`MASTERADDRHB:`MASTERADDRLB];
      HWRITEMuM0       = HWRITEM;
      HTRANSMuM0       = HTRANSM;
      HSIZEMuM0        = HSIZEM;
      HBURSTMuM0       = HBURSTM;
      HREADYINMuM0     = HREADYINM;
    end
  else
    begin
      HADDRMuM0        = 27'b0;
      HWRITEMuM0       = 1'b0;
      HTRANSMuM0       = 2'b0;
      HSIZEMuM0        = 3'b0;
      HBURSTMuM0       = 3'b0;
      HREADYINMuM0     = 1'b0;
    end
        
  if (HREADYINM == 1'b1)
    begin
      if (HSELMEMuM0 == 1'b1)
        NxtSyncMem0      = 1'b1;
      else
        NxtSyncMem0      = 1'b0;
    end

end // p_ControlInfoComb

// -----------------------------------------------------------------------------
// Sync Sequential Block 
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SyncSeq
  if (HRESETn == 1'b0)
    begin
      SyncMem0         <= 1'b0;
    end
  else
    begin
      SyncMem0         <= NxtSyncMem0;
    end
end // p_SyncSeq

// -----------------------------------------------------------------------------
// Read Write Data assignment Block
// -----------------------------------------------------------------------------
always @(SyncMem0 or HREADYOUTMuM0 or HRESPMuM0 or HRDATAMuM0 or HRDATAM or 
         ReqConfig or HRESETn)
begin : p_DataComb
  if (HRESETn == 1'b0)
    begin
      iHREADYOUTM      = 1'b1;
      iHRESPM          = 2'd0;
      iHRDATAM         = 32'd0;
    end

  if (SyncMem0 == 1'b1)
    begin
      HWDATAMuM0       = HWDATAM;
      iHREADYOUTM      = HREADYOUTMuM0;
      iHRESPM          = HRESPMuM0;
      iHRDATAM         = HRDATAMuM0;
    end
  else
    HWDATAMuM0         = 32'd0;

end // p_DataComb

// -----------------------------------------------------------------------------
// RegSync Generation Block  
// -----------------------------------------------------------------------------
always @(HSELREGuM0 or RegSyncMem0 )
begin : p_RegAssignComb
  NxtRegSyncMem0   = RegSyncMem0;

  if (HSELREGuM0 == 1'b1)
    NxtRegSyncMem0   = 1'b1;
  else
    NxtRegSyncMem0   = 1'b0;
    
end // p_RegAssignComb

// -----------------------------------------------------------------------------
// RegSync Sequential Block  
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegSeq
  if (HRESETn == 1'b0)
    begin
      RegSyncMem0      <= 1'b0;
    end
  else
    begin
      RegSyncMem0      <= NxtRegSyncMem0;
    end
end // p_RegSeq

// -----------------------------------------------------------------------------
// Read Write Data combo block.
// -----------------------------------------------------------------------------
always @(RegSyncMem0 or HREADYOUTuM0 or HRESPuM0 or HRDATAuM0 or HRESETn)
begin : p_RegDataComb
    
  if (HRESETn == 1'b0)
    begin
      iHREADYOUT       = 1'b1;
      iHRESP           = 2'd0;
      iHRDATA          = 32'd0;
    end

  if (RegSyncMem0 == 1'b1)
    begin
      iHREADYOUT       = HREADYOUTuM0;
      iHRESP           = HRESPuM0;
      iHRDATA          = HRDATAuM0;
    end

end // p_RegDataComb

// -----------------------------------------------------------------------------
// Assigning the internal signals to the outputs
// -----------------------------------------------------------------------------
assign HREADYOUT        = iHREADYOUT;
assign HRESP            = iHRESP;
assign HRDATA           = iHRDATA;
assign HREADYOUTM       = iHREADYOUTM;
assign HRESPM           = iHRESPM;
assign HRDATAM          = iHRDATAM;

endmodule
// --================================== End ==================================--
