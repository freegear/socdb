//
// Verilog Module LCDController_lib.lcd_if.arch_name
//
// Created:
//          by - gundam.UNKNOWN (RND-D4E2566A1B1)
//          at - 16:34:20 2006-05-01
//
// using Mentor Graphics HDL Designer(TM) 2004.1 (Build 41)
//

`resetall
`timescale 1ns/10ps
module lcd_if( 
   ADDR_reg, 
   CSb_reg2lif, 
   ENABLEb_reg, 
   WRb_reg, 
   bdata_mif2lif, 
   data_reg, 
   div_pxl_reg2lcd, 
   gdata_mif2lif, 
   mclk, 
   rdata_mif2lif, 
   rstb, 
   HSync_LCDO, 
   VSync_LCDO, 
   bdoutLCDO, 
   de_LCDO, 
   dreadb_lif2mif, 
   gdout_LCDO, 
   hrstb_lcd, 
   hrstb_lif2mif, 
   pclk_LCDO, 
   rdout_LCDO, 
   vrstb_lcd, 
   vrstb_lif2mif
);


// Internal Declarations

input  [15:2] ADDR_reg;
input         CSb_reg2lif;
input         ENABLEb_reg;
input         WRb_reg;
input  [7:0]  bdata_mif2lif;
input  [31:0] data_reg;
input  [4:0]  div_pxl_reg2lcd;
input  [7:0]  gdata_mif2lif;
input         mclk;
input  [7:0]  rdata_mif2lif;
input         rstb;
output        HSync_LCDO;
output        VSync_LCDO;
output [7:0]  bdoutLCDO;
output        de_LCDO;
output        dreadb_lif2mif;
output [7:0]  gdout_LCDO;
output        hrstb_lcd;
output        hrstb_lif2mif;
output        pclk_LCDO;
output [7:0]  rdout_LCDO;
output        vrstb_lcd;
output        vrstb_lif2mif;


wire [15:2] ADDR_reg;
wire CSb_reg2lif;
wire ENABLEb_reg;
wire WRb_reg;
wire [7:0] bdata_mif2lif;
wire [31:0] data_reg;
wire [4:0] div_pxl_reg2lcd;
wire [7:0] gdata_mif2lif;
wire mclk;
wire [7:0] rdata_mif2lif;
wire rstb;
wire HSync_LCDO;
wire VSync_LCDO;
wire [7:0] bdoutLCDO;
wire de_LCDO;
wire dreadb_lif2mif;
wire [7:0] gdout_LCDO;
wire hrstb_lcd;
wire hrstb_lif2mif;
wire pclk_LCDO;
wire [7:0] rdout_LCDO;
wire vrstb_lcd;
wire vrstb_lif2mif;
endmodule
