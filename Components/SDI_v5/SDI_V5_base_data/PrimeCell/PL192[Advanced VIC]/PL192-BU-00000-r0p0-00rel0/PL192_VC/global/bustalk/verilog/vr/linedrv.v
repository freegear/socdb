// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1998 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : linedrv.v.rca 
// File Revision       : 1.1 
// 
// Release Information : PrimeCell(TM)-GLOBAL-r8p0-00rel0 
// 
// -----------------------------------------------------------------------------
// Purpose             : Single Virtual register driver
// --=========================================================================--

`timescale 1ns/1ps

module LINEDRV (BCLK, VIO_SEL, VR_PACKET_DATA, VR_PACKET_MASK,
                VR_PACKET_EXP, VR_PACKET_PHASE, VR_PACKET_EDGE,
                VR_PACKET_TAG, REGEN, DATA_BUS, MASK_BUS);

  parameter 
     Verbosity = 0,
     HaltOnMismatch = 0;
   
  parameter [2:0] REGNO = 0;

  `include "../common/defs.v"

 
  input BCLK;
  input [1:0] VIO_SEL;
  input [31:0] VR_PACKET_DATA;
  input [31:0] VR_PACKET_MASK;
  input [31:0] VR_PACKET_EXP;
  input VR_PACKET_PHASE;
  input VR_PACKET_EDGE;
  input [159:0] VR_PACKET_TAG;

  output REGEN;
  inout [31:0] DATA_BUS;
  output [31:0] MASK_BUS;

  wire [31:0] I_R_DATA;
  wire I_REGEN;
 
  reg I_EDGE;
  reg [31:0] I_EXP;
  reg I_PHASE;
  reg [31:0] I_MASK;
  reg [31:0] I_DATA;
  reg [159:0] I_TAG;

  reg [31:0] I_DATA_BUS;
  assign DATA_BUS = I_DATA_BUS;
 
  always @(VIO_SEL or BCLK)
  begin
    if (VIO_SEL === `T_V_DRV_SEL_V_WRITE || VIO_SEL === `T_V_DRV_SEL_V_READ)
    begin
      I_DATA    <= VR_PACKET_DATA;       //   Drive data bus
      I_MASK    <= VR_PACKET_MASK;       //   Drive mask bus
      I_PHASE   <= VR_PACKET_PHASE;
      I_EXP     <= VR_PACKET_EXP;
      I_EDGE    <= VR_PACKET_EDGE;
      I_TAG     <= VR_PACKET_TAG;
    end
  end
 
  assign I_REGEN = (((I_PHASE === BCLK) && VIO_SEL === `T_V_DRV_SEL_V_WRITE) ?
                   1'b1 : 1'b0);
  assign REGEN = I_REGEN;
  assign MASK_BUS = I_MASK;

  
  // Data bus output tri-state buffer
  always @(BCLK or VIO_SEL or I_PHASE or I_DATA)
  begin
    if (VIO_SEL === `T_V_DRV_SEL_V_READ)
      I_DATA_BUS <= {32{ 1'bz }};
    else if (VIO_SEL === `T_V_DRV_SEL_V_WRITE && I_PHASE === BCLK)
      I_DATA_BUS <= I_DATA;
  end
 
  always @(BCLK)
  begin
    begin
      if (BCLK === I_EDGE)
      begin
        if (VIO_SEL === `T_V_DRV_SEL_V_WRITE && Verbosity)
          REPORTVIRWRITE (I_DATA,
                          I_MASK,
                          REGNO);
        else if (VIO_SEL === `T_V_DRV_SEL_V_READ)
          REPORTVIRREAD (DATA_BUS,
                         I_MASK,
                         I_EXP,
                         REGNO,
                         I_TAG);
      end
    end
  end
  
  task REPORTVIRWRITE;
 
    input [31:0] DATA;
    input [31:0] MASK;
    input [2:0]                REGNO;

    begin
    if (Verbosity)
     	$display("%t: VWI%d: Vector write of %h with mask %h to R%0d",
                 $time, REGNO, DATA, MASK, REGNO);
 
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
      $write("%t: VRE%d :Error on vector read from R%0d.", $time, REGNO, REGNO);
      $display(" Expected: %h Actual: %h Mask: %h, TAG: %0s", EXP, DATA, MASK,
               TAG);
      if (HaltOnMismatch)
        $finish;
    end
    else if (Verbosity)
      begin 
        $write("%t: VRC%d :Correct read value of %h", $time, REGNO, EXP);
        $display(" with mask %h from R%0d, TAG:%0s", MASK, REGNO, TAG);
      end
  end
  endtask
endmodule

// --================================= End ===================================--
