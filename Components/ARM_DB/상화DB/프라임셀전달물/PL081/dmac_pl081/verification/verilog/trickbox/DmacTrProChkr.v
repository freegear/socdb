// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacTrProChkr.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is resposible for doing comparison between UUT's O/P
//          signals and Behavioural Trickbox's O/P signals.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrProChkr (
// Inputs
                      HCLK,
                      HRESETn,
                      HBUSREQDMACM,
                      HLOCKDMACM,
                      HTRANSM,
                      HADDRM,
                      HSIZEM,
                      HBURSTM,
                      HPROTM,
                      HWRITEM,
                      HWDATAM,
                      // DMA response signals
                      DMACCLR,
                      DMACTC,
                      // DMA interrupt request signals
                      DMACINTERR,
                      DMACINTTC,
                      DMACINTR,
                      // Signals from Trickbox
                      HBUSREQMTr,
                      HLOCKMTr,
                      HTRANSMTr,
                      HADDRMTr,
                      HSIZEMTr,
                      HBURSTMTr,
                      HPROTMTr,
                      HWRITEMTr,
                      HWDATAMTr,
                      // DMA response signals
                      DMACCLRTr,
                      DMACTCTr,
                      // DMA interrupt request signals
                      DMACINTERRTr,
                      DMACINTTCTr,
                      DMACINTRTr,
                      HREADYINM,
                      HGRANTDMACM,
                      DmacTrEn
                      );

// Inputs
input         HCLK;          // AHB clock
input         HRESETn;       // AHB reset
input         HBUSREQDMACM; // Bus request signal to AHB1
input         HLOCKDMACM;   // HLOCK signal as driven by AHB1
input   [1:0] HTRANSM;      // Type of transfer on AHB1
input  [31:0] HADDRM;       // AHB1 address bus
input   [2:0] HSIZEM;       // Width of transfer on AHB1
input   [2:0] HBURSTM;      // Burst length on AHB1
input   [3:0] HPROTM;       // Protection information on AHB1
input         HWRITEM;      // Transfer direction on AHB1
input  [31:0] HWDATAM;      // Write data on AHB1

// DMA response signals
input  [15:0] DMACCLR;       // DMA request clear
input  [15:0] DMACTC;        // DMA terminal count

// DMA interrupt request signals
input         DMACINTERR;    // DMA error interrupt request
input         DMACINTTC;     // DMA terminal count interrupt request
input         DMACINTR;      // DMA combined interrupt

// Signals from Trickbox
input         HBUSREQMTr;   // Bus request signal to AHB1
input         HLOCKMTr;     // HLOCK signal as driven by AHB1
input   [1:0] HTRANSMTr;    // Type of transfer on AHB1
input  [31:0] HADDRMTr;     // AHB1 address bus
input   [2:0] HSIZEMTr;     // Width of transfer on AHB1
input   [2:0] HBURSTMTr;    // Burst length on AHB1
input   [3:0] HPROTMTr;     // Protection information on AHB1
input         HWRITEMTr;    // Transfer direction on AHB1
input  [31:0] HWDATAMTr;    // Write data on AHB1

// DMA response signals
input  [15:0] DMACCLRTr;     // DMA request clear
input  [15:0] DMACTCTr;      // DMA terminal count

// DMA interrupt request signals
input         DMACINTERRTr;  // DMA error interrupt request
input         DMACINTTCTr;   // DMA terminal count interrupt request
input         DMACINTRTr;    // DMA combined interrupt
input         HREADYINM;    // HREADY signal
input         HGRANTDMACM;  // Grant Signal from Arbiter
input         DmacTrEn;      // 




// Inputs
  wire        HCLK;          // AHB clock
  wire        HRESETn;       // AHB reset
  wire        HBUSREQDMACM; // Bus request signal to AHB1
  wire        HLOCKDMACM;   // HLOCK signal as driven by AHB1
  wire  [1:0] HTRANSM;      // Type of transfer on AHB1
  wire [31:0] HADDRM;       // AHB1 address bus
  wire  [2:0] HSIZEM;       // Width of transfer on AHB1
  wire  [2:0] HBURSTM;      // Burst length on AHB1
  wire  [3:0] HPROTM;       // Protection information on AHB1
  wire        HWRITEM;      // Transfer direction on AHB1
  wire [31:0] HWDATAM;      // Write data on AHB1

