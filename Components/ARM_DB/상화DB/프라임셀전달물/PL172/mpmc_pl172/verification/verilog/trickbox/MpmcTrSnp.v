// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : MpmcTrSnp.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Module, transaction Snoop, to "log" commands issued by the
//           controller to the SDRAM/SyncFLASH devices
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MpmcTrSnp (
// Inputs
                  HCLK,
                  MPMCCLK,
                  nReset,
                  FifoIn,
                  LatencyChkEn,
                  MPMCDATAOUT,
                  MPMCDATAIN,
                  nMPMCDYCSOUT,
                  nMPMCSTCSOUT,
                  MPMCTrSNPCR,
                  Fifo1Rd,
                  Fifo2Rd,
                  MPMCTrDynRC0,
                  MPMCTrDynRC1,
                  MPMCTrDynRC2,
                  MPMCTrDynRC3,

// Outputs
                  Fifo1Out,
                  Fifo2Out
                 );

// Inputs
input         HCLK;             // Input Clock To The Snooper
input         MPMCCLK;          // Operating clock of the SDRAMC
input         nReset;           // Input Reset To The Snooper
input  [31:0] FifoIn;           // Input data to the Snooper
input         LatencyChkEn;     // RAS/CAS latency check enable
input  [31:0] MPMCDATAOUT;      // Mpmc Data out signal
input  [31:0] MPMCDATAIN;       // Mpmc Data in signal
input   [3:0] nMPMCDYCSOUT;     // Chip Select Signal for Synchronous
                                // Memory devices
input   [3:0] nMPMCSTCSOUT;     // Chip Select Signal for Static Memory devices
input   [3:0] MPMCTrSNPCR;      // MPMCTrSNPCR register
input         Fifo1Rd;          // To Read the FIFO1
input         Fifo2Rd;          // To Read the FIFO2
input   [9:0] MPMCTrDynRC0;     // RAS/CAS Latency Register0
input   [9:0] MPMCTrDynRC1;     // RAS/CAS Latency Register1
input   [9:0] MPMCTrDynRC2;     // RAS/CAS Latency Register2
input   [9:0] MPMCTrDynRC3;     // RAS/CAS Latency Register3

// Outputs
output [31:0] Fifo1Out;         // Fifo1 Data Output
output [31:0] Fifo2Out;         // Fifo2 Data Output

// Inputs
wire          HCLK;             // Input Clock To The Snooper
wire          MPMCCLK;          // Operating clock of the SDRAMC
wire          nReset;           // Input Reset To The Snooper
wire   [31:0] FifoIn;           // Input data to the Snooper
wire          LatencyChkEn;     // RAS/CAS latency check enable
wire   [31:0] MPMCDATAOUT;      // Mpmc Data out signal
wire   [31:0] MPMCDATAIN;       // Mpmc Data in signal
wire    [3:0] nMPMCDYCSOUT;     // Chip Select Signal for Synchronous
                                // Memory devices
wire    [3:0] nMPMCSTCSOUT;     // Chip Select Signal for Static Memory devices
wire    [3:0] MPMCTrSNPCR;      // MPMCTrSNPCR register
wire          Fifo1Rd;          // To Read the FIFO1
wire          Fifo2Rd;          // To Read the FIFO2
wire    [9:0] MPMCTrDynRC0;     // RAS/CAS Latency Register0
wire    [9:0] MPMCTrDynRC1;     // RAS/CAS Latency Register1
wire    [9:0] MPMCTrDynRC2;     // RAS/CAS Latency Register2
wire    [9:0] MPMCTrDynRC3;     // RAS/CAS Latency Register3

// Outputs
wire   [31:0] Fifo1Out;         // Fifo1 Data Output
wire   [31:0] Fifo2Out;         // Fifo2 Data Output

