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
// Filename     	: mi02d0.v
// Description  	:  2-to-1 Multiplexer, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.2
//
//


module mi02d0 (I0,I1,S,ZN);

output  ZN;
input   I0,I1,S;

U_MUX_2_1_INV #1 (ZN,I0,I1,S);

`ifdef functional
`else
specify
// Parameter declarations
 specparam i0_lh_zn_hl_1=0,i0_hl_zn_lh_1=0,i1_hl_zn_lh_1=0,i1_lh_zn_hl_1=0,
 s_hl_zn_hl=0,s_lh_zn_lh=0;
// Delays
 (        S   => ZN) = (s_lh_zn_lh,s_hl_zn_hl);
 (        I0 -=> ZN) = (i0_hl_zn_lh_1,i0_lh_zn_hl_1);
 (        I1 -=> ZN) = (i1_hl_zn_lh_1,i1_lh_zn_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
