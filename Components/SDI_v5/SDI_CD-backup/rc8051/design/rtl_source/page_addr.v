module page_addr(pc, code, xrom, page_addr_a);
input[4:0]		pc;
input[2:0]		code;
input[7:0]		xrom;
output[15:0]		page_addr_a;

	assign page_addr_a = {pc,code,xrom};

endmodule 
