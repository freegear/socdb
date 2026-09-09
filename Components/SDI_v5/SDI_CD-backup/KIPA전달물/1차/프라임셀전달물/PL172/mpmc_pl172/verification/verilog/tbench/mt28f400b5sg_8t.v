// Module:                      mt28f400b5sg_8t
// SOMA file:                   ../../denali/mt28f400b5sg_8t.soma
// Initial contents file:       ../../denali/mt28f400b5sg

`timescale 1ps/1ps
module mt28f400b5sg_8t(
    a,
    dq,
    cebar,
    oebar,
    webar,
    wpbar,
    rpbar,
    bytebar
);
    parameter memory_spec = "../../denali/mt28f400b5sg_8t.soma";
    parameter init_file   = "../../denali/mt28f400b5sg";
    input [17:0] a;
    inout [15:0] dq;
      reg [15:0] den_dq;
      assign dq = den_dq;
    input cebar;
    input oebar;
    input webar;
    input wpbar;
    input rpbar;
    input bytebar;
initial
    $flash_access();
endmodule

