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
// Filename     	: clk2d2.v
// Description  	:  Non-overlapping dual phase Clock Generator, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module clk2d2 (CLK,C,CN);

output  C,CN;
input   CLK;

not inst_1(CN,CLK);
buf inst_2(C,CLK);

`ifdef functional
`else
specify
// Parameter declarations
 specparam clk_lh_cn_hl=0,clk_lh_c_lh=0,clk_hl_c_hl=0,clk_hl_cn_lh=0;
// Delays
 (        CLK -=> CN) = (clk_hl_cn_lh,clk_lh_cn_hl);
 (        CLK +=> C ) = (clk_lh_c_lh,clk_hl_c_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
