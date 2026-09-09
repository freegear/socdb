// ========================================================================== --
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
//  File Name              : UartTrApbif.v.rca
//  File Revision          : 1.4
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
//------------------------------------------------------------------------------
// Purpose     : This block generates decodes for Register accesses
//  
// ========================================================================== --
//  
`timescale 1ns/1ps
 
// Include Parameter File
//  ----------------------------------------------------------------------------

module UartTrApbif (
// Inputs
                    PCLK,
                    PRESETn,
                    PSELT,
                    PENABLE,
                    PWRITE,
                    nSIROUT,
                    nUARTOut2,
                    nUARTOut1,
                    nUARTRTS,
                    nUARTDTR,
                    UARTTXD,
                    RCVPE,
                    RCVFE,
                    IrdaRCVPE,
                    IrdaRCVFE,
                    RXFF,
                    TXFF,
                    RXFE,
                    TXHE,
                    TXFE,
                    RXHF,
                    PCLKOn,
                    REFCLKOn,
                    UartRXBUSY,
                    UartTXBUSY,
                    IrdaRXBUSY,
                    IrdaTXBUSY,
                    IrdaTXFRdPtrInc,
                    UartTXFRdPtrInc,
                    UARTINTR,
                    UARTEINTR,
                    UARTTXDMASREQ,
                    UARTTXDMABREQ,
                    UARTRXDMASREQ,
                    UARTRXDMABREQ,
                    RTIS,
                    TIS,
                    RIS,
                    MIS,
                    FREQERR,
                    PADDR,
                    PWDATA,
                    UTLCRH,
                    UTLCRM,
                    UTLCRL,
                    SPNUM,
                    EPNUM,
                    SHFT,
                    PNUM,
                    PSHFT,
                    RXFRdData,
                    UTCR,
                    UTILPR,
                    UTFORCEDERRS,
                    UTSETPINS,
                    UTBITSFTDATA,
                    UTBITSFTDATA2,
                    RSTMODEREG,
                    UTSTPARITY,
                    UTFBRD,
// Outputs
                    TXFRdPtrInc,
                    TXBUSY,
                    UTDRWrEn,
                    UTLCRHWrEn,
                    UTLCRMWrEn,
                    UTLCRLWrEn,
                    UTCRWrEn,
                    UTILPRWrEn,
                    UTFORCEDERRSWrEn,
                    UTSETPINSWrEn,
                    UTBITSFTDATAWrEn,
                    UTSFTDATA2WrEn,
                    UTCLKREGWrEn,
                    RSTMODEREGWrEn,
                    UTDMACRWrEn,
                    UTSTPARITYWrEn,
                    UTFBRDWrEn,
                    RXFRdPtrInc,
                    PWDATAIn,
                    PRDATA
                   );

// Inputs
input         PCLK;             // APB Bus clock
input         PRESETn;          // AMBA Reset
input         PSELT;            // APB Peripheral select
input         PENABLE;          // APB Peripheral enable
input         PWRITE;           // APB Write
input         nSIROUT;          // SiR transmit output
input         nUARTOut2;        // Modem signal
input         nUARTOut1;        // Modem signal
input         nUARTRTS;         // Modem signal
input         nUARTDTR;         // Modem signal    
input         UARTTXD;          // UT Transmit line
input         RCVPE;            // UT Parity Error
input         RCVFE;            // UT Frame Error
input         IrdaRCVPE;        // Parity Error in Irda mode
input         IrdaRCVFE;        // UT Irda Frame Error
input         RXFF;             // RX FIFO Full
input         TXFF;             // TX FIFO Full
input         RXFE;             // RX FIFO Empty
input         TXHE;             // TX FIFO LE Half Empty
input         TXFE;             // TX FIFO Empty
input         RXHF;             // RX FIFO GE Half Full
input         PCLKOn;           // PCLK Routing Status
input         REFCLKOn;         // UartClock Routing Status
input         UartRXBUSY;       // Uart Reception in progress
input         UartTXBUSY;       // UT Uart Transmission in progress
input         IrdaRXBUSY;       // Irda Reception in progress
input         IrdaTXBUSY;       // UT Irda Transmission in progress
input         IrdaTXFRdPtrInc;  // Irda Read Ptr Inc
input         UartTXFRdPtrInc;  // Uart Read Ptr Inc
input         UARTINTR;         // Uart Interrupt from UUT
input         UARTEINTR;        // Uart Error Interrupt from UUT
input         UARTTXDMASREQ;    // Transmit DMA single request
input         UARTTXDMABREQ;    // Transmit DMA burst request
input         UARTRXDMASREQ;    // Receive DMA single request
input         UARTRXDMABREQ;    // Receive DMA burst request
input         RTIS;             // Timeout Interrupt from UUT
input         TIS;              // Transmit Interrupt from UUT
input         RIS;              // Receive Interrupt from UUT
input         MIS;              // Modem Interrupt from UUT
input         FREQERR;          // Error in baud rate
input   [7:2] PADDR;            // APB Addr bus
input   [7:0] PWDATA;           // Wr databus
input   [7:0] UTLCRH;           // Trickbox LCRH
input   [7:0] UTLCRM;           // Trickbox LCRM
input   [7:0] UTLCRL;           // Trickbox LCRL
input   [2:0] SPNUM;            // Start Pulse 
input   [2:0] EPNUM;            // End Pulse No
input   [1:0] SHFT;             // Shift factor
input   [2:0] PNUM;             // Pulse No
input   [2:0] PSHFT;            // Pulse Shift 
input   [7:0] RXFRdData;        // FIFO Rd data 
input   [7:0] UTCR;             // UTControl Reg
input   [7:0] UTILPR;           // Irda LPR Reg
input   [7:0] UTFORCEDERRS;     // Forcing Error
input   [7:0] UTSETPINS;        // Setting Pins
input   [7:0] UTBITSFTDATA;     // Shift Pulse Reg
input   [5:0] UTBITSFTDATA2;    // Shift Pulse 2
input   [3:0] RSTMODEREG;       // Reset Mode Reg
input   [7:0] UTSTPARITY;       // STPARITY reg
input   [5:0] UTFBRD;           // FBRD reg

// Outputs
output        TXFRdPtrInc;      // Combined Read Ptr Inc
output        TXBUSY;           // Transmission in progress
output        UTDRWrEn;         // Trickbox Write Enable
output        UTLCRHWrEn;       // Write Enable for LCRH
output        UTLCRMWrEn;       // Write Enable for LCRM
output        UTLCRLWrEn;       // Write Enable for LCRL
output        UTCRWrEn;         // Write Enable for Trickbox CR
output        UTILPRWrEn;       // Write Enable for ILPR
output        UTFORCEDERRSWrEn; // Write Enable for UTFORCEDERRS
output        UTSETPINSWrEn;    // Write Enable for UTSETPINS
output        UTBITSFTDATAWrEn; // Write Enable for UTBITSFTDATA
output        UTSFTDATA2WrEn;   // Write Enable for UTBITSFTDATA2
output        UTCLKREGWrEn;     // Write Enable for UTCLKREG
output        RSTMODEREGWrEn;   // Write Enable for UT Reset mode 
output        UTDMACRWrEn;      // Write Enable for UTDMACR 
output        UTSTPARITYWrEn;   // Write Enable for UTSTPARITY 
output        UTFBRDWrEn;       // Write Enable for UTFBRD 
output        RXFRdPtrInc;      // FIFO Read Ptr to be Incremented 
output  [7:0] PWDATAIn;         // Int PWDATA
output  [7:0] PRDATA;           // Read databus

// Inputs
wire          PCLK;             // APB Bus clock
wire          PRESETn;            // AMBA Reset
wire          PSELT;            // APB Peripheral select
wire          PENABLE;          // APB Peripheral enable
wire          PWRITE;           // APB Write
wire          nSIROUT;          // SiR transmit output
wire          nUARTOut2;        // Modem signal
wire          nUARTOut1;        // Modem signal
wire          nUARTRTS;         // Modem signal
wire          nUARTDTR;         // Modem signal    
wire          UARTTXD;          // UT Transmit line
wire          RCVPE;            // UT Parity Error
wire          RCVFE;            // UT Frame Error
wire          IrdaRCVPE;        // Parity Error in Irda mode
wire          IrdaRCVFE;        // UT Irda Frame Error
wire          RXFF;             // RX FIFO Full
wire          TXFF;             // TX FIFO Full
wire          RXFE;             // RX FIFO Empty
wire          TXHE;             // TX FIFO LE Half Empty
wire          TXFE;             // TX FIFO Empty
wire          RXHF;             // RX FIFO GE Half Full
wire          PCLKOn;           // PCLK Routing Status
wire          REFCLKOn;         // UartClock Routing Status
wire          UartRXBUSY;       // Uart Reception in progress
wire          UartTXBUSY;       // UT Uart Transmission in progress
wire          IrdaRXBUSY;       // Irda Reception in progress
wire          IrdaTXBUSY;       // UT Irda Transmission in progress
wire          IrdaTXFRdPtrInc;  // Irda Read Ptr Inc
wire          UartTXFRdPtrInc;  // Uart Read Ptr Inc
wire          UARTINTR;         // Uart Interrupt from UUT
wire          UARTEINTR;        // Uart Error Interrupt from UUT
wire          UARTTXDMASREQ;    // Transmit DMA single request
wire          UARTTXDMABREQ;    // Transmit DMA burst request
wire          UARTRXDMASREQ;    // Receive DMA single request
wire          UARTRXDMABREQ;    // Receive DMA burst request
wire          RTIS;             // Timeout Interrupt from UUT
wire          TIS;              // Transmit Interrupt from UUT
wire          RIS;              // Receive Interrupt from UUT
wire          MIS;              // Modem Interrupt from UUT
wire          FREQERR;          // Error in baud rate
wire    [7:2] PADDR;            // APB Addr bus
wire    [7:0] PWDATA;           // Wr databus
wire    [7:0] UTLCRH;           // Trickbox LCRH
wire    [7:0] UTLCRM;           // Trickbox LCRM
wire    [7:0] UTLCRL;           // Trickbox LCRL
wire    [2:0] SPNUM;            // Start Pulse 
wire    [2:0] EPNUM;            // End Pulse No
wire    [1:0] SHFT;             // Shift factor
wire    [2:0] PNUM;             // Pulse No
wire    [2:0] PSHFT;            // Pulse Shift 
wire    [7:0] RXFRdData;        // FIFO Rd data 
wire    [7:0] UTCR;             // UTControl Reg
wire    [7:0] UTILPR;           // Irda LPR Reg
wire    [7:0] UTFORCEDERRS;     // Forcing Error
wire    [7:0] UTSETPINS;        // Setting Pins
wire    [7:0] UTBITSFTDATA;     // Shift Pulse Reg
wire    [5:0] UTBITSFTDATA2;    // Shift Pulse 2
wire    [3:0] RSTMODEREG;       // Reset Mode Reg
wire    [7:0] UTSTPARITY;       // STPARITY reg
wire    [5:0] UTFBRD;           // FBRD reg
 
// Outputs
reg           TXFRdPtrInc;      // Combined Read Ptr Inc
reg           TXBUSY;           // Transmission in progress
wire          UTDRWrEn;         // Trickbox Write Enable
wire          UTLCRHWrEn;       // Write Enable for LCRH
wire          UTLCRMWrEn;       // Write Enable for LCRM
wire          UTLCRLWrEn;       // Write Enable for LCRL
wire          UTCRWrEn;         // Write Enable for Trickbox CR
wire          UTILPRWrEn;       // Write Enable for ILPR
wire          UTFORCEDERRSWrEn; // Write Enable for UTFORCEDERRS
wire          UTSETPINSWrEn;    // Write Enable for UTSETPINS
wire          UTBITSFTDATAWrEn; // Write Enable for UTBITSFTDATA
wire          UTSFTDATA2WrEn;   // Write Enable for UTBITSFTDATA2
wire          UTCLKREGWrEn;     // Write Enable for UTCLKREG
wire          RSTMODEREGWrEn;   // Write Enable for UT Reset mode 
wire          UTDMACRWrEn;      // Write Enable for UTDMACR 
wire          UTSTPARITYWrEn;   // Write Enable for UTSTPARITY 
wire          UTFBRDWrEn;       // Write Enable for UTFBRD 
wire          RXFRdPtrInc;      // FIFO Read Ptr to be Incremented 
wire    [7:0] PWDATAIn;         // Int PWDATA
reg     [7:0] PRDATA;           // Read databus

//------------------------------------------------------------------------------
//
//                             UartTrickboxApbif
//                             =================
//
//------------------------------------------------------------------------------
//
// Overview
// ========
// This module decodes APB accesses and generates the read/write 
// strobes to the appropriate registers.
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// Normal mode registers address constants.Address decode is for
// bits 2 to 7 (6 bits)
//------------------------------------------------------------------------------
`define UTDR              6'b000000
// UTDR at offset 0x00

