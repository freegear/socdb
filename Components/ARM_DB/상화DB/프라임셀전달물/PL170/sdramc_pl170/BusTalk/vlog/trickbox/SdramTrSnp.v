//  ---------------------------------------------------------------------------
//  This confidential and proprietary software may be used only as 
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : $RCS: $
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL170-REL2v2
//
//  ----------------------------------------------------------------------------
//
//  ----------------------------------------------------------------------------
//  Purpose                : Module to "log" commands issued by the controller
//                           to the SDRAM devices 
//  ----------------------------------------------------------------------------

`timescale 1ns/1ps

module SdramTrSnp (
                     HCLK,
                     nReset,
                     FifoIn,
                     ChipSelect,
                     FifoClear,
                     FifoEn,
                     ReadEn,
                     ModeBit,
                     SupREFBit,
                     SupALL,
                     FifoOut
                  );
 
`define FIFO_DEPTH  128
`define MAXADDR  7 

parameter DISPLAY_ENABLE = 0; 
// parameter to display the commands.
 
input         HCLK;            // AHB Clock Input
input         nReset;          // Trickbox Reset input
input         FifoClear;       // FIFO clear pulse
input         FifoEn;          // FIFO Enable Signal
input         ReadEn;          // FIFO Read Signal
input         ModeBit;         // Mode Select Signal
input         SupREFBit;       // Disables the storing of REF command
input         SupALL;          // Disables the storing of All commands
                               //   except READ and WRITE
input   [3:0] ChipSelect;      // Chip Select Input
input  [16:0] FifoIn ;         // FIFO Input
output [31:0] FifoOut;         // FIFO Output

// ----------------------------------------------------------------------------
//
//                              SdramTrSnp 
//                              ===========
//
// ----------------------------------------------------------------------------
// Overview
// ========
// 
// This module "snoops" the SDRAM bus and stores the command encoding and
// the access address in a FIFO. This FIFO may be read or cleared under 
// program control. 
//
// ----------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------------
wire        FifoData18;
wire        FifoData19;
wire        FifoData20;
wire        FifoData21;
wire [31:0] FifoDataWrtPtr;
wire        DevSel;

wire        SupREFBit;     
wire        SupALL;     
// ---------------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------------
reg            [31:0] FifoOut; 
// Output from the FIFO

reg            [31:0] FifoData [`FIFO_DEPTH-1:0] ;
// Array of 32 bit FIFO datas

reg            [31:0] ShiftFifoData [`FIFO_DEPTH-1:0]; 
// D - input to FIFO datas

reg            [31:0] NextFifoData;
// 32 bit FIFO Word. It is this Word which is stored into the current location 
// of the ShiftFifoData array

reg            [31:0] NextFifoOut;
// D - Input to FifoOut

reg            [31:0] TempFifoData;
// Temporary 32 bit Fifo data. This is used for clearing the last bit of 
// ShiftFifodata

reg                   SnoopEn ;
// This bit decides whether the data needs to be loged into the FIFO

reg  [`MAXADDR - 1:0] WritePntr;
// The current location of the FIFO into which the data needs to be loged

