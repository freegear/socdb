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
// File Name              : vio_driver.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v4
//
// ---------------------------------------------------------------------
// Purpose : Virtual registers block structure
//
// --=================================================================--

`timescale 1ns/1ps

module VIO_DRIVER (PCLK, VIO_SEL, VR_PACKET_VREGNO, VR_PACKET_DATA,
                   VR_PACKET_MASK, VR_PACKET_EXP, VR_PACKET_WRITE,
                   VR_PACKET_PHASE, VR_PACKET_EDGE, VR_PACKET_DELAY,
                   VR_PACKET_TAG,
                   VRG0, VRG1, VRG2, VRG3, VRG4, VRG5, VRG6, VRG7); 
   parameter
      vrg0_del = 5,
      vrg1_del = 5,
      vrg2_del = 5,
      vrg3_del = 5,
      vrg4_del = 5,
      vrg5_del = 5,
      vrg6_del = 5,
      vrg7_del = 5,
      Verbosity = 0,
      HaltOnMismatch = 0;
   
  `include "../common/defs.v"
 
  input PCLK;
  input [8 * 2 - 1:0] VIO_SEL;
  input [8 * 3 - 1:0] VR_PACKET_VREGNO;
  input [8 * 32 - 1:0] VR_PACKET_DATA;
  input [8 * 32 - 1:0] VR_PACKET_MASK;
  input [8 * 32 - 1:0] VR_PACKET_EXP;
  input [7:0] VR_PACKET_WRITE;
  input [7:0] VR_PACKET_PHASE;
  input [7:0] VR_PACKET_EDGE;
  input [8 * 8 - 1:0] VR_PACKET_DELAY;
  input [8 * 160 - 1:0] VR_PACKET_TAG;

  inout [31:0] VRG0;
  inout [31:0] VRG1;
  inout [31:0] VRG2;
  inout [31:0] VRG3;
  inout [31:0] VRG4;
  inout [31:0] VRG5;
  inout [31:0] VRG6;
  inout [31:0] VRG7;

  wire [31:0] DATA_BUS_0;
  wire [31:0] DATA_BUS_1;
  wire [31:0] DATA_BUS_2;
  wire [31:0] DATA_BUS_3;
  wire [31:0] DATA_BUS_4;
  wire [31:0] DATA_BUS_5;
  wire [31:0] DATA_BUS_6;
  wire [31:0] DATA_BUS_7;
  wire [31:0] MASK_BUS_0;
  wire [31:0] MASK_BUS_1;
  wire [31:0] MASK_BUS_2;
  wire [31:0] MASK_BUS_3;
  wire [31:0] MASK_BUS_4;
  wire [31:0] MASK_BUS_5;
  wire [31:0] MASK_BUS_6;
  wire [31:0] MASK_BUS_7;
  wire [0:7] REGEN_BUS;
 
