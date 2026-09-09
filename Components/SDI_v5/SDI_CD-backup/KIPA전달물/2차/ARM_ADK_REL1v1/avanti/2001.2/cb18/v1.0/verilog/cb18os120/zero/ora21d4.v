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
// Filename     	: ora21d4.v
// Description  	:  2/1 OR-AND, 4X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module ora21d4 (B2,B1,A,Z);

output  Z;
input   B2,B1,A;

or (g_2_out,B1,B2);
and #1 (Z,A,g_2_out);

`ifdef functional
`else
specify
// Parameter declarations
 specparam b1_hl_z_hl=0,b1_lh_z_lh=0,b2_lh_z_lh=0,a_hl_z_hl_2=0,
 a_lh_z_lh_2=0,b2_hl_z_hl=0;
// Delays
 (        B1 +=> Z) = (b1_lh_z_lh,b1_hl_z_hl);
 (        B2 +=> Z) = (b2_lh_z_lh,b2_hl_z_hl);
 (        A  +=> Z) = (a_lh_z_lh_2,a_hl_z_hl_2);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
