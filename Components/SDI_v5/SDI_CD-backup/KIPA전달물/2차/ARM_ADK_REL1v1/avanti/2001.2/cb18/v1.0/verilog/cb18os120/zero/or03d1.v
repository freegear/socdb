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
// Filename     	: or03d1.v
// Description  	:  3-Input OR, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module or03d1 (A1,A2,A3,Z);

output  Z;
input   A1,A2,A3;

or #1 (Z,A3,A2,A1);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a1_lh_z_lh=0,a1_hl_z_hl=0,a2_lh_z_lh=0,a2_hl_z_hl=0,
 a3_lh_z_lh=0,a3_hl_z_hl=0;
// Delays
 (        A1 +=> Z) = (a1_lh_z_lh,a1_hl_z_hl);
 (        A2 +=> Z) = (a2_lh_z_lh,a2_hl_z_hl);
 (        A3 +=> Z) = (a3_lh_z_lh,a3_hl_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
