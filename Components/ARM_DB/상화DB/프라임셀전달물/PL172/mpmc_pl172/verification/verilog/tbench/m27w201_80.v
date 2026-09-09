// Module:                      m27w201_80
// SOMA file:                   ../../denali/m27w201-80.soma
// Initial contents file:       ../../denali/m27w201_80.dat

`timescale 1ps/1ps
module m27w201_80(
    a,
    ebar,
    gbar,
    q
);
    parameter memory_spec = "../../denali/m27w201-80.soma";
    parameter init_file   = "../../denali/m27w201_80.dat";
    input [17:0] a;
    input ebar;
    input gbar;
    inout [7:0] q;
      reg [7:0] den_q;
      assign q = den_q;
initial
    $prom_access();
endmodule

