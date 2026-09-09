// Module:                      mt28f002b3vg_9b
// SOMA file:                   ../../denali/mt28f002b3vg_9b.soma
// Initial contents file:       ../../denali/mt28f002b3vg_9b.dat

`timescale 1ps/1ps
module mt28f002b3vg_9b(
    a,
    dq,
    cebar,
    oebar,
    webar,
    wpbar,
    rpbar
);
    parameter memory_spec = "../../denali/mt28f002b3vg_9b.soma";
    parameter init_file   = "../../denali/mt28f002b3vg_9b.dat";
    input [17:0] a;
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

