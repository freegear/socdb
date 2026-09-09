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
parameter MADDR_LOWER = (DATA_WIDTH == 32) ? 2 : 3;
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
// AXI Request Processing
//
reg                  nReadOrWrite;	// Round-Robin Arbitration : 0 when read, 1 when write
reg                  nReadOrWrite_P;
reg [ADDR_WIDTH-1:0] Addr_P;
reg [3:0]            Len_P;
reg [2:0]            Size_P;
reg [1:0]            Burst_P;
reg [ID_WIDTH-1:0]   ID_P;
reg                  VALID_P;
wire                 StartNewRequest;

wire [ADDR_WIDTH-1:0] MuxedAddr;
wire [3:0]            MuxedLen;
wire [2:0]            MuxedSize;
wire [1:0]            MuxedBurst;
wire [ID_WIDTH-1:0]   MuxedId;

//
// Round robin arbitration : toggle nReadOrWrite
//
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		nReadOrWrite <= 1'b0;			// Read First
	else
	begin
		if(ARVALID == 1'b1 && ARREADY == 1'b1)
			nReadOrWrite <= 1'b1;		// Write First
		else if(AWVALID == 1'b1 && AWREADY == 1'b1)
			nReadOrWrite <= 1'b0;		// Read First
		else if((nReadOrWrite == 1'b0 && AWVALID == 1'b1 && ARVALID == 1'b0) || (nReadOrWrite == 1'b1 && ARVALID == 1'b1 && AWVALID == 1'b0))
			nReadOrWrite <= ~nReadOrWrite;	// toggle priority
	end
end

`define STRICT_AXI_STANDARD 1
`ifdef STRICT_AXI_STANDARD
//
// Strict AXI Standard : AR(W)READY is not dependent on AR(W)VALID directly.
//
wire RealnReadOrWrite;
assign RealnReadOrWrite = nReadOrWrite;
`else
//
// Not Strict AXI Standard : AR(W)READY is dependent on AR(W)VALID with combinational logic
//
reg RealnReadOrWrite;
always @(nReadOrWrite or AWVALID or ARVALID)
begin
	RealnReadOrWrite = nReadOrWrite;
	if(nReadOrWrite)
	begin
		if(AWVALID == 0 && ARVALID == 1)
			RealnReadOrWrite = 0;
	end
	else
	begin
		if(ARVALID == 0 && AWVALID == 1)
			RealnReadOrWrite = 1;
	end
end
`endif

assign MuxedAddr  = (RealnReadOrWrite) ? AWADDR : ARADDR;
assign MuxedLen   = (RealnReadOrWrite) ? AWLEN : ARLEN;
assign MuxedSize  = (RealnReadOrWrite) ? AWSIZE : ARSIZE;
assign MuxedBurst = (RealnReadOrWrite) ? AWBURST : ARBURST;
assign MuxedId    = (RealnReadOrWrite) ? AWID : ARID;

