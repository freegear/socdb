// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : Dmac2x2Ch.v
// File Revision       : 0.1
// ------------------------------------------------------------------------------
//  Purpose            : 2x2 Channel AXI DMA Controller Top
// ==============================================================================


`timescale 1ns/1ps

module Dmac2x2Ch
(
		//	CLK & Reset
		ACLK     ,
		ARESETn  ,

		DMAReq,
		DMAAck,
		Interrupt,

		// APB interface : PCLK/PRESETn should be equal to ACLK/ARESETn
		PENABLE, 
		PSEL,
		PWRITE, 
		PADDR, 
		PWDATA,
		PRDATA,

		// AXI Interface
		ARID,
		ARVALID,
		ARREADY,
		ARADDR,
		ARLEN,
		ARSIZE,
		ARBURST,

		RID,
		RDATA,
		RRESP,
		RLAST,
		RVALID,
		RREADY,

		AWID,
		AWVALID,
		AWREADY,
		AWADDR,
		AWLEN,
		AWSIZE,
		AWBURST,

		WID,
		WDATA,
		WSTRB,
		WLAST,
		WVALID,
		WREADY,

		BID,
		BRESP,
		BVALID,
		BREADY
);

//
// input/output port
//
input         ACLK;
input         ARESETn;

input  [3:0]  DMAReq;
output [3:0]  DMAAck;

output [3:0]  Interrupt;

input         PENABLE; 
input         PSEL;
input         PWRITE;
input  [6:2]  PADDR;
input  [31:0] PWDATA;
output [31:0] PRDATA;

output        ARID;
output        ARVALID;
input         ARREADY;
output [31:0] ARADDR;
output [3:0]  ARLEN;
output [2:0]  ARSIZE;
output [1:0]  ARBURST;

input         RID;
input  [31:0] RDATA;
input  [1:0]  RRESP;
input         RLAST;
input         RVALID;
output        RREADY;

output        AWID;
output        AWVALID;
input         AWREADY;
output [31:0] AWADDR;
output [3:0]  AWLEN;
output [2:0]  AWSIZE;
output [1:0]  AWBURST;

output        WID;
output [31:0] WDATA;
output [3:0]  WSTRB;
output        WLAST;
output        WVALID;
input         WREADY;

input         BID;
input  [1:0]  BRESP;
input         BVALID;
output        BREADY;

wire          PCLK0;
wire          PRESETn0;
wire          PENABLE0; 
wire          PSEL0;
wire          PWRITE0;
wire   [5:2]  PADDR0;
wire   [31:0] PWDATA0;
wire   [31:0] PRDATA0;

wire          PCLK1;
wire          PRESETn1;
wire          PENABLE1; 
wire          PSEL1;
wire          PWRITE1;
wire   [5:2]  PADDR1;
wire   [31:0] PWDATA1;
wire   [31:0] PRDATA1;

wire          ARVALID0;
wire          ARREADY0;
wire   [31:0] ARADDR0;
wire   [3:0]  ARLEN0;
wire   [2:0]  ARSIZE0;
wire   [1:0]  ARBURST0;

wire   [31:0] RDATA0;
wire   [1:0]  RRESP0;
wire          RLAST0;
wire          RVALID0;
wire          RREADY0;

wire          AWVALID0;
wire          AWREADY0;
wire   [31:0] AWADDR0;
wire   [3:0]  AWLEN0;
wire   [2:0]  AWSIZE0;
wire   [1:0]  AWBURST0;

wire   [31:0] WDATA0;
wire   [3:0]  WSTRB0;
wire          WLAST0;
wire          WVALID0;
wire          WREADY0;

wire   [1:0]  BRESP0;
wire          BVALID0;
wire          BREADY0;

wire          ARVALID1;
wire          ARREADY1;
wire   [31:0] ARADDR1;
wire   [3:0]  ARLEN1;
wire   [2:0]  ARSIZE1;
wire   [1:0]  ARBURST1;

wire   [31:0] RDATA1;
wire   [1:0]  RRESP1;
wire          RLAST1;
wire          RVALID1;
wire          RREADY1;

wire          AWVALID1;
wire          AWREADY1;
wire   [31:0] AWADDR1;
wire   [3:0]  AWLEN1;
wire   [2:0]  AWSIZE1;
wire   [1:0]  AWBURST1;

wire   [31:0] WDATA1;
wire   [3:0]  WSTRB1;
wire          WLAST1;
wire          WVALID1;
wire          WREADY1;

wire   [1:0]  BRESP1;
wire          BVALID1;
wire          BREADY1;

DmacAPBMux #(.PADDR_MAX(6)) APBMux
(
		.PCLK(PCLK),
		.PRESETn(PRESETn),
		.PENABLE(PENABLE),
		.PSEL(PSEL),
		.PWRITE(PWRITE),
		.PADDR(PADDR),
		.PWDATA(PWDATA),
		.PRDATA(PRDATA),

		.PCLK0(PCLK0),
		.PRESETn0(PRESETn1),
		.PENABLE0(PENABLE0),
		.PSEL0(PSEL0),
		.PWRITE0(PWRITE0),
		.PADDR0(PADDR0),
		.PWDATA0(PWDATA0),
		.PRDATA0(PRDATA0),

		.PCLK1(PCLK1),
		.PRESETn1(PRESETn1),
		.PENABLE1(PENABLE1),
		.PSEL1(PSEL1),
		.PWRITE1(PWRITE1),
		.PADDR1(PADDR1),
		.PWDATA1(PWDATA1),
		.PRDATA1(PRDATA1)
);

DmacAXIArbiter AXI2x1Arbiter
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.ARVALID0(ARVALID0),
		.ARREADY0(ARREADY0),
		.ARADDR0(ARADDR0),
		.ARLEN0(ARLEN0),
		.ARSIZE0(ARSIZE0),
		.ARBURST0(ARBURST0),

		.RDATA0(RDATA0),
		.RRESP0(RRESP0),
		.RLAST0(RLAST0),
		.RVALID0(RVALID0),
		.RREADY0(RREADY0),

		.AWVALID0(AWVALID0),
		.AWREADY0(AWREADY0),
		.AWADDR0(AWADDR0),
		.AWLEN0(AWLEN0),
		.AWSIZE0(AWSIZE0),
		.AWBURST0(AWBURST0),

		.WDATA0(WDATA0),
		.WSTRB0(WSTRB0),
		.WLAST0(WLAST0),
		.WVALID0(WVALID0),
		.WREADY0(WREADY0),

		.BRESP0(BRESP0),
		.BVALID0(BVALID0),
		.BREADY0(BREADY0),

		.ARVALID1(ARVALID1),
		.ARREADY1(ARREADY1),
		.ARADDR1(ARADDR1),
		.ARLEN1(ARLEN1),
		.ARSIZE1(ARSIZE1),
		.ARBURST1(ARBURST1),

		.RDATA1(RDATA1),
		.RRESP1(RRESP1),
		.RLAST1(RLAST1),
		.RVALID1(RVALID1),
		.RREADY1(RREADY1),

		.AWVALID1(AWVALID1),
		.AWREADY1(AWREADY1),
		.AWADDR1(AWADDR1),
		.AWLEN1(AWLEN1),
		.AWSIZE1(AWSIZE1),
		.AWBURST1(AWBURST1),

		.WDATA1(WDATA1),
		.WSTRB1(WSTRB1),
		.WLAST1(WLAST1),
		.WVALID1(WVALID1),
		.WREADY1(WREADY1),

		.BRESP1(BRESP1),
		.BVALID1(BVALID1),
		.BREADY1(BREADY1),

		.ARID(ARID),
		.ARVALID(ARVALID),
		.ARREADY(ARREADY),
		.ARADDR(ARADDR),
		.ARLEN(ARLEN),
		.ARSIZE(ARSIZE),
		.ARBURST(ARBURST),

		.RID(RID),
		.RDATA(RDATA),
		.RRESP(RRESP),
		.RLAST(RLAST),
		.RVALID(RVALID),
		.RREADY(RREADY),

		.AWID(AWID),
		.AWVALID(AWVALID),
		.AWREADY(AWREADY),
		.AWADDR(AWADDR),
		.AWLEN(AWLEN),
		.AWSIZE(AWSIZE),
		.AWBURST(AWBURST),

		.WID(WID),
		.WDATA(WDATA),
		.WSTRB(WSTRB),
		.WLAST(WLAST),
		.WVALID(WVALID),
		.WREADY(WREADY),

		.BID(BID),
		.BRESP(BRESP),
		.BVALID(BVALID),
		.BREADY(BREADY)
);

Dmac2Ch Dmac2_0
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.DMAReq(DMAReq[1:0]),
		.DMAAck(DMAAck[1:0]),
		.Interrupt(Interrupt[1:0]),

		.PENABLE(PENABLE0),
		.PSEL(PSEL0),
		.PWRITE(PWRITE0),
		.PADDR(PADDR0),
		.PWDATA(PWDATA0),
		.PRDATA(PRDATA0),

		.ARVALID(ARVALID0),
		.ARREADY(ARREADY0),
		.ARADDR(ARADDR0),
		.ARLEN(ARLEN0),
		.ARSIZE(ARSIZE0),
		.ARBURST(ARBURST0),

		.RDATA(RDATA0),
		.RRESP(RRESP0),
		.RLAST(RLAST0),
		.RVALID(RVALID0),
		.RREADY(RREADY0),

		.AWVALID(AWVALID0),
		.AWREADY(AWREADY0),
		.AWADDR(AWADDR0),
		.AWLEN(AWLEN0),
		.AWSIZE(AWSIZE0),
		.AWBURST(AWBURST0),

		.WDATA(WDATA0),
		.WSTRB(WSTRB0),
		.WLAST(WLAST0),
		.WVALID(WVALID0),
		.WREADY(WREADY0),

		.BRESP(BRESP0),
		.BVALID(BVALID0),
		.BREADY(BREADY0)
);

Dmac2Ch Dmac2_1
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.DMAReq(DMAReq[3:2]),
		.DMAAck(DMAAck[3:2]),
		.Interrupt(Interrupt[3:2]),

		.PENABLE(PENABLE1),
		.PSEL(PSEL1),
		.PWRITE(PWRITE1),
		.PADDR(PADDR1),
		.PWDATA(PWDATA1),
		.PRDATA(PRDATA1),

		.ARVALID(ARVALID1),
		.ARREADY(ARREADY1),
		.ARADDR(ARADDR1),
		.ARLEN(ARLEN1),
		.ARSIZE(ARSIZE1),
		.ARBURST(ARBURST1),

		.RDATA(RDATA1),
		.RRESP(RRESP1),
		.RLAST(RLAST1),
		.RVALID(RVALID1),
		.RREADY(RREADY1),

		.AWVALID(AWVALID1),
		.AWREADY(AWREADY1),
		.AWADDR(AWADDR1),
		.AWLEN(AWLEN1),
		.AWSIZE(AWSIZE1),
		.AWBURST(AWBURST1),

		.WDATA(WDATA1),
		.WSTRB(WSTRB1),
		.WLAST(WLAST1),
		.WVALID(WVALID1),
		.WREADY(WREADY1),

		.BRESP(BRESP1),
		.BVALID(BVALID1),
		.BREADY(BREADY1)
);

endmodule
