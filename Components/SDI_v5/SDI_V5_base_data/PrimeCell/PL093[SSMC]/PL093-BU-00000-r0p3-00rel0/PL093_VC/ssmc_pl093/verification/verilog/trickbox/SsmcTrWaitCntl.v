// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcTrWaitCntl.v.rca
// File Revision          : 1.9
//
// Release Information    : PrimeCell(TM)-PL093-r0p1-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module routes the SMWAIT signal and asserts the CancelSMWAIT
//           signal when the SMWAIT signal gets timed-out.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcTrWaitCntl (
// Inputs
                      // AHB bus signals
                      SMMemCLK,
                      HRESETn,
                      nSSMCS,
                      SMADDR,
                      SSMCTrCS2WTR0,
                      SSMCTrCS2WTR1,
                      SSMCTrCS2WTR2,
                      SSMCTrCS2WTR3,
                      SSMCTrCS2WTR4,
                      SSMCTrCS2WTR5,
                      SSMCTrCS2WTR6,
                      SSMCTrCS2WTR7,
                      SSMCTrWTCNCL,
                      SMMemClkRatio,

// Outputs
                      SMWAIT,
                      SMCANCELWAIT
                     );

parameter Tclk = 10.56;        // HCLK Period

// Inputs

// AHB bus signals
input         SMMemCLK;      // Memory Clock
input         HRESETn;       // Bus Reset
input   [7:0] nSSMCS;        // Active low Memory Bank Select
input  [11:0] SMADDR;        // External Address Bus
input  [11:0] SSMCTrCS2WTR0; // nCS-SSMCTrnWAIT assertion delay for Bank 0
input  [11:0] SSMCTrCS2WTR1; // nCS-SSMCTrnWAIT assertion delay for Bank 1
input  [11:0] SSMCTrCS2WTR2; // nCS-SSMCTrnWAIT assertion delay for Bank 2
input  [11:0] SSMCTrCS2WTR3; // nCS-SSMCTrnWAIT assertion delay for Bank 3
input  [11:0] SSMCTrCS2WTR4; // nCS-SSMCTrnWAIT assertion delay for Bank 4
input  [11:0] SSMCTrCS2WTR5; // nCS-SSMCTrnWAIT assertion delay for Bank 5
input  [11:0] SSMCTrCS2WTR6; // nCS-SSMCTrnWAIT assertion delay for Bank 6
input  [11:0] SSMCTrCS2WTR7; // nCS-SSMCTrnWAIT assertion delay for Bank 7
input   [8:0] SSMCTrWTCNCL;  // SMCANCELWAIT assertion delay
input   [1:0] SMMemClkRatio; // Clock Ratio

// Outputs
output        SMWAIT;       // External Wait signal routed to the SMC
output        SMCANCELWAIT; // External Wait time out signal

// Inputs

// AHB bus signals
  wire        SMMemCLK;      // Memory Clock
  wire        HRESETn;       // Bus Reset
  wire  [7:0] nSSMCS;        // Active low Memory Bank Select
  wire [25:0] SMADDR;        // External Address Bus
  wire [11:0] SSMCTrCS2WTR0; // nCS-SSMCTrnWAIT assertion delay for Bank 0
  wire [11:0] SSMCTrCS2WTR1; // nCS-SSMCTrnWAIT assertion delay for Bank 1
  wire [11:0] SSMCTrCS2WTR2; // nCS-SSMCTrnWAIT assertion delay for Bank 2
  wire [11:0] SSMCTrCS2WTR3; // nCS-SSMCTrnWAIT assertion delay for Bank 3
  wire [11:0] SSMCTrCS2WTR4; // nCS-SSMCTrnWAIT assertion delay for Bank 4
  wire [11:0] SSMCTrCS2WTR5; // nCS-SSMCTrnWAIT assertion delay for Bank 5
  wire [11:0] SSMCTrCS2WTR6; // nCS-SSMCTrnWAIT assertion delay for Bank 6
  wire [11:0] SSMCTrCS2WTR7; // nCS-SSMCTrnWAIT assertion delay for Bank 7
  wire  [8:0] SSMCTrWTCNCL;  // SMCANCELWAIT assertion delay
  wire  [1:0] SMMemClkRatio; // Clock Ratio

// Outputs
  wire        SMWAIT;        // External Wait signal routed to the SMC
  reg         SMCANCELWAIT;  // External Wait time out signal


// -----------------------------------------------------------------------------
//
//                                SmcTrWaitCntl
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// SSMC Tricbox is an AHB slave. This block performs the following operations:
//   - Routes the SMWAIT signal according to the selected Memory Bank.
//   - Asserts the SMCANCELWAIT signal when the SMWAIT signal gets timed out.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [25:0] DelSMADDR;
// Delayed SMADDR

