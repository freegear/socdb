// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : SMC1000FPGATop.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : SMC1000 FPGA Top
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps



`define X8MODE_2CHIP_2CTRL
module SMC1000FPGATop
(
	// sd signal
	SD_CLK,
	SD_DATA,
	SD_CMD,

	// SD External Setting PIN
	SEL_MMC,

	// 8051 debug interface
	M_CLK,	
	RESETn,


	// External ROM Interface
	EXT_ADDR,
	EXT_DATA,
	EXT_CSb,
	EXT_OEb,	


	// 8051 UART signal
	UART_RXD,
	UART_TXD,

	//	NAND Flash Interface
/*`ifdef X8MODE_1CHIP
	NFDATA0,
`elsif X8MODE_2CHIP_1CTRL
	NFDATA0,
	NFDATA1,
`elsif X8MODE_2CHIP_2CTRL*/
	NFDATA0,
	NFDATA1,
/*`elsif X8MODE_4CHIP_1CTRL
	NFDATA0,
	NFDATA1,
	NFDATA2,
	NFDATA3,
`elsif X16MODE_1CHIP
	NFDATA0,
`elsif X16MODE_2CHIP
	NFDATA0,
	NFDATA1,
`endif
*/
	CLE0, 
	CLE1, 
	ALE0,
	ALE1,
	nNFCE0,
	nNFCE1,
	nNFCE2,
	nNFCE3,
	nNFCE4,
	nNFCE5,
	nNFCE6,
	nNFCE7,

	nNFRE0,
	nNFRE1,
	nNFWE0,
	nNFWE1,
	RnB0,
	RnB1,
	RnB2,
	RnB3,
	RnB4,
	RnB5,
	RnB6,
	RnB7,


	WP0,
	WP1,
	PRE0,
	PRE1,
	// 8051 Gpio FND
	GPIO,
	FNDControlOut,
	FNDCommonOut
);

input			SD_CLK;
inout	[7:0]	SD_DATA;
inout			SD_CMD;

input			SEL_MMC;

input			M_CLK;
input			RESETn;

output	[19:0]	EXT_ADDR;
input	[15:0]	EXT_DATA;
output			EXT_CSb;
output			EXT_OEb;


input			UART_RXD;
output			UART_TXD;


/*`ifdef X8MODE_1CHIP
inout	[7:0]	NFDATA0;
`elsif X8MODE_2CHIP_1CTRL
inout	[7:0]	NFDATA0;
inout	[7:0]	NFDATA1;
`elsif X8MODE_2CHIP_2CTRL*/
inout	[7:0]	NFDATA0;
inout	[7:0]	NFDATA1;
/*`elsif X8MODE_4CHIP_1CTRL
inout	[7:0]	NFDATA0;
inout	[7:0]	NFDATA1;
inout	[7:0]	NFDATA2;
inout	[7:0]	NFDATA3;
`elsif X8MODE_4CHIP_2CTRL
inout	[7:0]	NFDATA0;
inout	[7:0]	NFDATA1;
inout	[7:0]	NFDATA2;
inout	[7:0]	NFDATA3;
`elsif X16MODE_1CHIP
inout	[15:0]	NFDATA0;
`endif
*/
output			CLE0; 
output			CLE1; 
output			ALE0;
output			ALE1;
output			nNFCE0;
output			nNFCE1;
output			nNFCE2;
output			nNFCE3;
output			nNFCE4;
output			nNFCE5;
output			nNFCE6;
output			nNFCE7;


output			nNFRE0;
output			nNFRE1;

output			nNFWE0;
output			nNFWE1;
input			RnB0;
input			RnB1;
input			RnB2;
input			RnB3;
input			RnB4;
input			RnB5;
input			RnB6;
input			RnB7;

output			WP0;
output			WP1;

output			PRE0;
output			PRE1;

output	[15:0]	GPIO;

output	[7:0]	FNDControlOut;
output	[3:0]	FNDCommonOut;

wire	[15:0]	NFDataIn;
wire	[15:0]	NFDataOut;
wire	[1:0]	NFDataOutEn;
wire	[1:0]	CLE;
wire	[1:0]	ALE;
wire	[7:0]	nNFCE;
wire	[1:0]	nNFRE;
wire	[1:0]	nNFWE;
wire	[7:0]	RnB;

