// Module:                      k4s643232c_60
// SOMA file:                   ../../denali/k4s643232c_60.soma
// Initial contents file:       ../../denali/k4s643232c_60.dat

`timescale 1ps/1ps
module k4s643232c_60(
    a,
    rasbar,
    casbar,
    webar,
    csbar,
    dqm,
    clk,
    cke,
    ba,
    dq
);
    parameter memory_spec = "../../denali/k4s643232c_60.soma";
    parameter init_file   = "../../denali/k4s643232c_60.dat";
    input [10:0] a;
    input rasbar;
    input casbar;
    input webar;
    input csbar;
    input [3:0] dqm;
    input clk;
    input cke;
    input [1:0] ba;
    inout [31:0] dq;
      reg [31:0] den_dq;
      assign dq = den_dq;
initial
    $sdram_access();
endmodule

