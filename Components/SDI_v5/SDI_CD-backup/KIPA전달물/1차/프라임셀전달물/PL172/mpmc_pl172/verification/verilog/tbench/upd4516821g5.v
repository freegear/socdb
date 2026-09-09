// Module:                      upd4516821g5_a10
// SOMA file:                   ../../denali/upd4516821g5.soma
// Initial contents file:       ../../denali/upd4516821g5.dat

`timescale 1ps/1ps
module upd4516821g5(
    a,
    rasbar,
    casbar,
    webar,
    csbar,
    dqm,
    clk,
    cke,
    dq
    
);
    parameter memory_spec = "../../denali/upd4516821g5.soma";
    parameter init_file   = "../../denali/upd4516821g5.dat";
    input [11:0] a;
    input rasbar;
    input casbar;
    input webar;
    input csbar;
    input [1:0] dqm;
    input clk;
    input cke;
    inout [7:0] dq;
      reg [7:0] den_dq;
      assign dq = den_dq;
      
initial
    $sdram_access();
endmodule

