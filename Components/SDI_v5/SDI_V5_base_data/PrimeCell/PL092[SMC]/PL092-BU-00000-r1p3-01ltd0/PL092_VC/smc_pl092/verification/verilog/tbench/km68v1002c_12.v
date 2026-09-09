// Module:                      sram1
// SOMA file:                   ../../denali/sram1.spc
// Initial contents file:       

`timescale 1ps/1ps
module km68v1002c_12(
    a,
    csbar,
    webar,
    oebar,
    io
);
    parameter memory_spec = "../../denali/km68v1002c_12.soma";
    parameter init_file   = "";
    input [16:0] a;
    input csbar;
    input webar;
    input oebar;
    inout [7:0] io;
      reg [7:0] den_io;
      assign io = den_io;
initial
    $sram_access();
endmodule

