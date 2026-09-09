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
// Filename     	: lachq1.v
// Description  	:  High Enable D latch with clear and output Q only, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module lachq1 (E,D,CDN,Q);

output  Q;
input   E,D,CDN;

`ifdef neg_tchk
wire d_E,d_D,d_CDN;
`endif

`ifdef functional
U_LD_P_RB #1 (Q,D,E,CDN);
`else
reg notifier;
`ifdef neg_tchk
U_LD_P_RB_NO #0.01 (Q,d_D,d_E,d_CDN,notifier);
`else
U_LD_P_RB_NO #0.01 (Q,D,E,CDN,notifier);
`endif
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_e=0.03,tsu_d_l_e=0.16,tsu_cdn_h_e=0.03,th_e_d_h=0.00,
 th_e_d_l=0.00,th_e_cdn_l=0.00,tpw_e_h=0.15,tpw_cdn_l=0.25,e_lh_q_lh=0,
 e_lh_q_hl=0,d_lh_q_lh=0,d_hl_q_hl=0,cdn_lh_q_lh=0,cdn_hl_q_hl_3=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge E &&& (CDN==1'b1),posedge D &&& (CDN==1'b1),tsu_d_h_e,th_e_d_l,notifier,,,d_E,d_D);
 $setuphold (negedge E &&& (CDN==1'b1),negedge D &&& (CDN==1'b1),tsu_d_l_e,th_e_d_h,notifier,,,d_E,d_D);
 $recrem (posedge CDN,negedge E,tsu_cdn_h_e,th_e_cdn_l,notifier,,,d_CDN,d_E);
`else
 $setup (posedge D &&& (CDN==1'b1),negedge E &&& (CDN==1'b1),tsu_d_h_e,notifier);
 $setup (negedge D &&& (CDN==1'b1),negedge E &&& (CDN==1'b1),tsu_d_l_e,notifier);
 $recovery (posedge CDN,negedge E,tsu_cdn_h_e,notifier);
 $hold  (negedge E &&& (CDN==1'b1),negedge D &&& (CDN==1'b1),th_e_d_h,notifier);
 $hold  (negedge E &&& (CDN==1'b1),posedge D &&& (CDN==1'b1),th_e_d_l,notifier);
 $hold  (negedge E,posedge CDN,th_e_cdn_l,notifier);
`endif
 $width (posedge E &&& (CDN==1'b1),tpw_e_h,0,notifier);
 $width (negedge CDN,tpw_cdn_l,0,notifier);
// Delays
 if ((E==1'b1) && (CDN==1'b1))
 (        D   +=> Q) = (d_lh_q_lh,d_hl_q_hl);
 (        CDN +=> Q) = (cdn_lh_q_lh,cdn_hl_q_hl_3);
 if (CDN==1'b1)
 (posedge E    => (Q +: D   )) = (e_lh_q_lh,e_lh_q_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
