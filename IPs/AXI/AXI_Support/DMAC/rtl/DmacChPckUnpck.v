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
// File Name              : DmacChPckUnpck.v.rca
// File Revision          : 1.8
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block contains packing-logic for the Channel FIFO Write data
//           and unpacking logic for the Channel FIFO Read data.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacChPckUnpck (
// Inputs
                       // Clock and reset
                       HCLK,
                       HRESETn,
                       // From AHB Master interface (DmacAhbMaster)
                       ChWrDataM1,
                       ChWrDataM2,
                       BusAvlblM1,
                       BusAvlblM2,
                       // From DmacChRegBlock
                       SWidth,
                       DWidth,
                       SrcSelect,
                       DstSelect,
                       FifoPtrReset,
                       // From DmacChRegFile block
                       FifoRdData,
                       // From DmacChSrcXfer block
                       SrcDmacState,
                       FifoWrEn,
                       SrcFactor,
                       DstFactor,
                       DstDmacState,
                       AxsCntDst,
                       RdPtrInc,

// Outputs
                       // To AHB Master interface (DmacAhbMaster)
                       ChHWDATAM1,
                       ChHWDATAM2,
                       // To DmacChRegFile block
                       FifoWrPtr,
                       FifoWrData,
                       FifoWrMask,
                       FifoRdPtr,
                       // To DmacChReqMask block
                       ActEmptyLevel,
                       ActFillLevel,
                       // To DmacChSrcXfer block
                       FifoEmptyLevel,
                       // To DmacChDstXfer block
                       FifoFillLevel,
                       // To DmacChRegBlock
                       FifoNonEmpty
                      );

// Inputs

// Clock and reset
input         HCLK;           // AHB Clock
input         HRESETn;        // AHB Reset
// From AHB Master interface (DmacAhbMaster)
input  [31:0] ChWrDataM1;     // Read Data from the AHB 1
input  [31:0] ChWrDataM2;     // Read Data from the AHB 2
input         BusAvlblM1;     // Bus Available signal from Master Interface 1.
input         BusAvlblM2;     // Bus Available signal from Master Interface 2.
// From DmacChRegBlock
input   [2:0] SWidth;         // Source transfer width
input   [2:0] DWidth;         // Destination transfer width
input         SrcSelect;      // Source AHB Master select
input         DstSelect;      // Destination AHB Master select
input         FifoPtrReset;   // Resetting FIFO pointers
// From DmacChRegFile block
input  [31:0] FifoRdData;     // Read Data from Channel FIFO
// From DmacChSrcXfer block
input   [4:0] SrcDmacState;    // Source Transfer Logic state
input         FifoWrEn;       // Write enable to data buffer
input   [3:0] SrcFactor;      // The addition factor to FifoFill
input   [2:0] DstFactor;      // The addition factor to FifoEmpty
input   [4:0] DstDmacState;   // Destination state information
input   [4:0] AxsCntDst;      // Access count value of destination
input         RdPtrInc;       // Read pointer increment signal

// Outputs
// To AHB Master interface (DmacAhbMaster)
output [31:0] ChHWDATAM1;     // 32-bit AHB1 write-data bus, ORed with all
                              // channel write data buses at top
output [31:0] ChHWDATAM2;     // 32-bit AHB2 write-data bus, ORed with all
                              // channel write data buses at top
// To DmacChRegFile block
output  [1:0] FifoWrPtr;      // FIFO write pointer
output [31:0] FifoWrData;     // Data to be written into the FIFO
output [31:0] FifoWrMask;     // Mask for writing into a specific data-lane in
                              // FIFO
output  [1:0] FifoRdPtr;      // FIFO read pointer
// To DmacChReqMask block
output  [4:0] ActEmptyLevel;  // Number of space empty in FIFO
output  [4:0] ActFillLevel;   // Number of spaces filled in FIFO
// To DmacChSrcXfer block
output  [4:0] FifoEmptyLevel; // Sum of ActEmptyLevel and optimization factor
                              // (DstFactor)
