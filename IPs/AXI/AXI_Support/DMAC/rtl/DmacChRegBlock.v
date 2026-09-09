// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacChRegBlock.v.rca
// File Revision          : 1.9
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This file describes the channel register and other flag-bits.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacChRegBlock (
// Inputs
                       // AHB signals
                       HCLK,
                       HRESETn,
                       HWDATA,
                       // From AHB master Interface (DmacAhbMaster)
                       MasterAddressM1,
                       MasterAddressM2,
                       ChWrDataM1,
                       ChWrDataM2,
                       // From Slave Interface (DmacAhbSlaveIf)
                       DmacChannelSel,
                       RegHWrite,
                       RegAddress,
                       // From DmacChSrcXfer block
                       SrcDmacState,
                       SrcErr,
                       SrcDisable,
                       SrcAddrUpdate,
                       DecTrfSizeSrc,
                       // From DmacChDstXfer block
                       DecTrfSizeDst,
                       DstDmacState,
                       DstErr,
                       DstDisable,
                       DstAddrUpdate,
                       // From DmacChLLILoad block
                       FinishedLLI,
                       LLIErr,
                       DisabledLLI,
                       LLISrcWr,
                       LLIDstWr,
                       LLILLIRegWr,
                       LLICntlWr,
                       // From DmacChPckUnpck
                       FifoNonEmpty,
                       // From DmacChReqProc
                       ChDstBReq,
                       ChDstLBReq,
                       LdSrcInDstFlow,

// Outputs
                       // To AHB Slave (DmacAhbSlaveIf)
                       ChHRDATA,
                       // To DmacChPckUnpck block
                       FifoPtrReset,
                       // To DmacChReqProc block
                       SetIntErr,
                       DMACChSrcAddr,
                       DMACChDstAddr,
                       // To DmacChReqMask block
                       UnsetErrMsk,
                       TrfSizeDst,
                       DisabledDst,
                       // To DmacChDstXfer block
                       SrcErred,
                       DisabledSrc,
                       IntTCEnable,
                       // To DmacChSrcXfer block
                       DstErred,
                       // Bit fields of DMACChControl to other channel blocks
                       SWidth,
                       DWidth,
                       SrcSelect,
                       DstSelect,
                       TrfSizeSrc,
                       SBSize,
                       DBSize,
                       SrcIncr,
                       DestIncr,
                       ProtStat,
                       TCIntMask,
                       // Bit fields of DMACChConfig to other channel blocks
                       ChannelEn,
                       SrcPeriph,
                       DstPeriph,
                       FlowCntl,
                       ErrIntMask,
                       ChLock,
                       Halt,
                       ChannelEnLow,
                       SourceEn,
                       DestEn,
                       LLISelForPkt,
                       LLIAddressUB
                      );

// Inputs

// AHB signals
input         HCLK;            // AHB Clock
input         HRESETn;         // AHB Reset
input  [31:0] HWDATA;          // AHB Slave data bus

// From AHB master Interface (DmacAhbMaster)
input  [31:0] MasterAddressM1; // HADDR information for AHB 1
input  [31:0] MasterAddressM2; // HADDR information for AHB 2
input  [31:0] ChWrDataM1;      // Read data bus of AHB Master 1
input  [31:0] ChWrDataM2;      // Read data bus of AHB Master 2

// From Slave Interface (DmacAhbSlaveIf)
input         DmacChannelSel;  // Read-write select for channel registers
input         RegHWrite;       // Write enable to DMAC channel registers.
input   [4:2] RegAddress;      // Lower order bits of the buffered address
                               // from DMAC AHB Slave

// From DmacChSrcXfer block
input   [4:0] SrcDmacState;    // Source Transfer Logic state
input         SrcErr;          // Source error
input         SrcDisable;      // Source disable
input         SrcAddrUpdate;   // When high, the MasterAddress is clocked in
                               // src-address-register
input         DecTrfSizeSrc;   // Decrease the source-transfer count by 1

// From DmacChDstXfer block
input         DecTrfSizeDst;   // Decrease the Transfer-Size-Dest counter by 1
input   [4:0] DstDmacState;    // Destination Transfer Logic state
input         DstErr;          // Destination error
input         DstDisable;      // Destination disable
input         DstAddrUpdate;   // Update the destination address register

// From DmacChLLILoad block
input         FinishedLLI;     // Indicates that Transfer-Size-Dest counter
                               // can be loaded
input         LLIErr;          // Indicates an error response while loading
                               // LLI
input         DisabledLLI;     // Indicates DMAC is disabled at the start of
                               // LLI loading operation
input         LLISrcWr;        // LLI update for ChSrc register
input         LLIDstWr;        // LLI update for ChDest register
input         LLILLIRegWr;     // LLI update for ChLLI register
input         LLICntlWr;       // LLI update for ChControl register

// From DmacChPckUnpck
input         FifoNonEmpty;    // Indicates data being preset in channel FIFO

// From DmacChReqProc
input         ChDstBReq;       // Destination Burst Request for the channel
input         ChDstLBReq;      // Destination Last Burst Request for the
                               // channel
input         LdSrcInDstFlow;  // Indicates that the TrfSizeSrc register can
                               // be loaded with destination required number



// Outputs

// To AHB Slave (DmacAhbSlaveIf)
output [31:0] ChHRDATA;        // AHB slave read data from channel

// To DmacChPckUnpck block
output        FifoPtrReset;    // Resetting FIFO pointers

// To DmacChReqProc block
output        SetIntErr;       // Signals error interrupt
output [31:0] DMACChSrcAddr;   // Source address
output [31:0] DMACChDstAddr;   // Destination address

// To DmacChReqMask block
output        UnsetErrMsk;     // Unsets the ErrMsk
output [13:0] TrfSizeDst;      // Transfer size value for the
                               // destination-transfer-logic
output        DisabledDst;     // Destination disabled

// To DmacChDstXfer block
output        SrcErred;        // Indicates error during source transfer.
output        DisabledSrc;     // Source disabled
output        IntTCEnable;     // Enable for Terminal Count interrupt

// To DmacChSrcXfer block
output        DstErred;        // Bit indicating an error during destination
                               // transfer

// Bit fields of DMACChControl to other channel blocks
output  [2:0] SWidth;          // Source transfer width
output  [2:0] DWidth;          // Destination transfer width
output        SrcSelect;       // Source AHB Master select
output        DstSelect;       // Destination AHB Master select
output [11:0] TrfSizeSrc;      // Indicates the number of source transfers to
                               // perform
output  [2:0] SBSize;          // Source burst size
output  [2:0] DBSize;          // Destination burst size
output        SrcIncr;         // Indicates incrementing addressing for source
output        DestIncr;        // Indicates incrementing addressing for
                               // destination
output  [2:0] ProtStat;        // Higher 3 bits of HPROT signal
output        TCIntMask;       // Terminal-count-interrupt mask

// Bit fields of DMACChConfig to other channel blocks
output        ChannelEn;       // The channel enable bit
output  [3:0] SrcPeriph;       // Indicates the source-peripheral mapped to
                               // the channel
output  [3:0] DstPeriph;       // Indicates the destination- peripheral mapped
                               // to the channel
