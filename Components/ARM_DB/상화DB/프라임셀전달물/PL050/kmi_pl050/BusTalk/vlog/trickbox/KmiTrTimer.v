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
//  Filename            : KmiTrTimer.v,v
//
//  File Revision       : 1.1
//
//  Release Information : PL050-REL1v1
//
// ---------------------------------------------------------------------------
// Purpose : This modules samples the input KCLK & DATA signals & 
//           asserts the Contention/Rx signal.
//
// ---------------------------------------------------------------------------

`timescale 1ns/1ps

//----------------------------------------------------------------------------

module KmiTrTimer (
                   REFCLK,
                   BnRES,
                   Pulse8MHz,
                   nKMIRST,
                   KDATAIn,
                   KCLKIn,
                   KDATAOut,
                   KCLKOut,
                   RTS
                  );

input        REFCLK;    // Reference Clock Input
input        BnRES;     // APB nKMIRST
input        Pulse8MHz; // 8 MHz clock input
input        nKMIRST;   // KMI nKMIRST
input        KDATAIn;   // Data Line/RTS
input        KCLKIn;    // KMI Clock/CTS
input        KDATAOut;  // TrickBox Data Output
input        KCLKOut;   // TrickBox Clock Output
output       RTS;       // Request to Send

// ---------------------------------------------------------------------------
//
//                        KmiTrTimer
//                        ==========
//
// ---------------------------------------------------------------------------
//
// Overview
// ========
// This module samples the KCLK line. If the  KCLK line is LOW for more than 
// 64 us  it asserts the RTS signal at the next edge of KCLK. 
//
// ---------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Constant definitions
// ----------------------------------------------------------------------------
`define WAITCYCLES   10'b0111111100
// Number of Pulse8MHz to count 64 us.

// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
reg [9:0] Counter;
// 64 usec Counter
 
reg [9:0] NextCounter;
// D-input of Counter
 
wire TimerEn;
// This signal enables the counter
 
reg DelayTimerEn;
// Delayed version of TimerEn
 
wire LoadTimer;
// This causes the Reloading of the Counter
 
reg iRTS;
// Internal copy of RTS

wire RTS;
// Request to Send
 
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------
 
assign TimerEn   = ~(KCLKIn) & KCLKOut;
assign LoadTimer = DelayTimerEn &  ~(TimerEn);
assign RTS       = iRTS;

// ----------------------------------------------------------------------------
// This process asserts the RTS signal if Counter Value is more  the 
// value in WAITCYCLES. It remains high for 1 REFCLK period.
// ----------------------------------------------------------------------------
always @(Counter or LoadTimer or KDATAIn) 
begin : p_iRTSComb
  if (LoadTimer == 1'b1)
    if ((Counter >= `WAITCYCLES) & (KDATAIn == 1'b0)) 
      iRTS = 1'b1;
    else
      iRTS = 1'b0;
  else
    iRTS = 1'b0;
end  // p_iRTSComb
 
// ----------------------------------------------------------------------------
// Delayed Version of TimerEn.
// ----------------------------------------------------------------------------
always @(posedge REFCLK or BnRES)
begin : p_DelayTimerEnSeq 
  if (BnRES == 1'b0) 
    DelayTimerEn <= 1'b0;
  else
    DelayTimerEn <= TimerEn;
end  // p_DelayTimerEnSeq

// ----------------------------------------------------------------------------
// Counter is being updated at the positive edge of REFCLK.
// ----------------------------------------------------------------------------
always @(posedge REFCLK or BnRES)
begin : p_CounterSeq
  if (BnRES == 1'b0) 
    Counter <= 10'b0000000000;
  else
    Counter <= NextCounter ;
end  // p_CounterSeq

// ----------------------------------------------------------------------------
// Counter value is incremented at Pulse8MHz signal.
// ----------------------------------------------------------------------------
always @(Counter or Pulse8MHz or nKMIRST or TimerEn or LoadTimer)
begin : p_NextCounterComb
  if (~(nKMIRST) | LoadTimer) 
    NextCounter = 10'b0000000000;
  else if (Pulse8MHz & TimerEn)
    NextCounter = Counter + 1;
  else
    NextCounter = Counter;
end  // p_NextCounterComb    

endmodule

//============================= End of KmiTrTimer ============================
