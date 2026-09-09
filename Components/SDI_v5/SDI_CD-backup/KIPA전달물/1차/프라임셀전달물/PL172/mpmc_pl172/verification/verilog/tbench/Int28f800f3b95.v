// Module:                      intel_28f800f3b95_ext
// SOMA file:                   ../../denali/Int28f800f3b95.soma
// Initial contents file:       ../../denali/Int28f800f3b95.dat

`timescale 1ps/1ps
module Int28f800f3b95(
    a,
    dq,
    cebar,
    oebar,
    webar,
    wpbar,
    rstbar,
    clk,
    advbar,
    waitbar
);
    parameter memory_spec = "../../denali/Int28f800f3b95.soma";
    parameter init_file   = "../../denali/Int28f800f3b95.dat";
    input [18:0] a;
    inout [15:0] dq;
      reg [15:0] den_dq;
      assign dq = den_dq;
    input cebar;
    input oebar;
    input webar;
    input wpbar;
    input rstbar;
    input clk;
    input advbar;
    output waitbar;
      reg den_waitbar;
      assign waitbar = den_waitbar;
initial
    $flash_access();
endmodule

