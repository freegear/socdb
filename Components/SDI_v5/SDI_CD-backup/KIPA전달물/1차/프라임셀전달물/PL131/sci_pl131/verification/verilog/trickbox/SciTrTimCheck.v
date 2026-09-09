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
//  File Name              : SciTrTimCheck.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Purpose     : This block check the SCICLK width and assert Error message
//               if there is any violations happened.  
//  
// -----------------------------------------------------------------------------

`timescale 1ns/1ps
 
//------------------------------------------------------------------------------

module SciTrTimCheck 
  (
        SCICLK, // Referance clock 
        PRESETn, // reset input
        SCIDATAOUT, // SCI data out
        SCICLKIN, // SCICLK input
        DeBugOn, // Debug message on
        SCITrRFCK, // RFCLK register    
        SCITrWV,  // Error Margin Reg 
        SCITrCKICC,
        SCICLKErEn, // SCICLK Error  En
        TXPtimErEn, // TX parity time Error En
        TXPErEn, // TX parity Error En
        TXPtimWdErEn , // TX P time width Error En
        RXPErEn, // Receive parity Error En
        RXCtimErEn, // RX charactor time Error En
        RXBtimErEn, // RX Block time Error En
        StartBitErEn, // Start Bit Error En
        TXPtimError, // TX parity time Error
        TXPtimWdError, // TX parity time width Error
        TXPError, // TX parity Error
        RXPError, // Receive parity Error
        RXCtimError, // RX charactor time Error
        RXBtimError, // RX Block time Error 
        StartBitError   // Start Bit Error 
       );
        
input        SCICLK; // Referance clock 
input        PRESETn; // reset input
input        SCIDATAOUT; // SCI data out
input        SCICLKIN; // SCICLK input
input        DeBugOn; // Debug message on
input [15:0] SCITrRFCK; // RFCLK register    
input  [7:0] SCITrWV;  // Error Margin Reg 
input [15:0] SCITrCKICC; 
input        SCICLKErEn; // SCICLK Error  En
input        TXPtimErEn; // TX parity time Error En
input        TXPErEn; // TX parity Error En
input        TXPtimWdErEn; // TX P time width Error En
input        RXPErEn; // Receive parity Error En
input        RXCtimErEn; // RX charactor time Error En
input        RXBtimErEn; // RX Block time Error En
input        StartBitErEn; // Start Bit Error En
input        TXPtimError; // TX parity time Error
input        TXPtimWdError ; // TX parity time width Error
input        TXPError; // TX parity Error
input        RXPError; // Receive parity Error
input        RXCtimError; // RX charactor time Error
input        RXBtimError; // RX Block time Error 
input        StartBitError;    // Start Bit Error 

// -----------------------------------------------------------------------------
//
//                   SciTrTimCheck
//                   =============
//
// -----------------------------------------------------------------------------
// Overview
// ========
//
// This module Check SCICLK width and assert Error message if any violations    
// happened. Depend on the mask bit condition this module generate other
// error messages also 
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
integer  CheckStartTime;  // 200ns 
integer  tSCICLKRiseEdge;
integer  tSCICLKFallEdge;
integer  SCICLKWPLUSE;  
integer  SCICLKWMINUSE;  
integer  SCICLKtime;
integer  SCICLKOuttime;
integer  Offset;


//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

  
 
//------------------------------------------------------------------------------
//  
// Calculating the required SCICLK width range
//
//------------------------------------------------------------------------------
initial
begin
  CheckStartTime  = 'd200; // 200ns 
  tSCICLKRiseEdge = 0;
  tSCICLKFallEdge = 0;
  SCICLKWPLUSE = 0;  
  SCICLKWMINUSE = 0;  
  SCICLKOuttime = 0;
  Offset = 0;
end

always @(SCITrRFCK or SCITrCKICC or SCICLKtime or SCITrWV or 
         SCICLKOuttime or Offset)
begin
SCICLKtime = SCITrRFCK;
SCICLKOuttime = (SCITrCKICC + 1) * SCICLKtime; 
Offset        = SCITrWV;  
SCICLKWPLUSE  = SCICLKOuttime  + Offset;
SCICLKWMINUSE = SCICLKOuttime  - Offset;
end
//------------------------------------------------------------------------------
// Sampling the rising edge time of SCICLK  
//------------------------------------------------------------------------------
always @(posedge SCICLKIN) 
begin
  tSCICLKRiseEdge = $time;
end 

//------------------------------------------------------------------------------
// Sampling the falling edge time of SCICLK  
//------------------------------------------------------------------------------
always @ (negedge SCICLKIN) 
begin
  tSCICLKFallEdge = $time;
end


//------------------------------------------------------------------------------
// Check the timing violations in the high phase of SCICLK  
//------------------------------------------------------------------------------
always @(tSCICLKFallEdge)
begin : p_HCheck
  if ((DeBugOn == 1'b1) & (SCICLKErEn == 1'b1) & ($time > CheckStartTime))
  begin 
    if ((tSCICLKFallEdge - tSCICLKRiseEdge) > SCICLKWPLUSE)  
       $display($time, "Pulse width violation in high phase: Max SCICLK");
    else
      if ((tSCICLKFallEdge - tSCICLKRiseEdge) < SCICLKWMINUSE) 
         $display($time, "Pulse width violation in high phase : Min SCICLK");
  end
end // p_HCheck;
 
//------------------------------------------------------------------------------
// Check the timing violations in the low phase of SCICLK  
//------------------------------------------------------------------------------
always @(tSCICLKRiseEdge)
begin : p_LCheck 
  if ((DeBugOn == 1'b1) & (SCICLKErEn == 1'b1) & ($time > CheckStartTime))
  begin 
    if ((tSCICLKRiseEdge - tSCICLKFallEdge) > SCICLKWPLUSE)  
       $display($time, "Pulse width violation in low phase: Max SCICLK");
    else 
      if ((tSCICLKRiseEdge - tSCICLKFallEdge) < SCICLKWMINUSE) 
        $display($time, "Pulse width violation in low phase : Min SCICLK");
  end
end // p_LCheck;

//------------------------------------------------------------------------------
// Assert Error messages depend on the mask bit conditions   
//------------------------------------------------------------------------------
always @(TXPtimError or TXPError or TXPtimWdError or RXPError or 
         StartBitError or RXCtimError or RXBtimError or TXPtimErEn or 
         TXPErEn or TXPtimWdErEn or RXPErEn or  StartBitErEn or 
         RXCtimErEn or RXBtimErEn)
begin : p_ErrorMessage 
  if ((DeBugOn == 1'b1) &  ($time > CheckStartTime))
  begin 
    if ((TXPtimError == 1'b1)  &  (TXPtimErEn == 1'b1)) 
       $display($time, "Parity Error signal asserted at wrong time");
    if ((TXPError == 1'b1)  &  (TXPErEn == 1'b1)) 
       $display($time, "Transmit Parity data bit Error ");
    if ((TXPtimWdError == 1'b1)  &  (TXPtimWdErEn == 1'b1)) 
       $display($time, "Parity signal width is wrong");
    if ((RXPError == 1'b1)  &  (RXPErEn == 1'b1)) 
       $display($time, "Timing error between retransmssion");
    if ((RXCtimError == 1'b1)  &  (RXCtimErEn == 1'b1)) 
       $display($time, "CH time error");
    if ((RXBtimError == 1'b1)  &  (RXBtimErEn == 1'b1)) 
       $display($time, "BLK time Error");
    if ((StartBitError == 1'b1)  &  (StartBitErEn == 1'b1)) 
       $display($time, "Start Bit Detect Error");
  end

end // p_ErrorMessage; 

endmodule

//================================== End =====================================--
