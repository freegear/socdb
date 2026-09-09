//----------------------------------------------------------------------------
// TSMC PLL for clock generator
//----------------------------------------------------------------------------
// Copyright (c) 2002 Taiwan Semiconductor Manufacturing Ltd.
// All Rights Reserved.
//----------------------------------------------------------------------------
// Author   : Bohr Shan Chiou (bschiou@tsmc.com)
// Date	    : 3/21/2002
// Version  : 1.0
// TEL      : 5673335
//--------------------------------------------------------------
// Timing Parameters :
//
//  (1) Bypass mode
//  
//  (2) Normal mode
//
//  (3) Power  Down mode
//                      
//  .In this model , we do not model SPE between FOUT and FIN
//  .Tready: delay time will be 500000ns+ 1 input cycle time.
//  .Tready: user can modify Tready value into a small value so that it can reduce simulation time.
//  .For by_pass mode, the delay between FIN and FOUT is just a simulation result.
//  .Rduty: duty cycle ratio (range from 0.1 to 0.9)
//----------------------------------------------------------------------
// Timing Constraints:
//
//  .Fmax_fref: max frequency constraint for FREF
//  .Fmin_fref: min frequency constraint for FREF
//  .Fmin_fvco/Fmax_fvco: min/max frequency constraint for FVCO
//----------------------------------------------------------------------
//**************************************************************/
`timescale 1ns/1ps
`celldefine 
module  PG13A1G3 (FOUT,AHVDD,AHVSS,AHVDDG,AHVSSG,DVDD,DVSS,BP,
		 F0,F1,F2,F3,F4,F5,FIN,OD,OEB,PD,R0,R1,R2,R3);

  parameter Tready=500000;     // delay time from the frequency re-lock to locked(ns)
  parameter Rduty=0.5;         // duty cycle ratio (range from 0.1 to 0.9)
  parameter Fmin_fref=10.0;    // min frequency constraint for FREF (MHz)
  parameter Fmax_fref=50.0;    // max frequency constraint for FREF (MHz) 
  parameter Fmax_fvco=1000.0;  // max frequency constraint for VCO  (MHz)
  parameter Fmin_fvco=500.0;   // min frequency constraint for VCO  (MHz)

  input  FIN,OEB,BP,PD,OD,F0,F1,F2,F3,F4,F5,R0,R1,R2,R3;
  output FOUT;
  inout  DVDD,DVSS,AHVDD,AHVSS,AHVDDG,AHVSSG; 

  supply0 DVSS,AHVSS,AHVSSG; 
  supply1 DVDD,AHVDD,AHVDDG; 

  wire [3:0] r;
  wire [5:0] f;
  integer total;
  reg  fout;

  buf (fin,FIN);
  buf (oeb,OEB);
  buf (pd,PD);
  buf (bp,BP);
  buf (od,OD);
  buf (r[3],R3);
  buf (r[2],R2);
  buf (r[1],R1);
  buf (r[0],R0);
  buf (f[5],F5);
  buf (f[4],F4);
  buf (f[3],F3);
  buf (f[2],F2);
  buf (f[1],F1);
  buf (f[0],F0);
  buf (FOUT,fout);

  
  reg 		fclk;
  reg           err_freq;
  reg 		locked;
  real 		t_fin_pos,per_fin;
  real 		t_fclk_high,t_fclk_low;
  real 		jitter;
  real 	        pper_fin;	
  integer       nfm,nrm,no_cbs,no;
  integer       Ipper_fin,Iper_fin; 
  real          per_fref, per_fvco, per_fout, per_fout1;
  reg 		pos_jitter;
  wire 		err_set= (fin===1'bx   || pd===1'bx || oeb===1'bx || bp===1'bx || od===1'bx 
		          || ^r===1'bx || ^f===1'bx) ;
  wire          normal= !pd && !bp && !oeb;

