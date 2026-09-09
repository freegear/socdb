// ----------------------------------------------------------------------------
//  This confidential  and  proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies  and  copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// ----------------------------------------------------------------------------
//  
//  Version  and  Release Control Information
//  
//  File Name               $RCSfile SspTrick.vhd,v $
//  File Revision           $Revision 1.16 $
//  
//  Release Information     $State Exp $
//  
// ----------------------------------------------------------------------------
//  Purpose           This block is the top level of the SSPTRICKBox.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspTrick( 
                PCLK,
                PRESETn,
                PSELT,
                PENABLE,
                PWRITE,
                PADDR,

                PWDATA,

                SSPRXD,
                SCLKIN,
                SCLKOUT,
                SFRMIN,
                SFRMOUT,
                SSPINTR,
                SSPRXINTR,
                SSPTXINTR,
                SSPRORINTR,
                SSPRTINTR,
                SSPTXDMASREQ,
                SSPTXDMABREQ,
                SSPRXDMASREQ,
                SSPRXDMABREQ,
                SCANMODE, 
                nSSPRST, 
                SSPCLK,
                SSPTXD,
                SSPTXDMACLR,
                SSPRXDMACLR,
                PRDATA 
               );

input         PCLK;         // APB Bus Clock
input         PRESETn;      // AMBA Bus Reset
input         PSELT;        // APB Peripheral select
input         PENABLE;      // APB Peripheral enable
input         PWRITE;       // APB Peripheral write
input  [7:2]  PADDR;        // APB High Addr
input [15:0]  PWDATA;       // APB Write databus
input         SSPRXD;       // SSPTB Receive input
input         SCLKIN;       // Serial Clock pin
input         SFRMIN;       // Serial Frame pin
input         SSPINTR;      // Combined Interrupt
input         SSPRXINTR;    // Receive FIFO Service Request
input         SSPTXINTR;    // Transmit FIFO Service Request
input         SSPRORINTR;   // Rx FIFO Overrun Interrupt
input         SSPRTINTR;    // Rx FIFO Timeout Interrupt
input         SSPTXDMASREQ; // Transmit DMA single request
input         SSPTXDMABREQ; // Transmit DMA burst request
input         SSPRXDMASREQ; // Receive DMA single request
input         SSPRXDMABREQ; //  Receive DMA burst request
output        SCLKOUT;      // Serial Clock out pin
output        SFRMOUT;      // Serial Frame out
output        SCANMODE;     // Reset control on Scan
output        nSSPRST;      // Reset control on Scan
output        SSPCLK;       // Main SSP Clock
output        SSPTXD;       // SSP Serial Transmit output
output        SSPTXDMACLR;  // Transmit DMA request clear
output        SSPRXDMACLR;  // Receive DMA request clear
output [15:0] PRDATA;       // Read databus

// -----------------------------------------------------------------------------
// 
//                                  SspTrick
//                                  ========
// 
// -----------------------------------------------------------------------------
// 
// Overview
// ========
// 
// This module instantiates the following sub-modules 
// 
// 1. SspTrApbif         - APB Interface
// 2. SspTrRegCore       - Register Block
// 3. SspTrRxFIFO        - Receive FIFO
// 4. SspTrTxFIFO        - Transmit FIFO
// 5. SspTrMTxRxCtl      - Transmitter/Receiver to test the SSP's Master 
//                         functionality
// 6. SspTrSynctoPCLK    - Synchronisers for signals crossing into PCLK domain
// 7. SspTrSynctoSSPCLK  - Synchronisers for signals crossing into SSPCLK domain
// 8. SspTrCkRsCntlr     - Clock and reset generation Block
// 8. SspTrScaleCntr     - Control Register sync module 
// 9. SspTrChecker       - Protocol Checker Block 
// 10.SspTrSTxRxCntl     - Transmitter/Receiver for Testing Slave
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations 
// -----------------------------------------------------------------------------
wire        PCLK;
// APB Bus Clock

