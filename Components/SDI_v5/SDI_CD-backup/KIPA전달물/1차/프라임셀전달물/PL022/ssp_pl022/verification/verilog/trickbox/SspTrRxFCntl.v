// --=========================================================================--
//  This confidential  &&  proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies  &&  copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
//  Version  &&  Release Control Information:
//  
//  File Name              : SspTrRxFCntl.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
// Purpose      : This block controls accesses to the Receive FIFO.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspTrRxFCntl( 
                    PCLK,
                    PRESETn,
                    RxFWrSync,
                    SRxFWrSync,
                    RxFRdPtrInc,
                    RXW,     
                    RegFileWrEn,
                    RNE,    
                    RFF,   
                    RXWFLG,
                    WrPtr,
                    RdPtr
                   );

input        PCLK;         // APB bus clock
input        PRESETn;        // APB bus reset 
input        RxFWrSync;    // RX FIFO write enable
input        SRxFWrSync;   // RX FIFO write enable for Slave test
input        RxFRdPtrInc;  // RX FIFO read pointer incr.
input  [1:0] RXW;          // Rx Watermark level  
output       RegFileWrEn;  // Write enable to register file
output       RNE;          // RX FIFO not empty
output       RFF;          // RX FIFO full
output       RXWFLG;       // RX FIFO full
output [3:0] WrPtr;        // Write pointer
output [3:0] RdPtr;        // Read pointer

// -----------------------------------------------------------------------------
//
//                          SspTrRxFCntl
//                          ============
//
// -----------------------------------------------------------------------------
// Overview
// ========
//
//   The control logic for the Receive FIFO uses two pointers - a write pointer
//  &&  a read pointer. Since the FIFO has 16 locations, the pointers are 4 bits
// wide. The write pointer points to the location to which the next write data 
// will be written into. The read pointer points to the location whose contents
// are driven on the RxFRdData[15:0] Read data bus.
//   Both the pointers operate on PCLK so as to serve data consistently to the 
// APB  &&  to facilitate calculation of the FIFO fill level by finding the 
// difference between the pointers. 
//   This module also contains logic to generate the RNE (Receive FIFO Not 
// Empty) status signal, the RFF (Receive FIFO Full) status signal.
//
// -----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Wire Declarations
// ----------------------------------------------------------------------------
wire       PCLK;
// APB bus clock

wire       PRESETn;
// APB bus reset

wire       RxFWrSync;
 // RX FIFO write enable

wire       SRxFWrSync;
// RX FIFO write enable for Slave test

wire       RxFRdPtrInc;
// RX FIFO read pointer incr.

wire [1:0] RXW;
// Rx Watermark level

wire [4:0] RxFFillLevel;
// Receive FIFO Fill level indication

wire       WrPtrIncValid;
// Valid Write pointer increment
 
wire       RdPtrIncValid;
// Valid Read Pointer Increment

// -----------------------------------------------------------------------------
// Register Declarations
// -----------------------------------------------------------------------------
reg [3:0] iRdPtr;
// Read pointer

reg [3:0] NextRdPtr;
// D-input of iRdPtr
 
reg [3:0] iWrPtr      ;
// Write pointer

reg [3:0] NextWrPtr; 
// D-input of iWrPtr
 
reg       DelRxFWrSync;
// Delayed version of RxFWr - Receive FIFO Write enable signal. Used to 
// convert the level on the RxFWr signal to a one-PCLK wide pulse.
 
reg       Wrap; 
// Store; the condition when the write pointer has rolled over (from '1111' to 
// '0000') but the read pointer hasn't. The 'Wrap'signal is used in calculating
// the FIFOFillLevel

reg       NextWrap;
// D-input of Wrap

reg       iRXWFLG;
// Receive FIFO service request interrupt

reg       NextRXWFLG ;
// D-input of iSSPRXINTR

reg       iRNE;
// Receive FIFO fill status indication (Receive FIFO not Empty)

