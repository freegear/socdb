// Module:                      sst37vf020_90
// SOMA file:                   ../../denali/sst37vf020-90.soma
// Initial contents file:       ../../denali/sst37vf020_90.dat

`timescale 1ps/1ps
module sst37vf020_90(
    a,
    cebar,
    oebar,
    dq
);
    parameter memory_spec = "../../denali/sst37vf020-90.soma";
    parameter init_file   = "../../denali/sst37vf020_90.dat";
    input [17:0] a;
    input cebar;
    input oebar;
    inout [7:0] dq;
      reg [7:0] den_dq;
      assign dq = den_dq;
initial
    $prom_access();
endmodule

