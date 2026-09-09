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
// File Name              : Mmci.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is the top level of the MMCI.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module Mmci (
// Inputs
             PCLK,
             PRESETn,
             PSEL,
             PENABLE,
             PWRITE,
             PADDR,
             PWDATA,
             SCANENABLE,
             SCANINPCLK,
             SCANINMCLK,
             SCANINnMCLK,
             SCANINMMCIFBCLK,
             MMCIDMACLR,
             MCLK,
             nMCLK,
             MMCIFBCLK,
             nMMCIRST,
             MMCICMDIN,
             MMCIDATIN,
// Outputs
             PRDATA,
             SCANOUTPCLK,
             SCANOUTMCLK,
             SCANOUTnMCLK,
             SCANOUTMMCIFBCLK,
             MMCIINTR0,
             MMCIINTR1,
             MMCIDMASREQ,
             MMCIDMABREQ,
             MMCIDMALSREQ,
             MMCIDMALBREQ,
             MMCICLKOUT,
             MMCICMDOUT,
             nMMCICMDEN,
             MMCIDATOUT,
             nMMCIDATEN,
             MMCIPWR,
             MMCIROD,
             MMCIVDD
            );

// Inputs
input         PCLK;             // APB Bus Clock
input         PRESETn;          // APB Bus Reset
input         PSEL;             // APB Peripheral select
input         PENABLE;          // APB Peripheral enable
input         PWRITE;           // APB Peripheral write
input  [11:2] PADDR;            // APB address bus
input  [31:0] PWDATA;           // APB write data bus
input         SCANENABLE;       // Scan Enable
input         SCANINPCLK;       // Scan Input signal in PCLK domain
input         SCANINMCLK;       // Scan Input signal in MCLK domain
input         SCANINnMCLK;      // Scan Input signal in nMCLK domain
input         SCANINMMCIFBCLK;  // Scan Input signal in MMCIFBCLK domain
input         MMCIDMACLR;       // DMA request clear
input         MCLK;             // MMCI adapter clock
input         nMCLK;            // Inverted MCLK
input         MMCIFBCLK;        // MMCI fed back clock
input         nMMCIRST;         // MMCI Reset
input         MMCICMDIN;        // MMCI command input
input         MMCIDATIN;        // MMCI data input

// Outputs
output [31:0] PRDATA;           // Read data bus
output        SCANOUTPCLK;      // SCANOUT port in PCLK domain
output        SCANOUTMCLK;      // SCANOUT port in MCLK domain
output        SCANOUTnMCLK;     // SCANOUT port in nMCLK domain
output        SCANOUTMMCIFBCLK; // Scan out port in the MMCIFBCLK domain
output        MMCIINTR0;        // Interrupt request 0
output        MMCIINTR1;        // Interrupt request 1
output        MMCIDMASREQ;      // DMA single word request
output        MMCIDMABREQ;      // DMA burst request
output        MMCIDMALSREQ;     // DMA last word request
output        MMCIDMALBREQ;     // DMA last burst request
output        MMCICLKOUT;       // MMCI clock output
output        MMCICMDOUT;       // MMCI command output
output        nMMCICMDEN;       // MMCI command output enable
output        MMCIDATOUT;       // MMCI data output
output        nMMCIDATEN;       // MMCI data output enable for line 0
output        MMCIPWR;          // Power supply enable
output        MMCIROD;          // Open-drain resistor enable
output  [3:0] MMCIVDD;          // Power supply output voltage

// Inputs
wire          PCLK;             // APB Bus Clock
wire          PRESETn;          // APB Bus Reset
wire          PSEL;             // APB Peripheral select
wire          PENABLE;          // APB Peripheral enable
wire          PWRITE;           // APB Peripheral write
wire   [11:2] PADDR;            // APB address bus
wire   [31:0] PWDATA;           // APB write data bus
wire          SCANENABLE;       // Scan Enable
wire          SCANINPCLK;       // Scan Input signal in PCLK domain
wire          SCANINMCLK;       // Scan Input signal in MCLK domain
wire          SCANINnMCLK;      // Scan Input signal in nMCLK domain
wire          SCANINMMCIFBCLK;  // Scan Input signal in MMCIFBCLK domain
wire          MMCIDMACLR;       // DMA request clear
wire          MCLK;             // MMCI adapter clock
wire          nMCLK;            // Inverted MCLK
wire          MMCIFBCLK;        // MMCI fed back clock
wire          nMMCIRST;         // MMCI Reset
wire          MMCICMDIN;        // MMCI command input
wire          MMCIDATIN;        // MMCI data input

// Outputs
wire   [31:0] PRDATA;           // Read data bus
wire          SCANOUTPCLK;      // SCANOUT port in PCLK domain
wire          SCANOUTMCLK;      // SCANOUT port in MCLK domain
wire          SCANOUTnMCLK;     // SCANOUT port in nMCLK domain
wire          SCANOUTMMCIFBCLK; // Scan out port in the MMCIFBCLK domain
wire          MMCIINTR0;        // Interrupt request 0
wire          MMCIINTR1;        // Interrupt request 1
wire          MMCIDMASREQ;      // DMA single word request
wire          MMCIDMABREQ;      // DMA burst request
wire          MMCIDMALSREQ;     // DMA last word request
wire          MMCIDMALBREQ;     // DMA last burst request
wire          MMCICLKOUT;       // MMCI clock output
wire          MMCICMDOUT;       // MMCI command output
wire          nMMCICMDEN;       // MMCI command output enable
wire          MMCIDATOUT;       // MMCI data output
wire          nMMCIDATEN;       // MMCI data output enable for line 0
wire          MMCIPWR;          // Power supply enable
wire          MMCIROD;          // Open-drain resistor enable
wire    [3:0] MMCIVDD;          // Power supply output voltage


