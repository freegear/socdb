// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DmacAXIArbiter.v
// File Revision       : 0.1
// ------------------------------------------------------------------------------
//  Purpose            : AXI Arbiter for DMA Controller
// ==============================================================================
// This module is similar to 2x1 AXI BUS, but is not 2x1 AXI BUS.
// There is a combinational path between AXI interface.
// So it can result in larget delay.
// I recommend use Register Slice after this module.


`timescale 1ns/1ps

module DmacAXIArbiter
(
		//	CLK & Reset
		ACLK     ,
		ARESETn  ,

		// AXI Interface 0
		ARVALID0,
		ARREADY0,
		ARADDR0,
		ARLEN0,
		ARSIZE0,
		ARBURST0,

		RDATA0,
		RRESP0,
		RLAST0,
		RVALID0,
		RREADY0,

		AWVALID0,
		AWREADY0,
		AWADDR0,
		AWLEN0,
		AWSIZE0,
		AWBURST0,

		WDATA0,
		WSTRB0,
		WLAST0,
		WVALID0,
		WREADY0,

		BRESP0,
		BVALID0,
		BREADY0,

		// AXI Interface 1
		ARVALID1,
		ARREADY1,
		ARADDR1,
		ARLEN1,
		ARSIZE1,
		ARBURST1,

		RDATA1,
		RRESP1,
		RLAST1,
		RVALID1,
		RREADY1,

		AWVALID1,
		AWREADY1,
		AWADDR1,
		AWLEN1,
		AWSIZE1,
		AWBURST1,

		WDATA1,
		WSTRB1,
		WLAST1,
		WVALID1,
		WREADY1,

		BRESP1,
		BVALID1,
		BREADY1,

		// AXI Interface
		ARID,
		ARVALID,
		ARREADY,
		ARADDR,
		ARLEN,
		ARSIZE,
		ARBURST,

		RID,
		RDATA,
		RRESP,
		RLAST,
		RVALID,
		RREADY,

		AWID,
		AWVALID,
		AWREADY,
		AWADDR,
		AWLEN,
		AWSIZE,
		AWBURST,

		WID,
		WDATA,
		WSTRB,
		WLAST,
		WVALID,
		WREADY,

		BID,
		BRESP,
		BVALID,
		BREADY
);

//
// input/output port
//
input         ACLK;
input         ARESETn;

// AXI Interface 0
input         ARVALID0;
output        ARREADY0;
input  [31:0] ARADDR0;
input  [3:0]  ARLEN0;
input  [2:0]  ARSIZE0;
input  [1:0]  ARBURST0;

output [31:0] RDATA0;
output [1:0]  RRESP0;
output        RLAST0;
output        RVALID0;
input         RREADY0;

input         AWVALID0;
output        AWREADY0;
input  [31:0] AWADDR0;
input  [3:0]  AWLEN0;
input  [2:0]  AWSIZE0;
input  [1:0]  AWBURST0;

input  [31:0] WDATA0;
input  [3:0]  WSTRB0;
input         WLAST0;
input         WVALID0;
output        WREADY0;

output [1:0]  BRESP0;
output        BVALID0;
input         BREADY0;

// AXI Interface 1
input         ARVALID1;
output        ARREADY1;
input  [31:0] ARADDR1;
input  [3:0]  ARLEN1;
input  [2:0]  ARSIZE1;
input  [1:0]  ARBURST1;

output [31:0] RDATA1;
output [1:0]  RRESP1;
output        RLAST1;
output        RVALID1;
input         RREADY1;

input         AWVALID1;
output        AWREADY1;
input  [31:0] AWADDR1;
input  [3:0]  AWLEN1;
input  [2:0]  AWSIZE1;
input  [1:0]  AWBURST1;

input  [31:0] WDATA1;
input  [3:0]  WSTRB1;
input         WLAST1;
input         WVALID1;
output        WREADY1;

output [1:0]  BRESP1;
output        BVALID1;
input         BREADY1;

// AXI Interface
output        ARID;
output        ARVALID;
input         ARREADY;
output [31:0] ARADDR;
output [3:0]  ARLEN;
output [2:0]  ARSIZE;
output [1:0]  ARBURST;

input         RID;
input  [31:0] RDATA;
input  [1:0]  RRESP;
input         RLAST;
input         RVALID;
output        RREADY;

output        AWID;
output        AWVALID;
input         AWREADY;
output [31:0] AWADDR;
output [3:0]  AWLEN;
output [2:0]  AWSIZE;
output [1:0]  AWBURST;

output        WID;
output [31:0] WDATA;
output [3:0]  WSTRB;
output        WLAST;
output        WVALID;
input         WREADY;

input         BID;
input  [1:0]  BRESP;
input         BVALID;
output        BREADY;

// AR Channel
reg   ARidle;
reg   ARSel_reg;
wire  ARSel;

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		ARidle <= 1;
	else if(ARVALID == 1 && ARREADY == 0)
		ARidle <= 0;
	else if(ARREADY == 1)
		ARidle <= 1;
end
always @(posedge ACLK)
	if(ARidle) ARSel_reg <= ARSel;

assign ARSel = (ARVALID0 == 1) ? 0 : 1;	// Channel 0 has higher priority
wire   ARSelected0;
assign ARSelected0 = (ARidle == 1 && ARSel == 0) | (ARidle == 0 && ARSel_reg == 0);

assign ARID     = !ARSelected0;
assign ARVALID  = ARVALID0|ARVALID1;
assign ARREADY0 = ARREADY & ARSelected0;
assign ARREADY1 = ARREADY & ~ARSelected0;
assign ARADDR   = (ARSelected0) ? ARADDR0 : ARADDR1;
assign ARLEN    = (ARSelected0) ? ARLEN0 : ARLEN1;
assign ARBURST  = (ARSelected0) ? ARBURST0 : ARBURST1;
assign ARSIZE   = (ARSelected0) ? ARSIZE0 : ARSIZE1;

// RDATA Channel
assign RDATA0 = RDATA;
assign RRESP0 = RRESP;
assign RLAST0 = RLAST;
assign RVALID0 = RVALID&(RID == 0);

assign RDATA1 = RDATA;
assign RRESP1 = RRESP;
assign RLAST1 = RLAST;
assign RVALID1 = RVALID&(RID != 0);

assign RREADY  = (RVALID) ? ((RID == 0) ? RREADY0 : RREADY1) : 0;	// this can result in large routing delay 

// AW Channel
reg   AWidle;
reg   AWSel_reg;
wire  AWSel;

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		AWidle <= 1;
	else if(AWVALID == 1 && AWREADY == 0)
		AWidle <= 0;
	else if(AWREADY == 1)
		AWidle <= 1;
end
always @(posedge ACLK)
	if(AWidle) AWSel_reg <= AWSel;

assign AWSel = (AWVALID0 == 1) ? 0 : 1;	// Channel 0 has higher priority
wire   AWSelected0;
assign AWSelected0 = (AWidle == 1 && AWSel == 0) | (AWidle == 0 && AWSel_reg == 0);

reg        AWIDQueFull;
assign AWID     = !AWSelected0;
assign AWVALID  = (AWVALID0|AWVALID1) & ~AWIDQueFull;
assign AWREADY0 = (AWREADY & AWSelected0) & ~AWIDQueFull;
assign AWREADY1 = (AWREADY & ~AWSelected0) & ~AWIDQueFull;
assign AWADDR   = (AWSelected0) ? AWADDR0 : AWADDR1;
assign AWLEN    = (AWSelected0) ? AWLEN0 : AWLEN1;
assign AWBURST  = (AWSelected0) ? AWBURST0 : AWBURST1;
assign AWSIZE   = (AWSelected0) ? AWSIZE0 : AWSIZE1;

wire AWTrans;
wire WLastTrans;

assign AWTrans    = AWVALID & AWREADY;
assign WLastTrans = WLAST & WVALID & WREADY;

reg  [5:0] AWIDQue;
reg  [2:0] AWIDQueReadIndex;
reg  [2:0] AWIDQueWriteIndex;
wire       AWIDQueEmpty;
assign     AWIDQueEmpty = (!AWIDQueFull) & (AWIDQueReadIndex == AWIDQueWriteIndex);

wire [2:0] NextAWIDQueWriteIndex;
assign     NextAWIDQueWriteIndex = (AWIDQueWriteIndex == 3'b101) ? 3'b000 : (AWIDQueWriteIndex + 1);
wire [2:0] NextAWIDQueReadIndex;
assign     NextAWIDQueReadIndex = (AWIDQueReadIndex == 3'b101) ? 3'b000 : (AWIDQueReadIndex + 1);
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		AWIDQue[5:0] <= 6'd0;
		AWIDQueReadIndex <= 0;
		AWIDQueWriteIndex <= 0;
		AWIDQueFull <= 0;
	end
	else
	begin
		if(AWTrans)
		begin
			case(AWIDQueWriteIndex)	// synopsys full_case
			3'b000: AWIDQue[0] <= AWID;
			3'b001: AWIDQue[1] <= AWID;
			3'b010: AWIDQue[2] <= AWID;
			3'b011: AWIDQue[3] <= AWID;
			3'b100: AWIDQue[4] <= AWID;
			3'b101: AWIDQue[5] <= AWID;
			endcase

			AWIDQueWriteIndex <= NextAWIDQueWriteIndex;
		end

		if(AWTrans & (NextAWIDQueWriteIndex == AWIDQueReadIndex) & ~WLastTrans)
			AWIDQueFull <= 1;
		else if(WLastTrans)
			AWIDQueFull <= 0;

		if(WLastTrans)
			AWIDQueReadIndex <= NextAWIDQueReadIndex;
	end
end

// WDATA Channel
reg    WID;
always @(AWIDQueReadIndex or AWIDQue)
begin
	case(AWIDQueReadIndex)	// synopsys full_case
	3'b000: WID = AWIDQue[0];
	3'b001: WID = AWIDQue[1];
	3'b010: WID = AWIDQue[2];
	3'b011: WID = AWIDQue[3];
	3'b100: WID = AWIDQue[4];
	3'b101: WID = AWIDQue[5];
	endcase
end

assign WDATA   = (WID == 0) ? WDATA0 : WDATA1;
assign WSTRB   = (WID == 0) ? WSTRB0 : WSTRB1;
assign WLAST   = (WID == 0) ? WLAST0 : WLAST1;
assign WVALID  = ((WID == 0) ? WVALID0 : WVALID1) & ~AWIDQueEmpty;
assign WREADY0 = (WREADY & (WID == 0)) & ~AWIDQueEmpty;
assign WREADY1 = (WREADY & (WID != 0)) & ~AWIDQueEmpty;


// WResp Channel
assign BRESP0 = BRESP;
assign BVALID0 = BVALID&(BID == 0);
assign BRESP1 = BRESP;
assign BVALID1 = BVALID&(BID != 0);
assign BREADY  = (BVALID) ? ((BID == 0) ? BREADY0 : BREADY1) : 0;	// this can result in large routing delay 


endmodule
