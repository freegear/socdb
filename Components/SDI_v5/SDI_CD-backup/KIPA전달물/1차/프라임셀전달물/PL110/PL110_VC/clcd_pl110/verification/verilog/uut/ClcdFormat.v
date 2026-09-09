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
//  File Name              : ClcdFormat.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//  Purpose                : This block packs the pixels in to 8 bit or 4 bit
//                           quantity and write it in to a 3 byte FIFO for STN
//                           panels:
//                           1. In Colour STN mode the pixels are packed in to
//                              an 8-bit data.
//                           2. In Mono STN mode the pixels are packed in to
//                              8-bit/4-bit data depending on the Interface 
//                              width (Mono8bit) bit setting.
//
// --=========================================================================--

`timescale 1ns/1ps

module ClcdFormat (
// Inputs
                   CLCDCLK, 
                   nCLCLKRESET, 
                   LcdBW, 
                   Mono8Bit, 
                   LcdTFT, 
                   PixelEn,
                   FifoRead,
                   AhbMBESyncLclk,
                   RGS, 
                   GGS, 
                   BGS, 

// Outputs
                   STNDout,
                   FormFifoFull
                  );


// Inputs
input        CLCDCLK;        // Clock input
input        nCLCLKRESET;    // Reset input - Asynchronous
input        LcdBW;          // Lcd is black and white
input        Mono8Bit;       // Lcd interface is 8 bit wide
input        LcdTFT;         // Lcd is of TFT type 
input        PixelEn;        // Pixel availble signal from Greyscaler
input        FifoRead;       // Read enable from Timing module
input        AhbMBESyncLclk; // AHB bus error interrupt from AHB master
input        RGS;            // Red Pixel in
input        GGS;            // Green Pixel in
input        BGS;            // Blue Pixel in

// Outputs
output       FormFifoFull;   // Fifo full status to greyscaler
output [7:0] STNDout;        // Fifo Read data out

// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module packs the pixels in to a 4-bit or 8-bit quantity in the STN mode
// of operation.
// it includes the following
// - 3-bit shift left register for the data path R,G,B.
// - A counter to count the formatter state.
// - MUX logic to arrange the pixel in the desired order
// - A 3 byte synchronous FIFO with Read/Write control logic
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire         CLCDCLK;         
// Clock input                                   (Module input)

wire         nCLCLKRESET;       
// Reset input - Asynchronous                    (Module input)

wire         LcdBW;        
// Lcd is black and white                        (Module input)

wire         Mono8Bit;     
// Lcd interface is 8 bit wide                   (Module input)

wire         LcdTFT;       
// Lcd is of TFT type                            (Module input)

wire         PixelEn;      
// Pixel availble signal from Greyscaler         (Module input)

wire          FifoRead;
// Read enable from Timing module                (Module input)

wire         AhbMBESyncLclk; 
// AHB bus error interrupt from AHB master        (Module input)

wire         RGS;          
// Red Pixel in                                  (Module input)

wire         GGS;          
// Green Pixel in                                (Module input)

wire         BGS;          
// Blue Pixel in                                 (Module input)

wire   [7:0]  FormData;
// Formatted data out to output FIFO             (Module output)

wire          FormFifoFull;
// FIFO FULL status                              (Module output)

wire [7:0]    STNDoutInt;
// D-input of Fifo read data register



// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg [7:0]     STNDout;
// FIFO read data out                            (Module output)

reg   [2:0]   R;
// Red shift register 

reg   [2:0]   G;
// Green shift register

reg   [2:0]   B;              
// Blue shift register

reg   [2:0]  FormState;      
// Formatter State register

reg   [2:0]  NextFormState;  
// D-input of Formatter State register

reg   [7:0]  FormMux;        
// Formatter MUX 

reg          FifoWrite;                        
// Output FIFO Write enable  

reg          NextFifoWrite;   
// D-input of Output FIFO Write enable

reg   [2:0]  NextR;          
// D-input of Red shift register output

reg   [2:0]  NextG;          
// D-input of Green shift register output

reg   [2:0]  NextB;          
// D-input of Blue shift register output

reg           PrevPixblue;    
// D-input of Blue pixel flip-flop

reg [1:0]     Rp;
// Fifo Read pointer

reg [1:0]     NextRp;
// D-input for Fifo Read pointer

reg [1:0]     Wp;
// Fifo Write pointer

reg [1:0]     NextWp;
// D-input for Fifo Write pointer

reg [1:0]     Fillevel;
// number of entries in Fifo

reg [1:0]     NextFillevel;
// D-input for Fillevel register 

reg [7:0]     FifoReg0;
// Fifo register0

reg [7:0]     FifoReg1;
// Fifo register1

reg [7:0]     FifoReg2;
// Fifo register2

reg [7:0]     NextFifoReg0;
// D-input for FifoReg0

reg [7:0]     NextFifoReg1;
// D-input for FifoReg1

reg [7:0]     NextFifoReg2;
// D-input for FifoReg2

reg           NextPrevPixblue;
// D-input of PrevPixBlue register

// -----------------------------------------------------------------------------
// Function to increment the read and write pointers of the FIFO.
// When this function is invoked; the pointer is reset to "00"if it is
// equal to "2'b10" else it is incremented by "2'b01"
// -----------------------------------------------------------------------------
function  [1:0]  IncPointer;
input  [1:0]  pointer;
begin
  if (pointer == 2'b10)
    IncPointer = 2'b00;
  else
    IncPointer = pointer + 2'b01;
end
endfunction

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Combinational logic to enable shift register.
// Shifting is enanbled only when the PixelEn signal is sampled HIGH.Otherwise
// it is forced to latch the previous data.
// in Mono mode, the R,G and B shift registers are effectively cascaded to form
// a 9-bit shift register.
// -----------------------------------------------------------------------------
always @(B or G or R or RGS or GGS or BGS or LcdBW or PixelEn or LcdTFT)
begin : p_ShiftRegComb
  if ((PixelEn == 1'b1) && (LcdTFT == 1'b0))
    begin
      NextR[2:0] = {R[1],R[0],RGS};
      if (LcdBW == 1'b1)
        begin 
          NextG[2:0] = {G[1],G[0],R[2]};
          NextB[2:0] = {B[1],B[0],G[2]};
        end  
      else
        begin
          NextG[2:0] = {G[1],G[0],GGS};
          NextB[2:0] = {B[1],B[0],BGS};
        end
    end 
  else
    begin
      NextR[2:0] = R[2:0];
      NextG[2:0] = G[2:0];
      NextB[2:0] = B[2:0];
    end
end // p_ShiftRegComb
  
// -----------------------------------------------------------------------------
// Sequential logic of 3-bit shift-left register
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_ShiftRegSeq 
  if (nCLCLKRESET == 1'b0)
    begin
      R[2:0] <= 3'b000;
      G[2:0] <= 3'b000;
      B[2:0] <= 3'b000;
    end
  else
    begin
      R[2:0] <= NextR[2:0];
      G[2:0] <= NextG[2:0];
      B[2:0] <= NextB[2:0];
    end
end // p_ShiftRegSeq
      
// -----------------------------------------------------------------------------
// The combinational logic to count the formatter state and to generate the 
// FifoWr signal.
//  - In Colour STN mode FifoWr signal is generated whenever an 8 bit data
//    is formed.
//  - In Mono STN 4 bit Interface mode FifoWrite signal is generated whenever 
//    a 4-bit data is formed.
//  - In Mono STN 8 bit Interface mode FifoWrite signal is generated whenever
//    an 8 bit data is formed.
// -----------------------------------------------------------------------------
always @(LcdBW or FormState or Mono8Bit or PixelEn or LcdTFT or AhbMBESyncLclk)
begin : p_FormStComb      
  if (AhbMBESyncLclk == 1'b1)
    begin
      NextFormState = 3'b000;
      NextFifoWrite = 1'b0;
    end
  else if ((PixelEn == 1'b1) && (LcdTFT == 1'b0))
    begin
      if (((LcdBW == 1'b1) && (Mono8Bit == 1'b0) && (FormState == 3'b011))
         || ((LcdBW == 1'b1) && (FormState == 3'b111)) ||
         ((LcdBW == 1'b0) && ((FormState == 3'b010) || 
         (FormState == 3'b101) || (FormState == 3'b111))))
        NextFifoWrite = 1'b1;
      else
        NextFifoWrite = 1'b0;

      if (FormState == 3'b111)
        NextFormState = 3'b000;
      else
        NextFormState = FormState + 3'b001;
    end 
  else
    begin
      NextFormState = FormState;        
      NextFifoWrite = 1'b0;
    end 
end // p_FormStComb

// ---------------------------------------------------------------------------- 
//  MUX loigc to pick data out of the shift register.
//  - In Mono 4 bit interface mode lower 4 bits are used to drive the data and 
//    the data is arranged in big-endian format
//     FormMux[3:0] = {Pixel1,Pixel2,Pixel3,Pixel4} etc..
//  - In Mono 8 bit interface mode lower 8 bits are used to drive the data and 
//    the data is arranged in big-endian format
//    FormMux[7:0] = {Pixel1,Pixel2,Pixel3,Pixel4,Pixel5,Pixel6,Pixel7,Pixel8}
//  - In Colour mode lower 8 bits are used to drive the data and the data is 
//    arranged in big-endian format
//      FormMux[7:0] = {R1,G1,B1,R2,G2,B2,R3,G3}
//      FormMux[7:0] = {B3,R4,G4,B4,R5,G5,B5,R6} etc..
//    Note: Pixel1 refers to the first pixel and pixel4 refers to the 4th pixel
//          on the LCD screen
// ----------------------------------------------------------------------------

always @(LcdBW or R or G or B or PrevPixblue or FormState) 
begin : p_FormuxComb
  if (LcdBW == 1'b1)  
    FormMux[7:0]   = {B[1] , B[0] , G[2] , G[1] , G[0] , R[2] , R[1] , R[0]};
  else
    case (FormState[2:0])
      3'b011 :
        FormMux[7:0] = {R[2], G[2], B[2], R[1], G[1], B[1], R[0], G[0]};
      3'b110 :
        FormMux[7:0] = {PrevPixblue, R[2], G[2], B[2], R[1], G[1], B[1], R[0]};
      3'b000 :
        FormMux[7:0] = {G[2],B[2], R[1], G[1], B[1], R[0], G[0], B[0]};
      default:
        FormMux[7:0] = 8'h00;
    endcase
end // p_FormuxComb

// ----------------------------------------------------------------------------
// In Colour STN mode latch Blue pixel(B0) when the formatter state = "010"
// this is used to form the next 8-bit data . Otherwise this pixel will
// be lost when the new pixel comes.
// ----------------------------------------------------------------------------
always @(FormState or PrevPixblue or B)
begin : p_PrPixBComb
  if (FormState == 3'b011)
    NextPrevPixblue = B[0];
  else
    NextPrevPixblue = PrevPixblue;
end // p_PrPixBComb

//-----------------------------------------------------------------------------
// Sequential process for PrevPixBlue signal
//-----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_PrPixBSeq
  if(nCLCLKRESET == 1'b0)
    PrevPixblue <= 1'b0;
  else
    PrevPixblue <= NextPrevPixblue;
end // p_PrPixBSeq

//-----------------------------------------------------------------------------
// Sequential process for Formstate and FifoWrite signal
//-----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET) 
begin : p_FormStateSeq
  if (nCLCLKRESET == 1'b0)
    begin
      FormState <= 3'b000;
      FifoWrite <= 1'b0;
    end
  else
    begin
      FormState <= NextFormState;
      FifoWrite <= NextFifoWrite;
    end
end // p_FormStateSeq

//-----------------------------------------------------------------------------
// Force upper nibble to zero if the mode is Mono 4-bit 
//-----------------------------------------------------------------------------
assign FormData[7:0] = ((LcdBW == 1'b1) && (Mono8Bit == 1'b0)) ?
                       {4'b0000,FormMux[3:0]} : FormMux[7:0];

// ----------------------------------------------------------------------------
// FIFO Read pointer and write pointer control logic
// ----------------------------------------------------------------------------
always @(Wp or Rp or Fillevel or FifoWrite or FifoRead or LcdTFT or
         AhbMBESyncLclk)
begin : p_FifoComb
  NextWp = Wp;
  NextRp = Rp;
  NextFillevel = Fillevel;
// ----------------------------------------------------------------------------
// if AHB master error interrupt is set clear the write/read pointers and fill
// level.
// ----------------------------------------------------------------------------
  if (AhbMBESyncLclk == 1'b1)
    begin
      NextWp = 2'b00;
      NextRp = 2'b00;
      NextFillevel = 2'b00;
    end
  else
    begin
// ----------------------------------------------------------------------------
// if WriteFifo signal is sampled HIGH Write data in to the register array and
// increment the write pointer
// ----------------------------------------------------------------------------
      if (FifoWrite == 1'b1)
        NextWp =  IncPointer(Wp);
// ----------------------------------------------------------------------------
// if the FifoRead signal is sampled HIGH,increment the read pointer
// ----------------------------------------------------------------------------
      if ((FifoRead == 1'b1) && (LcdTFT == 1'b0))
        NextRp =  IncPointer(Rp);
// ----------------------------------------------------------------------------
// Number of words and under/overflow logic
// on FIFO read, decrement the words by "1", On FIFO write increment the words
// by "1". When both the signals are sampled HIGH at the same time,
// do not change the words.
// ----------------------------------------------------------------------------
    if ((FifoRead == 1'b1) && (LcdTFT == 1'b0) && (FifoWrite == 1'b0))
      begin
        if (Fillevel == 2'b00)
          NextFillevel = Fillevel;
        else
          NextFillevel =  Fillevel - 2'b01;
      end
    else
      begin
        if ((FifoWrite == 1'b1) && (FifoRead == 1'b0))
          begin
            if (Fillevel == 2'b11)
              NextFillevel = Fillevel;
            else
              NextFillevel =  Fillevel + 2'b01;
          end
      end
    end
end // p_FifoComb

// ----------------------------------------------------------------------------
// Sequential process for FIFO read and write pointers
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_FifoSeq
  if (nCLCLKRESET == 1'b0)
    begin
      Wp       <=   2'b00;
      Rp       <=   2'b00;
      Fillevel <=   2'b00;
    end
  else
    begin
      Wp       <=   NextWp;
      Rp       <=   NextRp;
      Fillevel <=   NextFillevel;
    end
end // p_FifoSeq

//------------------------------------------------------------------------------
// Whenever FifoWrite signal is sampled HIGH on any rising edge of Clcdclk,latch
// the WrData in to the FIFO element pointed by the WrAddr
// -----------------------------------------------------------------------------
always @ (FifoWrite or Wp or FifoReg0 or FifoReg1 or FifoReg2 or FormData)
begin : p_FRegWrComb
  NextFifoReg0  = FifoReg0;
  NextFifoReg1  = FifoReg1;
  NextFifoReg2  = FifoReg2;

  if (FifoWrite == 1'b1)
    case (Wp)
      2'b00 : NextFifoReg0 = FormData;
      2'b01 : NextFifoReg1 = FormData;
      2'b10 : NextFifoReg2 = FormData;
      default : ;
    endcase
end // p_FRegWrComb

// -----------------------------------------------------------------------------
// Sequential logic for the Fifo register
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_FRegWrSeq 
  if (nCLCLKRESET == 1'b0)
    begin
      FifoReg0 <= 8'b0;
      FifoReg1 <= 8'b0;
      FifoReg2 <= 8'b0;
    end
  else
    begin
      FifoReg0 <= NextFifoReg0;
      FifoReg1 <= NextFifoReg1;
      FifoReg2 <= NextFifoReg2;
    end
end // p_FRegWrSeq
 
// ----------------------------------------------------------------------------
// Output the data from the current read pointer location
// ----------------------------------------------------------------------------
assign STNDoutInt[7:0] = (Rp == 2'b00) ? FifoReg0[7:0]
                       : (Rp == 2'b01) ? FifoReg1[7:0]
                       : (Rp == 2'b10) ? FifoReg2[7:0]
                       : 8'b0;
 
// ----------------------------------------------------------------------------
// FIFO full flag generation. Asserted when the number of words = "3" or when
// the number of words = "2" and Fifo write is sampled HIGH, Fifo Read is
// sampled LOW.
// ----------------------------------------------------------------------------
assign FormFifoFull = ((Fillevel == 2'b11) || ((Fillevel == 2'b10) 
                   && (FifoWrite == 1'b1 || NextFifoWrite == 1'b1) 
                   && (FifoRead == 1'b0))) ? 1'b1 : 1'b0;
 
// ----------------------------------------------------------------------------
// Sequential process for Lcd panel data
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_STNDSeq
  if (nCLCLKRESET == 1'b0)
    STNDout[7:0] <= 8'b0;
  else
    STNDout[7:0] <= STNDoutInt[7:0];
end // p_STNDSeq

// ----------------------------------------------------------------------------
// Formatter FIFO under run and overflow error indication.
// ----------------------------------------------------------------------------
// synopsys translate_off

always @(posedge CLCDCLK)
begin : p_FifoErdisSeq
  if ((FifoRead == 1'b1) && (LcdTFT == 1'b0) && (FifoWrite == 1'b0)
      && (Fillevel == 2'b00))
    $display("LCD Formatter FIFO under-run at time %t", $time);

  else if ((FifoWrite == 1'b1) && (FifoRead == 1'b0) && (Fillevel == 2'b11))
   $display("LCD Formatter FIFO overflow at time %t", $time);
end // p_FifoErdisSeq

// synopsys translate_on

endmodule

// --================================== End ==================================--