// To DmacChDstXfer block
output  [4:0] FifoFillLevel;  // Sum of ActFillLevel and optimization factor
                              // (SrcFactor)
// To DmacChRegBlock
output        FifoNonEmpty;   // Indicates data being present in channel FIFO

// Inputs
// Clock and reset
wire          HCLK;           // AHB Clock
wire          HRESETn;        // AHB Reset
// From AHB Master interface (DmacAhbMaster)
wire   [31:0] ChWrDataM1;     // Read Data from the AHB 1
wire   [31:0] ChWrDataM2;     // Read Data from the AHB 2
wire          BusAvlblM1;     // Bus Available signal from Master Interface 1.
wire          BusAvlblM2;     // Bus Available signal from Master Interface 2.
// From DmacChRegBlock
wire    [2:0] SWidth;         // Source transfer width
wire    [2:0] DWidth;         // Destination transfer width
wire          SrcSelect;      // Source AHB Master select
wire          DstSelect;      // Destination AHB Master select
wire          FifoPtrReset;   // Resetting FIFO pointers
// From DmacChRegFile block
wire   [31:0] FifoRdData;     // Read Data from Channel FIFO
// From DmacChSrcXfer block
wire    [4:0] SrcDmacState;    // Source Transfer Logic state
wire          FifoWrEn;       // Write enable to data buffer
wire    [3:0] SrcFactor;      // The addition factor to FifoFill level for burst
                              // optimization.
wire    [2:0] DstFactor;      // The addition factor to FifoEmpty level for
                              // burst optimization.
wire    [4:0] DstDmacState;   // Destination state information
wire    [4:0] AxsCntDst;      // Access count value of destination
wire          RdPtrInc;       // Read pointer increment signal

// Outputs
// To AHB Master interface (DmacAhbMaster)
wire   [31:0] ChHWDATAM1;     // 32-bit AHB1 write-data bus, ORed with all
                              // channel write data buses at top
wire   [31:0] ChHWDATAM2;     // 32-bit AHB2 write-data bus, ORed with all
                              // channel write data buses at top
// To DmacChRegFile block
reg     [1:0] FifoWrPtr;      // FIFO write pointer
reg    [31:0] FifoWrData;     // Data to be written into the FIFO
reg    [31:0] FifoWrMask;     // Mask for writing into a specific data-lane in
                              // FIFO
reg     [1:0] FifoRdPtr;      // FIFO read pointer
// To DmacChReqMask block
reg     [4:0] ActEmptyLevel;  // Number of space empty in FIFO
reg     [4:0] ActFillLevel;   // Number of spaces filled in FIFO
// To DmacChSrcXfer block
reg     [4:0] FifoEmptyLevel; // Sum of ActEmptyLevel and optimization factor
                              // (DstFactor)
// To DmacChDstXfer block
reg     [4:0] FifoFillLevel;  // Sum of ActFillLevel and optimization factor
                              // (SrcFactor)
// To DmacChRegBlock
reg           FifoNonEmpty;   // Indicates data being present in channel FIFO

// -----------------------------------------------------------------------------
//
//                               DmacChPckUnpck
//                               ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   The DmacChPckUnpck block performs the following main functionalities:
// o The AHB read data from one of the two AHB masters is muxed into the
//   channel on the basis of SrcSelect.
// o The FIFO is a word-wide FIFO. If source data accesses are going on, with
//   widths less than 32 bits, then the bytes/halfwords need to be stored into
//   FIFO after 'packing' so that the FIFO capacity is used optimally.
// o If the destination is narrower than a word, then only a portion of one
//   FIFO word has to be given to the destination, at a time. This process is
//   called unpacking and is performed in this block.
// o The data retrieved from the FIFO is routed onto one of the AHB data buses
//   depending upon DstSelect bit field.
// o The DmacChPckUnpck block also generates the fill-level of the channel FIFO
//   which is required by the source and destination state machines for loading
//   their transfer-counters.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire  [4:0] RawFillLvl;
// Gives the number of bytes stored in the channel FIFO

wire  [4:0] RawEmpLvl;
// Gives the number of empty byte-wide spaces available in channel FIFO

