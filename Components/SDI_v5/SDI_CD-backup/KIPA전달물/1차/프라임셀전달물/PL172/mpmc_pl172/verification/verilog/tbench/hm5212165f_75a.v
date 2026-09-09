// Module:                      hm5212165f_75a
// SOMA file:                   ../../denali/hm5212165f_75a.soma
// Initial contents file:       ../../denali/hm5212165f_75a.dat

`timescale 1ps/1ps
module hm5212165f_75a(
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
    parameter memory_spec = "../../denali/hm5212165f_75a.soma";
    parameter init_file   = "../../denali/hm5212165f_75a.dat";
    input [13:0] a;
    input rasbar;
    input casbar;
    input webar;
    input csbar;
    input [1:0] dqm;
    input clk;
    input cke;
    inout [15:0] dq;
      reg [15:0] den_dq;
      assign dq = den_dq;
initial
    $sdram_access();
endmodule

