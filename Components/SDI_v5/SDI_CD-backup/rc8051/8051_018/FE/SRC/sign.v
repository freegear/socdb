module sign(a, b); 
input[7:0]		a;
output[15:0]		b;
	
assign b = (a > 8'b01111111)? {8'b11111111,a}:{8'b00000000,a};

endmodule
