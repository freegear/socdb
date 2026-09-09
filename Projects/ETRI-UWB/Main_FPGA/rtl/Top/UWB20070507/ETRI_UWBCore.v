// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : ETRI_UWBCore.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose            : ETRI UWB FPGA Core module
//  --========================================================================--

`timescale 1ns/1ps

`undef FPGA

module ETRI_UWBCore (
		nRESET,		// Async Active Low Reset
		ARMnRESET,	// Async Reset for ARM926
		CLK200M,	// 200 MHz DDR Clock
		CLK100M,	// 100 MHz BUS Clock
		CLK50M,		// 50 Mhz APB Clock
		CLK27M,		// 27 MHz Video Clock
	
		// Mac Interrupt source
		MacIntSrc,

		// AHB MASTER0 Interface for MAC (FROM FPGA1)
	    HADDR_M0,
	    HTRANS_M0,
	    HWRITE_M0,
	    HSIZE_M0,
	    HBURST_M0,
	    HPROT_M0,
	    HWDATA_M0,
	    HRDATA_M0,
	    HREADY_OUT_M0,
	    HRESP_M0,
	 
	    // AHB MASTER1 Interface for PCI (FROM Expansion Board)
	    HADDR_M1,
	    HTRANS_M1,
	    HWRITE_M1,
	    HSIZE_M1,
	    HBURST_M1,
	    HPROT_M1,
	    HWDATA_M1,
	    HRDATA_M1,
	    HREADY_OUT_M1,
	    HRESP_M1,
	 
	    // AHB SLAVE0 Interface for MAC (TO FOGA1)
	    HADDR_S0,
	    HTRANS_S0,
	    HWRITE_S0,
	    HSIZE_S0,
	    HBURST_S0,
	    HPROT_S0,
	    HWDATA_S0,
	    HRDATA_S0,
	    HREADY_IN_S0,
	    HRESP_S0,
	 
	    HSEL_S0,
	 
	    // AHB SLAVE1 Interface to MAC (TO FPGA1)
	    HADDR_S1,
	    HTRANS_S1,
	    HWRITE_S1,
	    HSIZE_S1,
	    HBURST_S1,
	    HPROT_S1,
	    HWDATA_S1,
	    HRDATA_S1,
	    HREADY_IN_S1,
	    HRESP_S1,
	 
	    HSEL_S1,

	    // AHB SLAVE2 Interface for PCI (To Expansion Board)
	    HADDR_S2,
	    HTRANS_S2,
	    HWRITE_S2,
	    HSIZE_S2,
	    HBURST_S2,
	    HPROT_S2,
	    HWDATA_S2,
	    HRDATA_S2,
	    HREADY_IN_S2,
	    HRESP_S2,
	 
	    HSEL_S2,


		// SMC
        BOOT_WIDTH,

		SMC_ADDR,
		SMC_WDATA,
		SMC_RDATA,
		SMC_nCS,
		SMC_nOE,
		SMC_nWE,
		SMC_nBE,
		SMC_nWBE,
		SMC_BIDEN,

		// DDR Controller
		DDR_CLK,
		DDR_nCLK,
		DDR_CKE,
		DDR_CSB,
		DDR_RASB,
		DDR_CASB,
		DDR_WEB,
		DDR_BADDR,
		DDR_ADDR,
		DDR_DQE,
		DDR_DQI,
		DDR_DQO,
		DDR_DQM,
		DDR_DQSE,
		DDR_DQSO,
		DDR_DQSI,
		DDR_nDQSI,

		// UART
		UART_TXD,
		UART_RXD,

		// I2C
		I2C_SCLi,
		I2C_SDAi,
		I2C_SCLo,
		I2C_SDAo,
		I2C_nSDAEn,
		I2C_nSCLEn,

		// I2S Related
		I2S_MCLK,		// 256*Fs clock output
		I2S_MCLK_OE,	// MCLK Output Enable(active high)
		I2S_BCLK_O,		// BCLK clock output
		I2S_BCLK_I,		// BCLK clock input
		I2S_BCLK_OE,	// BCLK Output Enable(active high)
		I2S_LRCLK_O,	// LRCLK clock output
		I2S_LRCLK_I,	// LRCLK clock input
		I2S_LRCLK_OE,	// LRCLK Output Enable(active high)
		I2S_SDIN,		// Serial Data Input
		I2S_SDOUT,		// Serial Data Output

		// NAND Flash Controller
		// NAND booting
		NF_Boot,
		NF_IOWidth,
		NF_Width,
		NF_BootCfg,
		NF_OutDtmn,
		NF_DMADone,

		// NAND connection
		NF_DI,
		NF_DO,
		NF_DOE,
		NF_CLE,
		NF_ALE,
		NF_nCE1,
		NF_nCE0,
		NF_nRE,
		NF_nWE,
		NF_RnB1,
		NF_RnB0,

		// GPIO
		GPIO0_IN,
		GPIO0_OE,
		GPIO0_OUT,

		GPIO1_IN,
		GPIO1_OE,
		GPIO1_OUT,

		// SPI
		SPIRxd,
		SPInSSIn,
		SPIClkIn,
		SPInSSOut,
		SPIClkOut,
		SPITxd,
		SPInOE,		// Output Enable for SPITxd
		SPInCTLOE,		// Ouptut Enable for SPIClkOut/SPInSSOut

		// ARM ICE JTAG signal
		ARMICE_nTRST,
		ARMICE_TCK,
		ARMICE_RTCK,
		ARMICE_TMS,
		ARMICE_TDI,
		ARMICE_TDO
);

// ----------------------------------------------------------------------------
// Address Map
// ----------------------------------------------------------------------------
// 0x0000_0000 - 0x0800_0000  External Static Memory Bank0(SMC_CSb[0])
// 0x0800_0000 - 0x1000_0000  External Static Memory Bank0(SMC_CSb[1])
// 0x1000_0000 - 0x1800_0000  External Static Memory Bank0(SMC_CSb[2])
// 0x1800_0000 - 0x1C00_0000  External Static Memory Bank0(SMC_CSb[3])
// 0x1C00_0000 - 0x2000_0000  External Static Memory Bank0(SMC_CSb[4])
// 
// 0x2000_0000 - 0x3000_0000  Internal SRAM
//
// 0x4000_0000 - 0x5000_0000  APB0
//     (PSEL0_0) 0x4000_0000 - 0x4000_3FFC : SD/MMC Controller
//     (PSEL0_1) 0x4000_4000 - 0x4000_7FFC : DDRCtrl
//     (PSEL0_2) 0x4000_8000 - 0x4000_BFFC : NAND Flash Ctrl
//     (PSEL0_3) 0x4000_C000 - 0x4000_FFFC : DMA Ctrl
//     (PSEL0_4) 0x4001_0000 - 0x4001_3FFC : 2D DMA Ctrl
//     (PSEL0_5) 0x4001_4000 - 0x4001_7FFC : VIC(Vectored Interrupt Controller)
//     (PSEL0_6) 0x4001_8000 - 0x4001_BFFC : Sound Engine
//     (PSEL0_7) 0x4001_C000 - 0x4001_FFFC : USB
//
// 0x5000_0000 - 0x6000_0000  APB1
//     (PSEL1_0) 0x5000_0000 - 0x5000_0FFC : Timer4Ch
//     (PSEL1_1) 0x5000_1000 - 0x5000_1FFC : WDT
//     (PSEL1_2) 0x5000_2000 - 0x5000_2FFC : GPIO
//     (PSEL1_3) 0x5000_3000 - 0x5000_3FFC : Power Management Unit
//     (PSEL1_4) 0x5000_4000 - 0x5000_4FFC : Resource Share Control
//     (PSEL1_5) 0x5000_5000 - 0x5000_5FFC : UART 4Ch
//     (PSEL1_6) 0x5000_6000 - 0x5000_6FFC : I2S Ctrl
//     (PSEL1_7) 0x5000_7000 - 0x5000_7FFC : I2C Ctrl
//     (PSEL1_8) 0x5000_8000 - 0x5000_8FFC : SPI
//     (PSEL1_9) 0x5000_9000 - 0x5000_9FFC : SMC
//     (PSEL1_A) 0x5000_A000 - 0x5000_AFFC : Display Module
//     (PSEL1_B) 0x5000_B000 - 0x5000_BFFC : Video Encoder
//     (PSEL1_C) 0x5000_C000 - 0x5000_CFFC : VIF(Video Input Processor)
//     (PSEL1_D) 0x5000_D000 - 0x5000_DFFC : (Empty)
//     (PSEL1_E) 0x5000_E000 - 0x5000_EFFC : (Empty)
//     (PSEL1_F) 0x5000_F000 - 0x5000_FFFC : (Empty)
//
// 0x6000_0000 - 0x7000_0000  DDR SDRAM region
//
// 0x7000_0000 - 0x8000_0000  AHB0 --MAC interface
//	   (HSEL0)	 0x7000_0000 - 0x7800_0000
//	   (HSEL1)   0x7800_0000 - 0x8000_0000 
// 0x8000_0000 - 0xA000_0000  AHB1 --PCI interface
//

input         nRESET;
input         ARMnRESET;
input         CLK200M;
input         CLK100M;
input         CLK50M;
input         CLK27M;

// Mac interrupt source
input [ 1:0]  MacIntSrc;

// AHB MASTER Interface for MAC (from FPGA1)
input [31:0]  HADDR_M0;
input [ 1:0]  HTRANS_M0;
input         HWRITE_M0;
input [ 2:0]  HSIZE_M0;
input [ 2:0]  HBURST_M0;
input [ 3:0]  HPROT_M0;
input [31:0]  HWDATA_M0;
output[31:0]  HRDATA_M0;
output        HREADY_OUT_M0;
output[ 1:0]  HRESP_M0;

// AHB MASTER Interface for PCI (from PCI Expansion board)
input [31:0]  HADDR_M1;
input [ 1:0]  HTRANS_M1;
input         HWRITE_M1;
input [ 2:0]  HSIZE_M1;
input [ 2:0]  HBURST_M1;
input [ 3:0]  HPROT_M1;
input [31:0]  HWDATA_M1;
output[31:0]  HRDATA_M1;
output        HREADY_OUT_M1;
output[ 1:0]  HRESP_M1;

// AHB SLAVE0 Interface for MAC (to FPGA1)
output[31:0]  HADDR_S0;
output[ 1:0]  HTRANS_S0;
output        HWRITE_S0;
output[ 2:0]  HSIZE_S0;
output[ 2:0]  HBURST_S0;
output[ 3:0]  HPROT_S0;
output[31:0]  HWDATA_S0;
input [31:0]  HRDATA_S0;
input         HREADY_IN_S0;
input [ 1:0]  HRESP_S0;

output        HSEL_S0;

// AHB SLAVE1 Interface for MAC (to FPGA1)
output[31:0]  HADDR_S1;
output[ 1:0]  HTRANS_S1;
output        HWRITE_S1;
output[ 2:0]  HSIZE_S1;
output[ 2:0]  HBURST_S1;
output[ 3:0]  HPROT_S1;
output[31:0]  HWDATA_S1;
input [31:0]  HRDATA_S1;
input         HREADY_IN_S1;
input [ 1:0]  HRESP_S1;

output        HSEL_S1;

// AHB SLAVE2 Interface for PCI (To Expansion Board )
output[31:0]  HADDR_S2;
output[ 1:0]  HTRANS_S2;
output        HWRITE_S2;
output[ 2:0]  HSIZE_S2;
output[ 2:0]  HBURST_S2;
output[ 3:0]  HPROT_S2;
output[31:0]  HWDATA_S2;
input [31:0]  HRDATA_S2;
input         HREADY_IN_S2;
input [ 1:0]  HRESP_S2;

output        HSEL_S2;


input  [ 1:0] BOOT_WIDTH;
output [26:0] SMC_ADDR;
output [15:0] SMC_WDATA;
input  [15:0] SMC_RDATA;
output [ 8:0] SMC_nCS;
output        SMC_nOE;
output        SMC_nWE;
output [ 3:0] SMC_nBE;
output [ 3:0] SMC_nWBE;
output        SMC_BIDEN;

output        DDR_CLK;
output        DDR_nCLK;
output        DDR_CKE;		// clock enable
output        DDR_CSB;		// chip select
output        DDR_RASB;		// row address strobe
output        DDR_CASB;		// column address strobe
output        DDR_WEB;		// write enable
output [1:0]  DDR_BADDR;	// bank address
output [12:0] DDR_ADDR;		// address
output        DDR_DQE;		// dq output enable
input  [15:0] DDR_DQI;		// data input
output [15:0] DDR_DQO;		// data output
output [1:0]  DDR_DQM;
output        DDR_DQSE;
output [1:0]  DDR_DQSO;
input  [1:0]  DDR_DQSI;
input  [1:0]  DDR_nDQSI;

output [3:0]  UART_TXD;
input  [3:0]  UART_RXD;

// I2C
input         I2C_SCLi;
input         I2C_SDAi;
output        I2C_SCLo;
output        I2C_SDAo;
output        I2C_nSCLEn;
output        I2C_nSDAEn;

// I2S
output        I2S_MCLK;
output        I2S_MCLK_OE;
output        I2S_BCLK_O;
input         I2S_BCLK_I;
output        I2S_BCLK_OE;
output        I2S_LRCLK_O;
input         I2S_LRCLK_I;
output        I2S_LRCLK_OE;
input         I2S_SDIN;
output        I2S_SDOUT;

// NANDFLASH Controller
input         NF_Boot;
input         NF_IOWidth;
input         NF_Width;
input  [1:0]  NF_BootCfg;
input         NF_OutDtmn;
output        NF_DMADone;

input  [15:0] NF_DI;
output [15:0] NF_DO;
output        NF_DOE;
output        NF_CLE;
output        NF_ALE;
output        NF_nCE0;
output        NF_nCE1;
output        NF_nRE;
output        NF_nWE;
input         NF_RnB0;
input         NF_RnB1;

// GPIO
input  [31:0] GPIO0_IN;
output [31:0] GPIO0_OE;
output [31:0] GPIO0_OUT;
input  [31:0] GPIO1_IN;
output [31:0] GPIO1_OE;
output [31:0] GPIO1_OUT;


// SPI
input         SPIRxd;          // SPI Receive input
input         SPIClkIn;        // SPI Serial Clock input
input         SPInSSIn;        // SPI Serial Frame input
output        SPInSSOut;       // Serial Frame Output pin
output        SPIClkOut;       // Serial Clock Output pin
output        SPITxd;          // SPI Serial Transmit output
output        SPInOE;          // Output Enable for SPITxd
output        SPInCTLOE;       // Output Enable for SPIClkOut and SPInSSOut

// External JTAG signal
input         ARMICE_nTRST;
input         ARMICE_TCK;
output        ARMICE_RTCK;
input         ARMICE_TMS;
input         ARMICE_TDI;
output        ARMICE_TDO;

//
// Clock & Reset : This part will be replaced with Power Management Unit
//

