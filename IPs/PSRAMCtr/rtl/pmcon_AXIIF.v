// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name        : AXI2APBBridge_PSRAM.v
// File Revision    : 0.1 (Modified AXI2APBBridge_PREADY)
//  -----------------------------------------------------------------------------
//  Purpose			: This module is AXI-to-APB interface for PSRAM Controller.
//  =============================================================================

`timescale 1ns/1ps

module pmcon_AXIIF
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

//	APB Interface // Dedicated PSRAM Controller Interface
		PADDR    ,
		PWRITE   ,
		PSEL     ,
		PENABLE  ,
		PWSTRB	 ,
		PRDATA   ,
		PREADY   ,
		PWDATA	 


);

//
// module parameter
//
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;

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
input  [3:0] 		WSTRB;
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

output [31:0]          PADDR;
output                 PWRITE;
output                 PSEL;
output                 PENABLE;
output [3:0]	       PWSTRB;
input  [31:0]          PRDATA;
input                  PREADY;
output [31:0]          PWDATA;

reg                    PENABLE;

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
reg  [1:0]            Burst;

always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		ReadOrWrite <= 1'b0;
		BurstLen <= 0;
		Burst <= 0;
		Id		<= 0;
	end
	else
	begin
		if (StateIsIDLE)
		begin
			BurstLen <= MuxedLen;
			Burst <= MuxedBurst;
		end
/*		// synopsys translate_off
		if(LatchCommandEn == 1'b1 && MuxedSize[1:0] != 2'b10)
			$display("AXI2APBBridge : Transactin size is not 32bit word");
		// synopsys translate_on
*/
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
	else if(DecreaseLen) // burst length decrease
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
	else if(NextAddrCalcEn) // APB slave access가 끝나면 nextaddress
	begin
		case(Burst)	// synopsys parallel_case
		2'b01: // INCR Burst
		begin
			GeneratedAddr[11:2] <= IncreasedAddr[11:2];		// Only update for 4 KB
		end
		2'b10: // WRAP Burst
			GeneratedAddr[6:2] <= (GeneratedAddr[6:2]&(~WrapBoundary[6:2]))|(IncreasedAddr[6:2]&WrapBoundary[6:2]);
		default:	// Fixed_burst or Error
			GeneratedAddr[11:0] <= GeneratedAddr[11:0]; // do nothing
		endcase
	end
end


always @(BurstLen)
	WrapBoundary = {1'b0, BurstLen[3:0], 2'b11};

always @(GeneratedAddr)
begin
	IncreasedAddr[11:2] = GeneratedAddr[11:2] + 1'b1;
	IncreasedAddr[1:0]  = GeneratedAddr[1:0];
end

//
// Process READ
//
wire	PENABLEandPREADY;
assign 	PENABLEandPREADY = PENABLE & PREADY;
reg  	WaitingRREADY;	// 1 when send RVALID and not receive RREADY
wire 	ReadPSEL = (WaitingRREADY == 0 && StateIsREAD) ? 1'b1 : 1'b0;
assign 	DecreaseLen  = (WaitingRREADY == 1'b1 || PENABLEandPREADY == 1'b1) && RREADY == 1'b1;

always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		WaitingRREADY <= 0;
	else if(!StateIsREAD)
		WaitingRREADY <= 0;
	else if(PENABLEandPREADY == 1'b1 && RREADY == 1'b0) 
		WaitingRREADY <= 1;
	else if(WaitingRREADY == 1 && RREADY == 1'b1)
		WaitingRREADY <= 0;
end

reg  [31:0] LatchedPRDATA;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		LatchedPRDATA <= 0;
	else if(PENABLEandPREADY)
		LatchedPRDATA <= PRDATA;
end

assign RID    = Id[RID_WIDTH-1:0];
assign RDATA  = (WaitingRREADY == 1) ? LatchedPRDATA : PRDATA;
assign RVALID = StateIsREAD & (PENABLEandPREADY | WaitingRREADY);
assign RRESP  = `RESP_OKAY;
assign RLAST  = (Len == 0) ? 1'b1 : 1'b0;

//
// Process WRITE
//
reg  WDATAAvailable;	// 1 when received WDATA
wire WritePSEL = (WDATAAvailable == 1) ? 1'b1 : 1'b0;

always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		WDATAAvailable <= 0;
	else if(StateIsWRITE && WVALID == 1'b1)
		WDATAAvailable <= 1;
	else if(PENABLEandPREADY == 1'b1)
		WDATAAvailable <= 0;
end

reg  [31:0] LatchedWDATA;
always @(negedge ARESETn or posedge ACLK)
	if(!ARESETn)
		LatchedWDATA <= 0;
	else if(WVALID == 1'b1 && WREADY == 1'b1)
		LatchedWDATA <= WDATA;
// write Strobo latch
reg  [3:0] LatchedWSTRB;
always @(negedge ARESETn or posedge ACLK)
	if(!ARESETn)
		LatchedWSTRB <= 0;
	else if(WVALID == 1'b1 && WREADY == 1'b1)
		LatchedWSTRB <= WSTRB[3:0];




assign WREADY = (StateIsWRITE && (WDATAAvailable == 1'b0 || PENABLEandPREADY == 1'b1));

assign IsWritePending = WritePSEL^PENABLEandPREADY;

assign BID    = Id[WID_WIDTH-1:0];
assign BRESP  = `RESP_OKAY;
assign BVALID = StateIsWRITE_RESP;

assign NextAddrCalcEn = (PENABLEandPREADY == 1'b1);
//
// APB Interface
//
wire PSELEn = WritePSEL | ReadPSEL;
always @(negedge ARESETn or posedge ACLK)
	if(!ARESETn)
		PENABLE <= 0;
	else if(PSELEn == 1 && PENABLE == 0)
		PENABLE <= 1;
	else if(PSELEn == 1 && PENABLE == 1 && PREADY == 1)
		PENABLE <= 0;

assign PADDR  = GeneratedAddr;
assign PWDATA = LatchedWDATA;
assign PWSTRB = LatchedWSTRB;
assign PWRITE = (StateIsREAD == 1'b1) ? 1'b0 : 1'b1;

wire	PSEL = PSELEn;

endmodule