// Instantiate eight virtual register to packet interfaces, using 
// appropriate slices of composite VR_PACKET data.

  LINEDRV #(Verbosity,HaltOnMismatch,0) U_LNDRV0
    (.PCLK(PCLK),
     .VIO_SEL(VIO_SEL[1:0]),
     .VR_PACKET_DATA(VR_PACKET_DATA[31:0]),
     .VR_PACKET_MASK(VR_PACKET_MASK[31:0]),
     .VR_PACKET_EXP(VR_PACKET_EXP[31:0]),
     .VR_PACKET_PHASE(VR_PACKET_PHASE[0]),
     .VR_PACKET_EDGE(VR_PACKET_EDGE[0]),
     .VR_PACKET_TAG(VR_PACKET_TAG[(1 * 160 - 1):0]),
     .REGEN(REGEN_BUS[0]),
     .DATA_BUS(DATA_BUS_0),
     .MASK_BUS(MASK_BUS_0));
 
  LINEDRV #(Verbosity,HaltOnMismatch,1) U_LNDRV1
    (.PCLK(PCLK),
     .VIO_SEL(VIO_SEL[3:2]),
     .VR_PACKET_DATA(VR_PACKET_DATA[( 2 * 32 - 1):( 1 * 32)]),
     .VR_PACKET_MASK(VR_PACKET_MASK[( 2 * 32 - 1):( 1 * 32)]),
     .VR_PACKET_EXP(VR_PACKET_EXP[( 2 * 32 -1):( 1 * 32)]),
     .VR_PACKET_PHASE(VR_PACKET_PHASE[1]),
     .VR_PACKET_EDGE(VR_PACKET_EDGE[1]),
     .VR_PACKET_TAG(VR_PACKET_TAG[( 2 * 160 - 1):( 1 * 160 )]),
     .REGEN(REGEN_BUS[1]),
     .DATA_BUS(DATA_BUS_1),
     .MASK_BUS(MASK_BUS_1));
 
  LINEDRV #(Verbosity,HaltOnMismatch,2) U_LNDRV2
    (.PCLK(PCLK),
     .VIO_SEL(VIO_SEL[5:4]),
     .VR_PACKET_DATA(VR_PACKET_DATA[( 3 * 32 - 1):( 2 * 32)]),
     .VR_PACKET_MASK(VR_PACKET_MASK[( 3 * 32 - 1):( 2 * 32)]),
     .VR_PACKET_EXP(VR_PACKET_EXP[( 3 * 32 - 1):( 2 * 32)]),
     .VR_PACKET_PHASE(VR_PACKET_PHASE[2]),
     .VR_PACKET_EDGE(VR_PACKET_EDGE[2]),
     .VR_PACKET_TAG(VR_PACKET_TAG[( 3 * 160 - 1):( 2 * 160 )]),
     .REGEN(REGEN_BUS[2]),
     .DATA_BUS(DATA_BUS_2),
     .MASK_BUS(MASK_BUS_2));
 
  LINEDRV #(Verbosity,HaltOnMismatch,3) U_LNDRV3
    (.PCLK(PCLK),
     .VIO_SEL(VIO_SEL[7:6]),
     .VR_PACKET_DATA(VR_PACKET_DATA[( 4 * 32 - 1):( 3 * 32)]),
     .VR_PACKET_MASK(VR_PACKET_MASK[( 4 * 32 - 1):( 3 * 32)]),
     .VR_PACKET_EXP(VR_PACKET_EXP[( 4 * 32 - 1):( 3 * 32 )]),
     .VR_PACKET_PHASE(VR_PACKET_PHASE[3]),
     .VR_PACKET_EDGE(VR_PACKET_EDGE[3]),
     .VR_PACKET_TAG(VR_PACKET_TAG[( 4 * 160 - 1):( 3 * 160)]),
     .REGEN(REGEN_BUS[3]),
     .DATA_BUS(DATA_BUS_3),
     .MASK_BUS(MASK_BUS_3));
 
  LINEDRV #(Verbosity,HaltOnMismatch,4) U_LNDRV4
    (.PCLK(PCLK),
     .VIO_SEL(VIO_SEL[9:8]),
     .VR_PACKET_DATA(VR_PACKET_DATA[( 5 * 32 - 1):( 4 * 32)]),
     .VR_PACKET_MASK(VR_PACKET_MASK[( 5 * 32 - 1):( 4 * 32)]),
     .VR_PACKET_EXP(VR_PACKET_EXP[( 5 * 32 - 1):( 4 * 32)]),
     .VR_PACKET_PHASE(VR_PACKET_PHASE[4]),
     .VR_PACKET_EDGE(VR_PACKET_EDGE[4]),
     .VR_PACKET_TAG(VR_PACKET_TAG[( 5 * 160 - 1):( 4 * 160)]),
     .REGEN(REGEN_BUS[4]),
     .DATA_BUS(DATA_BUS_4),
     .MASK_BUS(MASK_BUS_4));
 
  LINEDRV #(Verbosity,HaltOnMismatch,5) U_LNDRV5
    (.PCLK(PCLK),
     .VIO_SEL(VIO_SEL[11:10]),
     .VR_PACKET_DATA(VR_PACKET_DATA[( 6 * 32 - 1):( 5 * 32)]),
     .VR_PACKET_MASK(VR_PACKET_MASK[( 6 * 32 - 1):( 5 * 32)]),
     .VR_PACKET_EXP(VR_PACKET_EXP[( 6 * 32 - 1):( 5 * 32)]),
     .VR_PACKET_PHASE(VR_PACKET_PHASE[5]),
     .VR_PACKET_EDGE(VR_PACKET_EDGE[5]),
     .VR_PACKET_TAG(VR_PACKET_TAG[( 6 * 160 - 1):( 5 * 160)]),
     .REGEN(REGEN_BUS[5]),
     .DATA_BUS(DATA_BUS_5),
     .MASK_BUS(MASK_BUS_5));
 
  LINEDRV #(Verbosity,HaltOnMismatch,6) U_LNDRV6
    (.PCLK(PCLK),
     .VIO_SEL(VIO_SEL[13:12]),
     .VR_PACKET_DATA(VR_PACKET_DATA[( 7 * 32 - 1):( 6 * 32)]),
     .VR_PACKET_MASK(VR_PACKET_MASK[( 7 * 32 - 1):( 6 * 32)]),
     .VR_PACKET_EXP(VR_PACKET_EXP[( 7 * 32 - 1):( 6 * 32)]),
     .VR_PACKET_PHASE(VR_PACKET_PHASE[6]),
     .VR_PACKET_EDGE(VR_PACKET_EDGE[6]),
     .VR_PACKET_TAG(VR_PACKET_TAG[( 7 * 160 - 1):( 6 * 160)]),
     .REGEN(REGEN_BUS[6]),
     .DATA_BUS(DATA_BUS_6),
     .MASK_BUS(MASK_BUS_6));
 
  LINEDRV #(Verbosity,HaltOnMismatch,7) U_LNDRV7
    (.PCLK(PCLK),
     .VIO_SEL(VIO_SEL[15:14]),
     .VR_PACKET_DATA(VR_PACKET_DATA[( 8 * 32 - 1):( 7 * 32)]),
     .VR_PACKET_MASK(VR_PACKET_MASK[( 8 * 32 - 1):( 7 * 32)]),
     .VR_PACKET_EXP(VR_PACKET_EXP[( 8 * 32 - 1):( 7 * 32)]),
     .VR_PACKET_PHASE(VR_PACKET_PHASE[7]),
     .VR_PACKET_EDGE(VR_PACKET_EDGE[7]),
     .VR_PACKET_TAG(VR_PACKET_TAG[( 8 * 160 - 1):( 7 * 160)]),
     .REGEN(REGEN_BUS[7]),
     .DATA_BUS(DATA_BUS_7),
     .MASK_BUS(MASK_BUS_7));
 
