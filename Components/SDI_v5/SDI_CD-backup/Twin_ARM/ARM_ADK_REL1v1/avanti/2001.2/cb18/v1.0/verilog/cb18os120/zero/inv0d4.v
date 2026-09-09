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
// Filename     	: inv0d4.v
// Description  	:  Inverting Buffer, 4X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module inv0d4 (I,ZN);

output  ZN;
input   I;

not #1 (ZN,I);

`ifdef functional
`else
specify
// Parameter declarations
 specparam i_lh_zn_hl=0,i_hl_zn_lh=0;
// Delays
 (        I -=> ZN) = (i_hl_zn_lh,i_lh_zn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