`define UTRSRDec          6'b000001
// UTRSR at offset 0x04

`define UTLCRHDec         6'b000010
// UTLLCRH at offset 0x08

`define UTLCRMDec         6'b000011
// UTLCRM at offset 0x0C

`define UTLCRLDec         6'b000100
// UTLCRL at offset 0x10

`define UTCRDec           6'b000101
// UTCR at offset 0x14

`define UTINTRDec         6'b000110
// UTINTR at offset 0x18

`define UTFRDec           6'b000111
// UTFR at offset 0x1C

`define UTFREQCTRERRDec   6'b001000
//  UT_FREQ_CTR_ERRS at offset 0x20

`define UTFORCEDERRSDec   6'b001001
// UTFORCEDERRS  at offset 0x24
 
`define UTSETPINSDec      6'b001010
// UT_SET_PINS at offset 0x28
 
`define UTCHECKPINSDec    6'b001011
// UT_CHECK_PINS at offset 0x2C
 
`define UTILPRDec         6'b001100
// UTILPR at offset 0x30
 
`define UTBITSFTDATADec   6'b001101
// UT_BIT_SFT_DATA at offset 0x34
 
`define UTBITSFTDATA2Dec  6'b001110
// UT_BIT_SFT_DATA_2 at offset 0x38

