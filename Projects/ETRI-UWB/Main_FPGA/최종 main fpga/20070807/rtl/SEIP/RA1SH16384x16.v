
module RA1SH16384x16(
	CLK, nRST, CEN, WEN, A, D, Q
);

parameter aw = 14;
parameter dw = 16;

input			CLK;	// Clock
input			nRST;	// Reset
input			CEN;	// Chip enable input
input			WEN;	// Write enable input
input 	[aw-1:0]	A;	// address bus inputs
input	[dw-1:0]	D;	// input data bus
output	[dw-1:0]	Q;	// output data bus

reg		[dw-1:0]	mem [(1<<aw)-1:0];
reg		[dw-1:0] Q;

integer i;

always @(negedge nRST or posedge CLK)
	if (!nRST) begin
    	for(i=0;i<16384;i=i+1) mem[i] <= 0;
    	Q <= 0;
  	end
	else begin
		if (!CEN && WEN)
			Q <= #1 mem[A];
		else if (!CEN && !WEN) begin
			mem[A] <= #1 D;
			Q <= #1 D;
		end
	end

endmodule