wire        PRESETn;
// AMBA Bus Reset

wire        PSELT;
// APB Peripheral select

wire        PENABLE;
// APB Peripheral enable

wire        PWRITE;
// APB Peripheral write

wire  [7:2] PADDR;
// APB High Addr

wire [15:0] PWDATA;
// APB Write databus

wire        SSPRXD;
// SSPTB Receive input

wire        SCLKIN;
// Serial Clock pin

wire        SFRMIN;
// Serial Frame pin

wire        SSPINTR;
// Combined Interrupt

wire        SSPRXINTR;
// Receive FIFO Service Request

wire        SSPTXINTR;
// Transmit FIFO Service Request

wire        SSPRORINTR;
// Rx FIFO Overrun Interrupt

wire [15:0] PWDATAIn; 
// Pheripharal input data

wire        RNE;
// Reciever not empty
 
wire [15:0] RxFRdData; 
// Reciever FIFO Read Data

wire        RxFRdPtrInc;
// Reciever FIFO pointer increament
 
wire        TNF;
// Transmiter not full flag
 
wire        TxFRdPtrInc;
// Transmiter FIFO Read pointer
 
wire        TxFRdPtrIncSync;
// Transmiter FIFO Read pointer increament sync signal
 
wire        TxDataAvlbl;
// Transmiter data available
 
wire        SPH	;
// Indicates phase of SCLK in SPI mode
 
wire        SPO;
// Indicates polarity of SCLK in SPI mode
 
wire  [7:0] SCR;
// Serial clock rate
 
wire  [1:0] FRF;
// Fram format
 
wire  [3:0] DSS;
// Specifies Datasize to be transmited
 
wire        SSPCLKDIV;
// SSPCLOCK Division signal
 
wire        SSPCLK0;
// Internal SSPCLK
 
wire        SSPCLK1;
// Internal SSPCLK1
 
wire        SSPCLK;
// Internal SSPCLK
 
wire        TxDataAvlblSync;
// Transmiter data available synchronised singnal
  
wire        RxFWrSync; 
// Reciever Fifo write sync signal

wire        RxFWr;
//  Reciever Fifo write signal
 
wire [15:0] RxFWrData;
// Reciever fifo data write enable
 
wire [15:0] SRxFWrData;
// Reciever fifo write data in testing slave
 
wire [15:0] MRxFWrData;
//  Reciever fifo write data for master
 
wire        TFE;
// Transmiter fifo empty
 
wire        RFF;
// Reciever fifo full
 
wire        SSESync;
// Trickbox enable signal
 
wire        nSSPRES;
// SSP reset signal
 
wire        SelSSPRXD;
// SelSSPRXD
 
wire        TxRxBSY;
// Tx/Rx Busy signal
 
wire        TxRxBSYSync;
// Snchronized TxRxBSY
 
wire        BSY;
// Busy signal
 
wire        ClrRORINTR;
// ClrRORINTR
 
wire        CR0UpdateSync;
// Snchronized CR0 update
 
wire        CR0Update;
// CR0Update
 
wire        CPSRUpdateSync;
// Clock prescale sync signal
 
wire        CR1UpdateSync;
// CR1 
 
wire        CR1Update;
// Control register update signal
 
wire        CPSRUpdate;
//  Clock prescale update signal
 
wire  [5:0] SSPTBCR1;
// SSPTBCR1
 
wire        SSPTBCR0Wr;
// Write signal to SSPTBCR0
 
wire        SSPTBCR1Wr; 
// Write signal to SSPTBCR1
 
wire        SSPTBSRWr; 
// Write signal to SSPTBSR
 
wire        SSPTBTDRWr1; 
// Write signal to SSPTBTDR
 
wire        SSPTBTDRWr; 
// Write signal to SSPTBCR0
 
