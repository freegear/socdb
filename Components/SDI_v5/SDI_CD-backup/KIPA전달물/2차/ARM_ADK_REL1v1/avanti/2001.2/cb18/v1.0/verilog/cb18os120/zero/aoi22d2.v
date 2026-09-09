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
// Filename     	: aoi22d2.v
// Description  	:  2/2 AND-OR-INVERT, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module aoi22d2 (A1,A2,B1,B2,ZN);

output  ZN;
input   A1,A2,B1,B2;

and (g_1_out,A2,A1);
and (g_2_out,B2,B1);
nor #1 (ZN,g_1_out,g_2_out);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a2_lh_zn_hl_2=0,a1_hl_zn_lh_2=0,a1_lh_zn_hl_2=0,a2_hl_zn_lh_2=0,
 b1_hl_zn_lh_1=0,b1_lh_zn_hl_1=0,b2_lh_zn_hl_2=0,b2_hl_zn_lh_2=0;
// Delays
 (        A2 -=> ZN) = (a2_hl_zn_lh_2,a2_lh_zn_hl_2);
 (        A1 -=> ZN) = (a1_hl_zn_lh_2,a1_lh_zn_hl_2);
 (        B1 -=> ZN) = (b1_hl_zn_lh_1,b1_lh_zn_hl_1);
 (        B2 -=> ZN) = (b2_hl_zn_lh_2,b2_lh_zn_hl_2);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
