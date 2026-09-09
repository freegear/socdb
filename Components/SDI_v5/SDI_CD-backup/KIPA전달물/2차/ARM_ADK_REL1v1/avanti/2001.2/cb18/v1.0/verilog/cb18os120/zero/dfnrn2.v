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
// Filename     	: dfnrn2.v
// Description  	:  Buffered D Flip-Flop with QN only, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module dfnrn2 (CP,D,QN);

output  QN;
input   CP,D;

`ifdef neg_tchk
wire d_CP,d_D;
`endif

`ifdef functional
s_dfnrn2 #0.01 (QN,CP,D,1'b0);
`else
reg notifier;
`ifdef neg_tchk
s_dfnrn2 #0.01 (QN,d_CP,d_D,notifier);
`else
s_dfnrn2 #0.01 (QN,CP,D,notifier);
`endif
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_cp=0.14,tsu_d_l_cp=0.18,th_cp_d_h=0.00,th_cp_d_l=0.00,
 tpw_cp_h=0.24,tpw_cp_l=0.41,cp_lh_qn_hl=0,cp_lh_qn_lh=0;
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
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps


primitive s_dfnrn2(QN,CP,D,notifier);

output QN;
reg    QN;
input  CP,D,notifier;

table
// CP   D    nfr : - : QN;

   r    0    ?   : ? : 1;
   r    1    ?   : ? : 0;
   n    ?    ?   : ? : -;
   ?    *    ?   : ? : -;
   ?    ?    *   : ? : x;
endtable
endprimitive

