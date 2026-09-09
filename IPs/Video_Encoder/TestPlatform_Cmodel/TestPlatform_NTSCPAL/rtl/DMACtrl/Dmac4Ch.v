// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : Dmac4Ch.v
// File Revision       : 0.1
// ------------------------------------------------------------------------------
//  Purpose            : 4 Channel AXI DMA Controller Top
// ==============================================================================


`timescale 1ns/1ps

module Dmac4Ch
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
		ARVALID,
		ARREADY,
		ARADDR,
		ARLEN,
		ARSIZE,
		ARBURST,

		RDATA,
		RRESP,
		RLAST,
		RVALID,
		RREADY,

		AWVALID,
		AWREADY,
		AWADDR,
		AWLEN,
		AWSIZE,
		AWBURST,

		WDATA,
		WSTRB,
		WLAST,
		WVALID,
		WREADY,

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

output        ARVALID;
input         ARREADY;
output [31:0] ARADDR;
output [3:0]  ARLEN;
output [2:0]  ARSIZE;
output [1:0]  ARBURST;

input  [31:0] RDATA;
input  [1:0]  RRESP;
input         RLAST;
input         RVALID;
output        RREADY;

output        AWVALID;
input         AWREADY;
output [31:0] AWADDR;
output [3:0]  AWLEN;
output [2:0]  AWSIZE;
output [1:0]  AWBURST;

output [31:0] WDATA;
output [3:0]  WSTRB;
output        WLAST;
output        WVALID;
input         WREADY;

input  [1:0]  BRESP;
input         BVALID;
output        BREADY;

wire Start;
wire Ready;

wire [31:0] ChControl;
wire [31:0] ChSrcAddr;
wire [31:0] ChDestAddr;
wire [31:0] ChDescriptor;

wire        ChControlWE;
wire        ChSrcAddrWE;
wire        ChDestAddrWE;
wire        ChDescriptorWE;

wire [31:0] ChControlWData;
wire [31:0] ChSrcAddrWData;
wire [31:0] ChDestAddrWData;
wire [31:0] ChDescriptorWData;

wire        StartInterrupt;
wire        EndInterrupt;
wire        ErrorInterrupt;
wire        StopInterrupt;

wire [3:0]  Active;
wire [3:0]  Memory2Memory;
wire [3:0]  Enabled;

DmacReqAck4Ch ReqProcUnit(
	.ACLK(ACLK),
	.ARESETn(ARESETn),

	.DMAReq(DMAReq),
	.DMAAck(DMAAck),

	.Start(Start),
	.Ready(Ready),

	.Active(Active),
	.Memory2Memory(Memory2Memory),
	.Enabled(Enabled)

);

DmacRegFile4Ch RegFile(
	.PCLK(ACLK),
	.PRESETn(ARESETn),
	.PENABLE(PENABLE),
	.PSEL(PSEL),
	.PWRITE(PWRITE),
	.PADDR(PADDR),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA),

	.Active(Active),
	.Enabled(Enabled),
	.Memory2Memory(Memory2Memory),

	.Control(ChControl),
	.SrcAddr(ChSrcAddr),
	.DestAddr(ChDestAddr),
	.Descriptor(ChDescriptor),
	.Status(),

	.ControlWE(ChControlWE),
	.SrcAddrWE(ChSrcAddrWE),
	.DestAddrWE(ChDestAddrWE),
	.DescriptorWE(ChDescriptorWE),

	.ControlWData(ChControlWData),
	.SrcAddrWData(ChSrcAddrWData),
	.DestAddrWData(ChDestAddrWData),
	.DescriptorWData(ChDescriptorWData),

	.StartInterruptIn(StartInterrupt),
	.EndInterruptIn(EndInterrupt),
	.ErrorInterruptIn(ErrorInterrupt),
	.StopInterruptIn(StopInterrupt),

	.Interrupt(Interrupt)
);

DmacEngine Engine
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.Start(Start),
		.Ready(Ready),

		.ChControl(ChControl),
		.ChSrcAddr(ChSrcAddr),
		.ChDestAddr(ChDestAddr),
		.ChDescriptor(ChDescriptor),

		.ChControlWE(ChControlWE),
		.ChSrcAddrWE(ChSrcAddrWE),
		.ChDestAddrWE(ChDestAddrWE),
		.ChDescriptorWE(ChDescriptorWE),
		.ChControlWData(ChControlWData),
		.ChSrcAddrWData(ChSrcAddrWData),
		.ChDestAddrWData(ChDestAddrWData),
		.ChDescriptorWData(ChDescriptorWData),

		.ARVALID(ARVALID),
		.ARREADY(ARREADY),
		.ARADDR(ARADDR),
		.ARLEN(ARLEN),
		.ARSIZE(ARSIZE),
		.ARBURST(ARBURST),

		.RDATA(RDATA),
		.RRESP(RRESP),
		.RLAST(RLAST),
		.RVALID(RVALID),
		.RREADY(RREADY),

		.AWVALID(AWVALID),
		.AWREADY(AWREADY),
		.AWADDR(AWADDR),
		.AWLEN(AWLEN),
		.AWSIZE(AWSIZE),
		.AWBURST(AWBURST),

		.WDATA(WDATA),
		.WSTRB(WSTRB),
		.WLAST(WLAST),
		.WVALID(WVALID),
		.WREADY(WREADY),

		.BRESP(BRESP),
		.BVALID(BVALID),
		.BREADY(BREADY),
		
		.StartInterrupt(StartInterrupt),
		.EndInterrupt(EndInterrupt),
		.ErrorInterrupt(ErrorInterrupt),
		.StopInterrupt(StopInterrupt)
);

endmodule
