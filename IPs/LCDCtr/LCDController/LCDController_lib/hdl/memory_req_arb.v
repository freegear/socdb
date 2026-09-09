//
// Verilog Module LCDController_lib.memory_req_arb.arch_name
//
// Created:
//          by - gundam.UNKNOWN (RND-D4E2566A1B1)
//          at - 17:08:12 2006-05-01
//
// using Mentor Graphics HDL Designer(TM) 2004.1 (Build 41)
//

`resetall
`timescale 1ns/10ps
module memory_req_arb( 
   DADDR_L0P2MRQ, 
   DREQb_L0P2MRQ, 
   mclk, 
   rstb, 
   DATA_MRQ, 
   DREADYb_L0P2MRQ
);


// Internal Declarations

input  [31:0] DADDR_L0P2MRQ;
input         DREQb_L0P2MRQ;
input         mclk;
input         rstb;
output [31:0] DATA_MRQ;
output        DREADYb_L0P2MRQ;


wire [31:0] DADDR_L0P2MRQ;
wire DREQb_L0P2MRQ;
wire mclk;
wire rstb;
wire [31:0] DATA_MRQ;
wire DREADYb_L0P2MRQ;
endmodule