wire  [4:0] FactoredFillLvl;
// SrcFactor added to RawFillLvl

wire  [4:0] FactoredEmpLvl;
// DstFactor added to RawEmpLvl

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [31:0] WrData;
// 32 bit data-bus for writing into the FIFO, prior to masking

reg   [1:0] WrSubPtr;
// The sub-pointer keeping track of the data-writes lesser than FIFO width
// (i.e. 32)

reg   [1:0] NextWrSubPtr;
// D-input of WrSubPtr

reg   [1:0] NextFifoWrPtr;
// D-input of FifoWrPtr

reg  [31:0] WrBufDataM1;
// Output of the endianization logic, to be written into Write Buffer only when
// corresponding BusAvlbl is there

reg  [31:0] WrBufDataM2;
// Output of the endianization logic, to be written into Write Buffer only when
// corresponding BusAvlbl is there

reg  [31:0] WrBufferM1;
// The buffer, into which the AHB1 data is "registered in" prior to the "write"
// on the destination AHB bus.

reg  [31:0] WrBufferM2;
// The buffer, into which the AHB2 data is "registered in" prior to the "write"
// on the destination AHB bus.

reg  [31:0] NextWrBufferM1;
// D-input for the WrBufferM1 register.

reg  [31:0] NextWrBufferM2;
// D-input for the WrBufferM2 register.

reg   [1:0] NextFifoRdPtr;
// D-input for FifoRdPtr

reg   [1:0] RdSubPtr;
// The sub-pointer keeping track of the data-reads lesser than FIFO width (i.e.
// 32) while reading

reg   [1:0] NextRdSubPtr;
// D-input for RdSubPtr

reg  [31:0] RdData;
// Output of FIFO i.e. FifoRdData's byte/halfword/word lanes are routed to the
// lower lane of RdData

reg         WrapFlag;
// Indicates the way fill level is to be calculated for the FIFO

