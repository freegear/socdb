/*****************************************************************
		         openrisc quem only testbench
*****************************************************************/
`timescale 1 ns/ 10ps
module tb;

parameter CLK_HALFPERIOD=5;

reg  clk;       // or1200 clock
reg  reset;     // or1200 active high reset

always #CLK_HALFPERIOD	clk = ~clk;

initial clk 		= 0;     // clock
initial
begin
	reset 	= 1;     // reset
	repeat(10) @(posedge clk);
	reset	= 0;
end

wire [19:0] interrupts;
assign interrupts = 20'h00000;

or1200_top or1200_top
(
		.clk_i(clk),
		.rst_i(reset),
		.pic_ints_i(interrupts)
);

endmodule