wire ACLK_BUS;
wire ACLK_CPU;
wire PCLK;
wire DDRCLK;
wire nDDRCLK;
wire nACLK_BUS;
wire BusClockEn;
wire PCLKEn;
wire ARESETn;
wire PRESETn0;
wire PRESETn1;

assign ACLK_BUS = CLK100M;
assign ACLK_CPU = CLK100M;
assign PCLK = CLK50M;
assign DDRCLK = CLK200M;
assign #0.1 nDDRCLK = ~CLK200M;
assign #0.1 nACLK_BUS = ~CLK100M;
assign BusClockEn = 1;
assign #0.1 PCLKEn = ~CLK50M;
assign ARESETn = nRESET;
assign PRESETn0 = nRESET;
assign PRESETn1 = nRESET;

//
// AXI BUS
//

// BUS interconneting signals

// AXI Master 0/1 : ARM Data/Instruciton
wire [31:0] AWADDR_ARMD;
wire [3:0]  AWLEN_ARMD;
wire [2:0]  AWSIZE_ARMD;
wire [1:0]  AWBURST_ARMD;
wire [1:0]  AWLOCK_ARMD;
wire        AWVALID_ARMD;
wire        AWREADY_ARMD;

wire [31:0] WDATA_ARMD;
wire [3:0]  WSTRB_ARMD;
wire        WLAST_ARMD;
wire        WVALID_ARMD;
wire        WREADY_ARMD;

wire [1:0]  BRESP_ARMD;
wire        BVALID_ARMD;
wire        BREADY_ARMD;

wire [31:0] ARADDR_ARMD;
wire [3:0]  ARLEN_ARMD;
wire [2:0]  ARSIZE_ARMD;
wire [1:0]  ARBURST_ARMD;
wire [1:0]  ARLOCK_ARMD;
wire        ARVALID_ARMD;
wire        ARREADY_ARMD;

wire [1:0]  RRESP_ARMD;
wire [31:0] RDATA_ARMD;
wire        RLAST_ARMD;
wire        RVALID_ARMD;
wire        RREADY_ARMD;

wire [31:0] ARADDR_ARMI;
wire [3:0]  ARLEN_ARMI;
wire [2:0]  ARSIZE_ARMI;
wire [1:0]  ARBURST_ARMI;
wire [1:0]  ARLOCK_ARMI;
wire        ARVALID_ARMI;
wire        ARREADY_ARMI;

wire [1:0]  RRESP_ARMI;
wire [31:0] RDATA_ARMI;
wire        RLAST_ARMI;
wire        RVALID_ARMI;
wire        RREADY_ARMI;


// AXI Master 2 : DMA Controller
wire        AWID_DMAC;
wire [31:0] AWADDR_DMAC;
wire [3:0]  AWLEN_DMAC;
wire [2:0]  AWSIZE_DMAC;
wire [1:0]  AWBURST_DMAC;
wire        AWVALID_DMAC;
wire        AWREADY_DMAC;

wire        WID_DMAC;
wire [31:0] WDATA_DMAC;
wire [3:0]  WSTRB_DMAC;
wire        WLAST_DMAC;
wire        WVALID_DMAC;
wire        WREADY_DMAC;

wire        BID_DMAC;
wire [1:0]  BRESP_DMAC;
wire        BVALID_DMAC;
wire        BREADY_DMAC;

wire        ARID_DMAC;
wire [31:0] ARADDR_DMAC;
wire [3:0]  ARLEN_DMAC;
wire [2:0]  ARSIZE_DMAC;
wire [1:0]  ARBURST_DMAC;
wire        ARVALID_DMAC;
wire        ARREADY_DMAC;

wire        RID_DMAC;
wire [1:0]  RRESP_DMAC;
wire [31:0] RDATA_DMAC;
wire        RLAST_DMAC;
wire        RVALID_DMAC;
wire        RREADY_DMAC;

// AXI Master 3 : MAC
wire [31:0] AWADDR_MAC;
wire [3:0]  AWLEN_MAC;
wire [2:0]  AWSIZE_MAC;
wire [1:0]  AWBURST_MAC;
wire        AWVALID_MAC;
wire        AWREADY_MAC;

wire [1:0]  AWLOCK_MAC;
wire [3:0]  AWCACHE_MAC;
wire [2:0]  AWPROT_MAC;
wire [1:0]  ARLOCK_MAC;
wire [3:0]  ARCACHE_MAC;
wire [2:0]  ARPROT_MAC;


wire [31:0] WDATA_MAC;
wire [3:0]  WSTRB_MAC;
wire        WLAST_MAC;
wire        WVALID_MAC;
wire        WREADY_MAC;

wire [1:0]  BRESP_MAC;
wire        BVALID_MAC;
wire        BREADY_MAC;

wire [31:0] ARADDR_MAC;
wire [3:0]  ARLEN_MAC;
wire [2:0]  ARSIZE_MAC;
wire [1:0]  ARBURST_MAC;
wire        ARVALID_MAC;
wire        ARREADY_MAC;

wire [1:0]  RRESP_MAC;
wire [31:0] RDATA_MAC;
wire        RLAST_MAC;
wire        RVALID_MAC;
wire        RREADY_MAC;

// AXI Master 4 : PCI
wire [31:0] AWADDR_PCI;
wire [3:0]  AWLEN_PCI;
wire [2:0]  AWSIZE_PCI;
wire [1:0]  AWBURST_PCI;
wire        AWVALID_PCI;
wire        AWREADY_PCI;

wire [31:0] WDATA_PCI;
wire [3:0]  WSTRB_PCI;
wire        WLAST_PCI;
wire        WVALID_PCI;
wire        WREADY_PCI;

wire [1:0]  BRESP_PCI;
wire        BVALID_PCI;
wire        BREADY_PCI;

wire [31:0] ARADDR_PCI;
wire [3:0]  ARLEN_PCI;
wire [2:0]  ARSIZE_PCI;
wire [1:0]  ARBURST_PCI;
wire        ARVALID_PCI;
wire        ARREADY_PCI;

wire [1:0]  RRESP_PCI;
wire [31:0] RDATA_PCI;
wire        RLAST_PCI;
wire        RVALID_PCI;
wire        RREADY_PCI;

// AXI Slave 0 : AHB0 Interface
wire [1:0]  AWID_AHB0;
wire [31:0] AWADDR_AHB0;
wire [3:0]  AWLEN_AHB0;
wire [2:0]  AWSIZE_AHB0;
wire [1:0]  AWBURST_AHB0;
wire        AWVALID_AHB0;
wire        AWREADY_AHB0;

wire [1:0]  WID_AHB0;
wire [31:0] WDATA_AHB0;
wire [3:0]  WSTRB_AHB0;
wire        WLAST_AHB0;
wire        WVALID_AHB0;
wire        WREADY_AHB0;

wire [1:0]  BID_AHB0;
wire [1:0]  BRESP_AHB0;
wire        BVALID_AHB0;
wire        BREADY_AHB0;

wire [1:0]  ARID_AHB0;
wire [31:0] ARADDR_AHB0;
wire [3:0]  ARLEN_AHB0;
wire [2:0]  ARSIZE_AHB0;
wire [1:0]  ARBURST_AHB0;
wire        ARVALID_AHB0;
wire        ARREADY_AHB0;

wire [1:0]  RID_AHB0;
wire [1:0]  RRESP_AHB0;
wire [31:0] RDATA_AHB0;
wire        RLAST_AHB0;
wire        RVALID_AHB0;
wire        RREADY_AHB0;

// AXI Slave 1 : AHB1 Interface
wire [1:0]  AWID_AHB1;
wire [31:0] AWADDR_AHB1;
wire [3:0]  AWLEN_AHB1;
wire [2:0]  AWSIZE_AHB1;
wire [1:0]  AWBURST_AHB1;
wire        AWVALID_AHB1;
wire        AWREADY_AHB1;

wire [1:0]  WID_AHB1;
wire [31:0] WDATA_AHB1;
wire [3:0]  WSTRB_AHB1;
wire        WLAST_AHB1;
wire        WVALID_AHB1;
wire        WREADY_AHB1;

wire [1:0]  BID_AHB1;
wire [1:0]  BRESP_AHB1;
wire        BVALID_AHB1;
wire        BREADY_AHB1;

wire [1:0]  ARID_AHB1;
wire [31:0] ARADDR_AHB1;
wire [3:0]  ARLEN_AHB1;
wire [2:0]  ARSIZE_AHB1;
wire [1:0]  ARBURST_AHB1;
wire        ARVALID_AHB1;
wire        ARREADY_AHB1;

wire [1:0]  RID_AHB1;
wire [1:0]  RRESP_AHB1;
wire [31:0] RDATA_AHB1;
wire        RLAST_AHB1;
wire        RVALID_AHB1;
wire        RREADY_AHB1;

// AXI Slave 2 : AHB2 Interface
wire [1:0]  AWID_AHB2;
wire [31:0] AWADDR_AHB2;
wire [3:0]  AWLEN_AHB2;
wire [2:0]  AWSIZE_AHB2;
wire [1:0]  AWBURST_AHB2;
wire        AWVALID_AHB2;
wire        AWREADY_AHB2;

wire [1:0]  WID_AHB2;
wire [31:0] WDATA_AHB2;
wire [3:0]  WSTRB_AHB2;
wire        WLAST_AHB2;
wire        WVALID_AHB2;
wire        WREADY_AHB2;

wire [1:0]  BID_AHB2;
wire [1:0]  BRESP_AHB2;
wire        BVALID_AHB2;
wire        BREADY_AHB2;

wire [1:0]  ARID_AHB2;
wire [31:0] ARADDR_AHB2;
wire [3:0]  ARLEN_AHB2;
wire [2:0]  ARSIZE_AHB2;
wire [1:0]  ARBURST_AHB2;
wire        ARVALID_AHB2;
wire        ARREADY_AHB2;

wire [1:0]  RID_AHB2;
wire [1:0]  RRESP_AHB2;
wire [31:0] RDATA_AHB2;
wire        RLAST_AHB2;
wire        RVALID_AHB2;
wire        RREADY_AHB2;

// AXI Slave 3 : DDRAM
wire [2:0]  AWID_DDR;
wire [31:0] AWADDR_DDR;
wire [3:0]  AWLEN_DDR;
wire [2:0]  AWSIZE_DDR;
wire [1:0]  AWBURST_DDR;
wire        AWVALID_DDR;
wire        AWREADY_DDR;

wire [2:0]  WID_DDR;
wire [31:0] WDATA_DDR;
wire [3:0]  WSTRB_DDR;
wire        WLAST_DDR;
wire        WVALID_DDR;
wire        WREADY_DDR;

wire [2:0]  BID_DDR;
wire [1:0]  BRESP_DDR;
wire        BVALID_DDR;
wire        BREADY_DDR;

wire [3:0]  ARID_DDR;
wire [31:0] ARADDR_DDR;
wire [3:0]  ARLEN_DDR;
wire [2:0]  ARSIZE_DDR;
wire [1:0]  ARBURST_DDR;
wire        ARVALID_DDR;
wire        ARREADY_DDR;

wire [4:0]  RID_DDR;
wire [1:0]  RRESP_DDR;
wire [31:0] RDATA_DDR;
wire        RLAST_DDR;
wire        RVALID_DDR;
wire        RREADY_DDR;

// AXI Slave 4 : APB0 Interface
wire [1:0]  AWID_APB0;
wire [31:0] AWADDR_APB0;
wire [3:0]  AWLEN_APB0;
wire [2:0]  AWSIZE_APB0;
wire [1:0]  AWBURST_APB0;
wire        AWVALID_APB0;
wire        AWREADY_APB0;

wire [1:0]  WID_APB0;
wire [31:0] WDATA_APB0;
wire [3:0]  WSTRB_APB0;
wire        WLAST_APB0;
wire        WVALID_APB0;
wire        WREADY_APB0;

wire [1:0]  BID_APB0;
wire [1:0]  BRESP_APB0;
wire        BVALID_APB0;
wire        BREADY_APB0;

wire [1:0]  ARID_APB0;
wire [31:0] ARADDR_APB0;
wire [3:0]  ARLEN_APB0;
wire [2:0]  ARSIZE_APB0;
wire [1:0]  ARBURST_APB0;
wire        ARVALID_APB0;
wire        ARREADY_APB0;

wire [1:0]  RID_APB0;
wire [1:0]  RRESP_APB0;
wire [31:0] RDATA_APB0;
wire        RLAST_APB0;
wire        RVALID_APB0;
wire        RREADY_APB0;

// AXI Slave 5 : APB1 Interface
wire [1:0]  AWID_APB1;
wire [31:0] AWADDR_APB1;
wire [3:0]  AWLEN_APB1;
wire [2:0]  AWSIZE_APB1;
wire [1:0]  AWBURST_APB1;
wire        AWVALID_APB1;
wire        AWREADY_APB1;

wire [1:0]  WID_APB1;
wire [31:0] WDATA_APB1;
wire [3:0]  WSTRB_APB1;
wire        WLAST_APB1;
wire        WVALID_APB1;
wire        WREADY_APB1;

wire [1:0]  BID_APB1;
wire [1:0]  BRESP_APB1;
wire        BVALID_APB1;
wire        BREADY_APB1;

wire [1:0]  ARID_APB1;
wire [31:0] ARADDR_APB1;
wire [3:0]  ARLEN_APB1;
wire [2:0]  ARSIZE_APB1;
wire [1:0]  ARBURST_APB1;
wire        ARVALID_APB1;
wire        ARREADY_APB1;

wire [1:0]  RID_APB1;
wire [1:0]  RRESP_APB1;
wire [31:0] RDATA_APB1;
wire        RLAST_APB1;
wire        RVALID_APB1;
wire        RREADY_APB1;

// AXI Slave 6 : Exnternal SMC
wire [2:0]  AWID_SMC;
wire [31:0] AWADDR_SMC;
wire [3:0]  AWLEN_SMC;
wire [2:0]  AWSIZE_SMC;
wire [1:0]  AWBURST_SMC;
wire        AWVALID_SMC;
wire        AWREADY_SMC;

wire [2:0]  WID_SMC;
wire [31:0] WDATA_SMC;
wire [3:0]  WSTRB_SMC;
wire        WLAST_SMC;
wire        WVALID_SMC;
wire        WREADY_SMC;

wire [3:0]  BID_SMC;
wire [1:0]  BRESP_SMC;
wire        BVALID_SMC;
wire        BREADY_SMC;

wire [3:0]  ARID_SMC;
wire [31:0] ARADDR_SMC;
wire [3:0]  ARLEN_SMC;
wire [2:0]  ARSIZE_SMC;
wire [1:0]  ARBURST_SMC;
wire        ARVALID_SMC;
wire        ARREADY_SMC;

wire [3:0]  RID_SMC;
wire [1:0]  RRESP_SMC;
wire [31:0] RDATA_SMC;
wire        RLAST_SMC;
wire        RVALID_SMC;
wire        RREADY_SMC;

