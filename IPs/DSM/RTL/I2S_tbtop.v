/*****************************************************************
		         Part of I2S Controller testbench
*****************************************************************/
`timescale 1 ns/ 100ps
module I2S_tbtop
(
		SYS_CLK,

		PCLK,
		PRESETn,
		PENABLE, 
		PSEL,
		PWRITE, 
		PADDR, 
		PWDATA,
		PRDATA,

		Interrupt,
		
		// For DSM test data output & reset
//		nReset,
		START_data_true,
//		DSM_INDATA_R,
//		DSM_INDATA_L,

		DSM_OUTDATA_Left,
		DSM_OUTDATA_Right,

		TxDMAReq,
		RxDMAReq,

		MCLK,		// 256*Fs clock output
	//	MCLK_OE,	// MCLK Output Enable(active high)
		BCLK_O,		// BCLK clock output
		BCLK_I,		// BCLK clock input
		BCLK_OE,	// BCLK Output Enable(active high)
		LRCLK_O,	// LRCLK clock output
		LRCLK_I,	// LRCLK clock input
		LRCLK_OE,	// LRCLK Output Enable(active high)
		SDIN,		// Serial Data Input
		SDOUT		// Serial Data Output
);

parameter I2S_RFIFO_DEPTH=6;
parameter I2S_TFIFO_DEPTH=6;

input         SYS_CLK;

input         PCLK;
input         PRESETn;
input         PENABLE; 
input         PSEL;
input         PWRITE;
input  [3:2]  PADDR;
input  [31:0] PWDATA;
output [31:0] PRDATA;

output        TxDMAReq;
output        RxDMAReq;

output        DSM_OUTDATA_Left;
output        DSM_OUTDATA_Right;


output        Interrupt;

//output	nReset;
//output	[23:0] DSM_INDATA_R;
//output	[23:0] DSM_INDATA_L;
output	START_data_true;


output        MCLK;
//output        MCLK_OE;
output        BCLK_O;
input         BCLK_I;
output        BCLK_OE;
output        LRCLK_O;
input         LRCLK_I;
output        LRCLK_OE;
input         SDIN;
output        SDOUT;


//output        MCLK;
//inout         BCLK;
//inout         LRCLK;
//input         SDIN;
//output        SDOUT;

wire Interrupt;
wire TxDMAReq;
wire RxDMAReq;
wire MCLK;
//wire MCLK_OE;
wire BCLK_O;
wire BCLK_I;
wire BCLK_OE;
wire LRCLK_O;
wire LRCLK_I;
wire LRCLK_OE;
wire SDIN;
wire SDOUT;

//tri  BCLK;
//tri  LRCLK;

wire  BCLK;
wire  LRCLK;

assign BCLK  = (BCLK_OE)  ? BCLK_O  : 1'bz;
assign LRCLK = (LRCLK_OE) ? LRCLK_O : 1'bz;

assign BCLK_I  = BCLK;
assign LRCLK_I = LRCLK;

I2S_Top #(I2S_RFIFO_DEPTH, I2S_TFIFO_DEPTH) I2SCtrl
(
		.SYS_CLK(SYS_CLK),

		.PCLK(PCLK),
		.PRESETn(PRESETn),
		.PENABLE(PENABLE),
		.PSEL(PSEL),
		.PWRITE(PWRITE),
		.PADDR(PADDR[3:2]),
		.PWDATA(PWDATA),
		.PRDATA(PRDATA),

		.Interrupt(Interrupt),
	
		// For DSM test data output & reset
	//	.nReset(nReset),
		.START_data_true(START_data_true),
	//	.DSM_INDATA_R(DSM_INDATA_R), 
	//	.DSM_INDATA_L(DSM_INDATA_L), 

		.DSM_OUTDATA_Left(DSM_OUTDATA_Left), 
		.DSM_OUTDATA_Right(DSM_OUTDATA_Right), 


		.TxDMAReq(TxDMAReq),
		.RxDMAReq(RxDMAReq),

		.MCLK(MCLK),
	//	.MCLK_OE(MCLK_OE),
		.BCLK_O(BCLK_O),
		.BCLK_I(BCLK_I),
		.BCLK_OE(BCLK_OE),
		.LRCLK_O(LRCLK_O),
		.LRCLK_I(LRCLK_I),
		.LRCLK_OE(LRCLK_OE),
		.SDIN(SDIN),
		.SDOUT(SDOUT)
);

endmodule

