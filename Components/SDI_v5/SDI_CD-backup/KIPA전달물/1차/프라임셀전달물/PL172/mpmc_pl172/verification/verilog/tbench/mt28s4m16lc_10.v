// Module:                      mt28s4m16lc_10
// SOMA file:                   ../../denali/mt28s4m16lc_10.soma
// Initial contents file:       ../../denali/mt28s4m161c_10.dat

`timescale 1ps/1ps
module mt28s4m16lc_10(
    clk,
    cke,
    csbar,
    rasbar,
    casbar,
    webar,
    dqm,
    address,
    data,
    rpbar,
    ba
);
    parameter memory_spec = "../../denali/mt28s4m16lc_10.soma";
    parameter init_file   = "../../denali/mt28s4m161c_10.dat";
    input clk;
    input cke;
    input csbar;
    input rasbar;
    input casbar;
    input webar;
    input [1:0] dqm;
    input [11:0] address;
    inout [15:0] data;
      reg [15:0] den_data;
      assign data = den_data;
    input rpbar;
    input [1:0] ba;
initial
    $sflash_access();
endmodule

