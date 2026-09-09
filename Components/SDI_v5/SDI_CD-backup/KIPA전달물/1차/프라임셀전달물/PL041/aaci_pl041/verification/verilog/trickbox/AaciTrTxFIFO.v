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
// File Name              : AaciTrTxFIFO.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           This block contains the control logic for transmit FIFO and
//           the transmit FIFO array.
//
// --=================================================================--

`timescale 1ns/1ps

`include   "AaciTrPackage.v"

// ---------------------------------------------------------------------

module AaciTrTxFIFO (
// Inputs
                     // APB signals
                     PCLK,
                     PRESETn,
                     AACITrTDRWr,
                     TxFRdPtrIncSync,
                     PWDataIn,
// Outputs
                     TxFRdDataIn,
                     TxFFillLevel
                    );

// Inputs
input                    PCLK;             // APB clock
input                    PRESETn;          // APB reset
input                    AACITrTDRWr;      // Tx FIFO write enable
input                    TxFRdPtrIncSync;  // TX FIFO read ptr incr.
// Outputs
input             [19:0] PWDataIn;         // Internal PWDATA
output            [19:0] TxFRdDataIn;      // Tx FIFO Rddata
output [`POINTERWIDTH:0] TxFFillLevel;     // Tx FIFO fill level

// Inputs
wire                     PCLK;             // APB clock
wire                     PRESETn;          // APB reset 
wire                     AACITrTDRWr;      // Tx FIFO write enable
wire                     TxFRdPtrIncSync;  // TX FIFO read ptr incr.
wire              [19:0] PWDataIn;         // Internal PWDATA
// Outputs
wire              [19:0] TxFRdDataIn;      // Tx FIFO Rddata
wire   [`POINTERWIDTH:0] TxFFillLevel;     // Tx FIFO fill level

// ---------------------------------------------------------------------
//  
//                           AaciTrTxFIFO
//                           ============
//  
// ---------------------------------------------------------------------
//  
// Overview
// ========
//  
//  The AaciTrTxFIFO block instantiates the AaciTrTxRegFile block, and 
// the AaciTrTxFCntl block.
//  The AaciTrTxRegFile block contains the Transmit FIFO register file.
// Data on the PWDataIn bus is written into the location in the Receive
// FIFO pointed to by the current value of the WrPtr[4:0] (Write 
// pointer) signal on the rising edge of PCLK on which the RegFileWrEn 
// signal is sampled high. Data in the FIFO location pointed to by the 
// RdPtr[4:0] signal is always driven on the TxFRdData[19:0] output. 
//  The AaciTrTxFCntl block controls the Read pointer and the Write 
// pointer. Thus, the Transmit FIFO is implemented as a circular buffer.
// ---------------------------------------------------------------------
 
// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        WrPtrIncValid;    // Valid Write pointer increment
wire        RdPtrIncValid;    // Valid Read Pointer Increment
wire        RegFileWrEn;      // Valid Read Pointer Increment

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg  [19:0] TxFIFO[(`FIFODEPTH - 1):0];
// FIFO Memory
 
reg  [15:0] ZEROS;
// The bits to be filled in with the ZEROs
 
reg  [15:0] ONES;
// The bits to be filled in with the ONEs

reg  [(`POINTERWIDTH -1):0] RdPtr;
// Write pointer
 
reg  [(`POINTERWIDTH -1):0] NextRdPtr;
// D-input of RdPtr
 
reg  [(`POINTERWIDTH -1):0] WrPtr;
// Write pointer
 
