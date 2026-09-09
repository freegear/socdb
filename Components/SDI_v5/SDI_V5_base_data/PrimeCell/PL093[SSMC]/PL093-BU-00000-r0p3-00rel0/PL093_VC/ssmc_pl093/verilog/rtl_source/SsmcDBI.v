// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcDBI.v.rca
// File Revision          : 1.9
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block does arbitration between TIC request and SsmcCore
//           request.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcDBI (
// Inputs
                HCLK,
                HRESETn,
                SMTICBUSGNTExt,
                SMBUSGNTExt,
                SmBusBackOffExt,
                BUSMUXEXT,
                SMBUSREQ,
                TICBUSREQ,
                TBUSOUT,
                TICREAD,
                SmDataEnCore,
                SmDataOutCore,
// Outputs
                SMBUSREQExt,
                SMTICBUSREQExt,
                SMDATAOUT,
                nSMDATAEN,
                TICBUSGNT,
                SMBUSGNT
               );

// Inputs
input         HCLK;            // Memory Clock
input         HRESETn;         // AHB system level Reset
input         SMTICBUSGNTExt;  // External bus granted for TIC Transfer
input         SMBUSGNTExt;     // External bus granted for Memory Transfer
input         SmBusBackOffExt; // Registered version of SMBUSBACKOFFEBI
input         BUSMUXEXT;       // Indication to either use Internal DBI or
                               // External EBI
input         SMBUSREQ;        // Internal Bus Request from Memory TSM to DBI
input         TICBUSREQ;       // Internal Bus Request from TIC to DBI
input  [31:0] TBUSOUT;         // TIC output Data bus
input         TICREAD;         // Pad enable from TIC
input   [3:0] SmDataEnCore;    // Data Enables when Write is progressing
input  [31:0] SmDataOutCore;   // Data Bus output from SSMC

// Outputs
output        SMBUSREQExt;     // Request EBI for Memory Transfer
output        SMTICBUSREQExt;  // Request EBI for TIC Transfer
output [31:0] SMDATAOUT;       // Data Bus output from SSMC to Memory
output  [3:0] nSMDATAEN;       // Tri-state I/O pad enable for the byte lanes
                               // of external memory data bus
output        TICBUSGNT;       // Bus Grant to TIC from DBI
output        SMBUSGNT;        // Bus Grant to SsmcCore from DBI




// Inputs
  wire        HCLK;            // Memory Clock
  wire        HRESETn;         // AHB system level Reset
  wire        SMTICBUSGNTExt;  // External bus granted for TIC Transfer
  wire        SMBUSGNTExt;     // External bus granted for Memory Transfer
  wire        SmBusBackOffExt; // Registered version of SMBUSBACKOFFEBI
  wire        BUSMUXEXT;       // Indication to either use Internal DBI or
                               // External EBI
  wire        SMBUSREQ;        // Internal Bus Request from Memory TSM to DBI
  wire        TICBUSREQ;       // Internal Bus Request from TIC to DBI
  wire [31:0] TBUSOUT;         // TIC output Data bus
  wire        TICREAD;         // Pad enable from TIC
  wire  [3:0] SmDataEnCore;    // Data Enables when Write is progressing
  wire [31:0] SmDataOutCore;   // Data Bus output from SSMC

// Outputs
  wire        SMBUSREQExt;     // Request EBI for Memory Transfer
  wire        SMTICBUSREQExt;  // Request EBI for TIC Transfer
  wire [31:0] SMDATAOUT;       // Data Bus output from SSMC to Memory
  wire  [3:0] nSMDATAEN;       // Tri-state I/O pad enable for the byte lanes
                               // of external memory data bus
  wire        TICBUSGNT;       // Bus Grant to TIC from DBI
  wire        SMBUSGNT;        // Bus Grant to SsmcCore from DBI


// -----------------------------------------------------------------------------
//
//                                   SsmcDBI
//                                   =======
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//          This module is responsible for carrying out Arbitration between
//          SsmcTIC and SsmcCore modules. The control signals are appropriately
//          multiplexed based on whether SsmcTIC or SsmcCore is granted.
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire     iSMBUSGNT;
// Internal version of SMBUSGNT

wire     iTICBUSGNT;
// Internal version of TICBUSGNT

// -----------------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg      TICBUSGNTdbi;
// TIC is granted when using DBI

reg      NextTICBUSGNT;
// D-Input of TICBUSGNTdbi register

reg      SMBUSGNTdbi;
// SSMCCore is granted when using DBI

reg      NextSMBUSGNT;
// D-Input of iSMBUSGNT register

// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Internal Signal Assignments
// -----------------------------------------------------------------------------
assign SMBUSGNT       = iSMBUSGNT;
assign TICBUSGNT      = iTICBUSGNT;

// -----------------------------------------------------------------------------
// Multiplexer to choose between the internal DBI and the external EBI for bus
// arbitration. When External EBI is used then this Mux selects the Grant from
// external EBI. If internal DBI is used then the Grant is selected from this
// module.
// -----------------------------------------------------------------------------
assign SMBUSREQExt    = (BUSMUXEXT == 1'b1) ? SMBUSREQ : 1'b0;

assign SMTICBUSREQExt = (BUSMUXEXT == 1'b1) ? TICBUSREQ : 1'b0;

assign iTICBUSGNT     = (BUSMUXEXT == 1'b1) ? SMTICBUSGNTExt : TICBUSGNTdbi;

assign iSMBUSGNT      = (BUSMUXEXT == 1'b1) ? (SMBUSGNTExt && SMBUSREQ &&
                                              (~SmBusBackOffExt)) : SMBUSGNTdbi;

// -----------------------------------------------------------------------------
// Grant generation logic.
// By default DBI grants to SsmcCore. But when TIC is requesting grant is
// switched to TIC. Switching of grant to TIC usually happens on Reset.
// -----------------------------------------------------------------------------
always @(SMBUSGNTdbi or TICBUSGNTdbi or TICBUSREQ)
begin : p_GntComb
  NextSMBUSGNT     = SMBUSGNTdbi;
  NextTICBUSGNT    = TICBUSGNTdbi;
  if (TICBUSREQ == 1'b1)
    begin
      NextSMBUSGNT     = 1'b0;
      NextTICBUSGNT    = 1'b1;
    end
end // p_GntComb

// -----------------------------------------------------------------------------
// Mux to select between SsmcCore or TIC Data, before driving out on SMDATAOUT.
// -----------------------------------------------------------------------------
assign SMDATAOUT   = (iTICBUSGNT == 1'b1) ? TBUSOUT : SmDataOutCore;

// -----------------------------------------------------------------------------
// Mux to select between SsmcCore or TIC Data Enables, before driving out on
// nSMDATAEN.
// -----------------------------------------------------------------------------
assign nSMDATAEN   = ((iTICBUSGNT == 1'b1) && (TICREAD == 1'b1)) ? 4'b0000 :
                      SmDataEnCore;

// -----------------------------------------------------------------------------
// Registering all Next state signals
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_GntSeq
  if (HRESETn == 1'b0)
    begin
      SMBUSGNTdbi      <= 1'b1;
      TICBUSGNTdbi     <= 1'b0;
    end
  else
    begin
      SMBUSGNTdbi      <= NextSMBUSGNT;
      TICBUSGNTdbi     <= NextTICBUSGNT;
    end
end // p_GntSeq

endmodule
// --================================== End ==================================--
