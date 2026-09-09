// Module:                      hm5225325f_b60
// SOMA file:                   ../../denali/hm5225325f_b60.soma
// Initial contents file:       ../../denali/hm5225325f_b60.dat

`timescale 1ps/1ps
module hm5225325f_b60(
    a,
    rasbar,
    casbar,
    webar,
    csbar,
    dqm,
    clk,
    cke,
    dq
);
    parameter memory_spec = "../../denali/hm5225325f_b60.soma";
    parameter init_file   = "../../denali/hm5225325f_b60.dat";
    input [13:0] a;
    input rasbar;
    input casbar;
    input webar;
    input csbar;
    input [3:0] dqm;
    input clk;
    input cke;
    inout [31:0] dq;
      reg [31:0] den_dq;
      assign dq = den_dq;
initial
    $sdram_access();
endmodule

