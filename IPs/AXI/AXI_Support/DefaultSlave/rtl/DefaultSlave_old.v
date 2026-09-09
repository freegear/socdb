// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DefaultSlave.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is AXI Default Slave
//  =============================================================================

`timescale 1ns/1ps

module DefaultSlave 
(
//	AXI Interface
		ACLK     , 
		ARESETn  , 
		// Write Address Channel
		AWID     ,
		AWADDR   ,
		AWLEN    ,
		AWSIZE   ,
		AWBURST  ,
		AWVALID  ,
		AWREADY  ,

		// Write Data Channel
		WID      ,
		WDATA    ,
		WSTRB    ,
		WLAST    ,
		WVALID   ,
		WREADY   ,

		// Write Response Channel
		BID      ,
		BRESP    ,
		BVALID   ,
		BREADY   ,

		// Read Address Channel
		ARID     ,
		ARADDR   ,
		ARLEN    ,
		ARSIZE   ,
		ARBURST  ,
		ARVALID  ,
		ARREADY  ,

		// Read Data Channel
		RID      ,
		RDATA    ,
		RRESP    ,
		RLAST    ,
		RVALID   ,
		RREADY
);

//
// module parameter
//
parameter DATA_WIDTH = 32;	// only support 32 bit now
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;
parameter ADDR_WIDTH = 32;	// Memory Address Width : should be at least 12(4KB)

// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;

`define RESP_DECERR	2'b11

//
// input/output port
//
input  ACLK;
input  ARESETn;

input  [WID_WIDTH-1:0]  AWID;
input  [ADDR_WIDTH-1:0] AWADDR;
input  [3:0]            AWLEN;
input  [2:0]            AWSIZE;
input  [1:0]            AWBURST;
input                   AWVALID;
output                  AWREADY;

input  [WID_WIDTH-1:0]  WID;
input  [DATA_WIDTH-1:0] WDATA;
input  [NUM_BYTE-1:0]   WSTRB;
input                   WLAST;
input                   WVALID;
output                  WREADY;

output [WID_WIDTH-1:0]  BID;
output [1:0]            BRESP;
output                  BVALID;
input                   BREADY;

input  [RID_WIDTH-1:0]  ARID;
input  [ADDR_WIDTH-1:0] ARADDR;
input  [3:0]            ARLEN;
input  [2:0]            ARSIZE;
input  [1:0]            ARBURST;
input                   ARVALID;
output                  ARREADY;

output [RID_WIDTH-1:0]  RID;
output [DATA_WIDTH-1:0] RDATA;
output [1:0]            RRESP;
output                  RLAST;
output                  RVALID;
input                   RREADY;

//
// main state machine
//
reg  [3:0] state;	// State
`define S_IDLE			4'b0001
`define S_READ			4'b0010
`define S_WRITE			4'b0100
`define S_WRITE_RESP 	4'b1000
wire state_is_IDLE;
wire state_is_READ;
wire state_is_WRITE;
wire state_is_WRITE_RESP;

assign state_is_IDLE = state[0];
assign state_is_READ = state[1];
assign state_is_WRITE = state[2];
assign state_is_WRITE_RESP = state[3];

always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		state <= `S_IDLE;
	else
	begin
		case (state)
		`S_IDLE:
		begin
			if(ARVALID == 1'b1 && ARREADY == 1'b1)
				state <= `S_READ;
			else if(AWVALID == 1'b1 && AWREADY == 1'b1)
				state <= `S_WRITE;
		end
		`S_READ:
		begin
			if(RLAST == 1'b1 && RVALID == 1'b1 && RREADY == 1'b1)
				state <= `S_IDLE;
		end
		`S_WRITE:
			if(WLAST == 1'b1 && WVALID == 1'b1 && WREADY == 1'b1)
				state <= `S_WRITE_RESP;
		`S_WRITE_RESP:
			if(BVALID == 1'b1 && BREADY == 1'b1)
				state <= `S_IDLE;
		endcase
	end
end

//
// AXI Interface
//
reg  read_or_write;	// 0 when read, 1 when write
wire [RID_WIDTH-1:0]  id_input;
wire [3:0]            len_input;

assign len_input = (read_or_write) ? AWLEN : ARLEN;

wire command_latch;
assign command_latch = (state_is_IDLE &&
			((read_or_write == 1'b0 && ARVALID == 1'b1)
				|| (read_or_write == 1'b1 && AWVALID == 1'b1)));

reg  [RID_WIDTH-1:0]  rid;
reg  [WID_WIDTH-1:0]  wid;
reg  [3:0]            len;

always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		read_or_write <= 1'b0;
	end
	else
	begin
		if (command_latch == 1'b1)
		begin
			rid <= ARID;
			wid <= AWID;
			read_or_write <= ~read_or_write;
		end
		else if(state_is_IDLE && ((ARVALID == 1'b1  && read_or_write == 1'b1) || (AWVALID == 1'b1 && read_or_write == 1'b0)))
				read_or_write <= ~read_or_write;
	end
end

assign ARREADY = state_is_IDLE && !read_or_write;

assign RID = rid;
assign RDATA = {(DATA_WIDTH){1'b0}};
assign RRESP = `RESP_DECERR;
assign RLAST = (len == 0) ? 1'b1 : 1'b0;
assign RVALID = state_is_READ;

assign AWREADY = state_is_IDLE && read_or_write;

assign WREADY = state_is_WRITE ? 1'b1 : 1'b0;

assign BID = wid;
assign BRESP = `RESP_DECERR;
assign BVALID = state_is_WRITE_RESP ? 1'b1 : 1'b0;

//
// length decreaser
//
wire len_decrease;
assign len_decrease = (state_is_READ) ? (RREADY) : ((state_is_WRITE) ? (WVALID) : 1'b0);

always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		len <= 0;
	else
	begin
		if(command_latch == 1'b1)
			len <= len_input;
		else if(len_decrease)
			len <= len - 1'b1;
	end
end

endmodule
