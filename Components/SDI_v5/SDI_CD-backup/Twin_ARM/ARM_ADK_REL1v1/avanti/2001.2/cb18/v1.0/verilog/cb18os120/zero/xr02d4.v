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
// Filename     	: xr02d4.v
// Description  	:  2-Input Exclusive OR, 4X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module xr02d4 (A1,A2,Z);

output  Z;
input   A1,A2;

xor #1 (Z,A2,A1);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a1_lh_z_hl=0,a1_hl_z_lh=0,a2_hl_z_lh=0,a2_lh_z_hl=0;
// Delays
 (        A1  => Z) = (a1_hl_z_lh,a1_lh_z_hl);
 (        A2  => Z) = (a2_hl_z_lh,a2_lh_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
