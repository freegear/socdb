// Module:                      mrom2
// SOMA file:                   ../../denali/mrom2.spc
// Initial contents file:       ../../denali/mrom2.dat

`timescale 1ps/1ps
module mrom2(
    address,
    nCS,
    nOE,
    Data,
    nWRD
);
    parameter memory_spec = "../../denali/mrom2.spc";
    parameter init_file   = "../../denali/mrom2.dat";
    input [19:0] address;
    input nCS;
    input nOE;
    inout [31:0] Data;
      reg [31:0] den_Data;
      assign Data = den_Data;
    input nWRD;
initial
    $prom_access();
endmodule

