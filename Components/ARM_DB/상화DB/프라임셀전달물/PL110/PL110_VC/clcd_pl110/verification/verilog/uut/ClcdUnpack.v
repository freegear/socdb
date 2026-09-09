// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdUnpack.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//   Purpose               : This module takes 64 bit input data, extracts
//                           1,2,4,8,16 or 24 bit pixel index for the palette
//                           depending on the BPP, byte order(BEBO) and pixel
//                           order (BEPO) settings.
// --=========================================================================--

`timescale 1ns/1ps
`include "ClcdConfig.v"
// -----------------------------------------------------------------------------

module ClcdUnpack (
// Inputs 
                   CLCDCLK,
                   nCLCLKRESET,
                   FrameRst,
                   FifoDataIn,
                   LcdBPP,
                   LcdDual,
                   BEBO,
                   BEPO,
                   Toggle,
                   UnpackEn,
                   PixelEn,
// Outputs 
                   PixelIndex,
                   PixelValid,
                   FRdPtr,
                   FRdPtrInc
                  );

// Inputs 
input          CLCDCLK;        // Clock input
input          nCLCLKRESET;    // System reset input
input          FrameRst;       // signal to flush pipeline at end of frame
input          UnpackEn;       // Enable unpacker signal from timing generator
input          LcdDual;        // Enable Dual panel mode 
input          Toggle;         // Dual mode toggle bit
input          PixelEn;        // Take current pixel
input          BEBO;           // Byte ordering with in the frame buffer
input          BEPO;           // Pixel ordering with in the byte
input [2:0]    LcdBPP;         // Bits per pixel
input [63:0]   FifoDataIn;     // DMA Fifo output data

// Outputs 
output         FRdPtrInc;      // upper/lower FIFO read pointer incr enable
output         PixelValid;     // Pixel data out is valid
output [`PTR_SIZE-1:0] FRdPtr; // Upper/Lower FIFO read address
output [23:0]  PixelIndex;     // Pixel data out

// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module consists of the following 
// - Unpacker state machine.
// - MUX logic for the extraction of pixel data from the input data based on the
//   unpacker state machine state.
// - DMA FIFO Read port control logic (Read pointer)
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// state machine states
// -----------------------------------------------------------------------------
`define ST_UP1      5'b00000    // Unpacker state
`define ST_UP2      5'b00001
`define ST_UP3      5'b00010
`define ST_UP4      5'b00011
`define ST_UP5      5'b00100
`define ST_UP6      5'b00101
`define ST_UP7      5'b00110
`define ST_UP8      5'b00111
`define ST_UP9      5'b01000
`define ST_UP10     5'b01001
`define ST_UP11     5'b01010
`define ST_UP12     5'b01011
`define ST_UP13     5'b01100
`define ST_UP14     5'b01101
`define ST_UP15     5'b01110
`define ST_UP16     5'b01111
`define ST_UP17     5'b10000
`define ST_UP18     5'b10001
`define ST_UP19     5'b10010
`define ST_UP20     5'b10011
`define ST_UP21     5'b10100
`define ST_UP22     5'b10101
`define ST_UP23     5'b10110
`define ST_UP24     5'b10111
`define ST_UP25     5'b11000
`define ST_UP26     5'b11001
`define ST_UP27     5'b11010
`define ST_UP28     5'b11011
`define ST_UP29     5'b11100
`define ST_UP30     5'b11101
`define ST_UP31     5'b11110
`define ST_UP32     5'b11111

// -----------------------------------------------------------------------------
// Bits per pixel field definition
// -----------------------------------------------------------------------------
`define BPP1          3'b000 // 1-bit per pixel
`define BPP2          3'b001 // 2-bits per pixel
`define BPP4          3'b010 // 4-bits per pixel
`define BPP8          3'b011 // 8-bits per pixel
`define BPP16         3'b100 // 16-bits per pixel
`define BPP24         3'b101 // 24-bits per pixel

// -----------------------------------------------------------------------------
// Byte and pixel ordering definition
// -----------------------------------------------------------------------------
`define LBLP        2'b00 // little-endian byte order little-endian pixel order
`define LBBP        2'b01 // little-endian byte order big-endian pixel order

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire           CLCDCLK;         
// Clock input                                        (Module input)

wire           nCLCLKRESET;  
// System reset input                                 (Module input)

wire           FrameRst;     
// signal to flush pipeline at end of frame           (Module input)

wire           UnpackEn;   
// Unpacker enable signal from timing generator       (Module input)

wire           LcdDual;     
// Enable Dual panel mode                             (Module input)

wire           Toggle;       
// Dual mode toggle bit                               (Module input)

wire  [63:0]   FifoDataIn;     
// Upper/Lower Fifo output data                       (Module input)

wire  [2:0]    LcdBPP;      
// Bits per pixel                                     (Module input)

wire           PixelEn;      
// Take current pixel                                 (Module input)

wire           BEBO;     
// Byte ordering with in the frame buffer             (Module input)

wire           BEPO;     
// Pixel ordering with in the byte                    (Module input)

wire        FifoRead;
// DMA FIFO read request from the unpacker logic

wire [31:0]  DataIn;
// output data MUX


// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         PixelValid;
// Out going pixel is vallid                         (Module output)

reg [`PTR_SIZE-1:0] FRdPtr;
// Upper/Lower fifo read address                     (Module Output)

