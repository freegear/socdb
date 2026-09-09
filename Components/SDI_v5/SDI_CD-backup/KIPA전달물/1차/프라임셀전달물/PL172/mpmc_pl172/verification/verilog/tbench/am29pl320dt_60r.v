// Module:                      am29pl320dt_60r
// SOMA file:                   ../../denali/am29pl320dt_60r.soma
// Initial contents file:       ../../denali/am29pl320dt_60r.dat

`timescale 1ps/1ps
module am29pl320dt_60r(
    a,
    dq,
    cebar,
    oebar,
    webar,
    wpbar,
    wordbar,
    acc
);
    parameter memory_spec = "../../denali/am29pl320dt_60r.soma";
    parameter init_file   = "../../denali/am29pl320dt_60r.dat";
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

