//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : Tube.v,v
//  File Revision       : 1.4
//
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Tube model for system messages
//  --========================================================================--
`timescale 1ns/1ps

module Tube (XD, XCSN, XWEN);
 
  input [31:0] XD;   // External data bus
  input  [3:0] XCSN; // External chip select
  input  [3:0] XWEN; // External write enable
 
//-----------------------------------------------------------------------------
// Constant declarations
//-----------------------------------------------------------------------------
// Control characters that are fed into the TUBE to control the output text.
  parameter CR    = 13; // Carriage Return
  parameter LF    = 10; // Line Feed
  parameter CTRLD =  4; // Program exit

//-----------------------------------------------------------------------------
// Signal declarations
//-----------------------------------------------------------------------------

// Input Signals
  wire [31:0] XD;
  wire  [3:0] XCSN;
  wire  [3:0] XWEN;

// Internal Signals
  integer          i;                 // Used as loop value
  integer          Outfile;           // Output file reference value
  reg [7:0]        DataVal;           // Input TUBE character value
  integer          StringLength;      // TUBE data length
  integer          j;
  reg [(8*80)-1:0] TubeString;        // TUBE data
  reg              PosedgeXwen0;
  event            PosedgeXwen0Event; // posedge XWEN[0] event

//-----------------------------------------------------------------------------
// Beginning of main code
//-----------------------------------------------------------------------------

// Display Task
  task Display;
    input            FilePtr;
    input [1:(8*80)] String;
    input            StrLength;
    integer          i, j, k, FilePtr, StrLength;
    reg        [0:7] Char;
  begin
    $write("TUBE: ");
    for (i = 1; i <= (StrLength * 8) ; i = i + 8) 
    begin
      for (j = 0; j <= 7; j = j + 1)
      begin
        k = i + j;
        Char[j] = String[k];
      end
      $write("%s",Char); 
      $fwrite(FilePtr, "%s", Char);
    end
    $display();
    $fdisplay(FilePtr);
  end
  endtask

//-----------------------------------------------------------------------------
// Tube Model
//-----------------------------------------------------------------------------

// Set up the file output variables
  initial
  begin
    Outfile = $fopen("Tube.txt");    // TUBE output file
    DataVal = 0;
    StringLength = 0;
    for (j = 0; j < 8*80; j = j + 1) // Initialise output string to zero
       TubeString[j] = 1'b0;
  end

// Used to trigger event on posedge XWEN[0]
  always @(posedge XWEN[0])
  begin
     PosedgeXwen0 = 1'b1;
     -> PosedgeXwen0Event;
  end

// Triggered on posedge XWEN[0]
  always @(PosedgeXwen0Event)
  begin

// Check for write to TUBE location. If the TUBE is moved from the default
//  position then the XCSN bit that is checked must be altered.
    if (XCSN[2] == 1'b0)
    begin
      DataVal = XD[7:0];

// Control-D, quit simulation, printing out string first
      if (DataVal == CTRLD)
      begin
        if (StringLength > 0)
        begin
          Display(Outfile, TubeString, StringLength);
        end
        $display("TUBE: Program exit");
        $finish;
      end

// Linefeed or carriage return, print output when tube contains data
      else if ((DataVal == LF) || (DataVal == CR))
      begin
        if (StringLength > 0)
        begin
          Display(Outfile, TubeString, StringLength);
          StringLength = 0;
          for (j = 0; j < 8*80; j = j + 1)
            TubeString[j] = 1'b0;
          end
        end 

// A normal character
      else
      begin
        StringLength = StringLength + 1;
        if (StringLength > 80) // Overflowed buffer, so print it out
        begin
          Display(Outfile, TubeString, StringLength);
          StringLength = 0;
          TubeString[((8 * 80) - 1):(8 * 79)] = DataVal[7:0];
          for (i = (8 * 79) - 1; i > 0; i = i - 1)
            TubeString[i] = 1'b0;
          end
        else
        begin
          i = (8 * 80) - (8 * StringLength); 
          for (j = 0; j < 8; j = j + 1)
          TubeString[i+j] = DataVal[j];
        end
      end
    end
    PosedgeXwen0 = 1'b0;
  end


endmodule

// --================================= End ===================================--
