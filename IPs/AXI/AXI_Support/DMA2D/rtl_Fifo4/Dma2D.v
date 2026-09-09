// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : Dma2D.v
// File Revision       : 0.1
// ------------------------------------------------------------------------------
//  Purpose            : 1 Channel AXI 2D DMA Controller Top
// ==============================================================================


`timescale 1ns/1ps

module Dma2D
(
		//	CLK & Reset
		ACLK     ,
		ARESETn  ,

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

output        Interrupt;

input         PENABLE; 
input         PSEL;
input         PWRITE;
input  [4:2]  PADDR;
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

wire [31:0] SrcAddr;
wire [31:0] DestAddr;
wire [15:0] ByteCnt;
wire [31:0] LineCnt;
wire [31:0] AddrUpd;

wire        SrcAddrWE;
wire        DestAddrWE;
wire        LineCntWE;

wire [31:0] SrcAddrWData;
wire [31:0] DestAddrWData;
wire [31:0] LineCntWData;

wire        Active;
wire        Enabled;

wire        ErrorInterrupt;
wire        StopInterrupt;

wire FifoReset;
wire [3:0] FifoNumByte;

wire [1:0]  FifoSrcWidth;
wire [31:0] FifoDataIn;
wire        FifoWriteEn;
wire [1:0]  FifoSrcAddr;

wire [1:0]  FifoDstWidth;
wire [31:0] FifoDataOut;
wire [3:0]  FifoDataMask;
wire        FifoReadEn;
wire [1:0]  FifoDstAddr;

Dma2DReg Registers(
	.PCLK(ACLK),
	.PRESETn(ARESETn),
	.PENABLE(PENABLE),
	.PSEL(PSEL),
	.PWRITE(PWRITE),
	.PADDR(PADDR),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA),

	.SrcAddr(SrcAddr),
	.DestAddr(DestAddr),
	.ByteCnt(ByteCnt),
	.LineCnt(LineCnt),
	.AddrUpd(AddrUpd),

	.SrcAddrWE(SrcAddrWE),
	.DestAddrWE(DestAddrWE),
	.LineCntWE(LineCntWE),

	.SrcAddrWData(SrcAddrWData),
	.DestAddrWData(DestAddrWData),
	.LineCntWData(LineCntWData),

	.Active(Active),
	.Enabled(Enabled),

	.ErrorInterruptIn(ErrorInterrupt),
	.StopInterruptIn(StopInterrupt),

	.Interrupt(Interrupt)
);

// FIFO
Dma2DFifo Dma2DFifo
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.FifoReset(FifoReset),
		.NumByte(FifoNumByte),

		.SrcWidth(FifoSrcWidth),
		.DataIn(FifoDataIn),
		.WriteEn(FifoWriteEn),
		.SrcAddr(FifoSrcAddr),

		.DstWidth(FifoDstWidth),
		.DataOut(FifoDataOut),
		.DataMask(FifoDataMask),
		.ReadEn(FifoReadEn),
		.DstAddr(FifoDstAddr)
);

// Control
Dma2DCtrl Ctrl
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.Enabled(Enabled),
		.Active(Active),

		.FifoReset(FifoReset),
		.FifoNumByte(FifoNumByte),
		.FifoSrcWidth(FifoSrcWidth),
		.FifoDataIn(FifoDataIn),
		.FifoWriteEn(FifoWriteEn),
		.FifoSrcAddr(FifoSrcAddr),
		.FifoDstWidth(FifoDstWidth),
		.FifoDataOut(FifoDataOut),
		.FifoDataMask(FifoDataMask),
		.FifoReadEn(FifoReadEn),
		.FifoDstAddr(FifoDstAddr),

		.SrcAddr(SrcAddr),
		.DestAddr(DestAddr),
		.ByteCnt(ByteCnt),
		.LineCnt(LineCnt),
		.AddrUpd(AddrUpd),

		.SrcAddrWE(SrcAddrWE),
		.DestAddrWE(DestAddrWE),
		.LineCntWE(LineCntWE),

		.SrcAddrWData(SrcAddrWData),
		.DestAddrWData(DestAddrWData),
		.LineCntWData(LineCntWData),

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
		
		.ErrorInterrupt(ErrorInterrupt),
		.StopInterrupt(StopInterrupt)
);

endmodule