// -----------------------------------------------------------------------------
//
//                                  MpmcTrSnp
//                                  =========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This module "snoops" the MPMC bus and stores the command encoding and
// the access address in a FIFO. This FIFO may be read or cleared under
// program control.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Range and Width Definitions
// -----------------------------------------------------------------------------
`define FIFO_DEPTH       128
// Depth of the FIFOs

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire          DelMPMCCLK;
// Delayed version of the MPMCCLK to sample the read command for CAS latency
// check

wire          Fifo1SelClk;
// Selected operating clock for the FIFO1

wire          Fifo2SelClk;
// Selected operating clock for the FIFO2

wire          SDRAMSel;
// Signal which indicates whether a SDRAM is selected

wire          Fifo1Clear;
// Snooper fifo clear signal

wire          Fifo2Clear;
// Snooper fifo clear signal

wire          Fifo1En;
// Snooper fifo Enable signal

wire          Fifo2En;
// Snooper fifo Enable signal

wire    [7:0] ChipSelect;
// signal indicates assertion of chip select for both Synchronous and Static
// Memory module.

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg    [31:0] iFifo1Out;
// local copy of FIFO data output

reg    [31:0] iFifo2Out;
// local copy of FIFO data output

reg    [31:0] NextFifo1Out;
// D-input of iFifo1Out register

reg    [31:0] NextFifo2Out;
// D-input of iFifo2Out register

reg    [31:0] Fifo1Data[(`FIFO_DEPTH - 1):0];
// Array of Fifo1 datas each 32 bit wide

reg    [31:0] Fifo2Data[(`FIFO_DEPTH - 1):0];
// Array of Fifo2 datas each 32 bit wide

reg    [31:0] ShiftFifo1Data[(`FIFO_DEPTH - 1):0];
// FIFO1 data

