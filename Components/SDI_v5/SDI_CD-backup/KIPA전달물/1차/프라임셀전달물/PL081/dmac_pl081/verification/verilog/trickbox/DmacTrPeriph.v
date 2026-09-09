// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacTrPeriph.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block mimics a Peripheral block on the AHB.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrPeriph (
// Inputs
                     HCLK,
                     HRESETn,
                     HADDR,
                     // Register Address
                     HSELREG,
                     HWRITE,
                     HTRANS,
                     HSIZE,
                     HWDATA,
                     HREADYIN,
                     HADDRM,
                     // Peripheral Address
                     HSELPERIPH,
                     HWRITEM,
                     HTRANSM,
                     HBURSTM,
                     HSIZEM,
                     HWDATAM,
                     HREADYINM,

                     DMACTC,

                     DMACCLR,
// Outputs
                     HREADYOUT,
                     HRESP,
                     HRDATA,
                     HREADYOUTM,
                     HRESPM,
                     HRDATAM,
                     DMACSREQ,
                     DMACBREQ,
                     DMACLSREQ,
                     DMACLBREQ
                     );
parameter
      CounterWidth = 8;

// Include parameters file
`include "DmacTrParams.v"

// Inputs
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
input [`SLAVEADDRHB : `SLAVEADDRLB] HADDR;
                                //  AHB Bus Address
// Register Address
input         HSELREG;          // Register Select
input         HWRITE;           // Register Read/Write
input   [1:0] HTRANS;           // Type of transfer on Register interface
input   [2:0] HSIZE;            // The width of the register data transfer
input  [31:0] HWDATA;           // Register Write Data
input         HREADYIN;         // Ready response to register interface
input  [`MASTERADDRHB : `MASTERADDRLB] HADDRM;
                                // Master AHB Address
// Peripheral Address
input         HSELPERIPH;       // Peripheral Select
input         HWRITEM;          // Peripheral Read/Write
input   [1:0] HTRANSM;          // Type of transfer on Peripheral Interface
input   [2:0] HBURSTM;          // Type of AHB Burst on Peripheral Interface
input   [2:0] HSIZEM;           // The width of the transfer on Peripheral
                                // Interface
input  [31:0] HWDATAM;          // Peripheral Write Data
input         HREADYINM;        // Ready response to Peripheral interface
input         DMACTC;           // DMA Terminal Count signal
input         DMACCLR;          // DMA clear signal

// Outputs
output        HREADYOUT;        // Ready response from Register interface
output  [1:0] HRESP;            // Transfer response from Register interface
output [31:0] HRDATA;           // Register read Data
output        HREADYOUTM;       // Ready response from Peripheral interface
output  [1:0] HRESPM;           // Transfer response from Peripheral interface
output [31:0] HRDATAM;          // Peripheral read data
output        DMACSREQ;         // DMA Single Request
output        DMACBREQ;         // DMA Burst Request
output        DMACLSREQ;        // DMA Last Single Request
output        DMACLBREQ;        // DMA Last Burst Request

// Inputs
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
wire   [`SLAVEADDRHB : `SLAVEADDRLB] HADDR;
                                // AHB Slave address
// Register Address
wire          HSELREG;          // Register Select
wire          HWRITE;           // Register Read/Write
wire    [1:0] HTRANS;           // Type of transfer on Register interface
wire    [2:0] HSIZE;            // The width of the register data transfer
wire   [31:0] HWDATA;           // Register Write Data
wire          HREADYIN;         // Ready response to register interface
wire   [`MASTERADDRHB : `MASTERADDRLB] HADDRM;
                                // Master Address
// Peripheral Address
wire          HSELPERIPH;       // Peripheral Select
wire          HWRITEM;          // Peripheral Read/Write
wire    [1:0] HTRANSM;          // Type of transfer on Peripheral Interface
wire    [2:0] HBURSTM;          // Type of AHB Burst on Peripheral Interface
wire    [2:0] HSIZEM;           // The width of the transfer on Peripheral
                                // Interface
wire   [31:0] HWDATAM;          // Peripheral Write Data
wire          HREADYINM;        // Ready response to Peripheral interface
wire          DMACTC;           // DMA Terminal Count signal
wire          DMACCLR;          // DMA clear signal

// Outputs
wire          HREADYOUT;        // Ready response from Register interface
wire    [1:0] HRESP;            // Transfer response from Register interface
wire   [31:0] HRDATA;           // Register read Data
wire          HREADYOUTM;       // Ready response from Peripheral interface
wire    [1:0] HRESPM;           // Transfer response from Peripheral interface
wire   [31:0] HRDATAM;          // Peripheral read data
wire          DMACSREQ;         // DMA Single Request
wire          DMACBREQ;         // DMA Burst Request
wire          DMACLSREQ;        // DMA Last Single Request
wire          DMACLBREQ;        // DMA Last Burst Request

// -----------------------------------------------------------------------------
//
//                                DmacTrPeriph
//                                ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//        This module is a behavioural model of a Peripheral interface. It has 2
// AHB slave interfaces. One AHB slave port is used to program the control
// registers and other slave port is used by the DMAC for peripheral accesses
// control registers are programmed to provide different data generation
// methods and various responses depending on data patterns and for the
// generation of all DMA requests. For source data transfers, this module
// generates the required number of data depending on data generation method.
// Any one data generation method, out of Four data generation methods, can be
// used. If this module is programmed for destination data transfer, it
// generates the expected data and compares it with incoming data. The module
// flags an error if there is mismatch in incoming and expected data. This
// module also checks whether DMATC and DMACLR signals are asserted at
// specified time. The Data generation methods are Random, GRAYCODE, Address
// based and Data based method. The following sub methods are used along with
// above data generation methods. The sub methods are Increment, Decrement, 1's
// complement and 2's complement. The above sub methods are only applicable
// to Address and Data generation method.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire                               Cyc1;
// First cycle of error response

wire                               Err1;
// First cycle of split/retry/error response

wire                               PeriphEnable;
// Peripheral model enable bit

wire                         [7:6] DefaultNoOfResp;
// Default number of split and retry response

wire                         [5:2] DefaultWaitCyc;
// Default wait cycles to be asserted by peripheral

wire                               Endianness;
// Indicates peripheral module is configured for Little/Big endian mode

wire                         [1:0] DefaultResp;
// Default Response should be asserted by peripheral

wire                         [3:0] Offset;
// Offset to generate address based data

wire                               DMASTermCount;
// DMA Single Terminal Count

wire                               DMABTermCount;
// DMA Burst Terminal Count

wire                               DMALSTermCount;
// DMA Last Single Terminal Count

wire                               DMALBTermCount;
// DMA Last Burst Terminal Count

wire                               DMACLRTermCount;
// DMA clear Terminal Count

wire                               DMATCTermCount;
// DMA TC Terminal Count

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [`MASTERADDRHB:`MASTERADDRLB-1] PeriphAddr;
// Clocked peripheral address

reg  [`SLAVEADDRHB:`SLAVEADDRLB-1] RegAddr;
// Clocked register address

reg                          [1:0] RegTrans;
// Clocked HTRANS

reg                          [1:0] PeriphTrans;
// Clocked HTRANSM

reg                                Selected;
// Selected state of the peripheral

reg                          [1:0] iHRESP;
// Data transfer response from register interface

reg                          [2:0] RegSize;
// Clocked HSIZE

reg                          [2:0] PeriphSize;
// Clocked HSIZEM

reg                          [1:0] iHRESPM;
// Data transfer response from peripheral interface

reg                                iHREADYOUT;
// Ready response from register interface

reg                                iHREADYOUTM;
// Ready response from peripheral interface

reg                         [31:0] iHRDATA;
// Register read data

reg                         [31:0] iHRDATAM;
// Peripheral read data

reg                                iDMACSREQ;
// DMA Single Request

reg                                iDMACBREQ;
// DMA Burst Request

reg                                iDMACLSREQ;
// DMA Last Single Request

reg                                iDMACLBREQ;
// DMA Last Burst Request

reg                                PeriphRegWrEn;
// Write enable for peripheral-specific register

reg                                Cyc2;
// Second cycle of error response

reg                                Err2;
// Second cycle of split/retry/error response

reg                                PeriphWrEn;
// Peripheral write enable

wire                                PeriphReset;
// Peripheral reset bit

wire                          [1:0] DataGenMethod;
// Data pattern generation method

reg                        [23:22] PrgmRespCount;
// Programmed number of split and retry response

reg                          [2:0] RespCount;
// To Count number of split and retry response asserted

reg                                DefIndicate;
// To indicate Default split and retry response asserted

reg                                PrgmIndicate;
// To indicate programmed split and retry response asserted

reg                                PrgmIndSync;
// Delayed PrgmIndicate

reg                          [1:0] PrgmRespSync;
// Delayed Programmed Response

reg                        [21:18] ProgramedWaitCyc;
// Programmed wait cycles to be asserted by peripheral

reg                                PeriphWaitCyc;
// To indicate wait cycle to be asserted

reg                                DataTransfer;
// To indicate data is transferred

reg                                TransferClear;
// To clear DataTransfer signal

reg                          [3:0] WaitCycCount;
// To count number of wait cycle asserted

reg                         [15:0] RdTotalTrans;
// To count number of read data

reg                         [15:0] WrTotalTrans;
// To count number of write data

wire                          [7:6] DataMethod;
// Type of method to be used to generate address based data

reg                          [7:0] RdPreviousData;
// To hold the previous cycle memory read data

reg                          [7:0] WrPreviousData;
// To hold the previous cycle memory write data

reg                         [31:0] ExpectedData;
// To hold expected data

reg                                RespOkInform;
// Indicates OK response should be asserted

reg                                RespClear;
// To clear response count.

reg                                FirstAccess;
// Indicate first access of DMAC

reg                                DMASCountEn;
// DMA Single Request counter enable bit

reg                                DMABCountEn;
// DMA Burst Request counter enable bit

reg                                DMALSCountEn;
// DMA Last Single Request counter enable bit

reg                                DMALBCountEn;
// DMA Last Burst Request counter enable bit

reg                                DMACLRCountEn;
// DMA clear counter enable bit

reg                                DMATCCountEn;
// DMA TC counter enable bit

reg                                DMASCntLoad;
// DMA Single Request counter load bit

reg                                DMABCntLoad;
// DMA Burst Request counter load bit

reg                                DMALSCntLoad;
// DMA Last Single Request counter load bit

reg                                DMALBCntLoad;
// DMA Last Burst Request counter load bit

reg                                DMACLRCntLoad;
// DMA clear counter load bit

reg                                DMATCCntLoad;
// DMA TC counter load bit

reg                          [2:0] NxtRespCount;
// D Input of RespCount

reg  [`SLAVEADDRHB:`SLAVEADDRLB-1] NxtRegAddr;
// D Input RegAddr

reg                          [1:0] NxtRegTrans;
// D input of RegTrans

reg                          [1:0] NxtPeriphTrans;
// D input of PeriphTrans

reg                          [2:0] NxtRegSize;
// D input of RegSize

reg                          [2:0] NxtPeriphSize;
// D input of PeriphSize

reg  [`MASTERADDRHB:`MASTERADDRLB-1] NxtPeriphAddr;
// D Input RegAddr

reg                                NxtPeriphRegWrEn;
// D Input of PeriphRegWrEn

reg                                NxtPeriphWrEn;
// D Input of PeriphWrEn

reg                                NxtDMACSREQ;
// D input of iDMACSREQ

reg                                NxtDMACBREQ;
// D input of iDMACBREQ

reg                                NxtDMACLSREQ;
// D input of iDMACLSREQ

reg                                NxtDMACLBREQ;
// D input of iDMACLBREQ

reg                                NxtDMASCntLoad;
// D input of DMA single request counter load

reg                                NxtDMABCntLoad;
// D input of DMA single request counter load

reg                                NxtDMALSCntLoad;
// D input of DMA single request counter load

reg                                NxtDMALBCntLoad;
// D input of DMA single request counter load

reg                                NxtDMACLRCntLoad;
// DMA clear counter load bit

reg                                NxtDMATCCntLoad;
// DMA TC counter load bit

reg                                NxtDMASCountEn;
// D input of DMA Single Request counter enable bit

reg                                NxtDMABCountEn;
// D input of DMA Burst Request counter enable bit

reg                                NxtDMALSCountEn;
// D input of DMA Last Single Request counter enable bit

reg                                NxtDMALBCountEn;
// D input of DMA Last Burst Request counter enable bit

reg                                NxtDMACLRCountEn;
// D input of DMA clear counter enable bit

reg                                NxtDMATCCountEn;
// D input of DMA TC counter enable bit

reg                          [1:0] NxtPrgmRespSync;
// D Input of PrgmRespSync

wire                        [31:0] PeriphReg0;
// Peripheral register 0

wire                        [31:0] PeriphReg1;
// Peripheral register 1

wire                        [31:0] PeriphReg2;
// Peripheral register 2

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Type declarations
// -----------------------------------------------------------------------------
reg [31:0] iPeriphReg [(`NO_OF_REG-1):0];
// Memory register

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Deriving the register contents from the register array
// -----------------------------------------------------------------------------
assign PeriphReg2 = iPeriphReg[2];

