// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TestPlatformCore.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose            : TestPlatform Core module
//  --========================================================================--

`timescale 1ns/1ps
module TestPlatformCore (
		RESETn,
		Clock,
	
		// SMC
		EXT_ADDR,
		EXT_WDATA,
		EXT_RDATA,
		EXT_CSb,
		EXT_OEb,
		EXT_WEb,
		EXT_BEb,
		EXT_WBEb,
		EXT_BIDEN,

		// DDR Controller
		SD_CLK,
		SD_nCLK,
		SD_CKE,
		SD_CSB,
		SD_RASB,
		SD_CASB,
		SD_WEB,
		SD_BADDR,
		SD_ADDR,
		SD_DQE,
		SD_DQI,
		SD_DQO,
		SD_DQM,
		SD_DQSE,
		SD_DQSO,
		SD_DQSI,
		nSD_DQSI,

		// UART
		UART_TXD,
		UART_RXD,

		// MMC
		MMC_FBCLK,
		MMC_CMDIN,
		MMC_DATIN,
		MMC_CLKOUT,
		MMC_CMDOUT,
		MMC_DATOUT,
		MMC_nCMDEN,
		MMC_nDATEN,

		// I2C
		I2CSCLi,
		I2CSDAi,
		I2CSCLo,
		I2CSDAo,

		// LCD
		LCDClk,
		LCDHSync,
		LCDVSync,
		LCDDataEn,
		LCDData,

		// I2S Related
		MCLK,		// 256*Fs clock output
		MCLK_OE,	// MCLK Output Enable(active high)
		BCLK_O,		// BCLK clock output
		BCLK_I,		// BCLK clock input
		BCLK_OE,	// BCLK Output Enable(active high)
		LRCLK_O,	// LRCLK clock output
		LRCLK_I,	// LRCLK clock input
		LRCLK_OE,	// LRCLK Output Enable(active high)
		SDIN,		// Serial Data Input
		SDOUT,		// Serial Data Output

		// GPIO
		GpioIn,
		GpioOutEn,
		GpioOut
);

// ----------------------------------------------------------------------------
// Address Map
// ----------------------------------------------------------------------------
// 0x0000_0000 - 0x0400_0000  External Static Memory Bank0(EXT_CSb[0])
// 0x0400_0000 - 0x0800_0000  External Static Memory Bank0(EXT_CSb[1])
// 0x0800_0000 - 0x0C00_0000  External Static Memory Bank0(EXT_CSb[2])
// 0x0C00_0000 - 0x1000_0000  External Static Memory Bank0(EXT_CSb[3])
// 
// 0x1000_0000 - 0x2000_0000  Internal SRAM Controller
//
// 0x2000_0000 - 0x3000_0000  APB0
//     (PSEL0_0) 0x2000_0000 - 0x2000_0FFC : DMA Controller register
//     (PSEL0_1) 0x2000_1000 - 0x2000_1FFC : External SMC register
//     (PSEL0_2) 0x2000_2000 - 0x2000_2FFC : DDR Controller register
//     (PSEL0_3) 0x2000_3000 - 0x2000_3FFC : Empty
// 0x3000_0000 - 0x4000_0000  APB1
//     (PSEL1_0) 0x3000_0000 - 0x3000_0FFC : VIC(Vectored Interrupt Controller)
//     (PSEL1_1) 0x3000_1000 - 0x3000_1FFC : GPIO
//     (PSEL1_2) 0x3000_2000 - 0x3000_2FFC : UART
//     (PSEL1_3) 0x3000_3000 - 0x3000_3FFC : MMC Controller
//     (PSEL1_4) 0x3000_4000 - 0x3000_4FFC : I2C Controller
//     (PSEL1_5) 0x3000_5000 - 0x3000_5FFC : Timer
//     (PSEL1_6) 0x3000_6000 - 0x3000_6FFC : Display Controller register
//     (PSEL1_7) 0x3000_7000 - 0x3000_7FFC : I2S Controller
//
// 0x4000_0000 - 0x8000_0000  DDR SDRAM region
//

parameter CPU2BUSClockRatio = 2;	// 2 or 1
parameter BUS2APBClockRatio = 1;

input          RESETn;
input          Clock;

output [25:0]  EXT_ADDR  ;
output [31:0]  EXT_WDATA ;
input  [31:0]  EXT_RDATA ;
output [ 3:0]  EXT_CSb   ;
output         EXT_OEb   ;
output         EXT_WEb   ;
output [ 3:0]  EXT_BEb   ;
output [ 3:0]  EXT_WBEb  ;
output         EXT_BIDEN ;

output         SD_CLK;
output         SD_nCLK;
output         SD_CKE  ; // clock enable
output         SD_CSB  ; // chip select
output         SD_RASB ; // row address strobe
output         SD_CASB ; // column address strobe
output         SD_WEB  ; // write enable
output [1:0]   SD_BADDR; // bank address
output [12:0]  SD_ADDR ; // address
output         SD_DQE; // dq output enable
input  [15:0]  SD_DQI; // data input
output [15:0]  SD_DQO; // data output
output [1:0]   SD_DQM;
output         SD_DQSE;
output [1:0]   SD_DQSO;
input  [1:0]   SD_DQSI;
input  [1:0]   nSD_DQSI;

output         UART_TXD;
input          UART_RXD;

input          MMC_FBCLK;
input          MMC_CMDIN;
input  [ 7:0]  MMC_DATIN;
output         MMC_CLKOUT;
output         MMC_CMDOUT;
output [ 7:0]  MMC_DATOUT;
output         MMC_nCMDEN;
output         MMC_nDATEN;

input  [1:0]   I2CSCLi;
input  [1:0]   I2CSDAi;
output [1:0]   I2CSCLo;
output [1:0]   I2CSDAo;

output         LCDClk;
output         LCDHSync;
output         LCDVSync;
output         LCDDataEn;
output [23:0]  LCDData;

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
input  [31:0]  GpioIn;
output [31:0]  GpioOutEn;
output [31:0]  GpioOut;
                	
//
// Clock & Reset Manager
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

ClockResetGen
	#(.CPU2BUSClockRatio(CPU2BUSClockRatio), .BUS2APBClockRatio(BUS2APBClockRatio)) 
ClockResetGen (
	.Clock_i(Clock),
	.Reset_i(RESETn),
	
	.DDRClk(DDRCLK),
	.nDDRClk(nDDRCLK),
	.CPUClk(ACLK_CPU),
	.BUSClk(ACLK_BUS),
	.nBUSClk(nACLK_BUS),
	.APBClk(PCLK),
	.BUSClkEn(BusClockEn),
	.PCLKEn(PCLKEn),
	.RESET_o(ARESETn)
);

//
// AXI BUS
//

// BUS interconneting signals

// AXI Master 0 : ARM
wire [31:0] AWADDR_ARM;
wire [3:0]  AWLEN_ARM;
wire [2:0]  AWSIZE_ARM;
wire [1:0]  AWBURST_ARM;
wire [1:0]  AWLOCK_ARM;
wire [3:0]  AWCACHE_ARM;
wire [2:0]  AWPROT_ARM;
wire        AWVALID_ARM;
wire        AWREADY_ARM;

wire [31:0] WDATA_ARM;
wire [3:0]  WSTRB_ARM;
wire        WLAST_ARM;
wire        WVALID_ARM;
wire        WREADY_ARM;

wire [1:0]  BRESP_ARM;
wire        BVALID_ARM;
wire        BREADY_ARM;

wire [31:0] ARADDR_ARM;
wire [3:0]  ARLEN_ARM;
wire [2:0]  ARSIZE_ARM;
wire [1:0]  ARBURST_ARM;
wire [1:0]  ARLOCK_ARM;
wire [3:0]  ARCACHE_ARM;
wire [2:0]  ARPROT_ARM;
wire        ARVALID_ARM;
wire        ARREADY_ARM;

wire [1:0]  RRESP_ARM;
wire [31:0] RDATA_ARM;
wire        RLAST_ARM;
wire        RVALID_ARM;
wire        RREADY_ARM;

// AXI Master 1 : Display Controller(Read Port Only)
wire [1:0]  ARID_DisplayCtrl;
wire [31:0] ARADDR_DisplayCtrl;
wire [3:0]  ARLEN_DisplayCtrl;
wire [2:0]  ARSIZE_DisplayCtrl;
wire [1:0]  ARBURST_DisplayCtrl;
wire        ARVALID_DisplayCtrl;
wire        ARREADY_DisplayCtrl;

wire [1:0]  RID_DisplayCtrl;
wire [1:0]  RRESP_DisplayCtrl;
wire [31:0] RDATA_DisplayCtrl;
wire        RLAST_DisplayCtrl;
wire        RVALID_DisplayCtrl;
wire        RREADY_DisplayCtrl;

// AXI Master 2 : DMA Controller
wire        AWID_DMACtrl;
wire [31:0] AWADDR_DMACtrl;
wire [3:0]  AWLEN_DMACtrl;
wire [2:0]  AWSIZE_DMACtrl;
wire [1:0]  AWBURST_DMACtrl;
wire        AWVALID_DMACtrl;
wire        AWREADY_DMACtrl;

wire        WID_DMACtrl;
wire [31:0] WDATA_DMACtrl;
wire [3:0]  WSTRB_DMACtrl;
wire        WLAST_DMACtrl;
wire        WVALID_DMACtrl;
wire        WREADY_DMACtrl;

wire        BID_DMACtrl;
wire [1:0]  BRESP_DMACtrl;
wire        BVALID_DMACtrl;
wire        BREADY_DMACtrl;

wire        ARID_DMACtrl;
wire [31:0] ARADDR_DMACtrl;
wire [3:0]  ARLEN_DMACtrl;
wire [2:0]  ARSIZE_DMACtrl;
wire [1:0]  ARBURST_DMACtrl;
wire        ARVALID_DMACtrl;
wire        ARREADY_DMACtrl;

wire        RID_DMACtrl;
wire [1:0]  RRESP_DMACtrl;
wire [31:0] RDATA_DMACtrl;
wire        RLAST_DMACtrl;
wire        RVALID_DMACtrl;
wire        RREADY_DMACtrl;

// AXI Master 3 : Video Input(BT656 Interface) : Write Port Only
wire [31:0] AWADDR_VideoIn;
wire [3:0]  AWLEN_VideoIn;
wire [2:0]  AWSIZE_VideoIn;
wire [1:0]  AWBURST_VideoIn;
wire        AWVALID_VideoIn;
wire        AWREADY_VideoIn;

wire [31:0] WDATA_VideoIn;
wire [3:0]  WSTRB_VideoIn;
wire        WLAST_VideoIn;
wire        WVALID_VideoIn;
wire        WREADY_VideoIn;

wire [1:0]  BRESP_VideoIn;
wire        BVALID_VideoIn;
wire        BREADY_VideoIn;

// AXI Slave 0 : DDRAM controller
wire [2:0]  AWID_DDRCtrl;
wire [31:0] AWADDR_DDRCtrl;
wire [3:0]  AWLEN_DDRCtrl;
wire [2:0]  AWSIZE_DDRCtrl;
wire [1:0]  AWBURST_DDRCtrl;
wire        AWVALID_DDRCtrl;
wire        AWREADY_DDRCtrl;

wire [2:0]  WID_DDRCtrl;
wire [31:0] WDATA_DDRCtrl;
wire [3:0]  WSTRB_DDRCtrl;
wire        WLAST_DDRCtrl;
wire        WVALID_DDRCtrl;
wire        WREADY_DDRCtrl;

wire [2:0]  BID_DDRCtrl;
wire [1:0]  BRESP_DDRCtrl;
wire        BVALID_DDRCtrl;
wire        BREADY_DDRCtrl;

wire [3:0]  ARID_DDRCtrl;
wire [31:0] ARADDR_DDRCtrl;
wire [3:0]  ARLEN_DDRCtrl;
wire [2:0]  ARSIZE_DDRCtrl;
wire [1:0]  ARBURST_DDRCtrl;
wire        ARVALID_DDRCtrl;
wire        ARREADY_DDRCtrl;

wire [3:0]  RID_DDRCtrl;
wire [1:0]  RRESP_DDRCtrl;
wire [31:0] RDATA_DDRCtrl;
wire        RLAST_DDRCtrl;
wire        RVALID_DDRCtrl;
wire        RREADY_DDRCtrl;

// AXI Slave 1 : APB0 Interface
wire [1:0]  AWID_APB0;
wire [31:0] AWADDR_APB0;
wire [3:0]  AWLEN_APB0;
wire [2:0]  AWSIZE_APB0;
wire [1:0]  AWBURST_APB0;
wire [1:0]  AWLOCK_APB0;
wire [3:0]  AWCACHE_APB0;
wire [2:0]  AWPROT_APB0;
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
wire [1:0]  ARLOCK_APB0;
wire [3:0]  ARCACHE_APB0;
wire [2:0]  ARPROT_APB0;
wire        ARVALID_APB0;
wire        ARREADY_APB0;

wire [1:0]  RID_APB0;
wire [1:0]  RRESP_APB0;
wire [31:0] RDATA_APB0;
wire        RLAST_APB0;
wire        RVALID_APB0;
wire        RREADY_APB0;

// AXI Slave 2 : APB1 Interface
wire [1:0]  AWID_APB1;
wire [31:0] AWADDR_APB1;
wire [3:0]  AWLEN_APB1;
wire [2:0]  AWSIZE_APB1;
wire [1:0]  AWBURST_APB1;
wire [1:0]  AWLOCK_APB1;
wire [3:0]  AWCACHE_APB1;
wire [2:0]  AWPROT_APB1;
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
wire [1:0]  ARLOCK_APB1;
wire [3:0]  ARCACHE_APB1;
wire [2:0]  ARPROT_APB1;
wire        ARVALID_APB1;
wire        ARREADY_APB1;

wire [1:0]  RID_APB1;
wire [1:0]  RRESP_APB1;
wire [31:0] RDATA_APB1;
wire        RLAST_APB1;
wire        RVALID_APB1;
wire        RREADY_APB1;

// AXI Slave 3 : Exnternal SMC
wire [2:0]  AWID_SMC;
wire [31:0] AWADDR_SMC;
wire [3:0]  AWLEN_SMC;
wire [2:0]  AWSIZE_SMC;
wire [1:0]  AWBURST_SMC;
wire [1:0]  AWLOCK_SMC;
wire [3:0]  AWCACHE_SMC;
wire [2:0]  AWPROT_SMC;
wire        AWVALID_SMC;
wire        AWREADY_SMC;

wire [2:0]  WID_SMC;
wire [31:0] WDATA_SMC;
wire [3:0]  WSTRB_SMC;
wire        WLAST_SMC;
wire        WVALID_SMC;
wire        WREADY_SMC;

wire [2:0]  BID_SMC;
wire [1:0]  BRESP_SMC;
wire        BVALID_SMC;
wire        BREADY_SMC;

wire [3:0]  ARID_SMC;
wire [31:0] ARADDR_SMC;
wire [3:0]  ARLEN_SMC;
wire [2:0]  ARSIZE_SMC;
wire [1:0]  ARBURST_SMC;
wire [1:0]  ARLOCK_SMC;
wire [3:0]  ARCACHE_SMC;
wire [2:0]  ARPROT_SMC;
wire        ARVALID_SMC;
wire        ARREADY_SMC;

wire [3:0]  RID_SMC;
wire [1:0]  RRESP_SMC;
wire [31:0] RDATA_SMC;
wire        RLAST_SMC;
wire        RVALID_SMC;
wire        RREADY_SMC;

// AXI Slave 4 : Internal SRAM
wire [2:0]  AWID_IntSRAM;
wire [31:0] AWADDR_IntSRAM;
wire [3:0]  AWLEN_IntSRAM;
wire [2:0]  AWSIZE_IntSRAM;
wire [1:0]  AWBURST_IntSRAM;
wire [1:0]  AWLOCK_IntSRAM;
wire [3:0]  AWCACHE_IntSRAM;
wire [2:0]  AWPROT_IntSRAM;
wire        AWVALID_IntSRAM;
wire        AWREADY_IntSRAM;

wire [2:0]  WID_IntSRAM;
wire [31:0] WDATA_IntSRAM;
wire [3:0]  WSTRB_IntSRAM;
wire        WLAST_IntSRAM;
wire        WVALID_IntSRAM;
wire        WREADY_IntSRAM;

wire [2:0]  BID_IntSRAM;
wire [1:0]  BRESP_IntSRAM;
wire        BVALID_IntSRAM;
wire        BREADY_IntSRAM;

wire [3:0]  ARID_IntSRAM;
wire [31:0] ARADDR_IntSRAM;
wire [3:0]  ARLEN_IntSRAM;
wire [2:0]  ARSIZE_IntSRAM;
wire [1:0]  ARBURST_IntSRAM;
wire [1:0]  ARLOCK_IntSRAM;
wire [3:0]  ARCACHE_IntSRAM;
wire [2:0]  ARPROT_IntSRAM;
wire        ARVALID_IntSRAM;
wire        ARREADY_IntSRAM;

wire [3:0]  RID_IntSRAM;
wire [1:0]  RRESP_IntSRAM;
wire [31:0] RDATA_IntSRAM;
wire        RLAST_IntSRAM;
wire        RVALID_IntSRAM;
wire        RREADY_IntSRAM;

// AXI BUS
SBUS SBUS(

//MASTER channel signal
    //_______________________________________________________________
    //For Master 0 :: ARM
    //Write address channel

//Disalbe_id_port
    .AWADDR_ARM  (AWADDR_ARM  ),
    .AWLEN_ARM   (AWLEN_ARM   ),
    .AWSIZE_ARM  (AWSIZE_ARM  ),
    .AWBURST_ARM (AWBURST_ARM ),
    .AWLOCK_ARM  (AWLOCK_ARM  ),
//Disalbe_cache_port
//Disalbe_protect_port

    .AWVALID_ARM (AWVALID_ARM ),
    .AWREADY_2_ARM   (AWREADY_ARM ),

    //Write data channel
//Disalbe_id_port
    .WDATA_ARM       (WDATA_ARM   ),
    .WSTRB_ARM       (WSTRB_ARM   ),
    .WLAST_ARM       (WLAST_ARM   ),
    .WVALID_ARM      (WVALID_ARM  ),
    .WREADY_2_ARM    (WREADY_ARM),

    //Write response channel
//Disalbe_id_port
    .BRESP_2_ARM     (BRESP_ARM   ),
    .BVALID_2_ARM    (BVALID_ARM  ),
    .BREADY_ARM      (BREADY_ARM    ),


    //Read address channel
//Disalbe_id_port
    .ARADDR_ARM  (ARADDR_ARM  ),
    .ARLEN_ARM   (ARLEN_ARM   ),
    .ARSIZE_ARM  (ARSIZE_ARM  ),
    .ARBURST_ARM (ARBURST_ARM ),
    .ARLOCK_ARM  (ARLOCK_ARM  ),
//Disalbe_cache_port
//Disalbe_protect_port

    .ARVALID_ARM (ARVALID_ARM ),
    .ARREADY_2_ARM (ARREADY_ARM ),

    //Read data channel
//Disalbe_id_port
    .RRESP_2_ARM   (RRESP_ARM   ),
    .RDATA_2_ARM   (RDATA_ARM   ),
    .RLAST_2_ARM   (RLAST_ARM   ),
    .RVALID_2_ARM  (RVALID_ARM  ),
    .RREADY_ARM  (RREADY_ARM  ),

    //_______________________________________________________________
    //For Master 1 :: DisplayCtrl
    //Write address channel

    //Read address channel
    .ARID_DisplayCtrl    (ARID_DisplayCtrl    ),
    .ARADDR_DisplayCtrl  (ARADDR_DisplayCtrl  ),
    .ARLEN_DisplayCtrl   (ARLEN_DisplayCtrl   ),
    .ARSIZE_DisplayCtrl  (ARSIZE_DisplayCtrl  ),
    .ARBURST_DisplayCtrl (ARBURST_DisplayCtrl ),
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port

    .ARVALID_DisplayCtrl (ARVALID_DisplayCtrl ),
    .ARREADY_2_DisplayCtrl (ARREADY_DisplayCtrl ),

    //Read data channel
    .RID_2_DisplayCtrl     (RID_DisplayCtrl     ),
    .RRESP_2_DisplayCtrl   (RRESP_DisplayCtrl   ),
    .RDATA_2_DisplayCtrl   (RDATA_DisplayCtrl   ),
    .RLAST_2_DisplayCtrl   (RLAST_DisplayCtrl   ),
    .RVALID_2_DisplayCtrl  (RVALID_DisplayCtrl  ),
    .RREADY_DisplayCtrl  (RREADY_DisplayCtrl  ),

    //_______________________________________________________________
    //For Master 2 :: DMACtrl
    //Write address channel

    .AWID_DMACtrl    (AWID_DMACtrl    ),
    .AWADDR_DMACtrl  (AWADDR_DMACtrl  ),
    .AWLEN_DMACtrl   (AWLEN_DMACtrl   ),
    .AWSIZE_DMACtrl  (AWSIZE_DMACtrl  ),
    .AWBURST_DMACtrl (AWBURST_DMACtrl ),
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port

    .AWVALID_DMACtrl (AWVALID_DMACtrl ),
    .AWREADY_2_DMACtrl   (AWREADY_DMACtrl ),

    //Write data channel
    .WID_DMACtrl         (WID_DMACtrl     ),
    .WDATA_DMACtrl       (WDATA_DMACtrl   ),
    .WSTRB_DMACtrl       (WSTRB_DMACtrl   ),
    .WLAST_DMACtrl       (WLAST_DMACtrl   ),
    .WVALID_DMACtrl      (WVALID_DMACtrl  ),
    .WREADY_2_DMACtrl    (WREADY_DMACtrl),

    //Write response channel
    .BID_2_DMACtrl       (BID_DMACtrl     ),
    .BRESP_2_DMACtrl     (BRESP_DMACtrl   ),
    .BVALID_2_DMACtrl    (BVALID_DMACtrl  ),
    .BREADY_DMACtrl      (BREADY_DMACtrl    ),


    //Read address channel
    .ARID_DMACtrl    (ARID_DMACtrl    ),
    .ARADDR_DMACtrl  (ARADDR_DMACtrl  ),
    .ARLEN_DMACtrl   (ARLEN_DMACtrl   ),
    .ARSIZE_DMACtrl  (ARSIZE_DMACtrl  ),
    .ARBURST_DMACtrl (ARBURST_DMACtrl ),
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port

    .ARVALID_DMACtrl (ARVALID_DMACtrl ),
    .ARREADY_2_DMACtrl (ARREADY_DMACtrl ),

    //Read data channel
    .RID_2_DMACtrl     (RID_DMACtrl     ),
    .RRESP_2_DMACtrl   (RRESP_DMACtrl   ),
    .RDATA_2_DMACtrl   (RDATA_DMACtrl   ),
    .RLAST_2_DMACtrl   (RLAST_DMACtrl   ),
    .RVALID_2_DMACtrl  (RVALID_DMACtrl  ),
    .RREADY_DMACtrl  (RREADY_DMACtrl  ),

    //_______________________________________________________________
    //For Master 3 :: VideoIn
    //Write address channel

//Disalbe_id_port
    .AWADDR_VideoIn  (AWADDR_VideoIn  ),
    .AWLEN_VideoIn   (AWLEN_VideoIn   ),
    .AWSIZE_VideoIn  (AWSIZE_VideoIn  ),
    .AWBURST_VideoIn (AWBURST_VideoIn ),
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port

    .AWVALID_VideoIn (AWVALID_VideoIn ),
    .AWREADY_2_VideoIn   (AWREADY_VideoIn ),

    //Write data channel
//Disalbe_id_port
    .WDATA_VideoIn       (WDATA_VideoIn   ),
    .WSTRB_VideoIn       (WSTRB_VideoIn   ),
    .WLAST_VideoIn       (WLAST_VideoIn   ),
    .WVALID_VideoIn      (WVALID_VideoIn  ),
    .WREADY_2_VideoIn    (WREADY_VideoIn),

    //Write response channel
//Disalbe_id_port
    .BRESP_2_VideoIn     (BRESP_VideoIn   ),
    .BVALID_2_VideoIn    (BVALID_VideoIn  ),
    .BREADY_VideoIn      (BREADY_VideoIn    ),



//SLAVE channel signal
    //_______________________________________________________________
    //For Slave 0 :: DDRCtrl
    //Write address channel
    .AWID_2_DDRCtrl    (AWID_DDRCtrl    ),
    .AWADDR_2_DDRCtrl  (AWADDR_DDRCtrl  ),
    .AWLEN_2_DDRCtrl   (AWLEN_DDRCtrl   ),
    .AWSIZE_2_DDRCtrl  (AWSIZE_DDRCtrl  ),
    .AWBURST_2_DDRCtrl (AWBURST_DDRCtrl ),
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port
    .AWVALID_2_DDRCtrl (AWVALID_DDRCtrl ),
    .AWREADY_DDRCtrl (AWREADY_DDRCtrl ),

    //Write data channel
    .WID_2_DDRCtrl     (WID_DDRCtrl     ),
    .WDATA_2_DDRCtrl   (WDATA_DDRCtrl   ),
    .WSTRB_2_DDRCtrl   (WSTRB_DDRCtrl   ),
    .WLAST_2_DDRCtrl   (WLAST_DDRCtrl   ),
    .WVALID_2_DDRCtrl  (WVALID_DDRCtrl  ),
    .WREADY_DDRCtrl  (WREADY_DDRCtrl  ),

    //Write response channel
    .BID_DDRCtrl     (BID_DDRCtrl     ),
    .BRESP_DDRCtrl   (BRESP_DDRCtrl   ),
    .BVALID_DDRCtrl  (BVALID_DDRCtrl  ),
    .BREADY_2_DDRCtrl  (BREADY_DDRCtrl  ),

    //Read channel signal
    .ARID_2_DDRCtrl    (ARID_DDRCtrl    ),
    .ARADDR_2_DDRCtrl  (ARADDR_DDRCtrl  ),
    .ARLEN_2_DDRCtrl   (ARLEN_DDRCtrl   ),
    .ARSIZE_2_DDRCtrl  (ARSIZE_DDRCtrl  ),
    .ARBURST_2_DDRCtrl (ARBURST_DDRCtrl ),
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port

    .ARVALID_2_DDRCtrl (ARVALID_DDRCtrl ),
    .ARREADY_DDRCtrl   (ARREADY_DDRCtrl ),

    //Read data channel
    .RID_DDRCtrl       (RID_DDRCtrl     ),
    .RRESP_DDRCtrl     (RRESP_DDRCtrl   ),
    .RDATA_DDRCtrl     (RDATA_DDRCtrl  ),
    .RLAST_DDRCtrl     (RLAST_DDRCtrl  ),
    .RVALID_DDRCtrl    (RVALID_DDRCtrl  ),
    .RREADY_2_DDRCtrl  (RREADY_DDRCtrl  ),
    //_______________________________________________________________
    //For Slave 1 :: APB0
    //Write address channel
    .AWID_2_APB0    (AWID_APB0    ),
    .AWADDR_2_APB0  (AWADDR_APB0  ),
    .AWLEN_2_APB0   (AWLEN_APB0   ),
    .AWSIZE_2_APB0  (AWSIZE_APB0  ),
    .AWBURST_2_APB0 (AWBURST_APB0 ),
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port
    .AWVALID_2_APB0 (AWVALID_APB0 ),
    .AWREADY_APB0 (AWREADY_APB0 ),

    //Write data channel
    .WID_2_APB0     (WID_APB0     ),
    .WDATA_2_APB0   (WDATA_APB0   ),
//Disalbe_WSTRB_port
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
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port

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
    //For Slave 2 :: APB1
    //Write address channel
    .AWID_2_APB1    (AWID_APB1    ),
    .AWADDR_2_APB1  (AWADDR_APB1  ),
    .AWLEN_2_APB1   (AWLEN_APB1   ),
    .AWSIZE_2_APB1  (AWSIZE_APB1  ),
    .AWBURST_2_APB1 (AWBURST_APB1 ),
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port
    .AWVALID_2_APB1 (AWVALID_APB1 ),
    .AWREADY_APB1 (AWREADY_APB1 ),

    //Write data channel
    .WID_2_APB1     (WID_APB1     ),
    .WDATA_2_APB1   (WDATA_APB1   ),
//Disalbe_WSTRB_port
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
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port

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
    //For Slave 3 :: SMC
    //Write address channel
    .AWID_2_SMC    (AWID_SMC    ),
    .AWADDR_2_SMC  (AWADDR_SMC  ),
    .AWLEN_2_SMC   (AWLEN_SMC   ),
    .AWSIZE_2_SMC  (AWSIZE_SMC  ),
    .AWBURST_2_SMC (AWBURST_SMC ),
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port
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
    .BID_SMC     (BID_SMC     ),
    .BRESP_SMC   (BRESP_SMC   ),
    .BVALID_SMC  (BVALID_SMC  ),
    .BREADY_2_SMC  (BREADY_SMC  ),

    //Read channel signal
    .ARID_2_SMC    (ARID_SMC    ),
    .ARADDR_2_SMC  (ARADDR_SMC  ),
    .ARLEN_2_SMC   (ARLEN_SMC   ),
    .ARSIZE_2_SMC  (ARSIZE_SMC  ),
    .ARBURST_2_SMC (ARBURST_SMC ),
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port

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
    //For Slave 4 :: IntSRAM
    //Write address channel
    .AWID_2_IntSRAM    (AWID_IntSRAM    ),
    .AWADDR_2_IntSRAM  (AWADDR_IntSRAM  ),
    .AWLEN_2_IntSRAM   (AWLEN_IntSRAM   ),
    .AWSIZE_2_IntSRAM  (AWSIZE_IntSRAM  ),
    .AWBURST_2_IntSRAM (AWBURST_IntSRAM ),
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port
    .AWVALID_2_IntSRAM (AWVALID_IntSRAM ),
    .AWREADY_IntSRAM (AWREADY_IntSRAM ),

    //Write data channel
    .WID_2_IntSRAM     (WID_IntSRAM     ),
    .WDATA_2_IntSRAM   (WDATA_IntSRAM   ),
    .WSTRB_2_IntSRAM   (WSTRB_IntSRAM   ),
    .WLAST_2_IntSRAM   (WLAST_IntSRAM   ),
    .WVALID_2_IntSRAM  (WVALID_IntSRAM  ),
    .WREADY_IntSRAM  (WREADY_IntSRAM  ),

    //Write response channel
    .BID_IntSRAM     (BID_IntSRAM     ),
    .BRESP_IntSRAM   (BRESP_IntSRAM   ),
    .BVALID_IntSRAM  (BVALID_IntSRAM  ),
    .BREADY_2_IntSRAM  (BREADY_IntSRAM  ),

    //Read channel signal
    .ARID_2_IntSRAM    (ARID_IntSRAM    ),
    .ARADDR_2_IntSRAM  (ARADDR_IntSRAM  ),
    .ARLEN_2_IntSRAM   (ARLEN_IntSRAM   ),
    .ARSIZE_2_IntSRAM  (ARSIZE_IntSRAM  ),
    .ARBURST_2_IntSRAM (ARBURST_IntSRAM ),
//Disalbe_lock_port
//Disalbe_cache_port
//Disalbe_protect_port

    .ARVALID_2_IntSRAM (ARVALID_IntSRAM ),
    .ARREADY_IntSRAM   (ARREADY_IntSRAM ),

    //Read data channel
    .RID_IntSRAM       (RID_IntSRAM     ),
    .RRESP_IntSRAM     (RRESP_IntSRAM   ),
    .RDATA_IntSRAM     (RDATA_IntSRAM  ),
    .RLAST_IntSRAM     (RLAST_IntSRAM  ),
    .RVALID_IntSRAM    (RVALID_IntSRAM  ),
    .RREADY_2_IntSRAM  (RREADY_IntSRAM  ),

    .ACLK    (ACLK_BUS),
    .ARESETn (ARESETn)
);

// AXI Master0 : ARM
wire ARMnFIQ;
wire ARMnIRQ;

tarm_axi_fastclk CPU
(
		.ACLK(ACLK_CPU),
		.ARESETn(ARESETn),

		.BusClockEn(BusClockEn),

		.ARMnFIQ(ARMnFIQ),
		.ARMnIRQ(ARMnIRQ),

		.AWADDR(AWADDR_ARM),
		.AWLEN(AWLEN_ARM),
		.AWSIZE(AWSIZE_ARM),
		.AWBURST(AWBURST_ARM),
		.AWLOCK(AWLOCK_ARM),
		.AWCACHE(AWCACHE_ARM),
		.AWPROT(AWPROT_ARM),
		.AWVALID(AWVALID_ARM),
		.AWREADY(AWREADY_ARM),

		.WDATA(WDATA_ARM),
		.WSTRB(WSTRB_ARM),
		.WLAST(WLAST_ARM),
		.WVALID(WVALID_ARM),
		.WREADY(WREADY_ARM),

		.BRESP(BRESP_ARM),
		.BVALID(BVALID_ARM),
		.BREADY(BREADY_ARM),

		.ARADDR(ARADDR_ARM),
		.ARLEN(ARLEN_ARM),
		.ARSIZE(ARSIZE_ARM),
		.ARBURST(ARBURST_ARM),
		.ARLOCK(ARLOCK_ARM),
		.ARCACHE(ARCACHE_ARM),
		.ARPROT(ARPROT_ARM),
		.ARVALID(ARVALID_ARM),
		.ARREADY(ARREADY_ARM),

		.RDATA(RDATA_ARM),
		.RRESP(RRESP_ARM),
		.RLAST(RLAST_ARM),
		.RVALID(RVALID_ARM),
		.RREADY(RREADY_ARM)
);

// AXI Master1 : Display Controller
wire DmErrInt;
wire [3:0]  ARID_DisplayCtrl_Temp;
assign ARID_DisplayCtrl = ARID_DisplayCtrl_Temp[1:0];

`ifdef LCDCLKisPCLK
assign LCDClk = PCLK;
`else
reg [3:0] LCDClkCounter;
always @(posedge ACLK_BUS or negedge RESETn)
begin
	if(!RESETn)
		LCDClkCounter <= 0;
	else
		LCDClkCounter <= LCDClkCounter + 1;
end

reg LCDClk;
always @(LCDClk or GpioOut or LCDClkCounter)
begin
	case(GpioOut[17:16])
	2'b00: LCDClk = LCDClkCounter[0];	// 1/2 clock
	2'b01: LCDClk = LCDClkCounter[1];	// 1/4 clock
	2'b10: LCDClk = LCDClkCounter[2];	// 1/8 clock
	2'b11: LCDClk = LCDClkCounter[3];	// 1/16 clock
	endcase
end
`endif

