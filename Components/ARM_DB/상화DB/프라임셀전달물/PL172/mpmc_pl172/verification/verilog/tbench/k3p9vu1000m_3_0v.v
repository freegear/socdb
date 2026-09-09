// Module:                      k3p9vu1000m_3_0v
// SOMA file:                   ../../denali/k3p9vu1000m_3.0v.soma
// Initial contents file:       ../../denali/k3p9vu1000m_3.0v.dat

`timescale 1ps/1ps
module k3p9vu1000m_3_0v(
    a,
    cebar,
    oebar,
    q,
    bhe
);
    parameter memory_spec = "../../denali/k3p9vu1000m_3_0v.soma";
    parameter init_file   = "../../denali/k3p9vu1000m_3_0v.dat";
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