// -----------------------------------------------------------------------------
// Instantiation of DMACTrSCounter
// -----------------------------------------------------------------------------
DmacTrCounter DMACTrSCounter          (
                     .HCLK            (HCLK),
                     .HRESETn         (HRESETn),
                     .CountIn         (PeriphReg2[7:0]),
                     .Load            (DMASCntLoad),
                     .Enable          (DMASCountEn),
                     .Reset           (PeriphReset),
                     .TerminalCount   (DMASTermCount)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DMACTrBCounter
// -----------------------------------------------------------------------------
DmacTrCounter DMACTrBCounter          (
                     .HCLK            (HCLK),
                     .HRESETn         (HRESETn),
                     .CountIn         (PeriphReg2[15:8]),
                     .Load            (DMABCntLoad),
                     .Enable          (DMABCountEn),
                     .Reset           (PeriphReset),
                     .TerminalCount   (DMABTermCount)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DMACTrLSCounter
// -----------------------------------------------------------------------------
DmacTrCounter DMACTrLSCounter         (
                     .HCLK            (HCLK),
                     .HRESETn         (HRESETn),
                     .CountIn         (PeriphReg2[23:16]),
                     .Load            (DMALSCntLoad),
                     .Enable          (DMALSCountEn),
                     .Reset           (PeriphReset),
                     .TerminalCount   (DMALSTermCount)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DMACTrLBCounter
// -----------------------------------------------------------------------------
DmacTrCounter DMACTrLBCounter         (
                     .HCLK            (HCLK),
                     .HRESETn         (HRESETn),
                     .CountIn         (PeriphReg2[31:24]),
                     .Load            (DMALBCntLoad),
                     .Enable          (DMALBCountEn),
                     .Reset           (PeriphReset),
                     .TerminalCount   (DMALBTermCount)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DMACTrCLRCounter
// -----------------------------------------------------------------------------
DmacTrCounter DMACTrCLRCounter        (
                     .HCLK            (HCLK),
                     .HRESETn         (HRESETn),
                     .CountIn         (iPeriphReg[3]),
                     .Load            (DMACLRCntLoad),
                     .Enable          (DMACLRCountEn),
                     .Reset           (PeriphReset),
                     .TerminalCount   (DMACLRTermCount)
                    );

// -----------------------------------------------------------------------------
// Instantiation of DMACTrTCCounter
// -----------------------------------------------------------------------------
DmacTrCounter  DMACTrTCCounter        (
                     .HCLK            (HCLK),
                     .HRESETn         (HRESETn),
                     .CountIn         (iPeriphReg[4]),
                     .Load            (DMATCCntLoad),
                     .Enable          (DMATCCountEn),
                     .Reset           (PeriphReset),
                     .TerminalCount   (DMATCTermCount)
                    );

// -----------------------------------------------------------------------------
// Defining the width of the request counters
// -----------------------------------------------------------------------------
defparam DMACTrSCounter.CounterWidth = 8;
defparam DMACTrBCounter.CounterWidth = 8;
defparam DMACTrLSCounter.CounterWidth = 8;
defparam DMACTrLBCounter.CounterWidth = 8;
defparam DMACTrCLRCounter.CounterWidth = 32;
defparam DMACTrTCCounter.CounterWidth = 32;

// -----------------------------------------------------------------------------
// Latching of Register Address
// -----------------------------------------------------------------------------
always @(HSELREG or HREADYIN or HTRANS or HADDR or RegAddr)
begin : p_RegAddrComb
  NxtRegAddr       = RegAddr;
  if ((HSELREG == 1'b1) && (HREADYIN == 1'b1) &&
      (HTRANS == `NSEQ || HTRANS == `SEQ)) begin
    NxtRegAddr       = HADDR[`SLAVEADDRHB:`SLAVEADDRLB];
    end
end // p_RegAddrComb

// -----------------------------------------------------------------------------
// Register Address sequential logic
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegAddrSeq
  if (HRESETn == 1'b0) begin
    RegAddr          <= 'b0;
    end
  else begin
    RegAddr          <= NxtRegAddr;
    end
end // p_RegAddrSeq

// -----------------------------------------------------------------------------
// Latching of Memory Address
// Latching of Memory Address
// -----------------------------------------------------------------------------
always @(HSELPERIPH or HREADYINM or HTRANSM or HADDRM or PeriphAddr)
begin : p_PeriphAddrComb
  NxtPeriphAddr       = PeriphAddr;
  if ((HSELPERIPH == 1'b1) && (HREADYINM == 1'b1) &&
      (HTRANSM == `NSEQ || HTRANSM == `SEQ)) begin
    NxtPeriphAddr       = HADDRM[`MASTERADDRHB:`MASTERADDRLB];
    end
end // p_PeriphAddrComb

// -----------------------------------------------------------------------------
// Memory Address sequential logic
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_PeriphAddrSeq
  if (HRESETn == 1'b0) begin
    PeriphAddr          <= 'b0;
    end
  else begin
    PeriphAddr          <= NxtPeriphAddr;
    end
end // p_PeriphAddrSeq

// -----------------------------------------------------------------------------
// Latching of HTRANS
// -----------------------------------------------------------------------------
always @(HSELREG or HREADYIN or HTRANS or RegTrans)
begin : p_RegTransComb
  NxtRegTrans      = RegTrans;
  if ((HSELREG == 1'b1) && (HREADYIN == 1'b1)) begin
    NxtRegTrans      = HTRANS[1:0];
    end
  else begin
    NxtRegTrans      = 1'b0;
    end
end // p_RegTransComb

// -----------------------------------------------------------------------------
// Register Trans sequential logic
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegTransSeq
  if (HRESETn == 1'b0) begin
    RegTrans         <= 2'b0;
    end
  else begin
    RegTrans         <= NxtRegTrans;
    end
end // p_RegTransSeq

// -----------------------------------------------------------------------------
// Latching of HTRANSM
// -----------------------------------------------------------------------------
always @(HSELPERIPH or HREADYINM or HTRANSM or PeriphTrans or Selected)
begin : p_PeriphTransComb
  NxtPeriphTrans      = PeriphTrans;
  if (HREADYINM == 1'b1 && HSELPERIPH == 1'b1) begin
    NxtPeriphTrans      = HTRANSM;
    end
  else if (Selected == 1'b0) begin
    NxtPeriphTrans      = `IDLE;
    end
end // p_PeriphTransComb

// -----------------------------------------------------------------------------
// Memory Selected State Generation Block
// The Selected signal indicates selected state of the memory block. It
// indicates valid duration where the memory block should assert default/
// programmed response The Selected signal is set when there is HREADYINM or
// default/programmed response to be asserted. The signal is cleared when all
// default/programmed responses are asserted for current transfer.
// -----------------------------------------------------------------------------
always @(HRESETn or HREADYINM or PeriphWaitCyc or RespClear or PeriphEnable or
         DefIndicate or PrgmIndicate)
begin : p_SelcectedSeq
 if (HRESETn == 1'b0) begin
   Selected         = 1'b0;
   end
 else begin
   if (HREADYINM == 1'b1 || ((DefIndicate == 1'b1 || PrgmIndicate == 1'b1) ||
        (PeriphWaitCyc == 1'b1 && RespClear == 1'b0 && PeriphEnable == 1'b1)))
     begin
       Selected         = 1'b1;
     end
   else begin
     Selected         = 1'b0;
     end
   end
end // p_SelcectedSeq

// -----------------------------------------------------------------------------
// Memory Trans sequential logic
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_PeriphTransSeq
  if (HRESETn == 1'b0) begin
    PeriphTrans         <= 2'b0;
    end
  else begin
    PeriphTrans         <= NxtPeriphTrans;
    end
end // p_PeriphTransSeq

// -----------------------------------------------------------------------------
// Latching of HSIZE
// -----------------------------------------------------------------------------
always @(HSELREG or HREADYIN or HSIZE or HTRANS or RegSize)
begin : p_RegSizeComb
  NxtRegSize       = RegSize;
  if ((HSELREG == 1'b1) && (HREADYIN == 1'b1) &&
      (HTRANS == `NSEQ || HTRANS == `SEQ)) begin
    NxtRegSize       = HSIZE[2:0];
    end
end // p_RegSizeComb

// -----------------------------------------------------------------------------
// Register Size sequential logic
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegSizeSeq
  if (HRESETn == 1'b0) begin
    RegSize          <= 3'b0;
    end
  else begin
    RegSize          <= NxtRegSize;
    end
end // p_RegSizeSeq

// -----------------------------------------------------------------------------
// Memory SIZE Combinational logic
// -----------------------------------------------------------------------------
always @(HSELPERIPH or HREADYINM or HSIZEM or HTRANSM or PeriphSize)
begin : p_PeriphSizeComb
  NxtPeriphSize       = PeriphSize;
  if ((HSELPERIPH == 1'b1) && (HREADYINM == 1'b1) &&
      (HTRANSM == `NSEQ || HTRANSM == `SEQ)) begin
    NxtPeriphSize       = HSIZEM[2:0];
    end
end // p_PeriphSizeComb

// -----------------------------------------------------------------------------
// Latching of HSIZEM
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_PeriphSizeSeq
  if (HRESETn == 1'b0) begin
    PeriphSize          <= 3'b0;
    end
  else begin
    PeriphSize          <= NxtPeriphSize;
    end
end // p_PeriphSizeSeq

// -----------------------------------------------------------------------------
// Generation of Register Read/Write signal
// -----------------------------------------------------------------------------
always @(HTRANS or HSELREG or HREADYIN or HWRITE)
begin : p_RegWrGenComb
  if ((HSELREG == 1'b1) && (HREADYIN == 1'b1) &&
       (HTRANS == `NSEQ || HTRANS == `SEQ) && HWRITE == 1'b1) begin
    NxtPeriphRegWrEn    = 1'b1;
    end
  else begin
    NxtPeriphRegWrEn    = 1'b0;
    end
end // p_RegWrGenComb

// -----------------------------------------------------------------------------
// Latching of Register read/write signal
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegWrGenSeq
  if (HRESETn == 1'b0) begin
    PeriphRegWrEn       <= 1'b0;
    end
  else begin
    PeriphRegWrEn       <= NxtPeriphRegWrEn;
    end
end // p_RegWrGenSeq

// -----------------------------------------------------------------------------
// Generation of Memory Read/Write signal
// -----------------------------------------------------------------------------
always @(HTRANSM or HSELPERIPH or HREADYINM or HWRITEM or PeriphWrEn)
begin : p_PeriphWrGenComb
  NxtPeriphWrEn       = PeriphWrEn;
  if ((HSELPERIPH == 1'b1) && (HREADYINM == 1'b1) &&
      (HTRANSM == `NSEQ || HTRANSM == `SEQ) && HWRITEM == 1'b1) begin
    NxtPeriphWrEn       = 1'b1;
    end
  else begin
    NxtPeriphWrEn       = 1'b0;
    end
end // p_PeriphWrGenComb

// -----------------------------------------------------------------------------
// Latching of Memory read/write signal
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_PeriphWrGenSeq
  if (HRESETn == 1'b0) begin
    PeriphWrEn          <= 1'b0;
    end
  else begin
    PeriphWrEn          <= NxtPeriphWrEn;
    end
end // p_PeriphWrGenSeq

// ----------------------------------------------------------------------------
// Memory Register Read Write Block.
// This combination process is responsible for writing in Register/LLI slave
// block and reading of register block. It also gives AHB response for each
// read/write to register/LLI block.
// ----------------------------------------------------------------------------
always @(HRESETn or PeriphRegWrEn or RegTrans or RegSize or
         RegAddr or HWDATA)
begin : p_RegRdWrComb
  iHRDATA          = 32'b0;
  if (HRESETn == 1'b0) begin
    iHRDATA          = 32'b0;
    iHRESP           = 2'b0;
    end

  if (PeriphRegWrEn == 1'b1) begin
    if (RegTrans == `NSEQ || RegTrans == `SEQ) begin
      if (RegSize == `WORD) begin
        iHRESP           = `OKAY_RESP;
        end
      else begin
        $display($time,"Error : DmacTrPeriph2 : WRITE ACCESS IS NOT",
                       " WORD WIDE \n %m");
        iHRESP           = `ERROR_RESP;
        end
      end
    else begin
      iHRESP           = `OKAY_RESP;
      end
    end
  else begin
    if (RegTrans == `NSEQ || RegTrans == `SEQ) begin
      if (RegSize == `WORD) begin
        iHRDATA          = iPeriphReg[RegAddr];
        iHRESP           = `OKAY_RESP;
        end
      else begin
        $display($time," Error : DmacTrPeriph4 : READ ACCESS IS NOT ",
                      " WORD WIDE \n %m");
        iHRESP           = `ERROR_RESP;
        end
      end
    else begin
      iHRESP           = `OKAY_RESP;
      end
    end
end // p_RegRdWrComb

// ----------------------------------------------------------------------------
// Write Block for Memory Registers
// This process is responsible for the updating of register block. When there is
// valid write to register block, it writes in register indicated by RegAddr.
// This process clears all control register except control 1 register when
// Memory reset bit is set. It clears all registers when HRESETn is asserted.
// -----------------------------------------------------------------------------
reg [31:0] TempRegValue,i;

always @(posedge HCLK or negedge HRESETn)
begin : p_RegSeq
  if (HRESETn == 1'b0) begin
    for(i=0; i<`NO_OF_REG; i=i+1)
      iPeriphReg[i] <= 'b0;
    end
  else begin
    if (PeriphReset == 1'b1) begin
      TempRegValue = iPeriphReg[0];
      for (i=0; i<`NO_OF_REG; i=i+1)
        iPeriphReg[i] <= 'b0;
        iPeriphReg[0] <= TempRegValue;
      end
    if ((PeriphRegWrEn == 1'b1) && (RegSize == `WORD)) begin
      iPeriphReg[RegAddr] <= HWDATA;
      end
    end
end // p_RegSeq

// -----------------------------------------------------------------------------
// Assigning internal signals values
// -----------------------------------------------------------------------------
assign PeriphReg0       = iPeriphReg[0];
assign PeriphReg1       = iPeriphReg[1];

assign PeriphEnable     = PeriphReg0[31];
assign PeriphReset      = PeriphReg0[30];
assign DataGenMethod    = PeriphReg0[9:8];
assign DefaultNoOfResp  = PeriphReg0[7:6];
assign DefaultWaitCyc   = PeriphReg0[5:2];
assign DefaultResp      = PeriphReg0[1:0];
assign Endianness       = PeriphReg0[10];
assign DataMethod       = PeriphReg1[7:6];
assign Offset           = PeriphReg1[3:0];

// -----------------------------------------------------------------------------
// Register two Cycle Response Generation : Cyc1 Generation :
// Cyc1 is set HIGH during the first cycle of an error response.
// The registered Cyc2 is HIGH during the second cycle of the error response.
// -----------------------------------------------------------------------------
assign Cyc1             = (iHRESP == `ERROR_RESP && Cyc2 == 1'b0) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Cyc2 Generation :
// Cyc2 is delayed version of Cyc1
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_Cyc2Seq
  if (HRESETn == 1'b0) begin
    Cyc2             <= 1'b0;
    end
  else begin
    Cyc2             <= Cyc1;
    end
end // p_Cyc2Seq

// -----------------------------------------------------------------------------
// Memory two Cycle Response Generation : Err1 Generation
// Err1 is set HIGH during the first cycle of an error response.
// The registered Err2 is HIGH during the second cycle of the error response.
// -----------------------------------------------------------------------------
assign Err1             = (iHRESPM != `OKAY_RESP && Err2 == 1'b0) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Err2 Generation : Err2 is delayed version of Err1
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_Err2Seq
  if (HRESETn == 1'b0) begin
    Err2             <= 1'b0;
    end
  else begin
    Err2             <= Err1;
    end
end // p_Err2Seq

// ----------------------------------------------------------------------------
// Register Ready Response generator Block.
// The HREADYOUT is kept low in first cycle of two cycle response(i.e. When Cyc1
// is set and Cyc2 is cleared).
// ----------------------------------------------------------------------------
always @(HRESETn or Cyc1 or Cyc2)
begin : p_RegReadyComb
  if (HRESETn == 1'b0) begin
    iHREADYOUT       = 1'b1;
    end
  if (Cyc1 == 1'b1 && Cyc2 == 1'b0) begin
    iHREADYOUT       = 1'b0;
    end
  else if (Cyc1 == 1'b0 && Cyc2 == 1'b1) begin
    iHREADYOUT       = 1'b1;
    end
end // p_RegReadyComb

// ----------------------------------------------------------------------------
// Memory Ready Response generator Block
// The HREADYOUTM is kept low in first cycle of two cycle response(i.e. When
// Err1 is set and Err2 is cleared) or when Wait response is asserted.
// ----------------------------------------------------------------------------
always @(HRESETn or Err1 or Err2 or PeriphWaitCyc)
begin : p_PeriphReadyComb
  if (HRESETn == 1'b0) begin
    iHREADYOUTM      = 1'b1;
    end
  else if (Err1 == 1'b1 && Err2 == 1'b0) begin
    iHREADYOUTM      = 1'b0;
    end
  else if (Err1 == 1'b0 && Err2 == 1'b1) begin
    iHREADYOUTM      = 1'b1;
    end
  else if (PeriphWaitCyc == 1'b1) begin
    iHREADYOUTM      = 1'b0;
    end
  else if (PeriphWaitCyc ==1'b0) begin
    iHREADYOUTM      = 1'b1;
    end
end // p_PeriphReadyComb

// ----------------------------------------------------------------------------
// First Access signal Generation Block
// ----------------------------------------------------------------------------
always @(HRESETn or HREADYINM)
begin : p_FirstAccComb
  if (HRESETn == 1'b0) begin
    FirstAccess      = 1'b0;
    end
  else if (HREADYINM == 1'b1) begin
    FirstAccess      = 1'b1;
    end
end // p_FirstAccComb

// ----------------------------------------------------------------------------
// Memory Read Sequential Block
// This process is responsible for Memory/LLI Master block read access.
// ----------------------------------------------------------------------------
reg     [31:0] Shifted_DataRd;
reg      [7:0] TempRd;
reg            RdFlag;
reg      [7:0] TempAddr;
integer        RdCount;
always @(negedge HRESETn or posedge HCLK)
begin : p_PeriphRdSeq
  if (HRESETn == 1'b0) begin
    // Clear previous cycle memory read data.
    RdPreviousData   <= 'b0;
    // Clear HRDATAM.
    iHRDATAM         <= 'b0;
    // Clear Number of total read data transfer.
    RdTotalTrans     <= 'b0;
    end
  else begin
    if (PeriphReset == 1'b1) begin
      // If Memory Reset bit is set, clear previous cycle memory data and
      // number of total read data transfer.
      RdPreviousData   <= 'b0;
      RdTotalTrans     <= 'b0;
      end

    if (RdTotalTrans == 'b0) begin
      RdFlag            = 1'b1;
      end

    // The RdCount indicates number of times data generation function to be
    // called to generate read data. The Data generation functions return byte
    // wide data.
    // If HSIZEM is BYTE then Data generation function is called only once.
    // If HSIZEM is Half Word then Data generation function is called twice as
    // function returns only byte wide data.
    if (HSIZEM == `BYTE) begin
      RdCount             = 1;
      end
    else if (HSIZEM == `HWORD) begin
      RdCount             = 2;
      end
    else if (HSIZEM == `WORD) begin
      RdCount             = 4;
      end

    if ((HSELPERIPH == 1'b1) && (HREADYINM == 1'b1)) begin
      if (HWRITEM == 1'b0 && RespCount == 3'b000 && RespClear == 1'b0) begin
        if (PeriphEnable == 1'b1) begin
          if (FirstAccess == 1'b1) begin
            if (HTRANSM == `NSEQ || HTRANSM == `SEQ) begin
              if (HSIZEM == `BYTE || HSIZEM == `HWORD || HSIZEM == `WORD) begin
                // Loop R2
                TempRd           = RdPreviousData;
                Shifted_DataRd   = 'b0;
                for (i = 1; i < RdCount + 1; i = i + 1) begin
                  case (DataGenMethod)
                    // RANDOM Data generation method
                    `RANDOM : begin
                      // Load previous cycle Read data.
                      RdFlag           = 1'b0;
                      TempRd           = PRBSDataGen(TempRd);
                      end

                    // GRAYCODE Data generation method
                    `GRAYCODE : begin
                      // Load previous cycle read data.
                      RdFlag           = 1'b0;
                      TempRd           = GrayDataGen(TempRd);
                      end

                    // Address Based Data Generation Method
                    `ADDRESSBASED : begin
                      TempAddr = HADDRM[7:0];
                      TempRd   = AddrBasedGen(TempAddr, Offset, DataMethod);
                      end

                    // Data Based Data generation Method
                    `DATABASED : begin
                      // Load previous cycle read data.
                      RdFlag   = 1'b0;
                      TempRd   = DataBasedGen(TempRd, Offset, DataMethod);
                      end

                    default : begin
                      // Invalid Data Generation Method
                      $display($time," Error : DmacTrPeriph6 : ",
                               " INVALID DATA GENERATION ",
                               " METHOD FOR READ COMPARISION",
                               " \n %m");
                      iHRDATAM         <= 'b0;
                      end
                  endcase
                  if (Endianness == 1'b0) begin
                    // Little Endian Mode
                    if (HSIZEM == `BYTE) begin
                      if (HADDRM[1:0] == 2'b00) begin
                        Shifted_DataRd[7:0] = TempRd;
                        end
                      else if (HADDRM[1:0] == 2'b01) begin
                        Shifted_DataRd[15:8] = TempRd;
                        end
                      else if (HADDRM[1:0] == 2'b10) begin
                        Shifted_DataRd[23:16] = TempRd;
                        end
                      else if (HADDRM[1:0] == 2'b11) begin
                        Shifted_DataRd[31:24] = TempRd;
                        end
                      end
                    else if (HSIZEM == `HWORD) begin
                      if (i==1)
                        Shifted_DataRd[7:0] = TempRd;
                      if (i==2)
                        Shifted_DataRd[15:8] = TempRd;

                      if (i == 2) begin
                        if (HADDRM[1:0] == 2'b10) begin
                          Shifted_DataRd = {Shifted_DataRd[15:0], 16'b0};
                          end
                        end
                      end
                    else if (HSIZEM == `WORD) begin
                      if (i==1)
                        Shifted_DataRd[7:0] = TempRd;
                      if (i==2)
                        Shifted_DataRd[15:8] = TempRd;
                      if (i==3)
                        Shifted_DataRd[23:16] = TempRd;
                      if (i==4)
                        Shifted_DataRd[31:24] = TempRd;
                      end
                    end
                  else begin
                    // Big Endian Mode
                    if (HSIZEM == `BYTE) begin
                      if (HADDRM[1:0] == 2'b00) begin
                        Shifted_DataRd[31:24] = TempRd;
                        end
                      else if (HADDRM[1:0] == 2'b01) begin
                        Shifted_DataRd[23:16] = TempRd;
                        end
                      else if (HADDRM[1:0] == 2'b10) begin
                        Shifted_DataRd[15:8] = TempRd;
                        end
                      else if (HADDRM[1:0] == 2'b11) begin
                        Shifted_DataRd[7:0] = TempRd;
                        end
                      end
                    else if (HSIZEM == `HWORD) begin
                      if (i==1)
                        Shifted_DataRd[7:0] = TempRd;
                      if (i==2)
                        Shifted_DataRd[15:8] = TempRd;
                      if (i == 2) begin
                        if (HADDRM[1:0] == 2'b00) begin
                          Shifted_DataRd = {Shifted_DataRd[15:0],16'b0};
                          end
                        end
                      end
                    else if (HSIZEM == `WORD) begin
                      if (i==1)
                        Shifted_DataRd[7:0] = TempRd;
                      if (i==2)
                        Shifted_DataRd[15:8] = TempRd;
                      if (i==3)
                        Shifted_DataRd[23:16] = TempRd;
                      if (i==4)
                        Shifted_DataRd[31:24] = TempRd;
                      end
                    end
                  end // Loop R2 Ends
                if (DataGenMethod == `RANDOM | DataGenMethod == `GRAYCODE |
                    DataGenMethod == `ADDRESSBASED |
                    DataGenMethod == `DATABASED) begin
                  iHRDATAM         = Shifted_DataRd;
                  RdTotalTrans     = (RdTotalTrans) + 1'b1;
                  end
                else begin
                  iHRDATAM         = 'b0;
                  end
                end
              end
            end
          end
        end
      end
    if (RdFlag == 1'b1) begin
      // Load seed from control register 1 for read data generation.
      RdPreviousData   = PeriphReg1[31:24];
      end
    else begin
      RdPreviousData   = TempRd;
      end
    end
end // p_PeriphRdSeq

// -----------------------------------------------------------------------------
// Memory Read Write Combo Logic.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_RdWrDataComb
  // If Memory Read/Write access is non BYTE/Half Word/Word access then assert
  // error message. If memory model is not enabled, return error message to
  // memory read/write access.

  if (PeriphWrEn == 1'b1) begin
    if (PeriphEnable == 1'b1) begin
      if ((PeriphTrans == `NSEQ) || (PeriphTrans == `SEQ)) begin
        if ((PeriphSize != `BYTE) && (PeriphSize != `HWORD) &&
             (PeriphSize != `WORD)) begin
          $display($time,"Error : DmacTrPeriph7 : WRITE ACCESS OF ",
                           "INVALID HSIZEM  \n %m");
          end
        end
      end
    else begin
      $display($time,"Error : MEMORY MODEL IS NOT ENABLED. INVALID WRITE",
                     " ACCESS \n %m");
      end
    end
  else begin
    if (PeriphEnable == 1'b1) begin
      if (FirstAccess == 1'b1) begin
        if ((PeriphTrans == `NSEQ) || (PeriphTrans == `SEQ)) begin
          if ((PeriphSize != `BYTE) && (PeriphSize != `HWORD) &&
              (PeriphSize != `WORD)) begin
            $display($time," Error : DmacTrPeriph8 : READ ACCESS OF ",
                           " INVALID HSIZEM  \n %m");
            end
          end
        end
      end
    else begin
      if (Selected == 1'b1 && FirstAccess == 1'b1 && PeriphTrans != `IDLE) begin
        $display($time,"Error : DmacTrPeriph9 : MEMORY MODEL IS NOT",
                       " ENABLED. INVALID READ ACCESS \n %m");
        end
      end
    end
end // p_RdWrDataComb

// -----------------------------------------------------------------------------
// Expected Data Generation Block.
// This process is responsible for the generation of expected data.
// -----------------------------------------------------------------------------
integer           WrCount;
reg        [31:0] Shifted_DataWr;
reg         [7:0] TempWr;
reg               WrFlag;
reg         [7:0] TempAddrWr;
always @(negedge HRESETn or posedge HCLK)
begin : p_ExpectDataSeq
  if (HRESETn == 1'b0) begin
    // Clear Expected Data
    ExpectedData     <= 'b0;
    // Clear previous cycle memory write data.
    WrPreviousData   <= 'b0;
    // Clear Number of total write data transfer.
    WrTotalTrans     <= 'b0;
    end
  else begin
    if (PeriphReset == 1'b1) begin
      // Clear previous cycle memory write data.
      WrPreviousData   <= 'b0;
      // Clear Number of total write data transfer.
      WrTotalTrans     <= 'b0;
      end

    if (WrTotalTrans == 'b0) begin
      WrFlag            = 1'b1;
      end

    if (WrFlag == 1'b1) begin
      // Load seed from control register 1 for write data generation.
      WrPreviousData   <= PeriphReg1[31:24];
      end

    // The WrCount indicates number of times data generation function to be
    // called to generate the Expected data. The Data generation functions
    // returns byte wide data.
    // If HSIZEM is BYTE then Data generation function is called only once.
    // If HSIZEM is Half Word then Data generation function is called twice as
    // function returns only byte wide data.
    if (HSIZEM == `BYTE) begin
      WrCount             = 1;
      end
    else if (HSIZEM == `HWORD) begin
      WrCount             = 2;
      end
    else if (HSIZEM == `WORD) begin
      WrCount             = 4;
      end

    if ((HSELPERIPH == 1'b1) && (HREADYINM == 1'b1)) begin
      if (HWRITEM == 1'b1 && RespCount == 3'b000 && RespClear == 1'b0) begin
        if (PeriphEnable == 1'b1) begin
          if (HTRANSM == `NSEQ || HTRANSM == `SEQ) begin
            if (HSIZEM == `BYTE || HSIZEM == `HWORD || HSIZEM == `WORD) begin
              // Increment Total Write Data transfer count
              WrTotalTrans     <= (WrTotalTrans) + 1'b1;
              // RANDOM Data generation method
              case (DataGenMethod)
                `RANDOM : begin
                  // Load previous cycle write data
                  TempWr           = WrPreviousData;
                  WrFlag           = 1'b0;
                  Shifted_DataWr   = 'b0;
                  // Loop R1
                  for (i = 1; i < WrCount + 1; i = i + 1) begin
                    // Call Random Data generator function
                    TempWr           = PRBSDataGen(TempWr);
                    if (i==1)
                      Shifted_DataWr[7:0] = TempWr;
                    if (i==2)
                      Shifted_DataWr[15:8] = TempWr;
                    if (i==3)
                      Shifted_DataWr[23:16] = TempWr;
                    if (i==4)
                      Shifted_DataWr[31:24] = TempWr;
                    end // loop R1;
 
                  if (HSIZEM == `BYTE) begin
                    ExpectedData     <= {Shifted_DataWr[7:0],
                                         Shifted_DataWr[7:0],
                                         Shifted_DataWr[7:0],
                                         Shifted_DataWr[7:0]};
                    end
                  else if (HSIZEM == `HWORD) begin
                    ExpectedData     <= {Shifted_DataWr[15:0],
                                         Shifted_DataWr[15:0]};
                    end
                  else begin
                    ExpectedData     <= Shifted_DataWr;
                    end
                  end

                // GRAYCODE Data generation method
                `GRAYCODE : begin
                  // Load previous cycle write data
                  TempWr           = WrPreviousData;
                  WrFlag           = 1'b0;
                  Shifted_DataWr   = 'b0;
                  // Loop G1
                  for (i = 1; i < WrCount + 1; i = i + 1) begin
                    // Call GRAY Code Data generator function
                    TempWr           = GrayDataGen(TempWr);
                    if (i==1)
                      Shifted_DataWr[7:0] = TempWr;
                    if (i==2)
                      Shifted_DataWr[15:8] = TempWr;
                    if (i==3)
                      Shifted_DataWr[23:16] = TempWr;
                    if (i==4)
                      Shifted_DataWr[31:24] = TempWr;
                    end // loop G1;

                  if (HSIZEM == `BYTE) begin
                    ExpectedData     <= {Shifted_DataWr[7:0],
                                         Shifted_DataWr[7:0],
                                         Shifted_DataWr[7:0],
                                         Shifted_DataWr[7:0]};
                    end
                  else if (HSIZEM == `HWORD) begin
                    ExpectedData     <= {Shifted_DataWr[15:0],
                                         Shifted_DataWr[15:0]};
                    end
                  else begin
                    ExpectedData     <= Shifted_DataWr;
                    end
 
                  end
                 // Address Based Data Generation Method
                `ADDRESSBASED : begin
                  TempAddrWr         = HADDRM[7:0];
                  Shifted_DataWr   = 'b0;
                  // Loop A1
                  for (i = 1; i < WrCount + 1; i = i + 1) begin
                    // Address based Data generator function
                    TempWr = AddrBasedGen(TempAddrWr, Offset, DataMethod);
                    if (i==1)
                      Shifted_DataWr[7:0] = TempWr;
                    if (i==2)
                      Shifted_DataWr[15:8] = TempWr;
                    if (i==3)
                      Shifted_DataWr[23:16] = TempWr;
                    if (i==4)
                      Shifted_DataWr[31:24] = TempWr;
                      TempAddrWr = TempAddrWr + 1;
                    end // loop A1;

                  if (HSIZEM == `BYTE) begin
                    ExpectedData     <= {Shifted_DataWr[7:0],
                                         Shifted_DataWr[7:0],
                                         Shifted_DataWr[7:0],
                                         Shifted_DataWr[7:0]};
                    end
                  else if (HSIZEM == `HWORD) begin
                    ExpectedData     <= {Shifted_DataWr[15:0],
                                         Shifted_DataWr[15:0]};
                    end
                  else begin
                    ExpectedData     <= Shifted_DataWr;
                    end
                  end

                // Data Based Data generation Method
                `DATABASED : begin
                  // Load previous cycle write data.
                  TempWr           = WrPreviousData;
                  WrFlag           = 1'b0;
                  Shifted_DataWr   = 'b0;
                  // D1: for i in 1 to WrCount loop
                  for (i = 1; i < WrCount + 1; i = i + 1) begin
                    // Call Data based Data generator function
                    TempWr       = DataBasedGen(TempWr, Offset, DataMethod);
                    if (i==1)
                      Shifted_DataWr[7:0] = TempWr;
                    if (i==2)
                      Shifted_DataWr[15:8] = TempWr;
                    if (i==3)
                      Shifted_DataWr[23:16] = TempWr;
                    if (i==4)
                      Shifted_DataWr[31:24] = TempWr;
                    end // loop D1;

                    if (HSIZEM == `BYTE) begin
                      ExpectedData     <= {Shifted_DataWr[7:0],
                                           Shifted_DataWr[7:0],
                                           Shifted_DataWr[7:0],
                                           Shifted_DataWr[7:0]};
                      end
                    else if (HSIZEM == `HWORD) begin
                      ExpectedData     <= {Shifted_DataWr[15:0],
                                           Shifted_DataWr[15:0]};
                      end
                    else begin
                      ExpectedData     <= Shifted_DataWr;
                      end
                    end

                default : begin
                  // Invalid Data Generation - give Error message
                  $display($time," Error : DmacTrPeriph10 : INVALID ",
                                 "DATA GENERATION METHOD FOR ",
                                 "WRITE DATA COMPARISION \n %m");
                  end
              endcase
              if (WrFlag == 1'b0)
                begin
                  WrPreviousData   <= TempWr;
                end
              end
            end
          end
        end
      end
    end
end // p_ExpectDataSeq

// ----------------------------------------------------------------------------
// Master Response decision Block
// This process is responsible for the assertion of HRESPM for memory Read/Write
// access.
// ----------------------------------------------------------------------------
reg           Flag;
reg   [31:0]  PeriphRegk;
reg   [31:0]  PeriphRegj1;

reg        Found;
integer  ValidBits;
integer    j1, k;
reg [15:0] TransCount;

always @(HRESETn or PeriphReset or PeriphAddr or PeriphTrans or PrgmIndSync or
         PeriphSize or PeriphEnable or DefaultResp or FirstAccess or
         PeriphWrEn or TransferClear or Err2 or RespClear or RespCount or
         RespOkInform or PeriphWaitCyc or Selected or PrgmRespSync)
begin : p_RespDecideComb
  NxtRespCount     = RespCount;
  NxtPrgmRespSync  = PrgmRespSync;
  if (HRESETn == 1'b0) begin
    // Assert OK response on reset
    iHRESPM          = 'b0;
    end

  if (HRESETn == 1'b0 || PeriphReset == 1'b1) begin
    // Clear Response count on HRESETn or Memory Reset.
    NxtRespCount     = 'b0;
    // Clear programmed response on HRESETn or Memory Reset.
    NxtPrgmRespSync  = 'b0;
    PrgmRespCount    = 'b0;
    DefIndicate      = 'b0;
    PrgmIndicate     = 'b0;
    end

  if (TransferClear == 1'b1) begin
    // Clear Data Transfer single when last data transfer is done
    DataTransfer     = 1'b0;
    end

  // TransCount variable is used for assertion of programmed response. It holds
  // number of total read/write count depending memory read/write data transfer.
  // For Data based programmed response(i.e. bit 30 of Memory Control register
  // is set)assertion, TransCount is compared with DataCount field of control
  // register. If TransCount is equal to DataCount, Programmed Response is
  // asserted.
  if (PeriphWrEn == 1'b1) begin
    // Assign Total number of Write Data Transfer to TransCount
    TransCount = WrTotalTrans;
    end
  else begin
    // Assign Total number of Read Data Transfer to TransCount
    TransCount = RdTotalTrans;
    end

  if (Selected == 1'b1) begin
    if (PeriphTrans == `IDLE)
      // Assert OK response to IDLE transfer
      iHRESPM          = `OKAY_RESP;
    else begin
      iHRESPM          = `OKAY_RESP;
      if (PeriphEnable == 1'b1) begin
        if (PeriphSize == `BYTE || PeriphSize == `HWORD ||
            PeriphSize == `WORD) begin
          if (PeriphReset == 1'b1) begin
            // If Memory reset bit is set, assert Error Response for
            // memory read/write access.
            iHRESPM          = `ERROR_RESP;
            $display($time,"Error : PeriphReset1: Memory Reset bit is set.",
                           " In Valid Access. \n %m");
            end
          else begin
            if (HREADYINM == 1'b1) begin : L5
              k = 0;
              // Programmed response assertion block.
              // L4 : for j in 2 to (`NO_OF_REG-1) loop
              for (j1 = 5; j1 < `NO_OF_REG; j1 = j1 + 1) begin : L4
                // Check Control register Enable bit is set
                PeriphRegj1 = iPeriphReg[j1];
                if (PeriphRegj1[31] ==1'b1) begin
                  if (PeriphRegj1[30] == 1'b0) begin
                    // Address based Programmed Response assertion method
                    // Determine Valid bits and Compare Memory address with
                    // AddressCount. If it equals set Flag True.
                    ValidBits = PeriphRegj1[27:24];
                    if (PeriphRegj1[29:28] == 2'b00) begin
                      case (ValidBits)
                        0 :
                           if (PeriphAddr[0:0] == PeriphRegj1[0:0])
                             Flag              = 1'b1;
                        1 :
                           if (PeriphAddr[1:0] == PeriphRegj1[1:0])
                             Flag              = 1'b1;
                        2 :
                           if (PeriphAddr[2:0] == PeriphRegj1[2:0])
                             Flag              = 1'b1;
                        3 :
                           if (PeriphAddr[3:0] == PeriphRegj1[3:0])
                             Flag              = 1'b1;
                        4 :
                           if (PeriphAddr[4:0] == PeriphRegj1[4:0])
                             Flag              = 1'b1;
                        5 :
                           if (PeriphAddr[5:0] == PeriphRegj1[5:0])
                             Flag              = 1'b1;
                        6 :
                           if (PeriphAddr[6:0] == PeriphRegj1[6:0])
                             Flag              = 1'b1;
                        7 :
                           if (PeriphAddr[7:0] == PeriphRegj1[7:0])
                             Flag              = 1'b1;
                        8 :
                           if (PeriphAddr[8:0] == PeriphRegj1[8:0])
                             Flag              = 1'b1;
                        9 :
                           if (PeriphAddr[9:0] == PeriphRegj1[9:0])
                             Flag              = 1'b1;
                        10 :
                           if (PeriphAddr[10:0] == PeriphRegj1[10:0])
                             Flag              = 1'b1;
                        11 :
                           if (PeriphAddr[11:0] == PeriphRegj1[11:0])
                             Flag              = 1'b1;
                        12 :
                           if (PeriphAddr[12:0] == PeriphRegj1[12:0])
                             Flag              = 1'b1;
                        13 :
                           if (PeriphAddr[13:0] == PeriphRegj1[13:0])
                             Flag              = 1'b1;
                        14 :
                           if (PeriphAddr[14:0] == PeriphRegj1[14:0])
                             Flag              = 1'b1;
                        15 :
                           if (PeriphAddr[15:0] == PeriphRegj1[15:0])
                             Flag              = 1'b1;
                        default :
                           if (PeriphAddr[15:0] == PeriphRegj1[15:0])
                             Flag              = 1'b1;
                      endcase
                      end
                    else if (PeriphRegj1[29:28] == 2'b01) begin
                      case (ValidBits)
                        0 :
                           if (PeriphAddr[1:1] == PeriphRegj1[1:1])
                             Flag              = 1'b1;
                        1 :
                           if (PeriphAddr[2:1] == PeriphRegj1[2:1])
                             Flag              = 1'b1;
                        2 :
                           if (PeriphAddr[3:1] == PeriphRegj1[3:1])
                             Flag              = 1'b1;
                        3 :
                           if (PeriphAddr[4:1] == PeriphRegj1[4:1])
                             Flag              = 1'b1;
                        4 :
                           if (PeriphAddr[5:1] == PeriphRegj1[5:1])
                             Flag              = 1'b1;
                        5 :
                           if (PeriphAddr[6:1] == PeriphRegj1[6:1])
                             Flag              = 1'b1;
                        6 :
                           if (PeriphAddr[7:1] == PeriphRegj1[7:1])
                             Flag              = 1'b1;
                        7 :
                           if (PeriphAddr[8:1] == PeriphRegj1[8:1])
                             Flag              = 1'b1;
                        8 :
                           if (PeriphAddr[9:1] == PeriphRegj1[9:1])
                             Flag              = 1'b1;
                        9 :
                           if (PeriphAddr[10:1] == PeriphRegj1[10:1])
                             Flag              = 1'b1;
                        10 :
                           if (PeriphAddr[11:1] == PeriphRegj1[11:1])
                             Flag              = 1'b1;
                        11 :
                           if (PeriphAddr[12:1] == PeriphRegj1[12:1])
                             Flag              = 1'b1;
                        12 :
                           if (PeriphAddr[13:1] == PeriphRegj1[13:1])
                             Flag              = 1'b1;
                        13 :
                           if (PeriphAddr[14:1] == PeriphRegj1[14:1])
                             Flag              = 1'b1;
                        14 :
                           if (PeriphAddr[15:1] == PeriphRegj1[15:1])
                             Flag              = 1'b1;
                        15 :
                           if (PeriphAddr[16:1] == PeriphRegj1[16:1])
                             Flag              = 1'b1;
                        default :
                           if (PeriphAddr[16:1] == PeriphRegj1[16:1])
                             Flag              = 1'b1;
                      endcase
                      end
                    else if (PeriphRegj1[29:28] == 2'b10) begin
                      case (ValidBits)
                        0 :
                           if (PeriphAddr[2:2] == PeriphRegj1[0:0])
                             Flag              = 1'b1;
                        1 :
                           if (PeriphAddr[3:2] == PeriphRegj1[1:0])
                             Flag              = 1'b1;
                        2 :
                           if (PeriphAddr[4:2] == PeriphRegj1[2:0])
                             Flag              = 1'b1;
                        3 :
                           if (PeriphAddr[5:2] == PeriphRegj1[3:0])
                             Flag              = 1'b1;
                        4 :
                           if (PeriphAddr[6:2] == PeriphRegj1[4:0])
                             Flag              = 1'b1;
                        5 :
                           if (PeriphAddr[7:2] == PeriphRegj1[5:0])
                             Flag              = 1'b1;
                        6 :
                           if (PeriphAddr[8:2] == PeriphRegj1[6:0])
                             Flag              = 1'b1;
                        7 :
                           if (PeriphAddr[9:2] == PeriphRegj1[7:0])
                             Flag              = 1'b1;
                        8 :
                           if (PeriphAddr[10:2] == PeriphRegj1[8:0])
                             Flag              = 1'b1;
                        9 :
                           if (PeriphAddr[11:2] == PeriphRegj1[9:0])
                             Flag              = 1'b1;
                        10 :
                           if (PeriphAddr[12:2] == PeriphRegj1[10:0])
                             Flag              = 1'b1;
                        11 :
                           if (PeriphAddr[13:2] == PeriphRegj1[11:0])
                             Flag              = 1'b1;
                        12 :
                           if (PeriphAddr[14:2] == PeriphRegj1[12:0])
                             Flag              = 1'b1;
                        13 :
                           if (PeriphAddr[15:2] == PeriphRegj1[13:0])
                             Flag              = 1'b1;
                        14 :
                           if (PeriphAddr[16:2] == PeriphRegj1[14:0])
                             Flag              = 1'b1;
                        15 :
                           if (PeriphAddr[17:2] == PeriphRegj1[15:0])
                             Flag              = 1'b1;
                        default :
                           if (PeriphAddr[17:2] == PeriphRegj1[15:0])
                             Flag              = 1'b1;
                      endcase
                      end
                    if (Flag == 1'b1) begin
                      Found            = 1'b1;
                      DataTransfer     = 1'b1;
                      end
                    end
                  else begin
                    // Data Based Programmed Response assertion
                    // Determine Valid number of bits and compare
                    // TransCount(i.e.  Total Read/Write transfer count)
                    // with Data Count. If it is equals set Flag True.
                    ValidBits = PeriphRegj1[27:24];
                    case (ValidBits)
                      0 :
                        if (TransCount[0:0] == PeriphRegj1[0:0])
                          Flag              = 1'b1;
                      1 :
                        if (TransCount[1:0] == PeriphRegj1[1:0])
                          Flag              = 1'b1;
                      2 :
                        if (TransCount[2:0] == PeriphRegj1[2:0])
                          Flag              = 1'b1;
                      3 :
                        if (TransCount[3:0] == PeriphRegj1[3:0])
                          Flag              = 1'b1;
                      4 :
                        if (TransCount[4:0] == PeriphRegj1[4:0])
                          Flag              = 1'b1;
                      5 :
                        if (TransCount[5:0] == PeriphRegj1[5:0])
                          Flag              = 1'b1;
                      6 :
                        if (TransCount[6:0] == PeriphRegj1[6:0])
                          Flag              = 1'b1;
                      7 :
                        if (TransCount[7:0] == PeriphRegj1[7:0])
                          Flag              = 1'b1;
                      8 :
                        if (TransCount[8:0] == PeriphRegj1[8:0])
                          Flag              = 1'b1;
                      9 :
                        if (TransCount[9:0] == PeriphRegj1[9:0])
                          Flag              = 1'b1;
                      10 :
                        if (TransCount[10:0] == PeriphRegj1[10:0])
                          Flag              = 1'b1;
                      11 :
                        if (TransCount[11:0] == PeriphRegj1[11:0])
                          Flag              = 1'b1;
                      12 :
                        if (TransCount[12:0] == PeriphRegj1[12:0])
                          Flag              = 1'b1;
                      13 :
                        if (TransCount[13:0] == PeriphRegj1[13:0])
                          Flag              = 1'b1;
                      14 :
                        if (TransCount[14:0] == PeriphRegj1[14:0])
                          Flag              = 1'b1;
                      15 :
                        if (TransCount[15:0] == PeriphRegj1[15:0])
                          Flag              = 1'b1;
                      default :
                        if (TransCount[15:0] == PeriphRegj1[15:0])
                          Flag              = 1'b1;
                    endcase
                    if (Flag == 1'b1) begin
                      Found            = 1'b1;
                      DataTransfer     = 1'b1;
                      end
                    end
                  end
                // Exit loop if any programmed response is found.
                if (Found == 1'b1) begin
                  k = j1;
                  // exit L4;
                  disable L5;
                  end
                end  // loop L4;
            end

          if (Flag == 1'b1 || PrgmIndSync != 1'b0)
            begin
              if (Flag == 1'b1) begin
                // If Programmed response is found for current transfer,
                // assert programmed response.
                PeriphRegk       = iPeriphReg[k];
                iHRESPM          = PeriphRegk[17:16];
                if ((PeriphRegk[17:16] == `SPLIT_RESP ||
                     PeriphRegk[17:16] == `RETRY_RESP ||
                     PeriphRegk[17:16] == `ERROR_RESP) &&
                     RespOkInform == 1'b0) begin
                  // Store Programmed Response and set PrgmIndicate(It
                  // indicates Programmed response is asserted)
                  PrgmRespCount    = PeriphRegk[23:22];
                  PrgmIndicate     = 1'b1;
                  // During Wait Cycle assert Ok Response
                  if (PeriphWaitCyc == 1'b1 && Err2 == 1'b0) begin
                    iHRESPM          = `OKAY_RESP;
                    end
                  else begin
                    // Increment Response counter
                    if (Err2 == 1'b0 && PeriphRegk[17:16] != `ERROR_RESP) begin
                      NxtRespCount     = RespCount + 1'b1;
                      end
                    end
                  end
                // Latch Programmed response and Programmed Wait cycle
                NxtPrgmRespSync  = PeriphRegk[17:16];
                ProgramedWaitCyc = PeriphRegk[21:18];
                end
              else begin
                if (RespOkInform == 1'b0) begin
                   PrgmIndicate     = 1'b1;
                  if (PeriphWaitCyc == 1'b1 && Err2 == 1'b0) begin
                    // For Programmed Wait Cycle response assert Ok
                    // response
                    iHRESPM          = `OKAY_RESP;
                    end
                  else begin
                    // If Programmed Wait Cycles are asserted, assert
                    // programmed response if any.
                     iHRESPM          = PrgmRespSync;
                    if (Err2 == 1'b0 && PrgmRespSync != `ERROR_RESP) begin
                      // Increment Response counter
                      NxtRespCount     = RespCount + 1'b1;
                      end
                    end
                  end
                end
              end
            else begin
              // if there is no programmed response for current transaction
              // assert default response
               iHRESPM          = DefaultResp;
              if ((DefaultResp == `SPLIT_RESP || DefaultResp == `RETRY_RESP ||
                   DefaultResp == `ERROR_RESP) && (RespOkInform == 1'b0)) begin
                if (PeriphWaitCyc == 1'b1 && Err2 == 1'b0) begin
                  // If default wait cycle any, assert Ok response
                  iHRESPM          = `OKAY_RESP;
                  end
                else begin
                  DefIndicate      = 1'b1;
                  if (Err2 == 1'b0 && DefaultResp != `ERROR_RESP) begin
                    // Increment response count
                    NxtRespCount     = RespCount + 1'b1;
                    end
                  end
                end
              end
            end
          end
        else begin
          // assert error response for Non byte/Half word/Word memory access
          iHRESPM          = `ERROR_RESP;
          end
        end
      else begin
        if (FirstAccess == 1'b1) begin
          // assert error response when there is access to memory when
          // memory is not enabled
          iHRESPM          = `ERROR_RESP;
          end
        end
      end
    end

  if (RespOkInform == 1'b1) begin
    // assert ok response after all programmed/default responses are asserted.
    iHRESPM          = `OKAY_RESP;
    DefIndicate      = 1'b0;
    PrgmIndicate     = 1'b0;
    NxtPrgmRespSync  = 'b0;
    end
  if (RespClear == 1'b1) begin
    // All programmed/Default responses are asserted, clear response count
    NxtRespCount     = 'b0;
    // All programmed/Default responses are asserted, clear programmed
    // response indicate and default response indicate signal
    DefIndicate      = 1'b0;
    PrgmIndicate     = 1'b0;
    PrgmRespCount    = 'b0;
    NxtPrgmRespSync  = 'b0;
    end

  // clear Flag and Found flags
  Flag              = 1'b0;
  Found             = 1'b0;
end // p_RespDecideComb

// ----------------------------------------------------------------------------
// Response Count Sequential Block
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RespCountSeq
  if (HRESETn == 1'b0) begin
    RespCount        <= 'b0;
    PrgmIndSync      <= 1'b0;
    PrgmRespSync     <= `OKAY_RESP;
    end
  else begin
    RespCount        <= NxtRespCount;
    PrgmIndSync      <= PrgmIndicate;
    PrgmRespSync     <= NxtPrgmRespSync;
    end
end // p_RespCountSeq

// ----------------------------------------------------------------------------
// Response Counter Clear Generation Block
// This process is responsible generation of RespClear signal. The RespClear
// signal is used to clear programmed response counter.
// ----------------------------------------------------------------------------
reg [2:0] Count;
reg [2:0] PrgmCount;
reg [2:0] DefCount;
always @(negedge HRESETn or posedge HCLK)
begin : p_RSPComb
  if (HRESETn == 1'b0) begin
    RespClear        <= 1'b0;
    end
  else begin
    Count     = RespCount;
    PrgmCount = {1'b0, PrgmRespCount};
    DefCount  = {1'b0, DefaultNoOfResp};
    PrgmCount = PrgmCount + 1;
    DefCount  = DefCount + 1;
    if (PeriphReset == 1'b1) begin
       RespClear        <= 1'b0;
       end
    else if (PrgmIndicate == 1'b1 && Count == PrgmCount) begin
      // Check actual response asserted and programmed response asserted are
      // equal. If it is equal generate RespClear signal to clear response
      // counter.
      RespClear        <= 1'b1;
      end
    else if (DefIndicate == 1'b1 && Count == DefCount) begin
      // Check actual response asserted and default response asserted are
      // equal. If it is equal generate RespClear signal to clear response
      // counter.
      RespClear        <= 1'b1;
      end
    else if (HTRANSM != `IDLE) begin
      RespClear        <= 1'b0;
      end
  end
end // p_RSPComb

// ----------------------------------------------------------------------------
// Ok Response Decision Sequential block
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RespOkInfSeq
  if (HRESETn == 1'b0) begin
    RespOkInform     <= 1'b0;
    end
  else begin
    if ((RespClear == 1) || (iHRESPM == `ERROR_RESP && Err2 == 1))
      RespOkInform     <= 1'b1;
    else
      RespOkInform     <= 1'b0;
  end
end // p_RespOkInfSeq

// ----------------------------------------------------------------------------
// Periphory Wait Cycle assertion Block
// This block is responsible for assertion of wait cycle response. If there is
// default wait cycle response or programmed wait cycle response to current
// data transfer, this block asserts wait cycle response.
// ----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_PeriphWaitCycSeq
  if (HRESETn == 1'b0 || PeriphReset == 1'b1) begin
    TransferClear    <= 1'b0;
    PeriphWaitCyc    <= 1'b0;
    WaitCycCount     <= 'b0;
    end
  else begin
    if (PeriphEnable == 1'b1 && Selected == 1'b1) begin
      if (HTRANSM == `IDLE && HREADYINM == 1'b1) begin
        // For Idle cycle No Wait Cycle to be asserted
        PeriphWaitCyc       <= 1'b0;
        end
      else if ((ProgramedWaitCyc !=4'b0000) && (DataTransfer == 1'b1) &&
                iHRESPM == `OKAY_RESP) begin
        if (WaitCycCount < ProgramedWaitCyc && RespClear == 1'b0 &&
            Err2 == 1'b0) begin
          // If number of wait cycle asserted is not equal to
          // programmed wait cycle count, Assert wait cycle and
          // increment wait cycle counter
          TransferClear    <= 1'b0;
          PeriphWaitCyc    <= 1'b1;
          WaitCycCount     <= (WaitCycCount) + 1;
          end
        else begin
          // If number of wait cycle asserted is equal to programmed
          // Wait Cycle count, Clear wait cycle counter
          WaitCycCount     <= 'b0;
          PeriphWaitCyc    <= 1'b0;
          TransferClear    <= 1'b1;
          end
        end
      else if (DefaultWaitCyc !=4'b0000 && iHRESPM == `OKAY_RESP) begin
        if (WaitCycCount < DefaultWaitCyc && RespClear == 1'b0 &&
            Err2 == 1'b0) begin
          // If number of Wait Cycle asserted is not equal to Default
          // Wait Cycle count. Assert Wait Cycle and Increment Wait
          // Cycle counter
          TransferClear    <= 1'b0;
          PeriphWaitCyc    <= 1'b1;
          WaitCycCount     <= (WaitCycCount) + 1;
          end
        else begin
          // If number of wait cycle asserted is equal to default wait
          // Cycle count, Clear wait cycle counter
          WaitCycCount     <= 'b0;
          PeriphWaitCyc    <= 1'b0;
          TransferClear    <= 1'b1;
          end
        end
      else begin
        PeriphWaitCyc    <= 1'b0;
        TransferClear    <= 1'b1;
        end
      end
    else begin
      PeriphWaitCyc    <= 1'b0;
      TransferClear    <= 1'b1;
      end
  end
end // p_PeriphWaitCycSeq

// -----------------------------------------------------------------------------
// Data Check Sequential Block.
// This block is responsible for data comparison. It compares the HWDATAM and
// Expected data. It flags an error message if there is mismatch.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_DataCheckSeq
  if (PeriphWrEn == 1'b1)
    if (DataGenMethod == `RANDOM)
      if (ExpectedData != HWDATAM)
        $display($time," Error : DmacTrPeriph11 : RANDOM METHOD : MISMATCH IN",
                        " EXPECTED AND ACTUAL DATA. EXPECTED DATA : %h",
                         ExpectedData, " ACTUAL DATA :%h",HWDATAM, " \n %m");
    else if (DataGenMethod == `GRAYCODE)
      if (ExpectedData != HWDATAM)
        $display($time," Error : DmacTrPeriph12 : GRAYCODE METHOD : MISMATCH ",
                 "IN EXPECTED AND ACTUAL DATA. EXPECTED DATA : %h ACTUAL",
                       " DATA :%h ", ExpectedData, HWDATAM," \n %m");
    else if (DataGenMethod == `ADDRESSBASED)
      if (ExpectedData != HWDATAM)
        $display ($time, " Error : DmacTrPeriph13 : ADDRESSBASED METHOD : ",
                  "MISMATCH IN EXPECTED AND ACTUAL DATA. EXPECTED DATA : %h ",
                  "ACTUAL DATA :%h", ExpectedData, HWDATAM," \n %m");
    else if (DataGenMethod == `DATABASED)
      if (ExpectedData != HWDATAM)
        $display($time," Error : DmacTrPeriph14 : DATABASED METHOD : MISMATCH ",
                       "IN EXPECTED AND ACTUAL DATA. EXPECTED DATA : %h ACTUAL",
                       " DATA :%h", ExpectedData, HWDATAM," \n %m");
end // p_DataCheckSeq;

// ----------------------------------------------------------------------------
// DMASREQ generation block
// This process is responsible for the assertion of DMACSREQ request.
// ----------------------------------------------------------------------------
always @(iDMACSREQ or DMASTermCount or DMACTC or RegAddr or PeriphReset or
         PeriphEnable or PeriphRegWrEn or DMASCountEn or DMASCntLoad or
         DMACCLR or iDMACBREQ or iDMACLSREQ or iDMACLBREQ)
begin : p_SREQGenComb
  NxtDMACSREQ      = iDMACSREQ;
  NxtDMASCountEn   = DMASCountEn;
  NxtDMASCntLoad   = DMASCntLoad;

  if (PeriphEnable == 1'b1) begin
    // Generate Load signal for DMACTrSCounter. It is generated when there is
    // Write access to DMAC Peripheral request register. The counter load is
    // also generated when only DMACCLR signal is asserted for previous
    // request.
    if ((((PeriphRegWrEn == 1'b1 & RegAddr == `ADDR_DMACTRREQREG)) &
          (iDMACSREQ == 1'b0) & (iDMACBREQ == 1'b0) & (iDMACLSREQ == 1'b0) &
          (iDMACLBREQ == 1'b0)) | (DMACCLR == 1'b1 & DMACTC == 1'b0)) begin
      NxtDMASCntLoad   = 1'b1;
      NxtDMASCountEn   = 1'b1;
      end
    else begin
      NxtDMASCntLoad   = 1'b0;
    end
  end
  // When terminal count occurs assert DMACSREQ request and clear Counter enable
  // signal.
  if (DMASTermCount == 1'b1) begin
    NxtDMACSREQ      = 1'b1;
    NxtDMASCountEn   = 1'b0;
    end
  else if (DMACCLR == 1'b1 | PeriphReset == 1'b1) begin
    // Clear DMACBREQ request when DMACCLR or Peripheral Reset is asserted.
    NxtDMACSREQ      = 1'b0;
  end
end // p_SREQGenComb

// ----------------------------------------------------------------------------
// DMASREQ Sequential block
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SREQGenSeq
  if (HRESETn == 1'b0)
    DMASCntLoad      <= 1'b0;
  else
    DMASCntLoad      <= NxtDMASCntLoad;
end // p_SREQGenSeq

// ----------------------------------------------------------------------------
// DMABREQ generation block
// ----------------------------------------------------------------------------
always @(HRESETn or iDMACBREQ or DMABTermCount or DMACTC or RegAddr or
         PeriphEnable or PeriphRegWrEn or DMABCountEn or DMABCntLoad or
         DMACCLR or iDMACSREQ or iDMACLSREQ or iDMACLBREQ or PeriphReset)
begin : p_BREQGenComb
  NxtDMACBREQ      = iDMACBREQ;
  NxtDMABCountEn   = DMABCountEn;
  NxtDMABCntLoad   = DMABCntLoad;

  if (PeriphEnable == 1'b1) begin
    // Generate Load signal for DMACTrBCounter. It is generated when there is
    // Write access to DMAC Peripheral request register. The counter load is
    // also generated when only DMACCLR signal is asserted for previous
    // request.
    if ((((PeriphRegWrEn == 1'b1 & RegAddr == `ADDR_DMACTRREQREG)) &
          (iDMACSREQ == 1'b0) & (iDMACBREQ == 1'b0) & (iDMACLSREQ == 1'b0) &
          (iDMACLBREQ == 1'b0)) | (DMACCLR == 1'b1 & DMACTC == 1'b0)) begin
      NxtDMABCntLoad   = 1'b1;
      NxtDMABCountEn   = 1'b1;
      end
    else
      NxtDMABCntLoad   = 1'b0;
  end
  // When terminal count occurs assert DMACBREQ request and clear Counter enable
  // signal.
  if (DMABTermCount == 1'b1) begin
    NxtDMACBREQ      = 1'b1;
    NxtDMABCountEn   = 1'b0;
    end
  else if (DMACCLR == 1'b1 | PeriphReset == 1'b1)
  // Clear DMACBREQ request when DMACCLR or Peripheral Reset is asserted.
    NxtDMACBREQ      = 1'b0;
end // p_BREQGenComb

// ----------------------------------------------------------------------------
// DMABREQ Sequential block
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_BREQGenSeq
  if (HRESETn == 1'b0)
    DMABCntLoad      <= 1'b0;
  else
    DMABCntLoad      <= NxtDMABCntLoad;
end // p_BREQGenSeq

// ----------------------------------------------------------------------------
// DMALSREQ generation block
// ----------------------------------------------------------------------------
always @(iDMACLSREQ or DMALSTermCount or DMACTC or RegAddr or PeriphEnable or
         PeriphRegWrEn or DMALSCountEn or DMACCLR or DMALSCntLoad or
         iDMACBREQ or iDMACSREQ or iDMACLBREQ or PeriphReset)
begin : p_LSREQGenComb
  NxtDMACLSREQ     = iDMACLSREQ;
  NxtDMALSCountEn  = DMALSCountEn;
  NxtDMALSCntLoad  = DMALSCntLoad;

  if (PeriphEnable == 1'b1) begin
    // Generate Load signal for DMACTrLSCounter. It is generated when there is
    // Write access to DMAC Peripheral request register. The counter load is
    // also generated when only DMACCLR signal is asserted for previous
    // request.
    if ((((PeriphRegWrEn == 1'b1 & RegAddr == `ADDR_DMACTRREQREG)) &
          (iDMACSREQ == 1'b0) & (iDMACBREQ == 1'b0) & (iDMACLSREQ == 1'b0) &
          (iDMACLBREQ == 1'b0)) | (DMACCLR == 1'b1 & DMACTC == 1'b0))
    begin
      NxtDMALSCntLoad  = 1'b1;
      NxtDMALSCountEn  = 1'b1;
      end
    else
      NxtDMALSCntLoad  = 1'b0;
  end
  if (DMALSTermCount == 1'b1) begin
    // When terminal count occurs assert DMACBREQ request and clear
    // Counter enable signal.
    NxtDMACLSREQ     = 1'b1;
    NxtDMALSCountEn  = 1'b0;
    end
  else if ((DMACCLR == 1'b1 & DMACTC == 1'b1) | PeriphReset == 1'b1)
    // Clear DMACLSREQ request when DMACCLR and DMATC or Peripheral Reset is
    // asserted.
    NxtDMACLSREQ     = 1'b0;
end // p_LSREQGenComb

// ----------------------------------------------------------------------------
// DMALSREQ Sequential block
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LSREQGenSeq
  if (HRESETn == 1'b0)
    DMALSCntLoad     <= 1'b0;
  else
    DMALSCntLoad     <= NxtDMALSCntLoad;
end // p_LSREQGenSeq

// ----------------------------------------------------------------------------
// DMALBREQ generation block
// ----------------------------------------------------------------------------
always @(iDMACLBREQ or DMALBTermCount or DMACTC or RegAddr or PeriphEnable or
         PeriphRegWrEn or DMALBCountEn or DMACCLR or DMALBCntLoad or
         iDMACLSREQ or iDMACSREQ or iDMACBREQ or PeriphReset)
begin : p_LBREQGenComb
  NxtDMACLBREQ     = iDMACLBREQ;
  NxtDMALBCountEn  = DMALBCountEn;
  NxtDMALBCntLoad  = DMALBCntLoad;

  if (PeriphEnable == 1'b1) begin
    // Generate Load signal for DMACTrLBCounter. It is generated when there is
    // Write access to DMAC Peripheral request register. The counter load is
    // also generated when only DMACCLR signal is asserted for previous
    // request.
    if ((((PeriphRegWrEn == 1'b1 & RegAddr == `ADDR_DMACTRREQREG)) &
          (iDMACSREQ == 1'b0) & (iDMACBREQ == 1'b0) & (iDMACLSREQ == 1'b0) &
          (iDMACLBREQ == 1'b0)) | (DMACCLR == 1'b1 & DMACTC == 1'b0)) begin
      NxtDMALBCntLoad  = 1'b1;
      NxtDMALBCountEn  = 1'b1;
      end
    else
      NxtDMALBCntLoad  = 1'b0;
  end
  if (DMALBTermCount == 1'b1) begin
    // When terminal count occurs assert DMACBREQ request and clear Counter
    // enable signal.
    NxtDMACLBREQ     = 1'b1;
    NxtDMALBCountEn  = 1'b0;
    end
  else if ((DMACCLR == 1'b1 & DMACTC == 1'b1) | PeriphReset == 1'b1)
    // Clear DMACLBREQ request when DMACCLR and DMATC or Peripheral Reset is
    // asserted.
    NxtDMACLBREQ     = 1'b0;
end // p_LBREQGenComb

// ----------------------------------------------------------------------------
// DMALBREQ Sequential block
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LBREQGenSeq
  if (HRESETn == 1'b0)
    DMALBCntLoad     <= 1'b0;
  else
    DMALBCntLoad     <= NxtDMALBCntLoad;
end // p_LBREQGenSeq

// ----------------------------------------------------------------------------
// DMACLR comparison block
// ----------------------------------------------------------------------------
always @(DMACCLR or PeriphEnable or PeriphRegWrEn or RegAddr or
         DMACLRTermCount or DMACLRCountEn or DMACLRCntLoad)
begin : p_DMACLRComb
   NxtDMACLRCountEn = DMACLRCountEn;
   NxtDMACLRCntLoad = DMACLRCntLoad;

  if (PeriphEnable == 1'b1)
  begin
    // Generate Load signal for DMACTrCLRCounter. It is generated when there is
    // Write access to DMAC Peripheral request register.
    if (PeriphRegWrEn == 1'b1 & RegAddr == `ADDR_DMACTRCLRREG) begin
      NxtDMACLRCntLoad = 1'b1;
      NxtDMACLRCountEn = 1'b1;
      end
    else
      NxtDMACLRCntLoad = 1'b0;
  end
  if (DMACLRTermCount == 1'b1) begin
    // Clear enable bit of DMACTrCLRCounter when terminal count is reached.
    NxtDMACLRCountEn = 1'b0;
    if (DMACCLR == 1)
      $display($time," ERROR: DmacTrPeriph13: DMACLR IS NOT RECEIVED \n %m");
    end
end // p_DMACLRComb

// ----------------------------------------------------------------------------
// DMACLR Sequential block
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DMACLRSeq
  if (HRESETn == 1'b0)
    DMACLRCntLoad    <= 1'b0;
  else
    DMACLRCntLoad    <= NxtDMACLRCntLoad;
end // p_DMACLRSeq

// ----------------------------------------------------------------------------
// DMATC comparison block
// ----------------------------------------------------------------------------
always @(DMACTC or PeriphEnable or PeriphRegWrEn or RegAddr or
         DMATCTermCount or DMATCCountEn or DMATCCntLoad)
begin : p_DMATCComb
  NxtDMATCCountEn  = DMATCCountEn;
  NxtDMATCCntLoad  = DMATCCntLoad;

  if (PeriphEnable == 1'b1) begin
    // Generate Load signal for DMACTrTCCounter. It is generated when there is
    // Write access to DMAC Peripheral request register.
    if (PeriphRegWrEn == 1'b1 & RegAddr == `ADDR_DMACTRTCREG) begin
      NxtDMATCCntLoad  = 1'b1;
      NxtDMATCCountEn  = 1'b1;
      end
    else
      NxtDMATCCntLoad  = 1'b0;
    end
  if (DMATCTermCount == 1'b1) begin
    // Clear enable bit of DMACTrTCCounter when terminal count is reached.
    NxtDMATCCountEn  = 1'b0;
    if (DMACTC == 1)
      $display($time," ERROR: DmacTrPeriph14: DMATC IS NOT RECEIVED \n %m");
    end
end // p_DMATCComb

// ----------------------------------------------------------------------------
// DMATC Sequential block
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DMATCSeq
  if (HRESETn == 1'b0)
    DMATCCntLoad     <= 1'b0;
  else
    DMATCCntLoad     <= NxtDMATCCntLoad;
end // p_DMATCSeq

// ----------------------------------------------------------------------------
// DMA request generation block
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DMAREQSeq
  if (HRESETn == 1'b0) begin
    iDMACSREQ        <= 1'b0;
    iDMACBREQ        <= 1'b0;
    iDMACLSREQ       <= 1'b0;
    iDMACLBREQ       <= 1'b0;
    end
  else begin
    iDMACSREQ        <= NxtDMACSREQ;
    iDMACBREQ        <= NxtDMACBREQ;
    iDMACLSREQ       <= NxtDMACLSREQ;
    iDMACLBREQ       <= NxtDMACLBREQ;
    end
end // p_DMAREQSeq

// ----------------------------------------------------------------------------
// Counter Enable signal generation block
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_CountEnSeq
  if (HRESETn == 1'b0) begin
    DMASCountEn      <= 1'b0;
    DMABCountEn      <= 1'b0;
    DMALSCountEn     <= 1'b0;
    DMALBCountEn     <= 1'b0;
    DMATCCountEn     <= 1'b0;
    DMACLRCountEn    <= 1'b0;
    end
  else begin
    DMASCountEn      <= NxtDMASCountEn;
    DMABCountEn      <= NxtDMABCountEn;
    DMALSCountEn     <= NxtDMALSCountEn;
    DMALBCountEn     <= NxtDMALBCountEn;
    DMATCCountEn     <= NxtDMATCCountEn;
    DMACLRCountEn    <= NxtDMACLRCountEn;
    end
end // p_CountEnSeq

// -----------------------------------------------------------------------------
// Assigning internal signals to the outputs
// -----------------------------------------------------------------------------
assign HRESP            = iHRESP;

assign HRESPM           = iHRESPM;

assign HREADYOUT        = iHREADYOUT;

assign HREADYOUTM       = iHREADYOUTM;

assign HRDATA           = iHRDATA;

assign HRDATAM          = iHRDATAM;

assign DMACSREQ         = iDMACSREQ;

assign DMACBREQ         = iDMACBREQ;

assign DMACLSREQ        = iDMACLSREQ;

assign DMACLBREQ        = iDMACLBREQ;

// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

endmodule
// --================================== End ==================================--
