module ip (
	clk, 
	rst_p, 
	in_ip,
	addr_ip, 
	wr,
	out_ip
	);

input           clk;
input           rst_p;
input [7:0]	in_ip;
input [7:0]	addr_ip;
input	        wr;
output[7:0]     out_ip;
reg   [7:0]     out_ip;

always @(posedge clk or posedge rst_p) 
if (rst_p) out_ip <= 0;
else if (wr & (addr_ip == 8'hb8)) 
	out_ip <= in_ip;
endmodule               
