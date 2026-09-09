//===========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//
//-----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : ClcdDMAFifo.v.rca
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//
//------------------------------------------------------------------------------
//  Purpose                : DMA FIFO Controller. Instanciates control logic for
//                           upper and lower panel FIFOs. The FIFOs are 
//                           configurable for depth and type (REG type or SRAM 
//                           type). In single panel mode upper and lower FIFOs 
//                           are effectively cascaded to form a single 2 X DEPTH
//                           FIFO.
//============================================================================--
 
`timescale 1ns/1ps
`include "ClcdConfig.v"

//  ----------------------------------------------------------------------------
 
module ClcdDMAFifo (
                  // Inputs
                     HCLK,
                     HRESETn,
                     FrRstSyncHclk,
                     FrStSyncHclk,
                     LcdDual,
                     WATERMARK,
                     UFDataValid,
                     LFDataValid,
                     LowerDmaFlag,
                     WordCount,
                     FRPIncSyncHclk,

                  // Outputs
                     UFWatermark,
                     LFWatermark,
                     UFifoAck,
                     LFifoAck,
                     UFWrPtr,
                     LFWrPtr,
                     UFifoWrEn,
                     LFifoWrEn,
                     DMAFifoUF
                    );

input         HCLK;           // AHB clock input - clock for FIFO write logic.
input         HRESETn;        // AHB Bus Reset signal - HCLK domain
input         FrRstSyncHclk;  // FrameRst signal synchronised to HCLK
input         FrStSyncHclk;   // Frame start signal synchronised to HCLK domain
input         LcdDual;        // Dual mode enable 
input         WATERMARK;      // DMAFIFO watermark level select bit
input         FRPIncSyncHclk; // FRdPtrInc signal synchronised to HCLK
input         UFDataValid;    // Upper FIFO write grant from AHB master
input         LFDataValid;    // Lower FIFO write grant from AHB master
input         LowerDmaFlag;   // Indicates which Fifo write is active
input [4:0]   WordCount;      // number of words to transferred to the DMA FIFO

output [1:0]  UFWatermark;      // Upper FIFO watermark level
output [1:0]  LFWatermark;      // Lower FIFO watermark level
output        UFifoAck;         // Acknowledge FIFO Grant from Ahb master
output        LFifoAck;         // Acknowledge FIFO Grant from Ahb master
output [`PTR_SIZE-1:0] UFWrPtr; // Upper FIFO write address
output [`PTR_SIZE-1:0] LFWrPtr; // Lower FIFO write address
output         UFifoWrEn;       // Upper FIFO REG/RAM write enable.
output         LFifoWrEn;       // Lower FIFO REG/RAM write enable.
output         DMAFifoUF;       // Logical or of UFifoUF and LFifoUF

// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module contains  
// - upper and lower FIFO control logic.
// - FIFO watermark level generation logic.
// - MUX logic for cascading of upper and lower FIFOs in single panel mode.
// -----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// Wire declaration
// ----------------------------------------------------------------------------
wire          HCLK;           
// AHB clock input - clock for FIFO write logic.       (Module Input)

wire          HRESETn;        
// AHB Bus Reset signal - HCLK domain                  (Module Input)

wire          FrRstSyncHclk;  
// FrameRst signal synchronised to HCLK domain         (Module Input)

wire          LcdDual;           
// Dual mode enable                                    (Module Input)

wire          WATERMARK;      
// DMAFIFO watermark level select bit                  (Module Input)

wire          FRPIncSyncHclk; 
// FRdPtrInc signal synchronised to HCLK               (Module Input)

wire          UFDataValid;    
// Upper FIFO write grant from AHB master              (Module Input)

wire          LFDataValid;    
// Lower FIFO write grant from AHB master              (Module Input)

wire          FrStSyncHclk;   
// Frame start signal synchronised to HCLK domain      (Module Input)

wire          LowerDmaFlag;   
// Indicates which Fifo write is active                (Module Input)

wire           UFifoWrEn;
// Upper fifo REG/RAM write enable                     (Module Output)