// AXI Slave 7 : Internal SRAM
wire [2:0]  AWID_SSRAM;
wire [31:0] AWADDR_SSRAM;
wire [3:0]  AWLEN_SSRAM;
wire [2:0]  AWSIZE_SSRAM;
wire [1:0]  AWBURST_SSRAM;
wire        AWVALID_SSRAM;
wire        AWREADY_SSRAM;

wire [2:0]  WID_SSRAM;
wire [31:0] WDATA_SSRAM;
wire [3:0]  WSTRB_SSRAM;
wire        WLAST_SSRAM;
wire        WVALID_SSRAM;
wire        WREADY_SSRAM;

wire [3:0]  BID_SSRAM;
wire [1:0]  BRESP_SSRAM;
wire        BVALID_SSRAM;
wire        BREADY_SSRAM;

wire [3:0]  ARID_SSRAM;
wire [31:0] ARADDR_SSRAM;
wire [3:0]  ARLEN_SSRAM;
wire [2:0]  ARSIZE_SSRAM;
wire [1:0]  ARBURST_SSRAM;
wire        ARVALID_SSRAM;
wire        ARREADY_SSRAM;

wire [3:0]  RID_SSRAM;
wire [1:0]  RRESP_SSRAM;
wire [31:0] RDATA_SSRAM;
wire        RLAST_SSRAM;
wire        RVALID_SSRAM;
wire        RREADY_SSRAM;

// APB0 signals
wire [31:0] PADDR0;
wire        PWRITE0;
wire        PENABLE0;
wire [31:0] PWDATA0;
wire        PSEL0_0;
wire        PSEL0_1;
wire        PSEL0_2;
wire        PSEL0_3;
wire        PSEL0_4;
wire        PSEL0_5;
wire        PSEL0_6;
wire        PSEL0_7;
wire [31:0] PRDATA0_0;
wire [31:0] PRDATA0_1;
wire [31:0] PRDATA0_2;
wire [31:0] PRDATA0_3;
wire [31:0] PRDATA0_4;
wire [31:0] PRDATA0_5;
wire [31:0] PRDATA0_6;
wire [31:0] PRDATA0_7;
wire        PREADY0_0;
wire        PREADY0_1;
wire        PREADY0_2;
wire        PREADY0_3;
wire        PREADY0_4;
wire        PREADY0_5;
wire        PREADY0_6;
wire        PREADY0_7;

// APB1 signals
wire [31:0] PADDR1;
wire        PWRITE1;
wire        PENABLE1;
wire [31:0] PWDATA1;
wire        PSEL1_0;
wire        PSEL1_1;
wire        PSEL1_2;
wire        PSEL1_3;
wire        PSEL1_4;
wire        PSEL1_5;
wire        PSEL1_6;
wire        PSEL1_7;
wire        PSEL1_8;
wire        PSEL1_9;
wire        PSEL1_A;
wire        PSEL1_B;
wire        PSEL1_C;
wire        PSEL1_D;
wire        PSEL1_E;
wire        PSEL1_F;
wire [31:0] PRDATA1_0;
wire [31:0] PRDATA1_1;
wire [31:0] PRDATA1_2;
wire [31:0] PRDATA1_3;
wire [31:0] PRDATA1_4;
wire [31:0] PRDATA1_5;
wire [31:0] PRDATA1_6;
wire [31:0] PRDATA1_7;
wire [31:0] PRDATA1_8;
wire [31:0] PRDATA1_9;
wire [31:0] PRDATA1_A;
wire [31:0] PRDATA1_B;
wire [31:0] PRDATA1_C;
wire [31:0] PRDATA1_D;
wire [31:0] PRDATA1_E;
wire [31:0] PRDATA1_F;
wire        PREADY1_0;
wire        PREADY1_1;
wire        PREADY1_2;
wire        PREADY1_3;
wire        PREADY1_4;
wire        PREADY1_5;
wire        PREADY1_6;
wire        PREADY1_7;
wire        PREADY1_8;
wire        PREADY1_9;
wire        PREADY1_A;
wire        PREADY1_B;
wire        PREADY1_C;
wire        PREADY1_D;
wire        PREADY1_E;
wire        PREADY1_F;

