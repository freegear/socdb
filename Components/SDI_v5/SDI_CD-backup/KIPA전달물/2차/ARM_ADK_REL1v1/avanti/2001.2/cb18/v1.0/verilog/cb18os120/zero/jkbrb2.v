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
// Filename     	: jkbrb2.v
// Description  	:  Buffered JKZ Flip-Flop with Clear, Preset, 1X Drive
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.8
//
//

module jkbrb2 (J,KZ,CP,Q,QN,SDN,CDN);

output  Q,QN;
input   J,KZ,CP,SDN,CDN;

`ifdef neg_tchk
wire d_J,d_KZ,d_CP,d_SDN,d_CDN;
`endif

`ifdef functional
s_jkbrb2_qn  (QN,J,not_KZ,CP,CDN,SDN,1'b0);
s_jkbrb2_q  (Q,J,not_KZ,CP,CDN,SDN,1'b0);
`else
reg notifier;
`ifdef neg_tchk
s_jkbrb2_qn #0.01 (QN,d_J,not_KZ,d_CP,d_CDN,d_SDN,notifier);
s_jkbrb2_q #0.01 (Q,d_J,not_KZ,d_CP,d_CDN,d_SDN,notifier);
`else
s_jkbrb2_qn #0.01 (QN,J,not_KZ,CP,CDN,SDN,notifier);
s_jkbrb2_q #0.01 (Q,J,not_KZ,CP,CDN,SDN,notifier);
`endif
`endif

`ifdef neg_tchk
`ifdef functional
not (not_KZ,KZ);
not (not_CP,CP);
`else
not (not_KZ,d_KZ);
not (not_CP,d_CP);
`endif
`else
not (not_KZ,KZ);
not (not_CP,CP);
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (SDN_buf,d_SDN);
buf (CDN_buf,d_CDN);
`else
buf (SDN_buf,SDN);
buf (CDN_buf,CDN);
`endif


wire vcond1 = ((SDN_buf==1'b1) && (CDN_buf==1'b1));
specify
// Parameter declarations
 specparam tsu_kz_h_cp=0.22,tsu_kz_l_cp=0.33,tsu_j_h_cp=0.29,tsu_j_l_cp=0.25,
 tsu_sdn_h_cp=0.00,tsu_cdn_h_cp=0.00,th_cp_kz_h=0.00,th_cp_kz_l=0.00,th_cp_j_h=0.00,
 th_cp_j_l=0.00,th_cp_sdn_l=0.17,th_cp_cdn_l=0.24,tpw_cp_h=0.35,tpw_cp_l=0.41,
 tpw_sdn_l=0.59,tpw_cdn_l=0.46,sdn_lh_qn_lh_1=0,cdn_lh_q_lh_1=0,sdn_hl_qn_hl_5=0,
 sdn_hl_q_lh_1=0,cdn_hl_q_hl_4=0,cp_lh_qn_lh_1=0,cp_lh_q_hl_1=0,cdn_hl_qn_lh_2=0,
 cp_lh_qn_hl_1=0,cp_lh_q_lh_1=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (vcond1==1'b1),posedge KZ &&& (vcond1==1'b1),tsu_kz_h_cp,th_cp_kz_l,notifier,,,d_CP,d_KZ);
 $setuphold (posedge CP &&& (vcond1==1'b1),negedge KZ &&& (vcond1==1'b1),tsu_kz_l_cp,th_cp_kz_h,notifier,,,d_CP,d_KZ);
 $setuphold (posedge CP &&& (vcond1==1'b1),posedge J &&& (vcond1==1'b1),tsu_j_h_cp,th_cp_j_l,notifier,,,d_CP,d_J);
 $setuphold (posedge CP &&& (vcond1==1'b1),negedge J &&& (vcond1==1'b1),tsu_j_l_cp,th_cp_j_h,notifier,,,d_CP,d_J);
 $recrem (posedge SDN &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_sdn_h_cp,th_cp_sdn_l,notifier,,,d_SDN,d_CP);
 $recrem (posedge CDN &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_cdn_h_cp,th_cp_cdn_l,notifier,,,d_CDN,d_CP);
`else
 $setup (posedge KZ &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_kz_h_cp,notifier);
 $setup (negedge KZ &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_kz_l_cp,notifier);
 $setup (posedge J &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_j_h_cp,notifier);
 $setup (negedge J &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_j_l_cp,notifier);
 $recovery (posedge SDN &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_sdn_h_cp,notifier);
 $recovery (posedge CDN &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_cdn_h_cp,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge KZ &&& (vcond1==1'b1),th_cp_kz_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge KZ &&& (vcond1==1'b1),th_cp_kz_l,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge J &&& (vcond1==1'b1),th_cp_j_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge J &&& (vcond1==1'b1),th_cp_j_l,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),posedge SDN &&& (CDN==1'b1),th_cp_sdn_l,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),posedge CDN &&& (SDN==1'b1),th_cp_cdn_l,notifier);
