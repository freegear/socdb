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
//  File Name              : SciTrApbif.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Purpose     : This block generates decodes for Register accesses
//
//------------------------------------------------------------------------------
`timescale 1ns/1ps

//------------------------------------------------------------------------------

module SciTrApbif 
        (PCLK,
        PRESETn,
        PSELT,
        PENABLE,
        PWRITE,
        PADDR,
        PWDATA,
        RxFRdData,
        SCITrCR,
        SCITrFiLCR,
        SCITrCTRL,
        SCITrTXPC,
        SCITrRXPC,
        SCITrTFF,
        SCITrTFE,
        SCITrTFR,
        SCITrRFF,
        SCITrRFE,
        SCITrRFR,
        SCITrAT,
        SCITrDT,
        SCITrTXBLKG,
        SCITrTXCHG,
        SCITrCKICC,
        SCITrBAUD,
        SCITrVALUE,
        SCITrRXCHG,
        SCITrRXBLKG,
        SCITrRFCK,
        SCITrWV,
        SCITrJit,
        SCITrJitPat,
        PCLKOn,
        REFCLKOn,
        SCICARDININTR,
        SCICARDOUTINTR,
        SCICARDUPINTR,
        SCICARDDNINTR,
        SCITXERRINTR,
        SCIATRSTOUTINTR,
        SCIATRDTOUTINTR,
        SCIBLKTOUTINTR,
        SCICHTOUTINTR,
        SCITXTIDEINTR,
        SCIRXTIDEINTR,
        SCIRTOUTINTR,
        SCIRORINTR,
        SCICLKSTPINTR,
        SCICLKACTINTR,
        SCIINTR,
        SCITrDATAWrEn ,
        SCITrCRWrEn,
        SCITrFiLCRWrEn,
        SCITrTXPCWrEn,
        SCITrRXPCWrEn,
        SCITrCTRLWrEn,
        SCITrATWrEn,
        SCITrDTWrEn,
        SCITrTXBLKGWrEn,
        SCITrTXCHGWrEn,
        SCITrCKICCWrEn,
        SCITrBAUDWrEn,
        SCITrVALUEWrEn,
        SCITrRXCHGWrEn,
        SCITrRXBLKGWrEn,
        SCITrRFCKWrEn,
        SCITrWVWrEn,
        SCITrJitWrEn,
        SCITrJitPatWrEn,
        SCITrRFCNTLWrEn,
        SCIDEACACK,
        RxFRdPtrInc,
        PWDATAIn,
        PRDATA,

        SCITXDMASREQ,
        SCITXDMABREQ,
        SCIRXDMASREQ,
        SCIRXDMABREQ,

        SCITrDMAWr
        );

input         PCLK;               
input         PRESETn;            // Bus Reset 
input         PSELT;              // APB Peripheral Select
input         PENABLE;            // APB Peripheral Enable
input         PWRITE;             // APB Peripheral Write
input   [7:2] PADDR;              // APB Addr Bus
input  [15:0] PWDATA;             // Wr  Data Bus
input   [8:0] RxFRdData;          // Rx FIFO data
input  [15:0] SCITrCR; // Control reg
input   [7:0] SCITrFiLCR;// FIFO level 
input   [7:0] SCITrCTRL;  // Er massage 
input   [3:0] SCITrTXPC;  // TX Retry reg
input   [3:0] SCITrRXPC;  // RX Retry reg
input         SCITrTFF;     // TX Full Flag
input         SCITrTFE;     // TX Empty Flag
input         SCITrTFR;     // TX level Flag
input         SCITrRFF;     // RX Full Flag
input         SCITrRFE;     // RX Empty Flag
input         SCITrRFR;     // RX level Flag
input  [15:0] SCITrAT; // ACTtime reg
input  [15:0] SCITrDT; // DEACTtim reg
input   [7:0] SCITrTXBLKG;  // TXBLKGrd reg
input   [7:0] SCITrTXCHG;  // TXCHGrd reg
input  [15:0] SCITrCKICC; // Clk freq reg
input  [15:0] SCITrBAUD; // Baud reg
input   [7:0] SCITrVALUE;  // Value reg
input   [7:0] SCITrRXCHG;  // RXCHGRD reg
input   [7:0] SCITrRXBLKG;  // RXBGUrd reg
input  [15:0] SCITrRFCK; // RXBLKGrd reg
input   [7:0] SCITrWV;  // RFCLK reg
input  [15:0] SCITrJit; // Jit Cnt reg
input   [9:0] SCITrJitPat;  // Jit val reg
input         PCLKOn;     // PCLK on 
input         REFCLKOn ;     // REFCLK on 
input         SCICARDININTR;     // CARDIN intr
input         SCICARDOUTINTR;     // CARDOUT intr
input         SCICARDUPINTR;     // CARDUP intr
input         SCICARDDNINTR;     // CARDDN intr
input         SCITXERRINTR;     // TXERR intrr
input         SCIATRSTOUTINTR;     // ATRSTOUT  intr
input         SCIATRDTOUTINTR;     // ATRDTOUT intr
input         SCIBLKTOUTINTR;     // BLKTIMEOUT intr
input         SCICHTOUTINTR;     // CHTIMEOUT intr
input         SCITXTIDEINTR;     // TXTIDE intr
input         SCIRXTIDEINTR;     // RXTIDE intr
input         SCIRTOUTINTR;     // Rx FIFO read timeout intr
input         SCIRORINTR;       // Rx OverRun intr
input         SCICLKSTPINTR;    // Clock stopped intr
input         SCICLKACTINTR;   // Clock active intr
input         SCIINTR;     // Intr
input         SCIDEACACK;     // Intr
input         SCITXDMASREQ;    // Transmit DMA single request
input         SCITXDMABREQ;    // Transmit DMA burst  request
input         SCIRXDMASREQ;    // Receive  DMA single request
input         SCIRXDMABREQ;    // Receive  DMA burst  request

output        SCITrDATAWrEn;     // Data Wr En
output        SCITrCRWrEn;     // Control Reg Wr En
output        SCITrFiLCRWrEn;     // FiFO level Reg Wr En
output        SCITrTXPCWrEn;     // TX Retray Cnt Wr En
output        SCITrRXPCWrEn;     // RX Retray Cnt Wr En
output        SCITrCTRLWrEn;     // Error massage enable Wr En
output        SCITrATWrEn;     // ATIME Wr En
output        SCITrDTWrEn;     // DTIME Wr En
output        SCITrTXBLKGWrEn;     // TXBLKGuard Wr En
output        SCITrTXCHGWrEn;     // TXCHTGuard Wr En
output        SCITrCKICCWrEn;     // CLKICC Wr En
output        SCITrBAUDWrEn;     // Baud Wr En
output        SCITrVALUEWrEn;     // Value Wr En
output        SCITrRXCHGWrEn;     // RXCHGuard Wr En
output        SCITrRXBLKGWrEn;     // RXBLKGuard Wr En
output        SCITrRFCKWrEn;     // REFCLK Wr En
output        SCITrWVWrEn;     // ErMargin Wr En
output        SCITrJitWrEn;     // Jit value Reg Wr En
output        SCITrJitPatWrEn;     // Jit Control Wr En
output        SCITrRFCNTLWrEn;     // REFCLK Gen Cnt Wr En
output        RxFRdPtrInc;     // Rx FIFO Rd ptr Inc
output [15:0] PWDATAIn; // Int PWDATA
output [15:0] PRDATA;  // Read data 
output        SCITrDMAWr;  // Write Enable for SCITDMACR

//-----------------------------------------------------------------------------
//
//
//                         SciTrApbif
//                         ========== 
//
//-----------------------------------------------------------------------------
//
// Overview    
// ========
// This module decodes APB accesses && generates the read/write 
// strobe to the appropriate registers.
//
//-----------------------------------------------------------------------------
//                         SciTr Register Map
//-----------------------------------------------------------------------------
// Offset Register Type Width      Describtion   
//-----------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------
//


//------------------------------------------------------------------------------
// Component Declaration
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Constant declaration
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Trickbox registers address `defines.Address decode is for
// bits 2 to 7 [6 bits)
//------------------------------------------------------------------------------

