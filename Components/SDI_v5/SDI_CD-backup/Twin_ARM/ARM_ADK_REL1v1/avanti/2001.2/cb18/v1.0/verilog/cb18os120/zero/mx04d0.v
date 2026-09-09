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
// Filename     	: mx04d0.v
// Description  	:  4-to-1 Multiplexer, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.2
//
//


module mx04d0 (I0,I1,I2,I3,S0,S1,Z);

output  Z;
input   I0,I1,I2,I3,S0,S1;

U_MUX_4_2 #1 (Z,I0,I1,I2,I3,S0,S1);

`ifdef functional
`else
specify
// Parameter declarations
 specparam i0_lh_z_lh_1=0,i0_hl_z_hl_1=0,i1_hl_z_hl_1=0,i1_lh_z_lh_3=0,
 s0_hl_z_lh_1=0,s0_lh_z_hl_2=0,i2_hl_z_hl_1=0,i2_lh_z_lh_1=0,i3_hl_z_hl_1=0,
 i3_lh_z_lh_1=0,s1_hl_z_lh_1=0,s1_lh_z_hl_6=0;
// Delays
 (        S0  => Z) = (s0_hl_z_lh_1,s0_lh_z_hl_2);
 (        S1  => Z) = (s1_hl_z_lh_1,s1_lh_z_hl_6);
 (        I0 +=> Z) = (i0_lh_z_lh_1,i0_hl_z_hl_1);
 (        I1 +=> Z) = (i1_lh_z_lh_3,i1_hl_z_hl_1);
 (        I2 +=> Z) = (i2_lh_z_lh_1,i2_hl_z_hl_1);
 (        I3 +=> Z) = (i3_lh_z_lh_1,i3_hl_z_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
