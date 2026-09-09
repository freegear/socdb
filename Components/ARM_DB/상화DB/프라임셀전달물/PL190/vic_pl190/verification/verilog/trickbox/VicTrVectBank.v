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
// File Name              : VicTrVectBank.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL190-REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           This module implements the Mirrored VIC functionality.
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module VicTrVectBank (
// Inputs
                      HCLK,
                      HRESETn,
                      VICTrFIQStatus,
                      VICTrIRQStatus,
                      VICTrIRQStatSync,
                      nVICTrFIQIn,
                      nVICTrIRQIn,
                      SetCSRBit,
                      ClearCSRBit,
                      VICTrVectAddrIn,
                      VICTrDefVectAddr,
                      VICTrVectAddr0,
                      VICTrVectAddr1,
                      VICTrVectAddr2,
                      VICTrVectAddr3,
                      VICTrVectAddr4,
                      VICTrVectAddr5,
                      VICTrVectAddr6,
                      VICTrVectAddr7,
                      VICTrVectAddr8,
                      VICTrVectAddr9,
                      VICTrVectAddr10,
                      VICTrVectAddr11,
                      VICTrVectAddr12,
                      VICTrVectAddr13,
                      VICTrVectAddr14,
                      VICTrVectAddr15,
                      VICTrVectCntl0,
                      VICTrVectCntl1,
                      VICTrVectCntl2,
                      VICTrVectCntl3,
                      VICTrVectCntl4,
                      VICTrVectCntl5,
                      VICTrVectCntl6,
                      VICTrVectCntl7,
                      VICTrVectCntl8,
                      VICTrVectCntl9,
                      VICTrVectCntl10,
                      VICTrVectCntl11,
                      VICTrVectCntl12,
                      VICTrVectCntl13,
                      VICTrVectCntl14,
                      VICTrVectCntl15,
// Outputs
                      nFIQ,
                      nIRQ,
                      VICTrVectAddrOut
                      );

// Inputs
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
input  [31:0] VICTrFIQStatus;   // FIQ status signal from VicTrIntReq
                                // sub-block
input  [31:0] VICTrIRQStatus;   // IRQ status signal from VicTrIntReq
                                // sub-block
input  [31:0] VICTrIRQStatSync; // Double synchronised IRQ Status
input         nVICTrFIQIn;      // nFIQIn Daisy chain signal from
                                // VicTrAhbif sub-block
input         nVICTrIRQIn;      // nIRQIn Daisy chain signal from
                                // VicTrAhbif sub-block
input         SetCSRBit;        // Control signal to set the active bit
                                // in the CSR
input         ClearCSRBit;      // Control signal to clear the active
                                // bit in the CSR
input  [31:0] VICTrVectAddrIn;  // VectAddrIn Daisy chain signal from
                                // VicTrAhbif sub-block
