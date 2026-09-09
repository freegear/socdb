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
// Filename     	: nd12d1.v
// Description  	:  2-Input NAND with one Input Inverted, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module nd12d1 (A1,A2,ZN);

output  ZN;
input   A1,A2;

not #1 (not_A2,A2);
or #1 (ZN,not_A2,A1);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a2_lh_zn_hl=0,a1_lh_zn_lh=0,a1_hl_zn_hl=0,a2_hl_zn_lh=0;
// Delays
 (        A2 -=> ZN) = (a2_hl_zn_lh,a2_lh_zn_hl);
 (        A1 +=> ZN) = (a1_lh_zn_lh,a1_hl_zn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
