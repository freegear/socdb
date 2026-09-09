// Module:                      mt48lc16m8a2_75
// SOMA file:                   /../../denali/mt48lc16m8a2_75.soma
// Initial contents file:       ../../denali/mt48lc16m8a2_75.dat

`timescale 1ps/1ps
module mt48lc16m8a2_75(
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
    parameter memory_spec = "/../../denali/mt48lc16m8a2_75.soma";
    parameter init_file   = "../../denali/mt48lc16m8a2_75.dat";
    input [11:0] a;
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

