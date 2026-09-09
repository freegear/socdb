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
//  File Name              : UartTrRXFIFO.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
//  ----------------------------------------------------------------------------
//  Purpose          : This block instantiates the UartRXFCntl (Receive FIFO
//                    control)  and the UartRXRegFile (Register File) blocks.
//============================================================================--

`timescale 1ns/1ps

//  ----------------------------------------------------------------------------

module UartTrRXFIFO (
// Inputs
                     PCLK,
                     PRESETn,
                     RXFWr,
                     RXFRdPtrInc,
                     RXFIFOData,
                     UTCR,
                     IrdaRXFWr,
                     IrdaRXFIFOData,
                     FEN,

// Outputs
                     RXFWrDone,
                     RXFE,
                     RXFF,
                     RXHF,
                     RXFRdData
       );

// Inputs
input         PCLK;             // APB Clock
input         PRESETn;          // AMBA Reset
input         RXFWr;            // RX FIFO Write Enable
input         RXFRdPtrInc;      // RX FIFO Read Pointer Incr
input  [10:0] RXFIFOData;       // RX FIFO Write data
input   [1:0] UTCR;             // Trickbox Control Reg
input         IrdaRXFWr;        // Irda RX FIFO Write Enable
input  [10:0] IrdaRXFIFOData;   //Irda RX Write data
input         FEN;              // FIFO Enable

// Outputs
output        RXFWrDone;        // RX FIFO Write Done
output        RXFE;             // Receive FIFO Empty
output        RXFF;             // Receive FIFO Full
output        RXHF;             // RX FIFO more than half-full
output [10:0] RXFRdData;        // RX FIFO Read Data

// Inputs
wire          PCLK;             // APB Clock
wire          PRESETn;          // AMBA Reset
wire          RXFWr;            // RX FIFO Write Enable
wire          RXFRdPtrInc;      // RX FIFO Read Pointer Incr
wire   [10:0] RXFIFOData;       // RX FIFO Write data
wire    [1:0] UTCR;             // Trickbox Control Reg
wire          IrdaRXFWr;        // Irda RX FIFO Write Enable
wire   [10:0] IrdaRXFIFOData;   //Irda RX Write data
wire          FEN;              // FIFO Enable

// Outputs
wire          RXFWrDone;        // RX FIFO Write Done
wire          RXFE;             // Receive FIFO Empty
wire          RXFF;             // Receive FIFO Full
wire          RXHF;             // RX FIFO more than half-full
wire   [10:0] RXFRdData;        // RX FIFO Read Data

// -----------------------------------------------------------------------------
//
//                                 UartTrRXFIFO
//                                 ==========
//
//------------------------------------------------------------------------------
//
// Overview
// ========
// 
//   The receive FIFO is a 11-bit wide 16-deep FIFO. It instantiates two 
// submodules - UartRXFCntl (which performs the FIFO control function and the
// UartRXRegFile (which is the register file). The receive FIFO is implemented
// as a circular buffer with read and write pointers. The pointers operate on
// PCLK to facilitate APB accesses and calculation of FIFO fill level.
// 
//-----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
 
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
wire          RegFileWrEn;
// Data Register write Enable

wire    [3:0] WrPtr;
// Pointing to write location of FIFO
 
wire    [3:0] RdPtr;
// Pointing to read location of FIFO

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// The UartRXFCntl block controls accesses to the FIFO register file.
//------------------------------------------------------------------------------
UartTrRXFCntl uUartRXFCntl            (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .RXFWr            (RXFWr),
                    .UTCR             (UTCR),
                    .IrdaRXFWr        (IrdaRXFWr),
                    .RXFRdPtrInc      (RXFRdPtrInc),
                    .FEN              (FEN),
                    .RegFileWrEn      (RegFileWrEn),
                    .RXFWrDone        (RXFWrDone),
                    .WrPtr            (WrPtr),
                    .RdPtr            (RdPtr),
                    .RXFE             (RXFE),
                    .RXFF             (RXFF),
                    .RXHF             (RXHF)
   );


//------------------------------------------------------------------------------
// The UartRXRegFile is a data buffer implemented using D-types.
//------------------------------------------------------------------------------
UartTrRXRegFile uUartRXRegFile        (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .RegFileWrEn      (RegFileWrEn),
                    .UTCR             (UTCR),
                    .WrPtr            (WrPtr),
                    .RdPtr            (RdPtr),
                    .RxFIFOData       (RXFIFOData),
                    .IrdaRxFIFOData   (IrdaRXFIFOData),
                    .RxFRdData        (RXFRdData)
   );

endmodule

// ============================== End  =========================================