input  [31:0] VICTrDefVectAddr; // Default vector Address
input  [31:0] VICTrVectAddr0;   // VectorAddr of Vector Bank0
input  [31:0] VICTrVectAddr1;   // VectorAddr of Vector Bank1
input  [31:0] VICTrVectAddr2;   // VectorAddr of Vector Bank2
input  [31:0] VICTrVectAddr3;   // VectorAddr of Vector Bank3
input  [31:0] VICTrVectAddr4;   // VectorAddr of Vector Bank4
input  [31:0] VICTrVectAddr5;   // VectorAddr of Vector Bank5
input  [31:0] VICTrVectAddr6;   // VectorAddr of Vector Bank6
input  [31:0] VICTrVectAddr7;   // VectorAddr of Vector Bank7
input  [31:0] VICTrVectAddr8;   // VectorAddr of Vector Bank8
input  [31:0] VICTrVectAddr9;   // VectorAddr of Vector Bank9
input  [31:0] VICTrVectAddr10;  // VectorAddr of Vector Bank10
input  [31:0] VICTrVectAddr11;  // VectorAddr of Vector Bank11
input  [31:0] VICTrVectAddr12;  // VectorAddr of Vector Bank12
input  [31:0] VICTrVectAddr13;  // VectorAddr of Vector Bank13
input  [31:0] VICTrVectAddr14;  // VectorAddr of Vector Bank14
input  [31:0] VICTrVectAddr15;  // VectorAddr of Vector Bank15
input   [5:0] VICTrVectCntl0;   // VectorCntl of Vector Bank0
input   [5:0] VICTrVectCntl1;   // VectorCntl of Vector Bank1
input   [5:0] VICTrVectCntl2;   // VectorCntl of Vector Bank2
input   [5:0] VICTrVectCntl3;   // VectorCntl of Vector Bank3
input   [5:0] VICTrVectCntl4;   // VectorCntl of Vector Bank4
input   [5:0] VICTrVectCntl5;   // VectorCntl of Vector Bank5
input   [5:0] VICTrVectCntl6;   // VectorCntl of Vector Bank6
input   [5:0] VICTrVectCntl7;   // VectorCntl of Vector Bank7
input   [5:0] VICTrVectCntl8;   // VectorCntl of Vector Bank8
input   [5:0] VICTrVectCntl9;   // VectorCntl of Vector Bank9
input   [5:0] VICTrVectCntl10;  // VectorCntl of Vector Bank10
input   [5:0] VICTrVectCntl11;  // VectorCntl of Vector Bank11
input   [5:0] VICTrVectCntl12;  // VectorCntl of Vector Bank12
input   [5:0] VICTrVectCntl13;  // VectorCntl of Vector Bank13
input   [5:0] VICTrVectCntl14;  // VectorCntl of Vector Bank14
input   [5:0] VICTrVectCntl15;  // VectorCntl of Vector Bank15

// Outputs
output        nFIQ;             // nFIQ output of the Mirrored VIC
output        nIRQ;             // nIRQ output of the Mirrored VIC
output [31:0] VICTrVectAddrOut; // VectAddr output of the Mirrored VIC

// Inputs
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
wire   [31:0] VICTrFIQStatus;   // FIQ status signal from VicTrIntReq
                                // sub-block
wire   [31:0] VICTrIRQStatus;   // IRQ status signal from VicTrIntReq
                                // sub-block
wire   [31:0] VICTrIRQStatSync; // Double synchronised IRQ Status
wire          nVICTrFIQIn;      // nFIQIn Daisy chain signal from
                                // VicTrAhbif sub-block
wire          nVICTrIRQIn;      // nIRQIn Daisy chain signal from
                                // VicTrAhbif sub-block
wire          SetCSRBit;        // Control signal to set the active bit
                                // in the CSR
wire          ClearCSRBit;      // Control signal to clear the active
                                // bit in the CSR
wire   [31:0] VICTrVectAddrIn;  // VectAddrIn Daisy chain signal from
                                // VicTrAhbif sub-block
