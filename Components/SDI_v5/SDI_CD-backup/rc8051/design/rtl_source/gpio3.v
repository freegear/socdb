module gpio3 (
	//in
	clk, 
	rst_p, 
	wr, 
	rmw, 
	combus, 
	prt3_addr,
 	p3_in,
	//out
	p3, 
	p3_out 
	);

input		clk;
input		rst_p; 
input		wr; 
input[7:0] 	p3_in;
input[7:0] 	combus; 
input		rmw;
input[7:0] 	prt3_addr; 
 
output[7:0]	p3; 
output[7:0]	p3_out; 
	    
reg[7:0]     	p3_out; 

always @(posedge clk or posedge rst_p)     
if (rst_p) p3_out <= 8'hff;
else if (wr & (prt3_addr == 8'hb0))
	p3_out <= combus;

assign p3 = (rmw == 1)? p3_out:p3_in;
endmodule
