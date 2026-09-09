// Module:                      I28f320w18b_70
// SOMA file:                   ../../denali/I28f320w18b_70.soma
// Initial contents file:       ../../denali/I28f320w18b_70.dat

`timescale 1ps/1ps
module I28f320w18b_70(
    a,
    dq,
    cebar,
    oebar,
    webar,
    wpbar,
    resetbar,
    clk,
    advbar,
    waitbar,
    vpp
);
    parameter memory_spec = "../../denali/I28f320w18b_70.soma";
    parameter init_file   = "../../denali/I28f320w18b_70.dat";
    input [20:0] a;
    inout [15:0] dq;
      reg [15:0] den_dq;
      assign dq = den_dq;
    input cebar;
    input oebar;
    input webar;
    input wpbar;
    input resetbar;
    input clk;
    input advbar;
    output waitbar;
      reg den_waitbar;
      assign waitbar = den_waitbar;
    input vpp;
initial
    $flash_access();
endmodule

