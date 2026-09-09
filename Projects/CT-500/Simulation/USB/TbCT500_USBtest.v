// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TbCT500.v
// File Revision       : 1.0
// ----------------------------------------------------------------------------
// Purpose            : Test Benc for CT500
// --========================================================================--

`timescale 1ns/1ps

module TbCT500;

parameter SDLY=1;

//parameter CLK27M_PERIOD=37.037;		// 27 Mhz
parameter CLK27M_PERIOD=41.667;	// 24MHz for PHY test
parameter CLK27M_HPERIOD=(CLK27M_PERIOD/2);

parameter CLK24M_PERIOD=41.667;	// 24MHz
parameter CLK24M_HPERIOD=(CLK24M_PERIOD/2);

reg   nRESET;
reg	  TestMode;
reg	  NF_RnB0;	// ScanMode
reg	  I2S_SDIN;	// BistMode
reg         USBPHY_TMode;
 
initial begin
	TestMode = 0;
	NF_RnB0  = 0;
	I2S_SDIN = 0;
end

reg   Clock27M;
initial Clock27M = 0;
always #CLK27M_HPERIOD Clock27M = ~Clock27M;

reg   Clock24M;
initial Clock24M = 0;
always #CLK24M_HPERIOD Clock24M = ~Clock24M;

   initial begin
//	  $readmemh ("./rom/program.rom.32", TbCT500.Top.Core.SRAM_0.mem); // for function
	  $readmemh ("./rom/program.rom.32", TbCT500.Top.Core.SRAM_0.SRAM_i0.mem); // for post
	  $display("ISRAM0[0]=%h",TbCT500.Top.Core.SRAM_0.SRAM_i0.mem[0]);
   end


   
initial
begin
	nRESET = 1'b0;

	repeat(100) @(posedge Clock27M);
	#(5) nRESET = 1'b1;
	$display("Reset Disabled Simulation Start Now >>>");
end

wire [23:6] SMC_ADDR;
tri  [ 5:0] SMC_ADDR5_0;
tri  [ 7:0] SMC_DATA;
wire        SMC_nCS8;
tri         SMC_nCS7;
tri         SMC_nCS6;
wire        SMC_nCS5;
wire		SMC_nCS0;
wire        SMC_nOE;
wire        SMC_nWE;

wire  [23:0]  WAVE_ADDR;
reg   [ 7:0]  WAVE_DATAi;
tri   [ 7:0]  WAVE_DATA;
wire          WAVE_nCE;
wire  		  WAVE_nOE;
wire  		  WAVE_nWE;

wire          DDR_CLK;
wire          DDR_nCLK;
wire [12:0]   #SDLY DDR_ADDR;
wire [1:0]    #SDLY DDR_BADDR;
wire          #SDLY DDR_CSB;
wire          #SDLY DDR_RASB;
wire          #SDLY DDR_CASB;
wire          #SDLY DDR_WEB;
wire [1:0]    DDR_DQM;
tri  [15:0]   DDR_DQ;
tri  [1:0]    DDR_DQS;
wire          #SDLY DDR_CKE;

pullup(DDR_DQS[0]);
pullup(DDR_DQS[1]);

tri           ARMICE_nSRST;
wire          ARMICE_nTRST;
wire          ARMICE_TCK;
wire          ARMICE_RTCK;
wire          ARMICE_TMS;
wire          ARMICE_TDI;
wire          ARMICE_TDO;

pullup(ARMICE_nSRST);
assign ARMICE_nTRST = nRESET;
assign ARMICE_TCK = 1;
assign ARMICE_TMS = 1;
assign ARMICE_TDI = 1;

wire        SEIP_ADMCK;
wire        SEIP_MLRCK;
wire        SEIP_MSCK;
wire         SEIP_SDI1;
reg         SEIP_SDI2;
wire        SEIP_LRCKO;
wire        SEIP_SCKO;
wire        SEIP_SD1O;
wire        SEIP_SD2O;

tri [7:0] pVIF_DATA;
reg [7:0] pVIF_DATA_i;

initial pVIF_DATA_i = 8'hFF;
/*
assign pVIF_DATA[7] = Top.PVIF_DATA7.OEN ? pVIF_DATA_i[7]: 1'bz;
assign pVIF_DATA[6] = Top.PVIF_DATA6.OEN ? pVIF_DATA_i[6]: 1'bz;
assign pVIF_DATA[5] = Top.PVIF_DATA5.OEN ? pVIF_DATA_i[5]: 1'bz;
assign pVIF_DATA[4] = Top.PVIF_DATA4.OEN ? pVIF_DATA_i[4]: 1'bz; 
assign pVIF_DATA[3] = Top.PVIF_DATA3.OEN ? pVIF_DATA_i[3]: 1'bz;
assign pVIF_DATA[2] = Top.PVIF_DATA2.OEN ? pVIF_DATA_i[2]: 1'bz;
assign pVIF_DATA[1] = Top.PVIF_DATA1.OEN ? pVIF_DATA_i[1]: 1'bz;
assign pVIF_DATA[0] = Top.PVIF_DATA0.OEN ? pVIF_DATA_i[0]: 1'bz;
*/
tri [31:30] GPIO1;
reg [31:30] GPIO1_i;

initial begin
	GPIO1_i = 2'h3;
end

//assign GPIO1[30] = (Top.PGPIO131.OEN) ? GPIO1_i[30] : 1'bz;
//assign GPIO1[31] = (Top.PGPIO130.OEN) ? GPIO1_i[31] : 1'bz;

tri [26:24] SMC_ADDR26_24;
tri [4:1] SMC_nCS4_1;
reg [26:24] SMC_ADDR26_24_i;
reg [4:1] SMC_nCS4_1_i;
initial begin
	SMC_ADDR26_24_i = 3'h7;
	SMC_nCS4_1_i = 4'hf;
end
/*
assign SMC_nCS4_1[4] = (Top.PSMC_nCS4_14.OEN) ? SMC_nCS4_1_i[4] : 1'bz;
assign SMC_nCS4_1[3] = (Top.PSMC_nCS4_13.OEN) ? SMC_nCS4_1_i[3] : 1'bz;
assign SMC_nCS4_1[2] = (Top.PSMC_nCS4_12.OEN) ? SMC_nCS4_1_i[2] : 1'bz;
assign SMC_nCS4_1[1] = (Top.PSMC_nCS4_11.OEN) ? SMC_nCS4_1_i[1] : 1'bz;

assign SMC_ADDR26_24[26] = (Top.PSMC_ADDR26_2426.OEN) ? SMC_ADDR26_24_i[26] : 1'bz;
assign SMC_ADDR26_24[25] = (Top.PSMC_ADDR26_2425.OEN) ? SMC_ADDR26_24_i[25] : 1'bz;
assign SMC_ADDR26_24[24] = (Top.PSMC_ADDR26_2424.OEN) ? SMC_ADDR26_24_i[24] : 1'bz;
*/
pulldown (SMC_ADDR5_0[5]);	// NandOutDtmn
pulldown (SMC_ADDR5_0[4]);	// NandBootCfg
pulldown (SMC_ADDR5_0[3]);	
pulldown (SMC_ADDR5_0[2]);	// NandIOWidth
pulldown (SMC_ADDR5_0[1]);	// BootMode, 00 : CS0 Normal Boot, 01 : NAND Boot, 10 : CS1 Boot
//pullup   (SMC_ADDR5_0[1]);	// BootMode, 00 : CS0 Normal Boot, 01 : NAND Boot, 10 : CS1 Boot
pulldown (SMC_ADDR5_0[0]);

reg SMC_nCS6_i;
reg SMC_nCS7_i;

initial begin
	SMC_nCS6_i = 1;
	SMC_nCS7_i = 1;
end

//assign SMC_nCS6 = (Top.PSMC_nCS6.OEN) ? SMC_nCS6_i : 1'bz;   // I2S_BCLK, B
//assign SMC_nCS7 = (Top.PSMC_nCS7.OEN) ? SMC_nCS7_i : 1'bz;   // I2S_LRCLK, B

tri  [7:0]  NF_IO;
tri         pNF_CLE;
tri         pNF_ALE;
tri         pNF_nCE0;
tri         pNF_nCE1;
tri         pNF_nRE;
tri         pNF_nWE;
tri         pNF_RnB1;

reg  [7:0]  NF_IO_i;
reg         pNF_CLE_i;
reg         pNF_ALE_i;
reg         pNF_nCE0_i;
reg         pNF_nCE1_i;
reg         pNF_nRE_i;
reg         pNF_nWE_i;
reg         pNF_RnB1_i;

initial begin
	NF_IO_i = 8'hff;
	pNF_CLE_i = 1;
	pNF_ALE_i = 1;
	pNF_nCE0_i = 1;
	pNF_nCE1_i = 1;
	pNF_nRE_i = 1;
	pNF_nWE_i = 1;
	pNF_RnB1_i = 1;
end
/*
assign NF_IO[0] = Top.PNF_IO0.OEN ? NF_IO_i[0] : 1'bz;
assign NF_IO[1] = Top.PNF_IO1.OEN ? NF_IO_i[1] : 1'bz;
assign NF_IO[2] = Top.PNF_IO2.OEN ? NF_IO_i[2] : 1'bz;
assign NF_IO[3] = Top.PNF_IO3.OEN ? NF_IO_i[3] : 1'bz;
assign NF_IO[4] = Top.PNF_IO4.OEN ? NF_IO_i[4] : 1'bz;
assign NF_IO[5] = Top.PNF_IO5.OEN ? NF_IO_i[5] : 1'bz;
assign NF_IO[6] = Top.PNF_IO6.OEN ? NF_IO_i[6] : 1'bz;
assign NF_IO[7] = Top.PNF_IO7.OEN ? NF_IO_i[7] : 1'bz;

assign pNF_ALE  = Top.PNF_ALE0.OEN ? pNF_ALE_i : 1'bz; 
assign pNF_CLE  = Top.PNF_CLE0.OEN ? pNF_CLE_i : 1'bz; 
assign pNF_nCE0 = Top.PNF_nCE00.OEN ? pNF_nCE0_i : 1'bz;
assign pNF_nCE1 = Top.PNF_nCE10.OEN ? pNF_nCE1_i : 1'bz;
assign pNF_nRE  = Top.PNF_nRE0.OEN ? pNF_nRE_i : 1'bz;
assign pNF_nWE  = Top.PNF_nWE0.OEN ? pNF_nWE_i : 1'bz;
assign pNF_RnB1 = Top.PNF_RnB10.OEN ? pNF_RnB1_i : 1'bz;
*/
// MMC
tri MMC_CMD;
tri [3:0] MMC_DAT;
tri MMC_CLK;

reg MMC_CMD_i;
reg [3:0] MMC_DAT_i;
reg MMC_CLK_i;

initial begin
	MMC_CMD_i = 1;
	MMC_DAT_i = 4'hF;
	MMC_CLK_i = 1;
end
/*
assign MMC_CMD = Top.PMMC_CMD.OEN ? MMC_CMD_i : 1'bz;
assign MMC_DAT[3] = Top.PMMC_DAT3.OEN ? MMC_DAT_i[3] : 1'bz;
assign MMC_DAT[2] = Top.PMMC_DAT2.OEN ? MMC_DAT_i[2] : 1'bz;
assign MMC_DAT[1] = Top.PMMC_DAT1.OEN ? MMC_DAT_i[1] : 1'bz;
assign MMC_DAT[0] = Top.PMMC_DAT0.OEN ? MMC_DAT_i[0] : 1'bz;
assign MMC_CLK = Top.PMMC_CLK.OEN ? MMC_CLK_i : 1'bz;
*/
tri       pUART2_TXD;
tri       pUART0_TXD;
reg       pUART2_TXD_i;
reg       pUART0_TXD_i;

initial begin
	pUART2_TXD_i = 1;
	pUART0_TXD_i = 1;
end

//assign pUART2_TXD = (Top.PUART2_TXD0.OEN) ? pUART2_TXD_i : 1'bz;
//assign pUART0_TXD = (Top.PUART0_TXD0.OEN) ? pUART0_TXD_i : 1'bz;

tri         pLCD_Clk;
tri         pLCD_VSync;
tri         pLCD_HSync;
tri         pLCD_DataEn;
tri  [15:0] pLCD_Data;

reg         pLCD_Clk_i;
reg         pLCD_VSync_i;
reg         pLCD_HSync_i;
reg         pLCD_DataEn_i;
reg  [15:0] pLCD_Data_i;

initial begin
	pLCD_Clk_i = 1;
	pLCD_VSync_i = 1;
	pLCD_HSync_i = 1;
	pLCD_DataEn_i = 1;
	pLCD_Data_i = 16'hffff;
end
/*
assign pLCD_DataEn  = Top.PLCD_DataEn0.OEN ? pLCD_DataEn_i : 1'bz;
assign pLCD_VSync   = Top.PLCD_VSync0.OEN ? pLCD_VSync_i  : 1'bz;
assign pLCD_HSync   = Top.PLCD_HSync0.OEN ? pLCD_HSync_i  : 1'bz;
assign pLCD_Clk     = Top.PLCD_Clk0.OEN ? pLCD_Clk_i  : 1'bz;
assign pLCD_Data[15]= Top.PLCD_Data15.OEN ? pLCD_Data_i[15]  : 1'bz;
assign pLCD_Data[14]= Top.PLCD_Data14.OEN ? pLCD_Data_i[14]: 1'bz;
assign pLCD_Data[13]= Top.PLCD_Data13.OEN ? pLCD_Data_i[13]: 1'bz;
assign pLCD_Data[12]= Top.PLCD_Data12.OEN ? pLCD_Data_i[12]: 1'bz;
assign pLCD_Data[11]= Top.PLCD_Data11.OEN ? pLCD_Data_i[11]: 1'bz;
assign pLCD_Data[10]= Top.PLCD_Data10.OEN ? pLCD_Data_i[10]: 1'bz;    // G6
assign pLCD_Data[9] = Top.PLCD_Data9.OEN ? pLCD_Data_i[9]: 1'bz;
assign pLCD_Data[8] = Top.PLCD_Data8.OEN ? pLCD_Data_i[8]: 1'bz;
assign pLCD_Data[7] = Top.PLCD_Data7.OEN ? pLCD_Data_i[7]: 1'bz;
assign pLCD_Data[6] = Top.PLCD_Data6.OEN ? pLCD_Data_i[6]: 1'bz;
assign pLCD_Data[5] = Top.PLCD_Data5.OEN ? pLCD_Data_i[5]: 1'bz;
assign pLCD_Data[4] = Top.PLCD_Data4.OEN ? pLCD_Data_i[4]: 1'bz; // B5
assign pLCD_Data[3] = Top.PLCD_Data3.OEN ? pLCD_Data_i[3]: 1'bz;
assign pLCD_Data[2] = Top.PLCD_Data2.OEN ? pLCD_Data_i[2]: 1'bz;
assign pLCD_Data[1] = Top.PLCD_Data1.OEN ? pLCD_Data_i[1]: 1'bz;
assign pLCD_Data[0] = Top.PLCD_Data0.OEN ? pLCD_Data_i[0]: 1'bz;
*/
// SPI
tri SPI_nSS;
tri SPI_SCK;
tri SPI_SDI;
tri SPI_SDO;
reg SPI_nSS_i;
reg SPI_SCK_i;
reg SPI_SDI_i;
reg SPI_SDO_i;

initial begin
	SPI_nSS_i = 1;
	SPI_SCK_i = 1;
	SPI_SDI_i = 1;
	SPI_SDO_i = 1;
end
   /*
assign SPI_nSS = (Top.PSPI_nSS.OEN) ? SPI_nSS_i : 1'bz;
assign SPI_SCK = (Top.PSPI_SCK.OEN) ? SPI_SCK_i : 1'bz;
assign SPI_SDI = (Top.PSPI_SDI.OEN) ? SPI_SDI_i : 1'bz;
assign SPI_SDO = (Top.PSPI_SDO.OEN) ? SPI_SDO_i : 1'bz;
*/

   wire     USB_DP;
   wire     USB_DN;

CT500CHIP_s0 Top(
	.TestMode(TestMode),
	.nRESET(nRESET),
	.CLK27M(Clock27M),
	.USB_CLK(Clock24M),

	.WAVE_ADDR(WAVE_ADDR),
	.WAVE_nCE(WAVE_nCE),
	.WAVE_nOE(WAVE_nOE),
	.WAVE_nWE(WAVE_nWE),
	.WAVE_DATA(WAVE_DATA),

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

		.SMC_ADDR26_24(SMC_ADDR26_24),
		.SMC_ADDR(SMC_ADDR),
		.SMC_ADDR5_0(SMC_ADDR5_0),
		.SMC_DATA(SMC_DATA),
		.SMC_nCS8(SMC_nCS8),
		.SMC_nCS7(SMC_nCS7),
		.SMC_nCS6(SMC_nCS6),
		.SMC_nCS5(SMC_nCS5),
		.SMC_nCS4_1(SMC_nCS4_1),
		.SMC_nCS0(SMC_nCS0),
		.SMC_nOE(SMC_nOE),
		.SMC_nWE(SMC_nWE),

	.VIF_CLK(1'b0),
	.pVIF_DATA(pVIF_DATA),

		.NF_IO(NF_IO),
		.pNF_CLE(pNF_CLE),
		.pNF_ALE(pNF_ALE),
		.pNF_nCE1(pNF_nCE1),
		.pNF_nCE0(pNF_nCE0),
		.pNF_nRE(pNF_nRE),
		.pNF_nWE(pNF_nWE),
		.pNF_RnB1(pNF_RnB1),
		.NF_RnB0(NF_RnB0),

	.pUART2_TXD(pUART2_TXD),
	.pUART0_TXD(pUART0_TXD),
	.UART_RXD(3'b111),

	.pLCD_Clk(pLCD_Clk),
	.pLCD_HSync(pLCD_HSync),
	.pLCD_VSync(pLCD_VSync),
	.pLCD_Data(pLCD_Data),
	.pLCD_DataEn(pLCD_DataEn),

	.ARMICE_nSRST(ARMICE_nSRST),
	.ARMICE_nTRST(ARMICE_nTRST),
	.ARMICE_TCK(ARMICE_TCK),
	.ARMICE_RTCK(ARMICE_RTCK),
	.ARMICE_TMS(ARMICE_TMS),
	.ARMICE_TDI(ARMICE_TDI),
	.ARMICE_TDO(ARMICE_TDO),

	.GPIO1(GPIO1),

	.I2S_SDIN(I2S_SDIN),

	    .SPI_SDO(SPI_SDO), 
        .SPI_SDI(SPI_SDI),
        .SPI_SCK(SPI_SCK),
        .SPI_nSS(SPI_nSS),

		.MMC_CLK(MMC_CLK),
        .MMC_CMD(MMC_CMD), 
        .MMC_DAT(MMC_DAT),

	  // USB PHY
	  .USB_DP  (USB_DP), 
	  .USB_DN  (USB_DN),
				 
		.SEIP_ADMCK(SEIP_ADMCK),
		.SEIP_MLRCK(SEIP_MLRCK),
		.SEIP_MSCK(SEIP_MSCK),
		.SEIP_SDI1(SEIP_SDI1),
		.SEIP_SDI2(SEIP_SDI2),
		.SEIP_LRCKO(SEIP_LRCKO),
		.SEIP_SCKO(SEIP_SCKO),
		.SEIP_SD1O(SEIP_SD1O),
		.SEIP_SD2O(SEIP_SD2O)
);
/*
//assign WAVE_DATA = (WAVE_nOE == 0 && WAVE_nCE == 0) ? WAVE_DATAi : 8'hzz;
assign WAVE_DATA[0] = (Top.PWAVE_DATA0.OEN) ? WAVE_DATAi[0] : 1'bz;
assign WAVE_DATA[1] = (Top.PWAVE_DATA1.OEN) ? WAVE_DATAi[1] : 1'bz;
assign WAVE_DATA[2] = (Top.PWAVE_DATA2.OEN) ? WAVE_DATAi[2] : 1'bz;
assign WAVE_DATA[3] = (Top.PWAVE_DATA3.OEN) ? WAVE_DATAi[3] : 1'bz;
assign WAVE_DATA[4] = (Top.PWAVE_DATA4.OEN) ? WAVE_DATAi[4] : 1'bz;
assign WAVE_DATA[5] = (Top.PWAVE_DATA5.OEN) ? WAVE_DATAi[5] : 1'bz;
assign WAVE_DATA[6] = (Top.PWAVE_DATA6.OEN) ? WAVE_DATAi[6] : 1'bz;
assign WAVE_DATA[7] = (Top.PWAVE_DATA7.OEN) ? WAVE_DATAi[7] : 1'bz;
*/
prom8bit prom
(
	.addr({SMC_ADDR[20:6], SMC_ADDR5_0}),
	.romdata(SMC_DATA[7:0]),
	.oeb(SMC_nOE),
	.csb(SMC_nCS0)
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

`ifdef WAVE
initial begin
  $shm_open("./TbCT500.shm");
  $shm_probe("AS");