wire           LFifoWrEn;
// Lower fifo REG/RAM write enable                     (Module Output)

wire [`PTR_SIZE-1:0] UFWrPtr;
// Upper Fifo write address                            (Module Output)

wire [`PTR_SIZE-1:0] LFWrPtr;
// Lower Fifo write address                            (Module Output)

wire           DMAFifoUF;
// Logical OR of upper fifo and lower fifo underflow stattus (Module Output)

wire           UFWrPtrInc;
// Internal version of upper fifo write pointer increment enable

wire           LFWrPtrInc;
// Internal version of upper fifo write pointer increment enable

wire           IntUFifoWrEn;
// Internal version of upper fifo REG/RAM write enable

wire           IntLFifoWrEn;
// Internal version of upper fifo REG/RAM write enable

wire [1:0]     IntUFWatermark1;
// Internal version of UFWatermark signal

wire [1:0]     IntUFWatermark2;
// Internal version of UFWatermark signal

wire [1:0]     IntLFWatermark;
// Internal version of LFWatermark signal

wire [1:0]     CFWatermark;
// watermark level when both the fifo's are cascaded in single panel mode

wire           UFifoUF;
// Upper fifo underflow status

wire           LFifoUF;
// Lower fifo underflow status

wire           FifoReadEn;
// 1 HCLK wide read pointer increment enable signal.

wire [`PTR_SIZE:0] UFillLevel;
// Upper fifo fill level

wire [`PTR_SIZE:0] LFillLevel;
// Lower fifo fill level

wire           UFifoAck;
// Acknowledge upper fifo Grant from Ahb master

wire           IntUFifoAck;
// Internal version of UFifoAck

wire           LFifoAck;
// Acknowledge lower fifo Grant from Ahb master

wire           IntLFifoAck;
// Internal version of LFifoAck;

wire           UFWrite;
// upper fifo write pointer increment enable

wire           LFWrite;
// lower fifo write pointer increment enable

wire           UFRAMWrite;
// Internal version of upper fifo REG/RAM write enable

wire           LFRAMWrite;
// Internal version of lower fifo REG/RAM write enable

wire [3:0]     FifoRamPW = `FIFO_WRITE_PW;
// upper/lower fifo RAM write pulse width value

wire           Fifotype = `FIFO_TYPE;
// Indicates the type of the fifo element (REG or RAM type)

wire           IntFrameRst;
// Frame reset signal qualified with the present FIFO write status.

// ----------------------------------------------------------------------------
// Register declaration
// ----------------------------------------------------------------------------
reg  [1:0]     LFWatermark;
// Lower fifo watermark/request signal to AHB master   (Module Output)

reg  [1:0]     UFWatermark;
// Upper fifo watermark/request signal to AHB master   (Module Output)

reg           FifoWSel;
// Fifo write select. when zero upper fifo is selected for write else lower fifo
// will be selected for write. this bit is used to cascade the fifo in single 
// panel mode.

reg           NextFifoWSel;
// D-input for FifoWSel

reg           DelFRpIncSync;
// 1 HCLK delayed version of synchronised read pointer increment enable

reg [3:0]     UFWriteState;
// Register for upper fifo write control state machine

reg [3:0]     NextUFWriteState;
// D-input of LFWriteState register

reg [3:0]     LFWriteState;
// Register for lower fifo write control state machine

reg [3:0]     NextLFWriteState;
// D-input of LFWriteState register

reg           IntUFWrite1;
// Internal version of upper fifo write enable- state machine output

reg           NextIntUFWrite;
// D-input of IntUFWrite1 register

reg           IntUFWrite2;
// Internal version of upper fifo write enable- delayed version

reg           IntLFWrite1;
// Internal version of lower fifo write enable- state machine output

reg           NextIntLFWrite;
// D-input of IntLFWrite1 register

reg           IntLFWrite2;
// Internal version of lower fifo write enable- delayed version

reg           UFWritedelFlag;
// Flag to delay the upper fifo write state transition from state-4 to state-1 
// by 1 clock.

