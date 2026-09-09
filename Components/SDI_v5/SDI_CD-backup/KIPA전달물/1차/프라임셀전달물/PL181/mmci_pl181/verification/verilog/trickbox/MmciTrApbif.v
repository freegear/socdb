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
// File Name              : MmciTrApbif.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block acts as an interface between the APB Bus and the
//           MMCI Trickbox.Mainly, it interprets the APB Address and
//           issues a write decode to respective register.It also
//           maintains a latched Address/write data till the device is
//           selected again for transfer.It also multiplexes the
//           various register reads onto the APB read data bus.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "MmciTrParams.v"

// -----------------------------------------------------------------------------

module MmciTrApbif (
// Inputs
                   PCLK,
                   PRESETn,
                   PSEL,
                   PSELT,
                   PWRITE,
                   PENABLE,
                   MMCITBSIGSTAT,
                   MMCITBRxdCInd,
                   MMCITBRxdCArg,
                   RFF,
                   TFF,
                   RFE,
                   TFE,
                   TFHE,
                   RFHF,
                   PCLKOn,
                   MCLKOn,
                   RxFRdData,
                   CmdCrcErrStat,
                   PADDR,
                   PWDATA,
// Outputs
                   RxFRdPtrInc,
                   MMCIPowerWr,
                   MMCIClockWr,
                   MMCICommandWr,
                   MMCIDataLenWr,
                   MMCIDataCntlWr,
                   MMCITBCmdRespWr,
                   MMCITBResp0Wr,
                   MMCITBResp1Wr,
                   MMCITBResp2Wr,
                   MMCITBResp3Wr,
                   MMCITBDtTimWr,
                   MMCITBMCLKWr,
                   MMCITBCntlWr,
                   MMCITBReTimWr,
                   MMCITBTokTimWr,
                   MMCITBBsyTimWr,
                   MMCITBPCDisWr,
                   MMCITBStTimWr,
                   MMCITBCLKRSTWr,
                   MMCITBTXFWr,
                   PRDATA,
                   PWDATAIn
                   );

// Inputs
input         PCLK;            // APB Bus Clock
input         PRESETn;         // APB Bus Reset
input         PSEL;            // APB MMCI select
input         PSELT;           // APB Trickbox select
input         PWRITE;          // APB Peripheral Write
input         PENABLE;         // APB Peripheral enable
input   [5:0] MMCITBSIGSTAT;   // Signal Status Reg
input   [5:0] MMCITBRxdCInd;   // Cmd Index recd from MMCI
input  [31:0] MMCITBRxdCArg;   // Cmd Arg recd from MMCI
input         RFF;             // Rx FIFO Full
input         TFF;             // Tx FIFO Full
input         RFE;             // Rx FIFO Empty
input         TFE;             // Tx FIFO Empty
input         TFHE;            // Tx FIFO Half Empty
input         RFHF;            // Rx FIFO Half Full
input         PCLKOn;          // Status flag for PCLK enabled
                               // internally
input         MCLKOn;          // Status flag for MCLK enabled
                               // internally
input  [32:0] RxFRdData;       // RxFIFO read data
input         CmdCrcErrStat;   // Cmd Crc error status
input  [11:2] PADDR;           // APB Addr
input  [31:0] PWDATA;          // Write databus

// Outputs
output        RxFRdPtrInc;     // RxFIFO read ptr Incr
output        MMCIPowerWr;     // Wr enable for MMCIPower
output        MMCIClockWr;     // Wr enable for MMCIClock
output        MMCICommandWr;   // Wr enable for MMCIComand
output        MMCIDataLenWr;   // WrEn for MMCIDatalen
output        MMCIDataCntlWr;  // WrEn for MMCIDataCntl
output        MMCITBCmdRespWr; // WrEn for MMCITBCmdResp
output        MMCITBResp0Wr;   // WrEn for MMCITBResp0
output        MMCITBResp1Wr;   // WrEn for MMCITBResp1
output        MMCITBResp2Wr;   // WrEn for MMCITBResp2
output        MMCITBResp3Wr;   // WrEn for MMCITBResp3
output        MMCITBDtTimWr;   // WrEn for MMCITBDataTimer
output        MMCITBMCLKWr;    // WrEn for MMCITBMCLKPd
output        MMCITBCntlWr;    // WrEn for MMCITBCntl
output        MMCITBReTimWr;   // WrEn for MMCITBRespTimer
output        MMCITBTokTimWr;  // WrEn for MMCITBTkTimer
output        MMCITBBsyTimWr;  // WrEn for MMCITBBusyTimer
output        MMCITBPCDisWr;   // WrEn for MMCITBPCDisable
output        MMCITBStTimWr;   // WrEn for MMCITBStTimeout
output        MMCITBCLKRSTWr;  // WrEn for MMCITBCkRstCntl
output        MMCITBTXFWr;     // WrEn for MMCITBFIFOReg
output [31:0] PRDATA;          // Read Databus
output [31:0] PWDATAIn;        // Int PWDATA

