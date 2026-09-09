/*****************************************************************
		         openrisc ahb testbench
*****************************************************************/
`timescale 1 ns/ 10ps
module tb;

parameter CLK_HALFPERIOD=5;

reg  clk;       // or1200 clock
reg  resetn;     // or1200 active high reset

always #CLK_HALFPERIOD	clk = ~clk;

initial clk 		= 0;     // clock
initial
begin
	resetn 	= 0;     // reset
	repeat(10) @(posedge clk);
	resetn	= 1;
end

system_top system_top
(
		.CLK(clk),
		.RESETn(resetn)
);

endmodule