// DMA response signals
  wire [15:0] DMACCLR;       // DMA request clear
  wire [15:0] DMACTC;        // DMA terminal count

// DMA interrupt request signals
  wire        DMACINTERR;    // DMA error interrupt request
  wire        DMACINTTC;     // DMA terminal count interrupt request
  wire        DMACINTR;      // DMA combined interrupt

// Signals from Trickbox
  wire        HBUSREQMTr;   // Bus request signal to AHB1
  wire        HLOCKMTr;     // HLOCK signal as driven by AHB1
  wire  [1:0] HTRANSMTr;    // Type of transfer on AHB1
  wire [31:0] HADDRMTr;     // AHB1 address bus
  wire  [2:0] HSIZEMTr;     // Width of transfer on AHB1
  wire  [2:0] HBURSTMTr;    // Burst length on AHB1
  wire  [3:0] HPROTMTr;     // Protection information on AHB1
  wire        HWRITEMTr;    // Transfer direction on AHB1
  wire [31:0] HWDATAMTr;    // Write data on AHB1

// DMA response signals
  wire [15:0] DMACCLRTr;     // DMA request clear
  wire [15:0] DMACTCTr;      // DMA terminal count

// DMA interrupt request signals
  wire        DMACINTERRTr;  // DMA error interrupt request
  wire        DMACINTTCTr;   // DMA terminal count interrupt request
  wire        DMACINTRTr;    // DMA combined interrupt
  wire        HREADYINM;    // HREADY signal
  wire        HGRANTDMACM;  // Grant Signal from Arbiter
  wire        DmacTrEn;      // 


// -----------------------------------------------------------------------------
//
//                            DmacTrProChkr
//                            =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This module is responsible for checking all UUT signals with the signals
// generated by the Behavioural DMAC in Trickbox
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire     LockPulse1;
// Pulse used to check the assertion of HLOCK for NSEQ

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg      ResetOver;
// Indication as to Reset is high.

reg      DelLockPulse1;
// Delayed version of LockPulse1

reg      DelHLOCK1;
// Delayed HLOCK

reg      CheckEn1;
// Enable to compare HTRANS