// Inputs
wire        PCLK;            // APB Bus Clock
wire        PRESETn;         // APB Bus Reset
wire        PSEL;            // APB MMCI select
wire        PSELT;           // APB Trickbox select
wire        PWRITE;          // APB Peripheral Write
wire        PENABLE;         // APB Peripheral enable
wire  [5:0] MMCITBSIGSTAT;   // Signal Status Reg
wire  [5:0] MMCITBRxdCInd;   // Cmd Index recd from MMCI
wire [31:0] MMCITBRxdCArg;   // Cmd Arg recd from MMCI
wire        RFF;             // Rx FIFO Full
wire        TFF;             // Tx FIFO Full
wire        RFE;             // Rx FIFO Empty
wire        TFE;             // Tx FIFO Empty
wire        TFHE;            // Tx FIFO Half Empty
wire        RFHF;            // Rx FIFO Half Full
wire        PCLKOn;          // Status flag for PCLK enabled
                             // internally
wire        MCLKOn;          // Status flag for MCLK enabled
                             // internally
wire        CmdCrcErrStat;   // Cmd Crc error status
wire [11:2] PADDR;           // APB Addr
wire [31:0] PWDATA;          // Write databus
wire [32:0] RxFRdData;       // RxFIFO read data

// Outputs
wire        RxFRdPtrInc;     // RxFIFO read ptr Incr
wire        MMCIPowerWr;     // Wr enable for MMCIPower
wire        MMCIClockWr;     // Wr enable for MMCIClock
wire        MMCICommandWr;   // Wr enable for MMCIComand
wire        MMCIDataLenWr;   // WrEn for MMCIDatalen
wire        MMCIDataCntlWr;  // WrEn for MMCIDataCntl
wire        MMCITBCmdRespWr; // WrEn for MMCITBCmdResp
wire        MMCITBResp0Wr;   // WrEn for MMCITBResp0
wire        MMCITBResp1Wr;   // WrEn for MMCITBResp1
wire        MMCITBResp2Wr;   // WrEn for MMCITBResp2
wire        MMCITBResp3Wr;   // WrEn for MMCITBResp3
wire        MMCITBDtTimWr;   // WrEn for MMCITBDataTimer
wire        MMCITBMCLKWr;    // WrEn for MMCITBMCLKPd
wire        MMCITBCntlWr;    // WrEn for MMCITBCntl
wire        MMCITBReTimWr;   // WrEn for MMCITBRespTimer
wire        MMCITBTokTimWr;  // WrEn for MMCITBTkTimer
wire        MMCITBBsyTimWr;  // WrEn for MMCITBBusyTimer
wire        MMCITBPCDisWr;   // WrEn for MMCITBPCDisable
wire        MMCITBStTimWr;   // WrEn for MMCITBStTimeout
wire        MMCITBCLKRSTWr;  // WrEn for MMCITBCkRstCntl
wire        MMCITBTXFWr;     // WrEn for MMCITBFIFOReg
reg  [31:0] PRDATA;          // Read Databus
wire [31:0] PWDATAIn;        // Int PWDATA

// -----------------------------------------------------------------------------
//
//                                 MmciTrApbif
//                                 ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This module decodes APB accesses and generates the write strobes to
// the appropriate registers. This module also contains the output data
// multiplexer and the output register that form the read interface. The
// internal databus, for the MMCITrickbox, PWDATAIn[15:0], is also
// generated in this module, by gating the input data bus, PWDATA[15:0]
// with PSEL and PWRITE.
//
// -----------------------------------------------------------------------------
//                    MMCITB Register Map
// -----------------------------------------------------------------------------
// Offset    Read (Width)     Write (Width)       Description
// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define ZEROFILL         32'b00000000000000000000000000000000
// Zero Fill for reads to return zeros in unused bit positions

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [11:2] GatedPA;
// Gate PA with PSEL to save power

// -----------------------------------------------------------------------------
// Read Decodes for Register reads
// -----------------------------------------------------------------------------
wire        MMCITBSIGSTATRd;
// MMCITBSIGSTAT Read

wire        MMCITBRxdCIndRd;
// MMCITBRxdCInd Read

wire        MMCITBRxdCArgRd;
// MMCITBRxdCArg Read

wire        MMCIFIFORegRd;
// MMCITBFIFOReg Read

wire        MMCICrcErrStatRd;
// MMCITBCrcErrStat Read

wire        MMCIStatusRd;
// MMCITBFifoStat Read