reg           NextUFWdelFlag;
// d-input of UFWritedelFlag register

reg           LFWritedelFlag;
// Flag to delay the lower fifo write state transition from state-4 to state-1 
// by 1 clock.

reg           NextLFWdelFlag;
// d-input of LFWritedelFlag register

reg [1:0]      NextUFWatermark;
// D-input of UFWatermark register

reg [1:0]      NextLFWatermark;
// D-input of LFWatermark register

reg            DelFrStSyncHclk;
// delayed version of Frame start signal. Needed for watermark signal assertion

reg DelLowerDmaFlag1;
// 1 clock delayed version of lower DMA flag signal.

reg DelLowerDmaFlag2;
// 2 clock delayed version of lower DMA flag signal.

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// State machine to generate FifoAck signal and fifo write signal of variable
// pulse width. the write pulse width can be varied by setting FIFO_WRITE_PW
// to an appropriate value(1-HCLK to 3-HCLK wide).For D type FIFO this state 
// machine is bypassed as the write has to happen on each clock. 
// -----------------------------------------------------------------------------
always @(UFWriteState or UFDataValid or UFWritedelFlag or FrRstSyncHclk)
begin : p_UFWStateComb
  NextUFWriteState = UFWriteState;
  NextIntUFWrite = 1'b0;
  NextUFWdelFlag = 1'b0;
  case (UFWriteState) 
      4'b0001 : begin
                          if (UFWritedelFlag == 1'b1)
                            NextUFWdelFlag = 1'b0;
                          else if (UFDataValid == 1'b1 && FrRstSyncHclk == 1'b0)
                            begin
                              NextUFWriteState = `FIFO_WRITE_PW;
                              NextIntUFWrite   = 1'b1;
                            end
                        end
       4'b0010 : begin
                           NextIntUFWrite   = 1'b1;
                           NextUFWriteState = 4'b0100;
                         end
       4'b0100 : begin
                           NextIntUFWrite   = 1'b1;
                           NextUFWriteState = 4'b1000;
                         end

       4'b1000 : begin
                           NextIntUFWrite   = 1'b0;
                           NextUFWdelFlag   = 1'b1;
                           NextUFWriteState = 4'b0001;
                         end
          default: begin
                       NextIntUFWrite   = 1'b0;
                       NextUFWriteState = 4'b0001;
                       NextUFWdelFlag   = 1'b0;
                   end
   endcase
end // p_UFWStateComb

// -----------------------------------------------------------------------------
// Sequential logic for Upper fifo write state machine
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_UFWStateSeq
  if (HRESETn == 1'b0)
    begin
      UFWriteState   <= 4'b0001;
      IntUFWrite1    <= 1'b0;
      UFWritedelFlag <= 1'b0;
    end
  else
    begin
      UFWriteState   <= NextUFWriteState;
      IntUFWrite1    <= NextIntUFWrite;
      UFWritedelFlag <= NextUFWdelFlag;
    end
end // p_UFWStateSeq
      

// -----------------------------------------------------------------------------
// Acknowledge for upper fifo data valid signal from AHB master. 
// - For TPRAM based Fifo this signal is asserted 2 HCLK early than the write 
//   pointer increment enable to limit the write latency to 
//   2-HCLK + WRITE PULSE WIDTH.
// - For REG type this signal is asserted when the request is raised and 
//   deasserted along with the data valid for the last word of the burst.
// -----------------------------------------------------------------------------
 assign IntUFifoAck = (Fifotype & (|UFWatermark | UFDataValid))
                       | (~Fifotype & (UFWriteState[2] |
                         (FifoRamPW[3] & UFDataValid & ~IntUFWrite1)));
 assign UFifoAck = IntUFifoAck | IntFrameRst;

// -----------------------------------------------------------------------------
// Generation of upper fifo write pointer increment enable. 
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_UFWriteSeq 
  if (HRESETn == 1'b0)
    IntUFWrite2 <= 1'b0;
  else
    IntUFWrite2 <= IntUFWrite1;
end // p_UFWriteSeq

assign UFWrite = (Fifotype & UFDataValid) |
                                     (~Fifotype & ~IntUFWrite1 & IntUFWrite2);

// -----------------------------------------------------------------------------
// Generation of TPRAM/REG write signal for upper fifo.
// -----------------------------------------------------------------------------
assign UFRAMWrite = (Fifotype & UFDataValid) | (~Fifotype & IntUFWrite1);

// -----------------------------------------------------------------------------
// State machine to generate FifoAck signal and fifo write signal of variable
// pulse width. the write pulse width can be varied by setting FIFO_WRITE_PW
// to an appropriate value(1-HCLK to 3-HCLK wide).For D-type FIFO this state
// machine is bypassed as the write has to happen on each clock.
// -----------------------------------------------------------------------------
always @(LFWriteState or LFDataValid or LFWritedelFlag or FrRstSyncHclk)
begin : p_LFWStateComb
  NextLFWriteState = LFWriteState;
  NextIntLFWrite = 1'b0;
  NextLFWdelFlag = 1'b0;
  case (LFWriteState)
    4'b0001 : begin
                          if (LFWritedelFlag == 1'b1)
                            NextLFWdelFlag = 1'b0;
                          else if (LFDataValid == 1'b1 && FrRstSyncHclk == 1'b0)
                            begin
                              NextLFWriteState = `FIFO_WRITE_PW;
                              NextIntLFWrite   = 1'b1;
                            end
                        end
    4'b0010 : begin
                           NextIntLFWrite   = 1'b1;
                           NextLFWriteState = 4'b0100;
                         end
    4'b0100 : begin
                           NextIntLFWrite   = 1'b1;
                           NextLFWriteState = 4'b1000;
                         end
 
    4'b1000 : begin
                           NextIntLFWrite   = 1'b0;
                           NextLFWdelFlag   = 1'b1;
                           NextLFWriteState = 4'b0001;
                         end
          default: begin
                       NextIntLFWrite   = 1'b0;
                       NextLFWriteState = 4'b0001;
                       NextLFWdelFlag   = 1'b0;
                   end
   endcase
end // p_LFWStateComb
 
// -----------------------------------------------------------------------------
// Sequential logic for Lower fifo write state machine
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LFWStateSeq
  if (HRESETn == 1'b0)
    begin
      LFWriteState   <= 4'b0001;
      IntLFWrite1    <= 1'b0;
      LFWritedelFlag <= 1'b0;
    end
  else
    begin
      LFWriteState   <= NextLFWriteState;
      IntLFWrite1    <= NextIntLFWrite;
      LFWritedelFlag <= NextLFWdelFlag;
    end
end // p_LFWStateSeq
 
// -----------------------------------------------------------------------------
// Acknowledge for lower fifo data valid signal from AHB master.
// - For TPRAM based Fifo this signal is asserted 2 HCLK early than the write
//   pointer increment enable to limit the write latency to
//   2-HCLK + WRITE PULSE WIDTH.
// - For REG type this signal is asserted when the request is raised and
//   deasserted along with the data valid for the last word of the burst.
// -----------------------------------------------------------------------------
 assign IntLFifoAck = (Fifotype & (|LFWatermark | LFDataValid))
                    | (~Fifotype & (LFWriteState[2] | 
                               (FifoRamPW[3] & LFDataValid & ~IntLFWrite1)));
 assign LFifoAck = IntLFifoAck | IntFrameRst;
 
// -----------------------------------------------------------------------------
// Generation of lower fifo write pointer increment enable. 
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LFWriteSeq
  if (HRESETn == 1'b0)
    IntLFWrite2 <= 1'b0;
  else
    IntLFWrite2 <= IntLFWrite1;
end // p_LFWriteSeq

assign LFWrite = (Fifotype & LFDataValid)
               | (~Fifotype & ~IntLFWrite1 & IntLFWrite2);

// -----------------------------------------------------------------------------
// Generation of TPRAM/REG write signal for lower fifo.
// -----------------------------------------------------------------------------
assign LFRAMWrite = (Fifotype & LFDataValid) | (~Fifotype & IntLFWrite1);

// -----------------------------------------------------------------------------
// Delayed version of synchronised Read pointer increment enable signals
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DelFRpIncSeq
  if (HRESETn == 1'b0)
    DelFRpIncSync <= 1'b0;
  else
    DelFRpIncSync <= FRPIncSyncHclk;
end // p_DelFRpIncSeq

// -----------------------------------------------------------------------------
// Read pointer increment enable signal generation
// -----------------------------------------------------------------------------
assign FifoReadEn = DelFRpIncSync ^ FRPIncSyncHclk;

// -----------------------------------------------------------------------------
// Frame-End reset signal to reset the write/read pointers. 
// Reset the pointers only when the current write operation  is over.
// -----------------------------------------------------------------------------
assign IntFrameRst = FrRstSyncHclk & (~IntLFWrite1 & ~IntUFWrite1);
 
// -----------------------------------------------------------------------------
// Instantiation of upper FIFO controller
// -----------------------------------------------------------------------------
ClcdFifoCntl uClcdFifoCntl1 (
                         .HCLK        (HCLK),
                         .HRESETn     (HRESETn),
                         .FrameRst    (IntFrameRst),
                         .RdPtrInc    (FifoReadEn),
                         .WrEnable    (UFWrPtrInc),
                             
                         .WrPtr       (UFWrPtr),
                         .FifoFull    (UFifoFull),
                         .FifoUF      (UFifoUF),
                         .FillLevel   (UFillLevel)
                       );

// -----------------------------------------------------------------------------
// Instantiation of lower FIFO controller
// -----------------------------------------------------------------------------
ClcdFifoCntl uClcdFifoCntl2 (
                         .HCLK        (HCLK),
                         .HRESETn     (HRESETn),
                         .FrameRst    (IntFrameRst),
                         .RdPtrInc    (FifoReadEn),
                         .WrEnable    (LFWrPtrInc),
                             
                         .WrPtr       (LFWrPtr),
                         .FifoFull    (LFifoFull),
                         .FifoUF      (LFifoUF),
                         .FillLevel   (LFillLevel)
                       );

// -----------------------------------------------------------------------------
// Generation of water mark levels for upper FIFO.
// 2'b00 - no space, 2'b01 - space for 4 words, 2'b10 - space for 8 words,
// 2'b11 - space for 16 words.
// -----------------------------------------------------------------------------
assign IntUFWatermark1[1:0] = (((`FIFO_DEPTH - UFillLevel) > 5'b10000) ||
                               (((`FIFO_DEPTH - UFillLevel) == 5'b10000) &&
                                  (UFWrPtrInc == 1'b0))) ? 2'b11
                           : (((`FIFO_DEPTH - UFillLevel) > 5'b01000) ||
                               (((`FIFO_DEPTH - UFillLevel) == 5'b01000) &&
                                (UFWrPtrInc == 1'b0))) ? 2'b10
                           : ((WATERMARK == 1'b0) && 
                              (((`FIFO_DEPTH - UFillLevel) > 5'b00100) ||
                               (((`FIFO_DEPTH - UFillLevel) == 5'b00100) && 
                                (UFWrPtrInc == 1'b0)))) ? 2'b01
                           : 2'b00;
 
 
// -----------------------------------------------------------------------------
// Generation of water mark levels for Lower FIFO
// 2'b00 - no space, 2'b01 - space for 4 words, 2'b10 - space for 8 words,
// 2'b11 - space for 16 words.
// -----------------------------------------------------------------------------
assign IntLFWatermark[1:0] = (((`FIFO_DEPTH - LFillLevel) > 5'b10000) ||
                               (((`FIFO_DEPTH - LFillLevel) == 5'b10000) &&
                                  (LFWrPtrInc == 1'b0))) ? 2'b11
                           : (((`FIFO_DEPTH - LFillLevel) > 5'b01000) ||
                               (((`FIFO_DEPTH - LFillLevel) == 5'b01000) &&
                                (LFWrPtrInc == 1'b0))) ? 2'b10
                           : ((WATERMARK == 1'b0) && 
                              (((`FIFO_DEPTH - LFillLevel) > 5'b00100) ||
                               (((`FIFO_DEPTH - LFillLevel) == 5'b00100) && 
                                (LFWrPtrInc == 1'b0)))) ? 2'b01
                           : 2'b00;
 
// -----------------------------------------------------------------------------
// Generation of water mark levels, when both the FIFOs are cascaded in single
// panel mode.
// 2'b00 - no space, 2'b01 - space for 4 words, 2'b10 - space for 8 words,
// 2'b11 - space for 16 words.
// -----------------------------------------------------------------------------
assign 
    CFWatermark[1:0] = (2*`FIFO_DEPTH - (UFillLevel + LFillLevel) >= 5'b10000)
    ? 2'b11 : (2 * `FIFO_DEPTH - (UFillLevel + LFillLevel) >= 5'b01000) ? 2'b10
            : ((WATERMARK == 1'b0) && (2 * `FIFO_DEPTH - 
               (UFillLevel + LFillLevel) >= 5'b00100)) ? 2'b01 
            : 2'b00;

// -----------------------------------------------------------------------------
// Generation of FifoWSel signal. This signal is used for writing data to both 
// the fifo alternatevely in single panel mode.
// -----------------------------------------------------------------------------
always @(FifoWSel or IntFrameRst or LcdDual or UFWrite)
begin : p_FWSelComb
  if (IntFrameRst == 1'b1)
    NextFifoWSel = 1'b0;
  else if (LcdDual == 1'b0 && UFWrite == 1'b1)
     NextFifoWSel = ~FifoWSel;
  else
     NextFifoWSel = FifoWSel;
end // p_FWSelComb  

// -----------------------------------------------------------------------------
// Sequential process for Fifo write select signal
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_FWSelSeq
  if (HRESETn == 1'b0)
     FifoWSel <= 1'b0;
  else
     FifoWSel <= NextFifoWSel;
end // p_FWSelSeq

// -----------------------------------------------------------------------------
// Muxing of upper FIFO Write pointer increment enable and lower FIFO write 
// pointer increment enable signals 
// -----------------------------------------------------------------------------
assign UFWrPtrInc = (FifoWSel == 1'b0) ? UFWrite : 1'b0;
assign LFWrPtrInc = (LcdDual == 1'b1) ? LFWrite : (FifoWSel == 1'b1) ? UFWrite 
                                                                  : 1'b0;

// -----------------------------------------------------------------------------
// Muxing of upper FIFOReg/FIFORAM  Write enable and lower FIFOReg/FIFORAM 
// write enable signals. MUX output is finally qualified with the FifoFull 
// signal to prevent writing of new data in to the FifoReg/TPRAM when it is 
// already FULL. 
// -----------------------------------------------------------------------------
assign IntUFifoWrEn = (FifoWSel == 1'b0) ? UFRAMWrite : 1'b0;
assign IntLFifoWrEn = (LcdDual == 1'b1) ? LFRAMWrite : (FifoWSel == 1'b1) 
                                                  ? UFRAMWrite : 1'b0;

assign UFifoWrEn = (Fifotype & IntUFifoWrEn & ~UFifoFull) | 
                   (~Fifotype & ~(IntUFifoWrEn & ~UFifoFull));

assign LFifoWrEn = (Fifotype & IntLFifoWrEn & ~LFifoFull) |
                   (~Fifotype & ~(IntLFifoWrEn & ~LFifoFull));

// -----------------------------------------------------------------------------
//  Selection of watermark signal for the upper fifo. In single panel mode 
//  combined watermark levels of upper and lower fifo is selected as the fifos
// are effectively cascaded.
// -----------------------------------------------------------------------------
assign IntUFWatermark2 = (LcdDual == 1'b1) ? IntUFWatermark1 : CFWatermark;

// -----------------------------------------------------------------------------
// Sequential process for delayed frame start signal. This is needed to assert
// the watermark levels at the beginning of a new frame.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DelFrStSeq
  if (HRESETn == 1'b0)
    DelFrStSyncHclk <= 1'b0;
  else
    DelFrStSyncHclk <= FrStSyncHclk;
end // p_DelFrStSeq

// -----------------------------------------------------------------------------
// Sequential process for 2 HCLK delayed lower DMA flag signal. 
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DelLDmaFlSeq
  if (HRESETn == 1'b0)
    begin
      DelLowerDmaFlag1 <= 1'b0;
      DelLowerDmaFlag2 <= 1'b0;
    end
  else
    begin
      DelLowerDmaFlag1 <= LowerDmaFlag;
      DelLowerDmaFlag2 <= DelLowerDmaFlag1;
    end
end // p_DelLDmaFlSeq

// -----------------------------------------------------------------------------
// Combinational process for UFWatermark signal. upper fifo watermark signal is
// deasserted during the transfer of the third word and it is asserted back 
// during the transfer of the last word of the burst.
// -----------------------------------------------------------------------------
always @(UFWatermark or WordCount or DelLowerDmaFlag2 or IntUFWatermark2 or
          FrRstSyncHclk or DelFrStSyncHclk)
begin : p_UfWmarkComb
  NextUFWatermark = UFWatermark;
  if (DelFrStSyncHclk == 1'b1)
     NextUFWatermark = IntUFWatermark2;

  else if ((FrRstSyncHclk == 1'b1) || ((DelLowerDmaFlag2 == 1'b0) && 
       (WordCount == 5'b00011) && (|UFWatermark == 1'b1)))
    NextUFWatermark = 2'b00;

  else if ((|WordCount == 1'b0) && (|UFWatermark == 1'b0))
    NextUFWatermark = IntUFWatermark2;
  else
    NextUFWatermark = UFWatermark;
end // p_UfWmarkComb

// -----------------------------------------------------------------------------
// Sequential process for upper fifo watermark signal.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_UfWmarkSeq
  if (HRESETn == 1'b0)
    UFWatermark <= 2'b00;
  else
    UFWatermark <= NextUFWatermark;
end // p_UfWmarkSeq

// -----------------------------------------------------------------------------
// Combinational process for LFWatermark signal. Lower fifo watermark signal is
// deasserted during the transfer of the third word and it is asserted back 
// during the transfer of the last word of the burst.
// -----------------------------------------------------------------------------
always @(LFWatermark or WordCount or DelLowerDmaFlag2 or IntLFWatermark or
           FrRstSyncHclk or DelFrStSyncHclk)
begin : p_LfWmarkComb
  NextLFWatermark = LFWatermark;
  if (DelFrStSyncHclk == 1'b1)
     NextLFWatermark = IntLFWatermark;

  else if ((FrRstSyncHclk == 1'b1) || ((DelLowerDmaFlag2 == 1'b1) && 
        (WordCount == 5'b00011) && (|LFWatermark == 1'b1)))
    NextLFWatermark = 2'b00;

  else if ((|WordCount == 1'b0) && (|LFWatermark == 1'b0))
    NextLFWatermark = IntLFWatermark;
  else 
    NextLFWatermark = LFWatermark;
end // p_LfWmarkComb

// -----------------------------------------------------------------------------
// Sequential process for Lower fifo watermark signal.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LfWmarkSeq
  if (HRESETn == 1'b0)
    LFWatermark <= 2'b00;
  else
    LFWatermark <= NextLFWatermark;
end // p_LfWmarkSeq


// -----------------------------------------------------------------------------
// DMA Fifo underflow status. This signal is asserted when the upper or lower
// Fifo or both Fifo underflow happens.
// -----------------------------------------------------------------------------
assign DMAFifoUF = UFifoUF | LFifoUF;

endmodule
// --================================== End ==================================--
