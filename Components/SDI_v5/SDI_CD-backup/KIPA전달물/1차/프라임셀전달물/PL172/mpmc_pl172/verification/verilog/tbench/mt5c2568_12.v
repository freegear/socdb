// Module:                      mt5c2568_12
// SOMA file:                   ../../denali/mt5c2568-12.soma
// Initial contents file:       ../../denali/mt5c2568_12.dat

`timescale 1ps/1ps
module mt5c2568_12(
    a,
    cebar,
    webar,
    oebar,
    dq
);
    parameter memory_spec = "../../denali/mt5c2568-12.soma";
    parameter init_file   = "../../denali/mt5c2568_12.dat";
    input [14:0] a;
    input cebar;
    input webar;
    input oebar;
    inout [7:0] dq;
      reg [7:0] den_dq;
      assign dq = den_dq;
initial
    $sram_access();
endmodule