wire   [31:0] VICTrDefVectAddr; // Default vector Address
wire   [31:0] VICTrVectAddr0;   // VectorAddr of Vector Bank0
wire   [31:0] VICTrVectAddr1;   // VectorAddr of Vector Bank1
wire   [31:0] VICTrVectAddr2;   // VectorAddr of Vector Bank2
wire   [31:0] VICTrVectAddr3;   // VectorAddr of Vector Bank3
wire   [31:0] VICTrVectAddr4;   // VectorAddr of Vector Bank4
wire   [31:0] VICTrVectAddr5;   // VectorAddr of Vector Bank5
wire   [31:0] VICTrVectAddr6;   // VectorAddr of Vector Bank6
wire   [31:0] VICTrVectAddr7;   // VectorAddr of Vector Bank7
wire   [31:0] VICTrVectAddr8;   // VectorAddr of Vector Bank8
wire   [31:0] VICTrVectAddr9;   // VectorAddr of Vector Bank9
wire   [31:0] VICTrVectAddr10;  // VectorAddr of Vector Bank10
wire   [31:0] VICTrVectAddr11;  // VectorAddr of Vector Bank11
wire   [31:0] VICTrVectAddr12;  // VectorAddr of Vector Bank12
wire   [31:0] VICTrVectAddr13;  // VectorAddr of Vector Bank13
wire   [31:0] VICTrVectAddr14;  // VectorAddr of Vector Bank14
wire   [31:0] VICTrVectAddr15;  // VectorAddr of Vector Bank15
wire    [5:0] VICTrVectCntl0;   // VectorCntl of Vector Bank0
wire    [5:0] VICTrVectCntl1;   // VectorCntl of Vector Bank1
wire    [5:0] VICTrVectCntl2;   // VectorCntl of Vector Bank2
wire    [5:0] VICTrVectCntl3;   // VectorCntl of Vector Bank3
wire    [5:0] VICTrVectCntl4;   // VectorCntl of Vector Bank4
wire    [5:0] VICTrVectCntl5;   // VectorCntl of Vector Bank5
wire    [5:0] VICTrVectCntl6;   // VectorCntl of Vector Bank6
wire    [5:0] VICTrVectCntl7;   // VectorCntl of Vector Bank7
wire    [5:0] VICTrVectCntl8;   // VectorCntl of Vector Bank8
wire    [5:0] VICTrVectCntl9;   // VectorCntl of Vector Bank9
wire    [5:0] VICTrVectCntl10;  // VectorCntl of Vector Bank10
wire    [5:0] VICTrVectCntl11;  // VectorCntl of Vector Bank11
wire    [5:0] VICTrVectCntl12;  // VectorCntl of Vector Bank12
wire    [5:0] VICTrVectCntl13;  // VectorCntl of Vector Bank13
wire    [5:0] VICTrVectCntl14;  // VectorCntl of Vector Bank14
wire    [5:0] VICTrVectCntl15;  // VectorCntl of Vector Bank15

// Outputs
reg           nFIQ;             // nFIQ output of the Mirrored VIC
reg           nIRQ;             // nIRQ output of the Mirrored VIC

reg    [31:0] VICTrVectAddrOut; // VectAddr output of the Mirrored VIC

// ---------------------------------------------------------------------
//
//                            VicTrVectBank
//                            =============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This block generates the outputs of the Mirrored VIC model.
// The Priority resolution logic and the VectAddrOut decoding logic
// are implemented in this module.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
integer     i;
// FOR loop variable

wire [15:0] RawVectIRQ;
// Status of Vectored IRQ after source decoding

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg TempFIQ;
// Temporary variable for generating nFIQ

reg         NonVectIRQ;
// Non vectored IRQ before masking by priority logic

reg TempIRQ;
// Temporary variable for generating nIRQ

reg         ActiveNonVectIRQ;
// Clocked non vectored IRQ after masking by priority logic

reg         NxtActNonVectIRQ;
// Non vectored IRQ after masking by priority logic

reg         ActiveExtIRQ;
// External IRQ after masking by priority logic

reg         MaskExtIRQ;
// Mask signal for External IRQ

reg         MaskNonVectIRQ;
// Mask signal for Non vectored IRQ

reg [15:0] MaskVectIRQ;
// Mask signal for vectored IRQ

reg [15:0] NxtVectIRQ;
// D-input for VectIRQ

reg [15:0] VectIRQ;
// Status register to indicate the currently active vectored IRQ

reg  [15:0] ActiveVectIRQ;
// Status register to indicate the IRQ currently being serviced

reg  [16:0] CurrentSerReg;
// Register to track nested Vectored Interrupts

reg  [16:0] NxtCurrentSerReg;
// D-input of CurrentSerReg

reg         ClearNonVectIRQ;
// Status signal to indicate the Non Vectored IRQ currently being
// serviced

// ---------------------------------------------------------------------
// Function declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// SelectSource
// ------------
//   This function decodes the Source part of the VectCntl. If the
// interrupt source corresponding to the VectCntl Source slice is
// active, the function returns HIGH, otherwise LOW.
// ---------------------------------------------------------------------
function SelectSource;
input  [31:0] IntSource; // IRQ Status
input   [5:0] VectCntl;  // Vector Control Register

