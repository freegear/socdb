// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : CT500FPGA.v
// File Revision       : 1.0
// ----------------------------------------------------------------------------
// Purpose            : CT500 Top module for FPGA implementaion
// --========================================================================--

`timescale 1ns/1ps
module CT500FPGA (
		// System Reset & CLK
		nRESET,
		CLK,
		CLK27M,
	
		// BOT Config Pin
		BOOTNAND,	// 0 : NOR(ROM) Boot, 1 : NAND Boot
		BOOTCSSWAP,	// 0 : WaveROM(CS0), RomEmul(CS1), 1 : RomEmul(CS0), WaveROM(CS1)

		// Boot ROM
		ROM_ADDR,
		ROM_DATA,
		ROM_nCS,
		ROM_nOE,

		// DDR
		DDR_CLK,
		DDR_nCLK,
		DDR_CKE,
		DDR_CSB,
		DDR_RASB,
		DDR_CASB,
		DDR_WEB,
		DDR_BADDR,
		DDR_ADDR,
		DDR_DQ,
		DDR_DQM,
		DDR_DQS,

		// UART
		UART_TXD,
		UART_RXD,

		// I2C
		I2C_SDA,
		I2C_SCL,

		// MMC
		MMC_CLKOUT,
		MMC_CMD,
		MMC_DAT,

		// Video/LCD : clock & data are shared
		VID_CLK,
		DAC_Blank,
		DAC_Sync,
		VID_VSync,
		VID_HSync,
		VID_DataEn,
		VID_Data,

		// Video Input Interface
		VIF_CLK,
		VIF_DATA,
		VIF_nRESET,

		// NAND Flash
		NF_IO,
		NF_CLE,
		NF_ALE,
//		NF_nCE1,
		NF_nCE0,
		NF_nRE,
		NF_nWE,
//		NF_RnB1,
		NF_RnB0,

		// ARM ICE
		ARMICE_nSRST,
		ARMICE_nTRST,
		ARMICE_TCK,
		ARMICE_RTCK,
		ARMICE_TMS,
		ARMICE_TDI,
		ARMICE_TDO,

		// GPIO
		GPIO0,
		GPIO1,

		// SEIP
		SEIP_ADMCK,
		SEIP_MLRCK,
		SEIP_MSCK,
		SEIP_SDI1,
		SEIP_SDI2,
		SEIP_LRCKO,
		SEIP_SCKO,
		SEIP_SD1O,
		SEIP_SD2O,

		WAVE_ADDR,
		WAVE_DATA,
		WAVE_nCE,
		WAVE_nWE,
		WAVE_nOE,

		// 7 Segment LED
		SevenSegmentCommon,
		SevenSegmentControl,

		// SPI
		SPI_SDO,
		SPI_SDI,
		SPI_SCK,

		// USB PHY Interface(UTMI)
		USB_xcvr_clk,
		USB_data, 
		USB_opmode, 
		USB_txvalid, 
		USB_reset, 
		USB_termselect, 
		USB_xcvrsel,
		USB_linestate, 
		USB_txready, 
		USB_rxvalid, 
		USB_rxactive, 
		USB_rxerror, 
		USB_chrgvbus,
		USB_dischrgvbus,
		USB_suspendn,
		USB_id_dig,
		USB_idpullup,
		USB_hostdisconnect,
		USB_dmpulldown,
		USB_dppulldown,
		USB_sessend,
		USB_sessvld,
		USB_vbusvld,          
		USB_drvvbus,

		// I2S Controller
		I2S_MCLK,
		I2S_BCLK,
		I2S_LRCLK,
		I2S_SDOUT,
		I2S_SDIN,

		// Clock Test Out
		CLK200M_Out,
		CLK100M_Out,
		CLK50M_Out

);

parameter CLK_PERIOD = 5;	// 200 MHz for DDR
parameter CLK_HPERIOD = CLK_PERIOD/2;
parameter SDLY   = 2;		// System Delay

input         nRESET;
input         CLK;
input         CLK27M;

input         BOOTNAND;	// 0 : NOR(ROM) Boot, 1 : NAND Boot
input         BOOTCSSWAP;

output [20:0] ROM_ADDR;
input  [ 7:0] ROM_DATA;
output        ROM_nCS;
output        ROM_nOE;

output        DDR_CLK  ;
output        DDR_nCLK ;
output        DDR_CKE  ; // clock enable
output        DDR_CSB  ; // chip select
output        DDR_RASB ; // row address strobe
output        DDR_CASB ; // column address strobe
output        DDR_WEB  ; // write enable
output [1:0]  DDR_BADDR; // bank address
output [12:0] DDR_ADDR ; // address
inout  [15:0] DDR_DQ; // data output
output [1:0]  DDR_DQM;
inout  [1:0]  DDR_DQS;

// UART Only 2 Channel support on FPGA
// another 1 channel routed to FPGA0 for MIDI
output [2:0]  UART_TXD;
input  [2:0]  UART_RXD;

inout         MMC_CLKOUT;
inout         MMC_CMD;
inout  [7:0]  MMC_DAT;

output        VID_CLK;
output        DAC_Blank;
output        DAC_Sync;
output        VID_VSync;
output        VID_HSync;
output        VID_DataEn;
output [29:0] VID_Data;

inout         I2C_SDA;
inout         I2C_SCL;

input         VIF_CLK;
input  [7:0]  VIF_DATA;
output        VIF_nRESET;

inout  [7:0]  NF_IO;
output        NF_CLE;
output        NF_ALE;
output        NF_nCE0;
//output        NF_nCE1;
wire          NF_nCE1;
output        NF_nRE;
output        NF_nWE;
input         NF_RnB0;
//input         NF_RnB1;
wire          NF_RnB1;
assign        NF_RnB1 = 1'b1;

// External JTAG signal
inout         ARMICE_nSRST;
input         ARMICE_nTRST;
input         ARMICE_TCK;
output        ARMICE_RTCK;
input         ARMICE_TMS;
input         ARMICE_TDI;
output        ARMICE_TDO;

inout  [31:20] GPIO0;
inout  [ 7:0] GPIO1;

// SEIP
output        SEIP_ADMCK;
output        SEIP_MLRCK;
output        SEIP_MSCK;
input         SEIP_SDI1;
input         SEIP_SDI2;
output        SEIP_LRCKO;
output        SEIP_SCKO;
output        SEIP_SD1O;
output        SEIP_SD2O;

output [26:0] WAVE_ADDR;
inout  [ 7:0] WAVE_DATA;
output        WAVE_nCE;
output        WAVE_nWE;
output        WAVE_nOE;

output [ 3:0] SevenSegmentCommon;
output [ 7:0] SevenSegmentControl;

output        SPI_SDO;
input         SPI_SDI;
output        SPI_SCK;

// USB3500 PHY interface
input         USB_xcvr_clk;
inout  [7:0]  USB_data; //1
output [1:0]  USB_opmode; //1
output        USB_txvalid; //1
//output  [VUSB_HS_NUM_PORT-1:0]  USB_txvalidh      ;
output        USB_reset; //1
output        USB_termselect; //1
output [1:0]  USB_xcvrsel; //2
   
input [1:0]   USB_linestate; //1
input         USB_txready; //1
input         USB_rxvalid; //1
//input [VUSB_HS_NUM_PORT-1:0]    USB_rxvalidh           ;
input         USB_rxactive; //1
input         USB_rxerror; //1
   
output        USB_chrgvbus;
output        USB_dischrgvbus;
output        USB_suspendn;
input         USB_id_dig; // USB type A or B
output        USB_idpullup;
//input                        clkout; //USB_xcvr_clk∑Œ ¥Î√º
input         USB_hostdisconnect; // no used
output        USB_dmpulldown;
output        USB_dppulldown;
input         USB_sessend; // no used
input         USB_sessvld;
input         USB_vbusvld; // no used
output        USB_drvvbus;

output        I2S_MCLK;
inout         I2S_BCLK;
inout         I2S_LRCLK;
output        I2S_SDOUT;
input         I2S_SDIN;

output        CLK200M_Out;
output        CLK100M_Out;
output        CLK50M_Out;

// Reset Control
wire  nRESET_nSRST;
wire  nSYSRESET;
assign nRESET_nSRST = nRESET & ARMICE_nSRST;
assign ARMICE_nSRST = (nRESET == 0) ? 1'b0 : 1'bz;

reg [11:0] RESET_CNT;
always @(negedge nRESET_nSRST or posedge CLK)
begin
	if(!nRESET_nSRST)
		RESET_CNT <= 0;
	else if(RESET_CNT[11] == 0)
		RESET_CNT <= RESET_CNT + 1;
end

wire NF_DMADone;
reg ARMnRESET;
always @(negedge nRESET_nSRST or posedge CLK)
begin
	if(!nRESET_nSRST)
		ARMnRESET <= 0;
	else
	begin
		if(BOOTNAND)
		begin
			if(NF_DMADone == 1)
				ARMnRESET <= 1'b1;
		end
		else
			ARMnRESET <= RESET_CNT[11];
	end
end

assign nSYSRESET = RESET_CNT[11];

wire [ 3:0]  SMC_nBE  ;
wire [ 3:0]  SMC_nWBE ;
wire [26:0]  SMC_ADDR;
wire [ 8:0]  SMC_nCS;
reg  [ 7:0]  SMC_RDATA;
wire [ 7:0]  SMC_WDATA;
wire         SMC_BIDEN;

wire [12:0]  DDR_ADDR;
wire [1:0]   DDR_BADDR;
wire         DDR_CSB;
wire         DDR_RASB;
wire         DDR_CASB;
wire         DDR_WEB;
wire [1:0]   DDR_DQM;
wire		 DDR_CKE;

wire         #0.5 DDR_DQE;
wire [15:0]  DDR_DQI;
wire [15:0]  DDR_DQO;
wire [1:0]   DDR_DQSO;
wire [1:0]   DDR_DQSI;

wire [3:0]   UART_TXD_4CH;
wire [3:0]   UART_RXD_4CH;

wire          VID_CLK;
wire          LCD_HSync;
wire          LCD_VSync;
wire          LCD_DataEn;
wire   [23:0] LCD_Data;

wire          DAC0_EN;
wire          DAC1_EN;
wire          DAC2_EN;
wire   [9:0]  DAC0_DATA;
wire   [9:0]  DAC1_DATA;
wire   [9:0]  DAC2_DATA;

wire        BT601_nHSYNC;
wire        BT601_FIELD;
wire        BT601_nBLANK;
wire [ 7:0] BT601_Y;
wire [ 7:0] BT601_UV;
wire        BT601_Enable;

wire        MMC_FBCLK;
wire [7:0]  MMC_DATOUT;
wire        MMC_CMDOUT;

wire        I2C_SCLi;
wire        I2C_SDAi;
wire        I2C_SCLo;
wire        I2C_SDAo;
wire        I2C_nSCLEn;
wire        I2C_nSDAEn;

wire [31:0] GPIO0_OE;
wire [31:0] GPIO0_OUT;
wire [31:0] GPIO1_OE;
wire [31:0] GPIO1_OUT;

wire [ 1:0] I2SInputMux;
wire        WaveROMOwner;
wire [26:0] WAVE_ADDR_SEIP;
wire [ 7:0] WAVE_DOUT_SEIP;
wire [ 7:0] WAVE_DIN_SEIP;
wire        WAVE_nDEN_SEIP;
wire        WAVE_nCE_SEIP;
wire        WAVE_nWE_SEIP;
wire        WAVE_nOE_SEIP;

// SPI
wire I2S_MCLK_O;
wire I2S_MCLK_OE;
wire I2S_BCLK_O;
wire I2S_BCLK_I;
wire I2S_BCLK_OE;
wire I2S_LRCLK_O;
wire I2S_LRCLK_I;
wire I2S_LRCLK_OE;

wire I2S_SDIN_Muxed;

wire [15:0] NF_DI;
wire [15:0] NF_DO;
wire        NF_DOE;

// SPI
wire        SPInSSOut;       // Serial Frame Output pin
wire        SPIClkOut;       // Serial Clock Output pin
wire        SPITxd;          // SPI Serial Transmit output
wire        SPInOE;          // Output Enable for SPITxd
wire        SPInCTLOE;       // Output Enable for SPIClkOut and SPInSSOut
wire        SPI_nSS;

wire [7:0]  USB_datain_l;
wire        USB_dataoe;
wire [7:0]  USB_dataout_l; //1

wire        CLK200M;
wire        CLK100M;
wire        CLK50M;

// Clock Generator for FPGA
mypll2x PLL(
	.CLKIN_IN(CLK),
	.CLKDV_OUT(CLK50M),
	.CLKIN_IBUFG_OUT(),
	.CLK0_OUT(CLK100M),
	.CLK2X_OUT(CLK200M),
	.LOCKED_OUT()
);

//wire [31:24] GPIO1;
CT500Core Core(
	.nRESET(nSYSRESET),
	.ARMnRESET(ARMnRESET),
	.CLK200M(CLK200M),
	.CLK100M(CLK100M),
	.CLK50M(CLK50M),
	.CLK27M(CLK27M),

	.SMC_ADDR(SMC_ADDR),
	.SMC_RDATA(SMC_RDATA),
	.SMC_WDATA(SMC_WDATA),
	.SMC_nCS(SMC_nCS),
	.SMC_nOE(SMC_nOE),
	.SMC_nWE(SMC_nWE),
	.SMC_nBE(SMC_nBE),
	.SMC_nWBE(SMC_nWBE),
	.SMC_BIDEN(SMC_BIDEN),

	.DDR_CLK(DDR_CLK),
	.DDR_nCLK(DDR_nCLK),
	.DDR_CKE(DDR_CKE),
	.DDR_CSB(DDR_CSB),
	.DDR_RASB(DDR_RASB),
	.DDR_CASB(DDR_CASB),
	.DDR_WEB(DDR_WEB),
	.DDR_BADDR(DDR_BADDR),
	.DDR_ADDR(DDR_ADDR),
	.DDR_DQE(DDR_DQE),
	.DDR_DQI(DDR_DQI),
	.DDR_DQO(DDR_DQO),
	.DDR_DQM(DDR_DQM),
	.DDR_DQSE(DDR_DQSE),
	.DDR_DQSO(DDR_DQSO),
	.DDR_DQSI(DDR_DQSI),
	.DDR_nDQSI(~DDR_DQSI),

	.UART_TXD(UART_TXD_4CH),
	.UART_RXD(UART_RXD_4CH),

	.MMC_FBCLK(MMC_FBCLK),
	.MMC_CMDIN(MMC_CMD),
	.MMC_DATIN(MMC_DAT),
	.MMC_CLKOUT(MMC_CLKOUT),
	.MMC_CMDOUT(MMC_CMDOUT),
	.MMC_DATOUT(MMC_DATOUT),
	.MMC_nCMDEN(MMC_nCMDEN),
	.MMC_nDATEN(MMC_nDATEN),

	.I2C_SCLi(I2C_SCLi),
	.I2C_SDAi(I2C_SDAi),
	.I2C_SCLo(I2C_SCLo),
	.I2C_SDAo(I2C_SDAo),
	.I2C_nSCLEn(I2C_nSCLEn),
	.I2C_nSDAEn(I2C_nSDAEn),

	.LCD_Clk(VID_CLK),
	.LCD_HSync(LCD_HSync),
	.LCD_VSync(LCD_VSync),
	.LCD_DataEn(LCD_DataEn),
	.LCD_Data(LCD_Data),

	.DAC0_EN(DAC0_EN),
	.DAC1_EN(DAC1_EN),
	.DAC2_EN(DAC2_EN),
	.DAC0_DATA(DAC0_DATA),
	.DAC1_DATA(DAC1_DATA),
	.DAC2_DATA(DAC2_DATA),

	.BT601_nHSYNC(BT601_nHSYNC),
	.BT601_FIELD(BT601_FIELD),
	.BT601_nBLANK(BT601_nBLANK),
	.BT601_Y(BT601_Y),
	.BT601_UV(BT601_UV),
	.BT601_Enable(BT601_Enable),

	.VIF_CLK(VIF_CLK),
	.VIF_DATA(VIF_DATA),

	.I2S_MCLK(I2S_MCLK_O),
	.I2S_MCLK_OE(I2S_MCLK_OE),
	.I2S_BCLK_O(I2S_BCLK_O),
	.I2S_BCLK_I(I2S_BCLK_I),
	.I2S_BCLK_OE(I2S_BCLK_OE),
	.I2S_LRCLK_O(I2S_LRCLK_O),
	.I2S_LRCLK_I(I2S_LRCLK_I),
	.I2S_LRCLK_OE(I2S_LRCLK_OE),
	.I2S_SDIN(I2S_SDIN_Muxed),
	.I2S_SDOUT(I2S_SDOUT),

	.NF_Boot(BOOTNAND),
	.NF_IOWidth(1'b0),		// 8 bit IO
	.NF_Width(1'b0),		// 8 bit IO
	.NF_BootCfg(2'b11),		// What the hell is it?
	.NF_OutDtmn(1'b1),		// What the hell is it?
	.NF_DMADone(NF_DMADone),	// DMA Finishied

	// NAND connection
	.NF_DI(NF_DI),
	.NF_DO(NF_DO),
	.NF_DOE(NF_DOE),
	.NF_CLE(NF_CLE),
	.NF_ALE(NF_ALE),
	.NF_nCE1(NF_nCE1),
	.NF_nCE0(NF_nCE0),
	.NF_nRE(NF_nRE),
	.NF_nWE(NF_nWE),
	.NF_RnB1(NF_RnB1),
	.NF_RnB0(NF_RnB0),

	.GPIO0_IN({GPIO0[31:20], 20'h00000}),
	.GPIO0_OE(GPIO0_OE[31:0]),
	.GPIO0_OUT(GPIO0_OUT[31:0]),

	.GPIO1_IN({24'h000000, GPIO1[7:0]}),
	.GPIO1_OE(GPIO1_OE[31:0]),
	.GPIO1_OUT(GPIO1_OUT[31:0]),

	// SEIP
	.I2SInputMux(I2SInputMux),
	.WaveROMOwner(WaveROMOwner),

	.SEIP_ADMCK(SEIP_ADMCK),
	.SEIP_MLRCK(SEIP_MLRCK),
	.SEIP_MSCK(SEIP_MSCK),
	.SEIP_SDI1(SEIP_SDI1),
	.SEIP_SDI2(SEIP_SDI2),
	.SEIP_LRCKO(SEIP_LRCKO),
	.SEIP_SCKO(SEIP_SCKO),
	.SEIP_SD1O(SEIP_SD1O),
	.SEIP_SD2O(SEIP_SD2O),

	.WAVE_ADDR_SEIP(WAVE_ADDR_SEIP),
	.WAVE_DOUT_SEIP(WAVE_DOUT_SEIP),
	.WAVE_DIN_SEIP(WAVE_DIN_SEIP),
	.WAVE_nDEN_SEIP(WAVE_nDEN_SEIP),
	.WAVE_nCE_SEIP(WAVE_nCE_SEIP),
	.WAVE_nWE_SEIP(WAVE_nWE_SEIP),
	.WAVE_nOE_SEIP(WAVE_nOE_SEIP),

	.SPIRxd(SPI_SDI),
	.SPInSSIn(SPI_nSS),
	.SPIClkIn(SPI_SCK),
	.SPInSSOut(SPInSSOut),
	.SPIClkOut(SPIClkOut),
	.SPITxd(SPITxd),
	.SPInOE(SPInOE),		// Output Enable for SPITxd
	.SPInCTLOE(SPInCTLOE),		// Ouptut Enable for SPIClkOut/SPInSSOut

	// USB PHY Interface(UTMI)
	.USB_xcvr_clk(USB_xcvr_clk),
	.USB_datain_l(USB_datain_l),
	.USB_dataoe(USB_dataoe),
	.USB_opmode(USB_opmode),
	.USB_txvalid(USB_txvalid),
	.USB_reset(USB_reset),
	.USB_termselect(USB_termselect),
	.USB_xcvrsel(USB_xcvrsel),
	.USB_linestate(USB_linestate),
	.USB_dataout_l(USB_dataout_l),
	.USB_txready(USB_txready),
	.USB_rxvalid(USB_rxvalid),
	.USB_rxactive(USB_rxactive),
	.USB_rxerror(USB_rxerror),
	.USB_chrgvbus(USB_chrgvbus),
	.USB_dischrgvbus(USB_dischrgvbus),
	.USB_suspendn(USB_suspendn),
	.USB_id_dig(USB_id_dig),
	.USB_idpullup(USB_idpullup),
	.USB_hostdisconnect(USB_hostdisconnect),
	.USB_dmpulldown(USB_dmpulldown),
	.USB_dppulldown(USB_dppulldown),
	.USB_sessend(USB_sessend),
	.USB_sessvld(USB_sessvld),
	.USB_vbusvld(USB_vbusvld),

	.ARMICE_nTRST(ARMICE_nTRST),
	.ARMICE_TCK(ARMICE_TCK),
	.ARMICE_RTCK(ARMICE_RTCK),
	.ARMICE_TMS(ARMICE_TMS),
	.ARMICE_TDI(ARMICE_TDI),
	.ARMICE_TDO(ARMICE_TDO)
);

// DDR
tri  [15:0] DDR_DQ;
tri  [1:0]  DDR_DQS;
wire        #0.5 DDR_DQSE;

assign #SDLY DDR_DQ  = DDR_DQE ? DDR_DQO : {16{1'bz}};
assign #CLK_HPERIOD DDR_DQI = DDR_DQ;

assign #SDLY DDR_DQS  = DDR_DQSE ? DDR_DQSO : {2{1'bz}};

`ifdef SIMUL_ONLY		// Do not define this
wire [1:0] DDR_DQS_Delay;
assign DDR_DQS_Delay = DDR_DQS;
assign #CLK_HPERIOD DDR_DQSI = DDR_DQS_Delay;	// Input Pad Delay
`else
wire [1:0] DDR_DQSI_0; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_1; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_2; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_3; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_4; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_5; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_6; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_7; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_8; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_9; // synthesis syn_keep=1

IDELAY #(.IOBDELAY_TYPE("DEFAULT")) delay0 (
		.O(DDR_DQSI_0[0]),
		.C(),
		.CE(),
		.I(DDR_DQS[0]),
		.INC(),
		.RST()
	);
IDELAY #(.IOBDELAY_TYPE("DEFAULT")) delay1 (
		.O(DDR_DQSI_0[1]),
		.C(),
		.CE(),
		.I(DDR_DQS[1]),
		.INC(),
		.RST()
	);
assign DDR_DQSI_1 = ~DDR_DQSI_0;
assign DDR_DQSI_2 = ~DDR_DQSI_1;
assign DDR_DQSI_3 = ~DDR_DQSI_2;
assign DDR_DQSI_4 = ~DDR_DQSI_3;
assign DDR_DQSI_5 = ~DDR_DQSI_4;
assign DDR_DQSI_6 = ~DDR_DQSI_5;
assign DDR_DQSI_7 = ~DDR_DQSI_6;
assign DDR_DQSI_8 = ~DDR_DQSI_7;
assign DDR_DQSI_9 = ~DDR_DQSI_8;
assign #CLK_HPERIOD DDR_DQSI   = ~DDR_DQSI_9;
`endif

