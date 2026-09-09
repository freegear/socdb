// --=========================================================================--
//  This confidential && proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies && copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version && Release Control Information:
//  
//  File Name              : SspTrApbif.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
// Purpose      : APB Interface to generate decodes for write && read
//                accesses to SSP internal registers.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspTrApbif( 
                  PRESETn, 
                  PCLK, 
                  PSEL,
                  PWRITE,
                  PENABLE,
                  PADDR,
                  PWDATA,
                  SSPTBPRE, 
                  SSPTBCR0, 
                  SSPTBCR1,
                  SSPTBCR2,
                  RxFRdData,
                  TxFRdData, 
                  RXFE,     
                  RXFF,     
                  TXFF,    
                  TXFE,    
                  BSY,    
                  SSPTBSETPINS,     

                  SSPTBCLKREG,      
                  SSPTBCLKREG1,     
 
                  SSPINTR,      
                  SSPTXINTR,    
                  SSPRXINTR,  
                  SSPRORINTR, 
                  SSPRTINTR,

                  RXWFLG, 
                  PCLKOn,
                  REFCLKOn,        
                  REFCLK1On,

                  SSPTXDMASREQ,
                  SSPTXDMABREQ,
                  SSPRXDMASREQ,
                  SSPRXDMABREQ,
      
                  RxFRdPtrInc,     

                  SSPTBCR0Wr,     
                  SSPTBCR1Wr,    
                  SSPTBCR2Wr,
                  SSPTBPREWr,   
                  SSPTBTDRWr,  
                  SSPTBRDRWr, 
                  SSPTBSRWr, 

                  SSPTBSETPINSWr, 
                  SSPTBCLKREGWr,
                  SSPTBCLKREG1Wr,  
                  SSPTBDMACRWrEn,
                  PRDATA,    
                  PWDATAIn  
                 );

input         PRESETn;         // AMBA Bus Reset
input         PCLK;            // APB Bus Clock
input         PSEL;            // APB Peripheral select
input         PWRITE;          // APB Peripheral Write
input         PENABLE;         // APB Peripheral enable
input   [7:2] PADDR;           // APB High Addr
input  [15:0] PWDATA;          // Write databus
input   [3:0] SSPTBPRE;        // PreScale Reg 
input  [15:0] SSPTBCR0;        // Cntl Reg0 
input   [5:0] SSPTBCR1;        // Cntl Reg1 
input  [10:0] SSPTBCR2;        // Reg to store no: of SCLK
input  [15:0] RxFRdData;       // Rx Data
input  [15:0] TxFRdData;       // Tx Data
input         RXFF;            // Rx FIFO Full
input         TXFF;            // Tx FIFO Full
input         RXFE;            // Rx FIFO Empty 
input         TXFE;            // Tx FIFO Empty 
input         BSY ;            // SSP Busy 
input   [6:0] SSPTBSETPINS;    // Clk Cntl Reg. 
input  [15:0] SSPTBCLKREG;     // SSP Clk Reg. 
input  [15:0] SSPTBCLKREG1;    // SSP Clk Reg. 
input         SSPINTR;         // SSP interrupt
input         SSPTXINTR;       // SSP TxFIFO interrupt 
input         SSPRXINTR;       // SSP RxFIFO interrupt
input         SSPRORINTR;      // SSP RxOverRUN interrupt 
input         SSPRTINTR;       // SSP RxTimeout interrupt
input         RXWFLG;          // RxFIFO Water FLG 
input         PCLKOn;          // PCLK start 
input         REFCLKOn;        // SSPCLK start  
input         REFCLK1On;       // SSPCLK1 start  
input         SSPTXDMASREQ;    // Transmit DMA single request
input         SSPTXDMABREQ;    // Transmit DMA burst  request
input         SSPRXDMASREQ;    // Receive  DMA single request
input         SSPRXDMABREQ;    // Receive  DMA burst  request
output        RxFRdPtrInc;     // RxFIFO read ptr Increment 
output        SSPTBCR0Wr;      // Write enable for SSPTBCR0
output        SSPTBCR1Wr;      // Write enable for SSPTBCR1
output        SSPTBCR2Wr;      // Write enable for SSPTBCR2
output        SSPTBPREWr;      // Write enable for SSPTBPRE
output        SSPTBTDRWr;      // Tx FIFO Write enable
output        SSPTBRDRWr;      // Rx FIFO Write enable
output        SSPTBSRWr;       // Write enable for SSPTBSR
output        SSPTBSETPINSWr;  // Write enable for SSPTBSETPINS
output        SSPTBCLKREGWr;   // Write enable for SSPTBCLKREG
output        SSPTBCLKREG1Wr;  // Write enable for SSPTBCLKREG1
output        SSPTBDMACRWrEn;  // Write Enable for SSPTDMACR
output [15:0] PRDATA ;         // Read Databus
output [15:0] PWDATAIn;        // Int PWDATA

