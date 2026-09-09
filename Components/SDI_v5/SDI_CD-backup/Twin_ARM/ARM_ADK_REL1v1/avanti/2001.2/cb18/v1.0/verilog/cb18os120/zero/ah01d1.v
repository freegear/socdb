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
// Filename     	: ah01d1.v
// Description  	:  1-Bit Half Adder, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module ah01d1 (A,B,S,CO);

output  S,CO;
input   A,B;

xor  #1  (S,B,A);
and  #1  (CO,B,A);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a_lh_co_lh=0,a_lh_s_hl=0,a_hl_co_hl=0,a_hl_s_lh=0,
 b_hl_co_hl=0,b_hl_s_lh=0,b_lh_co_lh=0,b_lh_s_hl=0;
// Delays
 (        A  => S ) = (a_hl_s_lh,a_lh_s_hl);
 (        B  => S ) = (b_hl_s_lh,b_lh_s_hl);
 (        A +=> CO) = (a_lh_co_lh,a_hl_co_hl);
 (        B +=> CO) = (b_lh_co_lh,b_hl_co_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
