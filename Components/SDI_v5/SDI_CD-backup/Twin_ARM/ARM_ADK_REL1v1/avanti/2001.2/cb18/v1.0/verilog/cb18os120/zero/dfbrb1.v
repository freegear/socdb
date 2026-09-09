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
// Filename     	: dfbrb1.v
// Description  	:  Buffered D Flip-Flop with Clear, Preset, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.6
//
//


module dfbrb1 (D,CP,SDN,CDN,Q,QN);

output  Q,QN;
input   D,CP,SDN,CDN;

`ifdef neg_tchk
wire d_D,d_CP,d_SDN,d_CDN;
`endif

`ifdef functional
U_FD_N_RB_SB_QN #1 (QN,D,not_CP,CDN,SDN);
U_FD_P_RB_SB #1 (Q,D,CP,CDN,SDN);
`else
reg notifier;
`ifdef neg_tchk
U_FD_N_R_S_NO_QN #1 (QN,d_D,not_CP,not_CDN,not_SDN,notifier);
U_FD_P_RB_SB_NO #1 (Q,d_D,d_CP,d_CDN,d_SDN,notifier);
`else
U_FD_N_R_S_NO_QN #0.01 (QN,D,not_CP,not_CDN,not_SDN,notifier);
U_FD_P_RB_SB_NO #0.01 (Q,D,CP,CDN,SDN,notifier);
`endif
`endif

`ifdef neg_tchk
`ifdef functional
not (not_CP,CP);
not (not_SDN,SDN);
not (not_CDN,CDN);
`else
not (not_CP,d_CP);
not (not_SDN,d_SDN);
not (not_CDN,d_CDN);
`endif
`else
not (not_CP,CP);
not (not_SDN,SDN);
not (not_CDN,CDN);
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (SDN_buf,d_SDN);
buf (CDN_buf,d_CDN);
`else
buf (SDN_buf,SDN);
buf (CDN_buf,CDN);
`endif

wire vcond1 = ((SDN_buf==1'b1) && (CDN_buf==1'b1));
specify
// Parameter declarations
 specparam tsu_d_h_cp=0.16,tsu_d_l_cp=0.22,tsu_sdn_h_cp=0.00,tsu_cdn_h_cp=0.00,
 th_cp_d_h=0.00,th_cp_d_l=0.00,th_cp_sdn_l=0.16,th_cp_cdn_l=0.31,tpw_cp_h=0.29,
 tpw_cp_l=0.43,tpw_sdn_l=0.36,tpw_cdn_l=0.25,sdn_lh_qn_lh_1=0,cp_lh_qn_lh=0,
 cp_lh_q_hl=0,sdn_hl_qn_hl_3=0,sdn_hl_q_lh_2=0,cdn_hl_q_hl_1=0,cdn_hl_qn_lh_2=0,
 cdn_lh_q_lh_1=0,cp_lh_qn_hl=0,cp_lh_q_lh=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
 $recrem (posedge SDN &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_sdn_h_cp,th_cp_sdn_l,notifier,,,d_SDN,d_CP);
 $recrem (posedge CDN &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_cdn_h_cp,th_cp_cdn_l,notifier,,,d_CDN,d_CP);
`else
 $setup (posedge D &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge SDN &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_sdn_h_cp,notifier);
 $recovery (posedge CDN &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_cdn_h_cp,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),posedge SDN &&& (CDN==1'b1),th_cp_sdn_l,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),posedge CDN &&& (SDN==1'b1),th_cp_cdn_l,notifier);
`endif
 $width (posedge CP &&& (vcond1==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (vcond1==1'b1),tpw_cp_l,0,notifier);
 $width (negedge SDN &&& (CDN==1'b1),tpw_sdn_l,0,notifier);
 $width (negedge CDN &&& (SDN==1'b1),tpw_cdn_l,0,notifier);
// Delays
 (        SDN +=> QN) = (sdn_lh_qn_lh_1,sdn_hl_qn_hl_3);
 (        CDN +=> Q ) = (cdn_lh_q_lh_1,cdn_hl_q_hl_1);
 if ((SDN==1'b1) && (CDN==1'b1))
 (posedge CP   => (QN -: D   )) = (cp_lh_qn_lh,cp_lh_qn_hl);
 if ((SDN==1'b1) && (CDN==1'b1))
 (posedge CP   => (Q  +: D   )) = (cp_lh_q_lh,cp_lh_q_hl);
 (negedge SDN  => (Q  +: 1'b1)) = (sdn_hl_q_lh_2,0);
 (negedge CDN  => (QN +: 1'b1)) = (cdn_hl_qn_lh_2,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
