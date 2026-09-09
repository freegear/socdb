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
// File Name           : vio_driver.v,v
// File Revision       : 1.3
// 
// Release Information : Rev1-3
// 
// ---------------------------------------------------------------------
// Purpose :
//           Virtual registers block structure
//
// --=================================================================--

`timescale 1ns/1ps
`include "../common/defs.v"

module VIODriver (HCLK,
                  VIOSel,
                  VRPacketVregno,
                  VRPacketData,
                  VRPacketMask,
                  VRPacketExp,
                  VRPacketWrite,
                  VRPacketPhase,
                  VRPacketEdge,
                  VRPacketDelay,
                  VRPacketTag,
                  VRG0,
                  VRG1,
                  VRG2,
                  VRG3,
                  VRG4,
                  VRG5,
                  VRG6,
                  VRG7
                 ); 
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
   
 
  input HCLK;
  input [8 * 2 - 1:0] VIOSel;
  input [8 * 3 - 1:0] VRPacketVregno;
  input [8 * 32 - 1:0] VRPacketData;
  input [8 * 32 - 1:0] VRPacketMask;
  input [8 * 32 - 1:0] VRPacketExp;
  input [7:0] VRPacketWrite;
  input [7:0] VRPacketPhase;
  input [7:0] VRPacketEdge;
  input [8 * 8 - 1:0] VRPacketDelay;
  input [8 * 160 - 1:0] VRPacketTag;

  inout [31:0] VRG0;
  inout [31:0] VRG1;
  inout [31:0] VRG2;
  inout [31:0] VRG3;
  inout [31:0] VRG4;
  inout [31:0] VRG5;
  inout [31:0] VRG6;
  inout [31:0] VRG7;

  wire [31:0] DataBus0;
  wire [31:0] DataBus1;
  wire [31:0] DataBus2;
  wire [31:0] DataBus3;
  wire [31:0] DataBus4;
  wire [31:0] DataBus5;
  wire [31:0] DataBus6;
  wire [31:0] DataBus7;
  wire [31:0] MaskBus0;
  wire [31:0] MaskBus1;
  wire [31:0] MaskBus2;
  wire [31:0] MaskBus3;
  wire [31:0] MaskBus4;
  wire [31:0] MaskBus5;
  wire [31:0] MaskBus6;
  wire [31:0] MaskBus7;
  wire [0:7] RegEnBus;
// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------
  
