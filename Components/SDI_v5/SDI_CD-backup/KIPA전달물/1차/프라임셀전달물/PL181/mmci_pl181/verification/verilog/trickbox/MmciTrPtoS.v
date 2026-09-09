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
// File Name              : MmciTrPtoS.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           MMCI Trickbox Parallel to serial convertor/
//           Transmitter module
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciTrPtoS (
// Inputs
                  MMCICLK,
                  nMMCIRST,
                  ResponseBits,
                  CmdEnable,
                  CmdRespCnt,
                  MMCITBCmdRespWr,
                  MMCITBResp0Wr,
                  MMCITBResp1Wr,
                  MMCITBResp2Wr,
                  MMCITBResp3Wr,
                  CRC7,
                  CrcBufferBit,
                  CmdCrcErr,
                  DataEn,
                  DataDirection,
                  DataMode,
                  DataLength,
                  Blocklen,
                  MDCStg2WrEn,
                  TxFRdData,
                  CRC160,
                  DCrcBufferBit,
                  DataTimeCnt,
                  TokenTimeCnt,
                  BsyTimeCnt,
                  DataRxd,
                  TokenErrBit,
                  DataCrcErr,
                  SendResponse,
                  RxCommand,
                  PWDATAIn,
// Outputs
                  TokenSent,
                  TkCntOver,
                  TxFRd,
                  TCRC7En,
                  TCRC16En,
                  BlkEnd,
                  MMCICMD,
                  MMCIDAT
                  );

// Inputs
input         MMCICLK;         // MMCI Bus clock
input         nMMCIRST;        // APB Bus reset
input   [1:0] ResponseBits;    // Response bits from cmd Reg
input         CmdEnable;       // Enable for command path
input  [31:0] CmdRespCnt;      // Counter to indicate when response is
                               // to be sent
input         MMCITBCmdRespWr; // Write En for CmdInd Reg
input         MMCITBResp0Wr;   // Write En for Response Reg 0
input         MMCITBResp1Wr;   // Write En for Response Reg 1
input         MMCITBResp2Wr;   // Write En for Response Reg 2
input         MMCITBResp3Wr;   // Write En for Response Reg 3
input   [6:0] CRC7;            // CRC7 calculated value
input         CrcBufferBit;    // Buffer bit for CRC7
input         CmdCrcErr;       // To induce incorrect crcs with Command
                               // Response
input         DataEn;          // Data Tx/Rx Enable Bit
input         DataDirection;   // Direction of Data 0-From Contoller
                               // 1-From card
input         DataMode;        // 0-Block Mode 1-Stream Mode
input  [15:0] DataLength;      // Number of bytes of Data
input   [3:0] Blocklen;        // Number of bytes in a block
input         MDCStg2WrEn;     // Indicates any write to MMCIDataCtrl
                               // register
input  [31:0] TxFRdData;       // Data from Tx FIFO
input  [15:0] CRC160;          // CRC16 for data line 0
input   [3:0] DCrcBufferBit;   // Buffer bit for CRC16, One/line
input  [31:0] DataTimeCnt;     // Timer for data transmission
input  [15:0] TokenTimeCnt;    // Timer for token transmission
input  [15:0] BsyTimeCnt;      // Timer for Busy duration
input         DataRxd;         // Indicates Data has been rxd
input         TokenErrBit;     // 1-Send incorrect token
input         DataCrcErr;      // To induce incorrect crcs on data
                               // lines
input         SendResponse;    // Qualifies sending of response
input         RxCommand;       // Qualifies command reception
input  [31:0] PWDATAIn;        // Internal version of APB Write Data
                               // Bus

// Outputs
output        TokenSent;       // Indicates token has been sent
output        TkCntOver;       // Qualifies Token
output        TxFRd;           // Read enable to Tx FIFO
output        TCRC7En;         // CRC7 calculation enable
output        TCRC16En;        // CRC16 calculation enable
output        BlkEnd;          // Indicates the end of blk
output        MMCICMD;         // MMCI Comand serial output
output        MMCIDAT;         // MMCI serial data output

// Inputs
wire        MMCICLK;          // MMCI Bus clock
wire        nMMCIRST;         // APB Bus reset
wire  [1:0] ResponseBits;     // Response bits from cmd Reg
wire        CmdEnable;        // Enable for command path
wire [31:0] CmdRespCnt;       // Counter to indicate when response is
                              // to be sent