reg    [31:0] ShiftFifo2Data[(`FIFO_DEPTH - 1):0];
// FIFO2 data

reg    [31:0] NextFifo1Data;
// Input to the ShiftFifo1Data

reg    [31:0] NextFifo2Data;
// Input to the ShiftFifo2Data

reg    [31:0] TempFifo1Data;
// Temporary Fifo1 data hold

reg    [31:0] TempFifo2Data;
// Temporary Fifo2 data hold

reg           Snoop1En;
// Signal which decides whether data has to be encoded in the FIFO1

reg           Snoop2En;
// Signal which decides whether data has to be encoded in the FIFO2

reg           RASLat1;
// RAS Latency1 Check enable

reg           RASLat2;
// RAS Latency2 Check enable

reg           RASLat3;
// RAS Latency3 Check enable

reg           NxtRASLat1;
// D-input for RAS Latency1 Check enable

reg           NxtRASLat2;
// D-input for RAS Latency2 Check enable

reg           NxtRASLat3;
// D-input for RAS Latency3 Check enable

reg           CASLat1;
// CAS Latency1 Check enable

reg           CASLat2;
// CAS Latency2 Check enable

reg           CASLat3;
// CAS Latency3 Check enable

reg           NxtCASLat1;
// D-input for CAS Latency1 Check enable

reg           NxtCASLat2;
// D-input for CAS Latency2 Check enable

reg           NxtCASLat3;
// D-input for CAS Latency3 Check enable

reg           RDataSmpEn;
// Enable signal to sample the Read data into the FIFO.

reg     [1:0] LatchCS;
// Latched version of the Synchronous memory CSs for CAS Latency checks

integer WritePntr1;
// Gives the number of the FIFO word into which the encoded data is written

integer WritePntr2;
// Gives the number of the FIFO word into which the encoded data is written

integer NextWritePntr1;
// D - input of the WritePntr1

integer NextWritePntr2;
// D - input of the WritePntr2

integer i, j;
// for loop variables;

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

initial
begin
  Snoop1En = 1'b0;
  Snoop2En = 1'b0;
  LatchCS  = 2'b00;
end

// -----------------------------------------------------------------------------
// Generation of Chipselect signal
// -----------------------------------------------------------------------------
assign ChipSelect       = {nMPMCDYCSOUT[3:0], nMPMCSTCSOUT[3:0]};

assign SDRAMSel         = ~(ChipSelect[7] & ChipSelect[6] & ChipSelect[5]
                           & ChipSelect[4]);

assign Fifo1Out         = NextFifo1Out;
assign Fifo2Out         = NextFifo2Out;

assign # 2 DelMPMCCLK   = MPMCCLK;

// -----------------------------------------------------------------------------
// Generation of Internal signals from register bit fields
// -----------------------------------------------------------------------------
assign Fifo1En          = MPMCTrSNPCR[0];
assign Fifo1Clear       = MPMCTrSNPCR[1];
assign Fifo2En          = MPMCTrSNPCR[2];
assign Fifo2Clear       = MPMCTrSNPCR[3];

// -----------------------------------------------------------------------------
// Select the operating clock for the FIFOs
// -----------------------------------------------------------------------------
assign Fifo1SelClk      = (Fifo1En == 1'b1) ? MPMCCLK : HCLK;
assign Fifo2SelClk      = (Fifo2En == 1'b1) ? MPMCCLK : HCLK;

// -----------------------------------------------------------------------------
// Combinational block which checks for a Snoop Enable condition and does
// the encoding of the FIFO1 data to a 32 bit register NextFifo1Data.
// -----------------------------------------------------------------------------
always @(FifoIn or Fifo1En or ChipSelect or SDRAMSel)
begin : p_EncodeComb
   NextFifo1Data = 32'h00000000;
   Snoop1En      = 1'b0;
// -----------------------------------------------------------------------------
//  Command Field - 3 bits
// -----------------------------------------------------------------------------
  if (Fifo1En == 1'b1)
    begin
      if (SDRAMSel == 1'b1 && FifoIn[30] == 1'b0 && FifoIn[29] == 1'b0 &&
          FifoIn[28] == 1'b1)
        begin
          NextFifo1Data[31:29] = 3'b111; // REFRESH/LCR;
          Snoop1En             = 1'b1;
        end

      if (SDRAMSel == 1'b1 && FifoIn[30] == 1'b0 && FifoIn[29] == 1'b1 &&
          FifoIn[28] == 1'b0 & FifoIn[10] ==1'b0)
        begin
          NextFifo1Data[31:29] = 3'b110; // PRECHARGE/ACTIVE;
          Snoop1En             = 1'b1;   // TERMINATE
        end

      if (SDRAMSel == 1'b1 && FifoIn[30] == 1'b1 && FifoIn[29] == 1'b0 &&
          FifoIn[28] == 1'b1)
        begin
          NextFifo1Data[31:29] = 3'b101; // READ;
          Snoop1En             = 1'b1;
        end

      if (SDRAMSel == 1'b1 && FifoIn[30] == 1'b1 && FifoIn[29] == 1'b0 &&
          FifoIn[28] ==1'b0)
        begin
          NextFifo1Data[31:29] = 3'b100; // WRITE;
          Snoop1En             = 1'b1;
        end

      if (SDRAMSel == 1'b1 && FifoIn[30] == 1'b0 && FifoIn[29] == 1'b1 &&
          FifoIn[28] == 1'b1)
        begin
          NextFifo1Data[31:29] = 3'b011; // ACTIVE;
          Snoop1En             = 1'b1;
        end

      if (SDRAMSel == 1'b1 && FifoIn[30] == 1'b1 && FifoIn[29] == 1'b1 &&
          FifoIn[28] == 1'b1)
        begin
          NextFifo1Data[31:29] = 3'b010; // NOP;
          Snoop1En             = 1'b1;
        end

      if (SDRAMSel == 1'b1 && FifoIn[30] == 1'b1 && FifoIn[29] == 1'b1 &&
          FifoIn[28] == 1'b0)
        begin
          NextFifo1Data[31:29] = 3'b001; // BURST TERMINATE;
          Snoop1En             = 1'b1;
        end

      if (SDRAMSel == 1'b1 && FifoIn[30] == 1'b0 && FifoIn[29] == 1'b0 &&
          FifoIn[28] ==1'b0)
        begin
          NextFifo1Data[31:29] = 3'b000; // LOAD MODE REGISTER;
          Snoop1En             = 1'b1;
        end
// -----------------------------------------------------------------------------
// Device Field - 3 bits
// -----------------------------------------------------------------------------
      if (Snoop1En == 1'b1)
        begin
          case (ChipSelect)
            8'b11111110 : NextFifo1Data[28:26] = 3'b000;
            8'b11111101 : NextFifo1Data[28:26] = 3'b001;
            8'b11111011 : NextFifo1Data[28:26] = 3'b010;
            8'b11110111 : NextFifo1Data[28:26] = 3'b011;
            8'b11101111 : NextFifo1Data[28:26] = 3'b100;
            8'b11011111 : NextFifo1Data[28:26] = 3'b101;
            8'b10111111 : NextFifo1Data[28:26] = 3'b110;
            8'b01111111 : NextFifo1Data[28:26] = 3'b111;
            default     : NextFifo1Data[28:26] = 3'b000;
          endcase
// -----------------------------------------------------------------------------
// Address Field - 26 bits
// -----------------------------------------------------------------------------
          NextFifo1Data[25:0] = FifoIn[25:0];
        end
    end
end // p_EncodeComb

// -----------------------------------------------------------------------------
// Combinational block which checks for a Snoop Enable condition and does
// the encoding of the FIFO2 data to a 32 bit register NextFifo2Data.
// -----------------------------------------------------------------------------
always @(FifoIn or Fifo2En or MPMCDATAOUT or MPMCDATAIN or SDRAMSel or
         RDataSmpEn)
begin : p_Fifo2Comb
   NextFifo2Data = 32'h00000000;
   Snoop2En      = 1'b0;
   if (Fifo2En == 1'b1)
     begin
       if (RDataSmpEn == 1'b1)
         begin
           NextFifo2Data = MPMCDATAIN;
           Snoop2En      = 1'b1;
         end

       if (SDRAMSel == 1'b1 && FifoIn[30] == 1'b1 && FifoIn[29] ==1'b0 &&
           FifoIn[28] ==1'b0)
         begin
           NextFifo2Data = MPMCDATAOUT;
           Snoop2En      = 1'b1;
         end
     end
end // p_Fifo2Comb

// -----------------------------------------------------------------------------
// Whenever a Fifo Clear or Snoop Enable or Read Enable comes, the required
// changes will be made to ShiftFifo1Data[i] respectively. The contents of the
// ShiftFifo1Data[i] will be moved to the Fifo1Data[i] at the positive edge
// of the HCLK in the sequential block.
// -----------------------------------------------------------------------------
always @(Fifo1Clear or Snoop1En or Fifo1Rd or NextFifo1Data or WritePntr1 or
         Fifo1Data[0] or iFifo1Out)
begin : p_ShiftReg1Comb
  for (i = 0; i < `FIFO_DEPTH; i = i+1)
    ShiftFifo1Data[i] = Fifo1Data[i];

  if (Fifo1Clear == 1'b1)
    begin
      NextWritePntr1   = 0;
      for (i = 0; i < `FIFO_DEPTH; i = i+1)
        begin
          TempFifo1Data     = Fifo1Data[i];
          TempFifo1Data[0]  = 1'b0;
          ShiftFifo1Data[i] = TempFifo1Data;
        end
    end
  else if (Snoop1En == 1'b1)
    begin
// -----------------------------------------------------------------------------
// Moving the encoded data to the WritePntr location of ShiftFifoData, when
// Snoop Enable is set, which will be refreshed to FifoData at posedge of
// the HCLK.
// -----------------------------------------------------------------------------
      NextWritePntr1 = WritePntr1 + 1;
      ShiftFifo1Data[WritePntr1] = NextFifo1Data;
    end
  else if (Fifo1Rd == 1'b1)
    begin
// -----------------------------------------------------------------------------
// The data in the FIFO register header is transfered to
// NextFifoOut, when Read Enable is set.This information will later be
// transfered to FifoOut at the positive edge of the HCLK.
// -----------------------------------------------------------------------------
      NextFifo1Out   = Fifo1Data[0];
      NextWritePntr1 = WritePntr1 - 1;
      for (i = 0; i < (`FIFO_DEPTH - 1); i = i+1)
        ShiftFifo1Data[i] = Fifo1Data[i + 1];
    end
  else
    begin
      NextFifo1Out   = iFifo1Out;
      NextWritePntr1 = WritePntr1;
    end
end // p_ShiftReg1Comb

// -----------------------------------------------------------------------------
// Whenever a Fifo Clear or Snoop Enable or Read Enable comes, the required
// changes will be made to ShiftFifo2Data[i] respectively. The contents of the
// ShiftFifo2Data[i] will be moved to the Fifo2Data[i] at the positive edge
// of the HCLK in the sequential block.
// -----------------------------------------------------------------------------
always @(Fifo2Clear or Snoop2En or Fifo2Rd or NextFifo2Data or WritePntr2 or
         Fifo2Data[0] or iFifo2Out)
begin : p_ShiftReg2Comb
  for (i = 0; i < `FIFO_DEPTH; i = i+1)
    ShiftFifo2Data[i] = Fifo2Data[i];

  if (Fifo2Clear == 1'b1)
    begin
      NextWritePntr2   = 1'b0;
      for (i = 0; i < `FIFO_DEPTH; i = i+1)
        begin
          TempFifo2Data     = Fifo2Data[i];
          TempFifo2Data[0]  = 1'b0;
          ShiftFifo2Data[i] = TempFifo2Data;
        end
    end
  else if (Snoop2En == 1'b1)
    begin
// -----------------------------------------------------------------------------
// Moving the encoded data to the WritePntr location of ShiftFifoData, when
// Snoop Enable is set, which will be refreshed to FifoData at posedge of
// the HCLK.
// -----------------------------------------------------------------------------
      NextWritePntr2 = WritePntr2 + 1;
      ShiftFifo2Data[WritePntr2] = NextFifo2Data;
// -----------------------------------------------------------------------------
// The data in the FIFO register header is transfered to
// NextFifoOut, when Read Enable is set.This information will later be
// transfered to FifoOut at the positive edge of the HCLK.
// -----------------------------------------------------------------------------
    end
  else if (Fifo2Rd == 1'b1)
    begin
      NextFifo2Out   = Fifo2Data[0];
      NextWritePntr2 = WritePntr2 - 1;
      for (i = 0; i < (`FIFO_DEPTH - 1); i = i+1)
        ShiftFifo2Data[i] = Fifo2Data[i + 1];
    end
  else
    begin
      NextFifo2Out   = iFifo2Out;
      NextWritePntr2 = WritePntr2;
    end
end // p_ShiftReg2Comb

// -----------------------------------------------------------------------------
// Sequential block in which the data is transfered to FIFO1 registers at
// the positive edge of the HCLK.
// -----------------------------------------------------------------------------
always @(posedge Fifo1SelClk or negedge nReset)
begin : p_ShiftReg1Seq
  if (nReset == 1'b0)
    begin
      WritePntr1       <= 1'b0;
      iFifo1Out        <= 32'h00000000;
      for (i = 0; i < `FIFO_DEPTH; i = i+1)
        Fifo1Data[i] <= 32'h00000000;
    end
  else
    begin
      WritePntr1       <= NextWritePntr1;
      iFifo1Out        <= NextFifo1Out;
      for (i = 0; i < `FIFO_DEPTH; i = i+1)
        Fifo1Data[i] <= ShiftFifo1Data[i];
    end
end // p_ShiftReg1Seq

// -----------------------------------------------------------------------------
// Sequential block in which the data is transfered to FIFO2 registers at
// the positive edge of the HCLK.
// -----------------------------------------------------------------------------
always @(posedge Fifo2SelClk or negedge nReset)
begin : p_ShiftReg2Seq
  if (nReset == 1'b0)
    begin
      WritePntr2       <= 1'b0;
      iFifo2Out        <= 32'h00000000;
      for (j = 0; j < `FIFO_DEPTH; j = j+1)
        Fifo2Data[j] <= 32'h00000000;
    end
  else
    begin
      WritePntr2       <= NextWritePntr2;
      iFifo2Out        <= NextFifo2Out;
      for (j = 0; j < `FIFO_DEPTH; j = j+1)
        Fifo2Data[j] <= ShiftFifo2Data[j];
    end
end // p_ShiftReg2Seq

// -----------------------------------------------------------------------------
// RAS latency check processes - RAS latency1 check timing signal
// -----------------------------------------------------------------------------
always @(NextFifo1Data)
begin : p_RASLat1Comb
  if (NextFifo1Data[31:29] == 3'b011)
    NxtRASLat1 = 1'b1;
  else
    NxtRASLat1 = 1'b0;
end // p_RASLat1Comb

// -----------------------------------------------------------------------------
// RAS latency2 check timing signal
// -----------------------------------------------------------------------------
always @(RASLat1)
begin : p_RASLat2Comb
  if (RASLat1 == 1'b1)
    NxtRASLat2 = 1'b1;
  else
    NxtRASLat2 = 1'b0;
end // p_RASLat2Comb

// -----------------------------------------------------------------------------
// RAS latency3 check timing signal
// -----------------------------------------------------------------------------
always @(RASLat2)
begin : p_RASLat3Comb
  if (RASLat2 == 1'b1)
    NxtRASLat3 = 1'b1;
  else
    NxtRASLat3 = 1'b0;
end // p_RASLat3Comb

// -----------------------------------------------------------------------------
// Clocking the RAS latency check timing signals
// -----------------------------------------------------------------------------
always @(negedge nReset or posedge MPMCCLK)
begin : p_RASLatSeq
  if (nReset == 1'b0)
    begin
      RASLat1 <= 1'b0;
      RASLat2 <= 1'b0;
      RASLat3 <= 1'b0;
    end
  else
    begin
      RASLat1 <= NxtRASLat1;
      RASLat2 <= NxtRASLat2;
      RASLat3 <= NxtRASLat3;
    end
end // p_RASLatSeq

// -----------------------------------------------------------------------------
// RAS latency protocol check. If the latency check is enabled and the MPMC
// does not meet the programmed latency, the process flags warning messages.
// -----------------------------------------------------------------------------
always @(posedge MPMCCLK)
begin : p_RChkSeq
  if (LatencyChkEn == 1'b1)
    begin
      if (ChipSelect[4] == 1'b0)
        begin
          if (MPMCTrDynRC0[1:0] == 2'b01)
            begin
              if (RASLat1 == 1'b1 && NextFifo1Data[31:30] != 2'b10)
                $display("RAS Latency1 violation for Dynamic memory bank 0");
            end
          else if (MPMCTrDynRC0[1:0] == 2'b10)
            begin
              if (RASLat2 == 1'b1 && NextFifo1Data[31:30] != 2'b10)
                $display("RAS Latency2 violation for Dynamic memory bank 0");
            end
          else if (MPMCTrDynRC0[1:0] == 2'b11)
            begin
              if (RASLat3 == 1'b1 && NextFifo1Data[31:30] != 2'b10)
                $display("RAS Latency3 violation for Dynamic memory bank 0");
            end
        end
      else if (ChipSelect[5] == 1'b0)
        begin
          if (MPMCTrDynRC1[1:0] == 2'b01)
            begin
              if (RASLat1 == 1'b1 && NextFifo1Data[31:30] != 2'b10)
                $display("RAS Latency1 violation for Dynamic memory bank 1");
            end
          else if (MPMCTrDynRC1[1:0] == 2'b10)
            begin
              if (RASLat2 == 1'b1 && NextFifo1Data[31:30] != 2'b10)
                $display("RAS Latency2 violation for Dynamic memory bank 1");
            end
          else if (MPMCTrDynRC1[1:0] == 2'b11)
            begin
              if (RASLat3 == 1'b1 && NextFifo1Data[31:30] != 2'b10)
                $display("RAS Latency3 violation for Dynamic memory bank 1");
            end
        end
      else if (ChipSelect[6] == 1'b0)
        begin
          if (MPMCTrDynRC2[1:0] == 2'b01)
            begin
              if (RASLat1 == 1'b1 && NextFifo1Data[31:30] != 2'b10)
                $display("RAS Latency1 violation for Dynamic memory bank 2");
            end
          else if (MPMCTrDynRC2[1:0] == 2'b10)
            begin
              if (RASLat2 == 1'b1 && NextFifo1Data[31:30] != 2'b10)
                $display("RAS Latency2 violation for Dynamic memory bank 2");
            end
          else if (MPMCTrDynRC2[1:0] == 2'b11)
            begin
              if (RASLat3 == 1'b1 && NextFifo1Data[31:30] != 2'b10)
                $display("RAS Latency3 violation for Dynamic memory bank 2");
            end
        end
      else if (ChipSelect[7] == 1'b0)
        begin
          if (MPMCTrDynRC3[1:0] == 2'b01)
            begin
              if (RASLat1 == 1'b1 && NextFifo1Data[31:30] != 2'b10)
                $display("RAS Latency1 violation for Dynamic memory bank 3");
            end
          else if (MPMCTrDynRC3[1:0] == 2'b10)
            begin
              if (RASLat2 == 1'b1 && NextFifo1Data[31:30] != 2'b10)
                $display("RAS Latency2 violation for Dynamic memory bank 3");
            end
          else if (MPMCTrDynRC3[1:0] == 2'b11)
            begin
              if (RASLat3 == 1'b1 && NextFifo1Data[31:30] != 2'b10)
                $display("RAS Latency3 violation for Dynamic memory bank 3");
            end
        end
    end
end // p_RChkSeq

// -----------------------------------------------------------------------------
// CAS latency check processes - CAS latency1 check timing signal
// -----------------------------------------------------------------------------
always @(NextFifo1Data)
begin : p_CASLat1Comb
  if (NextFifo1Data[31:29] == 3'b101)
    begin
      NxtCASLat1  = 1'b1;
      if (ChipSelect[4] == 1'b0)
        begin
          LatchCS = 2'b00;
        end
      else if (ChipSelect[5] == 1'b0)
        begin
          LatchCS = 2'b01;
        end
      else if (ChipSelect[6] == 1'b0)
        begin
          LatchCS = 2'b10;
        end
      else if (ChipSelect[7] == 1'b0)
        begin
          LatchCS = 2'b11;
        end
    end
  else
    NxtCASLat1    = 1'b0;
end // p_CASLat1Comb

// -----------------------------------------------------------------------------
// CAS latency2 check timing signal
// -----------------------------------------------------------------------------
always @(CASLat1)
begin : p_CASLat2Comb
  if (CASLat1 == 1'b1)
    NxtCASLat2 = 1'b1;
  else
    NxtCASLat2 = 1'b0;
end // p_CASLat2Comb

// -----------------------------------------------------------------------------
// CAS latency3 check timing signal
// -----------------------------------------------------------------------------
always @(CASLat2)
begin : p_CASLat3Comb
  if (CASLat2 == 1'b1)
    NxtCASLat3 = 1'b1;
  else
    NxtCASLat3 = 1'b0;
end // p_CASLat3Comb

// -----------------------------------------------------------------------------
// Clocking the CAS latency check timing signals
// -----------------------------------------------------------------------------
always @(negedge nReset or posedge DelMPMCCLK)
begin : p_CASLatSeq
  if (nReset == 1'b0)
    begin
      CASLat1 <= 1'b0;
      CASLat2 <= 1'b0;
      CASLat3 <= 1'b0;
    end
  else
    begin
      CASLat1 <= NxtCASLat1;
      CASLat2 <= NxtCASLat2;
      CASLat3 <= NxtCASLat3;
    end
end // p_CASLatSeq

// -----------------------------------------------------------------------------
// Generating Read Data sample enable signal to snoop the read data int o the
// FIFO. By reading the data from the FIFO validates the integrity of the
// read data.
// -----------------------------------------------------------------------------
always @(LatencyChkEn or LatchCS or MPMCTrDynRC0 or MPMCTrDynRC1 or
         MPMCTrDynRC2 or MPMCTrDynRC3 or CASLat1 or CASLat2 or CASLat3)
begin : p_SnpRDataComb
  if (LatencyChkEn == 1'b1)
    begin
      if ((LatchCS == 2'b00 && MPMCTrDynRC0[9:8] == 2'b01) ||
          (LatchCS == 2'b01 && MPMCTrDynRC1[9:8] == 2'b01) ||
          (LatchCS == 2'b10 && MPMCTrDynRC2[9:8] == 2'b01) ||
          (LatchCS == 2'b11 && MPMCTrDynRC3[9:8] == 2'b01))
        RDataSmpEn = CASLat1;
      else if ((LatchCS == 2'b00 && MPMCTrDynRC0[9:8] == 2'b10) ||
               (LatchCS == 2'b01 && MPMCTrDynRC1[9:8] == 2'b10) ||
               (LatchCS == 2'b10 && MPMCTrDynRC2[9:8] == 2'b10) ||
               (LatchCS == 2'b11 && MPMCTrDynRC3[9:8] == 2'b10))
        RDataSmpEn = CASLat2;
      else if ((LatchCS == 2'b00 && MPMCTrDynRC0[9:8] == 2'b11) ||
               (LatchCS == 2'b01 && MPMCTrDynRC1[9:8] == 2'b11) ||
               (LatchCS == 2'b10 && MPMCTrDynRC2[9:8] == 2'b11) ||
               (LatchCS == 2'b11 && MPMCTrDynRC3[9:8] == 2'b11))
        RDataSmpEn = CASLat3;
      else
        RDataSmpEn = 1'b0;
    end
  else
    RDataSmpEn = 1'b0;
end // p_SnpRDataComb

endmodule

// --================================== End ==================================--