wire        SSPTBRDRWr; 
// Write signal to SSPTBCR0
 
wire [15:0] TxFRdDataIn;
// Internal TxFRdData
 
wire  [7:1] SSPCPSR; 
// SSP Clock prescale reg

wire  [6:0] SSPCPSC;
// SSPCPSC
 
wire        SSPTXD0; 
// internal SSPTXD

wire        SSPTXD1; 
// internal SSPTXD

wire        SSPTBPREWr ;        
// Write enable for SSPTBPRE

wire        SSPTBSETPINSWr ; 
// Write enable for SSPTBSETPIN

wire        SSPTBCLKREGWr;   
// Write enable for SSPTBCLKREG

wire        SSPTBCLKREG1Wr;   
// Write enable for SSPTBCLKREG1

wire  [3:0] SSPTBPRE ;    
// Reg SSPTBPRE

wire [15:0] SSPTBCR0;    
// Reg  SSPTBCR0

wire [15:0] TxFRdData;  
// Transmiter FIFO Read data

wire        RXFE;      
// Status flag

wire        RXWFLG;
// Water mark status flag

wire  [1:0] RXW;
// Status flag
 
wire  [6:0] SSPTBSETPINS; 
// reg SSPTBSETPINS

wire [15:0] SSPTBCLKREG ;    
// Specifies SSPCLK period

wire [15:0] SSPTBCLKREG1 ;    
// Specifies SSPCLK1 period

wire        TXFF;       
// Status flag

wire        RXFF;       
// Reciever fifo full flag

wire        TXFE;
// Transmiter fifo empty flag

wire        PCLKOn;
// To switch on PCLK

wire        REFCLKOn;
// To Switch on REFCLK

wire        REFCLK1On;
// To Switch on REFCLK1

wire        MS;
// Master/Slave selection

wire        SSEMaster;
// SSP Enable signal for master

wire        SSESlave;
// SSP enable signal for in slave testing 

wire [10:0] SSPTBCR2;
// CR2 Reg

wire        SSPTBCR2Wr;
// Write enable signal for SSPTBCR2

wire        SSPOEOUT;
// Data output enable from the SSP's slave testing block 

wire        ChkTxBSY;
// Check Transmiter busy

wire        STxFRdPtrIncSync;
// Transmiter FIFO Read pointer increament sync signal     

wire        SRxFWrSync;
// Reciever Fifo write sync signal

wire        STxRxBSY; 
// Tx/Rx Busy signal

wire        STxRxBSYSync;
// Snchronized TxRxBSY

wire        SRxFWr;
//  Reciever Fifo write signal

wire        STxFRdPtrInc;
// Transmiter FIFO Read pointer

wire [1:0]  SSPTDMACR;
// Trickbox DMA Control Register

wire [10:0] SSPTBSR;
// SSP Trickbox Status Register



// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Extract MS bit from SSPTBCR1 register.
// -----------------------------------------------------------------------------
assign MS = SSPTBCR1[4];

