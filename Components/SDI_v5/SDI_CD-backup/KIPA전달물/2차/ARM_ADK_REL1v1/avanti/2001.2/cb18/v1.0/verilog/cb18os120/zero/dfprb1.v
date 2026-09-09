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
// Filename     	: dfprb1.v
// Description  	:  Buffered D Flip-Flop with Preset, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module dfprb1 (D,CP,SDN,Q,QN);

output  Q,QN;
input   D,CP,SDN;

`ifdef neg_tchk
wire d_D,d_CP,d_SDN;
`endif

`ifdef functional
U_FD_P_SB_NO #1 (buf_Q,D,CP,SDN,1'b1);
`else
reg notifier;
`ifdef neg_tchk
U_FD_P_SB_NO #0.01 (buf_Q,d_D,d_CP,d_SDN,notifier);
`else
U_FD_P_SB_NO #0.01 (buf_Q,D,CP,SDN,notifier);
`endif
`endif

buf (Q,buf_Q);
not (QN,buf_Q);

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_cp=0.13,tsu_d_l_cp=0.20,tsu_sdn_h_cp=0.00,th_cp_d_h=0.00,
 th_cp_d_l=0.00,th_cp_sdn_l=0.21,tpw_cp_h=0.28,tpw_cp_l=0.41,tpw_sdn_l=0.32,
 cp_lh_qn_lh=0,cp_lh_q_hl=0,cp_lh_qn_hl=0,cp_lh_q_lh=0,sdn_hl_qn_hl_1=0,sdn_hl_q_lh_3=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (SDN==1'b1),posedge D &&& (SDN==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (SDN==1'b1),negedge D &&& (SDN==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
 $recrem (posedge SDN,posedge CP,tsu_sdn_h_cp,th_cp_sdn_l,notifier,,,d_SDN,d_CP);
`else
 $setup (posedge D &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge SDN,posedge CP,tsu_sdn_h_cp,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),negedge D &&& (SDN==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),posedge D &&& (SDN==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP,posedge SDN,th_cp_sdn_l,notifier);
`endif
 $width (posedge CP &&& (SDN==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (SDN==1'b1),tpw_cp_l,0,notifier);
 $width (negedge SDN,tpw_sdn_l,0,notifier);
// Delays
 if (SDN==1'b1)
 (posedge CP   => (QN -: D   )) = (cp_lh_qn_lh,cp_lh_qn_hl);
 if (SDN==1'b1)
 (posedge CP   => (Q  +: D   )) = (cp_lh_q_lh,cp_lh_q_hl);
 (negedge SDN  => (QN -: 1'b1)) = (0,sdn_hl_qn_hl_1);
 (negedge SDN  => (Q  +: 1'b1)) = (sdn_hl_q_lh_3,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
