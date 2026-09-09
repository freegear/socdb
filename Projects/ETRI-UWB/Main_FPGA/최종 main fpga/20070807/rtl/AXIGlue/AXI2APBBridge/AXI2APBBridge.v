// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : AXI2APBBridge.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is AXI-to-APB interface.
//  =============================================================================

`timescale 1ns/1ps

`define SIMPLE_IMPLEMENTATION 1
module AXI2APBBridge 
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
		RREADY   ,

//	APB Interface
		PCLKEN   ,
		PADDR    ,
		PWRITE   ,
		PSEL0    ,
		PSEL1    ,
		PSEL2    ,
		PSEL3    ,
		PSEL4    ,
		PSEL5    ,
		PSEL6    ,
		PSEL7    ,
		PSEL8    ,
		PSEL9    ,
		PSELA    ,
		PSELB    ,
		PSELC    ,
		PSELD    ,
		PSELE    ,
		PSELF    ,
		PENABLE  ,
		PRDATA0  ,
		PRDATA1  ,
		PRDATA2  ,
		PRDATA3  ,
		PRDATA4  ,
		PRDATA5  ,
		PRDATA6  ,
		PRDATA7  ,
		PRDATA8  ,
		PRDATA9  ,
		PRDATAA  ,
		PRDATAB  ,
		PRDATAC  ,
		PRDATAD  ,
		PRDATAE  ,
		PRDATAF  ,
		PREADY0  ,
		PREADY1  ,
		PREADY2  ,
		PREADY3  ,
		PREADY4  ,
		PREADY5  ,
		PREADY6  ,
		PREADY7  ,
		PREADY8  ,
		PREADY9  ,
		PREADYA  ,
		PREADYB  ,
		PREADYC  ,
		PREADYD  ,
		PREADYE  ,
		PREADYF  ,
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
// input  [3:0]   WSTRB;
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

input                  PCLKEN;
output [31:0]          PADDR;
output                 PWRITE;
output                 PSEL0;
output                 PSEL1;
output                 PSEL2;
output                 PSEL3;
output                 PSEL4;
output                 PSEL5;
output                 PSEL6;
output                 PSEL7;
output                 PSEL8;
output                 PSEL9;
output                 PSELA;
output                 PSELB;
output                 PSELC;
output                 PSELD;
output                 PSELE;
output                 PSELF;
output                 PENABLE;
input  [31:0]          PRDATA0;
input  [31:0]          PRDATA1;
input  [31:0]          PRDATA2;
input  [31:0]          PRDATA3;
input  [31:0]          PRDATA4;
input  [31:0]          PRDATA5;
input  [31:0]          PRDATA6;
input  [31:0]          PRDATA7;
input  [31:0]          PRDATA8;
input  [31:0]          PRDATA9;
input  [31:0]          PRDATAA;
input  [31:0]          PRDATAB;
input  [31:0]          PRDATAC;
input  [31:0]          PRDATAD;
input  [31:0]          PRDATAE;
input  [31:0]          PRDATAF;
input                  PREADY0;
input                  PREADY1;
input                  PREADY2;
input                  PREADY3;
input                  PREADY4;
input                  PREADY5;
input                  PREADY6;
input                  PREADY7;
input                  PREADY8;
input                  PREADY9;
input                  PREADYA;
input                  PREADYB;
input                  PREADYC;
input                  PREADYD;
input                  PREADYE;
input                  PREADYF;
output [31:0]          PWDATA;

reg                    PENABLE;

