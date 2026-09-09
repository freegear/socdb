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
// Filename     	: lanln1.v
// Description  	:  Buffered Latch with Low Enable and QN only, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.7
//
//


module lanln1 (EN,D,QN);

output  QN;
input   EN,D;

`ifdef neg_tchk
wire d_EN,d_D;
`endif

`ifdef functional
buf b_EN (EN_buf,EN);
buf b_D (D_buf,D);
s_lanln #0.01 (QN,EN_buf,D_buf,1'b0);
`else
reg notifier;
`ifdef neg_tchk
buf b_EN (EN_buf,d_EN);
buf b_D (D_buf,d_D);
s_lanln #0.01 (QN,EN_buf,D_buf,notifier);
`else
buf b_EN (EN_buf,EN);
buf b_D (D_buf,D);
s_lanln #0.01 (QN,EN_buf,D_buf,notifier);
`endif
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_en=0.21,tsu_d_l_en=0.27,th_en_d_h=0.00,th_en_d_l=0.00,
 tpw_en_l=0.26,d_lh_qn_hl=0,d_hl_qn_lh=0,en_hl_qn_lh=0,en_hl_qn_hl=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge EN,posedge D,tsu_d_h_en,th_en_d_l,notifier,,,d_EN,d_D);
 $setuphold (posedge EN,negedge D,tsu_d_l_en,th_en_d_h,notifier,,,d_EN,d_D);
`else
 $setup (posedge D,posedge EN,tsu_d_h_en,notifier);
 $setup (negedge D,posedge EN,tsu_d_l_en,notifier);
 $hold  (posedge EN,negedge D,th_en_d_h,notifier);
 $hold  (posedge EN,posedge D,th_en_d_l,notifier);
`endif
 $width (negedge EN,tpw_en_l,0,notifier);
// Delays
 if (EN==1'b0)
 (        D  -=> QN) = (d_hl_qn_lh,d_lh_qn_hl);
 (negedge EN  => (QN -: D  )) = (en_hl_qn_lh,en_hl_qn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps


