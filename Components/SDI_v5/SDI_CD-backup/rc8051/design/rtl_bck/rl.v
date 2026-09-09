module rl(d, q); 
input[7:0] 	d;

output[7:0]	q;
	
	assign q ={d[6:0],d[7]};
endmodule
