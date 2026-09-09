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
// Filename     	: dfcrq1.v
// Description  	:  Buffered D Flip-Flop with Clear and Q only, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module dfcrq1 (D,CP,CDN,Q);

output  Q;
input   D,CP,CDN;

`ifdef neg_tchk
wire d_D,d_CP,d_CDN;
`endif

`ifdef functional
U_FD_P_RB_NO #1 (Q,D,CP,CDN,1'b1);
`else
reg notifier;
`ifdef neg_tchk
U_FD_P_RB_NO #0.01 (Q,d_D,d_CP,d_CDN,notifier);
`else
U_FD_P_RB_NO #0.01 (Q,D,CP,CDN,notifier);
`endif
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_cp=0.14,tsu_d_l_cp=0.17,tsu_cdn_h_cp=0.00,th_cp_d_h=0.00,
 th_cp_d_l=0.00,th_cp_cdn_l=0.29,tpw_cp_h=0.25,tpw_cp_l=0.37,tpw_cdn_l=0.20,
 cp_lh_q_lh=0,cp_lh_q_hl=0,cdn_hl_q_hl_1=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (CDN==1'b1),posedge D &&& (CDN==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (CDN==1'b1),negedge D &&& (CDN==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
 $recrem (posedge CDN,posedge CP,tsu_cdn_h_cp,th_cp_cdn_l,notifier,,,d_CDN,d_CP);
`else
 $setup (posedge D &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge CDN,posedge CP,tsu_cdn_h_cp,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),negedge D &&& (CDN==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),posedge D &&& (CDN==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP,posedge CDN,th_cp_cdn_l,notifier);
`endif
 $width (posedge CP &&& (CDN==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (CDN==1'b1),tpw_cp_l,0,notifier);
 $width (negedge CDN,tpw_cdn_l,0,notifier);
// Delays
 if (CDN==1'b1)
 (posedge CP   => (Q +: D   )) = (cp_lh_q_lh,cp_lh_q_hl);
 (negedge CDN  => (Q -: 1'b1)) = (0,cdn_hl_q_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
