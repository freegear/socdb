// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version  and  Release Control Information:
//
// File Name              : split.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
//
// ---------------------------------------------------------------------
//   Purpose :
//             Checks HSPLITx lines for numcycles specified 
//
// --=================================================================--

`include   "../common/defs.v"
`timescale 1ns/1ps

// ---------------------------------------------------------------------

module split (
              HCLK,
              HSPLIT,
              SpCycSel,
              SpExpmas,
              SpNumcyc0,
              SpNumcyc1,
              SpNumcyc2,
              SpNumcyc3,
              SpNumcyc4,
              SpNumcyc5,
              SpNumcyc6,
              SpNumcyc7,
              SpNumcyc8,
              SpNumcyc9,
              SpNumcyc10,
              SpNumcyc11,
              SpNumcyc12,
              SpNumcyc13,
              SpNumcyc14,
              SpNumcyc15,
              SpLimit
             );
parameter 
  Verbosity = 0,
  HaltOnMismatch = 0;
             
input          HCLK;           
// AHB Clock
input [15:0]   HSPLIT;         
// HSPLITx lines
input [3:0]    SpCycSel;       
// HSP command active 
input [15:0]   SpExpmas;       
// HSP command Expected Master field  
input [7:0]    SpNumcyc0;
input [7:0]    SpNumcyc1;
input [7:0]    SpNumcyc2;
input [7:0]    SpNumcyc3;
input [7:0]    SpNumcyc4;
input [7:0]    SpNumcyc5;
input [7:0]    SpNumcyc6;
input [7:0]    SpNumcyc7;
input [7:0]    SpNumcyc8;
input [7:0]    SpNumcyc9;
input [7:0]    SpNumcyc10;
input [7:0]    SpNumcyc11;
input [7:0]    SpNumcyc12;
input [7:0]    SpNumcyc13;
input [7:0]    SpNumcyc14;
input [7:0]    SpNumcyc15;
input [7:0]    SpLimit;
// HSP command Numcycle field 

// ---------------------------------------------------------------------
//
//                           split
//                           =====
//
// ---------------------------------------------------------------------
//
// Overview :
// ==========
//   This module checks the HSPLITx lines for the numcycle clocks
// mentioned and  reports an error if the slave fails to do so.
//
// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
reg        Splitcntren;  
// HSP is active  and  checking

reg [15:0] ExpSplit;
// Expected HSPLITx lines

reg [7:0]  Splitcount;   
// Counter which runs when HSP is active 

reg [7:0]  Numcyc [15:0];
// Numcyc bus for 16 Masters

reg        DelSplitcntren;
// Delayed Counter Enable 

integer    i;
// Loop Variable
// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Counter for the SPLITx check 
// ---------------------------------------------------------------------
always @(SpNumcyc15 or SpNumcyc14 or SpNumcyc13 or SpNumcyc12 or
         SpNumcyc11 or SpNumcyc10 or SpNumcyc9 or SpNumcyc8 or
         SpNumcyc7 or SpNumcyc6 or SpNumcyc5 or SpNumcyc4 or
         SpNumcyc3 or SpNumcyc2 or SpNumcyc1 or 
         SpNumcyc0 or SpExpmas)
begin
  Numcyc[15] = SpNumcyc15;
  Numcyc[14] = SpNumcyc14;
  Numcyc[13] = SpNumcyc13;
  Numcyc[12] = SpNumcyc12;
  Numcyc[11] = SpNumcyc12;
  Numcyc[10] = SpNumcyc11;
  Numcyc[9]  = SpNumcyc10;
  Numcyc[8]  = SpNumcyc9;
  Numcyc[7]  = SpNumcyc8;
  Numcyc[6]  = SpNumcyc7;
  Numcyc[5]  = SpNumcyc6;
  Numcyc[4]  = SpNumcyc5;
  Numcyc[3]  = SpNumcyc4;
  Numcyc[2]  = SpNumcyc3;
  Numcyc[1]  = SpNumcyc2;
  Numcyc[0]  = SpNumcyc1;
end
always @ ( posedge HCLK)
begin : p_Splitcounter
  if (Splitcntren == 1'b1 & SpCycSel != `T_CYCLE_C_SPLIT 
                                & DelSplitcntren == 1'b0) 
    Splitcount <= Splitcount + 1;
  else
    Splitcount <= 8'b00000001;
end  // p_Splitcounter;

initial
begin
  $timeformat(-9, 0, " ns", 13);
  DelSplitcntren = 1'b0;
  Splitcntren    = 1'b0;
end

// ---------------------------------------------------------------------
// Checking whether the limit has exceeded expected numcycle value
// ---------------------------------------------------------------------
always @ (posedge HCLK)
begin : reportsplit 
  if (SpCycSel == `T_CYCLE_C_SPLIT)
  begin
    DelSplitcntren <= ~DelSplitcntren; 
    Splitcntren <= 1'b1;
    if (Splitcntren == 1'b1 & DelSplitcntren == 1'b0)
    begin
      Splitcount <= 8'b00000001;
      for (i = 0; i <= 15; i = i + 1)
        if (ExpSplit[i] == 1'b1 & HSPLIT[i] != 1'b1)
          $display("%t:WARNHSP : WARNING : HMASTER%d not yet asserted",
                   $time,i,
                   " on HSPLITx and execution of command is broken ");
    end
    ExpSplit   = SpExpmas; 
  end
  else 
  begin
    if (Splitcntren == 1'b1)
    begin
      if (Splitcount > SpLimit)
      begin
        for(i = 0;i<= 15; i= i + 1)
          if (ExpSplit[i] == 1'b1 & HSPLIT[i] != 1'b1)
          begin
            ExpSplit[i] <= 1'b0;
            $display("%t : ERRHSPLT :Error : HMASTER %d not yet ",
                     $time,i,
            "asserted on HSPLITx within the expected number of clock cycles");
           if (HaltOnMismatch)
             $finish; 
          end
        Splitcntren  <= 1'b0;
      end
      for (i = 0 ; i <= 15; i = i + 1)
      begin
        if (HSPLIT[i] == 1'b1 & Splitcount <= Numcyc[i] &
            Numcyc[i] > 8'h00)
        begin
          ExpSplit[i] = 1'b0;
           $display("%t : ERRHSPLTP :Error : HMASTER %d asserted on ",
                    $time,i,
                    "HSPLITx prior to the expected number of clocks");
           if (HaltOnMismatch)
             $finish; 
        end
        if (HSPLIT[i] == 1'b1 & Splitcount >= Numcyc[i] &
            Numcyc[i] > 8'h00)
        begin
          ExpSplit[i] = 1'b0;
           $display("%t : ERRHSPLTL :Error : HMASTER %d asserted on ",
                    $time,i,
                    "HSPLITx after the expected number of clocks");
           if (HaltOnMismatch)
             $finish; 
        end
        if (HSPLIT[i] == 1'b1 &
          ((Splitcount == Numcyc[i] & Numcyc[i] > 8'h00) |
           (Numcyc[i] == 8'h00)))
        begin
          ExpSplit[i] = 1'b0;
          if (Verbosity)
            $display("%t :Note : HSPC : HMASTER %d correctly asserted",
                     $time,i,
                   " on HSPLITx on the expected number of clock");
        end
        
      end
    end
  end
end // reportsplit 

endmodule

// --============================= End ===============================--
