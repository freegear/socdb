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
// File Name              : funcsmaster.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v2
// 
// ---------------------------------------------------------------------
//
// Purpose : To describe procedures and functions, mainly for
// buschecker/watcher
//
// --=================================================================--

//`timescale 1ns/1ps

// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//
//                             funcsmaster
//                             ===========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This module describes some common functions and procedures, the
// brief outline of which are given as follows :-
// o Compare :-
//   This procedure is used in BusChecker module for flashing suitable
// error messages. It takes as input the actual signal to be checked,
// the value with which it is to be compared and the present value of
// the address line. If the values don't match it flashes an error along
// with giving the address during which the error occurred.
// o To_HexString :-
//   This function any  as input and returns the corresponding
//   hexadecimal string.
// o Endianize :- 
//   This function drives data on appropriate bytelanes as per
// endianness. It takes endianness and HADDR bits as input and on the
// basis of that, "puts" data on the correct byte lane and drives the
// other lanes to zero.
// o to_vec :-
//   This function converts a bit to a  of length 1.
// o from_vec :-
//   This function converts as  of length 1, to std_logic.
// o ReportVirRead :-
//   This function reports an error, if the value read from the VR does
// not match with expected value. If HaltOnMismatch is set, then it
// halts the simulation by giving a severity of failure. If verbosity is
// set, it reports the event, even if the value matches with the
// expected one.
// o ReportVirWrite :-
//   This function reports the write value along with the mask, whenever
// there is a virtual write.

// --========================== BODY =================================--

// ---------------------------------------------------------------------
// This procedure is used in BusChecker and BusWatch module for flashing
// suitable error messages. It takes as input the actual signal to be
// checked, the value with which it is to be compared and the present
// value of the address line. If the values don't match it flashes an
// error along with giving the address during which the error occurred.
// ---------------------------------------------------------------------

