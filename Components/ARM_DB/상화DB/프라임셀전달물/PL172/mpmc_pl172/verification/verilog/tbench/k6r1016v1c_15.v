// Module:                      k6r1016v1c_15
// SOMA file:                   ../../denali/k6r1016v1c_15.soma
// Initial contents file:       ../../denali/k6r1016v1c_15.dat

`timescale 1ps/1ps
module k6r1016v1c_15(
    a,
    webar,
    csbar,
    oebar,
    bebar,
    io
);
    parameter memory_spec = "../../denali/k6r1016v1c_15.soma";
    parameter init_file   = "../../denali/k6r1016v1c_15.dat";
    input [15:0] a;
    input webar;
    input csbar;
    input oebar;
    input [1:0] bebar;
    inout [15:0] io;
      reg [15:0] den_io;
      assign io = den_io;
initial
    $sram_access();
endmodule

