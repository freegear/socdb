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
// Filename     	: oai322d4.v
// Description  	:  3/2/2 OR-AND-INVERT, 4X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module oai322d4 (C3,C2,C1,B2,B1,A2,A1,ZN);

output  ZN;
input   C3,C2,C1,B2,B1,A2,A1;

or (g_1_out,B2,B1);
or (g_2_out,A2,A1);
or (g_3_out,C2,C1,C3);
nand #1 (ZN,g_1_out,g_2_out,g_3_out);

`ifdef functional
`else
specify
// Parameter declarations
 specparam c1_hl_zn_lh_5=0,c1_lh_zn_hl_5=0,c2_hl_zn_lh_5=0,c2_lh_zn_hl_6=0,
 b1_hl_zn_lh_11=0,b1_lh_zn_hl_11=0,a1_hl_zn_lh_11=0,a1_lh_zn_hl_11=0,a2_lh_zn_hl_11=0,
 a2_hl_zn_lh_11=0,b2_hl_zn_lh_11=0,b2_lh_zn_hl_12=0,c3_lh_zn_hl_6=0,c3_hl_zn_lh_6=0;
// Delays
 (        C1 -=> ZN) = (c1_hl_zn_lh_5,c1_lh_zn_hl_5);
 (        C2 -=> ZN) = (c2_hl_zn_lh_5,c2_lh_zn_hl_6);
 (        B1 -=> ZN) = (b1_hl_zn_lh_11,b1_lh_zn_hl_11);
 (        A1 -=> ZN) = (a1_hl_zn_lh_11,a1_lh_zn_hl_11);
 (        A2 -=> ZN) = (a2_hl_zn_lh_11,a2_lh_zn_hl_11);
 (        B2 -=> ZN) = (b2_hl_zn_lh_11,b2_lh_zn_hl_12);
 (        C3 -=> ZN) = (c3_hl_zn_lh_6,c3_lh_zn_hl_6);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
