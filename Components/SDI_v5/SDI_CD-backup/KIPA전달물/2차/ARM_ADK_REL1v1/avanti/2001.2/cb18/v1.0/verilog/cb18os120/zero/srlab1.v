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
// Filename     	: srlab1.v
// Description  	:  SetN ResetN Latch, (NAND Inputs)
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//


module srlab1 (RN,SN,Q,QN);

output  Q,QN;
input   RN,SN;

`ifdef functional
buf b_RN (RN_buf,RN);
buf b_SN (SN_buf,SN);
s_srlab1 g1_s_srlab1_1(RN_buf,SN_buf,Q,QN,1'bx);
`else
reg notifier;
buf b_RN (RN_buf,RN);
buf b_SN (SN_buf,SN);
s_srlab1 g1_s_srlab1_1(RN_buf,SN_buf,Q,QN,notifier);
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tpw_sn_l=0.21,tpw_rn_l=0.22,rn_hl_qn_lh=0,rn_lh_q_lh=0,
 rn_hl_q_hl_1=0,sn_lh_qn_lh=0,sn_hl_qn_hl_2=0,sn_hl_q_lh=0;
// Violation constraints
 $width (negedge SN,tpw_sn_l,0,notifier);
 $width (negedge RN,tpw_rn_l,0,notifier);
// Delays
 (        RN +=> Q ) = (rn_lh_q_lh,rn_hl_q_hl_1);
 (        SN +=> QN) = (sn_lh_qn_lh,sn_hl_qn_hl_2);
 (negedge RN  => (QN +: 1'b1)) = (rn_hl_qn_lh,0);
 (negedge SN  => (Q  +: 1'b1)) = (sn_hl_q_lh,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps




module s_srlab1 (RN,SN,Q,QN,notifier);

output    Q,QN;
input     RN,SN,notifier;
reg       reg_Q,xreg_Q,reg_QN,xreg_QN;
reg mem_notifier;
buf  #1 (Q,reg_Q);
buf  #1 (QN,reg_QN);

always @(SN or RN or notifier) begin
 if (notifier !== 1'bx && mem_notifier !== notifier) begin
 	reg_QN=1'bx;
	reg_Q=1'bx;
	mem_notifier = notifier;
 end 
  	
         
 else if ((SN===0) || (RN===0)) begin
  		if ((SN===0))  
    		reg_QN=0;
     		reg_Q=RN;

    
	 	if ((RN===0)) 
	 	reg_Q=0;
		reg_QN=SN;
            
 end
 
  
 
 else if ((SN===1) && (RN===0)) begin
  reg_QN=1;
  reg_Q=0;
 end
 
 
 else if ((SN===1'bx) || (RN===1'bx)) begin
  xreg_QN=reg_QN;
  xreg_Q=reg_Q;
  if ((SN===1'bx)) begin
     if (xreg_QN!==0) 
     xreg_QN=1'bx;
        if (xreg_Q!==RN) 
	xreg_Q=1'bx;
        end
       if (((SN===1) || (SN===1'bx)) && ((RN===0) || (RN===1'bx))) begin
     	 if (xreg_QN!==1) 
      	 xreg_QN=1'bx;
      		if (xreg_Q!==0) 
		xreg_Q=1'bx;
       end
   reg_QN=xreg_QN;
   reg_Q=xreg_Q;
   end
end


endmodule
