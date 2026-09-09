// Module:                      x28c256_15
// SOMA file:                   ../../denali/x28c256-15.soma
// Initial contents file:       /../../denali/x28c256_15.dat

`timescale 1ps/1ps
module x28c256_15(
    a,
    cebar,
    oebar,
    webar,
    io
);
    parameter memory_spec = "../../denali/x28c256-15.soma";
    parameter init_file   = "/../../denali/x28c256_15.dat";
    input [14:0] a;
    input cebar;
    input oebar;
    input webar;
    inout [7:0] io;
      reg [7:0] den_io;
      assign io = den_io;
initial
    $prom_access();
endmodule

