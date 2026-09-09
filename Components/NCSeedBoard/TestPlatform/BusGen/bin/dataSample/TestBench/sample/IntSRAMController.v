// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : IntSRAMController.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is AXI Internal SRAM Controller.
//  =============================================================================

`timescale 1ns/1ps

module IntSRAMController 
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
		RREADY   ,

//	SRAM Interface
		MEMADDR  ,
		MEMCEn   ,
		MEMWEn   ,
		MEMRDATA ,
		MEMWDATA
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
parameter ID_WIDTH = (WID_WIDTH > RID_WIDTH) ? WID_WIDTH : RID_WIDTH;

`define RESP_OKAY	2'b00

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

output [MADDR_WIDTH-1:0] MEMADDR;	// discard lower 2 line
output                  MEMCEn;
output [NUM_BYTE-1:0]   MEMWEn;
input  [DATA_WIDTH-1:0] MEMRDATA;
output [DATA_WIDTH-1:0] MEMWDATA;

//
// DATA line bypass
//
wire   [DATA_WIDTH-1:0] WDATA;
wire   [DATA_WIDTH-1:0] RDATA;
wire   [DATA_WIDTH-1:0] MEMWDATA;
wire   [DATA_WIDTH-1:0] MEMRDATA;

assign MEMWDATA = WDATA;
assign RDATA = MEMRDATA;

//
// main state machine
//
reg  ReadOrWrite;	// 0 when read, 1 when write
reg  [3:0] State;	// State
reg  [3:0] NextState;	// Next State
parameter S_IDLE = 0, S_READ = 1, S_WRITE = 2, S_WRITE_RESP = 3;

wire StateIsIDLE       = State[0];
wire StateIsREAD       = State[1];
wire StateIsWRITE      = State[2];
wire StateIsWRITE_RESP = State[3];
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		State <= 0;
		State[S_IDLE] <= 1'b1;
	end
	else
		State <= NextState;
end