output  [2:0] FlowCntl;        // flow control information
output        ErrIntMask;      // mask for error-interrupt
output        ChLock;          // HLOCK information for the channel
output        Halt;            // user mask for source requests
output        ChannelEnLow;    // Indicates a 0 being written to ChannelEnable
output        SourceEn;        // Source Enabled
output        DestEn;          // Destination Enabled
output        LLISelForPkt;    // AHB master select for LLI loading operations
                               // in the ongoing packet
output [31:2] LLIAddressUB;    // Address of the next LLI

// Inputs
// AHB signals
wire          HCLK;            // AHB Clock
wire          HRESETn;         // AHB Reset
wire   [31:0] HWDATA;          // AHB Slave data bus
// From AHB master Interface (DmacAhbMaster)
wire   [31:0] MasterAddressM1; // HADDR information for AHB 1
wire   [31:0] MasterAddressM2; // HADDR information for AHB 2
wire   [31:0] ChWrDataM1;      // Read data bus of AHB Master 1
wire   [31:0] ChWrDataM2;      // Read data bus of AHB Master 2
// From Slave Interface (DmacAhbSlaveIf)
wire          DmacChannelSel;  // Read-write select for channel registers
wire          RegHWrite;       // Write enable to DMAC channel registers.
wire    [4:2] RegAddress;      // Lower order bits of the buffered address
                               // from DMAC AHB Slave
// From DmacChSrcXfer block
wire    [4:0] SrcDmacState;    // Source Transfer Logic state
wire          SrcErr;          // Source error
wire          SrcDisable;      // Source disable
wire          SrcAddrUpdate;   // When high, the MasterAddress is clocked in
                               // src-address-register
wire          DecTrfSizeSrc;   // Decrease the source-transfer count by 1
// From DmacChDstXfer block
wire          DecTrfSizeDst;   // Decrease the Transfer-Size-Dest counter by 1
wire    [4:0] DstDmacState;    // Destination Transfer Logic state
wire          DstErr;          // Destination error
wire          DstDisable;      // Destination disable
wire          DstAddrUpdate;   // Update the destination address register
// From DmacChLLILoad block
wire          FinishedLLI;     // Indicates that Transfer-Size-Dest counter
                               // can be loaded
wire          LLIErr;          // Indicates an error response while loading
                               // LLI
wire          DisabledLLI;     // Indicates DMAC is disabled at the start of
                               // LLI loading operation
wire          LLISrcWr;        // LLI update for ChSrc register
wire          LLIDstWr;        // LLI update for ChDest register
wire          LLILLIRegWr;     // LLI update for ChLLI register
wire          LLICntlWr;       // LLI update for ChControl register
// From DmacChPckUnpck
wire          FifoNonEmpty;    // Indicates data being preset in channel FIFO
// From DmacChReqProc
wire          ChDstBReq;       // Destination Burst Request for the channel
wire          ChDstLBReq;      // Destination Last Burst Request for the
                               // channel
wire          LdSrcInDstFlow;  // Indicates that the TrfSizeSrc register can
                               // be loaded with destination required number

// Outputs
// To AHB Slave (DmacAhbSlaveIf)
reg    [31:0] ChHRDATA;        // AHB slave read data from channel
// To DmacChPckUnpck block
reg           FifoPtrReset;    // Resetting FIFO pointers
// To DmacChReqProc block
reg           SetIntErr;       // Signals error interrupt
reg    [31:0] DMACChSrcAddr;   // Source address
reg    [31:0] DMACChDstAddr;   // Destination address
// To DmacChReqMask block
reg           UnsetErrMsk;     // Unsets the ErrMsk
reg    [13:0] TrfSizeDst;      // Transfer size value for the
                               // destination-transfer-logic
reg           DisabledDst;     // Destination disabled
// To DmacChDstXfer block
reg           SrcErred;        // Indicates error during source transfer.
reg           DisabledSrc;     // Source disabled
wire          IntTCEnable;     // Enable for Terminal Count interrupt
// To DmacChSrcXfer block
reg           DstErred;        // Bit indicating an error during destination
                               // transfer
// Bit fields of DMACChControl to other channel blocks
wire    [2:0] SWidth;          // Source transfer width
wire    [2:0] DWidth;          // Destination transfer width
wire          SrcSelect;       // Source AHB Master select
wire          DstSelect;       // Destination AHB Master select
reg    [11:0] TrfSizeSrc;      // Indicates the number of source transfers to
                               // perform
wire    [2:0] SBSize;          // Source burst size
wire    [2:0] DBSize;          // Destination burst size
wire          SrcIncr;         // Indicates incrementing addressing for source
wire          DestIncr;        // Indicates incrementing addressing for
                               // destination
wire    [2:0] ProtStat;        // Higher 3 bits of HPROT signal
wire          TCIntMask;       // Terminal-count-interrupt mask
// Bit fields of DMACChConfig to other channel blocks
reg           ChannelEn;       // The channel enable bit
wire    [3:0] SrcPeriph;       // Indicates the source-peripheral mapped to
                               // the channel
wire    [3:0] DstPeriph;       // Indicates the destination- peripheral mapped
                               // to the channel
wire    [2:0] FlowCntl;        // flow control information
wire          ErrIntMask;      // mask for error-interrupt
wire          ChLock;          // HLOCK information for the channel
reg           Halt;            // user mask for source requests
wire          ChannelEnLow;    // Indicates a 0 being written to ChannelEnable
reg           SourceEn;        // Source Enabled
reg           DestEn;          // Destination Enabled
reg           LLISelForPkt;    // AHB master select for LLI loading operations
                               // in the ongoing packet
wire   [31:2] LLIAddressUB;    // Address of the next LLI

// -----------------------------------------------------------------------------
//
//                               DmacChRegBlock
//                               ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// The DmacChRegBlock file performs the following functionalities:
// o Write Enable signals are generated for the DMAC channel registers.
// o Channel-Source-Address register is described, which can be written by three
//   sources -
//   o AHB Slave side during programming.
//   o AHB master side during LLI Loading.
//   o Source-transfer block, when it updates the register with latest address.
// o Channel-Dest-Address register is described, which can be written by three
//   sources -
//   o AHB Slave side during programming.
//   o AHB master side during LLI Loading.
//   o Destination-transfer block, when it updates the register with latest
//     address.
// o Higher order bits of DmacChControl register (except the TrfSize bit field).
//   The higher bits can be updated by two sources -
//   o AHB Slave side during programming.
//   o AHB master side during LLI Loading.
// o The TrfSizeSrc (transfer size source counter) is described. This register
//   is updated from three sources -
//   o AHB Slave side during programming.
//   o AHB master side during LLI Loading.
//   o Source-transfer block, when it updates the register with every transfer.
//   o apart from that, this counter is re-used for doing the source transfers
//     in destination flow control mode.
// o Channel Configuration register is described. This register (except Active
//   and Channel Enable bit) is updated from only one source - AHB Slave side
//   during programming.
//   Channel-Enable bit is a control-bit cum status bit. It is enabled by the
//   AHB slave side, but can be disabled by the DMAC only. Even if the channel
//   enable bit is written a value of zero from the slave side, the zero is
//   reflected in the bit, only after the ongoing transfers on the master
//   bus(es) have terminated.
//   Active bit is a status bit which is a function of FIFO fill status.
// o TrfSizeDst counter is described. This counter tracks the destination
//   transfers in DMAC flow control mode. A different counter from source is
//   needed, as the source-request and the destination requests are given
//   separate Terminal-Count-signals (TC). The counter is loaded with the value
//   of TrfSizeSrc (Transfer Size in accordance to source width) multiplied by
//   ratio of DWidth to SWidth. In other words
//   TrfSizeDst = TrfSizeSrc * (DWidth/SWidth).
//   The counter is loaded after the channel is enabled.
// o Read Data Mux for channel registers is described. On the basis of the
//   address, the contents of the corresponding channel-register is muxed out
//   and clocked.
// o Bit fields of DMACChConfig and DMACChControl registers are split and
//   brought out as output of the module. These bit fields are used in other
//   modules.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire  [16:1] NextDMACChConfig;
// D-input for DMACChConfig

