//============================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : UartTrRXFCntl.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
//------------------------------------------------------------------------------
// Purpose     : This block contains the control logic for the receive
//               FIFO
//============================================================================--
 
`timescale 1ns/1ps

//------------------------------------------------------------------------------

module UartTrRXFCntl (
// Inputs
                      PCLK,
                      PRESETn,
                      RXFWr,
                      UTCR,
                      IrdaRXFWr,
                      RXFRdPtrInc,
                      FEN,

// Outputs
                      RegFileWrEn,
                      RXFWrDone,
                      WrPtr,
                      RdPtr,
                      RXFE,
                      RXHF,
                      RXFF
                     );

// Inputs
input         PCLK;             // APB Clock
input         PRESETn;          // AMBA Reset 
input         RXFWr;            // RX FIFO Write Enable
input   [1:0] UTCR;             // Trickbox Control Reg
input         IrdaRXFWr;        // Irda RX FIFO Write Enable
input         RXFRdPtrInc;      // RX FIFO Read Pointer Incr.
input         FEN;              // FIFO Enable

// Outputs
output        RegFileWrEn;      // Write Enable to Register File
output        RXFWrDone;        // RX FIFO Write Done
output  [3:0] WrPtr;            // Write Pointer
output  [3:0] RdPtr;            // Read Pointer
output        RXFE;             // Receive FIFO Empty
output        RXHF;             // RX FIFO more than half full
output        RXFF;             // Receive FIFO Full

// Inputs
wire          PCLK;             // APB Clock
wire          PRESETn;          // AMBA Reset 
wire          RXFWr;            // RX FIFO Write Enable
wire    [1:0] UTCR;             // Trickbox Control Reg
wire          IrdaRXFWr;        // Irda RX FIFO Write Enable
wire          RXFRdPtrInc;      // RX FIFO Read Pointer Incr.
wire          FEN;              // FIFO Enable

// Outputs
wire          RegFileWrEn;      // Write Enable to Register File
wire          RXFWrDone;        // RX FIFO Write Done
reg     [3:0] WrPtr;            // Write Pointer
reg     [3:0] RdPtr;            // Read Pointer
wire          RXFE;             // Receive FIFO Empty
wire          RXHF;             // RX FIFO more than half full
wire          RXFF;             // Receive FIFO Full

//------------------------------------------------------------------------------
//
//                              UartTrRXFCntl
//                              =============
//                                                      
//------------------------------------------------------------------------------
//
// Overview
// ========
//  The control logic for the receive FIFO uses two pointers - a write pointer 
// and a read pointer. The pointers are 4 bits wide. The write pointer points 
// to the location to which the next write data will be written into. The read 
// pointer points to the next location whose contents will be read out. Both 
// the pointers operate on PCLK so as to serve data consistently to APB 
// accesses and to conveniently calculate the FIFO fill level by finding the 
// difference between the pointers.
//  When the FIFO is disabled, the pointers do not change and the fill status 
// of the holding buffer is indicated by a separate bit 'HldBufValid'. 
//  The overrun condition is met when the receive logic attempts to write into 
// the FIFO  when the FIFO is already full (if the FIFO is enabled) or if the 
// holding buffer is already full (if the FIFO is disabled). Once the overrun 
// condition is met, further writes to the FIFO are ignored.
//  When the UARTECRWrEn input is set, the overrun condition is cleared. 
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Component declarations
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
reg     [3:0] NextRdPtr;
// D-input for Read pointer vector

// signal NextRXFWrSync;
// Combinational input for RXFWrSync

wire          RdPtrIncValid;
// Valid Read Pointer Increment condition detected

reg     [3:0] NextWrPtr;
// D-input for Write pointer vector

wire          WrPtrIncValid;
// Valid Write Pointer Increment condition detected

wire          NextDelRXFWrSync;

reg           Wrap;
// Store the condition when the write pointer has rolled over (from
// '1111' to '0000') but the read pointer hasn't. This signal is
// used in calculating the FIFOFillLevel 

reg           NextWrap;
// D-input of Wrap bit

reg           DelRXFF;
// Delayed version of RXFF 

wire          RXFGTEHalfFull;
// Receive FIFO Greater Than or Equal to Half Full

reg           DelRXFWrSync;
// Delayed version of RXFWrSync - FIFO write enable signal
// Used to convert the level on the RXFWrEn signal to a one-clock wide pulse

wire    [4:0] RXFFillLevel;
// Receive FIFO Fill level - can take values from 00000 to 10000

reg           HldBufValid;
// Fill status of the receive holding buffer when the FIFO is disabled

reg           NextHldBufValid;
// D-input of HldBufValid bit

reg           FIFOFull;
// Receive FIFO Full when the FIFO is enabled

reg           NextFIFOFull;
// D-input of FIFOFull bit

reg           FIFOEmpty;
// Receive FIFO empty when the FIFO is enabled

reg           NextFIFOEmpty;
// D-input of FIFOEmpty bit

wire          FIFOGTEHalfFull;
// FIFO Fill level compare result

reg           RXFWrSync;
// Multiplexed Uart and Irda RXFWr input

//------------------------------------------------------------------------------
// 
// Main VHDL code
// ==============
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Generate a one-PCLK wide write enable pulse for the Register File on every
// rising edge on the RXFWrSync signal. Mask writes to the Register File if FIFO
// is full
//------------------------------------------------------------------------------
assign RegFileWrEn      = (RXFWrSync & !(DelRXFWrSync) & !(DelRXFF));

//------------------------------------------------------------------------------
// Assert and De-assert RXFWrDone signal the next clock after RXFRdPtrInc
// is asserted or de-asserted.
//------------------------------------------------------------------------------
assign RXFWrDone        = DelRXFWrSync;

//------------------------------------------------------------------------------
// Sequential process to infer registers in this block
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_PtrsSeq
  if (PRESETn == 1'b0)
    begin
      WrPtr        <= 4'h0;
      RdPtr        <= 4'h0;
      Wrap         <= 1'b0;
      HldBufValid  <= 1'b0;
      DelRXFWrSync <= 1'b0;
//       NextRXFWrSync <= 1'b0;
      FIFOFull     <= 1'b0;
      FIFOEmpty    <= 1'b1;
      DelRXFF <= 1'b0; 
    end
  else
    begin
      WrPtr         <= NextWrPtr;
      RdPtr         <= NextRdPtr;
      Wrap          <= NextWrap;
      HldBufValid   <= NextHldBufValid;
//       DelRXFWrSync  <= NextRXFWrSync;
      DelRXFWrSync  <= RXFWrSync;
//       NextRXFWrSync <= RXFWrSync;
      DelRXFF       <= RXFF;
      FIFOFull      <= NextFIFOFull;
      FIFOEmpty     <= NextFIFOEmpty;
    end
end // p_PtrsSeq

//------------------------------------------------------------------------------
// Combinational process to multiplex RX FIFO Frame Write signals  
//------------------------------------------------------------------------------
always @(UTCR or IrdaRXFWr or RXFWr)
begin : p_modeComb
 
  if(UTCR[0] == 1'b1)
    if(UTCR[1] == 1'b1)
      RXFWrSync <= IrdaRXFWr;
    else
      RXFWrSync <= RXFWr;
end // p_modeComb

//------------------------------------------------------------------------------
// Increment the write pointer when there is a rising edge on RXFWrSync (FIFO 
// write enable) signal. Don't allow write pointer to increment if the FIFO is 
// already Full.
// If the FIFO is full and there is a simultaneous write and read, the write 
// pointer should be incremented.
//------------------------------------------------------------------------------
assign WrPtrIncValid    = RXFWrSync & !(DelRXFWrSync) & 
                          (!(FIFOFull) | (FIFOFull & RXFRdPtrInc));

//------------------------------------------------------------------------------
// Freeze the Write pointer at Zero when the FIFO is disabled. When the FIFO is
// enabled and when the WrPtrIncValid signal is asserted, increment the Write
// pointer by 1.
//------------------------------------------------------------------------------
always @(WrPtr or FEN or WrPtrIncValid)
begin : p_WrPtrComb
  if (FEN == 1'b0)
    NextWrPtr <= 4'h0;
  else if (WrPtrIncValid == 1'b1)
    NextWrPtr <= ((WrPtr) + 1);
  else
    NextWrPtr <= WrPtr;
end // p_WrPtrComb
  
//------------------------------------------------------------------------------
// Increment the read pointer when there is a read from the APB interface. For 
// safety, inhibit reads from having any effect if the FIFO is already empty. 
//------------------------------------------------------------------------------
assign RdPtrIncValid    = RXFRdPtrInc & !(FIFOEmpty);

//------------------------------------------------------------------------------
// Freeze the Read pointer at Zero when the FIFO is disabled. When the FIFO is
// enabled and when the RdPtrIncValid signal is asserted, increment the Read
// pointer by 1.
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
// The 'Wrap' bit is used to keep track of the condition when the write pointer
// has wrapped around from '1111' to '0000', but the read pointer has not 
// wrapped. This bit is used to calculate the FIFOFillLevel. As with the 
// pointers, the wrap is kept cleared when the FIFO is disabled. When both the 
// pointers wrap around from '1111' to '0000' simultaneously, the Wrap bit 
// remains unchanged.
//------------------------------------------------------------------------------
always @(WrPtr or RdPtr or Wrap or FEN or WrPtrIncValid or RdPtrIncValid)
begin : p_WrapComb
  if (FEN == 1'b0)
    NextWrap <= 1'b0;
  else if (((WrPtr == 4'hF) & (WrPtrIncValid == 1'b1)) ^
         ((RdPtr == 4'hF) & (RdPtrIncValid == 1'b1)))
    NextWrap <= !(Wrap);
  else
    NextWrap <= Wrap;                    
end // p_WrapComb

//------------------------------------------------------------------------------
// The FIFOFull signal indicates the status of the FIFO when it is enabled. 
// When the FIFO is one less than full and there is another write to the FIFO, 
// the FIFOFull signal is set. When the FIFO is already full and there is a 
// read from the FIFO without a simultaneous write, the FIFOFull signal is 
// de-asserted
//------------------------------------------------------------------------------
always @(FEN or RXFFillLevel or RXFWrSync or DelRXFWrSync or FIFOFull or 
         RXFRdPtrInc) 
begin : p_FIFOFull
  if (FEN == 1'b0)
    NextFIFOFull <= 1'b0;
  else if ((RXFFillLevel == 5'b01111) & (RXFWrSync == 1'b1) 
          & (DelRXFWrSync == 1'b0) & (RXFRdPtrInc == 1'b0))
    NextFIFOFull <= 1'b1;
  else if ((FIFOFull == 1'b1) & (RXFRdPtrInc == 1'b1) & 
          !((RXFWrSync == 1'b1) & (DelRXFWrSync == 1'b0)))
    NextFIFOFull <= 1'b0;
  else
    NextFIFOFull <= FIFOFull;
end // p_FIFOFull
  
//------------------------------------------------------------------------------
// The FIFOEmpty signal indicates the status of the FIFO when it is enabled. If
// the FIFO is empty and there is a write to the FIFO, the FIFOEmpty signal is 
// deasserted. If one location in the FIFO is filled and there is a read from 
// the FIFO, the FIFOEmpty signal is asserted.
//------------------------------------------------------------------------------
always @(FEN or RXFFillLevel or RXFWrSync or DelRXFWrSync or FIFOEmpty or
         RXFRdPtrInc) 
begin : p_FIFOEmpty
  if (FEN == 1'b0)
    NextFIFOEmpty <= 1'b1;
  else if ((FIFOEmpty == 1'b1) & (RXFWrSync == 1'b1) & 
          (DelRXFWrSync == 1'b0))
    NextFIFOEmpty <= 1'b0;
  else if ((RXFFillLevel == 5'b00001) & (RXFRdPtrInc == 1'b1) &
          !((RXFWrSync == 1'b1) & (DelRXFWrSync == 1'b0)))
    NextFIFOEmpty <= 1'b1;
  else
    NextFIFOEmpty <= FIFOEmpty;
end // p_FIFOEmpty

//------------------------------------------------------------------------------
// When the FIFO is disabled, have a single bit to indicate fill status while 
// the pointers are frozen at zero. Set the HldBufValid signal when a rising 
// edge is detected on the RXFWrSync signal. Clear the HldBufValid signal when
// there is a write and a simultaneous read.
//------------------------------------------------------------------------------
always @(FEN or RXFWrSync or RXFRdPtrInc or HldBufValid or DelRXFWrSync)
begin : p_BufValid
  if (FEN == 1'b1)
    NextHldBufValid <= 1'b0;
  else if ((RXFWrSync == 1'b1) & (DelRXFWrSync == 1'b0))
    NextHldBufValid <= 1'b1;
  else if ((RXFRdPtrInc == 1'b1) & 
         !((RXFWrSync == 1'b1) & (DelRXFWrSync == 1'b0)))
    NextHldBufValid <= 1'b0;
  else
    NextHldBufValid <= HldBufValid;
end // p_BufValid

//------------------------------------------------------------------------------
// Subtract the read pointer from the write pointer to calculate the FIFO fill 
// level. Use the Wrap bit to take into account whether the write pointer has 
// wrapped without the read pointer not having wrapped.
//------------------------------------------------------------------------------
assign RXFFillLevel     = (({Wrap, WrPtr}) - ({1'b0, RdPtr}));
                                                        
//------------------------------------------------------------------------------
// When the FIFO is enabled, use the FIFOFull signal to indicate FIFO fill 
// status. When the FIFO is disabled, use the HldBufValid signal to indicate 
// FIFO fill status.
//------------------------------------------------------------------------------
assign RXFF             = (FEN == 1'b1) ? FIFOFull : HldBufValid;

//------------------------------------------------------------------------------
// When the FIFO is enabled, use the FIFOEmpty signal to indicate FIFO fill 
// status. When the FIFO is disabled, use the HldBufValid signal to indicate 
// FIFO fill status.
//------------------------------------------------------------------------------
assign RXFE             = (FEN == 1'b1) ? FIFOEmpty : !(HldBufValid); 

//------------------------------------------------------------------------------
// When the FIFO is enabled, use the RXFFillLevel signal to find whether the 
// FIFO is greater than or equal to half full. If the FIFO is disabled, the 
// HldBufValid signal will indicate whether the FIFO is filled. 
//------------------------------------------------------------------------------
assign FIFOGTEHalfFull  = ((RXFFillLevel) >= 8) ? 1'b1 : 1'b0;

assign RXFGTEHalfFull   = (FEN == 1'b1) ? FIFOGTEHalfFull : HldBufValid;

assign RXHF             = RXFGTEHalfFull;

endmodule

//========================== End of UartTrRXFCntl ============================--
