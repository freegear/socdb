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
// Filename     	: lanhn2.v
// Description  	:  Buffered Latch with QN only, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.6
//
//


module lanhn2 (E,D,QN);

output  QN;
input   E,D;

`ifdef neg_tchk
wire d_E,d_D;
`endif

`ifdef functional
buf b_E (E_buf,E);
buf b_D (D_buf,D);
s_lanhn #0.01 (QN,E_buf,D_buf,1'b0);
`else
reg notifier;

`ifdef neg_tchk
buf b_E (E_buf,d_E);
buf b_D (D_buf,d_D);
s_lanhn #0.01 (QN,E_buf,D_buf,notifier);
`else
buf b_E (E_buf,E);
buf b_D (D_buf,D);
s_lanhn #0.01 (QN,E_buf,D_buf,notifier);
`endif
`endif


`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_e=0.31,tsu_d_l_e=0.21,th_e_d_h=0.00,th_e_d_l=0.00,
 tpw_e_h=0.24,d_lh_qn_hl=0,d_hl_qn_lh=0,e_lh_qn_hl=0,e_lh_qn_lh=0;
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
 (        D -=> QN) = (d_hl_qn_lh,d_lh_qn_hl);
 (posedge E  => (QN -: D )) = (e_lh_qn_lh,e_lh_qn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps

