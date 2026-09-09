//============================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : UartTrTXFCntl.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
// ----------------------------------------------------------------------------
// Purpose     : This block contains the control logic for the transmit
//               FIFO
//============================================================================--

`timescale 1ns/1ps

//  ----------------------------------------------------------------------------
module UartTrTXFCntl (
// Inputs
                      PCLK,
                      PRESETn,
                      TXBUSY,
                      UARTDRWrEn,
                      TXFIFOData,
                      PWDATAIn,
                      TXFRdPtrInc,
                      FEN,
                      UARTEN,

// Outputs
                      TXDataAvlbl,
                      RdPtrIncDone,
                      RegFileWrEn,
                      WrPtr,
                      RdPtr,
                      TXShiftData,
                      TXFF,
                      TXFE,
                      TXFLTEHalfFull
                     );

// Inputs
input         PCLK;             // APB Clock
input         PRESETn;          // AMBA Reset
input         TXBUSY;           // Transmitter busy
input         UARTDRWrEn;       // TX FIFO Write enable
input   [7:0] TXFIFOData;       // To Shft Reg
input   [7:0] PWDATAIn;         // Data bus.
input         TXFRdPtrInc;      // TX FIFO Rd Ptr Inc
input         FEN;              // FIFO Enable
input         UARTEN;           // UART Enable

// Outputs
output        TXDataAvlbl;      // TX Data Available
output        RdPtrIncDone;     // Rd Ptr Inc done
output        RegFileWrEn;      // Register file write enable
output  [3:0] WrPtr;            // Write pointer
output  [3:0] RdPtr;            // Read pointer
output  [7:0] TXShiftData;      // Xmit Data
output        TXFF;             // Transmit FIFO Full
output        TXFE;             // Transmit FIFO Empty
output        TXFLTEHalfFull;   // Transmit FIFO Half-Empty  

// Inputs
wire          PCLK;             // APB Clock
wire          PRESETn;          // AMBA Reset
wire          TXBUSY;           // Transmitter busy
wire          UARTDRWrEn;       // TX FIFO Write enable
wire    [7:0] TXFIFOData;       // To Shft Reg
wire    [7:0] PWDATAIn;         // Data bus.
wire          TXFRdPtrInc;      // TX FIFO Rd Ptr Inc
wire          FEN;              // FIFO Enable
wire          UARTEN;           // UART Enable

// Outputs
wire          TXDataAvlbl;      // TX Data Available
wire          RdPtrIncDone;     // Rd Ptr Inc done
wire          RegFileWrEn;      // Register file write enable
reg     [3:0] WrPtr;            // Write pointer
reg     [3:0] RdPtr;            // Read pointer
reg     [7:0] TXShiftData;      // Xmit Data
wire          TXFF;             // Transmit FIFO Full
wire          TXFE;             // Transmit FIFO Empty
wire          TXFLTEHalfFull;   // Transmit FIFO Half-Empty  

//------------------------------------------------------------------------------
//
//                            UartTrTXFCntl
//                            =============
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//  The control logic for the transmit FIFO uses two pointers - a write pointer
// and a read pointer. The pointers are 4 bits wide. The write pointer points 
// to the location to which the next write data will be written into. The read 
// pointer points to the next location whose contents will be read out. Both 
// the pointers operate on PCLK so as to not miss any writes from the APB and 
// to conveniently calculate the FIFO fill level by finding the difference 
// between the pointers.
//  When the FIFO is disabled, the pointers do not change and the fill status 
// of the holding buffer is indicated by a separate bit 'HldBufValid'. 
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
reg     [3:0] NextRdPtr;
// D-input of Read pointer vector

wire          RdPtrIncValid;
// Valid Read pointer increment 

reg     [3:0] NextWrPtr;
// D-input of the write pointer vector

wire          WrPtrIncValid;
// Valid Write pointer increment 

reg           DelRdPtrIncStg1;
// Delayed version of TXFRdPtrIncSync - FIFO read pointer increment signal
// Used to convert the level on the TXFRdPtrIncSync signal to a one-clock
// wide pulse

reg           Wrap;
// Store the condition when the write pointer has rolled over (from
// '1111' to '0000') but the read pointer hasn't. This signal is
// used in calculating the FIFOFillLevel 

reg           NextWrap;
// D-input of Wrap bit

wire          TXFNotEmpty;
// Signal used to indicate whether any data is available in the FIFO
// when the FIFO is enabled

wire    [4:0] TXFFillLevel;
// FIFO Fill level indication

reg           HldBufValid;
// Fill status of the holding register. Used in the case when the
// FIFO is disabled

reg           NextHldBufValid;
// D-input of HldBufValid bit

reg     [7:0] NextTXShiftData;
// D-input of TXShiftData vector

reg           TXShiftRegEmpty;
// Fill status of the transmit Shift register
// NOTE : The assertion of this signal does not directly mean that the shift 
// register is empty. It only implies that the next write to the transmit 
// FIFO should fill up the shift register directly instead of accumulating 
// in the FIFO

reg           NxtTXShiftRegEmpty;
// D-input of TXShiftRegEmpty bit 

wire          NextUARTTXINTR;
// D-input of UARTTXINTR bit

reg           DelUARTEN;
// Delayed version of the UARTEN signal. Used to detect a rising edge on this
// signal

reg           FIFOFull;
// FIFO full status indication when the FIFO is enabled

reg           NextFIFOFull;
// D-input of FIFOFull bit

reg           FIFONotEmpty;
// FIFO empty status indication when the FIFO is enabled

reg           DelRdPtrIncStg2;
// Twice delayed Read Pointer Increment signal
 
reg           NextFIFONotEmpty;
// D-input of FIFONotEmpty bit

wire          LoadShiftReg;
// Shift register load trigger

reg           ShiftDataAvlbl;
// Shift register contains valid data that is currently being transmitted
 
reg           NextShftDatAvlbl;
// D-input of ShftDataAvlbl signal

wire          FIFOLTEHalfFull;
// FIFO FillLevel compare result

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Indicate the availability of data to transmit to  the transmit logic. Data 
// is said to be available if the FIFO contains valid data or if the Shift
// Register contains valid data. 
//------------------------------------------------------------------------------
assign TXDataAvlbl      = (TXFNotEmpty | ShiftDataAvlbl);

//------------------------------------------------------------------------------
// Ignore writes to FIFO if FIFO is already full. Use WrPtrIncValid signal 
// as the Write enable. The Write pointer increment operation occurs only if
// the FIFO is enabled, but the WrPtrIncValid signal is generated independent 
// of whether the FIFO is enabled or not.
//------------------------------------------------------------------------------
assign RegFileWrEn      = WrPtrIncValid;

//------------------------------------------------------------------------------
// Assert and De-assert Done signal the next clock after TXFRdPtrIncSync
// is seen
//------------------------------------------------------------------------------
assign RdPtrIncDone     = DelRdPtrIncStg1;

//------------------------------------------------------------------------------
// Sequential process for registers/flip-flops in this block
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_PtrsSeq
  if (PRESETn == 1'b0)
    begin
      WrPtr           <= 4'h0;
      RdPtr           <= 4'h0;
      DelRdPtrIncStg1 <= 1'b1;
      DelRdPtrIncStg2 <= 1'b1;
      Wrap            <= 1'b0;
      HldBufValid     <= 1'b0;
      TXShiftData     <= 8'h00;
      TXShiftRegEmpty <= 1'b1;
      DelUARTEN       <= 1'b0;
      FIFOFull        <= 1'b0;
      FIFONotEmpty    <= 1'b0;
      ShiftDataAvlbl  <= 1'b0;
    end
  else
    begin
        WrPtr           <= NextWrPtr;
        RdPtr           <= NextRdPtr;
        DelRdPtrIncStg1 <= DelRdPtrIncStg2;
        DelRdPtrIncStg2 <= TXFRdPtrInc;
        Wrap            <= NextWrap;
        HldBufValid     <= NextHldBufValid;
        TXShiftData     <= NextTXShiftData;
        TXShiftRegEmpty <= NxtTXShiftRegEmpty;
        DelUARTEN       <= UARTEN;
        FIFOFull        <= NextFIFOFull;
        FIFONotEmpty    <= NextFIFONotEmpty;
        ShiftDataAvlbl  <= NextShftDatAvlbl;
    end
end // p_PtrsSeq

//------------------------------------------------------------------------------
// Load the shift register with transmit data from the FIFO when either of the 
// following conditions occur:
// * The UART is just enabled, and there is no Abort condition
// * The Abort condition is just removed and the UART is already enabled
// * The Read pointer increment signal (TXFRdPtrInc) signal is just
//   asserted with the UART being enabled and there being no Abort condition.
//------------------------------------------------------------------------------
assign LoadShiftReg     = UARTEN & 
                          (!(DelUARTEN) | (DelRdPtrIncStg2 &
                          !(DelRdPtrIncStg1)));

//------------------------------------------------------------------------------
// Increment the write pointer when there is a write to the FIFO from the APB. 
// The increment should be avoided if the transmit FIFO is already full or if 
// the TXShiftRegEmpty signal is asserted indicating that the next write should
// go to the shift register directly. If TXShiftRegEmpty is not already 
// asserted and if it is about to be asserted on the next PCLK (as indicated
// by the assertion of LoadShiftReg with the FIFO being empty), then the write
// data is to be written into the Shift register and not into the FIFO. 
//------------------------------------------------------------------------------
assign WrPtrIncValid    = UARTDRWrEn & (!(TXShiftRegEmpty | (!(TXShiftRegEmpty)
                          & LoadShiftReg & !(TXFNotEmpty)))) &
                          (!(TXFF) | (TXFF & LoadShiftReg));

//------------------------------------------------------------------------------
// Freeze the Write pointer at zero when the FIFO is disabled. When the FIFO is
// enabled and when the WrPtrIncValid signal is asserted, increment the Write 
// pointer by 1.
//------------------------------------------------------------------------------
always @(WrPtr or WrPtrIncValid or FEN)
begin : p_WrPtrComb
  if (FEN == 1'b0)
    NextWrPtr <= 4'h0;
  else if (WrPtrIncValid == 1'b1)
    NextWrPtr <= ((WrPtr) + 1);
  else
    NextWrPtr <= WrPtr;
end // p_WrPtrComb

//------------------------------------------------------------------------------
// Increment the read pointer when the FIFO is not already empty and when the
// Shift register is loaded with the next transmit data byte.
//------------------------------------------------------------------------------
assign RdPtrIncValid    = TXFNotEmpty & LoadShiftReg;

//------------------------------------------------------------------------------
// Freeze the read pointer at zero when the FIFO is disabled. When the FIFO is 
// enabled and the RdPtrIncValid signal is asserted, increment the Read pointer
// by 1
//------------------------------------------------------------------------------
always @(RdPtr or FEN or RdPtrIncValid)     
begin : p_RdPtrComb
  if (FEN == 1'b0)
    NextRdPtr <= 4'h0;
  else if (RdPtrIncValid == 1'b1)
    NextRdPtr <= ((RdPtr) + 1);
  else
    NextRdPtr <= RdPtr;
end // p_RdPtrComb

//------------------------------------------------------------------------------
// The 'Wrap' bit is used to keep track of the condition when the
// write pointer has wrapped around from '1111' to '0000', but
// the read pointer has not wrapped. This bit is used to calculate
// the FIFOFillLevel. As with the pointers, 'Wrap' is kept
// cleared when the FIFO is disabled.
//------------------------------------------------------------------------------
always @(WrPtr or RdPtr or Wrap or FEN or RdPtrIncValid or WrPtrIncValid)
begin : p_WrapComb
  if (FEN == 1'b0)
    NextWrap <= 1'b0;
  else if (((WrPtr == 4'hF) && (WrPtrIncValid == 1'b1)) ^ 
         ((RdPtr == 4'hF) && (RdPtrIncValid == 1'b1)))
    NextWrap <= !(Wrap);
  else
    NextWrap <= Wrap;
end // p_WrapComb

//------------------------------------------------------------------------------
// The FIFOFull signal indicates the status of the FIFO when it is
// enabled. When the FIFO is one less than full and there is
// another write to the FIFO, the FIFOFull signal is set. When
// the FIFO is already full and there is a read from the FIFO,
// the FIFOFull signal is de-asserted
//------------------------------------------------------------------------------
always @(TXFFillLevel or FIFOFull or FEN or WrPtrIncValid or RdPtrIncValid)
begin : p_FIFOFull
  if (FEN == 1'b0)
    NextFIFOFull <= 1'b0;
  else if ((TXFFillLevel == 5'b01111) && (WrPtrIncValid == 1'b1) &&
          (RdPtrIncValid == 1'b0))
    NextFIFOFull <= 1'b1;
  else if ((FIFOFull == 1'b1) && (RdPtrIncValid == 1'b1) && 
         (WrPtrIncValid == 1'b0))
    NextFIFOFull <= 1'b0;
  else
    NextFIFOFull <= FIFOFull;
end // p_FIFOFull

//------------------------------------------------------------------------------
// The FIFONotEmpty signal indicates the status of the FIFO when it is
// enabled. If the FIFO is empty and there is a write to the FIFO,
// the FIFONotEmpty signal is asserted. If one location in the FIFO
// is filled and there is a read from the FIFO, the FIFOEmpty
// signal is asserted.
//------------------------------------------------------------------------------
always @(TXFFillLevel or FIFONotEmpty or FEN or WrPtrIncValid or RdPtrIncValid)
begin : p_FIFONotEmpty
  if (FEN == 0)
    NextFIFONotEmpty <= 1'b0;
  else if ((FIFONotEmpty == 1'b0) && (WrPtrIncValid == 1'b1))
    NextFIFONotEmpty <= 1'b1;
  else if ((TXFFillLevel == 5'b00001) && (RdPtrIncValid == 1'b1) &&
         (WrPtrIncValid == 1'b0))
    NextFIFONotEmpty <= 1'b0;
  else
    NextFIFONotEmpty <= FIFONotEmpty;
end // p_FIFONotEmpty

//------------------------------------------------------------------------------
// When the FIFO is disabled, have a single bit to indicate fill status
// while the pointers are frozen at zero. The HldBufValid signal has a reset 
// value of 0, toggles to 1 when there is a write and back to zero when there
// is a read. The write and read requests can occur simultaneously. The two
// cases to be considered are when HldBufValid is 1 and when it is 0. When a 
// write and read occur simultaneously with a byte already in the holding 
// buffer (HldBufValid = 1), the write is allowed and HldBufValid remains set
// (untoggled). When HldBufValid is 0 (holding buffer empty), a read cannot 
// occur because reads are from the Transmit section which reads data from the 
// buffer only if valid data is available.
//------------------------------------------------------------------------------
always @(FEN or RdPtrIncValid or WrPtrIncValid or HldBufValid)
begin : p_BufValid
  if (FEN == 1'b1)
    NextHldBufValid <= 1'b0;
  else if ((WrPtrIncValid == 1'b1) ^ (RdPtrIncValid == 1'b1))
    NextHldBufValid <= !(HldBufValid);
  else
    NextHldBufValid <= HldBufValid;
end // p_BufValid

//------------------------------------------------------------------------------
// Fill status of the transmit Shift register
// NOTE : The assertion of this signal does not directly mean that
// the shift register is empty. It only implies that the next write
// to the transmit FIFO should fill up the shift register directly,
// instead of accumulating in the FIFO
//------------------------------------------------------------------------------
always @(UARTEN or TXShiftRegEmpty or UARTDRWrEn or
         LoadShiftReg or TXFNotEmpty)
begin : p_ShiftRegEmpty
//------------------------------------------------------------------------------
// If the UART is disabled, then writes should accumulate in the FIFO
// without updating the transmit shift register
//------------------------------------------------------------------------------
  if ((UARTEN == 1'b0))
    NxtTXShiftRegEmpty <= 1'b0;
//------------------------------------------------------------------------------
// If the FIFO is already empty and the shift register has to be loaded with
// transmit data and there is no write occuring to the FIFO, the 
// TXShiftRegEmpty signal is set.
//------------------------------------------------------------------------------
  else if ((LoadShiftReg == 1'b1) && (TXFNotEmpty == 1'b0) &&
         (UARTDRWrEn == 1'b0))
    NxtTXShiftRegEmpty <= 1'b1;
//------------------------------------------------------------------------------
// Else, if there is a write to the FIFO, the shift register is no 
// longer empty
//------------------------------------------------------------------------------
  else if (UARTDRWrEn == 1'b1)
    NxtTXShiftRegEmpty <= 1'b0;
  else 
    NxtTXShiftRegEmpty <= TXShiftRegEmpty;
end // p_ShiftRegEmpty

//------------------------------------------------------------------------------
// The TXShiftData register holds the transmit data byte.
//------------------------------------------------------------------------------
always @(TXShiftData or TXFIFOData or UARTDRWrEn or TXShiftRegEmpty or
         PWDATAIn or TXFNotEmpty or LoadShiftReg)
begin : p_TXShiftData
//------------------------------------------------------------------------------
// If the FIFO and the shift register are empty, then on the next write,
// move the write data straight into the shift register.
// If the TXShiftRegEmpty signal is already set or if the Shift register has to
// be loaded with the next transmit byte with the transmit FIFO being empty,
// and, if there is a write to the FIFO at the same time, the write data bus
// contents are copied directly into the Shift register. 
//------------------------------------------------------------------------------
    if ((UARTDRWrEn == 1'b1) && ((TXShiftRegEmpty == 1'b1) ||
        ((TXFNotEmpty == 1'b0) && (LoadShiftReg == 1'b1))))
      NextTXShiftData <= PWDATAIn;
//------------------------------------------------------------------------------
// If the Shift register has to be loaded with the next transmit data byte and
// the FIFO is not empty, then load the data in the FIFO pointed to by the
// current value of the read pointer, into the shift register. 
//------------------------------------------------------------------------------
    else if ((LoadShiftReg == 1'b1) && (TXFNotEmpty == 1'b1))
      NextTXShiftData <= TXFIFOData;
    else
      NextTXShiftData <= TXShiftData;
end // p_TXShiftData

//------------------------------------------------------------------------------
// The ShiftDataAvlbl signal indicates whether there is valid data present in 
// the Transmit shift register. This signal is used to generate the TXDataAvlbl
// output signal.
//------------------------------------------------------------------------------
always @(ShiftDataAvlbl or LoadShiftReg or TXFNotEmpty or
         UARTDRWrEn or TXShiftRegEmpty or UARTEN)
begin : p_ShiftDataAvlbl
  if ((UARTEN == 1'b0) || ((LoadShiftReg == 1'b1) &&
      (TXFNotEmpty == 1'b0) && (UARTDRWrEn == 1'b0)))
    NextShftDatAvlbl <= 1'b0;
  else if (((LoadShiftReg == 1'b1) && (TXFNotEmpty == 1'b1)) ||
          ((LoadShiftReg == 1'b1) && (TXFNotEmpty == 1'b0) &&
          (UARTDRWrEn == 1'b1)) || ((TXShiftRegEmpty == 1'b1) &&
          (UARTDRWrEn == 1'b1)))
    NextShftDatAvlbl <= 1'b1;
  else
    NextShftDatAvlbl <= ShiftDataAvlbl;
end // p_ShiftDataAvlbl

//------------------------------------------------------------------------------
// Subtract the read pointer from the write pointer to calculate
// the FIFO fill level. Use the Wrap bit to take into account
// whether the write pointer has wrapped without the read pointer
// not having wrapped
//------------------------------------------------------------------------------
assign TXFFillLevel     = (({Wrap, WrPtr}) - ({1'b0, RdPtr}));
//------------------------------------------------------------------------------
// When the FIFO is enabled, use the FIFOFull signal to indicate
// FIFO fill status. When the FIFO is disabled, use the
// HldBufValid signal to indicate FIFO fill status.
//------------------------------------------------------------------------------
assign TXFF             = (FEN == 1'b1) ? FIFOFull : HldBufValid;
//------------------------------------------------------------------------------
// When the FIFO is enabled, use the FIFONotEmpty signal to indicate
// FIFO fill status. When the FIFO is disabled, use the
// HldBufValid signal to indicate FIFO fill status.
//------------------------------------------------------------------------------
assign TXFNotEmpty      = (FEN == 1'b1) ? FIFONotEmpty : HldBufValid; 

assign TXFE             = !(TXFNotEmpty);
//------------------------------------------------------------------------------
// When the FIFO is enabled, use the TXFFillLevel signal to
// find whether the FIFO is less than or equal to half full. If the
// FIFO is disabled, the HldBufValid signal will do the job.
//------------------------------------------------------------------------------
assign FIFOLTEHalfFull  = ((TXFFillLevel) <= 8) ? 1'b1 : 1'b0;

assign TXFLTEHalfFull   = (FEN == 1'b1) ? FIFOLTEHalfFull : !(HldBufValid);

endmodule

//========================== End of UartTrTXFCntl ============================--