// -----------------------------------------------------------------------------
//
//                                 Mmci
//                                 ====
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the MMCI. This block instantiates
// the following sub-blocks in the MMCI.
// Mmci
//  - MmciPackage
//  - MmciApbifReg
//  - MmciSynctoMCLK
//  - MmciSynctoPCLK
//  - MmciRegUpd
//  - MmciPwrClkCtr
//  - MmciCPSM
//  - MmciDPSM
//  - MmciFifoDmaCtr
//  - MmciFIFOReg
//  - MmciIntGen
//  - MmciOPReSync
//  - MmciClockAnd
//  - MmciClockMux
//  - MmciRevAnd
//
//   The clock gating and muxing is being done in a separate modules
// (MmciClockAnd, MmciClockMux) so that it is easily identifiable in
// layout. The module MmciRevAnd used as a place-holder cell to mark the
// Revision of the MMCI. It contains a 2 input AND gate. The 2 input
// pins are tied-off at the top level of the hierarchy. These "TieOffs"
// can be identified during layout and re-wired to "VDD" or "VSS"
// if needed.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire  [7:0] MMCIPower;
// Power Ctrl Register

wire [10:0] MMCIClock;
// Clock Ctrl Register

wire [31:0] MMCIArgument;
// Argument Register

wire [10:0] MMCICommand;
// CPSM CtrlRegister

wire  [5:0] MMCIRespCmd;
// Cmd Resp Register

wire [31:0] MMCIResponse0;
// Response0 Register

wire [31:0] MMCIResponse1;
// Response1 Register

wire [31:0] MMCIResponse2;
// Response2 Register

wire [30:0] MMCIResponse3;
// Response3 Register

wire [31:0] MMCIDataTimer;
// Data Timer Register

wire [15:0] MMCIDataLength;
// Data Length Register

wire  [7:0] MMCIDataCtrl;
// DPSM Ctrl Register

wire [15:0] MMCIDataCnt;
// Data counter to the read mux

wire [15:0] DataCnt;
// Data counter

wire [21:0] MMCIMask0;
// INTR0 Mask Register

wire [21:0] MMCIMask1;
// INTR1 Mask Register

wire [31:0] FRdDataCo;
// FIFO Rd Data

wire        ITEN;
// Integration Test enable bit

wire        nTstMMCICMDEN;
// Integration Test command enable bit

wire        nTstMMCIDATEN;
// Integration Test data enable bit

wire  [1:0] FIFOTEST;
// FIFO write/read control bits

wire        RxFRdPtrInc;
// Receive FIFO Read

wire        MMCITxFIFOWr;
// Write enable for Data FIFO

wire [31:0] PWDataIn;
// Gated PWDATA

wire        PowerUpd;
// Update trigger for 2nd stage buffer

wire        ClockUpd;
// Update trigger for 2nd stage buffer

wire        CmdUpd;
// Update trigger for 2nd stage buffer

wire        DCtrUpd;
// Update trigger for 2nd stage buffer

wire        CMDEnUpd;
// CPSM Update trigger

wire        DATEnUpd;
// DPSM Update trigger

wire        RxOverrunClr;
// RxOverrun flag clear

wire        CCrcFClr;
// CmdCrcFail flag clear

wire        CToutClr;
// DataCrcFail flag clear

wire        CRspEClr;
// CmdTimeOut flag clear

wire        CSentClr;
// DataTimeOut flag clear

wire        DCrcFClr;
// DataCrcFail flag clear

wire        DToutClr;
// DataTimeOut flag clear

wire        TxUndClr;
// TxUnderrun flag clear

wire        DEndClr;
// DataEnd flag clear

wire        DBEndClr;
// DataBlockEnd flag clear

wire        MMCIITIP;
// Integration test input register

wire [11:0] MMCIITOP;
// Integration test output register

wire        PowerUpdSync;
// Update trigger for 2nd stage buffer

wire        ClockUpdSync;
// Update trigger for 2nd stage buffer

wire        CmdUpdSync;
// Update trigger for 2nd stage buffer

wire        DCtrUpdSync;
// Update trigger for 2nd stage buffer

wire        Opendrain;
// MMCICMD output control

wire  [7:0] ClkDiv;
// MCLK divider value

wire        ClkEn;
// MMCICLK enable

wire        PwrSave;
// Power save mode enable

wire        Bypass;
// ByPass mode enable

wire  [5:0] CmdIndex;
// Command index value

wire        Response;
// Respose enable

wire        LongRsp;
// Long response

wire        Interrupt;
// Interrupt mode enable

wire        Pending;
// Command Pend enable

wire        CPSMEn;
// CPSM enable

wire        DPSMEn;
// DPSM enable

wire        Direction;
// Transmit/receive

wire        Mode;
// Block/stream

wire  [3:0] BlockSize;
// Dat Block size

wire        TxDataAvl;
// Transmit Data avilable

wire        RxOverrun;
// FIFO over run during reception

wire        RxFifoEmpty;
// FIFO empty during reception

wire        RxWrDone;
// FIFO write done during reception

wire        CMDEnUpdSync;
// CPSM Update trigger

wire        DATEnUpdSync;
// DPSM Update trigger

wire        CCrcFClrSync;
// CmdCrcFail flag clear