// -----------------------------------------------------------------------------
//
//                               SspTrApbif
//                               ==========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module decodes APB accesses && generates the write strobes to the 
// appropriate registers. This module also contains the output data multiplexer
// && the output register that form the read interface. The internal databus, 
// for the SSPTrickbox, PWDATAIn[15:0], is also generated in this module, by 
// gating the input data bus, PWDATA[15:0] with PSEL && PWRITE.
//
// -----------------------------------------------------------------------------
//                    SspTB Register Map
// -----------------------------------------------------------------------------
// Offset Read (Width)              Write (Width)        Description
// -----------------------------------------------------------------------------
// 0x00   SSPTBPRE(4 bits)          SSPTBPRE(4 bits)      PREScale Register 
// 0x04   SSPTBCR0(16 bits)         SSPTBCRO(16 bits)     Control Register 0
// 0x08   SSPTBCR1(6 bits)          SSPTBCR1(6 bits)      Control Register 1
// 0x0C   SSPTBTDR(16 bits)         SSPTBTDR(16 bits)     TxData Register
// 0x10   SSPTBRDR(16 bits)         SSPTBRDR(16 bits)     RxData Register
// 0x14   SSPTBSR(13 bits)              -                 Status Register
// 0x1C   SSPTBCLKREG (16 bits)     SSPTBCLKREG(16bits)   REFClk Register 
// 0x20   SSPTBCR2 (11bits)         SSPTBCR2 (11bits)     Control Register 2
// 0x24   SSPTBCLKREG1 (16 bits)    SSPTBCLKREG1(16bits)  REFClk1 Register 
// 0x28   SSPTDMACR  (4 bits)       SSPTDMACR(2 bits)     DMACR Register
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Normal mode registers address `defines
// -----------------------------------------------------------------------------
`define PA_SSPTBPRE        6'b000000
// SSPTBPRE at offset 0x00

`define PA_SSPTBCR0        6'b000001
// SSPTBCR1 at offset 0x04

`define PA_SSPTBCR1        6'b000010
// SSPTBDR at offset 0x08

`define PA_SSPTBTDR        6'b000011
// SSPTBSR at offset 0x0C

`define PA_SSPTBRDR        6'b000100
// SSPTBCPSR at offset 0x10

`define PA_SSPTBSR         6'b000101
// SSPTBIIR at offset 0x14

`define PA_SSPTBSETPINS    6'b000110
// SSPTBIIR at offset 0x18

`define PA_SSPTBCLKREG     6'b000111
// SSPTBIIR at offset 0x1C
 
 `define PA_SSPTBCR2       6'b001000
// SSPTBCR2 at offset 0x20

`define PA_SSPTBCLKREG1    6'b001001
// SSPTBIIR at offset 0x24
 
`define  SSPTBDMACRDec     6'b001010
// SSPTBDMACR at offset 0x28
 
// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
wire [7:2] GatedPA;
// Gate PA with PSEL to save power 

