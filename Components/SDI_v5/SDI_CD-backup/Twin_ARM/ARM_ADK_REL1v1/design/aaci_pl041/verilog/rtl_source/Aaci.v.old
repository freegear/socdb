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
// File Name              : Aaci.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           This block is the top level of the Aaci.
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module Aaci (
// Inputs
             PCLK,
             AACIBITCLK,
             nAACIBITCLK,
             PRESETn,
             nAACIBITCLKRST,
             nFAACIBITCLKRST,
             PSEL,
             PENABLE,
             PWRITE,
             AACIDMACLRRX,
             AACIDMACLRTX,
             SCANENABLE,
             SCANINPCLK,
             SCANINBITCLK,
             SCANINnBITCLK,
             AACISDATAIN,
             PADDR,
             PWDATA,
// Outputs
             AACIRESET,
             AACISYNC,
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
             AACIURINTR1,
             AACIURINTR2,
             AACIURINTR3,
             AACIURINTR4,
             AACITXCINTR1,
             AACITXCINTR2,
             AACITXCINTR3,
             AACITXCINTR4,
             AACIRXTOINTR1,
             AACIRXTOINTR2,
             AACIRXTOINTR3,
             AACIRXTOINTR4,
             AACIWINTR,
             AACIGPIOINTR,
             AACIS12RXINTR,
             AACIS12TXINTR,
             AACIS2RXINTR,
             AACIS2TXINTR,
             AACIS1RXINTR,
             AACIS1TXINTR,
             AACIRXTOFEINTR1,
             AACIRXTOFEINTR2,
             AACIRXTOFEINTR3,
             AACIRXTOFEINTR4,
             AACIINTR,
             AACIDMASREQRX,
             AACIDMALSREQRX,
             AACIDMABREQRX,
             AACIDMALBREQRX,
             AACIDMABREQTX,
             SCANOUTPCLK,
             SCANOUTBITCLK,
             SCANOUTnBITCLK,
             AACISDATAOUT,
             PRDATA
            );

// Inputs
input         PCLK;            // APB Bus Clock
input         AACIBITCLK;      // AC-Link Clock
input         nAACIBITCLK;     // Inverted AC-Link Clock
input         PRESETn;         // APB Bus Reset
input         nAACIBITCLKRST;  // AACIBITCLK Reset
input         nFAACIBITCLKRST; // nAACIBITCLK Reset
input         PSEL;            // APB Peripheral select
input         PENABLE;         // APB Peripheral enable
input         PWRITE;          // APB Peripheral write
input         AACIDMACLRRX;    // DMA request clear for Rx requests
input         AACIDMACLRTX;    // DMA request clear for Tx request
input         SCANENABLE;      // Scan Enable
input         SCANINPCLK;      // PCLK domain ScanIn
input         SCANINBITCLK;    // AACIBITCLK domain ScanIn
input         SCANINnBITCLK;   // nAACIBITCLK domain ScanIn
input         AACISDATAIN;     // Serial DataIn from CODEC
input  [11:2] PADDR;           // APB address bus
input  [31:0] PWDATA;          // APB write databus

// Outputs
output        AACIRESET;       // AC-Link Reset
output        AACISYNC;        // AACIBITCLK divided by 256
output        AACITXINTR1;     // Channel 1 Tx interrupt
output        AACITXINTR2;     // Channel 2 Tx interrupt
output        AACITXINTR3;     // Channel 3 Tx interrupt
output        AACITXINTR4;     // Channel 4 Tx interrupt
output        AACIRXINTR1;     // Channel 1 Rx interrupt
output        AACIRXINTR2;     // Channel 2 Rx interrupt
output        AACIRXINTR3;     // Channel 3 Rx interrupt
output        AACIRXINTR4;     // Channel 4 Rx interrupt
output        AACIORINTR1;     // Channel 1 overrun interrupt
output        AACIORINTR2;     // Channel 2 overrun interrupt
output        AACIORINTR3;     // Channel 3 overrun interrupt
output        AACIORINTR4;     // Channel 4 overrun interrupt
output        AACIURINTR1;     // Channel 1 underrun interrupt
output        AACIURINTR2;     // Channel 2 underrun interrupt
output        AACIURINTR3;     // Channel 3 underrun interrupt
output        AACIURINTR4;     // Channel 4 underrun interrupt
output        AACITXCINTR1;    // Channel 1 Tx complete interrupt
output        AACITXCINTR2;    // Channel 2 Tx complete interrupt
output        AACITXCINTR3;    // Channel 3 Tx complete interrupt
output        AACITXCINTR4;    // Channel 4 Tx complete interrupt
output        AACIRXTOINTR1;   // Channel 1 Rx timeout interrupt
output        AACIRXTOINTR2;   // Channel 2 Rx timeout interrupt
output        AACIRXTOINTR3;   // Channel 3 Rx timeout interrupt
output        AACIRXTOINTR4;   // Channel 4 Rx timeout interrupt
output        AACIWINTR;       // Wakeup interrupt
output        AACIGPIOINTR;    // GPIO interrupt
output        AACIS12RXINTR;   // SLOT 12 Rx interrupt
output        AACIS12TXINTR;   // SLOT 12 Tx interrupt
output        AACIS2RXINTR;    // SLOT 2 Rx interrupt
output        AACIS2TXINTR;    // SLOT 2 Tx interrupt
output        AACIS1RXINTR;    // SLOT 1 Rx interrupt
output        AACIS1TXINTR;    // SLOT 1 Tx interrupt
output        AACIRXTOFEINTR1; // Channel 1 Rx timeout FIFO empty
                               // interrupt
output        AACIRXTOFEINTR2; // Channel 2 Rx timeout FIFO empty
                               // interrupt
output        AACIRXTOFEINTR3; // Channel 3 Rx timeout FIFO empty
                               // interrupt
output        AACIRXTOFEINTR4; // Channel 4 Rx timeout FIFO empty
                               // interrupt
output        AACIINTR;        // Combined Interrupt
output        AACIDMASREQRX;   // Single word Rx DMA transfer request
output        AACIDMALSREQRX;  // Last single word Rx DMA transfer
                               // request
output        AACIDMABREQRX;   // Burst receive DMA transfer request
output        AACIDMALBREQRX;  // Last burst receive DMA transfer
                               // request
output        AACIDMABREQTX;   // Burst transmit DMA transfer request
output        SCANOUTPCLK;     // PCLK domain ScanOut
output        SCANOUTBITCLK;   // BITCLK domain ScanOut
output        SCANOUTnBITCLK;  // nBITCLK domain ScanOut
output        AACISDATAOUT;    // Serial data out to CODEC
output [31:0] PRDATA;          // APB read databus

// Inputs
wire          PCLK;            // APB Bus Clock
wire          AACIBITCLK;      // AC-Link Clock
wire          nAACIBITCLK;     // Inverted AC-Link Clock
wire          PRESETn;         // APB Bus Reset
wire          nAACIBITCLKRST;  // AACIBITCLK Reset
wire          nFAACIBITCLKRST; // nAACIBITCLK Reset
wire          PSEL;            // APB Peripheral select
wire          PENABLE;         // APB Peripheral enable
wire          PWRITE;          // APB Peripheral write
wire          AACIDMACLRRX;    // DMA request clear for Rx requests
wire          AACIDMACLRTX;    // DMA request clear for Tx request
wire          SCANENABLE;      // Scan Enable
wire          SCANINPCLK;      // PCLK domain ScanIn
wire          SCANINBITCLK;    // AACIBITCLK domain ScanIn
wire          SCANINnBITCLK;   // nAACIBITCLK domain ScanIn
wire          AACISDATAIN;     // Serial DataIn from CODEC
wire   [11:2] PADDR;           // APB address bus
wire   [31:0] PWDATA;          // APB write databus

// Outputs
wire          AACIRESET;       // AC-Link Reset
wire          AACISYNC;        // AACIBITCLK divided by 256
wire          AACITXINTR1;     // Channel 1 Tx interrupt
wire          AACITXINTR2;     // Channel 2 Tx interrupt
wire          AACITXINTR3;     // Channel 3 Tx interrupt
wire          AACITXINTR4;     // Channel 4 Tx interrupt
wire          AACIRXINTR1;     // Channel 1 Rx interrupt
wire          AACIRXINTR2;     // Channel 2 Rx interrupt
wire          AACIRXINTR3;     // Channel 3 Rx interrupt
wire          AACIRXINTR4;     // Channel 4 Rx interrupt
wire          AACIORINTR1;     // Channel 1 overrun interrupt
wire          AACIORINTR2;     // Channel 2 overrun interrupt
wire          AACIORINTR3;     // Channel 3 overrun interrupt
wire          AACIORINTR4;     // Channel 4 overrun interrupt
wire          AACIURINTR1;     // Channel 1 underrun interrupt
wire          AACIURINTR2;     // Channel 2 underrun interrupt
wire          AACIURINTR3;     // Channel 3 underrun interrupt
wire          AACIURINTR4;     // Channel 4 underrun interrupt
wire          AACITXCINTR1;    // Channel 1 Tx complete interrupt
wire          AACITXCINTR2;    // Channel 2 Tx complete interrupt
wire          AACITXCINTR3;    // Channel 3 Tx complete interrupt
wire          AACITXCINTR4;    // Channel 4 Tx complete interrupt
wire          AACIRXTOINTR1;   // Channel 1 Rx timeout interrupt
wire          AACIRXTOINTR2;   // Channel 2 Rx timeout interrupt
wire          AACIRXTOINTR3;   // Channel 3 Rx timeout interrupt
wire          AACIRXTOINTR4;   // Channel 4 Rx timeout interrupt
wire          AACIWINTR;       // Wakeup interrupt
wire          AACIGPIOINTR;    // GPIO interrupt
wire          AACIS12RXINTR;   // SLOT 12 Rx interrupt
wire          AACIS12TXINTR;   // SLOT 12 Tx interrupt
wire          AACIS2RXINTR;    // SLOT 2 Rx interrupt
wire          AACIS2TXINTR;    // SLOT 2 Tx interrupt
wire          AACIS1RXINTR;    // SLOT 1 Rx interrupt
wire          AACIS1TXINTR;    // SLOT 1 Tx interrupt
wire          AACIRXTOFEINTR1; // Channel 1 Rx timeout FIFO empty
                               // interrupt
