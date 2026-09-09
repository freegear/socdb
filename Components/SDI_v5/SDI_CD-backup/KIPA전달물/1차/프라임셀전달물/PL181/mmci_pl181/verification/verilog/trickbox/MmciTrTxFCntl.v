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
// File Name              : MmciTrTxFCntl.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module controls accesses to the Transmit FIFO
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciTrTxFCntl (
// Inputs
                      PCLK,
                      PRESETn,
                      FifoClearSync,
                      MMCITBTXFWr,
                      TxFRdSync,
// Outputs
                      RegFileWrEn,
                      TxDataAvlbl,
                      TNF,
                      TFE,
                      TFHE,
                      WrPtr,
                      RdPtr
                     );

// Inputs
input        PCLK;          // APB bus clock
input        PRESETn;       // APB bus Reset
input        FifoClearSync; // FifoClear signal
input        MMCITBTXFWr;   // TX FIFO Write enable
input        TxFRdSync;     // TX FIFO Read Ptr Inc

// Outputs
output       RegFileWrEn;   // Reg file write enable
output       TxDataAvlbl;   // TX Data available
output       TNF;           // TX FIFO not full
output       TFE;           // TX FIFO empty
output       TFHE;          // TX FIFO half empty
output [4:0] WrPtr;         // Write pointer
output [4:0] RdPtr;         // Read pointer

// Inputs
wire       PCLK;            // APB bus clock
wire       PRESETn;         // APB bus Reset
wire       FifoClearSync;   // FifoClear signal
wire       MMCITBTXFWr;     // TX FIFO Write enable
wire       TxFRdSync;       // TX FIFO Read Ptr Inc

// Outputs
wire       RegFileWrEn;     // Reg file write enable
wire       TxDataAvlbl;     // TX Data available
wire       TNF;             // TX FIFO not full
wire       TFE;             // TX FIFO empty
wire       TFHE;            // TX FIFO half empty
wire [4:0] WrPtr;           // Write pointer
wire [4:0] RdPtr;           // Read pointer

// -----------------------------------------------------------------------------
//
//                                MmciTrTxFCntl
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//   The control logic for the Transmit FIFO uses two pointers, a write
// pointer and a read pointer.The pointers are 5 bits wide.The write ptr
// points to the place to which the next wr data will be written into.
// The read pointer points to the location whose contents are driven on
// the TxFRdData[15:0] Read data bus.
// Both the ptrs operate on PCLK so as not to miss any writes from the
// APB and to facilitate calculation of the FIFOfilllevel by finding the
// difference between the pointers.
// This module also contains logic to generate the TNF(Transmit FIFO Not
// Full), TFE (Transmit FIFO Empty) and TFHE (Transmit FIFO Half Empty)
// status signals.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [5:0] TxFFillLevel;
// FIFO Fill level indication

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

reg        DelRdPtrInc;
// Delayed version of TxFRdSync - FIFO read pointer increment signal.
// Used to convert the level on the TxFRdSync signal to a
// one-PCLK wide pulse

reg        Wrap;
// Store the condition when the write ptr has rolled over(from'11111' to
// '00000') but the read pointer hasn't. The 'Wrap'signal is used in
// calculating the FIFOFillLevel

reg        NextWrap;
// D-input of Wrap

reg        iTNF;
// FIFO fill status indication (Transmit FIFO not full)

reg        NextTNF;
// D-input of iTNF

reg        iTFHE;
// FIFO half empty status indication

reg        NextTFHE;
// D-input of iTFHE

reg        iTxDataAvlbl;
// FIFO Fill status indication (Transmit Data Available in FIFO)

reg        NextDatAvlbl;
// D-input of iTxDataAvlbl

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
// Connect local copies of signals to ports
// -----------------------------------------------------------------------------
assign WrPtr            = iWrPtr;
assign RdPtr            = iRdPtr;
assign TNF              = iTNF;
assign TFHE             = iTFHE;
assign TxDataAvlbl      = iTxDataAvlbl;

// -----------------------------------------------------------------------------
// Generate the TFE (Transmit FIFO Empty) signal by inverting the
// TxDataAvlbl signal. When the TxDataAvlbl signal is asserted, it
// implies that the transmit FIFO has atleast one byte of data and hence
// the FIFO is not empty (TFE to be de-asserted). When the TxDataAvlbl
// signal is not asserted, it implies that there is no data in the
// Transmit FIFO and hence the FIFO is empty (TFE to be asserted)
// -----------------------------------------------------------------------------
assign TFE              = ~(iTxDataAvlbl);

// -----------------------------------------------------------------------------
// Allow writes to the Tx FIFO only if the FIFO is not already full
// -----------------------------------------------------------------------------
assign RegFileWrEn      = WrPtrIncValid;

// -----------------------------------------------------------------------------
// Clocked process for flip-flops in this module
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (~PRESETn | FifoClearSync)
    begin
      iWrPtr           <= 5'b00000;
      iRdPtr           <= 5'b00000;
      Wrap             <= 1'b0;
      iTNF             <= 1'b1;
      iTFHE            <= 1'b0;
      iTxDataAvlbl     <= 1'b0;
      DelRdPtrInc      <= TxFRdSync;
    end
  else
    begin
      iWrPtr           <= NextWrPtr;
      iRdPtr           <= NextRdPtr;
      Wrap             <= NextWrap;
      iTNF             <= NextTNF;
      iTFHE            <= NextTFHE;
      iTxDataAvlbl     <= NextDatAvlbl;
      DelRdPtrInc      <= TxFRdSync;
    end
end // p_Seq