initial begin
    err_freq    =0; 
    no_cbs      =0;
    nrm         =1;
    nfm         =1;
    fclk        =1'b0;
    locked	=1'b0;
    t_fin_pos	=0.0;
    pos_jitter	=1'b0;
    jitter	=0.0;
    total       =0.0;
end

/* assign fout */
always @(pd or bp or oeb or err_set or per_fref or per_fvco or fin or fclk or total or nfm or od) begin

    if(err_set) begin
		fout =1'bx;
                err_freq = 0;
		locked=0;
                $display ($realtime," Control signal Unknown! ");
    end
	
    else if (pd) begin
		fout=1'bx;
	        locked=0;	              
		err_freq = 0;
    end

    else if(oeb) begin
		fout=1'b0;
		locked=0;
		err_freq=0;
    end

    else if (!pd && bp && !oeb) begin 
		fout<=#(0.4) fin;     // bypass mode
		err_freq = 0 ;
		locked=0;
    end

    else if (!pd && !bp && !oeb) begin

    		if(  (( per_fref < (1000.0/Fmax_fref))
       		  ||  ( per_fref > (1000.0/Fmin_fref))
       		  ||  ( per_fvco < (1000.0/Fmax_fvco))
       		  ||  ( per_fvco > (1000.0/Fmin_fvco))) && total>1) begin

			fout  = 1'bx;
			err_freq = 1;
			locked=0;
			$display ("Error input Freq range!");
               	end

		else if( nfm < 6.00*(2.00-od) ) begin
			
			fout  = 1'bx;
			err_freq = 1;
			locked=0;
			$display ("Sorry You can not set NF<6.00*(2.00-od) ");
		end 

	        else	begin
			fout<=fclk;
			err_freq = 0;
		end
    end

    else begin
		fout     = 1'bx;
                err_freq = 0;
	        locked=0;	
        	$display($realtime , " Error Function Mode ");
    end
end 

always begin
	wait(locked===1'b1 &&  no_cbs>=1) begin

	if(pos_jitter)    jitter =  0.05;
	if(!pos_jitter)   jitter = -0.05; 
        if(no_cbs==1)     fclk = 1'b1;

        per_fout      = per_fout1 + jitter;
    	t_fclk_low    = per_fout    * (1-Rduty);
    	t_fclk_high   = per_fout    * Rduty;
		
    	#(t_fclk_high)    fclk =1'b0;
    	#(t_fclk_low)     fclk =1'b1;
        pos_jitter = ~pos_jitter;

	end

	if(!locked) fclk=1'b0;
end 

always @(normal or Ipper_fin or Iper_fin or err_set or err_freq) begin

	if(!err_set && normal && !err_freq) begin
		if(   (Ipper_fin - Iper_fin) > 10.0 
		  ||  (Ipper_fin - Iper_fin) <-10.0 ) begin
			
                           locked=1'b0;
		     #(Tready) locked=1'b1;
		end
	end
	
	else locked=1'b0;

end 
  
always @(r[3] or r[2] or r[1] or r[0] or f[3] or f[2] or f[1] or f[0] or
	 f[4] or f[5] or normal or od or pd or oeb or bp
         or err_set or err_freq) begin

	locked=1'b0;

	if(normal && !err_set && !err_freq) begin
    	        #Tready locked =1'b1;
	end

	else 	locked =1'b0;
end
 
always @(posedge fin) begin

	per_fin    = $realtime - t_fin_pos;
        Iper_fin   = per_fin *1000;
	total = total + 1;
	nrm = r+1;
	no= 1+od;
	nfm = (3-no)*(f+2);


	per_fref  = per_fin * nrm ; 
	per_fvco  = per_fref/ (nfm * no) ;
    	per_fout1 = per_fref/nfm;


	if(locked===1'b1) no_cbs=no_cbs+1;
        else no_cbs=0;
        
	t_fin_pos  = $realtime;
end

always @(negedge  fin) begin
       pper_fin   = per_fin;
       Ipper_fin  = pper_fin  *1000;
end

endmodule
`endcelldefine
