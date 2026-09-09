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
// Filename     	: secrq2.v
// Description  	:  Muxed Scan Enable D Flip-Flop with Clear and Q only, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.10
//
//


module secrq2 (CP,CDN,ENN,D,SC,SD,Q);

output  Q;
input   CP,CDN,ENN,D,SC,SD;

`ifdef neg_tchk
wire d_CP,d_CDN,d_ENN,d_D,d_SC,d_SD;
`endif

`ifdef functional
s_secrq2 #1 (Q,CP,ENN,SC,CDN,D,SD,1'b0);
`else
reg notifier;
`ifdef neg_tchk
s_secrq2 #1 (Q,d_CP,d_ENN,d_SC,d_CDN,d_D,d_SD,notifier);
`else
s_secrq2 #1 (Q,CP,ENN,SC,CDN,D,SD,notifier);
`endif
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (CDN_buf,d_CDN);
buf (SC_buf,d_SC);
buf (ENN_buf,d_ENN);
`else
buf (CDN_buf,CDN);
buf (SC_buf,SC);
buf (ENN_buf,ENN);
`endif


wire vcond1 = ((CDN_buf==1'b1) && (SC_buf==1'b1));
wire vcond_CDN_vio = ((ENN_buf==1'b0) || (SC_buf==1'b1));
wire vcond_ENN_vio = ((CDN_buf==1'b1) && (SC_buf==1'b0));
wire vcond_D_vio = ((CDN_buf==1'b1) && (SC_buf==1'b0) && (ENN_buf==1'b0));
wire vcond2 = ((CDN_buf==1'b1) && (SC_buf==1'b0));
specify
// Parameter declarations
 specparam tsu_sd_h_cp=0.53,tsu_sd_l_cp=0.65,tsu_sc_h_cp=0.67,tsu_sc_l_cp=0.77,
 tsu_enn_h_cp=0.52,tsu_enn_l_cp=0.74,tsu_d_h_cp=0.39,tsu_d_l_cp=0.52,tsu_cdn_h_cp=0.00,
 th_cp_sd_h=0.00,th_cp_sd_l=0.00,th_cp_sc_h=0.00,th_cp_sc_l=0.00,th_cp_enn_h=0.00,
 th_cp_enn_l=0.00,th_cp_d_h=0.00,th_cp_d_l=0.00,th_cp_cdn_l=0.22,tpw_cp_h=0.24,
 tpw_cp_l=0.42,tpw_cdn_l=0.20,cp_lh_q_lh_1=0,cp_lh_q_hl_1=0,cdn_hl_q_hl_1=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),tsu_sd_h_cp,th_cp_sd_l,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),tsu_sd_l_cp,th_cp_sd_h,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (CDN==1'b1),posedge SC &&& (CDN==1'b1),tsu_sc_h_cp,th_cp_sc_l,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (CDN==1'b1),negedge SC &&& (CDN==1'b1),tsu_sc_l_cp,th_cp_sc_h,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (CDN==1'b1),posedge ENN &&& (vcond_ENN_vio==1'b1),tsu_enn_h_cp,th_cp_enn_l,notifier,,,d_CP,d_ENN);
 $setuphold (posedge CP &&& (CDN==1'b1),negedge ENN &&& (vcond_ENN_vio==1'b1),tsu_enn_l_cp,th_cp_enn_h,notifier,,,d_CP,d_ENN);
 $setuphold (posedge CP &&& (vcond2==1'b1),posedge D &&& (vcond_D_vio==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (vcond2==1'b1),negedge D &&& (vcond_D_vio==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
 $recrem (posedge CDN &&& (vcond_CDN_vio==1'b1) ,posedge CP,tsu_cdn_h_cp,th_cp_cdn_l,notifier,,,d_CDN,d_CP);
`else
 $setup (posedge SD &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_sd_h_cp,notifier);
 $setup (negedge SD &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_sd_l_cp,notifier);
 $setup (posedge SC &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_sc_h_cp,notifier);
 $setup (negedge SC &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_sc_l_cp,notifier);
 $setup (posedge ENN &&& (vcond_ENN_vio==1'b1),posedge CP &&& (CDN==1'b1),tsu_enn_h_cp,notifier);
 $setup (negedge ENN &&& (vcond_ENN_vio==1'b1),posedge CP &&& (CDN==1'b1),tsu_enn_l_cp,notifier);
 $setup (posedge D &&& (vcond_D_vio==1'b1),posedge CP &&& (vcond2==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (vcond_D_vio==1'b1),posedge CP &&& (vcond2==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge CDN &&& (vcond_CDN_vio==1'b1) ,posedge CP,tsu_cdn_h_cp,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),th_cp_sd_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),th_cp_sd_l,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),negedge SC &&& (CDN==1'b1),th_cp_sc_h,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),posedge SC &&& (CDN==1'b1),th_cp_sc_l,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),negedge ENN &&& (vcond_ENN_vio==1'b1),th_cp_enn_h,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),posedge ENN &&& (vcond_ENN_vio==1'b1),th_cp_enn_l,notifier);
 $hold  (posedge CP &&& (vcond2==1'b1),negedge D &&& (vcond_D_vio==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (vcond2==1'b1),posedge D &&& (vcond_D_vio==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP,posedge CDN &&& (vcond_CDN_vio==1'b1) ,th_cp_cdn_l,notifier);
`endif
 $width (posedge CP &&& (CDN==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (CDN==1'b1),tpw_cp_l,0,notifier);
 $width (negedge CDN,tpw_cdn_l,0,notifier);
// Delays
 (CP   *> Q) = (cp_lh_q_lh_1,cp_lh_q_hl_1);
 (negedge CDN  => (Q -: 1'b1)) = (0,cdn_hl_q_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps

primitive s_secrq2(Q,CP,ENN,SC,CDN,D,SD,notifier);

output Q;
reg    Q;
input  CP,ENN,SC,CDN,D,SD,notifier;

table
// CP   ENN  SC   CDN  D    SD   nfr : - : Q;

   r    ?    1    1    ?    0    ?   : ? : 0;
   r    0    0    1    0    ?    ?   : ? : 0;
   ?    ?    ?    0    ?    ?    ?   : ? : 0;
   r    0    0    1    1    ?    ?   : ? : 1;
   r    ?    1    1    ?    1    ?   : ? : 1;
   p    ?    ?    ?    0    0    ?   : 0 : 0;
   p    ?    ?    1    1    1    ?   : 1 : 1;
   n    ?    ?    1    ?    ?    ?   : ? : -;
   ?    *    ?    ?    ?    ?    ?   : ? : -;
   ?    ?    *    ?    ?    ?    ?   : ? : -;
   ?    ?    ?    p    ?    ?    ?   : ? : -;
   ?    ?    ?    ?    *    ?    ?   : ? : -;
   ?    ?    ?    ?    ?    *    ?   : ? : -;
   *    1    0    1    ?    ?    ?   : ? : -;
   r    x    0    ?    0    ?    ?   : 0 : -;
   r    x    0    1    1    ?    ?   : 1 : -;
   r    0    x    1    0    0    ?   : ? : 0;
   r    0    x    1    1    1    ?   : ? : 1;
   r    1    x    1    ?    0    ?   : 0 : -;
   r    1    x    1    ?    1    ?   : 1 : -;
   r    ?    1    x    ?    0    ?   : ? : 0;
   r    0    0    x    0    ?    ?   : ? : 0;
   r    1    0    x    ?    ?    ?   : 0 : 0;
   r    0    x    x    0    0    ?   : ? : 0;
   r    1    x    x    ?    0    ?   : 0 : 0;
   0    ?    ?    x    ?    ?    ?   : 0 : 0;
   1    ?    ?   (1x)  ?    ?    ?   : 0 : 0;
   ?    ?    ?    ?    ?    ?    *   : ? : x;
endtable
endprimitive