wire        CToutClrSync;
// DataCrcFail flag clear

wire        CRspEClrSync;
// CmdTimeOut flag clear

wire        CSentClrSync;
// DataTimeOut flag clear

wire        DCrcFClrSync;
// DataCrcFail flag clear

wire        DToutClrSync;
// DataTimeOut flag clear

wire        TxUndClrSync;
// TxUnderrun flag clear

wire        DEndClrSync;
// DataEnd flag clear

wire        DBEndClrSync;
// DataBlockEnd flag clear

wire        TxDataAvlSync;
// Transmit Data avilable

wire        RxOverrunSync;
// FIFO over run during reception

wire        RxFifoEmptySync;
// FIFO empty during reception

wire        RxWrDoneSync;
// FIFO write done during reception

wire        CCrcF;
// CmdCrcFail flag

wire        CTout;
// DataCrcFail flag

wire        CRspE;
// CmdTimeOut flag

wire        CSent;
// DataTimeOut flag

wire        DCrcF;
// DataCrcFail flag

wire        DTout;
// DataTimeOut flag

wire        TxUnd;
// TxUnderrun flag

wire        DEnd;
// DataEnd flag

wire        DBEnd;
// DataBlockEnd flag

wire        TxActClr;
// TxActive clear

wire        CmdActClr;
// CmdActive clear

wire        TxRdPtrInc;
// FIFO read pointer increment during transmission

wire        RxWrEn;
// FIFO write enable during the reception

wire        CCrcFSync;
// CmdCrcFail flag

wire        CToutSync;
// DataCrcFail flag

wire        CRspESync;
// CmdTimeOut flag

wire        CSentSync;
// DataTimeOut flag

wire        DCrcFSync;
// DataCrcFail flag

wire        DToutSync;
// DataTimeOut flag

wire        TxUndSync;
// TxUnderrun flag

wire        DEndSync;
// DataEnd flag

wire        DBEndSync;
// DataBlockEnd flag

wire        TxActClrSync;
// TxActive clear

wire        CmdActClrSync;
// CmdActive clear

wire        PowerUpdDone;
// Write finished in 2nd stage buffer in MCLK domain (Power)

wire        ClockUpdDone;
// Write finished in 2nd stage buffer in MCLK domain (Clock)

wire        CmdUpdDone;
// Write finished in 2nd stage buffer in MCLK domain (Cmd)

wire        DCtrUpdDone;
// Write finished in 2nd stage buffer in MCLK domain (DCtr)

wire        PowerUpdDoneSync;
// PCLK sync'ed version of PowerUpdDone

wire        ClockUpdDoneSync;
// PCLK sync'ed version of ClockUpdDone

wire        CmdUpdDoneSync;
// PCLK sync'ed version of CmdUpdDone

wire        DCtrUpdDoneSync;
// PCLK sync'ed version of DCtrUpdDone

wire        TxRdPtrIncSync;
// FIFO read pointer increment during transmission

wire        RxWrEnSync;
// FIFO write enable during the reception

wire        MMCICLK;
// MMC card clock for internal use

wire        DIVlevelCo;
// MCLK divder pulse

wire        PowerUpCo;
// Indicates MMCI in Power up state

wire        PowerOn;
// Indicates MMCI in Power on state

wire        CmdPSave;
// Power save input from CPSM

wire        DataPSave;
// Power save input from DPSM

wire        CMDIN;
// Command input

wire        PendPulse;
// trigger pulse for pend mode Outputs

wire        CMDOUTCo;
// Command output

wire        nCMDENCo;
// Command path enable

wire        TxActive;
// Data transmit in progress

wire        RxActive;
// Data receive in progress

wire        CmdActive;
// Command transfer in progress

wire        TxFifoHfEmptyCo;
// Transmit FIFO is half empty

wire        RxFifoHfFullCo;
// Receive FIFO is half full

wire        TxFifoFullCo;
// Transmit FIFO is full

wire        RxFifoFullCo;
// Receive FIFO is full

wire        TxFifoEmptyCo;
// Transmit FIFO is empty

wire        RxDataAvlCo;
// Receive FIFO data available

wire        INTR0;
// Interrupt zero from IntGen module (before Integration muxing)

wire        IntMMCIINTR0;
// Internal version of MMCIINTRO

wire        INTR1;
// Interrupt one from IntGen module (before Integration muxing)

wire        IntMMCIINTR1;
// Internal version of MMCIINTR1

wire        DMASREQ;
// DMASREQ from DMA block (before Integration muxing)

wire        IntMMCIDMASREQ;
// Internal version of MMCIDMASREQ

wire        DMABREQ;
// DMABREQ from DMA block (before Integration muxing)

wire        IntMMCIDMABREQ;
// Internal version of MMCIDMABREQ

wire        DMALSREQ;
// DMALSREQ from DMA block (before Integration muxing)

wire        IntMMCIDMALSREQ;
// Internal version of MMCIDMALSREQ

wire        DMALBREQ;
// DMALBREQ from DMA block (before Integration muxing)

wire        IntMMCIDMALBREQ;
// Internal version of MMCIDMALBREQ

wire        IntMMCIPWR;
// Internal version of MMCIPWR

wire        DMACLR;
// DMACLR signal to DMA block (after Integration muxing)

wire        nDATEN;
// DPSM output version of nMMCIDATEN (before MMCIFBCLK synchronisation)

wire        DATOUT;
// DPSM output version of MMCIDATOUT (before MMCIFBCLK synchronisation)

