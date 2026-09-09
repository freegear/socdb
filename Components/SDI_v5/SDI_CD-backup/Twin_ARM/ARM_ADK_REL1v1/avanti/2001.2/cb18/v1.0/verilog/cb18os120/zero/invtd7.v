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
// Filename     	: invtd7.v
// Description  	:  Inverting 3-State Buffer with Output Enable, 7X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module invtd7 (I,ZN,EN);

output  ZN;
input   I,EN;

notif0 #1 (ZN,I,EN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam en_lh_zn_hz=0,en_hl_zn_zh=0,i_lh_zn_hl=0,en_lh_zn_lz=0,
 en_hl_zn_zl=0,i_hl_zn_lh=0;
// Delays
 (        EN  => ZN) = (en_lh_zn_lz,en_lh_zn_hz,en_lh_zn_lz,en_hl_zn_zh,en_lh_zn_hz,en_hl_zn_zl);
 (        I  -=> ZN) = (i_hl_zn_lh,i_lh_zn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
