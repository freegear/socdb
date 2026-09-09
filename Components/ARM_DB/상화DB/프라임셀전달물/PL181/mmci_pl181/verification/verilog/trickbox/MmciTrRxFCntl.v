// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : MmciTrRxFCntl.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block controls accesses to the Receive FIFO.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciTrRxFCntl (
// Inputs
                     PCLK,
                     PRESETn,
                     FifoClearSync,
                     RxFWrSync,
                     RxFRdPtrInc,
// Outputs
                     RegFileWrEn,
                     RNE,
                     RFF,
                     RFHF,
                     WrPtr,
                     RdPtr
                     );

// Inputs
input        PCLK;          // APB bus clock
input        PRESETn;       // Bus reset
input        FifoClearSync; // Clear signal
input        RxFWrSync;     // RX FIFO write enable
input        RxFRdPtrInc;   // RX FIFO read ptr incr.

// Outputs
output       RegFileWrEn;   // Wr enable to reg file
output       RNE;           // RX FIFO not empty
output       RFF;           // RX FIFO full
output       RFHF;          // RX FIFO Half full
output [4:0] WrPtr;         // Write pointer
output [4:0] RdPtr;         // Read pointer

// Inputs
wire       PCLK;            // APB bus clock
wire       PRESETn;         // Bus reset
wire       FifoClearSync;   // Clear signal
wire       RxFWrSync;       // RX FIFO write enable
wire       RxFRdPtrInc;     // RX FIFO read ptr incr.

// Outputs
wire       RegFileWrEn;     // Wr enable to reg file
wire       RNE;             // RX FIFO not empty
wire       RFF;             // RX FIFO full
wire       RFHF;            // RX FIFO Half full
wire [4:0] WrPtr;           // Write pointer
wire [4:0] RdPtr;           // Read pointer

// -----------------------------------------------------------------------------
//
//                                MmciTrRxFCntl
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//   The control logic for the Receive FIFO uses two pointers - a write
// pointer and a read pointer. Since the FIFO has 32 locations, the
// pointers are 5 bits wide. The write pointer points to the location
// to which the next write data will be written into. The read pointer
// points to the location whose contents are driven on the
// RxFRdData[31:0] Read data bus.Both the pointers operate on PCLK so
// to serve data consistently to the APB and to facilitate calculation
// of the FIFO fill level by finding the difference between the
// pointers.
//   This module also contains logic to generate the RNE (Receive FIFO
// Not Empty) status signal, the RFF (Receive FIFO Full) status signal.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [5:0] RxFFillLevel;
// Receive FIFO Fill level indication

wire       WrPtrIncValid;
// Valid Write pointer increment

wire       RdPtrIncValid;
// Valid Read Pointer Increment

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [4:0] iRdPtr;
// Read pointer

reg  [4:0] NextRdPtr;
// D-input of iRdPtr

reg  [4:0] iWrPtr;
// Write pointer

reg  [4:0] NextWrPtr;
// D-input of iWrPtr

reg        DelRxFWrSync;
// Delayed version of RxFWr - Receive FIFO Write enable signal. Used to
// convert the level on the RxFWr signal to a one-PCLK wide pulse.

reg        Wrap;
// Store the condition when the write pointer has rolled over (from
// '11111' to '00000') but the read pointer hasn't. The 'Wrap' signal
// is used in calculating the FIFOFillLevel.

reg        NextWrap;
// D-input of Wrap

reg        iRNE;
// Receive FIFO fill status indication (Receive FIFO not Empty)

reg        NextRNE;
// D-input of iRNE

reg        iRFF;
// Receive FIFO Full indication. Also used to prevent writes into the
// FIFO when the FIFO is already full.

reg        NextRFF;
// D-input of iRFF

reg        iRFHF;
// Receive FIFO Half Full indication.

reg        NextRFHF;
// D-input of iRFHF

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
// Connect local copies to output ports
// -----------------------------------------------------------------------------
assign WrPtr            = iWrPtr;
assign RdPtr            = iRdPtr;
assign RNE              = iRNE;
assign RFF              = iRFF;
assign RFHF             = iRFHF;

// -----------------------------------------------------------------------------
// Allow writes to the Receive FIFO only if the FIFO is not already full
// -----------------------------------------------------------------------------
assign RegFileWrEn      = WrPtrIncValid;

// -----------------------------------------------------------------------------
// Clocked process for flip-flops in this module.
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (PRESETn ==  1'b0 | FifoClearSync ==  1'b1)
  begin
     iWrPtr           <= 5'b00000;
     iRdPtr           <= 5'b00000;
     Wrap             <= 1'b0;
     iRNE             <= 1'b0;
     iRFF             <= 1'b0;
     iRFHF            <= 1'b0;
     DelRxFWrSync     <= RxFWrSync;
  end
  else
  begin
     iWrPtr           <= NextWrPtr;
     iRdPtr           <= NextRdPtr;
     Wrap             <= NextWrap;
     iRNE             <= NextRNE;
     iRFF             <= NextRFF;
     iRFHF            <= NextRFHF;
     DelRxFWrSync     <= RxFWrSync;
  end
end // p_Seq

// -----------------------------------------------------------------------------
// Increment the write pointer when there is a write to the FIFO from
// the Receive logic. The increment should be avoided if the receive
// FIFO is already full. If the FIFO is already full and there is a
// simultaneous read and a write, the write should be allowed to
// complete and the write pointer should be incremented.
// -----------------------------------------------------------------------------
assign WrPtrIncValid    = (FifoClearSync == 1'b0) ? ((RxFWrSync ^
                           DelRxFWrSync) & ( ~(iRFF) | (iRFF &
                           RxFRdPtrInc))) : 1'b0;

