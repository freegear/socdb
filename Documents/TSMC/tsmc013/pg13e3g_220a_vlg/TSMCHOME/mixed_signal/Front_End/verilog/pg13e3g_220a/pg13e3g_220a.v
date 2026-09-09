// 
// Verilog Model for TSMC 400MHz PLL PG13E3G 
// 
// Version 220a
// Author : James Chou 
// Date   : 2006.3.22
// E-mail : jychouc@tsmc.com
//
//
// Copyright (c) 2006 Taiwan Semiconductor Manufacturing Ltd.
// All Rights Reserved.


`timescale 1ns/100fs
`celldefine 
module PG13E3G (FOUT,
                AVDD,AVSS,DVDD,DVSS,
		BP,OEB,PD,
		F0,F1,F2,F3,F4,F5,F6,F7,
		FIN,
		OD0,OD1,
		R0,R1,R2,R3,R4);

  
  //User can modify the following paramter(s) 
  parameter SkewLimit = 0.050; //50ps		     
  
  
  //Please keep the following parameters intact! 
  
  parameter Fmin_fref=1.99e6;      // min frequency constraint for FREF (MHz)
  parameter Fmax_fref=8.01e6;      // max frequency constraint for FREF (MHz) 
  parameter Fmin_fin=4.99e6;       // min frequency constraint for FIN  (MHz)
  parameter Fmax_fin=250.01e6;     // max frequency constraint for FIN  (MHz)
  parameter Fmin_fvco=199.0e6;     // min frequency constraint for VCO  (MHz)
  parameter Fmax_fvco=401.0e6;     // max frequency constraint for VCO  (MHz)

  parameter C1 =0.000125;
  parameter C2 =0.0025;
  parameter Kvco=-500e6;
  parameter Rduty=0.5;
  
    
  input  FIN,BP,PD,OEB,OD0,OD1,F0,F1,F2,F3,F4,F5,F6,F7,R0,R1,R2,R3,R4;
  output FOUT;
  inout  AVDD,AVSS,DVDD,DVSS;

  supply0 AVSS,DVSS; 
  supply1 AVDD,DVDD;

  wire [1:0] od;
  wire [4:0] r;
  wire [7:0] f;
   
  reg  fout, fref, fbck, ld;

  buf (fin,FIN);
  buf (pd,PD);
  buf (bp,BP);
  buf (oeb,OEB); 
  buf (od[1], OD1);
  buf (od[0], OD0);
  buf (r[4],R4);
  buf (r[3],R3);
  buf (r[2],R2);
  buf (r[1],R1);
  buf (r[0],R0);
  buf (f[7],F7);
  buf (f[6],F6);
  buf (f[5],F5);
  buf (f[4],F4);
  buf (f[3],F3);
  buf (f[2],F2);
  buf (f[1],F1);
  buf (f[0],F0);
  buf (FOUT,fout);
   
  
  real skew;
  real skew_Weighted;
  integer locked;
  integer inputDivider, outputDivider, feedbackDivider;
  reg  fin_div, fvco;
  real per_fref,prev_fref_rise, prev_fbck_rise; 
  real per_fvco;
  real t_fvco_low, t_fvco_high;
  reg fbk_div;
  reg fbk;
  integer finCount;
  integer UP, DN;
  real UP_time, DN_time;
  real Vctrl;
  real freq_vco;
  integer LockCount;
  real prev_fout_rise;
  real per_fout, freq_fout;
  real freq_fref;
  real per_fbck, freq_fbck;
  real foutCount, frefCount;
  reg  pd1D;
  reg  InputError;
  reg  pfout, fout0;
  real VC, VC1D;
  real Skew_Factor;
  
  reg [4:0] NR;
  reg [7:0] NF;
  
  reg  fvco_div2;
  reg  fvco_div4;
   
   
