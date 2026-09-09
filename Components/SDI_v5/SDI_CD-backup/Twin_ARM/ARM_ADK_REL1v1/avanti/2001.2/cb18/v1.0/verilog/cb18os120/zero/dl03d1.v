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
 `timescale 1ps / 1ps
 `delay_mode_path
`endif 


// Model type   	: zero timing
// Filename     	: dl03d1.v
// Description  	:  Non Inverting Delay Buffer with 4X Delay, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.2
//
//


module dl03d1 (I,Z);

output  Z;
input   I;

buf #1 (Z,I);

`ifdef functional
`else
specify
// Parameter declarations
 specparam i_lh_z_lh=0,i_hl_z_hl=0;
// Delays
 (        I +=> Z) = (i_lh_z_lh,i_hl_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
