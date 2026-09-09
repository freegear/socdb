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
// Filename     	: lanhq1.v
// Description  	:  Buffered Latch with Q only, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module lanhq1 (E,D,Q);

output  Q;
input   E,D;

`ifdef neg_tchk
wire d_E,d_D;
`endif

`ifdef functional
U_LD_P #1 (Q,D,E);
`else
reg notifier;
`ifdef neg_tchk
U_LD_P_NO #0.01 (Q,d_D,d_E,notifier);
`else
U_LD_P_NO #0.01 (Q,D,E,notifier);
`endif
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_e=0.04,tsu_d_l_e=0.16,th_e_d_h=0.00,th_e_d_l=0.00,
 tpw_e_h=0.24,d_hl_q_hl=0,d_lh_q_lh=0,e_lh_q_lh=0,e_lh_q_hl=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge E,posedge D,tsu_d_h_e,th_e_d_l,notifier,,,d_E,d_D);
 $setuphold (negedge E,negedge D,tsu_d_l_e,th_e_d_h,notifier,,,d_E,d_D);
`else
 $setup (posedge D,negedge E,tsu_d_h_e,notifier);
 $setup (negedge D,negedge E,tsu_d_l_e,notifier);
 $hold  (negedge E,negedge D,th_e_d_h,notifier);
 $hold  (negedge E,posedge D,th_e_d_l,notifier);
`endif
 $width (posedge E,tpw_e_h,0,notifier);
// Delays
 if (E==1'b1)
 (        D +=> Q) = (d_lh_q_lh,d_hl_q_hl);
 (posedge E  => (Q +: D )) = (e_lh_q_lh,e_lh_q_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
