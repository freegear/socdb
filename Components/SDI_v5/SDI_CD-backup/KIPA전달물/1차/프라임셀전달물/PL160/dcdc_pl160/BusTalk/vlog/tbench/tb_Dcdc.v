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
// File Name           : tb_Dcdc.v,v 
// File Revision       : 1.2 
// 
// Release Information : PL160-REL1v1 
// 
// -----------------------------------------------------------------------------
// Purpose             : Top level of the Dcdc Compliance TestBench
//
//                       This file instantiates the APB Slave model and the Dcdc
//                       module. All clock-enabled tests should be run on
//                       this testbench. 
//                       
// --=========================================================================--

`timescale 1ns/1ps


module tb_Dcdc;

   // Test bench setup parameters
   
   parameter 
      PRDATA_mask = 32'hFFFFFFFF,
      Verbosity = 0,
      HaltOnMismatch = 0;
      
 `uselib lib=common lib=reader lib=buswatcher lib=bid lib=trickbox lib=uut

  wire BCLK;
  wire BNRES;
  wire nDCDCRST;
  wire SCANMODE;
  wire [31:0] PADDR;
  wire PWRITE;
  wire PSTB;
  wire PSEL;
  wire [31:0] PWDATA;
  wire [31:0] PRDATA;
  wire [7:0]  PRDATAint;   

  wire [31:0] VRG0, VRG1, VRG2, VRG3, VRG4, VRG5, VRG6, VRG7;
  wire DCDCDRIVE1IN;
  wire DCDCDRIVE0IN;
  wire DCDCFB1;
  wire DCDCFB0;
  wire DCDCDR1SEL;
  wire DCDCDR0SEL;
  wire DCDCDRIVEOE;
  wire DCDCDRIVE1OUT;
  wire DCDCDRIVE0OUT;
   
  wire  PENABLE;
  reg  inDCDCRST;


// Assign SCANMODE Status
assign SCANMODE = 1'b0;
assign nDCDCRST = inDCDCRST;

assign DCDCDRIVE1IN = 1'b0;
assign DCDCDRIVE0IN = 1'b0;
assign DCDCFB1 = 1'b1;
assign DCDCFB0 = 1'b1;
assign DCDCDR1SEL = 1'b0;
assign DCDCDR0SEL = 1'b0;

assign PRDATA = {24'h00_0000,PRDATAint};
   
// Connect setup parameters to the test bench module
   
defparam U_APBSLV_TB.PRDATA_mask = PRDATA_mask;
defparam U_APBSLV_TB.Verbosity = Verbosity;
defparam U_APBSLV_TB.HaltOnMismatch = HaltOnMismatch;


// Create nDCDCRST by Synchronizing BnRES

   always @(posedge BCLK or negedge BNRES)
      begin
         if (!BNRES)
            inDCDCRST <= 1'b0;
         
         else if (BCLK)
            inDCDCRST <= BNRES;
         
   
      end
   
   
 
  APBSLAVE_TB U_APBSLV_TB
     (.BNRES(BNRES),
     .BCLK(BCLK),
     .PADDR(PADDR),
     .PWRITE(PWRITE),
     .PENABLE(PENABLE),
     .PSEL(PSEL),
     .PRDATA(PRDATA),
     .PWDATA(PWDATA),
     .VRG0(VRG0), .VRG1(VRG1), .VRG2(VRG2), .VRG3(VRG3),
     .VRG4(VRG4), .VRG5(VRG5), .VRG6(VRG6), .VRG7(VRG7)
     );
 
  Dcdc  u_Dcdc
    (.DCDCCLK(BCLK),
     .PCLK(BCLK),
     .BnRES(BNRES),
     .nDCDCRST(nDCDCRST),
     .SCANMODE(SCANMODE),
     .PSEL(PSEL),
     .PENABLE(PENABLE),
     .PWRITE(PWRITE),
     .PADDR(PADDR[7:2]),
     .PWDATA(PWDATA[7:0]),
     .DCDCDRIVE1IN(DCDCDRIVE1IN),
     .DCDCDRIVE0IN(DCDCDRIVE0IN),
     .DCDCFB1(DCDCFB1),
     .DCDCFB0(DCDCFB0),
     .DCDCDR1SEL(DCDCDR1SEL),
     .DCDCDR0SEL(DCDCDR0SEL),
     .PRDATA(PRDATAint),
     .DCDCDRIVEOE(DCDCDRIVEOE),
     .DCDCDRIVE1OUT(DCDCDRIVE1OUT),
     .DCDCDRIVE0OUT(DCDCDRIVE0OUT)
     );

  initial
  begin
    $timeformat(-9, 0, " ns", 9);
  end

  // include system task for best/worst case SDF delay annotation.
  `ifdef NET_MAX
   initial
   begin
     $sdf_annotate("../../../verilog/uutNetlist/Dcdc_Verilog.sdf21",u_Dcdc,,,"MAXIMUM");
   end
  `endif

  `ifdef NET_MIN
   initial
   begin
     $sdf_annotate("../../../verilog/uutNetlist/Dcdc_Verilog.sdf21",u_Dcdc,,,"MINIMUM");
   end
  `endif

/*
// the following for Simwave output
initial
begin
    $recordfile("sysstd.trn",100);
    $recordvars("primitives","drivers");
end
*/

   
endmodule