wire          AACIRXTOFEINTR2; // Channel 2 Rx timeout FIFO empty
                               // interrupt
wire          AACIRXTOFEINTR3; // Channel 3 Rx timeout FIFO empty
                               // interrupt
wire          AACIRXTOFEINTR4; // Channel 4 Rx timeout FIFO empty
                               // interrupt
wire          AACIINTR;        // Combined Interrupt
wire          AACIDMASREQRX;   // Single word Rx DMA transfer request
wire          AACIDMALSREQRX;  // Last single word Rx DMA transfer
                               // request
wire          AACIDMABREQRX;   // Burst receive DMA transfer request
wire          AACIDMALBREQRX;  // Last burst receive DMA transfer
                               // request
wire          AACIDMABREQTX;   // Burst transmit DMA transfer request
wire          SCANOUTPCLK;     // PCLK domain ScanOut
wire          SCANOUTBITCLK;   // BITCLK domain ScanOut
wire          SCANOUTnBITCLK;  // nBITCLK domain ScanOut
wire          AACISDATAOUT;    // Serial data out to CODEC
wire   [31:0] PRDATA;          // APB read databus

// ---------------------------------------------------------------------
//
//                                Aaci
//                                ====
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the AACI. This block instantiates
// the following functional sub-blocks in the AACI.
// - AaciApbifReg
// - AaciIntrGen
// - AaciFrmGen
// - AaciFrmDec
// - AaciSlot0Gen
// - AaciTmgCntl
// - AaciRxCntl
// - AaciTxCntl
// - AaciTxChannel
// - AaciDMATChannel
// - AaciRxChannel
// - AaciDMARChannel
// - AaciBtoPSync
// - AaciPtoBSync
// - AaciRevAnd
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire [31:0] RxFRdDataCo1;
// Receive FIFO 1 read data

wire [31:0] RxFRdDataCo2;
// Receive FIFO 2 read data

wire [31:0] RxFRdDataCo3;
// Receive FIFO 3 read data

wire [31:0] RxFRdDataCo4;
// Receive FIFO 4 read data

wire [28:0] AACIRXCR1;
// AACI receive control register for channel 1

wire [28:0] AACIRXCR2;
// AACI receive control register for channel 2

wire [28:0] AACIRXCR3;
// AACI receive control register for channel 3

wire [28:0] AACIRXCR4;
// AACI receive control register for channel 4

wire [16:0] AACITXCR1;
// AACI transmit control register for channel 1

wire [16:0] AACITXCR2;
// AACI transmit control register for channel 2

wire [16:0] AACITXCR3;
// AACI transmit control register for channel 3

wire [16:0] AACITXCR4;
// AACI transmit control register for channel 4

wire  [6:0] AACIISR1;
// AACI interrupt status register for channel 1

wire  [6:0] AACIIE1;
// AACI interrupt enable register for channel 1

wire  [6:0] AACIISR2;
// AACI interrupt status register for channel 2

wire  [6:0] AACIIE2;
// AACI interrupt enable register for channel 2

wire  [6:0] AACIISR3;
// AACI interrupt status register for channel 3

wire  [6:0] AACIIE3;
// AACI interrupt enable register for channel 3

wire  [6:0] AACIISR4;
// AACI interrupt status register for channel 4

wire  [6:0] AACIIE4;
// AACI interrupt enable register for channel 4

wire [19:0] AACISL1TX;
// Slot 1 Tx register

wire [19:4] Slot2Tx;
// AACISL2TX data bits to be transmitted in slot 2 of AACISDATAOUT

wire [19:0] AACISL12TX;
// Slot 12 Tx register

wire  [7:0] AACISLISTAT;
// Slot interrupts status register

wire  [8:0] AACISLIEN;
// Slot interrupts enable register

wire        ForcedSYNC;
// AACISYNC register bit

wire  [1:0] AACIITIP;
// Integration test input register

wire [29:0] AACIITOP0;
// Integration test output register 0

wire [12:0] AACIITOP1;
// Integration test output register 1

wire        ITEN;
// Integration test enable

wire  [1:0] FIFOTEST;
// FIFO test mode control bits

wire        ITIPDMACLRRX;
// DMACLRRX bit from AACIITIP

wire        ITIPDMACLRTX;
// DMACLRTX bit from AACIITIP

wire        ITOPSDATAOUT;
// AACISDATAOUT bit from AACIITIP

wire  [3:0] ITOPDMAREQRX;
// DMA receive request bits from AACIITOP0

wire        ITOPDMAREQTX;
// DMA transmit request bits from AACIITOP0

wire [23:0] ITOPINTR;
// Interrupt bits from AACIITOP0

wire        AACIDMACLRRXInt;
// Integration test muxed AACIDMACLRRX

wire        AACIDMACLRTXInt;
// Integration test muxed AACIDMACLRTX

wire        AACIDR1Wr;
// FIFO 1 write enable

wire        AACIDR2Wr;
// FIFO 2 write enable

wire        AACIDR3Wr;
// FIFO 3 write enable

wire        AACIDR4Wr;
// FIFO 4 write enable

wire        AACIDR1Rd;
// FIFO 1 read enable

wire        AACIDR2Rd;
// FIFO 2 read enable

wire        AACIDR3Rd;
// FIFO 3 read enable

wire        AACIDR4Rd;
// FIFO 4 read enable

wire        AACIRXCR1Wr;
// AACIRXCR1 write enable

wire        AACIRXCR2Wr;
// AACIRXCR2 write enable

wire        AACIRXCR3Wr;
// AACIRXCR3 write enable

wire        AACIRXCR4Wr;
// AACIRXCR4 write enable

wire        AACISL12RXRdCo;
// AACISL12RX read enable

wire [31:0] PWDataInt;
// Internal PWDATA

wire [11:0] TimeOutCnt1;
// Contents of TOC field of AACIRXCR1

wire [11:0] TimeOutCnt2;
// Contents of TOC field of AACIRXCR2

wire [11:0] TimeOutCnt3;
// Contents of TOC field of AACIRXCR3

wire [11:0] TimeOutCnt4;
// Contents of TOC field of AACIRXCR4

wire        RxFEn1;
// Rx FIFO 1 enable

wire        RxFEn2;
// Rx FIFO 2 enable

wire        RxFEn3;
// Rx FIFO 3 enable

wire        RxFEn4;
// Rx FIFO 4 enable

wire        RxCompactMode1;
// Compact mode enable for Rx FIFO 1

wire        RxCompactMode2;
// Compact mode enable for Rx FIFO 2

wire        RxCompactMode3;
// Compact mode enable for Rx FIFO 3

wire        RxCompactMode4;
// Compact mode enable for Rx FIFO 4

wire  [1:0] RSize1;
// Receive data size for channel 1

wire  [1:0] RSize2;
// Receive data size for channel 2

wire  [1:0] RSize3;
// Receive data size for channel 3

wire  [1:0] RSize4;
// Receive data size for channel 4

wire [12:1] Ch1Rx;
// Slot valid bits for receive FIFO 1

wire [12:1] Ch2Rx;
// Slot valid bits for receive FIFO 2

wire [12:1] Ch3Rx;
// Slot valid bits for receive FIFO 3

wire [12:1] Ch4Rx;
// Slot valid bits for receive FIFO 4

wire        RxEn1;
// Receive enable for channel 1

wire        RxEn2;
// Receive enable for channel 2

wire        RxEn3;
// Receive enable for channel 3

wire        RxEn4;
// Receive enable for channel 4

wire [12:1] Ch1Tx;
// Slot valid bits for transmit FIFO 1

wire [12:1] Ch2Tx;
// Slot valid bits for transmit FIFO 2

wire [12:1] Ch3Tx;
// Slot valid bits for transmit FIFO 3

wire [12:1] Ch4Tx;
// Slot valid bits for transmit FIFO 4

wire        TxEn1;
// Transmit enable for channel 1

wire        TxEn2;
// Transmit enable for channel 2

wire        TxEn3;
// Transmit enable for channel 3

wire        TxEn4;
// Transmit enable for channel 4

wire        TxFEn1;
// Transmit FIFO 1 enable

wire        TxFEn2;
// Transmit FIFO 2 enable

wire        TxFEn3;
// Transmit FIFO 3 enable

wire        TxFEn4;
// Transmit FIFO 4 enable

wire        TxCompactMode1;
// Compact mode enable for Tx FIFO 1

wire        TxCompactMode2;
// Compact mode enable for Tx FIFO 2

wire        TxCompactMode3;
// Compact mode enable for Tx FIFO 3

wire        TxCompactMode4;
// Compact mode enable for Tx FIFO 4

wire  [1:0] TSize1;
// Transmit data size for channel 1

wire  [1:0] TSize2;
// Transmit data size for channel 2

wire  [1:0] TSize3;
// Transmit data size for channel 3

wire  [1:0] TSize4;
// Transmit data size for channel 4

wire        DMAEnable;
// DMA logic enable

wire  [1:0] SCRA;
// Secondary CODEC Register Access bits

wire        Sl12TxEn;
// Slot 12 Tx register enable

wire        Sl12RxEn;
// Slot 12 Rx register enable

wire        Sl2TxEn;
// Slot 2 Tx register enable

wire        Sl1TxEn;
// Slot 1 Tx register enable

wire        Sl12TxEnSync;
// Synchronised version of Sl12TxEn

wire        Sl2TxEnSync;
// Synchronised version of Sl2TxEn

wire        Sl1TxEnSync;
// Synchronised version of Sl1TxEn

wire        LowPowerMode;
// Low Power Mode bit

wire        LoopBack;
// Loopback mode enable

wire        AacIfE;
// AACI enable

wire        LoopBackSync;
// Synchronised LoopBack

wire        AacIfESync;
// Synchronised AacIfE

wire        LPMDetected;
// Low power mode entry detected pulse

wire        LPMTogl;
// Low power mode entry detected toggle signal

wire        LPMToglSync;
// Synchronised LPMTogl

wire        LPMXorCo;
// Pulse to indicate toggling of LPMToglSync

wire  [7:0] AACIBITCLKCnt;
// AACIBITCLK count value

