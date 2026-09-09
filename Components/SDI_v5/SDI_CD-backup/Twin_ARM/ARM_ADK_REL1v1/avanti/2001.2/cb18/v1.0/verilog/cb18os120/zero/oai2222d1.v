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
// Filename     	: oai2222d1.v
// Description  	:  2/2/2/2 OR-AND-INVERT, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module oai2222d1 (A1,A2,B1,B2,C1,C2,D1,D2,ZN);

output  ZN;
input   A1,A2,B1,B2,C1,C2,D1,D2;

or (g_1_out,D2,D1);
or (g_2_out,B2,B1);
or (g_3_out,A2,A1);
or (g_4_out,C2,C1);
nand #1 (ZN,g_1_out,g_2_out,g_3_out,g_4_out);

`ifdef functional
`else
specify
// Parameter declarations
 specparam b1_hl_zn_lh_2=0,b1_lh_zn_hl_2=0,a1_hl_zn_lh_2=0,a1_lh_zn_hl_2=0,
 a2_hl_zn_lh_2=0,b2_hl_zn_lh_2=0,b2_lh_zn_hl_3=0,a2_lh_zn_hl_8=0,d1_hl_zn_lh_10=0,
 d1_lh_zn_hl_10=0,c1_hl_zn_lh_10=0,c1_lh_zn_hl_10=0,c2_lh_zn_hl_10=0,c2_hl_zn_lh_10=0,
 d2_hl_zn_lh_10=0,d2_lh_zn_hl_11=0;
// Delays
 (        B1 -=> ZN) = (b1_hl_zn_lh_2,b1_lh_zn_hl_2);
 (        A1 -=> ZN) = (a1_hl_zn_lh_2,a1_lh_zn_hl_2);
 (        A2 -=> ZN) = (a2_hl_zn_lh_2,a2_lh_zn_hl_8);
 (        B2 -=> ZN) = (b2_hl_zn_lh_2,b2_lh_zn_hl_3);
 (        D1 -=> ZN) = (d1_hl_zn_lh_10,d1_lh_zn_hl_10);
 (        C1 -=> ZN) = (c1_hl_zn_lh_10,c1_lh_zn_hl_10);
 (        C2 -=> ZN) = (c2_hl_zn_lh_10,c2_lh_zn_hl_10);
 (        D2 -=> ZN) = (d2_hl_zn_lh_10,d2_lh_zn_hl_11);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
