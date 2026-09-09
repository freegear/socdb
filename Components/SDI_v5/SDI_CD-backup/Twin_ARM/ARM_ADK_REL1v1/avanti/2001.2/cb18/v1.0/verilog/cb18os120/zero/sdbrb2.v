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
// Filename     	: sdbrb2.v
// Description  	:  Muxed Scan D Flip-Flop with Clear, Preset, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.6
//
//


module sdbrb2 (D,SD,SC,CP,SDN,CDN,Q,QN);

output  Q,QN;
input   D,SD,SC,CP,SDN,CDN;

`ifdef neg_tchk
wire d_D,d_SD,d_SC,d_CP,d_SDN,d_CDN;
`endif

`ifdef functional
U_FD_N_RB_SB_QN #1 (QN,mux_out,not_CP,CDN,SDN);
U_FD_P_RB_SB #1 (Q,mux_out,CP,CDN,SDN);
`else
reg notifier;
`ifdef neg_tchk
U_FD_N_R_S_NO_QN #0.01 (QN,mux_out,not_CP,not_CDN,not_SDN,notifier);
U_FD_P_RB_SB_NO #0.01 (Q,mux_out,d_CP,d_CDN,d_SDN,notifier);
`else
U_FD_N_R_S_NO_QN #0.01 (QN,mux_out,not_CP,not_CDN,not_SDN,notifier);
U_FD_P_RB_SB_NO #0.01 (Q,mux_out,CP,CDN,SDN,notifier);
`endif
`endif

`ifdef neg_tchk
`ifdef functional
U_MUX_2_1 (mux_out,D,SD,SC);
not (not_CP,CP);
not (not_SDN,SDN);
not (not_CDN,CDN);
`else
U_MUX_2_1 (mux_out,d_D,d_SD,d_SC);
not (not_CP,d_CP);
not (not_SDN,d_SDN);
not (not_CDN,d_CDN);
`endif
`else
U_MUX_2_1 (mux_out,D,SD,SC);
not (not_CP,CP);
not (not_SDN,SDN);
not (not_CDN,CDN);
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (SC_buf,d_SC);
buf (SDN_buf,d_SDN);
buf (CDN_buf,d_CDN);
`else
buf (SC_buf,SC);
buf (SDN_buf,SDN);
buf (CDN_buf,CDN);
`endif

wire vcond1 = ((SC_buf==1'b1) && (SDN_buf==1'b1) && (CDN_buf==1'b1));
wire vcond2 = ((SDN_buf==1'b1) && (CDN_buf==1'b1));
wire vcond3 = ((SC_buf==1'b0) && (SDN_buf==1'b1) && (CDN_buf==1'b1));
specify
// Parameter declarations
 specparam tsu_sd_h_cp=0.53,tsu_sd_l_cp=0.60,tsu_sc_h_cp=0.51,tsu_sc_l_cp=0.47,
 tsu_d_h_cp=0.34,tsu_d_l_cp=0.40,tsu_sdn_h_cp=0.00,tsu_cdn_h_cp=0.00,th_cp_sd_h=0.00,
 th_cp_sd_l=0.00,th_cp_sc_h=0.00,th_cp_sc_l=0.00,th_cp_d_h=0.00,th_cp_d_l=0.00,
 th_cp_sdn_l=0.16,th_cp_cdn_l=0.30,tpw_cp_h=0.47,tpw_cp_l=0.43,tpw_sdn_l=0.42,
 tpw_cdn_l=0.40,sdn_lh_qn_lh_1=0,cdn_lh_q_lh_1=0,cp_lh_qn_lh_1=0,cp_lh_q_hl_1=0,
 cdn_hl_q_hl_8=0,cp_lh_qn_hl_1=0,cp_lh_q_lh_1=0,sdn_hl_qn_hl_15=0,sdn_hl_q_lh_7=0,cdn_hl_qn_lh_6=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),tsu_sd_h_cp,th_cp_sd_l,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),tsu_sd_l_cp,th_cp_sd_h,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (vcond2==1'b1),posedge SC &&& (vcond2==1'b1),tsu_sc_h_cp,th_cp_sc_l,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (vcond2==1'b1),negedge SC &&& (vcond2==1'b1),tsu_sc_l_cp,th_cp_sc_h,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (vcond3==1'b1),posedge D &&& (vcond3==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (vcond3==1'b1),negedge D &&& (vcond3==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
 $recrem (posedge SDN &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_sdn_h_cp,th_cp_sdn_l,notifier,,,d_SDN,d_CP);
 $recrem (posedge CDN &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_cdn_h_cp,th_cp_cdn_l,notifier,,,d_CDN,d_CP);
`else
 $setup (posedge SD &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_sd_h_cp,notifier);
 $setup (negedge SD &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_sd_l_cp,notifier);
 $setup (posedge SC &&& (vcond2==1'b1),posedge CP &&& (vcond2==1'b1),tsu_sc_h_cp,notifier);
 $setup (negedge SC &&& (vcond2==1'b1),posedge CP &&& (vcond2==1'b1),tsu_sc_l_cp,notifier);
 $setup (posedge D &&& (vcond3==1'b1),posedge CP &&& (vcond3==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (vcond3==1'b1),posedge CP &&& (vcond3==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge SDN &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_sdn_h_cp,notifier);
 $recovery (posedge CDN &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_cdn_h_cp,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),th_cp_sd_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),th_cp_sd_l,notifier);
 $hold  (posedge CP &&& (vcond2==1'b1),negedge SC &&& (vcond2==1'b1),th_cp_sc_h,notifier);
 $hold  (posedge CP &&& (vcond2==1'b1),posedge SC &&& (vcond2==1'b1),th_cp_sc_l,notifier);
 $hold  (posedge CP &&& (vcond3==1'b1),negedge D &&& (vcond3==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (vcond3==1'b1),posedge D &&& (vcond3==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),posedge SDN &&& (CDN==1'b1),th_cp_sdn_l,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),posedge CDN &&& (SDN==1'b1),th_cp_cdn_l,notifier);
`endif
 $width (posedge CP &&& (vcond2==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (vcond2==1'b1),tpw_cp_l,0,notifier);
 $width (negedge SDN &&& (CDN==1'b1),tpw_sdn_l,0,notifier);
 $width (negedge CDN &&& (SDN==1'b1),tpw_cdn_l,0,notifier);
// Delays
 (        SDN +=> QN) = (sdn_lh_qn_lh_1,sdn_hl_qn_hl_15);
 (        CDN +=> Q ) = (cdn_lh_q_lh_1,cdn_hl_q_hl_8);
 if ((SDN==1'b1) && (CDN==1'b1))
 (posedge CP   => (QN -: ((D && ~SC) || (SD && SC)))) = (cp_lh_qn_lh_1,cp_lh_qn_hl_1);
 if ((SDN==1'b1) && (CDN==1'b1))
 (posedge CP   => (Q  +: ((D && ~SC) || (SD && SC)))) = (cp_lh_q_lh_1,cp_lh_q_hl_1);
 (negedge SDN  => (Q  +: 1'b1)) = (sdn_hl_q_lh_7,0);
 (negedge CDN  => (QN +: 1'b1)) = (cdn_hl_qn_lh_6,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
