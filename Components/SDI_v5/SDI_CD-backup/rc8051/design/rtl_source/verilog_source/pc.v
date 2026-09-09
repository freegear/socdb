module pc(
		clk, 
		rst_p, 
		ld_pc,  
		ld_pcl,  
		ld_pch,  
		inc_pc, 
		in_pc, 
		out_pc_r
		);

input  		clk; 
input  		rst_p; 
input  		ld_pc; 
input  		ld_pcl; 
input  		ld_pch; 
input  		inc_pc; 
input[15:0] 	in_pc;

output[15:0] 	out_pc_r;
reg[15:0]	out_pc_r;

always @(posedge clk or  posedge rst_p)
if (rst_p) out_pc_r <= 0;
else if (ld_pc) out_pc_r <= in_pc; 
else if (ld_pcl) out_pc_r[7:0] <= in_pc[7:0]; 
else if (ld_pch) out_pc_r[15:8] <= in_pc[15:8]; 
else if (inc_pc) out_pc_r <= out_pc_r + 1;
endmodule 