wire         ChannelEnHigh;
// Indicates a 1 being written to ChannelEnable

wire         SrcAddrWrEn;
// Write enable into the source from the AHB Slave interface

wire         DstAddrWrEn;
// Write enable into the destination from the AHB Slave interface

wire         CntlWrEn;
// Write enable into the DMAC channel control register

wire         LLIWrEn;
// Write enable into the DMAC LLI register

wire         LLISelect;
// Current value of LSB in DmacChLLIReg register

wire  [13:0] InTrfSizeDst;
// Intermediate signal for decrementing TrfSizeDst

wire  [11:0] InTrfSizeSrc;
// Intermediate signal for decrementing TrfSizeSrc

wire         NextHalt;
// D-input of the Halt bit

wire         NextRegChEnHigh;
// D-input of RegChEnHigh

wire   [5:0] SWidthDWidth;
// Concatenation of SWidth and DWidth bit-fields

wire  [31:0] MastAddrSrc;
// Routes the contents of one of the AHB address buses into DMACChSrcAddr

wire  [31:0] MastAddrDst;
// Routes the contents of one of the AHB address buses into DmacChDstAddress

wire  [31:0] ChWrDataSrc;
// During LLI Load operation, the databus from one of the AHB masters (decided
// by LLISel) is routed to DMACChSrcAddr

wire  [31:0] ChWrDataDst;
// During LLI Load operation, the databus from one of the AHB masters (decided
// by LLISel) is routed to DmacChDstAddr

wire [31:12] ChWrDataCntl;
// The upper 20 bits of DmacChControl register, that is routed from one of the
// AHB master data buses during LLI Loading operation

wire  [11:0] ChWrDataTrf;
// The TransferSize value, that is routed from one of the AHB master data buses
// during LLI Loading operation

wire  [31:2] ChWrDataLLIReg;
// The location of next LLI, that is routed from one of the AHB master data
// buses during LLI loading operation

wire         ChWrDataLLISel;
// The Master-port through which the next LLI will be fetched, is routed to
// DmacChLLIReg from one of the AHB-master-data-buses during LLI Load operation

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg   [31:0] NxtDMACChSrcAddr;
// D-input of DMACChSrcAddr

reg   [31:0] NxtDMACChDstAddr;
// D-input of DMACChDstAddr

reg  [31:12] DMACChControl;
// DMAC channel control register without the TrfSizeSrc bit field

reg  [31:12] NxtDMACChControl;
// D-input of DMACChControl

reg   [11:0] NextTrfSizeSrc;
// D-input for TrfSizeSrc

reg   [31:2] DMACChLLIReg;
// DMAC Channel linked-list register

reg   [31:2] NextDMACChLLIReg;
// D-input of DMACChLLIReg

reg          LLIMastSlct;
// Decides the master port through which LLI access will be routed

reg          NextLLIMastSlct;
// D-i/p of LLIMastSlct bit

reg   [16:1] DMACChConfig;
// DMAC channel configuration register without the channel-enable field

reg          NextChannelEn;
// D-input for ChannelEn

reg          NextSourceEn;
// D-input of SourceEn

reg          NextDestEn;
// D-input of DestEn

reg   [13:0] TrfSizeDstCo;
// TrfSizeSrc * (SWidth / DWidth)

reg   [13:0] NextTrfSizeDst;
// D-input for TrfSizeDst

reg          NextSrcErred;
// D-input for SrcErred

reg          NextDstErred;
// D-input for DstErred

reg          NextDisabledSrc;
// D-input for DisabledSrc

reg          NextDisabledDst;
// D-input for DisabledDst

reg          NextLLISelForPkt;
// D-input of the LLISelForPkt bit

reg          DmacSrcRegSel;
// ReadWrite select for DMACChSrcAddr

reg          DmacDestRegSel;
// ReadWrite select for DmacChDstAddr

reg          DmacLLIRegSel;
// ReadWrite select for DmacChLLIReg

reg          DmacCntlRegSel;
// ReadWrite select for DmacChControl

reg          DmacChCnfgSel;
// ReadWrite select for DmacChConfig

reg          NextFifoPtrReset;
// D-input of FifoPtrReset

reg          RegChEnHigh;
// clocked version of ChannelEnHigh

reg   [31:0] NextChHRDATA;
// D-input for ChHRDATA

reg   [10:0] DestReqNoSrc;
// Number of source transfers required to fetch data for destination peripheral
// in destination flow control mode

reg   [13:0] ReqNoSrcCombJ;
// Temporary variable for using inside p_ReqNoSrcCombJ

reg   [13:0] ChRdDataCombJ;
// Temporary variable for using inside p_ChRdDataComb

