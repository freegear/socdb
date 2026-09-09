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
// Filename     	: sdcrn2.v
// Description  	:  Buffered Muxed Scan D Flip-Flop with Clear and QN only, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.10
//
//


module sdcrn2 (CP,CDN,D,SC,SD,QN);

output  QN;
input   CP,CDN,D,SC,SD;

`ifdef neg_tchk
wire d_CP,d_CDN,d_D,d_SC,d_SD;
`endif

`ifdef functional
s_sdcrn #1 (QN,CP,SC,CDN,SD,D,1'b0);
`else
reg notifier;
`ifdef neg_tchk
s_sdcrn #1 (QN,d_CP,d_SC,d_CDN,d_SD,d_D,notifier);
`else
s_sdcrn #0.01 (QN,CP,SC,CDN,SD,D,notifier);
`endif
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
 specparam tsu_sd_h_cp=0.49,tsu_sd_l_cp=0.59,tsu_sc_h_cp=0.50,tsu_sc_l_cp=0.48,
 tsu_d_h_cp=0.30,tsu_d_l_cp=0.42,tsu_cdn_h_cp=0.00,th_cp_sd_h=0.00,th_cp_sd_l=0.00,
 th_cp_sc_h=0.00,th_cp_sc_l=0.00,th_cp_d_h=0.00,th_cp_d_l=0.00,th_cp_cdn_l=0.28,
 tpw_cp_h=0.30,tpw_cp_l=0.43,tpw_cdn_l=0.33,cp_lh_qn_hl_1=0,cp_lh_qn_lh_1=0,cdn_hl_qn_lh_3=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),tsu_sd_h_cp,th_cp_sd_l,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),tsu_sd_l_cp,th_cp_sd_h,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (CDN==1'b1),posedge SC &&& (CDN==1'b1),tsu_sc_h_cp,th_cp_sc_l,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (CDN==1'b1),negedge SC &&& (CDN==1'b1),tsu_sc_l_cp,th_cp_sc_h,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (vcond2==1'b1),posedge D &&& (vcond2==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (vcond2==1'b1),negedge D &&& (vcond2==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
 $recrem (posedge CDN,posedge CP,tsu_cdn_h_cp,th_cp_cdn_l,notifier,,,d_CDN,d_CP);
`else
 $setup (posedge SD &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_sd_h_cp,notifier);
 $setup (negedge SD &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_sd_l_cp,notifier);
 $setup (posedge SC &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_sc_h_cp,notifier);
 $setup (negedge SC &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_sc_l_cp,notifier);
 $setup (posedge D &&& (vcond2==1'b1),posedge CP &&& (vcond2==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (vcond2==1'b1),posedge CP &&& (vcond2==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge CDN,posedge CP,tsu_cdn_h_cp,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),th_cp_sd_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),th_cp_sd_l,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),negedge SC &&& (CDN==1'b1),th_cp_sc_h,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),posedge SC &&& (CDN==1'b1),th_cp_sc_l,notifier);
 $hold  (posedge CP &&& (vcond2==1'b1),negedge D &&& (vcond2==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (vcond2==1'b1),posedge D &&& (vcond2==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP,posedge CDN,th_cp_cdn_l,notifier);
`endif
 $width (posedge CP &&& (CDN==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (CDN==1'b1),tpw_cp_l,0,notifier);
 $width (negedge CDN,tpw_cdn_l,0,notifier);
// Delays
 if (CDN==1'b1)
 (posedge CP   => (QN -: ((SD && SC) || (D && ~SC)))) = (cp_lh_qn_lh_1,cp_lh_qn_hl_1);
 (negedge CDN  => (QN +: 1'b1)) = (cdn_hl_qn_lh_3,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps
