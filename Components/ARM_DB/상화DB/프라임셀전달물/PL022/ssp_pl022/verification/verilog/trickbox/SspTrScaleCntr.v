//  --========================================================================--
//  This confidential  and  proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies  and  copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version  and  Release Control Information:
//  
//  File Name              : SspTrScaleCntr.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
// Purpose      : This module implements the SSPCLK-domain 
//                buffers of the 2-buffer synchronisation mechanism.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspTrScaleCntr( 
                      SSPCLK,
                      nSSPRES,
                      SSESync,
                      CR0UpdateSync,
                      CR1UpdateSync,
                      SSPTBCR0, 
                      SSPTBCR1,
                      SSPTBPRE,
                      SPO,   
                      SPH,  
                      DSS, 
                      SSPCLKDIV,
                      FRF,
                      SCR 
                     );

input         SSPCLK;         // Main SSP clock
input         nSSPRES;        // Muxed reset (from nSSPRST)
input         SSESync;        // SSP enable
input         CR0UpdateSync;  // SSCR0 update
input         CR1UpdateSync;  // SSCR0 update
input  [15:0] SSPTBCR0;       // 2nd buffer
input   [5:0] SSPTBCR1;       // 2nd buffer
input   [3:0] SSPTBPRE;       // Prescale Reg
output        SPO;            // SCLK polarity
output        SPH;            // SCLK phase
output        SSPCLKDIV;      // Prescaled Output
output  [3:0] DSS;            // Bits per frame
output  [1:0] FRF;            // Frame format
output  [7:0] SCR;            // Serial clk rate

// -----------------------------------------------------------------------------
//
//                            SspTrScaleCntr
//                            ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//  This module  contains the SSPCLK domain buffers of the SSP control
// registers. The distinct bit information from these buffers is separated out
//  and  driven as individual outputs.
// 
// -----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Wire declarations
// ----------------------------------------------------------------------------
wire        SSPCLK;
// Main SSP clock

wire        nSSPRES;
// Muxed reset (from nSSPRST)

wire        SSESync;
// SSP enable

wire        CR0UpdateSync;
// SSCR0 update

wire        CR1UpdateSync;
// SSCR0 update

wire [15:0] SSPTBCR0;
// 2nd buffer

wire  [5:0] SSPTBCR1;
// 2nd buffer

wire  [3:0] SSPTBPRE;
// Prescale Reg

wire        CR0Stg2WrEn;
// Load signal for the second stage buffer for SSPPTBCR0 register

wire        CR1Stg2WrEn;
// Load signal for the second stage buffer for SSPPTBCR1 register

// -----------------------------------------------------------------------------
// Register declarations 
// -----------------------------------------------------------------------------

reg  [6:0] SSPCPSC;
// SSP Clock Pre-Scale Counter

reg  [6:0] NextSSPCPSC;
// D-input of SSPCPSC

reg [15:0] CR0;
// Second stage buffer for SSPTBCR0

reg  [5:0] CR1;
// Second stage buffer for SSPTBCR0

reg [15:0] NextCR0;
// D-input of SSPTBCR0

reg  [5:0] NextCR1;
// D-input of SSPTBCR0

reg        DelCR0Update;
// Delayed version of SSPTBCR0UpdateSync

