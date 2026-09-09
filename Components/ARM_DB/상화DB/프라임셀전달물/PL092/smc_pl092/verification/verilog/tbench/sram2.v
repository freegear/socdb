// Module:                      sram2
// SOMA file:                   ../../denali/sram2.spc
// Initial contents file:       ../../denali/sram2.dat

`timescale 1ps/1ps
module sram2(
    address,
    nCS,
    nWE,
    nOE,
    nBLS,
    Data
);
    parameter memory_spec = "../../denali/sram2.spc";
    parameter init_file   = "../../denali/sram2.dat";
    input [15:0] address;
    input nCS;
    input nWE;
    input nOE;
    input [1:0] nBLS;
    inout [15:0] Data;
      reg [15:0] den_Data;
      assign Data = den_Data;
initial
    $sram_access();
endmodule

