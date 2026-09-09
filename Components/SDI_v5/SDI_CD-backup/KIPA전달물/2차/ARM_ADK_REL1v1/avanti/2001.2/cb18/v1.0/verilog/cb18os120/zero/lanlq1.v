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
// Filename     	: lanlq1.v
// Description  	:  Buffered Latch with Low Enable and Q only, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module lanlq1 (EN,D,Q);

output  Q;
input   EN,D;

`ifdef neg_tchk
wire d_EN,d_D;
`endif

`ifdef functional
U_LD_N #1 (Q,D,EN);
`else
reg notifier;
`ifdef neg_tchk
U_LD_N_NO #1 (Q,d_D,d_EN,notifier);
`else
U_LD_N_NO #1 (Q,D,EN,notifier);
`endif
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_en=0.11,tsu_d_l_en=0.13,th_en_d_h=0.00,th_en_d_l=0.00,
 tpw_en_l=0.29,d_lh_q_lh=0,d_hl_q_hl=0,en_hl_q_hl=0,en_hl_q_lh=0;
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
 (        D  +=> Q) = (d_lh_q_lh,d_hl_q_hl);
 (negedge EN  => (Q +: D  )) = (en_hl_q_lh,en_hl_q_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
