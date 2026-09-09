// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name              : AaciTrick.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           This block is the top level of the AACI TRICKBOX
//
// --=================================================================--

`timescale 1ns/1ps

`include   "AaciTrPackage.v"

// ---------------------------------------------------------------------

module AaciTrick (
// Inputs
                  // APB signals
                  PCLK,
                  PRESETn,
                  PSEL,
                  PSELCOM,
                  PENABLE,
                  PWRITE,
                  PADDR,
                  PWDATA,
                  // DMA request signals 
                  AACIDMASREQRX,
                  AACIDMALSREQRX,
                  AACIDMABREQRX,
                  AACIDMALBREQRX,
                  AACIDMABREQTX,
                  // Interrupt signals
                  AACIINTR,
                  AACITXINTR1,
                  AACITXINTR2,
                  AACITXINTR3,
                  AACITXINTR4,
                  AACIRXINTR1,
                  AACIRXINTR2,
                  AACIRXINTR3,
                  AACIRXINTR4,
                  AACIORINTR1,
                  AACIORINTR2,
                  AACIORINTR3,
                  AACIORINTR4,
                  AACITXCINTR1,
                  AACITXCINTR2,
                  AACITXCINTR3,
                  AACITXCINTR4,
                  AACIURINTR1,
                  AACIURINTR2,
                  AACIURINTR3,
                  AACIURINTR4,
                  AACIRXTOINTR1,
                  AACIRXTOINTR2,
                  AACIRXTOINTR3,
                  AACIRXTOINTR4,
                  AACIWINTR,
                  AACIGPIOINTR,
                  AACIS1RXINTR,
                  AACIS2RXINTR,
                  AACIS12RXINTR,
                  AACIS1TXINTR,
                  AACIS2TXINTR,
                  AACIS12TXINTR,
                  AACIRXTOFEINTR1,
                  AACIRXTOFEINTR2,
                  AACIRXTOFEINTR3,
                  AACIRXTOFEINTR4,


                  // AC LINK signals and related signals
                  AACIRESET,
                  AACISYNC,
                  AACISDATAIN,

// Outputs
                  AACISDATAOUT,
                  AACIBITCLK,
                  // Reset outputs
                  nAACIBITCLKRST,
                  nFAACIBITCLKRST,
                  // DMA request clear signals 
                  AACIDMACLRRX,
                  AACIDMACLRTX,
                  // APB o/p signal
                  PRDATA
                 );
// Inputs
input         PCLK;             // APB Clock
input         PRESETn;          // APB Reset
input         PSEL;             // APB Peripheral select
input         PSELCOM;          // APB Peripheral select
input         PENABLE;          // APB Peripheral enable
input         PWRITE;           // APB Peripheral write
input  [11:2] PADDR;            // APB High Addr
input  [31:0] PWDATA;           // APB Write databus

// DMA request signals
input         AACIDMASREQRX;    // AACI  single transfer req
input         AACIDMALSREQRX;   // AACI  single last transfer
input         AACIDMABREQRX;    // AACI  burst transfer req
input         AACIDMALBREQRX;   // AACI  burst last transfer
input         AACIDMABREQTX;    // AACI  single transfer req
 
