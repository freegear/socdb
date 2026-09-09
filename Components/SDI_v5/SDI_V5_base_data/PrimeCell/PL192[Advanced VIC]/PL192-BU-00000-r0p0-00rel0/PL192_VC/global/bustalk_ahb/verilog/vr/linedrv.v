// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name              : linedrv.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-GLOBAL-r8p0-00rel0
// 
// ---------------------------------------------------------------------
// Purpose :
//           Single virtual regiser driver
//
// --=================================================================--

`timescale 1ns/1ps
`include "../common/defs.v"

// ---------------------------------------------------------------------

module linedrv (HCLK,
                VIOSel, 
                VRPacketVregno,
                VRPacketData,
                VRPacketMask,
                VRPacketExp,
                VRPacketPhase,
                VRPacketEdge,
                VRPacketTag,
                RegEn,
                DataBus,
                MaskBus
               );

parameter 
  Verbosity = 0,
  HaltOnMismatch = 0;
   
 parameter [2:0] REGNO = 0;

input         HCLK;
// main system bus clock
input [1:0]   VIOSel;
// indicates the current vr cycle e.g `T_V_DRV_SEL_V_WRITE
input [2:0]   VRPacketVregno;
input [31:0]  VRPacketData;
input [31:0]  VRPacketMask;
input [31:0]  VRPacketExp;
input         VRPacketPhase;
input         VRPacketEdge;
input [159:0] VRPacketTag;
// packet containing info about values to be driven on virtual
// reg lines

inout [31:0]  DataBus;
// internal i/o between linedriver and vregbank module

output        RegEn;
// when high, indicates that the Virtual Register can be written into

output [31:0] MaskBus;
// 32 bit mask used for reading and comparing data from virtual register

// ---------------------------------------------------------------------
//
//                             linedrv
//                             =======
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This module drives all the signal to virtual registers and checks
// the read data bus for the expected data.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------

wire [31:0] I_R_DATA;

wire iRegEn;
// acts as latching signal, to latch the VWrite data into the
// Virtual Register
 
reg [2:0]iRegNo; 
// indicates the virtual-register-number under consideration

reg iEdge;
// if VR, this signal indicates the clock edge, when the data is to
// be read

reg [31:0] iExp;
// in case of VR, this stores the data which is to be compared with
// VR value

reg iPhase;
// in case of VW, this signal indicates the clock phase when write is
// to occur

reg [31:0] iMask;
// it is the 32bit mask used for both VR and VW

reg [31:0] iData;
// if it is VW command then iData is intermediate storage for data to
// be written

reg [159:0] iTag;
// the tag to be flashed

reg [31:0] iDataBus;

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// --------------------------------------------------------------------

assign DataBus = iDataBus;
 
// ---------------------------------------------------------------------
// The VRpacket values are latched, because by the time these values
// will be driven in/from virtual registers, a different packet might
// have been driven.
// ---------------------------------------------------------------------
always @(VIOSel or HCLK)
begin
  if (VIOSel === `T_V_DRV_SEL_V_WRITE || VIOSel === `T_V_DRV_SEL_V_READ)
    begin
      iRegNo   <= VRPacketVregno;
      iData    <= VRPacketData;       //   Drive data bus
      iMask    <= VRPacketMask;       //   Drive mask bus
      iPhase   <= VRPacketPhase;
      iExp     <= VRPacketExp;
      iEdge    <= VRPacketEdge;
      iTag     <= VRPacketTag;
    end
end
 
assign iRegEn = (((iPhase === HCLK) &&
                   VIOSel === `T_V_DRV_SEL_V_WRITE) ?  1'b1 : 1'b0);
initial
begin
  $timeformat(-9, 0, " ns", 13);
end
// ---------------------------------------------------------------------
// Assigning the local copy to output
// ---------------------------------------------------------------------
assign RegEn   = iRegEn;
assign MaskBus = iMask;
  
// ---------------------------------------------------------------------
// If there is a read cycle, no values should be driven on the data
// bus, thus it is tristated. But if it is a write cycle, then latched
// VRpacket.data value is driven on the data line, which is to be
// stored by vregbank.
// ---------------------------------------------------------------------
always @(HCLK or VIOSel or iPhase or iData)
begin : p_dbdriv
  if (VIOSel === `T_V_DRV_SEL_V_READ)
    begin
      iDataBus <= {32{1'bz}};
    end
  else if (VIOSel === `T_V_DRV_SEL_V_WRITE && iPhase === HCLK)
    begin
      iDataBus <= iData;
    end
end
 
// ---------------------------------------------------------------------
// A Write to a virtual register, is reported during the simulation
// if the parameter Verbosity is switched on.
// ---------------------------------------------------------------------
always @(HCLK)
begin
  if (HCLK === iEdge)
    begin
      if (VIOSel === `T_V_DRV_SEL_V_WRITE && Verbosity)
        begin
          REPORTVIRWRITE (iData, iMask, iRegNo);
        end
      else if (VIOSel === `T_V_DRV_SEL_V_READ)
        begin
          REPORTVIRREAD (DataBus, iMask, iExp, iRegNo, iTag);
        end
    end
end
  
task REPORTVIRWRITE;
input [31:0] DATA;
input [31:0] MASK;
input [2:0]  REGNO;
begin
  if (Verbosity)
     	$display("%t: VWI%d: Vector write of %h ", $time, REGNO, DATA, 
                 "with mask %h to R%0d", MASK, REGNO);
 
end
endtask

task REPORTVIRREAD;
input [31:0] DATA;
input [31:0] MASK;
input [31:0] EXP;
input [2:0] REGNO;
input [159:0] TAG;
begin
  if (((MASK & DATA) !== (MASK & EXP)))
    begin
      $display("%t: VRE%d :Error on vector read from R%0d. ",
               $time,REGNO,REGNO,
               "Expected: %h Actual: %h Mask: %h, TAG:%0s",
               EXP,DATA,MASK, TAG);
      if (HaltOnMismatch)
        $finish;
    end
  else if (Verbosity)
      $display("%t: VRC%d: Correct read value of %h with mask ",
               $time,REGNO,EXP, "%h from R%0d, TAG:%0s",
               MASK, REGNO, TAG);
end
endtask

endmodule

// --============================= End ===============================--
