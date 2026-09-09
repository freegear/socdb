// Module:                      hm5225805b_75
// SOMA file:                   ../../denali/hm5225805b_75.soma
// Initial contents file:       ../../denali/hm5225805b_75.dat

`timescale 1ps/1ps
module hm5225805b_75(
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
    parameter memory_spec = "../../denali/hm5225805b_75.soma";
    parameter init_file   = "../../denali/hm5225805b_75.dat";
    input [12:0] a;
    input rasbar;
    input casbar;
    input webar;
    input csbar;
    input dqm;
    input clk;
    input cke;
    input [1:0] ba;
    inout [7:0] dq;
      reg [7:0] den_dq;
      assign dq = den_dq;
initial
    $sdram_access();
endmodule