wire        FrameState;
// State of frame state machine

wire [19:0] RxDataIn;
// Last slot data received on AACISDATAIN

wire [12:1] RxSlValid;
// Received slot valid indictor

wire        RxSlNoUpd;
// Received slot no. update indicator

wire        RxSlNoUpdXorCo;
// Pulse to indicate RxSlNoUpd toggling

wire [12:3] VarRate;
// Variable rate bits for slots 3 to 12

wire        Sl12RegValid;
// Slot 12 Tx register valid

wire        Sl2RegValid;
// Slot 2 Tx register valid

wire        Sl1RegValid;
// Slot 1 Tx register valid

wire [15:3] Slot0DataCo;
// Combinational slot 0 data

wire [19:0] Fifo1DataCo;
// Tx FIFO 1 read data

wire [19:0] Fifo2DataCo;
// Tx FIFO 2 read data

wire [19:0] Fifo3DataCo;
// Tx FIFO 3 read data

wire [19:0] Fifo4DataCo;
// Tx FIFO 4 read data

wire        TxBusy1;
// Tx FIFO 1 busy

wire        TxBusy2;
// Tx FIFO 2 busy

wire        TxBusy3;
// Tx FIFO 3 busy

wire        TxBusy4;
// Tx FIFO 4 busy

wire        RxBusy1;
// Rx FIFO 1 busy

wire        RxBusy2;
// Rx FIFO 2 busy

wire        RxBusy3;
// Rx FIFO 3 busy

wire        RxBusy4;
// Rx FIFO 4 busy

wire        RxSlot0;
// End of Slot 0 reception

wire        RxSlot0Sync;
// Synchronised RxSlot0

wire        RxSlot0XorCo;
// Pulse to indicate RxSlot0 toggling

wire [12:1] SlotValid;
// Slot valid information from received slot 0

wire        LstSlTxed;
// Last slot transmitted from a Tx FIFO for current frame

wire        LstSlTxedSync;
// Synchronised LstSlTxed

wire        LstSlXorCo;
// Pulse to indicate LstSlTxed toggle

wire  [4:1] LstSlFifoSel;
// Fifo select for LstSlTxed

wire        TxFF1;
// Tx FIFO 1 full

wire        TxFF2;
// Tx FIFO 2 full

wire        TxFF3;
// Tx FIFO 3 full

wire        TxFF4;
// Tx FIFO 4 full

wire        RxFF1;
// Rx FIFO 1 full

wire        RxFF2;
// Rx FIFO 2 full

wire        RxFF3;
// Rx FIFO 3 full

wire        RxFF4;
// Rx FIFO 4 full

wire        RxHF1;
// Rx FIFO 1 half-full

wire        RxHF2;
// Rx FIFO 2 half-full

wire        RxHF3;
// Rx FIFO 3 half-full

wire        RxHF4;
// Rx FIFO 4 half-full

wire        TxFE1;
// Tx FIFO 1 empty

wire        TxFE2;
// Tx FIFO 2 empty

wire        TxFE3;
// Tx FIFO 3 empty

wire        TxFE4;
// Tx FIFO 4 empty

wire        RxFE1;
// Rx FIFO 1 empty

wire        RxFE2;
// Rx FIFO 2 empty

wire        RxFE3;
// Rx FIFO 3 empty

wire        RxFE4;
// Rx FIFO 4 empty

wire        TxUnderrun1;
// Channel 1 Tx underrun

wire        TxUnderrun2;
// Channel 2 Tx underrun

wire        TxUnderrun3;
// Channel 3 Tx underrun

wire        TxUnderrun4;
// Channel 4 Tx underrun

wire        TxUnderrun1Sync;
// Synchronised TxUnderrun1

wire        TxUnderrun2Sync;
// Synchronised TxUnderrun2

wire        TxUnderrun3Sync;
// Synchronised TxUnderrun3

wire        TxUnderrun4Sync;
// Synchronised TxUnderrun4

wire        RxTOFE1;
// Channel 1 Rx timeout FIFO empty

wire        RxTOFE2;
// Channel 2 Rx timeout FIFO empty

wire        RxTOFE3;
// Channel 3 Rx timeout FIFO empty

wire        RxTOFE4;
// Channel 4 Rx timeout FIFO empty

wire        RxOverrun1;
// Channel 1 receive overrun

wire        RxOverrun2;
// Channel 2 receive overrun

wire        RxOverrun3;
// Channel 3 receive overrun

wire        RxOverrun4;
// Channel 4 receive overrun

wire  [4:1] RxFWrPtrIncCo;
// Rx FIFO read pointer increment for channels 4 to 1

wire        RxSlNoUpdSync;
// Synchronised RxSlNoUpd

wire  [4:1] TxFValid;
// Tx FIFO valid for channels 4 to 1

wire  [4:1] TxFValidSync;
// Synchronised TxFValid

wire        RdPtr01;
// Bit 0 of Channel 1 Tx FIFO read pointer

wire        RdPtr02;
// Bit 0 of Channel 2 Tx FIFO read pointer

wire        RdPtr03;
// Bit 0 of Channel 3 Tx FIFO read pointer

wire        RdPtr04;
// Bit 0 of Channel 4 Tx FIFO read pointer

wire        Sl12RxValid;
// Slot 12 Rx register valid

wire        Sl2RxValid;
// Slot 2 Rx register valid

wire        Sl1RxValid;
// Slot 1 Rx register valid

wire        Sl12TxEmpty;
// Slot 12 Tx register empty

wire        Sl2TxEmpty;
// Slot 2 Tx register empty

wire        Sl1TxEmpty;
// Slot 1 Tx register empty

wire  [4:1] TxFRdPtrIncCo;
// Tx FIFO read pointer increment for the channels 4 to 1

wire [19:0] TxFRdDataL1Co;
// Tx FIFO 1 left buffer read data

wire [19:0] TxFRdDataR1Co;
// Tx FIFO 1 right buffer read data

wire [19:0] TxFRdDataL2Co;
// Tx FIFO 2 left buffer read data

wire [19:0] TxFRdDataR2Co;
// Tx FIFO 2 right buffer read data

wire [19:0] TxFRdDataL3Co;
// Tx FIFO 3 left buffer read data

wire [19:0] TxFRdDataR3Co;
// Tx FIFO 3 right buffer read data

wire [19:0] TxFRdDataL4Co;
// Tx FIFO 4 left buffer read data

wire [19:0] TxFRdDataR4Co;
// Tx FIFO 4 right buffer read data

wire        TxHE1;
// Tx FIFO 1 half-empty

wire        TxHE2;
// Tx FIFO 2 half-empty

wire        TxHE3;
// Tx FIFO 3 half-empty

wire        TxHE4;
// Tx FIFO 4 half-empty

wire        RxTimeout1;
// Receive FIFO 1 timeout

wire        RxTimeout2;
// Receive FIFO 2 timeout

wire        RxTimeout3;
// Receive FIFO 3 timeout

wire        RxTimeout4;
// Receive FIFO 4 timeout

wire        Sl12RxChng;
// Toggle signal to indicate received slot 12 change

wire        Sl12RxChngSync;
// Synchronised Sl12RxChng

wire        Sl12TxChng;
// Toggle signal to indicate slot 12 Tx register write

wire        Sl2TxChng;
// Toggle signal to indicate slot 2 Tx register write

wire        Sl1TxChng;
// Toggle signal to indicate slot 1 Tx register write

wire        Sl12TxClr;
// Slot 12 Tx busy clear

wire        Sl2TxClr;
// Slot 2 Tx busy clear

wire        Sl1TxClr;
// Slot 1 Tx busy clear

wire        Sl12TxE;
// Slot 12 Tx register data loaded into Tx shift register

wire        Sl2TxE;
// Slot 2 Tx register data loaded into Tx shift register

wire        Sl1TxE;
// Slot 1 Tx register data loaded into Tx shift register

wire        Sl12TxESync;
// Synchronised Sl12TxE

wire        Sl2TxESync;
// Synchronised Sl2TxE

wire        Sl1TxESync;
// Synchronised Sl1TxE

wire        Sl12TxChngSync;
// Synchronised Sl12TxChng

wire        Sl2TxChngSync;
// Synchronised Sl2TxChng

wire        Sl1TxChngSync;
// Synchronised Sl1TxChng

wire        Sl12TxClrSync;
// Synchronised Sl12TxClr

wire        Sl2TxClrSync;
// Synchronised Sl2TxClr

wire        Sl1TxClrSync;
// Synchronised Sl1TxClr

wire        Ch4TxChngSync;
// Synchronised Ch4TxChng

wire        Ch3TxChngSync;
// Synchronised Ch3TxChng

wire        Ch2TxChngSync;
// Synchronised Ch2TxChng

wire        Ch1TxChngSync;
// Synchronised Ch1TxChng

wire        Ch4TxClrSync;
// Synchronised Ch4TxClr

wire        Ch3TxClrSync;
// Synchronised Ch3TxClr

wire        Ch2TxClrSync;
// Synchronised Ch2TxClr

wire        Ch1TxClrSync;
// Synchronised Ch1TxClr

wire        Ch4TxChng;
// Toggle signal to indicate a valid write to AACITXCR1

wire        Ch3TxChng;
// Toggle signal to indicate a valid write to AACITXCR2

wire        Ch2TxChng;
// Toggle signal to indicate a valid write to AACITXCR3

wire        Ch1TxChng;
// Pulse to indicate a valid write to AACITXCR4

wire        TxUE4ClrCo;
// Pulse to indicate a write of 1 to TxUEC4 bit of AACIINTCLR

wire        TxUE3ClrCo;
// Pulse to indicate a write of 1 to TxUEC3 bit of AACIINTCLR

wire        TxUE2ClrCo;
// Pulse to indicate a write of 1 to TxUEC2 bit of AACIINTCLR

wire        TxUE1ClrCo;
// Toggle signal to indicate a write of 1 to TxUEC1 bit of AACIINTCLR

wire        RxOEClr1Co;
// Pulse to indicate a write of 1 to RxOEC1 bit of AACIINTCLR

wire        RxOEClr2Co;
// Pulse to indicate a write of 1 to RxOEC2 bit of AACIINTCLR

