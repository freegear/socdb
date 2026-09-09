//  00000 ADD
//  00001 ADDC
//  00010 SUBB
//  00011 INC
//  00100 DEC
//  00101 MUL
//  00110 DIV
//  00111 DA
//  01000 ANL
//  01001 ORL
//  01010 XRL
//  01011 CLR
//  01100 CPL
//  01101 RL
//  01110 RLC
//  01111 RR
//  10000 RRC
//  10001 SWAP
module alu_flag_d_m(
		 al,		
                 m,		
                 r,		
		 dividor,
                 cy_addc,	
                 cy_rlc,	
                 cy_rrc,	
                 ac_addc,	
                 ov_addc,	
                 cy,		
                 ac,		
                 ov,		
                 IN_B
		 );		

input[4:0]	 al; // arithmetic and logic 
input[7:0]	 m;
input[7:0]	 r;
input[7:0]	 dividor;
input		 cy_addc;		
input		 cy_rlc;			
input		 cy_rrc;			
input		 ac_addc;		
input		 ov_addc;		

output		 cy;			
output		 ac;			
output		 ov;			
output[7:0]      IN_B;  

reg		 cy;  
reg		 ac;  
wire             s_ov_div;
wire             s_ov_mul;
reg		 ov;  
reg[7:0]         IN_B;	

always @(al or cy_addc or cy_rlc or cy_rrc) begin
    if(al == 5'd0 || al == 5'd1)
		 	cy <= cy_addc;
else if (al == 5'd2)    cy <= ~cy_addc; 
else if (al == 5'd14)	cy <= cy_rlc;
else if (al == 5'd16) 	cy <= cy_rrc;
else                    cy <= 0;
end
always @(al or ac_addc) begin
if(al == 5'd0 || al == 5'd1) 	
			ac <= ac_addc;
else if (al == 5'd2)	ac <= ~ac_addc;
else                    ac <= 0;
end                  

always @(al or ov_addc or s_ov_mul  or s_ov_div)
begin
if(al == 5'd0 || al == 5'd1 || al == 5'd2) 	
			ov <= ov_addc;
else if (al == 5'd5)    ov <= s_ov_mul;   
else if (al == 5'd6)    ov <= s_ov_div;   
else                    ov <= 0;          
end                                                
always @(al or m or r) 
begin
if      (al == 5'd5)    IN_B <= m;
else if (al == 5'd6)	IN_B <= r;
else                    IN_B <= 0;
end

assign s_ov_mul = (m)? 1'b1 : 0;

assign s_ov_div = (dividor == 0)? 1'b1 : 0; 

endmodule

