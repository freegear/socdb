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
// Filename     	: labhb2.v
// Description  	:  Buffered Latch with Clear, Preset, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.6
//
//


module labhb2 (E,D,CDN,SDN,Q,QN);

output  Q,QN;
input   E,D,CDN,SDN;

`ifdef neg_tchk
wire d_E,d_D,d_CDN,d_SDN;
`endif

`ifdef functional
U_LD_P_SB_RB_QN #1 (QN,D,E,CDN,SDN);
U_LD_P_SB_RB #1 (Q,D,E,CDN,SDN);
`else
reg notifier;
`ifdef neg_tchk
U_LD_P_SB_RB_QN_NO #0.01 (QN,d_D,d_E,d_CDN,d_SDN,notifier);
U_LD_P_SB_RB_NO #0.01 (Q,d_D,d_E,d_CDN,d_SDN,notifier);
`else
U_LD_P_SB_RB_QN_NO #0.01 (QN,D,E,CDN,SDN,notifier);
U_LD_P_SB_RB_NO #0.01 (Q,D,E,CDN,SDN,notifier);
`endif
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (CDN_buf,d_CDN);
buf (SDN_buf,d_SDN);
`else
buf (CDN_buf,CDN);
buf (SDN_buf,SDN);
`endif


wire vcond1 = ((CDN_buf==1'b1) && (SDN_buf==1'b1));
specify
// Parameter declarations
 specparam tsu_d_h_e=0.14,tsu_d_l_e=0.21,tsu_sdn_h_e=0.00,tsu_cdn_h_e=0.14,
 th_e_d_h=0.00,th_e_d_l=0.00,th_e_sdn_l=0.08,th_e_cdn_l=0.00,tpw_e_h=0.24,
 tpw_sdn_l=0.22,tpw_cdn_l=0.27,cdn_hl_q_hl_1=0,sdn_hl_q_lh_1=0,sdn_lh_q_hl_1=0,
 sdn_lh_qn_lh=0,e_lh_q_hl=0,e_lh_qn_lh=0,e_lh_q_lh=0,e_lh_qn_hl=0,
 d_hl_q_hl=0,d_hl_qn_lh=0,sdn_hl_qn_hl_2=0,cdn_hl_qn_lh_3=0,d_lh_q_lh=0,
 d_lh_qn_hl=0,cdn_lh_q_lh=0,cdn_lh_qn_hl_5=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge E &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),tsu_d_h_e,th_e_d_l,notifier,,,d_E,d_D);
 $setuphold (negedge E &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),tsu_d_l_e,th_e_d_h,notifier,,,d_E,d_D);
 $recrem (posedge SDN &&& (CDN==1'b1),negedge E &&& (CDN==1'b1),tsu_sdn_h_e,th_e_sdn_l,notifier,,,d_SDN,d_E);
 $recrem (posedge CDN &&& (SDN==1'b1),negedge E &&& (SDN==1'b1),tsu_cdn_h_e,th_e_cdn_l,notifier,,,d_CDN,d_E);
`else
 $setup (posedge D &&& (vcond1==1'b1),negedge E &&& (vcond1==1'b1),tsu_d_h_e,notifier);
 $setup (negedge D &&& (vcond1==1'b1),negedge E &&& (vcond1==1'b1),tsu_d_l_e,notifier);
 $recovery (posedge SDN &&& (CDN==1'b1),negedge E &&& (CDN==1'b1),tsu_sdn_h_e,notifier);
 $recovery (posedge CDN &&& (SDN==1'b1),negedge E &&& (SDN==1'b1),tsu_cdn_h_e,notifier);
 $hold  (negedge E &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),th_e_d_h,notifier);
 $hold  (negedge E &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),th_e_d_l,notifier);
 $hold  (negedge E &&& (CDN==1'b1),posedge SDN &&& (CDN==1'b1),th_e_sdn_l,notifier);
 $hold  (negedge E &&& (SDN==1'b1),posedge CDN &&& (SDN==1'b1),th_e_cdn_l,notifier);
`endif
 $width (posedge E &&& (vcond1==1'b1),tpw_e_h,0,notifier);
 $width (negedge SDN &&& (CDN==1'b1),tpw_sdn_l,0,notifier);
 $width (negedge CDN &&& (SDN==1'b1),tpw_cdn_l,0,notifier);
// Delays
 if (SDN==1'b1)
 (        CDN +=> Q ) = (cdn_lh_q_lh,cdn_hl_q_hl_1);
 (        SDN -=> Q ) = (sdn_hl_q_lh_1,sdn_lh_q_hl_1);
 if (CDN==1'b1)
 (        SDN +=> QN) = (sdn_lh_qn_lh,sdn_hl_qn_hl_2);
 if ((E==1'b1) && (CDN==1'b1) && (SDN==1'b1))
 (        D   +=> Q ) = (d_lh_q_lh,d_hl_q_hl);
 if ((E==1'b1) && (CDN==1'b1) && (SDN==1'b1))
 (        D   -=> QN) = (d_hl_qn_lh,d_lh_qn_hl);
 (        CDN -=> QN) = (cdn_hl_qn_lh_3,cdn_lh_qn_hl_5);
 if ((CDN==1'b1) && (SDN==1'b1))
 (posedge E    => (Q  +: D   )) = (e_lh_q_lh,e_lh_q_hl);
 if ((CDN==1'b1) && (SDN==1'b1))
 (posedge E    => (QN -: D   )) = (e_lh_qn_lh,e_lh_qn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
