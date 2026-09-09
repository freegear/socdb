// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : tarm_axi_fastclk.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : toy arm with AXI interface.
//                     : And toyarm  should run faster than AXI BUS
//  =============================================================================

`timescale 1ns/1ps

module tarm_axi_fastclk
(
		ACLK     , 			// ToyARM clock, BUS clock is slower than this.
		ARESETn  , 

		BusClockEn,		// BUS clock rising indicator

		// Interrupt
		ARMnFIQ  ,
		ARMnIRQ  ,

		// Write Address Channel
		AWADDR   ,
		AWLEN    ,
		AWSIZE   ,
		AWBURST  ,
		AWLOCK   ,
		AWCACHE  ,
		AWPROT   ,
		AWVALID  ,
		AWREADY  ,

		// Write Data Channel
		WDATA    ,
		WSTRB    ,
		WLAST    ,
		WVALID   ,
		WREADY   ,

		// Write Response Channel
		BRESP    ,
		BVALID   ,
		BREADY   ,

		// Read Address Channel
		ARADDR   ,
		ARLEN    ,
		ARSIZE   ,
		ARBURST  ,
		ARLOCK   ,
		ARCACHE  ,
		ARPROT   ,
		ARVALID  ,
		ARREADY  ,

		// Read Data Channel
		RDATA    ,
		RRESP    ,
		RLAST    ,
		RVALID   ,
		RREADY
);

//
// input/output port
//
input         ACLK;
input         ARESETn;

input         BusClockEn;

input         ARMnFIQ;
input         ARMnIRQ;

output [31:0] AWADDR;
output [3:0]  AWLEN;
output [2:0]  AWSIZE;
output [1:0]  AWBURST;
output [1:0]  AWLOCK;
output [3:0]  AWCACHE;
output [2:0]  AWPROT;
output        AWVALID;
input         AWREADY;

output [31:0] WDATA;
output [3:0]  WSTRB;
output        WLAST;
output        WVALID;
input         WREADY;

input  [1:0]  BRESP;
input         BVALID;
output        BREADY;

output [31:0] ARADDR;
output [3:0]  ARLEN;
output [2:0]  ARSIZE;
output [1:0]  ARBURST;
output [1:0]  ARLOCK;
output [3:0]  ARCACHE;
output [2:0]  ARPROT;
output        ARVALID;
input         ARREADY;

input  [31:0] RDATA;
input  [1:0]  RRESP;
input         RLAST;
input         RVALID;
output        RREADY;

wire [31:0] AWADDR_Fast;
wire [3:0]  AWLEN_Fast;
wire [2:0]  AWSIZE_Fast;
wire [1:0]  AWBURST_Fast;
wire [1:0]  AWLOCK_Fast;
wire [3:0]  AWCACHE_Fast;
wire [2:0]  AWPROT_Fast;
wire        AWVALID_Fast;
wire        AWREADY_Fast;

wire [31:0] WDATA_Fast;
wire [3:0]  WSTRB_Fast;
wire        WLAST_Fast;
wire        WVALID_Fast;
wire        WREADY_Fast;

wire [1:0]  BRESP_Fast;
wire        BVALID_Fast;
wire        BREADY_Fast;

wire [31:0] ARADDR_Fast;
wire [3:0]  ARLEN_Fast;
wire [2:0]  ARSIZE_Fast;
wire [1:0]  ARBURST_Fast;
wire [1:0]  ARLOCK_Fast;
wire [3:0]  ARCACHE_Fast;
wire [2:0]  ARPROT_Fast;
wire        ARVALID_Fast;
wire        ARREADY_Fast;

wire [31:0] RDATA_Fast;
wire [1:0]  RRESP_Fast;
wire        RLAST_Fast;
wire        RVALID_Fast;
wire        RREADY_Fast;

tarm_axi tarm_axi
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		// Interrupt
		.ARMnFIQ(ARMnFIQ),
		.ARMnIRQ(ARMnIRQ),

		// Write Address Channel
		.AWADDR(AWADDR_Fast),
		.AWLEN(AWLEN_Fast),
		.AWSIZE(AWSIZE_Fast),
		.AWBURST(AWBURST_Fast),
		.AWLOCK(AWLOCK_Fast),
		.AWCACHE(AWCACHE_Fast),
		.AWPROT(AWPROT_Fast),
		.AWVALID(AWVALID_Fast),
		.AWREADY(AWREADY_Fast),

		// Write Data Channel
		.WDATA(WDATA_Fast),
		.WSTRB(WSTRB_Fast),
		.WLAST(WLAST_Fast),
		.WVALID(WVALID_Fast),
		.WREADY(WREADY_Fast),

		// Write Response Channel
		.BRESP(BRESP_Fast),
		.BVALID(BVALID_Fast),
		.BREADY(BREADY_Fast),

		// Read Address Channel
		.ARADDR(ARADDR_Fast),
		.ARLEN(ARLEN_Fast),
		.ARSIZE(ARSIZE_Fast),
		.ARBURST(ARBURST_Fast),
		.ARLOCK(ARLOCK_Fast),
		.ARCACHE(ARCACHE_Fast),
		.ARPROT(ARPROT_Fast),
		.ARVALID(ARVALID_Fast),
		.ARREADY(ARREADY_Fast),

		// Read Data Channel
		.RDATA(RDATA_Fast),
		.RRESP(RRESP_Fast),
		.RLAST(RLAST_Fast),
		.RVALID(RVALID_Fast),
		.RREADY(RREADY_Fast)
);

//
// Downward synchronizing routine
//

// AW Channel
F2SSlice_Advanced #(50) aw_f2sslice(
	.ACLK_Fast(ACLK),
	.ARESETn(ARESETn),
	.SlowClockEn(BusClockEn),
	.INFORMATION_F({AWADDR_Fast, AWLEN_Fast, AWSIZE_Fast, AWBURST_Fast, AWLOCK_Fast, AWCACHE_Fast, AWPROT_Fast}),
	.VALID_F(AWVALID_Fast),
	.READY_F(AWREADY_Fast),
	.INFORMATION_S({AWADDR, AWLEN, AWSIZE, AWBURST, AWLOCK, AWCACHE, AWPROT}),
	.VALID_S(AWVALID),
	.READY_S(AWREADY)
);
	
// WD Channel
F2SSlice_Advanced #(37) wd_f2sslice(
	.ACLK_Fast(ACLK),
	.ARESETn(ARESETn),
	.SlowClockEn(BusClockEn),
	.INFORMATION_F({WDATA_Fast, WSTRB_Fast, WLAST_Fast}),
	.VALID_F(WVALID_Fast),
	.READY_F(WREADY_Fast),
	.INFORMATION_S({WDATA, WSTRB, WLAST}),
	.VALID_S(WVALID),
	.READY_S(WREADY)
);
	
// WR Channel
S2FSlice #(2) wr_s2fslice(
	.ACLK_Fast(ACLK),
	.ARESETn(ARESETn),
	.SlowClockEn(BusClockEn),
	.INFORMATION_F({BRESP_Fast}),
	.VALID_F(BVALID_Fast),
	.READY_F(BREADY_Fast),
	.INFORMATION_S({BRESP}),
	.VALID_S(BVALID),
	.READY_S(BREADY)
);

// AR Channel
F2SSlice_Advanced #(50) ar_f2sslice(
	.ACLK_Fast(ACLK),
	.ARESETn(ARESETn),
	.SlowClockEn(BusClockEn),
	.INFORMATION_F({ARADDR_Fast, ARLEN_Fast, ARSIZE_Fast, ARBURST_Fast, ARLOCK_Fast, ARCACHE_Fast, ARPROT_Fast}),
	.VALID_F(ARVALID_Fast),
	.READY_F(ARREADY_Fast),
	.INFORMATION_S({ARADDR, ARLEN, ARSIZE, ARBURST, ARLOCK, ARCACHE, ARPROT}),
	.VALID_S(ARVALID),
	.READY_S(ARREADY)
);
	
// RD Channel
S2FSlice #(35) rd_s2fslice(
	.ACLK_Fast(ACLK),
	.ARESETn(ARESETn),
	.SlowClockEn(BusClockEn),
	.INFORMATION_F({RDATA_Fast, RRESP_Fast, RLAST_Fast}),
	.VALID_F(RVALID_Fast),
	.READY_F(RREADY_Fast),
	.INFORMATION_S({RDATA, RRESP, RLAST}),
	.VALID_S(RVALID),
	.READY_S(RREADY)
);

endmodule