// Instantiate eight virtual register to packet interfaces, using
// appropriate slices of composite VR_PACKET data.

  linedrv #(Verbosity,HaltOnMismatch,0) u_linedriv0
    (.HCLK(HCLK),
     .VIOSel(VIOSel[1:0]),
     .VRPacketVregno(VRPacketVregno[2:0]),
     .VRPacketData(VRPacketData[31:0]),
     .VRPacketMask(VRPacketMask[31:0]),
     .VRPacketExp(VRPacketExp[31:0]),
     .VRPacketPhase(VRPacketPhase[0]),
     .VRPacketEdge(VRPacketEdge[0]),
     .VRPacketTag(VRPacketTag[(1 * 160 - 1):0]),
     .RegEn(RegEnBus[0]),
     .DataBus(DataBus0),
     .MaskBus(MaskBus0));
 
  linedrv #(Verbosity,HaltOnMismatch,1) u_linedriv1
    (.HCLK(HCLK),
     .VIOSel(VIOSel[3:2]),
     .VRPacketVregno(VRPacketVregno[( 2 * 3 - 1):( 1 * 3)]),
     .VRPacketData(VRPacketData[( 2 * 32 - 1):( 1 * 32)]),
     .VRPacketMask(VRPacketMask[( 2 * 32 - 1):( 1 * 32)]),
     .VRPacketExp(VRPacketExp[( 2 * 32 -1):( 1 * 32)]),
     .VRPacketPhase(VRPacketPhase[1]),
     .VRPacketEdge(VRPacketEdge[1]),
     .VRPacketTag(VRPacketTag[( 2 * 160 - 1):( 1 * 160 )]),
     .RegEn(RegEnBus[1]),
     .DataBus(DataBus1),
     .MaskBus(MaskBus1));
 
  linedrv #(Verbosity,HaltOnMismatch,2) u_linedriv2
    (.HCLK(HCLK),
     .VIOSel(VIOSel[5:4]),
     .VRPacketVregno(VRPacketVregno[( 3 * 3 - 1):( 2 * 3)]),
     .VRPacketData(VRPacketData[( 3 * 32 - 1):( 2 * 32)]),
     .VRPacketMask(VRPacketMask[( 3 * 32 - 1):( 2 * 32)]),
     .VRPacketExp(VRPacketExp[( 3 * 32 - 1):( 2 * 32)]),
     .VRPacketPhase(VRPacketPhase[2]),
     .VRPacketEdge(VRPacketEdge[2]),
     .VRPacketTag(VRPacketTag[( 3 * 160 - 1):( 2 * 160 )]),
     .RegEn(RegEnBus[2]),
     .DataBus(DataBus2),
     .MaskBus(MaskBus2));
 
  linedrv #(Verbosity,HaltOnMismatch,3) u_linedriv3
    (.HCLK(HCLK),
     .VIOSel(VIOSel[7:6]),
     .VRPacketVregno(VRPacketVregno[( 4 * 3 - 1):( 3 * 3)]),
     .VRPacketData(VRPacketData[( 4 * 32 - 1):( 3 * 32)]),
     .VRPacketMask(VRPacketMask[( 4 * 32 - 1):( 3 * 32)]),
     .VRPacketExp(VRPacketExp[( 4 * 32 - 1):( 3 * 32 )]),
     .VRPacketPhase(VRPacketPhase[3]),
     .VRPacketEdge(VRPacketEdge[3]),
     .VRPacketTag(VRPacketTag[( 4 * 160 - 1):( 3 * 160)]),
     .RegEn(RegEnBus[3]),
     .DataBus(DataBus3),
     .MaskBus(MaskBus3));
 
  linedrv #(Verbosity,HaltOnMismatch,4) u_linedriv4
    (.HCLK(HCLK),
     .VIOSel(VIOSel[9:8]),
     .VRPacketVregno(VRPacketVregno[( 5 * 3 - 1):( 4 * 3)]),
     .VRPacketData(VRPacketData[( 5 * 32 - 1):( 4 * 32)]),
     .VRPacketMask(VRPacketMask[( 5 * 32 - 1):( 4 * 32)]),
     .VRPacketExp(VRPacketExp[( 5 * 32 - 1):( 4 * 32)]),
     .VRPacketPhase(VRPacketPhase[4]),
     .VRPacketEdge(VRPacketEdge[4]),
     .VRPacketTag(VRPacketTag[( 5 * 160 - 1):( 4 * 160)]),
     .RegEn(RegEnBus[4]),
     .DataBus(DataBus4),
     .MaskBus(MaskBus4));
 
  linedrv #(Verbosity,HaltOnMismatch,5) u_linedriv5
    (.HCLK(HCLK),
     .VIOSel(VIOSel[11:10]),
     .VRPacketVregno(VRPacketVregno[( 6 * 3 - 1):( 5 * 3)]),
     .VRPacketData(VRPacketData[( 6 * 32 - 1):( 5 * 32)]),
     .VRPacketMask(VRPacketMask[( 6 * 32 - 1):( 5 * 32)]),
     .VRPacketExp(VRPacketExp[( 6 * 32 - 1):( 5 * 32)]),
     .VRPacketPhase(VRPacketPhase[5]),
     .VRPacketEdge(VRPacketEdge[5]),
     .VRPacketTag(VRPacketTag[( 6 * 160 - 1):( 5 * 160)]),
     .RegEn(RegEnBus[5]),
     .DataBus(DataBus5),
     .MaskBus(MaskBus5));
 
  linedrv #(Verbosity,HaltOnMismatch,6) u_linedriv6
    (.HCLK(HCLK),
     .VIOSel(VIOSel[13:12]),
     .VRPacketVregno(VRPacketVregno[( 7 * 3 - 1):( 6 * 3)]),
     .VRPacketData(VRPacketData[( 7 * 32 - 1):( 6 * 32)]),
     .VRPacketMask(VRPacketMask[( 7 * 32 - 1):( 6 * 32)]),
     .VRPacketExp(VRPacketExp[( 7 * 32 - 1):( 6 * 32)]),
     .VRPacketPhase(VRPacketPhase[6]),
     .VRPacketEdge(VRPacketEdge[6]),
     .VRPacketTag(VRPacketTag[( 7 * 160 - 1):( 6 * 160)]),
     .RegEn(RegEnBus[6]),
     .DataBus(DataBus6),
     .MaskBus(MaskBus6));
 
  linedrv #(Verbosity,HaltOnMismatch,7) u_linedriv7
    (.HCLK(HCLK),
     .VIOSel(VIOSel[15:14]),
     .VRPacketVregno(VRPacketVregno[( 8 * 3 - 1):( 7 * 3)]),
     .VRPacketData(VRPacketData[( 8 * 32 - 1):( 7 * 32)]),
     .VRPacketMask(VRPacketMask[( 8 * 32 - 1):( 7 * 32)]),
     .VRPacketExp(VRPacketExp[( 8 * 32 - 1):( 7 * 32)]),
     .VRPacketPhase(VRPacketPhase[7]),
     .VRPacketEdge(VRPacketEdge[7]),
     .VRPacketTag(VRPacketTag[( 8 * 160 - 1):( 7 * 160)]),
     .RegEn(RegEnBus[7]),
     .DataBus(DataBus7),
     .MaskBus(MaskBus7));
 