// -----------------------------------------------------------------------------
// Route the relevant Transmit data line to the SSPTXD output based on whether 
// the SSP is in the Master mode or the Slave mode.
// -----------------------------------------------------------------------------
assign SSPTXD = (MS == 1'b1) ? SSPTXD1 : SSPTXD0; 

// -----------------------------------------------------------------------------
// Route SSPCLK1 to the SSP
// -----------------------------------------------------------------------------
assign SSPCLK = SSPCLK1; 

// -----------------------------------------------------------------------------
// FIFO Fill level status signals.
// -----------------------------------------------------------------------------
assign TXFF = ~TNF;
assign RXFE = ~RNE;

// -----------------------------------------------------------------------------
// Route the relevant Receive data to the Receive FIFO based on whether 
// the SSP is in the Master mode or the Slave mode.
// -----------------------------------------------------------------------------
assign RxFWrData = (MS == 1'b1) ? SRxFWrData : MRxFWrData;

// -----------------------------------------------------------------------------
// Generate individual enable signals for the Master-testing block and the
// Slave-testing block.
// -----------------------------------------------------------------------------
assign SSEMaster = ~MS & SSESync;
assign SSESlave  = MS & SSESync;

// -----------------------------------------------------------------------------
// The APB Interface contains the Write interface  and  the Read interface
// for registers in the SSPTrickbox.
// -----------------------------------------------------------------------------
SspTrApbif uSspTrApbif
         (
          .PRESETn          (PRESETn),
          .PCLK             (PCLK),
          .PSEL             (PSELT),
          .PWRITE           (PWRITE),
          .PENABLE          (PENABLE),
          .PADDR            (PADDR),
          .PWDATA           (PWDATA),
          .SSPTBPRE         (SSPTBPRE), 
          .SSPTBCR0         (SSPTBCR0),
          .SSPTBCR1         (SSPTBCR1),
          .SSPTBCR2         (SSPTBCR2),
          .RxFRdData        (RxFRdData),
          .TxFRdData        (TxFRdData),
          .RXFE             (RXFE), 
          .RXFF             (RFF),
          .TXFF             (TXFF),
          .TXFE             (TFE),
          .BSY              (TxRxBSYSync),  
          .SSPTBSETPINS     (SSPTBSETPINS), 

          .SSPTBCLKREG      (SSPTBCLKREG), 
          .SSPTBCLKREG1     (SSPTBCLKREG1),
 
          .SSPINTR          (SSPINTR), 
          .SSPTXINTR        (SSPTXINTR), 
          .SSPRXINTR        (SSPRXINTR), 
          .SSPRORINTR       (SSPRORINTR),
          .SSPRTINTR        (SSPRTINTR),

          .RXWFLG           (RXWFLG),  
          .PCLKOn           (PCLKOn),  
          .REFCLKOn         (REFCLKOn), 
          .REFCLK1On        (REFCLK1On), 

          .SSPTXDMASREQ     (SSPTXDMASREQ),
          .SSPTXDMABREQ     (SSPTXDMABREQ),
          .SSPRXDMASREQ     (SSPRXDMASREQ),
          .SSPRXDMABREQ     (SSPRXDMABREQ),

          .RxFRdPtrInc      (RxFRdPtrInc),

          .SSPTBCR0Wr       (SSPTBCR0Wr), 
          .SSPTBCR1Wr       (SSPTBCR1Wr), 
          .SSPTBCR2Wr       (SSPTBCR2Wr),
          .SSPTBPREWr       (SSPTBPREWr), 
          .SSPTBTDRWr       (SSPTBTDRWr),
          .SSPTBRDRWr       (SSPTBRDRWr), 
          .SSPTBSRWr        (SSPTBSRWr),

          .SSPTBSETPINSWr   (SSPTBSETPINSWr), 
          .SSPTBCLKREGWr    (SSPTBCLKREGWr),
          .SSPTBCLKREG1Wr   (SSPTBCLKREG1Wr),
          .SSPTBDMACRWrEn   (SSPTBDMACRWrEn),
          .PRDATA           (PRDATA), 
          .PWDATAIn         (PWDATAIn) 
         );

// -----------------------------------------------------------------------------
// The SspTrTxFIFO block contains the Transmit FIFO  and  the control logic
// required to regulate accesses to the FIFO.
// -----------------------------------------------------------------------------
SspTrTxFIFO uSspTrTxFIFO
          (
          .PCLK             (PCLK),
          .PRESETn            (PRESETn),
          .SSPTBTDRWr       (SSPTBTDRWr),
          .TxFRdPtrIncSync  (TxFRdPtrIncSync),
          .STxFRdPtrIncSync (STxFRdPtrIncSync),
          .MS               (MS),
          .TxRxBSYSync      (TxRxBSYSync),
          .FRF              (SSPTBCR0[5:4]),
          .DSS              (SSPTBCR0[3:0]),
          .PWDATAIn         (PWDATAIn),
          .TxDataAvlbl      (TxDataAvlbl),
          .TNF              (TNF),
          .TFE              (TFE),
          .BSY              (BSY),
          .TxFRdDataIn      (TxFRdDataIn)
          );

// -----------------------------------------------------------------------------
// The SspTrRxFIFO block contains the Receive FIFO  and  the control logic
// required to regulate accesses to the FIFO.
// -----------------------------------------------------------------------------
SspTrRxFIFO uSspTrRxFIFO
          (
          .PCLK        (PCLK),
          .PRESETn       (PRESETn),
          .RxFWrSync   (RxFWrSync),
          .SRxFWrSync  (SRxFWrSync),
          .RxFRdPtrInc (RxFRdPtrInc),
          .RXW         (SSPTBCR1[3:2]),
          .RxFWrData   (RxFWrData),
          .RXWFLG      (RXWFLG), 
          .RNE         (RNE),
          .RFF         (RFF),
          .RxFRdData   (RxFRdData)
          );

// -----------------------------------------------------------------------------
// This block contains synchronisers for signals crossing into the PCLK
// domain.
// -----------------------------------------------------------------------------
 SspTrSynctoPCLK uSspTrSynctoPCLK
           (
           .PCLK             (PCLK),
           .PRESETn            (PRESETn),
           .TxRxBSY          (TxRxBSY | STxRxBSY),
           .TxFRdPtrInc      (TxFRdPtrInc),
           .STxFRdPtrInc     (STxFRdPtrInc),
           .RxFWr            (RxFWr),
           .SRxFWr           (SRxFWr),
           .TxRxBSYSync      (TxRxBSYSync),
           .TxFRdPtrIncSync  (TxFRdPtrIncSync),
           .STxFRdPtrIncSync (STxFRdPtrIncSync),
           .RxFWrSync        (RxFWrSync),
           .SRxFWrSync       (SRxFWrSync)
           );

// -----------------------------------------------------------------------------
// The SspTrRegCore Block contains all the read/writable  registers
// in the SSPTrickbox. It also contains the PCLK-domain part of the control
// logic required to synchronise the contents of SSPTBCR0  and  SSPTBCR1 to the 
// SSPCLK domain.
// -----------------------------------------------------------------------------
SspTrRegCore uSspTrRegCore
           (
          .PCLK             (PCLK),
          .PRESETn          (PRESETn),
          .SSPTBCR0Wr       (SSPTBCR0Wr),
          .SSPTBCR1Wr       (SSPTBCR1Wr),
          .SSPTBCR2Wr       (SSPTBCR2Wr),
          .SSPTBSRWr        (SSPTBSRWr),   
          .SSPTBPREWr       (SSPTBPREWr),
          .SSPTBTDRWr       (SSPTBTDRWr), 
          .SSPTBRDRWr       (SSPTBRDRWr),
          .SSPTBSETPINSWr   (SSPTBSETPINSWr),
          .SSPTBCLKREGWr    (SSPTBCLKREGWr), 
          .SSPTBCLKREG1Wr   (SSPTBCLKREG1Wr), 
          .SSPTBDMACRWrEn   (SSPTBDMACRWrEn),
          .PWDATAIn         (PWDATAIn[15:0]),

          .SSPTXDMACLRStag2 (SSPTXDMACLRStag2),
          .SSPRXDMACLRStag2 (SSPRXDMACLRStag2),
          .CR0Update        (CR0Update),
          .CR1Update        (CR1Update),
          .SSPTBCR0         (SSPTBCR0),
          .SSPTBCR1         (SSPTBCR1),
          .SSPTBCR2         (SSPTBCR2),
          .SSPTBSR          (SSPTBSR),
          .SSPTBCLKREG      (SSPTBCLKREG),
          .SSPTBCLKREG1     (SSPTBCLKREG1),
          .SSPTBSETPINS     (SSPTBSETPINS), 
          .SSPTBPRE         (SSPTBPRE), 
          .SSPTDMACR        (SSPTDMACR)
         );

// -----------------------------------------------------------------------------
// The SspTrSynctoSSPCLK block contains synchronisers for signals crossing
// into the SSPCLK domain. 
// -----------------------------------------------------------------------------
SspTrSynctoSSPCLK uSspTrSynctoSSPCLK (
          .SSPCLK          (SSPCLK0),
          .nSSPRES         (PRESETn), 
          .TxDataAvlbl     (TxDataAvlbl),
          .CR0Update       (CR0Update),
          .CR1Update       (CR1Update),
          .SSE             (SSPTBCR0[6]),
          .TxDataAvlblSync (TxDataAvlblSync),
          .CR0UpdateSync   (CR0UpdateSync),
          .CR1UpdateSync   (CR1UpdateSync),
          .SSESync         (SSESync)
         );

// -----------------------------------------------------------------------------
// The SspTrCkRsCntlr block generates SSPCLK for the SSP and the Trickbox. It
// also generates the nSSPRST and SCANMODE signals for the SSP.
// -----------------------------------------------------------------------------
SspTrCkRsCntlr uSspTrCkRsCntlr
         (
         .PCLK         (PCLK),        
         .PRESETn        (PRESETn),    
         .SSPTBCLKREG  (SSPTBCLKREG), 
         .SSPTBCLKREG1 (SSPTBCLKREG1), 
         .SSPTrCNTLR   (SSPTBSETPINS[6:2]),  
         .SCANMODEIN   (SSPTBSETPINS[0]), 
         .RSTMODE      (SSPTBSETPINS[1]),  
         .SCANMODE     (SCANMODE), 
         .nSSPRST      (nSSPRST),    
         .SSPCLK       (SSPCLK0),     
         .SSPCLK1      (SSPCLK1),     
         .PCLKOn       (PCLKOn),     
         .REFCLKOn     (REFCLKOn),     
         .REFCLK1On    (REFCLK1On)     
        );

// -----------------------------------------------------------------------------
// This block performs division of the SSPCLK by the Prescale value and 
// generates the SSPCLKDIV signal.
// -----------------------------------------------------------------------------
SspTrScaleCntr uSspTrScaleCntr
          (
          .SSPCLK         (SSPCLK0),
          .nSSPRES        (PRESETn),
          .SSESync        (SSESync),
          .CR0UpdateSync  (CR0UpdateSync),
          .CR1UpdateSync  (CR1UpdateSync),
          .SSPTBCR0       (SSPTBCR0),
          .SSPTBCR1       (SSPTBCR1),
          .SSPTBPRE       (SSPTBPRE),
          .SPO            (SPO),
          .SPH            (SPH),
          .DSS            (DSS),
          .SSPCLKDIV      (SSPCLKDIV),
          .FRF            (FRF),
          .SCR            (SCR)
         );

// -----------------------------------------------------------------------------
// The SspTrChecker block contains protocol checkers that monitor the SSP's
// non-AMBA outputs. 
// -----------------------------------------------------------------------------
SspTrChecker uSspTrChecker
          (
          .PCLK         (PCLK),   
          .SSPCLK       (SSPCLK1), 
          .PRESETn        (PRESETn), 
          .SCLK         (SCLKIN),    
          .SFRM         (SFRMIN),   
          .SFRMOUT      (SFRMOUT),
          .SCLKOUT      (SCLKOUT), 
          .SSPRXD       (SSPRXD),   
          .SPO          (SSPTBCR1[0]),        
          .SPH          (SSPTBCR1[1]),     
          .SSESync      (SSPTBCR0[6]), 
          .TxRxBSY      (TxRxBSY),
          .STxRxBSY     (STxRxBSY),
          .ChkTxBSY     (ChkTxBSY),
          .MS           (SSPTBCR1[4]),
          .OD           (SSPTBCR1[5]),
          .TiDASFRM     (SSPTBCR2[10]),
          .SSPOE        (SSPOEOUT),
          .DSS          (DSS),   
          .FRF          (FRF),   
          .SCR          (SCR),
          .PRESCALE     (SSPTBPRE), 
          .GENCLK1      (SSPTBSETPINS[6]),
          .SSPTBCLKREG  (SSPTBCLKREG),
          .SSPTBCLKREG1 (SSPTBCLKREG1)
         );
 
// -----------------------------------------------------------------------------
// The SspMTxRxCntl block contains the main Transmit/Receive control logic in 
// the trickbox that verifies the Master mode functionality of the SSP.
// -----------------------------------------------------------------------------
SspTrMTxRxCntl uSspTrMTxRxCntl
          (
          .PRESETn           (PRESETn), 
          .SCLK            (SCLKIN),
          .SFRM            (SFRMIN),
          .SSTBESync       (SSEMaster),
          .TxDataAvlblSync (TxDataAvlblSync),
          .DSS             (DSS),
          .FRF             (FRF),
          .SCR             (SCR),
          .SPO             (SPO),
          .SPH             (SPH),
          .TxFRdDataIn     (TxFRdDataIn),
          .SSPRXD          (SSPRXD), 
          .OD              (SSPTBCR1[5]),
          .TxFRdPtrInc     (TxFRdPtrInc),
          .RxFWr           (RxFWr),
          .TxRxBSY         (TxRxBSY),
          .ChkTxBSY        (ChkTxBSY),
          .SSPTXD          (SSPTXD0),
          .RxFWrData       (MRxFWrData)
         ); 

// -----------------------------------------------------------------------------
// The SspSTxRxCntl block contains the main Transmit/Receive control logic in 
// the trickbox that verifies the Slave mode functionality of the SSP.
// -----------------------------------------------------------------------------
SspTrSTxRxCntl uSspTrSTxRxCntl
         (
          .SSPCLK              (SSPCLK0),
          .nSSPRES             (PRESETn),
          .ClkEnable           (1'b1),
          .SSESync             (SSESlave),
          .SSPCLKDIV           (SSPCLKDIV),
          .TxDataAvlblSync     (TxDataAvlblSync),
          .Nibmode             (1'b0),
          .DSS                 (DSS),
          .FRF                 (FRF),
          .SCR                 (SCR),
          .SPO                 (SPO),
          .SPH                 (SPH),
          .SPISFRMEn           (SSPTBCR2[9]),
          .ESFRM               (SSPTBCR2[7:0]),
          .FRC                 (SSPTBCR2[8]),
          .TxFRdDataIn         (TxFRdDataIn),
          .SSPRXD              (SSPRXD),
          .OD                  (SSPTBCR1[5]),
          .STxFRdPtrInc        (STxFRdPtrInc),
          .SRxFWr              (SRxFWr),
          .STxRxBSY            (STxRxBSY),
          .SSPOE               (SSPOEOUT),
          .SSPTXD              (SSPTXD1),
          .SCLK                (SCLKOUT),
          .SFRM                (SFRMOUT),
          .RxFWrData           (SRxFWrData)
         );

SspTrDMA uSspTrDMA
         (
          .PCLK                (PCLK),
          .PRESETn             (PRESETn),
          .SSPTXDMACLRStag1    (SSPTDMACR[0]),
          .SSPRXDMACLRStag1    (SSPTDMACR[1]),
          .SSPTXDMACLR         (SSPTXDMACLR),
          .SSPRXDMACLR         (SSPRXDMACLR),
          .SSPTXDMACLRStag2    (SSPTXDMACLRStag2),
          .SSPRXDMACLRStag2    (SSPRXDMACLRStag2)
         );

endmodule


// --=========================== End =========================================--