// Interrupt signals
input         AACIINTR;         // AACI  combined interrupt
input         AACITXINTR1;      // Channel 1 fifo Tx intr
input         AACITXINTR2;      // Channel 2 fifo Tx intr
input         AACITXINTR3;      // Channel 3 fifo Tx intr
input         AACITXINTR4;      // Channel 4 fifo Tx intr
input         AACIRXINTR1;      // Channel 1 fifo Rx intr
input         AACIRXINTR2;      // Channel 2 fifo Rx intr
input         AACIRXINTR3;      // Channel 3 fifo Rx intr
input         AACIRXINTR4;      // Channel 4 fifo Rx intr
input         AACIORINTR1;      // Channel 1 fifo overrun Intr
input         AACIORINTR2;      // Channel 2 fifo overrun Intr
input         AACIORINTR3;      // Channel 3 fifo overrun Intr
input         AACIORINTR4;      // Channel 4 fifo overrun Intr
input         AACITXCINTR1;     // Channel 1 Tx complete Intr
input         AACITXCINTR2;     // Channel 2 Tx complete Intr
input         AACITXCINTR3;     // Channel 3 Tx complete Intr
input         AACITXCINTR4;     // Channel 4 Tx complete Intr
input         AACIURINTR1;      // Channel 1 Tx under run Intr
input         AACIURINTR2;      // Channel 2 Tx under run Intr
input         AACIURINTR3;      // Channel 3 Tx under run Intr
input         AACIURINTR4;      // Channel 4 Tx under run Intr
input         AACIRXTOINTR1;    // Channel 1 Rx timeout Intr
input         AACIRXTOINTR2;    // Channel 2 Rx timeout Intr
input         AACIRXTOINTR3;    // Channel 3 Rx timeout Intr
input         AACIRXTOINTR4;    // Channel 4 Rx timeout Intr
input         AACIWINTR;        // Wakeup Interrupt
input         AACIGPIOINTR;     // GPIO Interrupt
input         AACIS1RXINTR;     // Slot1 recieve interrupt
input         AACIS2RXINTR;     // Slot2 recieve interrupt
input         AACIS12RXINTR;    // Slot12 recieve interrupt
input         AACIS1TXINTR;     // Slot1 transmit interrupt
input         AACIS2TXINTR;     // Slot2 transmit interrupt
input         AACIS12TXINTR;    // Slot12 transmit interrupt
input         AACIRXTOFEINTR1;  // TimeOut FIFO Empty interrupt1
input         AACIRXTOFEINTR2;  // TimeOut FIFO Empty interrupt2
input         AACIRXTOFEINTR3;  // TimeOut FIFO Empty interrupt3
input         AACIRXTOFEINTR4;  // TimeOut FIFO Empty interrupt4
 
// AC LINK signals and related signals
input         AACIRESET;        // RESET port from AACI
input         AACISYNC;         // SYNC port from AACI
input         AACISDATAIN;      // AACISDATAOUT port from AACI
                                // Serial data input
// Outputs
output        AACISDATAOUT;     // AACISDATAIN port of AACI
                                // Serial data output
output        AACIBITCLK;       // AACIBITCLK output to AACI
// Reset outputs
output        nAACIBITCLKRST;   // Reset to AACI in AACIBITCLK domain
output        nFAACIBITCLKRST;  // Reset to AACI in nAACIBITCLK domain
// DMA request clear signals
output        AACIDMACLRRX;     // DMA receive request clear
output        AACIDMACLRTX;     // DMA transmit request clear
 
// APB o/p signal
output [31:0] PRDATA;           // Read databus

// Inputs
wire          PCLK;             // APB Clock
wire          PRESETn;          // APB Reset
wire          PSEL;             // APB Peripheral select
wire          PSELCOM;          // APB Peripheral select
wire          PENABLE;          // APB Peripheral enable
wire          PWRITE;           // APB Peripheral write
wire   [11:2] PADDR;            // APB Address bus
wire   [31:0] PWDATA;           // APB Write databus
wire          AACIDMASREQRX;    // AACI  single transfer req
wire          AACIDMALSREQRX;   // AACI  single last transfer req
wire          AACIDMABREQRX;    // AACI  burst transfer req
wire          AACIDMALBREQRX;   // AACI  burst last transfe req
wire          AACIDMABREQTX;    // AACI  single transfer req 
wire          AACIINTR;         // AACI  combined interrupt 
wire          AACITXINTR1;      // Channel 1 fifo Tx intr
wire          AACITXINTR2;      // Channel 2 fifo Tx intr
wire          AACITXINTR3;      // Channel 3 fifo Tx intr
wire          AACITXINTR4;      // Channel 4 fifo Tx intr
wire          AACIRXINTR1;      // Channel 1 fifo Rx intr
wire          AACIRXINTR2;      // Channel 2 fifo Rx intr
wire          AACIRXINTR3;      // Channel 3 fifo Rx intr
wire          AACIRXINTR4;      // Channel 4 fifo Rx intr
wire          AACIORINTR1;      // Channel 1 fifo overrun Intr
wire          AACIORINTR2;      // Channel 2 fifo overrun Intr
wire          AACIORINTR3;      // Channel 3 fifo overrun Intr
wire          AACIORINTR4;      // Channel 4 fifo overrun Intr
wire          AACITXCINTR1;     // Channel 1 Tx complete Intr
wire          AACITXCINTR2;     // Channel 2 Tx complete Intr
wire          AACITXCINTR3;     // Channel 3 Tx complete Intr
wire          AACITXCINTR4;     // Channel 4 Tx complete Intr
wire          AACIURINTR1;      // Channel 1 Tx under run Intr
wire          AACIURINTR2;      // Channel 2 Tx under run Intr
wire          AACIURINTR3;      // Channel 3 Tx under run Intr
wire          AACIURINTR4;      // Channel 4 Tx under run Intr
wire          AACIRXTOINTR1;    // Channel 1 Rx timeout Intr
wire          AACIRXTOINTR2;    // Channel 2 Rx timeout Intr
wire          AACIRXTOINTR3;    // Channel 3 Rx timeout Intr
wire          AACIRXTOINTR4;    // Channel 4 Rx timeout Intr
wire          AACIWINTR;        // Wakeup Interrupt
wire          AACIGPIOINTR;     // GPIO Interrupt
wire          AACIS1RXINTR;     // Slot1 recieve interrupt
wire          AACIS2RXINTR;     // Slot2 recieve interrupt
wire          AACIS12RXINTR;    // Slot12 recieve interrupt
wire          AACIS1TXINTR;     // Slot1 transmit interrupt
wire          AACIS2TXINTR;     // Slot2 transmit interrupt
wire          AACIS12TXINTR;    // Slot12 transmit interrupt

