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
// File Name              : DmacTrMem.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block mimics a Memory Interface on the AHB bus.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrMem (
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
                  // Memory Address
                  HSELMEM,
                  HWRITEM,
                  HTRANSM,
                  HBURSTM,
                  HSIZEM,
                  HWDATAM,
                  HREADYINM,

// Outputs
                  HREADYOUT,
                  HRESP,
                  HRDATA,
                  HREADYOUTM,
                  HRESPM,
                  HRDATAM
                  );

// Include the parameters file
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
// Memory Address
input         HSELMEM;          // Memory Select
input         HWRITEM;          // Memory Read/Write
input   [1:0] HTRANSM;          // Type of transfer on Memory Interface
input   [2:0] HBURSTM;          // Type of AHB Burst on Memory Interface
input   [2:0] HSIZEM;           // The width of the transfer on Memory Interface
input  [31:0] HWDATAM;          // Memory Write Data
input         HREADYINM;        // Ready response to Memory interface

// Outputs
output        HREADYOUT;        // Ready response from Register interface
output  [1:0] HRESP;            // Transfer response from Register interface
output [31:0] HRDATA;           // Register read Data
output        HREADYOUTM;       // Ready response from Memory interface
output  [1:0] HRESPM;           // Transfer response from Memory interface
output [31:0] HRDATAM;          // Memory read data

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
// Memory Address
wire          HSELMEM;          // Memory Select
wire          HWRITEM;          // Memory Read/Write
wire    [1:0] HTRANSM;          // Type of transfer on Memory Interface
wire    [2:0] HBURSTM;          // Type of AHB Burst on Memory Interface
wire    [2:0] HSIZEM;           // The width of the transfer on Memory Interface
wire   [31:0] HWDATAM;          // Memory Write Data
wire          HREADYINM;        // Ready response to Memory interface

// Outputs
wire          HREADYOUT;        // Ready response from Register interface
wire    [1:0] HRESP;            // Transfer response from Register interface
wire   [31:0] HRDATA;           // Register read Data
wire          HREADYOUTM;       // Ready response from Memory interface
wire    [1:0] HRESPM;           // Transfer response from Memory interface
wire   [31:0] HRDATAM;          // Memory read data

// -----------------------------------------------------------------------------
//
//                                  DmacTrMem
//                                  =========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//        This module is a behavioural model of a Memory interface. It has 2 AHB
// slave interfaces. One AHB slave port is used to program the control registers
// and the other slave port is used by the DMAC for memory access. The control
// registers are programmed to provide different data generation methods and
// various responses depending on data pattern. For source data transfers, this
// module generates the required number of data depending on data generation
// method. Any one data generation method, out of Four data generation methods,
// can be used. If this module is programmed for destination data transfer,
// it generates the expected data and compares it with incoming data. The module
// flags an error if there is mismatch in incoming and expected data. This
// block also responsible for LLI loading. The Data generation methods are
// Random, GRAYCODE, Address based and Data based method. The following sub
// methods are used along with above data generation methods. The sub methods
// are Increment, Decrement, 1's complement and 2's complement. The above sub
// methods are only applicable to Address and Data generation method.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define LLILOWADDRRANGE  'b0000000000000000000000000

`define LLIHIGHADDRRANGE 'b0000000000000000000001111

`define LLILOWSLAVERANGE 'b10000000

`define LLIHIGHSLAVERANGE 'b10001111

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire          Cyc1;
// First cycle of error response

wire          Err1;
// First cycle of split/retry/error response

wire          MemEnable;
// Memory model enable bit

wire          MemReset;
// Memory reset bit

wire    [7:6] DefaultNoOfResp;
// Default number of split and retry response

wire    [5:2] DefaultWaitCyc;
// Default wait cycles to be asserted by memory

wire          Endianness;
// Indicate memory module is configured for Little/Big endian mode

wire    [1:0] DefaultResp;
// Default Response should be asserted by memory

wire    [3:0] Offset;
// Offset to generate address based data

wire    [31:0] DMACTrMemReg0;
// Zero th location of Memory

wire    [31:0] DMACTrMemReg1;
// Zero th location of Memory

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [`MASTERADDRHB:`MASTERADDRLB] MemAddr;
// Clocked memory address

reg  [`SLAVEADDRHB:`SLAVEADDRLB] RegAddr;
// Clocked register address

reg     [2:0] RegSize;
// Clocked HSIZE

reg     [2:0] MemSize;
// Clocked HSIZEM

reg     [1:0] RegTrans;
// Clocked HTRANS

reg     [1:0] MemTrans;
// Clocked HTRANSM

reg           Selected;
// Selected state of the memory

reg     [1:0] iHRESP;
// Data transfer response from register interface

reg     [1:0] iHRESPM;
// Data transfer response from memory interface

reg           iHREADYOUT;
// Ready response from register interface

reg           iHREADYOUTM;
// Ready response from memory interface

reg    [31:0] iHRDATA;
// Register read data

reg    [31:0] iHRDATAM;
// Memory read data

reg           MemRegWrEn;
// Write enable for memory-specific register

reg           LLIRegWrEn;
// Write enable for LLI memory block

reg           Cyc2;
// Second cycle of error response

reg           Err2;
// Second cycle of split/retry/error response

reg           MemWrEn;
// Memory write enable

reg           LLIRdEn;
// LLI read enable

wire    [9:8] DataGenMethod;
// Data pattern generation method

reg   [23:22] PrgmRespCount;
// Programmed number of split and retry response

reg     [2:0] RespCount;
// To Count number of split and retry response asserted

reg           DefIndicate;
// To indicate Default split and retry response asserted

reg           PrgmIndicate;
// To indicate programmed split and retry response asserted

reg           PrgmIndSync;
// Delayed PrgmIndicate

reg     [1:0] PrgmRespSync;
// Delayed Programmed Response

reg   [21:18] ProgramedWaitCyc;
// Programmed wait cycles to be asserted by memory.

reg           MemWaitCyc;
// To indicate wait cycle to be asserted

reg           DataTransfer;
// To indicate data is transferred

reg           TransferClear;
// To clear DataTransfer signal

reg     [3:0] WaitCycCount;
// To count number of wait cycle asserted

reg    [15:0] RdTotalTrans;
// To count number of read data

reg    [15:0] WrTotalTrans;
// To count number of write data

wire    [7:6] DataMethod;
// Type of method to be used to generate address based data

reg     [7:0] RdPreviousData;
// To hold the previous cycle memory read data

reg     [7:0] WrPreviousData;
// To hold the previous cycle memory write data

reg    [31:0] ExpectedData;
// To hold expected data

reg           RespOkInform;
// Indicates OK response should be asserted

reg           RespClear;
// To clear response count.

reg  [`SLAVEADDRHB:`SLAVEADDRLB] NxtRegAddr;
// D Input RegAddr

reg     [2:0] NxtRespCount;
// D Input of RespCount

reg           FirstAccess;
// Indicate first access of DMAC

reg  [`MASTERADDRHB:`MASTERADDRLB] NxtMemAddr;
// D Input MemAddr

reg     [1:0] NxtRegTrans;
// D input of RegTrans

reg     [1:0] NxtMemTrans;
// D input of MemTrans

reg     [2:0] NxtRegSize;
// D input of RegSize

reg     [2:0] NxtMemSize;
// D input of MemSize

reg           NxtMemRegWrEn;
// D Input of MemRegWrEn

reg           NxtLLIRegWrEn;
// D Input of LLIRegWrEn

reg           NxtMemWrEn;
// D Input of MemRegWrEn

reg           NxtLLIRdEn;
// D Input of MemRegWrEn

reg     [1:0] NxtPrgmRespSync;
// D Input of PrgmRespSync

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Array declarations
// -----------------------------------------------------------------------------
reg [31:0] iDMACTrMemReg [(`NO_OF_REG-1):0];
// Memory register

