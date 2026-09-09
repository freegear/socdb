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
// Filename     	: decfq1.v
// Description  	:  Buffered Enabled D Flip-Flop with Clear and Q only, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.6
//
//


module decfq1 (CPN,CDN,D,ENN,Q);

output  Q;
input   CPN,CDN,D,ENN;

`ifdef neg_tchk
wire d_CPN,d_CDN,d_D,d_ENN;
`endif

`ifdef neg_tchk
`ifdef functional
buf (CPN_buf,CPN);
buf (CDN_buf,CDN);
buf (D_buf,D);
buf (ENN_buf,ENN);
`else
buf (CPN_buf,d_CPN);
buf (CDN_buf,d_CDN);
buf (D_buf,d_D);
buf (ENN_buf,d_ENN);
`endif
`else
buf (CPN_buf,CPN);
buf (CDN_buf,CDN);
buf (D_buf,D);
buf (ENN_buf,ENN);
`endif

wire BOOL_OUT = (((!ENN_buf && D_buf)) && ((!ENN_buf))) || !(!Q || ((!ENN_buf)));

`ifdef functional
s_decfq1 #1 (Q,CPN,ENN,CDN,D,1'b1);
`else
reg notifier;
`ifdef neg_tchk
s_decfq1 #1 (Q,d_CPN,d_ENN,d_CDN,d_D,notifier);
`else
s_decfq1 #1 (Q,CPN,ENN,CDN,D,notifier);
`endif
`endif

`ifdef functional
`else
wire vcond1 = ((CDN_buf==1'b1) && (ENN_buf==1'b0));
specify
// Parameter declarations
 specparam tsu_enn_h_cpn=0.25,tsu_enn_l_cpn=0.46,tsu_d_h_cpn=0.24,tsu_d_l_cpn=0.39,
 tsu_cdn_h_cpn=0.00,th_cpn_enn_h=0.00,th_cpn_enn_l=0.00,th_cpn_d_h=0.00,th_cpn_d_l=0.00,
 th_cpn_cdn_l=0.37,tpw_cpn_l=0.32,tpw_cpn_h=0.34,tpw_cdn_l=0.20,cpn_hl_q_lh=0,
 cpn_hl_q_hl=0,cdn_hl_q_hl_1=0;
// Violation constraints
`ifdef neg_tchk
$setuphold (negedge CPN &&& (CDN==1'b1),posedge ENN &&& (CDN==1'b1),tsu_enn_h_cpn,th_cpn_enn_l,notifier,,,d_CPN,d_ENN);
$setuphold (negedge CPN &&& (CDN==1'b1),negedge ENN &&& (CDN==1'b1),tsu_enn_l_cpn,th_cpn_enn_h,notifier,,,d_CPN,d_ENN);
$setuphold (negedge CPN &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),tsu_d_h_cpn,th_cpn_d_l,notifier,,,d_CPN,d_D);
$setuphold (negedge CPN &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),tsu_d_l_cpn,th_cpn_d_h,notifier,,,d_CPN,d_D);
$recrem (posedge CDN &&& (ENN==1'b0),negedge CPN &&& (ENN==1'b0),th_cpn_cdn_l,tsu_cdn_h_cpn,notifier,,,d_CDN,d_CPN);
`else
 $setup (posedge ENN &&& (CDN==1'b1),negedge CPN &&& (CDN==1'b1),tsu_enn_h_cpn,notifier);
 $setup (negedge ENN &&& (CDN==1'b1),negedge CPN &&& (CDN==1'b1),tsu_enn_l_cpn,notifier);
 $setup (posedge D &&& (vcond1==1'b1),negedge CPN &&& (vcond1==1'b1),tsu_d_h_cpn,notifier);
 $setup (negedge D &&& (vcond1==1'b1),negedge CPN &&& (vcond1==1'b1),tsu_d_l_cpn,notifier);
 $recovery (posedge CDN &&& (ENN==1'b0),negedge CPN &&& (ENN==1'b0),tsu_cdn_h_cpn,notifier);
 $hold  (negedge CPN &&& (CDN==1'b1),negedge ENN &&& (CDN==1'b1),th_cpn_enn_h,notifier);
 $hold  (negedge CPN &&& (CDN==1'b1),posedge ENN &&& (CDN==1'b1),th_cpn_enn_l,notifier);
 $hold  (negedge CPN &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),th_cpn_d_h,notifier);
 $hold  (negedge CPN &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),th_cpn_d_l,notifier);
 $hold  (negedge CPN &&& (ENN==1'b0),posedge CDN &&& (ENN==1'b0),th_cpn_cdn_l,notifier);
`endif
 $width (negedge CPN &&& (vcond1==1'b1),tpw_cpn_l,0,notifier);
 $width (posedge CPN &&& (vcond1==1'b1),tpw_cpn_h,0,notifier);
 $width (negedge CDN,tpw_cdn_l,0,notifier);
// Delays
 if ((CDN==1'b1) && (ENN==1'b0))
 (negedge CPN  => (Q +: BOOL_OUT)) = (cpn_hl_q_lh,cpn_hl_q_hl);
 (negedge CDN  => (Q -: 1'b1)) = (0,cdn_hl_q_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
 
primitive s_decfq1(Q,CPN,ENN,CDN,D,notifier);

output Q;
reg Q;
input CPN,ENN,CDN,D,notifier;

table
// CPN  ENN   CDN   D  notifier : -  :  Q;
    ?    ?     ?    ?    *      : ?  :  x;
    ?    ?     0    ?    ?      : ?  :  0;
    f    0     1    1    ?      : ?  :  1;
    f    0     1    0    ?      : ?  :  0;
    p    ?     ?    ?    ?      : ?  :  -;
    1    ?     1    ?    ?      : ?  :  -;  
    f    1     1    ?    ?      : ?  :  -;
    f    ?     1    0    ?      : 0  :  0;
    f    ?     1    1    ?      : 1  :  1;
    1    ?     x    ?    ?      : 0  :  0;
    f    ?     ?    0    ?      : 0  :  0;
    f    0     ?    0    ?      : ?  :  0;
    f    1     x    ?    ?      : 0  :  0;
    n    ?     1    0    ?      : 0  :  0;
    n    ?     1    1    ?      : 1  :  1;
    ?    ?     p    ?    ?      : ?  :  -;
    ?    *     ?    ?    ?      : ?  :  -;
    ?    ?     ?    *    ?      : ?  :  -;
    ?    ?    (?1)  ?    ?      : ?  :  -;
    ?    ?    (1x)  ?    ?      : 0  :  0;
endtable
endprimitive
