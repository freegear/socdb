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
// Filename     	: oaim311d4.v
// Description  	:  3/1/1 OR-AND-INVERT with C Inputs Inverted, 4X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module oaim311d4 (C3,C2,C1,B,A,ZN);

output  ZN;
input   C3,C2,C1,B,A;

buf (C3_buf,C3);
buf (C2_buf,C2);
buf (C1_buf,C1);
buf (B_buf,B);
buf (A_buf,A);

wire ZN_OUT = ((!B_buf) || (!A_buf) || (C1_buf && C3_buf && C2_buf));

buf #1 (ZN,ZN_OUT);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a_lh_zn_hl_1=0,a_hl_zn_lh_1=0,b_hl_zn_lh_1=0,b_lh_zn_hl_1=0,
 c1_lh_zn_lh=0,c1_hl_zn_hl=0,c2_hl_zn_hl=0,c2_lh_zn_lh=0,c3_hl_zn_hl=0,c3_lh_zn_lh=0;
// Delays
 (        A  -=> ZN) = (a_hl_zn_lh_1,a_lh_zn_hl_1);
 (        B  -=> ZN) = (b_hl_zn_lh_1,b_lh_zn_hl_1);
 (        C1 +=> ZN) = (c1_lh_zn_lh,c1_hl_zn_hl);
 (        C2 +=> ZN) = (c2_lh_zn_lh,c2_hl_zn_hl);
 (        C3 +=> ZN) = (c3_lh_zn_lh,c3_hl_zn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
