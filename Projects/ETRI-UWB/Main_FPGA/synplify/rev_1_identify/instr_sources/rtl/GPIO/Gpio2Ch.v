`timescale 1ns/1ps
module Gpio2Ch (
		PCLK, 
		PRESETn, 
		PENABLE, 
		PSEL, 
		PWRITE, 
		PADDR,
		PWDATA,
		PRDATA,
		
		Gpio0In,
		Gpio0OutEn,
		Gpio0Out,
		Gpio1In,
		Gpio1OutEn,
		Gpio1Out,

		Interrupt
);

input         PCLK;     // APB system clock
input         PRESETn;     // APB system reset
input         PENABLE;     // Data valid strobe 
input         PSEL;
input         PWRITE;     // Write/nRead signal
input  [5:2]  PADDR;     // Address (used bits only)

input  [31:0] PWDATA;
output [31:0] PRDATA;

input  [31:0] Gpio0In;
output [31:0] Gpio0OutEn;
output [31:0] Gpio0Out;

input  [31:0] Gpio1In;
output [31:0] Gpio1OutEn;
output [31:0] Gpio1Out;


output [1:0]  Interrupt;

wire PSELGpio0 = PSEL & ~PADDR[5];
wire PSELGpio1 = PSEL &  PADDR[5];

wire [31:0] PRDATAGpio0;
wire [31:0] PRDATAGpio1;

wire [31:0] PRDATA;
assign PRDATA = ({32{PSELGpio0}} & PRDATAGpio0)
			|   ({32{PSELGpio1}} & PRDATAGpio1);

Gpio Gpio0 
(
		.PCLK(PCLK), 
		.PRESETn(PRESETn), 
		.PENABLE(PENABLE), 
		.PSEL(PSELGpio0), 
		.PWRITE(PWRITE), 
		.PADDR(PADDR[4:2]), 
		.PWDATA(PWDATA),
		.PRDATA(PRDATAGpio0),

		.GpioIn(Gpio0In[31:0]),
		.GpioOutEn(Gpio0OutEn[31:0]),
		.GpioOut(Gpio0Out[31:0]),

		.Interrupt(Interrupt[0])
);

Gpio Gpio01
(
		.PCLK(PCLK),
		.PRESETn(PRESETn),
		.PENABLE(PENABLE),
		.PSEL(PSELGpio1),
		.PWRITE(PWRITE),
		.PADDR(PADDR[4:2]),
		.PWDATA(PWDATA),
		.PRDATA(PRDATAGpio1),

		.GpioIn(Gpio1In),
		.GpioOutEn(Gpio1OutEn),
		.GpioOut(Gpio1Out),

		.Interrupt(Interrupt[1])
);

endmodule