`define UTCLKREGDec       6'b001111
// UTCLKREG at offset 0x3C
 
`define RSTMODEREGDec     6'b010000
// UT Reset mode Reg  at offset 0x40

`define UTDMACRDec        6'b010001
// UTDMACR at offset 0x44

`define UTSTPARITYDec     6'b010010
// UTSTPARITY at offset 0x48

`define UTFBRDDec         6'b010011
// UTFBRD at offset 0x4C


//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
wire  [7:2] GatedPADDR; 
// Save power by gating PADDR internally with PSEL

//------------------------------------------------------------------------------
// Read Decodes for Register reads
//------------------------------------------------------------------------------
wire   [1:0] NextUTRSR;
// D-input for Receive Status reg
  
wire   [7:0] NextUTINTR;
// D-input for Trickbox Interrupt Reg

wire   [7:0] NextUTFR;
// D-input for Trickbox Flag Reg

wire   [5:0] NextUTDMACR;
// D-input for DMA  Reg
 
reg          UTFREQCTRERR;
// Trickbox Frequency Error Reg

wire   [5:0] NextUTCHECKPINS;
// D-input for Trickbox Check pins Reg 
 
wire         RSTMODEREGrd;
// Reset mode REG Read

wire         UTDRrd;
// UTDR Read

wire         UTRSRrd;
// UTRSR Read

wire         UTLCRHrd;
// LCRH Read

wire         UTLCRMrd;
// LCRM Read

wire         UTLCRLrd;
// LCRL Read

wire         UTCRrd;
// UTCR Read

wire         UTFRrd;
// Flag register Read

wire         UTDMACRrd;
// DMACR  Read

wire         UTSTPARITYrd;
// STPARITY  Read

wire         UTFBRDrd;
// FBRD  Read

reg          ActualRCVFE;
// Multiplexed Frame Error

reg          ActualRCVPE;
// Multiplexed Parity Error
 
wire         UTINTRrd;                  
// Interrupt Identification register Read

wire         UTILPRrd;
// ILPR Read

wire         UTFREQCTRERRrd;
// FREQ_CTR_ERR Read

wire         UTFORCEDERRSrd;
// FORCEDERRS Read
  
wire         UTSETPINSrd;
// SET_PINS Read

wire         UTCHECKPINSrd;
// CHECK_PINS Read

wire         UTBITSFTDATArd;
// TBITSFT_DATA Read

wire         UTBITSFTDATA2rd;
// BITSFT_DATA_2 Read

wire   [7:0] NextPRDATA;    
// D-input of iPRDATA

reg    [7:0] UTINTR;
// Trickbox INTR Reg

reg    [1:0] UTRSR;
// RSR concatenation of bits

reg    [7:0] UTFR;
// Flag register concatenation of bits

reg    [5:0] UTDMACR;
// DMA register concatenation of bits

reg    [5:0] UTCHECKPINS; 
// CHECK_PINS  concatenation of bits

reg          RXBUSY;
// Reception in Progress

wire         WrEn;
// Write enable signal common to all addresses in the APB interface

wire         RdEn;
// Read enable signal common to all addresses in the APB interface

//------------------------------------------------------------------------------
//
// Main body of  code
// ==================
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Write Interface
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Save power by preventing change in internal data bus and 
// address bus when the device is not selected
//------------------------------------------------------------------------------
assign PWDATAIn         = ((PSELT ==  1'b1) && (PWRITE == 1'b1)) ?
                          PWDATA : 7'b0000000;
  
assign GatedPADDR       = (PSELT == 1'b1) ?
                          PADDR : 6'b000000;

assign WrEn             = PENABLE & PSELT & PWRITE;


assign UTLCRHWrEn       = ((WrEn == 1'b1) && (GatedPADDR == `UTLCRHDec)) ?
                          1'b1 : 1'b0;

