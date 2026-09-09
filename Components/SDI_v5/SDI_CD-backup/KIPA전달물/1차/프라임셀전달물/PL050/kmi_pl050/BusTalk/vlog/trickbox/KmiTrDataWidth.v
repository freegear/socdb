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
//  Filename            : KmiTrDataWidth.v,v
//
//  File Revision       : 1.1
//
//  Release Information : PL050-REL1v1
//
// ----------------------------------------------------------------------------
// Purpose : This module measures the different timing parameters & 
//           asserts the corresponding Error Signals.
//
// ----------------------------------------------------------------------------

`timescale 1ns/1ps

// ----------------------------------------------------------------------------

module KmiTrDataWidth (
                       BnRES,
                       KmiTrCLKL,
                       KmiTrCLKH,
                       REFCLK,
                       Pulse8MHz,
                       WrenSTAT,
                       KDATAIn,
                       KDATAOut,
                       WidthMsrEn,
                       KCLKOut,
                       WrenTIMESTAT,
                       BitCount,
                       KmiTrDSO,
                       KmiTrDHO,
                       CurrentState,
                       PWDataIn,
                       TdsoErr,
                       TdhoErr,
                       KmiTrDWIDTHERR 
                      );

input        BnRES;           // APB Reset
input [8:0]  KmiTrCLKL;       // Low clock time
input [8:0]  KmiTrCLKH;       // High clock time
input        REFCLK;          // Reference Clock
input        Pulse8MHz;       // 8 MHz signal
input        WrenSTAT;        // Status Register Write Enable
input        KDATAIn;         // Data Input from PAD
input        KDATAOut;        // Data Output to PAD
input        WidthMsrEn;      // Data Width Measurement Enable
input        KCLKOut;         // Clock Output to the PAD
input        WrenTIMESTAT;    // Time Status Register Write Enable
input [3:0]  BitCount;        // Bit Counter Value
input [15:0] KmiTrDSO;        // Setup Timing
input [15:0] KmiTrDHO;        // Hold Timing
input [1:0]  CurrentState;    // Current State
input [15:0] PWDataIn;        // APB Data Input
output       TdsoErr;         // DSO Timing Error
output       TdhoErr;         // DHO Timing Error
output       KmiTrDWIDTHERR;  // Data Width Error

// ----------------------------------------------------------------------------
//
//                             KmiTrDataWidth
//                             ==============
//
// ----------------------------------------------------------------------------
//
// Overview
// ========
// This module checks the data signal for different timing parameters. 
// An internal counter has been implemented for Data Width measurement 
// test. It  takes the Clock line & Data line for testing the setup 
// & hold timing parameters. The Error signals can be cleared by 
// writing 1'b1 to the corresponding location in Status register.  
//
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Constant definitions 
// ----------------------------------------------------------------------------
`define MARGIN       10'b0000000011
// This is the tolerance in the Data Width Measurement. 

