// Module:                      hyb25l128800ac
// SOMA file:                   /h/dharmesh/armmpmc/mpmc_pl172/verification/denali/hyb25l128800ac.soma
// Initial contents file:       ../../denali/hyb25l128800ac.dat

`timescale 1ps/1ps
module hyb25l128800ac(
    a,
    rasbar,
    casbar,
    webar,
    csbar,
    dqm,
    clk,
    cke,
    ba,
    dq
);
    parameter memory_spec = "/h/dharmesh/armmpmc/mpmc_pl172/verification/denali/hyb25l128800ac.soma";
    parameter init_file   = "../../denali/hyb25l128800ac.dat";
    input [11:0] a;
    input rasbar;
    input casbar;
    input webar;
    input csbar;
    input dqm;
    input clk;
    input cke;
    input [1:0] ba;
    inout [7:0] dq;
      reg [7:0] den_dq;
      assign dq = den_dq;
initial
    $sdram_access();
endmodule