/*
  $shm_probe(TbCT500, "A");
  $shm_probe(ddram16bit, "A");
  $shm_probe(Top, "A");
  $shm_probe(Top.Core, "A");
//  $shm_probe(Top.Core.SBUS, "A");
  $shm_probe(Top.Core.CPU, "A");
//  $shm_probe(Top.Core.Vif, "A");
//  $shm_probe(Top.Core.DisplayModule, "A");
//  $shm_probe(Top.Core.VideoEnc, "A"); 
//  $shm_probe(Top.Core.DMACtrl, "A");
//  $shm_probe(Top.Core.Dma2D, "A");
  $shm_probe(Top.Core.DDRCtrl, "A");
//  $shm_probe(Top.Core.SMC, "A");
//  $shm_probe(Top.Core.IntSRAMController, "A");
//  $shm_probe(Top.Core.NFCtrl, "A");
//  $shm_probe(Top.Core.VIC, "A");
//  $shm_probe(Top.Core.MMCTop, "A");
  $shm_probe(Top.Core.SEIP, "A");
//  $shm_probe(Top.Core.Timer4Ch, "A");
//  $shm_probe(Top.Core.WatchDog, "A");
//  $shm_probe(Top.Core.Gpio2Ch, "A");
  $shm_probe(Top.Core.PMTop, "AS");
  $shm_probe(Top.Core.ResourceShare, "A");
//  $shm_probe(Top.Core.Uart4Ch, "A");
//  $shm_probe(Top.Core.I2SCtrl, "A");
//  $shm_probe(Top.Core.I2CMaster, "A");
//  $shm_probe(Top.Core.SPI, "A");
//  $shm_probe(Top.Core.USB20, "A");
*/
end
`endif

initial begin
	//$sdf_annotate("./Sdf/CT500CHIP_s0_rcworst.sdf.gz", Top);
	//$sdf_annotate("./Sdf/CI12338tlbiosdf_wc.sdf", Top.Core.USB20.USB_DEVICE.PHY);
	//$sdf_annotate("./Sdf/CT500CHIP_s0_rctypical.sdf.gz", Top);
	////////////////////////////////////////////////$sdf_annotate("./Sdf/CI12338tlbiosdf_typ.sdf", Top.Core.USB20.USB_DEVICE.PHY);
	$sdf_annotate("../PostSim7/Sdf/CT500CHIP_s0_rcbest.sdf.gz", Top);
	$sdf_annotate("../PostSim7/Sdf/CT500_USB_async_bc.sdf", Top);
	$sdf_annotate("../PostSim7/Sdf/CI12338tlbiosdf_bc.sdf", Top.Core.USB20.USB_DEVICE.PHY);
	
//    $sdf_annotate("../PostSim7/Sdf/CT500CHIP_s0_rcworst.sdf.gz", Top);
//    $sdf_annotate("../PostSim7/Sdf/CT500_USB_async_wc.sdf", Top);
//    $sdf_annotate("../PostSim7/Sdf/CI12338tlbiosdf_wc.sdf.gz", Top);
end

`ifdef STROBE
// ARM926 Debug Signal
wire			 ACLK_CPU = Top.Core.PMTop.PMCtl.CPUBUF.Y;
wire			 ARESETn = Top.Core.CPU.ARESETn;
wire			 BusClockEn = Top.Core.CPU.BusClockEn;
wire [31:0] 	 IHADDR = Top.Core.CPU.IHADDR;
wire [ 1:0]      IHTRANS = Top.Core.CPU.IHTRANS;
wire             IHREADY_OUT = Top.Core.CPU.IHREADY_OUT;
wire [31:0] 	 DHADDR = Top.Core.CPU.DHADDR;
wire [ 1:0]      DHTRANS = Top.Core.CPU.DHTRANS;
wire             DHREADY_OUT = Top.Core.CPU.DHREADY_OUT;

   integer     memf;
   
   initial begin
      memf = $fopen("memop.log");
   end // initial
   //----------------------------------------------------
   // Display the fetch address
   wire   valid_iaddr;
   
   assign valid_iaddr = (IHTRANS != 2'h0 && IHREADY_OUT == 1'b1)? 1'b1 : 1'b0;
   
   always@(posedge ACLK_CPU) begin
      if(ARESETn & BusClockEn & valid_iaddr) begin
         $display(" %t Instruction Fetch : %h",$time,IHADDR);
         $fdisplay(memf," %t Instruction Fetch : %h",$time,IHADDR);
      end
   end // always
   
   
   //----------------------------------------------------
   // Display the data access address
   wire   valid_daddr;
   assign valid_daddr = (DHTRANS != 2'h0 && DHREADY_OUT == 1'b1)? 1'b1 : 1'b0;
   
   always@(posedge ACLK_CPU) begin
      if(ARESETn & BusClockEn & valid_daddr) begin
         $display(" %t Data Access : %h",$time,DHADDR);
         $fdisplay(memf," %t Data Access : %h",$time,DHADDR);
      end
   end // always