DmTop DisplayCtrl(
   		.ACLK(ACLK_BUS),
   		.ARESETn(ARESETn),

   		.ARID(ARID_DisplayCtrl_Temp),
   		.ARADDR(ARADDR_DisplayCtrl),
   		.ARLEN(ARLEN_DisplayCtrl),
   		.ARSIZE(ARSIZE_DisplayCtrl),
   		.ARBURST(ARBURST_DisplayCtrl),
   		.ARLOCK(),
   		.ARCACHE(),
   		.ARPROT(),
   		.ARVALID(ARVALID_DisplayCtrl),
   		.ARREADY(ARREADY_DisplayCtrl),

   		.RID({2'b00, RID_DisplayCtrl}),
   		.RDATA(RDATA_DisplayCtrl),
   		.RRESP(RRESP_DisplayCtrl),
   		.RLAST(RLAST_DisplayCtrl),
   		.RVALID(RVALID_DisplayCtrl),
   		.RREADY(RREADY_DisplayCtrl),
 
   		.PCLK(PCLK),
		.PRESETB(ARESETn),
    	.PSEL(PSEL1_6),
    	.PENABLE(PENABLE1),
    	.PADDR(PADDR1[9:2]),
    	.PWRITE(PWRITE1),
    	.PWDATA(PWDATA1),
		.PRDATA(PRDATA1_6),

		.LCDCLK(LCDClk),
		.LCDHSync(LCDHSync),
		.LCDVSync(LCDVSync),
		.LCDDataEn(LCDDataEn),
		.LCDData(LCDData),
		
		.DmErrInt(DmErrInt)
);

// APB0 signals
wire [31:0] PADDR0;
wire        PWRITE0;
wire        PENABLE0;
wire [31:0] PWDATA0;
wire        PSEL0_0;
wire        PSEL0_1;
wire        PSEL0_2;
wire        PSEL0_3;
wire [31:0] PRDATA0_0;
wire [31:0] PRDATA0_1;
wire [31:0] PRDATA0_2;
wire [31:0] PRDATA0_3;

// AXI Master2 : DMA Controller
wire [7:0] DMAReq;
wire [7:0] DMAAck;
wire [7:0] DMAInterrupt;

wire MMC_DMAREQ;
wire I2STxDMAReq;
wire I2SRxDMAReq;
assign DMAReq = {5'd0, I2SRxDMAReq, I2STxDMAReq, MMC_DMAREQ};	// Now NO DMA
Dmac2x4Ch DMACtrl
(
		.ACLK(ACLK_BUS),
		.ARESETn(ARESETn),

		.DMAReq(DMAReq),
		.DMAAck(DMAAck),
		.Interrupt(DMAInterrupt),

		.PENABLE(PENABLE0),
		.PSEL(PSEL0_0),
		.PWRITE(PWRITE0),
		.PADDR(PADDR0[7:2]),
		.PWDATA(PWDATA0),
		.PRDATA(PRDATA0_0),

		.ARID(ARID_DMACtrl),
		.ARVALID(ARVALID_DMACtrl),
		.ARREADY(ARREADY_DMACtrl),
		.ARADDR(ARADDR_DMACtrl),
		.ARLEN(ARLEN_DMACtrl),
		.ARSIZE(ARSIZE_DMACtrl),
		.ARBURST(ARBURST_DMACtrl),

		.RID(RID_DMACtrl),
		.RDATA(RDATA_DMACtrl),
		.RRESP(RRESP_DMACtrl),
		.RLAST(RLAST_DMACtrl),
		.RVALID(RVALID_DMACtrl),
		.RREADY(RREADY_DMACtrl),

		.AWID(AWID_DMACtrl),
		.AWVALID(AWVALID_DMACtrl),
		.AWREADY(AWREADY_DMACtrl),
		.AWADDR(AWADDR_DMACtrl),
		.AWLEN(AWLEN_DMACtrl),
		.AWSIZE(AWSIZE_DMACtrl),
		.AWBURST(AWBURST_DMACtrl),

		.WID(WID_DMACtrl),
		.WDATA(WDATA_DMACtrl),
		.WSTRB(WSTRB_DMACtrl),
		.WLAST(WLAST_DMACtrl),
		.WVALID(WVALID_DMACtrl),
		.WREADY(WREADY_DMACtrl),

		.BID(BID_DMACtrl),
		.BRESP(BRESP_DMACtrl),
		.BVALID(BVALID_DMACtrl),
		.BREADY(BREADY_DMACtrl)
);

// AXI Master3 : Video Input(BT656 Interface)
assign AWADDR_VideoIn = 0;
assign AWLEN_VideoIn = 0;
assign AWSIZE_VideoIn = 0;
assign AWBURST_VideoIn = 0;
assign AWVALID_VideoIn = 0;

assign WDATA_VideoIn = 0;
assign WSTRB_VideoIn = 0;
assign WLAST_VideoIn = 0;
assign WVALID_VideoIn = 0;

assign BREADY_VideoIn = 0;

// Slave0  : DDRCtrl controller
assign SD_CLK = ACLK_BUS;
assign SD_nCLK = ~ACLK_BUS;
wire [3:0]  BID_DDRCtrl_Temp;
assign BID_DDRCtrl = BID_DDRCtrl_Temp[2:0];
DDRTop DDRCtrl(
   		.ARESETB(ARESETn),
   		.nPOR(ARESETn),
   		.MCLK(DDRCLK),
   		.nMCLK(nDDRCLK),
   		.ACLK(ACLK_BUS),
   		.nACLK(nACLK_BUS),

		.AWAddr(AWADDR_DDRCtrl),
		.AWId({1'b0, AWID_DDRCtrl}),
		.AWLen(AWLEN_DDRCtrl),
		.AWValid(AWVALID_DDRCtrl),
		.AWReady(AWREADY_DDRCtrl),
		.AWBurst(AWBURST_DDRCtrl),

   		.WLast(WLAST_DDRCtrl),
   		.WStrb(WSTRB_DDRCtrl),
   		.WData(WDATA_DDRCtrl),
   		.WValid(WVALID_DDRCtrl),
   		.WReady(WREADY_DDRCtrl),
   		.WId({1'b0, WID_DDRCtrl}),

   		.BResp(BRESP_DDRCtrl),
   		.BValid(BVALID_DDRCtrl),
   		.BReady(BREADY_DDRCtrl),
   		.BId(BID_DDRCtrl_Temp),

		.ARAddr(ARADDR_DDRCtrl),
		.ARId(ARID_DDRCtrl),
		.ARLen(ARLEN_DDRCtrl),
		.ARValid(ARVALID_DDRCtrl),
		.ARReady(ARREADY_DDRCtrl),
		.ARBurst(ARBURST_DDRCtrl),

   		.RData(RDATA_DDRCtrl),
   		.RValid(RVALID_DDRCtrl),
   		.RReady(RREADY_DDRCtrl),
   		.RLast(RLAST_DDRCtrl),
   		.RId(RID_DDRCtrl),
   		.RResp(RRESP_DDRCtrl),

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
   		.nSD_DQSI(nSD_DQSI),

		.PCLK(ACLK_BUS),
		.PRESETB(ARESETn),
   		.PSEL(PSEL0_2),
   		.PENABLE(PENABLE0),
   		.PADDR(PADDR0[7:2]),
   		.PWRITE(PWRITE0),
   		.PWDATA(PWDATA0),
		.PRDATA(PRDATA0_2)
);

/*
SDRAM Controller
SDRTop SDRTop(
		.ACLK		(ACLK_BUS), 
		.nACLK		(~ACLK_BUS), 
		.ARESETB	(ARESETn),
		.PORESETB	(ARESETn),
		.FCLK		(FDClk),

		.AWAddr		(AWADDR_DDRCtrl[27:2]),
		.AWLen		(AWLEN_DDRCtrl),
		.AWValid	(AWVALID_DDRCtrl),
		.AWReady	(AWREADY_DDRCtrl),
		.AWId		({3'b000, AWID_DDRCtrl}),
		.AWBurst	(AWBURST_DDRCtrl),
	
		.WLast		(WLAST_DDRCtrl),
		.WStrb  	(WSTRB_DDRCtrl),
		.WData   	(WDATA_DDRCtrl),
		.WValid		(WVALID_DDRCtrl),
		.WReady		(WREADY_DDRCtrl),
		.WId		({3'b000, WID_DDRCtrl}),

		.BResp 		(BRESP_DDRCtrl),
    	.BValid		(BVALID_DDRCtrl),
    	.BReady		(BREADY_DDRCtrl),
    	.BId		({3'bzzz, BID_DDRCtrl}),
    	
		.ARAddr		(ARADDR_DDRCtrl[27:2]),
		.ARLen		(ARLEN_DDRCtrl),
		.ARValid	(ARVALID_DDRCtrl),
		.ARReady	(ARREADY_DDRCtrl),
		.ARId		(ARID_DDRCtrl),
		.ARBurst	(ARBURST_DDRCtrl),

		.RReady		(RREADY_DDRCtrl),
		.RValid		(RVALID_DDRCtrl),
		.RLast		(RLAST_DDRCtrl),
		.RData   	(RDATA_DDRCtrl),
		.RId		(RID_DDRCtrl),
		.RResp		(RRESP_DDRCtrl),
		
		.PCLK		(ACLK_BUS), 
		.PRESETB	(ARESETn),
		.PENABLE 	(PENABLE0),
		.PSEL    	(PSEL0_2), 
		.PWRITE  	(PWRITE0), 
		.PADDR   	(PADDR0[7:2]), 
		.PWDATA  	(PWDATA0),
		.PRDATA  	(PRDATA0_2),
		
		.SD_CSB		(SDcsb), 
		.SD_RASB	(SDrasb), 
		.SD_CASB	(SDcasb), 
		.SD_WEB		(SDweb), 
		.SD_CKE		(SDcke), 
		.SD_BADDR	(SDba), 
		.SD_ADDR	(SDadr),
		.SD_DQE		(SDdate),
		.SD_DQI		(SDdati), 
		.SD_DQO		(SDdato),
		.SD_DQM		(SDdqm)
);
*/

// AXI Slave1  : APB0 which run @ same clock with AXI BUS
// You must edit AXI2APBBridge_Simple if you want to change memory map in APB0
AXI2APBBridge_Simple #(.RID_WIDTH(2), .WID_WIDTH(2)) APB0
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
		.PENABLE(PENABLE0),
		.PRDATA0(PRDATA0_0),
		.PRDATA1(PRDATA0_1),
		.PRDATA2(PRDATA0_2),
		.PRDATA3(PRDATA0_3),
		.PWDATA(PWDATA0)
);

// AXI Slave2  : APB1 which run slower than AXI BUS
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
wire [31:0] PRDATA1_0;
wire [31:0] PRDATA1_1;
wire [31:0] PRDATA1_2;
wire [31:0] PRDATA1_3;
wire [31:0] PRDATA1_4;
wire [31:0] PRDATA1_5;
wire [31:0] PRDATA1_6;
wire [31:0] PRDATA1_7;
wire        PREADY1_0;
wire        PREADY1_1;
wire        PREADY1_2;
wire        PREADY1_3;
wire        PREADY1_4;
wire        PREADY1_5;
wire        PREADY1_6;
wire        PREADY1_7;
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
		.PENABLE(PENABLE1),
		.PRDATA0(PRDATA1_0),
		.PRDATA1(PRDATA1_1),
		.PRDATA2(PRDATA1_2),
		.PRDATA3(PRDATA1_3),
		.PRDATA4(PRDATA1_4),
		.PRDATA5(PRDATA1_5),
		.PRDATA6(PRDATA1_6),
		.PRDATA7(PRDATA1_7),
		.PREADY0(PREADY1_0),
		.PREADY1(PREADY1_1),
		.PREADY2(PREADY1_2),
		.PREADY3(PREADY1_3),
		.PREADY4(PREADY1_4),
		.PREADY5(PREADY1_5),
		.PREADY6(PREADY1_6),
		.PREADY7(PREADY1_7),
		.PWDATA(PWDATA1)
);

// AXI Slave3  : Static Memory Controller
// You must edit SMC_TOP if you want to change memory map of SMC banks
SMC_TOP #(.RID_WIDTH(4), .WID_WIDTH(3)) SMC(
	.ACLK(ACLK_BUS),
	.ARESETn(ARESETn),

	.AWID(AWID_SMC),
	.AWADDR(AWADDR_SMC),
	.AWLEN(AWLEN_SMC),
	.AWSIZE(AWSIZE_SMC),
	.AWBURST(AWBURST_SMC),
	.AWVALID(AWVALID_SMC),
	.AWREADY(AWREADY_SMC),

	.WID(WID_SMC),
	.WDATA(WDATA_SMC),
	.WSTRB(WSTRB_SMC),
	.WLAST(WLAST_SMC),
	.WVALID(WVALID_SMC),
	.WREADY(WREADY_SMC),

	.BID(BID_SMC),
	.BRESP(BRESP_SMC),
	.BVALID(BVALID_SMC),
	.BREADY(BREADY_SMC),

	.ARID(ARID_SMC),
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

	.PCLK(ACLK_BUS),
	.PRESETn(ARESETn),
	.PADDR(PADDR0[3:2]),
	.PSEL(PSEL0_1),
	.PENABLE(PENABLE0),
	.PWRITE(PWRITE0),
	.PWDATA(PWDATA0),
	.PRDATA(PRDATA0_1),

	.EXT_ADDR(EXT_ADDR),
	.EXT_WDATA(EXT_WDATA),
	.EXT_RDATA(EXT_RDATA),
	.EXT_CSb(EXT_CSb),
	.EXT_OEb(EXT_OEb),
	.EXT_WEb(EXT_WEb),
	.EXT_BEb(EXT_BEb),
	.EXT_WBEb(EXT_WBEb),
	.EXT_BIDEN(EXT_BIDEN)
);

// AXI Slave4  : Internal SRAM Controller
wire [31:0] MEMADDR;
wire [31:0] MEMRDATA;
wire [31:0] MEMWDATA;
wire        MEMCEn;
wire [3:0]  MEMWEn;
IntSRAMController #(.RID_WIDTH(4), .WID_WIDTH(3)) IntSRAMController
(
		.ACLK(ACLK_BUS),
		.ARESETn(ARESETn),

		.AWID(AWID_IntSRAM),
		.AWADDR(AWADDR_IntSRAM),
		.AWLEN(AWLEN_IntSRAM),
		.AWSIZE(AWSIZE_IntSRAM),
		.AWBURST(AWBURST_IntSRAM),
		.AWVALID(AWVALID_IntSRAM),
		.AWREADY(AWREADY_IntSRAM),

		.WID(WID_IntSRAM),
		.WDATA(WDATA_IntSRAM),
		.WSTRB(WSTRB_IntSRAM),
		.WLAST(WLAST_IntSRAM),
		.WVALID(WVALID_IntSRAM),
		.WREADY(WREADY_IntSRAM),

		.BID(BID_IntSRAM),
		.BRESP(BRESP_IntSRAM),
		.BVALID(BVALID_IntSRAM),
		.BREADY(BREADY_IntSRAM),

		.ARID(ARID_IntSRAM),
		.ARADDR(ARADDR_IntSRAM),
		.ARLEN(ARLEN_IntSRAM),
		.ARSIZE(ARSIZE_IntSRAM),
		.ARBURST(ARBURST_IntSRAM),
		.ARVALID(ARVALID_IntSRAM),
		.ARREADY(ARREADY_IntSRAM),

		// Read Data Channel
		.RID(RID_IntSRAM),
		.RDATA(RDATA_IntSRAM),
		.RRESP(RRESP_IntSRAM),
		.RLAST(RLAST_IntSRAM),
		.RVALID(RVALID_IntSRAM),
		.RREADY(RREADY_IntSRAM),

		.MEMADDR(MEMADDR[29:0]),
		.MEMCEn(MEMCEn),
		.MEMWEn(MEMWEn),
		.MEMRDATA(MEMRDATA),
		.MEMWDATA(MEMWDATA)
);

SSRAM32bit #(.ADDR_WIDTH(16)) SRAM
(
		.CLK(ACLK_BUS),
		.ADDR(MEMADDR[15:0]),
		.CEn(MEMCEn),
		.WEn(MEMWEn),
		.RDATA(MEMRDATA),
		.WDATA(MEMWDATA)
);

//
// APB0 BUS
//

// APB0 Slave0 : DMA Controller registers
// already connected

// APB0 Slave1 : External SMC registers
// already connected

// APB0 Slave2 : DDR Controller registers
// already connected

// APB0 Slave3 : Display Controller 
// already connected


//
// APB1 BUS
//
wire UARTRXINT;
wire UARTTXINT;
wire UARTINT;

// APB1 Slave0 : VIC
assign PREADY1_0 = 1;
wire [31:0] IntSrc;
wire MMCInt;
wire [1:0] I2CInt;
wire [1:0] I2CAAS;
wire TimerIntOverFlow;
wire TimerIntMatch;
wire I2SInt;
assign IntSrc = { 12'd0, I2SInt, TimerIntOverFlow, TimerIntMatch, I2CInt[1], I2CAAS[1], I2CInt[0], I2CAAS[0], MMCInt, DmErrInt, UARTRXINT, UARTTXINT, UARTINT, DMAInterrupt };
APB_vic VIC(
		.PCLK(PCLK),
		.PRESETn(ARESETn),
		.PENABLE(PENABLE1),
		.PSEL(PSEL1_0),
		.PWRITE(PWRITE1),
		.PADDR(PADDR1[6:2]),
		.PWDATA(PWDATA1),
		.PRDATA(PRDATA1_0),

		.INTERRUPT_SRC(IntSrc),

		.nFIQ(ARMnFIQ),
		.nIRQ(ARMnIRQ),

		.LEVEL_PM(),
		.POLARITY_PM(),
		.INTMSK_PM()
);

// APB1 Slave1 : Gpio
assign PREADY1_1 = 1;
Gpio Gpio
(
		.PCLK(PCLK),
		.PRESETn(ARESETn),
		.PENABLE(PENABLE1),
		.PSEL(PSEL1_1),
		.PWRITE(PWRITE1),
		.PADDR(PADDR1[7:2]),
		.PWDATA(PWDATA1),
		.PRDATA(PRDATA1_1),
		
		.GpioIn(GpioIn),
		.GpioOutEn(GpioOutEn),
		.GpioOut(GpioOut)
);

// APB1 Slave2 : Uart
assign PREADY1_2 = 1;
Uart Uart(
		.PCLK(PCLK),
		.UARTCLK(PCLK),
		.PRESETn(ARESETn),
		.nUARTRST(ARESETn),
		.PSEL(PSEL1_2),
		.PENABLE(PENABLE1),
		.PWRITE(PWRITE1),
		.PADDR(PADDR1[7:2]),
		.PWDATA(PWDATA1[15:0]),
		.PRDATA(PRDATA1_2),

		.nUARTCTS(1'b0),
		.nUARTDCD(1'b0),
		.nUARTDSR(1'b0),
		.nUARTRI(1'b0),
		.nUARTOut2(),
		.nUARTOut1(),
		.nUARTRTS(),
		.nUARTDTR(),
		.UARTTXDMACLR(1'b0),
		.UARTRXDMACLR(1'b0),
		.UARTTXDMASREQ(),
		.UARTTXDMABREQ(),
		.UARTRXDMASREQ(),
		.UARTRXDMABREQ(),

		.UARTRXD(UART_RXD),
		.UARTTXD(UART_TXD),
		.SIRIN(1'b0),
		.nSIROUT(),

		.UARTMSINTR(),
		.UARTRXINTR(UARTRXINT),
		.UARTTXINTR(UARTTXINT),
		.UARTRTINTR(),
		.UARTEINTR(),
		.UARTINTR(UARTINT)
);

// APB1 Slave3 : MMC Controller
assign PREADY1_3 = 1;
MMCTop MMCTop(
		.PCLK(PCLK),
		.PRESETn(ARESETn),
		.PSEL(PSEL1_3),
		.PENABLE(PENABLE1),
		.PWRITE(PWRITE1),
		.PADDR(PADDR1[7:2]),
		.PWDATA(PWDATA1),
 	
		.PRDATA(PRDATA1_3),
		
//		.MCLK(ACLK_BUS),
		.MCLK(PCLK),
		.MMC_FBCLK(MMC_FBCLK),
		.MMC_CMDIN(MMC_CMDIN),
		.MMC_DATIN(MMC_DATIN),

		.MMC_INT(MMCInt),
		.MMC_DMAREQ(MMC_DMAREQ),
		.MMC_CLKOUT(MMC_CLKOUT),
		.MMC_CMDOUT(MMC_CMDOUT),
		.MMC_DATOUT(MMC_DATOUT),
		.MMC_nCMDEN(MMC_nCMDEN),
		.MMC_nDATEN(MMC_nDATEN)
);

// APB1 Slave4 : I2C
assign PREADY1_4 = 1;
  I2C I2C(
		.Clk(PCLK), 
		.nRst(ARESETn),
		.PSEL(PSEL1_4), 
		.PENABLE(PENABLE1), 
		.PADDR(PADDR1[7:2]), 
		.PWRITE(PWRITE1), 
		.PWDATA(PWDATA1[15:0]), 
		.PRDATA(PRDATA1_4),
	              	
		.I2cInt(I2CInt),
		.I2cAAS(I2CAAS),
	              	
		.ISCL(I2CSCLi), 
		.ISDA(I2CSDAi), 
		.OSCL(I2CSCLo), 
		.OSDA(I2CSDAo)
);

// APB1 Slave5 : 1 channel timer
assign PREADY1_5 = 1;
timer_pwm Timer(
		.PCLK(PCLK),
		.PRESETn(ARESETn),
		.PSEL(PSEL1_5),
		.PENABLE(PENABLE1),
		.PADDR(PADDR1[4:2]),
		.PWRITE(PWRITE1), 
		.PWDATA(PWDATA1[15:0]),
		.PRDATA(PRDATA1_5),

		.TCLK(1'b1),
		.TCAP(1'b1),
		.INT_TPOUT(),
		.INT_TOF(TimerIntOverFlow),
		.INT_TMC(TimerIntMatch)
);

// APB1 Slave6 : Display Controller
//assign PRDATA1_6 = 0;
assign PREADY1_6 = 1;

// APB1 Slave7 : I2S Controller
assign PREADY1_7 = 1;
I2S_Top I2SCtrl
(
		.SYS_CLK(DDRCLK),

		//	APB
		.PCLK(PCLK),
		.PRESETn(ARESETn),
		.PENABLE(PENABLE1),
		.PSEL(PSEL1_7),
		.PWRITE(PWRITE1),
		.PADDR(PADDR1[3:2]),
		.PWDATA(PWDATA1),
		.PRDATA(PRDATA1_7),

		// Interrupt Out
		.Interrupt(I2SInt),

		// DMA Request
		.TxDMAReq(I2STxDMAReq),
		.RxDMAReq(I2SRxDMAReq),

		.MCLK(MCLK),
		.MCLK_OE(MCLK_OE),
		.BCLK_O(BCLK_O),
		.BCLK_I(BCLK_I),
		.BCLK_OE(BCLK_OE),
		.LRCLK_O(LRCLK_O),
		.LRCLK_I(LRCLK_I),
		.LRCLK_OE(LRCLK_OE),
		.SDIN(SDIN),
		.SDOUT(SDOUT)
);

endmodule
