// ****** (C) Copyright 1998 Avant! Inc. ********
//  --    AVANT! Verilog Models
// **********************************************


`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 1ps
 `delay_mode_path
`endif 


// Model type   	: zero timing
// Filename     	: adp1d0.v
// Description  	:  1-Bit Full Adder with Propagate, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.2
//
//


module adp1d0 (A,B,CI,S,P,CO);

output  S,P,CO;
input   A,B,CI;

buf (A_buf,A);
buf (B_buf,B);
buf (CI_buf,CI);

wire S_OUT = ((!CI_buf && !B_buf && A_buf) || (!CI_buf && B_buf && !A_buf) || (CI_buf && B_buf && A_buf) || (CI_buf && !B_buf && !A_buf));

buf #1 (S,S_OUT);
wire P_OUT = ((!B_buf && A_buf) || (B_buf && !A_buf));

buf #1 (P,P_OUT);
wire CO_OUT = ((B_buf && A_buf) || (CI_buf && B_buf) || (CI_buf && A_buf));

buf #1 (CO,CO_OUT);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a_lh_s_hl_1=0,a_hl_s_lh_1=0,b_hl_p_lh_1=0,b_hl_s_lh_1=0,
 b_lh_s_hl_1=0,ci_lh_co_lh_1=0,ci_lh_s_hl_1=0,a_hl_co_hl_2=0,a_lh_co_lh_2=0,
 b_lh_co_lh_2=0,a_lh_p_hl_2=0,a_hl_p_lh_2=0,b_hl_co_hl_2=0,b_lh_p_hl_2=0,
 ci_hl_co_hl_1=0,ci_hl_s_lh_1=0;
// Delays
 (        A   => S ) = (a_hl_s_lh_1,a_lh_s_hl_1);
 (        B   => P ) = (b_hl_p_lh_1,b_lh_p_hl_2);
 (        B   => S ) = (b_hl_s_lh_1,b_lh_s_hl_1);
 (        CI  => S ) = (ci_hl_s_lh_1,ci_lh_s_hl_1);
 (        A   => P ) = (a_hl_p_lh_2,a_lh_p_hl_2);
 (        CI +=> CO) = (ci_lh_co_lh_1,ci_hl_co_hl_1);
 (        A  +=> CO) = (a_lh_co_lh_2,a_hl_co_hl_2);
 (        B  +=> CO) = (b_lh_co_lh_2,b_hl_co_hl_2);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