`define TIMEMARGIN   1 
// Tolerance for DSO & DHO time test.

// ----------------------------------------------------------------------------
// wire declarations
// ----------------------------------------------------------------------------
wire ValidData;
// Combination of KDATAOut & KDATAIn

wire  [9:0]  ExpWidthMin;
// Expected Minimum Data Width
 
wire  [9:0]  ExpWidthMax;
// Expected Maximum Data Width
 
wire CounterEn;
// Internal Counter Enable signal
 
// ----------------------------------------------------------------------------
// Register declarations
// ----------------------------------------------------------------------------
reg  [9:0]  Counter;
// Counter for Data Width measurement
      
reg  [9:0]  NextCounter;
// D-Input for The Counter

reg  DelayData;
// Delayed version of Data Line

reg  DataPulse;
// Indicates the edge on the ValidData signal

reg  DelayDataPulse;
// Delayed DataPulse for loading of Counter 
 
time Tdso;
// DSO time
 
time Tdho;
// DHO time
 
reg  TdhoEn;
// DSO time test enable
 
reg  TdsoEn;
// DHO time test enable

reg  DelayKCLK;
// Delayed version of KCLKOut

reg  TdsoErr;

reg  TdhoErr;

reg  KmiTrDWIDTHERR;

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

always @(KmiTrDSO or KmiTrDHO)
begin : p_TimingPar
  if (KmiTrDSO == 16'h0000) 
    Tdso = 0;
  else 
    Tdso = KmiTrDSO - `TIMEMARGIN;
  if (KmiTrDHO == 16'h0000) 
    Tdho = 0;
  else 
    Tdho = KmiTrDHO - `TIMEMARGIN;
end // p_TimingPar

assign ValidData  =  (KDATAOut == 1'b0) ? 1'b1 :
                     KDATAIn;

// ----------------------------------------------------------------------------
// Data Line is delayed by one REFCLK for generating the DataPulse.
// ----------------------------------------------------------------------------
always @ (posedge REFCLK or BnRES)
begin : p_DelayDataSeq  
  if (BnRES == 1'b0) 
    DelayData <= 1'b0;
  else
    DelayData <= ValidData;
end  // p_DelayDataSeq

// ----------------------------------------------------------------------------
// Data Pulse is being generated with REFCLK.
// ----------------------------------------------------------------------------
always @ (negedge REFCLK or BnRES)
begin : p_DataPulseSeq 
  if (BnRES == 1'b0) 
    DataPulse <= 1'b0;
  else
    DataPulse <= ValidData ^ DelayData;
end  // p_DataPulseSeq

// ----------------------------------------------------------------------------
// DelayData Pulse is being generated with REFCLK.
// ----------------------------------------------------------------------------
always @ (negedge REFCLK or BnRES)
begin : p_DelayDataPulseSeq
  if (BnRES == 1'b0) 
    DelayDataPulse <= 1'b0;
  else
    DelayDataPulse <= DataPulse;
end  // p_DelayDataPulseSeq

// ----------------------------------------------------------------------------
// Clock is being delayed by one REFCLK.
// ----------------------------------------------------------------------------
always @ (negedge REFCLK or BnRES)
begin : p_DelayKCLKSeq  
  if (BnRES == 1'b0) 
    DelayKCLK <= 1'b0;
  else 
    DelayKCLK <= KCLKOut;
end  // p_DelayKCLKSeq

// ----------------------------------------------------------------------------
// DHO measurement
//
// This process generate the DHO time window. TdhoEn will be asserted at the 
// negative edge of KCLKOut & remain high for the Tdho time. During this 
// window, there must not be any change on KDATAIn.
//
// ----------------------------------------------------------------------------
always @ (negedge DelayKCLK or negedge BnRES or posedge TdhoEn)
begin : p_TdhoComb 
  if (BnRES == 1'b0)
    TdhoEn <= 1'b0;
  else if (TdhoEn == 1'b1) 
    TdhoEn <= #Tdho 1'b0;
  else 
    TdhoEn <= 1'b1;
end  // p_TdhoComb
 
// ----------------------------------------------------------------------------
// If DataPulse is being asserted during TdhoEn High, TdhoErr will be set.
// It can be cleared by writing one to corresponding location.
// ----------------------------------------------------------------------------
always @ (TdhoEn or BnRES or DataPulse or WrenTIMESTAT)
begin : p_TdhoErrComb
  if (BnRES == 1'b0) 
    TdhoErr = 1'b0;
  else if ((WrenTIMESTAT & PWDataIn[0]) == 1'b1) 
    TdhoErr = 1'b0;
  else if ((DataPulse & TdhoEn) == 1'b1) 
  begin
    TdhoErr = 1'b1;
    $display($time," DHO Timing Error");
  end
end  // p_TdhoErrComb

// ----------------------------------------------------------------------------
// DSO measurement
//
// The TdsoEn signal will be asserted with the event on the KDATAIn. It will
// remain high for the Tdso time. During this period there must not be any 
// activity on the KCLKIn line.
//
// ----------------------------------------------------------------------------
always @ (DataPulse or BnRES or TdsoEn)
begin : p_TdsoComb
  if (BnRES == 1'b0) 
    TdsoEn = 1'b0;
  else if ((DataPulse == 1'b1) & (CurrentState == 01)) 
    TdsoEn = 1'b1;
  else if (TdsoEn == 1'b1) 
    TdsoEn = #Tdso 1'b0;
end  // p_TdsoComb
 
// ----------------------------------------------------------------------------
// If there is some event on KCLK line during TdsoEn High, TdsoErr will be set.
// It can be cleared by writing one to corresponding location.
// ----------------------------------------------------------------------------
always @ (TdsoEn or BnRES or KCLKOut or PWDataIn)
begin : p_TdsoErrComb 
  if (BnRES == 1'b0) 
    TdsoErr = 1'b0;
  else if ((WrenTIMESTAT & PWDataIn[1]) == 1'b1) 
    TdsoErr = 1'b0;
  else if ((DelayKCLK & TdsoEn) == 1'b1) 
  begin
    $display($time,"DSO Timing Error"); 
    TdsoErr = 1'b1;
  end
end  // p_TdsoErrComb

// ----------------------------------------------------------------------------
// Counter for Data Width Measurement
//
// This counter is being incremented at Pulse8MHz. This counter is being 
// reloaded at the next edge on the KDATAIn line.
//-----------------------------------------------------------------------------
always @ (Counter or Pulse8MHz or DelayDataPulse or CounterEn)
begin : p_NextCounterComb
  if (DelayDataPulse | ~(CounterEn))
    NextCounter = 10'b0000000000;
  else if (Pulse8MHz & CounterEn)
    NextCounter = Counter + 1;
  else
    NextCounter = Counter;
end  // p_NextCounterComb

// ----------------------------------------------------------------------------
// Counter Upadate with every positive edge of REFCLK
// ----------------------------------------------------------------------------
always @ (posedge REFCLK or BnRES)
begin : p_CounterSeq  
  if (BnRES == 1'b0) 
    Counter <= 10'b0000000000;
  else 
    Counter <= NextCounter;
end  // p_CounterSeq

// ----------------------------------------------------------------------------
// Data Width Measurement
// ----------------------------------------------------------------------------
assign ExpWidthMin = KmiTrCLKL + KmiTrCLKH - `MARGIN;

assign ExpWidthMax = KmiTrCLKL + KmiTrCLKH + `MARGIN;

assign CounterEn   = ((CurrentState == 2'b01) & (WidthMsrEn == 1'b1)) ? 1'b1 : 
                     1'b0;

// ----------------------------------------------------------------------------
// When DataPulse is there, Counter value must be between the ExpWidthMin 
// and ExpWidthMax. If it is not, DWIDTHERR will be asserted. It can be 
// cleared by writing one to the corresponding location.
// ----------------------------------------------------------------------------
always @ (Counter or WrenSTAT or DataPulse or CounterEn or PWDataIn or BnRES)
begin : p_DWIDTHERRComb
  if (BnRES == 1'b0) 
    KmiTrDWIDTHERR = 1'b0;
  else if (WrenSTAT & PWDataIn[5])
    KmiTrDWIDTHERR = 1'b0;
  else if ((BitCount > 4'b0000) & (BitCount < 4'b1001)) 
    if ((DataPulse & CounterEn) == 1'b1)  
      if ((Counter < ExpWidthMin) | (Counter > ExpWidthMax))  
        KmiTrDWIDTHERR = 1'b1;
end  // p_DWIDTHERRComb
 
endmodule

// ======================== End Of KmiTrDataWidth ===========================--
