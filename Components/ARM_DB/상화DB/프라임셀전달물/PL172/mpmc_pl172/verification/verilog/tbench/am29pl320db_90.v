// Module:                      am29pl320db_90
// SOMA file:                   ../../denali/am29pl320db_90.soma
// Initial contents file:       ../../denali/am29pl320db_90.dat

`timescale 1ps/1ps
module am29pl320db_90(
    a,
    dq,
    cebar,
    oebar,
    webar,
    wpbar,
    wordbar,
    acc
);
    parameter memory_spec = "../../denali/am29pl320db_90.soma";
    parameter init_file   = "../../denali/am29pl320db_90.dat";
    input [19:0] a;
    inout [31:0] dq;
      reg [31:0] den_dq;
      assign dq = den_dq;
    input cebar;
    input oebar;
    input webar;
    input wpbar;
    input wordbar;
    input acc;
initial
    $flash_access();
endmodule

