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
// Filename     	: ad01d0.v
// Description  	:  1-Bit Full Adder, 0.5X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module ad01d0 (A,B,CI,S,CO);

output  S,CO;
input   A,B,CI;

U_ADDR2_S #1 (S,A,B,CI);
U_ADDR2_C #1 (CO,A,B,CI);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a_lh_co_lh_1=0,b_hl_s_lh_1=0,b_lh_co_lh_1=0,ci_lh_co_lh_1=0,
 ci_lh_s_hl_1=0,a_hl_co_hl_2=0,a_hl_s_lh_2=0,a_lh_s_hl_2=0,b_hl_co_hl_2=0,
 b_hl_s_hl_2=0,ci_hl_co_hl_1=0,ci_hl_s_lh_1=0;
// Delays
 (        B   => S ) = (b_hl_s_lh_1,b_hl_s_hl_2);
 (        CI  => S ) = (ci_hl_s_lh_1,ci_lh_s_hl_1);
 (        A   => S ) = (a_hl_s_lh_2,a_lh_s_hl_2);
 (        A  +=> CO) = (a_lh_co_lh_1,a_hl_co_hl_2);
 (        B  +=> CO) = (b_lh_co_lh_1,b_hl_co_hl_2);
 (        CI +=> CO) = (ci_lh_co_lh_1,ci_hl_co_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
