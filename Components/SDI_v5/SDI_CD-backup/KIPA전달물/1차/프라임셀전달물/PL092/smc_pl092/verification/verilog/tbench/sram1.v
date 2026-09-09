// Module:                      sram1
// SOMA file:                   ../../denali/sram1.spc
// Initial contents file:       ../../denali/sram1.dat

`timescale 1ps/1ps
module sram1(
    address,
    nCS,
    nWE,
    nOE,
    Data
);
    parameter memory_spec = "../../denali/sram1.spc";
    parameter init_file   = "../../denali/sram1.dat";
    input [16:0] address;
    input nCS;
    input nWE;
    input nOE;
    inout [7:0] Data;
      reg [7:0] den_Data;
      assign Data = den_Data;
initial
    $sram_access();
endmodule

