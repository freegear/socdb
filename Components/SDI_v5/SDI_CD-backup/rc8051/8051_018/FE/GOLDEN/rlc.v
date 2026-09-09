module rlc(d, in_cy, out_cy, q); 
input[7:0]	 d;
input            in_cy;
output	 	 out_cy;
output[7:0]	 q;

	assign  q = {d[6:0],in_cy};
	assign  out_cy = d[7];
endmodule
