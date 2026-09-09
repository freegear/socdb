// Module:                      flash2
// SOMA file:                   ../../denali/flash2.spc
// Initial contents file:       ../../denali/flash2.dat

`timescale 1ps/1ps
module x28f800c3b_110(
    a,
    dq,
    cebar,
    oebar,
    webar,
    wpbar,
    rpbar
);
    parameter memory_spec = "../../denali/x28f800c3b_110.soma";
    parameter init_file   = "../../denali/x28f800c3b_110.dat";
    input [18:0] a;
    inout [15:0] dq;
      reg [15:0] den_dq;
      assign dq = den_dq;
    input cebar;
    input oebar;
    input webar;
    input wpbar;
    input rpbar;
initial
    $flash_access();
endmodule

