// --================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// --------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : tbench.v.rca 
// File Revision       : 1.2 
// 
// Release Information : PrimeCell(TM)-PL131-REL1v0 
// 
// ---------------------------------------------------------------------
// Purpose : Top level of the Sci Compliance TestBench
//           This file instantiates the Sci module, the Sci trickbox
//           and the Read Data Mux.
//
// --=================================================================--

`timescale 1ns/1ps
`include "../tbench/timing.v"
`uselib lib=uut lib=trickbox

module tbench ();

// ---------------------------------------------------------------------
//
//                               tbench
//                               ======
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//  Top level testbench.This file integrates the Sci, Sci trickbox and
//  the APB interface modules to enable system level testing.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// -----------------------------------------------------------------------------
// If the XonPSEL define is set to '0' (default), an 'X' appearing
// on the PSEL line will be converted to '0'. If this define is set
// to '1', the PSEL generated internally by the testbench is passed on
// unmodified.
// -----------------------------------------------------------------------------
`define XonPSEL 1'b0

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------      
reg   [31:0]  PADDR;

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------      
wire          PCLK;
wire          PENABLE;
wire          PRESETn;
wire  [31:0]  I_PADDR;
                                                              
wire          PWRITE;
wire          PSEL; 
wire          I_PSEL; 
wire          I_PWRITE; 
wire          PSELT; 
wire          I_PSELT; 
wire  [31:0]  PRDATA0;
wire  [31:0]  PRDATA1;
wire  [31:0]  PRDATA;
wire          SCIDEACACK;
wire  [31:0]  PWDATA;
wire          nSCIRST;

wire          SCICLK; 
wire          SCIDATAIN; 
wire          SCICLKIN; 
wire          SCIDETECT; 
wire          SCIDEACREQ; 
wire          SCITXDMACLR;
wire          SCIRXDMACLR;

wire          SCANENABLE;
wire          SCANINPCLK;
wire          SCANINSCICLK;

wire          nSCIDATAOUTEN; 
wire          nSCIDATAEN;	
wire          nSCIDATAIN; 
wire          SCICLKOUT; 
wire          nSCICLKOUTEN;
wire          nSCICLKEN;
wire          nSCICARDRST; 
wire          SCIFCB;
wire          SCIVCCEN;
wire          SCICARDININTR;

wire          SCICARDOUTINTR;
wire          SCICARDUPINTR;
wire          SCICARDDNINTR;
wire          SCITXERRINTR;

wire          SCIATRSTOUTINTR;
wire          SCIATRDTOUTINTR;
wire          SCIBLKTOUTINTR;
wire          SCICHTOUTINTR;
wire          SCITXTIDEINTR;
wire          SCIRXTIDEINTR;
wire          SCIRTOUTINTR;
wire          SCIRORINTR;
wire          SCICLKSTPINTR;
wire          SCICLKACTINTR;
wire          SCIINTR;
wire          SCITXDMASREQ;
wire          SCITXDMABREQ;
wire          SCIRXDMASREQ;
wire          SCIRXDMABREQ;
wire          SCANOUTPCLK;
wire          SCANOUTSCICLK;

// Read Fill vector
wire  [31:0]  ReadFill;

wire  [31:0]  VRG0;
wire  [31:0]  VRG1;
wire  [31:0]  VRG2;
wire  [31:0]  VRG3;
wire  [31:0]  VRG4;
wire  [31:0]  VRG5;
wire  [31:0]  VRG6;
wire  [31:0]  VRG7;

wire  [15:0]  SciRdData;
wire  [15:0]  TrickRdData;

wire          TSCICLKout;

wire          SCIDATA;
wire          TSCIDATAout;

wire          IntSciClkout; 

wire          ClockContention; 
wire          DataContention;

wire          DelayednSCIRST;

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

assign SCANINSCICLK  = 1'b0;
assign SCANINPCLK    = 1'b0;
assign SCANENABLE    = 1'b0;

assign ReadFill      = 32'b00000000;

// -----------------------------------------------------------------------------
// All the unconnected Virtual Register inputs should be set to zero:
// -----------------------------------------------------------------------------
assign VRG0[31:0] = 32'h00000000;
assign VRG1[31:0] = 32'h00000000;
assign VRG2[31:0] = 32'h00000000;
assign VRG3[31:0] = 32'h00000000;
assign VRG4[31:0] = 32'h00000000;
assign VRG5[31:0] = 32'h00000000;
assign VRG6[31:0] = 32'h00000000;
assign VRG7[31:0] = 32'h00000000;
 
// Connect setup parameters to the test bench module
// defparam U_APBSLV_TB.PRDATA_mask = PD_mask;
// defparam U_APBSLV_TB.Verbosity = Verbosity;
// defparam U_APBSLV_TB.HaltOnMismatch = HaltOnMismatch;
 
