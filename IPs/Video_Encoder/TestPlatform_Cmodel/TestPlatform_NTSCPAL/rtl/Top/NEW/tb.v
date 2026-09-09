
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
// Purpose            : Test Benc for TestPlatform
// --========================================================================--

`timescale 1ns/1ps
module tb;

parameter PERIOD=3.76;	// 133 MHz
parameter PHASETIME=(PERIOD / 2);
parameter SDLY=2;

parameter PERIOD2=6.67;	// 150 MHz for 27Mhz
parameter PHASETIME2=(PERIOD2 / 2);

reg   RESETn;
reg   Clock;
reg   Clock2;

initial Clock  = 0;
initial Clock2 = 0;

always #PHASETIME  Clock  = ~Clock;
always #PHASETIME2 Clock2 = ~Clock2;
initial
begin
	RESETn = 1'b0;

	repeat(100) @(posedge Clock);
	#(SDLY) RESETn = 1'b1;
end

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
tri  [1:0]    SD_DQS;

pullup(SD_DQS[0]);
pullup(SD_DQS[1]);

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

//Read address channel
wire   BUS_CLK:
wire   BUS_RESETn;

wire   [31:0] ARADDR_VideoEnC;
wire   [3:0]  ARLEN_VideoEnC;
wire   [2:0]  ARSIZE_VideoEnC;  
wire   [1:0]  ARBURST_VideoEnC; 

wire   ARVALID_VideoEnC; 
wire   ARREADY_2_VideoEnC; 

//Read data channel
wire   [1:0]   RRESP_2_VideoEnC;   
wire   [31:0]  RDATA_2_VideoEnC;
wire   RLAST_2_VideoEnC;
wire   RVALID_2_VideoEnC;  
wire   RREADY_VideoEnC;  


FPGA0 TOP0(

        /* BUS for Video Encoder tester */
        //Read address channel
        .ARADDR_VideoEnC(ARADDR_VideoEnC),
        .ARLEN_VideoEnC(ARLEN_VideoEnC),
        .ARSIZE_VideoEnC(ARSIZE_VideoEnC),
        .ARBURST_VideoEnC(ARBURST_VideoEnC),

        .ARVALID_VideoEnC(ARVALID_VideoEnC),
        .ARREADY_2_VideoEnC(ARREADY_2_VideoEnC),

        //Read data channel
        .RRESP_2_VideoEnC(RRESP_2_VideoEnC),   
        .RDATA_2_VideoEnC(RDATA_2_VideoEnC),
        .RLAST_2_VideoEnC(RLAST_2_VideoEnC),
        .RVALID_2_VideoEnC(RVALID_2_VideoEnC),  
        .RREADY_VideoEnC(RREADY_VideoEnC),
        
        //APB bus
        .PADDR0_2_VideoEnc(PADDR0_2_VideoEnc),
        .PWDATA0_2_VideoEnc(PWDATA0_2_VideoEnc),
        .PENABLE0_2_VideoEnc(PENABLE0_2_VideoEnc),
        .PSEL0_3_VideoEnc(PSEL0_3_VideoEnc),

        .BUS_CLK(BUS_CLK),
        .BUS_RESETn(BUS_RESETn)
        .VIDEO_CLK(Clock2),

        /* DAC output signal */
        .DAC_CLK(),
        .DAC_OUT(),
        .SYNC(),
        .BLANK()
);

FPGA1 TOP1(
	    .RESETn(RESETn),
	    .Clock(Clock),

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

	    .UART_TXD(),
	    .UART_RXD(1'b0),

	    .I2C_SDA(),
	    .I2C_SCL(),

	    .MMC_CLKOUT(MMC_CLKOUT),
	    .MMC_CMD(MMC_CMD),
	    .MMC_DAT(MMC_DAT),

	    .led_4094clk(),
	    .led_4094d(),
	    .led_4094oe(),
	    .led_4094str()

        /* BUS for Video Encoder tester */
        //Read address channel
        .ARADDR_VideoEnC(ARADDR_VideoEnC),
        .ARLEN_VideoEnC(ARLEN_VideoEnC),
        .ARSIZE_VideoEnC(ARSIZE_VideoEnC),
        .ARBURST_VideoEnC(ARBURST_VideoEnC),

        .ARVALID_VideoEnC(ARVALID_VideoEnC),
        .ARREADY_2_VideoEnC(ARREADY_2_VideoEnC),

        //Read data channel
        .RRESP_2_VideoEnC(RRESP_2_VideoEnC),   
        .RDATA_2_VideoEnC(RDATA_2_VideoEnC),
        .RLAST_2_VideoEnC(RLAST_2_VideoEnC),
        .RVALID_2_VideoEnC(RVALID_2_VideoEnC),  
        .RREADY_VideoEnC(RREADY_VideoEnC),
        
        //APB bus
        .PADDR0_2_VideoEnc(PADDR0_2_VideoEnc),
        .PWDATA0_2_VideoEnc(PWDATA0_2_VideoEnc),
        .PENABLE0_2_VideoEnc(PENABLE0_2_VideoEnc),
        .PSEL0_3_VideoEnc(PSEL0_3_VideoEnc),

        .BUS_CLK(BUS_CLK),
        .BUS_RESETn(BUS_RESETn)
);

prom16bit prom
(
	.addr(EXT_ADDR[18:0]),
	.romdata(EXT_DATA[15:0]),
	.oeb(EXT_OEb),
	.csb(EXT_CSb)
);

ddr ddram16bit (
	.Dq		(SD_DQ),
	.Addr	(SD_ADDR),
	.Ba		(SD_BADDR),
	.Clk	(SD_CLK),
	.Clk_n	(SD_nCLK),
	.Cke	(SD_CKE),
	.Cs_n	(SD_CSB),
	.Ras_n	(SD_RASB),
	.Cas_n	(SD_CASB),
	.We_n	(SD_WEB),
	.Dqs	(SD_DQS), 
	.Dm		(SD_DQM)
);

integer index  = 0;
integer index1 = 0;

always @(posedge Clock)
begin

	if(tb.TOP1.GpioOut[15:8] === 8'h43 && index == 0)
	begin
		$display("Simulation Ended with error code(%h)", tb.Top.GpioOut[7:0]);
		$stop;
        index=index+1;
	end

	if(tb.TOP1.GpioOut[15:8] === 8'h12 && index == 1)
	begin
		$display("Simulation Ended with error code(%h)", tb.Top.GpioOut[7:0]);
		$stop;
        index=index+1;
	end
end

always @(posedge Clock)
begin
	if(tb.Top.Core.VideoEnC.TempBuffer === 8'h01 && index1 == 0)
    begin
        index1 =1;
		$display("Simulation Check 1 point\n ");
        $stop;
    end

	if(tb.Top.Core.VideoEnC.TempBuffer === 8'hFF && index1 == 1)
    begin
        index1 =2;
		$display("Simulation Check 2 point\n ");
        $stop;
    end
end

integer compare_file;
always @(posedge Clock2) $fwrite(compare_file, "%02h\n",tb.Top.Core.VideoEnC.TempBuffer);

initial compare_file = $fopen("./compare.out");


endmodule
