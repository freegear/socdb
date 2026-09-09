// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdFifoCntl.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
// -----------------------------------------------------------------------------
// Purpose                 : To generate control signals for the FIFO.
// --=========================================================================--

`timescale 1ns/1ps
`include "ClcdConfig.v"
// ----------------------------------------------------------------------------

module ClcdFifoCntl(
                    HCLK, 
                    HRESETn,
                    FrameRst, 
                    RdPtrInc, 
                    WrEnable,
                    
                    WrPtr,
                    FifoFull,
                    FifoUF,
                    FillLevel
                   );

input  HCLK;
// All logic within the Sync FIFO is clocked on the rising edge of HCLK

input  HRESETn;
// Active low Reset

input  FrameRst;
// End of frame signal from timing generator

input  RdPtrInc;
// When HIGH, indicates that the Read Port has requested a Read Pointerincrement

input  WrEnable;
// Data is written into the selected FIFO element on the rising edge of HCLK
// when this signal is high

output [`PTR_SIZE-1:0] WrPtr;
// This goes as WrAddr to Register File/RAM

output FifoFull;
// This indicates whether Fifo is full

output FifoUF;
// Fifo underflow status

output [`PTR_SIZE:0] FillLevel;
// Indicates Fill level 

// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module contains
// - Write pointer and Read pointer increment logic.
// - Fifo fill level computation logic.
// - Data available signal generation logic.
// - Fifo underflow signal generation logic.
// -----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Wire declaration
// ----------------------------------------------------------------------------
wire   HCLK;
// Clock input                                                 (Module Input)

wire   HRESETn;
// Reset input                                                 (Module Input)

wire   FrameRst;
// End of frame signal from timing generator                   (Module Input)

wire   RdPtrInc;
// Read pointer increment enable                               (Module Input)

wire   WrEnable;
// Write pointer increment enable                              (Module Input)

wire               IntRdEnable;
// Read pointer increment enable qualified with data available signal

wire               IntWrEnable;
// Write pointer increment enable qualified with FifoFULL signal

wire               FifoFull;
// Register for Fifo full flag                                 (Module Output)

wire               DataAvail;
// Register for data available signal                        

wire [`PTR_SIZE:0] FillLevel;
// Fifo fill level                                             (Module Output)

// ----------------------------------------------------------------------------
// register declaration
// ----------------------------------------------------------------------------
reg                Wrap;
// Indicates pointers wrap around status. this bit is used in the FIFO fill 
// level computation.

reg                FifoUF;
// Register for Fifo underflow flag                            (Module Output)

reg [`PTR_SIZE-1:0] WrPtr;
// Fifo write pointer                                          (Module Output)

reg [`PTR_SIZE-1:0] RdPtr;
// Fifo read pointer                                           (Module Output)

reg [`PTR_SIZE-1:0] NextWrPtr;
// D-input of Fifo write pointer