// -----------------------------------------------------------------------------
// Use XonPSEL to propagate X on the APB Bus signals.
// -----------------------------------------------------------------------------
assign PSELT  = (!(`XonPSEL) && I_PSELT === 1'bx) ? 1'b0 : I_PSELT;
assign PSEL   = (!(`XonPSEL) && I_PSEL === 1'bx)  ? 1'b0 : I_PSEL;
assign PWRITE = (!(`XonPSEL) && I_PWRITE === 1'bx)  ? 1'b0 : I_PWRITE;
 
always @(I_PADDR)
begin : p_PADDR
  for (i = 0; i < 32; i = i + 1)
    if ((`XonPSEL == 1'b0) && (I_PADDR[i] === 1'bx))
      PADDR[i] = 1'b0;
    else
      PADDR[i] = I_PADDR[i];
end // p_PADDR

assign SCICLKIN = (nSCICLKEN == 1'b0) ? IntSciClkout : TSCICLKout;

assign SCIDATAIN = (nSCIDATAEN == 1'b0) ? nSCIDATAOUTEN : TSCIDATAout;
 
assign DataContention  = (~nSCIDATAEN) & (~TSCIDATAout);
assign ClockContention = (~nSCICLKEN) & (~TSCICLKout);
 
always @(DataContention or ClockContention)
begin : p_Contention
  if (DataContention == 1'b1)
     $display($time,"Contention on SCIDATA line");
 
   if (ClockContention == 1'b1)
     $display($time,"Contention on SCICLOCK line");
end // p_Contention
 
assign IntSciClkout = nSCICLKOUTEN ^ SCICLKOUT;

// -----------------------------------------------------------------------------
// Connect setup parameters to the test bench module
// -----------------------------------------------------------------------------
 
// -----------------------------------------------------------------------------
// Delay nSCIRST from rising edge of SCICLK
// -----------------------------------------------------------------------------

assign #1 DelayednSCIRST = nSCIRST;

//defparam u_apbslv_tb.PRDATA_mask = 32'hFFFFFFFF;
//defparam u_apbslv_tb.INFILE = "infile.bif";
//defparam u_apbslv_tb.Verbosity = 0;
//defparam u_apbslv_tb.HaltOnMismatch = 0;
//defparam u_apbslv_tb.tclks = `Tclks;
//defparam u_apbslv_tb.tclkl = `Tclkl;
//defparam u_apbslv_tb.tclkh = `Tclkh;
 
// -----------------------------------------------------------------------------
// APB Slave testbench instantiation
// -----------------------------------------------------------------------------
APBSLAVE_TB u_apbslv_tb (
            .PRESETn                (PRESETn),
            .PCLK                   (PCLK),
            .PADDR                  (I_PADDR),
            .PWRITE                 (I_PWRITE),
            .PENABLE                (PENABLE),
            .PSEL                   (I_PSEL),
            .PSELT                  (I_PSELT),
            .PWDATA                 (PWDATA),
            .PRDATA                 (PRDATA),
            .VRG0                   (VRG0), 
            .VRG1                   (VRG1),
            .VRG2                   (VRG2),
            .VRG3                   (VRG3),
            .VRG4                   (VRG4),
            .VRG5                   (VRG5),
            .VRG6                   (VRG6),
            .VRG7                   (VRG7)
            );
 
// -----------------------------------------------------------------------------
// Sci instantiation
// -----------------------------------------------------------------------------

Sci uut    (
// Inputs
            .PCLK                   (PCLK),
            .SCICLK                 (SCICLK),
            .PRESETn                (PRESETn),
            .nSCIRST                (DelayednSCIRST),
            .PSEL                   (PSEL),
            .PENABLE                (PENABLE),
            .PWRITE                 (PWRITE),
            .PADDR                  (PADDR[11:2]),
            .PWDATA                 (PWDATA[15:0]),
            .SCIDATAIN              (SCIDATAIN),
            .SCICLKIN               (SCICLKIN), 
            .SCIDETECT              (SCIDETECT),
            .SCIDEACREQ             (SCIDEACREQ),

            .SCITXDMACLR            (SCITXDMACLR),
            .SCIRXDMACLR            (SCIRXDMACLR),

            .SCANENABLE             (SCANENABLE), 
            .SCANINPCLK             (SCANINPCLK), 
            .SCANINSCICLK           (SCANINSCICLK),

// Outputs
            .nSCIDATAOUTEN          (nSCIDATAOUTEN),
            .nSCIDATAEN             (nSCIDATAEN),
            .SCICLKOUT              (SCICLKOUT),
            .nSCICLKOUTEN           (nSCICLKOUTEN),
            .nSCICLKEN              (nSCICLKEN),
            .nSCICARDRST            (nSCICARDRST),
            .SCIFCB                 (SCIFCB),     
            .SCIVCCEN               (SCIVCCEN),

            .SCIDEACACK             (SCIDEACACK),
            .PRDATA                 (SciRdData),

            .SCICARDININTR          (SCICARDININTR),
            .SCICARDOUTINTR         (SCICARDOUTINTR),
            .SCICARDUPINTR          (SCICARDUPINTR),
            .SCICARDDNINTR          (SCICARDDNINTR),
            .SCITXERRINTR           (SCITXERRINTR),
            .SCIATRSTOUTINTR        (SCIATRSTOUTINTR),
            .SCIATRDTOUTINTR        (SCIATRDTOUTINTR),
            .SCIBLKTOUTINTR         (SCIBLKTOUTINTR),
            .SCICHTOUTINTR          (SCICHTOUTINTR),
            .SCIRTOUTINTR           (SCIRTOUTINTR),
            .SCIRORINTR             (SCIRORINTR),   
            .SCICLKSTPINTR          (SCICLKSTPINTR),
            .SCICLKACTINTR          (SCICLKACTINTR),
            .SCITXTIDEINTR          (SCITXTIDEINTR),
            .SCIRXTIDEINTR          (SCIRXTIDEINTR),

            .SCIINTR                (SCIINTR),
 

            .SCITXDMASREQ           (SCITXDMASREQ),
            .SCITXDMABREQ           (SCITXDMABREQ),
            .SCIRXDMASREQ           (SCIRXDMASREQ),
            .SCIRXDMABREQ           (SCIRXDMABREQ),
            
            .SCANOUTPCLK            (SCANOUTPCLK), 
            .SCANOUTSCICLK          (SCANOUTSCICLK)
             );

// -----------------------------------------------------------------------------
// Trickbox instantiation
// -----------------------------------------------------------------------------
SciTrick  u_SciTrick (
// APB bus signals
            .PCLK                   (PCLK),
            .PRESETn                (PRESETn),
            .PENABLE                (PENABLE),
            .PSELT                  (PSELT),
            .PWRITE                 (PWRITE),
            .PADDR                  (PADDR[7:2]),
            .PWDATA                 (PWDATA[15:0]),
            .PRDATA                 (TrickRdData),
            .SCICLK                 (SCICLK),
            .nSCIRST                (nSCIRST),
            .SCIFCB                 (SCIFCB),
            .SCIDETECT              (SCIDETECT),
            .SCIVCCEN               (SCIVCCEN),
            .nSCICARDRST            (nSCICARDRST),
            .SCICLKOUT              (TSCICLKout),    
            .SCICLKIN               (SCICLKIN),
            .SCIDATAOUT             (TSCIDATAout), 
            .SCIDATAIN              (SCIDATAIN), 
            .SCICARDININTR          (SCICARDININTR),
            .SCICARDOUTINTR         (SCICARDOUTINTR),
            .SCICARDUPINTR          (SCICARDUPINTR),
            .SCICARDDNINTR          (SCICARDDNINTR),
            .SCITXERRINTR           (SCITXERRINTR),
            .SCIATRSTOUTINTR        (SCIATRSTOUTINTR),
            .SCIATRDTOUTINTR        (SCIATRDTOUTINTR),
            .SCIBLKTOUTINTR         (SCIBLKTOUTINTR),
            .SCICHTOUTINTR          (SCICHTOUTINTR),
            .SCITXTIDEINTR          (SCITXTIDEINTR),
            .SCIRXTIDEINTR          (SCIRXTIDEINTR),
            .SCIRTOUTINTR           (SCIRTOUTINTR),
            .SCIRORINTR             (SCIRORINTR),
            .SCICLKSTPINTR          (SCICLKSTPINTR),
            .SCICLKACTINTR          (SCICLKACTINTR),
            .SCIINTR                (SCIINTR),
            .SCIDEACACK             (SCIDEACACK), 
            .SCIDEACREQ             (SCIDEACREQ),
            .SCITXDMASREQ           (SCITXDMASREQ),
            .SCITXDMABREQ           (SCITXDMABREQ),
            .SCIRXDMASREQ           (SCIRXDMASREQ),
            .SCIRXDMABREQ           (SCIRXDMABREQ),
            .SCITXDMACLR            (SCITXDMACLR),
            .SCIRXDMACLR            (SCIRXDMACLR)
             );

assign PRDATA0 = {ReadFill[31:16], SciRdData};
assign PRDATA1 = {ReadFill[31:16], TrickRdData};

// -----------------------------------------------------------------------------
// APB Read Data mux 
// -----------------------------------------------------------------------------
apbmux  u_apbmux (
            .PCLK                   (PCLK),
            .PRESETn                (PRESETn),
            .PSEL                   (PSEL),
            .PSELT                  (PSELT),
            .PRData0                (PRDATA0),
            .PRData1                (PRDATA1),
            .PRData                 (PRDATA)
                );
initial
begin
  $timeformat(-9, 0, " ns", 9);
end

// -----------------------------------------------------------------------------
// Include system task for best/worst case SDF delay annotation.
// -----------------------------------------------------------------------------
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

/*
initial
begin
  $dumpvars();
  $dumpfile("Scinet.vcd");
end
*/

endmodule

// --================================= End ===================================--
