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
// Filename     	: aoim22d2.v
// Description  	:  2/2 AND-OR-INVERT with B Inputs Inverted, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module aoim22d2 (B2,B1,A2,A1,Z);

output  Z;
input   B2,B1,A2,A1;

buf (B2_buf,B2);
buf (B1_buf,B1);
buf (A2_buf,A2);
buf (A1_buf,A1);

wire Z_OUT = !((!B2_buf && !B1_buf) || (A2_buf && A1_buf));

buf #1 (Z,Z_OUT);

`ifdef functional
`else
specify
// Parameter declarations
 specparam b1_lh_z_lh_1=0,a1_hl_z_lh_1=0,a2_hl_z_lh_1=0,b1_hl_z_hl_1=0,
 b2_lh_z_lh_1=0,a2_lh_z_hl_3=0,a1_lh_z_hl_3=0,b2_hl_z_hl_1=0;
// Delays
 (        B1 +=> Z) = (b1_lh_z_lh_1,b1_hl_z_hl_1);
 (        A1 -=> Z) = (a1_hl_z_lh_1,a1_lh_z_hl_3);
 (        A2 -=> Z) = (a2_hl_z_lh_1,a2_lh_z_hl_3);
 (        B2 +=> Z) = (b2_lh_z_lh_1,b2_hl_z_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
