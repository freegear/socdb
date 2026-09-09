// --=========================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ---------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : tb.v
// File Revision       : 1.0
// ---------------------------------------------------------------------------
// Purpose            : Test Benc for TestPlatform
// --=========================================================================

`timescale 1ns/1ps

`include "ARM926EJS.vh" 
`include "ARM_Platform.vh"


module tb;

   parameter PERIOD=3.76;	// 133 MHz
   parameter PHASETIME=(PERIOD / 2);
   parameter SDLY=2;
   
   reg 		 RESETn;
   reg 		 Clock;

`ifdef __JTAG__   
   wire 	 etclk;
   wire 	 ertclk;
`endif // __JTAG__   
   
   initial Clock = 0;
   always #PHASETIME Clock = ~Clock;
   
   initial begin
	  RESETn = 1'b0;
	  #(1000)
	  repeat(10) @(posedge Clock);
	  #(SDLY) RESETn = 1'b1;
   end // initial

`ifdef __JTAG__   
   assign  etclk = (RESETn == 1'b0)? Clock : 1'b0;
`endif // __JTAG__   

wire  [19:0]		EXT_ADDR ;
wire  [15:0]		EXT_DATA ;
wire        		EXT_CSb  ;
wire  				EXT_OEb  ;
wire  				EXT_WEb  ;
wire  [ 3:0]		EXT_BEb  ;
wire  [ 3:0]		EXT_WBEb ;

wire          SD_CLK;
wire          SD_nCLK;
wire [12:0]   #SDLY SD_ADDR;
wire [1:0]    #SDLY SD_BADDR;
wire          #SDLY SD_CSB;
wire          #SDLY SD_RASB;
wire          #SDLY SD_CASB;
wire          #SDLY SD_WEB;
wire [1:0]    #SDLY SD_DQM;
wire          #SDLY SD_CKE;
wire [15:0]   SD_DQ;
wire [1:0]    SD_DQS;


   wire 	  UART_TXD;
   wire 	  I2C_SDA;
   wire 	  I2C_SCL;
   wire 	  LCDClk;
   wire 	  LCDHSync;
   wire 	  LCDVSync;
   wire 	  LCDDataEn;
   wire [23:0] LCDData;
   
   wire 	   led_4094clk;
   wire 	   led_4094d;
   wire 	   led_4094oe;
   wire [3:0]  led_4094str;

   // FPGA debug
`ifdef FPGA
   wire [33:0]     DBG0;       // FPGA debug output
   wire [33:0]     DBG1;       // FPGA debug output
   //wire   [7:0]     DSWITCH;    // FPGA debug input (from DIP switches)
`endif
   

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

TestPlatformFPGA #(.PERIOD(PERIOD), .SDLY(SDLY)) Top
(
	.RESETn(RESETn),
	.Clock(Clock),
    .VINITHI   ( 1'b0 ),													 

   // FPGA debug
`ifdef FPGA
    .DBG0            ( DBG0 ),
    .DBG1            ( DBG1 ),
    .DSWITCH         ( 8'h00 ),
`endif
 
`ifdef __JTAG__   
    .etrstb          (RESETn),
    .etclk           (etclk),
    .ertclk          (ertclk),
    .etms            (1'b0),
    .etdi            (1'b0),
    .etdo            (etdo)
`endif // __JTAG__

	.EXT_ADDR(EXT_ADDR),
	.EXT_DATA(EXT_DATA),
	.EXT_CSb(EXT_CSb),
	.EXT_OEb(EXT_OEb),
	.EXT_WEb(EXT_WEb),
//	.EXT_BEb(EXT_BEb),
//	.EXT_WBEb(EXT_WBEb),

	.SD_CLK(SD_CLK),
	.SD_nCLK(SD_nCLK),
	.SD_CKE(SD_CKE),
	.SD_CSB(SD_CSB),
	.SD_RASB(SD_RASB),
	.SD_CASB(SD_CASB),
	.SD_WEB(SD_WEB),
	.SD_BADDR(SD_BADDR),
	.SD_ADDR(SD_ADDR),
	.SD_DQM(SD_DQM),
	.SD_DQ(SD_DQ),
	.SD_DQS(SD_DQS),

	.UART_TXD(UART_TXD),
	.UART_RXD(1'b0),

	.I2C_SDA(I2C_SDA),
	.I2C_SCL(I2C_SCL),

	.MMC_CLKOUT(MMC_CLKOUT),
	.MMC_CMD(MMC_CMD),
	.MMC_DAT(MMC_DAT),

	.LCDClk(LCDClk),
	.LCDHSync(LCDHSync),
	.LCDVSync(LCDVSync),
    .LCDDataEn    (LCDDataEn),
	.LCDData(LCDData),

	.led_4094clk(led_4094clk),
	.led_4094d(led_4094d),
	.led_4094oe(led_4094oe),
	.led_4094str(led_4094str)
);

prom16bit prom
(
	.addr(EXT_ADDR[18:0]),
	.romdata(EXT_DATA[15:0]),
	.oeb(EXT_OEb),
	.csb(EXT_CSb)
);

ddr ddram16bit (
	.Dq		(),
//	.Dq		(SD_DQ),
	.Addr	(SD_ADDR),
	.Ba		(SD_BADDR),
	.Clk	(SD_CLK),
	.Clk_n	(SD_nCLK),
	.Cke	(SD_CKE),
	.Cs_n	(SD_CSB),
	.Ras_n	(SD_RASB),
	.Cas_n	(SD_CASB),
	.We_n	(SD_WEB),
	.Dqs	(), 
//	.Dqs	(SD_DQS), 
	.Dm		(SD_DQM)
				
);

   assign 	 SD_DQS = 0;
   assign 	 SD_Dq = 0;
   
   
/*
S3F49SAX MMC1GB(
	.MCLK(MMC_CLKOUT),
	.MCMD(MMC_CMD),
	.MDAT7(MMC_DAT[7]),
	.MDAT6(MMC_DAT[6]),
	.MDAT5(MMC_DAT[5]),
	.MDAT4(MMC_DAT[4]),
	.MDAT3(MMC_DAT[3]),      // MCS  common
	.MDAT2(MMC_DAT[2]),
	.MDAT1(MMC_DAT[1]),
	.MDAT0(MMC_DAT[0])
);
*/

//initial $dumpvars;

`ifndef __ANET_SIM__
always @(posedge Clock)
	if(tb.Top.GpioOut[15:8] === 8'hde)
	begin
		$display("Simulation Ended with error code(%h)", tb.Top.GpioOut[7:0]);
		$finish;
	end
`endif // __ANET_SIM__
  
endmodule



/*
 At Altera Netlist Simulation 
 Compile Option:
 
 +incdir+D:/Project/ARM926EJS_4k4k/RTL/v0.1

+incdir+D:/Project/ARM926_Platform/RTL/v0.1/Top

+define+__ANET_SIM__=1
 
 */