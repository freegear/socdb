// Module:                      k6t8016c3m_55
// SOMA file:                   ../../denali/k6t8016c3m_55.soma
// Initial contents file:       ../../denali/k6t8016c3m_55.dat

`timescale 1ps/1ps
module k6t8016c3m_55(
    a,
    webar,
    csbar,
    oebar,
    bbar,
    io
);
    parameter memory_spec = "../../denali/k6t8016c3m_55.soma";
    parameter init_file   = "../../denali/k6t8016c3m_55.dat";
    input [18:0] a;
    input webar;
    input csbar;
    input oebar;
    input [1:0] bbar;
    inout [15:0] io;
      reg [15:0] den_io;
      assign io = den_io;
initial
    $sram_access();
endmodule