wire        DATIN;
// MMCIFBCLK synchronised version of MMCIDATIN

wire        DMAEnable;
// DMA requests enable bit

wire        RxActiveSync;
// Synchronised version of RxActive

wire        PowerDown;
// Set to high when both CPSM and DPSM are in Power down mode

wire [31:0] RxFWrData;
// Data read by the state machine during receive phase

wire        FWrEnCo;
// FIFO Write enable

wire [31:0] FWrDataCo;
// Data written into the FIFO

wire  [3:0] RdPtr;
// FIFO Read pointer

wire  [3:0] WrPtr;
// FIFO Write pointer

wire  [2:0] MPowerCtrl;
// OpenDrain/Ctrl bits of power control register

wire [14:0] MMCIFifoCnt;
// FIFO counter

wire [6:0] MMCIDCtrl;
// Data control register bits to the MCLK domain

wire [10:0] Clock;
// 2nd stage buffer for MMCIClock register in the MCLK domain

wire [10:0] Cmd;
// 2nd stage buffer for MMCICommand register in the MCLK domain

wire  [6:0] DCtr;
// 2nd stage buffer for MMCIDataCtrl register in the MCLK domain

wire        NegPowerDown;
// InvertPowerDown bit synchronised to the negative edge of MCLK

wire        NegBypass;
// nMCLK synchronised version of Bypass

wire        GatedMCLK;
// MCLK gated with NegBypass

wire  [3:0] TieOff1;
// Static input to the block MmciRevAnd

wire  [3:0] TieOff2;
// Static input to the block MmciRevAnd

wire  [3:0] Revision;
// Output from MmciRevAnd block (Used for register read in ApbifReg)

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
// Connect the internal copy to output
// -----------------------------------------------------------------------------
assign MMCIDMALBREQ      = IntMMCIDMALBREQ;
assign MMCIDMALSREQ      = IntMMCIDMALSREQ;
assign MMCIDMABREQ       = IntMMCIDMABREQ;
assign MMCIDMASREQ       = IntMMCIDMASREQ;
assign MMCIINTR1         = IntMMCIINTR1;
assign MMCIINTR0         = IntMMCIINTR0;

// -----------------------------------------------------------------------------
// Separate the bit fields in the MMCIPower register and assign them to
// the respective outputs
// -----------------------------------------------------------------------------
assign MMCIVDD           = MMCIPower[5:2];
assign MPowerCtrl        = {MMCIPower[6], MMCIPower[1:0]};
assign MMCIROD           = MMCIPower[7];

// -----------------------------------------------------------------------------
// Separate the bit fields in the data control register
// -----------------------------------------------------------------------------
assign MMCIDCtrl         = {MMCIDataCtrl[7:4], MMCIDataCtrl[2:0]};
assign DMAEnable         = MMCIDataCtrl[3];

// -----------------------------------------------------------------------------
// Rename the data counter (which is going to the read mux)
// -----------------------------------------------------------------------------
assign MMCIDataCnt       = DataCnt;

// -----------------------------------------------------------------------------
// Separate the bit fields in the Clock register (MCLK domain buffer of
// MMCIClock register) and assign them to the respective outputs
// -----------------------------------------------------------------------------
assign ClkDiv           = Clock[7:0];
assign ClkEn            = Clock[8];
assign PwrSave          = Clock[9];
assign Bypass           = Clock[10];

// -----------------------------------------------------------------------------
// Separate the bit fields in the Cmd register (MCLK domain buffer of
// MMCICommand register) and assign them to the respective outputs
// -----------------------------------------------------------------------------
assign CmdIndex         = Cmd[5:0];
assign Response         = Cmd[6];
assign LongRsp          = Cmd[7];
assign Interrupt        = Cmd[8];
assign Pending          = Cmd[9];
assign CPSMEn           = Cmd[10];

// -----------------------------------------------------------------------------
// Separate the bit fields in the DCtr register (MCLK domain buffer of
// MMCIDataCtrl register) and assign them to the respective outputs
// -----------------------------------------------------------------------------
assign DPSMEn           = DCtr[0];
assign Direction        = DCtr[1];
assign Mode             = DCtr[2];
assign BlockSize        = DCtr[6:3];

// -----------------------------------------------------------------------------
// Assign the Revision number
// -----------------------------------------------------------------------------
assign TieOff1          = 4'b0000;
assign TieOff2          = 4'b0000;

