// Module:                      hm5264165f_75
// SOMA file:                   ../../denali/hm5264165f_75.soma
// Initial contents file:       ../../denali/hm5264165f_75.dat

`timescale 1ps/1ps
module hm5264165f_75(
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
    parameter memory_spec = "../../denali/hm5264165f_75.soma";
    parameter init_file   = "../../denali/hm5264165f_75.dat";
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

