// Module:                      k4s641632d_60
// SOMA file:                   ../../denali/k4s641632d_60.soma
// Initial contents file:       ../../denali/k4s641632d_60.dat

`timescale 1ps/1ps
module k4s641632d_60(
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
    parameter memory_spec = "../../denali/k4s641632d_60.soma";
    parameter init_file   = "../../denali/k4s641632d_60.dat";
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

