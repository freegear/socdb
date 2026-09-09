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
//		WDATA    ,
//		WSTRB    ,
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
//input  [DATA_WIDTH-1:0] WDATA;
//input  [NUM_BYTE-1:0]   WSTRB;
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
// READ transaction processing
//
reg ReadState;	// 0 when idle, 1 when read
`define S_READ_IDLE		1'b0
`define S_READ_DOING	1'b1

reg  [RID_WIDTH-1:0]  Rid;
reg  [3:0]            Arlen;
// READ Address channel transaction
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		ReadState <= `S_READ_IDLE;
		Rid <= 0;
		Arlen <= 0;
	end
	else
	begin
		case (ReadState)
		`S_READ_IDLE:
		begin
			if(ARVALID == 1'b1)
				ReadState <= `S_READ_DOING;
			Rid <= ARID;
			Arlen <= ARLEN;
		end
		`S_READ_DOING:
		begin
			if(RREADY == 1'b1)
				Arlen <= Arlen - 1;

			if(RLAST == 1'b1 && RREADY == 1'b1)
				ReadState <= `S_READ_IDLE;
		end
		endcase
	end
end

assign ARREADY = (ReadState == `S_READ_IDLE);
assign RID = Rid;
assign RDATA = {(DATA_WIDTH){1'b0}};
assign RRESP = `RESP_DECERR;
assign RLAST = (Arlen == 0) ? 1'b1 : 1'b0;
assign RVALID = (ReadState == `S_READ_DOING);

//
// WRITE transaction
//
reg  [2:0] WriteState;	// State
wire WriteStateIsIDLE = WriteState[0];
wire WriteStateIsDOING = WriteState[1];
wire WriteStateIsRESP = WriteState[2];
`define S_WRITE_IDLE	3'b001
`define S_WRITE_DOING	3'b010
`define S_WRITE_RESP 	3'b100

reg  [WID_WIDTH-1:0]  Wid;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		WriteState <= `S_WRITE_IDLE;
		Wid <= 0;
	end
	else
	begin
		case (WriteState)
		`S_WRITE_IDLE:
		begin
			if(AWVALID == 1'b1)
				WriteState <= `S_WRITE_DOING;
			Wid <= AWID;
		end
		`S_WRITE_DOING:
			if(WLAST == 1'b1 && WVALID == 1'b1)
				WriteState <= `S_WRITE_RESP;
		`S_WRITE_RESP:
			if(BREADY == 1'b1)
				WriteState <= `S_WRITE_IDLE;
		endcase
	end
end

assign AWREADY = WriteStateIsIDLE;
assign WREADY = WriteStateIsDOING ? 1'b1 : 1'b0;
assign BID = Wid;
assign BRESP = `RESP_DECERR;
assign BVALID = WriteStateIsRESP ? 1'b1 : 1'b0;

endmodule
