//
// Verilog Module LCDController_lib.reg_if.arch_name
//
// Created:
//          by - gundam.UNKNOWN (RND-D4E2566A1B1)
//          at - 17:13:05 2006-05-01
//
// using Mentor Graphics HDL Designer(TM) 2004.1 (Build 41)
//

`resetall
`timescale 1ns/10ps
module reg_if( 
   ADDR_APB2REG, 
   CSb_APB2REG, 
   DATA_APB2REG, 
   RDb_APB2REG, 
   WRb_APB2REG, 
   mclk, 
   rstb, 
   ADDR_reg, 
   CSb_reg2bg, 
   CSb_reg2cur, 
   CSb_reg2l0p, 
   CSb_reg2lif, 
   CSb_reg2mxr, 
   DATAO_REG2APB, 
   ENABLEb_reg, 
   WRb_reg, 
   data_reg
);


// Internal Declarations

input  [15:0] ADDR_APB2REG;
input         CSb_APB2REG;
input  [31:0] DATA_APB2REG;
input         RDb_APB2REG;
input         WRb_APB2REG;
input         mclk;
input         rstb;
output [15:2] ADDR_reg;
output        CSb_reg2bg;
output        CSb_reg2cur;
output        CSb_reg2l0p;
output        CSb_reg2lif;
output        CSb_reg2mxr;
output [31:0] DATAO_REG2APB;
output        ENABLEb_reg;
output        WRb_reg;
output [31:0] data_reg;


wire [15:0] ADDR_APB2REG;
wire CSb_APB2REG;
wire [31:0] DATA_APB2REG;
wire RDb_APB2REG;
wire WRb_APB2REG;
wire mclk;
wire rstb;
wire [15:2] ADDR_reg;
wire CSb_reg2bg;
wire CSb_reg2cur;
wire CSb_reg2l0p;
wire CSb_reg2lif;
wire CSb_reg2mxr;
wire [31:0] DATAO_REG2APB;
wire ENABLEb_reg;
wire WRb_reg;
wire [31:0] data_reg;
endmodule