// -----------------------------------------------------------------------------
// Increment the write pointer when the WrPtrIncValid signal is asserted
// -----------------------------------------------------------------------------
always @(iWrPtr or WrPtrIncValid)
begin : p_WrPtrComb
  if (WrPtrIncValid ==  1'b1)
     NextWrPtr        = (iWrPtr) + 1;
  else
     NextWrPtr        = iWrPtr;
end // p_WrPtrComb

// -----------------------------------------------------------------------------
// Increment the read pointer when the FIFO is not already empty and
// when there is a read from the FIFO i.e. when the RxFRdPtrInc signal
// from the APB interface, is asserted.
// -----------------------------------------------------------------------------
assign RdPtrIncValid    = (RxFRdPtrInc & iRNE);

// -----------------------------------------------------------------------------
// Increment the read pointer when the RdPtrIncValid signal is asserted
// -----------------------------------------------------------------------------
always @(iRdPtr or RdPtrIncValid)
begin : p_RdPtrComb
  if (RdPtrIncValid ==  1'b1)
     NextRdPtr        = (iRdPtr) + 1;
  else
     NextRdPtr        = iRdPtr;
end // p_RdPtrComb

// -----------------------------------------------------------------------------
// The 'Wrap' bit is used to keep track of the condition when the write
// pointer has wrapped around from '11111' to '00000', but the read
// pointer hasn't.This bit is used to calculate the value of
// RxFFillLevel. Toggle the 'Wrap' bit whenever the read pointer wraps
// around or the write pointer wraps around. When both the pointers wrap
// around simultaneously, the 'Wrap' bit should not toggle.
// -----------------------------------------------------------------------------
always @(iWrPtr or WrPtrIncValid or iRdPtr or Wrap or RdPtrIncValid)
begin : p_WrapComb
  if (((iWrPtr ==  5'b11111) & (WrPtrIncValid ==  1'b1)) ^
      ((iRdPtr ==  5'b11111) & (RdPtrIncValid ==  1'b1)))
     NextWrap         =  ~(Wrap);
  else
     NextWrap         = Wrap;
end // p_WrapComb

// -----------------------------------------------------------------------------
// Use the RxFFillLevel (Receive FIFO Fill Level) signal to detect
// whether the receive FIFO is not empty. If the FIFO is empty and
// there is a valid write detected, then the FIFO is no longer empty.
// If the FIFO has one valid entry and there is a valid read detected,
// without a simultaneous write, the Receive FIFO is empty.
// -----------------------------------------------------------------------------
always @(RxFFillLevel or WrPtrIncValid or RdPtrIncValid or iRNE)
begin : p_RNE
  if ((RxFFillLevel ==  6'b000000) & (WrPtrIncValid ==  1'b1))
     NextRNE          = 1'b1;
  else if ((RxFFillLevel ==  6'b000001) & (RdPtrIncValid ==  1'b1) &
           (WrPtrIncValid ==  1'b0))
     NextRNE          = 1'b0;
  else
     NextRNE          = iRNE;
end // p_RNE

// -----------------------------------------------------------------------------
// RFF (Receive FIFO Full) generation. When the FIFO has 31 entries and
// and there is another write without a simultaneous read, the FIFO is
// said to be Full. When the FIFO is already full and there is a read
// from the FIFO without a simultaneous write, the FIFO is said
// to be 'Not Full'
// -----------------------------------------------------------------------------
always @(RxFFillLevel or iRFF or WrPtrIncValid or RdPtrIncValid)
begin : p_RFF
  if ((RxFFillLevel ==  6'b011111) & (WrPtrIncValid ==  1'b1) &
      (RdPtrIncValid ==  1'b0))
     NextRFF          = 1'b1;
  else if ((RxFFillLevel ==  6'b100000) & (RdPtrIncValid ==  1'b1) &
           (WrPtrIncValid ==  1'b0))
     NextRFF          = 1'b0;
  else
     NextRFF          = iRFF;
end // p_RFF

// -----------------------------------------------------------------------------
// RFHF (Receive FIFO Half Full) generation. When the FIFO has 15
// entries and there is another write without a simultaneous read, the
// FIFO is said to be Half Full. When the FIFO is already Half full
// and there is a read from the without a simultaneous write, the FIFO
// is said to be 'Not Full'
// -----------------------------------------------------------------------------
always @(RxFFillLevel or iRFHF or WrPtrIncValid or RdPtrIncValid)
begin : p_RFHF
  if ((RxFFillLevel ==  6'b001111) & (WrPtrIncValid ==  1'b1) &
      (RdPtrIncValid ==  1'b0))
     NextRFHF         = 1'b1;
  else if ((RxFFillLevel ==  6'b010000) & (RdPtrIncValid ==  1'b1) &
           (WrPtrIncValid ==  1'b0))
     NextRFHF         = 1'b0;
  else
     NextRFHF         = iRFHF;
end // p_RFHF

// -----------------------------------------------------------------------------
// Subtract the write pointer from the read pointer to calculate the
// FIFO fill level. Use the Wrap bit to take into account the case
// when the write pointer has wrapped without the read pointer having
// wrapped
// -----------------------------------------------------------------------------
assign RxFFillLevel     = (({Wrap, iWrPtr}) - ({1'b0, iRdPtr}));

endmodule
// --================================== End ==================================--
