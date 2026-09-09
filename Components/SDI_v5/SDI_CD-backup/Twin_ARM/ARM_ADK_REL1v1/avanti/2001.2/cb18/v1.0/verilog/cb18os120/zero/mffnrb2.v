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
// Filename     	: mffnrb2.v
// Description  	:  Buffered Enabled D Flip-Flop, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//


module mffnrb2 (CP,D,ENN,Q,QN);

output  Q,QN;
input   CP,D,ENN;

`ifdef neg_tchk
wire d_CP,d_D,d_ENN;
`endif

`ifdef neg_tchk
`ifdef functional
buf (CP_buf,CP);
buf (D_buf,D);
buf (ENN_buf,ENN);
`else
buf (CP_buf,d_CP);
buf (D_buf,d_D);
buf (ENN_buf,d_ENN);
`endif
`else
buf (CP_buf,CP);
buf (D_buf,D);
buf (ENN_buf,ENN);
`endif

wire BOOL_OUT = (((D_buf && !ENN_buf)) && (!(!D_buf && !ENN_buf)) && ((D_buf && !ENN_buf) || (!D_buf && !ENN_buf))) || !(!Q || ((D_buf && !ENN_buf) || (!D_buf && !ENN_buf)));

`ifdef functional
s_mffnrb2 #1 (buf_Q,CP,ENN,D,1'b0);
`else
reg notifier;
`ifdef neg_tchk
s_mffnrb2 #1 (buf_Q,d_CP,d_ENN,d_D,notifier);
`else
s_mffnrb2 #1 (buf_Q,CP,ENN,D,notifier);
`endif
`endif

buf (Q,buf_Q);
not (QN,buf_Q);

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_enn_h_cp=0.40,tsu_enn_l_cp=0.55,tsu_d_h_cp=0.19,tsu_d_l_cp=0.43,
 th_cp_enn_h=0.00,th_cp_enn_l=0.00,th_cp_d_h=0.00,th_cp_d_l=0.00,tpw_cp_h=0.24,
 tpw_cp_l=0.47,cp_lh_qn_lh=0,cp_lh_q_hl=0,cp_lh_qn_hl=0,cp_lh_q_lh=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP,posedge ENN,tsu_enn_h_cp,th_cp_enn_l,notifier,,,d_CP,d_ENN);
 $setuphold (posedge CP,negedge ENN,tsu_enn_l_cp,th_cp_enn_h,notifier,,,d_CP,d_ENN);
 $setuphold (posedge CP &&& (ENN==1'b0),posedge D &&& (ENN==1'b0),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (ENN==1'b0),negedge D &&& (ENN==1'b0),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
`else
 $setup (posedge ENN,posedge CP,tsu_enn_h_cp,notifier);
 $setup (negedge ENN,posedge CP,tsu_enn_l_cp,notifier);
 $setup (posedge D &&& (ENN==1'b0),posedge CP &&& (ENN==1'b0),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (ENN==1'b0),posedge CP &&& (ENN==1'b0),tsu_d_l_cp,notifier);
 $hold  (posedge CP,negedge ENN,th_cp_enn_h,notifier);
 $hold  (posedge CP,posedge ENN,th_cp_enn_l,notifier);
 $hold  (posedge CP &&& (ENN==1'b0),negedge D &&& (ENN==1'b0),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (ENN==1'b0),posedge D &&& (ENN==1'b0),th_cp_d_l,notifier);
`endif
 $width (posedge CP &&& (ENN==1'b0),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (ENN==1'b0),tpw_cp_l,0,notifier);
// Delays
 if (ENN==1'b0)
 (posedge CP  => (QN -: BOOL_OUT)) = (cp_lh_qn_lh,cp_lh_qn_hl);
 if (ENN==1'b0)
 (posedge CP  => (Q  +: BOOL_OUT)) = (cp_lh_q_lh,cp_lh_q_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults

primitive s_mffnrb2(Q,CP,ENN,D,notifier);

output Q;
reg    Q;
input  CP,ENN,D,notifier;

table
// CP   ENN    D    nfr  :  -  :  Q;
   ?     ?     ?     *   :  ?  :  x;
   ?     *     ?     ?   :  ?  :  -;
   ?     ?     *     ?   :  ?  :  -;
   r     0     0     ?   :  ?  :  0;
   r     0     1     ?   :  ?  :  1;
   r     1     ?     ?   :  ?  :  -;
   p     ?     1     ?   :  1  :  1;
   p     ?     0     ?   :  0  :  0;
   0     ?     ?     ?   :  ?  :  -;
   n     ?     ?     ?   :  ?  :  -;
endtable
endprimitive