//  Instantiate eight virtual registers with output delays defined by 
//  vrgx_del
 
  VREG #(vrg0_del) U_REG0
    (.VREG_ENA(REGEN_BUS[0]),
     .VIO_SEL(VIO_SEL[1:0]),
     .DATA(DATA_BUS_0),
     .MASK(MASK_BUS_0),
     .VRG(VRG0));

  VREG #(vrg1_del) U_REG1
    (.VREG_ENA(REGEN_BUS[1]),
     .VIO_SEL(VIO_SEL[3:2]),
     .DATA(DATA_BUS_1),
     .MASK(MASK_BUS_1),
     .VRG(VRG1));

  VREG #(vrg2_del) U_REG2
    (.VREG_ENA(REGEN_BUS[2]),
     .VIO_SEL(VIO_SEL[5:4]),
     .DATA(DATA_BUS_2),
     .MASK(MASK_BUS_2),
     .VRG(VRG2));

  VREG #(vrg3_del) U_REG3
    (.VREG_ENA(REGEN_BUS[3]),
     .VIO_SEL(VIO_SEL[7:6]),
     .DATA(DATA_BUS_3),
     .MASK(MASK_BUS_3),
     .VRG(VRG3));

  VREG #(vrg4_del) U_REG4
    (.VREG_ENA(REGEN_BUS[4]),
     .VIO_SEL(VIO_SEL[9:8]),
     .DATA(DATA_BUS_4),
     .MASK(MASK_BUS_4),
     .VRG(VRG4));

  VREG #(vrg5_del) U_REG5
    (.VREG_ENA(REGEN_BUS[5]),
     .VIO_SEL(VIO_SEL[11:10]),
     .DATA(DATA_BUS_5),
     .MASK(MASK_BUS_5),
     .VRG(VRG5));

  VREG #(vrg6_del) U_REG6
    (.VREG_ENA(REGEN_BUS[6]),
     .VIO_SEL(VIO_SEL[13:12]),
     .DATA(DATA_BUS_6),
     .MASK(MASK_BUS_6),
     .VRG(VRG6));

  VREG #(vrg7_del) U_REG7
    (.VREG_ENA(REGEN_BUS[7]),
     .VIO_SEL(VIO_SEL[15:14]),
     .DATA(DATA_BUS_7),
     .MASK(MASK_BUS_7),
     .VRG(VRG7));

endmodule

// --============================= End ===============================--
