// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : I2S_Top.v
// File Revision       : 0.1
// ------------------------------------------------------------------------------
//  Purpose            : I2S Controller Top Module
// ==============================================================================


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

		// DMA Request
		TxDMAReq,
		RxDMAReq,

		MCLK,		// 256*Fs clock output
		MCLK_OE,	// MCLK Output Enable(active high)
		BCLK_O,		// BCLK clock output
		BCLK_I,		// BCLK clock input
		BCLK_OE,	// BCLK Output Enable(active high)
		LRCLK_O,	// LRCLK clock output
		LRCLK_I,	// LRCLK clock input
		LRCLK_OE,	// LRCLK Output Enable(active high)
		SDIN,		// Serial Data Input
		SDOUT		// Serial Data Output
);

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

output        MCLK;
output        MCLK_OE;
output        BCLK_O;
input         BCLK_I;
output        BCLK_OE;
output        LRCLK_O;
input         LRCLK_I;
output        LRCLK_OE;
input         SDIN;
output        SDOUT;

wire        ClkMS;
wire        LRClkInv;
wire        MClkOn;
wire        MClkOE;
wire [27:0] DTORatio;

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
wire [ 5:0] TxFifoLevel;
wire        nTxFifoReadEn;
wire [31:0] TxFifoData;
wire        TxFifoAfford2Write;
wire        TxFifoAfford2Read;

wire [31:0] RxFifoData;
wire        nRxFifoReadEn;
wire        RxFifoFull;
wire        RxFifoEmpty;
wire [ 5:0] RxFifoLevel;
wire        nRxFifoWriteEn;
wire [31:0] RxFifoWData;
wire        RxFifoAfford2Write;
wire        RxFifoAfford2Read;

wire        FrameStart;
wire        RightStart;
wire        BCLKRise;
wire        BCLKFall;

wire        BCLKInt;
I2S_Control Ctrl (
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

		.RxFifoData(RxFifoData),
		.nRxFifoReadEn(nRxFifoReadEn),
		.RxFifoFull(RxFifoFull),
		.RxFifoEmpty(RxFifoEmpty),
		.RxFifoLevel(RxFifoLevel)
);

I2S_DTO DTO(
		.SYS_CLK(SYS_CLK),
		.RESETn(PRESETn),

		.MCLK(MCLK),
		.BCLK(BCLKInt),

		.Enable(MClkOn),
		.DTORatio(DTORatio)
);

I2S_ClockMgr ClockMgr(
		.CLK(PCLK),
		.RESETn(PRESETn),
		.BCLKInt(BCLKInt),

		.LRCLK_O(LRCLK_O),
		.BCLK_O(BCLK_O),

		.LRCLK_I(LRCLK_I),
		.BCLK_I(BCLK_I),
		.SDIN(SDIN),

		.LeftStart(FrameStart),
		.RightStart(RightStart),
		.BCLKRise(BCLKRise),
		.BCLKFall(BCLKFall),
		.SDInput(SDInput),

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

		.FifoData(TxFifoData),
		.FifoAfford2Read(TxFifoAfford2Read),
		.FifoEmpty(TxFifoEmpty),
		.nFifoReadEn(nTxFifoReadEn)
);

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

// Not Implemented I2S Receiver Now.
// I2S_Deserializer
assign RxFifoOverRun = 0;

// RxFIFO
assign RxFifoData = 0;
assign RxFifoFull = 0;
assign RxFifoEmpty = 0;
assign RxFifoLevel = 5;

// Output Assign
assign BCLK_OE  = ClkMS;
assign LRCLK_OE = ClkMS;

endmodule