wire	[15:0]	NFDATA0out;
wire	[15:0]	NFDATA1out;
wire	[15:0]	NFDATA2out;
wire	[15:0]	NFDATA3out;

/*`ifdef X8MODE_1CHIP
wire	[7:0]	NFDATA0;
`elsif X8MODE_2CHIP_1CTRL
wire	[7:0]	NFDATA0;
wire	[7:0]	NFDATA1;
`elsif X8MODE_2CHIP_2CTRL*/
wire	[7:0]	NFDATA0;
wire	[7:0]	NFDATA1;
/*`elsif X8MODE_4CHIP_1CTRL
wire	[7:0]	NFDATA0;
wire	[7:0]	NFDATA1;
wire	[7:0]	NFDATA2;
wire	[7:0]	NFDATA3;
`elsif X8MODE_4CHIP_2CTRL
wire	[7:0]	NFDATA0;
wire	[7:0]	NFDATA1;
wire	[7:0]	NFDATA2;
wire	[7:0]	NFDATA3;
`elsif X16MODE_1CHIP
wire	[15:0]	NFDATA0;
`endif
*/
assign	WP0 = 1'b1;
assign  WP1 = 1'b1;
assign	PRE0 = 1'b1;
assign	PRE1 = 1'b1;
/*
`ifdef X8MODE_1CHIP
// CS = 2
assign 	NFDATA0out[7:0] = NFDataOut[7:0];
assign 	NFDataIn[7:0] = NFDATA0[7:0];
assign 	NFDATA0 = (NFDataOutEn[0]) ? NFDATA0out[7:0]: 8'bzzzzzzzz;
assign	CLE0 = CLE[0];
assign	CLE1 = 1'b0;
assign	ALE0 = ALE[0];
assign	ALE1 = 1'b0;
assign	nNFCE0 = nNFCE[0];
assign	nNFCE1 = nNFCE[1];
assign	nNFCE2 = 1'b1;
assign	nNFCE3 = 1'b1;
assign	nNFCE4 = 1'b1;
assign	nNFCE5 = 1'b1;
assign	nNFCE6 = 1'b1;
assign	nNFCE7 = 1'b1;
assign	nNFRE0 = nNFRE[0];
assign	nNFRE1 = 1'b1;
assign	nNFWE0 = nNFWE[0];
assign	nNFWE1 = 1'b1;
assign 	RnB[0] = RnB0;
assign 	RnB[1] = RnB1;
assign 	RnB[2] = 1'b1;
assign 	RnB[3] = 1'b1;
assign 	RnB[4] = 1'b1;
assign 	RnB[5] = 1'b1;
assign 	RnB[6] = 1'b1;
assign 	RnB[7] = 1'b1;

`elsif X8MODE_2CHIP_1CTRL
// CS = 4
assign NFDATA0out[7:0] = NFDataOut[7:0];
assign NFDATA1out[7:0] = NFDataOut[7:0];
assign NFDataIn[7:0] = NFDATA0[7:0] & NFDATA1[7:0] ;
assign NFDATA0 = (NFDataOutEn[0]) ? NFDATA0out[7:0]: 8'bzzzzzzzz;
assign NFDATA1 = (NFDataOutEn[0]) ? NFDATA0out[7:0]: 8'bzzzzzzzz;
assign	CLE0 = CLE[0];
assign	CLE1 = CLE[0];
assign	ALE0 = ALE[0];
assign	ALE1 = ALE[0];
assign	nNFCE0 = nNFCE[0];
assign	nNFCE1 = nNFCE[1];
assign	nNFCE2 = nNFCE[2];
assign	nNFCE3 = nNFCE[3];
assign	nNFCE4 = 1'b1;
assign	nNFCE5 = 1'b1;
assign	nNFCE6 = 1'b1;
assign	nNFCE7 = 1'b1;
assign	nNFRE0 = nNFRE[0];
assign	nNFRE1 = nNFRE[0];
assign	nNFWE0 = nNFWE[0];
assign	nNFWE1 = nNFWE[0];
assign 	RnB[0] = RnB0;
assign 	RnB[1] = RnB1;
assign 	RnB[2] = RnB2;
assign 	RnB[3] = RnB3;
assign 	RnB[4] = 1'b1;
assign 	RnB[5] = 1'b1;
assign 	RnB[6] = 1'b1;
assign 	RnB[7] = 1'b1;

`elsif X8MODE_2CHIP_2CTRL*/
assign NFDATA0out[7:0] = NFDataOut[7:0];
assign NFDATA1out[7:0] = NFDataOut[15:8];
assign NFDataIn[7:0] = NFDATA0[7:0];
assign NFDataIn[15:8] = NFDATA1[7:0];
assign NFDATA0 = (~NFDataOutEn[0]) ? NFDATA0out[7:0]: 8'bzzzzzzzz;
assign NFDATA1 = (~NFDataOutEn[1]) ? NFDATA1out[7:0]: 8'bzzzzzzzz;
assign	CLE0 = CLE[0];
assign	CLE1 = CLE[1];
assign	ALE0 = ALE[0];
assign	ALE1 = ALE[1];
assign	nNFCE0 = nNFCE[0];
assign	nNFCE1 = nNFCE[1];
assign	nNFCE2 = 1'b1;
assign	nNFCE3 = 1'b1;
assign	nNFCE4 = nNFCE[4];
assign	nNFCE5 = nNFCE[5];
assign	nNFCE6 = 1'b1;
assign	nNFCE7 = 1'b1;
assign	nNFRE0 = nNFRE[0];
assign	nNFRE1 = nNFRE[1];
assign	nNFWE0 = nNFWE[0];
assign	nNFWE1 = nNFWE[1];
assign 	RnB[0] = RnB0;
assign 	RnB[1] = RnB1;
assign 	RnB[2] = 1'b1;
assign 	RnB[3] = 1'b1;
assign 	RnB[4] = RnB4;
assign 	RnB[5] = RnB5;
assign 	RnB[6] = 1'b1;
assign 	RnB[7] = 1'b1;

