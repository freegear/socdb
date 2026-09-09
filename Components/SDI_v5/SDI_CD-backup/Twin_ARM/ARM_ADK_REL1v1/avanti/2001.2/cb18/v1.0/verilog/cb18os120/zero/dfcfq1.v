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
// Filename     	: dfcfq1.v
// Description  	:  Buffered D Flip-Flop with Clear and Q only, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module dfcfq1 (D,CPN,CDN,Q);

output  Q;
input   D,CPN,CDN;

`ifdef neg_tchk
wire d_D,d_CPN,d_CDN;
`endif

`ifdef functional
U_FD_N_RB_NO #1 (Q,D,CPN,CDN,1'b1);
`else
reg notifier;
`ifdef neg_tchk
U_FD_N_RB_NO #0.01 (Q,d_D,d_CPN,d_CDN,notifier);
`else
U_FD_N_RB_NO #0.01 (Q,D,CPN,CDN,notifier);
`endif
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_cpn=0.00,tsu_d_l_cpn=0.21,tsu_cdn_h_cpn=0.00,th_cpn_d_h=0.00,
 th_cpn_d_l=0.14,th_cpn_cdn_l=0.35,tpw_cpn_l=0.30,tpw_cpn_h=0.34,tpw_cdn_l=0.20,
 cpn_hl_q_lh=0,cpn_hl_q_hl=0,cdn_hl_q_hl_1=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge CPN &&& (CDN==1'b1),posedge D &&& (CDN==1'b1),tsu_d_h_cpn,th_cpn_d_l,notifier,,,d_CPN,d_D);
 $setuphold (negedge CPN &&& (CDN==1'b1),negedge D &&& (CDN==1'b1),tsu_d_l_cpn,th_cpn_d_h,notifier,,,d_CPN,d_D);
 $recrem (posedge CDN,negedge CPN,tsu_cdn_h_cpn,th_cpn_cdn_l,notifier,,,d_CDN,d_CPN);
`else
 $setup (posedge D &&& (CDN==1'b1),negedge CPN &&& (CDN==1'b1),tsu_d_h_cpn,notifier);
 $setup (negedge D &&& (CDN==1'b1),negedge CPN &&& (CDN==1'b1),tsu_d_l_cpn,notifier);
 $recovery (posedge CDN,negedge CPN,tsu_cdn_h_cpn,notifier);
 $hold  (negedge CPN &&& (CDN==1'b1),negedge D &&& (CDN==1'b1),th_cpn_d_h,notifier);
 $hold  (negedge CPN &&& (CDN==1'b1),posedge D &&& (CDN==1'b1),th_cpn_d_l,notifier);
 $hold  (negedge CPN,posedge CDN,th_cpn_cdn_l,notifier);
`endif
 $width (negedge CPN &&& (CDN==1'b1),tpw_cpn_l,0,notifier);
 $width (posedge CPN &&& (CDN==1'b1),tpw_cpn_h,0,notifier);
 $width (negedge CDN,tpw_cdn_l,0,notifier);
// Delays
 if (CDN==1'b1)
 (negedge CPN  => (Q +: D   )) = (cpn_hl_q_lh,cpn_hl_q_hl);
 (negedge CDN  => (Q -: 1'b1)) = (0,cdn_hl_q_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