reg         NextWrapFlag;
// D-input for WrapFlag

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
// Based on the targeted master-port (1 or 2), the corresponding ChWrData bus
// is muxed into WrData bus.
// -----------------------------------------------------------------------------
always @(SrcSelect or ChWrDataM1 or ChWrDataM2)
begin : p_AHBRdDataComb
  if (SrcSelect == 1'b0)
    WrData           = ChWrDataM1;
  // When SrcSelect is 1 or invalid-conditions
  else
    WrData           = ChWrDataM2;
end // p_AHBRdDataComb

// -----------------------------------------------------------------------------
// The following block describes the data-packing logic.
// The packing-logic described below needs to write into a portion of the
// FIFO-word during byte and halfword accesses. So FifoWrData and FifoWrMask
// both are generated from the process. The DmacChRegFile uses the FifoWrMask
// and FifoWrData to register new value in FIFO.
// -----------------------------------------------------------------------------
always @(FifoWrEn or SWidth or WrSubPtr or FifoWrPtr or WrData or FifoPtrReset)
begin : p_DataPackComb
  if (FifoPtrReset == 1'b1)
    begin
      NextWrSubPtr     = 2'b00;
      NextFifoWrPtr    = 2'b00;
      FifoWrData       = {32{1'b0}};
      FifoWrMask       = {32{1'b0}};
    end
  else
    begin
      if (FifoWrEn == 1'b1)
        begin
          case (SWidth)
            // In byte-accesses, it takes 4 FIFO writes to fill up a word.
            // The sub-pointer (WrSubPtr) is incremented with each write
            // and the main write pointer (FifoWrPtr) is incremented only
            // after 4 writes by the sub-pointer.
            `BYTE_ACCESS :
              begin
                NextWrSubPtr     = (WrSubPtr) + 1'b1;
                NextFifoWrPtr    = FifoWrPtr;
                case (WrSubPtr)
                  2'b00 :
                    begin
                      FifoWrData       = {{24{1'b0}}, WrData[7:0]};
                      FifoWrMask       = {{24{1'b0}}, {8{1'b1}}};
                    end
                  2'b01 :
                    begin
                      FifoWrData       = {{16{1'b0}}, WrData[7:0], {8{1'b0}}};
                      FifoWrMask       = {{16{1'b0}}, {8{1'b1}}, {8{1'b0}}};
                    end
                  2'b10 :
                    begin
                      FifoWrData       = {{8{1'b0}}, WrData[7:0], {16{1'b0}}};
                      FifoWrMask       = {{8{1'b0}}, {8{1'b1}}, {16{1'b0}}};
                    end
                  2'b11 :
                    begin
                      NextFifoWrPtr    = FifoWrPtr + 1'b1;
                      FifoWrData       = {WrData[7:0], {24{1'b0}}};
                      FifoWrMask       = {{8{1'b1}}, {24{1'b0}}};
                    end
                  default :
                    begin
                      FifoWrData       = {32{1'b0}};
                      FifoWrMask       = {32{1'b0}};
                    end
                endcase
              end
            // In halfword-accesses, it takes 2 FIFO writes to fill up a word.
            // The sub-pointer (WrSubPtr) is incremented by two with each
            // write and the main write pointer (FifoWrPtr) is incremented
            // only after 2 writes by the sub-pointer.
            `HWORD_ACCESS :
              begin
                NextWrSubPtr     = WrSubPtr + 2;
                NextFifoWrPtr    = FifoWrPtr;
                case (WrSubPtr)
                  2'b00 :
                    begin
                      FifoWrData       = {{16{1'b0}}, WrData[15:0]};
                      FifoWrMask       = {{16{1'b0}}, {16{1'b1}}};
                    end
                  2'b10 :
                    begin
                      NextFifoWrPtr    = FifoWrPtr + 1'b1;
                      FifoWrData       = {WrData[15:0], {16{1'b0}}};
                      FifoWrMask       = {{16{1'b1}}, {16{1'b0}}};
                    end
                  default :
                    begin
                      FifoWrData       = {32{1'b0}};
                      FifoWrMask       = {32{1'b0}};
                    end
                endcase
              end
            // During word-accesses, the main write-pointer (FifoWrPtr) is
            // incremented after every write. The sub-pointer (WrSubPtr) is
            // redundant in this case.
            `WORD_ACCESS :
              begin
                NextWrSubPtr     = WrSubPtr;
                NextFifoWrPtr    = FifoWrPtr + 1'b1;
                FifoWrData       = WrData;
                FifoWrMask       = `ONEFILL;
              end
            default :
              begin
                NextWrSubPtr     = WrSubPtr;
                NextFifoWrPtr    = FifoWrPtr;
                FifoWrData       = {32{1'b0}};
                FifoWrMask       = {32{1'b0}};
              end
          endcase
        end
      else
        begin
           NextWrSubPtr     = WrSubPtr;
           NextFifoWrPtr    = FifoWrPtr;
           FifoWrData       = {32{1'b0}};
           FifoWrMask       = {32{1'b0}};
        end
    end
end // p_DataPackComb

// -----------------------------------------------------------------------------
// Sequential block for the process DataPackComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DataPackSeq
  if (HRESETn == 1'b0)
    begin
      WrSubPtr         <= 2'b00;
      FifoWrPtr        <= 2'b00;
    end
  else
    begin
     WrSubPtr         <= NextWrSubPtr;
     FifoWrPtr        <= NextFifoWrPtr;
    end
end // p_DataPackSeq

// -----------------------------------------------------------------------------
// This block moves the main-read-pointer (FifoRdPtr) and the sub-pointer
// (RdSubPtr). The data corresponding to the (sub)read-pointer location is
// combinationally driven by p_FifoRead block.
// The read-pointers are moved according to the destination peripheral/memory's
// width. If the FifoPtrReset is asserted by the ChannelDisable logic, the main
// read pointer and sub-pointer, both are reset to zero.
// -----------------------------------------------------------------------------
always @(FifoPtrReset or RdPtrInc or DWidth or RdSubPtr or FifoRdPtr)
begin : p_DataUnpackComb
  if (FifoPtrReset == 1'b1)
    begin
      NextFifoRdPtr    = 2'b00;
      NextRdSubPtr     = 2'b00;
    end
  else if (RdPtrInc == 1'b1)
    begin
      case (DWidth)
        // Only when the sub-pointer is at "11", on the next read the main
        // pointer moves to next "word".
        `BYTE_ACCESS :
          begin
            NextRdSubPtr     = (RdSubPtr) + 1;
            NextFifoRdPtr    = FifoRdPtr;
            case (RdSubPtr)
              2'b11 : NextFifoRdPtr    = (FifoRdPtr) + 1;
              default :
                begin
                  NextRdSubPtr     = (RdSubPtr) + 1;
                  NextFifoRdPtr    = FifoRdPtr;
                end
            endcase
          end
        // Only when the sub-pointer is at "10", on the next read the main
        // pointer moves to next "word".
        `HWORD_ACCESS :
          begin
            NextRdSubPtr     = (RdSubPtr) + 2;
            NextFifoRdPtr    = FifoRdPtr;
            case (RdSubPtr)
              2'b10 : NextFifoRdPtr    = (FifoRdPtr) + 1;
              default :
                begin
                  NextRdSubPtr     = (RdSubPtr) + 2;
                  NextFifoRdPtr    = FifoRdPtr;
                end
            endcase
          end
        // The main pointer moves on every read. The sub-pointer is not moved
        // with every read.
        `WORD_ACCESS :
          begin
            NextRdSubPtr     = RdSubPtr;
            NextFifoRdPtr    = (FifoRdPtr) + 1;
          end
        default :
          begin
            NextFifoRdPtr    = FifoRdPtr;
            NextRdSubPtr     = RdSubPtr;
          end
      endcase
    end
  else
    begin
      NextFifoRdPtr    = FifoRdPtr;
      NextRdSubPtr     = RdSubPtr;
    end
end // p_DataUnpackComb

// -----------------------------------------------------------------------------
// Sequential part for p_DataUnpackComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DataUnpackSeq
  if (HRESETn == 1'b0)
    begin
      FifoRdPtr        <= 2'b00;
      RdSubPtr         <= 2'b00;
    end
  else
    begin
      FifoRdPtr        <= NextFifoRdPtr;
      RdSubPtr         <= NextRdSubPtr;
    end
end // p_DataUnpackSeq

// -----------------------------------------------------------------------------
// The input is FifoRdData from the DmacChRegFile block. According to the DWidth
// and RdSubPtr, appropriate byte/halfword/word lanes are to be routed to the
// lower lane of RdData
// -----------------------------------------------------------------------------
always @(DWidth or RdSubPtr or FifoRdData)
begin : p_FifoReadComb
  case (DWidth)
    `BYTE_ACCESS :
      begin
        case (RdSubPtr)
          2'b00 : RdData           = {4{FifoRdData[7:0]}};
          2'b01 : RdData           = {4{FifoRdData[15:8]}};
          2'b10 : RdData           = {4{FifoRdData[23:16]}};
          2'b11 : RdData           = {4{FifoRdData[31:24]}};
          default : RdData           = {32{1'b0}};
        endcase
      end
    `HWORD_ACCESS :
      begin
        case (RdSubPtr)
          2'b00 : RdData           = {2{FifoRdData[15:0]}};
          2'b10 : RdData           = {2{FifoRdData[31:16]}};
          default : RdData           = {32{1'b0}};
        endcase
      end
    `WORD_ACCESS : RdData           = FifoRdData;
    default : RdData           = {32{1'b0}};
  endcase
end // p_FifoReadComb

// -----------------------------------------------------------------------------
// The RdData is routed to either AHB1's HWDATA or AHB2's HWDATA, depending
// on the DstSelect bit in DMACChControl register.
// -----------------------------------------------------------------------------
always @(RdData or DstSelect)
begin : p_DataDemuxComb
  if (DstSelect == 1'b0)
    begin
       WrBufDataM1      = RdData;
       WrBufDataM2      = {32{1'b0}};
    end
  // When DstSelect is 1 and other invalid-conditions.
  else
    begin
       WrBufDataM1      = {32{1'b0}};
       WrBufDataM2      = RdData;
    end
end // p_DataDemuxComb

// -----------------------------------------------------------------------------
// Whenever BusAvlbl is high, the write-data is registered into Write Buffer,
// from where it is output on the AHB data bus.
// -----------------------------------------------------------------------------
always @(BusAvlblM1 or WrBufDataM1 or WrBufferM1 or BusAvlblM2 or WrBufDataM2 or
         WrBufferM2 or AxsCntDst or DstDmacState)
begin : p_WriteBufferComb
  if ((BusAvlblM1 == 1'b1) && (AxsCntDst == 5'b00001) &&
      (DstDmacState != `ST_DST_SELECTED))
    NextWrBufferM1   = {32{1'b0}};
  else if (((BusAvlblM1 == 1'b1) && (AxsCntDst > 5'b00001)) ||
           (DstDmacState == `ST_DST_SELECTED))
    NextWrBufferM1   = WrBufDataM1;
  // BusAvlblM1 is low or Invalid-condition
  else
    NextWrBufferM1   = WrBufferM1;

  if ((BusAvlblM2 == 1'b1) && (AxsCntDst == 5'b00001) &&
      (DstDmacState != `ST_DST_SELECTED))
    NextWrBufferM2   = {32{1'b0}};
  else if (((BusAvlblM2 == 1'b1) && (AxsCntDst > 5'b00001)) ||
           (DstDmacState == `ST_DST_SELECTED))
    NextWrBufferM2   = WrBufDataM2;
  // BusAvlblM2 is low or Invalid-condition
  else
    NextWrBufferM2   = WrBufferM2;
end // p_WriteBufferComb

// -----------------------------------------------------------------------------
// Sequential block for WrBufferM1 and WrBufferM2.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_WriteBufferSeq
  if (HRESETn == 1'b0)
    begin
      WrBufferM1       <= {32{1'b0}};
      WrBufferM2       <= {32{1'b0}};
    end
  else
    begin
      WrBufferM1       <= NextWrBufferM1;
      WrBufferM2       <= NextWrBufferM2;
    end
end // p_WriteBufferSeq

// -----------------------------------------------------------------------------
// Assigning to ChxHWDATA on the basis of Destination-state-machine.
// -----------------------------------------------------------------------------
assign ChHWDATAM1       = ((DstDmacState == `ST_DST_ONBUS) | (DstDmacState ==
                           `ST_DST_DATAXFER)) ? WrBufferM1 : {32{1'b0}};

assign ChHWDATAM2       = ((DstDmacState == `ST_DST_ONBUS) | (DstDmacState ==
                           `ST_DST_DATAXFER)) ? WrBufferM2 : {32{1'b0}};

// -----------------------------------------------------------------------------
// The Wrap bit is required for the fill level calculation of FIFO.
// -----------------------------------------------------------------------------
always @(FifoPtrReset or FifoWrPtr or NextFifoWrPtr or FifoRdPtr or
         NextFifoRdPtr or WrapFlag)
begin : p_WrapFlagComb
  // Reset the wrap flag when Fifo pointers are reset.
  if (FifoPtrReset == 1'b1)
    NextWrapFlag     = 1'b0;
  // Set the Wrap flag, when the Write pointer wraps-over from last FIFO word to
  // first FIFO word.
  else if ((NextFifoWrPtr == 2'b00) && (FifoWrPtr == 2'b11))
    NextWrapFlag     = 1'b1;
  // Unset the wrap-flag, when the read FIFO pointer wraps-over from last FIFO
  // word to first FIFO word.
  else if ((NextFifoRdPtr == 2'b00) && (FifoRdPtr == 2'b11))
    NextWrapFlag     = 1'b0;
  else
    NextWrapFlag     = WrapFlag;
end // p_WrapFlagComb

// -----------------------------------------------------------------------------
// Sequential part of WrapFlag process.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_WrapFlagSeq
  if (HRESETn == 1'b0)
    WrapFlag         <= 1'b0;
  else
    WrapFlag         <= NextWrapFlag;
end // p_WrapFlagSeq

// -----------------------------------------------------------------------------
// RawFillLvl indicates the fill-level of the FIFO in terms of bytes. The
// WrPtr, WrSubPtr, RdPtr and RdSubPtr, all are two bit values. Thus
// concatenation of WrPtr and WrSubPtr addresses a particular byte in the
// 4-deep word wide FIFO. Same is the case with RdPtr and RdSubPtr. Thus the
// difference between the two gives the "Raw Fill Level". Similarly Ram empty
// level.
// -----------------------------------------------------------------------------
assign RawFillLvl       = {WrapFlag, FifoWrPtr, WrSubPtr}
                           - {1'b0, FifoRdPtr, RdSubPtr};
assign RawEmpLvl        = {1'b1, FifoRdPtr, RdSubPtr}
                           - {WrapFlag, FifoWrPtr, WrSubPtr};

// -----------------------------------------------------------------------------
// The SrcFactor and DstFactor are added to the raw fill/empty level.
// -----------------------------------------------------------------------------
assign FactoredFillLvl  = RawFillLvl + SrcFactor;
assign FactoredEmpLvl   = RawEmpLvl + DstFactor;

// -----------------------------------------------------------------------------
// The following portion of code, generates the fill-level and the empty-level
// of channel-FIFO. This fill/empty level information is used by the Source/
// destination state machines for generating AccessCount. The mask-logic also
// uses the fill/empty level for masking/unmasking source/destination requests.
// -----------------------------------------------------------------------------
always @(SWidth or DWidth or RawFillLvl or RawEmpLvl or FactoredFillLvl or
         FactoredEmpLvl or SrcDmacState)
begin : p_FillLvlGenComb
  // The raw-empty-level (without the addition of DstFactor can be used for
  // masking in DmacChReqMask block. ActEmptyLevel is given separately to
  // DmacChReqMask block.
  case (SWidth)
    `BYTE_ACCESS : ActEmptyLevel    = RawEmpLvl;
    `HWORD_ACCESS : ActEmptyLevel    = {1'b0, RawEmpLvl[4:1]};
    `WORD_ACCESS : ActEmptyLevel    = {2'b00, RawEmpLvl[4:2]};
    default : ActEmptyLevel    = {5{1'b0}};
  endcase

  // The raw-fill-level (without the addition of SrcFactor can be used for
  // masking in DmacChReqMask block. ActFillLevel is given separately to
  // DmacChReqMask block.
  case (DWidth)
    `BYTE_ACCESS : ActFillLevel     = RawFillLvl;
    `HWORD_ACCESS : ActFillLevel     = {1'b0, RawFillLvl[4:1]};
    `WORD_ACCESS : ActFillLevel     = {2'b00, RawFillLvl[4:2]};
    default : ActFillLevel     = {5{1'b0}};
  endcase

  // FifoEmptyLevel = FactoredEmpLvl/SWidth. The remainder is to be ignored.
  case (SWidth)
    `BYTE_ACCESS : FifoEmptyLevel   = FactoredEmpLvl;
    `HWORD_ACCESS : FifoEmptyLevel   = {1'b0, FactoredEmpLvl[4:1]};
    `WORD_ACCESS : FifoEmptyLevel   = {2'b00, FactoredEmpLvl[4:2]};
    default : FifoEmptyLevel   = {5{1'b0}};
  endcase

  // FifoFillLevel = FactoredFillLvl/DWidth. The remainder is to be ignored.
  case (DWidth)
    `BYTE_ACCESS : FifoFillLevel    = FactoredFillLvl;
    `HWORD_ACCESS : FifoFillLevel    = {1'b0, FactoredFillLvl[4:1]};
    `WORD_ACCESS : FifoFillLevel    = {2'b00, FactoredFillLvl[4:2]};
    default : FifoFillLevel    = {5{1'b0}};
  endcase

  // The FifoNonEmpty is generated for the Active bit in DMACChConfig register.
  FifoNonEmpty     = (|(RawFillLvl)) | (SrcDmacState != `ST_SRC_IDLE);
end // p_FillLvlGenComb : 

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

  
// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule

// --================================== End ==================================--
