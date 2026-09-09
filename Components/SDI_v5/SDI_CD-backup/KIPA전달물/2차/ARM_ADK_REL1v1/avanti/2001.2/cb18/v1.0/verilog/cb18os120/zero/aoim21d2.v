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
// Filename     	: aoim21d2.v
// Description  	:  2/1 AND-OR-INVERT with B Inputs Inverted, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module aoim21d2 (B2,B1,A,ZN);

output  ZN;
input   B2,B1,A;

buf (B2_buf,B2);
buf (B1_buf,B1);
buf (A_buf,A);

wire ZN_OUT = !((A_buf) || (!B1_buf && !B2_buf));

buf #1 (ZN,ZN_OUT);

`ifdef functional
`else
specify
// Parameter declarations
 specparam b1_lh_zn_lh=0,a_lh_zn_hl_1=0,a_hl_zn_lh_1=0,b1_hl_zn_hl=0,
 b2_lh_zn_lh=0,b2_hl_zn_hl=0;
// Delays
 (        B1 +=> ZN) = (b1_lh_zn_lh,b1_hl_zn_hl);
 (        A  -=> ZN) = (a_hl_zn_lh_1,a_lh_zn_hl_1);
 (        B2 +=> ZN) = (b2_lh_zn_lh,b2_hl_zn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