// -----------------------------------------------------------------------------
// Instantiation of MmciApbifReg
// -----------------------------------------------------------------------------
MmciApbifReg uMmciApbifReg            (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSEL),
                    .PWRITE           (PWRITE),
                    .PENABLE          (PENABLE),
                    .PWDATA           (PWDATA),
                    .PADDR            (PADDR),
                    .MMCIRespCmd      (MMCIRespCmd),
                    .MMCIResponse0    (MMCIResponse0),
                    .MMCIResponse1    (MMCIResponse1),
                    .MMCIResponse2    (MMCIResponse2),
                    .MMCIResponse3    (MMCIResponse3),
                    .MMCIDataCnt      (MMCIDataCnt),
                    .MMCIFifoCnt      (MMCIFifoCnt),
                    .FRdDataCo        (FRdDataCo),
                    .MMCICMDIN        (MMCICMDIN),
                    .MMCIDATIN        (MMCIDATIN),
                    .DMACLR           (DMACLR),
                    .IntMMCIDMALBREQ  (IntMMCIDMALBREQ),
                    .IntMMCIDMALSREQ  (IntMMCIDMALSREQ),
                    .IntMMCIDMABREQ   (IntMMCIDMABREQ),
                    .IntMMCIDMASREQ   (IntMMCIDMASREQ),
                    .IntMMCIINTR1     (IntMMCIINTR1),
                    .IntMMCIINTR0     (IntMMCIINTR0),
                    .RxActiveSync     (RxActiveSync),
                    .CCrcFSync        (CCrcFSync),
                    .CToutSync        (CToutSync),
                    .CRspESync        (CRspESync),
                    .CSentSync        (CSentSync),
                    .DCrcFSync        (DCrcFSync),
                    .DToutSync        (DToutSync),
                    .TxUndSync        (TxUndSync),
                    .DEndSync         (DEndSync),
                    .DBEndSync        (DBEndSync),
                    .RxOverrun        (RxOverrun),
                    .TxFifoHfEmptyCo  (TxFifoHfEmptyCo),
                    .RxFifoHfFullCo   (RxFifoHfFullCo),
                    .TxFifoFullCo     (TxFifoFullCo),
                    .RxFifoFullCo     (RxFifoFullCo),
                    .TxFifoEmptyCo    (TxFifoEmptyCo),
                    .RxFifoEmpty      (RxFifoEmpty),
                    .TxDataAvl        (TxDataAvl),
                    .RxDataAvlCo      (RxDataAvlCo),
                    .TxActClrSync     (TxActClrSync),
                    .CmdActClrSync    (CmdActClrSync),
                    .PowerUpdDoneSync (PowerUpdDoneSync),
                    .ClockUpdDoneSync (ClockUpdDoneSync),
                    .CmdUpdDoneSync   (CmdUpdDoneSync),
                    .DCtrUpdDoneSync  (DCtrUpdDoneSync),
                    .Revision         (Revision),
                    .RxFRdPtrInc      (RxFRdPtrInc),
                    .CMDEnUpd         (CMDEnUpd),
                    .DATEnUpd         (DATEnUpd),
                    .CmdActive        (CmdActive),
                    .TxActive         (TxActive),
                    .RxOverrunClr     (RxOverrunClr),
                    .CCrcFClr         (CCrcFClr),
                    .CToutClr         (CToutClr),
                    .CRspEClr         (CRspEClr),
                    .CSentClr         (CSentClr),
                    .DCrcFClr         (DCrcFClr),
                    .DToutClr         (DToutClr),
                    .TxUndClr         (TxUndClr),
                    .DEndClr          (DEndClr),
                    .DBEndClr         (DBEndClr),
                    .MMCIPower        (MMCIPower),
                    .MMCIClock        (MMCIClock),
                    .MMCIArgument     (MMCIArgument),
                    .MMCICommand      (MMCICommand),
                    .MMCIDataTimer    (MMCIDataTimer),
                    .MMCIDataLength   (MMCIDataLength),
                    .MMCIDataCtrl     (MMCIDataCtrl),
                    .MMCIMask0        (MMCIMask0),
                    .MMCIMask1        (MMCIMask1),
                    .MMCIITIP         (MMCIITIP),
                    .MMCIITOP         (MMCIITOP),
                    .PowerUpd         (PowerUpd),
                    .ClockUpd         (ClockUpd),
                    .CmdUpd           (CmdUpd),
                    .DCtrUpd          (DCtrUpd),
                    .MMCITxFIFOWr     (MMCITxFIFOWr),
                    .ITEN             (ITEN),
                    .nTstMMCICMDEN    (nTstMMCICMDEN),
                    .nTstMMCIDATEN    (nTstMMCIDATEN),  
                    .FIFOTEST         (FIFOTEST),
                    .PRDATA           (PRDATA),
                    .PWDataIn         (PWDataIn)
                   );

// -----------------------------------------------------------------------------
// Instantiation of MmciRegUpd
// -----------------------------------------------------------------------------
MmciRegUpd uMmciRegUpd                (
                    .MCLK             (MCLK),
                    .nMMCIRST         (nMMCIRST),
                    .PowerUpdSync     (PowerUpdSync),
                    .ClockUpdSync     (ClockUpdSync),
                    .CmdUpdSync       (CmdUpdSync),
                    .DCtrUpdSync      (DCtrUpdSync),
                    .MPowerCtrl       (MPowerCtrl),
                    .MMCIClock        (MMCIClock),
                    .MMCICommand      (MMCICommand),
                    .MMCIDCtrl        (MMCIDCtrl),
                    .PowerOn          (PowerOn),
                    .PowerUpCo        (PowerUpCo),
                    .Opendrain        (Opendrain),
                    .PowerUpdDone     (PowerUpdDone),
                    .ClockUpdDone     (ClockUpdDone),
                    .CmdUpdDone       (CmdUpdDone),
                    .DCtrUpdDone      (DCtrUpdDone),
                    .Clock            (Clock),
                    .Cmd              (Cmd),
                    .DCtr             (DCtr)
                   );

