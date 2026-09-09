//
// AXIBUSIf.v
// Description : General AXI BUS Interface for AXI Master
//
// Copyright(C) 2008 RichenTech
//
// 18-Feb-2008 holelee Created
//

//
// CAUTIONS !!!
//
// When you assert Req, other request signals(ReqAddr,ReqLen,ReqRnW) should be stable until ReqAck is asserted.
//
// ReqAck is only asserted when Req is asserted.
// So you should not reference ReqAck before asserting Req.
//
// Write request can be acked after WriteDataReady is asserted.
// So you must connect WriteData & WriteDataReady simulateneously with Req(Write Request with ReqRnW == 0).
// But you are allowed to connect WriteData & WriteDataRead one cycle after Req is asserted
//
// Read request can be acked after ReadDataValid is asserted.
// So you must connect ReadData & ReadDataValid simulateneously with Req(Read Request with ReqRnW == 1).
// But you are allowed to connect ReadData & ReadDataValid one cycle after Req is asserted
// 

`timescale 1ns/1ps

//
// Configuration define
//
`define AXIBUSIF_WRITE	1	// define this if you want to support WRITE
`define AXIBUSIF_READ	1	// define this if you want to support READ

module AXIBUSIf
(
	Req,		// Request Strobe(Active High)
	ReqAddr,	// Request Address
	ReqLen,		// Request Burst Length
`ifdef AXIBUSIF_READ
`ifdef AXIBUSIF_WRITE
	ReqRnW,		// Request Type(1 when Read, 0 when Write)
`endif
`endif
	ReqAck,		// Request Ack(Active High)
			// Handshake done when both Req and ReqAck is high on rising of ACLK
`ifdef AXIBUSIF_READ
	// AXI Interface
	ARVALID,
	ARREADY,
	ARADDR,
	ARLEN,
	ARSIZE,
	ARBURST,

	RDATA,
	RVALID,
	RREADY,


	ReadData,	// Read Data
	ReadDataValid,	// Read Data Valid(Active High) : Latch Read Data when ReadDataValid is high on rising of ACLK
`endif

`ifdef AXIBUSIF_WRITE
	// AXI Interface
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

	WriteData,	// Write Data
	WriteEn,	// Write Data Byte Enable(Active High)
	WriteDataReady,	// Write Data Ready(Active High) : Toggle WriteData/WriteEn when WriteDataReady is high on rising of ACLK
`endif
	//	CLK & Reset
	ACLK,
	ARESETn
);

//
// Configuration Parameter
//
parameter DATA_WIDTH = 32;
parameter FIFO_DEPTH = 2;	// write request fifo depth

// alias(derivaties) and constants
parameter DW = DATA_WIDTH;	// for simple typing
parameter DENW = DATA_WIDTH/8;	// for simple typing
parameter FIFO_LEN = {FIFO_DEPTH{1'b1}};	// length corresspondent to FIFO_DEPTH
parameter AXISIZE = (DATA_WIDTH==32) ? 3'b010 : 3'b011;
parameter AXIBURST = 2'b01;	// always incremental burst

//
// input/output port
//
input  ACLK;
input  ARESETn;

input         Req;
input  [31:0] ReqAddr;
input  [ 3:0] ReqLen;
`ifdef AXIBUSIF_READ
`ifdef AXIBUSIF_WRITE
input         ReqRnW;
`else
wire          ReqRnW;
assign ReqRnW = 1'b1;
`endif
`else
wire          ReqRnW;
assign ReqRnW = 1'b0;
`endif
output        ReqAck;

`ifdef AXIBUSIF_READ
output        ARVALID;
input         ARREADY;
output [31:0] ARADDR;
output [3:0]  ARLEN;
output [2:0]  ARSIZE;
output [1:0]  ARBURST;

input  [DW-1:0] RDATA;
input         RVALID;
output        RREADY;

output [DW-1:0] ReadData;
output        ReadDataValid;
`endif

`ifdef AXIBUSIF_WRITE
output        AWVALID;
input         AWREADY;
output [31:0] AWADDR;
output [3:0]  AWLEN;
output [2:0]  AWSIZE;
output [1:0]  AWBURST;

output [DW-1:0] WDATA;
output [DENW-1:0]  WSTRB;
output        WLAST;
output        WVALID;
input         WREADY;