wire        RxOEClr3Co;
// Pulse to indicate a write of 1 to RxOEC3 bit of AACIINTCLR

wire        RxOEClr4Co;
// Pulse to indicate a write of 1 to RxOEC4 bit of AACIINTCLR

wire        RxTOFEClr1Co;
// Pulse to indicate a write of 1 to RxTOFEC1 bit of AACIINTCLR

wire        RxTOFEClr2Co;
// Pulse to indicate a write of 1 to RxTOFEC2 bit of AACIINTCLR

wire        RxTOFEClr3Co;
// Pulse to indicate a write of 1 to RxTOFEC3 bit of AACIINTCLR

wire        RxTOFEClr4Co;
// Pulse to indicate a write of 1 to RxTOFEC4 bit of AACIINTCLR

wire        WINTClrCo;
// Pulse to indicate a write of 1 to WISC bit of AACIINTCLR

wire        Ch4TxClr;
// Ch4TxChng clear

wire        Ch3TxClr;
// Ch3TxChng clear

wire        Ch2TxClr;
// Ch2TxChng clear

wire        Ch1TxClr;
// Ch1TxChng clear

wire        AACISDATAINIntCo;
// Internally generated AACISDATAIN

wire        AACISDATAINSync;
// AACISDATAIN Double synchronized into PCLK domain

wire        RawGPIOINTR;
// Raw status of GPIO Interrupt

wire        RawWINTRSync;
// Raw status of Synchronised Wakeup Interrupt

wire        TxUE1;
// Raw status of Underrun Interrupt from Channel 1

wire        TxUE2;
// Raw status of Underrun Interrupt from Channel 2

wire        TxUE3;
// Raw status of Underrun Interrupt from Channel 3

wire        TxUE4;
// Raw status of Underrun Interrupt from Channel 4

wire        RdPtrInc;
// Signal to generate increment read pointer increment for one of the
// channels

wire        RdPtrIncSync;
// Synchronised RdPtrInc

wire  [4:1] FifoSel;
// Tx Fifo select for read pointer increment generation

wire  [3:1] FDataSel;
// Tx Fifo data select for muxing data from the 4 channels

wire  [3:0] Sl1DataSel;
// Data source select for Slot 1 data

wire  [3:0] TieOff1;
// Input 1 for RevAnd

wire  [3:0] TieOff2;
// Input 2 for RevAnd

wire  [3:0] Revision;
// Output of RevAnd

wire        Slot1Valid;
// Slot valid bit for slot 1 in the incoming frame's slot 0

wire        Slot2Valid;
// slot valid bit for slot 2 in the incoming frame's slot 0

wire        Slot12Valid;
// slot valid bit for slot 12 in the incoming frame's slot 0

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Function declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Instantiation of AaciApbifReg
// ---------------------------------------------------------------------
AaciApbifReg uAaciApbifReg            (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSEL),
                    .PWRITE           (PWRITE),
                    .PENABLE          (PENABLE),
                    .Revision         (Revision),
                    .RawGPIOINTR      (RawGPIOINTR),
                    .RawWINTRSync     (RawWINTRSync),
                    .AACISDATAIN      (AACISDATAIN),
                    .AACIDMACLRRXInt  (AACIDMACLRRXInt),
                    .AACIDMACLRTXInt  (AACIDMACLRTXInt),
                    .AACIDMASREQRX    (AACIDMASREQRX),
                    .AACIDMABREQRX    (AACIDMABREQRX),
                    .AACIDMALSREQRX   (AACIDMALSREQRX),
                    .AACIDMALBREQRX   (AACIDMALBREQRX),
                    .AACIDMABREQTX    (AACIDMABREQTX),
                    .AACIRXINTR1      (AACIRXINTR1),
                    .AACIRXINTR2      (AACIRXINTR2),
                    .AACIRXINTR3      (AACIRXINTR3),
                    .AACIRXINTR4      (AACIRXINTR4),
                    .AACITXINTR1      (AACITXINTR1),
                    .AACITXINTR2      (AACITXINTR2),
                    .AACITXINTR3      (AACITXINTR3),
                    .AACITXINTR4      (AACITXINTR4),
                    .AACIORINTR1      (AACIORINTR1),
                    .AACIORINTR2      (AACIORINTR2),
                    .AACIORINTR3      (AACIORINTR3),
                    .AACIORINTR4      (AACIORINTR4),
                    .AACIURINTR1      (AACIURINTR1),
                    .AACIURINTR2      (AACIURINTR2),
                    .AACIURINTR3      (AACIURINTR3),
                    .AACIURINTR4      (AACIURINTR4),
                    .AACIRXTOINTR1    (AACIRXTOINTR1),
                    .AACIRXTOINTR2    (AACIRXTOINTR2),
                    .AACIRXTOINTR3    (AACIRXTOINTR3),
                    .AACIRXTOINTR4    (AACIRXTOINTR4),
                    .AACITXCINTR1     (AACITXCINTR1),
                    .AACITXCINTR2     (AACITXCINTR2),
                    .AACITXCINTR3     (AACITXCINTR3),
                    .AACITXCINTR4     (AACITXCINTR4),
                    .AACIRXTOFEINTR1  (AACIRXTOFEINTR1),
                    .AACIRXTOFEINTR2  (AACIRXTOFEINTR2),
                    .AACIRXTOFEINTR3  (AACIRXTOFEINTR3),
                    .AACIRXTOFEINTR4  (AACIRXTOFEINTR4),
                    .AACIWINTR        (AACIWINTR),
                    .AACIGPIOINTR     (AACIGPIOINTR),
                    .AACIS1RXINTR     (AACIS1RXINTR),
                    .AACIS2RXINTR     (AACIS2RXINTR),
                    .AACIS12RXINTR    (AACIS12RXINTR),
                    .AACIS1TXINTR     (AACIS1TXINTR),
                    .AACIS2TXINTR     (AACIS2TXINTR),
                    .AACIS12TXINTR    (AACIS12TXINTR),
                    .AACIINTR         (AACIINTR),
                    .TxBusy1          (TxBusy1),
                    .TxBusy2          (TxBusy2),
                    .TxBusy3          (TxBusy3),
                    .TxBusy4          (TxBusy4),
                    .RxBusy1          (RxBusy1),
                    .RxBusy2          (RxBusy2),
                    .RxBusy3          (RxBusy3),
                    .RxBusy4          (RxBusy4),
                    .TxHE1            (TxHE1),
                    .TxHE2            (TxHE2),
                    .TxHE3            (TxHE3),
                    .TxHE4            (TxHE4),
                    .TxFF1            (TxFF1),
                    .TxFF2            (TxFF2),
                    .TxFF3            (TxFF3),
                    .TxFF4            (TxFF4),
                    .RxFF1            (RxFF1),
                    .RxFF2            (RxFF2),
                    .RxFF3            (RxFF3),
                    .RxFF4            (RxFF4),
                    .RxHF1            (RxHF1),
                    .RxHF2            (RxHF2),
                    .RxHF3            (RxHF3),
                    .RxHF4            (RxHF4),
                    .TxFE1            (TxFE1),
                    .TxFE2            (TxFE2),
                    .TxFE3            (TxFE3),
                    .TxFE4            (TxFE4),
                    .RxFE1            (RxFE1),
                    .RxFE2            (RxFE2),
                    .RxFE3            (RxFE3),
                    .RxFE4            (RxFE4),
                    .RxTOFE1          (RxTOFE1),
                    .RxTOFE2          (RxTOFE2),
                    .RxTOFE3          (RxTOFE3),
                    .RxTOFE4          (RxTOFE4),
                    .RxTimeout1       (RxTimeout1),
                    .RxTimeout2       (RxTimeout2),
                    .RxTimeout3       (RxTimeout3),
                    .RxTimeout4       (RxTimeout4),
                    .TxUE1            (TxUE1),
                    .TxUE2            (TxUE2),
                    .TxUE3            (TxUE3),
                    .TxUE4            (TxUE4),
                    .RxOverrun1       (RxOverrun1),
                    .RxOverrun2       (RxOverrun2),
                    .RxOverrun3       (RxOverrun3),
                    .RxOverrun4       (RxOverrun4),
                    .RxSl1Valid       (RxSlValid[1]),
                    .RxSl2Valid       (RxSlValid[2]),
                    .RxSl12Valid      (RxSlValid[12]),
                    .Slot1Valid       (Slot1Valid),
                    .Slot2Valid       (Slot2Valid),
                    .Slot12Valid      (Slot12Valid),
                    .RxSlot0XorCo     (RxSlot0XorCo),
                    .LPMXorCo         (LPMXorCo),
                    .Ch1TxClrSync     (Ch1TxClrSync),
                    .Ch2TxClrSync     (Ch2TxClrSync),
                    .Ch3TxClrSync     (Ch3TxClrSync),
                    .Ch4TxClrSync     (Ch4TxClrSync),
                    .Sl12TxClrSync    (Sl12TxClrSync),
                    .Sl2TxClrSync     (Sl2TxClrSync),
                    .Sl1TxClrSync     (Sl1TxClrSync),
                    .Sl12TxESync      (Sl12TxESync),
                    .Sl2TxESync       (Sl2TxESync),
                    .Sl1TxESync       (Sl1TxESync),
                    .RxSlNoUpdXorCo   (RxSlNoUpdXorCo),
                    .AACIISR1         (AACIISR1),
                    .AACIISR2         (AACIISR2),
                    .AACIISR3         (AACIISR3),
                    .AACIISR4         (AACIISR4),
                    .AACISLISTAT      (AACISLISTAT),
                    .RxFRdDataCo1     (RxFRdDataCo1),
                    .RxFRdDataCo2     (RxFRdDataCo2),
                    .RxFRdDataCo3     (RxFRdDataCo3),
                    .RxFRdDataCo4     (RxFRdDataCo4),
                    .Fifo1DataCo      (Fifo1DataCo),
                    .Fifo2DataCo      (Fifo2DataCo),
                    .Fifo3DataCo      (Fifo3DataCo),
                    .Fifo4DataCo      (Fifo4DataCo),
                    .RxDataIn         (RxDataIn),
                    .PWDATA           (PWDATA),
                    .PADDR            (PADDR),
                    .AACIDR1Wr        (AACIDR1Wr),
                    .AACIDR2Wr        (AACIDR2Wr),
                    .AACIDR3Wr        (AACIDR3Wr),
                    .AACIDR4Wr        (AACIDR4Wr),
                    .AACIRXCR1Wr      (AACIRXCR1Wr),
                    .AACIRXCR2Wr      (AACIRXCR2Wr),
                    .AACIRXCR3Wr      (AACIRXCR3Wr),
                    .AACIRXCR4Wr      (AACIRXCR4Wr),
                    .AACIDR1Rd        (AACIDR1Rd),
                    .AACIDR2Rd        (AACIDR2Rd),
                    .AACIDR3Rd        (AACIDR3Rd),
                    .AACIDR4Rd        (AACIDR4Rd),
                    .AACISL12RXRdCo   (AACISL12RXRdCo),
                    .AACIRXCR1        (AACIRXCR1),
                    .AACIRXCR2        (AACIRXCR2),
                    .AACIRXCR3        (AACIRXCR3),
                    .AACIRXCR4        (AACIRXCR4),
                    .AACITXCR1        (AACITXCR1),
                    .AACITXCR2        (AACITXCR2),
                    .AACITXCR3        (AACITXCR3),
                    .AACITXCR4        (AACITXCR4),
                    .AACIIE1          (AACIIE1),
                    .AACIIE2          (AACIIE2),
                    .AACIIE3          (AACIIE3),
                    .AACIIE4          (AACIIE4),
                    .AACISL1TX        (AACISL1TX),
                    .Slot2Tx          (Slot2Tx),
                    .AACISL12TX       (AACISL12TX),
                    .AACISLIEN        (AACISLIEN),
                    .SCRA             (SCRA),
                    .DMAEnable        (DMAEnable),
                    .Sl12TxEn         (Sl12TxEn),
                    .Sl2TxEn          (Sl2TxEn),
                    .Sl1TxEn          (Sl1TxEn),
                    .Sl12RxEn         (Sl12RxEn),
                    .LowPowerMode     (LowPowerMode),
                    .LoopBack         (LoopBack),
                    .AacIfE           (AacIfE),
                    .AACIRESET        (AACIRESET),
                    .ForcedSYNC       (ForcedSYNC),
                    .FIFOTEST         (FIFOTEST),
                    .ITEN             (ITEN),
                    .AACIITIP         (AACIITIP),
                    .AACIITOP0        (AACIITOP0),
                    .AACIITOP1        (AACIITOP1),
                    .Sl12RxValid      (Sl12RxValid),
                    .Sl2RxValid       (Sl2RxValid),
                    .Sl1RxValid       (Sl1RxValid),
                    .Sl12TxEmpty      (Sl12TxEmpty),
                    .Sl2TxEmpty       (Sl2TxEmpty),
                    .Sl1TxEmpty       (Sl1TxEmpty),
                    .Ch1TxChng        (Ch1TxChng),
                    .Ch2TxChng        (Ch2TxChng),
                    .Ch3TxChng        (Ch3TxChng),
                    .Ch4TxChng        (Ch4TxChng),
                    .Sl12TxChng       (Sl12TxChng),
                    .Sl2TxChng        (Sl2TxChng),
                    .Sl1TxChng        (Sl1TxChng),
                    .TxUE1ClrCo       (TxUE1ClrCo),
                    .TxUE2ClrCo       (TxUE2ClrCo),
                    .TxUE3ClrCo       (TxUE3ClrCo),
                    .TxUE4ClrCo       (TxUE4ClrCo),
                    .RxOEClr1Co       (RxOEClr1Co),
                    .RxOEClr2Co       (RxOEClr2Co),
                    .RxOEClr3Co       (RxOEClr3Co),
                    .RxOEClr4Co       (RxOEClr4Co),
                    .RxTOFEClr1Co     (RxTOFEClr1Co),
                    .RxTOFEClr2Co     (RxTOFEClr2Co),
                    .RxTOFEClr3Co     (RxTOFEClr3Co),
                    .RxTOFEClr4Co     (RxTOFEClr4Co),
                    .WINTClrCo        (WINTClrCo),
                    .PRDATA           (PRDATA),
                    .PWDataInt        (PWDataInt)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciFrmDec
