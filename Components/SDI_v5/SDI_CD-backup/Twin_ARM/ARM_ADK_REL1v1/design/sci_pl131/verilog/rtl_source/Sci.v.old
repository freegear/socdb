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
//  File Name              : Sci.v.rca
//  File Revision          : 1.7
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Purpose     : This is the top level module of the PrimeCell SmartCard
//               Interface SCI PL131 
//                 
// -----------------------------------------------------------------------------


`timescale 1ns/1ps

module Sci(

// Inputs
           PCLK, 
           SCICLK, 
           PRESETn,
           nSCIRST,
           PSEL,
           PENABLE,
           PWRITE,
           PADDR, 
           PWDATA,
           SCIDATAIN,
           SCICLKIN,
           SCIDETECT,
           SCIDEACREQ,

           SCITXDMACLR,
           SCIRXDMACLR,

           SCANENABLE,
           SCANINPCLK,
           SCANINSCICLK,

// Outputs
           nSCIDATAOUTEN,
           nSCIDATAEN,
           SCICLKOUT,
           nSCICLKOUTEN,
           nSCICLKEN,
           nSCICARDRST,
           SCIFCB,
           SCIVCCEN,

           SCIDEACACK,
           PRDATA,

           SCICARDININTR,
           SCICARDOUTINTR,
           SCICARDUPINTR,
           SCICARDDNINTR,
           SCITXERRINTR,
           SCIATRSTOUTINTR,
           SCIATRDTOUTINTR,
           SCIBLKTOUTINTR,
           SCICHTOUTINTR,
           SCIRTOUTINTR,
           SCIRORINTR,
           SCICLKSTPINTR,
           SCICLKACTINTR,
           SCITXTIDEINTR,
           SCIRXTIDEINTR,
     
           SCIINTR,


           SCITXDMASREQ,
           SCITXDMABREQ,
           SCIRXDMASREQ,
           SCIRXDMABREQ,
           
           SCANOUTPCLK,
           SCANOUTSCICLK
          );

// Inputs
input   PCLK;             // APB Bus Clock
input   SCICLK;           // SCI Clock
input   PRESETn;          // APB Bus Reset
input   nSCIRST;          // SCI Reset
input   PSEL;             // APB Peripheral Select
input   PENABLE;          // APB Peripheral Enable
input   PWRITE;           // APB Peripheral Write
input   [11:2] PADDR;     // APB Address Bus
input   [15:0] PWDATA;    // APB Write Data Bus
input   SCIDATAIN;        // Data Input from PAD
input   SCICLKIN;         // Smartcard Clock input 
input   SCIDETECT;        // Card detect signal to interface
input   SCIDEACREQ;       // PMU Card Deactivation Request

input   SCITXDMACLR;      // TX DMA Clear
input   SCIRXDMACLR;      // RX DMA Clear

input   SCANENABLE;       // Scan Test Enable
input   SCANINPCLK;       // Scan Test Input PCLK domain
input   SCANINSCICLK;     // Scan Test Input SCICLK domain

// Outputs 
output  nSCIDATAOUTEN;    // Data output enable 
output  nSCIDATAEN;       // Tristate control for external buffer
output  SCICLKOUT;        // Smartcard Clock output
output  nSCICLKOUTEN;     // Tristate output buffer control
output  nSCICLKEN;        // Tristate control for external buffer
output  nSCICARDRST;      // Card Rst output
output  SCIFCB;           // Function Code Bit
output  SCIVCCEN;         // Supply voltage control

output  SCIDEACACK;       // Card deactivation Acknowledge
output  [15:0] PRDATA;    // APB Read Data Bus

output  SCICARDININTR;    // Card Inserted Interrupt
output  SCICARDOUTINTR;   // Card Out Interrupt
output  SCICARDUPINTR;    // Card powered Up Interrupt
output  SCICARDDNINTR;    // Card powered Down Interrupt
output  SCITXERRINTR;     // Transmit Error Interrupt
output  SCIATRSTOUTINTR;  // Answer-To-Reset Start TimeOut Interrupt
output  SCIATRDTOUTINTR;  // Answer-To-Reset Duration TimeOut Interrupt
output  SCIBLKTOUTINTR;   // Block Timeout Interrupt
output  SCICHTOUTINTR;    // Character Timeout Interrupt
output  SCIRTOUTINTR;     // Receive Timeout Interrupt
output  SCIRORINTR;       // Receive OverRun Interrupt
output  SCICLKSTPINTR;    // Clock Stopped Interrupt
output  SCICLKACTINTR;    // Clock Active Interrupt 
output  SCITXTIDEINTR;    // Transmit FIFO Tide level Interrupt
output  SCIRXTIDEINTR;    // Receive  FIFO Tide level Interrupt
output  SCIINTR;          // Combined interrupt

output  SCITXDMASREQ;     // TX DMA Single Request
output  SCITXDMABREQ;     // TX DMA Burst  Request
output  SCIRXDMASREQ;     // RX DMA Single Request
output  SCIRXDMABREQ;     // RX DMA Burst  Request

output  SCANOUTPCLK;      // Scan Test Output PCLK   domain
output  SCANOUTSCICLK;    // Scan Test Output SCICLK domain

// -----------------------------------------------------------------------------
// 
//                                      SCI
//                                      ===
// 
// -----------------------------------------------------------------------------
// 
// Overview
// ========
// This module instantiates the following sub-modules:
// 1.  SciApbif        - APB interface
// 2.  SciRegBlk       - Register block
// 3.  SciRegBlkUpdate - Second stage buffer on SCICLK clock domain
// 4.  SciTxFIFO       - Transmit FIFO
// 5.  SciRxFIFO       - Receive FIFO
// 6.  SciTxRx         - Sci transmitter and receiver
// 6.  SciCntl         - Sci control logic
// 7.  SciSynctoPCLK   - Synchroniser for signals crossing into PCLK domain
// 8.  SciSynctoSCICLK - Synchroniser for signals crossing into SCICLK domain
// 9.  SciIntGen       - Interrupt generation
// 10. SciDMA          - DMA interface
// 11. SciTest         - Integration test logic
// 
// -----------------------------------------------------------------------------

wire PRESETn; 
wire nSCIRST; 
wire SCIDATAWr; 
wire SCICR0Wr; 
wire SCICR1Wr; 
wire SCICR2Wr; 
wire SCICLKICCWr; 
wire SCIVALUEWr; 
wire SCIBAUDWr;
wire SCITIDEWr; 
wire SCIDMACRWr;
wire SCISTABLEWr; 
wire SCIATIMEWr; 
wire SCIDTIMEWr; 
wire SCIATRSTIMEWr; 
wire SCIATRDTIMEWr; 
wire SCISTOPTIMEWr;
wire SCISTARTTIMEWr;
wire SCIRETRYWr; 
wire SCICHTIMEMSWr; 
wire SCICHTIMELSWr; 
wire SCIBLKTIMEMSWr; 
wire SCIBLKTIMELSWr; 
wire SCICHGUARDWr; 
wire SCIBLKGUARDWr; 
wire SCIRXTIMEWr; 
wire SCIRXCOUNTCLR; 
wire SCITXCOUNTCLR; 
wire SCIIMSCWr;
wire SCIICRWr;
wire SCISYNCACTWr; 
wire SCISYNCTXWr; 

wire SCITCRWr; 
wire SCIITIPWr; 
wire SCIITOP1Wr; 
wire SCIITOP2Wr;
wire SCITDRWr;

wire [15:0] PWDATAIn; 
wire RxFRdPtrInc; 

wire [7:0]  SCICR0; 
wire [6:0]  SCICR1; 
wire [7:0]  SCICLKICC;
wire [7:0]  SCIVALUE; 
wire [15:0] SCIBAUD; 
wire [7:0]  SCITIDE; 
wire [1:0]  SCIDMACR;
wire [9:0]  SCISTABLE; 
wire [15:0] SCIATIME; 
wire [15:0] SCIDTIME; 
wire [15:0] SCIATRSTIME; 
wire [15:0] SCIATRDTIME; 
wire [11:0] SCISTOPTIME;
wire [11:0] SCISTARTTIME;
wire [5:0]  SCIRETRY; 
wire [15:0] SCICHTIMEMS; 
wire [15:0] SCICHTIMELS; 
wire [15:0] SCIBLKTIMEMS; 
wire [15:0] SCIBLKTIMELS; 
wire [7:0]  SCICHGUARD; 
wire [7:0]  SCIBLKGUARD; 
wire [15:0] SCIRXTIME; 
wire [3:0]  SCITXCOUNT; 
wire [3:0]  SCIRXCOUNT; 
wire [4:0]  SCISYNCACT; 
wire [5:0]  SCISYNCTX;

wire        RCLKSync; 
wire        TXFF; 
wire        TXFE; 
wire        RXFE; 
wire        RXFF; 
wire        VCCENSync; 
wire        nCARDRSTSync; 
wire        FCBSync;
wire [8:0]  RXFRdData; 
wire        nCLKENSync; 
wire        ClkoutEnSync; 
wire        DataoutEnSync; 
wire        nCLKOUTENSync; 
wire        CLKOUTSync; 
wire        nDATAENSync; 
wire        nDATAOUTENSync; 
wire        CARDPRESENTSync; 
wire        RETRYUpdate; 
wire        RXTIMEUpdate; 
wire        SYNCACTUpd; 
wire        ATIMEUpdate; 
wire        DTIMEUpdate; 
wire        ATRSTIMEUpdate; 
wire        ATRDTIMEUpdate; 
wire        BLKTIMEUpdate; 
wire        CHTIMEUpdate; 
wire        CLKICCUpdate; 
wire        BAUDUpdate; 
wire        VALUEUpdate; 
wire        CHGUARDUpdate; 
wire        BLKGUARDUpdate; 
wire        STABLEUpdate; 
wire        RETRYUpdateSync; 
wire        RXTIMEUpdateSync; 
wire        SYNCACTUpdSync; 
wire        ATIMEUpdateSync; 
wire        DTIMEUpdateSync; 
wire        ATRSTUpdateSync; 
wire        ATRDTUpdateSync; 
wire        BLKTUpdateSync; 
wire        CHTUpdateSync; 
wire        CLKICCUpdateSync; 
wire        BAUDUpdateSync; 
wire        VALUEUpdateSync; 
wire        CHGURUpdateSync; 
wire        BLKGURUpdateSync; 
wire [2:0]  TXRETRY; 
wire [2:0]  RXRETRY; 
wire [15:0] RXTIME; 
wire [9:0]  STABLE; 
wire [4:0]  SYNCACT; 
wire [15:0] ATIME; 
wire [15:0] DTIME; 
wire [15:0] ATRSTIME; 
wire [15:0] ATRDTIME;
wire [11:0] STOPTIME;
wire [11:0] STARTTIME;
wire [31:0] BLKTIME; 
wire [31:0] CHTIME; 
wire [7:0]  CLKICC; 
wire [15:0] BAUD; 
wire [7:0]  VALUE; 
wire [7:0]  CHGUARD; 
wire [7:0]  BLKGUARD; 
wire        DelRXTIMEWr; 
wire        DelATRSTIMEWr; 
wire        DelATRDTIMEWr; 
wire        DelSTOPTIMEWr;
wire        DelSTARTTIMEWr;
wire        DelBLKTIMEWr; 
wire        DelCHTIMEWr; 
wire        DelCLKICCWr; 
wire        DelBAUDWr; 
wire        DelVALUEWr; 
wire        DelCHGUARDWr; 
wire        DelBLKGUARDWr; 
wire        DBLDEN; 
wire        DBEN; 
wire        BLKGDLDEN; 
wire        RXDATALDEN; 
wire        RXDATAEN; 
wire        ACTSEQLDEN; 
wire        WRESETEN; 
wire        DEACTEN; 
wire        TXSTRBITLDEN; 
wire        TXDATAEN; 
wire        BGCNTEN; 
wire        ATRDCNTEN; 
wire        WATRSEN; 
wire        WATRLDEN; 
wire        DEACTLDEN; 
wire        CHTIMEEN; 
wire        BLKTIMEEN; 
wire        ACTSEQEN; 
wire        NOCARDEN; 
wire        DBTIMEOUT; 
wire        ACTSEQOVER; 
wire        WRESETOVER; 
wire        DEACTOVER; 
wire        RXOVER; 
wire        TXOVER; 
wire        ETU; 
wire        CHGUARDOVER; 
wire        BLKGUARDOVER; 
wire        CLKICCEN; 
wire        WATRSTIMEOUT; 
wire        TXFRdPtrInc; 
wire        RXFWr; 
wire        RxFWrSync; 
wire        RXFRdSync; 
wire        DataoutEn; 
wire        ClkoutEn; 
wire        CARDPRESENT; 
wire        TXFRdPtrIncSync; 
wire        SCIDEACREQSync; 
wire        STABLEUpdateSync; 
wire        RXFESync; 
wire        TxDataAvlbl; 
wire        TxDataAvlblSync; 
wire        SCIDETECTSync; 
wire        SENSESync; 
wire        ORDERSync; 
wire        TXPARITYSync; 
wire        TXNAKSync; 
wire        RXPARITYSync; 
wire        RXNAKSync; 
wire        ATRDENSync; 
wire        BLKENSync; 
wire        MODESync; 
wire        CLKZ1Sync; 
wire        BGTENSync; 
wire        EXDBNCESync; 
wire        WDATASync; 
wire        WCLKSync; 
wire        WDATAENSync; 
wire        WCLKENSync; 
wire        CARDINICSync; 
wire        CARDOUTICSync; 
wire        CARDUPICSync; 
wire        CARDDNICSync; 
wire        TXERRICSync; 
wire        ATRSTOUTICSync; 
wire        ATRDTOUTICSync; 
wire        BLKTOUTICSync; 
wire        CHTOUTICSync; 
wire        CARDINIC; 
wire        CARDOUTIC; 
wire        CARDUPIC; 
wire        TXERRIC; 
wire        CARDDNIC; 
wire        ATRSTOUTIC; 
wire        ATRDTOUTIC; 
wire        BLKTOUTIC; 
wire        CHTOUTIC; 
wire        LASTTXBYTE; 
wire        TXFRPIncDone; 
wire        LASTTXBYTESync; 
wire        TXFRPIncDoneSyn; 
wire        RETX; 
wire        TXFIFOCLR; 
wire        STARTUPWr; 
wire        WRESETWr; 
wire        FINISHWr; 
wire        STARTUP; 
wire        WRESET; 
wire        STARTUPWrSync; 
wire        FINISHWrSync; 
wire        WRESETWrSync; 
wire        DelSYNCACTWr; 
wire        CARDDOWN; 
wire        RXFRd; 
wire        RTLdDone; 
wire        RTLdDoneSync; 
wire        ETULDEN; 
wire        ATRSLDEN; 
wire [8:0]  RxFWrData; 
wire        RDATASync; 
wire [7:0]  TxFRdData; 

wire        TXDMACLR;
wire        RXDMACLR;
wire        TESTFIFO;
wire        STOPTIMEUpdate;
wire        STARTTIMEUpd;
wire        CLKACTIC;
wire        CLKSTPIC;
wire        RORIC;
wire        RTOUTIC;
wire        TXIMSC;
wire        RXIMSC;
wire        CLKACTIMSC;
wire        CLKSTPIMSC;
wire        RORIMSC;
wire        RTOUTIMSC;
wire        CHTOUTIMSC;
wire        BLKTOUTIMSC;
wire        ATRDTOUTIMSC;
wire        ATRSTOUTIMSC;
wire        TXERRIMSC;
wire        CARDDNIMSC;
wire        CARDUPIMSC;
wire        CARDOUTIMSC;
wire        CARDINIMSC;
wire        STOPTUpdateSync;
wire        STARTTUpdSync;
wire        CLKSTOPEN;
wire        CLKSTOPLDEN;
wire        CLKSTARTEN;
wire        CLKSTARTLDEN;
wire        CLKVALSync;
wire        WRSTSync;
wire        WFCBSync;
wire        CLKSTPICSync;
wire        CLKACTICSync;
wire        SYNCCARDSync;
wire        CLKACTIVE;
wire        CLKACTRIS;
wire        CLKSTPRIS;
wire        RTOUTRIS;
wire        CHTOUTRIS;
wire        BLKTOUTRIS;
wire        ATRDTOUTRIS;
wire        ATRSTOUTRIS;
wire        TXERRRIS;
wire        CARDDNRIS;
wire        CARDUPRIS;
wire        CARDOUTRIS;
wire        CARDINRIS;
wire        CLKDISSync;
wire        CLKSTOPPED;
wire        RORRIS;
wire        CLKACTMIS;
wire        CLKSTPMIS;
wire        RORMIS;
wire        RTOUTMIS;
wire        CHTOUTMIS;
wire        BLKTOUTMIS;
wire        ATRDTOUTMIS;
wire        ATRSTOUTMIS;
wire        TXERRMIS;
wire        CARDDNMIS;
wire        CARDUPMIS;
wire        CARDOUTMIS;
wire        CARDINMIS;
wire        CLKACTRISSync;
wire        CLKSTPRISSync;
wire        RORRISSync;
wire        RTOUTRISSync;
wire        CHTOUTRISSync;
wire        BLKTOUTRISSync;
wire        ATRDTOUTRISSync;
wire        ATRSTOUTRISSync;
wire        TXERRRISSync;
wire        CARDDNRISSync;
wire        CARDUPRISSync;
wire        CARDOUTRISSync;
wire        CARDINRISSync;
wire        CLKACTMISSync;
wire        CLKSTPMISSync;
wire        RORMISSync;
wire        RTOUTMISSync;
wire        CHTOUTMISSync;
wire        BLKTOUTMISSync;
wire        ATRDTOUTMISSync;
wire        ATRSTOUTMISSync;
wire        TXERRMISSync;
wire        CARDDNMISSync;
wire        CARDUPMISSync;
wire        CARDOUTMISSync;
wire        CARDINMISSync;
wire        RTOUTICSync;
wire        CARDINIMSCSync;
wire        CARDOUTIMSCSync;
wire        CARDUPIMSCSync;
wire        CARDDNIMSCSync;
wire        TXERRIMSCSync;
wire        ATRSTOUTIMSCSyn;
wire        ATRDTOUTIMSCSyn;
wire        BLKTOUTIMSCSync;
wire        CHTOUTIMSCSync;
wire        RTOUTIMSCSync;
wire        CLKSTPIMSCSync;
wire        CLKACTIMSCSync;
wire        TXRIS;
wire        RXRIS;
wire        TXMIS;
wire        RXMIS;
wire        INTR;
wire        TXFLTE7Full;
wire        RXFGTE1Full;
wire        TXDMACLRSync;
wire        RXDMACLRSync;
wire        TXDMASREQ;
wire        TXDMABREQ;
wire        RXDMASREQ;
wire        RXDMABREQ;
wire        CLKOUT;
wire        nCLKOUTEN;
wire        nCLKEN;
wire        nDATAOUTEN;
wire        nDATAEN;
wire        VCCEN;
wire        FCB;
wire        nCARDRST;
wire        DEACACK;
wire        SCITDRrd;
wire        SCIATRDTOUTINTR;
wire        SCIATRSTOUTINTR;
wire        SCIDEACACK;
wire  [8:0] SCIITOP2Reg;
wire        ITEN;
wire        TestTXFInc;
wire        SCIDATAINSync;
wire  [3:0] TieOff1;
wire  [3:0] TieOff2;
wire  [3:0] Revision;

// -----------------------------------------------------------------------------
// This module is the APB inferface
// -----------------------------------------------------------------------------
 SciApbif uSciApbif     (
// Inputs

// APB interface
          .PCLK                 (PCLK),
          .PRESETn              (PRESETn),
          .PSEL                 (PSEL),
          .PENABLE              (PENABLE),
          .PWRITE               (PWRITE),
          .PADDR                (PADDR),
          .PWDATA               (PWDATA),

// Rx FIFO Read Data
          .RXFRdData            (RXFRdData),

// Registers
          .SCICR0               (SCICR0),
          .SCICR1               (SCICR1),
          .SCICLKICC            (SCICLKICC),
          .SCIVALUE             (SCIVALUE),
          .SCIBAUD              (SCIBAUD),
          .SCITIDE              (SCITIDE),
          .SCIDMACR             (SCIDMACR),
          .SCISTABLE            (SCISTABLE),
          .SCIATIME             (SCIATIME),
          .SCIDTIME             (SCIDTIME),
          .SCIATRSTIME          (SCIATRSTIME),
          .SCIATRDTIME          (SCIATRDTIME),
          .SCISTOPTIME          (SCISTOPTIME),
          .SCISTARTTIME         (SCISTARTTIME),
          .SCIRETRY             (SCIRETRY),
          .SCICHTIMELS          (SCICHTIMELS),
          .SCICHTIMEMS          (SCICHTIMEMS),
          .SCIBLKTIMELS         (SCIBLKTIMELS),
          .SCIBLKTIMEMS         (SCIBLKTIMEMS),
          .SCICHGUARD           (SCICHGUARD),
          .SCIBLKGUARD          (SCIBLKGUARD),
          .SCIRXTIME            (SCIRXTIME),
          .SCITXCOUNT           (SCITXCOUNT),
          .SCIRXCOUNT           (SCIRXCOUNT),
          .SCISYNCTX            (SCISYNCTX),
          .TESTFIFO             (TESTFIFO),
          .ITEN                 (ITEN),

          .TxFRdData            (TxFRdData),
          .Revision             (Revision),

// Register bits
          .TXFF                 (TXFF),
          .TXFE                 (TXFE),
          .RXFF                 (RXFF),
          .RXFE                 (RXFE),

          .VCCENSync            (VCCENSync),
          .nCARDRSTSync         (nCARDRSTSync),
          .ClkoutEnSync         (ClkoutEnSync),
          .DataoutEnSync        (DataoutEnSync),
          .FCBSync              (FCBSync),
          .nCLKOUTENSync        (nCLKOUTENSync),
          .nCLKENSync           (nCLKENSync),
          .CLKOUTSync           (CLKOUTSync),
          .nDATAOUTENSync       (nDATAOUTENSync),
          .nDATAENSync          (nDATAENSync),
          .CARDPRESENTSync      (CARDPRESENTSync),
          .RDATASync            (RDATASync),
          .RCLKSync             (RCLKSync),

// Interrupt clear signals
          .CLKACTIC             (CLKACTIC),
          .CLKSTPIC             (CLKSTPIC),
          .RORIC                (RORIC),
          .RTOUTIC              (RTOUTIC),
          .CHTOUTIC             (CHTOUTIC),
          .BLKTOUTIC            (BLKTOUTIC),
          .ATRDTOUTIC           (ATRDTOUTIC),
          .ATRSTOUTIC           (ATRSTOUTIC),
          .TXERRIC              (TXERRIC),
          .CARDDNIC             (CARDDNIC),
          .CARDUPIC             (CARDUPIC),
          .CARDOUTIC            (CARDOUTIC),
          .CARDINIC             (CARDINIC),

// Raw interrupt status synced
          .TXRIS                (TXRIS),
          .RXRIS                (RXRIS),
          .CLKACTRISSync        (CLKACTRISSync),
          .CLKSTPRISSync        (CLKSTPRISSync),
          .RORRISSync           (RORRISSync),
          .RTOUTRISSync         (RTOUTRISSync),
          .CHTOUTRISSync        (CHTOUTRISSync),
          .BLKTOUTRISSync       (BLKTOUTRISSync),
          .ATRDTOUTRISSync      (ATRDTOUTRISSync),
          .ATRSTOUTRISSync      (ATRSTOUTRISSync),
          .TXERRRISSync         (TXERRRISSync),
          .CARDDNRISSync        (CARDDNRISSync),
          .CARDUPRISSync        (CARDUPRISSync),
          .CARDOUTRISSync       (CARDOUTRISSync),
          .CARDINRISSync        (CARDINRISSync),

// Interrupt Mask Set Clear
          .TXIMSC               (TXIMSC),
          .RXIMSC               (RXIMSC),
          .CLKACTIMSC           (CLKACTIMSC),
          .CLKSTPIMSC           (CLKSTPIMSC),
          .CARDINIMSC           (CARDINIMSC),
          .CARDOUTIMSC          (CARDOUTIMSC),
          .CARDUPIMSC           (CARDUPIMSC),
          .CARDDNIMSC           (CARDDNIMSC),
          .TXERRIMSC            (TXERRIMSC),
          .ATRSTOUTIMSC         (ATRSTOUTIMSC),
          .ATRDTOUTIMSC         (ATRDTOUTIMSC),
          .BLKTOUTIMSC          (BLKTOUTIMSC),
          .CHTOUTIMSC           (CHTOUTIMSC),
          .RTOUTIMSC            (RTOUTIMSC),
          .RORIMSC              (RORIMSC),

// Masked interrupt status synced
          .TXMIS                (TXMIS),
          .RXMIS                (RXMIS),
          .CLKACTMISSync        (CLKACTMISSync),
          .CLKSTPMISSync        (CLKSTPMISSync),
          .RORMISSync           (RORMISSync),
          .RTOUTMISSync         (RTOUTMISSync),
          .CHTOUTMISSync        (CHTOUTMISSync),
          .BLKTOUTMISSync       (BLKTOUTMISSync),
          .ATRDTOUTMISSync      (ATRDTOUTMISSync),
          .ATRSTOUTMISSync      (ATRSTOUTMISSync),
          .TXERRMISSync         (TXERRMISSync),
          .CARDDNMISSync        (CARDDNMISSync),
          .CARDUPMISSync        (CARDUPMISSync),
          .CARDOUTMISSync       (CARDOUTMISSync),
          .CARDINMISSync        (CARDINMISSync),

// DMA interface 
          .TXDMACLR             (TXDMACLR),
          .RXDMACLR             (RXDMACLR),

// Primary input signals 
          .SCICLKIN             (SCICLKIN),
          .SCIDATAIN            (SCIDATAIN),
          .SCIDETECT            (SCIDETECT),
          .SCIDEACREQ           (SCIDEACREQ),

// Intra-chip mux outputs from SciTest (SCIITOP1)
          .SCITXDMASREQ         (SCITXDMASREQ),
          .SCITXDMABREQ         (SCITXDMABREQ),
          .SCIRXDMASREQ         (SCIRXDMASREQ),
          .SCIRXDMABREQ         (SCIRXDMABREQ),
          .SCITXTIDEINTR        (SCITXTIDEINTR),
          .SCIRXTIDEINTR        (SCIRXTIDEINTR),
          .SCIRTOUTINTR         (SCIRTOUTINTR),
          .SCICHTOUTINTR        (SCICHTOUTINTR),
          .SCIBLKTOUTINTR       (SCIBLKTOUTINTR),
          .SCIATRDTOUTINTR      (SCIATRDTOUTINTR),
          .SCIATRSTOUTINTR      (SCIATRSTOUTINTR),
          .SCITXERRINTR         (SCITXERRINTR),
          .SCICARDDNINTR        (SCICARDDNINTR),
          .SCICARDUPINTR        (SCICARDUPINTR),
          .SCICARDOUTINTR       (SCICARDOUTINTR),
          .SCICARDININTR        (SCICARDININTR),

// Intra-chip mux outputs from SciTest (SCIITOP2)
          .SCIINTR              (SCIINTR),
          .SCICLKACTINTR        (SCICLKACTINTR),
          .SCICLKSTPINTR        (SCICLKSTPINTR),
          .SCIRORINTR           (SCIRORINTR),

// Primary outputs SCIITOP2 Register Read back bits
          .SCIITOP2Reg          (SCIITOP2Reg),
//Outputs

// Write Enables
          .SCIDATAWr            (SCIDATAWr),
          .SCICR0Wr             (SCICR0Wr),
          .SCICR1Wr             (SCICR1Wr),
          .SCICR2Wr             (SCICR2Wr),
          .SCICLKICCWr          (SCICLKICCWr),
          .SCIVALUEWr           (SCIVALUEWr),
          .SCIBAUDWr            (SCIBAUDWr),
          .SCITIDEWr            (SCITIDEWr),
          .SCIDMACRWr           (SCIDMACRWr),
          .SCISTABLEWr          (SCISTABLEWr),
          .SCIATIMEWr           (SCIATIMEWr),
          .SCIDTIMEWr           (SCIDTIMEWr),
          .SCIATRSTIMEWr        (SCIATRSTIMEWr),
          .SCIATRDTIMEWr        (SCIATRDTIMEWr),
          .SCISTOPTIMEWr        (SCISTOPTIMEWr),
          .SCISTARTTIMEWr       (SCISTARTTIMEWr),
          .SCIRETRYWr           (SCIRETRYWr),
          .SCICHTIMELSWr        (SCICHTIMELSWr),
          .SCICHTIMEMSWr        (SCICHTIMEMSWr),
          .SCIBLKTIMELSWr       (SCIBLKTIMELSWr),
          .SCIBLKTIMEMSWr       (SCIBLKTIMEMSWr),
          .SCICHGUARDWr         (SCICHGUARDWr),
          .SCIBLKGUARDWr        (SCIBLKGUARDWr),
          .SCIRXTIMEWr          (SCIRXTIMEWr),
          .SCITXCOUNTCLR        (SCITXCOUNTCLR),
          .SCIRXCOUNTCLR        (SCIRXCOUNTCLR),
          .SCIIMSCWr            (SCIIMSCWr),
          .SCISYNCACTWr         (SCISYNCACTWr),
          .SCISYNCTXWr          (SCISYNCTXWr),
          .SCIICRWr             (SCIICRWr),
          .SCITCRWr             (SCITCRWr),
          .SCIITIPWr            (SCIITIPWr),
          .SCIITOP1Wr           (SCIITOP1Wr),
          .SCIITOP2Wr           (SCIITOP2Wr),
          .SCITDRWr             (SCITDRWr),
          .SCITDRrd             (SCITDRrd),

// Miscellaneous 
          .RxFRdPtrInc          (RxFRdPtrInc),

// APB interface
          .PWDATAIn             (PWDATAIn),
          .PRDATA               (PRDATA)
                                );


// -----------------------------------------------------------------------------
// This module contains first stage registers of SCI. 
// -----------------------------------------------------------------------------
 SciRegBlk uSciRegBlk   (
// Inputs
// Register write enable signals
          .PCLK                 (PCLK),
          .PRESETn              (PRESETn),
          .SCICR0Wr             (SCICR0Wr),
          .SCICR1Wr             (SCICR1Wr),
          .SCICR2Wr             (SCICR2Wr),
          .SCICLKICCWr          (SCICLKICCWr),
          .SCIVALUEWr           (SCIVALUEWr),
          .SCIBAUDWr            (SCIBAUDWr),
          .SCITIDEWr            (SCITIDEWr),
          .SCIDMACRWr           (SCIDMACRWr), 
          .SCISTABLEWr          (SCISTABLEWr),
          .SCIATIMEWr           (SCIATIMEWr),
          .SCIDTIMEWr           (SCIDTIMEWr),
          .SCIATRSTIMEWr        (SCIATRSTIMEWr),
          .SCIATRDTIMEWr        (SCIATRDTIMEWr),
          .SCISTOPTIMEWr        (SCISTOPTIMEWr),
          .SCISTARTTIMEWr       (SCISTARTTIMEWr),
          .SCIRETRYWr           (SCIRETRYWr),
          .SCICHTIMELSWr        (SCICHTIMELSWr),
          .SCICHTIMEMSWr        (SCICHTIMEMSWr),
          .SCIBLKTIMELSWr       (SCIBLKTIMELSWr),
          .SCIBLKTIMEMSWr       (SCIBLKTIMEMSWr),
          .SCICHGUARDWr         (SCICHGUARDWr),
          .SCIBLKGUARDWr        (SCIBLKGUARDWr),
          .SCIRXTIMEWr          (SCIRXTIMEWr),
          .SCIIMSCWr            (SCIIMSCWr),
          .SCIICRWr             (SCIICRWr),
          .SCISYNCACTWr         (SCISYNCACTWr),
          .SCISYNCTXWr          (SCISYNCTXWr),

//
          .PWDATAIn             (PWDATAIn),

// Raw interrupt status synchronised to PCLK
          .CLKACTRISSync        (CLKACTRISSync),
          .CLKSTPRISSync        (CLKSTPRISSync),
          .RORRISSync           (RORRISSync),
          .RTOUTRISSync         (RTOUTRISSync),
          .CHTOUTRISSync        (CHTOUTRISSync),
          .BLKTOUTRISSync       (BLKTOUTRISSync),
          .ATRDTOUTRISSync      (ATRDTOUTRISSync),
          .ATRSTOUTRISSync      (ATRSTOUTRISSync),
          .TXERRRISSync         (TXERRRISSync),
          .CARDDNRISSync        (CARDDNRISSync),
          .CARDUPRISSync        (CARDUPRISSync),
          .CARDOUTRISSync       (CARDOUTRISSync),
          .CARDINRISSync        (CARDINRISSync),

// Outputs
// Registers
          .SCICR0               (SCICR0),
          .SCICR1               (SCICR1),
          .SCICLKICC            (SCICLKICC),
          .SCIVALUE             (SCIVALUE),
          .SCIBAUD              (SCIBAUD),
          .SCITIDE              (SCITIDE),
          .SCIDMACR             (SCIDMACR),
          .SCISTABLE            (SCISTABLE),
          .SCIATIME             (SCIATIME),
          .SCIDTIME             (SCIDTIME),
          .SCIATRSTIME          (SCIATRSTIME),
          .SCIATRDTIME          (SCIATRDTIME),
          .SCISTOPTIME          (SCISTOPTIME),
          .SCISTARTTIME         (SCISTARTTIME),
          .SCIRETRY             (SCIRETRY),
          .SCICHTIMELS          (SCICHTIMELS),
          .SCICHTIMEMS          (SCICHTIMEMS),
          .SCIBLKTIMELS         (SCIBLKTIMELS),
          .SCIBLKTIMEMS         (SCIBLKTIMEMS),
          .SCICHGUARD           (SCICHGUARD),
          .SCIBLKGUARD          (SCIBLKGUARD),
          .SCIRXTIME            (SCIRXTIME),
          .SCISYNCACT           (SCISYNCACT),
          .SCISYNCTX            (SCISYNCTX),

          .CLKICCUpdate         (CLKICCUpdate),
          .VALUEUpdate          (VALUEUpdate),
          .BAUDUpdate           (BAUDUpdate),
          .STABLEUpdate         (STABLEUpdate),
          .ATIMEUpdate          (ATIMEUpdate),
          .DTIMEUpdate          (DTIMEUpdate),
          .ATRSTIMEUpdate       (ATRSTIMEUpdate),
          .ATRDTIMEUpdate       (ATRDTIMEUpdate),
          .STOPTIMEUpdate       (STOPTIMEUpdate),
          .STARTTIMEUpd         (STARTTIMEUpd),
          .RETRYUpdate          (RETRYUpdate),
          .CHTIMEUpdate         (CHTIMEUpdate),
          .BLKTIMEUpdate        (BLKTIMEUpdate),
          .CHGUARDUpdate        (CHGUARDUpdate),
          .BLKGUARDUpdate       (BLKGUARDUpdate),
          .RXTIMEUpdate         (RXTIMEUpdate),
          .SYNCACTUpd           (SYNCACTUpd),

// Interrupt clear signals

          .CLKACTIC             (CLKACTIC),
          .CLKSTPIC             (CLKSTPIC),
          .RORIC                (RORIC),
          .RTOUTIC              (RTOUTIC),
          .CHTOUTIC             (CHTOUTIC),
          .BLKTOUTIC            (BLKTOUTIC),
          .ATRDTOUTIC           (ATRDTOUTIC),
          .ATRSTOUTIC           (ATRSTOUTIC),
          .TXERRIC              (TXERRIC),
          .CARDDNIC             (CARDDNIC),
          .CARDUPIC             (CARDUPIC),
          .CARDOUTIC            (CARDOUTIC),
          .CARDINIC             (CARDINIC),

// Interrupt mask set clear signals
          .TXIMSC               (TXIMSC),
          .RXIMSC               (RXIMSC),
          .CLKACTIMSC           (CLKACTIMSC),
          .CLKSTPIMSC           (CLKSTPIMSC),
          .RORIMSC              (RORIMSC),
          .RTOUTIMSC            (RTOUTIMSC),
          .CHTOUTIMSC           (CHTOUTIMSC),
          .BLKTOUTIMSC          (BLKTOUTIMSC),
          .ATRDTOUTIMSC         (ATRDTOUTIMSC),
          .ATRSTOUTIMSC         (ATRSTOUTIMSC),
          .TXERRIMSC            (TXERRIMSC),
          .CARDDNIMSC           (CARDDNIMSC),
          .CARDUPIMSC           (CARDUPIMSC),
          .CARDOUTIMSC          (CARDOUTIMSC),
          .CARDINIMSC           (CARDINIMSC),


// Sequence initiator signals
          .STARTUPWr            (STARTUPWr), 
          .FINISHWr             (FINISHWr),
          .WRESETWr             (WRESETWr)
                                );

// -----------------------------------------------------------------------------
// This module contains the second stage buffers for SCI registers.
// -----------------------------------------------------------------------------
 SciRegBlkUpdate uSciRegBlkUpdate       (
// Inputs
          .SCICLK               (SCICLK),
          .nSCIRST              (nSCIRST),
          .RETRYUpdateSync      (RETRYUpdateSync),
          .RXTIMEUpdateSync     (RXTIMEUpdateSync),
          .SYNCACTUpdSync       (SYNCACTUpdSync),
          .STABLEUpdateSync     (STABLEUpdateSync),
          .ATIMEUpdateSync      (ATIMEUpdateSync),
          .DTIMEUpdateSync      (DTIMEUpdateSync),
          .ATRSTUpdateSync      (ATRSTUpdateSync),
          .ATRDTUpdateSync      (ATRDTUpdateSync),
          .STOPTUpdateSync      (STOPTUpdateSync),
          .STARTTUpdSync        (STARTTUpdSync),
          .BLKTUpdateSync       (BLKTUpdateSync),
          .CHTUpdateSync        (CHTUpdateSync),
          .CLKICCUpdateSync     (CLKICCUpdateSync),
          .BAUDUpdateSync       (BAUDUpdateSync),
          .VALUEUpdateSync      (VALUEUpdateSync),
          .CHGURUpdateSync      (CHGURUpdateSync),
          .BLKGURUpdateSync     (BLKGURUpdateSync),
          .SCIRETRY             (SCIRETRY),
          .SCIRXTIME            (SCIRXTIME),
          .SCISTABLE            (SCISTABLE),
          .SCISYNCACT           (SCISYNCACT),
          .SCIATIME             (SCIATIME),
          .SCIDTIME             (SCIDTIME),
          .SCIATRSTIME          (SCIATRSTIME),
          .SCIATRDTIME          (SCIATRDTIME),
          .SCISTOPTIME          (SCISTOPTIME),
          .SCISTARTTIME         (SCISTARTTIME),
          .SCIBLKTIMELS         (SCIBLKTIMELS),
          .SCIBLKTIMEMS         (SCIBLKTIMEMS),
          .SCICHTIMELS          (SCICHTIMELS),
          .SCICHTIMEMS          (SCICHTIMEMS),
          .SCICLKICC            (SCICLKICC),
          .SCIBAUD              (SCIBAUD),
          .SCIVALUE             (SCIVALUE),
          .SCICHGUARD           (SCICHGUARD),
          .SCIBLKGUARD          (SCIBLKGUARD),
// Outputs
          .TXRETRY              (TXRETRY),
          .RXRETRY              (RXRETRY),
          .RXTIME               (RXTIME),
          .STABLE               (STABLE),
          .SYNCACT              (SYNCACT),
          .ATIME                (ATIME),
          .DTIME                (DTIME),
          .ATRSTIME             (ATRSTIME),
          .ATRDTIME             (ATRDTIME),
          .STOPTIME             (STOPTIME),
          .STARTTIME            (STARTTIME),
          .BLKTIME              (BLKTIME),
          .CHTIME               (CHTIME),
          .CLKICC               (CLKICC),
          .BAUD                 (BAUD),
          .VALUE                (VALUE),
          .CHGUARD              (CHGUARD),
          .BLKGUARD             (BLKGUARD),
          .DelSYNCACTWr         (DelSYNCACTWr),
          .DelRXTIMEWr          (DelRXTIMEWr),
          .DelATRSTIMEWr        (DelATRSTIMEWr),
          .DelATRDTIMEWr        (DelATRDTIMEWr),
          .DelSTOPTIMEWr        (DelSTOPTIMEWr),
          .DelSTARTTIMEWr       (DelSTARTTIMEWr),
          .DelBLKTIMEWr         (DelBLKTIMEWr),
          .DelCHTIMEWr          (DelCHTIMEWr),
          .DelCLKICCWr          (DelCLKICCWr),
          .DelBAUDWr            (DelBAUDWr),
          .DelVALUEWr           (DelVALUEWr),
          .DelCHGUARDWr         (DelCHGUARDWr),
          .DelBLKGUARDWr        (DelBLKGUARDWr)
                                );

// -----------------------------------------------------------------------------
// This module instantiates the SciTxRegFile and SciTxFCntl blocks.
// -----------------------------------------------------------------------------
 SciTxFIFO uSciTxFIFO   (
// Inputs
          .PCLK                 (PCLK), 
          .PRESETn              (PRESETn), 
          .SCIDATAWr            (SCIDATAWr), 
          .MODE                 (SCICR1[2]), 
          .TXFRdPtrIncSync      (TXFRdPtrIncSync),
          .SCITXTIDE            (SCITIDE[3:0]),
          .SCITXCOUNTCLR        (SCITXCOUNTCLR),
          .TESTFIFO             (TESTFIFO),
          .TestTXFInc           (TestTXFInc),
          .PWDATAIn             (PWDATAIn[7:0]),

// Outputs
          .TXFF                 (TXFF),
          .TXFE                 (TXFE),
          .TXRIS                (TXRIS),
          .TXFLTE7Full          (TXFLTE7Full),
          .TxDataAvlbl          (TxDataAvlbl),
          .TxFRdData            (TxFRdData),
          .SCITXCOUNT           (SCITXCOUNT),
          .LASTTXBYTE           (LASTTXBYTE),
          .TXFRPIncDone         (TXFRPIncDone)
                                );

// -----------------------------------------------------------------------------
// This module instantiates the SciRxRegFile and SciRxFCntl blocks.
// -----------------------------------------------------------------------------
 SciRxFIFO uSciRxFIFO   (
// Inputs
          .PCLK                 (PCLK), 
          .PRESETn              (PRESETn),
          .RORIC                (RORIC),
          .RxFWrSync            (RxFWrSync),
          .RxFRdPtrInc          (RxFRdPtrInc),
          .SCIRXCOUNTCLR        (SCIRXCOUNTCLR),
          .SCIRXTIDE            (SCITIDE[7:4]),
          .RxFWrData            (RxFWrData),
          .TESTFIFO             (TESTFIFO),
          .PWDATAIn             (PWDATAIn[8:0]),
          .SCITDRWr             (SCITDRWr),
          .RTLdDoneSync         (RTLdDoneSync),
// Outputs
          .RXFGTE1Full          (RXFGTE1Full),
          .RXFE                 (RXFE),
          .RXFF                 (RXFF),
          .SCIRXCOUNT           (SCIRXCOUNT),
          .RXRIS                (RXRIS),
          .RORRIS               (RORRIS),
          .RXFRdData            (RXFRdData),
          .RXFRd                (RXFRd)
                                );

// -----------------------------------------------------------------------------
// This module controls transmission and reception of the SCI and also 
// generates the smart card control signals.
// -----------------------------------------------------------------------------
// 
 SciTxRx uSciTxRx               (
// Inputs
          .SCICLK               (SCICLK),
          .nSCIRST              (nSCIRST),
          .NOCARDEN             (NOCARDEN),
          .DBLDEN               (DBLDEN),
          .DBEN                 (DBEN),
          .ACTSEQLDEN           (ACTSEQLDEN),
          .ATRSLDEN             (ATRSLDEN),
          .WATRSEN              (WATRSEN),
          .WRESETEN             (WRESETEN),
          .ATRDCNTEN            (ATRDCNTEN),
          .WATRLDEN             (WATRLDEN),
          .DEACTLDEN            (DEACTLDEN),
          .DEACTEN              (DEACTEN),
          .ACTSEQEN             (ACTSEQEN),
          .RXDATALDEN           (RXDATALDEN),
          .RXDATAEN             (RXDATAEN),
          .TXSTRBITLDEN         (TXSTRBITLDEN),
          .TXDATAEN             (TXDATAEN),
          .CLKSTOPEN            (CLKSTOPEN),
          .CLKSTOPLDEN          (CLKSTOPLDEN),
          .CLKSTARTEN           (CLKSTARTEN),
          .CLKSTARTLDEN         (CLKSTARTLDEN),
          .CLKVALSync           (CLKVALSync),
          .TXRETRY              (TXRETRY),
          .RXRETRY              (RXRETRY),
          .STABLE               (STABLE),
          .SYNCACT              (SYNCACT),
          .RXTIME               (RXTIME),
          .ATIME                (ATIME),
          .DTIME                (DTIME),
          .ATRSTIME             (ATRSTIME),
          .ATRDTIME             (ATRDTIME),
          .BLKTIME              (BLKTIME),
          .CHTIME               (CHTIME),
          .STOPTIME             (STOPTIME),
          .STARTTIME            (STARTTIME),
          .CLKICC               (CLKICC),
          .BAUD                 (BAUD),
          .VALUE                (VALUE),
          .CHGUARD              (CHGUARD),
          .BLKGUARD             (BLKGUARD),
          .DelSYNCACTWr         (DelSYNCACTWr),
          .DelRXTIMEWr          (DelRXTIMEWr),
          .DelATRSTIMEWr        (DelATRSTIMEWr),
          .DelATRDTIMEWr        (DelATRDTIMEWr),
          .DelSTOPTIMEWr        (DelSTOPTIMEWr),
          .DelSTARTTIMEWr       (DelSTARTTIMEWr),
          .DelBLKTIMEWr         (DelBLKTIMEWr),
          .DelCHTIMEWr          (DelCHTIMEWr),
          .DelCLKICCWr          (DelCLKICCWr), 
          .DelBAUDWr            (DelBAUDWr),
          .DelVALUEWr           (DelVALUEWr),
          .DelCHGUARDWr         (DelCHGUARDWr),
          .DelBLKGUARDWr        (DelBLKGUARDWr),
          .RXFRdSync            (RXFRdSync),
          .TxDataAvlblSync      (TxDataAvlblSync),
          .ETULDEN              (ETULDEN),
          .BLKGDLDEN            (BLKGDLDEN),
          .BGCNTEN              (BGCNTEN),
          .BLKTIMEEN            (BLKTIMEEN),
          .CHTIMEEN             (CHTIMEEN),
          .RXFESync             (RXFESync),
          .TxFRdData            (TxFRdData),
          .SCIDEACREQSync       (SCIDEACREQSync),
          .SCIDATAINSync        (SCIDATAINSync),
          .SENSESync            (SENSESync ),
          .ORDERSync            (ORDERSync),
          .TXPARITYSync         (TXPARITYSync),
          .TXNAKSync            (TXNAKSync),
          .RXPARITYSync         (RXPARITYSync),
          .RXNAKSync            (RXNAKSync),
          .ATRDENSync           (ATRDENSync),
          .BLKENSync            (BLKENSync),
          .MODESync             (MODESync),
          .CLKZ1Sync            (CLKZ1Sync),
          .BGTENSync            (BGTENSync),
          .EXDBNCESync          (EXDBNCESync),
          .WDATASync            (WDATASync),
          .WCLKSync             (WCLKSync),
          .WDATAENSync          (WDATAENSync),
          .WCLKENSync           (WCLKENSync),
          .WRSTSync             (WRSTSync),
          .WFCBSync             (WFCBSync),
          .STARTUPWrSync        (STARTUPWrSync),
          .FINISHWrSync         (FINISHWrSync),
          .WRESETWrSync         (WRESETWrSync),
          .SCIDETECTSync        (SCIDETECTSync),
          .CARDINICSync         (CARDINICSync),
          .CARDOUTICSync        (CARDOUTICSync), 
          .CARDUPICSync         (CARDUPICSync),
          .CARDDNICSync         (CARDDNICSync),
          .CARDPRESENT          (CARDPRESENT),
          .TXERRICSync          (TXERRICSync),
          .LASTTXBYTESync       (LASTTXBYTESync),
          .ATRSTOUTICSync       (ATRSTOUTICSync),
          .ATRDTOUTICSync       (ATRDTOUTICSync),
          .BLKTOUTICSync        (BLKTOUTICSync),
          .CHTOUTICSync         (CHTOUTICSync),
          .CLKSTPICSync         (CLKSTPICSync),
          .CLKACTICSync         (CLKACTICSync),
          .RTOUTICSync          (RTOUTICSync),
          .SYNCCARDSync         (SYNCCARDSync),
// Outputs
          .DBTIMEOUT            (DBTIMEOUT),
          .ACTSEQOVER           (ACTSEQOVER),
          .WRESETOVER           (WRESETOVER),
          .BLKGUARDOVER         (BLKGUARDOVER),
          .CHGUARDOVER          (CHGUARDOVER),
          .WATRSTIMEOUT         (WATRSTIMEOUT),
          .DEACTOVER            (DEACTOVER),
          .RXOVER               (RXOVER),
          .TXOVER               (TXOVER),
          .CLKSTOPPED           (CLKSTOPPED),
          .CLKACTIVE            (CLKACTIVE),
          .RXFWr                (RXFWr),
          .RTLdDone             (RTLdDone), 
          .TXFRdPtrInc          (TXFRdPtrInc),
          .RETX                 (RETX ),
          .TXFIFOCLR            (TXFIFOCLR), 
          .RxFWrData            (RxFWrData),
          .CLKICCEN             (CLKICCEN),
          .STARTUP              (STARTUP),
          .CARDDOWN             (CARDDOWN),
          .WRESET               (WRESET),
          .nDATAEN              (nDATAEN),
          .nDATAOUTEN           (nDATAOUTEN),
          .DataoutEn            (DataoutEn),
          .CLKOUT               (CLKOUT),
          .nCLKEN               (nCLKEN),
          .nCLKOUTEN            (nCLKOUTEN),
          .ClkoutEn             (ClkoutEn),
          .VCCEN                (VCCEN), 
          .nCARDRST             (nCARDRST),
          .FCB                  (FCB),
          .DEACACK              (DEACACK), 
          .ETU                  (ETU),

          .CLKACTRIS            (CLKACTRIS),
          .CLKSTPRIS            (CLKSTPRIS),
          .RTOUTRIS             (RTOUTRIS),
          .CHTOUTRIS            (CHTOUTRIS ),
          .BLKTOUTRIS           (BLKTOUTRIS),
          .ATRDTOUTRIS          (ATRDTOUTRIS),
          .ATRSTOUTRIS          (ATRSTOUTRIS),
          .TXERRRIS             (TXERRRIS),
          .CARDDNRIS            (CARDDNRIS),
          .CARDUPRIS            (CARDUPRIS),
          .CARDOUTRIS           (CARDOUTRIS),
          .CARDINRIS            (CARDINRIS)
);


// -----------------------------------------------------------------------------
// This module controls the overall functionality of SCI
// -----------------------------------------------------------------------------
 SciCntl uSciCntl(
// Inputs
        .SCICLK                 (SCICLK),                           
        .nSCIRST                (nSCIRST),
        .SCIDETECTSync          (SCIDETECTSync),
        .STARTUP                (STARTUP),
        .WRESET                 (WRESET),
        .CARDDOWN               (CARDDOWN),
        .DelSYNCACTWr           (DelSYNCACTWr),
        .SCIDEACREQSync         (SCIDEACREQSync),
        .DBTIMEOUT              (DBTIMEOUT),
        .ACTSEQOVER             (ACTSEQOVER),
        .DEACTOVER              (DEACTOVER),
        .SCIDATAINSync          (SCIDATAINSync),
        .MODESync               (MODESync),
        .ETU                    (ETU),
        .BLKGUARDOVER           (BLKGUARDOVER),
        .TxDataAvlblSync        (TxDataAvlblSync),
        .RXOVER                 (RXOVER),
        .TXOVER                 (TXOVER),
        .RETX                   (RETX),
        .TXFIFOCLR              (TXFIFOCLR),
        .WRESETOVER             (WRESETOVER),
        .WATRSTIMEOUT           (WATRSTIMEOUT),
        .RXNAKSync              (RXNAKSync),
        .CLKDISSync             (CLKDISSync),
        .CLKSTOPPED             (CLKSTOPPED),
        .CLKACTIVE              (CLKACTIVE),
        .CHGUARDOVER            (CHGUARDOVER),
        .CLKICCEN               (CLKICCEN),
        .TXFRPIncDoneSyn        (TXFRPIncDoneSyn),
        .SYNCCARDSync           (SYNCCARDSync),

// Outputs
        .NOCARDEN               (NOCARDEN),
        .DBLDEN                 (DBLDEN),
        .DBEN                   (DBEN),
        .ACTSEQLDEN             (ACTSEQLDEN),
        .ACTSEQEN               (ACTSEQEN),
        .ATRSLDEN               (ATRSLDEN),
        .BLKGDLDEN              (BLKGDLDEN),
        .BGCNTEN                (BGCNTEN),
        .RXDATALDEN             (RXDATALDEN),
        .ATRDCNTEN              (ATRDCNTEN),
        .RXDATAEN               (RXDATAEN),
        .WATRSEN                (WATRSEN),
        .WRESETEN               (WRESETEN),
        .DEACTLDEN              (DEACTLDEN),
        .DEACTEN                (DEACTEN),
        .TXSTRBITLDEN           (TXSTRBITLDEN),
        .TXDATAEN               (TXDATAEN),
        .WATRLDEN               (WATRLDEN),
        .CHTIMEEN               (CHTIMEEN),
        .BLKTIMEEN              (BLKTIMEEN),
        .CARDPRESENT            (CARDPRESENT),
        .ETULDEN                (ETULDEN),
        .CLKSTOPEN              (CLKSTOPEN),
        .CLKSTOPLDEN            (CLKSTOPLDEN),
        .CLKSTARTEN             (CLKSTARTEN),
        .CLKSTARTLDEN           (CLKSTARTLDEN)
                                );



// -----------------------------------------------------------------------------
// This module synchronises the signals crossing over to the PCLK domain.
// -----------------------------------------------------------------------------
 SciSynctoPCLK uSciSynctoPCLK   (
// Inputs
          .PCLK                 (PCLK),
          .PRESETn              (PRESETn),
          .SCIVCCEN             (SCIVCCEN),
          .nSCICARDRST          (nSCICARDRST),
          .SCIFCB               (SCIFCB),
          .nSCICLKEN            (nSCICLKEN),
          .nSCICLKOUTEN         (nSCICLKOUTEN),
          .ClkoutEn             (ClkoutEn),
          .SCICLKOUT            (SCICLKOUT),
          .nSCIDATAEN           (nSCIDATAEN),
          .nSCIDATAOUTEN        (nSCIDATAOUTEN),
          .DataoutEn            (DataoutEn),
          .CARDPRESENT          (CARDPRESENT),
          .SCICLKIN             (SCICLKIN),
          .SCIDATAIN            (SCIDATAIN),
          .RXFWr                (RXFWr),
          .RTLdDone             (RTLdDone),
          .TXFRdPtrInc          (TXFRdPtrInc),

          .CLKACTRIS            (CLKACTRIS),
          .CLKSTPRIS            (CLKSTPRIS),
          .RORRIS               (RORRIS),
          .RTOUTRIS             (RTOUTRIS),
          .CHTOUTRIS            (CHTOUTRIS),
          .BLKTOUTRIS           (BLKTOUTRIS),
          .ATRDTOUTRIS          (ATRDTOUTRIS),
          .ATRSTOUTRIS          (ATRSTOUTRIS),
          .TXERRRIS             (TXERRRIS),
          .CARDDNRIS            (CARDDNRIS),
          .CARDUPRIS            (CARDUPRIS),
          .CARDOUTRIS           (CARDOUTRIS),
          .CARDINRIS            (CARDINRIS),

          .CLKACTMIS            (CLKACTMIS),
          .CLKSTPMIS            (CLKSTPMIS),
          .RORMIS               (RORMIS),
          .RTOUTMIS             (RTOUTMIS),
          .CHTOUTMIS            (CHTOUTMIS),
          .BLKTOUTMIS           (BLKTOUTMIS),
          .ATRDTOUTMIS          (ATRDTOUTMIS),
          .ATRSTOUTMIS          (ATRSTOUTMIS),
          .TXERRMIS             (TXERRMIS),
          .CARDDNMIS            (CARDDNMIS),
          .CARDUPMIS            (CARDUPMIS),
          .CARDOUTMIS           (CARDOUTMIS),
          .CARDINMIS            (CARDINMIS),

          .TXDMACLR             (TXDMACLR),
          .RXDMACLR             (RXDMACLR),

// Outputs
          .VCCENSync            (VCCENSync),
          .nCARDRSTSync         (nCARDRSTSync),
          .FCBSync              (FCBSync),
          .nCLKENSync           (nCLKENSync),
          .nCLKOUTENSync        (nCLKOUTENSync),
          .ClkoutEnSync         (ClkoutEnSync),
          .CLKOUTSync           (CLKOUTSync),
          .nDATAENSync          (nDATAENSync),
          .nDATAOUTENSync       (nDATAOUTENSync),
          .DataoutEnSync        (DataoutEnSync),
          .CARDPRESENTSync      (CARDPRESENTSync),
          .RCLKSync             (RCLKSync),
          .RDATASync            (RDATASync),
          .RxFWrSync            (RxFWrSync),
          .RTLdDoneSync         (RTLdDoneSync),
          .TXFRdPtrIncSync      (TXFRdPtrIncSync),

          .CLKACTRISSync        (CLKACTRISSync),
          .CLKSTPRISSync        (CLKSTPRISSync),
          .RORRISSync           (RORRISSync),
          .RTOUTRISSync         (RTOUTRISSync),
          .CHTOUTRISSync        (CHTOUTRISSync),
          .BLKTOUTRISSync       (BLKTOUTRISSync),
          .ATRDTOUTRISSync      (ATRDTOUTRISSync),
          .ATRSTOUTRISSync      (ATRSTOUTRISSync),
          .TXERRRISSync         (TXERRRISSync),
          .CARDDNRISSync        (CARDDNRISSync),
          .CARDUPRISSync        (CARDUPRISSync),
          .CARDOUTRISSync       (CARDOUTRISSync),
          .CARDINRISSync        (CARDINRISSync),

          .CLKACTMISSync        (CLKACTMISSync),
          .CLKSTPMISSync        (CLKSTPMISSync),
          .RORMISSync           (RORMISSync),
          .RTOUTMISSync         (RTOUTMISSync),
          .CHTOUTMISSync        (CHTOUTMISSync),
          .BLKTOUTMISSync       (BLKTOUTMISSync),
          .ATRDTOUTMISSync      (ATRDTOUTMISSync),
          .ATRSTOUTMISSync      (ATRSTOUTMISSync),
          .TXERRMISSync         (TXERRMISSync),
          .CARDDNMISSync        (CARDDNMISSync),
          .CARDUPMISSync        (CARDUPMISSync),
          .CARDOUTMISSync       (CARDOUTMISSync),
          .CARDINMISSync        (CARDINMISSync),

          .TXDMACLRSync         (TXDMACLRSync),
          .RXDMACLRSync         (RXDMACLRSync)
                                );

// -----------------------------------------------------------------------------
// This module synchronises the signals crossing to the SCICLK domain
// -----------------------------------------------------------------------------
 SciSynctoSCICLK uSciSynctoSCICLK       (
          .SCICLK               (SCICLK), 
          .nSCIRST              (nSCIRST),
          .SCIDEACREQ           (SCIDEACREQ),
          .SCIDETECT            (SCIDETECT), 
          .SCIDATAIN            (SCIDATAIN),
          .RETRYUpdate          (RETRYUpdate),
          .RXTIMEUpdate         (RXTIMEUpdate),
          .STABLEUpdate         (STABLEUpdate),
          .SYNCACTUpd           (SYNCACTUpd), 
          .ATIMEUpdate          (ATIMEUpdate),
          .DTIMEUpdate          (DTIMEUpdate),
          .ATRSTIMEUpdate       (ATRSTIMEUpdate),
          .ATRDTIMEUpdate       (ATRDTIMEUpdate),
          .STOPTIMEUpdate       (STOPTIMEUpdate),
          .STARTTIMEUpd         (STARTTIMEUpd),
          .BLKTIMEUpdate        (BLKTIMEUpdate),
          .CHTIMEUpdate         (CHTIMEUpdate),
          .CLKICCUpdate         (CLKICCUpdate),
          .BAUDUpdate           (BAUDUpdate),
          .VALUEUpdate          (VALUEUpdate),
          .CHGUARDUpdate        (CHGUARDUpdate),
          .BLKGUARDUpdate       (BLKGUARDUpdate),
          .RXFE                 (RXFE),
          .RXFRd                (RXFRd),
          .TXFRPIncDone         (TXFRPIncDone),
          .LASTTXBYTE           (LASTTXBYTE),
          .TxDataAvlbl          (TxDataAvlbl),
          .SCICR0               (SCICR0),
          .SCICR1               (SCICR1),
          .SCISYNCTX            (SCISYNCTX),
          .STARTUPWr            (STARTUPWr),
          .FINISHWr             (FINISHWr),
          .WRESETWr             (WRESETWr),

// Interrupt clear inputs
          .CARDINIC             (CARDINIC),
          .CARDOUTIC            (CARDOUTIC),
          .CARDUPIC             (CARDUPIC),
          .CARDDNIC             (CARDDNIC),
          .TXERRIC              (TXERRIC),
          .ATRSTOUTIC           (ATRSTOUTIC),
          .ATRDTOUTIC           (ATRDTOUTIC),
          .BLKTOUTIC            (BLKTOUTIC),
          .CHTOUTIC             (CHTOUTIC),
          .RTOUTIC              (RTOUTIC),
          .CLKSTPIC             (CLKSTPIC),
          .CLKACTIC             (CLKACTIC),

// Interrupt mask set clear inputs
          .CARDINIMSC           (CARDINIMSC),
          .CARDOUTIMSC          (CARDOUTIMSC),
          .CARDUPIMSC           (CARDUPIMSC),
          .CARDDNIMSC           (CARDDNIMSC),
          .TXERRIMSC            (TXERRIMSC),
          .ATRSTOUTIMSC         (ATRSTOUTIMSC),
          .ATRDTOUTIMSC         (ATRDTOUTIMSC),
          .BLKTOUTIMSC          (BLKTOUTIMSC),
          .CHTOUTIMSC           (CHTOUTIMSC),
          .RTOUTIMSC            (RTOUTIMSC),
          .CLKSTPIMSC           (CLKSTPIMSC),
          .CLKACTIMSC           (CLKACTIMSC),

// Outputs
          .SCIDEACREQSync       (SCIDEACREQSync),
          .SCIDETECTSync        (SCIDETECTSync),
          .SCIDATAINSync        (SCIDATAINSync),
          .RETRYUpdateSync      (RETRYUpdateSync),
          .RXTIMEUpdateSync     (RXTIMEUpdateSync),
          .STABLEUpdateSync     (STABLEUpdateSync),
          .SYNCACTUpdSync       (SYNCACTUpdSync),
          .ATIMEUpdateSync      (ATIMEUpdateSync),
          .DTIMEUpdateSync      (DTIMEUpdateSync),
          .ATRSTUpdateSync      (ATRSTUpdateSync),
          .ATRDTUpdateSync      (ATRDTUpdateSync),
          .STOPTUpdateSync      (STOPTUpdateSync),
          .STARTTUpdSync        (STARTTUpdSync),
          .BLKTUpdateSync       (BLKTUpdateSync),
          .CHTUpdateSync        (CHTUpdateSync),
          .CLKICCUpdateSync     (CLKICCUpdateSync),
          .BAUDUpdateSync       (BAUDUpdateSync),
          .VALUEUpdateSync      (VALUEUpdateSync),
          .CHGURUpdateSync      (CHGURUpdateSync),
          .BLKGURUpdateSync     (BLKGURUpdateSync),
          .TxDataAvlblSync      (TxDataAvlblSync),
          .RXFESync             (RXFESync),
          .RXFRdSync            (RXFRdSync),
          .TXFRPIncDoneSyn      (TXFRPIncDoneSyn), 
          .LASTTXBYTESync       (LASTTXBYTESync),
          .SENSESync            (SENSESync),
          .ORDERSync            (ORDERSync), 
          .TXPARITYSync         (TXPARITYSync), 
          .TXNAKSync            (TXNAKSync),
          .RXPARITYSync         (RXPARITYSync),
          .RXNAKSync            (RXNAKSync),
          .CLKDISSync           (CLKDISSync),
          .CLKVALSync           (CLKVALSync),
          .ATRDENSync           (ATRDENSync),
          .BLKENSync            (BLKENSync),
          .MODESync             (MODESync),
          .CLKZ1Sync            (CLKZ1Sync), 
          .BGTENSync            (BGTENSync),
          .EXDBNCESync          (EXDBNCESync),
          .SYNCCARDSync         (SYNCCARDSync),
          .WDATASync            (WDATASync),
          .WCLKSync             (WCLKSync),
          .WDATAENSync          (WDATAENSync),
          .WCLKENSync           (WCLKENSync),
          .WRSTSync             (WRSTSync),
          .WFCBSync             (WFCBSync),
          .STARTUPWrSync        (STARTUPWrSync),
          .FINISHWrSync         (FINISHWrSync),
          .WRESETWrSync         (WRESETWrSync),

// Interrupt clear outputs

          .CARDINICSync         (CARDINICSync),
          .CARDOUTICSync        (CARDOUTICSync),
          .CARDUPICSync         (CARDUPICSync),
          .CARDDNICSync         (CARDDNICSync),
          .TXERRICSync          (TXERRICSync),
          .ATRSTOUTICSync       (ATRSTOUTICSync),
          .ATRDTOUTICSync       (ATRDTOUTICSync),
          .BLKTOUTICSync        (BLKTOUTICSync),
          .CHTOUTICSync         (CHTOUTICSync),
          .RTOUTICSync          (RTOUTICSync),
          .CLKSTPICSync         (CLKSTPICSync),
          .CLKACTICSync         (CLKACTICSync),

// Interrupt mask set clear outputs

          .CARDINIMSCSync       (CARDINIMSCSync),
          .CARDOUTIMSCSync      (CARDOUTIMSCSync),
          .CARDUPIMSCSync       (CARDUPIMSCSync),
          .CARDDNIMSCSync       (CARDDNIMSCSync),
          .TXERRIMSCSync        (TXERRIMSCSync),
          .ATRSTOUTIMSCSyn      (ATRSTOUTIMSCSyn),
          .ATRDTOUTIMSCSyn      (ATRDTOUTIMSCSyn),
          .BLKTOUTIMSCSync      (BLKTOUTIMSCSync),
          .CHTOUTIMSCSync       (CHTOUTIMSCSync),
          .RTOUTIMSCSync        (RTOUTIMSCSync),
          .CLKSTPIMSCSync       (CLKSTPIMSCSync),
          .CLKACTIMSCSync       (CLKACTIMSCSync)
          );


// -----------------------------------------------------------------------------
// This module generates the final interrupts based on the raw, masked and 
// clear status.
// -----------------------------------------------------------------------------

  SciIntGen uSciIntGen          (
// Inputs
// Raw interrupt source bits
          .TXRIS                (TXRIS),
          .RXRIS                (RXRIS),
          .CLKACTRIS            (CLKACTRIS),
          .CLKSTPRIS            (CLKSTPRIS),
          .RORRIS               (RORRIS),
          .RTOUTRIS             (RTOUTRIS),
          .CHTOUTRIS            (CHTOUTRIS),
          .BLKTOUTRIS           (BLKTOUTRIS),
          .ATRDTOUTRIS          (ATRDTOUTRIS),
          .ATRSTOUTRIS          (ATRSTOUTRIS),
          .TXERRRIS             (TXERRRIS),
          .CARDDNRIS            (CARDDNRIS),
          .CARDUPRIS            (CARDUPRIS),
          .CARDOUTRIS           (CARDOUTRIS),
          .CARDINRIS            (CARDINRIS),

// Interrupt mask set clear bits
          .TXIMSC               (TXIMSC),
          .RXIMSC               (RXIMSC),
          .CLKACTIMSCSync       (CLKACTIMSCSync),
          .CLKSTPIMSCSync       (CLKSTPIMSCSync),
          .RORIMSC              (RORIMSC),
          .RTOUTIMSCSync        (RTOUTIMSCSync),
          .CHTOUTIMSCSync       (CHTOUTIMSCSync),
          .BLKTOUTIMSCSync      (BLKTOUTIMSCSync),
          .ATRDTOUTIMSCSyn      (ATRDTOUTIMSCSyn),
          .ATRSTOUTIMSCSyn      (ATRSTOUTIMSCSyn),
          .TXERRIMSCSync        (TXERRIMSCSync),
          .CARDDNIMSCSync       (CARDDNIMSCSync),
          .CARDUPIMSCSync       (CARDUPIMSCSync),
          .CARDOUTIMSCSync      (CARDOUTIMSCSync),
          .CARDINIMSCSync       (CARDINIMSCSync),

// Interrupt Clear bits
          .CLKACTIC             (CLKACTIC),
          .CLKSTPIC             (CLKSTPIC),
          .RORIC                (RORIC),
          .RTOUTIC              (RTOUTIC),
          .CHTOUTIC             (CHTOUTIC),
          .BLKTOUTIC            (BLKTOUTIC),
          .ATRDTOUTIC           (ATRDTOUTIC),
          .ATRSTOUTIC           (ATRSTOUTIC),
          .TXERRIC              (TXERRIC),
          .CARDDNIC             (CARDDNIC),
          .CARDUPIC             (CARDUPIC),
          .CARDOUTIC            (CARDOUTIC),
          .CARDINIC             (CARDINIC),

// Outputs
          .TXMIS                (TXMIS),
          .RXMIS                (RXMIS),
          .CLKACTMIS            (CLKACTMIS),
          .CLKSTPMIS            (CLKSTPMIS),
          .RORMIS               (RORMIS),
          .RTOUTMIS             (RTOUTMIS),
          .CHTOUTMIS            (CHTOUTMIS),
          .BLKTOUTMIS           (BLKTOUTMIS),
          .ATRDTOUTMIS          (ATRDTOUTMIS),
          .ATRSTOUTMIS          (ATRSTOUTMIS),
          .TXERRMIS             (TXERRMIS),
          .CARDDNMIS            (CARDDNMIS),
          .CARDUPMIS            (CARDUPMIS),
          .CARDOUTMIS           (CARDOUTMIS),
          .CARDINMIS            (CARDINMIS),

          .INTR                 (INTR)
                                );

// -----------------------------------------------------------------------------
// This module provides the DMA Interface
// -----------------------------------------------------------------------------

  SciDMA uSciDMA                (
          .PCLK                 (PCLK),
          .PRESETn              (PRESETn),
        
          .TXDMAE               (SCIDMACR[1]),
          .RXDMAE               (SCIDMACR[0]),
        
          .TXRIS                (TXRIS),
          .RXRIS                (RXRIS),
          .TXFLTE7Full          (TXFLTE7Full),
          .RXFGTE1Full          (RXFGTE1Full),
          .TXDMACLRSync         (TXDMACLRSync),
          .RXDMACLRSync         (RXDMACLRSync),
        
          .TXDMASREQ            (TXDMASREQ),
          .TXDMABREQ            (TXDMABREQ),
          .RXDMASREQ            (RXDMASREQ),
          .RXDMABREQ            (RXDMABREQ)
);

// -----------------------------------------------------------------------------
// This module contains the test logic of the SCI.
// -----------------------------------------------------------------------------
 SciTest uSciTest       (
// Inputs

// Inputs: APB interface
          .PCLK                 (PCLK),         
          .PRESETn              (PRESETn),
          .PWDATAIn             (PWDATAIn),

// Inputs: Intra-Chip Inputs multiplexed with register SCIITIP[5:4]
          .SCITXDMACLR          (SCITXDMACLR),
          .SCIRXDMACLR          (SCIRXDMACLR),

// Inputs: Intra-Chip Outputs multiplexed with register SCIITOP1[15:0]
          .TXDMASREQ            (TXDMASREQ),
          .TXDMABREQ            (TXDMABREQ),
          .RXDMASREQ            (RXDMASREQ),
          .RXDMABREQ            (RXDMABREQ),
          .TXMIS                (TXMIS),
          .RXMIS                (RXMIS),
          .RTOUTMIS             (RTOUTMIS),
          .CHTOUTMIS            (CHTOUTMIS),
          .BLKTOUTMIS           (BLKTOUTMIS),
          .ATRDTOUTMIS          (ATRDTOUTMIS),
          .ATRSTOUTMIS          (ATRSTOUTMIS),
          .TXERRMIS             (TXERRMIS),
          .CARDDNMIS            (CARDDNMIS),
          .CARDUPMIS            (CARDUPMIS),
          .CARDOUTMIS           (CARDOUTMIS),
          .CARDINMIS            (CARDINMIS),

// Inputs: Intra-Chip Outputs multiplexed with register SCIITOP2[10:9]
          .INTR                 (INTR),
          .CLKACTMIS            (CLKACTMIS),
          .CLKSTPMIS            (CLKSTPMIS),
          .RORMIS               (RORMIS),

// Inputs: Primary outputs multiplexed with SCIITOP2[8:0]
          .CLKOUT               (CLKOUT),
          .nCLKOUTEN            (nCLKOUTEN),
          .nCLKEN               (nCLKEN),
          .nDATAOUTEN           (nDATAOUTEN),
          .nDATAEN              (nDATAEN),
          .VCCEN                (VCCEN),
          .FCB                  (FCB),
          .nCARDRST             (nCARDRST),
          .DEACACK              (DEACACK),

// Inputs: Test register Write Enables 
          .SCITCRWr             (SCITCRWr),
          .SCIITIPWr            (SCIITIPWr),
          .SCIITOP1Wr           (SCIITOP1Wr),
          .SCIITOP2Wr           (SCIITOP2Wr),

// Inputs: Test register Read Enable 
          .SCITDRrd             (SCITDRrd),
           
// Outputs     
 
// Outputs: Multiplexed output of Intra-Chip Inputs and SCIITIP[5:4]
          .TXDMACLR             (TXDMACLR),
          .RXDMACLR             (RXDMACLR),

// Outputs: Multiplexed output of Intra-Chip Outputs and SCIITOP1[15:0]
          .SCITXDMASREQ         (SCITXDMASREQ),
          .SCITXDMABREQ         (SCITXDMABREQ),
          .SCIRXDMASREQ         (SCIRXDMASREQ),
          .SCIRXDMABREQ         (SCIRXDMABREQ),
          .SCITXTIDEINTR        (SCITXTIDEINTR),
          .SCIRXTIDEINTR        (SCIRXTIDEINTR),
          .SCIRTOUTINTR         (SCIRTOUTINTR),
          .SCICHTOUTINTR        (SCICHTOUTINTR),
          .SCIBLKTOUTINTR       (SCIBLKTOUTINTR),
          .SCIATRDTOUTINTR      (SCIATRDTOUTINTR),
          .SCIATRSTOUTINTR      (SCIATRSTOUTINTR),
          .SCITXERRINTR         (SCITXERRINTR ),
          .SCICARDDNINTR        (SCICARDDNINTR),
          .SCICARDUPINTR        (SCICARDUPINTR),
          .SCICARDOUTINTR       (SCICARDOUTINTR),
          .SCICARDININTR        (SCICARDININTR),
          
// Outputs: Multiplexed output of Intra-Chip Outputs and SCIITOP2[10:9]
          .SCIINTR              (SCIINTR),
          .SCICLKACTINTR        (SCICLKACTINTR),
          .SCICLKSTPINTR        (SCICLKSTPINTR),
          .SCIRORINTR           (SCIRORINTR),

// Outputs: Multiplexed Primary outputs with SCIITOP2[8:0]
          .SCICLKOUT            (SCICLKOUT),
          .nSCICLKOUTEN         (nSCICLKOUTEN),
          .nSCICLKEN            (nSCICLKEN),
          .nSCIDATAOUTEN        (nSCIDATAOUTEN),
          .nSCIDATAEN           (nSCIDATAEN),
          .SCIVCCEN             (SCIVCCEN),
          .SCIFCB               (SCIFCB),
          .nSCICARDRST          (nSCICARDRST),
          .SCIDEACACK           (SCIDEACACK),

// Outputs: Primary outputs Register (SCIITOP2[8:0]) readback bits
          .SCIITOP2Reg          (SCIITOP2Reg),

// Test control signals
          .TESTFIFO             (TESTFIFO),
          .ITEN                 (ITEN),
          .TestTXFInc           (TestTXFInc)
                                );

// Instantiate Device Revision
assign TieOff1      = 4'b0000;
assign TieOff2      = 4'b1111;

// ---------------------------------------------------------------------
// 1st instantiation of SciRevAnd
// ---------------------------------------------------------------------
  SciRevAnd  u0SciRevAnd (

            .TieOff1  (TieOff1[0]),
            .TieOff2  (TieOff2[0]),

            .Revision (Revision[0])
    );

// ---------------------------------------------------------------------
// 2nd instantiation of SciRevAnd
// ---------------------------------------------------------------------
  SciRevAnd  u1SciRevAnd (

            .TieOff1 (TieOff1[1]),
            .TieOff2 (TieOff2[1]),

            .Revision (Revision[1])
    );

// ---------------------------------------------------------------------
// 3rd instantiation of SciRevAnd
// ---------------------------------------------------------------------
  SciRevAnd  u2SciRevAnd (

            .TieOff1  (TieOff1[2]),
            .TieOff2  (TieOff2[2]),

            .Revision (Revision[2])
    );
    
// ---------------------------------------------------------------------
// 4th instantiation of SciRevAnd
// ---------------------------------------------------------------------
  SciRevAnd  u3SciRevAnd (

            .TieOff1  (TieOff1[3]),
            .TieOff2  (TieOff2[3]),

            .Revision (Revision[3])
    );
endmodule
