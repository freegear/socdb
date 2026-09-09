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
// Filename     	: cg01d0.v
// Description  	:  1-Bit Carry Generator, 0.5X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module cg01d0 (A,B,CI,CO);

output  CO;
input   A,B,CI;

and (g_1_out,B,A);
and (g_2_out,CI,B);
and (g_3_out,CI,A);
or #1 (CO,g_1_out,g_2_out,g_3_out);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a_lh_co_lh_1=0,b_hl_co_hl_1=0,b_lh_co_lh_1=0,a_hl_co_hl_2=0,
 ci_hl_co_hl_1=0,ci_lh_co_lh_2=0;
// Delays
 (        A  +=> CO) = (a_lh_co_lh_1,a_hl_co_hl_2);
 (        B  +=> CO) = (b_lh_co_lh_1,b_hl_co_hl_1);
 (        CI +=> CO) = (ci_lh_co_lh_2,ci_hl_co_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
