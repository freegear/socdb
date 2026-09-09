// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : SciTrRxFCntl.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Purpose      : This block controls accesses to the Receive FIFO.
// -----------------------------------------------------------------------------
 

// -----------------------------------------------------------------------------

module SciTrRxFCntl (
                     PCLK,        
                     PRESETn,       
                     RxFWrSync,   
                     RxFRdPtrInc, 
                     RxSRLevel,   
                     SCITrRFR,    
                     RegFileWrEn, 
                     SCITrRFE,    
                     SCITrRFF,    
                     WrPtr,       
                     RdPtr        
                    );

input         PCLK;        // APB bus clock
input         PRESETn;     // reset (from PRESETn)
input         RxFWrSync;   //  RX FIFO write enable
input         RxFRdPtrInc; //  RX FIFO read pointer incr.
input   [3:0] RxSRLevel;   // RX FIFO level
output        SCITrRFR;    // RX FIFO service request
output        RegFileWrEn; // Write enable to register file
output        SCITrRFE;    // RX FIFO not empty
output        SCITrRFF;    // RX FIFO full
output  [3:0] WrPtr;       // Write pointer
output  [3:0] RdPtr;       // Read pointer
//------------------------------------------------------------------------------
//
//                          SciTrRxFCntl
//                          ============
//
//------------------------------------------------------------------------------
// Overview
// ========
//
//   The control logic for the Receive FIFO uses two pointers - a write pointer
// and a read pointer. Since the FIFO has 15 locations, the pointers are 4 bits
// wide. The write pointer points to the location to which the next write data 
// will be written into. The read pointer points to the location whose contents
// are driven on the RxFRdData[15:0] Read data bus.
//   Both the pointers operate on PCLK so as to serve data consistently to the 
// APB and to facilitate calculation of the FIFO fill level by finding the 
// difference between the pointers. 
//   This module also contains logic to generate the RFE (Receive FIFO  
// Empty) status signal, the RFF (Receive FIFO Full) status signal, the 
// RFR (Receive FIFO Service Request) signal 
//


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
reg [3:0] RdPtr;
// Read pointer

reg [3:0] NextRdPtr;
// D-input of RdPtr
 
reg [3:0] WrPtr;
// Write pointer

reg [3:0] NextWrPtr;
// D-input of WrPtr
 
reg  DelRxFWrSync;
// Delayed version of RxFWr - Receive FIFO Write enable signal. Used to 
// convert the level on the RxFWr signal to a one-PCLK wide pulse.
 
reg Wrap;
// Store the condition when the write pointer has rolled over (from '111' to 
// '000') but the read pointer hasn't. The 'Wrap'signal is used in calculating
// the FIFOFillLevel

reg NextWrap;
// D-input of Wrap

wire [3:0] RxFFillLevel;
// Receive FIFO Fill level indication

reg SCITrRFR;
// Receive FIFO service request interrupt

reg NextSCITrRFR;
// D-input of SCITrRFR

reg iRNE;
// Receive FIFO fill status indication (Receive FIFO not Empty)

reg NextRNE;
// D-input of iRNE

reg SCITrRFF;
// Receive FIFO Full indication. Also used to prevent writes into the FIFO 
// when the FIFO is already full.

reg NextSCITrRFF;
// D-input of SCITrRFF

wire WrPtrIncValid;
// Valid Write pointer increment
 
wire RdPtrIncValid;
// Valid Read Pointer Increment

//------------------------------------------------------------------------------
//
// Main body of Code
// =================
//
//------------------------------------------------------------------------------
// Connect local copies to output ports
//------------------------------------------------------------------------------
assign SCITrRFE   = ~(iRNE);

//------------------------------------------------------------------------------
// Allow writes to the Receive FIFO only if the FIFO is not already full
//------------------------------------------------------------------------------
assign RegFileWrEn = (RxFWrSync &  ~(DelRxFWrSync)) &  ~(SCITrRFF);

