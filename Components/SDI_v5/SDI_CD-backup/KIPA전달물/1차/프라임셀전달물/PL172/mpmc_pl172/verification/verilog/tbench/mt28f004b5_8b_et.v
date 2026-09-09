// Module:                      mt28f004b5_8b_et
// SOMA file:                   ../../denali/mt28f004b5_8b_et.soma
// Initial contents file:       ../../denali/mt28f004b5_8b_et.dat

`timescale 1ps/1ps
module mt28f004b5_8b_et(
    a,
    dq,
    cebar,
    oebar,
    webar,
    wpbar,
    rpbar
);
    parameter memory_spec = "../../denali/mt28f004b5_8b_et.soma";
    parameter init_file   = "../../denali/mt28f004b5_8b_et.dat";
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

