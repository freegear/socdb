module da(d, ac, cy, q); 
input[7:0]        d;
input             ac;		     
input             cy;
		     
output[7:0]       q;
reg[7:0]          q;

	always @(d or ac or cy)
	begin
      	  if(ac == 1 || (1111>= d[3:0] && d[3:0] >= 4'b1010))
		q <= d + 8'b00000110;
	  else if(cy == 1 || (4'b1111>= d[7:4] && d[7:4] >= 4'b1010)) 
		q <= d + 8'b01100000;
	  else  q <= d;
	end
endmodule
