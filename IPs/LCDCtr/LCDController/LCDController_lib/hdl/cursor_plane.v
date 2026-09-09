//
// Verilog Module LCDController_lib.cursor_plane.arch_name
//
// Created:
//          by - gundam.UNKNOWN (RND-D4E2566A1B1)
//          at - 16:56:03 2006-05-01
//
// using Mentor Graphics HDL Designer(TM) 2004.1 (Build 41)
//

`resetall
`timescale 1ns/10ps
module cursor_plane( 
   ADDR_reg, 
   CSb_reg2cur, 
   DATAREQb_MXR, 
   ENABLEb_reg, 
   LOC_X_MXR, 
   LOC_Y_MXR, 
   READDATAb_MXR2CUR, 
   WRb_reg, 
   data_reg, 
   hrstb_lcd, 
   mclk, 
   rstb, 
   vrstb_lcd, 
   BDATA_CUR2MXR, 
   GDATA_CUR2MXR, 
   RDATA_CUR2MXR, 
   WILLSENDb_CUR2MXR
);


// Internal Declarations

input  [15:2] ADDR_reg;
input         CSb_reg2cur;
input         DATAREQb_MXR;
input         ENABLEb_reg;
input  [11:0] LOC_X_MXR;
input  [11:0] LOC_Y_MXR;
input         READDATAb_MXR2CUR;
input         WRb_reg;
input  [31:0] data_reg;
input         hrstb_lcd;
input         mclk;
input         rstb;
input         vrstb_lcd;
output [7:0]  BDATA_CUR2MXR;
output [7:0]  GDATA_CUR2MXR;
output [7:0]  RDATA_CUR2MXR;
output        WILLSENDb_CUR2MXR;


wire [15:2] ADDR_reg;
wire CSb_reg2cur;
wire DATAREQb_MXR;
wire ENABLEb_reg;
wire [11:0] LOC_X_MXR;
wire [11:0] LOC_Y_MXR;
wire READDATAb_MXR2CUR;
wire WRb_reg;
wire [31:0] data_reg;
wire hrstb_lcd;
wire mclk;
wire rstb;
wire vrstb_lcd;
wire [7:0] BDATA_CUR2MXR;
wire [7:0] GDATA_CUR2MXR;
wire [7:0] RDATA_CUR2MXR;
wire WILLSENDb_CUR2MXR;
endmodule