wire        SSPTBPRERd ;
// SSPTBPRESCALE read

wire        SSPTBCR0Rd ;
// SSPTBCR0 read

wire        SSPTBCR1Rd ;
// SSPTBCR1 read
  
wire        SSPTBCR2Rd;
// SSPTBCR2Rd read 

wire        SSPTBTDRRd ;
// SSPTBTDR read

wire        SSPTBRDRRd;
// SSPTBRDR read
  
wire        SSPTBSRRd;
// SSPTBSR read

wire        SSPTBSETPINSRd;
// SSPTBSETPINS read

wire        SSPTBCLKREGRd;
// SSPTBCLKREG read

wire        SSPTBCLKREG1Rd;
// SSPTBCLKREG1 read

wire SSPTBDMACRrd;
// SSPTBDMACR read

wire [5:0] SSPTBDMACR;
// DMA register concatenation of bits

wire [12:0] SSPTBSR;
// SSPTB status register 

wire [15:0] NextPRDATA;
// D-input PRDATA output register

wire        WrEn;
// Write enable signal common to all addresses in the APB interface
 
wire        RdEn;
// Read enable signal common to all addresses in the APB interface

reg  [15:0] PRDATA;
// Reading Data 

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Write Interface
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Latch the  internal data bus && address bus when  the device is  selected.
// -----------------------------------------------------------------------------
assign GatedPA  = (PSEL == 1'b1) ? PADDR     : 6'b000000;
assign PWDATAIn = ((PSEL ==  1'b1) && (PWRITE == 1'b1)) ? PWDATA : 16'h0000;
assign WrEn     = PENABLE && PSEL && PWRITE;

// -----------------------------------------------------------------------------
//  Register Write Decodes
// -----------------------------------------------------------------------------
// SSPTBPRE
assign SSPTBPREWr        = (WrEn  && (GatedPA == `PA_SSPTBPRE));

// SSPTBCRO
assign SSPTBCR0Wr        = (WrEn  && (GatedPA == `PA_SSPTBCR0));

// SSPTBCR1
assign SSPTBCR1Wr        = (WrEn  && (GatedPA == `PA_SSPTBCR1));

// SSPTBCR2
assign SSPTBCR2Wr        = (WrEn  && (GatedPA == `PA_SSPTBCR2));

// SSPTBTDR
assign SSPTBTDRWr        = (WrEn  && (GatedPA == `PA_SSPTBTDR));

// SSPTBRDR
assign SSPTBRDRWr        = (WrEn  && (GatedPA == `PA_SSPTBRDR));

// SSPTBSR
assign SSPTBSRWr         = (WrEn  && (GatedPA == `PA_SSPTBSR));

// SSPTBSETPIN
assign SSPTBSETPINSWr    = (WrEn  && (GatedPA == `PA_SSPTBSETPINS));

// SSPTBCLKREG
assign SSPTBCLKREGWr     = (WrEn  && (GatedPA == `PA_SSPTBCLKREG));

// SSPTBCLKREG1
assign SSPTBCLKREG1Wr    = (WrEn  && (GatedPA == `PA_SSPTBCLKREG1));

// SSPTBDMACR
assign SSPTBDMACRWrEn    = (WrEn  && (GatedPA == `SSPTBDMACRDec));

// -----------------------------------------------------------------------------
// Read Interface
// -----------------------------------------------------------------------------
assign RdEn = (PSEL && ~PWRITE &&  ~PENABLE);

// -----------------------------------------------------------------------------
// Normal mode Register Read Decodes
// -----------------------------------------------------------------------------
// SSPTBCR0
assign SSPTBCR0Rd        =  (RdEn  && (GatedPA == `PA_SSPTBCR0));

// SSPTBCR1
assign SSPTBCR1Rd        =  (RdEn  && (GatedPA == `PA_SSPTBCR1));

// SSPTBCR2
assign SSPTBCR2Rd        =  (RdEn && (GatedPA == `PA_SSPTBCR2));

// SSPTBTDR
assign SSPTBTDRRd        =  (RdEn  && (GatedPA == `PA_SSPTBTDR));

// SSPTBRDR
assign SSPTBRDRRd        =  (RdEn  && (GatedPA == `PA_SSPTBRDR));

// SSPTBSR
assign SSPTBSRRd         =  (RdEn  && (GatedPA == `PA_SSPTBSR));

// SSPTBSETPINS
assign SSPTBSETPINSRd    =  (RdEn  && (GatedPA == `PA_SSPTBSETPINS));

// SSPTBCLKREG
assign SSPTBCLKREGRd     =  (RdEn  && (GatedPA == `PA_SSPTBCLKREG));

// SSPTBCLKREG1
assign SSPTBCLKREG1Rd    =  (RdEn  && (GatedPA == `PA_SSPTBCLKREG1));

// SSPTBPRE
assign SSPTBPRERd        =  (RdEn  && (GatedPA == `PA_SSPTBPRE));

// SSPTBDMACR
assign SSPTBDMACRrd       =  (RdEn  && (GatedPA == `SSPTBDMACRDec));

// -----------------------------------------------------------------------------
// Increment the Read pointer in the Receive FIFO after every read from
// the Receive FIFO i.e.  after every read from the SSPTBRDR Register
// -----------------------------------------------------------------------------
assign RxFRdPtrInc = ((PENABLE == 1'b1) && (PSEL == 1'b1) && 
                      (PWRITE == 1'b0)  && (GatedPA == `PA_SSPTBRDR)) ? 
                      1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Assign individual status bits  to SSPTBSR  
// -----------------------------------------------------------------------------
assign SSPTBSR  = {SSPRTINTR, REFCLKOn, PCLKOn, SSPRORINTR, SSPTXINTR, 
                   SSPRXINTR, RXWFLG, SSPINTR, BSY, TXFF, TXFE,RXFF, RXFE};                                                    
// -----------------------------------------------------------------------------
// Assign individual DMA status bits  to SSPTBDMACR  
// -----------------------------------------------------------------------------

assign SSPTBDMACR = {SSPRXDMASREQ,SSPRXDMABREQ,
                     SSPTXDMASREQ,SSPTXDMABREQ, 2'b00};

// -----------------------------------------------------------------------------
// Output Data Mux.
// -----------------------------------------------------------------------------
assign NextPRDATA = (SSPTBCR0Rd == 1'b1)         ?  SSPTBCR0               : (
                    (SSPTBCR1Rd == 1'b1)         ? 
                    {10'b0000000000 , SSPTBCR1}                            : ( 
                    (SSPTBCR2Rd == 1'b1)         ? SSPTBCR2                : (
                    (SSPTBTDRRd == 1'b1)         ? TxFRdData               : (
                    (SSPTBRDRRd == 1'b1)         ? RxFRdData               : (
                    (SSPTBSRRd == 1'b1)          ? {3'b000 , SSPTBSR}    : (
                    (SSPTBSETPINSRd == 1'b1)     ? 
                    {9'b000000000, SSPTBSETPINS}                           : (
                    (SSPTBCLKREGRd == 1'b1)      ?  SSPTBCLKREG            : (
                    (SSPTBCLKREG1Rd == 1'b1)     ?  SSPTBCLKREG1           : (
                    (SSPTBPRERd == 1'b1)         ? 
                    {12'b000000000000, SSPTBPRE}                           : (
                    (SSPTBDMACRrd == 1'b1)       ? 
                    {10'b0000000000, SSPTBDMACR}                           : (

                     16'b000000000000000)))))))))));


// -----------------------------------------------------------------------------
// Output Data register. 
// -----------------------------------------------------------------------------
always @ (posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (PRESETn == 1'b0) 
    PRDATA  <= 16'b0000000000000000;
  else
    PRDATA  <= NextPRDATA;
end   // p_Seq
endmodule

//  --============================== End =====================================--











