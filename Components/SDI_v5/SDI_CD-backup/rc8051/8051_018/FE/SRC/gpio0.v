module gpio0 (
	//in
	clk, 
	rst_p, 
	wr, 
	rmw, 
	combus, 
	prt0_addr,
 	p0_in,
	//out
	p0, 
	p0_out 
	);

input		clk;
input		rst_p; 
input		wr; 
input[7:0] 	p0_in;
input[7:0] 	combus; 
input		rmw;
input[7:0] 	prt0_addr; 
 
output[7:0]	p0; 
output[7:0]	p0_out; 
	    
reg[7:0]     	p0_out; 

always @(posedge clk or posedge rst_p)     
if (rst_p) p0_out <= 8'hff;
else if (wr & (prt0_addr == 8'h80))
	p0_out <= combus;

assign p0 = (rmw == 1)? p0_out:p0_in;
endmodule