////////////////////
// Initialization
////////////////////
initial 
begin
  skew = 0;
  skew_Weighted = 0;
  locked = 0;
  inputDivider = 0; 
  outputDivider = 0; 
  feedbackDivider = 0;
  finCount = 0;
  prev_fref_rise = 0;
  prev_fbck_rise = 0;
  per_fvco       = 2; 
  UP = 0;
  DN = 0;
  fout = 0;
  fref = 0;
  fin_div = 0;
  fbck = 0;
  fbk_div = 0;
  ld = 0;
  LockCount = 0;
  per_fref  = 500;
  per_fvco  = 2.5;
  prev_fout_rise = 0;
  foutCount = 0;
  frefCount = 0;
  pd1D      = 0;
  pfout     = 0;
  fout0     = 0;
  
  VC   = 0;
  VC1D = 0;
  Skew_Factor = 1;
  
  fvco_div2 = 0;
  fvco_div4 = 0;
   
  UP_time   = 0;
  DN_time   = 0;
  
  NR = r;
  NF = f;
  
  Vctrl = 0.5;
  
end

 
////////////////////
//Input Divider
////////////////////
always @(r)
  inputDivider = 0;
  
always @(r) begin
  NR = r - 1;
  if ( r == 0)
       $display ("R[4:0] cannot be all 0's!");
  
end   

always @(posedge fin) begin
  
  if (inputDivider == NR)
      begin  
        inputDivider = 0; 
        fin_div = 1;      
      end
  else
      begin
        inputDivider = inputDivider+1;
	fin_div = 0;
      end
      
  finCount = finCount + 1;    
end

always @(r or fin or fin_div) begin
   if (NR == 0)
     fref = fin; 
   else
     fref = fin_div;
end


////////////////////
//FeedBack Divider
////////////////////
always @(f)
  feedbackDivider = 0;
  
always @(f) begin
  NF = 2*f - 1;
  if ( f == 0)
       $display ("F[7:0] cannot be all 0's!");
end       


always @(posedge fvco) begin
  
  if (feedbackDivider == NF)
      begin  
        feedbackDivider = 0; 
        fbk_div = 1;      
      end
  else
      begin
        feedbackDivider = feedbackDivider+1;
	fbk_div = 0;
      end
end

always @(f or fbk or fbk_div) begin
   //if (NF == 0)
     //fbck = fvco; 
   //else
     fbck = fbk_div;
end


////////////////////
// PFD + VCO
////////////////////

always @(posedge fref)
  begin
      if (NF < 8)
          Skew_Factor = 0.125;
      else if (NF < 16)
          Skew_Factor = 0.25;
      else if (NF < 32) 
          Skew_Factor = 0.5;
      else if (NF < 64)	
          Skew_Factor = 1;
      else  
          Skew_Factor = 2;
       
  end


always @(posedge fref) begin
  wait(finCount >  1) begin 
    per_fref        = $realtime - prev_fref_rise;//the period of FREF
    prev_fref_rise  = $realtime;
    freq_fref = (1/per_fref)*1e9;
    
    if (DN == 0 && UP == 0)
      begin
        UP = 1;
        UP_time = $realtime;
      end  
      
    if (DN == 1)
      begin
        DN = 0;
         
        skew   = ($realtime - DN_time);
	skew_Weighted = skew*Skew_Factor;	  
	if ( pd == 1'b0 && bp == 1'b0) 
          begin
       
            VC    = VC1D + skew_Weighted*C1;
            Vctrl = skew_Weighted*C2 + VC1D;
	    VC1D  = VC;
          end
        else
          begin
            VC    = 0;
	    VC1D  = 0;
            Vctrl = 0;
          end
      
        freq_vco = 1200e6 + Vctrl*Kvco;
        if (freq_vco < 10e6)
            freq_vco = 10e6; 
       	  
        per_fvco = (1/freq_vco)*1e9;	
             	 
      end 
  end   
end  
  
always @(posedge fref) begin
  frefCount = frefCount+1;
  if ((freq_fref >  Fmax_fref || freq_fref <  Fmin_fref) && frefCount> 100 )
      $display ("FIN freq out of range, at time %0d ns", $time);
        
end	  	 
 

always @(posedge fref) begin
  if ((freq_vco >  Fmax_fvco || freq_vco<  Fmin_fvco) && frefCount> 100 &&ld==1)
      $display ("FVCO freq out of range, at time %0d ns", $time);      