// Instantiate eight virtual registers with output delays defined
// by vrgx_del
 
  Reg #(vrg0_del) U_Reg0
    (.VRegEn(RegEnBus[0]),
     .VIOSel(VIOSel[1:0]),
     .Data(DataBus0),
     .Mask(MaskBus0),
     .VIO(VRG0));

  Reg #(vrg1_del) U_Reg1
    (.VRegEn(RegEnBus[1]),
     .VIOSel(VIOSel[3:2]),
     .Data(DataBus1),
     .Mask(MaskBus1),
     .VIO(VRG1));

  Reg #(vrg2_del) U_Reg2
    (.VRegEn(RegEnBus[2]),
     .VIOSel(VIOSel[5:4]),
     .Data(DataBus2),
     .Mask(MaskBus2),
     .VIO(VRG2));

  Reg #(vrg3_del) U_Reg3
    (.VRegEn(RegEnBus[3]),
     .VIOSel(VIOSel[7:6]),
     .Data(DataBus3),
     .Mask(MaskBus3),
     .VIO(VRG3));

  Reg #(vrg4_del) U_Reg4
    (.VRegEn(RegEnBus[4]),
     .VIOSel(VIOSel[9:8]),
     .Data(DataBus4),
     .Mask(MaskBus4),
     .VIO(VRG4));

  Reg #(vrg5_del) U_Reg5
    (.VRegEn(RegEnBus[5]),
     .VIOSel(VIOSel[11:10]),
     .Data(DataBus5),
     .Mask(MaskBus5),
     .VIO(VRG5));

  Reg #(vrg6_del) U_Reg6
    (.VRegEn(RegEnBus[6]),
     .VIOSel(VIOSel[13:12]),
     .Data(DataBus6),
     .Mask(MaskBus6),
     .VIO(VRG6));

  Reg #(vrg7_del) U_Reg7
    (.VRegEn(RegEnBus[7]),
     .VIOSel(VIOSel[15:14]),
     .Data(DataBus7),
     .Mask(MaskBus7),
     .VIO(VRG7));

endmodule

// --============================= End ===============================--