reg [23:0]  PixelIndex;
// Pixel data out                                    (Module output)

reg [`PTR_SIZE-1:0] NextFRdPtr;
// D-input of Upper/Lower fifo read pointer

reg [4:0]   PixState;
// Unpacker state machine state register

reg [4:0]   NextPixState1;
// D-input of state register

reg [4:0]   NextPixState;
// Next state value from state machine logic

reg [23:0]  NextPixIndex1;
// D-input of Pixel data

reg [23:0]  NextPixIndex;
// Unpacker MUX output

reg         NextPixValid1;
// D-input of Pixelvalid register

reg         NextPixValid;
// PixelValid - State machine output

reg         DataIndex;
// Fifo data index to select 32-bit data out of 128-bit input data

reg         NextDataIndex;
// Data index- state machine out put

reg         IntFifoRead;
// Internal version of Fifo read request

reg         NextDIndex1;
// D-input of DataIndex 

reg            FRdPtrInc;
// Internal version of read pointer increment enable

reg            NextFRdPtrInc;
// D-input of FRdPtrInc

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                        UNPACKER LOGIC (PIXEL SERIALISER)
//                        --------------------------------
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Muxing of Data input in Dual Panel mode
// - in dual panel mode FifoDataIn[31:0] is taken as upper panel data and 
// FifoDataIn[63:32] as lower panel data.
// - in single panel mode entire 64 bit data is taken as upper panel data.
// -----------------------------------------------------------------------------
assign DataIn[31:0] = (Toggle == 1'b0 && DataIndex == 1'b0) ? FifoDataIn[31:0] 
                                                         : FifoDataIn[63:32];

// -----------------------------------------------------------------------------
// selection of read request. in dual panel mode the read request is of two
// clock wide. Hence it is ANDed with the Toggle signal to form 1 clock wide 
// read pulse. 
// -----------------------------------------------------------------------------
assign FifoRead = (LcdDual == 1'b0) ? IntFifoRead : Toggle & IntFifoRead;

// -----------------------------------------------------------------------------
//
// State machine to control which pixel is going out, and when the read is sent
// to the FIFO.
// The next 'valid' is generated, though this is enabled in the output register.
//
// -----------------------------------------------------------------------------
always @(PixState or PixelEn or LcdBPP or UnpackEn or DataIndex or
         LcdDual or NextPixValid)
begin : p_UnpStateComb
  IntFifoRead = 1'b0;
  NextPixState = PixState;
  NextPixValid = 1'b0;
  NextDataIndex = DataIndex;

  case (PixState[4:0])

    `ST_UP1:
      begin
// -----------------------------------------------------------------------------
// if a valid data is available in the FIFO and PixelEn is HIGH: check if the 
// BPP is set to 24bpp. if yes assert the FifoRead if the DataIndex is 1 else
// set DataIndex to a value of "1" and wait in the same state. if the BPP is set
// to other than 24bpp, go to ST_UP2 state.
// -----------------------------------------------------------------------------
        if ((UnpackEn == 1'b1) && (PixelEn == 1'b1))
          begin
            if (LcdBPP == `BPP24)
              begin
                if (DataIndex == 1'b1)
                  begin
                    NextDataIndex = 1'b0;
                    IntFifoRead = 1'b1;
                  end
                else
                  NextDataIndex = 1'b1;
                NextPixState = `ST_UP1;
              end
            else
              NextPixState = `ST_UP2;
            NextPixValid = 1'b1;
          end
      end

    `ST_UP2:
      begin
        NextPixValid = 1'b1;
// -----------------------------------------------------------------------------
// if PixelEn is HIGH and the mode is 16BPP: check if the mode is DUAL. if yes
// assert FifoRead and go back to the ST_UP1 state.Else if it is SINGLE panel
// mode go back to the ST_UP1 state to process the second word of the input data
// Else go to next state.
// -----------------------------------------------------------------------------
        if (PixelEn == 1'b1)
          begin
            if (LcdBPP == `BPP16)
              begin
                if (LcdDual == 1'b1 || DataIndex == 1'b1)
                  begin
                    NextDataIndex = 1'b0;
                    IntFifoRead = 1'b1;
                  end
                else
                  NextDataIndex = 1'b1;
                NextPixState = `ST_UP1;
              end
            else
              NextPixState = `ST_UP3;
          end
      end
    `ST_UP3:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP4;
      end
    `ST_UP4:
      begin
        NextPixValid = 1'b1;
// -----------------------------------------------------------------------------
// if PixelEn is HIGH and the mode is 8BPP: check if the mode is DUAL. if yes
// assert FifoRead and go back to the ST_UP1 state.Else if it is SINGLE panel
// mode go back to the ST_UP1 state to process the second word of the input data
// Else go to next state.
// ----------------------------------------------------------------------------
        if (PixelEn == 1'b1)
          begin
            if (LcdBPP == `BPP8)
              begin
                if (LcdDual == 1'b1 || DataIndex == 1'b1)
                  begin
                    NextDataIndex = 1'b0;
                    IntFifoRead = 1'b1;
                  end
                else
                  NextDataIndex = 1'b1;
                NextPixState = `ST_UP1;
              end
            else
              NextPixState = `ST_UP5;
          end
      end

    `ST_UP5:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP6;
      end

    `ST_UP6:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP7;
      end

    `ST_UP7:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP8;
      end

    `ST_UP8:
      begin
        NextPixValid = 1'b1;
// -----------------------------------------------------------------------------
// if PixelEn is HIGH and the mode is 16BPP: check if the mode is DUAL. if yes
// assert FifoRead and go back to the ST_UP1 state.Else if it is SINGLE panel
// mode go back to the ST_UP1 state to process the second word of the input data
// Else go to next state.
// ----------------------------------------------------------------------------
        if (PixelEn == 1'b1)
          begin
            if (LcdBPP == `BPP4)
              begin
                if (LcdDual == 1'b1 || DataIndex == 1'b1)
                  begin
                    NextDataIndex = 1'b0;
                    IntFifoRead = 1'b1;
                  end
                else
                  NextDataIndex = 1'b1;
                NextPixState = `ST_UP1;
              end
            else
              NextPixState = `ST_UP9;
          end
      end

    `ST_UP9:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP10;
      end

    `ST_UP10:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP11;
      end

    `ST_UP11:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP12;
      end

    `ST_UP12:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP13;
      end

    `ST_UP13:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP14;
      end

    `ST_UP14:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP15;
      end

    `ST_UP15:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP16;
      end

    `ST_UP16:
      begin
        NextPixValid = 1'b1;
// -----------------------------------------------------------------------------
// if PixelEn is HIGH and the mode is 2BPP: check if the mode is DUAL. if yes
// assert FifoRead and go back to the ST_UP1 state.Else if it is SINGLE panel
// mode go back to the ST_UP1 state to process the second word of the input data
// Else go to next state.
// ----------------------------------------------------------------------------
        if (PixelEn == 1'b1)
          begin
            if (LcdBPP == `BPP2)
              begin
                if (LcdDual == 1'b1 || DataIndex == 1'b1)
                  begin
                    NextDataIndex = 1'b0;
                    IntFifoRead = 1'b1;
                  end
                else
                  NextDataIndex = 1'b1;
                NextPixState = `ST_UP1;
              end
            else
              NextPixState = `ST_UP17;
          end
      end

    `ST_UP17:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP18;
      end

    `ST_UP18:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP19;
      end

    `ST_UP19:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP20;
      end

    `ST_UP20:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP21;
      end

    `ST_UP21:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP22;
      end

    `ST_UP22:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP23;
      end

    `ST_UP23:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP24;
      end
 
    `ST_UP24:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP25;
      end

    `ST_UP25:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP26;
      end

    `ST_UP26:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP27;
      end

    `ST_UP27:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP28;
      end

    `ST_UP28:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP29;
      end

    `ST_UP29:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP30;
      end

    `ST_UP30:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP31;
      end

    `ST_UP31:
      begin
        NextPixValid = 1'b1;
        if (PixelEn == 1'b1)
          NextPixState = `ST_UP32;
      end

    `ST_UP32:
      begin
        NextPixValid = 1'b1;
// -----------------------------------------------------------------------------
// if PixelEn is HIGH : check if the mode is DUAL. if yes
// assert FifoRead and go back to the ST_UP1 state.Else if it is SINGLE panel
// mode go back to the ST_UP1 state to process the second word of the input data
// Else go to next state.
// ----------------------------------------------------------------------------
        if (PixelEn == 1'b1)
          begin
            if (LcdDual == 1'b1 || DataIndex == 1'b1)
              begin
                NextDataIndex = 1'b0;
                IntFifoRead = 1'b1;
              end
            else
              NextDataIndex = 1'b1;
            NextPixState = `ST_UP1;
          end
      end

    default:
      begin
        NextPixState = `ST_UP1;
      end
  endcase
end // p_UnpStateComb


// -----------------------------------------------------------------------------
// MUX logic to extract pixel index from the input data based on bits per pixel,
// Byte ordering(BEBO), Pixel ordering(BEPO).
// the following byte and pixel ordering is supported:
// - Little-endian byte order and Little-endian pixel order
// - Little-endian byte order and Big-endian pixel order
// - Big-endian byte order and Big-endian pixel order
//
// Note: Pixel ordering is applicable only for 4,2 and 1 bpp mode
// -----------------------------------------------------------------------------
always @(LcdBPP or DataIn or PixState or BEBO or BEPO)
begin : p_UMuxComb
  case (PixState[4:0])
    `ST_UP32: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[31]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[24]};
          default: NextPixIndex  = {23'b0,DataIn[0]}; //BBBP 
        endcase
      end
    `ST_UP31: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[30]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[25]};
          default: NextPixIndex  = {23'b0,DataIn[1]}; //BBBP 
        endcase
      end
    `ST_UP30: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[29]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[26]};
          default: NextPixIndex  = {23'b0,DataIn[2]}; //BBBP 
        endcase
      end
    `ST_UP29: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[28]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[27]};
          default: NextPixIndex  = {23'b0,DataIn[3]}; //BBBP 
        endcase
      end
    `ST_UP28: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[27]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[28]};
          default: NextPixIndex  = {23'b0,DataIn[4]}; //BBBP 
        endcase
      end
    `ST_UP27: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[26]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[29]};
          default: NextPixIndex  = {23'b0,DataIn[5]}; //BBBP 
        endcase
      end
    `ST_UP26: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[25]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[30]};
          default: NextPixIndex  = {23'b0,DataIn[6]}; //BBBP 
        endcase
      end
    `ST_UP25: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[24]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[31]};
          default: NextPixIndex  = {23'b0,DataIn[7]}; //BBBP 
        endcase
      end
    `ST_UP24: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[23]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[16]};
          default: NextPixIndex  = {23'b0,DataIn[8]}; //BBBP 
        endcase
      end
    `ST_UP23: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[22]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[17]};
          default: NextPixIndex  = {23'b0,DataIn[9]}; //BBBP 
        endcase
      end
    `ST_UP22: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[21]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[18]};
          default: NextPixIndex  = {23'b0,DataIn[10]}; //BBBP
        endcase
      end
    `ST_UP21: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[20]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[19]};
          default: NextPixIndex  = {23'b0,DataIn[11]}; //BBBP
        endcase
      end
    `ST_UP20: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[19]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[20]};
          default: NextPixIndex  = {23'b0,DataIn[12]}; //BBBP
        endcase
      end
    `ST_UP19: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[18]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[21]};
          default: NextPixIndex  = {23'b0,DataIn[13]}; //BBBP
        endcase
      end
    `ST_UP18: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[17]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[22]};
          default: NextPixIndex  = {23'b0,DataIn[14]}; //BBBP
        endcase
      end
    `ST_UP17: // 1 bpp mode
      begin
        case ({BEBO,BEPO})
          `LBLP: NextPixIndex    = {23'b0,DataIn[16]};
          `LBBP: NextPixIndex    = {23'b0,DataIn[23]};
          default: NextPixIndex  = {23'b0,DataIn[15]}; //BBBP
        endcase
      end
    `ST_UP16: // 1bpp and 2bpp mode
      begin
        if (LcdBPP == `BPP1)
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {23'b0,DataIn[15]};
            `LBBP: NextPixIndex    = {23'b0,DataIn[8]};
            default: NextPixIndex  = {23'b0,DataIn[16]}; //BBBP
          endcase
        else     //`BPP2
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {22'b0,DataIn[31:30]};
            `LBBP: NextPixIndex    = {22'b0,DataIn[25:24]};
            default: NextPixIndex  = {22'b0,DataIn[1:0]}; //BBBP
          endcase
      end
    `ST_UP15: // 1bpp and 2bpp mode
      begin
        if (LcdBPP == `BPP1)
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {23'b0,DataIn[14]};
            `LBBP: NextPixIndex    = {23'b0,DataIn[9]};
            default: NextPixIndex  = {23'b0,DataIn[17]}; //BBBP
          endcase
        else     //`BPP2
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {22'b0,DataIn[29:28]};
            `LBBP: NextPixIndex    = {22'b0,DataIn[27:26]};
            default: NextPixIndex  = {22'b0,DataIn[3:2]}; //BBBP
          endcase
      end
    `ST_UP14: // 1bpp and 2bpp mode
      begin
        if (LcdBPP == `BPP1)
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {23'b0,DataIn[13]};
            `LBBP: NextPixIndex    = {23'b0,DataIn[10]};
            default: NextPixIndex  = {23'b0,DataIn[18]}; //BBBP
          endcase
        else     //`BPP2
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {22'b0,DataIn[27:26]};
            `LBBP: NextPixIndex    = {22'b0,DataIn[29:28]};
            default: NextPixIndex  = {22'b0,DataIn[5:4]}; //BBBP
          endcase
      end
    `ST_UP13: // 1bpp and 2bpp mode
      begin
        if (LcdBPP == `BPP1)
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {23'b0,DataIn[12]};
            `LBBP: NextPixIndex    = {23'b0,DataIn[11]};
            default: NextPixIndex  = {23'b0,DataIn[19]}; //BBBP
          endcase
        else     //`BPP2
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {22'b0,DataIn[25:24]};
            `LBBP: NextPixIndex    = {22'b0,DataIn[31:30]};
            default: NextPixIndex  = {22'b0,DataIn[7:6]}; //BBBP
          endcase
      end
    `ST_UP12: // 1bpp and 2bpp mode
      begin
        if (LcdBPP == `BPP1)
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {23'b0,DataIn[11]};
            `LBBP: NextPixIndex    = {23'b0,DataIn[12]};
            default: NextPixIndex  = {23'b0,DataIn[20]}; //BBBP
          endcase
        else     //`BPP2
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {22'b0,DataIn[23:22]};
            `LBBP: NextPixIndex    = {22'b0,DataIn[17:16]};
            default: NextPixIndex  = {22'b0,DataIn[9:8]}; //BBBP
          endcase
      end
    `ST_UP11: // 1bpp and 2bpp mode
      begin
        if (LcdBPP == `BPP1)
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {23'b0,DataIn[10]};
            `LBBP: NextPixIndex    = {23'b0,DataIn[13]};
            default: NextPixIndex  = {23'b0,DataIn[21]}; //BBBP
          endcase
        else     //`BPP2
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {22'b0,DataIn[21:20]};
            `LBBP: NextPixIndex    = {22'b0,DataIn[19:18]};
            default: NextPixIndex  = {22'b0,DataIn[11:10]}; //BBBP
          endcase
      end
    `ST_UP10: // 1bpp and 2bpp mode
      begin
        if (LcdBPP == `BPP1)
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {23'b0,DataIn[9]};
            `LBBP: NextPixIndex    = {23'b0,DataIn[14]};
            default: NextPixIndex  = {23'b0,DataIn[22]}; //BBBP
          endcase
        else     //`BPP2
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {22'b0,DataIn[19:18]};
            `LBBP: NextPixIndex    = {22'b0,DataIn[21:20]};
            default: NextPixIndex  = {22'b0,DataIn[13:12]}; //BBBP
          endcase
      end
    `ST_UP9: // 1bpp and 2bpp mode
      begin
        if (LcdBPP == `BPP1)
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {23'b0,DataIn[8]};
            `LBBP: NextPixIndex    = {23'b0,DataIn[15]};
            default: NextPixIndex  = {23'b0,DataIn[23]}; //BBBP
          endcase
        else     //`BPP2
          case ({BEBO,BEPO})
            `LBLP: NextPixIndex    = {22'b0,DataIn[17:16]};
            `LBBP: NextPixIndex    = {22'b0,DataIn[23:22]};
            default: NextPixIndex  = {22'b0,DataIn[15:14]}; //BBBP
          endcase
      end
   `ST_UP8:    // 1bpp,2bpp and 4bpp mode
     case (LcdBPP)
       `BPP1:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {23'b0,DataIn[7]};
           `LBBP: NextPixIndex    = {23'b0,DataIn[0]};
           default: NextPixIndex  = {23'b0,DataIn[24]}; //BBBP
         endcase

       `BPP2:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {22'b0,DataIn[15:14]};
           `LBBP: NextPixIndex    = {22'b0,DataIn[9:8]};
           default: NextPixIndex  = {22'b0,DataIn[17:16]}; //BBBP
         endcase

       default: // `BPP4
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {20'b0,DataIn[31:28]};
           `LBBP: NextPixIndex    = {20'b0,DataIn[27:24]};
           default: NextPixIndex  = {20'b0,DataIn[3:0]}; //BBBP
         endcase
     endcase

                                      
   `ST_UP7:    // 1bpp,2bpp and 4bpp mode
     case (LcdBPP)
       `BPP1:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {23'b0,DataIn[6]};
           `LBBP: NextPixIndex    = {23'b0,DataIn[1]};
           default: NextPixIndex  = {23'b0,DataIn[25]}; //BBBP
         endcase

       `BPP2:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {22'b0,DataIn[13:12]};
           `LBBP: NextPixIndex    = {22'b0,DataIn[11:10]};
           default: NextPixIndex  = {22'b0,DataIn[19:18]}; //BBBP
         endcase

       default: // `BPP4
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {20'b0,DataIn[27:24]};
           `LBBP: NextPixIndex    = {20'b0,DataIn[31:28]};
           default: NextPixIndex  = {20'b0,DataIn[7:4]}; //BBBP
         endcase
     endcase
                                      
   `ST_UP6:    // 1bpp,2bpp and 4bpp mode
     case (LcdBPP)
       `BPP1:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {23'b0,DataIn[5]};
           `LBBP: NextPixIndex    = {23'b0,DataIn[2]};
           default: NextPixIndex  = {23'b0,DataIn[26]}; //BBBP
         endcase

       `BPP2: 
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {22'b0,DataIn[11:10]};
           `LBBP: NextPixIndex    = {22'b0,DataIn[13:12]};
           default: NextPixIndex  = {22'b0,DataIn[21:20]}; //BBBP
         endcase

       default: // `BPP4
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {20'b0,DataIn[23:20]};
           `LBBP: NextPixIndex    = {20'b0,DataIn[19:16]};
           default: NextPixIndex  = {20'b0,DataIn[11:8]}; //BBBP
         endcase
     endcase

                                      
   `ST_UP5:    // 1bpp,2bpp or 4bpp mode
     case (LcdBPP)
       `BPP1:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {23'b0,DataIn[4]};
           `LBBP: NextPixIndex    = {23'b0,DataIn[3]};
           default: NextPixIndex  = {23'b0,DataIn[27]}; //BBBP
         endcase

       `BPP2: 
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {22'b0,DataIn[9:8]};
           `LBBP: NextPixIndex    = {22'b0,DataIn[15:14]};
           default: NextPixIndex  = {22'b0,DataIn[23:22]}; //BBBP
         endcase

       default: // `BPP4
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {20'b0,DataIn[19:16]};
           `LBBP: NextPixIndex    = {20'b0,DataIn[23:20]};
           default: NextPixIndex  = {20'b0,DataIn[15:12]}; //BBBP
         endcase
     endcase

   
   `ST_UP4:    // 1bpp,2bpp,4bpp or 8bpp mode
     case (LcdBPP)
       `BPP1:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {23'b0,DataIn[3]};
           `LBBP: NextPixIndex    = {23'b0,DataIn[4]};
           default: NextPixIndex  = {23'b0,DataIn[28]}; //BBBP
         endcase

       `BPP2: 
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {22'b0,DataIn[7:6]};
           `LBBP: NextPixIndex    = {22'b0,DataIn[1:0]};
           default: NextPixIndex  = {22'b0,DataIn[25:24]}; //BBBP
         endcase

       `BPP4:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {20'b0,DataIn[15:12]};
           `LBBP: NextPixIndex    = {20'b0,DataIn[11:8]};
           default: NextPixIndex  = {20'b0,DataIn[19:16]}; //BBBP
         endcase

       default:  
         if (BEBO == 1'b1) 
           NextPixIndex = {16'b0,DataIn[7:0]};
         else NextPixIndex = {16'b0,DataIn[31:24]};
    endcase // end of case (LcdBPP)


   `ST_UP3:    // 1bpp,2bpp,4bpp or 8bpp mode
     case (LcdBPP)
       `BPP1:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {23'b0,DataIn[2]};
           `LBBP: NextPixIndex    = {23'b0,DataIn[5]};
           default: NextPixIndex  = {23'b0,DataIn[29]}; //BBBP
         endcase

       `BPP2: 
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {22'b0,DataIn[5:4]};
           `LBBP: NextPixIndex    = {22'b0,DataIn[3:2]};
           default: NextPixIndex  = {22'b0,DataIn[27:26]}; //BBBP
         endcase

       `BPP4:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {20'b0,DataIn[11:8]};
           `LBBP: NextPixIndex    = {20'b0,DataIn[15:12]};
           default: NextPixIndex  = {20'b0,DataIn[23:20]}; //BBBP
         endcase

       default: 
         if (BEBO == 1'b1) 
           NextPixIndex = {16'b0,DataIn[15:8]}; 
         else 
           NextPixIndex = {16'b0,DataIn[23:16]};
     endcase // end of case (LcdBPP)

                                          
   `ST_UP2:    // 1bpp,2bpp,4bpp,8bpp or 16bpp mode
     case (LcdBPP)
       `BPP1: 
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {23'b0,DataIn[1]};
           `LBBP: NextPixIndex    = {23'b0,DataIn[6]};
           default: NextPixIndex  = {23'b0,DataIn[30]}; //BBBP
         endcase

       `BPP2:  
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {22'b0,DataIn[3:2]};
           `LBBP: NextPixIndex    = {22'b0,DataIn[5:4]};
           default: NextPixIndex  = {22'b0,DataIn[29:28]}; //BBBP
         endcase 

       `BPP4:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {20'b0,DataIn[7:4]};
           `LBBP: NextPixIndex    = {20'b0,DataIn[3:0]};
           default: NextPixIndex  = {20'b0,DataIn[27:24]}; //BBBP
         endcase

        `BPP8: 
          if (BEBO == 1'b1) 
            NextPixIndex = {16'b0,DataIn[23:16]};
          else 
            NextPixIndex = {16'b0,DataIn[15:8]};

       default: 
         if (BEBO == 1'b1) 
           NextPixIndex = {8'b0,DataIn[15:0]};
         else 
           NextPixIndex = {8'b0,DataIn[31:16]};
     endcase // end of case (LcdBPP)

   default: // `ST_UP1:        // 1bpp,2bpp,4bpp,8bpp or 16bpp 
     case (LcdBPP)
       `BPP1: 
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {23'b0,DataIn[0]};
           `LBBP: NextPixIndex    = {23'b0,DataIn[7]};
           default: NextPixIndex  = {23'b0,DataIn[31]}; //BBBP
         endcase

       `BPP2:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {22'b0,DataIn[1:0]};
           `LBBP: NextPixIndex    = {22'b0,DataIn[7:6]};
           default: NextPixIndex  = {22'b0,DataIn[31:30]}; //BBBP
         endcase  

       `BPP4:
         case ({BEBO,BEPO})
           `LBLP: NextPixIndex    = {20'b0,DataIn[3:0]};
           `LBBP: NextPixIndex    = {20'b0,DataIn[7:4]};
           default: NextPixIndex  = {20'b0,DataIn[31:28]}; //BBBP
         endcase

       `BPP8: 
         if (BEBO == 1'b1) 
           NextPixIndex = {16'b0,DataIn[31:24]};
         else 
           NextPixIndex = {16'b0,DataIn[7:0]};

       `BPP16: 
         if (BEBO == 1'b1) 
           NextPixIndex = {8'b0,DataIn[31:16]}; 
         else 
           NextPixIndex = {8'b0,DataIn[15:0]};

       default: NextPixIndex = DataIn[23:0]; //BPP24
     endcase // end of case (BPP)
  endcase // end of case PixelState
end // p_UMuxComb

// -----------------------------------------------------------------------------
// Combinational process for DataIndex. On reset or FrameEnd, initialise the 
// dataindex to zero.
// -----------------------------------------------------------------------------
always @(NextDataIndex or FrameRst)
begin : p_DIndexComb
  if (FrameRst == 1'b1)
    NextDIndex1 = 1'b0;
  else 
    NextDIndex1 = NextDataIndex;
end // p_DIndexComb    

// -----------------------------------------------------------------------------
// Sequential process for Data index
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_DIndexSeq
  if (nCLCLKRESET == 1'b0)
    DataIndex <= 1'b0;
  else
    DataIndex <= NextDIndex1;
end // p_DIndexSeq

// -----------------------------------------------------------------------------
// Combinational process for pixel state and PixelValid signal.
// in Dual panel mode state transition occurs on every alternate clock.
// -----------------------------------------------------------------------------
always @(FrameRst or PixelEn or Toggle or LcdDual or PixState or NextPixState 
         or NextPixValid or PixelValid)
begin : p_UStateComb
  NextPixState1 = PixState;
  NextPixValid1 = PixelValid;
// -----------------------------------------------------------------------------
// On frame reset, that is at the end of frame initialise state machine to 
// ST_UP1 state and pixel valid to "1'b0
// -----------------------------------------------------------------------------
  if (FrameRst == 1'b1)
    begin
      NextPixState1  =  `ST_UP1;
      NextPixValid1  =  1'b0;
    end
  else
    begin
      if (PixelEn == 1'b1)
        NextPixValid1 =  NextPixValid;
// -----------------------------------------------------------------------------
// in dual panel mode state transition should happen only when Toggle signal is
// sampled HIGH on any rising edge of CLCDCLK.in this mode the state transition 
// happens on alternate clock. 
// -----------------------------------------------------------------------------
      if ((LcdDual == 1'b1) && (Toggle == 1'b1))
        NextPixState1 =  NextPixState;
      else
// -----------------------------------------------------------------------------
// else if single panel mode is enabled state transition happens on each clock
// -----------------------------------------------------------------------------
          if (LcdDual == 1'b0)
        NextPixState1 =  NextPixState;
      end
end // p_UStateComb

// -----------------------------------------------------------------------------
// Sequential process for pixel state and PixelValid signal.
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_UStateSeq 
  if (nCLCLKRESET == 1'b0)
    begin
      PixelValid <= 1'b0;
      PixState   <= `ST_UP1;
    end
  else
    begin
      PixelValid <= NextPixValid1;
      PixState   <= NextPixState1;
    end
end // p_UStateSeq

// -----------------------------------------------------------------------------
// Combinational process for Pixel Index 
// -----------------------------------------------------------------------------
always @(PixelIndex or PixelEn or NextPixIndex or UnpackEn)
begin : p_PixelIndComb 
  NextPixIndex1 = PixelIndex;
  if (PixelEn == 1'b1 && UnpackEn == 1'b1)
    NextPixIndex1 = NextPixIndex;
end // p_PixelIndComb

// -----------------------------------------------------------------------------
// Sequential process for PixelIndex
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_PixelIndSeq  
  if (nCLCLKRESET == 1'b0)
    PixelIndex  <=  24'b0;
  else
    PixelIndex <= NextPixIndex1;
end // p_PixelIndSeq

// -----------------------------------------------------------------------------
//                  DMA FIFO READ PORT CONTROL LOGIC
//                  -------------------------------
// ----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Toggle FRdPtrInc signal on every read request. this signal is then double 
// synchronised to HCLK domain and then used for watermark level computation
// of the FIFO in ClcdDMAFifo module.
// -----------------------------------------------------------------------------
always @(FRdPtrInc or FrameRst or FifoRead)
begin : p_RdIncComb
   if (FrameRst == 1'b1)
     NextFRdPtrInc = 1'b0;
   else if (FifoRead == 1'b1)
     NextFRdPtrInc = ~FRdPtrInc;
   else
     NextFRdPtrInc = FRdPtrInc;
end // p_RdIncComb
 
// -----------------------------------------------------------------------------
// Sequential process for FRdPtrInc signal
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_RdIncSeq
  if (nCLCLKRESET == 1'b0)
    FRdPtrInc <= 1'b0;
  else
    FRdPtrInc <= NextFRdPtrInc;
end // p_RdIncSeq

// -----------------------------------------------------------------------------
// Increment the read address of the FIFO reg/FIFORAM in CLCDCLK domain
// when FifoRead is sampled HIGH.
// Data corresponding to this address will be driven out as FIFO read data.
// -----------------------------------------------------------------------------
always @(FifoRead or FRdPtr or FrameRst)
begin : p_FRdptrComb
  if (FrameRst == 1'b1)
    NextFRdPtr = 0;
  else if (FifoRead == 1'b1)
    NextFRdPtr = FRdPtr + 1'b1;
  else
    NextFRdPtr = FRdPtr;
end // p_FRdptrComb
 
// -----------------------------------------------------------------------------
// Sequential process for Fifo read pointer
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_FrdPtrSeq
  if (nCLCLKRESET == 1'b0)
    FRdPtr <= 0;
  else
    FRdPtr <= NextFRdPtr;
end // p_FrdPtrSeq

endmodule

// --================================== End ==================================--
