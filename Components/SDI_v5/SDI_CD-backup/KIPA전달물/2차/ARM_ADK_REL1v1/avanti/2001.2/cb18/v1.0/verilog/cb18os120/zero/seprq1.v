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
// Filename     	: seprq1.v
// Description  	:  Muxed Scan Enable D Flip-Flop with Preset and Q only, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.10
//
//


module seprq1 (CP,SDN,ENN,D,SC,SD,Q);

output  Q;
input   CP,SDN,ENN,D,SC,SD;

`ifdef neg_tchk
wire d_CP,d_SDN,d_ENN,d_D,d_SC,d_SD;
`endif

`ifdef functional
s_seprq1 #1 (Q,CP,SC,ENN,SDN,D,SD,1'b0);
`else
reg notifier;
`ifdef neg_tchk
s_seprq1 #1 (Q,d_CP,d_SC,d_ENN,d_SDN,d_D,d_SD,notifier);
`else
s_seprq1 #1 (Q,CP,SC,ENN,SDN,D,SD,notifier);
`endif
`endif


`ifdef functional
`else
`ifdef neg_tchk
buf (SDN_buf,d_SDN);
buf (SC_buf,d_SC);
buf (ENN_buf,d_ENN);
`else
buf (SDN_buf,SDN);
buf (SC_buf,SC);
buf (ENN_buf,ENN);
`endif


wire vcond1 = ((SDN_buf==1'b1) && (SC_buf==1'b1));
wire vcond_SDN_vio = ((ENN_buf==1'b0) || (SC_buf==1'b1));
wire vcond_ENN_vio = ((SDN_buf==1'b1) && (SC_buf==1'b0));
wire vcond_D_vio = ((SDN_buf==1'b1) && (SC_buf==1'b0) && (ENN_buf==1'b0));
wire vcond2 = ((SDN_buf==1'b1) && (SC_buf==1'b0));
specify
// Parameter declarations
 specparam tsu_sd_h_cp=0.52,tsu_sd_l_cp=0.70,tsu_sc_h_cp=0.72,tsu_sc_l_cp=0.76,
 tsu_enn_h_cp=0.52,tsu_enn_l_cp=0.80,tsu_d_h_cp=0.37,tsu_d_l_cp=0.57,tsu_sdn_h_cp=0.00,
 th_cp_sd_h=0.00,th_cp_sd_l=0.00,th_cp_sc_h=0.00,th_cp_sc_l=0.00,th_cp_enn_h=0.00,
 th_cp_enn_l=0.00,th_cp_d_h=0.00,th_cp_d_l=0.00,th_cp_sdn_l=0.07,tpw_cp_h=0.23,
 tpw_cp_l=0.43,tpw_sdn_l=0.40,cp_lh_q_hl_1=0,cp_lh_q_lh_1=0,sdn_hl_q_lh_7=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),tsu_sd_h_cp,th_cp_sd_l,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),tsu_sd_l_cp,th_cp_sd_h,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (SDN==1'b1),posedge SC &&& (SDN==1'b1),tsu_sc_h_cp,th_cp_sc_l,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (SDN==1'b1),negedge SC &&& (SDN==1'b1),tsu_sc_l_cp,th_cp_sc_h,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (SDN==1'b1),posedge ENN &&& (vcond_ENN_vio==1'b1),tsu_enn_h_cp,th_cp_enn_l,notifier,,,d_CP,d_ENN);
 $setuphold (posedge CP &&& (SDN==1'b1),negedge ENN &&& (vcond_ENN_vio==1'b1),tsu_enn_l_cp,th_cp_enn_h,notifier,,,d_CP,d_ENN);
 $setuphold (posedge CP &&& (vcond2==1'b1),posedge D &&& (vcond_D_vio==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (vcond2==1'b1),negedge D &&& (vcond_D_vio==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
 $recrem (posedge SDN &&& (vcond_SDN_vio==1'b1) ,posedge CP,tsu_sdn_h_cp,th_cp_sdn_l,notifier,,,d_SDN,d_CP);
`else
 $setup (posedge SD &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_sd_h_cp,notifier);
 $setup (negedge SD &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_sd_l_cp,notifier);
 $setup (posedge SC &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_sc_h_cp,notifier);
 $setup (negedge SC &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_sc_l_cp,notifier);
 $setup (posedge ENN &&& (vcond_ENN_vio==1'b1),posedge CP &&& (SDN==1'b1),tsu_enn_h_cp,notifier);
 $setup (negedge ENN &&& (vcond_ENN_vio==1'b1),posedge CP &&& (SDN==1'b1),tsu_enn_l_cp,notifier);
 $setup (posedge D &&& (vcond_D_vio==1'b1),posedge CP &&& (vcond2==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (vcond_D_vio==1'b1),posedge CP &&& (vcond2==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge SDN &&& (vcond_SDN_vio==1'b1) ,posedge CP,tsu_sdn_h_cp,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),th_cp_sd_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),th_cp_sd_l,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),negedge SC &&& (SDN==1'b1),th_cp_sc_h,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),posedge SC &&& (SDN==1'b1),th_cp_sc_l,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),negedge ENN &&& (vcond_ENN_vio==1'b1),th_cp_enn_h,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),posedge ENN &&& (vcond_ENN_vio==1'b1),th_cp_enn_l,notifier);
 $hold  (posedge CP &&& (vcond2==1'b1),negedge D &&& (vcond_D_vio==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (vcond2==1'b1),posedge D &&& (vcond_D_vio==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP,posedge SDN &&& (vcond_SDN_vio==1'b1) ,th_cp_sdn_l,notifier);
`endif
 $width (posedge CP &&& (SDN==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (SDN==1'b1),tpw_cp_l,0,notifier);
 $width (negedge SDN,tpw_sdn_l,0,notifier);
// Delays
 (CP   *> Q) = (cp_lh_q_lh_1,cp_lh_q_hl_1);
 (negedge SDN  => (Q +: 1'b1)) = (sdn_hl_q_lh_7,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps


primitive s_seprq1(Q,CP,SC,ENN,SDN,D,SD,notifier);

output Q;
reg    Q;
input  CP,SC,ENN,SDN,D,SD,notifier;

table
// CP   SC   ENN  SDN  D    SD   nfr : - : Q;

   r    1    ?    1    ?    0    ?   : ? : 0;
   r    0    0    1    0    ?    ?   : ? : 0;
   ?    ?    ?    0    ?    ?    ?   : ? : 1;
   r    0    0    1    1    ?    ?   : ? : 1;
   r    1    ?    1    ?    1    ?   : ? : 1;
   p    ?    ?    ?    1    1    ?   : 1 : 1;
   p    ?    ?    1    0    0    ?   : 0 : 0;
   n    ?    ?    1    ?    ?    ?   : ? : -;
   ?    *    ?    ?    ?    ?    ?   : ? : -;
   ?    ?    *    ?    ?    ?    ?   : ? : -;
   ?    ?    ?    p    ?    ?    ?   : ? : -;
   ?    ?    ?    ?    *    ?    ?   : ? : -;
   ?    ?    ?    ?    ?    *    ?   : ? : -;
   *    0    1    1    ?    ?    ?   : ? : -;
   r    0    x    ?    1    ?    ?   : 1 : -;
   r    0    x    1    0    ?    ?   : 0 : -;
   r    x    0    1    0    0    ?   : ? : 0;
   r    x    0    1    1    1    ?   : ? : 1;
   r    x    1    1    ?    0    ?   : 0 : -;
   r    x    1    1    ?    1    ?   : 1 : -;
   r    1    ?    x    ?    1    ?   : ? : 1;
   r    0    0    x    1    ?    ?   : ? : 1;
   r    0    1    x    ?    ?    ?   : 1 : 1;
   r    x    0    x    1    1    ?   : ? : 1;
   r    x    1    x    ?    1    ?   : 1 : 1;
   0    ?    ?    x    ?    ?    ?   : 1 : 1;
   1    ?    ?   (1x)  ?    ?    ?   : 1 : 1;
   ?    ?    ?    ?    ?    ?    *   : ? : x;
endtable
endprimitive