assign UTLCRMWrEn       = ((WrEn == 1'b1) && (GatedPADDR == `UTLCRMDec)) ?
                          1'b1 : 1'b0;

assign UTLCRLWrEn       = ((WrEn == 1'b1) && (GatedPADDR == `UTLCRLDec)) ?
                          1'b1 : 1'b0;
 
assign UTDRWrEn         = ((WrEn == 1'b1) && (GatedPADDR == `UTDR)) ?
                          1'b1 : 1'b0;
  
assign UTCRWrEn         = ((WrEn == 1'b1) && (GatedPADDR == `UTCRDec)) ?
                          1'b1 : 1'b0;

assign UTILPRWrEn       = ((WrEn == 1'b1) && (GatedPADDR == `UTILPRDec)) ?
                          1'b1 : 1'b0;

assign UTFORCEDERRSWrEn = ((WrEn == 1'b1) && (GatedPADDR == `UTFORCEDERRSDec)) ?
                          1'b1 : 1'b0;

assign UTSETPINSWrEn    = ((WrEn == 1'b1) && (GatedPADDR == `UTSETPINSDec)) ?
                          1'b1 : 1'b0;
  
assign UTBITSFTDATAWrEn = ((WrEn == 1'b1) && (GatedPADDR == `UTBITSFTDATADec)) ?
                          1'b1 : 1'b0;

assign UTSFTDATA2WrEn   = ((WrEn == 1'b1) &&
                           (GatedPADDR == `UTBITSFTDATA2Dec)) ?
                          1'b1 : 1'b0;
 
assign UTCLKREGWrEn     = ((WrEn == 1'b1) && (GatedPADDR == `UTCLKREGDec)) ?
                          1'b1 : 1'b0;
 
assign RSTMODEREGWrEn   = ((WrEn == 1'b1) && (GatedPADDR == `RSTMODEREGDec)) ?
                          1'b1 : 1'b0;
 
assign UTDMACRWrEn      = ((WrEn == 1'b1) && (GatedPADDR == `UTDMACRDec)) ?
                          1'b1 : 1'b0;
 
assign UTSTPARITYWrEn   = ((WrEn == 1'b1) && (GatedPADDR == `UTSTPARITYDec)) ?
                          1'b1 : 1'b0;
 
assign UTFBRDWrEn       = ((WrEn == 1'b1) && (GatedPADDR == `UTFBRDDec)) ?
                          1'b1 : 1'b0;
 
//------------------------------------------------------------------------------
// Read interface
//------------------------------------------------------------------------------
assign RdEn             = PSELT & (!PWRITE); 
  
assign UTLCRHrd         = ((RdEn == 1'b1) && (GatedPADDR == `UTLCRHDec)) ?
                          1'b1 : 1'b0;

assign UTLCRMrd         = ((RdEn == 1'b1) && (GatedPADDR == `UTLCRMDec)) ?
                          1'b1 : 1'b0;

assign UTLCRLrd         = ((RdEn == 1'b1) && (GatedPADDR == `UTLCRLDec)) ?
                          1'b1 : 1'b0;

assign UTDRrd           = ((RdEn == 1'b1) && (GatedPADDR == `UTDR)) ?
                          1'b1 : 1'b0;

assign UTRSRrd          = ((RdEn == 1'b1) && (GatedPADDR == `UTRSRDec)) ?
                          1'b1 : 1'b0;

assign UTCRrd           = ((RdEn == 1'b1) && (GatedPADDR == `UTCRDec)) ?
                          1'b1 : 1'b0;

assign UTFRrd           = ((RdEn == 1'b1) && (GatedPADDR == `UTFRDec)) ?
                          1'b1 : 1'b0;

assign UTINTRrd         = ((RdEn == 1'b1) && (GatedPADDR == `UTINTRDec)) ?
                          1'b1 : 1'b0;

assign UTILPRrd         = ((RdEn == 1'b1) && (GatedPADDR == `UTILPRDec)) ?
                          1'b1 : 1'b0;

assign UTFREQCTRERRrd   = ((RdEn == 1'b1) && (GatedPADDR == `UTFREQCTRERRDec)) ?
                          1'b1 : 1'b0;

assign UTFORCEDERRSrd   = ((RdEn == 1'b1) && (GatedPADDR == `UTFORCEDERRSDec)) ?
                          1'b1 : 1'b0;

assign UTSETPINSrd      = ((RdEn == 1'b1) && (GatedPADDR == `UTSETPINSDec)) ?
                          1'b1 : 1'b0;

assign UTCHECKPINSrd    = ((RdEn == 1'b1) && (GatedPADDR == `UTCHECKPINSDec)) ?
                          1'b1 : 1'b0;

assign UTBITSFTDATArd   = ((RdEn == 1'b1) && (GatedPADDR == `UTBITSFTDATADec)) ?
                          1'b1 : 1'b0;

assign UTBITSFTDATA2rd  = ((RdEn == 1'b1) && 
                           (GatedPADDR == `UTBITSFTDATA2Dec)) ?
                          1'b1 : 1'b0;
  
assign RSTMODEREGrd     = ((RdEn == 1'b1) && (GatedPADDR == `RSTMODEREGDec)) ?
                          1'b1 : 1'b0;

assign UTDMACRrd        = ((RdEn == 1'b1) && (GatedPADDR == `UTDMACRDec)) ?
                          1'b1 : 1'b0;

assign UTSTPARITYrd     = ((RdEn == 1'b1) && (GatedPADDR == `UTSTPARITYDec)) ?
                          1'b1 : 1'b0;

assign UTFBRDrd         = ((RdEn == 1'b1) && (GatedPADDR == `UTFBRDDec)) ?
                          1'b1 : 1'b0;

assign NextUTRSR        = {ActualRCVFE, ActualRCVPE}; 

assign NextUTFR         = {RXBUSY, TXBUSY, TXFF, TXHE, TXFE, RXFF, RXHF,
                           RXFE};


assign NextUTINTR       = {((RTIS | TIS | RIS | MIS | UARTEINTR) ^  UARTINTR),
                           1'b0, UARTEINTR, UARTINTR, RTIS, TIS, RIS, MIS};

assign NextUTCHECKPINS  = {nUARTOut2, nUARTOut1, nUARTRTS, nUARTDTR, nSIROUT,
                           UARTTXD};

assign NextUTDMACR      = {UARTRXDMABREQ, UARTTXDMABREQ, UARTRXDMASREQ,
                           UARTTXDMASREQ, 2'b00};
 
//------------------------------------------------------------------------------
// Increment the Read pointer in the RX FIFO after every read from
// the UTDR register i.e.  after every read from the Receive FIFO
//------------------------------------------------------------------------------
assign RXFRdPtrInc      = PENABLE & UTDRrd;

// Output Mux     
assign NextPRDATA       = (UTDRrd == 1'b1) ?
                           RXFRdData : ((UTRSRrd == 1'b1) ?
                           {6'b000000, UTRSR} : ((UTLCRHrd == 1'b1) ?
                           UTLCRH : ((UTLCRMrd == 1'b1) ?
                           UTLCRM : ((UTLCRLrd == 1'b1) ?
                           UTLCRL : ((UTCRrd == 1'b1) ?
                           UTCR : ((UTFRrd == 1'b1) ?
                           UTFR : ((UTINTRrd == 1'b1) ?
                           UTINTR : ((UTILPRrd == 1'b1) ?
                           UTILPR : ((UTFREQCTRERRrd == 1'b1) ?
                           {7'b0000000, UTFREQCTRERR} :
                           ((UTFORCEDERRSrd == 1'b1) ?
                           UTFORCEDERRS : ((UTSETPINSrd == 1'b1) ?
                           UTSETPINS : ((UTCHECKPINSrd == 1'b1) ?
                           {2'b00, UTCHECKPINS} : ((UTBITSFTDATArd == 1'b1) ?
                           UTBITSFTDATA : ((UTBITSFTDATA2rd == 1'b1) ?
                           {2'b00, UTBITSFTDATA2} : ((RSTMODEREGrd == 1'b1) ?
                           {2'b00, PCLKOn, REFCLKOn, RSTMODEREG} :
                           ((UTDMACRrd == 1'b1) ?
                           {2'b00, UTDMACR} : ((UTSTPARITYrd == 1'b1) ?
                           UTSTPARITY : ((UTFBRDrd == 1'b1) ?
                           {2'b00, UTFBRD} : 8'h00))))))))))))))))));

//------------------------------------------------------------------------------
// Multiplexing Parity and Frame Errors of the Uart and Irda modules in 
// trickbox
//------------------------------------------------------------------------------
always @(UTCR or IrdaRCVPE or IrdaRCVFE or RCVFE or RCVPE or IrdaRXBUSY or
         IrdaTXBUSY or IrdaTXFRdPtrInc or UartRXBUSY or UartTXBUSY or
         UartTXFRdPtrInc)
begin : p_modeComb
  if (UTCR[0] == 1'b1)
    if (UTCR[1] == 1'b1)
      begin
        RXBUSY      <= IrdaRXBUSY;
        TXBUSY      <= IrdaTXBUSY;
        TXFRdPtrInc <= IrdaTXFRdPtrInc; 
        ActualRCVFE <= IrdaRCVFE;
        ActualRCVPE <= IrdaRCVPE;
      end
    else
      begin
        RXBUSY      <= UartRXBUSY;
        TXBUSY      <= UartTXBUSY;
        TXFRdPtrInc <= UartTXFRdPtrInc;
        ActualRCVPE <= RCVPE;
        ActualRCVFE <= RCVFE;
      end
   else
     begin
       ActualRCVFE <= 1'b0;
       ActualRCVPE <= 1'b0;
     end
end // p_modeComb
 
//------------------------------------------------------------------------------
// Output register . This register is the APB data register from which all
// the other registers can be read 
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_RdSeq
  if (PRESETn == 1'b0)
    PRDATA  <= 8'h00;
  else
    PRDATA  <= NextPRDATA;
end // p_RdSeq
   
//------------------------------------------------------------------------------
// Output register . This register stores  the current status of UUT
// interrupt pins and also stores the combined interrupt generated from
// the other UUT interrupts 
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_IntSeq
  if (PRESETn == 1'b0)
    UTINTR   <= 8'h00;
  else
    UTINTR <= NextUTINTR;
end // p_IntSeq
 
//------------------------------------------------------------------------------
// Output register . This register stores the status of trickbox flags 
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_FRSeq
  if (PRESETn == 1'b0)
    UTFR  <= 8'h00;
  else
    UTFR  <= NextUTFR;
end // p_FRSeq
 
//------------------------------------------------------------------------------
// Output register . This register stores the status of errors during 
// baud rate measurement 
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_CTRSeq
  if (PRESETn == 1'b0)
    UTFREQCTRERR  <=  1'b0;
  else
    UTFREQCTRERR  <= FREQERR;
end // p_CTRSeq
 
//------------------------------------------------------------------------------
// Output register . This register stores the status of Trickbox transmitted 
// data in all the modes  
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_PINSSeq
  if (PRESETn == 1'b0)
    UTCHECKPINS  <= 6'b000000;
  else
    UTCHECKPINS  <= NextUTCHECKPINS;
end // p_PINSSeq
 
//------------------------------------------------------------------------------
// Output register . This register stores the parity and stop bit errors 
// in the received data in all the modes 
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_RXSSeq
  if (PRESETn == 1'b0)
    UTRSR  <=  6'b000000;
  else
    UTRSR  <= NextUTRSR;
end // p_RXSSeq
 
//------------------------------------------------------------------------------
// Output register . This register stores the DMA request signals and
// the DMA clear signals.
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_DMASeq
  if (PRESETn == 1'b0)
    UTDMACR  <= 6'b000000;
  else
    UTDMACR  <= NextUTDMACR;
end // p_DMASeq
 
//------------------------------------------------------------------------------

endmodule

//========================== End of UartTrApbif ==============================--