reg  [(`POINTERWIDTH -1):0] NextWrPtr;
// D-input of WrPtr

reg         DelRdPtrInc;
// Delayed version of TxFRdPtrIncSync read pointer increment signal.
// Used to convert the level on the TxFRdPtrIncSync signal to a one-PCLK
// wide pulse

reg         Wrap;
// Store the condition when the write pointer has rolled over 
// (from '11111' to '00000') but the read pointer hasn't. The 'Wrap'
// signal is used in calculating the FIFOFillLevel

reg         NextWrap;
// D-input of Wrap

reg         TNF;
// Transmit FIFO not full

reg         NextTNF;
// D-input of TNF

reg         iTxDataAvlbl;
// Transmit Data Available in FIFO

reg         NextDatAvlbl;
// D-input of iTxDataAvlbl

reg         TXWFLG;
// Transmit FIFO water mark flag

reg         NextTXWFLG;
// input of TXWFLG 

// -------------------------------------------------------------------
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
// Allow writes to the Transmit FIFO only if the FIFO is not full
// ---------------------------------------------------------------------
assign RegFileWrEn      = WrPtrIncValid;

// ---------------------------------------------------------------------
// Clocked process for flip-flops in this module
// ---------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (PRESETn == 1'b0)
    begin
      WrPtr        <= 'b0;
      RdPtr        <= 'b0;
      Wrap         <= 1'b0;
      TNF          <= 1'b1;
      iTxDataAvlbl <= 1'b0;
      DelRdPtrInc  <= 1'b0;
    end
  else
    begin
      WrPtr        <= NextWrPtr;
      RdPtr        <= NextRdPtr;
      Wrap         <= NextWrap;
      TNF          <= NextTNF;
      iTxDataAvlbl <= NextDatAvlbl;
      DelRdPtrInc  <= TxFRdPtrIncSync;
    end
end // process p_Seq;

// ---------------------------------------------------------------------
// Increment the write pointer when there is a write to the FIFO from 
// the APB. The increment should be avoided if the transmit FIFO is 
// already full. If when the FIFO is full, there is a write and a 
// simultaneous read, the write should be allowed.
// ---------------------------------------------------------------------
assign WrPtrIncValid    = (AACITrTDRWr && (TNF | (!TNF && 
                          (TxFRdPtrIncSync ^ DelRdPtrInc))));
 
// ---------------------------------------------------------------------
// Increment the Write pointer when the WrPtrIncValid sig is asserted.
// ---------------------------------------------------------------------
always @(WrPtr or WrPtrIncValid)
begin : p_WrPtrComb
  if (WrPtrIncValid == 1'b1)
    NextWrPtr = WrPtr + 1;
  else
    NextWrPtr = WrPtr;
end // process p_WrPtrComb;
 
// ---------------------------------------------------------------------
// Increment the read pointer when the FIFO is not already empty and 
// when there is a read from the FIFO i.e. a rising edge is detected on
// the TxFRdPtrIncSync signal.
// ---------------------------------------------------------------------
assign RdPtrIncValid    = (iTxDataAvlbl && (TxFRdPtrIncSync ^ 
                                            DelRdPtrInc));
 
// ---------------------------------------------------------------------
// Increment the read pointer when the RdPtrIncValid signal is asserted.
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
// TxFFillLevel. Toggle the 'Wrap' bit whenever the read pointer wraps
// around or the write pointer wraps around. When both the pointers wrap
// around simultaneously, the 'Wrap' bit should not toggle.
// ---------------------------------------------------------------------
always @(WrPtr or RdPtr or Wrap or WrPtrIncValid or RdPtrIncValid)
begin : p_WrapComb
  if (((WrPtr == ONES[(`POINTERWIDTH -1):0]) && (WrPtrIncValid == 1'b1))
                       ^ ((RdPtr == ONES[(`POINTERWIDTH -1):0])
                          && (RdPtrIncValid == 1'b1)))
    NextWrap = !(Wrap);
  else
    NextWrap = Wrap;
end // process p_WrapComb;

// ---------------------------------------------------------------------
// The TNF (Transmit FIFO not Full) signal indicates the status of the
// Transmit FIFO. When the FIFO is one less than full and there is 
// another write to the FIFO without a simultaneous read, the TNF 
// signal is cleared. When the FIFO is already full and there is a read
// from the FIFO, without a simultaneous write, the TNF signal is set.
// ---------------------------------------------------------------------
always @(TxFFillLevel or TNF or WrPtrIncValid or RdPtrIncValid)
begin : p_TNF
  if ((TxFFillLevel == {1'b0,ONES[(`POINTERWIDTH - 1):0]}) &&
      (WrPtrIncValid == 1'b1) && (RdPtrIncValid == 1'b0))
    NextTNF = 1'b0;
  else if ((TxFFillLevel == {1'b1,ZEROS[(`POINTERWIDTH - 1):0]}) &&
           (RdPtrIncValid == 1'b1) && (WrPtrIncValid == 1'b0))
    NextTNF = 1'b1;
  else
    NextTNF = TNF;
end // process p_TNF;
 
// ---------------------------------------------------------------------
// Use the TxFFillLevel (Transmit FIFO Fill Level) signal to indicate 
// that data is available for transmission. The result of the comparison
// is clocked out onto the TxDataAvlbl signal.
// ---------------------------------------------------------------------
always @(TxFFillLevel or WrPtrIncValid or RdPtrIncValid or iTxDataAvlbl)
begin : p_DataAvlbl
  if ((TxFFillLevel == ZEROS[`POINTERWIDTH:0]) &&
     (WrPtrIncValid == 1'b1))
    NextDatAvlbl = 1'b1;
  else if ((TxFFillLevel == {ZEROS[(`POINTERWIDTH - 1):0], 1'b1}) &&
           (RdPtrIncValid == 1'b1) && (WrPtrIncValid == 1'b0))
    NextDatAvlbl = 1'b0;
  else
    NextDatAvlbl = iTxDataAvlbl;
end // process p_DataAvlbl;

// ---------------------------------------------------------------------
// Subtract the write pointer from the read pointer to calculate the 
// FIFO fill level. Use the Wrap bit to take into account the case when
// the write pointer has wrapped without the read pointer having wrapped
// ---------------------------------------------------------------------
assign TxFFillLevel     = {Wrap, WrPtr} - {1'b0, RdPtr};

// ---------------------------------------------------------------------
// Register array write
// ---------------------------------------------------------------------
always @(posedge PCLK)
begin : p_FifoWriteSeq
  if (RegFileWrEn == 1'b1)
    TxFIFO[WrPtr] <= PWDataIn;
end // process p_FifoWriteSeq;
 
// ---------------------------------------------------------------------
// Read Mux. The contents of the location pointed to by the current
// value of the read pointer RdPtr, is driven onto the read databus,
// TxFRdDataIn.
// ---------------------------------------------------------------------
assign TxFRdDataIn      = (TxFFillLevel != (ZEROS[`POINTERWIDTH : 0])) ?
                    TxFIFO[RdPtr] : 20'b0;

endmodule

// --=========================== End =================================--