wire        MMCITBCmdRespWr;  // Write En for CmdInd Reg
wire        MMCITBResp0Wr;    // Write En for Response Reg 0
wire        MMCITBResp1Wr;    // Write En for Response Reg 1
wire        MMCITBResp2Wr;    // Write En for Response Reg 2
wire        MMCITBResp3Wr;    // Write En for Response Reg 3
wire  [6:0] CRC7;             // CRC7 calculated value
wire        CrcBufferBit;     // Buffer bit for CRC7
wire        CmdCrcErr;        // To induce incorrect crcs with Command
                              // Response
wire        DataEn;           // Data Tx/Rx Enable Bit
wire        DataDirection;    // Direction of Data 0-From Contoller
                              // 1-From card
wire        DataMode;         // 0-Block Mode 1-Stream Mode
wire [15:0] DataLength;       // Number of bytes of Data
wire  [3:0] Blocklen;         // Number of bytes in a block
wire        MDCStg2WrEn;      // Indicates any write to MMCIDataCtrl
                              // register
wire [31:0] TxFRdData;        // Data from Tx FIFO
wire [15:0] CRC160;           // CRC16 for data line 0
wire  [3:0] DCrcBufferBit;    // Buffer bit for CRC16, One/line
wire [31:0] DataTimeCnt;      // Timer for data transmission
wire [15:0] TokenTimeCnt;     // Timer for token transmission
wire [15:0] BsyTimeCnt;       // Timer for Busy duration
wire        DataRxd;          // Indicates Data has been rxd
wire        TokenErrBit;      // 1-Send incorrect token
wire        DataCrcErr;       // To induce incorrect crcs on data
                              // lines
wire        SendResponse;     // Qualifies sending of response
wire        RxCommand;        // Qualifies command reception
wire [31:0] PWDATAIn;         // Internal version of APB Write Data
                              // Bus

// Outputs
wire        TokenSent;        // Indicates token has been sent
wire        TkCntOver;        // Qualifies Token
wire        TxFRd;            // Read enable to Tx FIFO
wire        TCRC7En;          // CRC7 calculation enable
wire        TCRC16En;         // CRC16 calculation enable
wire        BlkEnd;           // Indicates the end of blk
wire        MMCICMD;          // MMCI Comand serial output
wire        MMCIDAT;          // MMCI serial data output

// -----------------------------------------------------------------------------
//
//                                   MmciTrPtoS
//                                   ==========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//   This module supports the logic from transmission of cmd Response
// and Crc tokens and block/stream mode data.The bits to transmitted
// is stored in respective registers and the MmciTrPtoS module converts
// this parallel data into a serial one and transmits them on the
// respective bus.This module is controlled by the data tx/rx
// handshakes, to ensure the correct timing of tokens, Response and data
// This module also gets inputs from the crc generators, aiding them in
// transmitting the correct crc with command responses and block mode
// data.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        iMMCIDAT0;
// Local copy of MMCIDAT(0)

wire  [3:0] IntBlocklen;
// Internal copy of Block length

wire [15:0] IntDataLength;
// Internal copy of DataLength

wire [31:0] NextDataReg;
// D-Input to DataReg

wire        iTxFRd;
// local copy of TxFRd

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         CmdBit;
// Command Bit that is to be transmitted serailly

reg   [7:0] CmdCnt;
// Counter to keep track of command fields

reg  [31:0] CmdShiftReg;
// Shift Register for serial transmission of command bits

reg   [5:0] IntCmdIndex;
// Internally stored command index

reg  [31:0] IntRespReg0;
// Internally stored response 0 value

reg  [31:0] IntRespReg1;
// Internally stored response 1 value

reg  [31:0] IntRespReg2;
// Internally stored response 2 value

reg  [23:0] IntRespReg3;
// Internally stored response 3 value

reg         TokenBit;
// It holds the token bit that is to be transmitted

reg   [4:0] TokenShiftReg;
// ShiftRegister for Token transmission

reg   [2:0] TokenCnt;
// Counts the transmitted token bits

reg         CRC16Check;
// Indicates whether the data was received correctly

reg         DelTokenSent;
// Delayed TokenSent

reg         DelMMCIDAT0;
// Delayed MMCIDAT(0)

reg  [11:0] IntBlkCnt;
// Internally computed block count value

reg  [11:0] BlkCnt;
// Counts down the number of bytes in a block