reg [`PTR_SIZE-1:0] NextRdPtr;
// D-input of Fifo read pointer

reg                NextFifoUF;
// D-input of FifoUF

reg                NextWrap;
// D-input of Wrap
//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Increment based on WrEnable ONLY if FifoFull is not asserted.
// ----------------------------------------------------------------------------
assign IntWrEnable = WrEnable & ((~FifoFull) | RdPtrInc);

// ----------------------------------------------------------------------------
// Increment based on RdPtrInc ONLY if DataAvail is asserted.
// ----------------------------------------------------------------------------
assign IntRdEnable = RdPtrInc && DataAvail;

// ----------------------------------------------------------------------------
// Increment the write pointer by 1 if the IntWrEnable signal is sampled HIGH.
// On system reset or Frame reset(End of frame),Initialise the  write pointer 
// to zero. 
// ----------------------------------------------------------------------------
always @(WrPtr or IntWrEnable or FrameRst)
begin : p_WrptrComb
  if (FrameRst == 1'b1)
    NextWrPtr =  0;
  else if (IntWrEnable == 1'b1)
    NextWrPtr = WrPtr + 1'b1;
  else
    NextWrPtr = WrPtr;
end // p_WrptrComb

// ----------------------------------------------------------------------------
// Sequential process for write pointer
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_WrptrSeq
  if (HRESETn == 1'b0)
    WrPtr <=  0;
  else
    WrPtr <=  NextWrPtr;
end // p_WrptrSeq

// ----------------------------------------------------------------------------
// Increment the read pointer by 1 if the IntRdEnable signal is sampled HIGH.
// On system reset or Frame reset(End of frame),Initialise the  write pointer 
// to zero. 
// ----------------------------------------------------------------------------
always @(RdPtr or IntRdEnable or FrameRst)
begin : p_RdptrComb
  if (FrameRst == 1'b1)
    NextRdPtr = 0;
  else if (IntRdEnable == 1'b1)
    NextRdPtr =  RdPtr + 1'b1;
  else
    NextRdPtr =  RdPtr;
end // p_RdptrComb

// ----------------------------------------------------------------------------
// Sequential process for read pointer
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RdPtrSeq
  if (HRESETn == 1'b0)
    RdPtr <=  0;
  else
    RdPtr <=  NextRdPtr;
end // p_RdPtrSeq

// ----------------------------------------------------------------------------
// Wrap signal generation
// This signal is asserted when WrPtr Wraps around. It is deasserted when RdPtr
// Wraps around.
// ----------------------------------------------------------------------------
always @(Wrap or IntWrEnable or IntRdEnable or FrameRst or WrPtr or RdPtr)
begin : p_WrapComb
  if (FrameRst == 1'b1)
    NextWrap =  1'b0;
  else if (((WrPtr == (`FIFO_DEPTH-1)) && (IntWrEnable == 1'b1)) ^
                ((RdPtr == (`FIFO_DEPTH-1)) && (IntRdEnable == 1'b1)))
    NextWrap =  ~Wrap;
  else
    NextWrap =  Wrap;
end // p_WrapComb

// ----------------------------------------------------------------------------
// Sequential process for Wrap 
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_WrapSeq
  if (HRESETn == 1'b0)
    Wrap <= 1'b0;
  else 
    Wrap <=  NextWrap;
end // p_WrapSeq

// ----------------------------------------------------------------------------
// Data available signal generation. An indication of whether the FIFO is empty.
// FifoFull signal is also generated out of this combinational block.
// - If the FillLevel is 0, both read and write pointers are pointing to the
// same location and the FIFO is empty. So DataAvail is not asserted.
//
// - If the FillLevel is equal to the FIFO_DEPTH, then also the pointers are
// pointing to the same location but the FIFO is full and the read pointer
// is behind write pointer by FIFO_DEPTH. We should not overwrite the data
// in the location that write pointer is presently pointing to since the
// data is not yet read.
// FifoFull can also be written as the top most bit of FillLevel
//
// ----------------------------------------------------------------------------

assign DataAvail = (FillLevel == 1'b0) ? 1'b0 : 1'b1;
assign FifoFull  = FillLevel[`PTR_SIZE];
assign FillLevel = ({Wrap, WrPtr} - {1'b0, RdPtr});

// ----------------------------------------------------------------------------
// Fifo underflow signal generation. If Fifo is empty and there is a read 
// request assert FifoUF signal.
// ----------------------------------------------------------------------------
always @(RdPtrInc or WrEnable or FillLevel)
begin : p_FifoUFComb
  if ((FillLevel == 1'b0) && (RdPtrInc == 1'b1) && (WrEnable == 1'b0))
    NextFifoUF = 1'b1;
  else
    NextFifoUF = 1'b0;
end // p_FifoUFComb

// ----------------------------------------------------------------------------
// Sequential process for FIFO underflow signal
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_FifoUFSeq
  if (HRESETn == 1'b0)
    FifoUF <= 1'b0;
  else
    FifoUF <= NextFifoUF;
end // p_FifoUFSeq

endmodule

// --=========================================================================--