reg       NextRNE;
// D-input of iRNE

reg       iRFF;
// Receive FIFO Full indication. Also used to prevent writes into the FIFO 
// when the FIFO is already full.

reg       NextRFF;
// D-input of iRFF

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Connect local copies to output ports
// -----------------------------------------------------------------------------
assign WrPtr      = iWrPtr;
assign RdPtr      = iRdPtr;
assign RNE        = iRNE;
assign RFF        = iRFF;
assign RXWFLG     = iRXWFLG;

// -----------------------------------------------------------------------------
// Allow writes to the Receive FIFO only if the FIFO is not already full
// -----------------------------------------------------------------------------
assign RegFileWrEn = ((RxFWrSync | SRxFWrSync)  &&  ~DelRxFWrSync)  &&  ~iRFF;

// -----------------------------------------------------------------------------
// Clocked process for flip-flops in this module.
// -----------------------------------------------------------------------------
always @( posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (PRESETn == 1'b0) 
    begin
      iWrPtr       <= 4'b0000;
      iRdPtr       <= 4'b0000;
      Wrap         <= 4'b0000;
      iRNE         <= 1'b0;
      iRFF         <= 1'b0;
      iRXWFLG      <= 1'b0;
      DelRxFWrSync <= 1'b0;
    end 
  else 
    begin
      iWrPtr       <= NextWrPtr;
      iRdPtr       <= NextRdPtr;
      Wrap         <= NextWrap;
      iRNE         <= NextRNE;
      iRFF         <= NextRFF;
      iRXWFLG      <= NextRXWFLG;
      DelRxFWrSync <= RxFWrSync | SRxFWrSync;
    end
end   // p_Seq;

// -----------------------------------------------------------------------------
// Increment the write pointer when there is a write to the FIFO from the 
// Receive logic. The increment should be avoided if the receive FIFO is already
// full. If the FIFO is already full  &&  there is a simultaneous read  &&  a
// write, the write should be allowed to complete  &&  the write pointer should
// be incremented.
// -----------------------------------------------------------------------------
assign WrPtrIncValid = ((RxFWrSync | SRxFWrSync)  &&  ( !(DelRxFWrSync))  
                         &&  ( !(iRFF) || (iRFF  &&  RxFRdPtrInc)));

// -----------------------------------------------------------------------------
// Increment the write pointer when the WrPtrIncValid signal is asserted
// -----------------------------------------------------------------------------
always @(iWrPtr or WrPtrIncValid)
begin : p_WrPtrComb 
  if (WrPtrIncValid == 1'b1)
    NextWrPtr = iWrPtr + 1; 
  else
    NextWrPtr = iWrPtr;
end   // p_WrPtrComb;

// -----------------------------------------------------------------------------
// Increment the read pointer when the FIFO is not already empty  &&  when there
// is a read from the FIFO i.e. when the RxFRdPtrInc signal from the APB
// interface, is asserted.
// -----------------------------------------------------------------------------
assign RdPtrIncValid = (RxFRdPtrInc  &&  iRNE);

// -----------------------------------------------------------------------------
// Increment the read pointer when the RdPtrIncValid signal is asserted
// -----------------------------------------------------------------------------
always @(iRdPtr or RdPtrIncValid)
begin : p_RdPtrComb 
  if (RdPtrIncValid == 1'b1) 
    NextRdPtr = iRdPtr + 1;
  else
    NextRdPtr = iRdPtr;
end   // p_RdPtrComb;

// -----------------------------------------------------------------------------
// The 'Wrap' bit is used to keep track of the condition when the write pointer
// has wrapped around from '111' to '000', but the read pointer has not wrapped.
// This bit is used to calculate the value of RxFFillLevel. Toggle the 'Wrap'
// bit whenever the read pointer wraps around or the write pointer wraps
// around. When both the pointers wrap around simultaneously, the 'Wrap' bit
// should not toggle.
// -----------------------------------------------------------------------------
always @(iWrPtr or  WrPtrIncValid or  iRdPtr or Wrap or RdPtrIncValid)
begin : p_WrapComb 
  if (((iWrPtr == 4'b1111)  &&  (WrPtrIncValid == 1'b1)) ^ 
      ((iRdPtr == 4'b1111)  &&  (RdPtrIncValid == 1'b1))) 
    NextWrap =  !(Wrap);
  else
    NextWrap = Wrap;
end   // p_WrapComb;

// -----------------------------------------------------------------------------
// Use the RxFFillLevel (Receive FIFO Fill Level) signal to detect whether
// the receive FIFO is not empty. If the FIFO is empty  &&  there is a valid
// write detected, then the FIFO is no longer empty. If the FIFO has one valid
// entry  &&  there is a valid read detected, without a simultaneous write,
// the Receive FIFO is empty.
// -----------------------------------------------------------------------------
always @(RxFFillLevel or WrPtrIncValid or RdPtrIncValid or iRNE)
begin : p_RNE 
  if ((RxFFillLevel == 5'b00000)  &&  (WrPtrIncValid == 1'b1))
    NextRNE = 1'b1;
  else if ((RxFFillLevel == 5'b00001)  &&  (RdPtrIncValid == 1'b1)
           &&  (WrPtrIncValid == 1'b0)) 
    NextRNE = 1'b0;
  else
    NextRNE = iRNE;
end  // p_RNE;

// -----------------------------------------------------------------------------
// Assert the Receive FIFO waterlevel Flag, 
// if the FIFO contains two or more valid entries,when RXW =00,
// if the FIFO contains four or more valid entries,when RXW =01,
// if the FIFO contains six or more valid entries,when RXW =10,
// if the FIFO contains eight or more valid entries,when RXW =11,
// -----------------------------------------------------------------------------
always @(RXW or RxFFillLevel)
begin : p_RFW 
  if ((RXW == 2'b00)  &&  ((RxFFillLevel) >= 2)) 
    NextRXWFLG = 1'b1;
  else if ((RXW == 2'b01)  &&  ((RxFFillLevel) >= 4)) 
    NextRXWFLG = 1'b1;
  else if ((RXW == 2'b10)  &&  ((RxFFillLevel) >= 6))
    NextRXWFLG = 1'b1;
  else if ((RXW == 2'b11)  &&  ((RxFFillLevel) >= 8))
    NextRXWFLG = 1'b1;
  else
    NextRXWFLG = 1'b0;
end  // p_RFW;

// -----------------------------------------------------------------------------
// RFF (Receive FIFO Full) generation. When the FIFO has seven entries and
//  &&  there is another write without a simultaneous read, the FIFO is said to
// be Full. When the FIFO is already full  &&  there is a read from the FIFO
// without a simultaneous write, the FIFO is said to be 'Not Full'
// -----------------------------------------------------------------------------
always @(RxFFillLevel or iRFF or WrPtrIncValid or RdPtrIncValid)
begin : p_RFF 
  if ((RxFFillLevel == 5'b01111)  &&  (WrPtrIncValid == 1'b1) && 
      (RdPtrIncValid == 1'b0)) 
    NextRFF = 1'b1;
  else if ((RxFFillLevel == 5'b10000)  &&  (RdPtrIncValid == 1'b1) && 
           (WrPtrIncValid == 1'b0)) 
    NextRFF = 1'b0;
  else
    NextRFF = iRFF;
end  // p_RFF;

// -----------------------------------------------------------------------------
// Subtract the write pointer from the read pointer to calculate the FIFO fill 
// level. Use the Wrap bit to take into account the case when the write pointer
// has wrapped without the read pointer having wrapped
// -----------------------------------------------------------------------------
assign RxFFillLevel = ({Wrap, iWrPtr} - {1'b0, iRdPtr});

endmodule

// --============================= End =======================================--


