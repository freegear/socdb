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
// Filename     	: dfnrb1.v
// Description  	:  Buffered D Flip-Flop, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module dfnrb1 (D,CP,Q,QN);

output  Q,QN;
input   D,CP;

`ifdef neg_tchk
wire d_D,d_CP;
`endif

`ifdef functional
U_FD_P #1 (buf_Q,D,CP);
`else
reg notifier;
`ifdef neg_tchk
U_FD_P_NO #0.01 (buf_Q,d_D,d_CP,notifier);
`else
U_FD_P_NO #0.01 (buf_Q,D,CP,notifier);
`endif
`endif

buf (Q,buf_Q);
not (QN,buf_Q);

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_cp=0.15,tsu_d_l_cp=0.16,th_cp_d_h=0.00,th_cp_d_l=0.00,
 tpw_cp_h=0.24,tpw_cp_l=0.40,cp_lh_qn_hl=0,cp_lh_q_lh=0,cp_lh_qn_lh=0,cp_lh_q_hl=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP,posedge D,tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP,negedge D,tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
`else
 $setup (posedge D,posedge CP,tsu_d_h_cp,notifier);
 $setup (negedge D,posedge CP,tsu_d_l_cp,notifier);
 $hold  (posedge CP,negedge D,th_cp_d_h,notifier);
 $hold  (posedge CP,posedge D,th_cp_d_l,notifier);
`endif
 $width (posedge CP,tpw_cp_h,0,notifier);
 $width (negedge CP,tpw_cp_l,0,notifier);
// Delays
 (posedge CP  => (QN -: D  )) = (cp_lh_qn_lh,cp_lh_qn_hl);
 (posedge CP  => (Q  +: D  )) = (cp_lh_q_lh,cp_lh_q_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
