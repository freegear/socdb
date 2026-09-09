module  acc(
		clk, 
		rst_p, 
		ld_acc, 
		ld_acc_chd, 
		wr,
		addr_acc,
		in_acc, 
		acc_chd, 
		out_acc_r
		);

input  		clk; 
input  		rst_p; 
input  		ld_acc; 
input  		ld_acc_chd; 
input  		wr; 
input[7:0] 	addr_acc; // address of acc
input[7:0] 	in_acc;
input[7:0] 	acc_chd;

output[7:0] 	out_acc_r;

reg[7:0]	out_acc_r;

always @(posedge clk or  posedge rst_p)
if (rst_p) out_acc_r <= 0;
else if (ld_acc) out_acc_r <= in_acc; 
else if (ld_acc_chd) out_acc_r <= acc_chd; 
else if (wr & (addr_acc == 8'he0)) 
	out_acc_r <= in_acc; 

endmodule 