`define ZEROFILL            16'b000000000000 
         
`define PADDR_SCITrDATA      6'b000000
// SCITrDATA at offset 0x00

`define PADDR_SCITrCR        6'b000001
// SCITrCR at offset 0x04

`define PADDR_SCITrFiLCR     6'b000010
// SCITrFiLCR at offset 0x08

`define PADDR_SCITrSR0       6'b000011
// SCITrSR0 at offset 0x0C

`define PADDR_SCITrSR1       6'b000100
// SCITrSR1 at offset 0x10

`define PADDR_SCITrSR2       6'b000101
// SCITrSR2 at offset 0x14

`define PADDR_SCITrTXPC      6'b000110
// SCITrTXPC at offset 0x18

`define PADDR_SCITrRXPC      6'b000111
// SCITrRXPC at offset 0x1C

`define PADDR_SCITrCTRL      6'b001000
// SCITrCTRL at offset 0x20

`define PADDR_SCITrAT        6'b001001
// SCITrAT at offset 0x24

`define PADDR_SCITrDT        6'b001010
// SCITrDT at offset 0x28

`define PADDR_SCITrCKICC     6'b001011
// SCITrCKICC at offset 0x2C

`define PADDR_SCITrBAUD      6'b001100
// SCITrBAUD at offset 0x30

