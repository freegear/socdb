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
// File Name              : AaciTrRxFIFO.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           This block is receive FIFO array of the trickbox and 
//           associated control logic
//
// --=================================================================--

`timescale 1ns/1ps

`include   "AaciTrPackage.v"

// ---------------------------------------------------------------------

module AaciTrRxFIFO (
// Inputs
                     // APB signals
                     PCLK,
                     PRESETn,
                     RxFWrSync,
                     RxFRdPtrInc,
                     RxFWrData,
// Outputs
                     RxFRdData,
                     RxFFillLevel 
                    );
 
// Inputs
input                    PCLK;             // APB clock
input                    PRESETn;          // Reset from APB
input                    RxFWrSync;        // RX FIFO write enable
input                    RxFRdPtrInc;      // RX FIFO read pointer incr.
input             [19:0] RxFWrData;        // RX FIFO Wr data
// Outputs
output            [19:0] RxFRdData;        // RX FIFO read data
output [`POINTERWIDTH:0] RxFFillLevel;     // RX FIFO fill level

// Inputs
wire                     PCLK;             // APB clock
wire                     PRESETn;          // Reset from APB
wire                     RxFWrSync;        // RX FIFO write enable
wire                     RxFRdPtrInc;      // RX FIFO read pointer incr
wire              [19:0] RxFWrData;        // RX FIFO Wr data
// Outputs
wire              [19:0] RxFRdData;        // RX FIFO read data
wire   [`POINTERWIDTH:0] RxFFillLevel;     // RX FIFO fill level

// ---------------------------------------------------------------------
//
//                           AaciTrRxFIFO
//                           ============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//
// Data on the RxFWrData bus is written into the location in the Receive
// FIFO pointed to by the current value of the WrPtr on the rising edge
// of PCLK on when the RegFileWrEn signal is sampled high.
// Data in the FIFO location pointed to by the RdPtr signal is always
// driven on the RxFRdData[19:0] output.
// The Receive FIFO is implemented as a circular buffer.
// FIFO fill level is calculated by finding the difference between the
// pointers.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire                       RegFileWrEn;
// The Wr enable for the FIFO

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg [19:0] RxFIFO[(`FIFODEPTH - 1):0];
// FIFO Memory
 
reg [15:0] ZEROS;
// The bits to be filled in with the ZEROs

reg [15:0] ONES;
// The bits to be filled in with the ONEs

reg [(`POINTERWIDTH -1):0] RdPtr;
// Write pointer

reg [(`POINTERWIDTH -1):0] NextRdPtr;
// D-input of RdPtr
 
reg [(`POINTERWIDTH -1):0] WrPtr;
// Write pointer

