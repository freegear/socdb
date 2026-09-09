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
// Filename     	: sdnrn2.v
// Description  	:  Buffered Muxed Scan D Flip-Flop with QN only, 2X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.6
//
//


module sdnrn2 (CP,D,SC,SD,QN);

output  QN;
input   CP,D,SC,SD;

`ifdef neg_tchk
wire d_CP,d_D,d_SC,d_SD;
`endif

`ifdef functional
s_sdnrn2 #0.01 (QN,CP,SC,D,SD,1'b0);
`else
reg notifier;
`ifdef neg_tchk
s_sdnrn2 #0.01 (QN,d_CP,d_SC,d_D,d_SD,notifier);
`else
s_sdnrn2 #0.01 (QN,CP,SC,D,SD,notifier);
`endif
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_sd_h_cp=0.45,tsu_sd_l_cp=0.57,tsu_sc_h_cp=0.47,tsu_sc_l_cp=0.45,
 tsu_d_h_cp=0.27,tsu_d_l_cp=0.38,th_cp_sd_h=0.00,th_cp_sd_l=0.00,th_cp_sc_h=0.00,
 th_cp_sc_l=0.00,th_cp_d_h=0.00,th_cp_d_l=0.00,tpw_cp_h=0.28,tpw_cp_l=0.39,
 cp_lh_qn_lh_1=0,cp_lh_qn_hl_1=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (SC==1'b1),posedge SD &&& (SC==1'b1),tsu_sd_h_cp,th_cp_sd_l,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (SC==1'b1),negedge SD &&& (SC==1'b1),tsu_sd_l_cp,th_cp_sd_h,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP,posedge SC,tsu_sc_h_cp,th_cp_sc_l,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP,negedge SC,tsu_sc_l_cp,th_cp_sc_h,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (SC==1'b0),posedge D &&& (SC==1'b0),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (SC==1'b0),negedge D &&& (SC==1'b0),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
`else
 $setup (posedge SD &&& (SC==1'b1),posedge CP &&& (SC==1'b1),tsu_sd_h_cp,notifier);
 $setup (negedge SD &&& (SC==1'b1),posedge CP &&& (SC==1'b1),tsu_sd_l_cp,notifier);
 $setup (posedge SC,posedge CP,tsu_sc_h_cp,notifier);
 $setup (negedge SC,posedge CP,tsu_sc_l_cp,notifier);
 $setup (posedge D &&& (SC==1'b0),posedge CP &&& (SC==1'b0),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (SC==1'b0),posedge CP &&& (SC==1'b0),tsu_d_l_cp,notifier);
 $hold  (posedge CP &&& (SC==1'b1),negedge SD &&& (SC==1'b1),th_cp_sd_h,notifier);
 $hold  (posedge CP &&& (SC==1'b1),posedge SD &&& (SC==1'b1),th_cp_sd_l,notifier);
 $hold  (posedge CP,negedge SC,th_cp_sc_h,notifier);
 $hold  (posedge CP,posedge SC,th_cp_sc_l,notifier);
 $hold  (posedge CP &&& (SC==1'b0),negedge D &&& (SC==1'b0),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (SC==1'b0),posedge D &&& (SC==1'b0),th_cp_d_l,notifier);
`endif
 $width (posedge CP,tpw_cp_h,0,notifier);
 $width (negedge CP,tpw_cp_l,0,notifier);
// Delays
 (posedge CP  => (QN -: ((SD && SC) || (D && ~SC)))) = (cp_lh_qn_lh_1,cp_lh_qn_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps

primitive s_sdnrn2(QN,CP,SC,D,SD,notifier);

output QN;
reg    QN;
input  CP,SC,D,SD,notifier;

table
// CP   SC   D    SD   nfr : - : QN;

   r    1    ?    0    ?   : ? : 1;
   r    1    ?    1    ?   : ? : 0;
   r    0    1    ?    ?   : ? : 0;
   r    0    0    ?    ?   : ? : 1;
   n    ?    ?    ?    ?   : ? : -;
   ?    *    ?    ?    ?   : ? : -;
   ?    ?    *    ?    ?   : ? : -;
   ?    ?    ?    *    ?   : ? : -;
   r    x    0    0    ?   : ? : 1;
   r    x    1    1    ?   : ? : 0;
   ?    ?    ?    ?    *   : ? : x;
  (?1)  0    1    ?    ?   : 0 : 0;
  (?1)  0    0    ?    ?   : 1 : 1;
  (?1)  1    ?    0    ?   : 1 : 1;
  (?1)  1    ?    1    ?   : 0 : 0;
   x    ?    ?    ?    ?   : ? : x; 

endtable
endprimitive