`endif



   //=================================================================================
   // USB PHY test

   wire xcvr_clk = Top.Core.USB20.USB_DEVICE.PHY.sieclock;
   wire #3 linestate_0 = Top.Core.USB20.pwrctl_linestate[0];
   wire #3 linestate_1 = Top.Core.USB20.pwrctl_linestate[1];
/*
   USBPHY_tb                   USB_test_model
	 (
	  .rst                          ((USBPHY_TMode)?1'b1:~nRESET),
	  //.pwrctl_utmi_xcvr_clk         ( Top.Core.USB20.pwrctl_utmi_xcvr_clk ),
	  //.pwrctl_linestate_0           ( Top.Core.USB20.pwrctl_linestate[0] ),
	  //.pwrctl_linestate_1           ( Top.Core.USB20.pwrctl_linestate[1] ),
	  .pwrctl_utmi_xcvr_clk         ( xcvr_clk ),
	  .pwrctl_linestate_0           ( linestate_0 ),
	  .pwrctl_linestate_1           ( linestate_1 ),
	  
	  .dp                           ( ),
	  .dn                           ( )
//	  .dp                           ( USB_DP ),
//	  .dn                           ( USB_DN )
	  );
*/
   // check end of USB test
   always @(posedge Clock27M) begin
	  if(TbCT500.Top.IntGPIO0_OUT[15:8] === 8'hED) begin
		 if(TbCT500.Top.IntGPIO0_OUT[7:0] == 8'h0C)
		   $display("<<<<<<< USB Test OK >>>>>>>>>");
		 else
		   $display("<<<<<<< USB Test FAIL >>>>>>>>>");
		 $finish;
	  end
   end // always


   
always @(posedge Top.Core.PMTop.PMCtl.PERI1XBUF.Y)
	if(TbCT500.Top.Core.GPIO0_OUT[15:8] === 8'hde)
	begin
		$display("Simulation Ended with error code(%h)", TbCT500.Top.Core.GPIO0_OUT[7:0]);
		$finish;
	end


initial begin
	#2000000 $stop;
end

   //----------------------------------------------------------------
   // USB PHY bist test
   wire 	phy_tb_rst;

   reg 			start;
   
   wire [1:0] 	xcvrsel;
   wire 		termsel;
   wire [3:0] 	vcontrol;
   wire 		vload;
   wire 		onbist;
   wire [7:0] 	vstatus;
   wire [1:0] 	opmode;
   wire [7:0] 	datain;
   wire 		txvalid;
   wire [1:0] 	linestate;
   


   USBPHY_TMode_tb       PHY_TMode
	 (
	  .clk         ( Clock24M ),
	  .rstb         ( nRESET ),
	  .rst_o       ( phy_tb_rst ),
	  .start       ( start ),
	  
	  .xcvrsel     ( xcvrsel ),
	  .termsel     ( termsel ),
	  
	  .vcontrol    ( vcontrol ),
	  .vload       ( vload ),
	  .onbist      ( onbist ),
	  .suspend     ( suspend ),
	  .opmode      ( opmode ),
	  .datain      ( datain ),
	  .txvalid     ( txvalid ),
	  
	  .vstatus     ( vstatus ),

	  .linestate   ( linestate ),
	  .USB_DP      ( USB_DP ),
	  .USB_DN      ( USB_DN )
	  );

   assign 		pLCD_Data[1:0] = (USBPHY_TMode)? opmode : 2'bzz; // gpio1[5:4] opmode
   assign 		pLCD_Data[3:2] = (USBPHY_TMode)? xcvrsel : 2'bzz; // gpio1[7:6]
   assign 		pLCD_Data[12] = (USBPHY_TMode)? termsel : 1'bz; // gpio1[16]
   assign 		WAVE_DATA[3:0] = (USBPHY_TMode)? vcontrol : 4'bzzzz;
   assign 		WAVE_DATA[7] = (USBPHY_TMode)? vload : 1'bz;
   assign 		SEIP_SDI1 = (USBPHY_TMode)? onbist : 1'bz;
   assign 		pLCD_Clk = (USBPHY_TMode)? suspend : 1'bz; // gpio1[20]
   
   assign 		vstatus = WAVE_ADDR[23:16];
   assign       pLCD_Data[15] = (USBPHY_TMode)? txvalid :1'bz; // gpio1[19] txvalid
   assign       pLCD_Data[14] = (USBPHY_TMode)? 1'b0 :1'bz; // gpio1[18] txvalidh
   assign 		pLCD_Data[11:4] = (USBPHY_TMode)? datain : 8'hzz; // gpio1[15:8]
   assign 		pLCD_Data[13] = (USBPHY_TMode)? phy_tb_rst : ~nRESET; //gpio1[17]
   
   assign       linestate = {SEIP_SD2O,SEIP_SD1O};
   
   initial begin
	  start = 1'b0;
      USBPHY_TMode = 1'b1;  // testbench pinmux

	  @(posedge Clock27M);
	  SEIP_SDI2 = 1'b1; // usb test
	  TestMode = 1'b1;
	  I2S_SDIN = 1'b0;
	  NF_RnB0 = 1'b0;
	  
	  wait(nRESET);

	  start = 1'b1;
   end // initial

   
endmodule
