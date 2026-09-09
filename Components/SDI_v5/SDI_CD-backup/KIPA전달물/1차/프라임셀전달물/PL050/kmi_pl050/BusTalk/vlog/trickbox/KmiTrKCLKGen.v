//  ----------------------------------------------------------------------------
//  This confidential & proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 1998 ARM Limited
//  ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  & copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version & Release Control Information :
//
//
//  Filename            : KmiTrKCLKGen.v,v
//
//  File Revision       : 1.1
//
//  Release Information : PL050-REL1v1
//
//  ----------------------------------------------------------------------------
//  Purpose : This block generates the KCLK clock. 
//
//  --------------------------------------------------------------------------- 

`timescale  1ns/1ps

// ----------------------------------------------------------------------------

module KmiTrKCLKGen (
                     BnRES,
                     KmiTrCLKL,
                     KmiTrCLKH,
                     REFCLK,
                     Pulse8MHz,
                     CLKEn,
                     CurrentState,
                     KCLK         
                    );

input       BnRES;        // APB Reset
input [8:0] KmiTrCLKL;    // Low clock time
input [8:0] KmiTrCLKH;    // High clock time
input       REFCLK;       // Reference Clock
input       Pulse8MHz;    // 8 MHz signal
input       CLKEn;        // Clock Hold/Enable
input [1:0] CurrentState; // Current State Input
output      KCLK;         // Clock output

// ---------------------------------------------------------------------------- 
//
//                      KmiTrKCLKGen
//                      ============
//
// ----------------------------------------------------------------------------
//
// Overview
// ========
// This module generates the KCLK for Recieve/Transmit operation.
// This Clock will be outputted on the KCLKOut line during. Clock Low time 
// & High time is programmable. KCLK will be generated only  CLKEn is
// High.
//
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Wire declarations
// ----------------------------------------------------------------------------
wire NextKCLK; 
// D-input for iKCLK

// ----------------------------------------------------------------------------
// Register declarations
// ----------------------------------------------------------------------------
reg [8:0] Counter;
// Internal Counter

reg [8:0] NextCounter;
// D-Input for Counter

reg iKCLK; 
// Internal Copy of KCLK

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// This module generate the NextCounter. The value loaded in the NextCounter
// will be KmiTrCLKL or KmiTrCLKH depending on the present condition on the
// KCLK line. Counter is being decremented at every Pulse8MHz signal.
// ----------------------------------------------------------------------------
always @ (Counter or CLKEn or Pulse8MHz or iKCLK or KmiTrCLKL or KmiTrCLKH)
begin : p_NextCounterComb
  if ((Counter == 9'b00000000) | (CLKEn == 1'b0)) 
  begin
    if (iKCLK == 1'b1) 
      NextCounter = KmiTrCLKL;
    else
      NextCounter = KmiTrCLKH;
  end
  else if (Pulse8MHz & CLKEn)  
    NextCounter = Counter - 1;
  else
    NextCounter = Counter;  
end  // p_NextCounterComb

// ----------------------------------------------------------------------------
// This process updates the value of Counter at the positive edge of REFCLK.
// ----------------------------------------------------------------------------
always @ (posedge REFCLK or BnRES)
begin : p_CounterSeq
  if (BnRES == 1'b0) 
    Counter <= 9'b000000000;
  else
    Counter <= NextCounter;
end  // p_CounterSeq
   
// In the Idle State NextKCLK will be pulled low. Otherwise it is being
// toggled whenever Counter value reaches to zero.
assign NextKCLK = (CurrentState == 2'b00) ? 1'b0 : 
                  (Counter == 9'b00000000) ?  ~(iKCLK) : 
                  iKCLK;

// ----------------------------------------------------------------------------
// iKCLK is being updated at the positive edge of REFCLK.
// ----------------------------------------------------------------------------
always @ (BnRES or posedge REFCLK)
begin : p_iKCLKSeq 
  if (BnRES == 1'b0) 
    iKCLK <= 1'b1;
  else
    iKCLK <= NextKCLK;
end  // p_iKCLKSeq

assign KCLK = iKCLK;
   
endmodule

// =========================== End Of KmiTrKCLKGen ========================--
