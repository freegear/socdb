// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : AHB2AXIBridge.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is AHB-to-AXI interface.
//  =============================================================================

`timescale 1ns/1ps

module AHB2AXIBridge 
(
//	Common Interface
		CLK     , 
		RESETn  , 

// AHB Interface
		HADDR    ,
		HTRANS   ,
		HWRITE   ,
		HSIZE    ,
		HBURST   ,
		HPROT    ,
		HWDATA   ,
		HRDATA   ,
		HREADY_IN,
		HREADY_OUT,
		HRESP    ,

		HSEL     ,
		HMASTLOCK,

// AXI Interface
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
// module parameter
//

`define HTRANS_NSEQ 2'b10
`define HTRANS_SEQ  2'b11
`define HTRANS_IDLE 2'b00
`define HTRANS_BUSY 2'b01

`define HRESP_OKAY  2'b00
`define HRESP_ERROR 2'b01

`define RESP_OKAY	2'b00

`define BURST_WRAP	2'b10
`define BURST_INCR	2'b01

//
// input/output port
//
input                  CLK;
input                  RESETn;

input  [31:0]          HADDR;
input  [ 1:0]          HTRANS;
input                  HWRITE;
input  [2:0]           HSIZE;
input  [2:0]           HBURST;
input  [3:0]           HPROT;
input  [31:0]          HWDATA;
output [31:0]          HRDATA;
input                  HREADY_IN;
output                 HREADY_OUT;
output [1:0]           HRESP;

input                  HSEL;
input                  HMASTLOCK;

output [31:0]          AWADDR;
output [3:0]           AWLEN;
output [2:0]           AWSIZE;
output [1:0]           AWBURST;
output [1:0]           AWLOCK;
output [3:0]           AWCACHE;
output [2:0]           AWPROT;
output                 AWVALID;
input                  AWREADY;

output [31:0]          WDATA;
output [3:0]   WSTRB;
output                 WLAST;
output                 WVALID;
input                  WREADY;


input  [1:0]           BRESP;
input                  BVALID;
output                 BREADY;

output [31:0]          ARADDR;
output [3:0]           ARLEN;
output [2:0]           ARSIZE;
output [1:0]           ARBURST;
output [1:0]           ARLOCK;
output [3:0]           ARCACHE;
output [2:0]           ARPROT;
output                 ARVALID;
input                  ARREADY;

input  [31:0]          RDATA;
input  [1:0]           RRESP;
input                  RLAST;
input                  RVALID;
output                 RREADY;

//
// main state machine
//
reg  [3:0] State;	// State
reg  [3:0] NextState;	// Next State
parameter S_IDLE=0, S_READ=1, S_WRITE=2, S_WRITE_RESP=3;

wire StateIsIDLE       = State[0];
wire StateIsREAD       = State[1];
wire StateIsWRITE      = State[2];
wire StateIsWRITE_RESP = State[3];
always @(negedge RESETn or posedge CLK)
begin
	if(!RESETn)
	begin
		State <= 0;
		State[S_IDLE] <= 1'b1;
	end
	else
		State <= NextState;
end

wire HTRANS_VALID;
assign HTRANS_VALID = HSEL == 1'b1 && HREADY_IN == 1'b1 && (HTRANS == `HTRANS_NSEQ || HTRANS == `HTRANS_SEQ);

