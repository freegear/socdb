//  ----------------------------------------------------------------------------
//  This confidential & proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 1998 ARM Limited
//  ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  & copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version & Release Control Information :
//
//
//  Filename            : KmiTrRXFIFO.v,v
//
//  File Revision       : 1.1
//
//  Release Information : PL050-REL1v1
//
//  ----------------------------------------------------------------------------
// Purpose : This block provides the Storage for the recieved Data.
//
// ----------------------------------------------------------------------------

`timescale 1ns/1ps

// ----------------------------------------------------------------------------

module KmiTrRXFIFO (
                    PCLK,
                    BnRES,
                    Write,
                    Read,
                    DataIn,
                    Ffull,
                    Fempty,
                    Fhalfmore,
                    DataOut   
                   );

input        PCLK;      // Clock
input        BnRES;     // Reset 
input        Write;     // FIFO Write enable
input        Read;      // FIFO Read  enable
input [7:0]  DataIn;    // Data bus
output       Ffull;     // FIFO Full
output       Fempty;    // FIFO Empty
output       Fhalfmore; // FIFO more than half filled
output [7:0] DataOut;   // Output Data

// ----------------------------------------------------------------------------
//
//                        KmiTrRXFIFO
//                        ===========
//
// ----------------------------------------------------------------------------
//
// Overview
// ========
// This modules stores the received data in the Fifo. Whenever Read signal is 
// asserted, Next Data stored in FIFO is being routed to the Output Data Bus. 
// This fifo is 32 word deep. This module also generates various flags to 
// indicate the current status of fifo. There are two internal pointers,
// pointing to current read & write locations. Based on the position of 
// these pointers, fifo flags are being asserted & cleared. 
//
// ----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// wire declarations
// -----------------------------------------------------------------------------
wire [5:0] FillLvl;
// Fill Level Indicator

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg [7:0] RegFile0;
// Fifo Register0

reg [7:0] NextRegFile0;
// D-Input of RegFile0
 
reg [7:0] RegFile1;
// Fifo Register1

reg [7:0] NextRegFile1;
// D-Input of RegFile1
 
reg [7:0] RegFile2;
// Fifo Register2

reg [7:0] NextRegFile2;
// D-Input of RegFile2
 
reg [7:0] RegFile3;
// Fifo Register3

reg [7:0] NextRegFile3;
// D-Input of RegFile3
 
reg [7:0] RegFile4;
// Fifo Register4

reg [7:0] NextRegFile4;
// D-Input of RegFile4
 
reg [7:0] RegFile5;
// Fifo Register5

reg [7:0] NextRegFile5;
// D-Input of RegFile5
 
reg [7:0] RegFile6;
// Fifo Register6

reg [7:0] NextRegFile6;
// D-Input of RegFile6
 
reg [7:0] RegFile7;
// Fifo Register7

reg [7:0] NextRegFile7;
// D-Input of RegFile7
 
reg [7:0] RegFile8;
// Fifo Register8

reg [7:0] NextRegFile8;
// D-Input of RegFile8
 
reg [7:0] RegFile9;
// Fifo Register9

reg [7:0] NextRegFile9;
// D-Input of RegFile9
 
reg [7:0] RegFile10;
// Fifo Register10

reg [7:0] NextRegFile10;
// D-Input of RegFile10
 
reg [7:0] RegFile11;
// Fifo Register11

reg [7:0] NextRegFile11;
// D-Input of RegFile11
 
reg [7:0] RegFile12;
// Fifo Register12

reg [7:0] NextRegFile12;
// D-Input of RegFile12
 
reg [7:0] RegFile13;
// Fifo Register13

reg [7:0] NextRegFile13;
// D-Input of RegFile13
 
reg [7:0] RegFile14;
// Fifo Register14

reg [7:0] NextRegFile14;
// D-Input of RegFile14
 
reg [7:0] RegFile15;
// Fifo Register15

reg [7:0] NextRegFile15;
// D-Input of RegFile15
 
reg [7:0] RegFile16;
// Fifo Register16

reg [7:0] NextRegFile16;
// D-Input of RegFile16
 
reg [7:0] RegFile17;
// Fifo Register17

reg [7:0] NextRegFile17;
// D-Input of RegFile17
 
reg [7:0] RegFile18;
// Fifo Register18

reg [7:0] NextRegFile18;
// D-Input of RegFile18
 
reg [7:0] RegFile19;
// Fifo Register19

reg [7:0] NextRegFile19;
// D-Input of RegFile19
 
reg [7:0] RegFile20;
// Fifo Register20

reg [7:0] NextRegFile20;
// D-Input of RegFile20
 
reg [7:0] RegFile21;
// Fifo Register21

reg [7:0] NextRegFile21;
// D-Input of RegFile21
 
reg [7:0] RegFile22;
// Fifo Register22

reg [7:0] NextRegFile22;
// D-Input of RegFile22
 
reg [7:0] RegFile23;
// Fifo Register23

reg [7:0] NextRegFile23;
// D-Input of RegFile23
 
reg [7:0] RegFile24;
// Fifo Register24

reg [7:0] NextRegFile24;
// D-Input of RegFile24
 
reg [7:0] RegFile25;
// Fifo Register25

reg [7:0] NextRegFile25;
// D-Input of RegFile25
 
reg [7:0] RegFile26;
// Fifo Register26

reg [7:0] NextRegFile26;
// D-Input of RegFile26
 
reg [7:0] RegFile27;
// Fifo Register27

reg [7:0] NextRegFile27;
// D-Input of RegFile27
 
reg [7:0] RegFile28;
// Fifo Register28

reg [7:0] NextRegFile28;
// D-Input of RegFile28
 
reg [7:0] RegFile29;
// Fifo Register29

reg [7:0] NextRegFile29;
// D-Input of RegFile29
 
reg [7:0] RegFile30;
// Fifo Register30

reg [7:0] NextRegFile30;
// D-Input of RegFile30
 
reg [7:0] RegFile31;
// Fifo Register31

reg [7:0] NextRegFile31;
// D-Input of RegFile31
 
reg [4:0] PtrWr;
// Pointer to write
 
reg [4:0] NextPtrWr;
// D-Input of PtrWr

reg [4:0] PtrRd;
// Pointer to read
 
reg [4:0] NextPtrRd;
// D-Input of PtrRd

reg NextFfull;
// Fifo Full Indicator
 
reg Ffull;
// Fifo Full Indicator

reg Fempty;
// Fifo Empty Indicator
 
reg NextFempty;
// Fifo Empty Indicator

reg Fhalfmore;
// Fifo more than half filled
 
reg NextFhalfmore;
// Fifo more than half filled

reg [7:0] DataOut;
// Data Output

reg [7:0] NextDataOut;
// D-Input of DataOut

reg Wrap;  
// Wrap bit
 
reg NextWrap;  
// D-Input of Wrap

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------
 


// ----------------------------------------------------------------------------
// This process initializes different signals used in this module. It also
// updates the signals at positive edge of PCLK.
// ----------------------------------------------------------------------------
always @ (BnRES or posedge PCLK) 
begin : p_ResSeq
  if (BnRES == 1'b0) 
  begin
    Fempty    = 1'b1;
    Ffull     = 1'b0;
    Fhalfmore = 1'b0;
    Wrap      = 1'b0;
    PtrWr     = 5'b00000;
    PtrRd     = 5'b00000;
    DataOut   = 8'b00000000;
    RegFile0  = 8'b00000000;
    RegFile1  = 8'b00000000;
    RegFile2  = 8'b00000000;
    RegFile3  = 8'b00000000;
    RegFile4  = 8'b00000000;
    RegFile5  = 8'b00000000;
    RegFile6  = 8'b00000000;
    RegFile7  = 8'b00000000;
    RegFile8  = 8'b00000000;
    RegFile9  = 8'b00000000;
    RegFile10 = 8'b00000000;
    RegFile11 = 8'b00000000;
    RegFile12 = 8'b00000000;
    RegFile13 = 8'b00000000;
    RegFile14 = 8'b00000000;
    RegFile15 = 8'b00000000;
    RegFile16 = 8'b00000000;
    RegFile17 = 8'b00000000;
    RegFile18 = 8'b00000000;
    RegFile19 = 8'b00000000;
    RegFile20 = 8'b00000000;
    RegFile21 = 8'b00000000;
    RegFile22 = 8'b00000000;
    RegFile23 = 8'b00000000;
    RegFile24 = 8'b00000000;
    RegFile25 = 8'b00000000;
    RegFile26 = 8'b00000000;
    RegFile27 = 8'b00000000;
    RegFile28 = 8'b00000000;
    RegFile29 = 8'b00000000;
    RegFile30 = 8'b00000000;
    RegFile31 = 8'b00000000;
  end 
  else
  begin
    Fempty    = NextFempty;
    Ffull     = NextFfull;
    Fhalfmore = NextFhalfmore;
    Wrap      = NextWrap;
    PtrWr     = NextPtrWr;
    PtrRd     = NextPtrRd;
    DataOut   = NextDataOut;
    RegFile0  = NextRegFile0;
    RegFile1  = NextRegFile1;
    RegFile2  = NextRegFile2;
    RegFile3  = NextRegFile3;
    RegFile4  = NextRegFile4;
    RegFile5  = NextRegFile5;
    RegFile6  = NextRegFile6;
    RegFile7  = NextRegFile7;
    RegFile8  = NextRegFile8;
    RegFile9  = NextRegFile9;
    RegFile10 = NextRegFile10;
    RegFile11 = NextRegFile11;
    RegFile12 = NextRegFile12;
    RegFile13 = NextRegFile13;
    RegFile14 = NextRegFile14;
    RegFile15 = NextRegFile15;
    RegFile16 = NextRegFile16;
    RegFile17 = NextRegFile17;
    RegFile18 = NextRegFile18;
    RegFile19 = NextRegFile19;
    RegFile20 = NextRegFile20;
    RegFile21 = NextRegFile21;
    RegFile22 = NextRegFile22;
    RegFile23 = NextRegFile23;
    RegFile24 = NextRegFile24;
    RegFile25 = NextRegFile25;
    RegFile26 = NextRegFile26;
    RegFile27 = NextRegFile27;
    RegFile28 = NextRegFile28;
    RegFile29 = NextRegFile29;
    RegFile30 = NextRegFile30;
    RegFile31 = NextRegFile31;
  end  
end  // p_ResSeq;
 
// ----------------------------------------------------------------------------
// PtrWr is being updated at every Write.
// ----------------------------------------------------------------------------
always @ (Write or PtrWr)
begin : p_PtrWrComb  
  if (Write == 1'b1) 
    NextPtrWr = PtrWr + 1;
  else 
    NextPtrWr = PtrWr; 
end  // p_PtrWrComb;

// ----------------------------------------------------------------------------
// PtrRd is being updated at every Read.
// ----------------------------------------------------------------------------
always @ (Read or PtrRd)
begin : p_PtrRdComb
  if ((Read == 1'b1) & (FillLvl != 000000)) 
     NextPtrRd = PtrRd + 1;
  else 
     NextPtrRd = PtrRd; 
end  // p_PtrRdComb;

// ----------------------------------------------------------------------------
// Wrap update
// ----------------------------------------------------------------------------
always @ (PtrWr or PtrRd or Wrap or Write or Read)
begin : p_WrapComb
  if (((PtrWr == 11111) & (Write == 1'b1)) ^
      ((PtrRd == 11111) & (Read == 1'b1))) 
    NextWrap =  ~(Wrap);
  else 
    NextWrap = Wrap; 
end  // p_WrapComb;

assign FillLvl = {Wrap, PtrWr} - {1'b0, PtrRd}; 

// ----------------------------------------------------------------------------
// Fempty is being asserted ever FillLvl reaches to zero.
// ----------------------------------------------------------------------------
always @ (FillLvl)
begin : p_FemptyComb
  if (FillLvl == 000000) 
    NextFempty = 1'b1;
  else
    NextFempty = 1'b0;
end  // p_FemptyComb;

// ----------------------------------------------------------------------------
// Ffull is being asserted ever FillLvl reaches to 31.
// ----------------------------------------------------------------------------
always @ (FillLvl)
begin : p_FfullComb
  if (FillLvl == 011111) 
    NextFfull = 1'b1;
  else
    NextFfull = 1'b0;
end  // p_FfullComb;

// ----------------------------------------------------------------------------
// Fhalfmore is being asserted ever FillLvl greater  15.
// ----------------------------------------------------------------------------
always @ (FillLvl)
begin : p_FhalfmoreComb
  if (FillLvl > 001111) 
    NextFhalfmore  = 1'b1;
  else
    NextFhalfmore  = 1'b0;
end  // p_FhalfmoreComb;

// ----------------------------------------------------------------------------
// Write to Register Array
// ----------------------------------------------------------------------------
always @ (PtrWr or DataIn or Write or RegFile0 or RegFile1 or RegFile2 or 
          RegFile3 or RegFile4 or RegFile5 or RegFile6 or RegFile7 or 
          RegFile8 or RegFile9 or RegFile10 or RegFile11 or RegFile12 or 
          RegFile13 or RegFile14 or RegFile15 or RegFile16 or RegFile17 or 
          RegFile18 or RegFile19 or RegFile20 or RegFile21 or RegFile22 or
          RegFile23 or RegFile24 or RegFile25 or RegFile26 or RegFile27 or
          RegFile28 or RegFile29 or RegFile30 or RegFile31)
begin : p_RegFileComb 

NextRegFile0  = RegFile0;
NextRegFile1  = RegFile1;
NextRegFile2  = RegFile2;
NextRegFile3  = RegFile3;
NextRegFile4  = RegFile4;
NextRegFile5  = RegFile5;
NextRegFile6  = RegFile6;
NextRegFile7  = RegFile7;
NextRegFile8  = RegFile8;
NextRegFile9  = RegFile9;
NextRegFile10 = RegFile10;
NextRegFile11 = RegFile11;
NextRegFile12 = RegFile12;
NextRegFile13 = RegFile13;
NextRegFile14 = RegFile14;
NextRegFile15 = RegFile15;
NextRegFile16 = RegFile16;
NextRegFile17 = RegFile17;
NextRegFile18 = RegFile18;
NextRegFile19 = RegFile19;
NextRegFile20 = RegFile20;
NextRegFile21 = RegFile21;
NextRegFile22 = RegFile22;
NextRegFile23 = RegFile23;
NextRegFile24 = RegFile24;
NextRegFile25 = RegFile25;
NextRegFile26 = RegFile26;
NextRegFile27 = RegFile27;
NextRegFile28 = RegFile28;
NextRegFile29 = RegFile29;
NextRegFile30 = RegFile30;
NextRegFile31 = RegFile31;
if (Write == 1'b1) 
  case (PtrWr)
     5'b00000 :
       NextRegFile0   = DataIn;

     5'b00001 :
       NextRegFile1   = DataIn;

     5'b00010 :
       NextRegFile2   = DataIn;

     5'b00011 :
       NextRegFile3   = DataIn;

     5'b00100 :
       NextRegFile4   = DataIn;

     5'b00101 :
       NextRegFile5   = DataIn;

     5'b00110 :
       NextRegFile6   = DataIn;

     5'b00111 :
       NextRegFile7   = DataIn;

     5'b01000 :
       NextRegFile8   = DataIn;

     5'b01001 :
       NextRegFile9   = DataIn;

     5'b01010 :
       NextRegFile10  = DataIn;

     5'b01011 :
       NextRegFile11  = DataIn;

     5'b01100 :
       NextRegFile12  = DataIn;

     5'b01101 :
       NextRegFile13  = DataIn;

     5'b01110 :
       NextRegFile14  = DataIn;

     5'b01111 :
       NextRegFile15  = DataIn;

     5'b10000 :
       NextRegFile16  = DataIn;

     5'b10001 :
       NextRegFile17  = DataIn;

     5'b10010 :
       NextRegFile18  = DataIn;

     5'b10011 :
       NextRegFile19  = DataIn;

     5'b10100 :
       NextRegFile20  = DataIn;

     5'b10101 :
       NextRegFile21  = DataIn;

     5'b10110 :
       NextRegFile22  = DataIn;

     5'b10111 :
       NextRegFile23  = DataIn;

     5'b11000 :
       NextRegFile24  = DataIn;

     5'b11001 :
       NextRegFile25  = DataIn;

     5'b11010 :
       NextRegFile26  = DataIn;

     5'b11011 :
       NextRegFile27  = DataIn;

     5'b11100 :
       NextRegFile28  = DataIn;

     5'b11101 :
       NextRegFile29  = DataIn;

     5'b11110 :
       NextRegFile30  = DataIn;

     5'b11111 :
       NextRegFile31  = DataIn;
  endcase
end  // p_RegFileComb;

// ----------------------------------------------------------------------------
// Output Data is updated.
// ----------------------------------------------------------------------------
always @ (PtrRd or RegFile0 or RegFile1 or RegFile2 or RegFile3 or 
          RegFile4 or RegFile5 or RegFile6 or RegFile7 or RegFile8 or 
          RegFile9 or RegFile10 or RegFile11 or RegFile12 or RegFile13 or
          RegFile14 or RegFile15 or RegFile16 or RegFile17 or RegFile18 or
          RegFile19 or RegFile20 or RegFile21 or RegFile22 or RegFile23 or
          RegFile24 or RegFile25 or RegFile26 or RegFile27 or RegFile28 or
          RegFile29 or RegFile30 or RegFile31)

begin : p_DataOutComb 
  case (PtrRd) 
     5'b00000 : 
      NextDataOut = RegFile0;
 
     5'b00001 : 
      NextDataOut = RegFile1;

     5'b00010 : 
      NextDataOut = RegFile2;

     5'b00011 : 
      NextDataOut = RegFile3;

     5'b00100 : 
      NextDataOut = RegFile4;

     5'b00101 : 
      NextDataOut = RegFile5;

     5'b00110 : 
      NextDataOut = RegFile6;

     5'b00111 : 
      NextDataOut = RegFile7;

     5'b01000 : 
      NextDataOut = RegFile8;

     5'b01001 : 
      NextDataOut = RegFile9;

     5'b01010 : 
      NextDataOut = RegFile10;

     5'b01011 : 
      NextDataOut = RegFile11;

     5'b01100 : 
      NextDataOut = RegFile12;

     5'b01101 : 
      NextDataOut = RegFile13;

     5'b01110 : 
      NextDataOut = RegFile14;

     5'b01111 : 
      NextDataOut = RegFile15;

     5'b10000 : 
      NextDataOut = RegFile16;

     5'b10001 : 
      NextDataOut = RegFile17;

     5'b10010 : 
      NextDataOut = RegFile18;

     5'b10011 : 
      NextDataOut = RegFile19;

     5'b10100 : 
      NextDataOut = RegFile20;

     5'b10101 : 
      NextDataOut = RegFile21;

     5'b10110 : 
      NextDataOut = RegFile22;

     5'b10111 : 
      NextDataOut = RegFile23;

     5'b11000 : 
      NextDataOut = RegFile24;

     5'b11001 : 
      NextDataOut = RegFile25;

     5'b11010 : 
      NextDataOut = RegFile26;

     5'b11011 : 
      NextDataOut = RegFile27;

     5'b11100 : 
      NextDataOut = RegFile28;

     5'b11101 : 
      NextDataOut = RegFile29;

     5'b11110 : 
      NextDataOut = RegFile30;

     5'b11111 : 
      NextDataOut = RegFile31;
 endcase
end  // p_DataOutComb; 

endmodule

//====================== End of KmiTrRXFIFO ==================================
