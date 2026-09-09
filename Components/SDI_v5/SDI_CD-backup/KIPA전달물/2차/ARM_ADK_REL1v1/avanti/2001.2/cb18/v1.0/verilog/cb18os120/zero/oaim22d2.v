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
// Filename     	: oaim22d2.v
// Description  	:  2/2 OR-AND-INVERT with B Inputs Inverted, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module oaim22d2 (B2,B1,A2,A1,ZN);

output  ZN;
input   B2,B1,A2,A1;

buf (B2_buf,B2);
buf (B1_buf,B1);
buf (A2_buf,A2);
buf (A1_buf,A1);

wire ZN_OUT = ((!A2_buf && !A1_buf) || (B2_buf && B1_buf));

buf #1 (ZN,ZN_OUT);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a1_lh_zn_hl_1=0,a1_hl_zn_lh_1=0,a2_lh_zn_hl_1=0,a2_hl_zn_lh_1=0,
 b1_hl_zn_hl_1=0,b1_lh_zn_lh_2=0,b2_hl_zn_hl_2=0,b2_lh_zn_lh_2=0;
// Delays
 (        A1 -=> ZN) = (a1_hl_zn_lh_1,a1_lh_zn_hl_1);
 (        A2 -=> ZN) = (a2_hl_zn_lh_1,a2_lh_zn_hl_1);
 (        B1 +=> ZN) = (b1_lh_zn_lh_2,b1_hl_zn_hl_1);
 (        B2 +=> ZN) = (b2_lh_zn_lh_2,b2_hl_zn_hl_2);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