//------------------------------------------------------------------------------
// Clocked process for flip-flops in this module.
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (PRESETn == 1'b0)
  begin
    WrPtr        <= 4'b0;
    RdPtr        <= 4'b0;
    Wrap         <= 1'b0;
    iRNE         <= 1'b0;
    SCITrRFF     <= 1'b0;
    SCITrRFR     <= 1'b0;
    DelRxFWrSync <= 1'b0;
  end
  else
  begin
    WrPtr        <= NextWrPtr;
    RdPtr        <= NextRdPtr;
    Wrap         <= NextWrap;
    iRNE         <= NextRNE;
    SCITrRFF     <= NextSCITrRFF;
    SCITrRFR     <= NextSCITrRFR;
    DelRxFWrSync <= RxFWrSync;
  end
end // p_Seq;

//------------------------------------------------------------------------------
// Increment the write pointer when there is a write to the FIFO from the 
// Receive logic. The increment should be avoided if the receive FIFO is already
// full. If the FIFO is already full and there is a simultaneous read and a
// write, the write should be allowed to complete and the write pointer should
// be incremented.
//------------------------------------------------------------------------------
assign WrPtrIncValid = (RxFWrSync & !(DelRxFWrSync) &  (!(SCITrRFF)| 
                       (SCITrRFF & RxFRdPtrInc)));

//------------------------------------------------------------------------------
// Increment the write pointer when the WrPtrIncValid signal is asserted
//------------------------------------------------------------------------------
always @(WrPtr or WrPtrIncValid)
begin : p_WrPtrComb
  if (WrPtrIncValid == 1'b1) 
    NextWrPtr = (WrPtr) + 1; 
  else
    NextWrPtr = WrPtr;
end // p_WrPtrComb;

//------------------------------------------------------------------------------
// Increment the read pointer when the FIFO is not already empty and when there
// is a read from the FIFO i.e. when the RxFRdPtrInc signal from the APB
// interface, is asserted.
//------------------------------------------------------------------------------
assign RdPtrIncValid = RxFRdPtrInc & iRNE;

//------------------------------------------------------------------------------
// Increment the read pointer when the RdPtrIncValid signal is asserted
//------------------------------------------------------------------------------
always @(RdPtr or RdPtrIncValid)
begin : p_RdPtrComb
  if (RdPtrIncValid == 1'b1) 
    NextRdPtr = (RdPtr) + 1;
  else
    NextRdPtr = RdPtr;
end // p_RdPtrComb;

//------------------------------------------------------------------------------
// The 'Wrap' bit is used to keep track of the condition when the write pointer
// has wrapped around from '1111' to '0000', but the read pointer has not 
// wrapped. This bit is used to calculate the value of RxFFillLevel. Toggle 
// the 'Wrap' bit whenever the read pointer wraps around or the write pointer 
// wraps around. When both the pointers wrap around simultaneously, the 'Wrap' 
// bit should not toggle.
//------------------------------------------------------------------------------
always @(WrPtr or WrPtrIncValid or RdPtr or Wrap or RdPtrIncValid)
begin : p_WrapComb
  if (((WrPtr == 4'b1111) &  (WrPtrIncValid == 1'b1)) ^ 
      ((RdPtr == 4'b1111) & (RdPtrIncValid == 1'b1))) 
    NextWrap =  !(Wrap);
  else
    NextWrap = Wrap;

end // p_WrapComb;

//------------------------------------------------------------------------------
// Use the RxFFillLevel (Receive FIFO Fill Level) signal to detect whether
// the receive FIFO is not empty. If the FIFO is empty and there is a valid
// write detected, then the FIFO is no longer empty. If the FIFO has one valid
// entry and there is a valid read detected, without a simultaneous write,
// the Receive FIFO is empty.
//------------------------------------------------------------------------------
always @(RxFFillLevel or WrPtrIncValid or RdPtrIncValid or iRNE)
begin : p_RNE
  if ((RxFFillLevel == 5'b00000) & (WrPtrIncValid == 1'b1)) 
    NextRNE = 1'b1;
  else
  begin
    if ((RxFFillLevel == 5'b00001) & (RdPtrIncValid == 1'b1)
         & (WrPtrIncValid == 1'b0)) 
      NextRNE = 1'b0;
    else
      NextRNE = iRNE;
  end
end // p_RNE

//------------------------------------------------------------------------------
// Assert the Receive FIFO service request if the FIFO contains four or more
// valid entries
//------------------------------------------------------------------------------
always @(RxSRLevel or RxFFillLevel)
begin : p_RFS
  if ((RxFFillLevel)  >=  (RxSRLevel)) 
    NextSCITrRFR = 1'b1;
  else
    NextSCITrRFR = 1'b0;
end // p_RFS;

//------------------------------------------------------------------------------
// RFF (Receive FIFO Full) generation. When the FIFO has seven entries and
// and there is another write without a simultaneous read, the FIFO is said to
// be Full. When the FIFO is already full and there is a read from the FIFO
// without a simultaneous write, the FIFO is said to be 'Not Full'
//------------------------------------------------------------------------------
always @(RxFFillLevel or SCITrRFF or WrPtrIncValid or RdPtrIncValid)
begin : p_SCITrRFF
  if ((RxFFillLevel == 5'b01111)  & (WrPtrIncValid == 1'b1) &
        (RdPtrIncValid == 1'b0)) 
    NextSCITrRFF = 1'b1;
  else
  begin
    if ((RxFFillLevel == 5'b10000)  & (RdPtrIncValid == 1'b1) & 
        (WrPtrIncValid == 1'b0)) 
      NextSCITrRFF = 1'b0;
    else
      NextSCITrRFF = SCITrRFF;
  end
end // p_SCITrRFF;

//------------------------------------------------------------------------------
// Subtract the write pointer from the read pointer to calculate the FIFO fill 
// level. Use the Wrap bit to take into account the case when the write pointer
// has wrapped without the read pointer having wrapped
//------------------------------------------------------------------------------
assign RxFFillLevel   = ({Wrap, WrPtr} - {1'b0, RdPtr});

endmodule 

//============================ End of SciRxFCntl =============================--








