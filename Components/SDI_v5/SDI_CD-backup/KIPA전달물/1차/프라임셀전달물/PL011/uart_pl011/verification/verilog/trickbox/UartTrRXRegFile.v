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
//  File Name              : UartTrRXRegFile.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
// -----------------------------------------------------------------------------
// Purpose      : Receive FIFO Register File
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------
module UartTrRXRegFile (
// Inputs
                        PCLK,
                        PRESETn,
                        RegFileWrEn,
                        UTCR,
                        WrPtr,
                        RdPtr,
                        RxFIFOData,
                        IrdaRxFIFOData,

// Outputs
                        RxFRdData
       );

// Inputs
input         PCLK;             // APB Clock
input         PRESETn;          // APB Reset
input         RegFileWrEn;      // Write Enable
input   [1:0] UTCR;             // Trickbox Control Reg
input   [3:0] WrPtr;            // Write Pointer
input   [3:0] RdPtr;            // Read Pointer
input  [10:0] RxFIFOData;       // Write data
input  [10:0] IrdaRxFIFOData;   // Irda Write data

// Outputs
output [10:0] RxFRdData;        // Read data

// Inputs
wire          PCLK;             // APB Clock
wire          PRESETn;          // APB Reset
wire          RegFileWrEn;      // Write Enable
wire    [1:0] UTCR;             // Trickbox Control Reg
wire    [3:0] WrPtr;            // Write Pointer
wire    [3:0] RdPtr;            // Read Pointer
wire   [10:0] RxFIFOData;       // Write data
wire   [10:0] IrdaRxFIFOData;   // Irda Write data

// Outputs
wire   [10:0] RxFRdData;        // Read data

//------------------------------------------------------------------------------
//
//                             UartTrRXRegFile
//                             ===============
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//  This block contains an array of flipflops that serve as the storage register
// file for the receive FIFO. 
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
reg    [10:0] iRxFIFOData;

reg    [10:0] RxReg0;
 
reg    [10:0] NextRxReg0;
// D-input of RxReg0
 
reg    [10:0] RxReg1;
// Receive FIFO register1
 
reg    [10:0] NextRxReg1;
// D-input of RxReg1
 
reg    [10:0] RxReg2;
// Receive FIFO register2
 
reg    [10:0] NextRxReg2;
// D-input of RxReg2
 
reg    [10:0] RxReg3;
// Receive FIFO register3
 
reg    [10:0] NextRxReg3;
// D-input of RxReg3
 
reg     [10:0] RxReg4;
// Receive FIFO register4
 
reg    [10:0] NextRxReg4;
// D-input of RxReg4
 
reg    [10:0] RxReg5;
// Receive FIFO register5
 
reg    [10:0] NextRxReg5;
// D-input of RxReg5
 
reg    [10:0] RxReg6;
// Receive FIFO register6
 
reg    [10:0] NextRxReg6;
// D-input of RxReg6
 
reg    [10:0] RxReg7;
// Receive FIFO register7
 
reg    [10:0] NextRxReg7;
// D-input of RxReg7

reg    [10:0] RxReg8;
// Receive FIFO register8
 
reg    [10:0] NextRxReg8;
// D-input of RxReg8
 
reg    [10:0] RxReg9;
// Receive FIFO register9
 
reg    [10:0] NextRxReg9;
// D-input of RxReg9
 
reg    [10:0] RxReg10;
// Receive FIFO register10
 
reg    [10:0] NextRxReg10;
// D-input of RxReg10
 
reg    [10:0] RxReg11;
// Receive FIFO register11
 
reg    [10:0] NextRxReg11;
// D-input of RxReg11
 
reg    [10:0] RxReg12;
// Receive FIFO register12
 
reg    [10:0] NextRxReg12;
// D-input of RxReg12
 
reg    [10:0] RxReg13;
// Receive FIFO register13
 
reg    [10:0] NextRxReg13;
// D-input of RxReg13
 
reg    [10:0] RxReg14;
// Receive FIFO register14
 
reg    [10:0] NextRxReg14;
// D-input of RxReg14
 
reg    [10:0] RxReg15;
// Receive FIFO register15
 
reg    [10:0] NextRxReg15;
// D-input of RxReg15

// -----------------------------------------------------------------------------
//
// Main body of Code
// =================
//
// -----------------------------------------------------------------------------
 