reg [(`POINTERWIDTH -1):0] NextWrPtr;
// D-input of WrPtr
 
reg        DelRxFWrSync;
// Delayed version of RxFWr - Receive FIFO Write enable signal. Used to 
// convert the level on the RxFWr signal to a one-PCLK wide pulse.
 
reg        Wrap;
// Store the condition when the write pointer has rolled over 
// (from '11111' to '00000') but the read pointer hasn't. The 'Wrap'
// signal is used in calculating the FIFOFillLevel

reg        NextWrap;
// D-input of Wrap

reg        RNE;
// Receive FIFO fill status indication (Receive FIFO not Empty)

reg        NextRNE;
// D-input of RNE

reg        RFF;
// Receive FIFO Full indication. Also used to prevent writes into the 
// FIFO when the FIFO is already full.

reg        NextRFF;
// D-input of RFF

wire       WrPtrIncValid;
// Valid Write pointer increment
 
wire       RdPtrIncValid;
// Valid Read Pointer Increment

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Initialization of the registers used in the module
// ---------------------------------------------------------------------
initial
begin
  ZEROS   <= 16'b0;
  ONES    <= 16'hFFFF;
end

// ---------------------------------------------------------------------
// Allow writes to the Receive FIFO only if the FIFO is not already full
// ---------------------------------------------------------------------
assign RegFileWrEn      = WrPtrIncValid;

// ---------------------------------------------------------------------
// Clocked process for flip-flops in this module.
// ---------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (PRESETn == 1'b0)
    begin
      WrPtr         <= 'b0;
      RdPtr         <= 'b0;
      Wrap          <= 1'b0;
      RNE           <= 1'b0;
      RFF           <= 1'b0;
      DelRxFWrSync  <= 1'b0;
    end
  else
    begin
      WrPtr        <= NextWrPtr;
      RdPtr        <= NextRdPtr;
      Wrap         <= NextWrap;
      RNE          <= NextRNE;
      RFF          <= NextRFF;
      DelRxFWrSync <= RxFWrSync;
    end
end // process p_Seq;

// ---------------------------------------------------------------------
// Increment the write pointer when there is a write to the FIFO from 
// the Receive logic. The increment should be avoided if the receive 
// FIFO is already full. If the FIFO is already full and there is a 
// simultaneous read and a write, the write should be allowed to 
// complete and the write pointer should be incremented.
// ---------------------------------------------------------------------
assign WrPtrIncValid    = ((RxFWrSync ^ DelRxFWrSync) && 
                         (!RFF | (RFF && RxFRdPtrInc)));

// ---------------------------------------------------------------------
// Increment the write pointer when the WrPtrIncValid signal is asserted
// ---------------------------------------------------------------------
always @(WrPtr or WrPtrIncValid)
begin : p_WrPtrComb
  if (WrPtrIncValid == 1'b1)
    NextWrPtr = WrPtr + 1'b1; 
  else
    NextWrPtr = WrPtr;
end // process p_WrPtrComb;

// ---------------------------------------------------------------------
// Increment the read pointer when the FIFO is not already empty and 
// when there is a read from the FIFO i.e. when the RxFRdPtrInc signal 
// from the APB interface, is asserted.
// ---------------------------------------------------------------------
assign RdPtrIncValid    = RxFRdPtrInc && RNE;

// ---------------------------------------------------------------------
// Increment the read pointer when the RdPtrIncValid signal is asserted
// ---------------------------------------------------------------------
always @(RdPtr or RdPtrIncValid)
begin : p_RdPtrComb
  if (RdPtrIncValid == 1'b1)
    NextRdPtr = RdPtr + 1;
  else
    NextRdPtr = RdPtr;
end // process p_RdPtrComb;

// ---------------------------------------------------------------------
// The 'Wrap' bit is used to keep track of the condition when the write
// pointer has wrapped around from '11111' to '00000', but the read
// pointer has not wrapped. This bit is used to calculate the value of
// RxFFillLevel. Toggle the 'Wrap' bit whenever the read pointer wraps
// around or the write pointer wraps around. When both the pointers wrap
// around simultaneously, the 'Wrap' bit should not toggle.
// ---------------------------------------------------------------------
always @(WrPtr or WrPtrIncValid or RdPtr or Wrap or RdPtrIncValid)
begin : p_WrapComb
  if (((WrPtr == ONES[(`POINTERWIDTH -1):0]) && (WrPtrIncValid == 1'b1))
        ^ ((RdPtr == ONES[(`POINTERWIDTH -1):0]) &&
           (RdPtrIncValid == 1'b1)))
    NextWrap = ! Wrap;
  else
    NextWrap = Wrap;
end // process p_WrapComb;

// ---------------------------------------------------------------------
// Use the RxFFillLevel (Receive FIFO Fill Level) signal to detect 
// whether the receive FIFO is not empty. If the FIFO is empty and there
// is a valid write detected, then the FIFO is no longer empty. If the 
// FIFO has one valid entry and there is a valid read detected, without 
// a simultaneous write, the Receive FIFO is empty.
// ---------------------------------------------------------------------
always @(RxFFillLevel or WrPtrIncValid or RdPtrIncValid or RNE)
begin : p_RNE
  if ((RxFFillLevel == ZEROS[`POINTERWIDTH:0]) &&
      (WrPtrIncValid == 1'b1))
    NextRNE = 1'b1;
  else if ((RxFFillLevel == {ZEROS[(`POINTERWIDTH - 1):0], 1'b1}) &&
           (RdPtrIncValid == 1'b1) && (WrPtrIncValid == 1'b0))
    NextRNE = 1'b0;
  else
    NextRNE = RNE;
end // process p_RNE;

// ---------------------------------------------------------------------
// RFF (Receive FIFO Full) generation. When the FIFO has seven entries 
// and there is another write without a simultaneous read, the FIFO 
// is said to be Full. When the FIFO is already full and there is a read
// from the FIFO without a simultaneous write, the FIFO is said to be 
// 'Not Full'
// ---------------------------------------------------------------------
always @(RxFFillLevel or RFF or WrPtrIncValid or RdPtrIncValid)
begin : p_RFF
  if ((RxFFillLevel == {1'b0,ONES[(`POINTERWIDTH - 1):0]}) &&
      (WrPtrIncValid == 1'b1) && (RdPtrIncValid == 1'b0))
    NextRFF = 1'b1;
  else if ((RxFFillLevel == {1'b1,ZEROS[(`POINTERWIDTH - 1):0]}) &&
           (RdPtrIncValid == 1'b1) && (WrPtrIncValid == 1'b0))
    NextRFF = 1'b0;
  else
    NextRFF = RFF;
end // process p_RFF;

// ---------------------------------------------------------------------
// Subtract the write pointer from the read pointer to calculate the 
// FIFO fill level. Use the Wrap bit to take into account the case when 
// the write pointer has wrapped without the read pointer having wrapped
// ---------------------------------------------------------------------
assign  RxFFillLevel    = ({Wrap, WrPtr} - {1'b0, RdPtr});

// ---------------------------------------------------------------------
// Register array write 
// ---------------------------------------------------------------------
always @(posedge PCLK)
begin : p_FifoWriteSeq
  if (RegFileWrEn == 1'b1)
    RxFIFO[WrPtr] <= RxFWrData;
end // process p_FifoWriteSeq;
 
// ---------------------------------------------------------------------
// Read Mux. The contents of the location pointed to by the current
// value of the read pointer RdPtr, is driven onto the read databus,
// RxFRdData.
// ---------------------------------------------------------------------
assign RxFRdData        = (RxFFillLevel != (ZEROS[`POINTERWIDTH : 0])) ?
                           RxFIFO[RdPtr] : 20'b0;

endmodule

// --=========================== End  ================================--
