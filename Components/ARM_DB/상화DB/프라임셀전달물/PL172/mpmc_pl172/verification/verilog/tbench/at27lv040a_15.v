// Module:                      at27lv040a_15
// SOMA file:                   ../../denali/at27lv040a_15.soma
// Initial contents file:       ../../denali/at27lv040a_15.dat

`timescale 1ps/1ps
module at27lv040a_15(
    a,
    cebar,
    oebar,
    o
);
    parameter memory_spec = "../../denali/at27lv040a_15.soma";
    parameter init_file   = "../../denali/at27lv040a_15.dat";
    input [18:0] a;
    input cebar;
    input oebar;
    inout [7:0] o;
      reg [7:0] den_o;
      assign o = den_o;
initial
    $prom_access();
endmodule

