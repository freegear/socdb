// ======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DefaultSlave.v
// File Revision       : 0.1
//  ---------------------------------------------------------------------
//  Purpose            : This module is AXI Default Slave
//  =====================================================================

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

//	SRAM Interface
        /*
		MEMADDR  ,
		MEMCEn   ,
		MEMWEn   ,
		MEMRDATA ,
		MEMWDATA
        */
);
//
// module parameter
//

parameter DATA_WIDTH = 32;	// only support 32 bit now
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;
parameter ADDR_WIDTH = 32;	// Memory Address Width : should be at least 12(4KB)

parameter MADDR_WIDTH = (DATA_WIDTH == 32) ? (ADDR_WIDTH-2) : (ADDR_WIDTH-3);
// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;

`define RESP_DECERR	2'b11

/*
output [MADDR_WIDTH-1:0] MEMADDR;	// discard lower 2 line
output                  MEMCEn;
output [NUM_BYTE-1:0]   MEMWEn;
input  [DATA_WIDTH-1:0] MEMRDATA;
output [DATA_WIDTH-1:0] MEMWDATA;

assign  MEMADDR = 0;
assign  MEMCEn = 0;
assign  MEMWEn = 0;
assign  MEMWDATA = 0;
*/

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
// READ transaction processing
//
reg ReadState;	// 0 when idle, 1 when read
parameter S_READ_IDLE = 1'b0, S_READ_DOING = 1'b1;

reg  [RID_WIDTH-1:0]  Rid;
reg  [3:0]            Arlen;
// READ Address channel transaction
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		ReadState <= S_READ_IDLE;
		Rid <= 0;
		Arlen <= 0;
	end
	else
	begin
		case (ReadState)
		S_READ_IDLE:
		begin
			if(ARVALID == 1'b1)
				ReadState <= S_READ_DOING;
			Rid <= ARID;
			Arlen <= ARLEN;
		end
		S_READ_DOING:
		begin
			if(RREADY == 1'b1)
				Arlen <= Arlen - 1;

			if(RLAST == 1'b1 && RREADY == 1'b1)
				ReadState <= S_READ_IDLE;
		end
		endcase
	end
end

assign ARREADY = (ReadState == S_READ_IDLE);
assign RID = Rid;
assign RDATA = {(DATA_WIDTH){1'b0}};
assign RRESP = `RESP_DECERR;
assign RLAST = (Arlen == 0) ? 1'b1 : 1'b0;
assign RVALID = (ReadState == S_READ_DOING);

//
// WRITE transaction
//
reg  [2:0] WriteState;	// State
reg  [2:0] NextWriteState;	// Next State
parameter S_WRITE_IDLE=0, S_WRITE_DOING=1, S_WRITE_RESP=2;
wire WriteStateIsIDLE = WriteState[S_WRITE_IDLE];
wire WriteStateIsDOING = WriteState[S_WRITE_DOING];
wire WriteStateIsRESP = WriteState[S_WRITE_RESP];

reg  [WID_WIDTH-1:0]  Wid;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		Wid <= 0;

		WriteState <= 0;
		WriteState[S_WRITE_IDLE] <= 1'b1;
	end
	else
	begin
		if(WriteState[S_WRITE_IDLE] == 1'b1)
			Wid <= AWID;

		WriteState <= NextWriteState;
	end
end

always @(WriteState or AWVALID or WLAST or WVALID or BREADY)
begin
	NextWriteState = 0;
	case (1'b1)	// synopsys parallel_case full_case
	WriteState[S_WRITE_IDLE]:
		if(AWVALID == 1'b1)
			NextWriteState[S_WRITE_DOING] = 1;
		else
			NextWriteState[S_WRITE_IDLE] = 1;
	WriteState[S_WRITE_DOING]:
		if(WLAST == 1'b1 && WVALID == 1'b1)
			NextWriteState[S_WRITE_RESP] = 1;
		else
			NextWriteState[S_WRITE_DOING] = 1;
	WriteState[S_WRITE_RESP]:
		if(BREADY == 1'b1)
			NextWriteState[S_WRITE_IDLE] = 1;
		else
			NextWriteState[S_WRITE_RESP] = 1;
	endcase
end

assign AWREADY = WriteStateIsIDLE;
assign WREADY = WriteStateIsDOING ? 1'b1 : 1'b0;
assign BID = Wid;
assign BRESP = `RESP_DECERR;
assign BVALID = WriteStateIsRESP ? 1'b1 : 1'b0;

endmodule
