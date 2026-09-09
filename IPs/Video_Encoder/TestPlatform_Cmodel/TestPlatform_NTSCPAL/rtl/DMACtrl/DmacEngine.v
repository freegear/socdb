// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DmacEngine.v
// File Revision       : 0.1
// ------------------------------------------------------------------------------
//  Purpose            : This module is a part of AXI DMA Controller
//                     : Dmac Processing Engine
// ==============================================================================


`timescale 1ns/1ps

module DmacEngine
(
		//	CLK & Reset
		ACLK     ,
		ARESETn  ,

		// Triggering signal
		Start   ,	// Input  : Start Operation
		Ready   ,	// Output : Operation Idle

		// From Register File
		ChControl   ,	// Input : Channel Control Register
		ChSrcAddr   ,	// Input ; Channel Source Address
		ChDestAddr  ,	// Input : Channel Destination Address
		ChDescriptor,	// Input : Channel Descriptor

		// To Register File
		ChControlWE,	// Output : Channel Control Register Write Enable(active high)
		ChSrcAddrWE,	// Output : Channel Source Address Write Enable(acthive high)
		ChDestAddrWE,	// Output : Channel Destination Address Write Enable(acthive high)
		ChDescriptorWE,	// Output : Channel Descriptor Write Enable(acthive high)
		ChControlWData,	// Output : Control Register Write Data
		ChSrcAddrWData,	// Output : Destination Register Write Data
		ChDestAddrWData,	// Output : Destination Address Register Write Data
		ChDescriptorWData,	// Output : Channel Register Write Data

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
		BREADY,
		
		StartInterrupt,		// Output : Start(end of descriptor load) interrupt
		EndInterrupt,		// Output : End(Length is zero) interrupt
		ErrorInterrupt,		// Output : Error(bus & other) Interrupt
		StopInterrupt		// Output : Stop(length is zero, no further descriptor) Interrupt
);

//
// input/output port
//
input  ACLK;
input  ARESETn;

input  Start;
output Ready;

input  [31:0] ChControl;
input  [31:0] ChSrcAddr;
input  [31:0] ChDestAddr;
input  [31:0] ChDescriptor;

output        ChControlWE;
output        ChSrcAddrWE;
output        ChDestAddrWE;
output        ChDescriptorWE;

output [31:0] ChControlWData;
output [31:0] ChSrcAddrWData;
output [31:0] ChDestAddrWData;
output [31:0] ChDescriptorWData;

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

output        StartInterrupt;
output        EndInterrupt;
output        ErrorInterrupt;
output        StopInterrupt;

wire FifoReset;
wire [4:0] NumByte;

wire [1:0]  SrcWidth;
wire [31:0] DataIn;
wire        WriteEn;
wire [1:0]  SrcAddr;

wire [1:0]  DstWidth;
wire [31:0] DataOut;
wire [3:0]  DataMask;
wire        ReadEn;
wire [1:0]  DstAddr;

// FIFO
DmacFifo DmacFifo
(
		.ACLK(ACLK),

		.FifoReset(FifoReset),
		.NumByte(NumByte),

		.SrcWidth(SrcWidth),
		.DataIn(DataIn),
		.WriteEn(WriteEn),
		.SrcAddr(SrcAddr),

		.DstWidth(DstWidth),
		.DataOut(DataOut),
		.DataMask(DataMask),
		.ReadEn(ReadEn),
		.DstAddr(DstAddr)
);

// Control
DmacControl Control
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.Start(Start),
		.Ready(Ready),

		.FifoReset(FifoReset),
		.NumByte(NumByte),
		.SrcWidth(SrcWidth),
		.DataIn(DataIn),
		.WriteEn(WriteEn),
		.SrcAddr(SrcAddr),
		.DstWidth(DstWidth),
		.DataOut(DataOut),
		.DataMask(DataMask),
		.ReadEn(ReadEn),
		.DstAddr(DstAddr),

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
