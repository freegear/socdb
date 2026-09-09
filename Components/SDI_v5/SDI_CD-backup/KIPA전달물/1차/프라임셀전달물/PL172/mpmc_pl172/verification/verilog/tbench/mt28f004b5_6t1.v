// Module:                      mt28f004b5_6t1
// SOMA file:                   ../../denali/mt28f004b5_6t1.soma
// Initial contents file:       ../../denali/mt28f004b5_6t1.dat

`timescale 1ps/1ps
module mt28f004b5_6t1(
    a,
    dq,
    cebar,
    oebar,
    webar,
    wpbar,
    rpbar
);
    parameter memory_spec = "../../denali/mt28f004b5_6t1.soma";
    parameter init_file   = "../../denali/mt28f004b5_6t1.dat";
    input [18:0] a;
    inout [7:0] dq;
      reg [7:0] den_dq;
      assign dq = den_dq;
    input cebar;
    input oebar;
    input webar;
    input wpbar;
    input rpbar;
initial
    $flash_access();
endmodule

