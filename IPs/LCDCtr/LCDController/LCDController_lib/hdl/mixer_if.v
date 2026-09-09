//
// Verilog Module LCDController_lib.mixer_if.arch_name
//
// Created:
//          by - gundam.UNKNOWN (RND-D4E2566A1B1)
//          at - 16:35:04 2006-05-01
//
// using Mentor Graphics HDL Designer(TM) 2004.1 (Build 41)
//

`resetall
`timescale 1ns/10ps
module mixer_if( 
   ENABLEb_reg, 
   bdata_mxr2lcd, 
   dreadb_lif2mif, 
   dvalidb_mxr2lcd, 
   gdata_mxr2lcd, 
   hrstb_lif2mif, 
   mclk, 
   rdata_mxr2lcd, 
   rstb, 
   vrstb_lif2mif, 
   bdata_mif2lif, 
   dread_lcd2mxr, 
   gdata_mif2lif, 
   rdata_mif2lif
);


// Internal Declarations

input        ENABLEb_reg;
input  [7:0] bdata_mxr2lcd;
input        dreadb_lif2mif;
input        dvalidb_mxr2lcd;
input  [7:0] gdata_mxr2lcd;
input        hrstb_lif2mif;
input        mclk;
input  [7:0] rdata_mxr2lcd;
input        rstb;
input        vrstb_lif2mif;
output [7:0] bdata_mif2lif;
output       dread_lcd2mxr;
output [7:0] gdata_mif2lif;
output [7:0] rdata_mif2lif;


wire ENABLEb_reg;
wire [7:0] bdata_mxr2lcd;
wire dreadb_lif2mif;
wire dvalidb_mxr2lcd;
wire [7:0] gdata_mxr2lcd;
wire hrstb_lif2mif;
wire mclk;
wire [7:0] rdata_mxr2lcd;
wire rstb;
wire vrstb_lif2mif;
wire [7:0] bdata_mif2lif;
wire dread_lcd2mxr;
wire [7:0] gdata_mif2lif;
wire [7:0] rdata_mif2lif;
endmodule
