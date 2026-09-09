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
// Filename     	: oai211d2.v
// Description  	:  2/1/1 OR-AND-INVERT, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module oai211d2 (C1,C2,A,B,ZN);

output  ZN;
input   C1,C2,A,B;

and (g_1_out,B,A,C1);
and (g_2_out,B,A,C2);
nor #1 (ZN,g_1_out,g_2_out);

`ifdef functional
`else
specify
// Parameter declarations
 specparam c1_hl_zn_lh=0,c1_lh_zn_hl=0,c2_lh_zn_hl=0,a_hl_zn_lh_2=0,
 a_lh_zn_hl_2=0,b_hl_zn_lh_2=0,b_lh_zn_hl_2=0,c2_hl_zn_lh=0;
// Delays
 (        C1 -=> ZN) = (c1_hl_zn_lh,c1_lh_zn_hl);
 (        C2 -=> ZN) = (c2_hl_zn_lh,c2_lh_zn_hl);
 (        A  -=> ZN) = (a_hl_zn_lh_2,a_lh_zn_hl_2);
 (        B  -=> ZN) = (b_hl_zn_lh_2,b_lh_zn_hl_2);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
