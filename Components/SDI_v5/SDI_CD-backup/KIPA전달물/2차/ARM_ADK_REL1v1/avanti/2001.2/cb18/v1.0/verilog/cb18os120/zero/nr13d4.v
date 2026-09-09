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
// Filename     	: nr13d4.v
// Description  	:  3-Input NOR with 1 Inverted Input, 4X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module nr13d4 (A1,A2,A3,ZN);

output  ZN;
input   A1,A2,A3;

not #1 (not_A3,A3);
not #1 (not_A2,A2);
and #1 (ZN,not_A3,not_A2,A1);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a1_lh_zn_lh=0,a1_hl_zn_hl=0,a2_lh_zn_hl=0,a2_hl_zn_lh=0,
 a3_lh_zn_hl=0,a3_hl_zn_lh=0;
// Delays
 (        A1 +=> ZN) = (a1_lh_zn_lh,a1_hl_zn_hl);
 (        A2 -=> ZN) = (a2_hl_zn_lh,a2_lh_zn_hl);
 (        A3 -=> ZN) = (a3_hl_zn_lh,a3_lh_zn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
