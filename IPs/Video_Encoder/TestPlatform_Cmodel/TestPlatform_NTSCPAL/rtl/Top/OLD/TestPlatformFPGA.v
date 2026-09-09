// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TestPlatformFPGA.v
// File Revision       : 1.0
// ----------------------------------------------------------------------------
// Purpose            : TestPlatform Top module for simulation
// --========================================================================--

`timescale 1ns/1ps
module TestPlatformFPGA (
		RESETn   ,
		Clock    ,
		Clock2   ,
	
		EXT_ADDR  ,
		EXT_DATA ,
		EXT_CSb   ,
		EXT_OEb   ,
		EXT_WEb   ,
//		EXT_BEb   ,
//		EXT_WBEb  ,

		SD_CLK,
		SD_nCLK,
		SD_CKE,
		SD_CSB,
		SD_RASB,
		SD_CASB,
		SD_WEB,
		SD_BADDR,
		SD_ADDR,
		SD_DQ,
		SD_DQM,
		SD_DQS,

		UART_TXD  ,
		UART_RXD  ,

		I2C_SDA,
		I2C_SCL,

		MMC_CLKOUT,
		MMC_CMD,
		MMC_DAT,

		LCDClk,
		LCDHSync,
		LCDVSync,
		LCDDataEn,
		LCDData,

        DAC_CLK,
        DAC_OUT,
        SYNC,
        BLANK,

		led_4094clk,
		led_4094d,
		led_4094oe,
		led_4094str
);

parameter PERIOD = 3.76;
parameter CKP1 = 1.88;	// PERIOD/2
parameter SDLY   = 2;

input          RESETn;
input          Clock;
input          Clock2;

output [19:0]  EXT_ADDR ;
inout  [15:0]  EXT_DATA ;
output         EXT_CSb  ;
output         EXT_OEb  ;
output         EXT_WEb  ;
wire   [ 3:0]  EXT_BEb  ;
wire   [ 3:0]  EXT_WBEb ;

output         SD_CLK  ;
output         SD_nCLK ;
output         SD_CKE  ; // clock enable
output         SD_CSB  ; // chip select
output         SD_RASB ; // row address strobe
output         SD_CASB ; // column address strobe
output         SD_WEB  ; // write enable
output [1:0]   SD_BADDR; // bank address
output [12:0]  SD_ADDR ; // address
inout  [15:0]  SD_DQ; // data output
output [1:0]   SD_DQM;
inout  [1:0]   SD_DQS;

output         UART_TXD;
input          UART_RXD;

inout          MMC_CLKOUT;
inout          MMC_CMD;
inout  [7:0]   MMC_DAT;

inout          I2C_SDA;
inout          I2C_SCL;

output         LCDClk;
output         LCDHSync;
output         LCDVSync;
output         LCDDataEn;
output [23:0]  LCDData;

output         DAC_CLK; 
assign         DAC_CLK = Clock2;

output [7:0]   DAC_OUT;
output         SYNC;
output         BLANK;

output         led_4094clk;
output         led_4094d;
output         led_4094oe;
output [3:0]   led_4094str;

wire [12:0]  SD_ADDR;
wire [1:0]   SD_BADDR;
wire         SD_CSB;
wire         SD_RASB;
wire         SD_CASB;
wire         SD_WEB;
wire [1:0]   SD_DQM;
wire		 SD_CKE;

wire         #0.5 SD_DQE;
wire [15:0] SD_DQI;
wire [15:0] SD_DQO;
tri  [15:0] SD_DQ;
tri  [1:0] SD_DQS;

assign #SDLY SD_DQ  = SD_DQE ? SD_DQO : {16{1'bz}};
assign #CKP1 SD_DQI = SD_DQ;

wire       #0.5 SD_DQSE;
wire [1:0] SD_DQSO;
wire [1:0] SD_DQSI;

wire [1:0] SD_DQSO_Delay;
wire [1:0] SD_DQS_Delay;
assign SD_DQSO_Delay = SD_DQSO;

/*
wire [1:0] SD_DQSI_0; // synthesis syn_keep=1
wire [1:0] SD_DQSI_1; // synthesis syn_keep=1
wire [1:0] SD_DQSI_2; // synthesis syn_keep=1
wire [1:0] SD_DQSI_3; // synthesis syn_keep=1

buf (SD_DQSI_0[0],SD_DQS[0]);
buf (SD_DQSI_0[1],SD_DQS[1]);
buf (SD_DQSI_1[0],SD_DQSI_0[0]);
buf (SD_DQSI_1[1],SD_DQSI_0[1]);
buf (SD_DQSI_2[0],SD_DQSI_1[0]);
buf (SD_DQSI_2[1],SD_DQSI_1[1]);
assign SD_DQSI_0 = ~SD_DQS;
assign SD_DQSI_1 = ~SD_DQSI_0;
assign SD_DQSI_2 = ~SD_DQSI_1;
assign SD_DQSI_3 = ~SD_DQSI_2;
*/

assign SD_DQS_Delay = SD_DQS;
assign #SDLY SD_DQS  = SD_DQSE ? SD_DQSO_Delay : {2{1'bz}};
assign #CKP1 SD_DQSI = SD_DQS_Delay;	// Input Pad Delay

wire [31:0] EXT_WDATA;
wire        EXT_BIDEN;

wire [7:0]   MMC_DATOUT;
wire         MMC_CMDOUT;
wire         MMC_CLKOUT_TEMP;

wire [1:0]  I2CSCLi;
wire [1:0]  I2CSDAi;
wire [1:0]  I2CSCLo;
wire [1:0]  I2CSDAo;

wire         LCDDataEn;
wire [15:0]  GpioOutEn;
wire [15:0]  GpioOut;
wire [15:0]  GpioInOut;

wire [25:0]  EXT_ADDR_Temp;
wire [3:0]   EXT_CSb_Temp;
assign EXT_CSb = EXT_CSb_Temp;
assign EXT_ADDR = EXT_ADDR_Temp[19:0];
tri  [15:0]  EXT_DATA;

wire   MMC_nCMDEN;
wire   MMC_nDATEN;

assign MMC_CMD = (!MMC_nCMDEN) ? MMC_CMDOUT : 1'bz;
assign MMC_DAT = (!MMC_nDATEN) ? MMC_DATOUT : 8'bz;
tri    MMC_CLKOUT;
assign MMC_CLKOUT = (1'b1) ? MMC_CLKOUT_TEMP : 1'bz;

wire	MMC_FBCLK1/* synthesis syn_keep=1 */;
wire	MMC_FBCLK2/* synthesis syn_keep=1 */;
wire	MMC_FBCLK3/* synthesis syn_keep=1 */;
wire	MMC_FBCLK4/* synthesis syn_keep=1 */;
wire	MMC_FBCLK5/* synthesis syn_keep=1 */;
wire	MMC_FBCLK6/* synthesis syn_keep=1 */;
wire	MMC_FBCLK7/* synthesis syn_keep=1 */;
wire	MMC_FBCLK8/* synthesis syn_keep=1 */;
wire	MMC_FBCLK9/* synthesis syn_keep=1 */;
wire	MMC_FBCLK10/* synthesis syn_keep=1 */;
wire	MMC_FBCLK11/* synthesis syn_keep=1 */;
wire	MMC_FBCLK12/* synthesis syn_keep=1 */;
wire	MMC_FBCLK13/* synthesis syn_keep=1 */;
wire	MMC_FBCLK14/* synthesis syn_keep=1 */;
wire	MMC_FBCLK15/* synthesis syn_keep=1 */;
wire	MMC_FBCLK16/* synthesis syn_keep=1 */;
wire	MMC_FBCLK17/* synthesis syn_keep=1 */;
wire	MMC_FBCLK18/* synthesis syn_keep=1 */;
wire	MMC_FBCLK19/* synthesis syn_keep=1 */;
wire	MMC_FBCLK20/* synthesis syn_keep=1 */;
wire	MMC_FBCLK21/* synthesis syn_keep=1 */;
wire	MMC_FBCLK22/* synthesis syn_keep=1 */;
wire	MMC_FBCLK23/* synthesis syn_keep=1 */;
wire	MMC_FBCLK24/* synthesis syn_keep=1 */;
wire	MMC_FBCLK25/* synthesis syn_keep=1 */;
wire	MMC_FBCLK/* synthesis syn_keep=1 */;
buf (MMC_FBCLK1,MMC_CLKOUT);
buf (MMC_FBCLK2,MMC_FBCLK1);
buf (MMC_FBCLK3,MMC_FBCLK2);
buf (MMC_FBCLK4,MMC_FBCLK3);
buf (MMC_FBCLK5,MMC_FBCLK4);
buf (MMC_FBCLK6,MMC_FBCLK5);
buf (MMC_FBCLK7,MMC_FBCLK6);
buf (MMC_FBCLK8,MMC_FBCLK7);
buf (MMC_FBCLK9,MMC_FBCLK8);
buf (MMC_FBCLK10,MMC_FBCLK9);
buf (MMC_FBCLK11,MMC_FBCLK10);
buf (MMC_FBCLK12,MMC_FBCLK11);
buf (MMC_FBCLK13,MMC_FBCLK12);
buf (MMC_FBCLK14,MMC_FBCLK13);
buf (MMC_FBCLK15,MMC_FBCLK14);
buf (MMC_FBCLK16,MMC_FBCLK15);
buf (MMC_FBCLK17,MMC_FBCLK16);
buf (MMC_FBCLK18,MMC_FBCLK17);
buf (MMC_FBCLK19,MMC_FBCLK18);
buf (MMC_FBCLK20,MMC_FBCLK19);
buf (MMC_FBCLK21,MMC_FBCLK20);
buf (MMC_FBCLK22,MMC_FBCLK21);
buf (MMC_FBCLK23,MMC_FBCLK22);
buf (MMC_FBCLK24,MMC_FBCLK23);
buf (MMC_FBCLK25,MMC_FBCLK24);
buf (MMC_FBCLK,MMC_FBCLK25);

TestPlatformCore Core(
	.RESETn(RESETn),
	.Clock(Clock),
    .Clock2(Clock2), // for video tester 27MHz

	.EXT_ADDR(EXT_ADDR_Temp),
	.EXT_RDATA({16'h0000, EXT_DATA}),
	.EXT_WDATA(EXT_WDATA),
	.EXT_CSb(EXT_CSb_Temp),
	.EXT_OEb(EXT_OEb),
	.EXT_WEb(EXT_WEb),
	.EXT_BEb(EXT_BEb),
	.EXT_WBEb(EXT_WBEb),
	.EXT_BIDEN(EXT_BIDEN),

	.SD_CLK(SD_CLK),
	.SD_nCLK(SD_nCLK),
	.SD_CKE(SD_CKE),
	.SD_CSB(SD_CSB),
	.SD_RASB(SD_RASB),
	.SD_CASB(SD_CASB),
	.SD_WEB(SD_WEB),
	.SD_BADDR(SD_BADDR),
	.SD_ADDR(SD_ADDR),
	.SD_DQE(SD_DQE),
	.SD_DQI(SD_DQI),
	.SD_DQO(SD_DQO),
	.SD_DQM(SD_DQM),
	.SD_DQSE(SD_DQSE),
	.SD_DQSO(SD_DQSO),
	.SD_DQSI(SD_DQSI),
	.nSD_DQSI(~SD_DQSI),

	.UART_TXD(UART_TXD),
	.UART_RXD(UART_RXD),

	.MMC_FBCLK(MMC_FBCLK),
	.MMC_CMDIN(MMC_CMD),
	.MMC_DATIN(MMC_DAT),
	.MMC_CLKOUT(MMC_CLKOUT_TEMP),
	.MMC_CMDOUT(MMC_CMDOUT),
	.MMC_DATOUT(MMC_DATOUT),
	.MMC_nCMDEN(MMC_nCMDEN),
	.MMC_nDATEN(MMC_nDATEN),

	.I2CSCLi(I2CSCLi),
	.I2CSDAi(I2CSDAi),
	.I2CSCLo(I2CSCLo),
	.I2CSDAo(I2CSDAo),

	.LCDClk(LCDClk),
	.LCDHSync(LCDHSync),
	.LCDVSync(LCDVSync),
	.LCDDataEn(LCDDataEn),
	.LCDData(LCDData),

	.GpioIn(GpioInOut),
	.GpioOutEn(GpioOutEn),
	.GpioOut(GpioOut),

    .DAC_OUT(DAC_OUT),
    .SYNC(SYNC),
    .BLANK(BLANK)
);



tri I2C_SDA;
tri I2C_SCL;
assign I2C_SDA    = (I2CSDAo[0] == 0) ? 1'b0 : 1'bz;
assign I2CSDAi[0] = I2C_SDA;
assign I2C_SCL    = (I2CSCLo[0] == 0) ? 1'b0 : 1'bz;
assign I2CSCLi[0] = I2C_SCL;

// I2C Secondchannel disable
assign I2CSDAi[1] = 1'b0;
assign I2CSCLi[1] = 1'b0;

/*
assign GpioInOut[0] = (GpioOutEn[0] == 1) ? GpioOut[0] : 1'bz;
assign GpioInOut[1] = (GpioOutEn[1] == 1) ? GpioOut[1] : 1'bz;
assign GpioInOut[2] = (GpioOutEn[2] == 1) ? GpioOut[2] : 1'bz;
assign GpioInOut[3] = (GpioOutEn[3] == 1) ? GpioOut[3] : 1'bz;
assign GpioInOut[4] = (GpioOutEn[4] == 1) ? GpioOut[4] : 1'bz;
assign GpioInOut[5] = (GpioOutEn[5] == 1) ? GpioOut[5] : 1'bz;
assign GpioInOut[6] = (GpioOutEn[6] == 1) ? GpioOut[6] : 1'bz;
assign GpioInOut[7] = (GpioOutEn[7] == 1) ? GpioOut[7] : 1'bz;
assign GpioInOut[8] = (GpioOutEn[8] == 1) ? GpioOut[8] : 1'bz;
assign GpioInOut[9] = (GpioOutEn[9] == 1) ? GpioOut[9] : 1'bz;
assign GpioInOut[10] = (GpioOutEn[10] == 1) ? GpioOut[10] : 1'bz;
assign GpioInOut[11] = (GpioOutEn[11] == 1) ? GpioOut[11] : 1'bz;
assign GpioInOut[12] = (GpioOutEn[12] == 1) ? GpioOut[12] : 1'bz;
assign GpioInOut[13] = (GpioOutEn[13] == 1) ? GpioOut[13] : 1'bz;
assign GpioInOut[14] = (GpioOutEn[14] == 1) ? GpioOut[14] : 1'bz;
assign GpioInOut[15] = (GpioOutEn[15] == 1) ? GpioOut[15] : 1'bz;
*/
assign GpioInOut = 16'h0000;

assign EXT_DATA = (EXT_BIDEN == 1) ? EXT_WDATA[15:0] : 16'hzzzz;

// Seven Segment LED
hc4094_7seg SevenSegmentCtrl(
	.clk(Clock),
	.rstb(RESETn),
	.seg_d(GpioOut),
	.led_4094d(led_4094d),
	.led_4094clk(led_4094clk),
	.led_4094oe(led_4094oe),
	.led_4094str(led_4094str)
);

endmodule