reg         RawVectIRQ;  // Source decoded vectored IRQ

begin
  case (VectCntl[4:0])
    5'b00000 : RawVectIRQ = IntSource[0] & VectCntl[5];
    5'b00001 : RawVectIRQ = IntSource[1] & VectCntl[5];
    5'b00010 : RawVectIRQ = IntSource[2] & VectCntl[5];
    5'b00011 : RawVectIRQ = IntSource[3] & VectCntl[5];
    5'b00100 : RawVectIRQ = IntSource[4] & VectCntl[5];
    5'b00101 : RawVectIRQ = IntSource[5] & VectCntl[5];
    5'b00110 : RawVectIRQ = IntSource[6] & VectCntl[5];
    5'b00111 : RawVectIRQ = IntSource[7] & VectCntl[5];
    5'b01000 : RawVectIRQ = IntSource[8] & VectCntl[5];
    5'b01001 : RawVectIRQ = IntSource[9] & VectCntl[5];
    5'b01010 : RawVectIRQ = IntSource[10] & VectCntl[5];
    5'b01011 : RawVectIRQ = IntSource[11] & VectCntl[5];
    5'b01100 : RawVectIRQ = IntSource[12] & VectCntl[5];
    5'b01101 : RawVectIRQ = IntSource[13] & VectCntl[5];
    5'b01110 : RawVectIRQ = IntSource[14] & VectCntl[5];
    5'b01111 : RawVectIRQ = IntSource[15] & VectCntl[5];
    5'b10000 : RawVectIRQ = IntSource[16] & VectCntl[5];
    5'b10001 : RawVectIRQ = IntSource[17] & VectCntl[5];
    5'b10010 : RawVectIRQ = IntSource[18] & VectCntl[5];
    5'b10011 : RawVectIRQ = IntSource[19] & VectCntl[5];
    5'b10100 : RawVectIRQ = IntSource[20] & VectCntl[5];
    5'b10101 : RawVectIRQ = IntSource[21] & VectCntl[5];
    5'b10110 : RawVectIRQ = IntSource[22] & VectCntl[5];
    5'b10111 : RawVectIRQ = IntSource[23] & VectCntl[5];
    5'b11000 : RawVectIRQ = IntSource[24] & VectCntl[5];
    5'b11001 : RawVectIRQ = IntSource[25] & VectCntl[5];
    5'b11010 : RawVectIRQ = IntSource[26] & VectCntl[5];
    5'b11011 : RawVectIRQ = IntSource[27] & VectCntl[5];
    5'b11100 : RawVectIRQ = IntSource[28] & VectCntl[5];
    5'b11101 : RawVectIRQ = IntSource[29] & VectCntl[5];
    5'b11110 : RawVectIRQ = IntSource[30] & VectCntl[5];
    5'b11111 : RawVectIRQ = IntSource[31] & VectCntl[5];
    default  : RawVectIRQ = 1'b0;
  endcase
  SelectSource = RawVectIRQ;
end
endfunction

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// nFIQ generation
// ---------------------------------------------------------------------
always @(nVICTrFIQIn or VICTrFIQStatus)
begin : p_FIQComb
  TempFIQ = |(VICTrFIQStatus);
  nFIQ    = ~(TempFIQ) & nVICTrFIQIn;
end // p_FIQComb

// ---------------------------------------------------------------------
// Non vectored IRQ generation
// ---------------------------------------------------------------------
always @(VICTrIRQStatus)
begin : p_IRQComb
  NonVectIRQ = |(VICTrIRQStatus);
end // p_IRQComb