/*
`elsif X8MODE_4CHIP_1CTRL
assign NFDATA0out[7:0] = NFDataOut[7:0];
assign NFDATA1out[7:0] = NFDataOut[7:0];
assign NFDATA2out[7:0] = NFDataOut[7:0];
assign NFDATA3out[7:0] = NFDataOut[7:0];
assign NFDataIn[7:0] = NFDATA0[7:0] & NFDATA1[7:0] & NFDATA2[7:0] & NFDATA3[7:0];

assign NFDATA0 = (NFDataOutEn[0]) ? NFDATA0out[7:0]: 8'bzzzzzzzz;
assign NFDATA1 = (NFDataOutEn[0]) ? NFDATA1out[7:0]: 8'bzzzzzzzz;
assign NFDATA2 = (NFDataOutEn[0]) ? NFDATA2out[7:0]: 8'bzzzzzzzz;
assign NFDATA3 = (NFDataOutEn[0]) ? NFDATA3out[7:0]: 8'bzzzzzzzz;

`elsif X8MODE_4CHIP_2CTRL
assign NFDATA0out = NFDataOut[7:0];
assign NFDATA1out = NFDataOut[7:0];
assign NFDATA2out = NFDataOut[15:8];
assign NFDATA3out = NFDataOut[15:8];
assign NFDataIn[7:0] = NFDATA0[7:0] & NFDATA1[7:0];
assign NFDataIn[15:8]= NFDATA2[7:0] & NFDATA3[7:0];

assign NFDATA0 = (NFDataOutEn[0]) ? NFDATA0out : 8'bzzzzzzzz;
assign NFDATA1 = (NFDataOutEn[0]) ? NFDATA0out : 8'bzzzzzzzz;
assign NFDATA2 = (NFDataOutEn[1]) ? NFDATA1out : 8'bzzzzzzzz;
assign NFDATA3 = (NFDataOutEn[1]) ? NFDATA1out : 8'bzzzzzzzz;

`elsif X16MODE_1CHIP
assign NFDATA0out = NFDataOut[15:0];
assign NFDataIn = NFDATA0;
assign NFDATA0 = (NFDataOutEn[0]) ? NFDATA0out : 16'bzzzzzzzzzzzzzzzz;

`elsif X16MODE_2CHIP
assign NFDATA0out = NFDataOut[15:0];
assign NFDATA1out = NFDataOut[15:0];
assign NFDataIn = NFDATA0[15:0] & NFDATA1[15:0];
assign NFDATA0 = (NFDataOutEn[0]) ? NFDATA0out : 16'bzzzzzzzzzzzzzzzz;
assign NFDATA1 = (NFDataOutEn[0]) ? NFDATA0out : 16'bzzzzzzzzzzzzzzzz;
`endif
*/
wire [15:0]	SevenData;
wire		SD_CMD_OE;
wire		SD_CMD;
wire [7:0]	SD_DATA;
wire [7:0]	SD_DATAo;