//
// Pending Request Register : accept when state is not S_IDLE.
//                          : When state is S_IDLE, Request is latched directly.
//
wire CanAcceptMoreRequest;
assign CanAcceptMoreRequest = (VALID_P == 1'b0 || StartNewRequest);

wire StateIsIDLE;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		VALID_P <= 1'b0;
	end
	else
	begin
		if (StateIsIDLE == 1'b0 && CanAcceptMoreRequest)
		begin
			if((ARVALID == 1'b1 && RealnReadOrWrite == 1'b0)|| (AWVALID == 1'b1 && RealnReadOrWrite == 1'b1))
			begin
				Addr_P         <= MuxedAddr;
				Len_P          <= MuxedLen;
				Size_P         <= MuxedSize;
				Burst_P        <= MuxedBurst;
				ID_P           <= MuxedId;
				nReadOrWrite_P <= RealnReadOrWrite;
				VALID_P        <= 1'b1;
			end
			else if(StartNewRequest == 1'b1)
				VALID_P <= 1'b0;
		end
		else if(StateIsIDLE == 1'b1)
			VALID_P <= 1'b0;
	end
end

assign ARREADY = CanAcceptMoreRequest && !RealnReadOrWrite;
assign AWREADY = CanAcceptMoreRequest && RealnReadOrWrite;

//
// main state machine
//
reg  [3:0] State;		// Current State
reg  [3:0] NextState;	// Next State
parameter S_IDLE = 0, S_READ = 1, S_WRITE = 2, S_WAIT_RESP = 3;

wire StateIsREAD;
wire StateIsWRITE;
wire StateIsWAIT_RESP;
assign StateIsIDLE      = State[S_IDLE];	// Idle state
assign StateIsREAD      = State[S_READ];	// Read state
assign StateIsWRITE     = State[S_WRITE];	// Write state
assign StateIsWAIT_RESP = State[S_WAIT_RESP];	// Wait until previous write response accepted
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

reg SuccessiveRead;	// Indicate READ following READ
reg NextFirstREADCycle;

always @(State or ARVALID or ARREADY or AWVALID or AWREADY or VALID_P or nReadOrWrite_P or RLAST or RVALID or RREADY or WLAST or WVALID or BREADY or BVALID or SuccessiveRead)
begin
	NextState = 0;
	NextFirstREADCycle = 1'b0;
	case(1'b1)	// synopsys parallel_case full_case
	State[S_IDLE]:
		if(VALID_P == 1'b1)	// Is there a previous latched request ?
		begin
			if(nReadOrWrite_P == 1'b0)
				NextState[S_READ] = 1'b1;
			else
				NextState[S_WRITE] = 1'b1;
		end
		else if(ARVALID == 1'b1 && ARREADY == 1'b1)
			NextState[S_READ] = 1'b1;
		else if(AWVALID == 1'b1 && AWREADY == 1'b1)
			NextState[S_WRITE] = 1'b1;
		else
			NextState[S_IDLE] = 1'b1;
	State[S_READ]:
		if(RLAST == 1'b1 && RVALID == 1'b1 && RREADY == 1'b1)	// last read cycle
		begin
			if(VALID_P == 1'b1) // is there a pending request ?
			begin
				if(nReadOrWrite_P == 1'b1)	// write ?
					NextState[S_WRITE] = 1'b1;
				else						// read 
				begin
					NextState[S_READ] = 1'b1;
					NextFirstREADCycle = ~SuccessiveRead;
				end
			end
			else	// No pending request
				NextState[S_IDLE] = 1'b1;
		end
		else
			NextState[S_READ] = 1'b1;
			
	State[S_WRITE]:
		if(WLAST == 1'b1 && WVALID == 1'b1)	// last write cycle
		begin
			if(BVALID == 1'b0 || BREADY == 1'b1)	// is write response logic idle ?
			begin
				if(VALID_P == 1'b1)	// is there a pending request ?
				begin
					if(nReadOrWrite_P == 1'b1)	// write ?
						NextState[S_WRITE] = 1'b1;
					else						// read
						NextState[S_READ] = 1'b1;
				end
				else	// No pending request
					NextState[S_IDLE] = 1'b1;
			end
			else	// Write response channel is busy. => wait
				NextState[S_WAIT_RESP] = 1'b1;
		end
		else
			NextState[S_WRITE] = 1'b1;
	State[S_WAIT_RESP]:
		if(BREADY == 1'b1)	// write response accepted ?
		begin
			if(VALID_P == 1'b1)	// is there a pending request ?
			begin
				if(nReadOrWrite_P == 1'b1)		// write ?
					NextState[S_WRITE] = 1'b1;
				else							// read
					NextState[S_READ] = 1'b1;
			end
			else	// No pending request
				NextState[S_IDLE] = 1'b1;
		end
		else
			NextState[S_WAIT_RESP] = 1'b1;
	endcase
end

//
// register used in real transfer
//
reg  [ID_WIDTH-1:0]   Id;		// ARID/AWID for BID/RID
reg  [ADDR_WIDTH-1:0] Addr;		// Address for SRAM
reg  [3:0]            Len;		// ARLEN/AWLEN, decreases at each read
reg  [3:0]            BurstLen;	// ARLEN/AWLEN, preserved during full transaciton.
reg  [1:0]            Size;		// ARSIZE/AWSIZE
reg  [1:0]            Burst;	// ARBURST/AWBURST


assign StartNewRequest =
		VALID_P == 1'b1 &&
		((StateIsWRITE && WLAST == 1'b1 && WVALID == 1'b1 && (BVALID == 1'b0 || BREADY == 1'b1))
		|| (StateIsWAIT_RESP && BREADY == 1'b1)
		|| (StateIsREAD && RLAST == 1'b1 && RVALID == 1'b1 && RREADY == 1'b1));

// first read cycle should be treated specially.(No RVALID output)
reg FirstREADCycle;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		FirstREADCycle <= 1'b0;
	else
	begin
		if((StateIsREAD != 1'b1 && NextState[S_READ] == 1'b1) || NextFirstREADCycle)
			FirstREADCycle <= 1'b1;
		else
			FirstREADCycle <= 1'b0;
	end
end

// successive read detect condition
wire SuccessiveReadCondition;
assign SuccessiveReadCondition =
		StateIsREAD && ((Len == 0 && (FirstREADCycle)) || (Len == 1 && ~FirstREADCycle)) && VALID_P == 1'b1 && nReadOrWrite_P == 1'b0;

//
// Latch Request Information for later use
//
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		BurstLen <= 0;
		Size <= 0;
		Burst <= 0;
		Id <= 0;
	end
	else
	begin
		if(StateIsIDLE && VALID_P == 1'b0)
		begin
			BurstLen <= MuxedLen;
			Size     <= MuxedSize;
			Burst    <= MuxedBurst;
			Id       <= MuxedId;
		end
		else
		begin
			if (StartNewRequest || StateIsIDLE || SuccessiveReadCondition)
			begin
				BurstLen <= Len_P;
				Size <= Size_P[1:0];
				Burst <= Burst_P;
			end
			if (StartNewRequest || StateIsIDLE)
				Id <= ID_P;
		end
	end
end

assign RID    = Id[RID_WIDTH-1:0];
assign RDATA  = MEMRDATA;		// Just connect to SRAM
assign RRESP  = `RESP_OKAY;		// Always OKAY
assign RVALID = StateIsREAD & ~FirstREADCycle;	// No Data available when First read cycle
assign RLAST  = (Len == 0) ? 1'b1 : 1'b0;

assign WREADY = (StateIsWRITE) ? 1'b1 : 1'b0;

//
// AXI Write Response Processing : Working independently
//
reg                 BVALID;
reg [WID_WIDTH-1:0] BID;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		BVALID <= 1'b0;
	else
	begin
		if((BVALID == 1'b0 || BREADY == 1'b1) && ((WLAST == 1'b1 && WVALID == 1'b1 && WREADY == 1'b1) || StateIsWAIT_RESP))	// Receive new response
		begin
			BID    <= Id[WID_WIDTH-1:0];
			BVALID <= 1'b1;
		end
		else if(BREADY == 1'b1)
			BVALID <= 1'b0;
	end
end
assign BRESP   = `RESP_OKAY;	// always OKAY

//
// Address generator & Len decreaser for RLAST
//
wire DecreaseLen    = RVALID && RREADY; // length decreases only when valid read cycle.
wire NextAddrCalcEn = FirstREADCycle | DecreaseLen | (StateIsWRITE == 1'b1 && WVALID == 1'b1);

reg [ADDR_WIDTH-1:0] IncreasedAddr;
reg [ADDR_WIDTH-1:0] PrevAddr;
reg [6:0]  WrapMask;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		Addr <= 0;
		Len <= 0;
		SuccessiveRead <= 0;
	end
	else
	begin
		if(StateIsIDLE && VALID_P == 1'b0)
		begin
			Addr <= MuxedAddr;
			Len  <= MuxedLen;
		end
		else if((StartNewRequest == 1'b1 || StateIsIDLE) && SuccessiveRead == 0)
		begin
			Addr <= Addr_P;
			Len <= Len_P;
		end
		else
		begin
			// update when ready, valid are both high
			if(NextAddrCalcEn)
			begin
				if(SuccessiveReadCondition == 1'b1)
				begin
					Addr <= Addr_P;
					SuccessiveRead <= 1;
				end
				else
				begin
					if(SuccessiveRead == 1)
						SuccessiveRead <= 0;
					case(Burst)
					2'b01: // INCR Burst
						Addr[ADDR_WIDTH-1:0] <= IncreasedAddr[ADDR_WIDTH-1:0];		// Only update for 4 KB
					2'b10: // WRAP Burst
						Addr[6:0] <= (Addr[6:0]&(~WrapMask))|(IncreasedAddr[6:0]&WrapMask);
					default:	// FIXED Burst or Unknown Burst
						Addr[ADDR_WIDTH-1:0] <= Addr[ADDR_WIDTH-1:0];
					endcase
				end
			end

			if(StartNewRequest == 1'b1)
				Len <= Len_P;
			else if(DecreaseLen)
				Len <= Len - 1'b1;
		end
	end
end

always @(posedge ACLK or negedge ARESETn )
  if(~ARESETn) PrevAddr <= {ADDR_WIDTH{1'b0}};
  else if(NextAddrCalcEn || FirstREADCycle)
		PrevAddr <= Addr;

// Wrap mask signal
always @(Size or BurstLen)
	case(BurstLen)
	4'b0001:	// 2
	begin
		case (Size[1:0])
		2'b00: WrapMask <= 7'b0000001;
		2'b01: WrapMask <= 7'b0000011;
		2'b10: WrapMask <= 7'b0000111;
		2'b11: WrapMask <= 7'b0001111;
		endcase
	end
	4'b0011:	// 4
	begin
		case (Size[1:0])
		2'b00: WrapMask <= 7'b0000011;
		2'b01: WrapMask <= 7'b0000111;
		2'b10: WrapMask <= 7'b0001111;
		2'b11: WrapMask <= 7'b0011111;
		endcase
	end
	4'b0111:	// 8
	begin
		case (Size[1:0])
		2'b00: WrapMask <= 7'b0000111;
		2'b01: WrapMask <= 7'b0001111;
		2'b10: WrapMask <= 7'b0011111;
		2'b11: WrapMask <= 7'b0111111;
		endcase
	end
	4'b1111:	// 16
	begin
		case (Size[1:0])
		2'b00: WrapMask <= 7'b0001111;
		2'b01: WrapMask <= 7'b0011111;
		2'b10: WrapMask <= 7'b0111111;
		2'b11: WrapMask <= 7'b1111111;
		endcase
	end
	default: WrapMask <= 7'bxxxxxxx;	// don't care
	endcase

reg [4:0] IncrSize;
always @(Size)
	case (Size[1:0])
	2'b00: IncrSize <= 4'h1;
	2'b01: IncrSize <= 4'h2;
	2'b10: IncrSize <= 4'h4;
	2'b11: IncrSize <= 4'h8;
	endcase

always @(Addr or IncrSize) IncreasedAddr <= Addr[ADDR_WIDTH-1:0] + IncrSize;

//
// SRAM Interface
//
assign MEMADDR[MADDR_WIDTH-1:0] = (StateIsWRITE || FirstREADCycle || RREADY == 1'b1) ? Addr[ADDR_WIDTH-1:MADDR_LOWER] : PrevAddr[ADDR_WIDTH-1:MADDR_LOWER];
assign MEMCEn   = (StateIsREAD || StateIsWRITE) ? 1'b0 : 1'b1;
assign MEMWEn   = (StateIsWRITE && WVALID == 1'b1) ? (~WSTRB) : {NUM_BYTE{1'b1}};
assign MEMWDATA = WDATA;

endmodule
