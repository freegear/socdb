// Module:                      mt48lc4m32b2_6
// SOMA file:                   ../../denali/mt48lc4m32b2_6.soma
// Initial contents file:       ../../denali/mt48lc4m32b2_6.dat

`timescale 1ps/1ps
module mt48lc4m32b2_6(
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
    parameter memory_spec = "../../denali/mt48lc4m32b2_6.soma";
    parameter init_file   = "../../denali/mt48lc4m32b2_6.dat";
    input [11:0] a;
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
    input [1:0] ba;
initial
    $sdram_access();
endmodule

