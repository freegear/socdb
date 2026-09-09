module gpio1 (
	//in
	clk, 
	rst_p, 
	wr, 
	rmw, 
	combus, 
	prt1_addr,
 	p1_in,
	//out
	p1, 
	p1_out 
	);

input		clk;
input		rst_p; 
input		wr; 
input[7:0] 	p1_in;
input[7:0] 	combus; 
input		rmw;
input[7:0] 	prt1_addr; 
 
output[7:0]	p1; 
output[7:0]	p1_out; 
	    
reg[7:0]     	p1_out; 

always @(posedge clk or posedge rst_p)     
if (rst_p) p1_out <= 8'hff;
else if (wr & (prt1_addr == 8'h90))
	p1_out <= combus;

assign p1 = (rmw == 1)? p1_out:p1_in;
endmodule