// -----------------------------------------------------------------------------
// Package insertion
// -----------------------------------------------------------------------------
`include "DmacTrParams.v"

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
// The comparison will start from the clock edge when reset occurs
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_ResetRegSeq
  if (HRESETn == 1'b0)
    ResetOver <= 1'b1;
end // p_ResetRegSeq

// ---------------------------------------------------------------------
// Latching HGRANTDMACM
// ---------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DelHGRANT1Seq
  if (HRESETn == 1'b0)
    CheckEn1 <= 1'b0;
   else
     if (HREADYINM == 1)
       CheckEn1 <= HGRANTDMACM;
end // p_DelHGRANT1Seq

// -----------------------------------------------------------------------------
// The comparison block
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_ProChkComb
  if ((DmacTrEn == 1'b1) && (ResetOver == 1'b1))
    begin
      if (HBUSREQDMACM != HBUSREQMTr)
        $display($time," ERROR: DmacTrProChkr1: Mismatch in Bus Request1",
                       " Assertion \n %m");
  
      if ((HTRANSMTr != `IDLE) && (CheckEn1 == 1'b1))
        if (HLOCKDMACM != HLOCKMTr)
          $display($time," ERROR: DmacTrProChkr3: Mismatch in HLOCK1 Assertion",
                         "\n %m");
  
      if (CheckEn1 == 1'b1)
        if (HTRANSM != HTRANSMTr)
          $display($time," ERROR: DmacTrProChkr5: Mismatch in HTRANSM ",
                   "EXPECTED: %h  ACTUAL: %h \n %m", HTRANSMTr, HTRANSM);
  
      if ((HTRANSM != `NSEQ) && (DelLockPulse1 == 1'b1) && (CheckEn1 == 1'b1))
        $display($time," ERROR: DmacTrProChkr6: HLOCK1 not asserted for NSEQ",
                       "\n %m");
  
      if ((HTRANSMTr != `IDLE) && (CheckEn1 == 1'b1))
        if (HADDRM != HADDRMTr)
          $display($time," ERROR: DmacTrProChkr9: Mismatch in HADDRM ",
                   "EXPECTED: %h  ACTUAL: %h \n %m", HADDRMTr, HADDRM);
  
      if ((HTRANSMTr != `IDLE) && (CheckEn1 == 1'b1))
        if (HSIZEM != HSIZEMTr)
          $display($time," ERROR: DmacTrProChkr12: Mismatch in HSIZEM \n %m");
  
      if (HSIZEM > `WORD)
        $display($time," ERROR: DmacTrProChkr13: HSIZEM greater than WORD",
                       " Access \n %m");
  
      if ((HTRANSMTr != `IDLE) && (CheckEn1 == 1'b1))
        if (HBURSTM != HBURSTMTr)
          $display($time," ERROR: DmacTrProChkr16: Mismatch in HBURSTM \n %m");
  
      if ((HBURSTM == `WRAP4) || (HBURSTM == `WRAP8) || (HBURSTM == `WRAP16))
        $display($time," ERROR: DmacTrProChkr17: DMAC initiated WRAP Access",
                       "\n %m");
  
      if ((HTRANSMTr != `IDLE) && (CheckEn1 == 1'b1))
        if (HPROTM != HPROTMTr)
          $display($time," ERROR: DmacTrProChkr20: Mismatch in HPROTM \n %m");
  
      if (HPROTM[0] == 1'b0)
        $display($time," ERROR: DmacTrProChkr21: HPROTM[0] is driven to 0",
                       " \n %m");
  
      if ((HTRANSMTr != `IDLE) && (CheckEn1 == 1'b1))
        if (HWRITEM != HWRITEMTr)
          $display($time," ERROR: DmacTrProChkr24: Mismatch in HWRITEM",
                         " Assertion \n %m");
  
      if (HWDATAM != HWDATAMTr)
        $display($time," ERROR: DmacTrProChkr26: Mismatch in HWDATAM ",
                 "EXPECTED: %h  ACTUAL: %h \n %m", HWDATAMTr, HWDATAM);
  
      if (DMACCLR != DMACCLRTr)
        $display($time," ERROR: DmacTrProChkr28: Mismatch in DMACCLR ",
                 "EXPECTED: %h  ACTUAL: %h \n %m", DMACCLRTr, DMACCLR);
  
      if (DMACTC != DMACTCTr)
        $display($time," ERROR: DmacTrProChkr29: Mismatch in DMACTC Assertion ",
                 "EXPECTED: %h  ACTUAL: %h \n %m", DMACTCTr, DMACTC);
  
      if (DMACINTERR != DMACINTERRTr)
        $display($time," ERROR: DmacTrProChkr30: Mismatch in DMACINTERR \n %m");
  
      if (DMACINTTC != DMACINTTCTr)
        $display($time," ERROR: DmacTrProChkr31: Mismatch in DMACINTTC \n %m");
  
      if (DMACINTR != DMACINTRTr)
        $display($time," ERROR: DmacTrProChkr32: Mismatch in DMACINTR \n %m");
    end
end // p_ProChkComb

// -----------------------------------------------------------------------------
// Clock Process to register next state signals
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DelHlockSeq
  if (HRESETn == 1'b0)
    begin
      DelHLOCK1        <= 1'b0;
      DelLockPulse1    <= 1'b0;
    end
  else
    begin
      DelHLOCK1        <= HLOCKDMACM;
      if (LockPulse1 == 1'b1)
        DelLockPulse1    <= 1'b1;
      else if (HTRANSMTr == `NSEQ)
        DelLockPulse1    <= 1'b0;
    end
end // p_DelHlockSeq

// -----------------------------------------------------------------------------
// Lock Pulse generation for HLOCK1
// -----------------------------------------------------------------------------
assign LockPulse1 = ((DelHLOCK1 == 1'b0) && (HLOCKDMACM == 1'b1)) ? 1'b1 : 1'b0;

endmodule
// --=============================== End =====================================--