wire  [7:0] WaitEn;
// The Wait Enable of the Memory Banks

wire  [7:0] WaitPol;
// The Wait Polarity of the Memory Banks

wire [31:0] IntCS2WTR0;
// Memory Chip Select to SMWAIT assertion delay time for Bank 0

wire [31:0] IntWT2DeWTR0;
// SMWAIT assertion to de-assertion delay time for Bank 0

wire [31:0] IntCS2WTR1;
// Memory Chip Select to SMWAIT assertion delay time for Bank 1

wire [31:0] IntWT2DeWTR1;
// SMWAIT assertion to de-assertion delay time for Bank 1

wire [31:0] IntCS2WTR2;
// Memory Chip Select to SMWAIT assertion delay time for Bank 2

wire [31:0] IntWT2DeWTR2;
// SMWAIT assertion to de-assertion delay time for Bank 2

wire [31:0] IntCS2WTR3;
// Memory Chip Select to SMWAIT assertion delay time for Bank 3

wire [31:0] IntWT2DeWTR3;
// SMWAIT assertion to de-assertion delay time for Bank 3

wire [31:0] IntCS2WTR4;
// Memory Chip Select to SMWAIT assertion delay time for Bank 4

wire [31:0] IntWT2DeWTR4;
// SMWAIT assertion to de-assertion delay time for Bank 4

wire [31:0] IntCS2WTR5;
// Memory Chip Select to SMWAIT assertion delay time for Bank 5

wire [31:0] IntWT2DeWTR5;
// SMWAIT assertion to de-assertion delay time for Bank 5

wire [31:0] IntCS2WTR6;
// Memory Chip Select to SMWAIT assertion delay time for Bank 6

integer temp2;
wire [31:0] IntWT2DeWTR6;
// SMWAIT assertion to de-assertion delay time for Bank 6

wire [31:0] IntCS2WTR7;
// Memory Chip Select to SMWAIT assertion delay time for Bank 7

wire [31:0] IntWT2DeWTR7;
// SMWAIT assertion to de-assertion delay time for Bank 7

wire [6:0] IntTOUT;
// Time out period for the External Wait transfer, this will assert SMCANCELWAIT

wire [6:0] TOUT;
// Time out value for the External Wait transfer, this will assert SMCANCELWAIT

wire     SMWAITIgnore;
// This is to ignore SMWAIT signal for SMCANCELWAIT assertion 

wire     SMCnclEn;
// This is to put SMCANCELWAIT signal masked
 
// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         SMWAIT4In;
// Internal version of the SMWAIT (Active LOW)

reg         SelWaitPol;
// The Wait Polarity of the Selected Memory

reg         CancelAssrt;
// Indicates that the SMADDR is changed and it is stable

reg   [6:0] WaitCount;
// External Wait State Counter

//reg   [6:0] TOUT;
// Time out value for the External Wait transfer, this will assert SMCANCELWAIT
 
reg   [1:0] ClkFactor;
// Memory Clock factor

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
// ClkFactor determination
// -----------------------------------------------------------------------------
always @(SMMemClkRatio)
begin : p_ClkFactorComb
  case (SMMemClkRatio)
    2'b00   : ClkFactor = 2'b01;
    2'b01   : ClkFactor = 2'b10;
    2'b10   : ClkFactor = 2'b11;
    default : ClkFactor = 2'b01;
  endcase
end // p_ClkFactorComb

// -----------------------------------------------------------------------------

initial
begin
  SMWAIT4In    = 1'b1;
  temp2 = Tclk*10;
end

// -----------------------------------------------------------------------------
// SMCTrCS2WT Register field rename
// -----------------------------------------------------------------------------
assign WaitEn           = {SSMCTrCS2WTR7[11], SSMCTrCS2WTR6[11],
                           SSMCTrCS2WTR5[11], SSMCTrCS2WTR4[11],
                           SSMCTrCS2WTR3[11], SSMCTrCS2WTR2[11],
                           SSMCTrCS2WTR1[11], SSMCTrCS2WTR0[11]};

assign WaitPol          = {SSMCTrCS2WTR7[10], SSMCTrCS2WTR6[10],
                           SSMCTrCS2WTR5[10], SSMCTrCS2WTR4[10],
                           SSMCTrCS2WTR3[10], SSMCTrCS2WTR2[10],
                           SSMCTrCS2WTR1[10], SSMCTrCS2WTR0[10]};

