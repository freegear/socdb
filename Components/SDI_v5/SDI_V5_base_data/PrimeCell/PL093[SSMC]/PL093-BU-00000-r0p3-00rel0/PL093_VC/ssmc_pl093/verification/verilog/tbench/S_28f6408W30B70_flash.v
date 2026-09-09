// Module:                      28f6408W30B70_flash
// SOMA file:                   /h/qureshi/armssmc/ssmc_pl093/verification/denali/28f6408W30B70_flash.spc
// Initial contents file:       

`timescale 1ps/1ps
module S_28f6408W30B70_flash(
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
    parameter memory_spec = "../../denali/28f6408W30B70_flash.spc";
    parameter init_file   = "";
    input [21:0] a;
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