assign UART_TXD = UART_TXD_4CH[2:0];
assign UART_RXD_4CH = { 1'b0, UART_RXD[2:0] };
// MMC Controller
assign MMC_CMD = (!MMC_nCMDEN) ? MMC_CMDOUT : 1'bz;
assign MMC_DAT = (!MMC_nDATEN) ? MMC_DATOUT : 8'bz;

wire   MMC_FBCLK1/* synthesis syn_keep=1 */;
assign MMC_FBCLK1 = ~MMC_CLKOUT;
assign MMC_FBCLK  = ~MMC_FBCLK1;	// should be delay here

// LCD & Video DAC
assign DAC_Sync = 1'b0;		// DAC Sync should be tied to 0
assign DAC_Blank = 1'b1;	// DAC Blank should be tied to 1
assign VID_Data[9:0] = (DAC0_EN == 0) ? {2'b00, LCD_Data[23:16]}: DAC0_DATA;		// RED DAC
assign VID_Data[19:10] = (BT601_Enable == 0) ? {2'b00, LCD_Data[15:8]}: {2'b00, BT601_Y};	// GREEN
assign VID_Data[29:20] = (BT601_Enable == 0) ? {2'b00, LCD_Data[7:0]}: {2'b00, BT601_UV};	// BLUE
assign VID_VSync = (BT601_Enable == 0) ? LCD_VSync : BT601_FIELD;
assign VID_HSync = (BT601_Enable == 0) ? LCD_HSync : BT601_nHSYNC;
assign VID_DataEn = (BT601_Enable == 0) ? LCD_DataEn : BT601_nBLANK;

// I2C 
tri    I2C_SDA;
tri    I2C_SCL;
assign I2C_SDA  = (I2C_nSDAEn == 0) ? I2C_SDAo : 1'bz;
assign I2C_SDAi = I2C_SDA;
assign I2C_SCL  = (I2C_nSCLEn == 0) ? I2C_SCLo : 1'bz;
assign I2C_SCLi = I2C_SCL;

// BOOT ROM
assign ROM_nCS = ((BOOTCSSWAP == 1) ? SMC_nCS[0] : SMC_nCS[1]);
assign ROM_nOE = SMC_nOE;
assign ROM_ADDR = SMC_ADDR[20:0];

// WaveROM
assign WAVE_ADDR = (WaveROMOwner == 1) ? WAVE_ADDR_SEIP : SMC_ADDR[26:0];
assign WAVE_DATA = (WaveROMOwner == 1) ? ((WAVE_nDEN_SEIP == 0) ? WAVE_DOUT_SEIP : 8'hzz) : ((SMC_BIDEN == 1) ? SMC_WDATA[7:0] : 8'hzz);
assign WAVE_nCE  = (WaveROMOwner == 1) ? WAVE_nCE_SEIP : ((BOOTCSSWAP == 1) ? SMC_nCS[1] : SMC_nCS[0]);
assign WAVE_nWE  = (WaveROMOwner == 1) ? WAVE_nWE_SEIP : SMC_nWBE[0];
assign WAVE_nOE  = (WaveROMOwner == 1) ? WAVE_nOE_SEIP : SMC_nOE;
assign WAVE_DIN_SEIP = WAVE_DATA;

always @(SMC_nCS or ROM_DATA or WAVE_DATA or BOOTCSSWAP)
begin
	case(SMC_nCS)
	9'b111111110:	SMC_RDATA = (BOOTCSSWAP == 1) ? ROM_DATA : WAVE_DATA;
	9'b111111101:	SMC_RDATA = (BOOTCSSWAP == 0) ? ROM_DATA : WAVE_DATA;
	9'b111111011:	SMC_RDATA = 8'h02;
	9'b111110111:	SMC_RDATA = 8'h03;
	9'b111101111:	SMC_RDATA = 8'h04;
	9'b111011111:	SMC_RDATA = 8'h05;
	9'b110111111:	SMC_RDATA = 8'h06;
	9'b101111111:	SMC_RDATA = 8'h07;
	9'b011101111:	SMC_RDATA = 8'h08;
	default:	SMC_RDATA = 8'hxx;
	endcase
end

// NAND Flash
tri [7:0] NF_IO;
assign NF_IO = (NF_DOE == 0) ? NF_DO[7:0] : 8'bzzzzzzzz;
assign NF_DI = {8'h00, NF_IO};

// Video Decoder Reset
//assign VIF_nRESET = nSYSRESET;
assign VIF_nRESET = GPIO1_OUT[31];

// Seven Segment LED
SevenSegment SevenSegment (
	.Clock(CLK50M),
	.nReset(nSYSRESET),

	.DataIn(GPIO0_OUT[15:0]),
	.DotIn(GPIO0_OUT[19:16]),
	.ControlOut(SevenSegmentControl),
	.CommonOut(SevenSegmentCommon)
);

// GPIO
assign GPIO0[20] = (GPIO0_OE[20] == 1) ? GPIO0_OUT[20] : 1'bz;
assign GPIO0[21] = (GPIO0_OE[21] == 1) ? GPIO0_OUT[21] : 1'bz;
assign GPIO0[22] = (GPIO0_OE[22] == 1) ? GPIO0_OUT[22] : 1'bz;
assign GPIO0[23] = (GPIO0_OE[23] == 1) ? GPIO0_OUT[23] : 1'bz;
assign GPIO0[24] = (GPIO0_OE[24] == 1) ? GPIO0_OUT[24] : 1'bz;
assign GPIO0[25] = (GPIO0_OE[25] == 1) ? GPIO0_OUT[25] : 1'bz;
assign GPIO0[26] = (GPIO0_OE[26] == 1) ? GPIO0_OUT[26] : 1'bz;
assign GPIO0[27] = (GPIO0_OE[27] == 1) ? GPIO0_OUT[27] : 1'bz;
assign GPIO0[28] = (GPIO0_OE[28] == 1) ? GPIO0_OUT[28] : 1'bz;
assign GPIO0[29] = (GPIO0_OE[29] == 1) ? GPIO0_OUT[29] : 1'bz;
assign GPIO0[30] = (GPIO0_OE[30] == 1) ? GPIO0_OUT[30] : 1'bz;
assign GPIO0[31] = (GPIO0_OE[31] == 1) ? GPIO0_OUT[31] : 1'bz;

assign GPIO1[0] = (GPIO1_OE[0] == 1) ? GPIO1_OUT[0] : 1'bz;
assign GPIO1[1] = (GPIO1_OE[1] == 1) ? GPIO1_OUT[1] : 1'bz;
assign GPIO1[2] = (GPIO1_OE[2] == 1) ? GPIO1_OUT[2] : 1'bz;
assign GPIO1[3] = (GPIO1_OE[3] == 1) ? GPIO1_OUT[3] : 1'bz;
assign GPIO1[4] = (GPIO1_OE[4] == 1) ? GPIO1_OUT[4] : 1'bz;
assign GPIO1[5] = (GPIO1_OE[5] == 1) ? GPIO1_OUT[5] : 1'bz;
assign GPIO1[6] = (GPIO1_OE[6] == 1) ? GPIO1_OUT[6] : 1'bz;
assign GPIO1[7] = (GPIO1_OE[7] == 1) ? GPIO1_OUT[7] : 1'bz;
/*
assign GPIO1[8] = (GPIO1_OE[8] == 1) ? GPIO1_OUT[8] : 1'bz;
assign GPIO1[9] = (GPIO1_OE[9] == 1) ? GPIO1_OUT[9] : 1'bz;
assign GPIO1[10] = (GPIO1_OE[10] == 1) ? GPIO1_OUT[10] : 1'bz;
assign GPIO1[11] = (GPIO1_OE[11] == 1) ? GPIO1_OUT[11] : 1'bz;
assign GPIO1[12] = (GPIO1_OE[12] == 1) ? GPIO1_OUT[12] : 1'bz;
assign GPIO1[13] = (GPIO1_OE[13] == 1) ? GPIO1_OUT[13] : 1'bz;
assign GPIO1[14] = (GPIO1_OE[14] == 1) ? GPIO1_OUT[14] : 1'bz;
assign GPIO1[15] = (GPIO1_OE[15] == 1) ? GPIO1_OUT[15] : 1'bz;
assign GPIO1[16] = (GPIO1_OE[16] == 1) ? GPIO1_OUT[16] : 1'bz;
assign GPIO1[17] = (GPIO1_OE[17] == 1) ? GPIO1_OUT[17] : 1'bz;
assign GPIO1[18] = (GPIO1_OE[18] == 1) ? GPIO1_OUT[18] : 1'bz;
assign GPIO1[19] = (GPIO1_OE[19] == 1) ? GPIO1_OUT[19] : 1'bz;
assign GPIO1[20] = (GPIO1_OE[20] == 1) ? GPIO1_OUT[20] : 1'bz;
assign GPIO1[21] = (GPIO1_OE[21] == 1) ? GPIO1_OUT[21] : 1'bz;
assign GPIO1[22] = (GPIO1_OE[22] == 1) ? GPIO1_OUT[22] : 1'bz;
assign GPIO1[23] = (GPIO1_OE[23] == 1) ? GPIO1_OUT[23] : 1'bz;
assign GPIO1[24] = (GPIO1_OE[24] == 1) ? GPIO1_OUT[24] : 1'bz;
assign GPIO1[25] = (GPIO1_OE[25] == 1) ? GPIO1_OUT[25] : 1'bz;
assign GPIO1[26] = (GPIO1_OE[26] == 1) ? GPIO1_OUT[26] : 1'bz;
assign GPIO1[27] = (GPIO1_OE[27] == 1) ? GPIO1_OUT[27] : 1'bz;
assign GPIO1[28] = (GPIO1_OE[28] == 1) ? GPIO1_OUT[28] : 1'bz;
assign GPIO1[29] = (GPIO1_OE[29] == 1) ? GPIO1_OUT[29] : 1'bz;
assign GPIO1[30] = (GPIO1_OE[30] == 1) ? GPIO1_OUT[30] : 1'bz;
assign GPIO1[31] = (GPIO1_OE[31] == 1) ? GPIO1_OUT[31] : 1'bz;
assign GPIO1[29] = (GPIO1_OE[29] == 1) ? GPIO1_OUT[29] : 1'bz;
assign GPIO1[30] = (GPIO1_OE[30] == 1) ? GPIO1_OUT[30] : 1'bz;
*/

// I2S BUS Connection
tri    I2S_LRCLK;
tri    I2S_BCLK;
tri    I2S_MCLK;
assign I2S_MCLK  = (I2S_MCLK_OE) ? I2S_MCLK_O : 1'bz;
assign I2S_LRCLK = (I2S_LRCLK_OE) ? I2S_LRCLK_O : 1'bz;
assign I2S_LRCLK_I = (I2SInputMux == 2'b00) ? I2S_LRCLK : SEIP_MLRCK;
assign I2S_BCLK = (I2S_BCLK_OE) ? I2S_BCLK_O : 1'bz;
assign I2S_BCLK_I = (I2SInputMux == 2'b00) ? I2S_BCLK : SEIP_MSCK;
assign I2S_SDIN_Muxed = (I2SInputMux == 2'b00) ? I2S_SDIN : ((I2SInputMux[0] == 0) ? SEIP_SDI1 : SEIP_SDI2);

// SPI
assign SPI_SDO = (SPInOE == 0) ? SPITxd : 1'bz;
//assign SPI_nSS[0] = (SPInCTLOE[0] == 0) ? SPInSSOut[0] : 1'bz;
//assign SPI_nSS[1] = (SPInCTLOE[1] == 0) ? SPInSSOut[1] : 1'bz;
assign SPI_nSS = 1'b1;
assign SPI_SCK = (SPInCTLOE == 0) ? SPIClkOut : 1'bz;

// USB Data
assign USB_data = (USB_dataoe == 1) ? USB_datain_l : 8'hzz;
assign USB_dataout_l = USB_data;
assign USB_drvvbus = 1'b1;	// active low : diactive

reg [26:0] CLK200MCnt;
reg [26:0] CLK100MCnt;
reg [26:0] CLK50MCnt;

always @(posedge CLK200M or negedge nSYSRESET)
	if(!nSYSRESET)
		CLK200MCnt <= 0;
	else
		CLK200MCnt <= CLK200MCnt + 1;

always @(posedge CLK100M or negedge nSYSRESET)
	if(!nSYSRESET)
		CLK100MCnt <= 0;
	else
		CLK100MCnt <= CLK100MCnt + 1;

always @(posedge CLK50M or negedge nSYSRESET)
	if(!nSYSRESET)
		CLK50MCnt <= 0;
	else
		CLK50MCnt <= CLK50MCnt + 1;

assign CLK200M_Out = CLK200MCnt[26];
assign CLK100M_Out = CLK100MCnt[26];
assign CLK50M_Out  = CLK50MCnt[26];

endmodule
