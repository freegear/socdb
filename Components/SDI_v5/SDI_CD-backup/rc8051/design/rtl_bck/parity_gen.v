module parity_gen(p_acc, parity);
input[7:0]	 p_acc;
output		 parity;  

assign parity = p_acc[7] ^ p_acc[6] ^ p_acc[5] ^ 
	p_acc[4] ^ p_acc[3] ^ p_acc[2] ^ 
	p_acc[1] ^ p_acc[0];
endmodule