wire          AACIRESET;        // RESET port from AACI
wire          AACISYNC;         // SYNC port from AACI 
wire          AACISDATAIN;      // AACISDATAOUT port from AACI

// Outputs
wire          AACISDATAOUT;     // AACISDATAIN port of AACI
wire          AACIBITCLK;       // AACIBITCLK output to AACI
wire          nAACIBITCLKRST;   // Reset to AACI in AACIBITCLK domain
wire          nFAACIBITCLKRST;  // Reset to AACI in nAACIBITCLK domain
wire          AACIDMACLRRX;     // DMA receive request clear
wire          AACIDMACLRTX;     // DMA transmit request clear
wire   [31:0] PRDATA;           // Read databus

// ---------------------------------------------------------------------
// 
//                           AaciTrick
//                           =========
// 
// ---------------------------------------------------------------------
// 
// Overview
// ========
// 
// This module instantiates the following sub-modules: 
// 
// 1. AaciTrApbIf        - APB Interface
// 2. AaciTrRegBlk       - Register Block
// 3. AaciTrRxFIFO       - Receive FIFO
// 4. AaciTrTxFIFO       - Transmit FIFO
// 5. AaciTrMainCntl     - Transmitter/Receiver main state machine
// 6. AaciTrSnc2PClk     - Synchronisers for signals crossing into PCLK
//                         domain
// 7. AaciTrSnc2BtClk    - Synchronisers for signals crossing into 
//                         AACIBITCLK domain
// 8. AaciTrClkGen       - Clock generation Block
// 10.AaciTrProtChk      - Protocol Checker Block 

// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire [31:0] PWDataIn;         // Pheripharal input data
wire        RxFRdPtrInc;      // Receive FIFO Rd Ptr increment
wire        AACITrEn;         // trickbox enable
wire        AACITrWidChkEn;   // Data width Check enable
wire        AACITrTxEn;       // transmit FIFO enable
wire        AACITrRxEn;       // Receive  FIFO enable
wire        AACITrBtClkE;     // AACIBITCLK enable
wire        AACITrBtClkRst;   // AACIBITCLK domain reset bit
wire [31:0] AACITrIntr1Reg;   // Interrupt Reg
wire        AACITrIntr2Reg;   // Interrupt Reg
wire [15:0] AACITrBtClkPrd;   // AACIBITCLK Period
wire  [2:0] AACITrClkReg;     // Muxing register
wire  [6:5] AACITrDMAReg;     // DMA interfacing register
wire        FORCEDRESET;      // Reset Register
wire        FORCEDSYNC;       // Sync Register
wire [19:0] RxFRData;         // Control Reg 4
wire        AACITrTxFIFOWr;   // Control Reg 4
wire  [3:0] SlotState;        // Slot number in progress
wire        BITCLKIn;         // Internal version of BITCLK 
                              // to AACI 
