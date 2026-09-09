module b (
	clk, 
	rst_p, 
	in_b,
	in_dat,
	addr_b, 
	wr,
	ld_b,
	out_b
	);

input           clk;
input           rst_p;
input [7:0]	in_b;
input [7:0]	in_dat;
input [7:0]	addr_b;
input	        ld_b;
input	        wr;
output[7:0]     out_b;
reg   [7:0]     out_b;

always @(posedge clk or posedge rst_p) 
if (rst_p) out_b <= 0;
else if (ld_b) out_b <= in_b;
else if (wr & (addr_b == 8'hf0)) 
	out_b <= in_dat;
endmodule               
