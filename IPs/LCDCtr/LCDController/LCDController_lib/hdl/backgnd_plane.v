//
// Verilog Module LCDController_lib.backgnd_plane.arch_name
//
// Created:
//          by - gundam.UNKNOWN (RND-D4E2566A1B1)
//          at - 17:00:06 2006-05-01
//
// using Mentor Graphics HDL Designer(TM) 2004.1 (Build 41)
//

`resetall
`timescale 1ns/10ps
module backgnd_plane( 
   ADDR_reg, 
   CSb_reg2bg, 
   ENABLEb_reg, 
   WRb_reg, 
   data_reg, 
   mclk, 
   rstb, 
   BDATAb_BG2MXR, 
   GDATAb_BG2MXR, 
   RDATAb_BG2MXR
);


// Internal Declarations

input  [15:2] ADDR_reg;
input         CSb_reg2bg;
input         ENABLEb_reg;
input         WRb_reg;
input  [31:0] data_reg;
input         mclk;
input         rstb;
output [7:0]  BDATAb_BG2MXR;
output [7:0]  GDATAb_BG2MXR;
output [7:0]  RDATAb_BG2MXR;


wire [15:2] ADDR_reg;
wire CSb_reg2bg;
wire ENABLEb_reg;
wire WRb_reg;
wire [31:0] data_reg;
wire mclk;
wire rstb;
wire [7:0] BDATAb_BG2MXR;
wire [7:0] GDATAb_BG2MXR;
wire [7:0] RDATAb_BG2MXR;
endmodule
