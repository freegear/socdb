// Module:                      k6r4016c1c_12
// SOMA file:                   ../../denali/k6r4016c1c_12.soma
// Initial contents file:       ../../denali/k6r4016c1c_12.dat

`timescale 1ps/1ps
module k6r4016c1c_12(
    a,
    webar,
    csbar,
    oebar,
    bbar,
    io
);
    parameter memory_spec = "../../denali/k6r4016c1c_12.soma";
    parameter init_file   = "../../denali/k6r4016c1c_12.dat";
    input [17:0] a;
    input webar;
    input csbar;
    input oebar;
    input [1:0] bbar;
    inout [15:0] io;
      reg [15:0] den_io;
      assign io = den_io;
initial
    $sram_access();
endmodule