task Compare;
input                  HaltOnMismatch;
input [(8 * 10 - 1):0] strg1;
input [63:0]           data1;
input [63:0]           data2;
input [63:0]           data3;
input [(8 * 25 - 1):0] strg2;
input [(8 * 15 - 1):0] strg3;
input [(8 * 20 - 1):0] tag;
begin
  if (data1 != data2)
  begin
    $display("%0s: %0s Error on %s at address %h. Expected: %h Actual: %h",
             strg3, strg2, strg1, data3, data2, data1,
             " TAG: %0s. TIME : %t", tag, $time);
    if (HaltOnMismatch)
      $finish;
  end
  else if (data1 == data2)
    if (Verbosity == 1'b1)
      $display("%t: Correct value expected for %0s = %h",
               $time, strg1, data1);
end
endtask

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
      $display("%t: VRE%h: Error on vector read from VR%h.",
               $time, regnum, regnum,
               "Expected: %h Actual: %h Mask: %h, TAG: %0s",
               EXP, DATA, MASK, TAG);
      if (HaltOnMismatch)
        $finish;
    end
    else
      if (Verbosity)
        $display("%t: VRC%h: Correct read value of %h with mask %h from R%s,",
                 " TAG: %0s", $time, regnum, DATA, MASK, regnum, TAG);
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
endtask

// ---------------------------------------------------------------------
// This block is responsible for driving data on appropriate bytelanes
// as per the endianness. It takes endianness and HADDR bits as input
// and on the basis of that, "puts" the data on the correct byte lane
// and drives the other lanes to zero.
// ---------------------------------------------------------------------
function [63:0] EndnzdData; 
input [63 :0] data;
input [2:0]   size;  
input [31:0]  address;
input [2:0]   ByteLaneDecidr;
input [1:0]   Endianness;
input [7:0]   DATABUSWIDTH;
reg [63:0]    ALLZEROES;
//variable EndnzdData : T_data;
begin
  assign ALLZEROES = 64'h0000000000000000;
  if ((Endianness == 2'b00) || (Endianness == 2'b01))
  begin
    if (DATABUSWIDTH == 32)
    begin 
      if (size == 3'b000) 
        begin 
           case (ByteLaneDecidr[1:0])
             2'b00 : 
               EndnzdData = {ALLZEROES[63:32], ALLZEROES[31:8], 
                             data[7:0]};
             2'b01 :
               EndnzdData = {ALLZEROES[63:32], ALLZEROES[31:16], 
                             data[7:0], ALLZEROES[7:0]};
             2'b10 : 
               EndnzdData = {ALLZEROES[63:32], ALLZEROES[31:24], 
                             data[7:0], ALLZEROES[15:0]};
             2'b11: 
               EndnzdData = {ALLZEROES[63:32], data[7:0], 
                               ALLZEROES[23:0]};
             default:
              EndnzdData  = data; 
           endcase
        end
      else if (size == 3'b001)
        begin 
          case (ByteLaneDecidr[1]) 
            1'b0 : 
              EndnzdData = {ALLZEROES[63:32], ALLZEROES[31:16],
                            data[15:0]};
            1'b1 : 
              EndnzdData = {ALLZEROES[63:32], data[15:0],
                            ALLZEROES[15:0]};
            default :
              EndnzdData  = data; 
          endcase
        end 
      else if (size == 3'b010) 
         EndnzdData = {ALLZEROES[63:32], data[31:0]};
      else
        // although this is an illegal clause, still for correct
        // behaviour of expected data, here data is assigned to
        // EndnzdData
        EndnzdData = data;
    end
    else if (DATABUSWIDTH == 64) 
    begin
      if (size == 3'b000) 
        begin
      // transfer size is byte-size
          case (ByteLaneDecidr[2:0]) 
            3'b000 : 
              EndnzdData = {ALLZEROES[63:8], data[7:0]};
            3'b001 : 
              EndnzdData = {ALLZEROES[63:16], data[7:0], 
                            ALLZEROES[7:0]};
            3'b010 : 
              EndnzdData = {ALLZEROES[63:24], data[7:0], 
                            ALLZEROES[15:0]};
            3'b011 : 
              EndnzdData = {ALLZEROES[63:32], data[7:0], 
                          ALLZEROES[23:0]};
            3'b100 : 
              EndnzdData = {ALLZEROES[63:40], data[7:0], 
                            ALLZEROES[31:0]};
            3'b101 : 
              EndnzdData = {ALLZEROES[63:48], data[7:0], 
                            ALLZEROES[39:0]};
            3'b110 : 
              EndnzdData = {ALLZEROES[63:56], data[7:0], 
                          ALLZEROES[47:0]};
            3'b111 : 
              EndnzdData = {data[7:0], ALLZEROES[55:0]};
            default :
              EndnzdData  = data; 
          endcase
        end 
      else if (size == 3'b001) 
        begin 
      // transfer size is halfword-size
          case (ByteLaneDecidr[2:1]) 
            2'b00 : 
              EndnzdData = {ALLZEROES[63:16], data[15:0]};
            2'b01 : 
              EndnzdData = {ALLZEROES[63:32], data[15:0]
                           , ALLZEROES[15:0]};
            2'b10 : 
              EndnzdData = {ALLZEROES[63:48], data[15:0]
                           , ALLZEROES[31:0]};
            2'b11 : 
              EndnzdData = {data[15:0], ALLZEROES[47:0]};
            default : 
          EndnzdData = data; 
          endcase
        end
      else if (size == 3'b010) 
        begin
      // transfer size is word-size
          case (ByteLaneDecidr[2]) 
            1'b0 : 
              EndnzdData = {ALLZEROES[63:32], data[31:0]};
            1'b1 : 
              EndnzdData = {data[31:0], ALLZEROES[31:0]};
            default : 
          EndnzdData = data; 
          endcase
        end
      else if (size == 3'b011) 
    // transfer size is doubleword-size
        EndnzdData = data;
      else
        // although this is an illegal clause, still for correct
        // behaviour of expected data, here data is assigned
        // to EndnzdData
        EndnzdData = data;
    end
  end
  else if (Endianness == 2'b11)
  begin
    EndnzdData = data;
  end
end
endfunction

// --============================= End ===============================--