wire        TxFRdPtrInc;      // Transmit FIFO read pointer 
                              // increment signal
wire        TxFRdPtrIncSync;  // Transmit FIFO read pointer 
                              // increment signal sync to PCLK
wire [19:0] TxFRdDataIn;      // Transmit FIFO read data 
wire [`POINTERWIDTH:0]
            TxFFillLevel;     // Transmit FIFO fill level 
wire        AACITrEnBSync;    // Trickbox enable on AACIBITCLK domain
wire        RxFWr;            // Recieve FIFO write signal
wire        RxFWrSync;        // Recieve FIFO write signal
                              // sync to PCLK 
wire [`POINTERWIDTH:0]
            RxFFillLevel;     // Receive FIFO fill level 
wire [19:0] RxFWrData;        // Recieve FIFO write signal
                              // sync to PCLK 

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Connects the internal signal to output
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// The APB Interface contains the Write interface and the Read interface
// for registers in the AacAaciickbox.
// ---------------------------------------------------------------------
AaciTrApbIf uAaciTrApbIf              (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSEL),
                    .PSELCOM          (PSELCOM),
                    .PWRITE           (PWRITE),
                    .PENABLE          (PENABLE),
                    .PADDR            (PADDR),
                    .PWDATA           (PWDATA),

                    .AACIDMASREQRX    (AACIDMASREQRX),
                    .AACIDMALSREQRX   (AACIDMALSREQRX),
                    .AACIDMABREQRX    (AACIDMABREQRX),
                    .AACIDMALBREQRX   (AACIDMALBREQRX),
                    .AACIDMABREQTX    (AACIDMABREQTX),
           
                    .AACIINTR         (AACIINTR),
                    .AACITXINTR1      (AACITXINTR1),
                    .AACITXINTR2      (AACITXINTR2),
                    .AACITXINTR3      (AACITXINTR3),
                    .AACITXINTR4      (AACITXINTR4),
                    .AACIRXINTR1      (AACIRXINTR1),
                    .AACIRXINTR2      (AACIRXINTR2),
                    .AACIRXINTR3      (AACIRXINTR3),
                    .AACIRXINTR4      (AACIRXINTR4),
                    .AACIORINTR1      (AACIORINTR1),
                    .AACIORINTR2      (AACIORINTR2),
                    .AACIORINTR3      (AACIORINTR3),
                    .AACIORINTR4      (AACIORINTR4),
                    .AACITXCINTR1     (AACITXCINTR1),
                    .AACITXCINTR2     (AACITXCINTR2),
                    .AACITXCINTR3     (AACITXCINTR3),
                    .AACITXCINTR4     (AACITXCINTR4),
                    .AACIURINTR1      (AACIURINTR1),
                    .AACIURINTR2      (AACIURINTR2),
                    .AACIURINTR3      (AACIURINTR3),
                    .AACIURINTR4      (AACIURINTR4),
                    .AACIRXTOINTR1    (AACIRXTOINTR1),
                    .AACIRXTOINTR2    (AACIRXTOINTR2),
                    .AACIRXTOINTR3    (AACIRXTOINTR3),
                    .AACIRXTOINTR4    (AACIRXTOINTR4),
                    .AACIWINTR        (AACIWINTR),
                    .AACIGPIOINTR     (AACIGPIOINTR),
                    .AACIS1RXINTR     (AACIS1RXINTR),
                    .AACIS2RXINTR     (AACIS2RXINTR),
                    .AACIS12RXINTR    (AACIS12RXINTR),
                    .AACIS1TXINTR     (AACIS1TXINTR),
                    .AACIS2TXINTR     (AACIS2TXINTR),
                    .AACIS12TXINTR    (AACIS12TXINTR),
                    .AACIRXTOFEINTR1  (AACIRXTOFEINTR1),
                    .AACIRXTOFEINTR2  (AACIRXTOFEINTR2),
                    .AACIRXTOFEINTR3  (AACIRXTOFEINTR3),
                    .AACIRXTOFEINTR4  (AACIRXTOFEINTR4),
 
                    .TxFFillLevel     (TxFFillLevel),
                    .RxFFillLevel     (RxFFillLevel),
                    .PCLKOn           (PCLKOn),
                    .BITCLKOn         (BITCLKOn),
                    .AACITrClkReg     (AACITrClkReg),
                    .AACITrDMAReg     (AACITrDMAReg),
                    .AACITrBtClkPrd   (AACITrBtClkPrd),
                    .RxFRData         (RxFRData),
                    .AACITRCNTRLWr    (AACITRCNTRLWr),
                    .AACITRCLKWr      (AACITRCLKWr),
                    .AACITRBTCLKWr    (AACITRBTCLKWr),
                    .AACITRDMAWr      (AACITRDMAWr),
                    .AACITrTxFIFOWr   (AACITrTxFIFOWr),
                    .AACITRRESETWr    (AACITRRESETWr),
                    .AACITSYNCWr      (AACITSYNCWr),
                    .RxFRdPtrInc      (RxFRdPtrInc),
                    .PRDATA           (PRDATA),
                    .PWDataIn         (PWDataIn)
                    );
 