`define PADDR_SCITrVALUE     6'b001101
// SCITrVALUE at offset 0x34

`define PADDR_SCITrTXCHG     6'b001110
// SCITrTXCHG at offset 0x38

`define PADDR_SCITrTXBG      6'b001111
// SCITrTXBLKG at offset 0x3C

`define PADDR_SCITrRXCHG     6'b010000
// SCITrRXCHG at offset 0x40

`define PADDR_SCITrRXBG      6'b010001
// SCITrRXBLKG at offset 0x44

`define PADDR_SCITrRFCK      6'b010010
// SCITrRFCK at offset 0x48

`define PADDR_SCITrWV        6'b010011
// SCITrWV at offset 0x4C

`define PADDR_SCITrJit       6'b010100
// SCITrJit at offset 0x50

`define PADDR_SCITrJitPt     6'b010101
// SCITrJitPat at offset 0x54

`define PADDR_RFCNTL         6'b010110
// SCITrRFCNTLR at offset 0x58

`define PADDR_SCITrDMA       6'b010111
// SCITrRFCNTLR at offset 0x5C


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
wire [7:2] GatedPADDR;
// Save power by gating PADDR internally with PSEL

//------------------------------------------------------------------------------
// Read Decodes for Register reads
//------------------------------------------------------------------------------
wire SCITrDATArd;  
// SCITrDATA Read

wire SCITrCRrd;
// SCITrCR Read 

wire SCITrFiLCRrd;
// SCITrFiL Read 

wire SCITrSR0rd;
// SCITrSR0 Read 

wire SCITrSR1rd;
// SCITrSR1 Read 

wire SCITrSR2rd;
// SCITrSR2 Read 

wire SCITrTXPCrd;
// SCITrTXPC Read 

wire SCITrRXPCrd;
// SCITrRXPC Read 

wire SCITrCTRLrd;
// SCITrCTRL Read 

wire SCITrATrd;
// SCITrAT Read 

wire SCITrDTrd;
// SCITrDT Read 

wire SCITrTXBLKGrd;
// SCITrTXBLKG Read 

wire SCITrTXCHGrd;
// SCITrTXCHG Read 

wire SCITrCKICCrd;
// SCITrCKICC Read 

wire SCITrBAUDrd;
// SCITrBAUD Read 

wire SCITrVALUErd;
// SCITrVALUE Read 

wire SCITrRXCHGrd;
// SCITrRXCHG Read 

wire SCITrRXBLKGrd;
// SCITrRXBLKG Read 

wire SCITrRFCKrd;
// SCITrRFCK Read
 
wire SCITrWVrd;
// SCITrWV Read
 
wire SCITrJitrd ;
// SCITrJit Read
 
wire SCITrJitPatrd;
// SCITrJitPat Read

wire SCITrRFCNTLrd;
// SCITrRFCNTRL Read
 
wire [15:0] NextPRDATA;
// D-input of iPRDATA

wire WrEn;
// Write enable signal common to all addresses in the APB interface

wire RdEn;
// Read enable signal common to all addresses in the APB interface
reg [15:0] PRDATA;

reg nSCIDAOUTEN;
// SciTrickbox Data out Enable

wire SCITrDMArd;
// SCITrDMA read

wire [5:0] SCITrDMA;
// DMA register concatenation of bits

wire [15:0] SCIINTERRUPTS;
// Interrupts register concatenation of bits

wire [5:0] TrFIFOSTATUS;
// DMA register concatenation of bits

//------------------------------------------------------------------------------
//
// Main body of  code
// =================
//
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Write Interface
// Save power by preventing change in internal data bus && 
// address bus when the device is not selected
//------------------------------------------------------------------------------

assign PWDATAIn          = ((PSELT ==  1'b1) && (PWRITE == 1'b1)) ? 
                           PWDATA : 16'b0000000000000000;

assign GatedPADDR        = (PSELT == 1'b1) ? PADDR :6'b000000;

assign WrEn              = PENABLE && PSELT && PWRITE;

   
// Write enable for registers 
 
assign SCITrDATAWrEn     = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrDATA)) ? 1'b1 : 1'b0; 

assign SCITrCRWrEn       = ((WrEn == 1'b1) && 
                           (GatedPADDR == `PADDR_SCITrCR)) ? 
                            1'b1 : 1'b0; 

