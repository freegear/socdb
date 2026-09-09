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
// File Name              : tbench.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-PL061-REL1v0
//
// ---------------------------------------------------------------------
// Purpose : Top level of the GPIO Compliance TestBench
//           This file instantiates the GPIO module, the GPIO trickbox
//           and the Read Data Mux.
//           Free-running tests should be run on this testbench.
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
//  Top level testbench.This file integrates the GPIO, GPIO trickbox and
// the APB interface modules to enable system level testing.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// If the XonPSEL constant is set to '0' (default), an 1'bX appearing
// on the PSEL line will be converted to '0'. If this constant is set
// to '1', the PSEL generated internally by the testbench is passed on
// unmodified.
// ---------------------------------------------------------------------
`define XonPSEL                  1'b0

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        PCLK;
wire        PENABLE;
wire        PRESETn;
wire [31:0] I_PADDR;

wire        PWRITE;
wire        PSEL;
wire        I_PSEL;
wire        I_PWRITE;
wire        PSELT;
wire        I_PSELT;
wire [31:0] PRDATA0;
wire [31:0] PRDATA1;
wire [31:0] PRDATA;
wire [31:0] PWDATA;
wire [7:0]  nGPEN;
wire [7:0]  GPOUT;
wire [7:0]  GPIN;
wire [7:0]  nGPAFEN;
wire [7:0]  GPAFOUT;
wire [7:0]  GPAFIN;
wire        GPIOINTR;
wire [7:0]  GPIOMIS;

// Read Fill vector
wire [31:0] ReadFill;
wire [7:0]  GpioRdData;
wire [7:0]  TrickRdData;

wire [31:0] VRG0;
wire [31:0] VRG1;
wire [31:0] VRG2;
wire [31:0] VRG3;
wire [31:0] VRG4;
wire [31:0] VRG5;
wire [31:0] VRG6;
wire [31:0] VRG7;

// Scan related signals
wire        SCANENABLE;
wire        SCANINPCLK;
wire        SCANOUTPCLK;

integer     i;

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg  [31:0] PADDR;

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

assign ReadFill = 32'b00000000000000000000000000000000;

assign PSEL             = (`XonPSEL == 1'b0 && I_PSEL === 1'bX) ? 1'b0 :
                           I_PSEL;
assign PSELT            = (`XonPSEL == 1'b0 && I_PSELT === 1'bX) ? 1'b0 :
                           I_PSELT;
assign PWRITE           = (`XonPSEL == 1'b0 && I_PWRITE === 1'bX) ? 
                            1'b0 : I_PWRITE;

always @(I_PADDR)
begin : p_PADDR
  for(i=0;i<=31;i=i+1)
  begin
   if ((`XonPSEL == 1'b0) && (I_PADDR[i] === 1'bX))
     PADDR[i] = 1'b0;
   else
     PADDR[i] = I_PADDR[i];
  end
end // p_PADDR

// All the unconnected Virtual Register inputs should be set to zero:
assign VRG0 [31:0]      = 32'h00000000;
assign VRG1 [31:0]      = 32'h00000000;
assign VRG2 [31:0]      = 32'h00000000;
assign VRG3 [31:0]      = 32'h00000000;
assign VRG4 [31:0]      = 32'h00000000;
assign VRG5 [31:0]      = 32'h00000000;
assign VRG6 [31:0]      = 32'h00000000;
assign VRG7 [31:0]      = 32'h00000000;

defparam u_apbslv_tb.PRDATA_mask = 32'hFFFFFFFF;
defparam u_apbslv_tb.INFILE = "infile.bif";
defparam u_apbslv_tb.Verbosity = 0;
defparam u_apbslv_tb.HaltOnMismatch = 0;
defparam u_apbslv_tb.tclks = `Tclks;
defparam u_apbslv_tb.tclkl = `Tclkl;
defparam u_apbslv_tb.tclkh = `Tclkh;

APBSLAVE_TB u_apbslv_tb               (
                    .PRESETn          (PRESETn),
                    .PCLK             (PCLK),
                    .PADDR            (I_PADDR),
                    .PWRITE           (I_PWRITE),
                    .PENABLE          (PENABLE),
                    .PSEL             (I_PSEL),
                    .PSELT            (I_PSELT),
                    .PRDATA           (PRDATA),
                    .PWDATA           (PWDATA),
                    .VRG0             (VRG0),
                    .VRG1             (VRG1),
                    .VRG2             (VRG2),
                    .VRG3             (VRG3),
                    .VRG4             (VRG4),
                    .VRG5             (VRG5),
                    .VRG6             (VRG6),
                    .VRG7             (VRG7)
                    );
Gpio uut                              (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSEL),
                    .PENABLE          (PENABLE),
                    .PWRITE           (PWRITE),
                    .PADDR            (PADDR[11:2]),
                    .PWDATA           (PWDATA[7:0]),
                    .nGPEN            (nGPEN),
                    .GPOUT            (GPOUT),
                    .GPIN             (GPIN),
                    .nGPAFEN          (nGPAFEN),
                    .GPAFOUT          (GPAFOUT),
                    .GPAFIN           (GPAFIN),
                    .GPIOINTR         (GPIOINTR),
                    .GPIOMIS          (GPIOMIS),
                    .SCANENABLE       (SCANENABLE),
                    .SCANINPCLK       (SCANINPCLK),
                    .SCANOUTPCLK      (SCANOUTPCLK),
                    .PRDATA           (GpioRdData)
                   );

GpioTrick  u_GpioTrick                (
                    .PCLK             (PCLK),
                    .PENABLE          (PENABLE),
                    .PSELT            (PSELT),
                    .PWRITE           (PWRITE),
                    .PA               (PADDR[7:2]),
                    .PWData           (PWDATA[7:0]),
                    .PRData           (TrickRdData[7:0]),
                    .nGPEN            (nGPEN),
                    .GPOUT            (GPOUT),
                    .GPIN             (GPIN),
                    .PRESETn          (PRESETn),
                    .nGPAFEN          (nGPAFEN),
                    .GPAFOUT          (GPAFOUT),
                    .GPAFIN           (GPAFIN),
                    .GPIOINTR         (GPIOINTR),
                    .GPIOMIS          (GPIOMIS)
                   );
 
assign  PRDATA0 = {ReadFill[31:8], GpioRdData};
assign  PRDATA1 = {ReadFill[31:8], TrickRdData};

apbmux u_apbmux                       (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSEL),
                    .PSELT            (PSELT),
                    .PRData0          (PRDATA0),
                    .PRData1          (PRDATA1),
                    .PRData           (PRDATA)
                    );

// ---------------------------------------------------------------------
// SDF annotation for the netlist simulation
// ---------------------------------------------------------------------
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

// ---------------------------------------------------------------------
// Dumping the vcd file for wave form viewing
// ---------------------------------------------------------------------
//initial
//begin
//  $dumpvars();
//  $dumpfile("/dump/arm/satishb/gpio.vcd");
//end

endmodule
// --============================== End ==============================--
