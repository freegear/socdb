module dptr(
		clk, 
		rst_p, 
		ld_dpl, 
		ld_dph, 
		wr,
		inc_dptr,
		addr_dptr,
		in_dptr, 
		out_dptr  
		);

input 		clk;
input 		rst_p;
input 		ld_dpl;
input 		ld_dph;
input		wr;
input 		inc_dptr;
input[7:0]	addr_dptr;
input [7:0] 	in_dptr;

output [15:0] 	out_dptr;
reg [15:0] 	out_dptr;

always @(posedge clk or posedge rst_p) 
if (rst_p) out_dptr <= 0; 
else if ((addr_dptr == 8'h82 && wr == 1'd1) ||
	ld_dpl == 1'd1) 
	out_dptr[7:0] <= in_dptr; 
else if ((addr_dptr == 8'h83 && wr == 1'd1) ||
	ld_dph == 1'd1) 
	out_dptr[15:8] <= in_dptr; 
else if (inc_dptr) out_dptr <= out_dptr + 1'b1;
endmodule 
