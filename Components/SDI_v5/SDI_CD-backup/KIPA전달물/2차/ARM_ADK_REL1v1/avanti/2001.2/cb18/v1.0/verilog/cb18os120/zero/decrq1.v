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
// Filename     	: decrq1.v
// Description  	:  Buffered Enabled D Flip-Flop with Clear and Q only, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.6
//
//


module decrq1 (CP,CDN,D,ENN,Q);

output  Q;
input   CP,CDN,D,ENN;

`ifdef neg_tchk
wire d_CP,d_CDN,d_D,d_ENN;
`endif

`ifdef neg_tchk
`ifdef functional
buf (CP_buf,CP);
buf (CDN_buf,CDN);
buf (D_buf,D);
buf (ENN_buf,ENN);
`else
buf (CP_buf,d_CP);
buf (CDN_buf,d_CDN);
buf (D_buf,d_D);
buf (ENN_buf,d_ENN);
`endif
`else
buf (CP_buf,CP);
buf (CDN_buf,CDN);
buf (D_buf,D);
buf (ENN_buf,ENN);
`endif

wire BOOL_OUT = (((!ENN_buf && D_buf)) && ((!ENN_buf))) || !(!Q || ((!ENN_buf)));

`ifdef functional
s_decrq1 #1 (Q,CP,ENN,CDN,D,1'b0);
`else
reg notifier;
`ifdef neg_tchk
s_decrq1 #1 (Q,d_CP,d_ENN,d_CDN,d_D,notifier);
`else
s_decrq1 #1 (Q,CP,ENN,CDN,D,notifier);
`endif
`endif

`ifdef functional
`else
wire vcond1 = ((CDN_buf==1'b1) && (ENN_buf==1'b0));
specify
// Parameter declarations
 specparam tsu_enn_h_cp=0.40,tsu_enn_l_cp=0.46,tsu_d_h_cp=0.33,tsu_d_l_cp=0.38,
 tsu_cdn_h_cp=0.00,th_cp_enn_h=0.00,th_cp_enn_l=0.00,th_cp_d_h=0.00,th_cp_d_l=0.00,
 th_cp_cdn_l=0.31,tpw_cp_h=0.23,tpw_cp_l=0.43,tpw_cdn_l=0.20,cp_lh_q_lh=0,
 cp_lh_q_hl=0,cdn_hl_q_hl_1=0;
// Violation constraints
`ifdef neg_tchk
$setuphold (posedge CP &&& (CDN==1'b1),posedge ENN &&& (CDN==1'b1),tsu_enn_h_cp,th_cp_enn_l,notifier,,,d_CP,d_ENN);
$setuphold (posedge CP &&& (CDN==1'b1),negedge ENN &&& (CDN==1'b1),tsu_enn_l_cp,th_cp_enn_h,notifier,,,d_CP,d_ENN);
$setuphold (posedge CP &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
$setuphold (posedge CP &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
$recrem (posedge CDN &&& (ENN==1'b0),posedge CP &&& (ENN==1'b0),tsu_cdn_h_cp,th_cp_cdn_l,notifier,,,d_CDN,d_CP);
`else
 $setup (posedge ENN &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_enn_h_cp,notifier);
 $setup (negedge ENN &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_enn_l_cp,notifier);
 $setup (posedge D &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge CDN &&& (ENN==1'b0),posedge CP &&& (ENN==1'b0),tsu_cdn_h_cp,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),negedge ENN &&& (CDN==1'b1),th_cp_enn_h,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),posedge ENN &&& (CDN==1'b1),th_cp_enn_l,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP &&& (ENN==1'b0),posedge CDN &&& (ENN==1'b0),th_cp_cdn_l,notifier);
`endif
 $width (posedge CP &&& (vcond1==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (vcond1==1'b1),tpw_cp_l,0,notifier);
 $width (negedge CDN,tpw_cdn_l,0,notifier);
// Delays
 if ((CDN==1'b1) && (ENN==1'b0))
 (posedge CP   => (Q +: BOOL_OUT)) = (cp_lh_q_lh,cp_lh_q_hl);
 (negedge CDN  => (Q -: 1'b1)) = (0,cdn_hl_q_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults

primitive s_decrq1(Q,CP,ENN,CDN,D,notifier);

output Q;
reg Q;
input CP,ENN,CDN,D,notifier;

table
// CP  ENN   CDN   D  notifier : -  :  Q;
    ?    ?     ?    ?    *      : ?  :  x;
    ?    ?     0    ?    ?      : ?  :  0;
    r    0     1    1    ?      : ?  :  1;
    r    0     1    0    ?      : ?  :  0;
    n    ?     ?    ?    ?      : ?  :  -;  
    0    ?     1    ?    ?      : ?  :  -;
    r    1     1    ?    ?      : ?  :  -;
    r    ?     1    0    ?      : 0  :  0;
    r    ?     1    1    ?      : 1  :  1;
    0    ?     x    ?    ?      : 0  :  0;
    r    ?     ?    0    ?      : 0  :  0;
    r    0     ?    0    ?      : ?  :  0;
    r    1     x    ?    ?      : 0  :  0;
    p    ?     1    0    ?      : 0  :  0;
    p    ?     1    1    ?      : 1  :  1;
    ?    ?     p    ?    ?      : ?  :  -;
    ?    *     ?    ?    ?      : ?  :  -;
    ?    ?     ?    *    ?      : ?  :  -;
    ?    ?    (?1)  ?    ?      : ?  :  -;
    ?    ?    (1x)  ?    ?      : 0  :  0;
endtable
endprimitive

