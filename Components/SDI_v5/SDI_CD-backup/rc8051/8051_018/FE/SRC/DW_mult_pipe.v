//-----------------------------------------------------------------------------
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 2002 - 2004 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Rajeev Huralikoppi         Feb 15, 2002
//
// VERSION:   Verilog Simulation Architecture
//
// DesignWare_version: b5e12471
// DesignWare_release: V-2004.06-DWF_0406
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// ABSTRACT:   An n stage pipelined multipler 
//      Parameters      Valid Values    Description
//      ==========      =========       ===========  
//      a_width         >= 1            Word length of a
//      b_width         >= 1            Word length of b
//      num_stages      >= 1            Number of pipelined stages
//      stall_mode      0 or 1          Stall mode
//                                      (0 = non-stallable)
//                                      (1 = stallable)
//      rst_mode        0 to 2          Reset mode
//                                      (0 = no reset)
//                                      (1 = asynchronous reset)
//                                      (2 = synchronous reset)
//
//      Input Ports     Size            Description
//      ===========     ====            ============ 
//      clk             1               Clock 
//      rst_n           1               Reset, active low
//      en              1               Load enable, active low
//      tc              1               2's complement control
//      a               a_width         Multiplier
//      b               b_width         Multiplicand
//      
//      product         a_width+b_width Product (a*b)
// MODIFIED:
//           
//
//
//-----------------------------------------------------------------------------

module DW_mult_pipe_a_width8_b_width8_num_stages5_stall_mode1_rst_mode1 (clk,rst_n,en,tc,a,b,product);
   
   parameter a_width = 8;
   parameter b_width = 8;
   parameter num_stages = 5;
   parameter stall_mode = 1;
   parameter rst_mode = 1;

   
   input clk;
   input rst_n;
   input [a_width-1 : 0] a;
   input [b_width-1 : 0] b;
   input tc;
   input en;
   
   output [a_width+b_width-1: 0] product;

   wire   a_rst_n;
   reg [a_width-1 : 0] a_reg[0 : num_stages-1];
   reg [b_width-1 : 0] b_reg[0 : num_stages-1];
   reg tc_reg[0 : num_stages-1];

endmodule //


