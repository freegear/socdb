//
// Verilog Module LCDController_lib.layer_mixer_block.arch_name
//
// Created:
//          by - gundam.UNKNOWN (RND-D4E2566A1B1)
//          at - 16:54:50 2006-05-01
//
// using Mentor Graphics HDL Designer(TM) 2004.1 (Build 41)
//

`resetall
`timescale 1ns/10ps
module layer_mixer_block( 
   ADATA_L0P2MXR, 
   ADDR_reg, 
   BDATA_CUR2MXR, 
   BDATA_L0P2MXR, 
   BDATAb_BG2MXR, 
   CSb_reg2mxr, 
   DREADY_L0P2MXR, 
   ENABLEb_reg, 
   GDATA_CUR2MXR, 
   GDATA_L0P2MXR, 
   GDATAb_BG2MXR, 
   RDATA_CUR2MXR, 
   RDATA_L0P2MXR, 
   RDATAb_BG2MXR, 
   WILLSENDb_CUR2MXR, 
   WILLSENDb_L0P2MXR, 
   WRb_reg, 
   data_reg, 
   dread_lcd2mxr, 
   mclk, 
   rstb, 
   DATAREQb_MXR, 
   DREADb_MXR2L0P, 
   LOC_X_MXR, 
   LOC_Y_MXR, 
   READDATAb_MXR2CUR, 
   bdata_mxr2lcd, 
   dvalidb_mxr2lcd, 
   gdata_mxr2lcd, 
   rdata_mxr2lcd
);


// Internal Declarations

input  [7:0]  ADATA_L0P2MXR;
input  [15:2] ADDR_reg;
input  [7:0]  BDATA_CUR2MXR;
input  [7:0]  BDATA_L0P2MXR;
input  [7:0]  BDATAb_BG2MXR;
input         CSb_reg2mxr;
input         DREADY_L0P2MXR;
input         ENABLEb_reg;
input  [7:0]  GDATA_CUR2MXR;
input  [7:0]  GDATA_L0P2MXR;
input  [7:0]  GDATAb_BG2MXR;
input  [7:0]  RDATA_CUR2MXR;
input  [7:0]  RDATA_L0P2MXR;
input  [7:0]  RDATAb_BG2MXR;
input         WILLSENDb_CUR2MXR;
input         WILLSENDb_L0P2MXR;
input         WRb_reg;
input  [31:0] data_reg;
input         dread_lcd2mxr;
input         mclk;
input         rstb;
output        DATAREQb_MXR;
output        DREADb_MXR2L0P;
output [11:0] LOC_X_MXR;
output [11:0] LOC_Y_MXR;
output        READDATAb_MXR2CUR;
output [7:0]  bdata_mxr2lcd;
output        dvalidb_mxr2lcd;
output [7:0]  gdata_mxr2lcd;
output [7:0]  rdata_mxr2lcd;


wire [7:0] ADATA_L0P2MXR;
wire [15:2] ADDR_reg;
wire [7:0] BDATA_CUR2MXR;
wire [7:0] BDATA_L0P2MXR;
wire [7:0] BDATAb_BG2MXR;
wire CSb_reg2mxr;
wire DREADY_L0P2MXR;
wire ENABLEb_reg;
wire [7:0] GDATA_CUR2MXR;
wire [7:0] GDATA_L0P2MXR;
wire [7:0] GDATAb_BG2MXR;
wire [7:0] RDATA_CUR2MXR;
wire [7:0] RDATA_L0P2MXR;
wire [7:0] RDATAb_BG2MXR;
wire WILLSENDb_CUR2MXR;
wire WILLSENDb_L0P2MXR;
wire WRb_reg;
wire [31:0] data_reg;
wire dread_lcd2mxr;
wire mclk;
wire rstb;
wire DATAREQb_MXR;
wire DREADb_MXR2L0P;
wire [11:0] LOC_X_MXR;
wire [11:0] LOC_Y_MXR;
wire READDATAb_MXR2CUR;
wire [7:0] bdata_mxr2lcd;
wire dvalidb_mxr2lcd;
wire [7:0] gdata_mxr2lcd;
wire [7:0] rdata_mxr2lcd;
endmodule
