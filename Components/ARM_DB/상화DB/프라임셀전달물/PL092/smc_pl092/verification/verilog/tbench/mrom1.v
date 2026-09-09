// Module:                      mrom1
// SOMA file:                   ../../denali/mrom1.spc
// Initial contents file:       ../../denali/mrom1.dat

`timescale 1ps/1ps
module mrom1(
    address,
    nCS,
    nOE,
    Data,
    nWRD
);
    parameter memory_spec = "../../denali/mrom1.spc";
    parameter init_file   = "../../denali/mrom1.dat";
    input [18:0] address;
    input nCS;
    input nOE;
    inout [31:0] Data;
      reg [31:0] den_Data;
      assign Data = den_Data;
    input nWRD;
initial
    $prom_access();
endmodule

