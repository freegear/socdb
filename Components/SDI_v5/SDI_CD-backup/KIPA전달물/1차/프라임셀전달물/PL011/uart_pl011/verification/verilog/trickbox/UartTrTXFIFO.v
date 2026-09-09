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
//  File Name              : UartTrTXFIFO.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
// -----------------------------------------------------------------------------
//  Purpose          : This block instantiates the UartTXFCntl (Transmit FIFO
//                    control)  and the UartTXRegFile (Register File) blocks.
// ===========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module UartTrTXFIFO (
// Inputs
                     PCLK,
                     PRESETn,
                     UARTEN,
                     UARTDRWrEn,
                     TXFRdPtrInc,
                     FEN,
                     TXBUSY,
                     PWDATAIn,

// Outputs
                     TXHE,
                     TXFF,
                     TXFE,
                     RdPtrIncDone,
                     TXShiftData,
                     TXDataAvlbl
                    );

// Inputs
input         PCLK;             // APB Clock
input         PRESETn;          // AMBA Reset
input         UARTEN;           // UART Enable
input         UARTDRWrEn;       // TX FIFO Write enable
input         TXFRdPtrInc;      // TX FIFO Rd Ptr Inc
input         FEN;              // FIFO Enable
input         TXBUSY;           // Transmitter busy
input   [7:0] PWDATAIn;         // Data bus

// Outputs
output        TXHE;             // TX FIFO GE Half full
output        TXFF;             // Transmit FIFO Full
output        TXFE;             // Transmit FIFO Empty
output        RdPtrIncDone;     // Rd Ptr Inc done
output  [7:0] TXShiftData;      // Xmit Data
output        TXDataAvlbl;      // TX Data Available

// -----------------------------------------------------------------------------
// 
//                                 UartTrTXFIFO
//                                 ==========
// 
// -----------------------------------------------------------------------------
// 
// Overview
// ========
//   Writes to the transmit FIFO occur through the APB interface from the PCLK 
// domain. Reads from the transmit FIFO occur from the transmit block which 
// falls in the UARTCLK clock domain. The FIFO is 8-bit wide and 16-deep. 
//   The UartTrTXFCntl module contains the control logic for the FIFO. It 
// contains a write pointer, a read pointer and a transmit shift register.
//  Writes from the APB can occur as close as every two PCLK periods. So as 
// to ensure that no writes are missed, the write pointer operates on PCLK.
//  To facilitate FIFO fill level calculation, the read pointer is also operated
// on PCLK. 
//   Write data from the APB is written into the location pointed to by the 
// current value of the write pointer. If a write occurs to the FIFO when it is
// already full, the write is ignored.
//   The TXDataAvlbl output signal is asserted when there is data available to 
// be transmitted. Upon detecting this signal, the transmitter commences
// transmission. At the end of transmission of one data byte, the transmitter 
// asserts the RdPtrInc signal. 
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
wire    [3:0] WrPtr;
wire    [3:0] RdPtr;
wire          RegFileWrEn;
wire    [7:0] TXFIFOData;
 
//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// The UartTXRegFile is a data buffer implemented using D-types.
//------------------------------------------------------------------------------
UartTrTXRegFile uUartTXRegFile        (
                    .WrPtr            (WrPtr),
                    .PWDATAIn         (PWDATAIn),
                    .RegFileWrEn      (RegFileWrEn),
                    .PCLK             (PCLK),
                    .RdPtr            (RdPtr),
                    .TXFIFOData       (TXFIFOData),
                    .PRESETn          (PRESETn)
                    );


//------------------------------------------------------------------------------
// The UartTXFCntl block controls accesses to the FIFO register file.
//------------------------------------------------------------------------------
UartTrTXFCntl uUartTXFCntl            (
                    .WrPtr            (WrPtr),
                    .RegFileWrEn      (RegFileWrEn),
                    .RdPtr            (RdPtr),
                    .PCLK             (PCLK),
                    .PWDATAIn         (PWDATAIn),
                    .TXFF             (TXFF),
                    .TXFE             (TXFE),
                    .TXFLTEHalfFull   (TXHE),
                    .TXDataAvlbl      (TXDataAvlbl),
                    .PRESETn          (PRESETn),
                    .FEN              (FEN),
                    .TXShiftData      (TXShiftData),
                    .UARTEN           (UARTEN),
                    .UARTDRWrEn       (UARTDRWrEn),
                    .TXFIFOData       (TXFIFOData),
                    .RdPtrIncDone     (RdPtrIncDone),
                    .TXFRdPtrInc      (TXFRdPtrInc),
                    .TXBUSY           (TXBUSY)
                    );

endmodule

// --================================== End ==================================--