end	


 
always @(posedge fbck) begin
  wait(finCount >  1) begin 
    per_fbck = $realtime - prev_fbck_rise;
    prev_fbck_rise  = $realtime;
         
    if (UP == 0 && DN == 0)
      begin
        DN = 1;
        DN_time = $realtime;
      end  
    if (UP == 1)
      begin
        UP = 0;
         
        skew   = ($realtime - UP_time);
	skew_Weighted = -skew*Skew_Factor;
	
	if ( pd == 1'b0 && bp == 1'b0) 
          begin
       
            VC    = VC1D + skew_Weighted*C1;
            Vctrl = skew_Weighted*C2 + VC1D;
	    VC1D  = VC;
          end
        else
          begin
            VC    = 0;
	    VC1D  = 0;
            Vctrl = 0;
          end 
       
      
        freq_vco = 1200e6 + Vctrl*Kvco;
        if (freq_vco < 10e6)
            freq_vco = 10e6; 
       	  
        per_fvco = (1/freq_vco)*1e9;	
         
       
      end   
  end 
       
end 


////////////////////
//Pseudo LPF + VCO
////////////////////
 


 
always begin
  t_fvco_low    = per_fvco*(1-Rduty);
  t_fvco_high   = per_fvco*Rduty;
		
  #(t_fvco_high) fvco =1'b0;
  #(t_fvco_low)  fvco =1'b1;    	 
end  
 
 
////////////////////
//Output Divider
////////////////////
always @(posedge fvco)     
  fvco_div2 = !fvco_div2;  
  
always @(posedge fvco_div2)     
  fvco_div4 = !fvco_div4;
  

always @(fin or fvco or fvco_div2 or fvco_div4 or pd or bp or InputError) 
begin 
  if (InputError == 1)
      fout = 1'bx;
  else    
     if (pd == 1)//Power down 
         fout = 1;  
     else if (oeb == 1)//Output disabled 
         fout = 1; 	 
     else if (bp == 1)//Bypass mode 
     	 fout = fin;  
     else   
        case (od)
	  2'b00: fout = 1'b0;
	  2'b01: fout = fvco; 
	  2'b10: fout = fvco_div2;
	  default: fout = fvco_div4;  
        endcase  	
end


always @(fvco or fvco_div2 or fvco_div4 or pd or fin) 
begin 
   
     if (pd == 1 || bp == 1)//Power down or Bypass 
         fbk = 1; 
     else    
        case (od)
	  2'b00: fbk = fin;
	  2'b01: fbk = fvco_div2; 
	  2'b10: fbk = fvco_div4;
	  default: fbk = fvco_div4;  
        endcase  	
end



always  @(posedge fout)begin
  foutCount = foutCount+1;
  per_fout = $realtime - prev_fout_rise;
  prev_fout_rise  = $realtime;
  freq_fout = (1/per_fout)*1e9;
  //if(foutCount >  100 && pd == 0)    
    //if (freq_fout >= freq_fout_max || freq_fout <= freq_fout_min)
        //$display ("FOUT freq out of range, at time %0d ns", $time);    	  
end  

////////////////////
//Lock Detector
////////////////////
always  @(posedge fbck or skew or pd or bp )begin
  if (skew >= SkewLimit || pd==1 || bp==1)
     begin
       LockCount = 0;
       if (ld == 1)
         $display("PLL loses lock!, at time = %0d ns", $time);
       ld = 0;
     end
  else 
    if (LockCount > 256)
      begin
        if (ld == 0)
	  $display("PLL acquires lock!, FOUT = %fMHz, at time = %0d ns", freq_fout/1e6, $time);
	ld = 1;
      end
    else
        LockCount = LockCount + 1;
end


////////////////////
//Power down
////////////////////
always  @(pd) begin
  if (pd == 1)
    begin
      LockCount = 0;
      foutCount = 0;
      frefCount = 0;
    end    
end 

always @(posedge fin) begin
  if(pd1D == 0 && pd == 1)
     $display("PLL enters power-down mode!, at time = %0d ns", $time);
  if(pd1D == 1 && pd == 0)
     $display("PLL leaves power-down mode!, at time = %0d ns", $time);   
  pd1D = pd;   
end


////////////////////////
//Check Input Setting
///////////////////////
always @(fin or od or pd or r or f or bp or oeb)
begin
  InputError = (fin === 1'bx | ^od === 1'bx | pd  === 1'bx | 
                ^r  === 1'bx | ^f  === 1'bx | oeb === 1'bx | bp === 1'bx);

  if (InputError == 1)
     $display("Some Input(s) Unknown! Please check your design.");
     
 
        
end 


endmodule
`endcelldefine
