// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : AXI_ESMC_interface.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is part of AXI ESMC.
//  =============================================================================

`timescale 1ns/1ps

module AXI_ESMC_interface 
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

//	SRAM_CTRL Interface
		SMC_READY    ,
		SMC_RDATA    ,
		SMC_ADDR     ,
		SMC_WDATA    ,
		SMC_WBEB     ,
		SMC_WRITE    ,
		SMC_READ     ,
		SMC_BANK_SEL ,
		SMC_SRAM_START,
		SMC_TRANS_SIZE
);

//
// module parameter
//
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;

`define BANK_SIZE 4

// auto assign from above parameter
parameter ID_WIDTH = (WID_WIDTH > RID_WIDTH) ? WID_WIDTH : RID_WIDTH;

`define RESP_OKAY	2'b00

//
// input/output port
//
input                  ACLK;
input                  ARESETn;

input  [WID_WIDTH-1:0] AWID;
input  [31:0]          AWADDR;
input  [3:0]           AWLEN;
input  [2:0]           AWSIZE;
input  [1:0]           AWBURST;
input                  AWVALID;
output                 AWREADY;

input  [WID_WIDTH-1:0] WID;
input  [31:0]          WDATA;
input  [3:0]           WSTRB;
input                  WLAST;
input                  WVALID;
output                 WREADY;


output [WID_WIDTH-1:0] BID;
output [1:0]           BRESP;
output                 BVALID;
input                  BREADY;

input  [RID_WIDTH-1:0] ARID;
input  [31:0]          ARADDR;
input  [3:0]           ARLEN;
input  [2:0]           ARSIZE;
input  [1:0]           ARBURST;
input                  ARVALID;
output                 ARREADY;

output [RID_WIDTH-1:0] RID;
output [31:0]          RDATA;
output [1:0]           RRESP;
output                 RLAST;
output                 RVALID;
input                  RREADY;

input                  SMC_READY;
input  [31:0]          SMC_RDATA;
output [25:0]          SMC_ADDR;
output [31:0]          SMC_WDATA;
output [3:0]           SMC_WBEB;
output                 SMC_WRITE;
output                 SMC_READ;
output [`BANK_SIZE-1:0] SMC_BANK_SEL;
output                 SMC_SRAM_START;
output [1:0]           SMC_TRANS_SIZE;

//
// main state machine
//
reg  ReadOrWrite;	// 0 when read, 1 when write
reg  [4:0] State;	// State
reg  [4:0] NextState;	// Next State
parameter S_IDLE=0, S_READ=1, S_WRITE=2, S_WRITE_RESP=3, S_WAIT_WRITE=4;

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

