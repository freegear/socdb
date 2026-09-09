// ==============================================================================
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : I2S_Top.v
// File Revision       : 3.0 CT500(TSMC)
// ------------------------------------------------------------------------------
//  Purpose            : I2S Controller Top Module
// ==============================================================================
// DSM test 

`timescale 1ns/1ps
module I2S_Top
(
		// System Clock : connect to much higher clock(at least 5x256xFs)
		SYS_CLK,

		//	APB
		PCLK     ,
		PRESETn  ,
		PENABLE, 
		PSEL,
		PWRITE, 
		PADDR, 
		PWDATA,
		PRDATA,

		// Interrupt Out
		Interrupt,
		
		// For DSM debugging LED test 
		START_data_true,
		DSM_OUTDATA_Left,
		DSM_OUTDATA_Right,

		// DMA Request
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

parameter I2S_RFIFO_DEPTH=5;
parameter I2S_TFIFO_DEPTH=5;
//
// input/output port
//
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

output        Interrupt;

//output			nReset;
output			START_data_true;
//output			DSM_sysclk;

//output [23:0] DSM_INDATA_R;
//output [23:0] DSM_INDATA_L;

output		DSM_OUTDATA_Left;
output		DSM_OUTDATA_Right;




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

wire START_data_true;
wire  [23:0] DSM_INDATA_R;
wire  [23:0] DSM_INDATA_L;

wire        ClkMS;
wire        LRClkInv;
wire        MClkOn;
wire [17:0] DTORatio;

wire        TxEnabled;
wire        TxReset;
wire [1:0]  TxWordLength;
wire        TxLeftJust;
wire        TxFifoUnderRun;

wire        RxEnabled;
wire        RxReset;
wire [1:0]  RxWordLength;
wire        RxLeftJust;
wire        RxFifoOverRun;

wire [31:0] TxFifoWData;
wire        nTxFifoWriteEn;
wire        TxFifoFull;
wire        TxFifoEmpty;
wire [I2S_TFIFO_DEPTH-1:0] TxFifoLevel;
wire        nTxFifoReadEn;
wire [31:0] TxFifoData;
wire        TxFifoAfford2Write;
wire        TxFifoAfford2Read;

wire [31:0] RxFifoData;
wire        nRxFifoReadEn;
wire        RxFifoFull;
wire        RxFifoEmpty;
wire [I2S_RFIFO_DEPTH-1:0] RxFifoLevel;
wire        nRxFifoWriteEn;
wire [31:0] RxFifoWData;
wire        RxFifoAfford2Write;
wire        RxFifoAfford2Read;

wire        FrameStart;
wire        RightStart;
wire        BCLKRise;
wire        BCLKFall;
wire        SDInput;
wire        LRCLKInt;


wire	[31:0]	RightChannelData;			//MCHong
wire	[31:0]	LeftChannelData;			//MCHong
wire        RightLoad;
wire  		MCLK;

I2S_Control #(I2S_RFIFO_DEPTH, I2S_TFIFO_DEPTH) Ctrl (
		.PCLK(PCLK),
		.PRESETn(PRESETn),
		.PADDR(PADDR),
		.PENABLE(PENABLE),
		.PSEL(PSEL),
		.PWRITE(PWRITE),
		.PWDATA(PWDATA),
		.PRDATA(PRDATA),

		.Interrupt(Interrupt),
		.TxDMAReq(TxDMAReq),
		.RxDMAReq(RxDMAReq),

		.ClkMS(ClkMS),
		.LRClkInv(LRClkInv),
		.MClkOn(MClkOn),
		.MClkOE(MCLK_OE),
		.DTORatio(DTORatio),

		.TxEnabled(TxEnabled),
		.TxReset(TxReset),
		.TxWordLength(TxWordLength),
		.TxLeftJust(TxLeftJust),
		.TxFifoUnderRun(TxFifoUnderRun),

		.RxEnabled(RxEnabled),
		.RxReset(RxReset),
		.RxWordLength(RxWordLength),
		.RxLeftJust(RxLeftJust),
		.RxFifoOverRun(RxFifoOverRun),

		.TxFifoWData(TxFifoWData),
		.nTxFifoWriteEn(nTxFifoWriteEn),
		.TxFifoFull(TxFifoFull),
		.TxFifoEmpty(TxFifoEmpty),
		.TxFifoLevel(TxFifoLevel),
		.TxFifoAfford2Read(TxFifoAfford2Read),

		.RxFifoData(RxFifoData),
		.nRxFifoReadEn(nRxFifoReadEn),
		.RxFifoFull(RxFifoFull),
		.RxFifoEmpty(RxFifoEmpty),
		.RxFifoLevel(RxFifoLevel),
		.RxFifoAfford2Write(RxFifoAfford2Write)
);

I2S_DTO DTO(
		.SYS_CLK(SYS_CLK),
		.RESETn(PRESETn),

		.MCLK(MCLK),
		.BCLK(BCLK_O),
		.LRCLK(LRCLK_O),

		.Enable(MClkOn),
		.LRClkInv(LRClkInv),
		.ClkMS(ClkMS),
		.DTORatio(DTORatio)
);

I2S_ClockMgr ClockMgr(
		.CLK(PCLK),
		.RESETn(PRESETn),

		.LRCLK_I(LRCLK_I),
		.BCLK_I(BCLK_I),
		.SDIN(SDIN),

		.LeftStart(FrameStart),
		.RightStart(RightStart),
		.BCLKRise(BCLKRise),
		.BCLKFall(BCLKFall),
		.SDInput(SDInput),
		.LRCLK(LRCLKInt),

		.Master(ClkMS),
		.LRCLKInvert(LRClkInv)
);

I2S_Serializer Serializer(
		.CLK(PCLK),
		.RESETn(PRESETn),

		.Enabled(TxEnabled),
		.SyncReset(TxReset),
		.WordLength(TxWordLength),
		.LeftJust(TxLeftJust),
		
		.FifoUnderRun(TxFifoUnderRun),

		.FrameStart(FrameStart),
		.RightStart(RightStart),
		.BCLKFall(BCLKFall),
		.SDOUT(SDOUT),

		.RightChannelData(RightChannelData),
		.LeftChannelData(LeftChannelData),
		.RightLoad(RightLoad),

		.FifoData(TxFifoData),
		.FifoAfford2Read(TxFifoAfford2Read),
		.FifoEmpty(TxFifoEmpty),
		.nFifoReadEn(nTxFifoReadEn)
);

//I2S_FIFO #(I2S_TFIFO_DEPTH) TxFifo(
I2S_FIFO TxFifo(
		.CLK(PCLK),
		.RESETn(PRESETn),

		.nReadEnable(nTxFifoReadEn),
		.ReadData(TxFifoData),

		.nWriteEnable(nTxFifoWriteEn),
		.WriteData(TxFifoWData),

		.SyncReset(TxReset),
		.Full(TxFifoFull),
		.Empty(TxFifoEmpty),
		.Afford2Write(TxFifoAfford2Write),
		.Afford2Read(TxFifoAfford2Read),

		.FillLevel(TxFifoLevel)
);

I2S_Deserializer Deserializer(
		.CLK(PCLK),
		.RESETn(PRESETn),

		// Control
		.Enabled(RxEnabled),
		.SyncReset(RxReset),
		.WordLength(RxWordLength),
		.LeftJust(RxLeftJust),

		.FifoOverRun(RxFifoOverRun),

		// I2SLINK Clock
		.LRCLK(LRCLKInt),
		.BCLKRise(BCLKRise),
		.SDIN(SDInput),

		.FifoWData(RxFifoWData),
		.FifoAfford2Write(RxFifoAfford2Write),
		.FifoFull(RxFifoFull),
		.nFifoWriteEn(nRxFifoWriteEn)
);
// Not Implemented I2S Receiver Now.


DSM_DelayDataBlock DSM_DelayDataBlock
(
	.CLK(SYS_CLK),   				
	.nReset(PRESETn),			
	.MCLK(MCLK),					   	//48Kh * 256 Freq

	.DATAINPUT_R(RightChannelData), 		//I2S FIFO output
	.DATAINPUT_L(LeftChannelData), 		//I2S FIFO output
	.RightLoadSignal(RightLoad),
	.START_data_true(START_data_true),			//DSM output
//	.DSM_sysclk(DSM_sysclk),			//DSM output sys clk

	.DSM_INDATA_R(DSM_INDATA_R),		//DSM output
	.DSM_INDATA_L(DSM_INDATA_L)			//DSM output
);

DSM_Left DSM_Left(
		.nReset(PRESETn),
		.Left_start(START_data_true),
		.DSM_SYSCLK(SYS_CLK),
		.DATAINPUTL(DSM_INDATA_L),
		.MCLK(MCLK),
		.DSM_OUTDATA_L(DSM_OUTDATA_Left)
);
DSM_Right DSM_Right(
		.nReset(PRESETn),
		.Right_start(START_data_true),
		.DSM_SYSCLK(SYS_CLK),
		.DATAINPUTR(DSM_INDATA_R),
		.MCLK(MCLK),
		.DSM_OUTDATA_R(DSM_OUTDATA_Right)
);
   				
		




//I2S_FIFO #(I2S_RFIFO_DEPTH) RxFifo(
I2S_FIFO RxFifo(
		.CLK(PCLK),
		.RESETn(PRESETn),

		.nReadEnable(nRxFifoReadEn),
		.ReadData(RxFifoData),

		.nWriteEnable(nRxFifoWriteEn),
		.WriteData(RxFifoWData),

		.SyncReset(RxReset),
		.Full(RxFifoFull),
		.Empty(RxFifoEmpty),
		.Afford2Write(RxFifoAfford2Write),
		.Afford2Read(RxFifoAfford2Read),

		.FillLevel(RxFifoLevel)
);

// Output Assign
assign BCLK_OE  = ClkMS;
assign LRCLK_OE = ClkMS;

wire nReset = PRESETn;//MCHong 10.01.10
//wire RightLoadSignal = RightLoad;//MCHong 10.01.10
//wire [23:0] DATAINPUT = RightChannelData;//MCHong 10.01.10
endmodule