//Include Parameters File
`include "DmacParams.v"

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
// Generating write enables for AHB-Slave-writable registers.
// -----------------------------------------------------------------------------
assign SrcAddrWrEn      = DmacSrcRegSel & RegHWrite;

assign DstAddrWrEn      = DmacDestRegSel & RegHWrite;

assign CntlWrEn         = DmacCntlRegSel & RegHWrite;

assign LLIWrEn          = DmacLLIRegSel & RegHWrite;

// -----------------------------------------------------------------------------
// The following block registers the LLISelect into LLISelForPkt at the start of
// packet transfer (which happens when Channel Enable goes high for the first
// time or LLI loading operation finishes). The LLISelForPkt is used for routing
// information to/from one of the two AHB Master ports.
// -----------------------------------------------------------------------------
always @(RegChEnHigh or FinishedLLI or LLISelect or LLISelForPkt)
begin : p_LLISelPktComb
  if ((RegChEnHigh == 1'b1) || (FinishedLLI == 1'b1))
    NextLLISelForPkt = LLISelect;
  else
    NextLLISelForPkt = LLISelForPkt;
end // p_LLISelPktComb

// -----------------------------------------------------------------------------
// Sequential block for p_LLISelPktComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LLISelPktSeq
  if (HRESETn == 1'b0)
    LLISelForPkt     <= 1'b0;
  else
    LLISelForPkt     <= NextLLISelForPkt;
end // p_LLISelPktSeq

// -----------------------------------------------------------------------------
// The following statement selects one of the AHB Master address buses, to be
// routed to DMACChSrcAddr register.
// -----------------------------------------------------------------------------
assign MastAddrSrc      = (SrcSelect == 1'b0) ? MasterAddressM1     :
                           MasterAddressM2;

// -----------------------------------------------------------------------------
// During LLI Load operation, the databus from one of the AHB masters (decided
// by LLISelForPkt) is routed to DMACChSrcAddr
// -----------------------------------------------------------------------------
assign ChWrDataSrc      = (LLISelForPkt == 1'b0) ? ChWrDataM1       :
                           ChWrDataM2;

// -----------------------------------------------------------------------------
// The following block describes the combinational part of the Channel Source
// address register. The register can be updated from three sources, namely, AHB
// Slave port, Channel logic and LLI-load-block.
// -----------------------------------------------------------------------------
always @(SrcAddrUpdate or LLISrcWr or SrcAddrWrEn or MastAddrSrc or
         DMACChSrcAddr or ChWrDataSrc or HWDATA)
begin : p_SrcRegComb
  // In case of address-update during source-DMAC transfers, the address
  // on the master-port (1/2) (decided by SrcSelect) is clocked into the
  // channel-source-address register.
  if ((SrcAddrUpdate == 1'b1) && (LLISrcWr == 1'b0) && (SrcAddrWrEn == 1'b0))
    NxtDMACChSrcAddr = MastAddrSrc;

  // In case of LLI-loading operation, the data on the master-port
  // (1/2) (decided by LLISelForPkt, which is the registered version of
  // LLISelect at the start of packet transfer) is clocked into the
  // channel-source-address register.
  else if ((SrcAddrUpdate == 1'b0) && (LLISrcWr == 1'b1) &&
           (SrcAddrWrEn == 1'b0))
    NxtDMACChSrcAddr = ChWrDataSrc;

  // When the SrcAddr register is programmed from AHB Slave side.
  else if ((SrcAddrUpdate == 1'b0) && (LLISrcWr == 1'b0) &&
           (SrcAddrWrEn == 1'b1))
     NxtDMACChSrcAddr = HWDATA;

  else
    NxtDMACChSrcAddr = DMACChSrcAddr;
end // p_SrcRegComb

// -----------------------------------------------------------------------------
// The following statement selects one of the AHB Master address buses, to be
// routed to DmacChDstAddr register.
// -----------------------------------------------------------------------------
assign MastAddrDst      = (DstSelect == 1'b0) ? MasterAddressM1     :
                           MasterAddressM2;

// -----------------------------------------------------------------------------
// During LLI Load operation, the databus from one of the AHB masters (decided
// by LLISelForPkt) is routed to DmacChDstAddr
// -----------------------------------------------------------------------------
assign ChWrDataDst      = (LLISelForPkt == 1'b0) ? ChWrDataM1       :
                           ChWrDataM2;

// -----------------------------------------------------------------------------
// The following block describes the combinational part of the Channel
// Destination address register. The register can be updated from three sources,
// namely, AHB Slave port, Channel logic and LLI-load-block.
// -----------------------------------------------------------------------------
always @(DstAddrUpdate or LLIDstWr or DstAddrWrEn or MastAddrDst or
         DMACChDstAddr or ChWrDataDst or HWDATA)
begin : p_DstRegComb
  // In case of address-update during destination-DMAC transfers, the address
  // on the master-port (1/2) (decided by DstSelect) is clocked into the
  // channel-destination-address register.
  if ((DstAddrUpdate == 1'b1) && (LLIDstWr == 1'b0) && (DstAddrWrEn == 1'b0))
    NxtDMACChDstAddr = MastAddrDst;

  // In case of LLI-loading operation, the data on the master-port
  // (1/2) (decided by LLISelForPkt, which is the registered version of
  // LLISelect at the start of packet transfer) is clocked into the
  // channel-destination-address register.
  else if ((DstAddrUpdate == 1'b0) && (LLIDstWr == 1'b1) &&
           (DstAddrWrEn == 1'b0))
    NxtDMACChDstAddr = ChWrDataDst;

  // When the DstAddr register is programmed from AHB Slave side.
  else if ((DstAddrUpdate == 1'b0) && (LLIDstWr == 1'b0) &&
           (DstAddrWrEn == 1'b1))
    NxtDMACChDstAddr = HWDATA;
  else
    NxtDMACChDstAddr = DMACChDstAddr;
end // p_DstRegComb

// -----------------------------------------------------------------------------
// The upper 20 bits of DmacChControl register, that is routed from one of the
// AHB master data buses during LLI Loading operation
// -----------------------------------------------------------------------------
assign ChWrDataCntl     = (LLISelForPkt == 1'b0) ? ChWrDataM1[31:12] :
                           ChWrDataM2[31:12];

// -----------------------------------------------------------------------------
// The DMAC Channel control register (except the TrfSize bit-field) is updated
// by two sources.
// o When there is a write from AHB slave side.
// o There is LLI loading.
// -----------------------------------------------------------------------------
always @(CntlWrEn or LLICntlWr or HWDATA or ChWrDataCntl or DMACChControl)
begin : p_CntlRegComb
  // when the control register is programmed from the AHB slave side.
  if ((CntlWrEn == 1'b1) && (LLICntlWr == 1'b0))
    NxtDMACChControl = HWDATA[31:12];
  else if ((CntlWrEn == 1'b0) && (LLICntlWr == 1'b1))
    NxtDMACChControl = ChWrDataCntl;
  else
    NxtDMACChControl = DMACChControl;
end // p_CntlRegComb

// -----------------------------------------------------------------------------
// The following block calculates the number of source transfers to be done to
// fetch sufficient data for performing destination transfer in destination
// flow control mode.
// -----------------------------------------------------------------------------
always @(ChDstBReq or ChDstLBReq or DWidth or SWidth or DBSize)
begin : p_ReqNoSrcComb
  // when the destination-burst-requests are raised
  if ((ChDstBReq | ChDstLBReq) == 1'b1)
    begin
      // DestReqNoSrc := DBSize * (DWidth/SWidth);
      ReqNoSrcCombJ    = DivideFactor(SWidth, DWidth,
                                      ({5'b00000, DecodeBSize(DBSize)}));
      DestReqNoSrc     = ReqNoSrcCombJ[10:0];
    end
  // when the destination-single-requests are raised
  else
    begin
      // DestReqNoSrc := 1 * (DWidth/SWidth);
      ReqNoSrcCombJ    = DivideFactor(SWidth, DWidth,
                                      ({13'b0000000000000, 1'b1}));
      DestReqNoSrc     = ReqNoSrcCombJ[10:0];
    end
end // p_ReqNoSrcComb

// -----------------------------------------------------------------------------
// The TransferSize value, that is routed from one of the AHB master data buses
// during LLI Loading operation.
// -----------------------------------------------------------------------------
assign ChWrDataTrf      = (LLISelForPkt == 1'b0) ? ChWrDataM1[11:0] :
                           ChWrDataM2[11:0];

// -----------------------------------------------------------------------------
// Precalculating the decremented TrfSizeSrc.
// -----------------------------------------------------------------------------
assign InTrfSizeSrc     = TrfSizeSrc - 1'b1;

// -----------------------------------------------------------------------------
// The Transfer Size counter has got two versions - Source and destination. This
// block describes TrfSizeSrc register. The register is loaded with a new value
// when
// o There is a write from AHB Slave side
// o There is LLI loading.
// o During data transfers (indicated by DecTrfSizeSrc = 1), the register is
//   decremented by 1.
// -----------------------------------------------------------------------------
always @(CntlWrEn or LLICntlWr or DecTrfSizeSrc or TrfSizeSrc or HWDATA or
         ChWrDataTrf or InTrfSizeSrc or ChannelEn or LdSrcInDstFlow or
         DestReqNoSrc)
begin : p_TrfSizeComb
  // when there is a write from AHB Slave side
  if ((CntlWrEn == 1'b1) && (LLICntlWr == 1'b0) && (DecTrfSizeSrc == 1'b0))
     NextTrfSizeSrc   = HWDATA[11:0];
  // when the transfer-size register is updated during LLI-load
  else if ((CntlWrEn == 1'b0) && (LLICntlWr == 1'b1) && (DecTrfSizeSrc == 1'b0))
     NextTrfSizeSrc   = ChWrDataTrf;
  // when the transfer-size register is decremented by channel logic.
  else if ((CntlWrEn == 1'b0) && (LLICntlWr == 1'b0) && (DecTrfSizeSrc == 1'b1))
     NextTrfSizeSrc   = InTrfSizeSrc;
  // In destination flow control mode, whenever any destination request makes
  // a positive transition, LdSrcInDstFlow goes high, which is used to load the
  // TrfSizeSrc register.
  else if ((ChannelEn & LdSrcInDstFlow) == 1'b1)
     NextTrfSizeSrc   = {1'b0, DestReqNoSrc};
  // when the register does not need to be updated
  else
     NextTrfSizeSrc   = TrfSizeSrc;
end // p_TrfSizeComb

// -----------------------------------------------------------------------------
// The location of next LLI is routed from one of the AHB master data buses
// during LLI loading operation
// -----------------------------------------------------------------------------
assign ChWrDataLLIReg   = (LLISelForPkt == 1'b0) ? ChWrDataM1[31:2] :
                           ChWrDataM2[31:2];

// -----------------------------------------------------------------------------
// The Master-port through which the next LLI will be fetched, is routed to
// DmacChLLIReg from one of the AHB-master-data-buses during LLI Load operation
// -----------------------------------------------------------------------------
assign ChWrDataLLISel   = (LLISelForPkt == 1'b0) ? ChWrDataM1[0]    :
                           ChWrDataM2[0];

// -----------------------------------------------------------------------------
// The DMAC LLI register is updated from two sources.
// o When there is a write from AHB slave side.
// o When there is LLI loading.
// -----------------------------------------------------------------------------
always @(LLIWrEn or LLILLIRegWr or HWDATA or ChWrDataLLIReg or ChWrDataLLISel
         or DMACChLLIReg or LLIMastSlct)
begin : p_LLIRegComb
  // when the LLIRegister is written from AHB-slave side
  if ((LLIWrEn == 1'b1) && (LLILLIRegWr == 1'b0))
    begin
      NextDMACChLLIReg = HWDATA[31:2];
      NextLLIMastSlct  = HWDATA[0];
    end
  // when the LLIRegister is updated by an LLI load operation
  else if ((LLIWrEn == 1'b0) && (LLILLIRegWr == 1'b1))
    begin
      NextDMACChLLIReg = ChWrDataLLIReg;
      NextLLIMastSlct  = ChWrDataLLISel;
    end
  else
    begin
      NextDMACChLLIReg = DMACChLLIReg;
      NextLLIMastSlct  = LLIMastSlct;
    end
end // p_LLIRegComb

// -----------------------------------------------------------------------------
// The DMACChConfig register(except the ChannelEn bit) is written from the
// AHB slave side. The following statement generates the D-input for
// DMACChConfig, except the channel-enable bit.
// -----------------------------------------------------------------------------
assign NextHalt         = ((DmacChCnfgSel == 1'b1) && (RegHWrite == 1'b1)) ?
                           HWDATA[18] : Halt;

assign NextDMACChConfig = ((DmacChCnfgSel == 1'b1) && (RegHWrite == 1'b1)) ?
                           HWDATA[16:1] : DMACChConfig;

// -----------------------------------------------------------------------------
// Sequential process for inferring the channel-registers
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ChannelRegSeq
  if (HRESETn == 1'b0)
    begin
      DMACChSrcAddr    <= {32{1'b0}};
      DMACChDstAddr    <= {32{1'b0}};
      DMACChControl    <= {20{1'b0}};
      TrfSizeSrc       <= {12{1'b0}};
      DMACChLLIReg     <= {30{1'b0}};
      LLIMastSlct      <= 1'b0;
      Halt             <= 1'b0;
      DMACChConfig     <= {16{1'b0}};
    end
  else
    begin
      DMACChSrcAddr    <= NxtDMACChSrcAddr;
      DMACChDstAddr    <= NxtDMACChDstAddr;
      DMACChControl    <= NxtDMACChControl;
      TrfSizeSrc       <= NextTrfSizeSrc;
      DMACChLLIReg     <= NextDMACChLLIReg;
      LLIMastSlct      <= NextLLIMastSlct;
      Halt             <= NextHalt;
      DMACChConfig     <= NextDMACChConfig;
    end
end // p_ChannelRegSeq

// -----------------------------------------------------------------------------
// The following statements splits the bit-fields of DMACChConfig register.
// -----------------------------------------------------------------------------
// The fifth bit of SrcPeriph is not used in 16-requestor configuration.
assign SrcPeriph        = DMACChConfig[4:1];
// The fifth bit of DstPeriph is not used in 16-requestor configuration.
assign DstPeriph        = DMACChConfig[9:6];
assign FlowCntl         = DMACChConfig[13:11];
assign ErrIntMask       = DMACChConfig[14];
assign TCIntMask        = DMACChConfig[15];
assign ChLock           = DMACChConfig[16];

// -----------------------------------------------------------------------------
// The following statements splits the bit-fields of DMACChLLIReg register.
// -----------------------------------------------------------------------------
assign LLISelect        = LLIMastSlct;
assign LLIAddressUB     = DMACChLLIReg[31:2];

// -----------------------------------------------------------------------------
// ChannelEnHigh is taken to '1' whenever the ChannelEnable bit (HWDATA(0)) is
// set.
// -----------------------------------------------------------------------------
assign ChannelEnHigh    = DmacChCnfgSel & RegHWrite & HWDATA[0];

// -----------------------------------------------------------------------------
// The TrfSizeDst register is loaded, one clock after the channel enable is
// written high by the AHB slave. The one stage buffering is done in order to
// meet synthesis timings. The following block clocks out ChannelEnHigh.
// In normal cases, the AHB slave side should not write into the channel
// registers when the channel is enabled. But there is one exception and that is
// setting of the halt bit. The Halt Bit is in the same register as the "channel
// enable" bit. At halt time, the RegChEnHigh signal should not go high
// and reload the destination counter.
// -----------------------------------------------------------------------------
assign NextRegChEnHigh  = ChannelEnHigh & ~(ChannelEn);

// -----------------------------------------------------------------------------
// Sequential block for ChannelEnComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ChEnSeq
  if (HRESETn == 1'b0)
    RegChEnHigh      <= 1'b0;
  else
    RegChEnHigh      <= NextRegChEnHigh;
end // p_ChEnSeq

// -----------------------------------------------------------------------------
// Concatenation of SWidth and Dwidth fields is used for arithmetic operations
// within the p_DivideFactor2 block.
// -----------------------------------------------------------------------------
assign SWidthDWidth     = {SWidth, DWidth};

// -----------------------------------------------------------------------------
// The following process does the following arithmetic operation :-
// TrfSizeDstCo <= TrfSizeSrc * (SWidth/DWidth).
// -----------------------------------------------------------------------------
always @(SWidth or DWidth or SWidthDWidth or TrfSizeSrc)
begin : p_DvdFctr2Comb
  // Default assignment
  TrfSizeDstCo     = {14{1'b0}};

  if (SWidth == DWidth)
    TrfSizeDstCo     = {2'b00, TrfSizeSrc};
  else if (SWidth > DWidth)
    begin
      case (SWidthDWidth)
        // when SWidth = DWidth * 2
        6'b001000 :
          // return (2 * TrfSizeSrc) as the TrfSizeDstCo value
          TrfSizeDstCo     = {1'b0, TrfSizeSrc[11:0], 1'b0};
        6'b010001 :
          // return (2 * TrfSizeSrc) as the TrfSizeDstCo value
          TrfSizeDstCo     = {1'b0, TrfSizeSrc[11:0], 1'b0};
        // when SWidth = DWidth * 4
        6'b010000 :
          // return (4 * TrfSizeSrc) as the TrfSizeDstCo value
          TrfSizeDstCo     = {TrfSizeSrc, 2'b00};
        default :
           TrfSizeDstCo     = {14{1'b0}};
      endcase
    end
  // when SWidth is lesser than DWidth
  else
    begin
      case (SWidthDWidth)
        // when SWidth = DWidth / 2
        6'b000001 :
          TrfSizeDstCo     = {3'b000, TrfSizeSrc[11:1]};
        // when SWidth = DWidth / 2
        6'b001010 :
          TrfSizeDstCo     = {3'b000, TrfSizeSrc[11:1]};
        // when SWidth = DWidth / 4
        6'b000010 :
          TrfSizeDstCo     = {4'b0000, TrfSizeSrc[11:2]};
        default :
          TrfSizeDstCo     = {14{1'b0}};
      endcase
    end
end // p_DvdFctr2Comb : 

// -----------------------------------------------------------------------------
// Precalculating the decremented TrfSizeSrc.
// -----------------------------------------------------------------------------
assign InTrfSizeDst     = TrfSizeDst - 1'b1;

// -----------------------------------------------------------------------------
// TrfSizeDst register is to be loaded with TrfSizeSrc multiplied by a factor.
// The factor is SWidth/DWidth. This register cannot be loaded at the time of
// control-register write, as the DWidth and SWidth values might not be valid
// at the time of programming. Thus it is loaded when the LLI loading has
// finished or when the Channel is getting enabled.
// -----------------------------------------------------------------------------
always @(RegChEnHigh or FinishedLLI or DecTrfSizeDst or TrfSizeDst or
         TrfSizeDstCo or InTrfSizeDst)
begin : p_TrfSizeDstComb
  // When the channel is enabled, the TrfSizeDst is loaded with TrfSizeSrc
  // multiplied by (SWidth/DWidth) factor.
  if (RegChEnHigh == 1'b1)
     NextTrfSizeDst   = TrfSizeDstCo;
  else if (FinishedLLI == 1'b1)
     NextTrfSizeDst   = TrfSizeDstCo;
  else if (DecTrfSizeDst == 1'b1)
     NextTrfSizeDst   = InTrfSizeDst;
  // when the register does not need to be updated or invalid-conditions
  else
     NextTrfSizeDst   = TrfSizeDst;
end // p_TrfSizeDstComb

// -----------------------------------------------------------------------------
// Sequential block for p_TrfSizeDstComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_TrfSizeDstSeq
  if (HRESETn == 1'b0)
    TrfSizeDst       <= {14{1'b0}};
  else
    TrfSizeDst       <= NextTrfSizeDst;
end // p_TrfSizeDstSeq

// -----------------------------------------------------------------------------
// ChannelEnLow is taken to '1' whenever the ChannelEnable bit (HWDATA(0)) is
// written with a '0' from AHB Slave side.
// -----------------------------------------------------------------------------
assign ChannelEnLow    = DmacChCnfgSel & RegHWrite & ~(HWDATA[0]);

// -----------------------------------------------------------------------------
// Whenever ChannelEn bit in DMACChConfig register is written with 1, SourceEn
// and DestEn bits are set. Whenever the ChannelEnable bit is written with
// 0, the SourceEn and DestEn bits are cleared.
// -----------------------------------------------------------------------------
always @(ChannelEnHigh or ChannelEnLow or SourceEn or DestEn)
begin : p_EnableComb
  if (ChannelEnHigh == 1'b1)
    begin
      NextSourceEn     = 1'b1;
      NextDestEn       = 1'b1;
    end
  else if (ChannelEnLow == 1'b1)
    begin
      NextSourceEn     = 1'b0;
      NextDestEn       = 1'b0;
    end
  // when no writes are attempted to Channel Enable bit or invalid-condition
  else
    begin
      NextSourceEn     = SourceEn;
      NextDestEn       = DestEn;
    end
end // p_EnableComb

// -----------------------------------------------------------------------------
// Sequential block for p_EnableComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_EnableSeq
  if (HRESETn == 1'b0)
    begin
      SourceEn         <= 1'b0;
      DestEn           <= 1'b0;
    end
  else
    begin
      SourceEn         <= NextSourceEn;
      DestEn           <= NextDestEn;
    end
end // p_EnableSeq

// -----------------------------------------------------------------------------
// The following process describes the combinational part of SrcErred bit. The
// SrcErr signal comes from the source-state-machine at suitable error
// conditions. When SrcErred bit is set to 1, and the destination-DMAC state
// reaches IDLE, the p_ChannelEnComb-process disables the channel. The SrcErred
// bit needs to be cleared at this time and that is done by the following
// process.
// -----------------------------------------------------------------------------
always @(SrcErr or SrcErred or DstDmacState)
begin : p_SrcErredComb
  if (SrcErr == 1'b1)
    NextSrcErred     = 1'b1;
  else if ((SrcErred == 1'b1) && (DstDmacState == `ST_DST_IDLE))
    NextSrcErred     = 1'b0;
  else
    NextSrcErred     = SrcErred;