reg [31:0] iLLIBlock     [(`MEMORYDEPTH-1):0];
// LLI block

reg [31:0] NxtLLIBlock   [(`MEMORYDEPTH-1):0];
// D input of iLLIBlock

integer RdCount, i;
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Latching of Register Address
// -----------------------------------------------------------------------------
always @(HSELREG or HREADYIN or HTRANS or HADDR or RegAddr)
begin : p_RegAddrComb
  NxtRegAddr       = RegAddr;
  if ((HSELREG == 1'b1) && (HREADYIN == 1'b1) &&
      (HTRANS == `NSEQ || HTRANS == `SEQ))
    begin
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
// -----------------------------------------------------------------------------
always @(HSELMEM or HREADYINM or HTRANSM or HADDRM or MemAddr)
begin : p_MemAddrComb
  NxtMemAddr       = MemAddr;
  if ((HSELMEM == 1'b1) && (HREADYINM == 1'b1) &&
      (HTRANSM == `NSEQ || HTRANSM == `SEQ)) begin
    NxtMemAddr       = HADDRM[`MASTERADDRHB:`MASTERADDRLB];
    end
end // p_MemAddrComb

// -----------------------------------------------------------------------------
// Memory Address sequential logic
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_MemAddrSeq
  if (HRESETn == 1'b0) begin
    MemAddr          <= 'b0;
    end
  else begin
    MemAddr          <= NxtMemAddr;
    end
end // p_MemAddrSeq

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
always @(HSELMEM or HREADYINM or HTRANSM or MemTrans or Selected)
begin : p_MemTransComb
  NxtMemTrans      = MemTrans;
  if (HREADYINM == 1'b1 && HSELMEM == 1'b1) begin
    NxtMemTrans      = HTRANSM;
    end
  else if (Selected == 1'b0) begin
    NxtMemTrans      = `IDLE;
    end
end // p_MemTransComb

// -----------------------------------------------------------------------------
// Memory Selected State Generation Block
// The Selected signal indicates selected state of the memory block. It
// indicates valid duration where the memory block should assert default/
// programmed response The Selected signal is set when there is HREADYINM or
// default/programmed response to be asserted. The signal is cleared when all
// default/programmed responses are asserted for current transfer.
// -----------------------------------------------------------------------------
always @(HRESETn or HREADYINM or MemWaitCyc or RespClear or MemEnable or
         DefIndicate or PrgmIndicate)
begin : p_SelcectedSeq
 if (HRESETn == 1'b0) begin
   Selected         = 1'b0;
   end
 else begin
   if (HREADYINM == 1'b1 || ((DefIndicate == 1'b1 || PrgmIndicate == 1'b1) ||
        (MemWaitCyc == 1'b1 && RespClear == 1'b0 && MemEnable == 1'b1))) begin
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
begin : p_MemTransSeq
  if (HRESETn == 1'b0) begin
    MemTrans         <= 2'b0;
    end
  else begin
    MemTrans         <= NxtMemTrans;
    end
end // p_MemTransSeq

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
// LLI Read signal combinational block.
// The LLI read signal is set when HADDRM lies in the LLI block Master address
// range and there is valid read access to Memory block.
// -----------------------------------------------------------------------------
always @(HSELMEM or HWRITEM or HREADYINM or HTRANSM or HADDRM or LLIRdEn)
begin : p_LLIRdComb
  NxtLLIRdEn       = LLIRdEn;
  if ((HSELMEM == 1'b1) && (HREADYINM == 1'b1) &&
      (HTRANSM == `NSEQ || HTRANSM == `SEQ)) begin
    if ((HADDRM[`MASTERADDRHB:2] >= `LLILOWADDRRANGE) &&
        (HADDRM[`MASTERADDRHB:2] <= `LLIHIGHADDRRANGE)) begin
      if (HWRITEM == 1'b0) begin
        NxtLLIRdEn       = 1'b1;
        end
      else begin
        NxtLLIRdEn       = 1'b0;
        end
      end
    else begin
      NxtLLIRdEn       = 1'b0;
      end
    end
  else begin
    NxtLLIRdEn       = 1'b0;
    end
end // p_LLIRdComb

// -----------------------------------------------------------------------------
// LLI Read Signal Sequential block
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LLIWrSeq
  if (HRESETn == 1'b0) begin
    LLIRdEn          <= 1'b0;
    end
  else begin
    LLIRdEn          <= NxtLLIRdEn;
    end
end // p_LLIWrSeq

// -----------------------------------------------------------------------------
// Memory SIZE Combinational logic
// -----------------------------------------------------------------------------
always @(HSELMEM or HREADYINM or HSIZEM or HTRANSM or MemSize)
begin : p_MemSizeComb
  NxtMemSize       = MemSize;
  if ((HSELMEM == 1'b1) && (HREADYINM == 1'b1) &&
      (HTRANSM == `NSEQ || HTRANSM == `SEQ)) begin
    NxtMemSize       = HSIZEM[2:0];
    end
end // p_MemSizeComb

// -----------------------------------------------------------------------------
// Latching of HSIZEM
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_MemSizeSeq
  if (HRESETn == 1'b0) begin
    MemSize          <= 3'b0;
    end
  else begin
    MemSize          <= NxtMemSize;
    end
end // p_MemSizeSeq

// -----------------------------------------------------------------------------
// Generation of Register Read/Write signal
// -----------------------------------------------------------------------------
always @(HTRANS or HSELREG or HREADYIN or HWRITE)
begin : p_RegWrGenComb
  if ((HSELREG == 1'b1) && (HREADYIN == 1'b1) &&
       (HTRANS == `NSEQ || HTRANS == `SEQ) && HWRITE == 1'b1) begin
    NxtMemRegWrEn    = 1'b1;
    end
  else begin
    NxtMemRegWrEn    = 1'b0;
    end
end // p_RegWrGenComb

// -----------------------------------------------------------------------------
// Latching of Register read/write signal
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegWrGenSeq
  if (HRESETn == 1'b0) begin
    MemRegWrEn       <= 1'b0;
    end
  else begin
    MemRegWrEn       <= NxtMemRegWrEn;
    end
end // p_RegWrGenSeq

// -----------------------------------------------------------------------------
// Generation of Memory Read/Write signal
// -----------------------------------------------------------------------------
always @(HTRANSM or HSELMEM or HREADYINM or HWRITEM or MemWrEn)
begin : p_MemWrGenComb
  NxtMemWrEn       = MemWrEn;
  if ((HSELMEM == 1'b1) && (HREADYINM == 1'b1) &&
      (HTRANSM == `NSEQ || HTRANSM == `SEQ) && HWRITEM == 1'b1) begin
    NxtMemWrEn       = 1'b1;
    end
  else begin
    NxtMemWrEn       = 1'b0;
    end
end // p_MemWrGenComb

// -----------------------------------------------------------------------------
// Latching of Memory read/write signal
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_MemWrGenSeq
  if (HRESETn == 1'b0) begin
    MemWrEn          <= 1'b0;
    end
  else begin
    MemWrEn          <= NxtMemWrEn;
    end
end // p_MemWrGenSeq

// -----------------------------------------------------------------------------
// LLI block write combo logic
// The LLI block slave write signal is set when HADDR lies in the LLI block
// Slave address range and there is valid Write to register block.
// -----------------------------------------------------------------------------
always @(HTRANS or HSELREG or HREADYIN or HWRITE or HADDR or LLIRegWrEn)
begin : p_LLIRegWrComb
  NxtLLIRegWrEn    = LLIRegWrEn;
  if ((HSELREG == 1'b1) && (HREADYIN == 1'b1) &&
      (HTRANS == `NSEQ || HTRANS == `SEQ)) begin
    if ((HADDR[`SLAVEADDRHB:`SLAVEADDRLB] >= `LLILOWSLAVERANGE) &&
        (HADDR[`SLAVEADDRHB:`SLAVEADDRLB] <= `LLIHIGHSLAVERANGE)) begin
        if (HWRITE == 1'b1) begin
          NxtLLIRegWrEn    = 1'b1;
          end
        else begin
          NxtLLIRegWrEn    = 1'b0;
          end
      end
    else begin
      NxtLLIRegWrEn    = 1'b0;
      end
    end
  else begin
    NxtLLIRegWrEn    = 1'b0;
    end
end // p_LLIRegWrComb

// -----------------------------------------------------------------------------
// Generation of Register read/write signal
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LLIRegWrSeq
  if (HRESETn == 1'b0) begin
    LLIRegWrEn       <= 1'b0;
    end
  else begin
    LLIRegWrEn       <= NxtLLIRegWrEn;
    end
end // p_LLIRegWrSeq

// ----------------------------------------------------------------------------
// Memory Register Read Write Block.
// This combination process is responsible for writing in Register/LLI slave
// block and reading of register block. It also gives AHB response for each
// read/write to register/LLI block.
// ----------------------------------------------------------------------------
always @(HRESETn or MemRegWrEn or RegTrans or RegSize or
         RegAddr or HWDATA or LLIRegWrEn)
begin : p_RegRdWrComb
  iHRDATA          = 32'b0;
  for(i=0; i<`NO_OF_REG; i=i+1)
    NxtLLIBlock[i] = iLLIBlock[i];

  if (HRESETn == 1'b0) begin
    iHRDATA          = 32'b0;
    iHRESP           = 2'b0;
    end

  if (MemRegWrEn == 1'b1) begin
    if (LLIRegWrEn == 1'b1) begin
      if (RegTrans == `NSEQ || RegTrans == `SEQ) begin
        if (RegSize == `WORD) begin
          NxtLLIBlock[RegAddr[5:2]] = HWDATA[31:0];
          iHRESP           = `OKAY_RESP;
          end
        else begin
          $display($time,"Error : DmacTrMem1 : LLI WRITE ACCESS IS NOT",
                         " WORD WIDE \n %m");
          iHRESP           = `ERROR_RESP;
          end
        end
      end
    else begin
      if (RegTrans == `NSEQ || RegTrans == `SEQ) begin
        if (RegSize == `WORD) begin
          iHRESP           = `OKAY_RESP;
          end
        else begin
          $display($time,"Error : DmacTrMem2 : WRITE ACCESS IS NOT",
                        " WORD WIDE \n %m");
          iHRESP           = `ERROR_RESP;
          end
        end
      else begin
        iHRESP           = `OKAY_RESP;
        end
      end
    end
  else begin
    if (RegTrans == `NSEQ || RegTrans == `SEQ) begin
      if (LLIRegWrEn == 1'b0) begin
        if ((RegAddr[`SLAVEADDRHB:`SLAVEADDRLB] >= `LLILOWSLAVERANGE) &&
             (RegAddr[`SLAVEADDRHB:`SLAVEADDRLB] <= `LLIHIGHSLAVERANGE)) begin
          if (RegSize == `WORD) begin
            iHRDATA          =
              iLLIBlock[RegAddr[(`SLAVEADDRLB +3):`SLAVEADDRLB]];
            end
          else begin
            $display ($time," Error : DmacTrMem3 : LLI SLAVE READ",
                           " ACCESS IS NOT WORD WIDE \n %m");
            end
          end
        end
      else begin
        if (RegSize == `WORD) begin
          iHRDATA          = iDMACTrMemReg[RegAddr];
          iHRESP           = `OKAY_RESP;
          end
        else begin
          $display($time," Error : DmacTrMem4 : READ ACCESS IS NOT ",
                        " WORD WIDE \n %m");
          iHRESP           = `ERROR_RESP;
          end
        end
      end
    else begin
      iHRESP           = `OKAY_RESP;
      end
    end
end // p_RegRdWrComb

// -----------------------------------------------------------------------------
// LLI write sequential block
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LLISeq
  if (HRESETn == 1'b0) begin
    for(i=0; i<`MEMORYDEPTH; i=i+1)
      iLLIBlock[i]     <= 'b0;
    end
  else begin
    for(i=0; i<`MEMORYDEPTH; i=i+1)
     iLLIBlock[i]     <= NxtLLIBlock[i];
    end
end // p_LLISeq

// ----------------------------------------------------------------------------
// Write Block for Memory Registers
// This process is responsible for the updating of register block. When there is
// valid write to register block, it writes in register indicated by RegAddr.
// This process clears all control register except control 1 register when
// Memory reset bit is set. It clears all registers when HRESETn is asserted.
// -----------------------------------------------------------------------------
reg [31:0] TempRegValue;

always @(posedge HCLK or negedge HRESETn)
begin : p_RegSeq
  if (HRESETn == 1'b0) begin
    for(i=0; i<`NO_OF_REG; i=i+1)
      iDMACTrMemReg[i] <= 'b0;
    end
  else begin
    if (MemReset == 1'b1) begin
      TempRegValue = iDMACTrMemReg[0];
      for(i=0; i<`NO_OF_REG; i=i+1)
        iDMACTrMemReg[i] <= 'b0;
        iDMACTrMemReg[0] <= TempRegValue;
      end
    if ((MemRegWrEn == 1'b1) && (RegSize == `WORD) && LLIRegWrEn == 1'b0) begin
      iDMACTrMemReg[RegAddr] <= HWDATA;
      end
    end
end // p_RegSeq

// -----------------------------------------------------------------------------
// Assigning internal signals values
// -----------------------------------------------------------------------------
assign DMACTrMemReg0    = iDMACTrMemReg[0];
assign DMACTrMemReg1    = iDMACTrMemReg[1];

assign MemEnable        = DMACTrMemReg0[31];
assign MemReset         = DMACTrMemReg0[30];
assign DataGenMethod    = DMACTrMemReg0[9:8];
assign DefaultNoOfResp  = DMACTrMemReg0[7:6];
assign DefaultWaitCyc   = DMACTrMemReg0[5:2];
assign DefaultResp      = DMACTrMemReg0[1:0];
assign Endianness       = DMACTrMemReg0[10];
assign DataMethod       = DMACTrMemReg1[7:6];
assign Offset           = DMACTrMemReg1[3:0];

// -----------------------------------------------------------------------------
// Register two Cycle Response Generation
// Cyc1 Generation
// -----------------------------------------------------------------------------
// Cyc1 is set HIGH during the first cycle of an error response.
// The registered Cyc2 is HIGH during the second cycle of the error
// response.

assign Cyc1             = (iHRESP == `ERROR_RESP && Cyc2 == 1'b0) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Cyc2 Generation
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
// Memory two Cycle Response Generation
// Err1 Generation :
// Err1 is set HIGH during the first cycle of an error response.
// The registered Err2 is HIGH during the second cycle of the error response.
// -----------------------------------------------------------------------------
assign Err1             = (iHRESPM != `OKAY_RESP && Err2 == 1'b0) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Err2 Generation
// Err2 is delayed version of Err1
// ---------------------------------------------------------------------
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
always @(HRESETn or Err1 or Err2 or MemWaitCyc)
begin : p_MemoryReadyComb
  if (HRESETn == 1'b0) begin
    iHREADYOUTM      = 1'b1;
    end
  else if (Err1 == 1'b1 && Err2 == 1'b0) begin
    iHREADYOUTM      = 1'b0;
    end
  else if (Err1 == 1'b0 && Err2 == 1'b1) begin
    iHREADYOUTM      = 1'b1;
    end
  else if (MemWaitCyc == 1'b1) begin
    iHREADYOUTM      = 1'b0;
    end
  else if (MemWaitCyc ==1'b0) begin
    iHREADYOUTM      = 1'b1;
    end
end // p_MemoryReadyComb

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
always @(negedge HRESETn or posedge HCLK)
begin : p_MemoryRdSeq
  if (HRESETn == 1'b0) begin
    // Clear previous cycle memory read data.
    RdPreviousData   <= 'b0;
    // Clear HRDATAM.
    iHRDATAM         <= 'b0;
    // Clear Number of total read data transfer.
    RdTotalTrans     <= 'b0;
    end
  else begin
    if (MemReset == 1'b1) begin
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

    if ((HSELMEM == 1'b1) && (HREADYINM == 1'b1)) begin
      if (HWRITEM == 1'b0 && RespCount == 3'b000 && RespClear == 1'b0) begin
        if (MemEnable == 1'b1) begin
          if ((HADDRM[`MASTERADDRHB:2] >= `LLILOWADDRRANGE) &&
              (HADDRM[`MASTERADDRHB:2] <= `LLIHIGHADDRRANGE)) begin
            if (HSIZEM == `WORD) begin
              // If there is valid LLI word wide read access,
              // output HRDTAM from location indicated by HADDRM
              // from LLI block
              iHRDATAM         <= iLLIBlock[HADDRM[5:2]];
              end
            else if (HTRANSM != `IDLE && Selected == 1'b1) begin
              // If LLI read is Non Word access, assert error
              $display($time, " Error : DmacTrMem5 : LLI READ",
                              " ACCESS IS NOT WORD WIDE \n %m");
              end
            end
          else if (FirstAccess == 1'b1) begin
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
                      TempRd   = AddrBasedGen(TempAddr, Offset,
                                              DataMethod);
                      end

                    // Data Based Data generation Method
                    `DATABASED : begin
                      // Load previous cycle read data.
                      RdFlag   = 1'b0;
                      TempRd   = DataBasedGen(TempRd, Offset,
                                                DataMethod);
                      end

                    default : begin
                      // Invalid Data Generation Method
                      $display($time," Error : DmacTrMem6 : ",
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
                          Shifted_DataRd
                            = {Shifted_DataRd[15:0],
                               16'b0};
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
                          Shifted_DataRd =
                           {Shifted_DataRd[15:0],16'b0};
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
                if (DataGenMethod == `RANDOM |
                    DataGenMethod == `GRAYCODE |
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

      if (RdFlag == 1'b0) begin
        RdPreviousData   = TempRd;
        end
      else begin
        RdPreviousData   = DMACTrMemReg1[31:24];
        end
    end
end // p_MemoryRdSeq

// -----------------------------------------------------------------------------
// Memory Read Write Combo Logic.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_RdWrDataComb
  // If Memory Read/Write access is non BYTE/Half Word/Word access then assert
  // error message. If memory model is not enabled, return error message to
  // memory read/write access.

  if (MemWrEn == 1'b1) begin
    if (MemEnable == 1'b1) begin
      if ((MemTrans == `NSEQ) || (MemTrans == `SEQ)) begin
        if ((MemSize != `BYTE) && (MemSize != `HWORD) &&
            (MemSize != `WORD)) begin
          $display($time,"Error : DmacTrMem7 : WRITE ACCESS OF ",
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
    if (MemEnable == 1'b1) begin
      if (FirstAccess == 1'b1) begin
        if ((MemTrans == `NSEQ) || (MemTrans == `SEQ)) begin
          if ((MemSize != `BYTE) && (MemSize != `HWORD) &&
              (MemSize != `WORD)) begin
            $display($time," Error : DmacTrMem8 : READ ACCESS OF ",
                           " INVALID HSIZEM  \n %m");
            end
          end
        end
      end
    else begin
      if (Selected == 1'b1 && FirstAccess == 1'b1 && MemTrans != `IDLE) begin
        $display($time,"Error : DmacTrMem9 : MEMORY MODEL IS NOT",
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
    if (MemReset == 1'b1) begin
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
      WrPreviousData   <= DMACTrMemReg1[31:24];
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

    if ((HSELMEM == 1'b1) && (HREADYINM == 1'b1)) begin
      if (HWRITEM == 1'b1 && RespCount == 3'b000 && RespClear == 1'b0) begin
        if (MemEnable == 1'b1) begin
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
                    TempWr = AddrBasedGen(TempAddrWr, Offset,
                                          DataMethod);
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
                  $display($time," Error : DmacTrMem10 : INVALID ",
                                 "DATA GENERATION METHOD FOR ",
                                 "WRITE DATA COMPARISION \n %m");
                  end
              endcase
              if (WrFlag == 1'b0) begin
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
reg   [31:0]  DMACTrMemRegk;
reg   [31:0]  DMACTrMemRegj1;

reg        Found;
integer  ValidBits;
integer    j1, k;
reg [15:0] TransCount;

always @(HRESETn or MemReset or MemAddr or MemTrans or PrgmIndSync or MemSize or
         LLIRdEn or MemEnable or DefaultResp or FirstAccess or
         MemWrEn or TransferClear or Err2 or RespClear or RespCount or
         RespOkInform or MemWaitCyc or Selected or PrgmRespSync)
begin : p_RespDecideComb
  NxtRespCount     = RespCount;
  NxtPrgmRespSync  = PrgmRespSync;
  if (HRESETn == 1'b0) begin
    // Assert OK response on reset
    iHRESPM          = 'b0;
    end

  if (HRESETn == 1'b0 || MemReset == 1'b1) begin
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
  if (MemWrEn == 1'b1) begin
    // Assign Total number of Write Data Transfer to TransCount
    TransCount = WrTotalTrans;
    end
  else begin
    // Assign Total number of Read Data Transfer to TransCount
    TransCount = RdTotalTrans;
    end

  if (Selected == 1'b1) begin
    if (MemTrans == `IDLE)
      // Assert OK response to IDLE transfer
      iHRESPM          = `OKAY_RESP;
    else if (LLIRdEn == 1'b1 && MemSize != `WORD)
      // Assert Error Response for non word LLI read access
      iHRESPM          = `ERROR_RESP;
    else begin
      iHRESPM          = `OKAY_RESP;
      if (MemEnable == 1'b1) begin
        if (MemSize == `BYTE || MemSize == `HWORD || MemSize == `WORD) begin
          if (MemReset == 1'b1) begin
            // If Memory reset bit is set, assert Error Response for
            // memory read/write access.
            iHRESPM          = `ERROR_RESP;
            $display($time,"Error : MemReset1: Memory Reset bit is set.",
                           " In Valid Access. \n %m");
            end
          else begin
            if (HREADYINM == 1'b1) begin : L5
              k = 0;
              // Programmed response assertion block.

              // L4 : for j in 2 to (`NO_OF_REG-1) loop
              for (j1 = 2; j1 < `NO_OF_REG; j1 = j1 + 1) begin : L4
                // Check Control register Enable bit is set
                DMACTrMemRegj1 = iDMACTrMemReg[j1];
                if (DMACTrMemRegj1[31] ==1'b1) begin
                  if (DMACTrMemRegj1[30] == 1'b0) begin
                    // Address based Programmed Response assertion method
                    // Determine Valid bits and Compare Memory address with
                    // AddressCount. If it equals set Flag True.
                    ValidBits = DMACTrMemRegj1[27:24];
                    if (DMACTrMemRegj1[29:28] == 2'b00) begin
                      case (ValidBits)
                        0 :
                           if (MemAddr[0:0] == DMACTrMemRegj1[0:0])
                             Flag              = 1'b1;
                        1 :
                           if (MemAddr[1:0] == DMACTrMemRegj1[1:0])
                             Flag              = 1'b1;
                        2 :
                           if (MemAddr[2:0] == DMACTrMemRegj1[2:0])
                             Flag              = 1'b1;
                        3 :
                           if (MemAddr[3:0] == DMACTrMemRegj1[3:0])
                             Flag              = 1'b1;
                        4 :
                           if (MemAddr[4:0] == DMACTrMemRegj1[4:0])
                             Flag              = 1'b1;
                        5 :
                           if (MemAddr[5:0] == DMACTrMemRegj1[5:0])
                             Flag              = 1'b1;
                        6 :
                           if (MemAddr[6:0] == DMACTrMemRegj1[6:0])
                             Flag              = 1'b1;
                        7 :
                           if (MemAddr[7:0] == DMACTrMemRegj1[7:0])
                             Flag              = 1'b1;
                        8 :
                           if (MemAddr[8:0] == DMACTrMemRegj1[8:0])
                             Flag              = 1'b1;
                        9 :
                           if (MemAddr[9:0] == DMACTrMemRegj1[9:0])
                             Flag              = 1'b1;
                        10 :
                           if (MemAddr[10:0] == DMACTrMemRegj1[10:0])
                             Flag              = 1'b1;
                        11 :
                           if (MemAddr[11:0] == DMACTrMemRegj1[11:0])
                             Flag              = 1'b1;
                        12 :
                           if (MemAddr[12:0] == DMACTrMemRegj1[12:0])
                             Flag              = 1'b1;
                        13 :
                           if (MemAddr[13:0] == DMACTrMemRegj1[13:0])
                             Flag              = 1'b1;
                        14 :
                           if (MemAddr[14:0] == DMACTrMemRegj1[14:0])
                             Flag              = 1'b1;
                        15 :
                           if (MemAddr[15:0] == DMACTrMemRegj1[15:0])
                             Flag              = 1'b1;
                        default :
                           if (MemAddr[15:0] == DMACTrMemRegj1[15:0])
                             Flag              = 1'b1;
                      endcase
                      end
                    else if (DMACTrMemRegj1[29:28] == 2'b01) begin
                      case (ValidBits)
                        0 :
                           if (MemAddr[1:1] == DMACTrMemRegj1[1:1])
                             Flag              = 1'b1;
                        1 :
                           if (MemAddr[2:1] == DMACTrMemRegj1[2:1])
                             Flag              = 1'b1;
                        2 :
                           if (MemAddr[3:1] == DMACTrMemRegj1[3:1])
                             Flag              = 1'b1;
                        3 :
                           if (MemAddr[4:1] == DMACTrMemRegj1[4:1])
                             Flag              = 1'b1;
                        4 :
                           if (MemAddr[5:1] == DMACTrMemRegj1[5:1])
                             Flag              = 1'b1;
                        5 :
                           if (MemAddr[6:1] == DMACTrMemRegj1[6:1])
                             Flag              = 1'b1;
                       6 :
                           if (MemAddr[7:1] == DMACTrMemRegj1[7:1])
                             Flag              = 1'b1;
                        7 :
                           if (MemAddr[8:1] == DMACTrMemRegj1[8:1])
                             Flag              = 1'b1;
                       8 :
                           if (MemAddr[9:1] == DMACTrMemRegj1[9:1])
                             Flag              = 1'b1;
                        9 :
                           if (MemAddr[10:1] == DMACTrMemRegj1[10:1])
                             Flag              = 1'b1;
                        10 :
                           if (MemAddr[11:1] == DMACTrMemRegj1[11:1])
                             Flag              = 1'b1;
                        11 :
                           if (MemAddr[12:1] == DMACTrMemRegj1[12:1])
                             Flag              = 1'b1;
                        12 :
                           if (MemAddr[13:1] == DMACTrMemRegj1[13:1])
                             Flag              = 1'b1;
                       13 :
                           if (MemAddr[14:1] == DMACTrMemRegj1[14:1])
                             Flag              = 1'b1;
                        14 :
                           if (MemAddr[15:1] == DMACTrMemRegj1[15:1])
                             Flag              = 1'b1;
                        15 :
                           if (MemAddr[16:1] == DMACTrMemRegj1[16:1])
                             Flag              = 1'b1;
                        default :
                           if (MemAddr[16:1] == DMACTrMemRegj1[16:1])
                             Flag              = 1'b1;
                      endcase
                      end
                    else if (DMACTrMemRegj1[29:28] == 2'b10) begin
                      case (ValidBits)
                        0 :
                           if (MemAddr[2:2] == DMACTrMemRegj1[0:0])
                             Flag              = 1'b1;
                        1 :
                           if (MemAddr[3:2] == DMACTrMemRegj1[1:0])
                             Flag              = 1'b1;
                        2 :
                           if (MemAddr[4:2] == DMACTrMemRegj1[2:0])
                             Flag              = 1'b1;
                        3 :
                           if (MemAddr[5:2] == DMACTrMemRegj1[3:0])
                             Flag              = 1'b1;
                        4 :
                           if (MemAddr[6:2] == DMACTrMemRegj1[4:0])
                             Flag              = 1'b1;
                        5 :
                           if (MemAddr[7:2] == DMACTrMemRegj1[5:0])
                             Flag              = 1'b1;
                       6 :
                           if (MemAddr[8:2] == DMACTrMemRegj1[6:0])
                             Flag              = 1'b1;
                        7 :
                           if (MemAddr[9:2] == DMACTrMemRegj1[7:0])
                             Flag              = 1'b1;
                       8 :
                           if (MemAddr[10:2] == DMACTrMemRegj1[8:0])
                             Flag              = 1'b1;
                        9 :
                           if (MemAddr[11:2] == DMACTrMemRegj1[9:0])
                             Flag              = 1'b1;
                        10 :
                           if (MemAddr[12:2] == DMACTrMemRegj1[10:0])
                             Flag              = 1'b1;
                        11 :
                           if (MemAddr[13:2] == DMACTrMemRegj1[11:0])
                             Flag              = 1'b1;
                        12 :
                           if (MemAddr[14:2] == DMACTrMemRegj1[12:0])
                             Flag              = 1'b1;
                       13 :
                           if (MemAddr[15:2] == DMACTrMemRegj1[13:0])
                             Flag              = 1'b1;
                        14 :
                           if (MemAddr[16:2] == DMACTrMemRegj1[14:0])
                             Flag              = 1'b1;
                        15 :
                           if (MemAddr[17:2] == DMACTrMemRegj1[15:0])
                             Flag              = 1'b1;
                        default :
                           if (MemAddr[17:2] == DMACTrMemRegj1[15:0])
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
                    ValidBits = DMACTrMemRegj1[27:24];
                      case (ValidBits)
                        0 :
                          if (TransCount[0:0] == DMACTrMemRegj1[0:0])
                            Flag              = 1'b1;
                        1 :
                          if (TransCount[1:0] == DMACTrMemRegj1[1:0])
                            Flag              = 1'b1;
                        2 :
                          if (TransCount[2:0] == DMACTrMemRegj1[2:0])
                            Flag              = 1'b1;
                        3 :
                          if (TransCount[3:0] == DMACTrMemRegj1[3:0])
                            Flag              = 1'b1;
                        4 :
                          if (TransCount[4:0] == DMACTrMemRegj1[4:0])
                            Flag              = 1'b1;
                        5 :
                          if (TransCount[5:0] == DMACTrMemRegj1[5:0])
                            Flag              = 1'b1;
                       6 :
                          if (TransCount[6:0] == DMACTrMemRegj1[6:0])
                            Flag              = 1'b1;
                        7 :
                          if (TransCount[7:0] == DMACTrMemRegj1[7:0])
                            Flag              = 1'b1;
                       8 :
                          if (TransCount[8:0] == DMACTrMemRegj1[8:0])
                            Flag              = 1'b1;
                        9 :
                          if (TransCount[9:0] == DMACTrMemRegj1[9:0])
                            Flag              = 1'b1;
                        10 :
                          if (TransCount[10:0] == DMACTrMemRegj1[10:0])
                            Flag              = 1'b1;
                        11 :
                          if (TransCount[11:0] == DMACTrMemRegj1[11:0])
                            Flag              = 1'b1;
                        12 :
                          if (TransCount[12:0] == DMACTrMemRegj1[12:0])
                            Flag              = 1'b1;
                       13 :
                          if (TransCount[13:0] == DMACTrMemRegj1[13:0])
                            Flag              = 1'b1;
                        14 :
                          if (TransCount[14:0] == DMACTrMemRegj1[14:0])
                            Flag              = 1'b1;
                        15 :
                          if (TransCount[15:0] == DMACTrMemRegj1[15:0])
                            Flag              = 1'b1;
                        default :
                          if (TransCount[15:0] == DMACTrMemRegj1[15:0])
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

            if (Flag == 1'b1 || PrgmIndSync != 1'b0) begin
              if (Flag == 1'b1) begin
                // If Programmed response is found for current transfer,
                // assert programmed response.
                DMACTrMemRegk    = iDMACTrMemReg[k];
                iHRESPM          = DMACTrMemRegk[17:16];
                if ((DMACTrMemRegk[17:16] == `SPLIT_RESP ||
                     DMACTrMemRegk[17:16] == `RETRY_RESP ||
                     DMACTrMemRegk[17:16] == `ERROR_RESP) &&
                    RespOkInform == 1'b0) begin
                  // Store Programmed Response and set PrgmIndicate(It
                  // indicates Programmed response is asserted)
                   PrgmRespCount    = DMACTrMemRegk[23:22];
                   PrgmIndicate     = 1'b1;
                  // During Wait Cycle assert Ok Response
                  if (MemWaitCyc == 1'b1 && Err2 == 1'b0) begin
                    iHRESPM          = `OKAY_RESP;
                    end
                  else begin
                    // Increment Response counter
                    if (Err2 == 1'b0 && DMACTrMemRegk[17:16] != `ERROR_RESP)
                      begin
                        NxtRespCount     = RespCount + 1'b1;
                      end
                  end
                end
                // Latch Programmed response and Programmed Wait cycle
                NxtPrgmRespSync  = DMACTrMemRegk[17:16];
                ProgramedWaitCyc = DMACTrMemRegk[21:18];
                end
              else begin
                if (RespOkInform == 1'b0) begin
                  PrgmIndicate     = 1'b1;
                  if (MemWaitCyc == 1'b1 && Err2 == 1'b0) begin
                    // For Programmed Wait Cycle response assert Ok
                    // response
                    iHRESPM          = `OKAY_RESP;
                    end
                  else begin
                    // If Programmed Wait Cycles are asserted, assert
                    // programmed response if any.
                     iHRESPM          = PrgmRespSync;
                    if (Err2 == 1'b0 && PrgmRespSync != `ERROR_RESP)
                      begin
                        // Increment Response counter
                        NxtRespCount     = RespCount + 1'b1;
                      end
                    end
                  end
                end
              end
            else begin
              // if there is no programmed response for current 
              // transaction assert default response
               iHRESPM          = DefaultResp;
              if ((DefaultResp == `SPLIT_RESP || DefaultResp == `RETRY_RESP ||
                   DefaultResp == `ERROR_RESP) && (RespOkInform == 1'b0)) begin
                if (MemWaitCyc == 1'b1 && Err2 == 1'b0) begin
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
    if (MemReset == 1'b1) begin
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
// Memory Wait Cycle assertion Block
// This block is responsible for assertion of wait cycle response. If there is
// default wait cycle response or programmed wait cycle response to current
// data transfer, this block asserts wait cycle response.
// ----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_MemWaitCycSeq
  if (HRESETn == 1'b0 || MemReset == 1'b1) begin
    TransferClear    <= 1'b0;
    MemWaitCyc       <= 1'b0;
    WaitCycCount     <= 'b0;
    end
  else begin
    if (MemEnable == 1'b1 && Selected == 1'b1) begin
      if (HTRANSM == `IDLE && HREADYINM == 1'b1) begin
        // For Idle cycle No Wait Cycle to be asserted
        MemWaitCyc       <= 1'b0;
        end
      else if ((ProgramedWaitCyc !=4'b0000) && (DataTransfer == 1'b1) &&
                iHRESPM == `OKAY_RESP) begin
        if (WaitCycCount < ProgramedWaitCyc && RespClear == 1'b0 &&
            Err2 == 1'b0) begin
          // If number of wait cycle asserted is not equal to
          // programmed wait cycle count, Assert wait cycle and
          // increment wait cycle counter
          TransferClear    <= 1'b0;
          MemWaitCyc       <= 1'b1;
          WaitCycCount     <= (WaitCycCount) + 1;
          end
        else begin
          // If number of wait cycle asserted is equal to programmed
          // Wait Cycle count, Clear wait cycle counter
          WaitCycCount     <= 'b0;
          MemWaitCyc       <= 1'b0;
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
          MemWaitCyc       <= 1'b1;
          WaitCycCount     <= (WaitCycCount) + 1;
          end
        else begin
          // If number of wait cycle asserted is equal to default wait
          // Cycle count, Clear wait cycle counter
          WaitCycCount     <= 'b0;
          MemWaitCyc       <= 1'b0;
          TransferClear    <= 1'b1;
          end
        end
      else begin
        MemWaitCyc       <= 1'b0;
        TransferClear    <= 1'b1;
        end
      end
    else begin
      MemWaitCyc       <= 1'b0;
      TransferClear    <= 1'b1;
      end
    end
end // p_MemWaitCycSeq

// -----------------------------------------------------------------------------
// Data Check Sequential Block.
// This block is responsible for data comparison. It compares the HWDATAM and
// Expected data. It flags an error message if there is mismatch.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_DataCheckSeq
  if (MemWrEn == 1'b1)
    if (DataGenMethod == `RANDOM)
      if (ExpectedData != HWDATAM)
        $display($time," Error : DmacTrMem11 : RANDOM METHOD : MISMATCH IN",
                        " EXPECTED AND ACTUAL DATA. EXPECTED DATA : %h",
                         ExpectedData, " ACTUAL DATA :%h",HWDATAM, " \n %m");
    else if (DataGenMethod == `GRAYCODE)
      if (ExpectedData != HWDATAM)
        $display($time," Error : DmacTrMem12 : GRAYCODE METHOD : MISMATCH IN",
                       " EXPECTED AND ACTUAL DATA. EXPECTED DATA : %h ACTUAL",
                       " DATA :%h ", ExpectedData, HWDATAM," \n %m");
    else if (DataGenMethod == `ADDRESSBASED)
      if (ExpectedData != HWDATAM)
        $display ($time, " Error : DmacTrMem13 : ADDRESS METHOD : MISMATCH",
                         " IN EXPECTED AND ACTUAL DATA. EXPECTED DATA : %h ",
                         "ACTUAL DATA :%h", ExpectedData, HWDATAM," \n %m");
    else if (DataGenMethod == `DATABASED)
      if (ExpectedData != HWDATAM)
        $display($time," Error : DmacTrMem14 : DATABASED METHOD : MISMATCH IN",
                       "EXPECTED AND ACTUAL DATA. EXPECTED DATA : %h ACTUAL",
                       " DATA :%h", ExpectedData, HWDATAM," \n %m");
end // p_DataCheckSeq;

// -----------------------------------------------------------------------------
// Assigning internal signals to the outputs
// -----------------------------------------------------------------------------
assign HRESP            = iHRESP;

assign HRESPM           = iHRESPM;

assign HREADYOUT        = iHREADYOUT;

assign HREADYOUTM       = iHREADYOUTM;

assign HRDATA           = iHRDATA;

assign HRDATAM          = iHRDATAM;

// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

endmodule
// --================================== End ==================================--