// -----------------------------------------------------------------------------
// Converting std_logic_vector to time.
// -----------------------------------------------------------------------------
assign IntWT2DeWTR0        = (SSMCTrCS2WTR0[4:0] * ClkFactor * temp2)/10;
assign IntWT2DeWTR1        = (SSMCTrCS2WTR1[4:0] * ClkFactor * temp2)/10;
assign IntWT2DeWTR2        = (SSMCTrCS2WTR2[4:0] * ClkFactor * temp2)/10;
assign IntWT2DeWTR3        = (SSMCTrCS2WTR3[4:0] * ClkFactor * temp2)/10;
assign IntWT2DeWTR4        = (SSMCTrCS2WTR4[4:0] * ClkFactor * temp2)/10;
assign IntWT2DeWTR5        = (SSMCTrCS2WTR5[4:0] * ClkFactor * temp2)/10;
assign IntWT2DeWTR6        = (SSMCTrCS2WTR6[4:0] * ClkFactor * temp2)/10;
assign IntWT2DeWTR7        = (SSMCTrCS2WTR7[4:0] * ClkFactor * temp2)/10;
assign IntCS2WTR0          = (SSMCTrCS2WTR0[9:5] * ClkFactor * temp2)/10;
assign IntCS2WTR1          = (SSMCTrCS2WTR1[9:5] * ClkFactor * temp2)/10;
assign IntCS2WTR2          = (SSMCTrCS2WTR2[9:5] * ClkFactor * temp2)/10;
assign IntCS2WTR3          = (SSMCTrCS2WTR3[9:5] * ClkFactor * temp2)/10;
assign IntCS2WTR4          = (SSMCTrCS2WTR4[9:5] * ClkFactor * temp2)/10;
assign IntCS2WTR5          = (SSMCTrCS2WTR5[9:5] * ClkFactor * temp2)/10;
assign IntCS2WTR6          = (SSMCTrCS2WTR6[9:5] * ClkFactor * temp2)/10;
assign IntCS2WTR7          = (SSMCTrCS2WTR7[9:5] * ClkFactor * temp2)/10;
assign IntTOUT             = (SSMCTrWTCNCL[6:0]  * ClkFactor * temp2)/10;

assign TOUT                = SSMCTrWTCNCL[6:0];
// -----------------------------------------------------------------------------
// Generation of Delayed SMADDR
// -----------------------------------------------------------------------------
assign # 3 DelSMADDR        = SMADDR;

// -----------------------------------------------------------------------------
// Ignore the SMWAIT signal for the asertion of SMCANCELWAIT signal
// -----------------------------------------------------------------------------

assign SMWAITIgnore         = SSMCTrWTCNCL[7];
assign SMCnclEn             = SSMCTrWTCNCL[8]; 