wire [19:0] EXT_ADDR;
assign EXT_ADDR[19:15] = 5'b00000;

wire	[7:0] xrom_dout;
wire	[15:0]	xrom_addr;
assign EXT_ADDR[14:0] = xrom_addr[15:1];

wire	[7:0]	SD_DATA_OE;

SMC1000Core	uSMC1000Core(
	.XTAL1		(M_CLK),
	.RESET		(~RESETn),
//	.PSEN		(),

	// External ROM Interface
	.xrom_addr	(xrom_addr),
	.xrom_ce_b	(EXT_CSb),
	.xrom_oe_b	(EXT_OEb),
	.xrom_dout	(xrom_dout),

	// Debug UART
	.RX_PIN		(UART_RXD),
	.TX_PIN		(UART_TXD),
	
	// 8051 GPIO 
	.P0_DIN		(),// 	Unused
	.P0_DOUT	(SevenData[7:0]),
	.P1_DIN		(),//	Unused
	.P1_DOUT	(SevenData[15:8]),
	.P2_DIN		(),//	Unused
	.P2_DOUT	(GPIO[7:0]),//	Unused
	.P3_DIN		(),//	Unused
	.P3_DOUT	(GPIO[15:8]),//	Unused

	// Nand Inferface
	.NFDataIn	(NFDataIn),
	.NFDataOut	(NFDataOut),  
	.NFDataOutEn(NFDataOutEn),
	.CLE		(CLE),
	.ALE		(ALE),
	.nNFCE		(nNFCE	),
	.nNFRE		(nNFRE	),
	.nNFWE		(nNFWE	),
	.RnB		(RnB	),

	// MMC IP  signal
	.sel_mmc	(SEL_MMC),
	.oe_card_detect(OE_CD),
	
	// MMC SD Signal
	.cmdin		(SD_CMD),
	.cmdout		(SD_CMDo),	
	.dtin		(SD_DATA),
	.dtout		(SD_DATAo),
	.oe_cmd		(SD_CMD_OE),
	.oe_dt		(SD_DATA_OE),
	.sdclk		(SD_CLK)
);

assign SD_CMD = (SD_CMD_OE)? SD_CMDo : 1'bz;
assign SD_DATA[0] = (SD_DATA_OE[0])? SD_DATAo[0]: 1'bz;
assign SD_DATA[1] = (SD_DATA_OE[1])? SD_DATAo[1]: 1'bz;
assign SD_DATA[2] = (SD_DATA_OE[2])? SD_DATAo[2]: 1'bz;
assign SD_DATA[3] = (SD_DATA_OE[3])? SD_DATAo[3]: 1'bz;
assign SD_DATA[4] = (SD_DATA_OE[4])? SD_DATAo[4]: 1'bz;
assign SD_DATA[5] = (SD_DATA_OE[5])? SD_DATAo[5]: 1'bz;
assign SD_DATA[6] = (SD_DATA_OE[6])? SD_DATAo[6]: 1'bz;
assign SD_DATA[7] = (SD_DATA_OE[7])? SD_DATAo[7]: 1'bz;

// DEBUG 7-Segment
SevenSegment SevenSegment(
		.Clock			(M_CLK),
		.nReset			(RESETn),
		.DataIn			(SevenData[15:0]),			// GPIO Mapping for DEBUG
		.ControlOut		(FNDControlOut),
		.CommonOut		(FNDCommonOut)
);

Romconv romconverter(
	.addr0(xrom_addr[0]),
	.datain(EXT_DATA), 
	.datao(xrom_dout)
);

endmodule




