wire IsWritePending;
always @(State or ARVALID or ReadOrWrite or AWVALID or RLAST or RVALID or RREADY or WLAST or WVALID or WREADY or BREADY or IsWritePending)
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
		if(WLAST == 1'b1 && WVALID == 1'b1 && WREADY == 1'b1)
			NextState[S_WRITE_RESP] = 1'b1;
		else
			NextState[S_WRITE] = 1'b1;
	State[S_WRITE_RESP]:
		if(BREADY == 1'b1 && IsWritePending == 1'b0)
			NextState[S_IDLE] = 1'b1;
		else if(BREADY == 1'b1 && IsWritePending == 1'b1)
			NextState[S_WAIT_WRITE] = 1'b1;
		else
			NextState[S_WRITE_RESP] = 1'b1;
	State[S_WAIT_WRITE]:
		if(IsWritePending == 1'b0)
			NextState[S_IDLE] = 1'b1;
		else
			NextState[S_WAIT_WRITE] = 1'b1;
	endcase
end

//
// AXI Interface
//
wire [31:0] MuxedAddr;
wire [3:0]  MuxedLen;
wire [2:0]  MuxedSize;
wire [1:0]  MuxedBurst;

assign MuxedAddr  = (ReadOrWrite) ? AWADDR : ARADDR;
assign MuxedLen   = (ReadOrWrite) ? AWLEN : ARLEN;
assign MuxedSize  = (ReadOrWrite) ? AWSIZE : ARSIZE;
assign MuxedBurst = (ReadOrWrite) ? AWBURST : ARBURST;

wire LatchCommandEn = (StateIsIDLE &&
			((ReadOrWrite == 1'b0 && ARVALID == 1'b1)
			|| (ReadOrWrite == 1'b1 && AWVALID == 1'b1)));

reg  [ID_WIDTH-1:0]   Id;
reg  [31:0]           GeneratedAddr;
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
			Burst <= MuxedBurst;
			Size  <= MuxedSize;
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
	end
end

assign ARREADY = (StateIsIDLE) && !ReadOrWrite;
assign AWREADY = (StateIsIDLE) && ReadOrWrite;

//
// address generator & Len decreaser
//
wire DecreaseLen;

always @(negedge ARESETn or posedge ACLK)
	if(!ARESETn)
		Len <= 0;
	else if(StateIsIDLE == 1'b1)
		Len <= ARLEN;
	else if(DecreaseLen)
		Len <= Len - 1'b1;


wire NextAddrCalcEn;
reg  [11:0] IncreasedAddr;
reg  [6:0]  WrapBoundary;

always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		GeneratedAddr <= 0;
	else if(StateIsIDLE == 1'b1)
		GeneratedAddr <= MuxedAddr;
	else if(NextAddrCalcEn)
	begin
		case(Burst)	// synopsys parallel_case
		2'b01: // INCR Burst
		begin
			GeneratedAddr[11:0] <= IncreasedAddr[11:0];		// Only update for 4 KB
		end
		2'b10: // WRAP Burst
			GeneratedAddr[6:0] <= (GeneratedAddr[6:0]&(~WrapBoundary[6:0]))|(IncreasedAddr[6:0]&WrapBoundary[6:0]);
		default:	// Fixed_burst or Error
			GeneratedAddr[11:0] <= GeneratedAddr[11:0]; // do nothing
		endcase
	end
end


always @(Size or BurstLen)
	case(BurstLen)
	4'b0001:	// 2
	begin
		case (Size[1:0])
		2'b00: WrapBoundary <= 7'b0000001;
		2'b01: WrapBoundary <= 7'b0000011;
		2'b10: WrapBoundary <= 7'b0000111;
		2'b11: WrapBoundary <= 7'bxxxxxxx;
		endcase
	end
	4'b0011:	// 4
	begin
		case (Size[1:0])
		2'b00: WrapBoundary <= 7'b0000011;
		2'b01: WrapBoundary <= 7'b0000111;
		2'b10: WrapBoundary <= 7'b0001111;
		2'b11: WrapBoundary <= 7'bxxxxxxx;
		endcase
	end
	4'b0111:	// 8
	begin
		case (Size[1:0])
		2'b00: WrapBoundary <= 7'b0000111;
		2'b01: WrapBoundary <= 7'b0001111;
		2'b10: WrapBoundary <= 7'b0011111;
		2'b11: WrapBoundary <= 7'bxxxxxxx;
		endcase
	end
	4'b1111:	// 16
	begin
		case (Size[1:0])
		2'b00: WrapBoundary <= 7'b0001111;
		2'b01: WrapBoundary <= 7'b0011111;
		2'b10: WrapBoundary <= 7'b0111111;
		2'b11: WrapBoundary <= 7'bxxxxxxx;
		endcase
	end
	default: WrapBoundary <= 7'bxxxxxxx;
	endcase

reg [2:0] IncrSize;
always @(Size)
	case (Size[1:0])
	2'b00: IncrSize = 1;
	2'b01: IncrSize = 2;
	2'b10: IncrSize = 4;
	2'b11: IncrSize = 3'bxxx; // IncrSize = 8;
	endcase

always @(GeneratedAddr or IncrSize) IncreasedAddr = GeneratedAddr[11:0] + IncrSize;

//
// Process READ
//
reg  WaitingRREADY;	// 1 when send RVALID and not receive RREADY
wire ReadEnable = (WaitingRREADY == 0 && StateIsREAD) ? 1'b1 : 1'b0;
assign DecreaseLen  = (WaitingRREADY == 1'b1 || SMC_READY == 1'b1) && RREADY == 1'b1;

always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		WaitingRREADY <= 0;
	else if(!StateIsREAD)
		WaitingRREADY <= 0;
	else if(SMC_READY == 1'b1 && RREADY == 1'b0) 
		WaitingRREADY <= 1;
	else if(WaitingRREADY == 1 && RREADY == 1'b1)
		WaitingRREADY <= 0;
end

reg  [31:0] LatchedRDATA;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		LatchedRDATA <= 0;
	else if(SMC_READY)
		LatchedRDATA <= SMC_RDATA;
end

assign RID    = Id[RID_WIDTH-1:0];
assign RDATA  = (WaitingRREADY == 1) ? LatchedRDATA : SMC_RDATA;
assign RVALID = StateIsREAD & (SMC_READY | WaitingRREADY);
assign RRESP  = `RESP_OKAY;
assign RLAST  = (Len == 0) ? 1'b1 : 1'b0;

//
// Process WRITE
//
reg  WDATAAvailable;	// 1 when received WDATA
wire WriteEnable = (WDATAAvailable == 1) ? 1'b1 : 1'b0;

always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		WDATAAvailable <= 0;
	else if(StateIsWRITE && WVALID == 1'b1)
		WDATAAvailable <= 1;
	else if(SMC_READY == 1'b1)
		WDATAAvailable <= 0;
end

reg  [31:0] LatchedWDATA;
reg  [3:0]  LatchedWBEB;
always @(negedge ARESETn or posedge ACLK)
	if(!ARESETn)
	begin
		LatchedWDATA <= 0;
		LatchedWBEB <= 4'hf;
	end
	else if(WVALID == 1'b1 && WREADY == 1'b1)
	begin
		LatchedWDATA <= WDATA;
		LatchedWBEB <= ~WSTRB;
	end

assign WREADY = (StateIsWRITE && (WDATAAvailable == 1'b0 || SMC_READY == 1'b1));

assign IsWritePending = (WriteEnable == 1'b1 && SMC_READY == 1'b0);

assign BID    = Id[WID_WIDTH-1:0];
assign BRESP  = `RESP_OKAY;
assign BVALID = StateIsWRITE_RESP;

assign NextAddrCalcEn = (SMC_READY == 1'b1 && SMC_SRAM_START == 1'b1);

//
// SRAM_CTRL Interface
//
assign SMC_SRAM_START = WriteEnable | ReadEnable;
assign SMC_WDATA      = LatchedWDATA;
assign SMC_WBEB       = LatchedWBEB;
assign SMC_WRITE      = (StateIsREAD == 1'b1) ? 1'b0 : 1'b1;
assign SMC_READ       = (StateIsREAD == 1'b1) ? 1'b1 : 1'b0;
assign SMC_TRANS_SIZE = Size;

//
// Address decoding for Bank selection
//
reg [25:0] SMC_ADDR;
always @(GeneratedAddr, Size)
begin
	case(Size[1:0])
	2'b00: SMC_ADDR = GeneratedAddr[25:0];
	2'b01: SMC_ADDR = {GeneratedAddr[25:1], 1'b0};
	2'b10: SMC_ADDR = {GeneratedAddr[25:2], 2'b00};
	default: SMC_ADDR = GeneratedAddr[25:0];
	endcase
end

reg [`BANK_SIZE-1:0] SMC_BANK_SEL;
always @(GeneratedAddr)
begin
	case(GeneratedAddr[27:26])
	2'd0: SMC_BANK_SEL = 4'b0001;
	2'd1: SMC_BANK_SEL = 4'b0010;
	2'd2: SMC_BANK_SEL = 4'b0100;
	2'd3: SMC_BANK_SEL = 4'b1000;
	endcase
end

endmodule
