// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : SciTrREFCLKGen.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Purpose      : This generates the SCIREFCLK from either PCLK or an 
//                internally generated clock.It also has the RESET controller.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SciTrREFCLKGen (
                       PCLK,      
                       PRESETn,    
                       SCICLK,
                       PCLKOn,
                       REFCLKOn,    
                       SCITrRFCK,  
                       SCICLKOUT, 
                       SCITrCKICC,    
                       SCITrRFCNTL,  
                       TrSCICLKEn    
                      );

input           PCLK;          // APB bus clock
input           PRESETn;       // APB Reset
output          SCICLK;        // SCIREF Reference Clock Signal
output          PCLKOn;        // PCLK is routed to SCICLK
output          REFCLKOn;      // SCIREFClK is routed to SCICLK
input    [15:0] SCITrRFCK;     // SCICLK frequency value              
output          SCICLKOUT;     // Sync for BLKGUUpdate
input    [15:0] SCITrCKICC;                 
 
input    [2:0]  SCITrRFCNTL;   // Clock Select
input           TrSCICLKEn;   
// -----------------------------------------------------------------------------
//
//                               SciTrREFCLKGen
//                               ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This Clock Controller provides the SCICLK signal to the UUT. The 
// SCIREFClK generator generates a clock whose frequency is dependent on
// the SCLTrRFCK. Depending on the state of SCITrRFCNTL either 
// SCIREFClK or PCLK is routed as the final SCICLK.
 
// -----------------------------------------------------------------------------



// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------

reg SCICLK;     
// SCIREF Reference Clock Signal

reg PCLKOn;   
// PCLK is routed to SCICLK

reg REFCLKOn;      
// SCIREFClK is routed to SCICLK

reg SCICLKOUT;     
// Sync for BLKGUUpdate

reg IntSCICLK; 
// internal SCIREFClK

reg PCLKEnNegSync; 
// PCLKEN bit synced to falling edge of PCLK

reg RCLKEnNegSync;
// RCLKEn bit synced to falling edge of SCIREFClK

wire MuxInRCLK;
// RCLKEnNegSync anded with SCIREFClK

wire MuxInPCLK;
// PCLKEnNegSync anded with PCLK

reg IntSCICLKOUT;
// Internal gnerated SCICLKOUT

reg [15:0] Clk_low;
// low phase of SCICLK 

reg [15:0] Clk_high;
// high phase of SCICLK 

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------
// Initialization
// -----------------------------------------------------------------------------
initial
begin
  IntSCICLK = 1'b0;
  IntSCICLKOUT = 1'b0;
  Clk_low  = 16'd10;
  Clk_high = 16'd10;
end
 
// -----------------------------------------------------------------------------
// SCIREFClK generation based on the value in SCITrRFCK
// -----------------------------------------------------------------------------

// assign Clk_low = (SCITrRFCK[0] == 1'b1) ? ({1'b0, SCITrRFCK[15:1]} + 1'b1) :
//                                          {1'b0, SCITrRFCK[15:1]};

// assign Clk_high = {1'b0, SCITrRFCK[15:1]};

always @(PCLK)
begin 
  Clk_low  <= (SCITrRFCK[0] == 1'b1) ? ({1'b0, SCITrRFCK[15:1]} + 1'b1) :
                                      {1'b0, SCITrRFCK[15:1]};
  Clk_high <= {1'b0, SCITrRFCK[15:1]};
end 
   
/*
always @(IntSCICLK)
begin 
   if (IntSCICLK == 1'b1) 
      #(Clk_high) IntSCICLK <= 1'b0;
    else
      #(Clk_low) IntSCICLK <= 1'b1;
end 
*/
   
always
begin : p_CLockGenComb
  IntSCICLK = 1'b0;
  #(Clk_high);
  IntSCICLK = 1'b1;
  #(Clk_low);
end // p_ClockGenComb

// -----------------------------------------------------------------------------
// Synchronize the Enable of the PCLK to the PCLK domain.
// -----------------------------------------------------------------------------
always @(negedge PCLK or negedge PRESETn)
begin : p_PCLKEnSynczrSeq
    if (PRESETn == 1'b0)
      PCLKEnNegSync <= 1'b0;
    else
      PCLKEnNegSync <= SCITrRFCNTL[1];
end // p_PCLKEnSynczrSeq;

// -----------------------------------------------------------------------------
// Synchronize the Enable of the IntSCIREFClK to the SCIREFClK domain.
// -----------------------------------------------------------------------------
always @(negedge IntSCICLK or negedge PRESETn)
begin : p_RCLKEnSynczrSeq
    if (PRESETn == 1'b0)
      RCLKEnNegSync <= 1'b0;
    else
      RCLKEnNegSync <= SCITrRFCNTL[2];
end // p_RCLKEnSynczrSeq;

// -----------------------------------------------------------------------------
// Writes the Status Bits PCLKOn and REFCLKOn into the Status Register of the 
// TrickBox and the write is done on seeing the positive edge of the PCLK  
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_StatGeneratorSeq
  if (PRESETn == 1'b0)
  begin
    PCLKOn   = PCLKEnNegSync;
    REFCLKOn = RCLKEnNegSync;
  end
  else
  begin
    PCLKOn   = PCLKEnNegSync;
    REFCLKOn = RCLKEnNegSync;
  end
end // p_StatGeneratorSeq;

assign MuxInRCLK = IntSCICLK & RCLKEnNegSync;

assign MuxInPCLK = PCLK &  PCLKEnNegSync;

// -----------------------------------------------------------------------------
// This process routes either the SCIREFClK or the PCLK clock to the SCICLK
// line based on the value of the Select Bit of the SCITrRFCNTL Register.
// -----------------------------------------------------------------------------
always @(SCITrRFCNTL or MuxInPCLK or MuxInRCLK)
begin : p_MuxComb
  if (SCITrRFCNTL[0] == 1'b1) 
    SCICLK = MuxInPCLK;
  else
    SCICLK = MuxInRCLK;
end // p_MuxComb;

// -----------------------------------------------------------------------------
// IntSCICLKOUT generation based on the value in SCITrCKICC
// -----------------------------------------------------------------------------
always @(SCITrCKICC or IntSCICLK or SCITrRFCK)
begin : p_ClkComb
    if ((SCITrRFCK != 16'h0000) | (SCITrRFCK != 16'hxxxx))
      # ((SCITrCKICC + 1) * (SCITrRFCK/2)* 2) IntSCICLKOUT <= ~(IntSCICLKOUT);
end   //  p_ClkComb;
 
// -----------------------------------------------------------------------------
// IntSCICLKOUT is connected to pin based on the condition of TrSCICLKEn  
// -----------------------------------------------------------------------------

always @(TrSCICLKEn or IntSCICLKOUT)
begin
  if (TrSCICLKEn == 1'b1)
    SCICLKOUT  = IntSCICLKOUT;
  else
    SCICLKOUT  = 1'b1;
end

endmodule

// ============================== End ========================================--

