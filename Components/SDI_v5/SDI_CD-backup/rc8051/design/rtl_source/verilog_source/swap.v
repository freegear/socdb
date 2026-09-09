module swap(d, q); 
input[7:0]	 d;

output[7:0]	 q;

	assign q = {d[3:0],d[7:4]};
endmodule