input  [1:0]  BRESP;
input         BVALID;
output        BREADY;

input  [DW-1:0] WriteData;
input  [DENW-1:0] WriteEn;
output        WriteDataReady;
`endif

`ifndef AXIBUSIF_READ
wire ARVALID;
wire ARREADY;
assign ARVALID = 1'b0;
assign ARREADY = 1'b0;
`endif
`ifndef AXIBUSIF_WRITE
wire AWVALID;
wire AWREADY;
assign AWVALID = 1'b0;
assign AWREADY = 1'b0;
`endif

//
// State Machine
//
reg [2:0] State;	// Current State
reg [2:0] NextState;	// Next State
parameter S_IDLE = 0, S_PEND = 1, S_ADDREQ = 2;

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		State <= 1;	// S_IDLE
	else State <= NextState;
end

assign ReqAck = Req && NextState[S_IDLE];

wire AXIRequestHandshake;
assign AXIRequestHandshake = (ARVALID&&ARREADY) || (AWVALID&&AWREADY);

wire AdditionalAddrReq;

always @(State or Req or ARVALID or ARREADY or AWVALID or AWREADY or AXIRequestHandshake or AdditionalAddrReq)
begin
	NextState = 0;
	case(1'b1)	// synopsys parallel_case full_case
	State[S_IDLE]:	// Idle State
		if(Req == 1'b1)
		begin
			if(ARVALID == 1'b1)
			begin
				if(ARREADY == 1'b0)
					NextState[S_PEND] = 1'b1;
				else if(AdditionalAddrReq == 1)
					NextState[S_ADDREQ] = 1'b1;
				else
					NextState[S_IDLE] = 1'b1;
			end
			else if(AWVALID == 1'b1)
			begin
				if(AWREADY == 1'b0)
					NextState[S_PEND] = 1'b1;
				else if(AdditionalAddrReq == 1)
					NextState[S_ADDREQ] = 1'b1;
				else
					NextState[S_IDLE] = 1'b1;
			end
			else	// Write Request, but FIFO full(Both ARVALID && AWVALID are low)
				NextState[S_PEND] = 1'b1;
		end
		else
			NextState[S_IDLE] = 1'b1;
	State[S_PEND]:	// Request Pending State
		if(AXIRequestHandshake)
		begin
			if(AdditionalAddrReq == 0)
				NextState[S_IDLE] = 1'b1;
			else
				NextState[S_ADDREQ] = 1'b1;
		end
		else
			NextState[S_PEND] = 1'b1;
	State[S_ADDREQ]:	// Additional Request State
		if(AXIRequestHandshake)
			NextState[S_IDLE] = 1'b1;
		else
			NextState[S_ADDREQ] = 1'b1;
	endcase
end

wire [31:0] Addr;
assign Addr = ReqAddr;

wire Addr_11_7;
assign Addr_11_7 = (&Addr[11:7]);

wire [3:0] LenWO4KBCross;
assign LenWO4KBCross = (DATA_WIDTH==32 && Addr_11_7 && Addr[6]) ? (4'd15-Addr[5:2]) : ((DATA_WIDTH==64 && Addr_11_7) ? (5'd15 - Addr[6:3]) : 4'd15);
assign AdditionalAddrReq = LenWO4KBCross < ReqLen[3:0];

wire [3:0] RealReqLen;
assign RealReqLen = (AdditionalAddrReq) ? LenWO4KBCross : ReqLen;

reg  [3:0] RemReqLen;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		RemReqLen <= 0;
	else if(AXIRequestHandshake)
	begin
		RemReqLen <= ReqLen - RealReqLen - 1;
	end
end

wire [31:0] NextAddr;
assign NextAddr = {{Addr[31:12]+1}, 12'd0};	// Next 4KB Boundary Start
reg [31:0] SavedAddr;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		SavedAddr <= 0;
	else if(AXIRequestHandshake)
		SavedAddr <= NextAddr;
end

wire [31:0] AXIADDR;
wire [3:0] AXILEN;
assign AXIADDR = State[S_ADDREQ] ? SavedAddr : {Addr[31:3], (DATA_WIDTH==32) ? Addr[2] : 1'b0, 2'b00};
assign AXILEN  = State[S_ADDREQ] ? RemReqLen : RealReqLen;

`ifdef AXIBUSIF_READ
assign ARVALID = Req && ReqRnW;
assign ARADDR = AXIADDR;
assign ARLEN = AXILEN;
assign ARSIZE = AXISIZE;
assign ARBURST = AXIBURST;