// ---------------------------------------------------------------------
// Vectored IRQ Mask generation
// ---------------------------------------------------------------------
always @(MaskVectIRQ or NxtVectIRQ or CurrentSerReg)
begin : p_MaskVectIRQComb
  MaskVectIRQ[0] <= CurrentSerReg[0];
  for (i = 1; i < 16; i = i + 1)
    begin
      if ((MaskVectIRQ[i-1] == 1'b1) | (NxtVectIRQ[i-1] == 1'b1) |
         (CurrentSerReg[i] == 1'b1))
        MaskVectIRQ[i] = 1'b1;
      else
        MaskVectIRQ[i] = 1'b0;
    end
end // p_MaskVectIRQComb

// ---------------------------------------------------------------------
// External IRQ Mask generation
// ---------------------------------------------------------------------
always @(MaskNonVectIRQ or NxtActNonVectIRQ)
begin : p_MaskExtIRQComb
  if ((MaskNonVectIRQ == 1'b1) | (NxtActNonVectIRQ == 1'b1))
    MaskExtIRQ = 1'b1;
  else
    MaskExtIRQ = 1'b0;
end // p_MaskExtIRQComb

// ---------------------------------------------------------------------
// External IRQ Masking
// ---------------------------------------------------------------------
always @(MaskExtIRQ or nVICTrIRQIn)
begin : p_ExtIRQComb
  if (MaskExtIRQ == 1'b1)
    ActiveExtIRQ = 1'b0;
  else
    ActiveExtIRQ = ~(nVICTrIRQIn);
end // p_ExtIRQComb

// ---------------------------------------------------------------------
// Non vectored IRQ Mask generation
// ---------------------------------------------------------------------
always @(MaskVectIRQ or NxtVectIRQ or CurrentSerReg)
begin : p_MskNonVecIRQComb
  if ((MaskVectIRQ[15] == 1'b1) | (NxtVectIRQ[15] == 1'b1) |
      (CurrentSerReg[16] == 1'b1))
    MaskNonVectIRQ = 1'b1;
  else
    MaskNonVectIRQ = 1'b0;
end // p_MskNonVecIRQComb

// ---------------------------------------------------------------------
// Non vectored IRQ Masking
// ---------------------------------------------------------------------
always @(MaskNonVectIRQ or NonVectIRQ)
begin : p_NonVectIRQComb
  if (MaskNonVectIRQ == 1'b1)
    NxtActNonVectIRQ = 1'b0;
  else
    NxtActNonVectIRQ = NonVectIRQ;
end // p_NonVectIRQComb

// ---------------------------------------------------------------------
// Vector Bank RawInterrupt generation
// ---------------------------------------------------------------------
assign RawVectIRQ[0]    = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl0);
assign RawVectIRQ[1]    = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl1);
assign RawVectIRQ[2]    = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl2);
assign RawVectIRQ[3]    = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl3);
assign RawVectIRQ[4]    = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl4);
assign RawVectIRQ[5]    = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl5);
assign RawVectIRQ[6]    = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl6);
assign RawVectIRQ[7]    = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl7);
assign RawVectIRQ[8]    = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl8);
assign RawVectIRQ[9]    = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl9);
assign RawVectIRQ[10]   = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl10);
assign RawVectIRQ[11]   = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl11);
assign RawVectIRQ[12]   = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl12);
assign RawVectIRQ[13]   = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl13);
assign RawVectIRQ[14]   = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl14);
assign RawVectIRQ[15]   = SelectSource(VICTrIRQStatSync,
                                       VICTrVectCntl15);