wire  [7:0] MMCITBStatus;
// MMCITB FIFO status register

wire [31:0] NextPRDATA;
// D-input of PRDATA output register

wire        WrEn;
// Write enable signal common to all addresses in the APB interface

wire        RdEn;
// Read enable signal common to all addresses in the APB interface

wire  [1:0] MMCITBCrcErrStat;
// Register for storing the Crc error status

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         DataCrcErrStat;
// Error status of Data Crc

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
// Write Interface
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Latch the data bus and address bus when the device is selected.
// -----------------------------------------------------------------------------
assign GatedPA          = ((PSEL == 1'b1) || (PSELT == 1'b1)) ?
                          PADDR[11:2] : 10'h000;

assign PWDATAIn         = (((PSEL == 1'b1) || (PSELT == 1'b1)) &&
                            (PWRITE == 1'b1)) ? PWDATA : 32'h00000000;

assign WrEn             = (PENABLE & PSEL & PWRITE) || (PENABLE &&
                           PSELT & PWRITE);


// -----------------------------------------------------------------------------
//  Register Write Decodes
// -----------------------------------------------------------------------------

// MMCIPower Reg Write
assign MMCIPowerWr       = (WrEn == 1'b1 && (GatedPA == `PA_MMCIPOWER) &&
                           (PSEL == 1'b1)) ? 1'b1 : 1'b0;
// MMCIClock Reg Write
assign MMCIClockWr       = (WrEn == 1'b1 && (GatedPA == `PA_MMCICLOCK) &&
                           (PSEL == 1'b1)) ? 1'b1 : 1'b0;
// MMCICommand Reg Write
assign MMCICommandWr     = (WrEn == 1'b1 && (GatedPA == `PA_MMCICMD)   &&
                           (PSEL == 1'b1)) ? 1'b1 : 1'b0;

// MMCIDataLength Reg Write
assign MMCIDataLenWr     = (WrEn == 1'b1 &&
                           (GatedPA == `PA_MMCIDATALEN) &&
                           (PSEL == 1'b1)) ? 1'b1 : 1'b0;

// MMCIDataCntl Reg Write
assign MMCIDataCntlWr    = (WrEn == 1'b1 &&
                           (GatedPA == `PA_MMCIDATACNTL) &&
                           (PSEL == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBCmdResponse Reg Write
assign MMCITBCmdRespWr   = (WrEn == 1'b1 &&
                           (GatedPA == `PA_MMCICMDRESP) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBResponse0 Reg Write
assign MMCITBResp0Wr     = (WrEn == 1'b1 && (GatedPA == `PA_MMCIRESP0) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBResponse1 Reg Write
assign MMCITBResp1Wr     = (WrEn == 1'b1 && (GatedPA == `PA_MMCIRESP1) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBResponse2 Reg Write
assign MMCITBResp2Wr     = (WrEn == 1'b1 && (GatedPA == `PA_MMCIRESP2) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBResponse3 Reg Write
assign MMCITBResp3Wr     = (WrEn == 1'b1 && (GatedPA == `PA_MMCIRESP3) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBDataTimer Reg Write
assign MMCITBDtTimWr     = (WrEn == 1'b1 && (GatedPA == `PA_MMCIDTIMER) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBMCLKPeriod Reg Write
assign MMCITBMCLKWr      = (WrEn == 1'b1 && (GatedPA == `PA_MMCIMCLK)   &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBCntl Reg Write
assign MMCITBCntlWr      = (WrEn == 1'b1 &&
                           (GatedPA == `PA_MMCICONTROL) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBRespTimer Reg Write
assign MMCITBReTimWr     = (WrEn == 1'b1 &&
                           (GatedPA == `PA_MMCIRETIMER) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBTokenTimer Reg Write
assign MMCITBTokTimWr    = (WrEn == 1'b1 &&
                           (GatedPA == `PA_MMCITOKTIMER) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBBusyTimer Reg Write
assign MMCITBBsyTimWr    = (WrEn == 1'b1 &&
                           (GatedPA == `PA_MMCIBSYTIMER) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBPCDisable Reg Write
assign MMCITBPCDisWr     = (WrEn == 1'b1 &&
                           (GatedPA == `PA_MMCIPCDISABLE) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBStTimeout Reg Write
assign MMCITBStTimWr     = (WrEn == 1'b1 &&
                           (GatedPA == `PA_MMCISTTIMEOUT) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBCLKRSTCntl Reg Write
assign MMCITBCLKRSTWr    = (WrEn == 1'b1 && (GatedPA == `PA_MMCICLKRST) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;

// MMCITBFIFOReg Reg Write
assign MMCITBTXFWr       = (WrEn == 1'b1 && (GatedPA == `PA_MMCITXFIFO) &&
                           (PSELT == 1'b1)) ? 1'b1 : 1'b0;


// -----------------------------------------------------------------------------
// Read Interface
// -----------------------------------------------------------------------------
assign RdEn             = PSELT & (~PWRITE) & (~PENABLE) & (~PSEL);

// -----------------------------------------------------------------------------
// Normal mode Register Read Decodes
// -----------------------------------------------------------------------------

// MMCITBSIGSTAT Read
assign MMCITBSIGSTATRd   = ((RdEn == 1'b1) &&
                            (GatedPA == `PA_MMCISIGSTAT)) ? 1'b1 : 1'b0;

// MMCITBRxdCInd Read
assign MMCITBRxdCIndRd   = ((RdEn == 1'b1) &&
                            (GatedPA == `PA_MMCITBCMDIND)) ? 1'b1 : 1'b0;

// MMCITBRxdCArg Read
assign MMCITBRxdCArgRd   = ((RdEn == 1'b1) &&
                            (GatedPA == `PA_MMCITBCMDARG)) ? 1'b1 : 1'b0;

// MMCITBFIFOReg Read
assign MMCIFIFORegRd     = ((RdEn == 1'b1) &&
                            (GatedPA == `PA_MMCITBRXFIFO)) ? 1'b1 : 1'b0;

// MMCITBCrcErrStat Read
assign MMCICrcErrStatRd  = ((RdEn == 1'b1) &&
                            (GatedPA == `PA_MMCITBCRCSTAT)) ? 1'b1 : 1'b0;

// MMCITBStatus Read
assign MMCIStatusRd      = ((RdEn == 1'b1) &&
                            (GatedPA == `PA_MMCITBFIFOSTAT)) ? 1'b1 : 1'b0;
// -----------------------------------------------------------------------------
// Increment the Read pointer in the Receive FIFO after every read from
// the Receive FIFO i.e. after every read from the MMCITBFIFOReg Register
// -----------------------------------------------------------------------------
assign RxFRdPtrInc      = ((PENABLE == 1'b1) && (PSELT == 1'b1) &&
                           (PWRITE == 1'b0) &&
                           (GatedPA == `PA_MMCITBRXFIFO)) ? 1'b1 : 1'b0;
// -----------------------------------------------------------------------------
// Assign individual FIFO status bits to MMCITBFifoStatus
// -----------------------------------------------------------------------------
assign MMCITBStatus      = {MCLKOn, PCLKOn, RFHF, RFF, RFE, TFHE, TFF,
                           TFE};

// -----------------------------------------------------------------------------
// Assign individual CRC status bits to MMCITBCrcErrStat
// -----------------------------------------------------------------------------
assign MMCITBCrcErrStat  = {DataCrcErrStat, CmdCrcErrStat};

// -----------------------------------------------------------------------------
// Output Mux.
// When the peripheral is not being accessed, '0's are driven on the
// Read Databus (PRDATA) so as not to place any restrictions on the
// method of external bus connection.The external data buses of the
// peripherals on the APB may then be connected to the ASB-to-APB bridge
// using Muxed or ORed bus connection method.
// -----------------------------------------------------------------------------
assign NextPRDATA       = (MMCITBSIGSTATRd == 1'b1) ?
                          {26'b00000000000000000000000000, MMCITBSIGSTAT}
                                                                       : (
                          (MMCITBRxdCIndRd == 1'b1) ?
                          {26'b00000000000000000000000000, MMCITBRxdCInd}
                                                                       : (
                          (MMCITBRxdCArgRd == 1'b1) ? MMCITBRxdCArg    : (
                          (MMCIFIFORegRd == 1'b1) ? RxFRdData[31:0]    : (
                          (MMCICrcErrStatRd == 1'b1) ?
                          {30'b000000000000000000000000000000,
                          MMCITBCrcErrStat}                            : (
                          (MMCIStatusRd == 1'b1) ?
                          {24'b000000000000000000000000, MMCITBStatus} :
                          32'h00000000)))));

// -----------------------------------------------------------------------------
// Data crc error status is the MSB of the data read from FIFO and is
// loaded into MMCITBCrcErrStat Register.
// -----------------------------------------------------------------------------

always @(MMCIFIFORegRd or PRESETn)
begin : p_DataCrcErrStat
  if (PRESETn == 1'b0)
    DataCrcErrStat = 1'b0;
  else if (MMCIFIFORegRd == 1'b1)
    DataCrcErrStat = RxFRdData[32];
end // p_DataCrcErrStat

// -----------------------------------------------------------------------------
// Output Data register.
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_PRDATASeq
  if (PRESETn ==  1'b0)
    PRDATA <= 32'h00000000;
  else
    PRDATA <= NextPRDATA;
end // p_PRDATASeq

endmodule

// --================================== End ==================================--