`ifndef SIMPLE_IMPLEMENTATION
reg    [31:0]          PRDATA;
reg                    PREADY;
`else
wire   [31:0]          PRDATA;
wire                   PREADY;
`endif
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
		Id <= 0;
	end
	else
	begin
		if (StateIsIDLE)
		begin
			BurstLen <= MuxedLen;
			Burst <= MuxedBurst;
		end
		// synopsys translate_off
		if(LatchCommandEn == 1'b1 && MuxedSize[1:0] != 2'b10)
			$display("AXI2APBBridge : Transaction size is not 32bit word");
		// synopsys translate_on

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
	else if(StateIsIDLE == 1'b1 && (ARVALID == 1 || AWVALID == 1))
		GeneratedAddr <= MuxedAddr;
	else if(NextAddrCalcEn)
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
wire PENABLEandPREADY;
assign PENABLEandPREADY = PENABLE & PREADY;
reg  WaitingRREADY;	// 1 when send RVALID and not receive RREADY
reg  ReadPSELRiseControl;
wire ReadPSEL = (WaitingRREADY == 0 && StateIsREAD && ReadPSELRiseControl) ? 1'b1 : 1'b0;
assign DecreaseLen  = (WaitingRREADY == 1'b1 || (PENABLEandPREADY == 1'b1 && PCLKEN == 1'b1)) && RREADY == 1'b1;

reg  nextWaitingRREADY;
always @(WaitingRREADY or StateIsREAD or PENABLEandPREADY or PCLKEN or RREADY)
begin
	nextWaitingRREADY = WaitingRREADY;
	if(!StateIsREAD)
		nextWaitingRREADY = 0;
	else if(PENABLEandPREADY == 1'b1 && PCLKEN == 1'b1 && RREADY == 1'b0)
		nextWaitingRREADY = 1;
	else if(WaitingRREADY == 1 && RREADY == 1'b1)
		nextWaitingRREADY = 0;
end

/*
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		WaitingRREADY <= 0;
	else if(!StateIsREAD)
		WaitingRREADY <= 0;
	else if(PENABLEandPREADY == 1'b1 && PCLKEN == 1'b1 && RREADY == 1'b0)
		WaitingRREADY <= 1;
	else if(WaitingRREADY == 1 && RREADY == 1'b1)
		WaitingRREADY <= 0;
end
*/
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		WaitingRREADY <= 0;
	else WaitingRREADY <= nextWaitingRREADY;
end

always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		ReadPSELRiseControl <= 1'b1;
	else if (((StateIsIDLE && ARVALID == 1'b1 && ReadOrWrite == 1'b0) // transition to S_READ
			|| (WaitingRREADY == 1'b1 && nextWaitingRREADY == 1'b0))
			&& PCLKEN == 1'b0)
		ReadPSELRiseControl <= 1'b0;
	else if(ReadPSELRiseControl == 1'b0 && PCLKEN == 1'b1)
		ReadPSELRiseControl <= 1'b1;
end

reg  [31:0] LatchedPRDATA;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		LatchedPRDATA <= 0;
	else if(PENABLEandPREADY == 1'b1 && PCLKEN == 1'b1)
		LatchedPRDATA <= PRDATA;
end

assign RID    = Id[RID_WIDTH-1:0];
assign RDATA  = (WaitingRREADY == 1) ? LatchedPRDATA : PRDATA;
assign RVALID = StateIsREAD & ((PENABLEandPREADY&PCLKEN) | WaitingRREADY);
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
	else if(StateIsWRITE && WVALID == 1'b1 && PCLKEN == 1)
		WDATAAvailable <= 1;
	else if(PENABLEandPREADY == 1'b1 && PCLKEN == 1)
		WDATAAvailable <= 0;
end

reg  [31:0] LatchedWDATA;
always @(negedge ARESETn or posedge ACLK)
	if(!ARESETn)
		LatchedWDATA <= 0;
	else if(WVALID == 1'b1 && WREADY == 1'b1)
		LatchedWDATA <= WDATA;

assign WREADY = (StateIsWRITE && (WDATAAvailable == 1'b0 || PENABLEandPREADY == 1'b1) && PCLKEN == 1'b1);

assign IsWritePending = WritePSEL^(PENABLEandPREADY&PCLKEN);

assign BID    = Id[WID_WIDTH-1:0];
assign BRESP  = `RESP_OKAY;
assign BVALID = StateIsWRITE_RESP;

