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
// Filename     	: oai21d1.v
// Description  	:  2/1 OR-AND-INVERT, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module oai21d1 (B1,B2,A,ZN);

output  ZN;
input   B1,B2,A;

or (g_2_out,B1,B2);
nand #1 (ZN,A,g_2_out);

`ifdef functional
`else
specify
// Parameter declarations
 specparam b1_hl_zn_lh=0,b1_lh_zn_hl=0,b2_lh_zn_hl=0,a_hl_zn_lh_2=0,
 a_lh_zn_hl_2=0,b2_hl_zn_lh=0;
// Delays
 (        B1 -=> ZN) = (b1_hl_zn_lh,b1_lh_zn_hl);
 (        B2 -=> ZN) = (b2_hl_zn_lh,b2_lh_zn_hl);
 (        A  -=> ZN) = (a_hl_zn_lh_2,a_lh_zn_hl_2);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
