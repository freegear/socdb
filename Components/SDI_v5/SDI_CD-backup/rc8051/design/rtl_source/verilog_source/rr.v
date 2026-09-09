module rr(d, q); 
input[7:0]      d;

output[7:0]	q;

	assign  q = {d[0],d[7:1]};
endmodule
