module gpio2 (
	//in
	clk, 
	rst_p, 
	wr, 
	rmw, 
	combus, 
	prt2_addr,
 	p2_in,
	//out
	p2, 
	p2_out 
	);

input		clk;
input		rst_p; 
input		wr; 
input[7:0] 	p2_in;
input[7:0] 	combus; 
input		rmw;
input[7:0] 	prt2_addr; 
 
output[7:0]	p2; 
output[7:0]	p2_out; 
	    
reg[7:0]     	p2_out; 

always @(posedge clk or posedge rst_p)     
if (rst_p) p2_out <= 8'hff;
else if (wr & (prt2_addr == 8'ha0))
	p2_out <= combus;

assign p2 = (rmw == 1)? p2_out:p2_in;
endmodule
