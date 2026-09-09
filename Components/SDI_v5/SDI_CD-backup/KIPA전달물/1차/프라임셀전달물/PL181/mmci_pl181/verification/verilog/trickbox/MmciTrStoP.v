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
// File Name              : MmciTrStoP.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           MMCI Trickbox Serial to parallel convertor and receiver
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciTrStoP (
// Inputs
                  MMCICLK,
                  nMMCIRST,
                  DataLength,
                  Blocklen,
                  RxCommand,
                  SendResponse,
                  CmdEnable,
                  DataEn,
                  DataDirection,
                  DataMode,
                  TokenSent,
                  MDCStg2WrEn,
                  CRC7,
                  CRC160,
                  MMCICMDIn,
                  MMCIDATIn,
// Outputs
                  MMCITBRxdCIndS2,
                  MMCITBRxdCArgS2,
                  MTBCIUpdate,
                  MTBCAUpdate,
                  DataCnt,
                  BitCnt,
                  RxFWr,
                  CmdCrcErrStat,
                  CTxBitCheckErr,
                  RCRC7En,
                  RCRC16En,
                  DataRxd,
                  RxFWrData
                  );

// Inputs
input         MMCICLK;        // MMCI Bus Clock
input         nMMCIRST;       // APB Bus Reset
input  [15:0] DataLength;     // Number of data bytes to be rxd
input   [3:0] Blocklen;       // Num of bytes in a block
input         RxCommand;      // Qualifies cmd reception
input         SendResponse;   // Qualifies resp transmission
input         CmdEnable;      // Cmd Path Enable
input         DataEn;         // Data Path Enable
input         DataDirection;  // Direction of data
input         DataMode;       // Mode of Data-Block, Stream
input         TokenSent;      // Qualifies token bits
input         MDCStg2WrEn;    // Indictes any write to DataCtrl
                              // register.
input   [6:0] CRC7;           // Computed CRC7 value
input  [15:0] CRC160;         // Computed CRC16 value
input         MMCICMDIn;      // MMCI Command Path
input         MMCIDATIn;      // MMCI Data Path

// Outputs
output  [5:0] MMCITBRxdCIndS2; // Command Index received
output [31:0] MMCITBRxdCArgS2; // Command argument recd
output        MTBCIUpdate;     // Updt signal for Cmd Ind
output        MTBCAUpdate;     // Updt signal for Cmd Arg
output [15:0] DataCnt;         // Indicates num of bytes of data
                               // remaining
output  [2:0] BitCnt;          // Counts each bit of data rxd
output        RxFWr;           // WrEnable for Rx FIFO
output        CmdCrcErrStat;   // Error Status of Cmd CRC
output        CTxBitCheckErr;  // Indicates any Tx Bit Error
output        RCRC7En;         // Enable for CRC7
output        RCRC16En;        // Enable for CRC16
output        DataRxd;         // Qualifies that data reception is over
output [32:0] RxFWrData;       // Rx Fifo write data

// Inputs
wire        MMCICLK;           // MMCI Bus Clock
wire        nMMCIRST;          // APB Bus Reset
wire [15:0] DataLength;        // Number of data bytes to be rxd
wire  [3:0] Blocklen;          // Num of bytes in a block
wire        RxCommand;         // Qualifies cmd reception
wire        SendResponse;      // Qualifies resp transmission
wire        CmdEnable;         // Cmd Path Enable
wire        DataEn;            // Data Path Enable
wire        DataDirection;     // Direction of data
wire        DataMode;          // Mode of Data-Block, Stream
wire        TokenSent;         // Qualifies token bits
wire        MDCStg2WrEn;       // Indictes any write to DataCtrl
                               // register.
wire  [6:0] CRC7;              // Computed CRC7 value
wire [15:0] CRC160;            // Computed CRC16 value
wire        MMCICMDIn;         // MMCI Command Path
wire        MMCIDATIn;         // MMCI Data Path

// Outputs
wire  [5:0] MMCITBRxdCIndS2;   // Command Index received
wire [31:0] MMCITBRxdCArgS2;   // Command argument recd
wire        MTBCIUpdate;       // Updt signal for Cmd Ind
wire        MTBCAUpdate;       // Updt signal for Cmd Arg
wire [15:0] DataCnt;           // Indicates num of bytes of data
                               // remaining
