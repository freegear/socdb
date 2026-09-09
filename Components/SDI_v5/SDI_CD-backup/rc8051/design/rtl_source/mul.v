module mul(op1, op2, m);

input[7:0]	op1;
input[7:0]	op2;
output[15:0]	m;

assign  m = op1 * op2;
endmodule