end // p_SrcErredComb

// -----------------------------------------------------------------------------
// Sequential process for p_SrcErredComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SrcErredSeq
  if (HRESETn == 1'b0)
    SrcErred         <= 1'b0;
  else
    SrcErred         <= NextSrcErred;
end // p_SrcErredSeq

// -----------------------------------------------------------------------------
// The following process describes the combinational part of DstErred bit. The
// DstErr signal comes from the destination-state-machine at suitable error
// conditions. When DstErred bit is set to 1, and the source-DMAC state
// reaches IDLE, the p_ChannelEnComb-process disables the channel. The DstErred
// bit needs to be cleared at this time and that is done by the following
// process.
// -----------------------------------------------------------------------------
always @(DstErr or DstErred or SrcDmacState)
begin : p_DstErredComb
  if (DstErr == 1'b1)
    NextDstErred     = 1'b1;
  else if ((DstErred == 1'b1) && (SrcDmacState == `ST_SRC_IDLE))
    NextDstErred     = 1'b0;
  else
    NextDstErred     = DstErred;
end // p_DstErredComb

// -----------------------------------------------------------------------------
// Sequential process for p_DstErredComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DstErredSeq
  if (HRESETn == 1'b0)
    DstErred         <= 1'b0;
  else
    DstErred         <= NextDstErred;
end // p_DstErredSeq

// -----------------------------------------------------------------------------
// At the time of enabling the channel, the DisabledSrc bit should be reset. It
// should be set, when the source-state-machine signals SrcDisable. When both
// DisabledSrc and DisabledDst are set, the channel is 'actually' disabled.
// -----------------------------------------------------------------------------
always @(ChannelEnHigh or SrcDisable or DisabledSrc)
begin : p_SrcDisableComb
  if ((ChannelEnHigh == 1'b0) && (SrcDisable == 1'b0))
    NextDisabledSrc  = DisabledSrc;
  else if ((ChannelEnHigh == 1'b1) && (SrcDisable == 1'b0))
    NextDisabledSrc  = 1'b0;
  else if (SrcDisable == 1'b1)
    NextDisabledSrc  = 1'b1;
  else
    NextDisabledSrc  = DisabledSrc;
end // p_SrcDisableComb

// -----------------------------------------------------------------------------
// Sequential block for p_SrcDisableComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SrcDisableSeq
  if (HRESETn == 1'b0)
    DisabledSrc      <= 1'b0;
  else
    DisabledSrc      <= NextDisabledSrc;
end // p_SrcDisableSeq

// -----------------------------------------------------------------------------
// At the time of enabling the channel, the DisabledDst bit should be reset. It
// should be set, when the Dest-state-machine signals DstDisable. When both
// DisabledSrc and DisabledDst are set, the channel is 'actually' disabled.
// -----------------------------------------------------------------------------
always @(ChannelEnHigh or DstDisable or DisabledDst)
begin : p_DstDisableComb
  if ((ChannelEnHigh == 1'b0) && (DstDisable == 1'b0))
    NextDisabledDst  = DisabledDst;
  else if ((ChannelEnHigh == 1'b1) && (DstDisable == 1'b0))
    NextDisabledDst  = 1'b0;
  else if (DstDisable == 1'b1)
    NextDisabledDst  = 1'b1;
  else
    NextDisabledDst  = DisabledDst;
end // p_DstDisableComb

// -----------------------------------------------------------------------------
// Sequential block for p_DstDisableComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DstDisableSeq
  if (HRESETn == 1'b0)
    DisabledDst      <= 1'b0;
  else
    DisabledDst      <= NextDisabledDst;
end // p_DstDisableSeq

// -----------------------------------------------------------------------------
// The following block does the final disable (be it due to error or disable or
// normal packet-termination. This block resets the read and write pointers in
// the FIFO at the time of 'actual channel disable'.
// In case of error, the error-interrupt is set. But the interrupt request is
// not raised immediately after an error response. In case of dual AHB (source
// and destination on different ports), interrupt is raised if there is an error
// on one/both AHB AND both source and destination bursts have finished.
// -----------------------------------------------------------------------------
always @(ChannelEnHigh or ChannelEn or SrcErred or SrcDmacState or DstErred
         or DisabledDst or DstDmacState or LLIErr or DisabledLLI or
         FinishedLLI)
begin : p_ChannelEnComb
  // Default assignments
  NextFifoPtrReset = 1'b0;
  SetIntErr        = 1'b0;
  NextChannelEn    = ChannelEn;
  UnsetErrMsk      = 1'b0;

  if (ChannelEnHigh == 1'b1)
     NextChannelEn    = 1'b1;
  else if (((SrcErred == 1'b1) && (DstDmacState == `ST_DST_IDLE)) ||
           ((DstErred == 1'b1) && (SrcDmacState == `ST_SRC_IDLE)))
    begin
      NextChannelEn    = 1'b0;
      NextFifoPtrReset = 1'b1;
      // No request should be routed to Internal arbiter from the point "when
      // source/destination gets the error response" to the point "when the
      // channel is actually disabled". This is handled by ErrMsk. This mask is
      // "unset" at the time of resetting of Channel-Enable.
      UnsetErrMsk      = 1'b1;
      // set the error interrupt for the channel.
      SetIntErr        = 1'b1;
    end
  // In any transfer, destination is the second one to get disabled after source
  // (may be due to Software disable or due to normal channel completion). Thus
  // the combination of destination-getting-disabled and source remaining IDLE
  // is taken for making ChannelEn '0' and resetting the pointers. The converse,
  // i.e. source-getting-disabled and destination remaining in IDLE state should
  // not be taken, as after an end of a normal-transfer, the condition that
  // 'source might have been disabled but the destination transfers are
  // remaining' may "legally" arise.
  else if ((SrcDmacState == `ST_SRC_IDLE) && (DisabledDst == 1'b1))
    begin
      NextChannelEn    = 1'b0;
      NextFifoPtrReset = 1'b1;
    end
  else if (((LLIErr == 1'b1) || (DisabledLLI == 1'b1)) &&
           (DstDmacState == `ST_DST_IDLE) && (SrcDmacState == `ST_SRC_IDLE))
    begin
      NextChannelEn    = 1'b0;
      NextFifoPtrReset = 1'b1;
    end
  else if (FinishedLLI == 1'b1)
    NextFifoPtrReset = 1'b1;
end // p_ChannelEnComb

// -----------------------------------------------------------------------------
// Sequential process for Channel Enable and FifoPtrReset signal.
// FifoPtrReset is also being clocked out to break the combinational path from
// AHB slave HWDATA to Fifo Reg file.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ChanneEnSeq
  if (HRESETn == 1'b0)
    begin
      ChannelEn        <= 1'b0;
      FifoPtrReset     <= 1'b0;
    end
  else
    begin
      ChannelEn        <= NextChannelEn;
      FifoPtrReset     <= NextFifoPtrReset;
    end
end // p_ChanneEnSeq

// -----------------------------------------------------------------------------
// The following process describes a mux, which muxes out the data of one of
// the five channel registers (namely, DMACChSrcAddr, DMACChDstAddr,
// DMACChControl, DMACChLLIReg and DMACChConfig). The output of the mux is
// clocked and ORed at the top-level to be driven on the AHB as HRDATA.
// -----------------------------------------------------------------------------
always @(DmacChannelSel or RegAddress or DMACChSrcAddr or DMACChDstAddr or
         DMACChLLIReg or LLIMastSlct or DMACChControl or SWidth or DWidth or
         TrfSizeDst or Halt or DMACChConfig or ChannelEn or FifoNonEmpty)
begin : p_ChRdDataComb
  DmacSrcRegSel    = 1'b0;
  DmacDestRegSel   = 1'b0;
  DmacLLIRegSel    = 1'b0;
  DmacCntlRegSel   = 1'b0;
  DmacChCnfgSel    = 1'b0;
  NextChHRDATA     = {32{1'b0}};
  if (DmacChannelSel == 1'b1)
    begin
      case (RegAddress)
        `HADDR_DMACCHSRCADDR :
          begin
           DmacSrcRegSel    = 1'b1;
           NextChHRDATA     = DMACChSrcAddr;
          end
        `HADDR_DMACCHDESTADDR :
          begin
            DmacDestRegSel   = 1'b1;
            NextChHRDATA     = DMACChDstAddr;
          end
        `HADDR_DMACCHLLIREG :
          begin
            DmacLLIRegSel    = 1'b1;
            NextChHRDATA     = {DMACChLLIReg, 1'b0, LLIMastSlct};
          end
        `HADDR_DMACCHCONTROL :
          begin
            DmacCntlRegSel   = 1'b1;
            ChRdDataCombJ    = DivideFactor(SWidth, DWidth, TrfSizeDst);
            NextChHRDATA     = {DMACChControl, ChRdDataCombJ[11:0]};
          end
        `HADDR_DMACCHCONFIG :
          begin
            DmacChCnfgSel    = 1'b1;
            NextChHRDATA     = {{13{1'b0}}, Halt, FifoNonEmpty,
                                DMACChConfig[16:1], ChannelEn};
          end
        default :
          begin
            NextChHRDATA     = {32{1'b0}};
            // synopsys translate_off
            $display($time, "DmacChRegBlock1 : Reserved address space in the",
                     " DMAC channel is accessed");
            // synopsys translate_on
          end
      endcase
    end
end // p_ChRdDataComb

// -----------------------------------------------------------------------------
// Sequential block for NextChHRDATA.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ChRdDataSeq
  if (HRESETn == 1'b0)
    ChHRDATA         <= {32{1'b0}};
  else
    ChHRDATA         <= NextChHRDATA;
end // p_ChRdDataSeq

// -----------------------------------------------------------------------------
// The following statements splits the bit-fields of DMACChControl register.
// -----------------------------------------------------------------------------
assign SBSize           = DMACChControl[14:12];
assign DBSize           = DMACChControl[17:15];
assign SWidth           = DMACChControl[20:18];
assign DWidth           = DMACChControl[23:21];
assign SrcSelect        = DMACChControl[24];
assign DstSelect        = DMACChControl[25];
assign SrcIncr          = DMACChControl[26];
assign DestIncr         = DMACChControl[27];
assign ProtStat         = DMACChControl[30:28];
assign IntTCEnable      = DMACChControl[31];

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// The ChannelEn bit, once set to 1, should not be written with a 1 again,
// unless it is disabled.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_Wr1EnChnlProt
  if ((ChannelEnHigh & ChannelEn) == 1'b1)
    $display($time, "DmacChRegBlock2 : Channel-Enable written 1, when already",
             " high");
end // p_Wr1EnChnlProt

// -----------------------------------------------------------------------------
// The source address register can be written from three sources.
// 1. LLI loading operation
// 2. AHB Slave programming
// 3. Update from channel logic with latest address.
// In normal condition, only one signal among above 3 should be active at a
// time.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_SrcWrSimulProt
    if (((SrcAddrUpdate & LLISrcWr) || (LLISrcWr & SrcAddrWrEn) ||
        (SrcAddrUpdate & SrcAddrWrEn)) == 1'b1)
      $display($time, "DmacChRegBlock3 : SrcAddr Register is written",
               " simultaneously");
end // p_SrcWrSimulProt

// -----------------------------------------------------------------------------
// The destination address register can be written from three sources.
// 1. LLI loading operation
// 2. AHB Slave programming
// 3. Update from channel logic with latest address.
// In normal condition, only one signal among above 3 should be active at a
// time.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_DstWrSimulProt
  if (((DstAddrUpdate & LLIDstWr) | (LLIDstWr & DstAddrWrEn) |
      (DstAddrUpdate & DstAddrWrEn)) == 1'b1)
    $display($time, "DmacChRegBlock4 : DstAddr Register is written",
             " simultaneously");
end // p_DstWrSimulProt

// -----------------------------------------------------------------------------
// The TrfSize bit field in control register can be written from three sources.
// 1. LLI loading operation
// 2. AHB Slave programming
// 3. Update from channel logic with. (DecTrfSizeSrc)
// The rest of the bits are not updated from channel-logic. They are written
// into only during AHB Slave programming and LLI loading.
// In normal condition, only one signal among above 3 should be active at a
// time.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_CntlWrSimlProt
  if (((DecTrfSizeSrc & LLIWrEn) | (LLICntlWr & LLIWrEn) |
      (DecTrfSizeSrc & LLICntlWr)) == 1'b1)
    $display($time, "DmacChRegBlock5 : Control Register is written",
             " simultaneously");
end // p_CntlWrSimlProt

// -----------------------------------------------------------------------------
// The LLI register is written from two sources
// 1. AHB Slave programming
// 2. LLI loading operation.
// In normal condition, only one signal among above 2 should be active at a
// time.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_LLIWrSimulProt
  if ((LLILLIRegWr & LLIWrEn) == 1'b1)
    $display($time, "DmacChRegBlock6 : LLI register is written simultaneously");
end // p_LLIWrSimulProt

// -----------------------------------------------------------------------------
// If the SWidth is less than DWidth, then there are restrictions on the value
// that can be programmed into TrfSize register.
// o If SWidth = DWidth/2, then the TrfSizeSrc should be a multiple of 2.
//   Otherwise protocol violation is flagged.
// o If SWidth = DWidth/4, then the TrfSizeSrc should be a multiple of 4.
//   Otherwise protocol violation is flagged.
//
// The source address and destination-address values programmed into the channel
// registers should be aligned according to the values programmed in SWidth and
// DWidth bit-fields in DmacChControl register. The following process checks for
// the alignment also.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrfSizeChkProt
  // The check is to be performed when the channel is initially programmed
  // with incorrect values.
  if ((ChannelEnHigh == 1'b1) && (ChannelEn == 1'b0))
  begin
    if (IsDMAFlowCntl(FlowCntl[2:1]))
      begin
        // When SWidth is lesser than DWidth
        if (SWidth < DWidth)
          begin
            case (SWidthDWidth)
              // TrfSizeDstCo = TrfSizeSrc/2. If remainder is non zero, flash
              // protocol violation.
              6'b000001 :
                if (TrfSizeSrc[0] == 1'b1)
                  $display($time, "Warning : DmacChRegBlock7 : TrfSize",
                           " programmed to illegal value");
              6'b001010 :
                if (TrfSizeSrc[0] == 1'b1)
                  $display($time, "Warning : DmacChRegBlock8 : TrfSize",
                           " programmed to illegal value");
              // TrfSizeDstCo = TrfSizeSrc/4. If remainder is non zero, flash
              // protocol violation.
              6'b000010 :
                if ((TrfSizeSrc[0] | TrfSizeSrc[1]) == 1'b1)
                  $display($time, "Warning : DmacChRegBlock9: TrfSize",
                           " programmed to illegal value");
              default :;
            endcase
          end
      end

      // checking for source-address and destination-address alignment
      if (SWidth == 3'b001)
        if (DMACChSrcAddr[0] != 1'b0)
          $display($time, "Warning : DmacChRegBlock10: Source address is not",
                   " half-word aligned");
      else if (SWidth == 3'b010)
        if (DMACChSrcAddr[1:0] != 2'b00)
          $display($time, "Warning : DmacChRegBlock11: Source address is not",
                   " word aligned");
      if (DWidth == 3'b001)
        if (DMACChDstAddr[0] != 1'b0)
          $display($time, "Warning : DmacChRegBlock12 : Destination address is",
                   " not half-word aligned");
      else if (DWidth == 3'b010)
      begin
        if (DMACChDstAddr[1:0] != 2'b00)
          $display($time, "Warning : DmacChRegBlock13 : Destination address is",
                   " not word aligned");
      end
  end
end // p_TrfSizeChkProt : 

// -----------------------------------------------------------------------------
// The following protocol checker checks for the programmed source or
// destination width to be lesser than 32 bit.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_WidthViolProt
  if (ChannelEn == 1'b1)
    begin
      if (SWidth > 3'b010)
        $display($time, "DmacChRegBlock14 : Source Width is greater than AHB",
                 " buswidth");
      if (DWidth > 3'b010)
        $display($time, "DmacChRegBlock15 : Source Width is greater than AHB",
                 " buswidth");
    end
end // p_WidthViolProt

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule

// --================================== End ==================================--