wire  [2:0] BitCnt;            // Counts each bit of data rxd
wire        RxFWr;             // WrEnable for Rx FIFO
reg         CmdCrcErrStat;     // Error Status of Cmd CRC
reg         CTxBitCheckErr;    // Indicates any Tx Bit Error
reg         RCRC7En;           // Enable for CRC7
reg         RCRC16En;          // Enable for CRC16
wire        DataRxd;           // Qualifies that data reception is over
wire [32:0] RxFWrData;         // Rx Fifo write data

// -----------------------------------------------------------------------------
//
//                                 MmciTrStoP
//                                 ==========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//  MmciTrStoP is the serial to parallel convertor block.It starts to
// receive command and data bits, once the startbit is received and
// shifts these bits till the end bit is received or a word boundary is
// reached (in case of data) . It moves the shift register contents
// to respective registers.
// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        CmdBit;
// Command Bit received

wire        DataBit0;
// Data Bit received on line 0

wire [31:0] ZEROFILL;
// Register filled with zeros

wire [15:0] IntDataLength;
// Number of bytes of data to be recd

wire  [3:0] IntBlocklen;
// Number of bytes of data in a block, as powers of 2

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         DelCmdBit;
// Delayed version of Command Bit received

reg         CmdSBit;
// Qualifies start bit of Command path

reg         DelDataBit0;
// Delayed version of Data Bit received on line 0

reg         DataSBit0;
// Qualifies start bit of data on line 0

reg         CTxBitCheck;
// Qualifies the reception of Transmit bit in command field

reg         CStartStoP;
// Qualifies the reception of Command Bits

reg         DelCStartStoP;
// Delayed version of CStartStoP

reg         DelCmdSBit;
// Delayed version of CmdSbit

reg         DelCTxBitCheck;
// Delayed version of CTxBitCheck

reg         DStartStoP0;
// Qualifies the reception of Data Bits on line 0

reg         DelDStartStoP0;
// Delayed version of DStartStoP0

reg         DelDataSBit0;
// Delayed version of DataSBit0

reg  [45:0] CmdStoreReg;
// Register to store the recd command

reg   [5:0] NextMTBRxdCIndS2;
// D-Input to MMCITBRxdCIndS2 register

reg   [5:0] iMMCITBRxdCIndS2;
// local copy of MMCITBRxdCIndS2 register

reg  [31:0] NextMTBRxdCArgS2;
// D-Input to MMCITBRxdCArgS2 register

reg  [31:0] iMMCITBRxdCArgS2;
// local copy of MMCITBRxdCArgS2 register

reg         iMTBCIUpdate;
// Update signal for Command Index register

reg         NextMTBCIUpdate;
// D-Input to iMTBCIUpdate

reg         iMTBCAUpdate;
// Update signal for Command Argument register

reg         NextMTBCAUpdate;
// D-Input to iMTBCAUpdate

reg  [31:0] DataReg;
// Register to store the recd and shifted data bits

reg  [31:0] ShiftDataReg;
// Register to shift the incoming data bits

reg         RxCRCBit;
// Qualifies the reception of CRC bits

reg         DataCrcFail;
// Gives Crc error status of the recd data

reg         DelDataRxd;
// Delayed version of iDataRxd

reg         iDataRxd;
// Qualifies the reception of data bits

reg         RCRC160;
// Internal enable signal for CRC16 Calculation on line 0

reg         IntRxFWr;
// Internal write enable for Rx FIFO

reg         CmdEBit;
// Qualifies end bit on commmand line

reg         DataEBit0;
// Qualifies end bit on data line 0

reg  [11:0] IntBlkCnt;
// Number of bytes of data in a block, for internal purpose

reg  [15:0] iDataCnt;
// Number of bytes of data remaining in the transfer

reg  [11:0] BlkCnt;
// Number of bytes of data in a block

reg   [1:0] WrdCnt;
// Counts every byte of data recd

reg   [2:0] iBitCnt;
// Counts every bit of data recd

reg         LoadCounters;
// Enables loading of DataCnt and BlkCnt

reg         LoadOver;
// Indicates that loading of counters is over

reg   [1:0] BytePos;
// Used to write data correctly into the Rx FIFO when Blocklen or
// DataLength < 4

reg   [1:0] NextBytePos;
// D-Input to BytePos

reg         DataEnd;
// Indicates end of data in stream mode data transfer

reg         status;
// Used to generate BytePos

