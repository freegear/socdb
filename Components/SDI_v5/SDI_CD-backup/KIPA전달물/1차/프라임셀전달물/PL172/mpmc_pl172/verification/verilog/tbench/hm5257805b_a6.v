// Module:                      hm5257805b_a6
// SOMA file:                   ../../denali/hm5257805b_a6.soma
// Initial contents file:       ../../denali/hm5257805b_a6.dat

`timescale 1ps/1ps
module hm5257805b_a6(
    a,
    rasbar,
    casbar,
    webar,
    csbar,
    dqm,
    clk,
    cke,
    dq,
    ba
);
    parameter memory_spec = "../../denali/hm5257805b_a6.soma";
    parameter init_file   = "../../denali/hm5257805b_a6.dat";
    input [12:0] a;
    input rasbar;
    input casbar;
    input webar;
    input csbar;
    input dqm;
    input clk;
    input cke;
    inout [7:0] dq;
      reg [7:0] den_dq;
      assign dq = den_dq;
    input [1:0] ba;
initial
    $sdram_access();
endmodule