assign SCITrFiLCRWrEn    = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrFiLCR)) ?
                             1'b1 : 1'b0; 
                  
assign SCITrTXPCWrEn     = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrTXPC)) ?
                             1'b1 : 1'b0; 

assign SCITrRXPCWrEn     = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrRXPC)) ?
                             1'b1 : 1'b0; 

assign SCITrCTRLWrEn     = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrCTRL)) ?
                             1'b1 : 1'b0; 

assign SCITrATWrEn       = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrAT)) ?
                              1'b1 : 1'b0; 
                  

assign SCITrDTWrEn       = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrDT)) ?
                           1'b1 : 1'b0; 

assign SCITrTXBLKGWrEn   = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrTXBG)) ?
                           1'b1 : 1'b0; 

assign SCITrTXCHGWrEn    = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrTXCHG)) ?
                          1'b1 : 1'b0; 

assign SCITrCKICCWrEn    = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrCKICC)) ?
                            1'b1 : 1'b0; 

assign SCITrBAUDWrEn     = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrBAUD)) ?
                            1'b1 : 1'b0; 

assign SCITrVALUEWrEn    = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrVALUE)) ?
                            1'b1 : 1'b0; 

assign SCITrRXCHGWrEn    = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrRXCHG)) ?
                            1'b1 : 1'b0; 
          
assign SCITrRXBLKGWrEn   = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrRXBG)) ?
                            1'b1 : 1'b0; 

assign SCITrRFCKWrEn     = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrRFCK)) ?
                            1'b1 : 1'b0; 

assign SCITrWVWrEn       = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrWV)) ?
                             1'b1 : 1'b0; 

assign SCITrJitWrEn      = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrJit)) ?
                             1'b1 : 1'b0; 

assign SCITrJitPatWrEn   = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrJitPt)) ?
                             1'b1 : 1'b0; 

