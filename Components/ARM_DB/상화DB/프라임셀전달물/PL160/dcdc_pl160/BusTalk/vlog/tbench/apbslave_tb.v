// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : apbslave_tb.v,v 
// File Revision       : 1.2 
// 
// Release Information : PL160-REL1v1 
// 
// -----------------------------------------------------------------------------
// Purpose             : APB Slave testbench module
// --=========================================================================--

module APBSLAVE_TB (BNRES, BCLK, PADDR, PWRITE, PENABLE, PSEL, PWDATA, PRDATA,
                    VRG0, VRG1, VRG2, VRG3, VRG4, VRG5, VRG6, VRG7);
   parameter
      INFILE = "",
      PRDATA_mask = 32'hFFFFFFFF,
      Verbosity = 0,
      HaltOnMismatch = 0; 

   `include "../common/defs.v"
   `include "../tbench/timing.v"
      
 `uselib dir=../common dir=../reader dir=../buswatcher dir=../bid dir=../trickbox dir=../../../verilog/uut

  output BNRES;
  output BCLK;
  output [31:0] PADDR;
  output PWRITE;
  output PENABLE;
  output PSEL;
  input  [31:0] PRDATA;
  output [31:0] PWDATA;
  inout [31:0] VRG0, VRG1, VRG2, VRG3, VRG4, VRG5, VRG6, VRG7;
  wire I_CLK;
  wire I_NRES;
  wire I_PWRITE;
  wire I_PSEL;
  wire I_PENABLE;

  // output packets from command reader
  wire [3:0] PCYC_SEL;
  wire [3:0] RCYC_SEL;
  wire [(8 * 4 - 1):0] VCYC_SEL;
  wire APB_PACKET_SEL;
  wire APB_PACKET_WRITE;
  wire [31:0] APB_PACKET_ADDR;
  wire [31:0] APB_PACKET_DATA;
  wire [31:0] APB_PACKET_MASK;
  wire [31:0] APB_PACKET_EXP;
  wire [7:0] APB_PACKET_NUM_CYC;
  wire [7:0] APB_PACKET_LIMIT;
  wire [159:0] APB_PACKET_TAG;
  wire [(8 * 3 - 1):0] VR_PACKET_VREGNO;
  wire [(8 * 32 - 1):0] VR_PACKET_DATA;
  wire [(8 * 32 - 1):0] VR_PACKET_MASK;
  wire [(8 * 32 - 1):0] VR_PACKET_EXP;
  wire [(8 - 1):0] VR_PACKET_WRITE;
  wire [(8 - 1):0] VR_PACKET_PHASE;
  wire [(8 - 1):0] VR_PACKET_EDGE;
  wire [(8 * 8 - 1):0] VR_PACKET_DELAY;
  wire [(8 * 160 - 1):0] VR_PACKET_TAG;
  wire RES_PACKET_PHASE;
  wire [7:0] RES_PACKET_DELAY;
  wire [7:0] RES_PACKET_NUM_CYC;
  wire POSTATI;

  wire APB_GET_LINE;
  wire VR_GET_LINE;
  wire [7:0] CYC_COUNT;
  wire PADDR_SEL;
  wire [2:0] PWDATA_SEL;
  wire PSEL_SEL;
  wire PWRITE_SEL;
  wire [1:0] PENABLE_SEL;
  wire [(8 * 2 - 1):0] VIO_SEL;
 
  assign BCLK = I_CLK;
  assign BNRES = I_NRES;
  assign PSEL = I_PSEL;
  assign PWRITE = I_PWRITE;
  assign PENABLE = I_PENABLE & I_NRES;

defparam U_WATCH.PRDATA_mask = PRDATA_mask;
   
  BUSWATCH  U_WATCH
    (.BNRES(I_NRES),
     .BCLK(I_CLK),
     .PWRITE(I_PWRITE),
     .PENABLE(I_PENABLE & I_NRES),
     .PRDATA(PRDATA),
     .PSEL(I_PSEL));

  READER  #(`Tclkl, `Tclkh) U_READER
    (.BCLK(I_CLK),
     .APB_GET_LINE(APB_GET_LINE),
     .VR_GET_LINE(VR_GET_LINE),
     .APB_PACKET_SEL(APB_PACKET_SEL),
     .APB_PACKET_WRITE(APB_PACKET_WRITE),
     .APB_PACKET_ADDR(APB_PACKET_ADDR),
     .APB_PACKET_DATA(APB_PACKET_DATA),
     .APB_PACKET_MASK(APB_PACKET_MASK),
     .APB_PACKET_EXP(APB_PACKET_EXP),
     .APB_PACKET_NUM_CYC(APB_PACKET_NUM_CYC),
     .APB_PACKET_LIMIT(APB_PACKET_LIMIT),
     .APB_PACKET_TAG(APB_PACKET_TAG),
     .VR_PACKET_VREGNO(VR_PACKET_VREGNO),
     .VR_PACKET_DATA(VR_PACKET_DATA),
     .VR_PACKET_MASK(VR_PACKET_MASK),
     .VR_PACKET_EXP(VR_PACKET_EXP),
     .VR_PACKET_WRITE(VR_PACKET_WRITE),
     .VR_PACKET_PHASE(VR_PACKET_PHASE),
     .VR_PACKET_EDGE(VR_PACKET_EDGE),
     .VR_PACKET_DELAY(VR_PACKET_DELAY),
     .VR_PACKET_TAG(VR_PACKET_TAG),
     .RES_PACKET_PHASE(RES_PACKET_PHASE),
     .RES_PACKET_DELAY(RES_PACKET_DELAY),
     .RES_PACKET_NUM_CYC(RES_PACKET_NUM_CYC),
     .PCYC_SEL(PCYC_SEL),
     .VCYC_SEL(VCYC_SEL),
     .RCYC_SEL(RCYC_SEL),
     .POSTAT(POSTAT));
 
  VIREGCYC_DRIVERS  U_VRCYCDRV
    (.BCLK(I_CLK),
     .CYC_SEL(VCYC_SEL),
     .VR_PACKET_WRITE(VR_PACKET_WRITE),
     .VR_PACKET_DELAY(VR_PACKET_DELAY),
     .CYC_COUNT(CYC_COUNT),
     .VREG_GET_LINE(VR_GET_LINE),
     .VIO_SEL(VIO_SEL));

defparam U_VIODRV.Verbosity = Verbosity;
defparam U_VIODRV.HaltOnMismatch = HaltOnMismatch;
   
  VIO_DRIVER #(`vrg0_del, `vrg1_del, `vrg2_del, `vrg3_del, 
               `vrg4_del, `vrg5_del, `vrg6_del, `vrg7_del) U_VIODRV
    (.BCLK(I_CLK),
     .VIO_SEL(VIO_SEL),
     .VR_PACKET_VREGNO(VR_PACKET_VREGNO),
     .VR_PACKET_DATA(VR_PACKET_DATA),
     .VR_PACKET_MASK(VR_PACKET_MASK),
     .VR_PACKET_EXP(VR_PACKET_EXP),
     .VR_PACKET_WRITE(VR_PACKET_WRITE),
     .VR_PACKET_PHASE(VR_PACKET_PHASE),
     .VR_PACKET_EDGE(VR_PACKET_EDGE),
     .VR_PACKET_DELAY(VR_PACKET_DELAY),
     .VR_PACKET_TAG(VR_PACKET_TAG),
     .VRG0(VRG0), .VRG1(VRG1), .VRG2(VRG2), .VRG3(VRG3),
     .VRG4(VRG4), .VRG5(VRG5), .VRG6(VRG6), .VRG7(VRG7));

defparam U_RESET.Verbosity = Verbosity;

  RESET_DRIVER  #(`Tclkl, `Tisnres, `Tihnres, `reset_del) U_RESET
    (.RES_SEL(RCYC_SEL),
     .BCLK(I_CLK),
     .RES_PACKET_PHASE(RES_PACKET_PHASE),
     .RES_PACKET_DELAY(RES_PACKET_DELAY),
     .RES_PACKET_NUM_CYC(RES_PACKET_NUM_CYC),
     .BNRES(I_NRES));
 
  CLOCKGEN  #(`Tclkh, `Tclkl) U_CLOCKGEN
    (.BCLK(I_CLK));
 
defparam U_BLINDRV.Verbosity = Verbosity;
defparam U_BLINDRV.HaltOnMismatch = HaltOnMismatch;

  BUSLINE_DRIVERS
    #(`Tclkh, `Tclkl, `Tispaddr, `Tihpaddr, `Tispw, `Tihpw, `Tispsel, 
      `Tihpsel, `Tispen, `Tihpen, `Tispdw, `Tihpdw) U_BLINDRV
    (.BNRES(I_NRES),
     .BCLK(I_CLK),
     .PADDR_SEL(PADDR_SEL),
     .PWDATA_SEL(PWDATA_SEL),
     .PSEL_SEL(PSEL_SEL),
     .PWRITE_SEL(PWRITE_SEL),
     .PENABLE_SEL(PENABLE_SEL),
     .APB_PACKET_SEL(APB_PACKET_SEL),
     .APB_PACKET_WRITE(APB_PACKET_WRITE),
     .APB_PACKET_ADDR(APB_PACKET_ADDR),
     .APB_PACKET_DATA(APB_PACKET_DATA),
     .APB_PACKET_MASK(APB_PACKET_MASK),
     .APB_PACKET_EXP(APB_PACKET_EXP),
     .APB_PACKET_NUM_CYC(APB_PACKET_NUM_CYC),
     .APB_PACKET_LIMIT(APB_PACKET_LIMIT),
     .APB_PACKET_TAG(APB_PACKET_TAG),
     .POSTATI(POSTATI),
     .POSTATO(POSTATO),
     .CYC_SEL(PCYC_SEL),
     .PADDR(PADDR),
     .PRDATA(PRDATA),
     .PWDATA(PWDATA),
     .PSEL(I_PSEL),
     .PWRITE(I_PWRITE),
     .PENABLE(I_PENABLE));

defparam U_BCYCDRV.Verbosity = Verbosity;
   
  BUSCYC_DRIVERS  U_BCYCDRV
    (.BCLK(I_CLK),
     .BNRES(I_NRES),
     .CYC_SEL(PCYC_SEL),
     .APB_PACKET_SEL(APB_PACKET_SEL),
     .APB_PACKET_WRITE(APB_PACKET_WRITE),
     .APB_PACKET_ADDR(APB_PACKET_ADDR),
     .APB_PACKET_DATA(APB_PACKET_DATA),
     .APB_PACKET_MASK(APB_PACKET_MASK),
     .APB_PACKET_EXP(APB_PACKET_EXP),
     .APB_PACKET_NUM_CYC(APB_PACKET_NUM_CYC),
     .APB_PACKET_TAG(APB_PACKET_TAG),
     .POSTAT(POSTAT),
     .POSTATI(POSTATI),
     .APB_GET_LINE(APB_GET_LINE),
     .PADDR_SEL(PADDR_SEL),
     .PWDATA_SEL(PWDATA_SEL),
     .PSEL_SEL(PSEL_SEL),
     .PWRITE_SEL(PWRITE_SEL),
     .PENABLE_SEL(PENABLE_SEL),
     .CYC_COUNT(CYC_COUNT));

endmodule

// --================================= End ===================================--
