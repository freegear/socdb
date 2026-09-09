// Module:                      mt48lc8m16a2_7e
// SOMA file:                   ../../denali/mt48lc8m16a2_7e.soma
// Initial contents file:       ../../denali/mt48lc8m16a2_7e.dat

`timescale 1ps/1ps
module mt48lc8m16a2_7e(
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
    parameter memory_spec = "../../denali/mt48lc8m16a2_7e.soma";
    parameter init_file   = "../../denali/mt48lc8m16a2_7e.dat";
    input [11:0] a;
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
    input [1:0] ba;
initial
    $sdram_access();
endmodule