assign SCITrRFCNTLWrEn   = ((WrEn == 1'b1) && 
                            (GatedPADDR == `PADDR_RFCNTL)) ?
                             1'b1 : 1'b0; 
                   
assign SCITrDMAWr        = ((WrEn == 1'b1) &&
                           (GatedPADDR == `PADDR_SCITrDMA)) ?
                             1'b1 : 1'b0; 

//------------------------------------------------------------------------------
// Read interface
//------------------------------------------------------------------------------

assign RdEn              = PSELT && ( ~PENABLE) && (~PWRITE);
// Read enable for registers 
 
assign SCITrDATArd       = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrDATA)) ?
                             1'b1 : 1'b0; 

assign SCITrCRrd         = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrCR)) ?
                             1'b1 : 1'b0; 
                  

assign SCITrFiLCRrd      = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrFiLCR)) ?
                            1'b1 : 1'b0; 
                  

assign SCITrSR0rd        = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrSR0)) ?
                           1'b1 : 1'b0; 
                  

assign SCITrSR1rd        = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrSR1)) ?
                  1'b1 : 1'b0; 
                  

assign SCITrSR2rd        = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrSR2)) ?
                  1'b1 : 1'b0; 
                  

assign SCITrTXPCrd       = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrTXPC)) ?
                  1'b1 : 1'b0; 
                  

assign SCITrRXPCrd       = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrRXPC)) ?
                  1'b1 : 1'b0; 
                  

assign SCITrCTRLrd       = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrCTRL)) ?
                  1'b1 : 1'b0; 

assign SCITrATrd         = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrAT)) ?
                  
                  1'b1 : 1'b0; 

assign SCITrDTrd         = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrDT)) ?
                  
                  1'b1 : 1'b0; 
assign SCITrTXBLKGrd     = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrTXBG)) ?
                  1'b1 : 1'b0; 
assign SCITrTXCHGrd      = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrTXCHG)) ?
                  1'b1 : 1'b0; 

assign SCITrCKICCrd      = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrCKICC)) ?
                  1'b1 : 1'b0; 

assign SCITrBAUDrd       = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrBAUD)) ?
                  1'b1 : 1'b0; 
                  

assign SCITrVALUErd      = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrVALUE)) ?
                  1'b1 : 1'b0; 
                  

assign SCITrRXCHGrd      = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrRXCHG)) ?
                  1'b1 : 1'b0; 
                  

assign SCITrRXBLKGrd     = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrRXBG)) ?
                  1'b1 : 1'b0; 
                  

assign SCITrRFCKrd       = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrRFCK)) ?
                  1'b1 : 1'b0; 
                  

assign SCITrWVrd         = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrWV)) ?
                  1'b1 : 1'b0; 

