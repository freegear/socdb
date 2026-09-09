module tmod(
	clk, 
	rst_p, 
	wr, 
	in_tmod, 
	addr_tmod, 
	out_tmod	
	);
input			clk, rst_p;
input			wr;
input[7:0]		in_tmod;
input[7:0]		addr_tmod;

output[7:0]		out_tmod;
reg[7:0]		out_tmod;

always @(posedge clk or posedge rst_p) 
	if(rst_p) out_tmod <= 0;
	else if (wr)
		if (addr_tmod == 8'h89) 
			out_tmod <= in_tmod;
endmodule
