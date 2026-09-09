//------------------------------------------------------------------------------
//  This confidential and proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  and copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//------------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//
//  File Name              : tb_Kmi.v,v
//  File Revision          : 1.1
//
//  Release Information    : PL050-REL1v1
//
//------------------------------------------------------------------------------
 
//------------------------------------------------------------------------------
//  Purpose          : Top level of the Kmi Compliance TestBench 
//
//                     This file instantiates the APB Slave model and the Kmi 
//                     module. In this test bench, the KMIREFCLK is fed from  
//                     the PCLK source. All clock-enabled tests should be run
//                     on this testbench.
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module tb_Kmi;

   // Test bench setup parameters
   parameter
      PD_mask = 32'hFFFFFFFF,
      Verbosity = 0,
      HaltOnMismatch = 0;
 
  `uselib lib=uut
 

  //---------------------------------------------------------------------------
  // If the XonPSEL `define is set to 1'b0 (default), an 'X' appearing
  // on the PSEL line will be converted to 1'b0. If this `define is set
  // to 1'b1, the PSEL generated internally by the testbench is passed on
  // unmodified.
  //---------------------------------------------------------------------------
  `define XonPSEL  1'b0

  wire        BCLK;
  wire        PENABLE;
  wire        BnRES;
  reg         nKMIRST;
  reg  [31:0] PADDR;
  wire [31:0] I_PADDR;
  wire        SCANMODE; 
       
  wire        PWRITE;
  wire        I_PWRITE;
  wire        PSEL; 
  wire        I_PSEL; 
  wire        PSELT; 
  wire [31:0] PRDATA;
  wire [31:0] PWDATA;
       
  wire        KMICLKIN;
  wire        KMIDATAIN;
  wire        nKMICLKEN;
  wire        nKMIDATAEN;
  wire        KMITXINTR;
  wire        KMIRXINTR;
  wire        KMIINTR;
  reg         nKMIRSTInt;
  wire [7:0]  KmiRdData;
        
  wire [31:0] VRG0;
  wire [31:0] VRG1;
  wire [31:0] VRG2;
  wire [31:0] VRG3;
  wire [31:0] VRG4;
  wire [31:0] VRG5;
  wire [31:0] VRG6;
  wire [31:0] VRG7;
       
  // Read Fill vector
  wire [31:0] ReadFill;
 
  integer i;
 
  assign ReadFill = 32'h00000000;
  
  assign PSEL = (`XonPSEL == 1'b0) && (I_PSEL === 1'bx) ? 1'b0 :
                I_PSEL ;
  assign PWRITE = (`XonPSEL == 1'b0) && (I_PWRITE === 1'bx) ? 1'b0 :
                I_PWRITE ;

  always @(I_PADDR)
  begin
    for (i = 0; i < 32; i = i + 1)
      if ((`XonPSEL == 1'b0) && (I_PADDR[i] === 1'bx))
        PADDR[i] = 1'b0;
      else
        PADDR[i] = I_PADDR[i];
  end
         
  // select functional mode
  assign SCANMODE  = 1'b0; 
  assign KMICLKIN  = 1'b1;
  assign KMIDATAIN = 1'b1;
  
  // All the unconnected Virtual Register inputs should be set to zero:
  assign VRG0  = 32'h00000000;
  assign VRG1  = 32'h00000000;
  assign VRG2  = 32'h00000000;
  assign VRG3  = 32'h00000000;
  assign VRG4  = 32'h00000000;
  assign VRG5  = 32'h00000000;
  assign VRG6  = 32'h00000000;
  assign VRG7  = 32'h00000000;

  // create nKMIRST by synchronizing BnRES
  always @(posedge BCLK or negedge BnRES)
  begin
    if (BnRES == 1'b0) 
    begin
      nKMIRSTInt <= 1'b0;
      nKMIRST    <= 1'b0;
    end
    else
    begin
      nKMIRSTInt <= BnRES;
      nKMIRST    <= nKMIRSTInt;
    end
  end

 // Connect setup parameters to the test bench module
 defparam U_APBSLV_TB.PRDATA_mask = PD_mask;
 defparam U_APBSLV_TB.Verbosity = Verbosity;
 defparam U_APBSLV_TB.HaltOnMismatch = HaltOnMismatch;

  APBSLAVE_TB  U_APBSLV_TB 
           ( 
            .BNRES      (BnRES),
            .BCLK       (BCLK),
            .PADDR      (I_PADDR),
            .PWRITE     (I_PWRITE),
            .PENABLE    (PENABLE),
            .PSEL       (I_PSEL),
            .PSELT      (PSELT),
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


// Note : KMIREFCLK and PCLK need to be fed from the APB bus clock during
//        production testing.
  Kmi u_Kmi
         (
         .PCLK        (BCLK),
         .KMIREFCLK   (BCLK),
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
         .KMICLKIN    (KMICLKIN),
         .KMIDATAIN   (KMIDATAIN),
         .nKMICLKEN   (nKMICLKEN),
         .nKMIDATAEN  (nKMIDATAEN),
         .KMITXINTR   (KMITXINTR),
         .KMIRXINTR   (KMIRXINTR),
         .KMIINTR     (KMIINTR)
         );
 
//Zero fill unused upper bits
assign PRDATA = {ReadFill[31:8], KmiRdData};

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