always @(State or HWRITE or HTRANS_VALID or RLAST or RVALID or RREADY or WLAST or WVALID or WREADY or BVALID or BREADY)
begin
	NextState = 0;
	case(1'b1)	// synopsys parallel_case full_case
	State[S_IDLE]:
		if(HWRITE == 1'b0 && HTRANS_VALID)
			NextState[S_READ] = 1'b1;
		else if(HWRITE == 1'b1 && HTRANS_VALID)
			NextState[S_WRITE] = 1'b1;
		else
			NextState[S_IDLE] = 1'b1;
	State[S_READ]:
		if(RLAST == 1'b1 && RVALID == 1'b1 && RREADY == 1'b1)
		begin
			if(HWRITE == 1'b0 && HTRANS_VALID)
				NextState[S_READ] = 1'b1;
			else if(HWRITE == 1'b1 && HTRANS_VALID)
				NextState[S_WRITE] = 1'b1;
			else
				NextState[S_IDLE] = 1'b1;
		end
		else
			NextState[S_READ] = 1'b1;
	State[S_WRITE]:
		if(WLAST == 1'b1 && WVALID == 1'b1 && WREADY == 1'b1)
			NextState[S_WRITE_RESP] = 1'b1;
		else
			NextState[S_WRITE] = 1'b1;
	State[S_WRITE_RESP]:
		if(BVALID == 1'b1 && BREADY == 1'b1)
		begin
			if(HWRITE == 1'b0 && HTRANS_VALID)
				NextState[S_READ] = 1'b1;
			else if(HWRITE == 1'b1 && HTRANS_VALID)
				NextState[S_WRITE] = 1'b1;
			else
				NextState[S_IDLE] = 1'b1;
		end
		else
			NextState[S_WRITE_RESP] = 1'b1;
	endcase
end

// AHB command latching
wire CommandLatchEn;
assign CommandLatchEn = (StateIsIDLE && HTRANS_VALID)
		|| (StateIsREAD && RLAST == 1'b1 && RVALID == 1'b1 && RREADY == 1'b1 && HTRANS_VALID)
		|| (StateIsWRITE_RESP && BVALID == 1'b1 && BREADY == 1'b1 && HTRANS_VALID);
reg [31:0] HADDR_r;
reg [1:0]  HADDR_lower_r;
reg [3:0]  BurstLen;
reg [3:0]  Len;
reg [1:0]  HTRANS_r;
reg [2:0]  HSIZE_r;
reg [3:0]  HPROT_r;
reg        HMASTLOCK_r;
reg        WrapBurst;
reg        NewCommandArrived;

reg [3:0] HBURST2Len;
always @(HBURST)
begin
	case (HBURST[2:1])
	2'b00: HBURST2Len <= 4'd0;	// Single or INCR
	2'b01: HBURST2Len <= 4'd3;	// WRAP4 or INCR4
	2'b10: HBURST2Len <= 4'd7;	// WRAP8 or INCR8
	2'b11: HBURST2Len <= 4'd15;	// WRAP16 or INCR16
	endcase
end

wire DecreaseLen;
always @(negedge RESETn or posedge CLK)
begin
	if(!RESETn)
	begin
		HADDR_r <= 0;
		HADDR_lower_r <= 0;
		Len <= 0;
		HTRANS_r <= `HTRANS_IDLE;
		HSIZE_r <= 0;
		WrapBurst <= 0;
		NewCommandArrived <= 0;
	end
	else
	begin
		if(HREADY_IN == 1'b1)
		begin
			HTRANS_r <= HTRANS;
			HADDR_lower_r <= HADDR;
		end
		if(CommandLatchEn)
		begin
			NewCommandArrived <= 1;
			HADDR_r <= HADDR;
			HSIZE_r <= HSIZE;
			HPROT_r <= HPROT;
			HMASTLOCK_r <= HMASTLOCK;
			BurstLen <= HBURST2Len;
			Len <= HBURST2Len;
			if(HBURST[0] || HBURST == 3'b000)
				WrapBurst <= 0;
			else
				WrapBurst <= 1;
		end
		else
		begin
			if((StateIsREAD && ARVALID == 1'b1 && ARREADY == 1'b1)
				|| (StateIsWRITE && AWVALID == 1'b1 && AWREADY == 1'b1))
				NewCommandArrived <= 0;

			if(DecreaseLen == 1'b1)
				Len <= Len - 1;
		end
	end
end

wire ErrorDetected;
reg ErrorDetected_1d;

// AXI Processing

// Read Address Channel
assign ARADDR = HADDR_r;
assign ARLEN  = BurstLen;
assign ARSIZE = HSIZE_r;
assign ARBURST = (WrapBurst) ? `BURST_WRAP : `BURST_INCR;
assign ARLOCK = (HMASTLOCK_r) ? 2'b10 : 2'b00;
assign ARCACHE = { 2'b00, HPROT_r[3:2] };
assign ARPROT = { ~HPROT_r[0], 1'b0, HPROT_r[1] };
assign ARVALID = (StateIsREAD && NewCommandArrived);

// Write Address Channel
assign AWADDR = HADDR_r;
assign AWLEN  = BurstLen;
assign AWSIZE = HSIZE_r;
assign AWBURST = (WrapBurst) ? `BURST_WRAP : `BURST_INCR;
assign AWLOCK = (HMASTLOCK_r) ? 2'b10 : 2'b00;
assign AWCACHE = { 2'b00, HPROT_r[3:2] };
assign AWPROT = { ~HPROT_r[0], 1'b0, HPROT_r[1] };
assign AWVALID = (StateIsWRITE && NewCommandArrived);

// Read Data Channel
assign RREADY = (HTRANS != `HTRANS_BUSY) && (~ErrorDetected_1d);

// Write Data Channel
assign WDATA = HWDATA;
reg [3:0] WSTRB;
always @(HADDR_lower_r or HSIZE_r)
begin
	case(HSIZE_r[1:0])
	2'b00:
	begin
		case(HADDR_lower_r)
		2'b00 : WSTRB = 4'b0001;
		2'b01 : WSTRB = 4'b0010;
		2'b10 : WSTRB = 4'b0100;
		2'b11 : WSTRB = 4'b1000;
		endcase
	end
	2'b01:
	begin
		if(HADDR_lower_r[1])
			WSTRB = 4'b1100;
		else
			WSTRB = 4'b0011;
	end
	default:
		WSTRB = 4'b1111;
	endcase
end
assign WLAST = (Len == 0);
assign WVALID = (StateIsWRITE && HTRANS_r != `HTRANS_BUSY);
assign DecreaseLen = (WVALID == 1'b1 && WREADY == 1'b1);

// Write Response Channel
assign BREADY = 1'b1;	// always ready

// AHB signals
assign HRDATA = RDATA;
reg HREADY_OUT;
always @(ErrorDetected_1d or ErrorDetected or State or HTRANS_r or RVALID or WLAST or WREADY or BVALID)
begin
	if(ErrorDetected_1d == 1'b1)
		HREADY_OUT = 1'b1;
	else
	begin
		case(1'b1)	// synopsys parallel_case full_case
		State[S_IDLE]      : HREADY_OUT = 1'b1;
		State[S_READ]      : HREADY_OUT = (HTRANS_r == `HTRANS_BUSY) || (~ErrorDetected) & RVALID;
		State[S_WRITE]     : HREADY_OUT = (WLAST != 1'b1 && WREADY == 1'b1) || (HTRANS_r == `HTRANS_BUSY);
		State[S_WRITE_RESP]: HREADY_OUT = (~ErrorDetected) & BVALID;
		endcase
	end
end

reg [1:0] HRESP;
always @(ErrorDetected_1d or State or HTRANS_r or RVALID or RRESP or BVALID or BRESP)
begin
	if(ErrorDetected_1d == 1'b1)
		HRESP = `HRESP_ERROR;
	else
	begin
		case(1'b1)	// synopsys parallel_case full_case
		State[S_IDLE]      : HRESP = `HRESP_OKAY;
		State[S_READ]      : HRESP = (HTRANS_r == `HTRANS_BUSY || RVALID == 1'b0 || RRESP == `RESP_OKAY) ? `HRESP_OKAY : `HRESP_ERROR;
		State[S_WRITE]     : HRESP = `HRESP_OKAY;
		State[S_WRITE_RESP]: HRESP = (BVALID == 1'b0 || BRESP == `RESP_OKAY) ? `HRESP_OKAY : `HRESP_ERROR;
		endcase
	end
end

// 2 cycle HRESP_ERROR processing
assign ErrorDetected = (HRESP == `HRESP_ERROR && ErrorDetected_1d == 0);
always @(negedge RESETn or posedge CLK)
begin
	if(!RESETn)
		ErrorDetected_1d <= 0;
	else
		ErrorDetected_1d <= ErrorDetected;
end

endmodule
