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
// Filename     	: dfnfb1.v
// Description  	:  Buffered D Flip-Flop, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module dfnfb1 (D,CPN,Q,QN);

output  Q,QN;
input   D,CPN;

`ifdef neg_tchk
wire d_CPN,d_D;
`endif

`ifdef functional
U_FD_N #1 (buf_Q,D,CPN);
`else
reg notifier;
`ifdef neg_tchk
U_FD_N_NO #1 (buf_Q,d_D,d_CPN,notifier);
`else
U_FD_N_NO #1 (buf_Q,D,CPN,notifier);
`endif
`endif

buf (Q,buf_Q);
not (QN,buf_Q);

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_cpn=0.04,tsu_d_l_cpn=0.18,th_cpn_d_h=0.00,th_cpn_d_l=0.10,
 tpw_cpn_l=0.39,tpw_cpn_h=0.30,cpn_hl_qn_lh=0,cpn_hl_q_hl=0,cpn_hl_qn_hl=0,cpn_hl_q_lh=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold(negedge CPN, posedge D, tsu_d_h_cpn, th_cpn_d_l, notifier,,,d_CPN,d_D);
 $setuphold(negedge CPN, negedge D, tsu_d_l_cpn, th_cpn_d_h, notifier,,,d_CPN,d_D);
`else
 $setup (posedge D,negedge CPN,tsu_d_h_cpn,notifier);
 $setup (negedge D,negedge CPN,tsu_d_l_cpn,notifier);
 $hold  (negedge CPN,negedge D,th_cpn_d_h,notifier);
 $hold  (negedge CPN,posedge D,th_cpn_d_l,notifier);
`endif
 $width (negedge CPN,tpw_cpn_l,0,notifier);
 $width (posedge CPN,tpw_cpn_h,0,notifier);
// Delays
 (negedge CPN  => (QN -: D   )) = (cpn_hl_qn_lh,cpn_hl_qn_hl);
 (negedge CPN  => (Q  +: D   )) = (cpn_hl_q_lh,cpn_hl_q_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
