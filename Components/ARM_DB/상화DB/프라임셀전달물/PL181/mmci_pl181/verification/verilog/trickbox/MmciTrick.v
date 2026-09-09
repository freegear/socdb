// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : MmciTrick.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Data Flow code for the Top level. Instantiates the
//           following modules MmciTrApbif, MmciTrRegblk,
//           MmciTrMclkRsgen, MmciTrSynctoMCLK, MmciTrSynctoPCLK,
//           MmciTrRxFifo, MmciTrTxFifo, MmciTrCrc16gen, MmciTrCrc7gen,
//           MmciTrStoP, MmciTrPtoS, MmciTrChecker and defines the
//           connectivity between them.
//
// --=========================================================================--

`timescale 1ns/1ps

// ----------------------------------------------------------------------------

module MmciTrick (
// Inputs
                  PCLK,
                  MMCICLKOUT,
                  PRESETn,
                  PSEL,
                  PSELT,
                  PWRITE,
                  PENABLE,
                  MMCIPWR,
                  MMCIVDD,
                  MMCIROD,
                  MMCIINTR0,
                  MMCIINTR1,
                  MMCIDMASREQ,
                  MMCIDMABREQ,
                  MMCIDMALSREQ,
                  MMCIDMALBREQ,
                  PADDR,
                  PWDATA,
// Inouts
                  MMCICMD,
                  MMCIDAT,
// Outputs
                  MCLK,
                  nMMCIRST,
                  MMCIDMACLR,
                  PRDATA
                 );

// Inputs
input         PCLK;         // APB Bus Clock
input         MMCICLKOUT;   // MMCI Bus Clock
input         PRESETn;      // APB Bus Reset
input         PSEL;         // APB MMCI select
input         PSELT;        // APB Trickbox select
input         PWRITE;       // APB Peripheral Write
input         PENABLE;      // APB Peripheral enable
input         MMCIPWR;      // MMCI Bus Power phase Indication
input   [3:0] MMCIVDD;      // Power Supply input voltage
input         MMCIROD;      // Open Drain resistor enable
input         MMCIINTR0;    // Interrupt 0 Request from MMCI
input         MMCIINTR1;    // Interrupt 1 Request from MMCI
input         MMCIDMASREQ;  // DMA Single Req from MMCI
input         MMCIDMABREQ;  // DMA Burst Req from MMCI
input         MMCIDMALSREQ; // DMA last single Req from MMCI
input         MMCIDMALBREQ; // DMA last Burst Req from MMCI
input  [11:2] PADDR;        // APB Addr
input  [31:0] PWDATA;       // Write databus

// Inouts
inout         MMCICMD;      // MMCI command path
inout         MMCIDAT;      // MMCI data path

// Outputs
output        MCLK;         // MMCI Adapter Clock
output        nMMCIRST;     // MCLK Domain reset signal
output        MMCIDMACLR;   // MMCI DMA request clear
output [31:0] PRDATA;       // Read Databus

// Inputs
wire        PCLK;           // APB Bus Clock
wire        MMCICLKOUT;     // MMCI Bus Clock
wire        PRESETn;        // APB Bus Reset
wire        PSEL;           // APB MMCI select
wire        PSELT;          // APB Trickbox select
wire        PWRITE;         // APB Peripheral Write
wire        PENABLE;        // APB Peripheral enable
wire        MMCIPWR;        // MMCI Bus Power phase Indication
wire  [3:0] MMCIVDD;        // Power Supply input voltage
wire        MMCIROD;        // Open Drain resistor enable
wire        MMCIINTR0;      // Interrupt 0 Request from MMCI
wire        MMCIINTR1;      // Interrupt 1 Request from MMCI
wire        MMCIDMASREQ;    // DMA Single Req from MMCI
wire        MMCIDMABREQ;    // DMA Burst Req from MMCI
wire        MMCIDMALSREQ;   // DMA last single Req from MMCI
wire        MMCIDMALBREQ;   // DMA last Burst Req from MMCI
wire [11:2] PADDR;          // APB Addr
wire [31:0] PWDATA;         // Write databus

// Inouts
wire        MMCICMD;        // MMCI command path
wire        MMCIDAT;        // MMCI data path

// Outputs
wire        MCLK;           // MMCI Adapter Clock
wire        nMMCIRST;       // MCLK Domain reset signal
wire        MMCIDMACLR;     // MMCI DMA request clear
wire [31:0] PRDATA;         // Read Databus

// -----------------------------------------------------------------------------
//
//                                    MmciTrick
//                                    =========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This module instantiates the following sub-modules:
//
// 1. MmciTrApbif         - APB Interface
// 2. MmciTrRegBlk        - Register Block
// 3. MmciTrRxFifo        - Receive FIFO
// 4. MmciTrTxFifo        - Transmit FIFO
// 5. MmciTrStoP          - Receiver/Serial to Parallel converter
// 6. MmciTrSynctoPCLK    - Synchronisers for signals crossing into
//                          PCLK domain
// 7. MmciTrSynctoMCLK    - Synchronisers for signals crossing into
//                          MMCICLK domain
// 8. MmciTrMclkRsgen     - Clock generation and RST Controller Block
// 9. MmciTrChecker       - Protocol Checker Block
// 10.MmciTrPtoS          - Transmitter/Parallel to Serial Convertor
// 11.MmciTrCrc7gen       - Generates CRC7
// 12.MmciTrCrc16gen      - Generates CRC16
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        inMMCIRST;
// Reset for MMCI Controller

wire  [5:0] MMCITBSIGSTAT;
// Gives readability to Interrupt and DMA Requests of MMCI

wire  [5:0] MMCITBRxdCInd;
// Cmd Index recd from MMCI

wire [31:0] MMCITBRxdCArg;
// Cmd Argument recd from MMCI

wire  [7:0] MMCIPower;
// MMCIPower register

wire [10:0] MMCIClock;
// MMCIClock register

wire [10:0] MMCICommand;
// MMCICommand register

wire [15:0] MMCIDataLength;
// MMCIDataLength register

wire  [7:0] MMCIDataCntl;
// MMCIDataCntl register

wire [13:0] MMCITBCntl;
// MMCITBCntl register

wire [31:0] MMCITBMCLKPeriod;
// The period of MCLK

wire        iMCLK;
// local copy of MCLK

wire        RFF;
// RX FIFO Full indication

wire        TFF;
// TX FIFO Full indication

wire        RFE;
// RX FIFO empty indication

wire        TFE;
// TX FIFO empty indication

wire        TFHE;
// TX FIFO half empty indication

wire        RFHF;
// RX FIFO half full indication

wire        FifoClear;
// Clear signal for FIFO

wire        FifoClearSync;
// Syncd version of FifoClear

wire        PCLKOn;
// Indicates PCLK in internally active

wire        MCLKOn;
// Indicates MCLK in internally active

wire [32:0] RxFRdData;
// RX FIFO read data

wire        RxFRdPtrInc;
// RX FIFO read pionter increment

wire        MMCIPowerWr;
// Write enable for MMCIPower Reg

wire        MMCIClockWr;
// Write enable for MMCIClock Reg

wire        MMCICommandWr;
// Write enable for MMCICommand Reg

wire        MMCIDataLenWr;
// Write enable for MMCIDataLength Reg

wire        MMCIDataCntlWr;
// Write enable for MMCIDataCntl Reg

wire        MMCITBCmdRespWr;
// Write enable for MMCITBCmdResp Reg

wire        MMCITBResp0Wr;
// Write enable for MMCITBResp0 Reg

wire        MMCITBResp1Wr;
// Write enable for MMCITBResp1 Reg

wire        MMCITBResp2Wr;
// Write enable for MMCITBResp2 Reg

wire        MMCITBResp3Wr;
// Write enable for MMCITBResp3 Reg

wire        MMCITBMCLKWr;
// Write enable for MMCITBMCLK Reg

wire        MMCITBCntlWr;
// Write enable for MMCITBCntl Reg

wire        MMCITBReTimWr;
// Write enable for MMCITBRespTimer Reg

wire        MMCITBDtTimWr;
// Write enable for MMCITBDataTimer reg

wire        MMCITBTokTimWr;
// Write enable for MMCITBTokenTimer Reg

wire        MMCITBBsyTimWr;
// Write enable for MMCITBBsyTimer Reg

wire        MMCITBPCDisWr;
// Write enable for MMCITBPCDisable Reg

wire        MMCITBStTimWr;
// Write enable for MMCITBStTimeout Reg

wire        MMCITBCLKRSTWr;
// Write enable for MMCITBCLKRST Reg

wire [31:0] PWDATAIn;
// local version of PWDATA

wire        RxFWrSync;
// Syncd version of Rx Fifo Write enable

wire [32:0] RxFWrData;
// Rx Fifo Write Data

wire        RNE;
// Rx Fifo not empty indication

wire        MMCITBTXFWr;
// Write enable for Tx Fifo

wire        TxFRdSync;
// Tx Fifo Read pointer Inc, syncd with PCLK

wire        TxDataAvlbl;
// Indication of Data availability in Tx Fifo

wire [31:0] TxFRdData;
// Tx FIFO Read Data

wire        TNF;
// Tx Fifo not empty indication

wire        MTBCIUpdate;
// Update signal to MMCITBRxdCInd Reg

wire        MTBCAUpdate;
// Update signal to MMCITBRxdCArg Reg

wire        RxFWr;
// write enable for Rx Fifo, in MMCICLK domain

wire        TxFRd;
// Read pointer inc for Tx Fifo, in MMCICLK domain

wire        MTBCIUpdateSync;
// Syncd Update signal to MMCITBRxdCInd Reg

wire        MTBCAUpdateSync;
// Syncd Update signal to MMCITBRxdCArg Reg

wire        MPUpdate;
// Update signal to MMCIPower Reg

wire        MCUpdate;
// Update signal to MMCIClock Reg

wire        MCMUpdate;
// Update signal to MMCICommand Reg

wire        MDLUpdate;
// Update signal to MMCIDataLength Reg

wire        MDCUpdate;
// Update signal to MMCIDataCntl Reg

wire        MTBCUpdate;
// Update signal to MMCITBCntl Reg

wire        MPUpdateSync;
// Syncd Update signal to MMCIPower Reg

wire        MCUpdateSync;
// Syncd Update signal to MMCIClock Reg

wire        MCMUpdateSync;
// Syncd Update signal to MMCICommand Reg

wire        MDLUpdateSync;
// Syncd Update signal to MMCIDataLength Reg

wire        MDCUpdateSync;
// Syncd Update signal to MMCIDataCntl Reg

wire        MTBCUpdateSync;
// Syncd Update signal to MMCITBCntl Reg

wire        MDCStg2WrEn;
// Indicates any write to MMCIDataCtrl register

wire  [5:0] MMCITBRxdCIndS2;
// Buffered MMCITBRxdCInd Reg

wire [31:0] MMCITBRxdCArgS2;
// Buffered MMCITBRxdCArg Reg

wire        Crc7En;
// Enable for CRC7 calculation

wire        TCRC7En;
// Enable for CRC7 calculation for txd response

wire        RCRC7En;
// Enable for CRC7 calculation for cmd rxd

wire  [6:0] CRC7;
// CRC7 Value

wire        CrcBufferBit;
// Crc buffer bit, to make up for 2 clk latency b/w CmdCnt and CRC7

wire        CmdCrcErrStat;
// Gives the status of Crc bits in the recd command

wire        CRC16En;
// Enable for CRC16 calculation

wire        RCRC16En;
// Enable for CRC16 calculation for data reception

wire        TCRC16En;
// Enable for CRC16 calculation for data transmission

wire [15:0] CRC160;
// CRC160 for data on line 0

wire  [3:0] DCrcBufferBit;
// BufferBit for CRC16, one bit per data line

wire  [3:0] Blocklen;
// Block size as specified in DataCntl Reg

wire        RxCommand;
// Handshake signal used to qualify command reception

wire        CmdEnable;
// Enable bit in command register

wire        DataEn;
// Enable bit in Data register

wire        DataDirection;
// Direction of flow on data lines

wire        DataMode;
// Indicates whether Data is in Stream or Block mode

wire [15:0] DataLength;
// Number of bytes of data involved in transfer

wire        TokenSent;
// Handshake signal, qualifies sending of token bits

wire        TkCntOver;
// Qualifies the period when token is being sent

wire        SendResponse;
// Qualifies sending of responce

wire        CTxBitCheckErr;
// Indicates Error on Tx Bit

wire        DataRxd;
// Qualifies completion of data reception

wire [15:0] DataCnt;
// Counts down with each byte of data received

wire  [2:0] BitCnt;
// Counts each bit of data received

wire  [1:0] ResponseBits;
// Responce bits in command register

wire [31:0] CmdRespCnt;
// Counter to count CmdRespTimer Reg value

wire        CmdCrcErr;
// Indicates any error on recd command CRC

wire [31:0] DataTimeCnt;
// Counter to count DataTimer Reg value

wire        BlkEnd;
// Indicates the end of a block

wire [15:0] TokenTimeCnt;
// Counter to count TokenTimer Reg value

wire [15:0] BsyTimeCnt;
// Counter to count BsyTimer Reg value

wire        TokenErrBit;
// Controls Tx of correct Crc Token

wire        DataCrcErr;
// Controls Tx of correct Crc with data, one bit for each line

wire        MMCICMDBUS;
// Version of MMCICMD, which takes into account the OpenDrain mode
// cmd transfer

wire        MMCIDATIn;
// Version of MMCIDAT, which is drived only in trickbox rception mode

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Assigning Fifo Flags
// -----------------------------------------------------------------------------
assign RFE              = ~(RNE);
assign TFF              = ~(TNF);

// -----------------------------------------------------------------------------
// Assigning Reset and clock outputs
// -----------------------------------------------------------------------------
assign nMMCIRST         = inMMCIRST;
assign MCLK             = iMCLK;

// -----------------------------------------------------------------------------
// Generating enables for CRC computation
// -----------------------------------------------------------------------------
assign Crc7En           = TCRC7En | RCRC7En;
assign CRC16En          = TCRC16En | RCRC16En;

// -----------------------------------------------------------------------------
// Component Instantiations and port mapping
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// MmciTrApbif Instantiation
// -----------------------------------------------------------------------------
MmciTrApbif uMmciTrApbif              (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSEL),
                    .PSELT            (PSELT),
                    .PWRITE           (PWRITE),
                    .PENABLE          (PENABLE),
                    .MMCITBSIGSTAT    (MMCITBSIGSTAT),
                    .MMCITBRxdCInd    (MMCITBRxdCInd),
                    .MMCITBRxdCArg    (MMCITBRxdCArg),
                    .RFF              (RFF),
                    .TFF              (TFF),
                    .RFE              (RFE),
                    .TFE              (TFE),
                    .TFHE             (TFHE),
                    .RFHF             (RFHF),
                    .PCLKOn           (PCLKOn),
                    .MCLKOn           (MCLKOn),
                    .CmdCrcErrStat    (CmdCrcErrStat),
                    .RxFRdData        (RxFRdData),
                    .PADDR            (PADDR),
                    .PWDATA           (PWDATA),
                    .RxFRdPtrInc      (RxFRdPtrInc),
                    .MMCIPowerWr      (MMCIPowerWr),
                    .MMCIClockWr      (MMCIClockWr),
                    .MMCICommandWr    (MMCICommandWr),
                    .MMCIDataLenWr    (MMCIDataLenWr),
                    .MMCIDataCntlWr   (MMCIDataCntlWr),
                    .MMCITBCmdRespWr  (MMCITBCmdRespWr),
                    .MMCITBResp0Wr    (MMCITBResp0Wr),
                    .MMCITBResp1Wr    (MMCITBResp1Wr),
                    .MMCITBResp2Wr    (MMCITBResp2Wr),
                    .MMCITBResp3Wr    (MMCITBResp3Wr),
                    .MMCITBDtTimWr    (MMCITBDtTimWr),
                    .MMCITBMCLKWr     (MMCITBMCLKWr),
                    .MMCITBCntlWr     (MMCITBCntlWr),
                    .MMCITBReTimWr    (MMCITBReTimWr),
                    .MMCITBTokTimWr   (MMCITBTokTimWr),
                    .MMCITBBsyTimWr   (MMCITBBsyTimWr),
                    .MMCITBPCDisWr    (MMCITBPCDisWr),
                    .MMCITBStTimWr    (MMCITBStTimWr),
                    .MMCITBCLKRSTWr   (MMCITBCLKRSTWr),
                    .MMCITBTXFWr      (MMCITBTXFWr),
                    .PRDATA           (PRDATA),
                    .PWDATAIn         (PWDATAIn)
                   );

// -----------------------------------------------------------------------------
// Rx FIFO instantiation
// -----------------------------------------------------------------------------

MmciTrRxFifo uMmciTrRxFifo            (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .FifoClearSync    (FifoClearSync),
                    .RxFWrSync        (RxFWrSync),
                    .RxFRdPtrInc      (RxFRdPtrInc),
                    .RxFWrData        (RxFWrData),
                    .RNE              (RNE),
                    .RFF              (RFF),
                    .RFHF             (RFHF),
                    .RxFRdData        (RxFRdData)
                   );

// -----------------------------------------------------------------------------
// Tx FIFO instantiation
// -----------------------------------------------------------------------------

MmciTrTxFifo uMmciTrTxFifo            (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .FifoClearSync    (FifoClearSync),
                    .MMCITBTXFWr      (MMCITBTXFWr),
                    .TxFRdSync        (TxFRdSync),
                    .PWDATAIn         (PWDATAIn),
                    .TxDataAvlbl      (TxDataAvlbl),
                    .TNF              (TNF),
                    .TFE              (TFE),
                    .TFHE             (TFHE),
                    .TxFRdData        (TxFRdData)
                   );

// -----------------------------------------------------------------------------
// MmciTrSynctoPCLK instantiation
// -----------------------------------------------------------------------------

MmciTrSynctoPCLK uMmciTrSynctoPCLK    (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .MTBCIUpdate      (MTBCIUpdate),
                    .MTBCAUpdate      (MTBCAUpdate),
                    .RxFWr            (RxFWr),
                    .TxFRd            (TxFRd),
                    .FifoClear        (FifoClear),
                    .MTBCIUpdateSync  (MTBCIUpdateSync),
                    .MTBCAUpdateSync  (MTBCAUpdateSync),
                    .FifoClearSync    (FifoClearSync),
                    .RxFWrSync        (RxFWrSync),
                    .TxFRdSync        (TxFRdSync)
                   );

// -----------------------------------------------------------------------------
// MmciTrSynctoMCLK instantiation
// -----------------------------------------------------------------------------

MmciTrSynctoMCLK uMmciTrSynctoMCLK    (
                    .MCLK             (iMCLK),
                    .nMMCIRST         (inMMCIRST),
                    .MPUpdate         (MPUpdate),
                    .MCUpdate         (MCUpdate),
                    .MCMUpdate        (MCMUpdate),
                    .MDLUpdate        (MDLUpdate),
                    .MDCUpdate        (MDCUpdate),
                    .MTBCUpdate       (MTBCUpdate),
                    .MPUpdateSync     (MPUpdateSync),
                    .MCUpdateSync     (MCUpdateSync),
                    .MCMUpdateSync    (MCMUpdateSync),
                    .MDLUpdateSync    (MDLUpdateSync),
                    .MDCUpdateSync    (MDCUpdateSync),
                    .MTBCUpdateSync   (MTBCUpdateSync)
                   );

// -----------------------------------------------------------------------------
// MmciTrRegBlk instantiation
// -----------------------------------------------------------------------------

MmciTrRegblk uMmciTrRegblk            (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .MMCIPowerWr      (MMCIPowerWr),
                    .MMCIClockWr      (MMCIClockWr),
                    .MMCICommandWr    (MMCICommandWr),
                    .MMCIDataLenWr    (MMCIDataLenWr),
                    .MMCIDataCntlWr   (MMCIDataCntlWr),
                    .MMCITBCntlWr     (MMCITBCntlWr),
                    .MMCITBRxdCIndS2  (MMCITBRxdCIndS2),
                    .MMCITBRxdCArgS2  (MMCITBRxdCArgS2),
                    .MTBCIUpdateSync  (MTBCIUpdateSync),
                    .MTBCAUpdateSync  (MTBCAUpdateSync),
                    .PWDATAIn         (PWDATAIn),
                    .MMCIPower        (MMCIPower),
                    .MMCIClock        (MMCIClock),
                    .MMCICommand      (MMCICommand),
                    .MMCIDataLength   (MMCIDataLength),
                    .MMCIDataCntl     (MMCIDataCntl),
                    .MMCITBCntl       (MMCITBCntl),
                    .MPUpdate         (MPUpdate),
                    .MCUpdate         (MCUpdate),
                    .MCMUpdate        (MCMUpdate),
                    .MDLUpdate        (MDLUpdate),
                    .MDCUpdate        (MDCUpdate),
                    .MTBCUpdate       (MTBCUpdate),
                    .MMCITBRxdCInd    (MMCITBRxdCInd),
                    .MMCITBRxdCArg    (MMCITBRxdCArg)
                   );

// -----------------------------------------------------------------------------
// MmciTrCrc7gen instantiation
// -----------------------------------------------------------------------------

MmciTrCrc7gen uMmciTrCrc7gen          (
                    .MMCICLK          (MMCICLKOUT),
                    .nMMCIRST         (inMMCIRST),
                    .Crc7En           (Crc7En),
                    .SendResponse     (SendResponse),
                    .MMCICMD          (MMCICMDBUS),
                    .CRC7             (CRC7),
                    .CrcBufferBit     (CrcBufferBit)
                   );

// -----------------------------------------------------------------------------
// MmciTrCrc16gen instantiation for Data line 0
// -----------------------------------------------------------------------------

MmciTrCrc16gen uMmciTrCrc16gen0       (
                    .MMCICLK          (MMCICLKOUT),
                    .nMMCIRST         (inMMCIRST),
                    .CRC16En          (CRC16En),
                    .DataDirection    (DataDirection),
                    .MMCIDAT          (MMCIDAT),
                    .CRC16            (CRC160),
                    .DCrcBufferBit    (DCrcBufferBit[0])
                   );

// -----------------------------------------------------------------------------
// MmciTrStoP instantiation
// -----------------------------------------------------------------------------

MmciTrStoP uMmciTrStoP                (
                    .MMCICLK          (MMCICLKOUT),
                    .nMMCIRST         (inMMCIRST),
                    .DataLength       (DataLength),
                    .Blocklen         (Blocklen),
                    .RxCommand        (RxCommand),
                    .SendResponse     (SendResponse),
                    .CmdEnable        (CmdEnable),
                    .DataEn           (DataEn),
                    .DataDirection    (DataDirection),
                    .DataMode         (DataMode),
                    .TokenSent        (TokenSent),
                    .MDCStg2WrEn      (MDCStg2WrEn),
                    .CRC7             (CRC7),
                    .CRC160           (CRC160),
                    .MMCICMDIn        (MMCICMDBUS),
                    .MMCIDATIn        (MMCIDATIn),
                    .MMCITBRxdCIndS2  (MMCITBRxdCIndS2),
                    .MMCITBRxdCArgS2  (MMCITBRxdCArgS2),
                    .MTBCIUpdate      (MTBCIUpdate),
                    .MTBCAUpdate      (MTBCAUpdate),
                    .DataCnt          (DataCnt),
                    .BitCnt           (BitCnt),
                    .RxFWr            (RxFWr),
                    .CmdCrcErrStat    (CmdCrcErrStat),
                    .CTxBitCheckErr   (CTxBitCheckErr),
                    .RCRC7En          (RCRC7En),
                    .RCRC16En         (RCRC16En),
                    .DataRxd          (DataRxd),
                    .RxFWrData        (RxFWrData)
                   );

// -----------------------------------------------------------------------------
// MmciTrPtoS instantiation
// -----------------------------------------------------------------------------

MmciTrPtoS uMmciTrPtoS                (
                    .MMCICLK          (MMCICLKOUT),
                    .nMMCIRST         (inMMCIRST),
                    .ResponseBits     (ResponseBits),
                    .CmdEnable        (CmdEnable),
                    .CmdRespCnt       (CmdRespCnt),
                    .MMCITBCmdRespWr  (MMCITBCmdRespWr),
                    .MMCITBResp0Wr    (MMCITBResp0Wr),
                    .MMCITBResp1Wr    (MMCITBResp1Wr),
                    .MMCITBResp2Wr    (MMCITBResp2Wr),
                    .MMCITBResp3Wr    (MMCITBResp3Wr),
                    .CRC7             (CRC7),
                    .CrcBufferBit     (CrcBufferBit),
                    .CmdCrcErr        (CmdCrcErr),
                    .DataEn           (DataEn),
                    .DataDirection    (DataDirection),
                    .DataMode         (DataMode),
                    .DataLength       (DataLength),
                    .Blocklen         (Blocklen),
                    .MDCStg2WrEn      (MDCStg2WrEn),
                    .TxFRdData        (TxFRdData),
                    .CRC160           (CRC160),
                    .DCrcBufferBit    (DCrcBufferBit),
                    .DataTimeCnt      (DataTimeCnt),
                    .TokenTimeCnt     (TokenTimeCnt),
                    .BsyTimeCnt       (BsyTimeCnt),
                    .DataRxd          (DataRxd),
                    .TokenErrBit      (TokenErrBit),
                    .DataCrcErr       (DataCrcErr),
                    .SendResponse     (SendResponse),
                    .RxCommand        (RxCommand),
                    .PWDATAIn         (PWDATAIn),
                    .TokenSent        (TokenSent),
                    .TkCntOver        (TkCntOver),
                    .TxFRd            (TxFRd),
                    .TCRC7En          (TCRC7En),
                    .TCRC16En         (TCRC16En),
                    .BlkEnd           (BlkEnd),
                    .MMCICMD          (MMCICMD),
                    .MMCIDAT          (MMCIDAT)
                   );

// -----------------------------------------------------------------------------
// MmciTrChecker instantiation
// -----------------------------------------------------------------------------

MmciTrChecker uMmciTrChecker          (
                    .MMCICLK          (MMCICLKOUT),
                    .nMMCIRST         (inMMCIRST),
                    .MMCIINTR0        (MMCIINTR0),
                    .MMCIINTR1        (MMCIINTR1),
                    .MMCIDMASREQ      (MMCIDMASREQ),
                    .MMCIDMABREQ      (MMCIDMABREQ),
                    .MMCIDMALSREQ     (MMCIDMALSREQ),
                    .MMCIDMALBREQ     (MMCIDMALBREQ),
                    .MMCIPWR          (MMCIPWR),
                    .MMCIVDD          (MMCIVDD),
                    .MMCIROD          (MMCIROD),
                    .MMCIPower        (MMCIPower),
                    .MMCIClock        (MMCIClock),
                    .MMCICommand      (MMCICommand),
                    .MMCIDataLength   (MMCIDataLength),
                    .MMCIDataCntl     (MMCIDataCntl),
                    .MMCITBCntl       (MMCITBCntl),
                    .MMCITBMCLKPeriod (MMCITBMCLKPeriod),
                    .DataCnt          (DataCnt),
                    .BitCnt           (BitCnt),
                    .MMCITBReTimWr    (MMCITBReTimWr),
                    .MMCITBDtTimWr    (MMCITBDtTimWr),
                    .MMCITBTokTimWr   (MMCITBTokTimWr),
                    .MMCITBBsyTimWr   (MMCITBBsyTimWr),
                    .MMCITBPCDisWr    (MMCITBPCDisWr),
                    .MMCITBStTimWr    (MMCITBStTimWr),
                    .MPUpdateSync     (MPUpdateSync),
                    .MCUpdateSync     (MCUpdateSync),
                    .MCMUpdateSync    (MCMUpdateSync),
                    .MDLUpdateSync    (MDLUpdateSync),
                    .MDCUpdateSync    (MDCUpdateSync),
                    .MTBCUpdateSync   (MTBCUpdateSync),
                    .TokenSent        (TokenSent),
                    .BlkEnd           (BlkEnd),
                    .MMCICMD          (MMCICMD),
                    .MMCIDAT          (MMCIDAT),
                    .PWDATAIn         (PWDATAIn),
                    .MMCITBSIGSTAT    (MMCITBSIGSTAT),
                    .ResponseBits     (ResponseBits),
                    .CmdEnable        (CmdEnable),
                    .DataEn           (DataEn),
                    .DataDirection    (DataDirection),
                    .DataMode         (DataMode),
                    .DataLength       (DataLength),
                    .Blocklen         (Blocklen),
                    .MDCStg2WrEn      (MDCStg2WrEn),
                    .CmdCrcErr        (CmdCrcErr),
                    .DataCrcErr       (DataCrcErr),
                    .TokenErrBit      (TokenErrBit),
                    .CmdRespCnt       (CmdRespCnt),
                    .DataTimeCnt      (DataTimeCnt),
                    .TokenTimeCnt     (TokenTimeCnt),
                    .BsyTimeCnt       (BsyTimeCnt),
                    .MMCIDMACLR       (MMCIDMACLR),
                    .FifoClear        (FifoClear),
                    .SendResponse     (SendResponse),
                    .RxCommand        (RxCommand)
                    );

// -----------------------------------------------------------------------------
// MmciTrMclkRsgen instantiation
// -----------------------------------------------------------------------------

MmciTrMclkRsgen uMmciTrMclkRsgen      (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .MMCITBMCLKWr     (MMCITBMCLKWr),
                    .MMCITBCLKRSTWr   (MMCITBCLKRSTWr),
                    .PWDATAIn         (PWDATAIn),
                    .MCLK             (iMCLK),
                    .nMMCIRST         (inMMCIRST),
                    .MMCITBMCLKPeriod (MMCITBMCLKPeriod),
                    .PCLKOn           (PCLKOn),
                    .MCLKOn           (MCLKOn)
                   );

// -----------------------------------------------------------------------------
// MMCICMDBUS driven by bidirectional MMCICMD, command transfer in open
// drain mode is interpreted as '1' when MMCICMD is 'Z'.
// -----------------------------------------------------------------------------
assign MMCICMDBUS       = (MMCICMD === 1'bZ && MMCIPower[6]) ? 1'b1 :
                          ((~MMCICMD & MMCIPower[6]) ? 1'b0 : MMCICMD);

// -----------------------------------------------------------------------------
// MMCIDATIn is fed to MmciTrStoP and it is driven with MMCIDAT line only
// in the data reception case.
// -----------------------------------------------------------------------------
assign MMCIDATIn         = (~DataDirection & ~TkCntOver) ?
                           MMCIDAT : 1'bZ;

endmodule
// --================================== End ==================================--