reg  [15:0] DataCnt;
// Counts down the number of data bytes rxd or txd

reg   [1:0] WrdCnt;
// Count to indicate reception/txn of a Word of data

reg   [2:0] BitCnt;
// Counts up on reception/txn of each bit of data

reg         DataBit0;
// Holds the data bit to be txd on line 0

reg  [31:0] DataReg;
// Holds the data word read from the Tx FIFO

reg  [31:0] DataShiftReg;
// Holds the data to be shifted out

reg         iBlkEnd;
// Signal used to separate any two blocks by 2 clocks

reg         IntTxFRd;
// Internal version of TxFRd

reg         DelTxFRd;
// Delayed IntTxFRd

reg         iCRC16En;
// local copy of CRC16En

reg         iCRC7En;
// local copy of TCRC7En

reg         DelCRC7En;
// Delayed version of iCRC7En

reg         iTokenSent;
// local copy of output TokenSent

reg         NextTokenSent;
// D-Input to iTokenSent

reg         CntOver;
// Used to qualify the time from which CmdRespCnt becomes zero

reg         LoadOver;
// Used to indicate that loading of counters is over

reg         iTkCntOver;
// Used to qualify the time from which TokenTimeCnt becomes zero

reg         BsyCntOver;
// Used to qualify the time from which BsyTimeCnt becomes zero

reg         LoadCounters;
// Enables the loading of DataCount and BlockCount before the Tx starts

reg         DtTimeCntOver;
// Indicates that the DataTimerCounter has run down to zero

reg         DelDtTCntOver;
// Delayed version of DtTimeCntOver

reg         StBitSent;
// Indicates that start bit has been txd

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
  CmdCnt     = 8'h00;
  TokenCnt   = 3'b111;
  CRC16Check = 1'b0;
  IntBlkCnt  = 12'h000;
  DataCnt    = 16'h0000;
  BlkCnt     = 12'h000;
  WrdCnt     = 2'b00;
  BitCnt     = 3'b111;
end // p_Initialisations

// -----------------------------------------------------------------------------
// Driving Command path and Crc enable
// -----------------------------------------------------------------------------
assign MMCICMD           = SendResponse == 1'b1 ? CmdBit : 1'bZ;

// -----------------------------------------------------------------------------
// Generating Crc computation enable.There exists a two clock latency
// between the bit being transmitted and computing crc inclusive of the
// transmitted bit.This latency forces the Tx module to hold the enable
// high for one extra clock than usual, so the actual enable is an or of
// iCRC7En and DelCRC7En.
// -----------------------------------------------------------------------------
assign TCRC7En          = iCRC7En | DelCRC7En;

// -----------------------------------------------------------------------------
// Writes to command and response registers
// -----------------------------------------------------------------------------
always @(PWDATAIn or MMCITBCmdRespWr or MMCITBResp0Wr or MMCITBResp1Wr or
         MMCITBResp2Wr or MMCITBResp3Wr)
begin : p_RegisterWr
  if (MMCITBCmdRespWr)
    IntCmdIndex   = PWDATAIn[5:0];
  else if (MMCITBResp0Wr)
    IntRespReg0   = PWDATAIn[31:0];
  else if (MMCITBResp1Wr)
    IntRespReg1   = PWDATAIn[31:0];
  else if (MMCITBResp2Wr)
    IntRespReg2   = PWDATAIn[31:0];
  else if (MMCITBResp3Wr)
    IntRespReg3   = PWDATAIn[23:0];
end // p_RegisterWr

// -----------------------------------------------------------------------------
// Command Response Transmission logic.Once the trickbox receives a
// command which requires a response, the SendResponse handshake goes
// high and the process waits till the RespTimer runs to zero,
// depending on the CmdCnt value the respective fields of Command
// Response are transmitted. The CmdCnt is also qualified with the
// ResponseBits, which indicate whether the response is a short one or
// long one.For Short response, the fields txd are, start bit, Tx bit,
// Command Index as stored in CmdResponse register, card status as
// stored in the Response0 register and finally the CRC7 value computed
// for the above bits and the end bit.For long response the
// enabling of crc computation is done at the start of the card status,
// and the card status transmission involves the bits in Response0,
// Response1, Response2 and Response3 registers.
// -----------------------------------------------------------------------------

