// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : tbench.v.rca
// File Revision       : 1.8
// 
// Release Information : PrimeCell(TM)-PL031-REL1v0
// 
// -----------------------------------------------------------------------------
// Purpose             : Top level of the Rtc Compliance TestBench
//
//                       This file instantiates the Rtc module, the Rtc trickbox
//                       and the Read Data Mux. In this test bench, the CLK1HZ
//                       frequency is set to be different from the PCLK
//                       frequency. Free-running tests should be run on this
//                       testbench. 
//                       
// --=========================================================================--

`timescale 1ns/1ps
`include "../tbench/timing.v"
`uselib lib=uut lib=trickbox
            
            
module tbench;

   // Test bench setup parameters
   
   parameter 
      PD_mask = 32'hFFFFFFFF,
      Verbosity = 0,
      HaltOnMismatch = 0;
      
  
     
  // --------------------------------------------------------------------------
  // If the XonPSEL define is set to '0' (default), an 'X' appearing
  // on the PSEL line, the PWRITE line or the PADDR lines will be converted
  // to '0'. If this define is set to '1', the PSEL, PWRITE and the PADDR
  // generated internally by the testbench are passed on unmodified.
  // --------------------------------------------------------------------------
  `define XonPSEL 1'b0

  wire        PCLK;
  wire        PRESETn;
  reg  [31:0] PADDR;
  wire        PWRITE;
  wire        PENABLE;
  wire        PSEL;
  wire [31:0] PRDATA;
  wire [31:0] PWDATA;
  wire [31:0] VRG0; 
  wire [31:0] VRG1; 
  wire [31:0] VRG2; 
  wire [31:0] VRG3; 
  wire [31:0] VRG4; 
  wire [31:0] VRG5; 
  wire [31:0] VRG6; 
  wire [31:0] VRG7; 
   
  wire        RTCINTR;
  wire        SCANMODE;
  wire        SCANINPCLK;         
  wire        SCANINCLK1HZ;          
  wire        SCANOUTPCLK;
  wire        SCANOUTCLK1HZ;      
  wire        SCANENABLE;       
  wire        CLK1HZ;
  wire        nRTCRST;
  wire        nPOR;
  wire        PSELT;
  wire        I_PSEL;
  wire        I_PSELT;
  wire        I_PWRITE;
  wire [31:0] I_PADDR;

  wire [31:0] PRDATA1;
  wire [31:0] PRDATA0;
  wire [31:0] RtcRdData;
  wire [15:0] TrickRdData;
 
  wire [31:0] ReadFill;

  integer     i; 

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Function declarations
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// Connect all the scan inputs to '0' to prevent interference with
// functional mode tests.
 assign SCANENABLE       = 1'b0;
 assign SCANINPCLK       = 1'b0;
 assign SCANINCLK1HZ     = 1'b0;
  
 assign ReadFill = 32'h00000000;
   
 // All the unconnected Virtual Register inputs should be set to zero:
 assign VRG0[31:0] = 32'h00000000;
 assign VRG1[31:0] = 32'h00000000;
 assign VRG2[31:0] = 32'h00000000;
 assign VRG3[31:0] = 32'h00000000;
 assign VRG4[31:0] = 32'h00000000;
 assign VRG5[31:0] = 32'h00000000;
 assign VRG6[31:0] = 32'h00000000;
 assign VRG7[31:0] = 32'h00000000;
   
 // Connect setup parameters to the test bench module
 defparam u_apbslv_tb.PRDATA_mask = PD_mask;
 defparam u_apbslv_tb.Verbosity = Verbosity;
 defparam u_apbslv_tb.HaltOnMismatch = HaltOnMismatch;
 defparam u_apbslv_tb.tclks = `Tclks;
 defparam u_apbslv_tb.tclkl = `Tclkl;
 defparam u_apbslv_tb.tclkh = `Tclkh; 
 
 assign PSELT = (!(`XonPSEL) && I_PSELT === 1'bx) ? 1'b0 : I_PSELT;
 assign PSEL  = (!(`XonPSEL) && I_PSEL === 1'bx)  ? 1'b0 : I_PSEL;
 assign PWRITE= (!(`XonPSEL) && I_PWRITE === 1'bx)  ? 1'b0 : I_PWRITE;

 always @(I_PADDR)
 begin
   for (i = 0; i < 32; i = i + 1)
     if ((`XonPSEL == 1'b0) && (I_PADDR[i] === 1'bx))
       PADDR[i] = 1'b0;
     else
       PADDR[i] = I_PADDR[i];
 end

  APBSLAVE_TB   u_apbslv_tb (
        .PRESETn           (PRESETn),
        .PCLK            (PCLK),
        .PADDR           (I_PADDR),
        .PWRITE          (I_PWRITE),
        .PENABLE         (PENABLE),
        .PSEL            (I_PSEL),
        .PSELT           (I_PSELT),
        .PRDATA          (PRDATA),
        .PWDATA          (PWDATA),
        .VRG0            (VRG0),
        .VRG1            (VRG1),
        .VRG2            (VRG2),
        .VRG3            (VRG3),
        .VRG4            (VRG4),
        .VRG5            (VRG5),
        .VRG6            (VRG6),
        .VRG7            (VRG7)
           );
 
  Rtc  uut (
        .PRESETn         (PRESETn),
        .PCLK            (PCLK),
        .PWRITE          (PWRITE),
        .PENABLE         (PENABLE),
        .PSEL            (PSEL),
        .PADDR           (PADDR[11:2]),
        .PWDATA          (PWDATA),
        .PRDATA          (RtcRdData),
        .CLK1HZ          (CLK1HZ),
        .nRTCRST         (nRTCRST),
        .nPOR            (nPOR),
        .SCANINPCLK      (SCANINPCLK),
        .SCANINCLK1HZ    (SCANINCLK1HZ),
        .SCANOUTPCLK     (SCANOUTPCLK),
        .SCANOUTCLK1HZ   (SCANOUTCLK1HZ),
        .SCANENABLE      (SCANMODE),   
        .RTCINTR         (RTCINTR)
        );

  RtcTrick  u_RtcTrick (
        .PRESETn         (PRESETn),
        .PCLK            (PCLK),
        .PWRITE          (PWRITE),
        .PENABLE         (PENABLE),
        .PSELT           (PSELT),
        .PADDR           (PADDR[7:2]),
        .PWData          (PWDATA[15:0]),
        .PRData          (TrickRdData),
        .CLK1HZ          (CLK1HZ),
        .nRTCRST         (nRTCRST),
        .nPOR            (nPOR),                
        .RTCINTR         (RTCINTR),
        .SCANMODE        (SCANMODE)
        );

  assign PRDATA0 = RtcRdData;
  assign PRDATA1 = {ReadFill[31:16], TrickRdData};

  apbmux   u_apbmux (
        .PCLK            (PCLK),
        .PRESETn         (PRESETn),
        .PSEL            (PSEL),
        .PSELT           (PSELT),
        .PRData0         (PRDATA0),
        .PRData1         (PRDATA1),
        .PRData          (PRDATA)
           );

  initial
  begin
    $timeformat(-9, 0, " ns", 9);
  end

  // include system task for best/worst case SDF delay annotation.
`ifdef NET_MAX
  initial
  begin
    $sdf_annotate("",uut,,,"MAXIMUM");
  end
  `endif
 
`ifdef NET_MIN
  initial
  begin
    $sdf_annotate("",uut,,,"MINIMUM");
  end
`endif

`ifdef NET_TYP
  initial
  begin
    $sdf_annotate("",uut,,,"TYPICAL");
  end
`endif

endmodule

// --================================= End ===================================--
