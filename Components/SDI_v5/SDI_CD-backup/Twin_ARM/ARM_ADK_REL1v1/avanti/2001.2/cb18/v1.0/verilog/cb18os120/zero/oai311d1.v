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
// Filename     	: oai311d1.v
// Description  	:  3/1/1 OR-AND-INVERT, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module oai311d1 (C3,C2,C1,B,A,ZN);

output  ZN;
input   C3,C2,C1,B,A;

or (g_3_out,C1,C3,C2);
nand #1 (ZN,B,A,g_3_out);

`ifdef functional
`else
specify
// Parameter declarations
 specparam c1_hl_zn_lh=0,c1_lh_zn_hl=0,c2_lh_zn_hl=0,b_hl_zn_lh_2=0,
 c2_hl_zn_lh=0,c3_lh_zn_hl=0,a_hl_zn_lh_4=0,a_lh_zn_hl_4=0,b_lh_zn_hl_4=0,c3_hl_zn_lh=0;
// Delays
 (        C1 -=> ZN) = (c1_hl_zn_lh,c1_lh_zn_hl);
 (        C2 -=> ZN) = (c2_hl_zn_lh,c2_lh_zn_hl);
 (        B  -=> ZN) = (b_hl_zn_lh_2,b_lh_zn_hl_4);
 (        C3 -=> ZN) = (c3_hl_zn_lh,c3_lh_zn_hl);
 (        A  -=> ZN) = (a_hl_zn_lh_4,a_lh_zn_hl_4);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