reg  [`MAXADDR - 1:0] NextWritePntr;
// D - Input the WritePntr

reg           [8*5:1] CMDstr;        
// To display the commands

reg            [13:0] ADDstr;        
// To display the address

integer      i;
       
// ----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// ----------------------------------------------------------------------------

assign DevSel = ~(ChipSelect[3] & ChipSelect[2] & 
                  ChipSelect[1] & ChipSelect[0]);
	
assign FifoData18 = FifoData[18];
assign FifoData19 = FifoData[19];
assign FifoData20 = FifoData[20];
assign FifoData21 = FifoData[21];

assign FifoDataWrtPtr = FifoData[WritePntr];

//-----------------------------------------------------------------------------
//   Combinational block which checks for a Snoop Enable condition and does
//   the encoding of the FIFO data to a 32 bit register NextFifoData.
//-----------------------------------------------------------------------------
always @(FifoIn or FifoEn or FifoDataWrtPtr or ChipSelect or SnoopEn or 
         WritePntr or DevSel or SupREFBit or SupALL or ModeBit)
begin : p_EncodeComb
  NextFifoData  = 0; 
  SnoopEn       = 0;

  if(FifoEn)
  begin

//-----------------------------------------------------------------------------
//  Command Field - 3 bits
//-----------------------------------------------------------------------------
    if ( DevSel && ~FifoIn[16] && ~FifoIn[15] && FifoIn[14] && ~SupREFBit 
         && ~SupALL )
    begin 
      NextFifoData [31:29] = 3'b111;         // REF
      SnoopEn              = 1;	 
    end

    if (DevSel && FifoIn[16] && FifoIn[15] && ~FifoIn[14] && FifoIn[10] && 
        ModeBit && ~SupALL)
    begin 
      if (~FifoIn[7] && ~FifoIn[6] && ~FifoIn[5])
      begin
	NextFifoData [31:29] = 3'b110;       // PFCA
        SnoopEn              = 1;
      end
      else if (FifoIn[7])
      begin
        NextFifoData [31:29] = 3'b010;       // RSTA
        SnoopEn              = 1;
      end
    end  
//-----------------------------------------------------------------------------
//  In DRAM mode, (ModeBit = 0),Check for PFCA replaced by PRE
//-----------------------------------------------------------------------------
    if ( DevSel && ~FifoIn[16] && (~ModeBit && FifoIn[15]) && ~FifoIn[14]
          && ~FifoIn[10] && ~SupALL)
    begin 
      NextFifoData [31:29] = 3'b110;         // PRE
      SnoopEn              = 1;           
    end

    if ( DevSel && FifoIn[16] && ~FifoIn[15] && FifoIn[14] )
    begin 
       NextFifoData [31:29] = 3'b101;        // READ	 
       SnoopEn              = 1;
    end 

    if ( DevSel && FifoIn[16] && ~FifoIn[15] && ~FifoIn[14] && 
         ((ModeBit && ~FifoIn[13]) || ~ModeBit))
    begin 
       NextFifoData [31:29] = 3'b100;        // WRITE
       SnoopEn              = 1;	 
    end 

    if ( DevSel && ~FifoIn[16] && FifoIn[15] && FifoIn[14] && ~SupALL )
    begin 
      NextFifoData [31:29] = 3'b011;         // ACT	 
      SnoopEn              = 1;
    end 

    if (DevSel && ~FifoIn[16] && ~FifoIn[15] && ~FifoIn[14] && ~SupALL )
    begin 
      if (~ModeBit)
      begin
        NextFifoData [31:29] = 3'b000;       // SDRAM MODE
        SnoopEn              = 1;
      end 
      else if ( FifoIn[13:5] == 9'h001 )
      begin
        NextFifoData [31:29] = 3'b000;       // SCLR
        SnoopEn              = 1;
      end 
      else if (~FifoIn[8] && ~FifoIn[7] && FifoIn[6] && FifoIn[5] && ~SupALL)
      begin 
        NextFifoData [31:29] = 3'b001;       // SCCR
        SnoopEn              = 1;
      end
    end

//---------------------------------------------------------------------------
//             Device Field - 2 bits
//--------------------------------------------------------------------------- 
    if (SnoopEn)
    begin
      if ( NextFifoData [31:29] == 3'b111 )
      begin
        NextFifoData [28:25] = ChipSelect[3:0];
        NextFifoData [24:13] = FifoIn[13:2];
      end
      else
      begin
        case (ChipSelect)
          4'b1110 : NextFifoData [28:27] = 2'b00;
          4'b1101 : NextFifoData [28:27] = 2'b01;
          4'b1011 : NextFifoData [28:27] = 2'b10;
          4'b0111 : NextFifoData [28:27] = 2'b11;
        endcase 

//------------------------------- -------------------------------------------
//             Bank Field - 1 bits
//--------------------------------------------------------------------------- 
      
        NextFifoData [26] = FifoIn[13];
     
//----------------------------------------------------------------------------
//             Page Field - 13 bits
//---------------------------------------------------------------------------- 

        NextFifoData [25:13] = FifoIn[12:0]; 
      end
//----------------------------------------------------------------------------
//            Channel Fields - 4 bits
//----------------------------------------------------------------------------
 
      if ( NextFifoData [31:29] == 3'b001 )
        NextFifoData [12:9] = FifoIn [12:9];
      else
      begin
        NextFifoData [12:11] = FifoIn [12:11];
        NextFifoData [10:9 ] = FifoIn [9:8];
      end

//-----------------------------------------------------------------------------
//            Segment Field - 2 bits
//-----------------------------------------------------------------------------

      NextFifoData [8:7] = FifoIn [1:0];

//-----------------------------------------------------------------------------
//            Column Field - 6 bits 
//-----------------------------------------------------------------------------

      NextFifoData [6:1] = FifoIn [5:0];

//-----------------------------------------------------------------------------
//             Valid Field - 1 bit
//-----------------------------------------------------------------------------

      NextFifoData [0] = 1;
    end
  end	
end

//-----------------------------------------------------------------------------
// Sequential block in which the data is transfered to FIFO registers at
// the positive edge of the HCLK. 
//-----------------------------------------------------------------------------

always @(posedge HCLK or negedge nReset)
begin : p_ShiftRegSeq
  if (~nReset)
  begin
    WritePntr <= 6'h00;
    FifoOut   <= 32'h00000000;
    for (i = 0; i < `FIFO_DEPTH; i = i + 1)
    begin
      FifoData[i]      <= 32'h00000000;
      ShiftFifoData[i] <= 32'h00000000;
    end
  end 
  else
  begin
    if (DISPLAY_ENABLE)
    begin
      if (CMDstr == "READ" || CMDstr == "WRITE" || CMDstr == "ACT"
          || CMDstr == "PRE" || CMDstr == "PFCA" || CMDstr == "RSTA") 
        $display (" %s at address %h,time = %0d ",CMDstr,ADDstr,$time);
      else
        $display (" %s , %0d ",CMDstr,$time);
    end
    WritePntr <= NextWritePntr ;
    FifoOut   <= NextFifoOut ;
    for (i = 0; i < `FIFO_DEPTH; i = i + 1)
      FifoData[i] <= ShiftFifoData[i];  
  end
end

//-----------------------------------------------------------------------------
// Whenever a Fifo Clear or Snoop Enable or Read Enable comes ,the required 
// changes will be made to ShiftFifoData[i] respectively. The contents of the 
// ShiftFifoData[i] will be moved to the FifoData[i] at the positive edge 
// of the HCLK in the sequential block.
//-----------------------------------------------------------------------------
always @(FifoClear or TempFifoData  or SnoopEn or ReadEn or WritePntr or 
         NextFifoData or FifoData[0] or FifoIn or FifoOut or nReset)
begin
  if (nReset == 1'b0)
    begin
      for (i = 0; i < `FIFO_DEPTH; i = i + 1)
        ShiftFifoData[i]  = 32'h00000000; 
    end
  else if (FifoClear)
  begin
    NextWritePntr = 6'h00; 
    for (i = 0; i < `FIFO_DEPTH; i = i + 1)
    begin
      TempFifoData     = FifoData[i];
      TempFifoData[0]  = 0;
      ShiftFifoData[i] = TempFifoData;
    end 
  end
  else
  begin
//-----------------------------------------------------------------------------
// Moving the encoded data to the WritePntr location of ShiftFifoData, when
// Snoop Enable is set, which will be refreshed to FifoData at posedge of 
// the HCLK.
//-----------------------------------------------------------------------------
    
    if (SnoopEn)
    begin
      NextWritePntr = WritePntr + 1;      
      ShiftFifoData[WritePntr]     = NextFifoData;
    end  
    else
    begin
//-----------------------------------------------------------------------------
// The data in the FIFO register header is transfered to
// NextFifoOut, when Read Enable is set.This information will later be  
// transfered to FifoOut at the positive edge of the HCLK.
//-----------------------------------------------------------------------------

      if (ReadEn)
        begin
          NextFifoOut = FifoData[0];
          NextWritePntr = WritePntr - 1;
          for (i = 0; i < `FIFO_DEPTH-1; i = i + 1)
            ShiftFifoData[i] = FifoData[i + 1];
          ShiftFifoData[`FIFO_DEPTH-1] = 32'h00000000;
        end
      else
      begin
        NextFifoOut = FifoOut;
        NextWritePntr = WritePntr;
        for (i = 0; i < `FIFO_DEPTH; i = i + 1)
          ShiftFifoData[i] = FifoData[i];
      end
    end 
  end
