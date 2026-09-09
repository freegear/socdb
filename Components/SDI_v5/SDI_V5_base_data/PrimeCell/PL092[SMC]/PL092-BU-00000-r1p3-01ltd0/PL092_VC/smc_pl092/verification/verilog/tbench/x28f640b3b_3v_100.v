// Module:                      flash1
// SOMA file:                   ../../denali/flash1.spc
// Initial contents file:       ../../denali/flash1.dat

`timescale 1ps/1ps
module x28f640b3b_3v_100(
    address,
    data,
    cebar,
    oebar,
    webar,
    wpbar,
    rpbar
);
    parameter memory_spec = "../../denali/x28f640b3b_3v_100.soma";
    parameter init_file   = "../../denali/x28f640b3b_3v_100.dat";
    input [21:0] address;
    inout [15:0] data;
      reg [15:0] den_data;
      assign data = den_data;
    input cebar;
    input oebar;
    input webar;
    input wpbar;
    input rpbar;
initial
    $flash_access();
endmodule