// -----------------------------------------------------------------------------
// Incr the write pointer when there is a wr to the FIFO from the APB.
// The incr should be avoided if the transmit FIFO is already full. If
// when the FIFO is full, there is a write and a simultaneous read, the
// write should be allowed.
// -----------------------------------------------------------------------------
assign WrPtrIncValid    = (~FifoClearSync) ? (MMCITBTXFWr & (iTNF |
                           ( ~(iTNF) & (TxFRdSync ^ DelRdPtrInc))))  :
                           1'b0;

// -----------------------------------------------------------------------------
// Increment the Write ptr when the WrPtrIncValid signal is asserted.
// -----------------------------------------------------------------------------
always @(iWrPtr or WrPtrIncValid)
begin : p_WrPtrComb
  if (WrPtrIncValid ==  1'b1)
     NextWrPtr        = (iWrPtr) + 1;
  else
     NextWrPtr        = iWrPtr;
end // p_WrPtrComb

// -----------------------------------------------------------------------------
// Incr the read ptr when the FIFO is not already empty and when there
// is a read from the FIFO i.e. a rising edge is detected on the
// TxFRdSync signal.
// -----------------------------------------------------------------------------
assign RdPtrIncValid    = (~FifoClearSync) ? (iTxDataAvlbl &
                           (TxFRdSync ^ DelRdPtrInc)) : 1'b0;

// -----------------------------------------------------------------------------
// Increment the read pointer when the RdPtrIncValid signal is asserted.
// -----------------------------------------------------------------------------
always @(iRdPtr or RdPtrIncValid)
begin : p_RdPtrComb
  if (RdPtrIncValid ==  1'b1)
    NextRdPtr        = (iRdPtr) + 1;
  else
    NextRdPtr        = iRdPtr;
end // p_RdPtrComb

// -----------------------------------------------------------------------------
// The 'Wrap' bit is used to keep track of the condition when the wr ptr
// has wrapped around from '111' to '000', but the rd ptr hasn't wrapped
// This bit is used to calculate the value of TxFFillLevel. Toggle the
// 'Wrap' bit whenever the read pointer wraps around or the write ptr
// wraps around. When both the pointers wrap around simultaneously, the
// 'Wrap' bit should not toggle.
// -----------------------------------------------------------------------------
always @(iWrPtr or iRdPtr or Wrap or WrPtrIncValid or RdPtrIncValid)
begin : p_WrapComb
  if (((iWrPtr ==  5'b11111) & (WrPtrIncValid ==  1'b1)) ^
      ((iRdPtr ==  5'b11111) & (RdPtrIncValid ==  1'b1)))
    NextWrap         =  ~(Wrap);
  else
    NextWrap         = Wrap;
end // p_WrapComb

// -----------------------------------------------------------------------------
// The iTNF (Transmit FIFO not Full) sig indicates the status of the Tx
// FIFO.When the FIFO is 1 less than full and there is another wr to the
// FIFO without a simultaneous read, the iTNF signal is cleared.
// When the FIFO is already full and there is a read from the FIFO,
// without a simultaneous write, the iTNF signal is set.
// -----------------------------------------------------------------------------
always @(TxFFillLevel or iTNF or WrPtrIncValid or RdPtrIncValid)
begin : p_TNF
  if ((TxFFillLevel ==  6'b011111) && (WrPtrIncValid ==  1'b1) &&
      (RdPtrIncValid ==  1'b0))
    NextTNF          = 1'b0;
  else if ((TxFFillLevel ==  6'b100000) && (RdPtrIncValid ==  1'b1) &&
           (WrPtrIncValid ==  1'b0))
    NextTNF          = 1'b1;
  else
    NextTNF          = iTNF;
end // p_TNF:
// [vhdl2vlog] The following line is NOT modified.

// -----------------------------------------------------------------------------
// Use the TxFFillLevel(Transmit FIFO Fill Level) sig to indicate that
// data is available for transmission. The result of the comparison is
// clocked out onto the TxDataAvlbl signal.
// -----------------------------------------------------------------------------
always @(TxFFillLevel or WrPtrIncValid or RdPtrIncValid or iTxDataAvlbl)
begin : p_DataAvlbl
  if ((TxFFillLevel ==  6'b000000) && (WrPtrIncValid ==  1'b1))
    NextDatAvlbl     = 1'b1;
  else if ((TxFFillLevel ==  6'b000001) && (RdPtrIncValid ==  1'b1) &&
           (WrPtrIncValid ==  1'b0))
    NextDatAvlbl     = 1'b0;
  else
    NextDatAvlbl     = iTxDataAvlbl;
end // p_DataAvlbl

// -----------------------------------------------------------------------------
// Use the TxFFillLevel (Transmit FIFO Fill Level) sig to indicate that
// data is available for transmission. The result of the comparison is
// clocked out onto the TFHE signal.
// -----------------------------------------------------------------------------
always @(TxFFillLevel or WrPtrIncValid or RdPtrIncValid or iTxDataAvlbl)
begin : p_TFHE
  if ((TxFFillLevel ==  6'b010000) && (RdPtrIncValid ==  1'b1))
    NextTFHE         = 1'b1;
  else if ((TxFFillLevel ==  6'b001111) && (WrPtrIncValid ==  1'b1) &&
           (RdPtrIncValid ==  1'b0))
    NextTFHE         = 1'b0;
  else
    NextTFHE         = iTFHE;
end // p_TFHE:

// -----------------------------------------------------------------------------
// Subtract the write ptr from the read ptr to calculate the FIFO fill
// level. Use the Wrap bit to take into account the case when the write
// pointer has wrapped without the read pointer having wrapped
// -----------------------------------------------------------------------------
assign TxFFillLevel     = (({Wrap, iWrPtr}) - ({1'b0, iRdPtr}));

endmodule
// --================================== End ==================================--
