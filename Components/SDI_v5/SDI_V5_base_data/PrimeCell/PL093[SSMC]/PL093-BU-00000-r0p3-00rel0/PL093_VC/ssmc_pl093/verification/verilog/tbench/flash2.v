// Module:                      flash2
// SOMA file:                   ../../denali/flash2.spc
// Initial contents file:       ../../denali/flash2.dat

`timescale 1ps/1ps
module flash2(
    address,
    Data,
    nCS,
    nOE,
    nWE
);
    parameter memory_spec = "../../denali/flash2.spc";
    parameter init_file   = "../../denali/flash2.dat";
    input [18:0] address;
    inout [15:0] Data;
      reg [15:0] den_Data;
      assign Data = den_Data;
    input nCS;
    input nOE;
    input nWE;
initial
    $flash_access();
endmodule

