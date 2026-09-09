// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name              : SspTrCkRsCntlr.v.rca
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//
// -----------------------------------------------------------------------------
// Purpose      : This module generates the SSPCLK from either PCLK or an
//                internally generated clock.It also has the RESET controller.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspTrCkRsCntlr(
                      PCLK,           
                      PRESETn,         
                      SSPTBCLKREG,  
                      SSPTBCLKREG1,
                      SSPTrCNTLR,       
                      SCANMODEIN,      
                      RSTMODE,        
                      SCANMODE,      
                      nSSPRST,
                      SSPCLK,   
                      SSPCLK1,
                      PCLKOn,  
                      REFCLKOn,
                      REFCLK1On
                     );

input        PCLK;          // APB bus clock
input        PRESETn;         // APB Reset  
input [15:0] SSPTBCLKREG;   // SSPCLK frequency value 
input [15:0] SSPTBCLKREG1;  // SSPCLK1 frequency value 
input  [4:0] SSPTrCNTLR;    // Clock Select 
input        SCANMODEIN;    // SSP TrickBox SCANMODE bit
input        RSTMODE;       // SSP TrickBox RXTMODE bit

output       SCANMODE;      // SCANMODE output signal
output       nSSPRST;       // SSP reset signal 
output       SSPCLK;        // SSP Reference Clock Signal
output       SSPCLK1;       // SSP Second Reference Clock Signal
output       PCLKOn;        // Indicates PCLK is routed to SSPCLK line
output       REFCLKOn;      // Indicates SSPCLK is routed to SSPCLK line
output       REFCLK1On;     // Indicates SSPCLK1 is routed to SSPCLK1 line

// -----------------------------------------------------------------------------
//
//                               SspTrCkRsCntlr
//                               ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This Clock-Reset Controller provides the nSSPRST and SSPCLK signal to the
// Ssp. The nSSPRST is derived from the RSTMODE bit of the TB_SET_PINS Register.
// Whenever the RSTMODE bit is asserted, the nSSPRST is asserted asynchronously
// but the deassertion is synchronized with respect to the SSPCLK.
// The SSPRefClk generator generates a clock whose frequency is dependent on
// the SCLKTBCLKREG.
// The SSPRefClk1 generator generates a clock whose frequency is dependent on
// the SCLKTBCLKREG1.
// Depending on the state of SSPTrCNTLR SSPRefClk, SSPRefClk1 or PCLK is routed
// as the final SSPCLK.
//
// -----------------------------------------------------------------------------
 
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        PCLK;
// APB bus clock

wire        PRESETn;
// APB Reset

wire [15:0] SSPTBCLKREG;
// SSPCLK frequency value

wire [15:0] SSPTBCLKREG1;
// SSPCLK1 frequency value

wire  [4:0] SSPTrCNTLR;
// Clock Select

wire        SCANMODEIN;
// SSP TrickBox SCANMODE bit

wire        RSTMODE;
// SSP TrickBox RXTMODE bit

wire        MuxInRCLK;
// RCLKEnNegSync anded with SSPRefClk

wire        MuxInRCLK1;
// RCLKEnNegSync1 anded with SSPRefClk1

wire        MuxInPCLK;
// PCLKEnNegSync anded with PCLK

// -----------------------------------------------------------------------------
// Register Declarations
// -----------------------------------------------------------------------------
reg SSPRefClk;         
// Generated as per SSPTBCLKREG

reg SSPRefClk1;         
// Generated as per SSPTBCLKREG1

reg PCLKEnNegSync; 
// PCLKEN bit synced to falling edge of PCLK

reg RCLKEnNegSync;
// RCLKEn bit synced to falling edge of SSPRefClk

reg RCLK1EnNegSync;
// RCLKEn bit synced to falling edge of SSPRefClk1

reg SCANMODE;
// SCANMODE Reg

reg nSSPRST;     
// SSP Reset Reg

reg SSPCLK;    
// SSPCLK Reg

reg SSPCLK1;    
// SSPCLK1 Reg

reg PCLKOn;       
// Used to ON the PCLK

reg REFCLKOn;   
// Used to Switch ON REFCLK

reg REFCLK1On;   
// Used to Switch ON REFCLK1

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Gate the clock with the respective Enable signal that is synchronised to the
// falling edge of the respective clock. This ensures that the MuxIn*** clock
// signals are glitch-free.
// -----------------------------------------------------------------------------
assign MuxInRCLK  = SSPRefClk && RCLKEnNegSync;
assign MuxInPCLK  = PCLK && PCLKEnNegSync;
assign MuxInRCLK1 = SSPRefClk1 && RCLK1EnNegSync;
 
// -----------------------------------------------------------------------------
// Initialization         
// -----------------------------------------------------------------------------

initial
begin
  SSPRefClk      = 1'b1;
  SSPRefClk1     = 1'b1;
  SSPCLK         = 1'b1;
  SSPCLK1        = 1'b1;
  PCLKEnNegSync  = 1'b0;
  RCLKEnNegSync  = 1'b0;
  RCLK1EnNegSync = 1'b0;