// -----------------------------------------------------------------------------
// Instantiation of MmciSynctoMCLK
// -----------------------------------------------------------------------------
MmciSynctoMCLK uMmciSynctoMCLK        (
                    .MCLK             (MCLK),
                    .nMMCIRST         (nMMCIRST),
                    .CMDEnUpd         (CMDEnUpd),
                    .DATEnUpd         (DATEnUpd),
                    .PowerUpd         (PowerUpd),
                    .ClockUpd         (ClockUpd),
                    .CmdUpd           (CmdUpd),
                    .DCtrUpd          (DCtrUpd),
                    .CCrcFClr         (CCrcFClr),
                    .CToutClr         (CToutClr),
                    .CRspEClr         (CRspEClr),
                    .CSentClr         (CSentClr),
                    .DCrcFClr         (DCrcFClr),
                    .DToutClr         (DToutClr),
                    .TxUndClr         (TxUndClr),
                    .DEndClr          (DEndClr),
                    .DBEndClr         (DBEndClr),
                    .TxDataAvl        (TxDataAvl),
                    .RxOverrun        (RxOverrun),
                    .RxFifoEmpty      (RxFifoEmpty),
                    .RxWrDone         (RxWrDone),
                    .CMDEnUpdSync     (CMDEnUpdSync),
                    .DATEnUpdSync     (DATEnUpdSync),
                    .PowerUpdSync     (PowerUpdSync),
                    .ClockUpdSync     (ClockUpdSync),
                    .CmdUpdSync       (CmdUpdSync),
                    .DCtrUpdSync      (DCtrUpdSync),
                    .CCrcFClrSync     (CCrcFClrSync),
                    .CToutClrSync     (CToutClrSync),
                    .CRspEClrSync     (CRspEClrSync),
                    .CSentClrSync     (CSentClrSync),
                    .DCrcFClrSync     (DCrcFClrSync),
                    .DToutClrSync     (DToutClrSync),
                    .TxUndClrSync     (TxUndClrSync),
                    .DEndClrSync      (DEndClrSync),
                    .DBEndClrSync     (DBEndClrSync),
                    .TxDataAvlSync    (TxDataAvlSync),
                    .RxOverrunSync    (RxOverrunSync),
                    .RxFifoEmptySync  (RxFifoEmptySync),
                    .RxWrDoneSync     (RxWrDoneSync)
                   );

// -----------------------------------------------------------------------------
// Instantiation of MmciSynctoPCLK
// -----------------------------------------------------------------------------
MmciSynctoPCLK uMmciSynctoPCLK        (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .CCrcF            (CCrcF),
                    .CTout            (CTout),
                    .CRspE            (CRspE),
                    .CSent            (CSent),
                    .DCrcF            (DCrcF),
                    .DTout            (DTout),
                    .TxUnd            (TxUnd),
                    .DEnd             (DEnd),
                    .DBEnd            (DBEnd),
                    .TxActClr         (TxActClr),
                    .CmdActClr        (CmdActClr),
                    .TxRdPtrInc       (TxRdPtrInc),
                    .RxWrEn           (RxWrEn),
                    .RxActive         (RxActive),
                    .PowerUpdDone     (PowerUpdDone),
                    .ClockUpdDone     (ClockUpdDone),
                    .CmdUpdDone       (CmdUpdDone),
                    .DCtrUpdDone      (DCtrUpdDone),
                    .CCrcFSync        (CCrcFSync),
                    .CToutSync        (CToutSync),
                    .CRspESync        (CRspESync),
                    .CSentSync        (CSentSync),
                    .DCrcFSync        (DCrcFSync),
                    .DToutSync        (DToutSync),
                    .TxUndSync        (TxUndSync),
                    .DEndSync         (DEndSync),
                    .DBEndSync        (DBEndSync),
                    .TxActClrSync     (TxActClrSync),
                    .CmdActClrSync    (CmdActClrSync),
                    .TxRdPtrIncSync   (TxRdPtrIncSync),
                    .RxWrEnSync       (RxWrEnSync),
                    .RxActiveSync     (RxActiveSync),
                    .PowerUpdDoneSync (PowerUpdDoneSync),
                    .ClockUpdDoneSync (ClockUpdDoneSync),
                    .CmdUpdDoneSync   (CmdUpdDoneSync),
                    .DCtrUpdDoneSync  (DCtrUpdDoneSync)
                   );

// -----------------------------------------------------------------------------
// Instantiation of MmciPwrClkCtr
// -----------------------------------------------------------------------------
MmciPwrClkCtr uMmciPwrClkCtr          (
                    .MCLK             (MCLK),
                    .nMMCIRST         (nMMCIRST),
                    .PowerOn          (PowerOn),
                    .PowerUpCo        (PowerUpCo),
                    .ClkDiv           (ClkDiv),
                    .ClkEn            (ClkEn),
                    .PwrSave          (PwrSave),
                    .Bypass           (Bypass),
                    .CmdPSave         (CmdPSave),
                    .DataPSave        (DataPSave),
                    .MMCICLK          (MMCICLK),
                    .DIVlevelCo       (DIVlevelCo),
                    .IntMMCIPWR       (IntMMCIPWR),
                    .PowerDown        (PowerDown)
                   );

// -----------------------------------------------------------------------------
// Instantiation of MmciCPSM
// -----------------------------------------------------------------------------
MmciCPSM uMmciCPSM                    (
                    .MCLK             (MCLK),
                    .nMMCIRST         (nMMCIRST),
                    .CCrcFClrSync     (CCrcFClrSync),
                    .CToutClrSync     (CToutClrSync),
                    .CRspEClrSync     (CRspEClrSync),
                    .CSentClrSync     (CSentClrSync),
                    .CMDEnUpdSync     (CMDEnUpdSync),
                    .CmdIndex         (CmdIndex),
                    .Response         (Response),
                    .LongRsp          (LongRsp),
                    .Interrupt        (Interrupt),
                    .Pending          (Pending),
                    .MMCIArgument     (MMCIArgument),
                    .DIVlevelCo       (DIVlevelCo),
                    .Opendrain        (Opendrain),
                    .CMDIN            (CMDIN),
                    .CPSMEn           (CPSMEn),
                    .PendPulse        (PendPulse),
                    .MMCIRespCmd      (MMCIRespCmd),
                    .MMCIResponse0    (MMCIResponse0),
                    .MMCIResponse1    (MMCIResponse1),
                    .MMCIResponse2    (MMCIResponse2),
                    .MMCIResponse3    (MMCIResponse3),
                    .CmdPSave         (CmdPSave),
                    .CMDOUTCo         (CMDOUTCo),
                    .nCMDENCo         (nCMDENCo),
                    .CCrcF            (CCrcF),
                    .CTout            (CTout),
                    .CRspE            (CRspE),
                    .CSent            (CSent),
                    .CmdActClr        (CmdActClr)
                   );

