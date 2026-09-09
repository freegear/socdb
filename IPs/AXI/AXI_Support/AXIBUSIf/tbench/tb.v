//
// tb.v
// Description : Test Bench For AXIBUSIf
//
// Copyright(C) 2008 RichenTech 
//
// 20-Feb-2008 holelee Created
//

`timescale 1 ns/ 10ps
module tb;

parameter CLK_PERIOD=10;	// should be even integer
parameter CLK_HPERIOD = CLK_PERIOD/2;
parameter DATA_WIDTH = 32;
parameter NUM_BYTE = DATA_WIDTH/8;

// auto assign from above parameter

reg CLK;	// clock
reg RESETn;	// Active Low Asynchronous Reset

always #CLK_HPERIOD	CLK = ~CLK;

initial CLK= 0;
initial
begin
	RESETn 	= 0;     // reset
	repeat(10) @(posedge CLK);
	RESETn	= 1;
end


wire        Req;
wire [31:0] ReqAddr;
wire [ 3:0] ReqLen;
wire        ReqRnW;
wire [DATA_WIDTH-1:0] WriteData;
wire [NUM_BYTE-1:0] WriteEn;
wire        WriteDataReady;
wire [DATA_WIDTH-1:0] ReadData;
wire        ReadDataValid;
TestReqGen #(.DATA_WIDTH(DATA_WIDTH)) TestReqGen(
        .CLK(CLK),
        .RESETn(RESETn),

        .Req(Req),
        .ReqAddr(ReqAddr),
        .ReqLen(ReqLen),
        .ReqRnW(ReqRnW),
        .ReqAck(ReqAck),

        .WriteData(WriteData),
        .WriteEn(WriteEn),
        .WriteDataReady(WriteDataReady),
        .ReadData(ReadData),
        .ReadDataValid(ReadDataValid)
);

wire        ARVALID;
wire        ARREADY;
wire [31:0] ARADDR;
wire [3:0]  ARLEN;
wire [2:0]  ARSIZE;
wire [1:0]  ARBURST;

wire [DATA_WIDTH-1:0] RDATA;
wire        RVALID;
wire        RREADY;

wire        AWVALID;
wire        AWREADY;
wire [31:0] AWADDR;
wire [3:0]  AWLEN;
wire [2:0]  AWSIZE;
wire [1:0]  AWBURST;

wire [DATA_WIDTH-1:0] WDATA;
wire [NUM_BYTE-1:0]  WSTRB;
wire        WLAST;
wire        WVALID;
wire        WREADY;

wire [1:0]  BRESP;
wire        BVALID;
wire        BREADY;

AXIBUSIf #(.DATA_WIDTH(DATA_WIDTH)) AXIBUSIf(
	.Req(Req),
	.ReqAddr(ReqAddr),
	.ReqLen(ReqLen),
	.ReqRnW(ReqRnW),
	.ReqAck(ReqAck),

	.ARVALID(ARVALID),
	.ARREADY(ARREADY),
	.ARADDR(ARADDR),
	.ARLEN(ARLEN),
	.ARSIZE(ARSIZE),
	.ARBURST(ARBURST),

	.RDATA(RDATA),
	.RVALID(RVALID),
	.RREADY(RREADY),


	.ReadData(ReadData),
	.ReadDataValid(ReadDataValid),

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

	.WriteData(WriteData),
	.WriteEn(WriteEn),
	.WriteDataReady,
	.ACLK(CLK),
	.ARESETn(RESETn)
);

TestSlave #(.DATA_WIDTH(DATA_WIDTH)) TestSlave
(
	.ACLK(CLK),
	.ARESETn(RESETn),

	.AWID(0),
	.AWADDR(AWADDR),
	.AWLEN(AWLEN),
	.AWSIZE(AWSIZE),
	.AWBURST(AWBURST),
        .AWLOCK(0),
        .AWCACHE(0),
        .AWPROT(0),
	.AWVALID(AWVALID),
	.AWREADY(AWREADY),

	.WID(0),
	.WDATA(WDATA),
	.WSTRB(WSTRB),
	.WLAST(WLAST),
	.WVALID(WVALID),
	.WREADY(WREADY),

	.BID(),
	.BRESP(BRESP),
	.BVALID(BVALID),
	.BREADY(BREADY),

	.ARID(0),
	.ARADDR(ARADDR),
	.ARLEN(ARLEN),
	.ARSIZE(ARSIZE),
	.ARBURST(ARBURST),
        .ARLOCK(0),
        .ARCACHE(0),
        .ARPROT(0),
	.ARVALID(ARVALID),
	.ARREADY(ARREADY),

	.RID(),
	.RDATA(RDATA),
	.RRESP(),
	.RLAST(RLAST),
	.RVALID(RVALID),
	.RREADY(RREADY)
);

endmodule

