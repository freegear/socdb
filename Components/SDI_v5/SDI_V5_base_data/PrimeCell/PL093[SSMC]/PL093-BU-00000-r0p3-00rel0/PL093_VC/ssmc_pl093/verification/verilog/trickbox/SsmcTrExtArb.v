// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 2003 ARM Limited
//      ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcTrExtArb.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL093-r0p1-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module act as external bus arbitor for TIC and SSMC.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------
module SsmcTrExtArb (
// Inputs         
                     SMMemCLK,           
                     HRESETn,       
                     SMBUSREQEBI,   
                     SMTICBUSREQEBI,
                     SSMCTrExtMux,
// Outputs                         
                     SMBUSGNTEBI, 
                     BackOffSsmc,  
                     SMTICBUSGNTEBI
                    );

// Inputs
input      SMMemCLK;       // Memory Clock
input      HRESETn;        // Bus Reset
input      SMBUSREQEBI;    // SSMC request
input      SMTICBUSREQEBI; // TIC request
input [8:0]SSMCTrExtMux;   // External Arbitor register

//outputs

output     SMBUSGNTEBI;    // External bus granted to SSMC
output     BackOffSsmc;    // Backoff signal for SSMC      
output     SMTICBUSGNTEBI; // External bus granted to TIC


// Inputs
  wire      SMMemCLK;       // Memory Clock
  wire      HRESETn;        // Bus Reset
  wire      SMBUSREQEBI;    // SSMC request
  wire      SMTICBUSREQEBI; // TIC request
  wire [8:0]SSMCTrExtMux;   // External Arbitor register  
 
//outputs
  reg      SMBUSGNTEBI;    // External bus granted to SSMC
  reg      BackOffSsmc;    // Backoff signal for SSMC
  reg      SMTICBUSGNTEBI; // External bus granted to TIC
    

// -----------------------------------------------------------------------------
//
//                              SsmcTrExtArb
//                              ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// SSMC Tricbox is an AHB slave. This block performs the following operations:
//  - Implements the external bus arbitor.
//  - Takes the request from SSMC and TIC,with TIC has highest priority.
//  - Genarates the grant signal for TIC and SSMC saperately.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// wire declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg NextSMTICGNTEBI;
// D-Input of SMTICBUSGNTEBI

reg NextSMBUSGNTEBI;
// D-Input of SMBUSGNTEBI

reg NextBackOffSsmc;
// D-Input of BackOffSsmc
 
reg iSMTICBUSGNTEBI;
// Internal version of SMTICBUSGNTEBI

reg iSMBUSGNTEBI;
// Internal version of SMBUSGNTEBI

reg iBackOffSsmc;
// Internal version of BackOffSsmc


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
// Assigning the Request and Grant signals.
// -----------------------------------------------------------------------------
always @(iSMTICBUSGNTEBI or iSMBUSGNTEBI or iBackOffSsmc)
begin
  SMTICBUSGNTEBI <= iSMTICBUSGNTEBI;
  SMBUSGNTEBI    <= iSMBUSGNTEBI;
  BackOffSsmc    <= iBackOffSsmc;
end
 
always @(iSMTICBUSGNTEBI or iSMBUSGNTEBI or iBackOffSsmc or SSMCTrExtMux
                         or SMTICBUSREQEBI or SMBUSREQEBI)
begin : p_GntLogicComb
  NextSMTICGNTEBI <= iSMTICBUSGNTEBI;
  NextSMBUSGNTEBI <= iSMBUSGNTEBI;
  NextBackOffSsmc <= iBackOffSsmc;
  if (SSMCTrExtMux[0] == 1'b1)
    begin
      if (SMTICBUSREQEBI == 1'b1)
        NextSMTICGNTEBI <= 1'b1;
      else if (SMBUSREQEBI == 1'b1)
        begin
          NextSMBUSGNTEBI <= 1'b1;
          NextSMTICGNTEBI <= 1'b0;
          if (iSMBUSGNTEBI == 1'b1)
            NextBackOffSsmc <= 1'b1;
        end
      else
        begin
          NextSMBUSGNTEBI <= 1'b0;
          NextBackOffSsmc <= 1'b0;
          NextSMTICGNTEBI <= 1'b0;
        end
    end
end // p_GntLogicComb    
 
always @(posedge SMMemCLK or negedge HRESETn)
begin : p_GntLogicSeq
  if (HRESETn == 1'b0)
    begin
      iSMTICBUSGNTEBI <= 1'b1;
      iSMBUSGNTEBI    <= 1'b0;
      iBackOffSsmc    <= 1'b0;
    end
  else 
    begin
      iSMTICBUSGNTEBI <= NextSMTICGNTEBI;
      iSMBUSGNTEBI    <= NextSMBUSGNTEBI;
      iBackOffSsmc    <= NextBackOffSsmc;
    end
end // p_GntLogicSeq
    

endmodule
// --============================== END ======================================--
