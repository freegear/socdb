// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : tb.v
// File Revision       : 1.0
// ----------------------------------------------------------------------------
// Purpose            : Test Benc for CT500
// --========================================================================--

`timescale 1ns/1ps
//`include "CT500.vh"
module tb;

parameter CLK_PERIOD=5.0;	// 200 MHz for DDR
parameter CLK_HPERIOD=(CLK_PERIOD / 2);
parameter SDLY=2;

parameter CLK27M_PERIOD=37.04/2;		// 54MHz(27 Mhz)
parameter CLK27M_HPERIOD=(CLK27M_PERIOD/2);

reg   nRESET;
reg   Clock;

initial Clock = 0;
always #CLK_HPERIOD Clock = ~Clock;

reg   Clock27M;
initial Clock27M = 0;
always #CLK27M_HPERIOD Clock27M = ~Clock27M;

initial
begin
	nRESET = 1'b0;

	repeat(100) @(posedge Clock);
	#(SDLY) nRESET = 1'b1;
end

wire  [19:0]  ROM_ADDR ;
wire  [15:0]  ROM_DATA ;
wire          ROM_CSb  ;
wire  		  ROM_OEb  ;
wire  [ 3:0]  ROM_BEb  ;
wire  [ 3:0]  ROM_WBEb ;

wire          DDR_CLK;
wire          DDR_nCLK;
wire [12:0]   #SDLY DDR_ADDR;
wire [1:0]    #SDLY DDR_BADDR;
wire          #SDLY DDR_CSB;
wire          #SDLY DDR_RASB;
wire          #SDLY DDR_CASB;
wire          #SDLY DDR_WEB;
wire [1:0]    #SDLY DDR_DQM;
wire          #SDLY DDR_CKE;
wire [15:0]   DDR_DQ;
tri  [1:0]    DDR_DQS;

pullup(DDR_DQS[0]);
pullup(DDR_DQS[1]);

`ifdef INCLUDE_MMC
wire         MMC_CLKOUT;
tri          MMC_CMD;
tri  [7:0]   MMC_DAT;
pullup(MMC_DAT[0]);
pullup(MMC_DAT[1]);
pullup(MMC_DAT[2]);
pullup(MMC_DAT[3]);
pullup(MMC_DAT[4]);
pullup(MMC_DAT[5]);
pullup(MMC_DAT[6]);
pullup(MMC_DAT[7]);
`endif

wire I2S_BCLK;
wire I2S_LRCLK;
wire I2S_SDOUT;

ETRI_UWBFPGA #(.CLK_PERIOD(CLK_PERIOD), .SDLY(SDLY)) Top(
	.nRESET(nRESET),
	.CLK(Clock),
	.CLK27M(Clock27M),

	.ROM_ADDR(ROM_ADDR),
	.ROM_DATA(ROM_DATA),
	.ROM_CSb(ROM_CSb),
	.ROM_OEb(ROM_OEb),

	.ETH_RESET(),
	.ETH_CSb(),
	.ETH_OEb(),
	.ETH_WEb(),
	.ETH_ADDR(),
	.ETH_DQM(),
	.ETH_DATA(),

	.DDR_CLK(DDR_CLK),
	.DDR_nCLK(DDR_nCLK),
	.DDR_CKE(DDR_CKE),
	.DDR_CSB(DDR_CSB),
	.DDR_RASB(DDR_RASB),
	.DDR_CASB(DDR_CASB),
	.DDR_WEB(DDR_WEB),
	.DDR_BADDR(DDR_BADDR),
	.DDR_ADDR(DDR_ADDR),
	.DDR_DQM(DDR_DQM),
	.DDR_DQ(DDR_DQ),
	.DDR_DQS(DDR_DQS),

	.UART_TXD(),
	.UART_RXD(2'b00),

	.I2C_SDA(),
	.I2C_SCL(),

`ifdef INCLUDE_MMC
	.MMC_CLKOUT(MMC_CLKOUT),
	.MMC_CMD(MMC_CMD),
	.MMC_DAT(MMC_DAT),
`endif

	.LCD_Clk(),
	.LCD_HSync(),
	.LCD_VSync(),
	.LCD_Data(),
	.LCD_DataEn(),

	.led_4094clk(),
	.led_4094d(),
	.led_4094oe(),
	.led_4094str(),

	.I2S_MCLK(),
	.I2S_BCLK(I2S_BCLK),
	.I2S_LRCLK(I2S_LRCLK),
	.I2S_SDOUT(I2S_SDOUT),
	.I2S_SDIN(1'b0)
);

prom16bit prom
(
	.addr(ROM_ADDR[18:0]),
	.romdata(ROM_DATA[15:0]),
	.oeb(ROM_OEb),
	.csb(ROM_CSb)
);

ddr ddram16bit (
	.Dq		(DDR_DQ),
	.Addr	(DDR_ADDR),
	.Ba		(DDR_BADDR),
	.Clk	(DDR_CLK),
	.Clk_n	(DDR_nCLK),
	.Cke	(DDR_CKE),
	.Cs_n	(DDR_CSB),
	.Ras_n	(DDR_RASB),
	.Cas_n	(DDR_CASB),
	.We_n	(DDR_WEB),
	.Dqs	(DDR_DQS), 
	.Dm		(DDR_DQM)
);


I2S_DAC AudioDAC
(
		.MASTER(1'b0),		// Slave Mode
		.WORD_LEN(2'b01),	// 16 bit per sample mode
		.LJUST(1'b0),		// I2S Mode

		.MCLK(1'b1),		// no connection because of slave mode operation
		.BCLK(I2S_BCLK),
		.LRCLK(I2S_LRCLK),
		.SDIN(I2S_SDOUT)
);


always @(posedge Clock)
	if(tb.Top.GPIO_OUT[15:8] === 8'hde)
	begin
		$display("Simulation Ended with error code(%h)", tb.Top.GPIO_OUT[7:0]);
		$finish;
	end

endmodule