always @(State or ARVALID or ReadOrWrite or AWVALID or RLAST or RVALID or RREADY or WLAST or WVALID or WREADY or BREADY)
begin
	NextState = 0;
	case(1'b1)	// synopsys parallel_case full_case
	State[S_IDLE]:
		if(ARVALID == 1'b1 && ReadOrWrite == 1'b0)
			NextState[S_READ] = 1'b1;
		else if(AWVALID == 1'b1 && ReadOrWrite == 1'b1)
			NextState[S_WRITE] = 1'b1;
		else
			NextState[S_IDLE] = 1'b1;
	State[S_READ]:
		if(RLAST == 1'b1 && RVALID == 1'b1 && RREADY == 1'b1)
			NextState[S_IDLE] = 1'b1;
		else
			NextState[S_READ] = 1'b1;
	State[S_WRITE]:
		if(WLAST == 1'b1 && WVALID == 1'b1)
			NextState[S_WRITE_RESP] = 1'b1;
		else
			NextState[S_WRITE] = 1'b1;
	State[S_WRITE_RESP]:
		if(BREADY == 1'b1)
			NextState[S_IDLE] = 1'b1;
		else
			NextState[S_WRITE_RESP] = 1'b1;
	endcase
end

reg FirstREADCycle;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		FirstREADCycle <= 1'b0;
	else
	begin
		if(StateIsIDLE == 1'b1 && ARVALID == 1'b1 && ReadOrWrite == 1'b0)
			FirstREADCycle <= 1'b1;
		else
			FirstREADCycle <= 1'b0;
	end
end

//
// AXI Interface
//
wire [ADDR_WIDTH-1:0] MuxedAddr;
wire [3:0]            MuxedLen;
wire [2:0]            MuxedSize;
wire [1:0]            MuxedBurst;

assign MuxedAddr  = (ReadOrWrite) ? AWADDR : ARADDR;
assign MuxedLen   = (ReadOrWrite) ? AWLEN : ARLEN;
assign MuxedSize  = (ReadOrWrite) ? AWSIZE : ARSIZE;
assign MuxedBurst = (ReadOrWrite) ? AWBURST : ARBURST;

wire LatchCommandEn = (StateIsIDLE &&
			((ReadOrWrite == 1'b0 && ARVALID == 1'b1)
			|| (ReadOrWrite == 1'b1 && AWVALID == 1'b1)));

reg  [ID_WIDTH-1:0]   Id;
reg  [ADDR_WIDTH-1:0] Addr;
reg  [3:0]            Len;
reg  [3:0]            BurstLen;
reg  [1:0]            Size;
reg  [1:0]            Burst;

always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		ReadOrWrite <= 1'b0;
		BurstLen <= 0;
		Size <= 0;
		Burst <= 0;
	end
	else
	begin
		if (StateIsIDLE)
		begin
			BurstLen <= MuxedLen;
			Size <= MuxedSize[1:0];
			Burst <= MuxedBurst;
		end

		if (LatchCommandEn == 1'b1)
		begin
			if(ReadOrWrite == 1'b0)
				Id[RID_WIDTH-1:0] <= ARID;
			else
				Id[WID_WIDTH-1:0] <= AWID;
			ReadOrWrite <= ~ReadOrWrite;
		end
		else if(StateIsIDLE && ((ARVALID == 1'b1  && ReadOrWrite == 1'b1) || (AWVALID == 1'b1 && ReadOrWrite == 1'b0)))
				ReadOrWrite <= ~ReadOrWrite;
/*
		else if((StateIsWRITE_RESP && BREADY == 1'b1) || (StateIsREAD && RLAST == 1'b1 && RREADY == 1'b1))
		begin
			if(ReadOrWrite == 1'b1 && ARVALID == 1'b1 && AWVALID == 1'b0)
				ReadOrWrite <= 1'b0;
			else if(ReadOrWrite == 1'b0 && ARVALID == 1'b0 && AWVALID == 1'b1)
				ReadOrWrite <= 1'b1;
		end
*/
	end
end

assign ARREADY = (StateIsIDLE) && !ReadOrWrite;

assign RID     = Id[RID_WIDTH-1:0];
assign RRESP   = `RESP_OKAY;
assign RVALID  = StateIsREAD & ~FirstREADCycle;

assign RLAST   = (Len == 0) ? 1'b1 : 1'b0;

assign AWREADY = (StateIsIDLE) && ReadOrWrite;

assign WREADY  = (StateIsWRITE) ? 1'b1 : 1'b0;

assign BID     = Id[WID_WIDTH-1:0];
assign BRESP   = `RESP_OKAY;
assign BVALID  = (StateIsWRITE_RESP) ? 1'b1 : 1'b0;

//
// address generator
//
//wire DecreaseLen = (StateIsREAD&& ~FirstREADCycle) ? (RREADY) : ((StateIsWRITE) ? (WVALID) : 1'b0);
wire DecreaseLen = (StateIsREAD&& ~FirstREADCycle) ? (RREADY) : 1'b0;
//wire NextAddrCalcEn = FirstREADCycle | DecreaseLen;
wire NextAddrCalcEn = FirstREADCycle | DecreaseLen | (StateIsWRITE == 1'b1 && WVALID == 1'b1);

reg [11:0]           IncreasedAddr;
reg [ADDR_WIDTH-1:0] PrevAddr;
reg [6:0] WrapBoundary;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		Addr <= 0;
		Len <= 0;
	end
	else
	begin
//		if(LatchCommandEn == 1'b1)
		if(StateIsIDLE == 1'b1)
		begin
			Addr <= MuxedAddr;
			Len <= ARLEN;
		end
		else
		begin
			// update when ready, valid are both high
			if(NextAddrCalcEn)
			begin
				case(Burst)	// synopsys parallel_case
				// synopsys translate_off
				2'b00: // FIXED Burst
					$display("Warning:IntSRAMController: FIXED Burst is not supported.");
				// synopsys translate_on
				2'b01: // INCR Burst
				begin
					Addr[11:0] <= IncreasedAddr[11:0];		// Only update for 4 KB
				end
				2'b10: // WRAP Burst
					Addr[6:0] <= (Addr[6:0]&(~WrapBoundary))|(IncreasedAddr[6:0]&WrapBoundary);
				// synopsys translate_off
				default:
					$display("Warning:IntSRAMController: unknown Burst type");
				// synopsys translate_on
				endcase

			end
			if(DecreaseLen)
				Len <= Len - 1'b1;
		end
	end
end

always @(posedge ACLK)
	if(NextAddrCalcEn || FirstREADCycle)
		PrevAddr <= Addr;

assign MEMADDR = (StateIsWRITE || FirstREADCycle || RREADY == 1'b1) ? Addr[ADDR_WIDTH-1:2] : PrevAddr[ADDR_WIDTH-1:2];
assign MEMCEn = (StateIsREAD || StateIsWRITE) ? 1'b0 : 1'b1;
assign MEMWEn = (StateIsWRITE && WVALID == 1'b1) ? (~WSTRB) : {NUM_BYTE{1'b1}};

always @(Size or BurstLen)
	case(BurstLen)
	4'b0001:	// 2
	begin
		case (Size[1:0])
		2'b00: WrapBoundary <= 7'b0000001;
		2'b01: WrapBoundary <= 7'b0000011;
		2'b10: WrapBoundary <= 7'b0000111;
		2'b11: WrapBoundary <= 7'b0001111;
		endcase
	end
	4'b0011:	// 4
	begin
		case (Size[1:0])
		2'b00: WrapBoundary <= 7'b0000011;
		2'b01: WrapBoundary <= 7'b0000111;
		2'b10: WrapBoundary <= 7'b0001111;
		2'b11: WrapBoundary <= 7'b0011111;
		endcase
	end
	4'b0111:	// 8
	begin
		case (Size[1:0])
		2'b00: WrapBoundary <= 7'b0000111;
		2'b01: WrapBoundary <= 7'b0001111;
		2'b10: WrapBoundary <= 7'b0011111;
		2'b11: WrapBoundary <= 7'b0111111;
		endcase
	end
	4'b1111:	// 16
	begin
		case (Size[1:0])
		2'b00: WrapBoundary <= 7'b0001111;
		2'b01: WrapBoundary <= 7'b0011111;
		2'b10: WrapBoundary <= 7'b0111111;
		2'b11: WrapBoundary <= 7'b1111111;
		endcase
	end
	default: WrapBoundary <= 7'bxxxxxxx;
	endcase

reg [2:0] IncrSize;
always @(Size)
	case (Size[1:0])
	2'b00: IncrSize <= 1;
	2'b01: IncrSize <= 2;
	2'b10: IncrSize <= 4;
	2'b11: IncrSize <= 8;
	endcase

always @(Addr or IncrSize) IncreasedAddr <= Addr[11:0] + IncrSize;

endmodule