// -----------------------------------------------------------------------------
// Instantiation of MmciDPSM
// -----------------------------------------------------------------------------
MmciDPSM uMmciDPSM                    (
                    .MCLK             (MCLK),
                    .nMMCIRST         (nMMCIRST),
                    .DCrcFClrSync     (DCrcFClrSync),
                    .DToutClrSync     (DToutClrSync),
                    .TxUndClrSync     (TxUndClrSync),
                    .DEndClrSync      (DEndClrSync),
                    .DBEndClrSync     (DBEndClrSync),
                    .DATEnUpdSync     (DATEnUpdSync),
                    .DIVlevelCo       (DIVlevelCo),
                    .DATIN            (DATIN),
                    .DPSMEn           (DPSMEn),
                    .RxWrDoneSync     (RxWrDoneSync),
                    .RxFifoEmptySync  (RxFifoEmptySync),
                    .RxOverrunSync    (RxOverrunSync),
                    .TxDataAvlSync    (TxDataAvlSync),
                    .FRdDataCo        (FRdDataCo),
                    .MMCIDataTimer    (MMCIDataTimer),
                    .MMCIDataLength   (MMCIDataLength),
                    .Direction        (Direction),
                    .Mode             (Mode),
                    .BlockSize        (BlockSize),
                    .PendPulse        (PendPulse),
                    .DataPSave        (DataPSave),
                    .DCrcF            (DCrcF),
                    .DTout            (DTout),
                    .TxUnd            (TxUnd),
                    .DEnd             (DEnd),
                    .DBEnd            (DBEnd),
                    .TxActClr         (TxActClr),
                    .RxActive         (RxActive),
                    .TxRdPtrInc       (TxRdPtrInc),
                    .DataCnt          (DataCnt),
                    .RxWrEn           (RxWrEn),
                    .DATOUT           (DATOUT),
                    .nDATEN           (nDATEN),
                    .RxFWrData        (RxFWrData)
                   );

// -----------------------------------------------------------------------------
// Instantiation of MmciFifoDmaCtr
// -----------------------------------------------------------------------------
MmciFifoDmaCtr uMmciFifoDmaCtr        (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .TxActive         (TxActive),
                    .RxActiveSync     (RxActiveSync),
                    .DMACLR           (DMACLR),
                    .RxFWrData        (RxFWrData),
                    .PWDataIn         (PWDataIn),
                    .RxFRdPtrInc      (RxFRdPtrInc),
                    .MMCITxFIFOWr     (MMCITxFIFOWr),
                    .TxRdPtrIncSync   (TxRdPtrIncSync),
                    .RxWrEnSync       (RxWrEnSync),
                    .RxOverrunClr     (RxOverrunClr),
                    .DATEnUpd         (DATEnUpd),
                    .DMAEnable        (DMAEnable),
                    .MMCIDataLength   (MMCIDataLength),
                    .FIFOTEST         (FIFOTEST),
                    .TxFifoHfEmptyCo  (TxFifoHfEmptyCo),
                    .RxFifoHfFullCo   (RxFifoHfFullCo),
                    .TxFifoFullCo     (TxFifoFullCo),
                    .RxFifoFullCo     (RxFifoFullCo),
                    .TxFifoEmptyCo    (TxFifoEmptyCo),
                    .RxFifoEmpty      (RxFifoEmpty),
                    .TxDataAvl        (TxDataAvl),
                    .RxDataAvlCo      (RxDataAvlCo),
                    .RxOverrun        (RxOverrun),
                    .DMASREQ          (DMASREQ),
                    .DMABREQ          (DMABREQ),
                    .DMALSREQ         (DMALSREQ),
                    .DMALBREQ         (DMALBREQ),
                    .RxWrDone         (RxWrDone),
                    .FWrEnCo          (FWrEnCo),
                    .FWrDataCo        (FWrDataCo),
                    .MMCIFifoCnt      (MMCIFifoCnt),
                    .RdPtr            (RdPtr),
                    .WrPtr            (WrPtr)
                   );

// -----------------------------------------------------------------------------
// Instantiation of MmciFIFOReg
// -----------------------------------------------------------------------------
MmciFIFOReg uMmciFIFOReg              (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .FWrEnCo          (FWrEnCo),
                    .WrPtr            (WrPtr),
                    .RdPtr            (RdPtr),
                    .FWrDataCo        (FWrDataCo),
                    .FRdDataCo        (FRdDataCo)
                   );