`endif
 $width (posedge CP &&& (vcond1==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (vcond1==1'b1),tpw_cp_l,0,notifier);
 $width (negedge SDN &&& (CDN==1'b1),tpw_sdn_l,0,notifier);
 $width (negedge CDN &&& (SDN==1'b1),tpw_cdn_l,0,notifier);
// Delays
 (        SDN +=> QN) = (sdn_lh_qn_lh_1,sdn_hl_qn_hl_5);
 (        CDN +=> Q ) = (cdn_lh_q_lh_1,cdn_hl_q_hl_4);
 if ((SDN==1'b1) && (CDN==1'b1))
 (posedge CP   => (QN -: ((J && ~Q) || (KZ && Q)))) = (cp_lh_qn_lh_1,cp_lh_qn_hl_1);
 if ((SDN==1'b1) && (CDN==1'b1))
 (posedge CP   => (Q  +: ((J && ~Q) || (KZ && Q)))) = (cp_lh_q_lh_1,cp_lh_q_hl_1);
 (negedge SDN  => (Q  +: 1'b1)) = (sdn_hl_q_lh_1,0);
 (negedge CDN  => (QN +: 1'b1)) = (cdn_hl_qn_lh_2,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults


primitive s_jkbrb2_qn(QN, J, K, CP, RB, SB, NOTIFIER_REG);
    output QN;
    reg    QN;  
    input  J,K,CP,RB,SB,NOTIFIER_REG;
    
    table
      // J   K   CP   RB   SB : NOTIFIER_REG : Qtn : Qtn+1
         0   0   r    1    1      ?          :  ?  :   - ;    // Output retains the 
         0   1   r    1    1      ?          :  ?  :   1 ;    // Clocked J and K.
         0   1   r    ?    1      ?          :  ?  :   1 ;    // pessimism
         ?   0   b    1    ?      ?          :  0  :   0 ;
         1   0   r    1    1      ?          :  ?  :   0 ;    
         1   0   r    1    ?      ?          :  ?  :   0 ;    // pessimism
         1   1   r    1    1      ?          :  1  :   0 ;    // Clocked toggle.
         1   1   r    1    1      ?          :  0  :   1 ;
         ?   1   r    ?    1      ?          :  0  :   1 ;     //pessimism
         1   ?   r    1    ?      ?          :  1  :   0 ;
         0   0  (x1)  1    1      ?          :  ?  :   - ;   //possible clocked JK
         0   1  (x1)  1    1      ?          :  1  :   1 ;   
         1   0  (x1)  1    1      ?          :  0  :   0 ;
         *   ?   b    1    1      ?          :  ?  :   - ;    // Insensitive to 
         ?   *   b    1    1      ?          :  ?  :   - ;    
         ?   ?   ?    1    0      ?          :  ?  :  0  ;    // Set.
         ?   ?   ?    0    1      ?          :  ?  :  1  ;    // clear 
         ?   ?   ?    0    0      ?          :  ?  :  0  ;    // clear override. 
         ?   ? (x0)   1    1      ?          :   ? :  -  ;    //ignore falling clock.
         ?   0   r    1    1      ?          :   0  :   0 ;   
         0   ?   r    1    1      ?          :   1  :   1 ; 
         ?   0  (x1)  1    1      ?          :   0  :   0 ; 
         0   ?  (x1)  1    1      ?          :   1  :   1 ; 
         ?   ?   b  (?1)   1      ?          :   ?  :  -  ;  
         ?   ?   b   1   (?1)     ?          :   ?  :  -  ; 
	 ?   ?   ?    ?    0      ?          :  ?   :  0  ;
	 0   ?   1    ?    1      ?          :  1   :  1  ;
	 0   ?   0    ?    1      ?          :  1   :  1  ;
	 ?   ?   0    ?    1      ?          :  1   :  1  ;
	 ?   ?   0    1    ?      ?          :  0   :  0  ;
	 ?   ?   x    1    1      ?          :  ?   :  x  ;
         ?   ?   ?   ?     ?      *          :   ?  :  x  ;
    endtable
endprimitive

primitive s_jkbrb2_q(Q, J, K, CP, RB, SB, NOTIFIER_REG); 
    output Q;
    reg    Q;  
    input  J,K, CP,RB,SB,NOTIFIER_REG;

    table
      // J   K   CP   RB   SB       NOTIFIER_REG  : Qt  : Qt+1
         0   0   r    1    1           ?          :  ?  :   - ;    
         0   1   r    1    1           ?          :  ?  :   0 ;   
         0   1   r    ?    1           ?          :  ?  :   0 ;  
         ?   0   b    1    ?           ?          :  1  :   1 ;
         1   0   r    1    1           ?          :  ?  :   1 ;    
         1   0   r    1    ?           ?          :  ?  :   1 ;    // pessimism
         1   1   r    1    1           ?          :  0  :   1 ;    // Clocked toggle.
         1   1   r    1    1           ?          :  1  :   0 ;
         ?   1   r    ?    1           ?          :  1  :   0 ;    //pessimism
         1   ?   r    1    ?           ?          :  0  :   1 ;
         0   0  (x1)  1    1           ?          :  ?  :   - ;
         0   1  (x1)  1    1           ?          :  0  :   0 ;
         1   0  (x1)  1    1           ?          :  1  :   1 ;
         *   ?   b    1    1           ?          :  ?  :   - ;    // Insensitive to 
         ?   *   b    1    1           ?          :  ?  :   - ;    
         ?   ?   ?    1    0           ?          :  ?  :   1 ;    // Set.
         ?   ?   ?    0    ?           ?          :  ?  :   0 ;    // clear override.
         ?   0   r    1    1           ?          :  1  :   1 ;  
         0   ?   r    1    1           ?          :  0  :   0 ;
         ?   0  (x1)  1    1           ?          :  1  :   1 ;
         0   ?  (x1)  1    1           ?          :  0  :   0 ;
         ?   ?   b  (?1)   1           ?          :  ?  :   - ;  
         ?   ?   b   1   (?1)          ?          :  ?  :   - ;  
         ?   ?   ?   ?     ?           *          :  ?  :   x ;
	 0   ?   0   ?     1           ?          :  0  :   0 ;
	 0   ?   1   ?     1           ?          :  0  :   0 ;
         ?   ?   0   ?     1           ?          :  0  :   0 ; 
         ?   ?   0   1     ?           ?          :  1  :   1 ;
	 ?   ?   x    1    1      ?          :  ?   :  x  ;
    endtable
endprimitive