// ---------------------------------------------------------------------
// The AaciTrRegBlk Block contains all the read/writable  registers
// in the AaciTrickbox. It also contains the PCLK-domain part of the 
// control logic required to synchronise the contents of AACITrCNTRL 
// register to the AACIBITCLK domain.
// ---------------------------------------------------------------------
AaciTrRegBlk uAaciTrRegBlk            (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PWDataIn         (PWDataIn),

                    .AACITSYNCWr      (AACITSYNCWr),
                    .AACITRRESETWr    (AACITRRESETWr),
                    .AACITRDMAWr      (AACITRDMAWr),
                    .AACITRBTCLKWr    (AACITRBTCLKWr),
                    .AACITRCLKWr      (AACITRCLKWr),
                    .AACITRCNTRLWr    (AACITRCNTRLWr),
           
                    // Control outputs to other submodules
                    .AACITrEn         (AACITrEn),
                    .AACITrWidChkEn   (AACITrWidChkEn),
                    .AACITrTxEn       (AACITrTxEn),
                    .AACITrRxEn       (AACITrRxEn),
                    .AACITrBtClkE     (AACITrBtClkE),
                    .AACITrBtClkRst   (AACITrBtClkRst),
                    .AACITrWintGen    (AACITrWintGen),
           
                    // Register outputs to other submodules
                    .AACITrBtClkPrd   (AACITrBtClkPrd),
                    .AACITrClkReg     (AACITrClkReg),
                    .AACITrDMAReg     (AACITrDMAReg),
                    .FORCEDRESET      (FORCEDRESET),
                    .FORCEDSYNC       (FORCEDSYNC),
                    .AACIDMACLRRX     (AACIDMACLRRX),
                    .AACIDMACLRTX     (AACIDMACLRTX)
                    );

// ---------------------------------------------------------------------
// The AaciTrTxFIFO block contains the Transmit FIFO and the control 
// logic required to regulate accesses to the FIFO.
// ---------------------------------------------------------------------
AaciTrTxFIFO uAaciTrTxFIFO            (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .AACITrTDRWr      (AACITrTxFIFOWr),
                    .TxFRdPtrIncSync  (TxFRdPtrIncSync),
                    .PWDataIn         (PWDataIn[19:0]),
                    .TxFRdDataIn      (TxFRdDataIn),
                    .TxFFillLevel     (TxFFillLevel)
                    );

// ---------------------------------------------------------------------
// The AaciTrRxFIFO block contains the Receive FIFO and the control 
// logic required to regulate accesses to the FIFO.
// ---------------------------------------------------------------------
AaciTrRxFIFO uAaciTrRxFIFO            (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .RxFWrSync        (RxFWrSync),
                    .RxFRdPtrInc      (RxFRdPtrInc),
                    .RxFWrData        (RxFWrData),
                    .RxFRdData        (RxFRData),
                    .RxFFillLevel     (RxFFillLevel)
                    );

// ---------------------------------------------------------------------
// This block contains synchronisers for signals crossing into the PCLK
// domain.
// ---------------------------------------------------------------------
AaciTrSnc2PClk uAaciTrSnc2PClk        (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .TxFRdPtrInc      (TxFRdPtrInc),
                    .RxFWr            (RxFWr),
                    .TxFRdPtrIncSync  (TxFRdPtrIncSync),
                    .RxFWrSync        (RxFWrSync)
                    );

