`timescale 1ns/1ps
module Uart4Ch (
		PCLK, 
		PRESETn, 
		PENABLE, 
		PSEL, 
		PWRITE, 
		PADDR,
		PWDATA,
		PRDATA,
		
		TXD,
		RXD,

		Interrupt,
		RxDMAReq,
		TxDMAReq

);

input         PCLK;     // APB system clock
input         PRESETn;     // APB system reset
input         PENABLE;     // Data valid strobe 
input         PSEL;
input         PWRITE;     // Write/nRead signal
input  [6:2]  PADDR;     // Address (used bits only)

input  [31:0] PWDATA;
output [31:0] PRDATA;

output [3:0]  TXD;
input  [3:0]  RXD;

output [3:0]  Interrupt;
output [3:0]  RxDMAReq;
output [3:0]  TxDMAReq;

wire PSELUart0 = PSEL & ~PADDR[6] & ~PADDR[5];
wire PSELUart1 = PSEL & ~PADDR[6] &  PADDR[5];
wire PSELUart2 = PSEL & PADDR[6] & ~PADDR[5];
wire PSELUart3 = PSEL & PADDR[6] &  PADDR[5];

wire [31:0] PRDATAUart0;
wire [31:0] PRDATAUart1;
wire [31:0] PRDATAUart2;
wire [31:0] PRDATAUart3;

wire [31:0] PRDATA;
assign PRDATA = ({32{PSELUart0}} & PRDATAUart0)
			|   ({32{PSELUart1}} & PRDATAUart1)
			|   ({32{PSELUart2}} & PRDATAUart2)
			|   ({32{PSELUart3}} & PRDATAUart3);

//Timers0~3
UartTop #(3'b011) Uart0 	// 32 Depth FIFO
(
		.clk(PCLK), 
		.rstb(PRESETn), 
		.PENABLE(PENABLE), 
		.PSEL(PSELUart0), 
		.PWRITE(PWRITE), 
		.PADDR(PADDR[4:2]), 
		.PWDATA(PWDATA),
		.PRDATA(PRDATAUart0),

		.rxd(RXD[0]),
		.txd(TXD[0]),
		.int(Interrupt[0]),
		.rxdmareq(RxDMAReq[0]),
		.txdmareq(TxDMAReq[0])
);

UartTop #(3'b011) Uart1 	// 32 Depth FIFO
(
		.clk(PCLK), 
		.rstb(PRESETn), 
		.PENABLE(PENABLE), 
		.PSEL(PSELUart1), 
		.PWRITE(PWRITE), 
		.PADDR(PADDR[4:2]), 
		.PWDATA(PWDATA),
		.PRDATA(PRDATAUart1),

		.rxd(RXD[1]),
		.txd(TXD[1]),
		.int(Interrupt[1]),
		.rxdmareq(RxDMAReq[1]),
		.txdmareq(TxDMAReq[1])
);

UartTop #(3'b001) Uart2 	// 8 Depth FIFO
(
		.clk(PCLK), 
		.rstb(PRESETn), 
		.PENABLE(PENABLE), 
		.PSEL(PSELUart2), 
		.PWRITE(PWRITE), 
		.PADDR(PADDR[4:2]), 
		.PWDATA(PWDATA),
		.PRDATA(PRDATAUart2),

		.rxd(RXD[2]),
		.txd(TXD[2]),
		.int(Interrupt[2]),
		.rxdmareq(RxDMAReq[2]),
		.txdmareq(TxDMAReq[2])
);

UartTop #(3'b001) Uart3 	// 8 Depth FIFO
(
		.clk(PCLK), 
		.rstb(PRESETn), 
		.PENABLE(PENABLE), 
		.PSEL(PSELUart3), 
		.PWRITE(PWRITE), 
		.PADDR(PADDR[4:2]), 
		.PWDATA(PWDATA),
		.PRDATA(PRDATAUart3),

		.rxd(RXD[3]),
		.txd(TXD[3]),
		.int(Interrupt[3]),
		.rxdmareq(RxDMAReq[3]),
		.txdmareq(TxDMAReq[3])
);

endmodule
