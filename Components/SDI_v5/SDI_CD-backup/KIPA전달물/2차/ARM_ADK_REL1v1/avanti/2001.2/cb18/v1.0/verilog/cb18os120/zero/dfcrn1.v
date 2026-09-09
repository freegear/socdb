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
// Filename     	: dfcrn1.v
// Description  	:  Buffered D Flip-Flop with Clear and QN only, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.6
//
//


module dfcrn1 (D,CP,CDN,QN);

output  QN;
input   D,CP,CDN;

`ifdef neg_tchk
wire d_D,d_CP,d_CDN;
`endif

`ifdef functional
s_dfcrn1 #1 (QN,CP,CDN,D,1'b0);
`else
reg notifier;
`ifdef neg_tchk
s_dfcrn1 #1 (QN,d_CP,d_CDN,d_D,notifier);
`else
s_dfcrn1 #1 (QN,CP,CDN,D,notifier);
`endif
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_cp=0.12,tsu_d_l_cp=0.22,tsu_cdn_h_cp=0.00,th_cp_d_h=0.00,
 th_cp_d_l=0.00,th_cp_cdn_l=0.33,tpw_cp_h=0.26,tpw_cp_l=0.43,tpw_cdn_l=0.23,
 cp_lh_qn_hl=0,cp_lh_qn_lh=0,cdn_hl_qn_lh_1=0;
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
 (posedge CP   => (QN -: D   )) = (cp_lh_qn_lh,cp_lh_qn_hl);
 (negedge CDN  => (QN +: 1'b1)) = (cdn_hl_qn_lh_1,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps


primitive s_dfcrn1(QN,CP,CDN,D,notifier);

output QN;
reg    QN;
input  CP,CDN,D,notifier;

table
// CP   CDN  D    nfr : - : QN;

   ?    0    ?    ?   : ? : 1;
   r    1    0    ?   : ? : 1;
   r    1    1    ?   : ? : 0;
   n    1    ?    ?   : ? : -;
   ?    (?1) ?    ?   : ? : -;
   ?    ?    *    ?   : ? : -;
   r    x    0    ?   : ? : 1;
   0    x    ?    ?   : 1 : 1;
   ?    ?    ?    *   : ? : x;
endtable
endprimitive

