module ie (
	clk, 
	rst_p, 
	in_ie,
	addr_ie, 
	wr,
	out_ie
	);

input           clk;
input           rst_p;
input [7:0]	in_ie;
input [7:0]	addr_ie;
input	        wr;
output[7:0]     out_ie;
reg   [7:0]     out_ie;

always @(posedge clk or posedge rst_p) 
if (rst_p) out_ie <= 0;
else if (wr & (addr_ie == 8'ha8)) 
	out_ie <= in_ie;

endmodule               