reg         DelIntRxFWr;
// Delayed version of IntRxFWr

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
// Initialisations
// -----------------------------------------------------------------------------
initial
begin : p_Initialisations
  IntBlkCnt   = 12'h000;
  iDataCnt    = 16'h0000;
  BlkCnt      = 12'h000;
  WrdCnt      = 2'b00;
  iBitCnt     = 3'b111;
end // p_Initialisations

// -----------------------------------------------------------------------------
//  Filling ZEROFILL register with zeros
// -----------------------------------------------------------------------------
assign ZEROFILL         = 32'h00000000;

// -----------------------------------------------------------------------------
//  Driving CmdBit with the MMCICMDIn
// -----------------------------------------------------------------------------
assign CmdBit           = (CmdEnable == 1'b1 && RxCommand == 1'b1) ?
                           MMCICMDIn : 1'bZ;

// -----------------------------------------------------------------------------
//  Driving outputs with local copies
// ----------------------------------------------------------------------------
assign MMCITBRxdCIndS2  = iMMCITBRxdCIndS2;
assign MMCITBRxdCArgS2  = iMMCITBRxdCArgS2;
assign DataCnt          = iDataCnt;
assign BitCnt           = iBitCnt;
assign MTBCIUpdate      = iMTBCIUpdate;
assign MTBCAUpdate      = iMTBCAUpdate;

