module yfd1 (d,clk,q);

input d,clk;
output q;

reg pq;
always @(posedge clk)
	pq <= d;

assign #0.4 q = pq;

endmodule
