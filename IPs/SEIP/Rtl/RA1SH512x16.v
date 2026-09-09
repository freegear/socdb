
module RA1SH512x16(
	CLK, CEN, WEN, A, D, Q
);

parameter aw = 9;
parameter dw = 16;

input			CLK;	// Clock
input			CEN;	// Chip enable input
input			WEN;	// Write enable input
input 	[aw-1:0]	A;	// address bus inputs
input	[dw-1:0]	D;	// input data bus
output	[dw-1:0]	Q;	// output data bus

integer i;
reg     [dw-1:0]    mem [{(aw){1'b1}}:0];
reg     [dw-1:0] Q;


always @(posedge CLK)
	if (!CEN && WEN)
		Q <= #1 mem[A];
	else if (!CEN && !WEN) begin
		mem[A] <= #1 D;
		Q <= #1 D;
	end

endmodule
