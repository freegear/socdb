module dimod(
		clk, 
		rst_p, 
		wr,
		addr_dimod,
		in_dimod, 
		out_dimod  
		);

input 		clk;
input 		rst_p;
input		wr;
input[7:0]	addr_dimod;
input [7:0] 	in_dimod;

output [7:0] 	out_dimod;
reg [7:0] 	out_dimod;

always @(posedge clk or posedge rst_p) 
if (rst_p) out_dimod <= 0; 
else if (addr_dimod == 8'h84 && wr == 1'd1) 
	out_dimod[7:0] <= in_dimod; 
endmodule 
