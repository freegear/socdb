/*****************************************************************
		         Part of I2S Controller testbench
*****************************************************************/
`timescale 1 ns/1ps
module MCLKGen
(
		MASTER,
		MCLK		// 256*Fs
);

input  MASTER;
output MCLK;

reg MCLKInt;
initial MCLKInt = 0;

always #(81.38/2.0) MCLKInt = ~MCLKInt;

assign MCLK = (MASTER == 1) ? MCLKInt : 1'bz;
endmodule

