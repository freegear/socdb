module sp(
	clk, 
	rst_p, 
	wr, 
	inc_sp, 
	dec_sp,
	addr_sp,
	in_sp, 
	out_sp  
	);

input	 	clk;
input 		rst_p;
input 		wr;
input 		inc_sp;
input 		dec_sp;
input[7:0] 	addr_sp;
input[7:0] 	in_sp;

output[7:0] 	out_sp;

reg[7:0] 	out_sp;

always @(posedge clk or posedge rst_p) 
if (rst_p) out_sp <= 8'd7;
else if (addr_sp == 8'h81 & wr) 
	out_sp <= in_sp; 
else if (inc_sp) out_sp <= out_sp + 1'b1;
else if (dec_sp) out_sp <= out_sp - 1'b1;
endmodule 