// -----------------------------------------------------------------------------
// Register array.
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (PRESETn == 1'b0)
    begin
      RxReg0  <= 11'b00000000000;
      RxReg1  <= 11'b00000000000;
      RxReg2  <= 11'b00000000000;
      RxReg3  <= 11'b00000000000;
      RxReg4  <= 11'b00000000000;
      RxReg5  <= 11'b00000000000;
      RxReg6  <= 11'b00000000000;
      RxReg7  <= 11'b00000000000;
      RxReg8  <= 11'b00000000000;
      RxReg9  <= 11'b00000000000;
      RxReg10 <= 11'b00000000000;
      RxReg11 <= 11'b00000000000;
      RxReg12 <= 11'b00000000000;
      RxReg13 <= 11'b00000000000;
      RxReg14 <= 11'b00000000000;
      RxReg15 <= 11'b00000000000;
    end 
  else
    begin
      RxReg0  <= NextRxReg0;
      RxReg1  <= NextRxReg1;
      RxReg2  <= NextRxReg2;
      RxReg3  <= NextRxReg3;
      RxReg4  <= NextRxReg4;
      RxReg5  <= NextRxReg5;
      RxReg6  <= NextRxReg6;
      RxReg7  <= NextRxReg7;
      RxReg8  <= NextRxReg8;
      RxReg9  <= NextRxReg9;
      RxReg10 <= NextRxReg10;
      RxReg11 <= NextRxReg11;
      RxReg12 <= NextRxReg12;
      RxReg13 <= NextRxReg13;
      RxReg14 <= NextRxReg14;
      RxReg15 <= NextRxReg15;
    end
end // p_Seq
 
// -----------------------------------------------------------------------------
// Write logic. When the Write enable signal, RegFileWrEn, is asserted, data on
// the write data bus PWDATAIn is written into the location pointed to by the
// current value of the Write pointer, WrPtr[2:0].
// -----------------------------------------------------------------------------
always @(RxReg0 or RxReg1 or RxReg2 or RxReg3 or RxReg4 or RxReg5 or RxReg6 or 
         RxReg7 or RxReg8 or RxReg9 or RxReg10 or RxReg11 or RxReg12 or
         RxReg13 or RxReg14 or RxReg15 or WrPtr or RegFileWrEn or iRxFIFOData)
begin : p_WrComb
  NextRxReg0  = RxReg0;
  NextRxReg1  = RxReg1;
  NextRxReg2  = RxReg2;
  NextRxReg3  = RxReg3;
  NextRxReg4  = RxReg4;
  NextRxReg5  = RxReg5;
  NextRxReg6  = RxReg6;
  NextRxReg7  = RxReg7;
  NextRxReg8  = RxReg8;
  NextRxReg9  = RxReg9;
  NextRxReg10 = RxReg10;
  NextRxReg11 = RxReg11;
  NextRxReg12 = RxReg12;
  NextRxReg13 = RxReg13;
  NextRxReg14 = RxReg14;
  NextRxReg15 = RxReg15;
 
  if (RegFileWrEn == 1'b1)
    case (WrPtr)
      4'h0 : NextRxReg0 = iRxFIFOData;
      4'h1 : NextRxReg1 = iRxFIFOData;
      4'h2 : NextRxReg2 = iRxFIFOData;
      4'h3 : NextRxReg3 = iRxFIFOData;
      4'h4 : NextRxReg4 = iRxFIFOData;
      4'h5 : NextRxReg5 = iRxFIFOData;
      4'h6 : NextRxReg6 = iRxFIFOData;
      4'h7 : NextRxReg7 = iRxFIFOData;
      4'h8 : NextRxReg8 = iRxFIFOData;
      4'h9 : NextRxReg9 = iRxFIFOData;
      4'hA : NextRxReg10 = iRxFIFOData;
      4'hB : NextRxReg11 = iRxFIFOData;
      4'hC : NextRxReg12 = iRxFIFOData;
      4'hD : NextRxReg13 = iRxFIFOData;
      4'hE : NextRxReg14 = iRxFIFOData;
      4'hF : NextRxReg15 = iRxFIFOData;
      //default : null;
    endcase
end // p_WrComb
 
// -----------------------------------------------------------------------------
// Read Mux. The contents of the location pointed to by the current value of
// the read pointer RdPtr, is driven onto the read databus, RxFRdData.
// -----------------------------------------------------------------------------
assign RxFRdData        = (RdPtr == 4'h0) ?
                          RxReg0 : ((RdPtr == 4'h1) ?
                          RxReg1 : ((RdPtr == 4'h2) ?
                          RxReg2 : ((RdPtr == 4'h3) ?
                          RxReg3 : ((RdPtr == 4'h4) ?
                          RxReg4 : ((RdPtr == 4'h5) ?
                          RxReg5 : ((RdPtr == 4'h6) ?
                          RxReg6 : ((RdPtr == 4'h7) ?
                          RxReg7 : ((RdPtr == 4'h8) ?
                          RxReg8 : ((RdPtr == 4'h9) ?
                          RxReg9 : ((RdPtr == 4'hA) ?
                          RxReg10 : ((RdPtr == 4'hB) ?
                          RxReg11 : ((RdPtr == 4'hC) ?
                          RxReg12 : ((RdPtr == 4'hD) ?
                          RxReg13 : ((RdPtr == 4'hE) ?
                          RxReg14 : ((RdPtr == 4'hF) ?
                          RxReg15 : 11'b00000000000)))))))))))))));

//------------------------------------------------------------------------------
// Write logic
//------------------------------------------------------------------------------
always @(UTCR or RxFIFOData or IrdaRxFIFOData)
begin : p_modeComb
  if (UTCR[0] == 1'b1)
     if (UTCR[1] == 1'b1)
        iRxFIFOData <= IrdaRxFIFOData;
     else
        iRxFIFOData <= RxFIFOData;
end // p_modeComb

endmodule

//========================== End of UartTrRXRegFile ==========================--
