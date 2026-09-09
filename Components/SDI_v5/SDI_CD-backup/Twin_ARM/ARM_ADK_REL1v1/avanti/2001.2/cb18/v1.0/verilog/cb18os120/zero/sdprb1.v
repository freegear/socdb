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
// Filename     	: sdprb1.v
// Description  	:  Muxed Scan D Flip-Flop with Preset, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//


module sdprb1 (D,SD,SC,CP,SDN,Q,QN);

output  Q,QN;
input   D,SD,SC,CP,SDN;

`ifdef neg_tchk
wire d_D,d_SD,d_SC,d_CP,d_SDN;
`endif

`ifdef functional
U_FD_P_SB_NO #1 (buf_Q,mux_out,CP,SDN,1'b1);
`else
reg notifier;
`ifdef neg_tchk
U_FD_P_SB_NO #0.01 (buf_Q,mux_out,d_CP,d_SDN,notifier);
`else
U_FD_P_SB_NO #0.01 (buf_Q,mux_out,CP,SDN,notifier);
`endif
`endif

`ifdef neg_tchk
`ifdef functional
U_MUX_2_1 (mux_out,D,SD,SC);
`else
U_MUX_2_1 (mux_out,d_D,d_SD,d_SC);
`endif
`else
U_MUX_2_1 (mux_out,D,SD,SC);
`endif

buf (Q,buf_Q);
not (QN,buf_Q);

`ifdef functional
`else
`ifdef neg_tchk
buf (SC_buf,d_SC);
buf (SDN_buf,d_SDN);
`else
buf (SC_buf,SC);
buf (SDN_buf,SDN);
`endif


wire vcond1 = ((SC_buf==1'b1) && (SDN_buf==1'b1));
wire vcond2 = ((SC_buf==1'b0) && (SDN_buf==1'b1));
specify
// Parameter declarations
 specparam tsu_sd_h_cp=0.50,tsu_sd_l_cp=0.57,tsu_sc_h_cp=0.47,tsu_sc_l_cp=0.50,
 tsu_d_h_cp=0.31,tsu_d_l_cp=0.40,tsu_sdn_h_cp=0.00,th_cp_sd_h=0.00,th_cp_sd_l=0.00,
 th_cp_sc_h=0.00,th_cp_sc_l=0.00,th_cp_d_h=0.00,th_cp_d_l=0.00,th_cp_sdn_l=0.20,
 tpw_cp_h=0.31,tpw_cp_l=0.41,tpw_sdn_l=0.37,cp_lh_qn_lh_1=0,cp_lh_q_hl_1=0,
 sdn_hl_qn_hl_1=0,cp_lh_qn_hl_1=0,cp_lh_q_lh_1=0,sdn_hl_q_lh_6=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),tsu_sd_h_cp,th_cp_sd_l,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),tsu_sd_l_cp,th_cp_sd_h,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (SDN==1'b1),posedge SC &&& (SDN==1'b1),tsu_sc_h_cp,th_cp_sc_l,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (SDN==1'b1),negedge SC &&& (SDN==1'b1),tsu_sc_l_cp,th_cp_sc_h,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (vcond2==1'b1),posedge D &&& (vcond2==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (vcond2==1'b1),negedge D &&& (vcond2==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
 $recrem (posedge SDN,posedge CP,tsu_sdn_h_cp,th_cp_sdn_l,notifier,,,d_SDN,d_CP);
`else
 $setup (posedge SD &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_sd_h_cp,notifier);
 $setup (negedge SD &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_sd_l_cp,notifier);
 $setup (posedge SC &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_sc_h_cp,notifier);
 $setup (negedge SC &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_sc_l_cp,notifier);
 $setup (posedge D &&& (vcond2==1'b1),posedge CP &&& (vcond2==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (vcond2==1'b1),posedge CP &&& (vcond2==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge SDN,posedge CP,tsu_sdn_h_cp,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),th_cp_sd_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),th_cp_sd_l,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),negedge SC &&& (SDN==1'b1),th_cp_sc_h,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),posedge SC &&& (SDN==1'b1),th_cp_sc_l,notifier);
 $hold  (posedge CP &&& (vcond2==1'b1),negedge D &&& (vcond2==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (vcond2==1'b1),posedge D &&& (vcond2==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP,posedge SDN,th_cp_sdn_l,notifier);
`endif
 $width (posedge CP &&& (SDN==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (SDN==1'b1),tpw_cp_l,0,notifier);
 $width (negedge SDN,tpw_sdn_l,0,notifier);
// Delays
 if (SDN==1'b1)
 (posedge CP   => (QN -: ((D && ~SC) || (SD && SC)))) = (cp_lh_qn_lh_1,cp_lh_qn_hl_1);
 if (SDN==1'b1)
 (posedge CP   => (Q  +: ((D && ~SC) || (SD && SC)))) = (cp_lh_q_lh_1,cp_lh_q_hl_1);
 (negedge SDN  => (QN -: 1'b1)) = (0,sdn_hl_qn_hl_1);
 (negedge SDN  => (Q  +: 1'b1)) = (sdn_hl_q_lh_6,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