// ---------------------------------------------------------------------
// The AaciTrSynctoAaciCLK block contains synchronisers for signals 
// crossing into the AACIBITCLK domain. 
// ---------------------------------------------------------------------
AaciTrSnc2BtClk uAaciTrSnc2BtClk      (
                    .BITCLKIn         (BITCLKIn),
                    .nAACIBITCLKRST   (nAACIBITCLKRST),
                    .AACITrTxEn       (AACITrTxEn),
                    .AACITrRxEn       (AACITrRxEn),
                    .AACITrEn         (AACITrEn),
                    .AACITrBtClkE     (AACITrBtClkE),
                    .AACITrWintGen    (AACITrWintGen),
                    .AACITrWidChkEn   (AACITrWidChkEn),
                    .AACITrEnBSync    (AACITrEnBSync),
                    .TxEnSync         (TxEnSync),
                    .RxEnSync         (RxEnSync),
                    .BtClkESync       (BtClkESync),
                    .WintGenSync      (WintGenSync),
                    .WidChkEnSync     (WidChkEnSync)
                    );

// ---------------------------------------------------------------------
// The AaciTrClkGen block contains the following processes
//                   * BITCLK generator and nAACIBITCLKRST generator 
// ---------------------------------------------------------------------
AaciTrClkGen uAaciTrClkGen            (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .AACITrBtClkE     (AACITrBtClkE),
                    .AACITrBtClkRst   (AACITrBtClkRst),
                    .AACITrBtClkPrd   (AACITrBtClkPrd),
                    .AACITrClkReg     (AACITrClkReg[2:0]),
                    .PCLKOn           (PCLKOn),
                    .BITCLKOn         (BITCLKOn),
                    .AACIBITCLK       (AACIBITCLK),
                    .BITCLKIn         (BITCLKIn),
                    .nAACIBITCLKRST   (nAACIBITCLKRST),
                    .nFAACIBITCLKRST  (nFAACIBITCLKRST)
                    );

// ---------------------------------------------------------------------
// The AaciTrChecker block contains protocol checkers that monitor the 
// Aaci's non-AMBA outputs. 
// ---------------------------------------------------------------------
AaciTrProtChk uAaciTrProtChk          (
                    .PRESETn          (PRESETn),
                    .PCLK             (PCLK),
                    .BITCLKIn         (BITCLKIn),
                    .AACITrEnBSync    (AACITrEnBSync),
                    .BtClkESync       (BtClkESync),
                    .AACITrEn         (AACITrEn),
                    .AACISDATAIN      (AACISDATAIN),
                    .SlotState        (SlotState),
                    .AACITrBtClkPrd   (AACITrBtClkPrd),
                    .AACISYNC         (AACISYNC),
                    .AACIRESET        (AACIRESET),    
                    .FORCEDRESET      (FORCEDRESET),
                    .FORCEDSYNC       (FORCEDSYNC),
                    .WidChkEnSync     (WidChkEnSync)
                    );
 
// ---------------------------------------------------------------------
// The AaciMTxRxCntl block contains the main Transmit/Receive control 
// logic in the trickbox that verifies the Master mode functionality 
// of the Aaci.
// ---------------------------------------------------------------------
AaciTrMainCntl uAaciTrMainCntl        (
                    .BITCLKIn         (BITCLKIn),
                    .nAACIBITCLKRST   (nAACIBITCLKRST),
                    .AACITrEnBSync    (AACITrEnBSync),
                    .TxEnSync         (TxEnSync),
                    .RxEnSync         (RxEnSync),
                    .BtClkESync       (BtClkESync),
                    .WintGenSync      (WintGenSync),
                    .AACISYNC          (AACISYNC),
                    .AACISDATAIN      (AACISDATAIN),
                    .TxFRdDataIn      (TxFRdDataIn),
                    .AACITrBtClkPrd   (AACITrBtClkPrd),
                    .TxFRdPtrInc      (TxFRdPtrInc),
                    .RxFWr            (RxFWr),
                    .AACISDATAOUT     (AACISDATAOUT),
                    .RxFWrData        (RxFWrData),
                    .SlotState        (SlotState)
                    ); 

endmodule

// --============================ End ================================--