always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_TxCmdlogic
  if (nMMCIRST ==  1'b0)
  begin
     CmdCnt      <= 8'b00000000;
     CmdBit      <= 1'bZ;
     CmdShiftReg <= 46'h000000000000;
     iCRC7En     <= 1'b0;
     CntOver     <= 1'b0;
  end
  else
  begin
    if (SendResponse == 1'b1 && CmdEnable == 1'b1)
    begin
      if (CmdRespCnt == 32'b00000000000000000000000000000001
          && CntOver == 1'b0)
      begin
         CntOver <= 1'b1;
      end
      else if (CntOver ==  1'b1)
      begin
        if (CmdCnt == 8'b00000000)
        begin
          CmdCnt <= (CmdCnt) + 1'b1;
          CmdBit <= 1'b0;
          iCRC7En <= 1'b1;
          if (ResponseBits == 2'b01)
          begin
            CmdShiftReg[31:25]
                   <= ({1'b0, IntCmdIndex[5:0]});
          end
          else
          begin
             CmdShiftReg[31:25] <= ({1'b0, 6'b111111});
             iCRC7En <= 1'b0;
          end
        end
        else if (CmdCnt == 8'b00000111 && ResponseBits == 2'b11)
        begin
          CmdBit <= 1'b1;
          CmdCnt <= (CmdCnt) + 1'b1;
        end
        else if (CmdCnt == 8'b00001000)
         // common to both Short && long responses
        begin
          CmdCnt     <= (CmdCnt) + 1'b1;
          CmdShiftReg[31:1]  <= IntRespReg0[30:0];
          CmdBit     <= IntRespReg0[31];
          iCRC7En    <= 1'b1;
        end
        else if (CmdCnt == 8'b00101000)
        begin
          CmdCnt     <= (CmdCnt) + 1'b1;
          if (ResponseBits ==  2'b01)
             CmdBit <= CrcBufferBit;
          else
             CmdBit <= IntRespReg1[31];
        end
        else if (CmdCnt == 8'b00101001)
        begin
          CmdCnt     <= (CmdCnt) + 1'b1;
          if (ResponseBits ==  2'b01)
          begin
            iCRC7En <= 1'b0;
            if (CmdCrcErr == 1'b1)
            begin
               CmdShiftReg[31:25] <= 7'b1110101;
               CmdBit <= 1'b1;
            end
            else
            begin
               CmdShiftReg[31:26] <= ({CRC7[4:0], 1'b1});
               CmdBit <= CRC7[5];
            end
          end
          else
          begin
            CmdShiftReg[31:2]  <= IntRespReg1[29:0];
            CmdBit <= IntRespReg1[30];
          end
        end
        else if (CmdCnt == 8'b00101111 && ResponseBits == 2'b01)
        begin
          CmdCnt   <= 8'b00000000;
          CntOver  <= 1'b0;
          CmdBit   <= 1'b1;
        end
        else if (CmdCnt == 8'b01001000 && ResponseBits == 2'b11)
        begin
          CmdCnt   <= (CmdCnt) + 1'b1;
          CmdShiftReg[31:1] <= IntRespReg2[30:0];
          CmdBit   <= IntRespReg2[31];
        end
        else if (CmdCnt == 8'b01101000 && ResponseBits == 2'b11)
        begin
          CmdCnt   <= (CmdCnt) + 1'b1;
          CmdShiftReg[31:9] <= IntRespReg3[22:0];
          CmdBit   <= IntRespReg3[23];
        end
        else if (CmdCnt == 8'b10000000 && ResponseBits == 2'b11)
        begin
          CmdCnt   <= (CmdCnt) + 1'b1;
          CmdBit   <= CrcBufferBit;
        end
        else if (CmdCnt == 8'b10000001 && ResponseBits == 2'b11)
        begin
          CmdCnt   <= (CmdCnt) + 1'b1;
          iCRC7En  <= 1'b0;
          if (CmdCrcErr ==  1'b1)
          begin
             CmdShiftReg[31:26] <= 6'b110001;
             CmdBit <= 1'b1;
          end
          else
          begin
             CmdShiftReg[31:26] <= ({CRC7[4:0], 1'b1});
             CmdBit <= CRC7[5];
          end
        end
        else if (CmdCnt == 8'b10000111 && ResponseBits == 2'b11)
        begin
          CmdCnt   <= 8'b00000000;
          CntOver  <= 1'b0;
          CmdBit   <= 1'b1;
        end
        else
        begin
          CmdBit <= CmdShiftReg[31];
          CmdShiftReg[31:1] <= CmdShiftReg[30:0];
          CmdShiftReg[0] <= 1'b0;
          CmdCnt <= (CmdCnt) + 1'b1;
        end
      end
      else
        CmdBit <= 1'bZ;
    end
    else
    begin
      CmdBit  <= 1'bZ;
      CntOver <= 1'b0;
      iCRC7En <= 1'b0;
    end
  end
end // p_TxCmdlogic

// -----------------------------------------------------------------------------
// Delayed version of CRC7 enable
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelCRC7En
  if (nMMCIRST ==  1'b0)
    DelCRC7En <= 1'b0;
  else
    DelCRC7En <= iCRC7En;
end // p_DelCRC7En
// [vhdl2vlog] The following line is NOT modified.

// -----------------------------------------------------------------------------
// Token transmission logic.This process gets triggered when a block
// mode of data has been received and the TokenTimer has run down to
// zero.The token shiftregister is loaded with the token value to be txd
// and after the transmission of the token the MMCIDAT(0) line is held
// high till the BsyTimeCnt is not zero.
// -----------------------------------------------------------------------------
always @(posedge  MMCICLK or negedge nMMCIRST)
begin : p_TxTkBsylogic
  if (nMMCIRST == 1'b0)
  begin
    TokenCnt   <= 3'b111;
    TokenBit   <= 1'b0;
    iTkCntOver <= 1'b0;
    BsyCntOver <= 1'b0;
    TokenShiftReg  <= 5'b00000;
  end
  else
  begin
    if (MDCStg2WrEn == 1'b1)
      begin
        iTkCntOver <= 1'b0;
        BsyCntOver <= 1'b0;
        TokenBit   <= 1'bZ;
      end
    else if (DataDirection == 1'b0 && DataMode == 1'b0 &&
             DataEn == 1'b1)
    begin
      if (DataRxd == 1'b1)
      begin
        if (TokenTimeCnt == 16'b0000000000000001 &&
            iTkCntOver == 1'b0)
        begin
          iTkCntOver <= 1'b1;
          TokenCnt   <= 3'b100;
          TokenBit   <= 1'b0;
          if (TokenErrBit == 1'b1)
            TokenShiftReg    <= 5'b10110;
          else
            if (CRC16Check == 1'b0)
              TokenShiftReg  <= 5'b10110;
            else
              TokenShiftReg  <= {3'b010, 1'b1, 1'b0};
        end
        else if (iTkCntOver == 1'b1)
        begin
          if (TokenCnt == 3'b000)
            if (BsyTimeCnt == 16'b0000000000000001)
            begin
              TokenBit   <= 1'b1;
              BsyCntOver <= 1'b1;
              TokenCnt   <= 3'b111;
            end
            else
              TokenBit   <= 1'b0;
          else if (BsyCntOver == 1'b1)
          begin
            iTkCntOver <= 1'b0;
            BsyCntOver <= 1'b0;
            TokenBit   <= 1'bZ;
          end
          else
          begin
            TokenBit <= TokenShiftReg[4];
            TokenShiftReg[4:1] <= TokenShiftReg[3:0];
            TokenShiftReg[0] <= 1'b0;
            TokenCnt <= (TokenCnt) - 1'b1;
          end
        end
      end
    end
    else
    begin
      iTkCntOver <= 1'b0;
      BsyCntOver <= 1'b0;
      TokenBit   <= 1'bZ;
    end
  end
end // p_TxTkBsylogic

// -----------------------------------------------------------------------------
// Checking CRC16 to determine Crc error status
// -----------------------------------------------------------------------------
always @(CRC160)
begin
  if (CRC160 == 16'b0000000000000000)
    CRC16Check = 1'b1;
  else
    CRC16Check = 1'b0;
end // p_CRC16Check

// -----------------------------------------------------------------------------
// Combinational logic for generation of TokenSent
// -----------------------------------------------------------------------------
always @(MMCICLK or negedge nMMCIRST or MDCStg2WrEn)
begin
  if (~nMMCIRST | MDCStg2WrEn)
    NextTokenSent = 1'b1;
  else if (DataEn & ~DataDirection & DataRxd & ~DataMode)
    if (iMMCIDAT0 == 1'b0 && DelMMCIDAT0 === 1'bZ)
      NextTokenSent = 1'b0;
    else if (iMMCIDAT0 === 1'bZ && DelMMCIDAT0 == 1'b1)
      NextTokenSent = 1'b1;
    else
      NextTokenSent = iTokenSent;
end // p_NextTokenSent
// -----------------------------------------------------------------------------
// Sequential logic for TokenSent
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_TokenSent
  if (nMMCIRST ==  1'b0)
    iTokenSent <= 1'b1;
  else
    iTokenSent <= NextTokenSent;
end // p_TokenSent

// -----------------------------------------------------------------------------
// Delayed version of TokenSent
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelTokenSent
  if (nMMCIRST ==  1'b0)
     DelTokenSent <= 1'b1;
  else
     DelTokenSent <= iTokenSent;
end // p_DelTokenSent

// -----------------------------------------------------------------------------
// Delayed version of MMCIDAT(0)
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelMMCIDAT0
  if (nMMCIRST ==  1'b0)
     DelMMCIDAT0 <= 1'b0;
  else
    if (DataEn == 1'b1)
       DelMMCIDAT0 <= iMMCIDAT0;
    else
       DelMMCIDAT0 <= 1'b0;
end // p_DelMMCIDAT0

// -----------------------------------------------------------------------------
// The MMCIDAT(0) is used for transmission of token and also data.The
// signals iTkCntOver and DelDtTCntOver are used to sought out whether
// token bit or a data bit is transmitted.
// -----------------------------------------------------------------------------
assign iMMCIDAT0         = iTkCntOver == 1'b1 ? TokenBit              :
                          ((DataDirection == 1'b1 &&
                            DataEn == 1'b1 &&
                            (DtTimeCntOver == 1'b1 |
                            DelDtTCntOver == 1'b1)) ? DataBit0 : 1'bZ);

// -----------------------------------------------------------------------------
// Driving Data path
// -----------------------------------------------------------------------------
assign MMCIDAT           = iMMCIDAT0;

// -----------------------------------------------------------------------------
// Assigning outputs with local copies
// -----------------------------------------------------------------------------
assign TokenSent        = iTokenSent;
assign TkCntOver        = iTkCntOver;
assign BlkEnd           = iBlkEnd;
assign TxFRd            = iTxFRd;
assign TCRC16En         = iCRC16En;
assign iTxFRd           = DelTxFRd;

// -----------------------------------------------------------------------------
// Making internal versions of inputs
// -----------------------------------------------------------------------------
assign IntDataLength    = DataLength;
assign IntBlocklen      = Blocklen;

// -----------------------------------------------------------------------------
// The Command path and Data path FSM's in MMCI handle only a byte wide
// data at a time.So while transmitting data the MSB of the first byte
// is txd first followed by MSB of 2nd byte and so on. So, in order
// to satisfy this the data read from the FIFO has to be properly
// positioned in the Shift register.
// -----------------------------------------------------------------------------
assign NextDataReg[31:24] = TxFRdData[7:0];
assign NextDataReg[23:16] = TxFRdData[15:8];
assign NextDataReg[15:8]  = TxFRdData[23:16];
assign NextDataReg[7:0]   = TxFRdData[31:24];

// -----------------------------------------------------------------------------
// Sequential logic for DataReg
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DataReg
  if (nMMCIRST ==  1'b0)
    DataReg <= ('d0);
  else
    DataReg <= NextDataReg;
end // p_DataReg

// -----------------------------------------------------------------------------
// Delayed version of Tx FIFO read enable
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_DelTxFRd
  if (nMMCIRST ==  1'b0)
    DelTxFRd <= 1'b0;
  else
    DelTxFRd <= IntTxFRd;
end // p_DelTxFRd

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
// Generating enable for loading of DataCnt and BlkCnt counters
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
// Delayed version of DtTCntOver
// -----------------------------------------------------------------------------
always @(negedge nMMCIRST or posedge MMCICLK)
begin : p_DelDtTCntOver
  if (~nMMCIRST)
    DelDtTCntOver <= 1'b0;
  else
    DelDtTCntOver <= DtTimeCntOver;
end // p_DelDtTCntOver

// -----------------------------------------------------------------------------
// Data transmission logic.This process is activated when the data
// direction and data enable bits are set and the DataTimer has run down
// to zero.The data from the Tx FIFO is put into the DataReg and the
// data in the DataReg is loaded into the ShiftDataReg every time the
// WrdCnt is "11" and BitCnt is "111" and transmitted.
// Initially when the LoadCounters is high the DataCnt and BlkCnt are
// loaded and at the end of every block the BlkCnt is loaded again
// till the DataCnt reaches zero.For Stream/Non WideBus Block modes the
// DataCnt, BlkCnt's are decremented with the transmission of every byte
// The WrdCnt is incremented with every byte, while the BitCnt is
// BlkCnt's are decremented with the transmission of every byte.The
// WrdCnt is incremented with every byte, while the BitCnt is
// incremented with every bit transmitted.For WideBus Block mode the
// counter increment/decrement is at byte/bit boundary but the BitCnt
// value at which this is done is "001" as we receive half a byte
// (4 bits) for every incement of BitCnt.In Block mode Data Transfer,
// two signals StBitSent and BlkEnd are used, the tBitSent signal holds
// the BlkCnt at its initial value, while the start bit is being sent,
// while the lkEnd signal is used to hold the data bus in high impedance
// for one clk duration in between two blocks.The BlkCnt that is taken
// into consideration includes provision of 2 bytes for the CRC16 value
// Even in WideBus Mode the CRC16 is to be sent independently on each of
// the four lines and hence a normal count pattern (as that of
// NonWideBus case) is followed for the BitCnt during transmission of
// CRC16. Also CrcShiftReg take over the shifting out of bits from
// DataShiftReg during the time CRC16 is being transmitted.
// The process remains active till the DataCnt reaches zero and the Crc
// bits have been transmitted.
// -----------------------------------------------------------------------------
always @(posedge MMCICLK or negedge nMMCIRST)
begin : p_TxDatalogic
  if (nMMCIRST == 1'b0 || DataEn == 1'b0 || DataDirection == 1'b0)
  begin
    DataCnt       <= 16'h0000;
    BlkCnt        <= 12'h000;
    WrdCnt        <= 2'b00;
    BitCnt        <= 3'b111;
    IntTxFRd      <= 1'b0;
    DataShiftReg  <= 32'h00000000;
    iCRC16En      <= 1'b0;
    DataBit0      <= 1'bZ;
    LoadOver      <= 1'b0;
    DtTimeCntOver <= 1'b0;
    iBlkEnd       <= 1'b0;
    StBitSent     <= 1'b0;
  end
  else
  begin
    if (DataEn == 1'b1 && DataDirection == 1'b1)
    begin
     if (LoadCounters == 1'b1 && LoadOver == 1'b0)
     begin
        DataCnt       <= IntDataLength;
        BlkCnt        <= (IntBlkCnt) + 2'b10;
        WrdCnt        <= 2'b00;
        BitCnt        <= 3'b111;
        LoadOver      <= 1'b1;
        DataBit0      <= 1'bZ;
        DtTimeCntOver <= 1'b0;
        DataShiftReg  <= 32'h00000000;
        iCRC16En      <= 1'b0;
        iBlkEnd       <= 1'b0;
        StBitSent     <= 1'b0;
     end
     else
     begin
      LoadOver <= 1'b0;
      if (DataTimeCnt == 32'b00000000000000000000000000000001 &&
         DtTimeCntOver == 1'b0)
        DtTimeCntOver   <= 1'b1;
      else if (DtTimeCntOver == 1'b1)
      begin
        if (DataMode == 1'b1)
        begin
          if (DataCnt == IntDataLength && BitCnt == 3'b111)
          begin
            if (StBitSent == 1'b1)
            begin
              DataBit0  <= DataReg[31];
              IntTxFRd  <= ~(IntTxFRd);
              DataCnt   <= (DataCnt) - 1'b1;
              BitCnt    <= (BitCnt) + 1'b1;
            end
            else
            begin
              DataBit0  <= 1'b0;
              DataShiftReg[31:1] <= DataReg[30:0];
              StBitSent <= 1'b1;
            end
          end
          else if (DataCnt == 16'b0000000000000000 && BitCnt == 3'b111)
          begin
            DataBit0      <= 1'b1;
            DtTimeCntOver <= 1'b0;
            StBitSent     <= 1'b0;
            DataCnt       <= IntDataLength;
          end
          else
          begin
            if (BitCnt == 3'b111)
            begin
              if (WrdCnt == 2'b11)
              begin
                DataBit0    <= DataReg[31];
                DataShiftReg[31:1] <= DataReg[30:0];
                IntTxFRd    <= ~(IntTxFRd);
              end
              else
              begin
                DataBit0    <= DataShiftReg[31];
                DataShiftReg[31:1] <= DataShiftReg[30:0];
                DataShiftReg[0]  <= 1'b0;
              end
              DataCnt  <= (DataCnt) - 1'b1;
              WrdCnt   <= (WrdCnt) + 1'b1;
              BitCnt   <= (BitCnt) + 1'b1;
            end
            else
            begin
              DataBit0  <= DataShiftReg[31];
              DataShiftReg[31:1] <= DataShiftReg[30:0];
              DataShiftReg[0]  <= 1'b0;
              BitCnt <= (BitCnt) + 1'b1;
            end
          end
        end
        else
        begin
          // Block Mode Transfer
          if (DataCnt == 16'b0000000000000000 &&
              BlkCnt == 12'b000000000000 && BitCnt == 3'b111)
          begin
            DtTimeCntOver  <= 1'b0;
            DataBit0  <= 1'b1;
            WrdCnt    <= 2'b00;
            DataCnt   <= IntDataLength;
            BlkCnt    <= ((IntBlkCnt) + 2'b10);
          end
          else
          begin
            if (BlkCnt == ((IntBlkCnt) + 2'b10) &&
                BitCnt == 3'b111)
            begin
              if (iBlkEnd == 1'b0)
              begin
                if (StBitSent == 1'b0)
                begin
                  iCRC16En  <= 1'b1;
                  DataBit0  <= 1'b0;
                  DataShiftReg[31:1] <= DataReg[30:0];
                  StBitSent <= 1'b1;
                  WrdCnt    <= 2'b00;
                end
                else
                begin
                  DataBit0  <= DataReg[31];
                  IntTxFRd  <= ~(IntTxFRd);
                  BlkCnt    <= (BlkCnt) - 1'b1;
                  BitCnt    <= (BitCnt) + 1'b1;
                  StBitSent <= 1'b0;
                end
              end
              else
              begin
                DataBit0       <= 1'bZ;
                iBlkEnd        <= 1'b0;
                DtTimeCntOver  <= 1'b0;
              end
            end
            else if (BlkCnt == 12'b000000000000 && BitCnt == 3'b111)
            begin
              DataBit0  <= 1'b1;
              BlkCnt    <= ((IntBlkCnt) + 2'b10);
              iBlkEnd   <= 1'b1;
              WrdCnt    <= 2'b00;
            end
            else
            begin
              if (BlkCnt == 12'b000000000010 && BitCnt == 3'b111)
              begin
                BitCnt <= (BitCnt) + 1'b1;
                BlkCnt <= (BlkCnt) - 1'b1;
                DataBit0 <= DCrcBufferBit[0];
              end
              else if (BlkCnt == 12'b000000000001 && BitCnt == 3'b000)
              begin
                iCRC16En   <= 1'b0;
                WrdCnt     <= 2'b00;
                BitCnt     <= (BitCnt) + 1'b1;
                if (DataCrcErr == 1'b1)
                begin
                  DataShiftReg[31:17] <= 15'b111000011110000;
                  DataBit0 <= 1'b1;
                end
                else
                begin
                  DataShiftReg[31:18] <= CRC160[13:0];
                  DataBit0 <= CRC160[14];
                end
              end
              else
              begin
                if (BitCnt == 3'b111)
                begin
                  if (WrdCnt == 2'b11)
                  begin
                    DataBit0 <= DataReg[31];
                    DataShiftReg[31:1] <= DataReg[30:0];
                    IntTxFRd <= ~(IntTxFRd);
		  end
                  else
		  begin
                    DataBit0 <= DataShiftReg[31];
                    DataShiftReg[31:1]
                             <= DataShiftReg[30:0];
                    DataShiftReg[0] <= 1'b0;
                  end
                  BitCnt     <= (BitCnt) + 1'b1;
                  WrdCnt     <= (WrdCnt) + 1'b1;
                  BlkCnt     <= (BlkCnt) - 1'b1;
                  DataCnt    <= (DataCnt) - 1'b1;
                end
                else
		begin
                  DataBit0   <= DataShiftReg[31];
                  DataShiftReg[31:1]
                             <= DataShiftReg[30:0];
                  DataShiftReg[0] <= 1'b0;
                  BitCnt     <= (BitCnt) + 1'b1;
                end
              end
            end
          end
        end
      end
      else
        DataBit0 <= 1'bZ;
     end
    end
  end
end // p_TxDatalogic
endmodule

// --================================== End ==================================--