// -----------------------------------------------------------------------------
// Instantiation of MmciIntGen
// -----------------------------------------------------------------------------
MmciIntGen uMmciIntGen                (
                    .CCrcF            (CCrcF),
                    .CTout            (CTout),
                    .CRspE            (CRspE),
                    .CSent            (CSent),
                    .DCrcF            (DCrcF),
                    .DTout            (DTout),
                    .TxUnd            (TxUnd),
                    .DEnd             (DEnd),
                    .DBEnd            (DBEnd),
                    .RxOverrun        (RxOverrun),
                    .TxActive         (TxActive),
                    .RxActive         (RxActive),
                    .CmdActive        (CmdActive),
                    .TxFifoHfEmptyCo  (TxFifoHfEmptyCo),
                    .RxFifoHfFullCo   (RxFifoHfFullCo),
                    .TxFifoFullCo     (TxFifoFullCo),
                    .RxFifoFullCo     (RxFifoFullCo),
                    .TxFifoEmptyCo    (TxFifoEmptyCo),
                    .RxFifoEmpty      (RxFifoEmpty),
                    .TxDataAvl        (TxDataAvl),
                    .RxDataAvlCo      (RxDataAvlCo),
                    .MMCIMask0        (MMCIMask0),
                    .MMCIMask1        (MMCIMask1),
                    .INTR0            (INTR0),
                    .INTR1            (INTR1)
                   );

// -----------------------------------------------------------------------------
// Instantiation of MmciOPReSync
// -----------------------------------------------------------------------------
MmciOPReSync uMmciOPReSync            (
                    .MMCIFBCLK        (MMCIFBCLK),
                    .nMCLK            (nMCLK),
                    .nMMCIRST         (nMMCIRST),
                    .Bypass           (Bypass),
                    .MMCICMDIN        (MMCICMDIN),
                    .MMCIDATIN        (MMCIDATIN),
                    .CMDOUTCo         (CMDOUTCo),
                    .DATOUT           (DATOUT),
                    .nCMDENCo         (nCMDENCo),
                    .nDATEN           (nDATEN),
                    .PowerDown        (PowerDown),
                    .ITEN             (ITEN),
                    .nTstMMCICMDEN    (nTstMMCICMDEN),
                    .nTstMMCIDATEN    (nTstMMCIDATEN),
                    .MMCIITIP         (MMCIITIP),
                    .MMCIITOP         (MMCIITOP),
                    .MMCIDMACLR       (MMCIDMACLR),
                    .INTR0            (INTR0),
                    .INTR1            (INTR1),
                    .DMASREQ          (DMASREQ),
                    .DMABREQ          (DMABREQ),
                    .DMALSREQ         (DMALSREQ),
                    .DMALBREQ         (DMALBREQ),
                    .IntMMCIPWR       (IntMMCIPWR),
                    .NegPowerDown     (NegPowerDown),
                    .NegBypass        (NegBypass),
                    .DMACLR           (DMACLR),
                    .IntMMCIINTR0     (IntMMCIINTR0),
                    .IntMMCIINTR1     (IntMMCIINTR1),
                    .IntMMCIDMASREQ   (IntMMCIDMASREQ),
                    .IntMMCIDMABREQ   (IntMMCIDMABREQ),
                    .IntMMCIDMALSREQ  (IntMMCIDMALSREQ),
                    .IntMMCIDMALBREQ  (IntMMCIDMALBREQ),
                    .nMMCIDATEN       (nMMCIDATEN),
                    .nMMCICMDEN       (nMMCICMDEN),
                    .MMCIDATOUT       (MMCIDATOUT),
                    .MMCICMDOUT       (MMCICMDOUT),
                    .MMCIPWR          (MMCIPWR),
                    .CMDIN            (CMDIN),
                    .DATIN            (DATIN)
                   );

// -----------------------------------------------------------------------------
// Instantiation of MmciClockAnd
// -----------------------------------------------------------------------------
MmciClockAnd uMmciClockAnd            (
                    .MCLK             (MCLK),
                    .NegPowerDown     (NegPowerDown),
                    .GatedMCLK        (GatedMCLK)
                   );

// -----------------------------------------------------------------------------
// Instantiation of MmciClockMux
// -----------------------------------------------------------------------------
MmciClockMux uMmciClockMux            (
                    .MMCICLK          (MMCICLK),
                    .GatedMCLK        (GatedMCLK),
                    .NegBypass        (NegBypass),
                    .MMCICLKOUT       (MMCICLKOUT)
                   );

// -----------------------------------------------------------------------------
// 1st instantiation of MmciRevAnd
// -----------------------------------------------------------------------------
MmciRevAnd u0MmciRevAnd               (
                    .TieOff1          (TieOff1[0]),
                    .TieOff2          (TieOff2[0]),
                    .Revision         (Revision[0])
                   );

// -----------------------------------------------------------------------------
// 2nd instantiation of MmciRevAnd
// -----------------------------------------------------------------------------
MmciRevAnd u1MmciRevAnd               (
                    .TieOff1          (TieOff1[1]),
                    .TieOff2          (TieOff2[1]),
                    .Revision         (Revision[1])
                   );

// -----------------------------------------------------------------------------
// 3rd instantiation of MmciRevAnd
// -----------------------------------------------------------------------------
MmciRevAnd u2MmciRevAnd               (
                    .TieOff1          (TieOff1[2]),
                    .TieOff2          (TieOff2[2]),
                    .Revision         (Revision[2])
                   );

// -----------------------------------------------------------------------------
// 4th instantiation of MmciRevAnd
// -----------------------------------------------------------------------------
MmciRevAnd u3MmciRevAnd               (
                    .TieOff1          (TieOff1[3]),
                    .TieOff2          (TieOff2[3]),
                    .Revision         (Revision[3])
                   );

endmodule

// --============================== End ======================================--