reg        DelCR1Update;
// Delayed version of SSPTBCR0UpdateSync

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Prescaler to divide SSPCLK by the value programmed in SSCPSR register
//------------------------------------------------------------------------------
  always @(posedge SSPCLK or negedge nSSPRES)
  begin : p_CntSeq
    if (nSSPRES == 1'b0)
      SSPCPSC   <= 7'b0000000;
    else
      SSPCPSC <= NextSSPCPSC;
  end //  p_CntSeq
 
//------------------------------------------------------------------------------
//  Prescaler to divide SSPCLK by the value programmed in SSCPSR register. The
// counter is reloaded with the value in the SSCPSRBuf3 register when any of
// the following conditions occur:
//  * When the counter counts down and reaches the value of "0001"
//  * When the SSP is disabled (so that on enabling the SSP, the counter starts
//    counting down from the reload value)
//
//  When the CPSR register is rewritten, i.e. when then reload value is changed,
// the counter continues counting down and after reaching the count of "0001",
// new reload value is loaded into the counter. Thus, there is a maximum
// possible latency of 15 SSPCLK cycles before the new reload value takes
// full effect after the second stage buffer has been updated.
//------------------------------------------------------------------------------
  always @(SSPCPSC or SSPTBPRE or SSESync )
  begin : p_CntComb
    if ((SSESync == 1'b0) || (SSPCPSC == 7'b0000001))
      NextSSPCPSC = {3'b000 ,SSPTBPRE};
    else
      NextSSPCPSC = (SSPCPSC - 7'b0000001);
  end // p_CntComb
 
//------------------------------------------------------------------------------
// When the SSPCPSC counter reaches 1, assert the SSPCLKDIV signal.
//------------------------------------------------------------------------------
  assign SSPCLKDIV = (SSPCPSC == 7'b0000001);
 
// -----------------------------------------------------------------------------
// Second stage buffers for the SSPTBCR0  and  SSPTBCR1 registers.
// -----------------------------------------------------------------------------
always @(SSPCLK or  nSSPRES)
begin : p_RegSeq
  if (nSSPRES == 1'b0) 
    begin
      CR0  <= 16'h0000;
      CR1  <= 6'b000000;
    end
  else  
    begin
      CR0  <= NextCR0;
      CR1  <= NextCR1;
    end
end  // p_RegSeq;

// -----------------------------------------------------------------------------
// Generation of delayed versions of the Update trigger inputs.
// -----------------------------------------------------------------------------
always @(SSPCLK or  nSSPRES)
begin : p_TriggerDel
  if (nSSPRES == 1'b0) 
    begin
      DelCR0Update  = 1'b0;
      DelCR1Update  = 1'b0;
    end
  else  
    begin
      DelCR0Update  = CR0UpdateSync;
      DelCR1Update  = CR1UpdateSync;
     end
end  // p_TriggerDel;
 
// -----------------------------------------------------------------------------
// Generation of load signals for second stage buffers.
// -----------------------------------------------------------------------------
assign CR0Stg2WrEn = CR0UpdateSync ^ DelCR0Update;
assign CR1Stg2WrEn = CR1UpdateSync ^ DelCR1Update;

// -----------------------------------------------------------------------------
// When the CR0Stg2WrEn signal is asserted, clock in the value on the 
// SSPTBCR0 input into the CR0 register.
// -----------------------------------------------------------------------------
always @(CR0Stg2WrEn or SSPTBCR0 or CR0)
begin : p_CR0Comb
  if (CR0Stg2WrEn == 1'b1) 
    NextCR0 = SSPTBCR0;
  else
    NextCR0 = CR0;
end   // p_CR0Comb;

// -----------------------------------------------------------------------------
// When the CR1Stg2WrEn signal is asserted, clock in the value on the 
// SSPTBCR1 input into the CR1 register.
// -----------------------------------------------------------------------------
 always @(CR1Stg2WrEn or  SSPTBCR1 or  CR1)
begin : p_CR1Comb
  if (CR1Stg2WrEn == 1'b1) 
    NextCR1 = SSPTBCR1;
  else
    NextCR1 = CR1;
end   // p_CR1Comb;

// -----------------------------------------------------------------------------
// Separate the bit fields in CR0  and  assign them to the respective 
// outputs
// -----------------------------------------------------------------------------
assign DSS   = CR0[3:0];
assign FRF   = CR0[5:4];
assign SPO   = CR1[0];
assign SPH   = CR1[1];
assign SCR   = CR0[15:8];

endmodule

// --=========================== End =========================================--