assign ReadData = RDATA;
assign ReadDataValid = RVALID;
assign RREADY = 1'b1;	// always RREADY
`endif

`ifdef AXIBUSIF_WRITE
reg  FIFO_Full;
assign AWVALID = Req && (!ReqRnW) && (!FIFO_Full);
assign AWADDR = AXIADDR;
assign AWLEN = AXILEN;
assign AWSIZE = AXISIZE;
assign AWBURST = AXIBURST;

wire   FIFO_Empty;
assign WDATA = WriteData;
assign WSTRB = WriteEn;
assign WVALID = !FIFO_Empty;	// Should check Write Request FIFO
assign WriteDataReady = WREADY && WVALID;

assign BREADY = 1'b1;	// always high

//
// Write Request Fifo : WLAST signal generation
//                    : I'm not sure it can be synthesized correctly.
//
reg  [3:0] AWLEN_FIFO [FIFO_LEN:0];
reg  [FIFO_DEPTH-1:0] FIFO_WAddr;
reg  [FIFO_DEPTH-1:0] FIFO_RAddr;
wire [FIFO_DEPTH-1:0] FIFO_WAddrPlusOne;
wire [FIFO_DEPTH-1:0] FIFO_RAddrPlusOne;
wire FIFO_AddrSame;
wire [3:0] CurrentAWLEN;

assign FIFO_WAddrPlusOne = FIFO_WAddr + 1;
assign FIFO_RAddrPlusOne = FIFO_RAddr + 1;
assign FIFO_AddrSame = (FIFO_WAddr == FIFO_RAddr) ? 1'b1 : 1'b0;
assign FIFO_Empty = FIFO_AddrSame && (!FIFO_Full);
assign CurrentAWLEN = AWLEN_FIFO[FIFO_RAddr];

wire CurrentAWLENIsZero = (CurrentAWLEN == 0);
integer FIFO_index;	// for reset
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		FIFO_Full <= 0;
		FIFO_WAddr <= 0;
		FIFO_RAddr <= 0;
		for(FIFO_index = 0; FIFO_index <= FIFO_LEN; FIFO_index = FIFO_index + 1)
			AWLEN_FIFO[FIFO_index] <= 0;
	end
	else
	begin
		if(WREADY && WVALID)
		begin
			if(CurrentAWLENIsZero)
				FIFO_RAddr <= FIFO_RAddrPlusOne;
			else
				AWLEN_FIFO[FIFO_RAddr] <= AWLEN_FIFO[FIFO_RAddr] - 1;

			if(AWREADY && AWVALID)
				AWLEN_FIFO[FIFO_WAddr] <= AWLEN;
		end
		else if(AWREADY && AWVALID)
			AWLEN_FIFO[FIFO_WAddr] <= AWLEN;

		if(WREADY && WVALID && CurrentAWLENIsZero)
			FIFO_Full <= 0;
		else if(AWREADY && AWVALID && (FIFO_WAddrPlusOne == FIFO_RAddr))
			FIFO_Full <= 1;

		if(AWREADY && AWVALID)
			FIFO_WAddr <= FIFO_WAddrPlusOne;
	end
end

assign WLAST = (CurrentAWLENIsZero) ? 1'b1 : 1'b0;
`endif

// synopsys translate_off
wire [31:0] AWADDR_Check;
wire [31:0] ARADDR_Check;

assign AWADDR_Check = AWADDR + ((DATA_WIDTH == 64) ? (AWLEN*8) : (AWLEN*4));
assign ARADDR_Check = ARADDR + ((DATA_WIDTH == 64) ? (ARLEN*8) : (ARLEN*4));
always @(posedge ACLK)
begin
	if(ARESETn)
	begin
		if(AWVALID)
		begin
			if(AWADDR[12] != AWADDR_Check[12])
			begin
				$display("Write Request is crossing 4KB Boundary");
				$stop;
			end
		end
		if(ARVALID)
		begin
			if(ARADDR[12] != ARADDR_Check[12])
			begin
				$display("Read Request is crossing 4KB Boundary");
				$stop;
			end
		end
	end
end
// synopsys translate_on
endmodule
