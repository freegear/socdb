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
// Filename     	: dfbfb1.v
// Description  	:  Buffered D Flip-Flop with Clear, Preset, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//


module dfbfb1 (D,CPN,SDN,CDN,Q,QN);

output  Q,QN;
input   D,CPN,SDN,CDN;

`ifdef neg_tchk
wire d_D,d_CPN,d_SDN,d_CDN;
`endif

`ifdef functional
U_FD_N_RB_SB_QN #1 (QN,D,CPN,CDN,SDN);
U_FD_N_RB_SB #1 (Q,D,CPN,CDN,SDN);
`else
reg notifier;
`ifdef neg_tchk
U_FD_N_R_S_NO_QN #1 (QN,d_D,d_CPN,not_CDN,not_SDN,notifier);
U_FD_N_RB_SB_NO #1 (Q,d_D,d_CPN,d_CDN,d_SDN,notifier);
`else
U_FD_N_R_S_NO_QN #1 (QN,D,CPN,not_CDN,not_SDN,notifier);
U_FD_N_RB_SB_NO #1 (Q,D,CPN,CDN,SDN,notifier);
`endif
`endif

`ifdef neg_tchk
not (not_SDN,d_SDN);
not (not_CDN,d_CDN);
`else
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
 specparam tsu_d_h_cpn=0.15,tsu_d_l_cpn=0.24,tsu_sdn_h_cpn=0.00,tsu_cdn_h_cpn=0.00,
 th_cpn_d_h=0.00,th_cpn_d_l=0.06,th_cpn_sdn_l=0.13,th_cpn_cdn_l=0.33,tpw_cpn_l=0.40,
 tpw_cpn_h=0.39,tpw_sdn_l=0.32,tpw_cdn_l=0.30,cdn_hl_qn_lh_1=0,sdn_lh_qn_lh_1=0,
 sdn_hl_qn_hl_2=0,sdn_hl_q_lh_1=0,cdn_hl_q_hl_1=0,cpn_hl_qn_hl=0,cpn_hl_q_lh=0,
 cdn_lh_q_lh_1=0,cpn_hl_qn_lh=0,cpn_hl_q_hl=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge CPN &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),tsu_d_h_cpn,th_cpn_d_l,notifier,,,d_CPN,d_D);
 $setuphold (negedge CPN &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),tsu_d_l_cpn,th_cpn_d_h,notifier,,,d_CPN,d_D);
 $recrem (posedge SDN &&& (CDN==1'b1),negedge CPN &&& (CDN==1'b1),tsu_sdn_h_cpn,th_cpn_sdn_l,notifier,,,d_SDN,d_CPN);
 $recrem (posedge CDN &&& (SDN==1'b1),negedge CPN &&& (SDN==1'b1),tsu_cdn_h_cpn,th_cpn_cdn_l,notifier,,,d_CDN,d_CPN);
`else
 $setup (posedge D &&& (vcond1==1'b1),negedge CPN &&& (vcond1==1'b1),tsu_d_h_cpn,notifier);
 $setup (negedge D &&& (vcond1==1'b1),negedge CPN &&& (vcond1==1'b1),tsu_d_l_cpn,notifier);
 $recovery (posedge SDN &&& (CDN==1'b1),negedge CPN &&& (CDN==1'b1),tsu_sdn_h_cpn,notifier);
 $recovery (posedge CDN &&& (SDN==1'b1),negedge CPN &&& (SDN==1'b1),tsu_cdn_h_cpn,notifier);
 $hold  (negedge CPN &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),th_cpn_d_h,notifier);
 $hold  (negedge CPN &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),th_cpn_d_l,notifier);
 $hold  (negedge CPN &&& (CDN==1'b1),posedge SDN &&& (CDN==1'b1),th_cpn_sdn_l,notifier);
 $hold  (negedge CPN &&& (SDN==1'b1),posedge CDN &&& (SDN==1'b1),th_cpn_cdn_l,notifier);
`endif
 $width (negedge CPN &&& (vcond1==1'b1),tpw_cpn_l,0,notifier);
 $width (posedge CPN &&& (vcond1==1'b1),tpw_cpn_h,0,notifier);
 $width (negedge SDN &&& (CDN==1'b1),tpw_sdn_l,0,notifier);
 $width (negedge CDN &&& (SDN==1'b1),tpw_cdn_l,0,notifier);
// Delays
 (        SDN +=> QN) = (sdn_lh_qn_lh_1,sdn_hl_qn_hl_2);
 (        CDN +=> Q ) = (cdn_lh_q_lh_1,cdn_hl_q_hl_1);
 if ((SDN==1'b1) && (CDN==1'b1))
 (negedge CPN  => (QN -: D   )) = (cpn_hl_qn_lh,cpn_hl_qn_hl);
 if ((SDN==1'b1) && (CDN==1'b1))
 (negedge CPN  => (Q  +: D   )) = (cpn_hl_q_lh,cpn_hl_q_hl);
 (negedge CDN  => (QN +: 1'b1)) = (cdn_hl_qn_lh_1,0);
 (negedge SDN  => (Q  +: 1'b1)) = (sdn_hl_q_lh_1,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