// ---------------------------------------------------------------------
AaciFrmDec uAaciFrmDec                (
                    .nAACIBITCLK      (nAACIBITCLK),
                    .nFAACIBITCLKRST  (nFAACIBITCLKRST),
                    .AACISDATAIN      (AACISDATAIN),
                    .AACISDATAOUT     (AACISDATAOUT),
                    .LPMDetected      (LPMDetected),
                    .LoopBackSync     (LoopBackSync),
                    .AacIfESync       (AacIfESync),
                    .AACIBITCLKCnt    (AACIBITCLKCnt),
                    .AACISDATAINIntCo (AACISDATAINIntCo),
                    .FrameState       (FrameState),
                    .Sl12RxChng       (Sl12RxChng),
                    .RxDataIn         (RxDataIn),
                    .SlotValid        (SlotValid),
                    .RxSlValid        (RxSlValid),
                    .RxSlNoUpd        (RxSlNoUpd),
                    .RxSlot0          (RxSlot0),
                    .VarRate          (VarRate)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciFrmGen
// ---------------------------------------------------------------------
AaciFrmGen uAaciFrmGen                (
                    .AACIBITCLK       (AACIBITCLK),
                    .nAACIBITCLKRST   (nAACIBITCLKRST),
                    .Sl12RegValid     (Sl12RegValid),
                    .Sl2RegValid      (Sl2RegValid),
                    .Sl1RegValid      (Sl1RegValid),
                    .Slot0DataCo      (Slot0DataCo),
                    .AACISL1TX        (AACISL1TX),
                    .Slot2Tx          (Slot2Tx),
                    .AACISL12TX       (AACISL12TX),
                    .AacIfESync       (AacIfESync),
                    .SCRA             (SCRA),
                    .Fifo1DataCo      (Fifo1DataCo),
                    .Fifo2DataCo      (Fifo2DataCo),
                    .Fifo3DataCo      (Fifo3DataCo),
                    .Fifo4DataCo      (Fifo4DataCo),
                    .FDataSel         (FDataSel),
                    .Sl1DataSel       (Sl1DataSel),
                    .AACIBITCLKCnt    (AACIBITCLKCnt),
                    .FrameState       (FrameState),
                    .ITEN             (ITEN),
                    .ITOPSDATAOUT     (ITOPSDATAOUT),
                    .LPMDetected      (LPMDetected),
                    .LPMTogl          (LPMTogl),
                    .AACISDATAOUT     (AACISDATAOUT)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciSlot0Gen
// ---------------------------------------------------------------------
AaciSlot0Gen uAaciSlot0Gen            (
                    .AACIBITCLK       (AACIBITCLK),
                    .nAACIBITCLKRST   (nAACIBITCLKRST),
                    .AacIfESync       (AacIfESync),
                    .Sl1TxEnSync      (Sl1TxEnSync),
                    .Sl2TxEnSync      (Sl2TxEnSync),
                    .Sl12TxEnSync     (Sl12TxEnSync),
                    .TxEn1            (TxEn1),
                    .TxEn2            (TxEn2),
                    .TxEn3            (TxEn3),
                    .TxEn4            (TxEn4),
                    .Sl1TxChngSync    (Sl1TxChngSync),
                    .Sl2TxChngSync    (Sl2TxChngSync),
                    .Sl12TxChngSync   (Sl12TxChngSync),
                    .Ch1TxChngSync    (Ch1TxChngSync),
                    .Ch2TxChngSync    (Ch2TxChngSync),
                    .Ch3TxChngSync    (Ch3TxChngSync),
                    .Ch4TxChngSync    (Ch4TxChngSync),
                    .FrameState       (FrameState),
                    .LPMDetected      (LPMDetected),
                    .TxFValidSync     (TxFValidSync),
                    .Ch1Tx            (Ch1Tx),
                    .Ch2Tx            (Ch2Tx),
                    .Ch3Tx            (Ch3Tx),
                    .Ch4Tx            (Ch4Tx),
                    .VarRate          (VarRate),
                    .AACIBITCLKCnt    (AACIBITCLKCnt),
                    .TxUnderrun1      (TxUnderrun1),
                    .TxUnderrun2      (TxUnderrun2),
                    .TxUnderrun3      (TxUnderrun3),
                    .TxUnderrun4      (TxUnderrun4),
                    .Sl1RegValid      (Sl1RegValid),
                    .Sl2RegValid      (Sl2RegValid),
                    .Sl12RegValid     (Sl12RegValid),
                    .LstSlTxed        (LstSlTxed),
                    .LstSlFifoSel     (LstSlFifoSel),
                    .Sl12TxClr        (Sl12TxClr),
                    .Sl2TxClr         (Sl2TxClr),
                    .Sl1TxClr         (Sl1TxClr),
                    .Sl12TxE          (Sl12TxE),
                    .Sl2TxE           (Sl2TxE),
                    .Sl1TxE           (Sl1TxE),
                    .Ch4TxClr         (Ch4TxClr),
                    .Ch3TxClr         (Ch3TxClr),
                    .Ch2TxClr         (Ch2TxClr),
                    .Ch1TxClr         (Ch1TxClr),
                    .RdPtrInc         (RdPtrInc),
                    .FifoSel          (FifoSel),
                    .FDataSel         (FDataSel),
                    .Sl1DataSel       (Sl1DataSel),
                    .Slot0DataCo      (Slot0DataCo)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciTmgCntl
// ---------------------------------------------------------------------
AaciTmgCntl uAaciTmgCntl              (
                    .AACIBITCLK       (AACIBITCLK),
                    .nAACIBITCLKRST   (nAACIBITCLKRST),
                    .LPMDetected      (LPMDetected),
                    .ForcedSYNC       (ForcedSYNC),
                    .AacIfESync       (AacIfESync),
                    .AACISYNC         (AACISYNC),
                    .AACIBITCLKCnt    (AACIBITCLKCnt)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciRxCntl
// ---------------------------------------------------------------------
AaciRxCntl uAaciRxCntl                (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .RxEn1            (RxEn1),
                    .RxEn2            (RxEn2),
                    .RxEn3            (RxEn3),
                    .RxEn4            (RxEn4),
                    .RxSlNoUpdSync    (RxSlNoUpdSync),
                    .RxSlot0Sync      (RxSlot0Sync),
                    .LPMToglSync      (LPMToglSync),
                    .Ch1Rx            (Ch1Rx),
                    .Ch2Rx            (Ch2Rx),
                    .Ch3Rx            (Ch3Rx),
                    .Ch4Rx            (Ch4Rx),
                    .RxSlValid        (RxSlValid),
                    .RxSlNoUpdXorCo   (RxSlNoUpdXorCo),
                    .RxSlot0XorCo     (RxSlot0XorCo),
                    .LPMXorCo         (LPMXorCo),
                    .RxFWrPtrIncCo    (RxFWrPtrIncCo)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciTxCntl
// ---------------------------------------------------------------------
AaciTxCntl uAaciTxCntl                (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .TxCompactMode1   (TxCompactMode1),
                    .TxCompactMode2   (TxCompactMode2),
                    .TxCompactMode3   (TxCompactMode3),
                    .TxCompactMode4   (TxCompactMode4),
                    .RdPtr01          (RdPtr01),
                    .RdPtr02          (RdPtr02),
                    .RdPtr03          (RdPtr03),
                    .RdPtr04          (RdPtr04),
                    .TSize1           (TSize1),
                    .TSize2           (TSize2),
                    .TSize3           (TSize3),
                    .TSize4           (TSize4),
                    .TxFRdDataL1Co    (TxFRdDataL1Co),
                    .TxFRdDataR1Co    (TxFRdDataR1Co),
                    .TxFRdDataL2Co    (TxFRdDataL2Co),
                    .TxFRdDataR2Co    (TxFRdDataR2Co),
                    .TxFRdDataL3Co    (TxFRdDataL3Co),
                    .TxFRdDataR3Co    (TxFRdDataR3Co),
                    .TxFRdDataL4Co    (TxFRdDataL4Co),
                    .TxFRdDataR4Co    (TxFRdDataR4Co),
                    .RdPtrIncSync     (RdPtrIncSync),
                    .FifoSel          (FifoSel),
                    .LstSlTxedSync    (LstSlTxedSync),
                    .TxFRdPtrIncCo    (TxFRdPtrIncCo),
                    .LstSlXorCo       (LstSlXorCo),
                    .Fifo1DataCo      (Fifo1DataCo),
                    .Fifo2DataCo      (Fifo2DataCo),
                    .Fifo3DataCo      (Fifo3DataCo),
                    .Fifo4DataCo      (Fifo4DataCo)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciDMATChannel (Channel 1)
// ---------------------------------------------------------------------
AaciDMATChannel uAaciDMATChannel      (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .AACIDRWr         (AACIDR1Wr),
                    .AACIDRRd         (AACIDR1Rd),
                    .FIFOTEST         (FIFOTEST),
                    .TxFRdPtrIncCo    (TxFRdPtrIncCo[1]),
                    .TxCompactMode    (TxCompactMode1),
                    .TxFEn            (TxFEn1),
                    .DMAEnable        (DMAEnable),
                    .AacIfE           (AacIfE),
                    .AACIDMACLRTX     (AACIDMACLRTX),
                    .ITEN             (ITEN),
                    .ITIPDMACLRTX     (ITIPDMACLRTX),
                    .ITOPDMAREQTX     (ITOPDMAREQTX),
                    .LstSlXorCo       (LstSlXorCo),
                    .LstSlFifoSel     (LstSlFifoSel[1]),
                    .ChTx             (Ch1Tx),
                    .PWDataInt        (PWDataInt),
                    .TxFF             (TxFF1),
                    .TxHE             (TxHE1),
                    .TxFE             (TxFE1),
                    .RdPtr0           (RdPtr01),
                    .TxBusy           (TxBusy1),
                    .TxFValid         (TxFValid[1]),
                    .AACIDMACLRTXInt  (AACIDMACLRTXInt),
                    .AACIDMABREQTX    (AACIDMABREQTX),
                    .TxFRdDataLCo     (TxFRdDataL1Co),
                    .TxFRdDataRCo     (TxFRdDataR1Co)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciTxChannel (Channel 2)
// ---------------------------------------------------------------------
AaciTxChannel u2AaciTxChannel         (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .AACIDRWr         (AACIDR2Wr),
                    .AACIDRRd         (AACIDR2Rd),
                    .FIFOTEST         (FIFOTEST),
                    .TxFRdPtrIncCo    (TxFRdPtrIncCo[2]),
                    .TxCompactMode    (TxCompactMode2),
                    .TxFEn            (TxFEn2),
                    .AacIfE           (AacIfE),
                    .LstSlXorCo       (LstSlXorCo),
                    .LstSlFifoSel     (LstSlFifoSel[2]),
                    .ChTx             (Ch2Tx),
                    .PWDataInt        (PWDataInt),
                    .TxFF             (TxFF2),
                    .TxHE             (TxHE2),
                    .TxFE             (TxFE2),
                    .RdPtr0           (RdPtr02),
                    .TxBusy           (TxBusy2),
                    .TxFValid         (TxFValid[2]),
                    .TxFRdDataLCo     (TxFRdDataL2Co),
                    .TxFRdDataRCo     (TxFRdDataR2Co)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciTxChannel (Channel 3)
// ---------------------------------------------------------------------
AaciTxChannel u3AaciTxChannel         (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .AACIDRWr         (AACIDR3Wr),
                    .AACIDRRd         (AACIDR3Rd),
                    .FIFOTEST         (FIFOTEST),
                    .TxFRdPtrIncCo    (TxFRdPtrIncCo[3]),
                    .TxCompactMode    (TxCompactMode3),
                    .TxFEn            (TxFEn3),
                    .AacIfE           (AacIfE),
                    .LstSlXorCo       (LstSlXorCo),
                    .LstSlFifoSel     (LstSlFifoSel[3]),
                    .ChTx             (Ch3Tx),
                    .PWDataInt        (PWDataInt),
                    .TxFF             (TxFF3),
                    .TxHE             (TxHE3),
                    .TxFE             (TxFE3),
                    .RdPtr0           (RdPtr03),
                    .TxBusy           (TxBusy3),
                    .TxFValid         (TxFValid[3]),
                    .TxFRdDataLCo     (TxFRdDataL3Co),
                    .TxFRdDataRCo     (TxFRdDataR3Co)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciTxChannel (Channel 4)
// ---------------------------------------------------------------------
AaciTxChannel u4AaciTxChannel         (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .AACIDRWr         (AACIDR4Wr),
                    .AACIDRRd         (AACIDR4Rd),
                    .FIFOTEST         (FIFOTEST),
                    .TxFRdPtrIncCo    (TxFRdPtrIncCo[4]),
                    .TxCompactMode    (TxCompactMode4),
                    .TxFEn            (TxFEn4),
                    .AacIfE           (AacIfE),
                    .LstSlXorCo       (LstSlXorCo),
                    .LstSlFifoSel     (LstSlFifoSel[4]),
                    .ChTx             (Ch4Tx),
                    .PWDataInt        (PWDataInt),
                    .TxFF             (TxFF4),
                    .TxHE             (TxHE4),
                    .TxFE             (TxFE4),
                    .RdPtr0           (RdPtr04),
                    .TxBusy           (TxBusy4),
                    .TxFValid         (TxFValid[4]),
                    .TxFRdDataLCo     (TxFRdDataL4Co),
                    .TxFRdDataRCo     (TxFRdDataR4Co)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciDMARChannel (Channel 1)
// ---------------------------------------------------------------------
AaciDMARChannel uAaciDMARChannel      (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .RxFWrPtrIncCo    (RxFWrPtrIncCo[1]),
                    .AACIDRWr         (AACIDR1Wr),
                    .AACIDRRd         (AACIDR1Rd),
                    .FIFOTEST         (FIFOTEST),
                    .TimeOutCnt       (TimeOutCnt1),
                    .RxCompactMode    (RxCompactMode1),
                    .RSize            (RSize1),
                    .RxFEn            (RxFEn1),
                    .RxEn             (RxEn1),
                    .DMAEnable        (DMAEnable),
                    .AacIfE           (AacIfE),
                    .RxOEClrCo        (RxOEClr1Co),
                    .RxTOFEClrCo      (RxTOFEClr1Co),
                    .RxSlot0XorCo     (RxSlot0XorCo),
                    .AACIRXCRWr       (AACIRXCR1Wr),
                    .LPMXorCo         (LPMXorCo),
                    .AACIDMACLRRX     (AACIDMACLRRX),
                    .ITEN             (ITEN),
                    .ITIPDMACLRRX     (ITIPDMACLRRX),
                    .ITOPDMAREQRX     (ITOPDMAREQRX),
                    .RxDataIn         (RxDataIn),
                    .SlotValid        (SlotValid),
                    .ChRx             (Ch1Rx),
                    .PWDataInt        (PWDataInt[19 : 0]),
                    .RxHF             (RxHF1),
                    .RxOverrun        (RxOverrun1),
                    .RxFE             (RxFE1),
                    .RxFF             (RxFF1),
                    .RxTimeout        (RxTimeout1),
                    .RxBusy           (RxBusy1),
                    .RxTOFE           (RxTOFE1),
                    .AACIDMACLRRXInt  (AACIDMACLRRXInt),
                    .AACIDMASREQRX    (AACIDMASREQRX),
                    .AACIDMABREQRX    (AACIDMABREQRX),
                    .AACIDMALSREQRX   (AACIDMALSREQRX),
                    .AACIDMALBREQRX   (AACIDMALBREQRX),
                    .RxFRdDataCo      (RxFRdDataCo1)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciRxChannel (Channel 2)
// ---------------------------------------------------------------------
AaciRxChannel u2AaciRxChannel         (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .RxFWrPtrIncCo    (RxFWrPtrIncCo[2]),
                    .AACIDRWr         (AACIDR2Wr),
                    .AACIDRRd         (AACIDR2Rd),
                    .FIFOTEST         (FIFOTEST),
                    .TimeOutCnt       (TimeOutCnt2),
                    .RxCompactMode    (RxCompactMode2),
                    .RSize            (RSize2),
                    .RxFEn            (RxFEn2),
                    .RxEn             (RxEn2),
                    .AacIfE           (AacIfE),
                    .RxOEClrCo        (RxOEClr2Co),
                    .RxTOFEClrCo      (RxTOFEClr2Co),
                    .RxSlot0XorCo     (RxSlot0XorCo),
                    .AACIRXCRWr       (AACIRXCR2Wr),
                    .LPMXorCo         (LPMXorCo),
                    .RxDataIn         (RxDataIn),
                    .SlotValid        (SlotValid),
                    .ChRx             (Ch2Rx),
                    .PWDataInt        (PWDataInt[19 : 0]),
                    .RxHF             (RxHF2),
                    .RxOverrun        (RxOverrun2),
                    .RxFE             (RxFE2),
                    .RxFF             (RxFF2),
                    .RxTimeout        (RxTimeout2),
                    .RxBusy           (RxBusy2),
                    .RxTOFE           (RxTOFE2),
                    .RxFRdDataCo      (RxFRdDataCo2)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciRxChannel (Channel 3)
// ---------------------------------------------------------------------
AaciRxChannel u3AaciRxChannel         (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .RxFWrPtrIncCo    (RxFWrPtrIncCo[3]),
                    .AACIDRWr         (AACIDR3Wr),
                    .AACIDRRd         (AACIDR3Rd),
                    .FIFOTEST         (FIFOTEST),
                    .TimeOutCnt       (TimeOutCnt3),
                    .RxCompactMode    (RxCompactMode3),
                    .RSize            (RSize3),
                    .RxFEn            (RxFEn3),
                    .RxEn             (RxEn3),
                    .AacIfE           (AacIfE),
                    .RxOEClrCo        (RxOEClr3Co),
                    .RxTOFEClrCo      (RxTOFEClr3Co),
                    .RxSlot0XorCo     (RxSlot0XorCo),
                    .AACIRXCRWr       (AACIRXCR3Wr),
                    .LPMXorCo         (LPMXorCo),
                    .RxDataIn         (RxDataIn),
                    .SlotValid        (SlotValid),
                    .ChRx             (Ch3Rx),
                    .PWDataInt        (PWDataInt[19 : 0]),
                    .RxHF             (RxHF3),
                    .RxOverrun        (RxOverrun3),
                    .RxFE             (RxFE3),
                    .RxFF             (RxFF3),
                    .RxTimeout        (RxTimeout3),
                    .RxBusy           (RxBusy3),
                    .RxTOFE           (RxTOFE3),
                    .RxFRdDataCo      (RxFRdDataCo3)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciRxChannel (Channel 4)
// ---------------------------------------------------------------------
AaciRxChannel u4AaciRxChannel         (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .RxFWrPtrIncCo    (RxFWrPtrIncCo[4]),
                    .AACIDRWr         (AACIDR4Wr),
                    .AACIDRRd         (AACIDR4Rd),
                    .FIFOTEST         (FIFOTEST),
                    .TimeOutCnt       (TimeOutCnt4),
                    .RxCompactMode    (RxCompactMode4),
                    .RSize            (RSize4),
                    .RxFEn            (RxFEn4),
                    .RxEn             (RxEn4),
                    .AacIfE           (AacIfE),
                    .RxOEClrCo        (RxOEClr4Co),
                    .RxTOFEClrCo      (RxTOFEClr4Co),
                    .RxSlot0XorCo     (RxSlot0XorCo),
                    .AACIRXCRWr       (AACIRXCR4Wr),
                    .LPMXorCo         (LPMXorCo),
                    .RxDataIn         (RxDataIn),
                    .SlotValid        (SlotValid),
                    .ChRx             (Ch4Rx),
                    .PWDataInt        (PWDataInt[19 : 0]),
                    .RxHF             (RxHF4),
                    .RxOverrun        (RxOverrun4),
                    .RxFE             (RxFE4),
                    .RxFF             (RxFF4),
                    .RxTimeout        (RxTimeout4),
                    .RxBusy           (RxBusy4),
                    .RxTOFE           (RxTOFE4),
                    .RxFRdDataCo      (RxFRdDataCo4)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciIntrGen
// ---------------------------------------------------------------------
AaciIntrGen uAaciIntrGen              (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .AacIfE           (AacIfE),
                    .WINTClrCo        (WINTClrCo),
                    .TxBusy1          (TxBusy1),
                    .TxBusy2          (TxBusy2),
                    .TxBusy3          (TxBusy3),
                    .TxBusy4          (TxBusy4),
                    .TxUnderrun1Sync  (TxUnderrun1Sync),
                    .TxUnderrun2Sync  (TxUnderrun2Sync),
                    .TxUnderrun3Sync  (TxUnderrun3Sync),
                    .TxUnderrun4Sync  (TxUnderrun4Sync),
                    .TxUE1ClrCo       (TxUE1ClrCo),
                    .TxUE2ClrCo       (TxUE2ClrCo),
                    .TxUE3ClrCo       (TxUE3ClrCo),
                    .TxUE4ClrCo       (TxUE4ClrCo),
                    .RxOverrun1       (RxOverrun1),
                    .RxOverrun2       (RxOverrun2),
                    .RxOverrun3       (RxOverrun3),
                    .RxOverrun4       (RxOverrun4),
                    .RxTimeout1       (RxTimeout1),
                    .RxTimeout2       (RxTimeout2),
                    .RxTimeout3       (RxTimeout3),
                    .RxTimeout4       (RxTimeout4),
                    .RxHF1            (RxHF1),
                    .RxHF2            (RxHF2),
                    .RxHF3            (RxHF3),
                    .RxHF4            (RxHF4),
                    .TxHE1            (TxHE1),
                    .TxHE2            (TxHE2),
                    .TxHE3            (TxHE3),
                    .TxHE4            (TxHE4),
                    .RxTOFE1          (RxTOFE1),
                    .RxTOFE2          (RxTOFE2),
                    .RxTOFE3          (RxTOFE3),
                    .RxTOFE4          (RxTOFE4),
                    .Sl12RxValid      (Sl12RxValid),
                    .Sl2RxValid       (Sl2RxValid),
                    .Sl1RxValid       (Sl1RxValid),
                    .Sl12TxEmpty      (Sl12TxEmpty),
                    .Sl2TxEmpty       (Sl2TxEmpty),
                    .Sl1TxEmpty       (Sl1TxEmpty),
                    .AACISDATAINIntCo (AACISDATAINIntCo),
                    .AACISDATAINSync  (AACISDATAINSync),
                    .Sl12RxEn         (Sl12RxEn),
                    .LowPowerMode     (LowPowerMode),
                    .Sl12RxChngSync   (Sl12RxChngSync),
                    .AACISL12RXRdCo   (AACISL12RXRdCo),
                    .AACIIE1          (AACIIE1),
                    .AACIIE2          (AACIIE2),
                    .AACIIE3          (AACIIE3),
                    .AACIIE4          (AACIIE4),
                    .AACISLIEN        (AACISLIEN),
                    .ITEN             (ITEN),
                    .ITOPINTR         (ITOPINTR),
                    .AACIITOP1        (AACIITOP1),
                    .AACISLISTAT      (AACISLISTAT),
                    .AACIISR1         (AACIISR1),
                    .AACIISR2         (AACIISR2),
                    .AACIISR3         (AACIISR3),
                    .AACIISR4         (AACIISR4),
                    .RawGPIOINTR      (RawGPIOINTR),
                    .RawWINTRSync     (RawWINTRSync),
                    .TxUE1            (TxUE1),
                    .TxUE2            (TxUE2),
                    .TxUE3            (TxUE3),
                    .TxUE4            (TxUE4),
                    .AACIRXINTR1      (AACIRXINTR1),
                    .AACIRXINTR2      (AACIRXINTR2),
                    .AACIRXINTR3      (AACIRXINTR3),
                    .AACIRXINTR4      (AACIRXINTR4),
                    .AACITXINTR1      (AACITXINTR1),
                    .AACITXINTR2      (AACITXINTR2),
                    .AACITXINTR3      (AACITXINTR3),
                    .AACITXINTR4      (AACITXINTR4),
                    .AACIORINTR1      (AACIORINTR1),
                    .AACIORINTR2      (AACIORINTR2),
                    .AACIORINTR3      (AACIORINTR3),
                    .AACIORINTR4      (AACIORINTR4),
                    .AACIURINTR1      (AACIURINTR1),
                    .AACIURINTR2      (AACIURINTR2),
                    .AACIURINTR3      (AACIURINTR3),
                    .AACIURINTR4      (AACIURINTR4),
                    .AACIRXTOINTR1    (AACIRXTOINTR1),
                    .AACIRXTOINTR2    (AACIRXTOINTR2),
                    .AACIRXTOINTR3    (AACIRXTOINTR3),
                    .AACIRXTOINTR4    (AACIRXTOINTR4),
                    .AACITXCINTR1     (AACITXCINTR1),
                    .AACITXCINTR2     (AACITXCINTR2),
                    .AACITXCINTR3     (AACITXCINTR3),
                    .AACITXCINTR4     (AACITXCINTR4),
                    .AACIRXTOFEINTR1  (AACIRXTOFEINTR1),
                    .AACIRXTOFEINTR2  (AACIRXTOFEINTR2),
                    .AACIRXTOFEINTR3  (AACIRXTOFEINTR3),
                    .AACIRXTOFEINTR4  (AACIRXTOFEINTR4),
                    .AACIWINTR        (AACIWINTR),
                    .AACIGPIOINTR     (AACIGPIOINTR),
                    .AACIS1RXINTR     (AACIS1RXINTR),
                    .AACIS2RXINTR     (AACIS2RXINTR),
                    .AACIS12RXINTR    (AACIS12RXINTR),
                    .AACIS1TXINTR     (AACIS1TXINTR),
                    .AACIS2TXINTR     (AACIS2TXINTR),
                    .AACIS12TXINTR    (AACIS12TXINTR),
                    .AACIINTR         (AACIINTR)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciBtoPSync
// ---------------------------------------------------------------------
AaciBtoPSync uAaciBtoPSync            (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .RxSlNoUpd        (RxSlNoUpd),
                    .RxSlot0          (RxSlot0),
                    .Sl12RxChng       (Sl12RxChng),
                    .Sl12TxClr        (Sl12TxClr),
                    .Sl2TxClr         (Sl2TxClr),
                    .Sl1TxClr         (Sl1TxClr),
                    .Sl12TxE          (Sl12TxE),
                    .Sl2TxE           (Sl2TxE),
                    .Sl1TxE           (Sl1TxE),
                    .Ch4TxClr         (Ch4TxClr),
                    .Ch3TxClr         (Ch3TxClr),
                    .Ch2TxClr         (Ch2TxClr),
                    .Ch1TxClr         (Ch1TxClr),
                    .LstSlTxed        (LstSlTxed),
                    .TxUnderrun1      (TxUnderrun1),
                    .TxUnderrun2      (TxUnderrun2),
                    .TxUnderrun3      (TxUnderrun3),
                    .TxUnderrun4      (TxUnderrun4),
                    .LPMTogl          (LPMTogl),
                    .RdPtrInc         (RdPtrInc),
                    .AACISDATAINIntCo (AACISDATAINIntCo),
                    .RxSlNoUpdSync    (RxSlNoUpdSync),
                    .RxSlot0Sync      (RxSlot0Sync),
                    .Sl12RxChngSync   (Sl12RxChngSync),
                    .Sl12TxClrSync    (Sl12TxClrSync),
                    .Sl2TxClrSync     (Sl2TxClrSync),
                    .Sl1TxClrSync     (Sl1TxClrSync),
                    .Sl12TxESync      (Sl12TxESync),
                    .Sl2TxESync       (Sl2TxESync),
                    .Sl1TxESync       (Sl1TxESync),
                    .Ch4TxClrSync     (Ch4TxClrSync),
                    .Ch3TxClrSync     (Ch3TxClrSync),
                    .Ch2TxClrSync     (Ch2TxClrSync),
                    .Ch1TxClrSync     (Ch1TxClrSync),
                    .LstSlTxedSync    (LstSlTxedSync),
                    .TxUnderrun1Sync  (TxUnderrun1Sync),
                    .TxUnderrun2Sync  (TxUnderrun2Sync),
                    .TxUnderrun3Sync  (TxUnderrun3Sync),
                    .TxUnderrun4Sync  (TxUnderrun4Sync),
                    .LPMToglSync      (LPMToglSync),
                    .RdPtrIncSync     (RdPtrIncSync),
                    .AACISDATAINSync  (AACISDATAINSync)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciPtoBSync
// ---------------------------------------------------------------------
AaciPtoBSync uAaciPtoBSync            (
                    .AACIBITCLK       (AACIBITCLK),
                    .nAACIBITCLKRST   (nAACIBITCLKRST),
                    .Sl12TxChng       (Sl12TxChng),
                    .Sl2TxChng        (Sl2TxChng),
                    .Sl1TxChng        (Sl1TxChng),
                    .Ch4TxChng        (Ch4TxChng),
                    .Ch3TxChng        (Ch3TxChng),
                    .Ch2TxChng        (Ch2TxChng),
                    .Ch1TxChng        (Ch1TxChng),
                    .TxFValid         (TxFValid),
                    .LoopBack         (LoopBack),
                    .AacIfE           (AacIfE),
                    .Sl12TxEn         (Sl12TxEn),
                    .Sl2TxEn          (Sl2TxEn),
                    .Sl1TxEn          (Sl1TxEn),
                    .Sl12TxChngSync   (Sl12TxChngSync),
                    .Sl2TxChngSync    (Sl2TxChngSync),
                    .Sl1TxChngSync    (Sl1TxChngSync),
                    .Ch4TxChngSync    (Ch4TxChngSync),
                    .Ch3TxChngSync    (Ch3TxChngSync),
                    .Ch2TxChngSync    (Ch2TxChngSync),
                    .Ch1TxChngSync    (Ch1TxChngSync),
                    .TxFValidSync     (TxFValidSync),
                    .LoopBackSync     (LoopBackSync),
                    .AacIfESync       (AacIfESync),
                    .Sl12TxEnSync     (Sl12TxEnSync),
                    .Sl2TxEnSync      (Sl2TxEnSync),
                    .Sl1TxEnSync      (Sl1TxEnSync)
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciRevAnd for bit 0 of Revision
// ---------------------------------------------------------------------
AaciRevAnd u0AaciRevAnd               (
                    .TieOff1          (TieOff1[0]),
                    .TieOff2          (TieOff2[0]),
                    .Revision         (Revision[0])
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciRevAnd for bit 1 of Revision
// ---------------------------------------------------------------------
AaciRevAnd u1AaciRevAnd               (
                    .TieOff1          (TieOff1[1]),
                    .TieOff2          (TieOff2[1]),
                    .Revision         (Revision[1])
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciRevAnd for bit 2 of Revision
// ---------------------------------------------------------------------
AaciRevAnd u2AaciRevAnd               (
                    .TieOff1          (TieOff1[2]),
                    .TieOff2          (TieOff2[2]),
                    .Revision         (Revision[2])
                    );

// ---------------------------------------------------------------------
// Instantiation of AaciRevAnd for bit 3 of Revision
// ---------------------------------------------------------------------
AaciRevAnd u3AaciRevAnd               (
                    .TieOff1          (TieOff1[3]),
                    .TieOff2          (TieOff2[3]),
                    .Revision         (Revision[3])
                    );

// ---------------------------------------------------------------------
// Assign values to inputs of RevAnd
// ---------------------------------------------------------------------
assign TieOff1          = 4'b0000;
assign TieOff2          = 4'b0000;

// ---------------------------------------------------------------------
// Assign slices of vectors
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Assign the AACIRXCR register bits to the corresponding signals
// ---------------------------------------------------------------------

// Timeout counts for the 4 channels
assign TimeOutCnt1      = AACIRXCR1[28:17];
assign TimeOutCnt2      = AACIRXCR2[28:17];
assign TimeOutCnt3      = AACIRXCR3[28:17];
assign TimeOutCnt4      = AACIRXCR4[28:17];

// Receive FIFO enables for the 4 channels
assign RxFEn1           = AACIRXCR1[16];
assign RxFEn2           = AACIRXCR2[16];
assign RxFEn3           = AACIRXCR3[16];
assign RxFEn4           = AACIRXCR4[16];

// Receive compact mode enables for the 4 channels
assign RxCompactMode1   = AACIRXCR1[15];
assign RxCompactMode2   = AACIRXCR2[15];
assign RxCompactMode3   = AACIRXCR3[15];
assign RxCompactMode4   = AACIRXCR4[15];

// RSIZE values for the 4 Rx channels
assign RSize1           = AACIRXCR1[14:13];
assign RSize2           = AACIRXCR2[14:13];
assign RSize3           = AACIRXCR3[14:13];
assign RSize4           = AACIRXCR4[14:13];

// Rx slot valid 1-12 bits for Rx FIFO 1
assign Ch1Rx            = AACIRXCR1[12:1];

// Rx slot valid 1-12 bits for Rx FIFO 2
assign Ch2Rx            = AACIRXCR2[12:1];

// Rx slot valid 1-12 bits for Rx FIFO 3
assign Ch3Rx            = AACIRXCR3[12:1];

// Rx slot valid 1-12 bits for Rx FIFO 4
assign Ch4Rx            = AACIRXCR4[12:1];

// RxEn for the 4 channels
assign RxEn1            = AACIRXCR1[0];
assign RxEn2            = AACIRXCR2[0];
assign RxEn3            = AACIRXCR3[0];
assign RxEn4            = AACIRXCR4[0];

// ---------------------------------------------------------------------
// Assign the AACITXCR register bits to the corresponding signals
// ---------------------------------------------------------------------

// Transmit FIFO Enables for the 4 Channels
assign TxFEn1           = AACITXCR1[16];
assign TxFEn2           = AACITXCR2[16];
assign TxFEn3           = AACITXCR3[16];
assign TxFEn4           = AACITXCR4[16];

// Transmit Compact Mode Enables for the 4 Channels
assign TxCompactMode1   = AACITXCR1[15];
assign TxCompactMode2   = AACITXCR2[15];
assign TxCompactMode3   = AACITXCR3[15];
assign TxCompactMode4   = AACITXCR4[15];

// TSIZE Values for the 4 Channels
assign TSize1           = AACITXCR1[14:13];
assign TSize2           = AACITXCR2[14:13];
assign TSize3           = AACITXCR3[14:13];
assign TSize4           = AACITXCR4[14:13];

// Tx 1-12 bits for Rx FIFO 1
assign Ch1Tx            = AACITXCR1[12:1];

// Tx 1-12 bits for Rx FIFO 2
assign Ch2Tx            = AACITXCR2[12:1];

// Tx 1-12 bits for Rx FIFO 3
assign Ch3Tx            = AACITXCR3[12:1];

// Tx 1-12 bits for Rx FIFO 4
assign Ch4Tx            = AACITXCR4[12:1];

// TxEn for the 4 channels
assign TxEn1            = AACITXCR1[0];
assign TxEn2            = AACITXCR2[0];
assign TxEn3            = AACITXCR3[0];
assign TxEn4            = AACITXCR4[0];

// ---------------------------------------------------------------------
// Assign the Test register bits to the corresponding signals
// ---------------------------------------------------------------------
// AACIITIP bits
assign ITIPDMACLRTX     = AACIITIP[1];
assign ITIPDMACLRRX     = AACIITIP[0];

// AACIITOP0 bits
assign ITOPSDATAOUT     = AACIITOP0[29];
assign ITOPDMAREQTX     = AACIITOP0[28];
assign ITOPDMAREQRX     = AACIITOP0[27:24];
assign ITOPINTR         = AACIITOP0[23:0];

// ---------------------------------------------------------------------
// Slot valid bits from the incoming frame's slot 0
// ---------------------------------------------------------------------
assign Slot1Valid       = SlotValid[12];
assign Slot2Valid       = SlotValid[11];
assign Slot12Valid      = SlotValid[1];

endmodule

// --============================== End ==============================--
