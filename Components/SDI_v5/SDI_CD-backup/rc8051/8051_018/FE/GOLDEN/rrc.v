module rrc(d, in_cy, out_cy, q); 
input[7:0]	d;	
input	 	in_cy; 
	
output		out_cy;	
output[7:0]     q;	

	assign  q = {in_cy,d[7:1]};
	assign  out_cy = d[0];
endmodule