assign SCITrJitrd        = ((RdEn == 1'b1) && 
                           (GatedPADDR == `PADDR_SCITrJit)) ?
                  1'b1 : 1'b0; 
                  

assign SCITrJitPatrd     = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_SCITrJitPt)) ?
                  1'b1 : 1'b0; 

assign SCITrRFCNTLrd     = ((RdEn == 1'b1) && 
                            (GatedPADDR == `PADDR_RFCNTL)) ?
                  1'b1 : 1'b0; 

assign SCITrDMArd        = ((RdEn == 1'b1) &&
                           (GatedPADDR == `PADDR_SCITrDMA)) ?
                             1'b1 : 1'b0; 

//------------------------------------------------------------------------------
// Increment the Read pointer in the RX FIFO after every read from
// the SCIDATA register i.e.  after every read from the Receive FIFO
//------------------------------------------------------------------------------

assign RxFRdPtrInc       = ((PSELT == 1'b1) && (PENABLE == 1'b1) &&
                           (PWRITE == 1'b0) &&  
                           (GatedPADDR == `PADDR_SCITrDATA)) ? 
                     1'b1 :1'b0;

// -----------------------------------------------------------------------------
// Assign individual DMA status bits  to SCITrDMA  
// -----------------------------------------------------------------------------

assign SCITrDMA      = { SCITXDMASREQ,SCITXDMABREQ,
                         SCIRXDMASREQ,SCIRXDMABREQ, 2'b00 };

assign SCIINTERRUPTS = { SCICLKACTINTR,   SCICLKSTPINTR,  SCIRORINTR,
                         SCICARDININTR,   SCICARDOUTINTR, SCICARDUPINTR, 
                         SCICARDDNINTR,   SCITXERRINTR,   SCIATRSTOUTINTR, 
                         SCIATRDTOUTINTR, SCIBLKTOUTINTR, SCICHTOUTINTR, 
                         SCITXTIDEINTR,   SCIRXTIDEINTR,  SCIRTOUTINTR, 
                         SCIINTR };

assign TrFIFOSTATUS  = { SCITrRFF, SCITrRFE, SCITrRFR, 
                         SCITrTFF, SCITrTFE, SCITrTFR };
// Output Mux
assign NextPRDATA = (SCITrDATArd == 1'b1)   ? RxFRdData               :(        
                    (SCITrCRrd   == 1'b1)   ? SCITrCR                 :( 
                    (SCITrCRrd   == 1'b1)   ? SCITrFiLCR              :(  
                    (SCITrSR0rd   == 1'b1)  ? {10'h000, TrFIFOSTATUS} :(
                    (SCITrSR1rd   == 1'b1)  ? SCIINTERRUPTS           :( 
                    (SCITrSR2rd   == 1'b1)  ? {15'h0000, SCIDEACACK}  :( 
                    (SCITrTXPCrd == 1'b1)   ? SCITrTXPC               :(       
                    (SCITrDTrd == 1'b1)     ? SCITrDT                 :(        
                    (SCITrTXBLKGrd == 1'b1) ? SCITrTXBLKG             :(
                    (SCITrTXCHGrd == 1'b1)  ? SCITrTXCHG              :(
                    (SCITrCKICCrd == 1'b1)  ? SCITrCKICC              :(        
                    (SCITrBAUDrd == 1'b1)   ? SCITrBAUD               :(       
                    (SCITrVALUErd  == 1'b1) ? SCITrVALUE              :( 
                    (SCITrRXCHGrd == 1'b1)  ? SCITrRXCHG              :(
                    (SCITrRXBLKGrd == 1'b1) ? SCITrRXBLKG             :(
                    (SCITrRFCKrd == 1'b1)   ? SCITrRFCK               :(        
                    (SCITrWVrd == 1'b1)     ? SCITrWV                 :(
                    (SCITrJitrd == 1'b1)    ? SCITrJit                :(
                    (SCITrJitPatrd == 1'b1) ? SCITrJitPat             :(
                    (SCITrRFCNTLrd == 1'b1) ? {PCLKOn, REFCLKOn}      :(
                    (SCITrDMArd == 1'b1)  ? {10'h000, SCITrDMA}       :(
                    (16'b0000000000000000)))))))))))))))))))))); 
// Initialisation
//------------------------------------------------------------------------------
initial
begin
 nSCIDAOUTEN = 1'b0;
end
//------------------------------------------------------------------------------
// When the peripheral is not being accessed, 1'b0s are driven
// on the Read Databus (PRDATA) so as not to place any restrictions
// on the method of external bus connection. The external data buses of the
// peripherals on the APB may then be connected to the ASB-to-APB bridge using
// Muxed or ORed bus connection method.
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Output register . This register is not reset by the TESTRST bit in the
// SCITCR register. If it were, it would not be possible to read the internal
// registers with the TESTRST bit set.
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_RdSeq 
  if (PRESETn == 1'b0)
    PRDATA  = 16'b0000000000000000;
  else
    PRDATA  = NextPRDATA;
end // p_RdSeq;
endmodule
 

//====================================  End  =================================--
