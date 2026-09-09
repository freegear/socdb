// ========================================================================== 
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//---------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : UartTrick.v.rca
//  File Revision          : 1.4
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
//------------------------------------------------------------------------------
//  Purpose  : This module is the top level entity of the VHDL  trickbox 
//
// ========================================================================== --

`timescale 1ns/1ps

//  ----------------------------------------------------------------------------

module UartTrick (
// Inputs
                  PCLK,
                  PRESETn,
                  PENABLE,
                  PSELT,
                  PWRITE,
                  PADDR,
                  PWData,
                  UARTTXD,
                  nSIROUT,
                  nUARTOut2,
                  nUARTOut1,
                  nUARTRTS,
                  nUARTDTR,
                  UARTMSINTR,
                  UARTRXINTR,
                  UARTTXINTR,
                  UARTRTINTR,
                  UARTINTR,
                  UARTEINTR,
                  UARTTXDMASREQ,
                  UARTTXDMABREQ,
                  UARTRXDMASREQ,
                  UARTRXDMABREQ,

// Outputs
                  UARTRXD,
                  SIRIN,
                  PRData,
                  nUARTRST,
                  UARTCLK,
                  nUARTRI,
                  nUARTCTS,
                  nUARTDCD,
                  nUARTDSR,
                  SCANMODE,
                  UARTTXDMACLR,
                  UARTRXDMACLR
                 );

// Inputs
input         PCLK;             // APB bus signal
input         PRESETn;          // APB bus signal
input         PENABLE;          // APB bus signal
input         PSELT;            // APB bus signal
input         PWRITE;           // APB bus signal
input   [7:2] PADDR;            // APB bus signal
input   [7:0] PWData;           // APB bus signal
input         UARTTXD;          // UUT's TXD & Trickbox's RXD
input         nSIROUT;          // UUT's SIROUT & Trickbox's SIRIN
input         nUARTOut2;        // Modem signal
input         nUARTOut1;        // Modem signal
input         nUARTRTS;         // Modem signal
input         nUARTDTR;         // Modem signal
input         UARTMSINTR;       // UART Modem Status Interrupt Signal
input         UARTRXINTR;       // UART RX Interrupt Signal
input         UARTTXINTR;       // UART TX Interrupt Signal
input         UARTRTINTR;       // UART Timeout Interrupt Signal
input         UARTINTR;         // UART Combined Interrupt Signal
input         UARTEINTR;        // UART Error Combined Interrupt Signal
input         UARTTXDMASREQ;    // Transmit DMA single request
input         UARTTXDMABREQ;    // Transmit DMA burst request
input         UARTRXDMASREQ;    // Receive DMA single request
input         UARTRXDMABREQ;    // Receive DMA burst request

// Outputs
output        UARTRXD;          // UUT's RXD & Trickbox's TXD
output        SIRIN;            // UUT's SIRIN  & Trickbox's SIROUT
output  [7:0] PRData;           // APB bus signal
output        nUARTRST;         // Uart Reset
output        UARTCLK;          // Uart Clock
output        nUARTRI;          // UART Modem Control Signal
output        nUARTCTS;         // UART Modem Control Signal
output        nUARTDCD;         // UART Modem Control Signal
output        nUARTDSR;         // UART Modem Control Signal
output        SCANMODE;         // SCAN-specific signal
output        UARTTXDMACLR;     // Transmit DMA request clear
output        UARTRXDMACLR;     // Receive DMA request clear

// Inputs
wire          PCLK;             // APB bus signal
wire          PRESETn;          // APB bus signal
wire          PENABLE;          // APB bus signal
wire          PSELT;            // APB bus signal
wire          PWRITE;           // APB bus signal
wire    [7:2] PADDR;            // APB bus signal
wire    [7:0] PWData;           // APB bus signal
wire          UARTTXD;          // UUT's TXD & Trickbox's RXD
wire          nSIROUT;          // UUT's SIROUT & Trickbox's SIRIN
wire          nUARTOut2;        // Modem signal
wire          nUARTOut1;        // Modem signal
wire          nUARTRTS;         // Modem signal
wire          nUARTDTR;         // Modem signal
wire          UARTMSINTR;       // UART Modem Status Interrupt Signal
wire          UARTRXINTR;       // UART RX Interrupt Signal
wire          UARTTXINTR;       // UART TX Interrupt Signal
wire          UARTRTINTR;       // UART Timeout Interrupt Signal
wire          UARTINTR;         // UART Combined Interrupt Signal
wire          UARTEINTR;        // UART Error Combined Interrupt Signal
wire          UARTTXDMASREQ;    // Transmit DMA single request
wire          UARTTXDMABREQ;    // Transmit DMA burst request
wire          UARTRXDMASREQ;    // Receive DMA single request
wire          UARTRXDMABREQ;    // Receive DMA burst request

// Outputs
wire          UARTRXD;          // UUT's RXD & Trickbox's TXD
wire          SIRIN;            // UUT's SIRIN  & Trickbox's SIROUT
wire    [7:0] PRData;           // APB bus signal
wire          nUARTRST;         // Uart Reset
wire          UARTCLK;          // Uart Clock
wire          nUARTRI;          // UART Modem Control Signal
wire          nUARTCTS;         // UART Modem Control Signal
wire          nUARTDCD;         // UART Modem Control Signal
wire          nUARTDSR;         // UART Modem Control Signal
wire          SCANMODE;         // SCAN-specific signal
wire          UARTTXDMACLR;     // Transmit DMA request clear
wire          UARTRXDMACLR;     // Receive DMA request clear

// -----------------------------------------------------------------------------
//
//                                UartTrickbox
//                                ============
//
// -----------------------------------------------------------------------------
//
//  Overview
//  ========
//    This block is the top level of the UART. This block instantiates the
// functional sub-blocks in the UART.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
// UART Transmitter
wire    [7:0] PWDATAIn;
// Input data from APB Bus

wire          UTILPRWrEn; 
// ILPR Reg Write Enable

wire          UTLCRHWrEn; 
// LCRH Reg Write Enable

wire          UTLCRMWrEn; 
// LCRM Reg Write Enable

wire          UTLCRLWrEn;
// LCRL Reg Write Enable

wire          UTCRWrEn;
// Control Reg Write Enable

wire          UTFORCEDERRSWrEn;
// FORCED Errors  Reg Write Enable

wire          UTSETPINSWrEn;
// SETPINS  Reg Write Enable

wire          UTBITSFTDATAWrEn;
// Shift Pulse Reg Write Enable

wire          UTSFTDATA2WrEn;
// Shift Pulse second  Reg Write Enable

wire          UTCLKREGWrEn;
// Uart Clock Reg Write Enable

wire          RSTMODEREGWrEn;
// Reset Reg Write Enable

wire          UTDMACRWrEn;
// UT DMA Control Reg Write Enable

wire          UTSTPARITYWrEn;
// UT STPARITY Reg Write Enable

wire          UTFBRDWrEn;
// UTFBRD Reg Write Enable

wire   [10:0] RXFRdData;
// Data read out to APB bus from RX FIFO

wire    [7:0] UTFORCEDERRS; 
// Forced Errors Register

wire    [7:0] UTLCRH;
// Line Control Register

wire    [7:0] UTLCRM;
// Line Control Register

wire    [7:0] UTLCRL;
// Line Control Register

wire    [7:0] UTILPR;
// Low Power Register

wire    [7:0] UTCR;
// Trickbox Control Register

wire    [7:0] UTSETPINS;
// Set Pins Register

wire    [7:0] UTBITSFTDATA;
// Shift Pulse status register

wire    [5:0] UTBITSFTDATA2;
// Shift Pulse status register 2

wire    [7:0] UTCLKREG;
// Uart Clock Register

wire    [3:0] RSTMODEREG;
// Resetmode Register

wire    [1:0] UTDMACR;
// Trickbox DMA Control Register

wire    [7:0] UTSTPARITY;
// Trickbox STPARITY  Register

wire    [5:0] UTFBRD;
// Trickbox FBRD  Register

wire   [10:0] RXFIFOData;
// Data written into RX FIFO

wire          IrdaRXFWr;
// Write to RX FIFO from Irda mode

wire   [10:0] IrdaRXFIFOData;
// Data written into RX FIFO in Irda mode

wire          RXFRdPtrInc;
// Increment Read pointer

wire          TXFRdPtrInc;
// Increment TX FIFO Read Pointer

wire          RdPtrIncDone;
// Rd Ptr Inc done in TX FIFO

wire    [7:0] TXShiftData;
// Transmit Shift Register data

wire          nSIRIN;
// Internal version of SIRIN

wire          TXFF;
// TX FIFO Full

wire          TXFE;
// TX FIFO Empty

wire          TXDataAvlbl;
// Transmit Data available in TX FIFO

wire          TXD;
// Transmitted Data

wire          UartRXBUSY;
// Reception in progress in normal mode

wire          IrdaRXBUSY;
// Reception in progress in Irda mode

wire          nUARTRES;
// Uart Reset

wire          PCLKOn;
// Routing PCLK

wire          REFCLKOn;
// Routing UartClk

wire    [7:0] ClkPeriod;        
// Clock Width

wire          RESETBIT;        
// Uart Reset status

wire          UTDRWrEn;
// Trickbox DR Write Enable

wire          IrdaRCVPE;
// Parity Error in Irda mode

wire          IrdaRCVFE;
// Parity Error in Irda mode

wire          RCVPE;
// Parity Error in Normal  mode

wire          RCVFE;
// Parity Error in Normal  mode

wire          TXHE;
// TX FIFO Half Empty

wire          RXHF;
// RX FIFO Half Full

wire          RXFF;
// RX FIFO Full

wire          RXFE;
// RX FIFO Empty

wire          RTIS;
// Receive Timeout Interrupt Status

wire          TIS;
// Transmit Interrupt Status

wire          RIS;
// Receive Interrupt Status

wire          MIS;
// Modem Interrupt Status

wire    [2:0] SPNUM;
// Starting Pulse to be jittered

wire    [2:0] EPNUM;
// Last Pulse number upto which pulses are jittered

wire    [1:0] SHFT;
// Shift factor

wire    [2:0] PSHFT;
// Pulse Shift factor

wire    [2:0] PNUM;
// Pulse number to be jittered

wire          FREQERR;
// Frequency Baud width in Error

wire   [15:0] Divisor; 
// Uart baud Rate

wire    [5:0] FracDiv; 
// Fractional part of Uart baud Rate

wire    [1:0] Mode;
// Trickbox operation mode

wire          RXFWr;
// RX FIFO Frame Write

wire          RXFWrDone;
// RX FIFO Frame write over

wire          TXBUSY;
// Transmission in Progress

wire          UartTXBUSY;
// Transmission in Progress in Normal mode

wire          IrdaTXBUSY;
// Transmission in Progress in Irda mode

wire          UartTXFRdPtrInc;
// TX FIFO ReadPtr to br incremented in Normal mode

wire          IrdaTXFRdPtrInc;
// TX FIFO ReadPtr to br incremented in Irda mode

wire          TXDMACLRStag4;
// For generating UARTTXDMACLR

wire          RXDMACLRStag4;
// For generating UARTRXDMACLR

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Internal versions of output(s)...
//------------------------------------------------------------------------------
assign nUARTRST         = nUARTRES;
assign nUARTCTS         = UTSETPINS[0];
assign nUARTDCD         = UTSETPINS[1];
assign nUARTDSR         = UTSETPINS[2];
assign nUARTRI          = UTSETPINS[5];
assign SCANMODE         = UTSETPINS[7];
assign Divisor          = {UTLCRM, UTLCRL};
assign FracDiv          = UTFBRD;
assign UARTRXD          = TXD;
assign SIRIN            = nSIRIN;

//------------------------------------------------------------------------------
//Generating Uart Clock
//------------------------------------------------------------------------------
UartTrClk uUartTrClk                  (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .ClkPeriod        (UTCLKREG),
                    .RSTMODEREG       (RSTMODEREG),
                    .UartClk          (UARTCLK),
                    .PCLKOn           (PCLKOn),
                    .REFCLKOn         (REFCLKOn),
                    .RESETBIT         (RSTMODEREG[0]),
                    .nUARTRST         (nUARTRES)
                    );
 
//------------------------------------------------------------------------------
// Register block for normal mode registers
//------------------------------------------------------------------------------
UartTrRegBlock uUartTrRegBlock        (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .Mode             (Mode),
                    .UTILPRWrEn       (UTILPRWrEn),
                    .UTLCRHWrEn       (UTLCRHWrEn),
                    .UTLCRMWrEn       (UTLCRMWrEn),
                    .UTLCRLWrEn       (UTLCRLWrEn),
                    .UTCRWrEn         (UTCRWrEn),
                    .UTFORCEDERRSWrEn (UTFORCEDERRSWrEn),
                    .UTSETPINSWrEn    (UTSETPINSWrEn),
                    .UTBITSFTDATAWrEn (UTBITSFTDATAWrEn),
                    .UTSFTDATA2WrEn   (UTSFTDATA2WrEn),
                    .UTCLKREGWrEn     (UTCLKREGWrEn),
                    .RSTMODEREGWrEn   (RSTMODEREGWrEn),
                    .UTDMACRWrEn      (UTDMACRWrEn),
                    .UTSTPARITYWrEn   (UTSTPARITYWrEn),
                    .UTFBRDWrEn       (UTFBRDWrEn),
                    .PWDATAIn         (PWDATAIn),
                    .TXDMACLRStag4    (TXDMACLRStag4),
                    .RXDMACLRStag4    (RXDMACLRStag4),
                    .UTFORCEDERRS     (UTFORCEDERRS),
                    .UTLCRH           (UTLCRH),
                    .UTLCRM           (UTLCRM),
                    .UTLCRL           (UTLCRL),
                    .UTILPR           (UTILPR),
                    .UTCR             (UTCR),
                    .UTSETPINS        (UTSETPINS),
                    .UTBITSFTDATA     (UTBITSFTDATA),
                    .UTBITSFTDATA2    (UTBITSFTDATA2),
                    .UTCLKREG         (UTCLKREG),
                    .RSTMODEREG       (RSTMODEREG),
                    .UTDMACR          (UTDMACR),
                    .UTSTPARITY       (UTSTPARITY),
                    .UTFBRD           (UTFBRD)
                    );
 
//------------------------------------------------------------------------------
// This block provides the interface to the APB bus
//------------------------------------------------------------------------------
UartTrApbif uUartTrApbif              (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PENABLE          (PENABLE),
                    .PSELT            (PSELT),
                    .PWRITE           (PWRITE),
                    .PADDR            (PADDR),
                    .PWDATA           (PWData),
                    .UTLCRHWrEn       (UTLCRHWrEn),
                    .UTLCRMWrEn       (UTLCRMWrEn),
                    .UTLCRLWrEn       (UTLCRLWrEn),
                    .PWDATAIn         (PWDATAIn),
                    .UTDRWrEn         (UTDRWrEn),
                    .UTCRWrEn         (UTCRWrEn),
                    .UTSETPINSWrEn    (UTSETPINSWrEn),
                    .RSTMODEREGWrEn   (RSTMODEREGWrEn),
                    .UTDMACRWrEn      (UTDMACRWrEn),
                    .UTSTPARITYWrEn   (UTSTPARITYWrEn),
                    .UTFBRDWrEn       (UTFBRDWrEn),
                    .UTCLKREGWrEn     (UTCLKREGWrEn),
                    .UTFORCEDERRSWrEn (UTFORCEDERRSWrEn),
                    .UTBITSFTDATAWrEn (UTBITSFTDATAWrEn),
                    .UTSFTDATA2WrEn   (UTSFTDATA2WrEn),
                    .UTLCRH           (UTLCRH),
                    .UTLCRM           (UTLCRM),
                    .PRDATA           (PRData),
                    .PCLKOn           (PCLKOn),
                    .REFCLKOn         (REFCLKOn),
                    .UTLCRL           (UTLCRL),
                    .UTBITSFTDATA     (UTBITSFTDATA),
                    .UTBITSFTDATA2    (UTBITSFTDATA2),
                    .RSTMODEREG       (RSTMODEREG),
                    .RCVPE            (RCVPE),
                    .RCVFE            (RCVFE),
                    .IrdaRCVFE        (IrdaRCVFE),
                    .IrdaRCVPE        (IrdaRCVPE),
                    .TXHE             (TXHE),
                    .RXHF             (RXHF),
                    .UTCR             (UTCR),
                    .TXFE             (TXFE),
                    .RXFF             (RXFF),
                    .TXFF             (TXFF),
                    .RXFE             (RXFE),
                    .TXFRdPtrInc      (TXFRdPtrInc),
                    .UartTXFRdPtrInc  (UartTXFRdPtrInc),
                    .IrdaTXFRdPtrInc  (IrdaTXFRdPtrInc),
                    .TXBUSY           (TXBUSY),
                    .UartRXBUSY       (UartRXBUSY),
                    .UartTXBUSY       (UartTXBUSY),
                    .IrdaRXBUSY       (IrdaRXBUSY),
                    .IrdaTXBUSY       (IrdaTXBUSY),
                    .UARTINTR         (UARTINTR),
                    .UARTEINTR        (UARTEINTR),
                    .RTIS             (UARTRTINTR),
                    .TIS              (UARTTXINTR),
                    .RIS              (UARTRXINTR),
                    .MIS              (UARTMSINTR),
                    .UARTTXDMASREQ    (UARTTXDMASREQ),
                    .UARTTXDMABREQ    (UARTTXDMABREQ),
                    .UARTRXDMASREQ    (UARTRXDMASREQ),
                    .UARTRXDMABREQ    (UARTRXDMABREQ),
                    .SPNUM            (SPNUM),
                    .EPNUM            (EPNUM),
                    .SHFT             (SHFT),
                    .PSHFT            (PSHFT),
                    .PNUM             (PNUM),
                    .RXFRdData        (RXFRdData[7:0]),
                    .RXFRdPtrInc      (RXFRdPtrInc),
                    .nSIROUT          (nSIROUT),
                    .nUARTOut2        (nUARTOut2),
                    .nUARTOut1        (nUARTOut1),
                    .nUARTRTS         (nUARTRTS),
                    .nUARTDTR         (nUARTDTR),
                    .UARTTXD          (UARTTXD),
                    .UTILPRWrEn       (UTILPRWrEn),
                    .UTILPR           (UTILPR),
                    .FREQERR          (FREQERR),
                    .UTFORCEDERRS     (UTFORCEDERRS),
                    .UTSETPINS        (UTSETPINS),
                    .UTSTPARITY       (UTSTPARITY),
                    .UTFBRD           (UTFBRD)
                    );

//------------------------------------------------------------------------------
// Uart Baudwidth Checker
//------------------------------------------------------------------------------
UartTrBaud uUartTRBaud                (
                    .UARTCLK          (UARTCLK),
                    .Mode             (Mode),
                    .RXD              (UARTTXD),
                    .SIRIN            (nSIROUT),
                    .CLKPERIOD        (UTCLKREG),
                    .Divisor          (Divisor),
                    .FracDiv          (FracDiv),
                    .IRLPDivisor      (UTILPR),
                    .FRENABLE         (UTCR[7]),
                    .FREQERR          (FREQERR)
   );
 
//------------------------------------------------------------------------------
// UART Receiver
//------------------------------------------------------------------------------
UartTrRX uUartTrRX                    (
                    .RXD              (UARTTXD),
                    .UARTCLK          (UARTCLK),
                    .nUARTRES         (nUARTRES),
                    .RXBUSY           (UartRXBUSY),
                    .RXFWr            (RXFWr),
                    .RXFWrDone        (RXFWrDone),
                    .RXFIFOData       (RXFIFOData),
                    .WLEN             (UTLCRH[6:5]),
                    .STP2             (UTLCRH[3]),
                    .EPS              (UTLCRH[2]),
                    .PEN              (UTLCRH[1]),
                    .SPS              (UTSTPARITY[7]),
                    .UARTEN           (UTCR[0]),
                    .RCVFE            (RCVFE),
                    .RCVPE            (RCVPE),
                    .Mode             (Mode),
                    .Divisor          (Divisor),
                    .FracDiv          (FracDiv),
                    .RxJitterSign     (UTFORCEDERRS[7]),
                    .RxJitterFactor   (UTFORCEDERRS[6:5]),
                    .FEN              (UTLCRH[4])
                    );

UartTrRXFIFO uUartTrRXFIFO            (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .RXFWr            (RXFWr),
                    .IrdaRXFWr        (IrdaRXFWr),
                    .IrdaRXFIFOData   (IrdaRXFIFOData),
                    .RXFRdPtrInc      (RXFRdPtrInc),
                    .RXFIFOData       (RXFIFOData),
                    .FEN              (UTLCRH[4]),
                    .UTCR             (UTCR[1:0]),
                    .RXFWrDone        (RXFWrDone),
                    .RXFE             (RXFE),
                    .RXFF             (RXFF),
                    .RXHF             (RXHF),
                    .RXFRdData        (RXFRdData)
                    );
  
//------------------------------------------------------------------------------
// Transmit FIFO
//------------------------------------------------------------------------------
UartTrTXFIFO uUartTrTXFIFO            (
                    .UARTDRWrEn       (UTDRWrEn),
                    .PCLK             (PCLK),
                    .PWDATAIn         (PWDATAIn),
                    .TXFRdPtrInc      (TXFRdPtrInc),
                    .PRESETn          (PRESETn),
                    .FEN              (UTLCRH[4]),
                    .TXFF             (TXFF),
                    .TXHE             (TXHE),
                    .RdPtrIncDone     (RdPtrIncDone),
                    .TXShiftData      (TXShiftData),
                    .TXDataAvlbl      (TXDataAvlbl),
                    .UARTEN           (UTCR[0]),
                    .TXFE             (TXFE),
                    .TXBUSY           (TXBUSY)
                    );

//------------------------------------------------------------------------------
// Irda Receiver
//------------------------------------------------------------------------------
UartTrIrdaRX uUartTrIrdaRX            (
                    .UARTCLK          (UARTCLK),
                    .nUARTRES         (nUARTRES),
                    .RXBUSY           (IrdaRXBUSY),
                    .nSIRIN           (nSIROUT),
                    .IRLPDivisor      (UTILPR),
                    .WLEN             (UTLCRH[6:5]),
                    .EPS              (UTLCRH[2]),
                    .PEN              (UTLCRH[1]),
                    .STP2             (UTLCRH[3]),
                    .UARTEN           (UTCR[0]),
                    .RXFWr            (IrdaRXFWr),
                    .RXFWrDone        (RXFWrDone),
                    .RXFIFOData       (IrdaRXFIFOData),
                    .RCVFE            (IrdaRCVFE),
                    .RCVPE            (IrdaRCVPE),
                    .Mode             (Mode),
                    .Divisor          (Divisor),
                    .RxJitterSign     (UTFORCEDERRS[7]),
                    .RxJitterFactor   (UTFORCEDERRS[6:5]),
                    .FEN              (UTLCRH[4]),
                    .FracDiv          (FracDiv)
                    );
 
//------------------------------------------------------------------------------
// IRDA Transmitter
//------------------------------------------------------------------------------
UartTrIrdaTX uUartTrIrdaTX            (
                    .UARTCLK          (UARTCLK),
                    .nUARTRES         (nUARTRES),
                    .TXDataAvlbl      (TXDataAvlbl),
                    .TXFRdPtrInc      (IrdaTXFRdPtrInc),
                    .TXBUSY           (IrdaTXBUSY),
                    .RdPtrIncDone     (RdPtrIncDone),
                    .UARTEN           (UTCR[0]),
                    .UTSETPINS        (UTSETPINS[4]),
                    .PEEN             (UTFORCEDERRS[0]),
                    .FEEN             (UTFORCEDERRS[1]),
                    .UTLCRH           (UTLCRH),
                    .IRDADEC          (UTCR[6:3]),
                    .IRLPDivisor      (UTILPR),
                    .UTBITSFTDATA     (UTBITSFTDATA),
                    .UTBITSFTDATA2    (UTBITSFTDATA2),
                    .Mode             (Mode),
                    .Divisor          (Divisor),
                    .TxJitterSign     (UTFORCEDERRS[4]),
                    .TxJitterFactor   (UTFORCEDERRS[3:2]),
                    .SIROUT           (nSIRIN),
                    .WLEN             (UTLCRH[6:5]),
                    .EPS              (UTLCRH[2]),
                    .TXShiftData      (TXShiftData)
                    );
 
//------------------------------------------------------------------------------
// UART Transmitter
//------------------------------------------------------------------------------
UartTrTX uUartTrTX                    (
                    .UARTCLK          (UARTCLK),
                    .nUARTRES         (nUARTRES),
                    .TXDataAvlbl      (TXDataAvlbl),
                    .TXD              (TXD),
                    .TXFRdPtrInc      (UartTXFRdPtrInc),
                    .TXBUSY           (UartTXBUSY),
                    .RdPtrIncDone     (RdPtrIncDone),
                    .UARTEN           (UTCR[0]),
                    .UTSETPINS        (UTSETPINS[3]),
                    .UTLCRH           (UTLCRH),
                    .Mode             (Mode ),
                    .PEEN             (UTFORCEDERRS[0]),
                    .FEEN             (UTFORCEDERRS[1]),
                    .SPS              (UTSTPARITY[7]),
                    .Divisor          (Divisor),
                    .TxJitterSign     (UTFORCEDERRS[4]),
                    .TxJitterFactor   (UTFORCEDERRS[3:2]),
                    .WLEN             (UTLCRH[6:5]),
                    .EPS              (UTLCRH[2]),
                    .TXShiftData      (TXShiftData)
           );
 
//------------------------------------------------------------------------------
// UART DMA Interface
//------------------------------------------------------------------------------
UartTrDMA uUartTrDMA                  (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .TXDMACLRStag1    (UTDMACR[0]),
                    .RXDMACLRStag1    (UTDMACR[1]),
                    .UARTTXDMACLR     (UARTTXDMACLR),
                    .UARTRXDMACLR     (UARTRXDMACLR),
                    .TXDMACLRStag4    (TXDMACLRStag4),
                    .RXDMACLRStag4    (RXDMACLRStag4)
                    );
   
endmodule

//============================== End of UartTrick  ==========================--