// ---------------------------------------------------------------------
// Vectored IRQ Masking
// ---------------------------------------------------------------------
always @(MaskVectIRQ or RawVectIRQ)
begin : p_VectIRQComb
  for (i = 0; i < 16; i = i + 1)
    if (MaskVectIRQ[i] == 1'b1)
      NxtVectIRQ[i] = 1'b0;
    else
      NxtVectIRQ[i] = RawVectIRQ[i];
end // p_VectIRQComb

// ---------------------------------------------------------------------
// Generation of the signal which indicates the bit to be cleared
// next in the Current Service Register
// ---------------------------------------------------------------------
always @(MaskVectIRQ or MaskNonVectIRQ)
begin : p_ActVecIRQComb
  ActiveVectIRQ[0] = MaskVectIRQ[0];
  for (i = 1; i < 16; i = i + 1)
    ActiveVectIRQ[i] = MaskVectIRQ[i-1] ^ MaskVectIRQ[i];
  ClearNonVectIRQ = MaskVectIRQ[15] ^ MaskNonVectIRQ;
end // p_ActVecIRQComb

// ---------------------------------------------------------------------
// nIRQ generation
// ---------------------------------------------------------------------
always @(ActiveExtIRQ or NxtActNonVectIRQ or NxtVectIRQ)
begin : p_nIRQComb
  TempIRQ = |(NxtVectIRQ);
  nIRQ    = ~(TempIRQ | ActiveExtIRQ | NxtActNonVectIRQ);
end // p_nIRQComb

// ---------------------------------------------------------------------
// Combinational logic for the Current Service Register
// ---------------------------------------------------------------------
always @(SetCSRBit or ClearCSRBit or VectIRQ or ActiveNonVectIRQ or
         ClearNonVectIRQ or CurrentSerReg or ActiveVectIRQ)
begin : p_CSRComb
  if (SetCSRBit == 1'b1)
    begin
      for (i = 0; i < 16; i = i + 1)
        begin
          if (VectIRQ[i] == 1'b1)
            NxtCurrentSerReg[i] = 1'b1;
          else
            NxtCurrentSerReg[i] = CurrentSerReg[i];
        end
      if (ActiveNonVectIRQ == 1'b1)
        NxtCurrentSerReg[16] = 1'b1;
      else
        NxtCurrentSerReg[16] = CurrentSerReg[16];
    end
  else if (ClearCSRBit == 1'b1)
    begin
      for (i = 0; i < 16; i = i + 1)
        begin
          if (ActiveVectIRQ[i] == 1'b1)
            NxtCurrentSerReg[i] = 1'b0;
          else
            NxtCurrentSerReg[i] = CurrentSerReg[i];
        end
      if (ClearNonVectIRQ == 1'b1)
        NxtCurrentSerReg[16] = 1'b0;
      else
        NxtCurrentSerReg[16] = CurrentSerReg[16];
      end
  else
    NxtCurrentSerReg = CurrentSerReg;
end // p_CSRComb

// ---------------------------------------------------------------------
// Sequential logic for the Current Service Register
// ---------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_CSRSeq
  if (HRESETn == 1'b0)
    begin
      CurrentSerReg    <= 16'h0000;
      VectIRQ          <= 16'h0000;
      ActiveNonVectIRQ <= 1'b0;
    end
  else
    begin
      CurrentSerReg    <= NxtCurrentSerReg;
      VectIRQ          <= NxtVectIRQ;
      ActiveNonVectIRQ <= NxtActNonVectIRQ;
    end
end // p_CSRSeq

// ---------------------------------------------------------------------
// Vector Address select
// ---------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_VectAddrSeq
  if (HRESETn == 1'b0)
    VICTrVectAddrOut <= 32'h0;
  else if (NxtVectIRQ[0] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr0;
  else if (NxtVectIRQ[1] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr1;
  else if (NxtVectIRQ[2] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr2;
  else if (NxtVectIRQ[3] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr3;
  else if (NxtVectIRQ[4] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr4;
  else if (NxtVectIRQ[5] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr5;
  else if (NxtVectIRQ[6] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr6;
  else if (NxtVectIRQ[7] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr7;
  else if (NxtVectIRQ[8] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr8;
  else if (NxtVectIRQ[9] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr9;
  else if (NxtVectIRQ[10] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr10;
  else if (NxtVectIRQ[11] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr11;
  else if (NxtVectIRQ[12] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr12;
  else if (NxtVectIRQ[13] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr13;
  else if (NxtVectIRQ[14] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr14;
  else if (NxtVectIRQ[15] == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddr15;
  else if (NxtActNonVectIRQ == 1'b1)
    VICTrVectAddrOut <= VICTrDefVectAddr;
  else if (ActiveExtIRQ == 1'b1)
    VICTrVectAddrOut <= VICTrVectAddrIn;
  else
    VICTrVectAddrOut <= VICTrDefVectAddr;
end // p_VectAddrSeq

endmodule

// --============================== End ==============================--