//////////////////////////////////////////////////////////////////////
// AXI BUS
//////////////////////////////////////////////////////////////////////
SBUS SBUS(

//MASTER channel signal
    //_______________________________________________________________
    //For Master 0 :: ARMD
    //Write address channel

//Disable_id_port
    .AWADDR_ARMD  (AWADDR_ARMD  ),
    .AWLEN_ARMD   (AWLEN_ARMD   ),
    .AWSIZE_ARMD  (AWSIZE_ARMD  ),
    .AWBURST_ARMD (AWBURST_ARMD ),
    .AWLOCK_ARMD  (AWLOCK_ARMD  ),
//Disable_cache_port
//Disable_protect_port

    .AWVALID_ARMD (AWVALID_ARMD ),
    .AWREADY_2_ARMD   (AWREADY_ARMD ),

    //Write data channel
//Disable_id_port
    .WDATA_ARMD       (WDATA_ARMD   ),
    .WSTRB_ARMD       (WSTRB_ARMD   ),
    .WLAST_ARMD       (WLAST_ARMD   ),
    .WVALID_ARMD      (WVALID_ARMD  ),
    .WREADY_2_ARMD    (WREADY_ARMD),

    //Write response channel
//Disable_id_port
    .BRESP_2_ARMD     (BRESP_ARMD   ),
    .BVALID_2_ARMD    (BVALID_ARMD  ),
    .BREADY_ARMD      (BREADY_ARMD    ),


    //Read address channel
//Disable_id_port
    .ARADDR_ARMD  (ARADDR_ARMD  ),
    .ARLEN_ARMD   (ARLEN_ARMD   ),
    .ARSIZE_ARMD  (ARSIZE_ARMD  ),
    .ARBURST_ARMD (ARBURST_ARMD ),
    .ARLOCK_ARMD  (ARLOCK_ARMD  ),
//Disable_cache_port
//Disable_protect_port

    .ARVALID_ARMD (ARVALID_ARMD ),
    .ARREADY_2_ARMD (ARREADY_ARMD ),

    //Read data channel
//Disable_id_port
    .RRESP_2_ARMD   (RRESP_ARMD   ),
    .RDATA_2_ARMD   (RDATA_ARMD   ),
    .RLAST_2_ARMD   (RLAST_ARMD   ),
    .RVALID_2_ARMD  (RVALID_ARMD  ),
    .RREADY_ARMD  (RREADY_ARMD  ),

    //_______________________________________________________________
    //For Master 1 :: ARMI
    //Write address channel

    //Read address channel
//Disable_id_port
    .ARADDR_ARMI  (ARADDR_ARMI  ),
    .ARLEN_ARMI   (ARLEN_ARMI   ),
    .ARSIZE_ARMI  (ARSIZE_ARMI  ),
    .ARBURST_ARMI (ARBURST_ARMI ),
    .ARLOCK_ARMI  (ARLOCK_ARMI  ),
//Disable_cache_port
//Disable_protect_port

    .ARVALID_ARMI (ARVALID_ARMI ),
    .ARREADY_2_ARMI (ARREADY_ARMI ),

    //Read data channel
//Disable_id_port
    .RRESP_2_ARMI   (RRESP_ARMI   ),
    .RDATA_2_ARMI   (RDATA_ARMI   ),
    .RLAST_2_ARMI   (RLAST_ARMI   ),
    .RVALID_2_ARMI  (RVALID_ARMI  ),
    .RREADY_ARMI  (RREADY_ARMI  ),

    //_______________________________________________________________
    //For Master 2 :: DMAC
    //Write address channel

    .AWID_DMAC    (AWID_DMAC    ),
    .AWADDR_DMAC  (AWADDR_DMAC  ),
    .AWLEN_DMAC   (AWLEN_DMAC   ),
    .AWSIZE_DMAC  (AWSIZE_DMAC  ),
    .AWBURST_DMAC (AWBURST_DMAC ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .AWVALID_DMAC (AWVALID_DMAC ),
    .AWREADY_2_DMAC   (AWREADY_DMAC ),

    //Write data channel
    .WID_DMAC         (WID_DMAC     ),
    .WDATA_DMAC       (WDATA_DMAC   ),
    .WSTRB_DMAC       (WSTRB_DMAC   ),
    .WLAST_DMAC       (WLAST_DMAC   ),
    .WVALID_DMAC      (WVALID_DMAC  ),
    .WREADY_2_DMAC    (WREADY_DMAC),

    //Write response channel
    .BID_2_DMAC       (BID_DMAC     ),
    .BRESP_2_DMAC     (BRESP_DMAC   ),
    .BVALID_2_DMAC    (BVALID_DMAC  ),
    .BREADY_DMAC      (BREADY_DMAC    ),


    //Read address channel
    .ARID_DMAC    (ARID_DMAC    ),
    .ARADDR_DMAC  (ARADDR_DMAC  ),
    .ARLEN_DMAC   (ARLEN_DMAC   ),
    .ARSIZE_DMAC  (ARSIZE_DMAC  ),
    .ARBURST_DMAC (ARBURST_DMAC ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_DMAC (ARVALID_DMAC ),
    .ARREADY_2_DMAC (ARREADY_DMAC ),

    //Read data channel
    .RID_2_DMAC     (RID_DMAC     ),
    .RRESP_2_DMAC   (RRESP_DMAC   ),
    .RDATA_2_DMAC   (RDATA_DMAC   ),
    .RLAST_2_DMAC   (RLAST_DMAC   ),
    .RVALID_2_DMAC  (RVALID_DMAC  ),
    .RREADY_DMAC  (RREADY_DMAC  ),

    //_______________________________________________________________
    //For Master 3 :: MAC
    //Write address channel

//Disable_id_port
    .AWADDR_MAC  (AWADDR_MAC  ),
    .AWLEN_MAC   (AWLEN_MAC   ),
    .AWSIZE_MAC  (AWSIZE_MAC  ),
    .AWBURST_MAC (AWBURST_MAC ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .AWVALID_MAC (AWVALID_MAC ),
    .AWREADY_2_MAC   (AWREADY_MAC ),

    //Write data channel
//Disable_id_port
    .WDATA_MAC       (WDATA_MAC   ),
    .WSTRB_MAC       (WSTRB_MAC   ),
    .WLAST_MAC       (WLAST_MAC   ),
    .WVALID_MAC      (WVALID_MAC  ),
    .WREADY_2_MAC    (WREADY_MAC),

    //Write response channel
//Disable_id_port
    .BRESP_2_MAC     (BRESP_MAC   ),
    .BVALID_2_MAC    (BVALID_MAC  ),
    .BREADY_MAC      (BREADY_MAC    ),


    //Read address channel
//Disable_id_port
    .ARADDR_MAC  (ARADDR_MAC  ),
    .ARLEN_MAC   (ARLEN_MAC   ),
    .ARSIZE_MAC  (ARSIZE_MAC  ),
    .ARBURST_MAC (ARBURST_MAC ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_MAC (ARVALID_MAC ),
    .ARREADY_2_MAC (ARREADY_MAC ),

    //Read data channel
//Disable_id_port
    .RRESP_2_MAC   (RRESP_MAC   ),
    .RDATA_2_MAC   (RDATA_MAC   ),
    .RLAST_2_MAC   (RLAST_MAC   ),
    .RVALID_2_MAC  (RVALID_MAC  ),
    .RREADY_MAC  (RREADY_MAC  ),

    //_______________________________________________________________
    //For Master 4 :: PCI
    //Write address channel

//Disable_id_port
    .AWADDR_PCI  (AWADDR_PCI  ),
    .AWLEN_PCI   (AWLEN_PCI   ),
    .AWSIZE_PCI  (AWSIZE_PCI  ),
    .AWBURST_PCI (AWBURST_PCI ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .AWVALID_PCI (AWVALID_PCI ),
    .AWREADY_2_PCI   (AWREADY_PCI ),

    //Write data channel
//Disable_id_port
    .WDATA_PCI       (WDATA_PCI   ),
    .WSTRB_PCI       (WSTRB_PCI   ),
    .WLAST_PCI       (WLAST_PCI   ),
    .WVALID_PCI      (WVALID_PCI  ),
    .WREADY_2_PCI    (WREADY_PCI),

    //Write response channel
//Disable_id_port
    .BRESP_2_PCI     (BRESP_PCI   ),
    .BVALID_2_PCI    (BVALID_PCI  ),
    .BREADY_PCI      (BREADY_PCI    ),


    //Read address channel
//Disable_id_port
    .ARADDR_PCI  (ARADDR_PCI  ),
    .ARLEN_PCI   (ARLEN_PCI   ),
    .ARSIZE_PCI  (ARSIZE_PCI  ),
    .ARBURST_PCI (ARBURST_PCI ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_PCI (ARVALID_PCI ),
    .ARREADY_2_PCI (ARREADY_PCI ),

    //Read data channel
//Disable_id_port
    .RRESP_2_PCI   (RRESP_PCI   ),
    .RDATA_2_PCI   (RDATA_PCI   ),
    .RLAST_2_PCI   (RLAST_PCI   ),
    .RVALID_2_PCI  (RVALID_PCI  ),
    .RREADY_PCI  (RREADY_PCI  ),


//SLAVE channel signal
    //_______________________________________________________________
    //For Slave 0 :: AHB0
    //Write address channel
    .AWID_2_AHB0    (AWID_AHB0    ),
    .AWADDR_2_AHB0  (AWADDR_AHB0  ),
    .AWLEN_2_AHB0   (AWLEN_AHB0   ),
    .AWSIZE_2_AHB0  (AWSIZE_AHB0  ),
    .AWBURST_2_AHB0 (AWBURST_AHB0 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_AHB0 (AWVALID_AHB0 ),
    .AWREADY_AHB0 (AWREADY_AHB0 ),

    //Write data channel
    .WID_2_AHB0     (WID_AHB0     ),
    .WDATA_2_AHB0   (WDATA_AHB0   ),
//Disable_WSTRB_port
    .WLAST_2_AHB0   (WLAST_AHB0   ),
    .WVALID_2_AHB0  (WVALID_AHB0  ),
    .WREADY_AHB0  (WREADY_AHB0  ),

    //Write response channel
    .BID_AHB0     (BID_AHB0     ),
    .BRESP_AHB0   (BRESP_AHB0   ),
    .BVALID_AHB0  (BVALID_AHB0  ),
    .BREADY_2_AHB0  (BREADY_AHB0  ),

    //Read channel signal
    .ARID_2_AHB0    (ARID_AHB0    ),
    .ARADDR_2_AHB0  (ARADDR_AHB0  ),
    .ARLEN_2_AHB0   (ARLEN_AHB0   ),
    .ARSIZE_2_AHB0  (ARSIZE_AHB0  ),
    .ARBURST_2_AHB0 (ARBURST_AHB0 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_AHB0 (ARVALID_AHB0 ),
    .ARREADY_AHB0   (ARREADY_AHB0 ),

    //Read data channel
    .RID_AHB0       (RID_AHB0     ),
    .RRESP_AHB0     (RRESP_AHB0   ),
    .RDATA_AHB0     (RDATA_AHB0  ),
    .RLAST_AHB0     (RLAST_AHB0  ),
    .RVALID_AHB0    (RVALID_AHB0  ),
    .RREADY_2_AHB0  (RREADY_AHB0  ),
    //_______________________________________________________________
    //For Slave 1 :: AHB1
    //Write address channel
    .AWID_2_AHB1    (AWID_AHB1    ),
    .AWADDR_2_AHB1  (AWADDR_AHB1  ),
    .AWLEN_2_AHB1   (AWLEN_AHB1   ),
    .AWSIZE_2_AHB1  (AWSIZE_AHB1  ),
    .AWBURST_2_AHB1 (AWBURST_AHB1 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_AHB1 (AWVALID_AHB1 ),
    .AWREADY_AHB1 (AWREADY_AHB1 ),

    //Write data channel
    .WID_2_AHB1     (WID_AHB1     ),
    .WDATA_2_AHB1   (WDATA_AHB1   ),
//Disable_WSTRB_port
    .WLAST_2_AHB1   (WLAST_AHB1   ),
    .WVALID_2_AHB1  (WVALID_AHB1  ),
    .WREADY_AHB1  (WREADY_AHB1  ),

    //Write response channel
    .BID_AHB1     (BID_AHB1     ),
    .BRESP_AHB1   (BRESP_AHB1   ),
    .BVALID_AHB1  (BVALID_AHB1  ),
    .BREADY_2_AHB1  (BREADY_AHB1  ),

    //Read channel signal
    .ARID_2_AHB1    (ARID_AHB1    ),
    .ARADDR_2_AHB1  (ARADDR_AHB1  ),
    .ARLEN_2_AHB1   (ARLEN_AHB1   ),
    .ARSIZE_2_AHB1  (ARSIZE_AHB1  ),
    .ARBURST_2_AHB1 (ARBURST_AHB1 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_AHB1 (ARVALID_AHB1 ),
    .ARREADY_AHB1   (ARREADY_AHB1 ),

    //Read data channel
    .RID_AHB1       (RID_AHB1     ),
    .RRESP_AHB1     (RRESP_AHB1   ),
    .RDATA_AHB1     (RDATA_AHB1  ),
    .RLAST_AHB1     (RLAST_AHB1  ),
    .RVALID_AHB1    (RVALID_AHB1  ),
    .RREADY_2_AHB1  (RREADY_AHB1  ),
    //_______________________________________________________________
    //For Slave 2 :: AHB2
    //Write address channel
    .AWID_2_AHB2    (AWID_AHB2    ),
    .AWADDR_2_AHB2  (AWADDR_AHB2  ),
    .AWLEN_2_AHB2   (AWLEN_AHB2   ),
    .AWSIZE_2_AHB2  (AWSIZE_AHB2  ),
    .AWBURST_2_AHB2 (AWBURST_AHB2 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_AHB2 (AWVALID_AHB2 ),
    .AWREADY_AHB2 (AWREADY_AHB2 ),

    //Write data channel
    .WID_2_AHB2     (WID_AHB2     ),
    .WDATA_2_AHB2   (WDATA_AHB2   ),
//Disable_WSTRB_port
    .WLAST_2_AHB2   (WLAST_AHB2   ),
    .WVALID_2_AHB2  (WVALID_AHB2  ),
    .WREADY_AHB2  (WREADY_AHB2  ),

    //Write response channel
    .BID_AHB2     (BID_AHB2     ),
    .BRESP_AHB2   (BRESP_AHB2   ),
    .BVALID_AHB2  (BVALID_AHB2  ),
    .BREADY_2_AHB2  (BREADY_AHB2  ),

    //Read channel signal
    .ARID_2_AHB2    (ARID_AHB2    ),
    .ARADDR_2_AHB2  (ARADDR_AHB2  ),
    .ARLEN_2_AHB2   (ARLEN_AHB2   ),
    .ARSIZE_2_AHB2  (ARSIZE_AHB2  ),
    .ARBURST_2_AHB2 (ARBURST_AHB2 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_AHB2 (ARVALID_AHB2 ),
    .ARREADY_AHB2   (ARREADY_AHB2 ),

    //Read data channel
    .RID_AHB2       (RID_AHB2     ),
    .RRESP_AHB2     (RRESP_AHB2   ),
    .RDATA_AHB2     (RDATA_AHB2  ),
    .RLAST_AHB2     (RLAST_AHB2  ),
    .RVALID_AHB2    (RVALID_AHB2  ),
    .RREADY_2_AHB2  (RREADY_AHB2  ),
    //_______________________________________________________________
    //For Slave 3 :: DDR
    //Write address channel
    .AWID_2_DDR    (AWID_DDR ),
    .AWADDR_2_DDR  (AWADDR_DDR  ),
    .AWLEN_2_DDR   (AWLEN_DDR   ),
    .AWSIZE_2_DDR  (AWSIZE_DDR  ),
    .AWBURST_2_DDR (AWBURST_DDR ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_DDR (AWVALID_DDR ),
    .AWREADY_DDR (AWREADY_DDR ),

    //Write data channel
    .WID_2_DDR     (WID_DDR     ),
    .WDATA_2_DDR   (WDATA_DDR   ),
    .WSTRB_2_DDR   (WSTRB_DDR   ),
    .WLAST_2_DDR   (WLAST_DDR   ),
    .WVALID_2_DDR  (WVALID_DDR  ),
    .WREADY_DDR  (WREADY_DDR  ),

    //Write response channel
    .BID_DDR     (BID_DDR     ),
    .BRESP_DDR   (BRESP_DDR   ),
    .BVALID_DDR  (BVALID_DDR  ),
    .BREADY_2_DDR  (BREADY_DDR  ),

    //Read channel signal
    .ARID_2_DDR    (ARID_DDR    ),
    .ARADDR_2_DDR  (ARADDR_DDR  ),
    .ARLEN_2_DDR   (ARLEN_DDR   ),
    .ARSIZE_2_DDR  (ARSIZE_DDR  ),
    .ARBURST_2_DDR (ARBURST_DDR ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_DDR (ARVALID_DDR ),
    .ARREADY_DDR   (ARREADY_DDR ),

    //Read data channel
    .RID_DDR       (RID_DDR[3:0]),
    .RRESP_DDR     (RRESP_DDR   ),
    .RDATA_DDR     (RDATA_DDR  ),
    .RLAST_DDR     (RLAST_DDR  ),
    .RVALID_DDR    (RVALID_DDR  ),
    .RREADY_2_DDR  (RREADY_DDR  ),
    //_______________________________________________________________
    //For Slave 4 :: APB0
    //Write address channel
    .AWID_2_APB0    (AWID_APB0    ),
    .AWADDR_2_APB0  (AWADDR_APB0  ),
    .AWLEN_2_APB0   (AWLEN_APB0   ),
    .AWSIZE_2_APB0  (AWSIZE_APB0  ),
    .AWBURST_2_APB0 (AWBURST_APB0 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_APB0 (AWVALID_APB0 ),
    .AWREADY_APB0 (AWREADY_APB0 ),

    //Write data channel
    .WID_2_APB0     (WID_APB0     ),
    .WDATA_2_APB0   (WDATA_APB0   ),
//Disable_WSTRB_port
    .WLAST_2_APB0   (WLAST_APB0   ),
    .WVALID_2_APB0  (WVALID_APB0  ),
    .WREADY_APB0  (WREADY_APB0  ),

    //Write response channel
    .BID_APB0     (BID_APB0     ),
    .BRESP_APB0   (BRESP_APB0   ),
    .BVALID_APB0  (BVALID_APB0  ),
    .BREADY_2_APB0  (BREADY_APB0  ),

    //Read channel signal
    .ARID_2_APB0    (ARID_APB0    ),
    .ARADDR_2_APB0  (ARADDR_APB0  ),
    .ARLEN_2_APB0   (ARLEN_APB0   ),
    .ARSIZE_2_APB0  (ARSIZE_APB0  ),
    .ARBURST_2_APB0 (ARBURST_APB0 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_APB0 (ARVALID_APB0 ),
    .ARREADY_APB0   (ARREADY_APB0 ),

    //Read data channel
    .RID_APB0       (RID_APB0     ),
    .RRESP_APB0     (RRESP_APB0   ),
    .RDATA_APB0     (RDATA_APB0  ),
    .RLAST_APB0     (RLAST_APB0  ),
    .RVALID_APB0    (RVALID_APB0  ),
    .RREADY_2_APB0  (RREADY_APB0  ),
    //_______________________________________________________________
    //For Slave 5 :: APB1
    //Write address channel
    .AWID_2_APB1    (AWID_APB1    ),
    .AWADDR_2_APB1  (AWADDR_APB1  ),
    .AWLEN_2_APB1   (AWLEN_APB1   ),
    .AWSIZE_2_APB1  (AWSIZE_APB1  ),
    .AWBURST_2_APB1 (AWBURST_APB1 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_APB1 (AWVALID_APB1 ),
    .AWREADY_APB1 (AWREADY_APB1 ),

    //Write data channel
    .WID_2_APB1     (WID_APB1     ),
    .WDATA_2_APB1   (WDATA_APB1   ),
//Disable_WSTRB_por
    .WLAST_2_APB1   (WLAST_APB1   ),
    .WVALID_2_APB1  (WVALID_APB1  ),
    .WREADY_APB1  (WREADY_APB1  ),

    //Write response channel
    .BID_APB1     (BID_APB1     ),
    .BRESP_APB1   (BRESP_APB1   ),
    .BVALID_APB1  (BVALID_APB1  ),
    .BREADY_2_APB1  (BREADY_APB1  ),

    //Read channel signal
    .ARID_2_APB1    (ARID_APB1    ),
    .ARADDR_2_APB1  (ARADDR_APB1  ),
    .ARLEN_2_APB1   (ARLEN_APB1   ),
    .ARSIZE_2_APB1  (ARSIZE_APB1  ),
    .ARBURST_2_APB1 (ARBURST_APB1 ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_APB1 (ARVALID_APB1 ),
    .ARREADY_APB1   (ARREADY_APB1 ),

    //Read data channel
    .RID_APB1       (RID_APB1     ),
    .RRESP_APB1     (RRESP_APB1   ),
    .RDATA_APB1     (RDATA_APB1  ),
    .RLAST_APB1     (RLAST_APB1  ),
    .RVALID_APB1    (RVALID_APB1  ),
    .RREADY_2_APB1  (RREADY_APB1  ),
    //_______________________________________________________________
    //For Slave 6 :: SMC
    //Write address channel
    .AWID_2_SMC    (AWID_SMC    ),
    .AWADDR_2_SMC  (AWADDR_SMC  ),
    .AWLEN_2_SMC   (AWLEN_SMC   ),
    .AWSIZE_2_SMC  (AWSIZE_SMC  ),
    .AWBURST_2_SMC (AWBURST_SMC ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_SMC (AWVALID_SMC ),
    .AWREADY_SMC (AWREADY_SMC ),

    //Write data channel
    .WID_2_SMC     (WID_SMC     ),
    .WDATA_2_SMC   (WDATA_SMC   ),
    .WSTRB_2_SMC   (WSTRB_SMC   ),
    .WLAST_2_SMC   (WLAST_SMC   ),
    .WVALID_2_SMC  (WVALID_SMC  ),
    .WREADY_SMC  (WREADY_SMC  ),

    //Write response channel
    .BID_SMC     (BID_SMC[2:0]  ),
    .BRESP_SMC   (BRESP_SMC   ),
    .BVALID_SMC  (BVALID_SMC  ),
    .BREADY_2_SMC  (BREADY_SMC  ),

    //Read channel signal
    .ARID_2_SMC    (ARID_SMC    ),
    .ARADDR_2_SMC  (ARADDR_SMC  ),
    .ARLEN_2_SMC   (ARLEN_SMC   ),
    .ARSIZE_2_SMC  (ARSIZE_SMC  ),
    .ARBURST_2_SMC (ARBURST_SMC ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_SMC (ARVALID_SMC ),
    .ARREADY_SMC   (ARREADY_SMC ),

    //Read data channel
    .RID_SMC       (RID_SMC     ),
    .RRESP_SMC     (RRESP_SMC   ),
    .RDATA_SMC     (RDATA_SMC  ),
    .RLAST_SMC     (RLAST_SMC  ),
    .RVALID_SMC    (RVALID_SMC  ),
    .RREADY_2_SMC  (RREADY_SMC  ),
    //_______________________________________________________________
    //For Slave 7 :: SSRAM
    //Write address channel
    .AWID_2_SSRAM    (AWID_SSRAM    ),
    .AWADDR_2_SSRAM  (AWADDR_SSRAM  ),
    .AWLEN_2_SSRAM   (AWLEN_SSRAM   ),
    .AWSIZE_2_SSRAM  (AWSIZE_SSRAM  ),
    .AWBURST_2_SSRAM (AWBURST_SSRAM ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port
    .AWVALID_2_SSRAM (AWVALID_SSRAM ),
    .AWREADY_SSRAM (AWREADY_SSRAM ),

    //Write data channel
    .WID_2_SSRAM     (WID_SSRAM     ),
    .WDATA_2_SSRAM   (WDATA_SSRAM   ),
    .WSTRB_2_SSRAM   (WSTRB_SSRAM   ),
    .WLAST_2_SSRAM   (WLAST_SSRAM   ),
    .WVALID_2_SSRAM  (WVALID_SSRAM  ),
    .WREADY_SSRAM  (WREADY_SSRAM  ),

    //Write response channel
    .BID_SSRAM     (BID_SSRAM[2:0]  ),
    .BRESP_SSRAM   (BRESP_SSRAM   ),
    .BVALID_SSRAM  (BVALID_SSRAM  ),
    .BREADY_2_SSRAM  (BREADY_SSRAM  ),

    //Read channel signal
    .ARID_2_SSRAM    (ARID_SSRAM    ),
    .ARADDR_2_SSRAM  (ARADDR_SSRAM  ),
    .ARLEN_2_SSRAM   (ARLEN_SSRAM   ),
    .ARSIZE_2_SSRAM  (ARSIZE_SSRAM  ),
    .ARBURST_2_SSRAM (ARBURST_SSRAM ),
//Disable_lock_port
//Disable_cache_port
//Disable_protect_port

    .ARVALID_2_SSRAM (ARVALID_SSRAM ),
    .ARREADY_SSRAM   (ARREADY_SSRAM ),

    //Read data channel
    .RID_SSRAM       (RID_SSRAM     ),
    .RRESP_SSRAM     (RRESP_SSRAM   ),
    .RDATA_SSRAM     (RDATA_SSRAM  ),
    .RLAST_SSRAM     (RLAST_SSRAM  ),
    .RVALID_SSRAM    (RVALID_SSRAM  ),
    .RREADY_2_SSRAM  (RREADY_SSRAM  ),

    .ACLK    (ACLK_BUS),
    .ARESETn (ARESETn),
    .SelMAP1 (NF_Boot)
);



//////////////////////////////////////////////////////////////////////
// AXI Master0/1 : ARM
//////////////////////////////////////////////////////////////////////
wire ARMnFIQ;		// ARM FIQ
wire ARMnIRQ;		// ARM IRQ

wire DBGnTRST;
wire DBGTCKEN;
wire DBGTDI;
wire DBGTMS;
wire DBGTDO;

wire SCANENABLE = 1'b0;
wire INTEST = 1'b0;
wire EXTEST = 1'b0;
wire TESTMODE = 1'b0;

arm_axi CPU
(
		.ACLK_CPU(ACLK_CPU),
		.ACLK_BUS(ACLK_BUS),
		.BusClockEn(BusClockEn),
		.ARESETn(ARMnRESET),
		.VINITHI(1'b0),
   
		.ARMnFIQ(ARMnFIQ),
		.ARMnIRQ(ARMnIRQ),
   
		.ARADDR_ARMI(ARADDR_ARMI),
		.ARLEN_ARMI(ARLEN_ARMI),
		.ARSIZE_ARMI(ARSIZE_ARMI),
		.ARBURST_ARMI(ARBURST_ARMI),
		.ARLOCK_ARMI(ARLOCK_ARMI),
		.ARVALID_ARMI(ARVALID_ARMI),
		.ARREADY_2_ARMI(ARREADY_ARMI),
   
		.RRESP_2_ARMI(RRESP_ARMI),
		.RDATA_2_ARMI(RDATA_ARMI),
		.RLAST_2_ARMI(RLAST_ARMI),
		.RVALID_2_ARMI(RVALID_ARMI),
		.RREADY_ARMI(RREADY_ARMI),
   
		.ARADDR_ARMD(ARADDR_ARMD),
		.ARLEN_ARMD(ARLEN_ARMD),
		.ARSIZE_ARMD(ARSIZE_ARMD),
		.ARBURST_ARMD(ARBURST_ARMD),
		.ARLOCK_ARMD(ARLOCK_ARMD),
   
		.ARVALID_ARMD(ARVALID_ARMD),
		.ARREADY_2_ARMD(ARREADY_ARMD),
   
		.RRESP_2_ARMD(RRESP_ARMD),
		.RDATA_2_ARMD(RDATA_ARMD),
		.RLAST_2_ARMD(RLAST_ARMD),
		.RVALID_2_ARMD(RVALID_ARMD),
		.RREADY_ARMD(RREADY_ARMD),
   
		.AWADDR_ARMD(AWADDR_ARMD),
		.AWLEN_ARMD(AWLEN_ARMD),
		.AWSIZE_ARMD(AWSIZE_ARMD),
		.AWBURST_ARMD(AWBURST_ARMD),
		.AWLOCK_ARMD(AWLOCK_ARMD),
		.AWVALID_ARMD(AWVALID_ARMD),
		.AWREADY_2_ARMD(AWREADY_ARMD),
   
		.WDATA_ARMD(WDATA_ARMD),
		.WSTRB_ARMD(WSTRB_ARMD),
		.WLAST_ARMD(WLAST_ARMD),
		.WVALID_ARMD(WVALID_ARMD),
		.WREADY_2_ARMD(WREADY_ARMD),
   
		.BRESP_2_ARMD(BRESP_ARMD),
		.BVALID_2_ARMD(BVALID_ARMD),
		.BREADY_ARMD(BREADY_ARMD),
   
   `ifdef FPGA
		.DBG0                ,       // FPGA debug 
		.DBG1                ,       // FPGA debug 
		.DSWITCH             ,    // FPGA debug  (from DIP switches)
   `endif
   
		//ATPG
		.SCANENABLE(SCANENABLE),
		.INTEST(INTEST),
		.EXTEST(EXTEST),
		.TESTMODE(TESTMODE),
   
		// Debug JTAG signals
		.DBGnTRST(DBGnTRST),
		.DBGTCKEN(DBGTCKEN),
		.DBGTDI(DBGTDI),
		.DBGTMS(DBGTMS),
		.DBGTDO(DBGTDO),
		.EDBGRQ(1'b0),
		.DBGACK(),
		.DBGIR()
);

// ARM JTAG Sync
jtag_sync      arm_jtag_sync
(
		.clk             ( ACLK_CPU ),
		.rstb            ( ARESETn ),

		// External JTAG signal
		.etrstb          ( ARMICE_nTRST ),
		.etclk           ( ARMICE_TCK ),
		.ertclk          ( ARMICE_RTCK ),
		.etms            ( ARMICE_TMS ),
		.etdi            ( ARMICE_TDI ),
		.etdo            ( ARMICE_TDO ),

		// ARM JTAG signal
		.DBGnTRST        ( DBGnTRST ),
		.DBGTCKEN        ( DBGTCKEN ),
		.DBGTDI          ( DBGTDI ),
		.DBGTMS          ( DBGTMS ),
		.DBGTDO          ( DBGTDO )
);



//////////////////////////////////////////////////////////////////////
// AXI Master2 : DMA Controller
//////////////////////////////////////////////////////////////////////
reg  [7:0] DMAReq;			// DMA Channel Request Signal
wire [7:0] DMAAck;			// DMA Channel Ack Signal
wire [7:0] DMAInterrupt;	// DMA Interrupt

assign NF_DMADone = DMAInterrupt[0];
Dmac2x4Ch DMACtrl
(
		.ACLK(ACLK_BUS),
		.ARESETn(ARESETn),

		.DMA_BOOT(NF_Boot),
		.DMA_BOOT_SRC(32'h40008004),		// from NAND DATA
		.DMA_BOOT_DST(32'h00000000),		// to Address 0
		.DMA_BOOT_CTRL(32'h0B502000),		// 8KB
		
		.DMAReq(DMAReq),
		.DMAAck(DMAAck),
		.Interrupt(DMAInterrupt),

		.PENABLE(PENABLE0),
		.PSEL(PSEL0_3),
		.PWRITE(PWRITE0),
		.PADDR(PADDR0[7:2]),
		.PWDATA(PWDATA0),
		.PRDATA(PRDATA0_3),

		.ARID(ARID_DMAC),
		.ARVALID(ARVALID_DMAC),
		.ARREADY(ARREADY_DMAC),
		.ARADDR(ARADDR_DMAC),
		.ARLEN(ARLEN_DMAC),
		.ARSIZE(ARSIZE_DMAC),
		.ARBURST(ARBURST_DMAC),

		.RID(RID_DMAC),
		.RDATA(RDATA_DMAC),
		.RRESP(RRESP_DMAC),
		.RLAST(RLAST_DMAC),
		.RVALID(RVALID_DMAC),
		.RREADY(RREADY_DMAC),

		.AWID(AWID_DMAC),
		.AWVALID(AWVALID_DMAC),
		.AWREADY(AWREADY_DMAC),
		.AWADDR(AWADDR_DMAC),
		.AWLEN(AWLEN_DMAC),
		.AWSIZE(AWSIZE_DMAC),
		.AWBURST(AWBURST_DMAC),

		.WID(WID_DMAC),
		.WDATA(WDATA_DMAC),
		.WSTRB(WSTRB_DMAC),
		.WLAST(WLAST_DMAC),
		.WVALID(WVALID_DMAC),
		.WREADY(WREADY_DMAC),

		.BID(BID_DMAC),
		.BRESP(BRESP_DMAC),
		.BVALID(BVALID_DMAC),
		.BREADY(BREADY_DMAC)
);

// DMA Request Signal Mux
wire [31:0] DMAMux;
wire I2STxDMAReq;
wire I2SRxDMAReq;
wire [3:0] UartTxDMAReq;
wire [3:0] UartRxDMAReq;
wire SEIPTxDMAReq = 1'b0;
wire SEIPRxDMAReq = 1'b0;
wire SPI0TxDMAReq = 1'b0;
wire SPI0RxDMAReq = 1'b0;
wire NFDMAReq;
wire MMCDMAReq;

// DMA Mux
always @(DMAMux or NFDMAReq or SEIPRxDMAReq or SEIPTxDMAReq or I2STxDMAReq or I2SRxDMAReq or UartTxDMAReq or UartRxDMAReq or SPI0TxDMAReq or SPI0RxDMAReq or MMCDMAReq)
begin
	// DMA Channel 0
	case(DMAMux[3:0])
	4'b0000 : DMAReq[0] = NFDMAReq;
	4'b0001 : DMAReq[0] = SEIPTxDMAReq;
	4'b0010 : DMAReq[0] = SEIPRxDMAReq;
	4'b0011 : DMAReq[0] = I2STxDMAReq;
	4'b0100 : DMAReq[0] = I2SRxDMAReq;
	4'b0101 : DMAReq[0] = SPI0TxDMAReq;
	4'b0110 : DMAReq[0] = SPI0RxDMAReq;
	4'b0111 : DMAReq[0] = UartTxDMAReq[0];
	4'b1000 : DMAReq[0] = UartRxDMAReq[0];
	4'b1001 : DMAReq[0] = UartTxDMAReq[1];
	4'b1010 : DMAReq[0] = UartRxDMAReq[1];
	4'b1011 : DMAReq[0] = MMCDMAReq;
	default : DMAReq[0] = 0;
	endcase;
end

always @(DMAMux or NFDMAReq or SEIPRxDMAReq or SEIPTxDMAReq or I2STxDMAReq or I2SRxDMAReq or UartTxDMAReq or UartRxDMAReq or SPI0TxDMAReq or SPI0RxDMAReq or MMCDMAReq)
begin
	// DMA Channel 1
	case(DMAMux[7:4])
	4'b0000 : DMAReq[1] = NFDMAReq;
	4'b0001 : DMAReq[1] = SEIPTxDMAReq;
	4'b0010 : DMAReq[1] = SEIPRxDMAReq;
	4'b0011 : DMAReq[1] = I2STxDMAReq;
	4'b0100 : DMAReq[1] = I2SRxDMAReq;
	4'b0101 : DMAReq[1] = SPI0TxDMAReq;
	4'b0110 : DMAReq[1] = SPI0RxDMAReq;
	4'b0111 : DMAReq[1] = UartTxDMAReq[0];
	4'b1000 : DMAReq[1] = UartRxDMAReq[0];
	4'b1001 : DMAReq[1] = UartTxDMAReq[1];
	4'b1010 : DMAReq[1] = UartRxDMAReq[1];
	4'b1011 : DMAReq[1] = MMCDMAReq;
	default : DMAReq[1] = 0;
	endcase;
end

always @(DMAMux or NFDMAReq or SEIPRxDMAReq or SEIPTxDMAReq or I2STxDMAReq or I2SRxDMAReq or UartTxDMAReq or UartRxDMAReq or SPI0TxDMAReq or SPI0RxDMAReq or MMCDMAReq)
begin
	// DMA Channel 2
	case(DMAMux[11:8])
	4'b0000 : DMAReq[2] = NFDMAReq;
	4'b0001 : DMAReq[2] = SEIPTxDMAReq;
	4'b0010 : DMAReq[2] = SEIPRxDMAReq;
	4'b0011 : DMAReq[2] = I2STxDMAReq;
	4'b0100 : DMAReq[2] = I2SRxDMAReq;
	4'b0101 : DMAReq[2] = SPI0TxDMAReq;
	4'b0110 : DMAReq[2] = SPI0RxDMAReq;
	4'b0111 : DMAReq[2] = UartTxDMAReq[0];
	4'b1000 : DMAReq[2] = UartRxDMAReq[0];
	4'b1001 : DMAReq[2] = UartTxDMAReq[1];
	4'b1010 : DMAReq[2] = UartRxDMAReq[1];
	4'b1011 : DMAReq[2] = MMCDMAReq;
	default : DMAReq[2] = 0;
	endcase;
end

always @(DMAMux or NFDMAReq or SEIPRxDMAReq or SEIPTxDMAReq or I2STxDMAReq or I2SRxDMAReq or UartTxDMAReq or UartRxDMAReq or SPI0TxDMAReq or SPI0RxDMAReq or MMCDMAReq)
begin
	// DMA Channel 3
	case(DMAMux[15:12])
	4'b0000 : DMAReq[3] = NFDMAReq;
	4'b0001 : DMAReq[3] = SEIPTxDMAReq;
	4'b0010 : DMAReq[3] = SEIPRxDMAReq;
	4'b0011 : DMAReq[3] = I2STxDMAReq;
	4'b0100 : DMAReq[3] = I2SRxDMAReq;
	4'b0101 : DMAReq[3] = SPI0TxDMAReq;
	4'b0110 : DMAReq[3] = SPI0RxDMAReq;
	4'b0111 : DMAReq[3] = UartTxDMAReq[0];
	4'b1000 : DMAReq[3] = UartRxDMAReq[0];
	4'b1001 : DMAReq[3] = UartTxDMAReq[1];
	4'b1010 : DMAReq[3] = UartRxDMAReq[1];
	4'b1011 : DMAReq[3] = MMCDMAReq;
	default : DMAReq[3] = 0;
	endcase;
end

always @(DMAMux or NFDMAReq or SEIPRxDMAReq or SEIPTxDMAReq or I2STxDMAReq or I2SRxDMAReq or UartTxDMAReq or UartRxDMAReq or SPI0TxDMAReq or SPI0RxDMAReq or MMCDMAReq)
begin
	// DMA Channel 4
	case(DMAMux[19:16])
	4'b0000 : DMAReq[4] = NFDMAReq;
	4'b0001 : DMAReq[4] = SEIPTxDMAReq;
	4'b0010 : DMAReq[4] = SEIPRxDMAReq;
	4'b0011 : DMAReq[4] = I2STxDMAReq;
	4'b0100 : DMAReq[4] = I2SRxDMAReq;
	4'b0101 : DMAReq[4] = SPI0TxDMAReq;
	4'b0110 : DMAReq[4] = SPI0RxDMAReq;
	4'b0111 : DMAReq[4] = UartTxDMAReq[0];
	4'b1000 : DMAReq[4] = UartRxDMAReq[0];
	4'b1001 : DMAReq[4] = UartTxDMAReq[1];
	4'b1010 : DMAReq[4] = UartRxDMAReq[1];
	4'b1011 : DMAReq[4] = MMCDMAReq;
	default : DMAReq[4] = 0;
	endcase;
end

always @(DMAMux or NFDMAReq or SEIPRxDMAReq or SEIPTxDMAReq or I2STxDMAReq or I2SRxDMAReq or UartTxDMAReq or UartRxDMAReq or SPI0TxDMAReq or SPI0RxDMAReq or MMCDMAReq)
begin
	// DMA Channel 5
	case(DMAMux[23:20])
	4'b0000 : DMAReq[5] = NFDMAReq;
	4'b0001 : DMAReq[5] = SEIPTxDMAReq;
	4'b0010 : DMAReq[5] = SEIPRxDMAReq;
	4'b0011 : DMAReq[5] = I2STxDMAReq;
	4'b0100 : DMAReq[5] = I2SRxDMAReq;
	4'b0101 : DMAReq[5] = SPI0TxDMAReq;
	4'b0110 : DMAReq[5] = SPI0RxDMAReq;
	4'b0111 : DMAReq[5] = UartTxDMAReq[0];
	4'b1000 : DMAReq[5] = UartRxDMAReq[0];
	4'b1001 : DMAReq[5] = UartTxDMAReq[1];
	4'b1010 : DMAReq[5] = UartRxDMAReq[1];
	4'b1011 : DMAReq[5] = MMCDMAReq;
	default : DMAReq[5] = 0;
	endcase;
end

always @(DMAMux or NFDMAReq or SEIPRxDMAReq or SEIPTxDMAReq or I2STxDMAReq or I2SRxDMAReq or UartTxDMAReq or UartRxDMAReq or SPI0TxDMAReq or SPI0RxDMAReq or MMCDMAReq)
begin
	// DMA Channel 6
	case(DMAMux[27:24])
	4'b0000 : DMAReq[6] = NFDMAReq;
	4'b0001 : DMAReq[6] = SEIPTxDMAReq;
	4'b0010 : DMAReq[6] = SEIPRxDMAReq;
	4'b0011 : DMAReq[6] = I2STxDMAReq;
	4'b0100 : DMAReq[6] = I2SRxDMAReq;
	4'b0101 : DMAReq[6] = SPI0TxDMAReq;
	4'b0110 : DMAReq[6] = SPI0RxDMAReq;
	4'b0111 : DMAReq[6] = UartTxDMAReq[0];
	4'b1000 : DMAReq[6] = UartRxDMAReq[0];
	4'b1001 : DMAReq[6] = UartTxDMAReq[1];
	4'b1010 : DMAReq[6] = UartRxDMAReq[1];
	4'b1011 : DMAReq[6] = MMCDMAReq;
	default : DMAReq[6] = 0;
	endcase;
end

always @(DMAMux or NFDMAReq or SEIPRxDMAReq or SEIPTxDMAReq or I2STxDMAReq or I2SRxDMAReq or UartTxDMAReq or UartRxDMAReq or SPI0TxDMAReq or SPI0RxDMAReq or MMCDMAReq)
begin
	// DMA Channel 7
	case(DMAMux[31:28])
	4'b0000 : DMAReq[7] = NFDMAReq;
	4'b0001 : DMAReq[7] = SEIPTxDMAReq;
	4'b0010 : DMAReq[7] = SEIPRxDMAReq;
	4'b0011 : DMAReq[7] = I2STxDMAReq;
	4'b0100 : DMAReq[7] = I2SRxDMAReq;
	4'b0101 : DMAReq[7] = SPI0TxDMAReq;
	4'b0110 : DMAReq[7] = SPI0RxDMAReq;
	4'b0111 : DMAReq[7] = UartTxDMAReq[0];
	4'b1000 : DMAReq[7] = UartRxDMAReq[0];
	4'b1001 : DMAReq[7] = UartTxDMAReq[1];
	4'b1010 : DMAReq[7] = UartRxDMAReq[1];
	4'b1011 : DMAReq[7] = MMCDMAReq;
	default : DMAReq[7] = 0;
	endcase;
end

//////////////////////////////////////////////////////////////////////
// AXI Master3 : MAC Controller
//////////////////////////////////////////////////////////////////////

AHB2AXIBridge_noBL MACCtrl (   
//	Common Interface
        .CLK         (ACLK_BUS       ),
		.RESETn      (ARESETn        ),

// AHB Interface
	    .HADDR       (HADDR_M0      ), 
	    .HTRANS      (HTRANS_M0     ),
	    .HWRITE      (HWRITE_M0     ),
	    .HSIZE       (HSIZE_M0      ),
	    .HBURST      (HBURST_M0     ),
	    .HPROT       (HPROT_M0      ),
	    .HWDATA      (HWDATA_M0     ),
	    .HRDATA      (HRDATA_M0     ),
	    .HREADY_IN   (1'b1  ), 
	    .HREADY_OUT  (HREADY_OUT_M0 ), 
	    .HRESP       (HRESP_M0      ),     

	    .HSEL        ( 1'b1       ),
	    .HMASTLOCK   ( 1'b0  ),

// AXI Interface
		// Write Address Channel
	    .AWADDR      (AWADDR_MAC     ),   
	    .AWLEN       (AWLEN_MAC      ),
	    .AWSIZE      (AWSIZE_MAC     ),
	    .AWBURST     (AWBURST_MAC    ),
	    .AWLOCK      (AWLOCK_MAC     ),
	    .AWCACHE     (AWCACHE_MAC    ),
	    .AWPROT      (AWPROT_MAC     ),
	    .AWVALID     (AWVALID_MAC    ),
	    .AWREADY     (AWREADY_MAC    ),

		// Write Data Channel
	    .WDATA       (WDATA_MAC      ),
	    .WSTRB       (WSTRB_MAC      ),
	    .WLAST       (WLAST_MAC      ),
	    .WVALID      (WVALID_MAC     ),
	    .WREADY      (WREADY_MAC     ),

		// Write Response Channel
	    .BRESP       (BRESP_MAC      ),
	    .BVALID      (BVALID_MAC     ),
	    .BREADY      (BREADY_MAC     ),

		// Read Address Channel
	    .ARADDR      (ARADDR_MAC     ),
	    .ARLEN       (ARLEN_MAC      ),
	    .ARSIZE      (ARSIZE_MAC     ),
	    .ARBURST     (ARBURST_MAC    ),
	    .ARLOCK      (ARLOCK_MAC     ),
	    .ARCACHE     (ARCACHE_MAC    ),
	    .ARPROT      (ARPROT_MAC     ),
	    .ARVALID     (ARVALID_MAC    ),
	    .ARREADY     (ARREADY_MAC    ),

		// Read Data Channel
	    .RDATA       (RDATA_MAC      ),
	    .RRESP       (RRESP_MAC      ),
	    .RLAST       (RLAST_MAC      ),
	    .RVALID      (RVALID_MAC     ),
	    .RREADY      (RREADY_MAC     )
);

//////////////////////////////////////////////////////////////////////
// AXI Master3 : PCI Controller
//////////////////////////////////////////////////////////////////////
AHB2AXIBridge_noBL PCICtrl (   
//	Common Interface
	    .CLK        (ACLK           ),
	    .RESETn     (ARESETn        ),

// AHB Interface
	    .HADDR      (HADDR_M1      ), 
	    .HTRANS     (HTRANS_M1     ),
	    .HWRITE     (HWRITE_M1     ),
	    .HSIZE      (HSIZE_M1      ),
	    .HBURST     (HBURST_M1     ),
	    .HPROT      (HPROT_M1      ),
	    .HWDATA     (HWDATA_M1     ),
	    .HRDATA     (HRDATA_M1     ),
	    .HREADY_IN  (1'b1          ), 
	    .HREADY_OUT (HREADY_OUT_M1 ), 
	    .HRESP      (HRESP_M1      ),     

	    .HSEL       ( 1'b1       ),
	    .HMASTLOCK  ( 1'b0  ),

// AXI Interface
		// Write Address Channel
	    .AWADDR     (AWADDR_PCI     ),   
	    .AWLEN      (AWLEN_PCI      ),
	    .AWSIZE     (AWSIZE_PCI     ),
	    .AWBURST    (AWBURST_PCI    ),
	    .AWLOCK     (               ),
	    .AWCACHE    (               ),
	    .AWPROT     (               ),
	    .AWVALID    (AWVALID_PCI    ),
	    .AWREADY    (AWREADY_PCI    ),

		// Write Data Channel
	    .WDATA      (WDATA_PCI      ),
	    .WSTRB      (WSTRB_PCI      ),
	    .WLAST      (WLAST_PCI      ),
	    .WVALID     (WVALID_PCI     ),
	    .WREADY     (WREADY_PCI     ),

		// Write Response Channel
	    .BRESP      (BRESP_PCI      ),
	    .BVALID     (BVALID_PCI     ),
	    .BREADY     (BREADY_PCI     ),

		// Read Address Channel
	    .ARADDR     (ARADDR_PCI     ),
	    .ARLEN      (ARLEN_PCI      ),
	    .ARSIZE     (ARSIZE_PCI     ),
	    .ARBURST    (ARBURST_PCI    ),
	    .ARLOCK     (               ),
	    .ARCACHE    (               ),
	    .ARPROT     (               ),
	    .ARVALID    (ARVALID_PCI    ),
	    .ARREADY    (ARREADY_PCI    ),

		// Read Data Channel
	    .RDATA      (RDATA_PCI      ),
	    .RRESP      (RRESP_PCI      ),
	    .RLAST      (RLAST_PCI      ),
	    .RVALID     (RVALID_PCI     ),
	    .RREADY     (RREADY_PCI     )
);

//////////////////////////////////////////////////////////////////////
// AXI Slave0 : AHB0 SLAVE
//////////////////////////////////////////////////////////////////////
AXI2AHBBridge AHBSlave0 (

        .ACLK       (ACLK_BUS       ), 
	    .ARESETn    (ARESETn        ),
		// Write Address Channel
	    .AWID       (AWID_AHB0      ), 
	    .AWADDR     (AWADDR_AHB0    ),
	    .AWLEN      (AWLEN_AHB0     ),
	    .AWSIZE     (AWSIZE_AHB0    ),
	    .AWBURST    (AWBURST_AHB0   ),
	    .AWVALID    (AWVALID_AHB0   ),
	    .AWREADY    (AWREADY_AHB0   ),

		// Write Data Channel
	    .WID        (WID_AHB0       ),
	    .WDATA      (WDATA_AHB0     ),
//	    .WSTRB      (WSTRB_AHB0     ),
	    .WLAST      (WLAST_AHB0     ),
	    .WVALID     (WVALID_AHB0    ),
	    .WREADY     (WREADY_AHB0    ),

		// Write Response Channel
	    .BID        (BID_AHB0       ),
	    .BRESP      (BRESP_AHB0     ),
	    .BVALID     (BVALID_AHB0    ),
	    .BREADY     (BREADY_AHB0    ),

		// Read Address Channel
	    .ARID       (ARID_AHB0      ),
	    .ARADDR     (ARADDR_AHB0    ),
	    .ARLEN      (ARLEN_AHB0     ),
	    .ARSIZE     (ARSIZE_AHB0    ),
	    .ARBURST    (ARBURST_AHB0   ),
	    .ARVALID    (ARVALID_AHB0   ),
	    .ARREADY    (ARREADY_AHB0   ),

		// Read Data Channel
	    .RID        (RID_AHB0       ),
	    .RDATA      (RDATA_AHB0     ),
	    .RRESP      (RRESP_AHB0     ),
	    .RLAST      (RLAST_AHB0     ),
	    .RVALID     (RVALID_AHB0    ),
	    .RREADY     (RREADY_AHB0    ),

// AHB Interface
	    .HADDR      (HADDR_S0       ),
	    .HTRANS     (HTRANS_S0      ),
	    .HWRITE     (HWRITE_S0      ),
	    .HSIZE      (HSIZE_S0       ),
	    .HBURST     (HBURST_S0      ),
//	    .HPROT      (HPROT_S0       ),
	    .HWDATA     (HWDATA_S0      ),
	    .HRDATA     (HRDATA_S0      ),
	    .HREADY_IN  (HREADY_IN_S0   ),
	    .HREADY_OUT (HREADY_OUT_S0  ), // not used
	    .HRESP      (HRESP_S0       ),

	    .HSEL       (HSEL_S0        )
        );
//////////////////////////////////////////////////////////////////////
// AXI Slave1 : AHB1 SLAVE
//////////////////////////////////////////////////////////////////////
AXI2AHBBridge AHBSlave1 (

        .ACLK       (ACLK_BUS       ), 
	    .ARESETn    (ARESETn        ),
		// Write Address Channel
	    .AWID       (AWID_AHB1      ), 
	    .AWADDR     (AWADDR_AHB1    ),
	    .AWLEN      (AWLEN_AHB1     ),
	    .AWSIZE     (AWSIZE_AHB1    ),
	    .AWBURST    (AWBURST_AHB1   ),
	    .AWVALID    (AWVALID_AHB1   ),
	    .AWREADY    (AWREADY_AHB1   ),

		// Write Data Channel
	    .WID        (WID_AHB1       ),
	    .WDATA      (WDATA_AHB1     ),
//	    .WSTRB      (WSTRB_AHB1     ),
	    .WLAST      (WLAST_AHB1     ),
	    .WVALID     (WVALID_AHB1    ),
	    .WREADY     (WREADY_AHB1    ),

		// Write Response Channel
	    .BID        (BID_AHB1       ),
	    .BRESP      (BRESP_AHB1     ),
	    .BVALID     (BVALID_AHB1    ),
	    .BREADY     (BREADY_AHB1    ),

		// Read Address Channel
	    .ARID       (ARID_AHB1      ),
	    .ARADDR     (ARADDR_AHB1    ),
	    .ARLEN      (ARLEN_AHB1     ),
	    .ARSIZE     (ARSIZE_AHB1    ),
	    .ARBURST    (ARBURST_AHB1   ),
	    .ARVALID    (ARVALID_AHB1   ),
	    .ARREADY    (ARREADY_AHB1   ),

		// Read Data Channel
	    .RID        (RID_AHB1       ),
	    .RDATA      (RDATA_AHB1     ),
	    .RRESP      (RRESP_AHB1     ),
	    .RLAST      (RLAST_AHB1     ),
	    .RVALID     (RVALID_AHB1    ),
	    .RREADY     (RREADY_AHB1    ),

// AHB Interface
	    .HADDR      (HADDR_S1       ),
	    .HTRANS     (HTRANS_S1      ),
	    .HWRITE     (HWRITE_S1      ),
	    .HSIZE      (HSIZE_S1       ),
	    .HBURST     (HBURST_S1      ),
//	    .HPROT      (HPROT_S1       ),
	    .HWDATA     (HWDATA_S1      ),
	    .HRDATA     (HRDATA_S1      ),
	    .HREADY_IN  (HREADY_IN_S1   ),
	    .HREADY_OUT (HREADY_OUT_S1  ), // not used
	    .HRESP      (HRESP_S1       ),

	    .HSEL       (HSEL_S1        )
        );

//////////////////////////////////////////////////////////////////////
// AXI Slave2 : AHB2 SLAVE
//////////////////////////////////////////////////////////////////////
AXI2AHBBridge AHBSlave2 (

        .ACLK       (ACLK_BUS       ),
        .ARESETn    (ARESETn        ),
        // Write Address Channel
        .AWID       (AWID_AHB2      ),
        .AWADDR     (AWADDR_AHB2    ),
        .AWLEN      (AWLEN_AHB2     ),
        .AWSIZE     (AWSIZE_AHB2    ),
        .AWBURST    (AWBURST_AHB2   ),
        .AWVALID    (AWVALID_AHB2   ),
        .AWREADY    (AWREADY_AHB2   ),

        // Write Data Channel
        .WID        (WID_AHB2       ),
        .WDATA      (WDATA_AHB2     ),
//      .WSTRB      (WSTRB_AHB2     ),
        .WLAST      (WLAST_AHB2     ),
        .WVALID     (WVALID_AHB2    ),
        .WREADY     (WREADY_AHB2    ),

        // Write Response Channel
        .BID        (BID_AHB2       ),
        .BRESP      (BRESP_AHB2     ),
        .BVALID     (BVALID_AHB2    ),
        .BREADY     (BREADY_AHB2    ),
 
        // Read Address Channel
        .ARID       (ARID_AHB2      ),
        .ARADDR     (ARADDR_AHB2    ),
        .ARLEN      (ARLEN_AHB2     ),
        .ARSIZE     (ARSIZE_AHB2    ),
        .ARBURST    (ARBURST_AHB2   ),
        .ARVALID    (ARVALID_AHB2   ),
        .ARREADY    (ARREADY_AHB2   ),
 
        // Read Data Channel
        .RID        (RID_AHB2       ),
        .RDATA      (RDATA_AHB2     ),
        .RRESP      (RRESP_AHB2     ),
        .RLAST      (RLAST_AHB2     ),
        .RVALID     (RVALID_AHB2    ),
        .RREADY     (RREADY_AHB2    ),
 
// AHB Interface
        .HADDR      (HADDR_S2       ),
        .HTRANS     (HTRANS_S2      ),
        .HWRITE     (HWRITE_S2      ),
        .HSIZE      (HSIZE_S2       ),
        .HBURST     (HBURST_S2      ),
//      .HPROT      (HPROT_S2       ),
        .HWDATA     (HWDATA_S2      ),
        .HRDATA     (HRDATA_S2      ),
        .HREADY_IN  (HREADY_IN_S2   ),
        .HREADY_OUT (HREADY_OUT_S2  ), // not used
        .HRESP      (HRESP_S2       ),

        .HSEL       (HSEL_S2        )
        );

//////////////////////////////////////////////////////////////////////
// AXI Slave3 : DDR
//////////////////////////////////////////////////////////////////////
assign DDR_CLK = ACLK_BUS;
assign DDR_nCLK = ~ACLK_BUS;
wire [4:0]  BID_DDR_Temp;
assign BID_DDR = BID_DDR_Temp[3:0];
DDRTop DDRCtrl(
   		.ARESETB(ARESETn),
   		.nPOR(ARESETn),
   		.MCLK(DDRCLK),
   		.nMCLK(nDDRCLK),
   		.ACLK(ACLK_BUS),
   		.nACLK(nACLK_BUS),

		.AWAddr(AWADDR_DDR),
		.AWId({2'h0,AWID_DDR}),
		.AWLen(AWLEN_DDR),
		.AWValid(AWVALID_DDR),
		.AWReady(AWREADY_DDR),
		.AWBurst(AWBURST_DDR),

   		.WLast(WLAST_DDR),
   		.WStrb(WSTRB_DDR),
   		.WData(WDATA_DDR),
   		.WValid(WVALID_DDR),
   		.WReady(WREADY_DDR),
   		.WId({2'h0,WID_DDR}),

   		.BResp(BRESP_DDR),
   		.BValid(BVALID_DDR),
   		.BReady(BREADY_DDR),
   		.BId(BID_DDR_Temp),

		.ARAddr(ARADDR_DDR),
		.ARId({1'b0,ARID_DDR}),
		.ARLen(ARLEN_DDR),
		.ARValid(ARVALID_DDR),
		.ARReady(ARREADY_DDR),
		.ARBurst(ARBURST_DDR),

   		.RData(RDATA_DDR),
   		.RValid(RVALID_DDR),
   		.RReady(RREADY_DDR),
   		.RLast(RLAST_DDR),
   		.RId(RID_DDR),
   		.RResp(RRESP_DDR),

   		.SD_CKE(DDR_CKE),
   		.SD_CSB(DDR_CSB),
   		.SD_RASB(DDR_RASB),
   		.SD_CASB(DDR_CASB),
   		.SD_WEB(DDR_WEB),
   		.SD_BADDR(DDR_BADDR),
   		.SD_ADDR(DDR_ADDR),
   		.SD_DQE(DDR_DQE),
   		.SD_DQI(DDR_DQI),
   		.SD_DQO(DDR_DQO),
   		.SD_DQM(DDR_DQM),
   		.SD_DQSE(DDR_DQSE),
   		.SD_DQSO(DDR_DQSO),
   		.SD_DQSI(DDR_DQSI),
   		.nSD_DQSI(DDR_nDQSI),

		.PCLK(ACLK_BUS),
		.PRESETB(PRESETn0),
   		.PSEL(PSEL0_1),
   		.PENABLE(PENABLE0),
   		.PADDR(PADDR0[7:2]),
   		.PWRITE(PWRITE0),
   		.PWDATA(PWDATA0),
		.PRDATA(PRDATA0_1)
);

//////////////////////////////////////////////////////////////////////
// AXI Slave1 : APB0(run @ BUS clock)
//////////////////////////////////////////////////////////////////////
// You must edit AXI2APBBridge_Simple if you want to change memory map in APB0
AXI2APBBridge_PREADY #(.RID_WIDTH(2), .WID_WIDTH(2)) APB0
(
		.ACLK(ACLK_BUS),
		.ARESETn(ARESETn),

		.AWID(AWID_APB0),
		.AWADDR(AWADDR_APB0),
		.AWLEN(AWLEN_APB0),
		.AWSIZE(AWSIZE_APB0),
		.AWBURST(AWBURST_APB0),
		.AWVALID(AWVALID_APB0),
		.AWREADY(AWREADY_APB0),

		.WID(WID_APB0),
		.WDATA(WDATA_APB0),
		.WLAST(WLAST_APB0),
		.WVALID(WVALID_APB0),
		.WREADY(WREADY_APB0),

		.BID(BID_APB0),
		.BRESP(BRESP_APB0),
		.BVALID(BVALID_APB0),
		.BREADY(BREADY_APB0),

		.ARID(ARID_APB0),
		.ARADDR(ARADDR_APB0),
		.ARLEN(ARLEN_APB0),
		.ARSIZE(ARSIZE_APB0),
		.ARBURST(ARBURST_APB0),
		.ARVALID(ARVALID_APB0),
		.ARREADY(ARREADY_APB0),

		.RID(RID_APB0),
		.RDATA(RDATA_APB0),
		.RRESP(RRESP_APB0),
		.RLAST(RLAST_APB0),
		.RVALID(RVALID_APB0),
		.RREADY(RREADY_APB0),

		.PADDR(PADDR0),
		.PWRITE(PWRITE0),
		.PSEL0(PSEL0_0),
		.PSEL1(PSEL0_1),
		.PSEL2(PSEL0_2),
		.PSEL3(PSEL0_3),
		.PSEL4(PSEL0_4),
		.PSEL5(PSEL0_5),
		.PSEL6(PSEL0_6),
		.PSEL7(PSEL0_7),
		.PENABLE(PENABLE0),
		.PRDATA0(PRDATA0_0),
		.PRDATA1(PRDATA0_1),
		.PRDATA2(PRDATA0_2),
		.PRDATA3(PRDATA0_3),
		.PRDATA4(PRDATA0_4),
		.PRDATA5(PRDATA0_5),
		.PRDATA6(PRDATA0_6),
		.PRDATA7(PRDATA0_7),
		.PREADY0(PREADY0_0),
		.PREADY1(PREADY0_1),
		.PREADY2(PREADY0_2),
		.PREADY3(PREADY0_3),
		.PREADY4(PREADY0_4),
		.PREADY5(PREADY0_5),
		.PREADY6(PREADY0_6),
		.PREADY7(PREADY0_7),
		.PWDATA(PWDATA0)
);

//////////////////////////////////////////////////////////////////////
// AXI Slave2 : APB1(run @ slower clock than AXI BUS)
//////////////////////////////////////////////////////////////////////
// You must edit AXI2APBBridge if you want to change memory map in APB1
AXI2APBBridge #(.RID_WIDTH(2), .WID_WIDTH(2)) APB1
(
		.ACLK(ACLK_BUS),
		.ARESETn(ARESETn),

		.AWID(AWID_APB1),
		.AWADDR(AWADDR_APB1),
		.AWLEN(AWLEN_APB1),
		.AWSIZE(AWSIZE_APB1),
		.AWBURST(AWBURST_APB1),
		.AWVALID(AWVALID_APB1),
		.AWREADY(AWREADY_APB1),

		.WID(WID_APB1),
		.WDATA(WDATA_APB1),
		.WLAST(WLAST_APB1),
		.WVALID(WVALID_APB1),
		.WREADY(WREADY_APB1),

		.BID(BID_APB1),
		.BRESP(BRESP_APB1),
		.BVALID(BVALID_APB1),
		.BREADY(BREADY_APB1),

		.ARID(ARID_APB1),
		.ARADDR(ARADDR_APB1),
		.ARLEN(ARLEN_APB1),
		.ARSIZE(ARSIZE_APB1),
		.ARBURST(ARBURST_APB1),
		.ARVALID(ARVALID_APB1),
		.ARREADY(ARREADY_APB1),

		.RID(RID_APB1),
		.RDATA(RDATA_APB1),
		.RRESP(RRESP_APB1),
		.RLAST(RLAST_APB1),
		.RVALID(RVALID_APB1),
		.RREADY(RREADY_APB1),

		.PCLKEN(PCLKEn),
		.PADDR(PADDR1),
		.PWRITE(PWRITE1),
		.PSEL0(PSEL1_0),
		.PSEL1(PSEL1_1),
		.PSEL2(PSEL1_2),
		.PSEL3(PSEL1_3),
		.PSEL4(PSEL1_4),
		.PSEL5(PSEL1_5),
		.PSEL6(PSEL1_6),
		.PSEL7(PSEL1_7),
		.PSEL8(PSEL1_8),
		.PSEL9(PSEL1_9),
		.PSELA(PSEL1_A),
		.PSELB(PSEL1_B),
		.PSELC(PSEL1_C),
		.PSELD(PSEL1_D),
		.PSELE(PSEL1_E),
		.PSELF(PSEL1_F),
		.PENABLE(PENABLE1),
		.PRDATA0(PRDATA1_0),
		.PRDATA1(PRDATA1_1),
		.PRDATA2(PRDATA1_2),
		.PRDATA3(PRDATA1_3),
		.PRDATA4(PRDATA1_4),
		.PRDATA5(PRDATA1_5),
		.PRDATA6(PRDATA1_6),
		.PRDATA7(PRDATA1_7),
		.PRDATA8(PRDATA1_8),
		.PRDATA9(PRDATA1_9),
		.PRDATAA(PRDATA1_A),
		.PRDATAB(PRDATA1_B),
		.PRDATAC(PRDATA1_C),
		.PRDATAD(PRDATA1_D),
		.PRDATAE(PRDATA1_E),
		.PRDATAF(PRDATA1_F),
		.PREADY0(PREADY1_0),
		.PREADY1(PREADY1_1),
		.PREADY2(PREADY1_2),
		.PREADY3(PREADY1_3),
		.PREADY4(PREADY1_4),
		.PREADY5(PREADY1_5),
		.PREADY6(PREADY1_6),
		.PREADY7(PREADY1_7),
		.PREADY8(PREADY1_8),
		.PREADY9(PREADY1_9),
		.PREADYA(PREADY1_A),
		.PREADYB(PREADY1_B),
		.PREADYC(PREADY1_C),
		.PREADYD(PREADY1_D),
		.PREADYE(PREADY1_E),
		.PREADYF(PREADY1_F),
		.PWDATA(PWDATA1)
);

//////////////////////////////////////////////////////////////////////
// AXI Slave3 : SMC(Static Memory Controller)
//////////////////////////////////////////////////////////////////////
// You must edit SMC_TOP if you want to change memory map of SMC banks
wire [31:0] SMC_WDATA_32bit;
SMC_TOP #(.RID_WIDTH(5), .WID_WIDTH(4)) SMC(
		.ACLK(ACLK_BUS),
		.ARESETn(ARESETn),

		.AWID({1'b0,AWID_SMC}),
		.AWADDR(AWADDR_SMC),
		.AWLEN(AWLEN_SMC),
		.AWSIZE(AWSIZE_SMC),
		.AWBURST(AWBURST_SMC),
		.AWVALID(AWVALID_SMC),
		.AWREADY(AWREADY_SMC),

		.WID({1'b0,WID_SMC}),
		.WDATA(WDATA_SMC),
		.WSTRB(WSTRB_SMC),
		.WLAST(WLAST_SMC),
		.WVALID(WVALID_SMC),
		.WREADY(WREADY_SMC),

		.BID(BID_SMC),
		.BRESP(BRESP_SMC),
		.BVALID(BVALID_SMC),
		.BREADY(BREADY_SMC),

		.ARID({1'b0,ARID_SMC}),
		.ARADDR(ARADDR_SMC),
		.ARLEN(ARLEN_SMC),
		.ARSIZE(ARSIZE_SMC),
		.ARBURST(ARBURST_SMC),
		.ARVALID(ARVALID_SMC),
		.ARREADY(ARREADY_SMC),

		.RID(RID_SMC),
		.RDATA(RDATA_SMC),
		.RRESP(RRESP_SMC),
		.RLAST(RLAST_SMC),
		.RVALID(RVALID_SMC),
		.RREADY(RREADY_SMC),

		.BOOT_WIDTH(BOOT_WIDTH),

        .PCLK(PCLK),
		.PRESETn(PRESETn1),
		.PADDR(PADDR1[5:2]),
		.PSEL(PSEL1_9),
		.PENABLE(PENABLE1),
		.PWRITE(PWRITE1),
		.PWDATA(PWDATA1),
		.PRDATA(PRDATA1_9),
        
		.EXT_ADDR(SMC_ADDR),
		.EXT_WDATA(SMC_WDATA_32bit),
		.EXT_RDATA({16'h0000,SMC_RDATA}),
		.EXT_CSb(SMC_nCS),
		.EXT_OEb(SMC_nOE),
		.EXT_WEb(SMC_nWE),
		.EXT_BEb(SMC_nBE),
		.EXT_WBEb(SMC_nWBE),
		.EXT_BIDEN(SMC_BIDEN)
);
assign SMC_WDATA = SMC_WDATA_32bit[15:0];

//////////////////////////////////////////////////////////////////////
// AXI Slave4 : SSRAM(Internal SRAM)
//////////////////////////////////////////////////////////////////////
wire [31:0] MEMADDR;
wire [31:0] MEMRDATA;
wire [31:0] MEMWDATA;
wire        MEMnCE;
wire [3:0]  MEMnWE;
IntSRAMController #(.RID_WIDTH(5), .WID_WIDTH(4)) IntSRAMController
(
		.ACLK(ACLK_BUS),
		.ARESETn(ARESETn),

		.AWID({1'b0,AWID_SSRAM}),
		.AWADDR(AWADDR_SSRAM),
		.AWLEN(AWLEN_SSRAM),
		.AWSIZE(AWSIZE_SSRAM),
		.AWBURST(AWBURST_SSRAM),
		.AWVALID(AWVALID_SSRAM),
		.AWREADY(AWREADY_SSRAM),

		.WID({1'b0,WID_SSRAM}),
		.WDATA(WDATA_SSRAM),
		.WSTRB(WSTRB_SSRAM),
		.WLAST(WLAST_SSRAM),
		.WVALID(WVALID_SSRAM),
		.WREADY(WREADY_SSRAM),

		.BID(BID_SSRAM),
		.BRESP(BRESP_SSRAM),
		.BVALID(BVALID_SSRAM),
		.BREADY(BREADY_SSRAM),

		.ARID(ARID_SSRAM),
		.ARADDR(ARADDR_SSRAM),
		.ARLEN(ARLEN_SSRAM),
		.ARSIZE(ARSIZE_SSRAM),
		.ARBURST(ARBURST_SSRAM),
		.ARVALID(ARVALID_SSRAM),
		.ARREADY(ARREADY_SSRAM),

		// Read Data Channel
		.RID(RID_SSRAM),
		.RDATA(RDATA_SSRAM),
		.RRESP(RRESP_SSRAM),
		.RLAST(RLAST_SSRAM),
		.RVALID(RVALID_SSRAM),
		.RREADY(RREADY_SSRAM),

		.MEMADDR(MEMADDR[29:0]),
		.MEMCEn(MEMnCE),
		.MEMWEn(MEMnWE),
		.MEMRDATA(MEMRDATA),
		.MEMWDATA(MEMWDATA)
);

wire [15:0] SEIP_EEMA;
wire [ 3:0] SEIP_XEEMWE;
wire [31:0] SEIP_EEMDI;
wire [31:0] SEIP_EEMDO;

wire [31:0] M128KADDR;
wire [31:0] M128KRDATA;
wire [31:0] M128KWDATA;
wire        M128KnCE;
wire [3:0]  M128KnWE;

// Internal SRAM MUX
wire SRAMOwner = 1'b0;	// 1 when SEIP, 0 when system
assign M128KADDR = (SRAMOwner == 1) ? SEIP_EEMA[14:0] : MEMADDR[14:0];
assign MEMRDATA = M128KRDATA;
assign SEIP_EEMDO = M128KRDATA;
assign M128KWDATA = (SRAMOwner == 1) ? SEIP_EEMDI : MEMWDATA;
assign M128KnCE = (SRAMOwner == 1) ? 1'b0 : MEMnCE;
assign M128KnWE = (SRAMOwner == 1) ? SEIP_XEEMWE : MEMnWE;

SSRAM32bit #(.ADDR_WIDTH(15)) SRAM
(
		.CLK(CLK100M),
		.ADDR(M128KADDR[14:0]),
		.CEn(M128KnCE),
		.WEn(M128KnWE),
		.RDATA(M128KRDATA),
		.WDATA(M128KWDATA)
);

//////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////
// APB0 BUS
//////////////////////////////////////////////////////////////////////

// APB0 Slave0 : SD/MMC Controller

assign PREADY0_0 = 1;

// APB0 Slave1 : DDR Controller
// already connected
assign PREADY0_1 = 1;

// APB0 Slave2 : NAND Flash Ctrl
assign PREADY0_2 = 1;
wire NFInt;
NFTop NFCtrl
(
		.PCLK(ACLK_BUS),
		.PRESETn(PRESETn0),
		.PADDR(PADDR0[6:2]),
		.PSEL(PSEL0_2),
		.PENABLE(PENABLE0),
		.PWRITE(PWRITE0),
		.PWDATA(PWDATA0),
		.PRDATA(PRDATA0_2),

		.NFDMAReqOut(NFDMAReq),
		.NFINTOut(NFInt),

		.NFBootPinIn(NF_Boot),
		.IOWidthPinIn(NF_IOWidth),
		.NandWidthPinIn(NF_Width),
		.BootCfgPinIn(NF_BootCfg),
		.OutDtmnPinIn(NF_OutDtmn),
		// synopsys translate_off
		.AddrCnt(),
		// synopsys translate_on
		.NFDataIn(NF_DI),
		.NFDataOut(NF_DO),
		.NFDataOutEn(NF_DOE),
		.CLE(NF_CLE),
		.ALE(NF_ALE),
		.nNFCE1(NF_nCE1),
		.nNFCE0(NF_nCE0),
		.nNFRE(NF_nRE),
		.nNFWE(NF_nWE),
		.RnB1(NF_RnB1),
		.RnB0(NF_RnB0)
);

// APB0 Slave3 : DMA Controllere
// already connected
assign PREADY0_3 = 1;

// APB0 Slave4 : 2D DMA Controller
// already connected
assign PREADY0_4 = 1;

// APB0 Slave5 : VIC(Vectored Interrupt Controller)
assign PREADY0_5 = 1;
wire [3:0] UartInt;
wire [31:0] IntSrc;
wire       I2CInt;
wire [3:0] TimerMatchInt;
wire WDTInt;
wire I2SInt;
wire       SEIPInt;
wire [1:0] GPIOInt;
wire       SPIInt;
assign IntSrc = { 3'd0,				// IRQ31~29 : Not Assigned
				1'b0,		 		// IRQ28
				NFInt,				// IRQ27
				1'b0,				// IRQ26
				I2CInt,				// IRQ25
				I2SInt,				// IRQ24
				SPIInt,				// IRQ23
				1'b0,		 		// IRQ22	UartInt[3]
				1'b0,				// IRQ21	UartInt[2]
				UartInt[1],			// IRQ20
				TimerMatchInt[3],	// IRQ19
				TimerMatchInt[2],	// IRQ18
				TimerMatchInt[1],	// IRQ17
				TimerMatchInt[0],	// IRQ16
				1'b0,			// IRQ15  GPIO[1]
				1'b0,			// IRQ14  GPIO[0]
				DMAInterrupt[7],	// IRQ13
				DMAInterrupt[3],	// IRQ12
				DMAInterrupt[6],	// IRQ11
				DMAInterrupt[2],	// IRQ10
				DMAInterrupt[5],	// IRQ9
				DMAInterrupt[1],	// IRQ8
				DMAInterrupt[4],	// IRQ7
				DMAInterrupt[0],	// IRQ6
				1'b0, 				// IRQ5
				1'b0,				// IRQ4
				WDTInt,				// IRQ3
				MacIntSrc[1],		// IRQ2
				MacIntSrc[0],		// IRQ1
				UartInt[0]			// IRQ0
			};

VIC VIC (
		.PCLK(ACLK_BUS),
		.PRESETn(PRESETn0),
		.PENABLE(PENABLE0),
		.PSEL(PSEL0_5),
		.PWRITE(PWRITE0),
		.PADDR(PADDR0[6:2]),
		.PWDATA(PWDATA0),
		.PRDATA(PRDATA0_5),

		.INTERRUPT_SRC(IntSrc),

		.nFIQ(ARMnFIQ),
		.nIRQ(ARMnIRQ),

		.LEVEL_PM(),
		.POLARITY_PM(),
		.INTMSK_PM()
);

// APB0 Slave6 : Sound Engine(Located at FPGA0)
 
wire  [7:0] SEIP_WEMDO;
wire  [7:0] SEIP_WEMDI;
wire [23:0] SEIP_WEMA;
wire        SEIP_EXMBIH;
wire        SEIP_XWEMOC;
wire        SEIP_XWEMWE;

   assign 	PREADY0_6 = 0;
   assign 	PRDATA0_6 = 0;

// APB0 Slave7 : USB 
// already connected
//assign PREADY0_7 = 1;

//////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////
// APB1 BUS
//////////////////////////////////////////////////////////////////////

// APB1 Slave0 : Timer(4Channel)
assign PREADY1_0 = 1;
Timer4Ch Timer4Ch(
		.PCLK(PCLK),
		.PRESETn(PRESETn1),
		.PSEL(PSEL1_0),
		.PENABLE(PENABLE1),
		.PADDR(PADDR1[5:2]),
		.PWRITE(PWRITE1), 
		.PWDATA(PWDATA1[31:0]),
		.PRDATA(PRDATA1_0),

		.TimerTMCInt(TimerMatchInt)
);

// APB1 Slave1 : WarchDog Timer
assign PREADY1_1 = 1;
WatchDog WatchDog(
		.PCLK(PCLK),
		.PRESETn(PRESETn1),
		.PENABLE(PENABLE1),
		.PSEL(PSEL1_1),
		.PWRITE(PWRITE1),
		.PADDR(PADDR1[7:2]),
		.PWDATA(PWDATA1),
		.PRDATA(PRDATA1_1),

		.WDOGRESn(ARESETn),
		.WDOGINT(WDTInt),
		.WDOGRES()
);

// APB1 Slave2 : GPIO(64bit)
assign PREADY1_2 = 1;
Gpio2Ch Gpio2Ch
(
		.PCLK(PCLK),
		.PRESETn(PRESETn1),
		.PENABLE(PENABLE1),
		.PSEL(PSEL1_2),
		.PWRITE(PWRITE1),
		.PADDR(PADDR1[5:2]),
		.PWDATA(PWDATA1),
		.PRDATA(PRDATA1_2),
		
		.Gpio0In(GPIO0_IN[31:0]),
		.Gpio0OutEn(GPIO0_OE[31:0]),
		.Gpio0Out(GPIO0_OUT[31:0]),

		.Gpio1In(GPIO1_IN[31:0]),
		.Gpio1OutEn(GPIO1_OE[31:0]),
		.Gpio1Out(GPIO1_OUT[31:0]),

		.Interrupt(GPIOInt)
);

// APB1 Slave3 : Power Management Unit(Not Connected Yet)
assign PREADY1_3 = 1;
assign PRDATA1_3 = 0;

// APB1 Slave4 : Resource Share Control
assign PREADY1_4 = 1;
ResourceShare ResourceShare
(
		.PCLK(PCLK),
		.PRESETn(PRESETn1),
		.PENABLE(PENABLE1),
		.PSEL(PSEL1_4),
		.PWRITE(PWRITE1),
		.PADDR(PADDR1[4:2]),
		.PWDATA(PWDATA1),
		.PRDATA(PRDATA1_4),
		
		.DMAMux(DMAMux),	// for DMA mux
		.I2SInputMux(),
		.WaveROMHAddr(),
		.WaveROMOwner(),
		.SRAMOwner()		// dethermine Internal SRAM Ownership(SYSTEM or SEIP)
);

// APB1 Slave5 : UART(4Ch)
assign PREADY1_5 = 1;
Uart4Ch Uart4Ch(
		.PADDR(PADDR1[6:2]),
		.PENABLE(PENABLE1),
		.PSEL(PSEL1_5),
		.PWDATA(PWDATA1),
		.PWRITE(PWRITE1),
		.PRDATA(PRDATA1_5),
		.PCLK(PCLK),
		.PRESETn(PRESETn1),
		.RXD(UART_RXD),
		.Interrupt(UartInt),
		.RxDMAReq(UartRxDMAReq),
		.TXD(UART_TXD),
		.TxDMAReq(UartTxDMAReq)
);

// APB1 Slave6 : I2S Controller
assign PREADY1_6 = 1;
I2S_Top I2SCtrl
(
		.SYS_CLK(DDRCLK),

		//	APB
		.PCLK(PCLK),
		.PRESETn(PRESETn1),
		.PENABLE(PENABLE1),
		.PSEL(PSEL1_6),
		.PWRITE(PWRITE1),
		.PADDR(PADDR1[3:2]),
		.PWDATA(PWDATA1),
		.PRDATA(PRDATA1_6),

		// Interrupt Out
		.Interrupt(I2SInt),

		// DMA Request
		.TxDMAReq(I2STxDMAReq),
		.RxDMAReq(I2SRxDMAReq),

		.MCLK(I2S_MCLK),
		.MCLK_OE(I2S_MCLK_OE),
		.BCLK_O(I2S_BCLK_O),
		.BCLK_I(I2S_BCLK_I),
		.BCLK_OE(I2S_BCLK_OE),
		.LRCLK_O(I2S_LRCLK_O),
		.LRCLK_I(I2S_LRCLK_I),
		.LRCLK_OE(I2S_LRCLK_OE),
		.SDIN(I2S_SDIN),
		.SDOUT(I2S_SDOUT)
);

// APB1 Slave7 : I2C Master Controller
assign PREADY1_7 = 1;
I2CTop I2CMaster(
		.PCLK(PCLK),
		.PRESETn(PRESETn1),
		.PENABLE(PENABLE1),
		.PSEL(PSEL1_7),
		.PWRITE(PWRITE1),
		.PADDR(PADDR1[3:2]),
		.PWDATA(PWDATA1),
		.PRDATA(PRDATA1_7),

		.int(I2CInt),
		.SCL_i(I2C_SCLi),
		.SCL_o(I2C_SCLo),
		.nSCL_En(I2C_nSCLEn),
		.SDA_i(I2C_SDAi),
		.SDA_o(I2C_SDAo),
		.nSDA_En(I2C_nSDAEn)
);

// APB1 Slave8 : SPI
assign PREADY1_8 = 1;
Ssp SPI(
		.PCLK(PCLK),
		.PRESETn(PRESETn1),
		.PADDR(PADDR1[4:2]),
		.PSEL(PSEL1_8),
		.PENABLE(PENABLE1),
		.PWRITE(PWRITE1),
		.PWDATA(PWDATA1[15:0]),
		.PRDATA(PRDATA1_8),

		.SSPRXD(SPIRxd),
		.SSPFSSIN(SPInSSIn),
		.SSPCLKIN(SPIClkIn),
		.SSPFSSOUT(SPInSSOut),
		.SSPCLKOUT(SPIClkOut),
		.SSPTXD(SPITxd),
		.nSSPOE(SPInOE),
		.nSSPCTLOE(SPInCTLOE),

		.SSPINTR(SPIInt),
		.TxDMAReq(SPI0TxDMAReq),
		.RxDMAReq(SPI0RxDMAReq)
);

// APB1 Slave9 : SMC
// alreay connected
assign PREADY1_9 = 1;

// APB1 SlaveA : Display Module
// already connected
assign PREADY1_A = 1;

// APB1 SlaveB : Video Encoder
// already connected
assign PREADY1_B = 1;

// APB1 SlaveC : VIF(Video Input Processor)
// already connected
assign PREADY1_C = 1;

// APB1 SlaveD : None
assign PREADY1_D = 1;
assign PRDATA1_D = 1;

// APB1 SlaveE : Not Used
assign PREADY1_E = 1;
assign PRDATA1_E = 0;

// APB1 SlaveF : Not Used
assign PREADY1_F = 1;
assign PRDATA1_F = 0;

endmodule
