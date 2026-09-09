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
// Version and Release Control Information:
//
// File Name           : funcs.v,v
// File Revision       : 1.3
//
// Release Information : Rev1-3
//
// --------------------------------------------------------------------
//   Purpose :
//             This contains the functions/procedures to_vec and
//             from_vec convert length 1 s to std_logic and
//             vice-versa for use in the generic width addr_driver.
//
// --=================================================================--

`timescale 1ns/1ps
`include "../common/defs.v"
`include "../tbench/timing.v"
 
`uselib lib=common 

// --------------------------------------------------------------------

module funcs ();

// ---------------------------------------------------------------------
//
//                                  funcs
//                                  =====
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This module contains some functions for checking the data in the
// read bus as well as for driving the data according to the endianness
// of the system it is driving. It also have some functions for
// printing out any string.d
// 
// --============================= BODY ==============================--

// ---------------------------------------------------------------------
// This function returns the length of the string
// ---------------------------------------------------------------------
// Checking read data bus for the expected value
// ---------------------------------------------------------------------
task ReportRead;
    input         Verbosity;
    input         HaltOnMismatch;
    input [63:0]  DATA;
    input [63:0]  MASK;
    input [31:0]  ADDRESS;
    input [63:0]  EXP;
    input [159:0] TAG;
begin
  if ((MASK & DATA) !== (MASK & EXP)) 
    begin
      $display("%t: PSRE: Error on data read from %h. Expected: %h",
               $time, ADDRESS,EXP,
               " Actual: %h Mask: %h TAG: %0s", DATA, MASK, TAG);
      if (HaltOnMismatch)
        $finish;
    end
    else 
      if (Verbosity)
      $display("%t: PSRC: Correct read value of %h from %h ",
               $time,DATA,ADDRESS,
               "with mask %h, TAG: %0s", MASK, TAG);
end
endtask

// ---------------------------------------------------------------------
// Checks for extra transfers in a beat
// ---------------------------------------------------------------------
task ReportExtra;
  input count;
  input [63:0] ADDRESS;
  input [159:0] TAG;
begin
  if (count == 4)
    $display("%t: Extra: Extra transfer for four-beat burst ", $time,
              "Address: %h TAG: %0s", ADDRESS, TAG);
  else
  begin
    if (count == 8)
        $display("%t: Extra: Extra transfer for eight-beat burst ",
                 $time, "Address:  %h TAG: %0s", ADDRESS, TAG); 
    else 
    begin
      if (count == 16)
        $display("%t: Extra: Extra transfer for sixteen-beat ", $time,
                  "burst Address: %h TAG: %0s", ADDRESS, TAG);
    end 
  end
end
endtask // ReportExtra; 

// ---------------------------------------------------------------------
// Checks for reset getting asserted and deasserted
// ---------------------------------------------------------------------
task ReportReset;
  input nres;
begin
  if (nres == 1'b0)
    $display("RESL: HRESETn asserted (LOW)");
  else 
    if (nres == 1'b1)
    $display("RESH: HRESETn deasserted (HIGH)");
end
endtask  //ReportReset
 
// ---------------------------------------------------------------------
// Checks VR read data bus for expected data
// ---------------------------------------------------------------------
task ReportVirRead;
    input         Verbosity;
    input         HaltOnMismatch;
    input [31:0]  DATA;
    input [31:0]  MASK;
    input [31:0]  EXP;
    input [3:0]   regnum;
    input [159:0] TAG;
  begin
    if ((MASK & DATA) !== (MASK & EXP))
    begin
      $display ("%t: VRE%h: Error on vector read from", $time, regnum,
                " VR%h. Expected: %h", regnum, EXP,
                " Actual:" , " %h Mask: %h, TAG: %0s", DATA, MASK, TAG);
      if (HaltOnMismatch)
        $finish;
    end
    else
      if (Verbosity)
      $display("%t: VRC%h: Correct read value of %h",
               $time, regnum, DATA,
               " with mask %h from R%s,", MASK, regnum,
               " TAG: %0s", TAG);
  end
endtask
 
// ---------------------------------------------------------------------
// Writing into VR
// ---------------------------------------------------------------------
task ReportVirWrite;
 
input [31:0] data;
input [31:0] mask;
input        regnum;
begin
  $display("VW%s: Vector write of %h with mask %h to  R%h",
           regnum,data, mask, regnum);
end
endtask     //  ReportVirWrite;

endmodule

// --============================= End ===============================--
