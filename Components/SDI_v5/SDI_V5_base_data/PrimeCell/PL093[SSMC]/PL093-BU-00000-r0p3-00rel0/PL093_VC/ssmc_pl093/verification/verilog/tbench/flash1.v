// Module:                      flash1
// SOMA file:                   ../../denali/flash1.spc
// Initial contents file:       ../../denali/flash1.dat

`timescale 1ps/1ps
module flash1(
    address,
    Data,
    nCS,
    nOE,
    nWE
);
    parameter memory_spec = "../../denali/flash1.spc";
    parameter init_file   = "../../denali/flash1.dat";
    input [21:0] address;
    inout [15:0] Data;
      reg [15:0] den_Data;
      assign Data = den_Data;
    input nCS;
    input nOE;
    input nWE;
initial
    $flash_access();
endmodule