end

//-----------------------------------------------------------------------------
//  To display the commands issued by the SDRAM Control Engine
//-----------------------------------------------------------------------------

always @(FifoIn or FifoEn or FifoData[WritePntr] or ChipSelect or SnoopEn or 
          nReset )
begin
  
  CMDstr        = "NDF";       // Not Defined
  ADDstr        = 14'h0000 ;   

  if ( DevSel && FifoIn[16] && FifoIn[15] && FifoIn[14] )
  begin 
    CMDstr  = "NOP";       // NOP	 
  end
 
  if ( DevSel && ~FifoIn[16] && ~FifoIn[15] && FifoIn[14] )
  begin 
    CMDstr  = "REF";       // REF	 
  end  
  
  if (DevSel && FifoIn[16] && FifoIn[15] && ~FifoIn[14] && ~FifoIn[10] && 
       FifoIn[7])
  begin
    CMDstr  = "RST";       // RST 
  end 
  
  if (DevSel && FifoIn[16] && FifoIn[15] && ~FifoIn[14] && FifoIn[10] && 
        ModeBit)
  begin 
    if (~FifoIn[7] && ~FifoIn[6] && ~FifoIn[5])
    begin
      CMDstr = "PFCA";      // PFCA
      ADDstr[3:0] = {FifoIn[12],FifoIn[11],FifoIn[9],FifoIn[8]} ;
    end
    else if (FifoIn[7])
    begin
      CMDstr = "RSTA";      // RSTA
      ADDstr[3:0] = {FifoIn[12],FifoIn[11],FifoIn[9],FifoIn[8]} ;
    end
  end  

    if ( DevSel && FifoIn[16] && ~FifoIn[15] && FifoIn[14] )
    begin 
      CMDstr = "READ" ;       // READ
      ADDstr = FifoIn [13:0] ;
    end 

    if ( DevSel && FifoIn[16] && ~FifoIn[15] && ~FifoIn[14] && 
           ((ModeBit && ~FifoIn[13]) || ~ModeBit))
    begin 
      CMDstr = "WRITE";      // WRITE
      ADDstr = FifoIn [13:0] ;
    end 

    if ( DevSel && ~FifoIn[16] && FifoIn[15] && FifoIn[14] )
    begin 
      CMDstr = "ACT";      // ACT
      ADDstr = FifoIn [13:0] ;           
    end 
    
    if ( DevSel && ~FifoIn[16] && ((ModeBit && ~FifoIn[15] && ~FifoIn[5] ) ||
       (~ModeBit && FifoIn[15])) && ~FifoIn[14] )
    begin 
      if ( ~FifoIn[10])
      begin
        CMDstr = "PRE";      // PRE
        ADDstr = FifoIn [13:0] ;    
      end
      else if (FifoIn[10])
        CMDstr = "PALL";     // PALL	
    end 

    if (DevSel && ~FifoIn[16] && ~FifoIn[15] && ~FifoIn[14] )
    begin 
      if ( ~ModeBit )
      begin
        CMDstr = "MSR";      // MODE SET REGISTER (DRAM MODE)
      end 
      else if ( FifoIn[13:5] == 9'h001 )
      begin
        CMDstr = "SCLR";      // SCLR
      end 
      else if (~FifoIn[8] && ~FifoIn[7] && FifoIn[6] && FifoIn[5] )
      begin 
        CMDstr = "SCCR";      // SCCR
      end
    end

end

endmodule

// --================================== End =================================--
