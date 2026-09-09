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
// Filename     	: sdcfq1.v
// Description  	:  Buffered Muxed Scan D Flip-Flop with Clear and Q only, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//


module sdcfq1 (CPN,CDN,D,SC,SD,Q);

output  Q;
input   CPN,CDN,D,SC,SD;

`ifdef neg_tchk
wire d_CPN,d_CDN,d_D,d_SC,d_SD;
`endif

`ifdef functional
U_FD_N_RB_NO #1 (Q,mux_out,CPN,CDN,1'b1);
`else
reg notifier;
`ifdef neg_tchk
U_FD_N_RB_NO #0.01 (Q,mux_out,d_CPN,d_CDN,notifier);
`else
U_FD_N_RB_NO #0.01 (Q,mux_out,CPN,CDN,notifier);
`endif
`endif

`ifdef neg_tchk
`ifdef functional
U_MUX_2_1 (mux_out,D,SD,SC);
`else
U_MUX_2_1 (mux_out,d_D,d_SD,d_SC);
`endif
`else
U_MUX_2_1 (mux_out,D,SD,SC);
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (CDN_buf,d_CDN);
buf (SC_buf,d_SC);
`else
buf (CDN_buf,CDN);
buf (SC_buf,SC);
`endif


wire vcond1 = ((CDN_buf==1'b1) && (SC_buf==1'b1));
wire vcond2 = ((CDN_buf==1'b1) && (SC_buf==1'b0));
specify
// Parameter declarations
 specparam tsu_sd_h_cpn=0.44,tsu_sd_l_cpn=0.59,tsu_sc_h_cpn=0.48,tsu_sc_l_cpn=0.43,
 tsu_d_h_cpn=0.24,tsu_d_l_cpn=0.42,tsu_cdn_h_cpn=0.00,th_cpn_sd_h=0.00,th_cpn_sd_l=0.00,
 th_cpn_sc_h=0.00,th_cpn_sc_l=0.00,th_cpn_d_h=0.00,th_cpn_d_l=0.00,th_cpn_cdn_l=0.36,
 tpw_cpn_l=0.31,tpw_cpn_h=0.33,tpw_cdn_l=0.18,cpn_hl_q_lh_1=0,cpn_hl_q_hl_1=0,cdn_hl_q_hl_2=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge CPN &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),tsu_sd_h_cpn,th_cpn_sd_l,notifier,,,d_CPN,d_SD);
 $setuphold (negedge CPN &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),tsu_sd_l_cpn,th_cpn_sd_h,notifier,,,d_CPN,d_SD);
 $setuphold (negedge CPN &&& (CDN==1'b1),posedge SC &&& (CDN==1'b1),tsu_sc_h_cpn,th_cpn_sc_l,notifier,,,d_CPN,d_SC);
 $setuphold (negedge CPN &&& (CDN==1'b1),negedge SC &&& (CDN==1'b1),tsu_sc_l_cpn,th_cpn_sc_h,notifier,,,d_CPN,d_SC);
 $setuphold (negedge CPN &&& (vcond2==1'b1),posedge D &&& (vcond2==1'b1),tsu_d_h_cpn,th_cpn_d_l,notifier,,,d_CPN,d_D);
 $setuphold (negedge CPN &&& (vcond2==1'b1),negedge D &&& (vcond2==1'b1),tsu_d_l_cpn,th_cpn_d_h,notifier,,,d_CPN,d_D);
 $recrem (posedge CDN,negedge CPN,tsu_cdn_h_cpn,th_cpn_cdn_l,notifier,,,d_CDN,d_CPN);
`else
 $setup (posedge SD &&& (vcond1==1'b1),negedge CPN &&& (vcond1==1'b1),tsu_sd_h_cpn,notifier);
 $setup (negedge SD &&& (vcond1==1'b1),negedge CPN &&& (vcond1==1'b1),tsu_sd_l_cpn,notifier);
 $setup (posedge SC &&& (CDN==1'b1),negedge CPN &&& (CDN==1'b1),tsu_sc_h_cpn,notifier);
 $setup (negedge SC &&& (CDN==1'b1),negedge CPN &&& (CDN==1'b1),tsu_sc_l_cpn,notifier);
 $setup (posedge D &&& (vcond2==1'b1),negedge CPN &&& (vcond2==1'b1),tsu_d_h_cpn,notifier);
 $setup (negedge D &&& (vcond2==1'b1),negedge CPN &&& (vcond2==1'b1),tsu_d_l_cpn,notifier);
 $recovery (posedge CDN,negedge CPN,tsu_cdn_h_cpn,notifier);
 $hold  (negedge CPN &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),th_cpn_sd_h,notifier);
 $hold  (negedge CPN &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),th_cpn_sd_l,notifier);
 $hold  (negedge CPN &&& (CDN==1'b1),negedge SC &&& (CDN==1'b1),th_cpn_sc_h,notifier);
 $hold  (negedge CPN &&& (CDN==1'b1),posedge SC &&& (CDN==1'b1),th_cpn_sc_l,notifier);
 $hold  (negedge CPN &&& (vcond2==1'b1),negedge D &&& (vcond2==1'b1),th_cpn_d_h,notifier);
 $hold  (negedge CPN &&& (vcond2==1'b1),posedge D &&& (vcond2==1'b1),th_cpn_d_l,notifier);
 $hold  (negedge CPN,posedge CDN,th_cpn_cdn_l,notifier);
`endif
 $width (negedge CPN &&& (CDN==1'b1),tpw_cpn_l,0,notifier);
 $width (posedge CPN &&& (CDN==1'b1),tpw_cpn_h,0,notifier);
 $width (negedge CDN,tpw_cdn_l,0,notifier);
// Delays
 if (CDN==1'b1)
 (negedge CPN  => (Q +: ((SD && SC) || (D && ~SC)))) = (cpn_hl_q_lh_1,cpn_hl_q_hl_1);
 (negedge CDN  => (Q -: 1'b1)) = (0,cdn_hl_q_hl_2);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
