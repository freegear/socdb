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
// Filename     	: aor22d1.v
// Description  	:  2/2 AND-OR, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module aor22d1 (B2,B1,A2,A1,Z);

output  Z;
input   B2,B1,A2,A1;

and (g_1_out,B2,B1);
and (g_2_out,A2,A1);
or #1 (Z,g_1_out,g_2_out);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a2_lh_z_lh_2=0,a1_hl_z_hl_2=0,a1_lh_z_lh_2=0,a2_hl_z_hl_2=0,
 b1_hl_z_hl_1=0,b1_lh_z_lh_1=0,b2_lh_z_lh_2=0,b2_hl_z_hl_2=0;
// Delays
 (        A2 +=> Z) = (a2_lh_z_lh_2,a2_hl_z_hl_2);
 (        A1 +=> Z) = (a1_lh_z_lh_2,a1_hl_z_hl_2);
 (        B1 +=> Z) = (b1_lh_z_lh_1,b1_hl_z_hl_1);
 (        B2 +=> Z) = (b2_lh_z_lh_2,b2_hl_z_hl_2);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
