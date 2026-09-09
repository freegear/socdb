// Module:                      k3n9vu1000m_3_0v_yc
// SOMA file:                   ../../denali/k3n9vu1000m.soma
// Initial contents file:       ../../denali/k3n9vu1000m.dat

`timescale 1ps/1ps
module k3n9vu1000m(
    a,
    cebar,
    oebar,
    q,
    bhe
);
    parameter memory_spec = "../../denali/k3n9vu1000m.soma";
    parameter init_file   = "../../denali/k3n9vu1000m.dat";
    input [22:0] a;
    input cebar;
    input oebar;
    inout [15:0] q;
      reg [15:0] den_q;
      assign q = den_q;
    input bhe;
initial
    $prom_access();
endmodule