// -----------------------------------------------------------------------------
//  Delayed version of CmdBit
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelayCmdBit
  if (nMMCIRST ==  1'b0)
    DelCmdBit   <= 1'b0;
  else
    begin
      DelCmdBit <= CmdBit;
    end
end // p_DelayCmdBit

// -----------------------------------------------------------------------------
//  Process detects the Command path start and end bit
// -----------------------------------------------------------------------------
always @(CmdBit or DelCmdBit or RxCommand or nMMCIRST)
begin : p_StartnEndBit
  if (nMMCIRST ==  1'b0)
    begin
      CmdSBit  = 1'b0;
      CmdEBit  = 1'b0;
      RCRC7En  = 1'b0;
    end
  else if ((DelCmdBit === 1'bZ) && (~CmdBit & RxCommand))
    begin
      CmdSBit  = 1'b1;
      RCRC7En  = 1'b1;
    end
  else if (CmdBit === 1'bZ && (DelCmdBit & RxCommand & CmdEnable))
    begin
      RCRC7En  = 1'b0;
      CmdEBit  = 1'b1;
    end
  else
    begin
      CmdSBit  = 1'b0;
      CmdEBit  = 1'b0;
    end
end //  p_StartnEndBit

// -----------------------------------------------------------------------------
//  Process checks whether a proper Tx bit has been transmitted by MMCI
// -----------------------------------------------------------------------------
always @(CmdSBit or CmdBit or DelCmdSBit)
begin : p_CTxBitCheck
  if (DelCmdSBit & ~CmdSBit)
    if (CmdBit)
      CTxBitCheck    = 1'b1;
    else
      CTxBitCheckErr = 1'b1;
  else
    begin
      CTxBitCheck      = 1'b0;
      CTxBitCheckErr   = 1'b0;
    end
end // p_CTxBitCheck

// -----------------------------------------------------------------------------
//  CStartStoP generated by this process qualifies the reception of
// command bits
// -----------------------------------------------------------------------------
always @(CTxBitCheck or CmdBit or DelCmdBit or DelCStartStoP or
         DelCTxBitCheck)
begin : p_CStartStoP
  if (DelCTxBitCheck & ~CTxBitCheck)
    CStartStoP = 1'b1;
  else if ((CmdBit === 1'bZ) && (DelCmdBit == 1'b1))
    CStartStoP = 1'b0;
  else
    CStartStoP = DelCStartStoP;
end // p_CStartStoP

// -----------------------------------------------------------------------------
//  Delayed version of CStartStoP
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelayCStartStoP
  if (nMMCIRST == 1'b0)
     DelCStartStoP <= 1'b0;
  else
    if (CmdEnable == 1'b1)
      DelCStartStoP <= CStartStoP;
    else
      DelCStartStoP <= 1'b0;
end // p_DelayCStartStoP

// -----------------------------------------------------------------------------
//  Delayed version of CmdSBit
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelayCmdSBit
  if (nMMCIRST ==  1'b0)
    DelCmdSBit <= 1'b0;
  else
    DelCmdSBit <= CmdSBit;
end // p_DelayCmdSBit

// -----------------------------------------------------------------------------
//  Delayed version of CTxBitCheck
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelayCTxBitCheck
  if (nMMCIRST ==  1'b0)
    DelCTxBitCheck <= 1'b0;
  else
    DelCTxBitCheck <= CTxBitCheck;
end // p_DelayCTxBitCheck

// -----------------------------------------------------------------------------
//  Shifting in of the recd command bit
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_CmdStoreComb
  if (nMMCIRST ==  1'b0)
     CmdStoreReg <= 46'h000000000000;
  else
    if (CStartStoP == 1'b1)
      begin
        CmdStoreReg[45:1] <= CmdStoreReg[44:0];
        CmdStoreReg[0]    <= CmdBit;
      end
end // p_CmdStoreComb

// -----------------------------------------------------------------------------
//  Transfering the respective command fields to their registers
// -----------------------------------------------------------------------------
always @(CmdEBit or nMMCIRST or CmdStoreReg or iMTBCIUpdate or
         iMTBCAUpdate or iMMCITBRxdCIndS2 or iMMCITBRxdCArgS2)
begin : p_CmdStoreTransfer
  if (nMMCIRST == 1'b0)
    begin
      NextMTBRxdCIndS2 = 6'h00;
      NextMTBRxdCArgS2 = 32'h00000000;
      NextMTBCIUpdate  = 1'b0;
      NextMTBCAUpdate  = 1'b0;
    end
  else if (CmdEBit == 1'b1)
    begin
      NextMTBRxdCIndS2 = CmdStoreReg[45:40];
      NextMTBRxdCArgS2 = CmdStoreReg[39:8];
      NextMTBCIUpdate  = ~(iMTBCIUpdate);
      NextMTBCAUpdate  = ~(iMTBCAUpdate);
    end
  else
    begin
      NextMTBRxdCIndS2 = iMMCITBRxdCIndS2;
      NextMTBRxdCArgS2 = iMMCITBRxdCArgS2;
      NextMTBCIUpdate  = iMTBCIUpdate;
      NextMTBCAUpdate  = iMTBCAUpdate;
    end
end // p_CmdStoreTransfer

// -----------------------------------------------------------------------------
//  Clocking the command fields into registers
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_CmdRegWr
  if (nMMCIRST ==  1'b0)
    begin
      iMMCITBRxdCIndS2 <= 6'h00;
      iMMCITBRxdCArgS2 <= 32'h00000000;
      iMTBCIUpdate     <= 1'b0;
      iMTBCAUpdate     <= 1'b0;
    end
  else
    begin
      iMMCITBRxdCIndS2 <= NextMTBRxdCIndS2;
      iMMCITBRxdCArgS2 <= NextMTBRxdCArgS2;
      iMTBCIUpdate     <= NextMTBCIUpdate;
      iMTBCAUpdate     <= NextMTBCAUpdate;
    end
end // p_CmdRegWr

// -----------------------------------------------------------------------------
//          Data Path related Serial to Parallel conversion.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Making internal versions
// -----------------------------------------------------------------------------

assign IntDataLength    = DataLength;
assign IntBlocklen      = Blocklen;
assign DataRxd          = iDataRxd;

// -----------------------------------------------------------------------------
// Block length conversion from powers of two to actual number of bytes
// -----------------------------------------------------------------------------
always @(IntBlocklen or nMMCIRST)
begin : p_BlkCntcal
  if (nMMCIRST == 1'b0)
    IntBlkCnt <= 12'h000;
  else
    case (IntBlocklen)
      4'b0000 : IntBlkCnt = 12'b000000000001;
      4'b0001 : IntBlkCnt = 12'b000000000010;
      4'b0010 : IntBlkCnt = 12'b000000000100;
      4'b0011 : IntBlkCnt = 12'b000000001000;
      4'b0100 : IntBlkCnt = 12'b000000010000;
      4'b0101 : IntBlkCnt = 12'b000000100000;
      4'b0110 : IntBlkCnt = 12'b000001000000;
      4'b0111 : IntBlkCnt = 12'b000010000000;
      4'b1000 : IntBlkCnt = 12'b000100000000;
      4'b1001 : IntBlkCnt = 12'b001000000000;
      4'b1010 : IntBlkCnt = 12'b010000000000;
      4'b1011 : IntBlkCnt = 12'b100000000000;
      default : IntBlkCnt = 12'b000000000001;
    endcase
end // p_BlkCntcal

// -----------------------------------------------------------------------------
// Tapping the MMCIDATIn bus
// -----------------------------------------------------------------------------

assign DataBit0         = (DataDirection == 1'b0 && DataEn == 1'b1) ?
                           MMCIDATIn : 1'bZ;

// -----------------------------------------------------------------------------
// Delayed version of DataBit
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelayDataBit
  if (nMMCIRST ==  1'b0)
    begin
      DelDataBit0 <= 1'b0;
    end
  else
    if (DataEn == 1'b1)
      begin
         DelDataBit0 <= DataBit0;
      end
    else
      begin
        DelDataBit0  <= 1'b0;
      end
end // p_DelayDataBit

// -----------------------------------------------------------------------------
// Process detects the Data path start and end bit and also enables the
// CRC16 calculation for line 0
// -----------------------------------------------------------------------------
always @(DataBit0 or DelDataBit0 or nMMCIRST or MDCStg2WrEn)
begin : p_DStartnEndBit0
  if (nMMCIRST ==  1'b0 || MDCStg2WrEn == 1'b1)
    RCRC160 = 1'b0;
  else if (DelDataBit0 === 1'bZ && DataBit0 == 1'b0)
    begin
      DataSBit0 = 1'b1;
      if (~DataMode)
        RCRC160 = 1'b1;
    end
  else if (DelDataBit0 == 1'b1 && DataBit0 === 1'bZ)
    begin
      DataEBit0 = 1'b1;
      if (~DataMode)
        RCRC160 = 1'b0;
    end
  else
    begin
      DataSBit0 = 1'b0;
      DataEBit0 = 1'b0;
    end
end // p_DStartnEndBit0

// -----------------------------------------------------------------------------
//  Generating the CRC enable
// -----------------------------------------------------------------------------
always @(RCRC160 or DataMode)
begin : p_Crc16En
  if (~DataMode)
      RCRC16En <= RCRC160;
end // p_Crc16En

// -----------------------------------------------------------------------------
//  DStartStoP0 generated by this process qualifies the reception of
// data bits
// -----------------------------------------------------------------------------
always @(DataSBit0 or DataBit0 or DelDataBit0 or DelDStartStoP0)
begin : p_DStartStoP0
  if (DelDataSBit0 & ~DataSBit0)
    DStartStoP0 = 1'b1;
  else if (DelDataBit0 == 1'b1 && DataBit0 === 1'bZ)
    DStartStoP0 = 1'b0;
  else
    DStartStoP0 = DelDStartStoP0;
end // p_DStartStoP0

// -----------------------------------------------------------------------------
//  Delayed version of DStartStoP0
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelDStartStoP0
  if (nMMCIRST ==  1'b0)
    DelDStartStoP0 <= 1'b0;
  else
    if (DataEn == 1'b1)
      DelDStartStoP0  <= DStartStoP0;
    else
       DelDStartStoP0 <= 1'b0;
end // p_DelDStartStoP0

// -----------------------------------------------------------------------------
//  Delayed version of DataSBit0
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelDataSBit0
  if (nMMCIRST ==  1'b0)
    DelDataSBit0 <= 1'b0;
  else
    DelDataSBit0 <= DataSBit0;
end // p_DelDataSBit0

// -----------------------------------------------------------------------------
// Process to check if correct CRC is recd
// -----------------------------------------------------------------------------
always @(CRC7 or CRC160 or DataEBit0 or nMMCIRST)
begin : p_CheckCRC
  if (nMMCIRST == 1'b0)
    begin
      CmdCrcErrStat = 1'b0;
      DataCrcFail   = 1'b0;
    end
  else
    begin
      if (CmdEBit)
        begin
          if (CRC7 == 7'b0001001)
            CmdCrcErrStat = 1'b0;
          else
            CmdCrcErrStat = 1'b1;
        end
      if (DataEBit0)
        begin
          if (CRC160 == 16'b0000000000000000)
            DataCrcFail = 1'b0;
          else
            DataCrcFail = 1'b1;
        end
    end
end // p_CheckCRC

// -----------------------------------------------------------------------------
// Process to generate LoadCounters which will enable loading of
// DataCnt and BlkCnt counters
// -----------------------------------------------------------------------------
always @(MDCStg2WrEn or DataLength or LoadOver or nMMCIRST)
begin : p_LoadCounters
  if (nMMCIRST == 1'b0)
    LoadCounters = 1'b0;
  else if (MDCStg2WrEn == 1'b1)
    LoadCounters = 1'b1;
  else if (LoadOver == 1'b1)
    LoadCounters = 1'b0;
end // p_LoadCounters

// -----------------------------------------------------------------------------
// The Command path and Data path FSM's in MMCI handle only a byte wide
// data at a time.So while receiving data the MSB of the first byte
// is rxd first followed by MSB of 2nd byte and so on.So, in order
// to satisfy this the data rxd from the MMCI has to be properly
// positioned while writing into the Rx FIFO.
// -----------------------------------------------------------------------------
assign RxFWrData[7:0]   = BytePos == 2'b01 ? DataReg[7:0]   :
                          BytePos == 2'b10 ? DataReg[15:8]  :
                          BytePos == 2'b11 ? DataReg[23:16] :
                          BytePos == 2'b00 ? DataReg[31:24] :
                          8'h00;

assign RxFWrData[15:8]  = BytePos == 2'b10 ? DataReg[7:0]   :
                          BytePos == 2'b11 ? DataReg[15:8]  :
                          BytePos == 2'b00 ? DataReg[23:16] :
                          8'h00;

assign RxFWrData[23:16] = BytePos == 2'b11 ? DataReg[7:0]   :
                          BytePos == 2'b00 ? DataReg[15:8]  :
                          8'h00;

assign RxFWrData[31:24] = BytePos == 2'b00 ? DataReg[7:0]   :
                          8'h00;

// -----------------------------------------------------------------------------
// Positioning the data written into the Rx FIFO in cases where
// Datalength or Blocklen is less than 4, is done using the BytePos
// signal generated in this process.
// -----------------------------------------------------------------------------
always @(IntDataLength or IntBlkCnt or DataMode or nMMCIRST or
         iDataCnt or IntRxFWr)
begin : p_ByteAlign
  if (nMMCIRST == 1'b0)
    begin
      NextBytePos = 2'b00;
      status      = 1'b0;
    end
  else if (~DataMode)
    if (IntBlkCnt == 12'b000000000010)
      NextBytePos = 2'b10;
    else if (IntBlkCnt == 12'b000000000001)
      NextBytePos = 2'b01;
    else
      NextBytePos = 2'b00;
  else if (DataMode)
    begin
      if (IntDataLength == 16'b0000000000000011)
        NextBytePos = 2'b11;
      else if (IntDataLength == 16'b0000000000000010)
        NextBytePos = 2'b10;
      else if (IntDataLength == 16'b0000000000000001)
        NextBytePos = 2'b01;
      else
        begin
          if (IntDataLength > 16'b0000000000000100 &&
            iDataCnt < 16'b0000000000000100 && IntRxFWr != DelIntRxFWr)
            begin
              NextBytePos = iDataCnt[1:0] + 1;
              status      = 1'b1;
            end
          else if (status == 1'b0 || (status == 1'b1 &&
                   IntRxFWr != DelIntRxFWr))
            begin
              NextBytePos = 2'b00;
              status      = 1'b0;
            end
        end
    end
end // p_ByteAlign

// -----------------------------------------------------------------------------
// Sequential Process for BytePos
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST or MDCStg2WrEn)
begin : BytePosSeq
  BytePos = NextBytePos;
  if (~nMMCIRST | MDCStg2WrEn)
    BytePos = 2'b00;
  else if (DataMode && IntDataLength > 16'b0000000000000100)
    if (iDataCnt == 16'b0000000000000000 && iBitCnt == 3'b110)
      BytePos = NextBytePos;
  else
    BytePos   = NextBytePos;
end // BytePosSeq

// -----------------------------------------------------------------------------
// Driving Rx FIFO related signals
// -----------------------------------------------------------------------------
assign RxFWrData[32] = DataCrcFail;
assign RxFWr         = IntRxFWr;

// -----------------------------------------------------------------------------
// Delayed version of IntRxFWr
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelIntRxFWr
  if (~nMMCIRST)
    DelIntRxFWr <= 1'b0;
  else
    DelIntRxFWr <= IntRxFWr;
end // p_DelIntRxFWr

// -----------------------------------------------------------------------------
// Data Receive logic
// If the data to be received is in stream mode with each bit
// of data rxd data received the WrdCnt is incremented, the dataCnt is
// decremented.Once a word of data is received, the contents of the
// Shift register is transfered to the Rx FIFO and the FIFO write enable
// RxFWr is also toggled.The process ceases action once all the bytes of
// data have been received, this is ensured by the DStartStoP0
// qualifying signal going low.
// If the Data to be received is in Block mode with each bit of
// data rxd the bit is shifted in, the BitCnt is incremented by 1.
// With every byte of data received the WrdCnt is incremented, the
// dataCnt is decremented and the block count is also decremented.
// The block length that is taken into consideration excludes the crc
// bits.Once a word of data is received, the, contents of the Shift
// register is transfered to the Rx FIFO and the FIFO write enable,
// RxFWr is also toggled.The process, for block lengths lesserthan a
// word or otherwise, transfers the contents of the shift register to
// the FIFO when Block count runs to zero or the Data count runs to 0.
// At the time when Block count is zero or Data count is zero, the
// latter having higher priority, the RxCrcBit is set, which qualifies
// the received bit as CRC bit and the WrdCnt is set to "10" and the
// process keeps all the counters active till the CRC Bits are
// received, ie WrdCnt == "11" and BitCnt == "111".Once this is over the
// RxCrcBit signal is made low.The DStartStoP signal remains high
// throughout the process activity.The CrcError status is updated each
// time the CRC16 input to this module changes and at every endbit of
// data received this crc error status is written as the 33rd bit into
// the Rx FIFO.
// In case of Block mode and Wide Bus case a BitCnt of "001" indicates
// that a byte has been received.But in case of crc bits 16 crc bits
// have to be received independently on each line and hence we need
// to set WrdCnt == "10" and wait for the condition WrdCnt == "11" and
// BitCnt == "111", to receive all the crc bits.The shifting in of data
// is done four places per clock.
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_RxDatlogic
  if (~nMMCIRST | ~DataEn | DataDirection)
    begin
      LoadOver     <= 1'b0;
      IntRxFWr     <= 1'b0;
      DataReg      <= 32'h00000000;
      ShiftDataReg <= 32'h00000000;
      iDataCnt     <= 16'h0000;
      BlkCnt       <= 12'h000;
      iBitCnt      <= 3'b000;
      WrdCnt       <= 2'b00;
      RxCRCBit     <= 1'b0;
    end
  else if (~DataDirection & DataEn)
    begin
      if (LoadCounters && DataBit0 === 1'bZ && ~LoadOver)
        begin
          iDataCnt <= IntDataLength - 1;
          BlkCnt   <= IntBlkCnt - 1;
          WrdCnt   <= 2'b00;
          iBitCnt  <= 3'b000;
          LoadOver <= 1'b1;
        end
      else
        begin
          LoadOver <= 1'b0;
        end

      if (DataBit0 === 1'bZ)
        begin
          DataEnd  <= 1'b0;
          RxCRCBit <= 1'b0;
          WrdCnt   <= 2'b00;
        end

      if (DataMode & DStartStoP0)
        begin
        // Stream Mode Data Transfer
          if (iDataCnt == 16'b0000000000000000 && iBitCnt == 3'b111)
            begin
              DataReg[31:1] <= ShiftDataReg[30:0];
              DataReg[0]    <= DataBit0;
              WrdCnt        <= 2'b00;
              iBitCnt       <= 3'b000;
              IntRxFWr      <= ~(IntRxFWr);
              ShiftDataReg  <= 32'h00000000;
              DataEnd       <= 1'b1;
              iDataCnt      <= IntDataLength - 1;
            end
          else if (~DataEnd)
            begin
              if (iBitCnt == 3'b111)
                begin
                  if (WrdCnt == 2'b11)
                    begin
                      DataReg[31:1] <= ShiftDataReg[30:0];
                      ShiftDataReg  <= 32'h00000000;
                      DataReg[0]    <= DataBit0;
                      IntRxFWr      <= ~(IntRxFWr);
                    end
                  else
                    begin
                      ShiftDataReg[0] <= DataBit0;
                      ShiftDataReg[31:1] <= ShiftDataReg[30:0];
                    end
                  iBitCnt  <= (iBitCnt) + 1'b1;
                  WrdCnt   <= (WrdCnt) + 1'b1;
                  iDataCnt <= (iDataCnt) - 1'b1;
                end
              else
                begin
                  ShiftDataReg[0]    <= DataBit0;
                  ShiftDataReg[31:1] <= ShiftDataReg[30:0];
                  iBitCnt            <= (iBitCnt) + 1'b1;
                end
            end
        end
      else
        begin
        // Block Mode Data Transfer
          if (DStartStoP0 == 1'b1 && DataMode == 1'b0)
            begin
              if (iDataCnt == 16'b0000000000000000 && iBitCnt == 3'b111 &&
                  RxCRCBit == 1'b0)
                begin
                  RxCRCBit      <= 1'b1;
                  WrdCnt        <= 2'b10;
                  iBitCnt       <= 3'b000;
                  DataReg[31:1] <= ShiftDataReg[30:0];
                  DataReg[0]    <= DataBit0;
                  ShiftDataReg  <= 32'h00000000;
                  IntRxFWr      <= ~(IntRxFWr);
                  iDataCnt      <= (IntDataLength) - 1'b1;
                end
              else
                begin
                  if (BlkCnt == 12'b000000000000 && iBitCnt == 3'b111 &&
                      RxCRCBit == 1'b0)
                    begin
                      RxCRCBit <= 1'b1;
                      DataReg[31:1] <= ShiftDataReg[30:0];
                      DataReg[0]    <= DataBit0;
                      ShiftDataReg  <= 32'h00000000;
                      IntRxFWr      <= ~(IntRxFWr);
                      WrdCnt        <= 2'b10;
                      iBitCnt       <= 3'b000;
                      BlkCnt        <= (IntBlkCnt) - 1'b1;
                      iDataCnt      <= (iDataCnt) - 1'b1;
                    end
                  else
                    begin
                      if (iBitCnt == 3'b111)
                        begin
                          if (WrdCnt == 2'b11)
                            begin
                              if (RxCRCBit == 1'b0)
                                begin
                                  DataReg[31:1] <= ShiftDataReg[30:0];
                                  DataReg[0]    <= DataBit0;
                                  IntRxFWr      <= ~(IntRxFWr);
                                  ShiftDataReg  <= 32'h00000000;
                                end
                              else
                                RxCRCBit <= 1'b0;
                            end
                          else
                            begin
                              if (RxCRCBit == 1'b0)
                                begin
                                  ShiftDataReg[0] <= DataBit0;
                                  ShiftDataReg[31:1]
                                                  <= ShiftDataReg[30:0];
                                end
                            end
                          iBitCnt <= (iBitCnt) + 1'b1;
                          WrdCnt  <= (WrdCnt) + 1'b1;
                          if (RxCRCBit == 1'b0)
                            begin
                              BlkCnt   <= (BlkCnt) - 1'b1;
                              iDataCnt <= (iDataCnt) - 1'b1;
                            end
                        end
                      else
                        begin
                          if (RxCRCBit == 1'b0)
                            begin
                              ShiftDataReg[0] <= DataBit0;
                              ShiftDataReg[31:1]
                                              <= ShiftDataReg[30:0];
                            end
                          if (DStartStoP0 == 1'b1 && DelDStartStoP0 == 1'b0)
                            iBitCnt <= 3'b001;
                          else
                            iBitCnt <= (iBitCnt) + 1'b1;
                        end
                    end
                end
            end
        end
    end
end // p_RxDatlogic

// -----------------------------------------------------------------------------
// Generation of DataRxd, which qualifies the time after which data
// has been received
// -----------------------------------------------------------------------------
always @(MMCICLK or nMMCIRST or MDCStg2WrEn)
begin : p_iDataRxd
  if (~nMMCIRST | MDCStg2WrEn)
    iDataRxd = 1'b0;
  else if (DataEn & ~DataDirection & TokenSent & ~DataMode)
    if (DataBit0 == 1'b0 && DelDataBit0 === 1'bZ)
      iDataRxd = 1'b0;
    else if (DataBit0 === 1'bZ && DelDataBit0 == 1'b1)
      iDataRxd = 1'b1;
    else
      iDataRxd = DelDataRxd;
end // p_iDataRxd

// -----------------------------------------------------------------------------
// Delayed version of DataRxd
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelDataRxd
  if (~nMMCIRST)
    DelDataRxd <= 1'b0;
  else
    DelDataRxd <= iDataRxd;
end // p_DelDataRxd
endmodule

// --================================== End ==================================--