// -----------------------------------------------------------------------------
// Choose the Wait Polarity of the selected Memory
// -----------------------------------------------------------------------------
always @(SMWAIT4In or nSSMCS or WaitPol)
begin : p_WaitPolSelComb
  if (SMWAIT4In == 1'b1)
    begin
      if (nSSMCS[0] == 1'b0)
        SelWaitPol = WaitPol[0];
      else if (nSSMCS[1] == 1'b0)
        SelWaitPol = WaitPol[1];
      else if (nSSMCS[2] == 1'b0)
        SelWaitPol = WaitPol[2];
      else if (nSSMCS[3] == 1'b0)
        SelWaitPol = WaitPol[3];
      else if (nSSMCS[4] == 1'b0)
        SelWaitPol = WaitPol[4];
      else if (nSSMCS[5] == 1'b0)
        SelWaitPol = WaitPol[5];
      else if (nSSMCS[6] == 1'b0)
        SelWaitPol = WaitPol[6];
      else if (nSSMCS[7] == 1'b0)
        SelWaitPol = WaitPol[7];
      else
        SelWaitPol = WaitPol[0];
    end
end // p_WaitPolSelComb

// -----------------------------------------------------------------------------
// Combinational logic for the Assertion and de-Assertion of the SMWAIT
// signal
// -----------------------------------------------------------------------------
//always @(nSSMCS or DelSMADDR or  SMWAIT4In or WaitEn)
always @(nSSMCS or SMWAIT4In or WaitEn)
//always @(nSSMCS or DelSMADDR or negedge SMWAIT4In or WaitEn)
//        or IntCS2WTR0 or IntCS2WTR1 or IntCS2WTR2 or IntCS2WTR3 or IntCS2WTR4
//        or IntCS2WTR5 or IntCS2WTR6 or IntCS2WTR7 or IntTOUT)
begin : p_SMWAITComb
    if (SMWAIT4In == 1'b1)
      begin
        if ((nSSMCS[0] == 1'b0) && (WaitEn[0] == 1'b1))
          begin
              # (IntCS2WTR0 - 3) SMWAIT4In <= 1'b0;
          end
        else if ((nSSMCS[1] == 1'b0) && (WaitEn[1] == 1'b1))
          begin
              # (IntCS2WTR1 - 3) SMWAIT4In <= 1'b0;
          end
        else if ((nSSMCS[2] == 1'b0) && (WaitEn[2] == 1'b1))
          begin
              # (IntCS2WTR2 - 3) SMWAIT4In <= 1'b0;
          end
        else if ((nSSMCS[3] == 1'b0) && (WaitEn[3] == 1'b1))
          begin
              # (IntCS2WTR3 - 3) SMWAIT4In <= 1'b0;
          end
        else if ((nSSMCS[4] == 1'b0) && (WaitEn[4] == 1'b1))
          begin
              # (IntCS2WTR4 - 3) SMWAIT4In <= 1'b0;
          end
        else if ((nSSMCS[5] == 1'b0) && (WaitEn[5] == 1'b1))
          begin
              # (IntCS2WTR5 - 3) SMWAIT4In <= 1'b0;
          end
        else if ((nSSMCS[6] == 1'b0) && (WaitEn[6] == 1'b1))
          begin
              # (IntCS2WTR6 - 3) SMWAIT4In <= 1'b0;
          end
        else if ((nSSMCS[7] == 1'b0) && (WaitEn[7] == 1'b1))
          begin
              # (IntCS2WTR7 - 3) SMWAIT4In <= 1'b0;
          end
        else
          SMWAIT4In <= 1'b1;
      end
  else if (SMWAIT4In == 1'b0)
    begin
      if ((nSSMCS[0] == 1'b0) && (WaitEn[0] == 1'b1))
        # (IntWT2DeWTR0 - 3) SMWAIT4In = 1'b1;
      else if ((nSSMCS[1] == 1'b0) && (WaitEn[1] == 1'b1))
        # (IntWT2DeWTR1 - 3) SMWAIT4In = 1'b1;
      else if ((nSSMCS[2] == 1'b0) && (WaitEn[2] == 1'b1))
        # (IntWT2DeWTR2 - 3) SMWAIT4In = 1'b1;
      else if ((nSSMCS[3] == 1'b0) && (WaitEn[3] == 1'b1))
        # (IntWT2DeWTR3 - 3) SMWAIT4In = 1'b1;
      else if ((nSSMCS[4] == 1'b0) && (WaitEn[4] == 1'b1))
        # (IntWT2DeWTR4 - 3) SMWAIT4In = 1'b1;
      else if ((nSSMCS[5] == 1'b0) && (WaitEn[5] == 1'b1))
        # (IntWT2DeWTR5 - 3) SMWAIT4In = 1'b1;
      else if ((nSSMCS[6] == 1'b0) && (WaitEn[6] == 1'b1))
        # (IntWT2DeWTR6 - 3) SMWAIT4In = 1'b1;
      else if ((nSSMCS[7] == 1'b0) && (WaitEn[7] == 1'b1))
        # (IntWT2DeWTR7 - 3) SMWAIT4In = 1'b1;
//      else if (CancelAssrt == 1'b0)
//        SMWAIT4In = 1'b1;
    end
end // p_SMWAITComb

// -----------------------------------------------------------------------------
// Process to count for the External WAIT time-out
// -----------------------------------------------------------------------------
always @(posedge SMMemCLK or negedge HRESETn)
begin : p_ExtWAITCntSeq
  if (HRESETn == 1'b0)
    WaitCount <= 7'b0000000;
  else
    begin
      if (SMWAITIgnore == 1'b1)
        begin
          if (SMWAIT4In == 1'b0)
            begin
              if (WaitCount < TOUT)
                WaitCount <= WaitCount + 1;
              else 
                WaitCount <= 7'b0000000;
            end
          else
            WaitCount <= 7'b0000000;
        end
      else if (SMWAITIgnore == 1'b0)
        begin
         if (WaitCount <= TOUT)
           WaitCount <= WaitCount + 1;
         else 
           WaitCount <= 7'b0000000;
        end
    end
end // p_ExtWAITCntSeq

// -----------------------------------------------------------------------------
// Process to generate CancelSMWAIT
// -----------------------------------------------------------------------------
always @( WaitCount or negedge HRESETn)
begin : p_CanSMWAITComb
  if (HRESETn == 1'b0)
    SMCANCELWAIT <= 1'b0;
  else if ((WaitCount == TOUT) && (SMCnclEn == 1'b1)) 
        SMCANCELWAIT <= 1'b1;
  else
        SMCANCELWAIT <= 1'b0;
end // p_CanSMWAITComb

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
assign SMWAIT           = SMWAIT4In ^ SelWaitPol;

endmodule
// --================================= End ===================================--
