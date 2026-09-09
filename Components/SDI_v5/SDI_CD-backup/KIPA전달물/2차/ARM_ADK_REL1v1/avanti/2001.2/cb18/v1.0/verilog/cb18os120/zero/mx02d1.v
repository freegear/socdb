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
// Filename     	: mx02d1.v
// Description  	:  2-to-1 Multiplexer, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module mx02d1 (I0,I1,S,Z);

output  Z;
input   I0,I1,S;

U_MUX_2_1 #1 (Z,I0,I1,S);

`ifdef functional
`else
specify
// Parameter declarations
 specparam i0_lh_z_lh_1=0,i0_hl_z_hl_1=0,i1_hl_z_hl_1=0,i1_lh_z_lh_1=0,
 s_hl_z_lh=0,s_lh_z_hl=0;
// Delays
 (        S   => Z) = (s_hl_z_lh,s_lh_z_hl);
 (        I0 +=> Z) = (i0_lh_z_lh_1,i0_hl_z_hl_1);
 (        I1 +=> Z) = (i1_lh_z_lh_1,i1_hl_z_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