end

// -----------------------------------------------------------------------------
// SSPRefClk generation based on the value in SSPTBCLKREG
// -----------------------------------------------------------------------------
always @(SSPTBCLKREG or SSPRefClk)
begin : p_ClkComb
    if (SSPTBCLKREG != 16'b0) 
        #(SSPTBCLKREG / 2.0) SSPRefClk <= ~SSPRefClk;
end   //  p_SSPCLK; 

// -----------------------------------------------------------------------------
// SSPRefClk1 generation based on the value in SSPTBCLKREG1
// -----------------------------------------------------------------------------
always @(SSPTBCLKREG1 or SSPRefClk1)
begin : p_ClkComb1
    if (SSPTBCLKREG1 != 16'b0) 
        #(SSPTBCLKREG1 / 2) SSPRefClk1 <= ~SSPRefClk1;
end   // p_ClkComb1 

// -----------------------------------------------------------------------------
// Reset signal generator.The Reset is done asynchronously but the deassertion
// is done synchronous to the SSPClk clock.
// -----------------------------------------------------------------------------
always @(negedge SSPCLK  or negedge PRESETn)
begin : p_RstCntrlSeq
  if (PRESETn == 1'b0)
    nSSPRST <= 1'b0;
  else 
    nSSPRST <= RSTMODE;
end   // p_RstCntrlSeq

// -----------------------------------------------------------------------------
// This process generates the SCANMODE signal.
// -----------------------------------------------------------------------------
always @(SCANMODEIN)
begin : p_SCANMODEGenComb
  if (SCANMODEIN == 1'b1)
    SCANMODE = 1'b1;
  else
    SCANMODE = 1'b0;
end   // p_SCANMODEGenComb 

// -----------------------------------------------------------------------------
// Synchronize the Enable of the PCLK to the PCLK domain.
// -----------------------------------------------------------------------------
always @(negedge PCLK)
begin : p_PCLKEnSynczrSeq
  if (PCLK == 1'b0)
    PCLKEnNegSync = SSPTrCNTLR[1];
end   // p_PCLKEnSynczrSeq

// -----------------------------------------------------------------------------
// Synchronize the Enable of the SSPRefClk to the SSPRefCLk domain.
// -----------------------------------------------------------------------------
always @(negedge SSPRefClk)
begin : p_RCLKEnSynczrSeq
  if (SSPRefClk == 1'b0)
    RCLKEnNegSync = SSPTrCNTLR[2];
end   // p_RCLKEnSynczrSeq

// -----------------------------------------------------------------------------
// Synchronize the Enable of the SSPRefClk1 to the SSPRefCLk1 domain.
// -----------------------------------------------------------------------------
always @(negedge SSPRefClk1)
begin : p_RCLK1EnSynczrSeq
  if (SSPRefClk1 == 1'b0)
    RCLK1EnNegSync = SSPTrCNTLR[3];
end   // p_RCLK1EnSynczrSeq

// -----------------------------------------------------------------------------
// Writes the Status Bits PCLKOn and REFCLKOn and REFCLK1On into the Status 
// Register of the TrickBox and the write is done on seeing the positive edge
// of the PCLK
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_StatGeneratorSeq
  if (PRESETn == 1'b0)
    begin 
      PCLKOn    = 1'b0;
      REFCLKOn  = 1'b0;
      REFCLK1On = 1'b0;
    end
  else
    begin
      PCLKOn    = PCLKEnNegSync;
      REFCLKOn  = RCLKEnNegSync;
      REFCLK1On = RCLK1EnNegSync;
    end
end   // p_StatGeneratorSeq

// ----------------------------------------------------------------------------
// This process routes either MuxInPCLK or MuxInRCLK to SSPCLK and also routes
// MuxInPCLK or MuxInRCLK1 to SSPCLK1 with respect to SSPTrCNTLR reg 
// ----------------------------------------------------------------------------
always @(SSPTrCNTLR or MuxInPCLK or MuxInRCLK or MuxInRCLK1 )
begin : p_RoutComp
  if (SSPTrCNTLR[4] == 1'b0)
    begin
      if (SSPTrCNTLR[0] !== 1'bx)
        begin
          if (SSPTrCNTLR[0] == 1'b1)
            begin
              SSPCLK1 = MuxInPCLK;
              SSPCLK  = MuxInPCLK;
            end
          else
            begin
              SSPCLK1 = MuxInRCLK;
              SSPCLK  = MuxInRCLK;
            end
        end
    end
  else if (SSPTrCNTLR[4] == 1'b1)
    begin
      if (SSPTrCNTLR[0] !== 1'bx)
        begin
          if (SSPTrCNTLR[0] == 1'b1)
            begin
              SSPCLK1 = MuxInRCLK1;
              SSPCLK  = MuxInPCLK;
            end
          else
            begin
              SSPCLK1 = MuxInRCLK1;
              SSPCLK  = MuxInRCLK;
            end
        end
    end
end // p_RoutComp

endmodule

// --============================= End =======================================--

