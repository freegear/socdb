// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name              : AaciTrSnc2BtClk.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           Synchronisers for signals crossing from PCLK domain to
//           BITCLK domain
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module AaciTrSnc2BtClk (
// Inputs
                        BITCLKIn,
                        nAACIBITCLKRST,
                        AACITrTxEn,
                        AACITrRxEn,
                        AACITrEn,
                        AACITrBtClkE,
                        AACITrWintGen,
                        AACITrWidChkEn,
// Outputs
                        AACITrEnBSync,
                        TxEnSync,
                        RxEnSync,
                        BtClkESync,
                        WintGenSync,
                        WidChkEnSync
                       );
// Inputs
input         BITCLKIn;        // BITCLK serial clock
input         nAACIBITCLKRST;  // BITCLK domain reset
input         AACITrTxEn;      // Transmission Enable
input         AACITrRxEn;      // Reception Enable
input         AACITrEn;        // Trickbox enable
input         AACITrBtClkE;    // BITCLK Enable
input         AACITrWintGen;   // Wake up interrupt generate
input         AACITrWidChkEn;  // Data width check enable
// Outputs
output        AACITrEnBSync;   // Trickbox Enable
output        TxEnSync;        // Transmit Enable
output        RxEnSync;        // Receive Enable
output        BtClkESync;      // BITCLK Enable
output        WintGenSync;     // Wake up interrupt generate
output        WidChkEnSync;    // Data width check enable

// Inputs
wire          BITCLKIn;        // BITCLK serial clock
wire          nAACIBITCLKRST;  // BITCLK domain reset
wire          AACITrTxEn;      // Transmission Enable
wire          AACITrRxEn;      // Reception Enable
wire          AACITrEn;        // Trickbox enable
wire          AACITrBtClkE;    // BITCLK Enable
wire          AACITrWintGen;   // Wake up interrupt generate
wire          AACITrWidChkEn;  // Data width check enable

// Outputs
reg           AACITrEnBSync;   // Trickbox Enable
reg           TxEnSync;        // Transmit Enable
reg           RxEnSync;        // Receive Enable
reg           BtClkESync;      // BITCLK Enable
reg           WintGenSync;     // Wake up interrupt generate
reg           WidChkEnSync;    // Data width check enable

// ---------------------------------------------------------------------
//
//                           AaciTrSnc2BtClk
//                           ===============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//
// This block implements the synchronisers for signals crossing over 
// from the PCLK domain to the BITCLK domain. The signals are 'double-
// synchronise'd using inferred d-type flip-flops.
// 
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg         TxEnSync1;
// 1st stage synchronised version of AACITrTxEn input 

reg         AACITrEnSync1;
// 1st stage synchronised version of AACITrEn input 

reg         RxEnSync1;
// 1st stage synchronised version of AACITrRxEn input 

reg         BtClkESync1;
// 1st stage synchronised version of AACITrBtClkE input 

reg         WintGenSync1;
// 1st stage synchronised version of AACITrWintGen input 

reg         WidChkEnSync1;
// 1st stage synchronised version of AACITrWidChkEn input 

// ---------------------------------------------------------------------
// 
// Main body of Code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Double-synchronise with inferred D-types 
// ---------------------------------------------------------------------
always @(posedge BITCLKIn or negedge nAACIBITCLKRST)
begin : p_SyncBtClk
  if (nAACIBITCLKRST == 1'b0)
    begin
      AACITrEnSync1     <= 1'b0;
      TxEnSync1         <= 1'b0;
      RxEnSync1         <= 1'b0;
      BtClkESync1       <= 1'b0;
      WintGenSync1      <= 1'b0;
      WidChkEnSync1     <= 1'b0;
      AACITrEnBSync     <= 1'b0;
      TxEnSync          <= 1'b0;
      RxEnSync          <= 1'b0;
      BtClkESync        <= 1'b0;
      WintGenSync       <= 1'b0;
      WidChkEnSync      <= 1'b0;
    end
  else
    begin
      AACITrEnSync1     <= AACITrEn;
      TxEnSync1         <= AACITrTxEn;
      RxEnSync1         <= AACITrRxEn;
      BtClkESync1       <= AACITrBtClkE;
      WintGenSync1      <= AACITrWintGen;
      WidChkEnSync1     <= AACITrWidChkEn;
      AACITrEnBSync     <= AACITrEnSync1;
      TxEnSync          <= TxEnSync1;
      RxEnSync          <= RxEnSync1;
      BtClkESync        <= BtClkESync1;
      WintGenSync       <= WintGenSync1;
      WidChkEnSync      <= WidChkEnSync1;
    end
end // process p_SyncBtClk;

endmodule

// --========================= End ===================================--
