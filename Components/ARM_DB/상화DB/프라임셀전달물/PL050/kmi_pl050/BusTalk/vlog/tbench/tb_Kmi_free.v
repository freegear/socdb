//------------------------------------------------------------------------------
//  This confidential & proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  & copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//------------------------------------------------------------------------------
//  
//  Version & Release Control Information:
//
//  File Name              : tb_Kmi_free.v,v
//  File Revision          : 1.1
//
//  Release Information    : PL050-REL1v1
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//  Purpose      : Top level of the Kmi Compliance TestBench 
//
//                 This file instantiates the Kmi module, the Kmi trickbox
//                 & the Read Data Mux. In this test bench, the KMIREFCLK
//                 frequency may be set to be different from the PCLK frequency.
//                 Free-running tests should be run on this testbench.
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module tb_Kmi_free;

   // Test bench setup parameters
   parameter
      PD_mask = 32'hFFFFFFFF,
      Verbosity = 0,
      HaltOnMismatch = 0;
  
  `uselib lib=uut lib=trickbox

  //---------------------------------------------------------------------------
  // If the XonPSEL `define is set to 1'b0 (default), an 'X' appearing
  // on the PSEL line will be converted to 1'b0. If this `define is set
  // to 1'b1, the PSEL generated internally by the testbench is passed on
  // unmodified.
  //--------------------------------------------------------------------------
  `define XonPSEL  1'b0

  wire        BCLK;
  wire        PENABLE;
  wire        BnRES;
  reg  [31:0] PADDR;
  wire [31:0] I_PADDR;

  wire        PWRITE;
  wire        I_PWRITE;
  wire        PSEL;
  wire        I_PSEL;
  wire        PSELT;
  wire        I_PSELT;
  wire [31:0] PRDATA0;
  wire [31:0] PRDATA1;
  wire [31:0] PRDATA;
  wire [31:0] PWDATA;
  
  // Read Fill vector
  wire [31:0] ReadFill;
  
  wire [31:0] VRG0;
  wire [31:0] VRG1;
  wire [31:0] VRG2;
  wire [31:0] VRG3;
  wire [31:0] VRG4;
  wire [31:0] VRG5;
  wire [31:0] VRG6;
  wire [31:0] VRG7;

  wire [7:0]  KmiRdData;
  wire [15:0] TrickRdData;
  wire        KMIREFCLK;
  
  wire        SCANMODE;
  wire        KMICLKIN;
  wire        nKMIDATAEN;
  wire        KMIDATAIN;
  wire        nKMICLKEN;
  wire        KMITXINTR;
  wire        KMIRXINTR;
  wire        KMIINTR;
  wire        nKMIRST;
  
  wire        KCLK;
  wire        TKCLKout;

  wire        KDATA;
  wire        TKDATAout;

  integer     i;

  // Connect setup parameters to the test bench module
  defparam U_APBSLV_TB.PRDATA_mask = PD_mask;
  defparam U_APBSLV_TB.Verbosity = Verbosity;
  defparam U_APBSLV_TB.HaltOnMismatch = HaltOnMismatch;

  assign ReadFill = 32'h00000000;

  assign PSELT = (!(`XonPSEL) && I_PSELT === 1'bx) ? 1'b0 : I_PSELT;
  assign PSEL  = (!(`XonPSEL) && I_PSEL === 1'bx)  ? 1'b0 : I_PSEL;
  assign PWRITE  = (!(`XonPSEL) && I_PWRITE === 1'bx)  ? 1'b0 : I_PWRITE;
  
  always @(I_PADDR)
  begin
    for (i = 0; i < 32; i = i + 1)
      if ((`XonPSEL == 1'b0) && (I_PADDR[i] === 1'bx))
        PADDR[i] = 1'b0;
      else
        PADDR[i] = I_PADDR[i];
  end

  //  All the unconnected Virtual Register inputs should be set to zero:
  assign VRG0 = 32'h00000000;
  assign VRG1 = 32'h00000000;
  assign VRG2 = 32'h00000000;
  assign VRG3 = 32'h00000000;
  assign VRG4 = 32'h00000000;
  assign VRG5 = 32'h00000000;
  assign VRG6 = 32'h00000000;
  assign VRG7 = 32'h00000000;

  assign KCLK = (nKMICLKEN == 1'b0) ? 1'b0 :
                TKCLKout;

  assign KDATA = (nKMIDATAEN == 1'b0) ? 1'b0 :
                 TKDATAout;

  APBSLAVE_TB U_APBSLV_TB
           ( 
            .BNRES      (BnRES),
            .BCLK       (BCLK),
            .PADDR      (I_PADDR),
            .PWRITE     (I_PWRITE),
            .PENABLE    (PENABLE),
            .PSEL       (I_PSEL),
            .PSELT      (I_PSELT),
            .PRDATA     (PRDATA),
            .PWDATA     (PWDATA),
            .VRG0       (VRG0),
            .VRG1       (VRG1),
            .VRG2       (VRG2),
            .VRG3       (VRG3),
            .VRG4       (VRG4),
            .VRG5       (VRG5),
            .VRG6       (VRG6),
            .VRG7       (VRG7)
           );


  KmiTrick u_KmiTrick
           (
           .PCLK       (BCLK), 
           .BnRES      (BnRES),
           .PENABLE    (PENABLE),
           .PSELT      (PSELT),
           .PWRITE     (PWRITE), 
           .PADDR      (PADDR[7:2]),
           .PWDATA     (PWDATA[15:0]),
           .PRDATA     (TrickRdData[15:0]),
           .KMIREFCLK  (KMIREFCLK),
           .nKMIRST    (nKMIRST),
           .KCLKOUT    (TKCLKout),
           .KCLKIN     (KCLK),
           .KDATAOUT   (TKDATAout),
           .KDATAIN    (KDATA),
           .KMIRXINTR  (KMIRXINTR),
           .KMITXINTR  (KMITXINTR),
           .KMIINTR    (KMIINTR),
           .SCANMODE   (SCANMODE)
           );

   Kmi   u_Kmi
         (
         .PCLK        (BCLK),
         .KMIREFCLK   (KMIREFCLK),
         .BnRES       (BnRES),
	 .nKMIRST     (nKMIRST),
         .PSEL        (PSEL),
         .PENABLE     (PENABLE),
         .PWRITE      (PWRITE),
         .PADDRH      (PADDR[7:6]),
         .PADDRL      (PADDR[4:2]),
         .PWDATA      (PWDATA[7:0]),
         .PRDATA      (KmiRdData),
         .SCANMODE    (SCANMODE),
         .KMICLKIN    (KCLK),
         .KMIDATAIN   (KDATA),
         .nKMICLKEN   (nKMICLKEN),
         .nKMIDATAEN  (nKMIDATAEN),
         .KMITXINTR   (KMITXINTR),
         .KMIRXINTR   (KMIRXINTR),
         .KMIINTR     (KMIINTR)
         );
 
  assign PRDATA0 = {ReadFill[31:8], KmiRdData};
  assign PRDATA1 = {ReadFill[31:16], TrickRdData};

  apbmux    u_apbmux
            (
            .BCLK      (BCLK),
            .BNRES     (BnRES),
            .PSEL      (PSEL),
            .PSELT     (PSELT),
            .PRData0   (PRDATA0),
            .PRData1   (PRDATA1),
            .PRData    (PRDATA)
            );

  initial
  begin
    $timeformat(-9, 0, " ns", 9);
  end
 
  // include system task for best/worst case SDF delay annotation.
  `ifdef NET_MAX
  initial
  begin
    $sdf_annotate("../../../verilog/uutNetlist/Kmi_Verilog.sdf21",u_Kmi,,,"MAXIMUM");
  end
  `endif

  `ifdef NET_MIN
   initial
   begin
     $sdf_annotate("../../../verilog/uutNetlist/Kmi_Verilog.sdf21",u_Kmi,,,"MINIMUM");
   end
  `endif

endmodule