assign NextAddrCalcEn = (PENABLEandPREADY&PCLKEN == 1'b1);
//
// APB Interface
//
wire PSELEn = WritePSEL | ReadPSEL;
always @(negedge ARESETn or posedge ACLK)
	if(!ARESETn)
		PENABLE <= 0;
	else if(PSELEn == 1 && PENABLE == 0 && PCLKEN == 1)
		PENABLE <= 1;
	else if(PSELEn == 1 && PENABLE == 1 && PREADY == 1 && PCLKEN == 1)
		PENABLE <= 0;

assign PADDR  = GeneratedAddr;
assign PWDATA = LatchedWDATA;
assign PWRITE = (StateIsREAD == 1'b1) ? 1'b0 : 1'b1;

// Address decoding
reg  PSEL0;
reg  PSEL1;
reg  PSEL2;
reg  PSEL3;
reg  PSEL4;
reg  PSEL5;
reg  PSEL6;
reg  PSEL7;
reg  PSEL8;
reg  PSEL9;
reg  PSELA;
reg  PSELB;
reg  PSELC;
reg  PSELD;
reg  PSELE;
reg  PSELF;
always @(GeneratedAddr or PSELEn)
begin
	PSEL0 = 0;
	PSEL1 = 0;
	PSEL2 = 0;
	PSEL3 = 0;
	PSEL4 = 0;
	PSEL5 = 0;
	PSEL6 = 0;
	PSEL7 = 0;
	PSEL8 = 0;
	PSEL9 = 0;
	PSELA = 0;
	PSELB = 0;
	PSELC = 0;
	PSELD = 0;
	PSELE = 0;
	PSELF = 0;
	case(GeneratedAddr[15:12])
	4'h0: PSEL0 = PSELEn;
	4'h1: PSEL1 = PSELEn;
	4'h2: PSEL2 = PSELEn;
	4'h3: PSEL3 = PSELEn;
	4'h4: PSEL4 = PSELEn;
	4'h5: PSEL5 = PSELEn;
	4'h6: PSEL6 = PSELEn;
	4'h7: PSEL7 = PSELEn;
	4'h8: PSEL8 = PSELEn;
	4'h9: PSEL9 = PSELEn;
	4'hA: PSELA = PSELEn;
	4'hB: PSELB = PSELEn;
	4'hC: PSELC = PSELEn;
	4'hD: PSELD = PSELEn;
	4'hE: PSELE = PSELEn;
	4'hF: PSELF = PSELEn;
	endcase
end

// PDATA mux
// Note :
//  I think PRDATA can be calculated as ({32{PSEL0}} & PRDATA0) | ({32{PSEL1}} & PRDATA1) | ...
//  And the method can result in less gate count.
//  But I wrote above code for easy understanding.
//  Same method can be applited to PREADY generation.
//
`ifndef SIMPLE_IMPLEMENTATION
wire [15:0] PSEL_ALL = {PSELF, PSELE, PSELD, PSELC, PSELB, PSELA, PSEL9, PSEL8, PSEL7, PSEL6, PSEL5, PSEL4, PSEL3, PSEL2, PSEL1, PSEL0 };
always @(PSEL_ALL, PRDATA0, PRDATA1, PRDATA2, PRDATA3, PRDATA4, PRDATA5, PRDATA6, PRDATA7, PRDATA8, PRDATA9, PRDATAA, PRDATAB, PRDATAC, PRDATAD, PRDATAE, PRDATAF)
begin
	case(PSEL_ALL)
	16'b0000000000000001:	PRDATA = PRDATA0;
	16'b0000000000000010:	PRDATA = PRDATA1;
	16'b0000000000000100:	PRDATA = PRDATA2;
	16'b0000000000001000:	PRDATA = PRDATA3;
	16'b0000000000010000:	PRDATA = PRDATA4;
	16'b0000000000100000:	PRDATA = PRDATA5;
	16'b0000000001000000:	PRDATA = PRDATA6;
	16'b0000000010000000:	PRDATA = PRDATA7;
	16'b0000000100000000:	PRDATA = PRDATA8;
	16'b0000001000000000:	PRDATA = PRDATA9;
	16'b0000010000000000:	PRDATA = PRDATAA;
	16'b0000100000000000:	PRDATA = PRDATAB;
	16'b0001000000000000:	PRDATA = PRDATAC;
	16'b0010000000000000:	PRDATA = PRDATAD;
	16'b0100000000000000:	PRDATA = PRDATAE;
	16'b1000000000000000:	PRDATA = PRDATAF;
	default:	PRDATA = 32'h00000000;
	endcase
end

always @(PSEL_ALL, PREADY0, PREADY1, PREADY2, PREADY3, PREADY4, PREADY5, PREADY6, PREADY7, PREADY8, PREADY9, PREADYA, PREADYB, PREADYC, PREADYD, PREADYE, PREADYF)
begin
	case(PSEL_ALL)
	16'b0000000000000001:	PREADY = PREADY0;
	16'b0000000000000010:	PREADY = PREADY1;
	16'b0000000000000100:	PREADY = PREADY2;
	16'b0000000000001000:	PREADY = PREADY3;
	16'b0000000000010000:	PREADY = PREADY4;
	16'b0000000000100000:	PREADY = PREADY5;
	16'b0000000001000000:	PREADY = PREADY6;
	16'b0000000010000000:	PREADY = PREADY7;
	16'b0000000100000000:	PREADY = PREADY8;
	16'b0000001000000000:	PREADY = PREADY9;
	16'b0000010000000000:	PREADY = PREADYA;
	16'b0000100000000000:	PREADY = PREADYB;
	16'b0001000000000000:	PREADY = PREADYC;
	16'b0010000000000000:	PREADY = PREADYD;
	16'b0100000000000000:	PREADY = PREADYE;
	16'b1000000000000000:	PREADY = PREADYF;
	default:	PREADY = 1'b0;
	endcase
end
`else
assign PRDATA = ({32{PSEL0}} & PRDATA0)
			|   ({32{PSEL1}} & PRDATA1)
			|   ({32{PSEL2}} & PRDATA2)
			|   ({32{PSEL3}} & PRDATA3)
			|   ({32{PSEL4}} & PRDATA4)
			|   ({32{PSEL5}} & PRDATA5)
			|   ({32{PSEL6}} & PRDATA6)
			|   ({32{PSEL7}} & PRDATA7)
			|   ({32{PSEL8}} & PRDATA8)
			|   ({32{PSEL9}} & PRDATA9)
			|   ({32{PSELA}} & PRDATAA)
			|   ({32{PSELB}} & PRDATAB)
			|   ({32{PSELC}} & PRDATAC)
			|   ({32{PSELD}} & PRDATAD)
			|   ({32{PSELE}} & PRDATAE)
			|   ({32{PSELF}} & PRDATAF);

assign PREADY = (PSEL0 & PREADY0)
			|   (PSEL1 & PREADY1)
			|   (PSEL2 & PREADY2)
			|   (PSEL3 & PREADY3)
			|   (PSEL4 & PREADY4)
			|   (PSEL5 & PREADY5)
			|   (PSEL6 & PREADY6)
			|   (PSEL7 & PREADY7)
			|   (PSEL8 & PREADY8)
			|   (PSEL9 & PREADY9)
			|   (PSELA & PREADYA)
			|   (PSELB & PREADYB)
			|   (PSELC & PREADYC)
			|   (PSELD & PREADYD)
			|   (PSELE & PREADYE)
			|   (PSELF & PREADYF);
`endif
endmodule
