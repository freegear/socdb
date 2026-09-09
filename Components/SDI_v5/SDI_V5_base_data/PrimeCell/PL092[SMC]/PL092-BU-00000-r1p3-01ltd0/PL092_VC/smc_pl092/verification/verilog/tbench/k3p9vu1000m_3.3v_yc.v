// Module:                      mrom1
// SOMA file:                   ../../denali/mrom1.spc
// Initial contents file:       ../../denali/mrom1.dat

`timescale 1ps/1ps
module k3p9vu1000m_33v_yc(
    a,
    cebar,
    oebar,
    q,
    bhe
);
    parameter memory_spec = "../../denali/k3p9vu1000m_3.3v_yc.soma";
    parameter init_file   = "../../denali/k3p9vu1000m_3.3v_yc.dat";
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

