// Module:                      mt48lc1m16a1_6s
// SOMA file:                   ../../denali/mt48lc1m16a1_6s.soma
// Initial contents file:       ../../denali/mt48lc1m16a1_6s.dat

`timescale 1ps/1ps
module mt48lc1m16a1_6s(
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
    parameter memory_spec = "../../denali/mt48lc1m16a1_6s.soma";
    parameter init_file   = "../../denali/mt48lc1m16a1_6s.dat";
    input [10:0] a;
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
    input ba;
initial
    $sdram_access();
endmodule

