// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TestMaster.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is programmable AXI master signal generator.
//                     : This is behavioral model.(You cannot synthesize this)
//  =============================================================================

`timescale 1ns/10ps

module TestMaster
(
		ACLK     , 
		ARESETn  , 
		// Write Address Channel
		AWID     ,
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
		ARLOCK   ,
		ARCACHE  ,
		ARPROT   ,
		ARVALID  ,
		ARREADY  ,

		// Read Data Channel
		RID      ,
		RDATA    ,
		RRESP    ,
		RLAST    ,
		RVALID   ,
		RREADY   ,

		WADDR_START,
		WADDR_END
);

//
// module parameter
//
parameter DATA_WIDTH = 32;	// only support 32 now
parameter WID_WIDTH = 4;	// AWID/WID/BID width
parameter RID_WIDTH = 4;	// ARID/RID width
parameter RANDOMIZE = 1;	// VALID & READY timing is random
parameter WRAP_SUPPORT = 1;	// WRAP Burst support flag at random read/write test
parameter WORD_ONLY = 0;	// Word Only or Word/HWord/Byte support
parameter HALFWORD_BYTE_SINGLE_ONLY = 0;	// Halfword/byte transfer will be only single tranfer(not burst)
parameter MAXIMUM_IDLE_CNT = 100000;	// maximum idle cycle without generating error

parameter AWQ_WIDTH = 4;	// AW Request Que(4 bit : que length 16)
parameter WDQ_WIDTH = 8;	// WD Data Que(16*16)

parameter ARQ_WIDTH = 4;	// AR Request Que
parameter RDQ_WIDTH = 8;	// RD DAta Que for each ARID

parameter CNT_WIDTH = 32;		// I think it is sufficient

// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;
parameter AWQ_LEN = {AWQ_WIDTH{1'b1}}+1;
parameter WDQ_LEN = {WDQ_WIDTH{1'b1}}+1;
parameter ARQ_LEN = {ARQ_WIDTH{1'b1}}+1;
parameter RDQ_LEN = {RDQ_WIDTH{1'b1}}+1;
parameter RID_LEN = {RID_WIDTH{1'b1}}+1;
parameter WID_LEN = {WID_WIDTH{1'b1}}+1;

parameter UNITDELAY = 1;
`define RESP_OKAY	2'b00

//
// input/output port
//
input  ACLK;
input  ARESETn;

output [WID_WIDTH-1:0]  AWID;
output [31:0]           AWADDR;
output [3:0]            AWLEN;
output [2:0]            AWSIZE;
output [1:0]            AWBURST;
output [1:0]            AWLOCK;
output [3:0]            AWCACHE;
output [2:0]            AWPROT;
output                  AWVALID;
input                   AWREADY;

output [WID_WIDTH-1:0]  WID;
output [DATA_WIDTH-1:0] WDATA;
output [NUM_BYTE-1:0]   WSTRB;
output                  WLAST;
output                  WVALID;
input                   WREADY;


input  [WID_WIDTH-1:0]  BID;
input  [1:0]            BRESP;
input                   BVALID;
output                  BREADY;

output [RID_WIDTH-1:0]  ARID;
output [31:0]           ARADDR;
output [3:0]            ARLEN;
output [2:0]            ARSIZE;
output [1:0]            ARBURST;
output [1:0]            ARLOCK;
output [3:0]            ARCACHE;
output [2:0]            ARPROT;
output                  ARVALID;
input                   ARREADY;

input  [RID_WIDTH-1:0]  RID;
input  [DATA_WIDTH-1:0] RDATA;
input  [1:0]            RRESP;
input                   RLAST;
input                   RVALID;
output                  RREADY;

// for check of write address range
output [31:0]           WADDR_START;
output [31:0]           WADDR_END;

//
// reg for ouptut
//
reg    [WID_WIDTH-1:0]  AWID_r;
reg    [31:0]           AWADDR_r;
reg    [3:0]            AWLEN_r;
reg    [2:0]            AWSIZE_r;
reg    [1:0]            AWBURST_r;
reg    [1:0]            AWLOCK_r;
reg    [3:0]            AWCACHE_r;
reg    [2:0]            AWPROT_r;
reg                     AWVALID;

reg    [WID_WIDTH-1:0]  WID_r;
reg    [DATA_WIDTH-1:0] WDATA_r;
reg    [DATA_WIDTH-1:0] WDATA;
reg    [NUM_BYTE-1:0]   WSTRB_r;
reg                     WLAST_r;
reg                     WVALID;

reg                     BREADY;

reg    [RID_WIDTH-1:0]  ARID_r;
reg    [31:0]           ARADDR_r;
reg    [3:0]            ARLEN_r;
reg    [2:0]            ARSIZE_r;
reg    [1:0]            ARBURST_r;
reg    [1:0]            ARLOCK_r;
reg    [3:0]            ARCACHE_r;
reg    [2:0]            ARPROT_r;
reg                     ARVALID;

reg                     RREADY;


assign AWID    = (AWVALID) ? AWID_r : {WID_WIDTH{1'bx}};
assign AWADDR  = (AWVALID) ? AWADDR_r : {32{1'bx}};
assign AWLEN   = (AWVALID) ? AWLEN_r : {4{1'bx}};
assign AWSIZE  = (AWVALID) ? AWSIZE_r : {3{1'bx}};
assign AWBURST = (AWVALID) ? AWBURST_r : {2{1'bx}};
assign AWLOCK  = (AWVALID) ? AWLOCK_r : {2{1'bx}};
assign AWCACHE = (AWVALID) ? AWCACHE_r : {4{1'bx}};
assign AWPROT  = (AWVALID) ? AWPROT_r : {3{1'bx}};

assign WID     = (WVALID) ? WID_r : {WID_WIDTH{1'bx}};
//assign WDATA   = (WVALID) ? WDATA_r : {DATA_WIDTH{1'bx}};
always @(WDATA_r, WVALID, WSTRB)
begin
	if(WVALID == 0)
		WDATA = {DATA_WIDTH{1'bx}};
	else
	begin
		WDATA = WDATA_r;
		if(WSTRB[0] !== 1)
			WDATA[7:0] = {8{1'bx}};
		if(WSTRB[1] !== 1)
			WDATA[15:8] = {8{1'bx}};
		if(WSTRB[2] !== 1)
			WDATA[23:16] = {8{1'bx}};
		if(WSTRB[3] !== 1)
			WDATA[31:24] = {8{1'bx}};
	end
end
assign WSTRB   = (WVALID) ? WSTRB_r : {NUM_BYTE{1'bx}};
assign WLAST   = (WVALID) ? WLAST_r : 1'bx;

assign ARID    = (ARVALID) ? ARID_r : {RID_WIDTH{1'bx}};
assign ARADDR  = (ARVALID) ? ARADDR_r : {32{1'bx}};
assign ARLEN   = (ARVALID) ? ARLEN_r : {4{1'bx}};
assign ARSIZE  = (ARVALID) ? ARSIZE_r : {3{1'bx}};
assign ARBURST = (ARVALID) ? ARBURST_r : {2{1'bx}};
assign ARLOCK  = (ARVALID) ? ARLOCK_r : {2{1'bx}};
assign ARCACHE = (ARVALID) ? ARCACHE_r : {4{1'bx}};
assign ARPROT  = (ARVALID) ? ARPROT_r : {3{1'bx}};

//
// QUE & Data for each channel
//

// AW Channel Que & Data
reg  [AWQ_WIDTH-1:0]  AWQ_WINDEX;	// Write Que Index
reg  [AWQ_WIDTH-1:0]  AWQ_RINDEX;	// Read Que Index
reg  [WID_WIDTH-1:0]  AWID_Q[AWQ_LEN-1:0];
reg  [31:0]           AWADDR_Q[AWQ_LEN-1:0];
reg  [3:0]            AWLEN_Q[AWQ_LEN-1:0];
reg  [2:0]            AWSIZE_Q[AWQ_LEN-1:0];
reg  [1:0]            AWBURST_Q[AWQ_LEN-1:0];
reg  [1:0]            AWLOCK_Q[AWQ_LEN-1:0];
reg  [3:0]            AWCACHE_Q[AWQ_LEN-1:0];
reg  [2:0]            AWPROT_Q[AWQ_LEN-1:0];
wire AWQ_empty;
assign AWQ_empty = (AWQ_RINDEX == AWQ_WINDEX) ? 1'b1 : 1'b0;
function AWQ_full;	// USE function instead of wire
	input dummy;
	AWQ_full = (AWQ_RINDEX == (AWQ_WINDEX+1'b1)) ? 1'b1 : 1'b0;
endfunction

// WID_Q => AW fill Q, WD empty Q
reg  [AWQ_WIDTH-1:0] WIDQ_WINDEX;
reg  [AWQ_WIDTH-1:0] WIDQ_RINDEX;
reg  [WID_WIDTH-1:0] WID_Q[AWQ_LEN-1:0];
wire WIDQ_full;
wire WIDQ_empty;
assign WIDQ_full = (WIDQ_RINDEX == (WIDQ_WINDEX+1'b1)) ? 1'b1 : 1'b0;
assign WIDQ_empty = (WIDQ_RINDEX == WIDQ_WINDEX) ? 1'b1 : 1'b0;

// WD Channel Que
reg  [WDQ_WIDTH-1:0]  WDQ_RINDEX;
reg  [WDQ_WIDTH-1:0]  WDQ_WINDEX;
reg  [DATA_WIDTH-1:0] WDATA_Q[WDQ_LEN-1:0];
reg  [NUM_BYTE-1:0]   WSTRB_Q[WDQ_LEN-1:0];
reg                   WLAST_Q[WDQ_LEN-1:0];
wire WDQ_empty;
assign WDQ_empty = (WDQ_RINDEX == WDQ_WINDEX) ? 1'b1 : 1'b0;
function WDQ_full;	// USE function instead of wire
	input dummy;
	WDQ_full = (WDQ_RINDEX == (WDQ_WINDEX+1'b1)) ? 1'b1 : 1'b0;
endfunction
function WDQ_HaveSpace;	// check WDQ have sufficient space for data
	input [3:0] reserved_len;
	reg   [WDQ_WIDTH-1:0] temp;
	reg   [WDQ_WIDTH-1:0] space;
	begin
		temp = reserved_len;
		space = (WDQ_RINDEX-WDQ_WINDEX)-1'b1;
		WDQ_HaveSpace = temp < space;
	end
endfunction

// AR Channel Que & Data
reg  [ARQ_WIDTH-1:0]  ARQ_WINDEX;	// Write Que Index
reg  [ARQ_WIDTH-1:0]  ARQ_RINDEX;	// Read Que Index
reg  [RID_WIDTH-1:0]  ARID_Q[ARQ_LEN-1:0];
reg  [31:0]           ARADDR_Q[ARQ_LEN-1:0];
reg  [3:0]            ARLEN_Q[ARQ_LEN-1:0];
reg  [2:0]            ARSIZE_Q[ARQ_LEN-1:0];
reg  [1:0]            ARBURST_Q[ARQ_LEN-1:0];
reg  [1:0]            ARLOCK_Q[ARQ_LEN-1:0];
reg  [3:0]            ARCACHE_Q[ARQ_LEN-1:0];
reg  [2:0]            ARPROT_Q[ARQ_LEN-1:0];
wire ARQ_empty;
assign ARQ_empty = (ARQ_RINDEX == ARQ_WINDEX) ? 1'b1 : 1'b0;

function ARQ_full;	// USE function instead of wire
	input dummy;
	ARQ_full = (ARQ_RINDEX == (ARQ_WINDEX+1'b1)) ? 1'b1 : 1'b0;
endfunction

// RD Channel Que
reg  [RDQ_WIDTH-1:0] RDQ_RINDEX[RID_LEN-1:0];
reg  [RDQ_WIDTH-1:0] RDQ_WINDEX[RID_LEN-1:0];
reg  [DATA_WIDTH-1:0] RDATA_Q[RID_LEN-1:0][RDQ_LEN-1:0];
reg  [DATA_WIDTH-1:0] RDM_Q[RID_LEN-1:0][RDQ_LEN-1:0];	// Read Mask for comparison

function RDQ_Empty;
	input [RID_WIDTH-1:0] rid;
	begin
		RDQ_Empty = (RDQ_RINDEX[rid] == RDQ_WINDEX[rid]) ? 1'b1 : 1'b0;
	end
endfunction

function RDQ_Full;
	input [RID_WIDTH-1:0] rid;
	begin
		RDQ_Full = (RDQ_RINDEX[rid] == (RDQ_WINDEX[rid]+1'b1)) ? 1'b1 : 1'b0;
	end
endfunction
function RDQ_HaveSpace;	// check RDQ have sufficient space for data
	input [RID_WIDTH-1:0] rid;
	input [3:0] reserved_len;
	reg   [RDQ_WIDTH-1:0] temp;
	reg   [RDQ_WIDTH-1:0] space;
	begin
		temp = reserved_len;
		space = (RDQ_RINDEX[rid]-RDQ_WINDEX[rid])-1'b1;
		RDQ_HaveSpace = temp < space;
	end
endfunction

// Write Transaction Counter for each WID
reg  [CNT_WIDTH-1:0]  WTRANS_CNT[WID_LEN-1:0];	// Transaction Counter
reg  [WID_WIDTH-1:0]  DecreaseWID;
reg                   DecreaseWIDEnable;
reg  [WID_WIDTH-1:0]  IncreaseWID;
reg                   IncreaseWIDEnable;

reg  [CNT_WIDTH-1:0]  RTRANS_CNT[RID_LEN-1:0];	// Transaction Counter
reg  [RID_WIDTH-1:0]  DecreaseRID;
reg                   DecreaseRIDEnable;
reg  [RID_WIDTH-1:0]  IncreaseRID;
reg                   IncreaseRIDEnable;

//
// AW Channel Processing
//
reg AW_idle;
reg AW_RANDOM;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		AW_idle <= 1'b1;
		WIDQ_WINDEX <= 0;
		AWID_r <= 0;
		AWADDR_r <= 0;
		AWLEN_r <= 0;
		AWSIZE_r <= 0;
		AWBURST_r <= 0;
		AWLOCK_r <= 0;
		AWCACHE_r <= 0;
		AWPROT_r <= 0;
		AWVALID <= 1'b0;
		AWQ_RINDEX <= 0;
		AW_RANDOM <= 1;
		IncreaseWIDEnable <= 1'b0;
		IncreaseWID <= 0;
	end
	else
	begin
		if(RANDOMIZE == 1)
			AW_RANDOM <= $random/16;
		if(AW_idle == 1'b1 && AWQ_empty != 1'b1 && WIDQ_full != 1'b1 && (AW_RANDOM == 1'b1 || RANDOMIZE == 0))
		begin
			// Push WID to WIDQUE for WData Channel
			WID_Q[WIDQ_WINDEX] <= AWID_Q[AWQ_RINDEX];
			WIDQ_WINDEX <= WIDQ_WINDEX + 1'b1;	// Increment Write Que Index

			AWID_r <= AWID_Q[AWQ_RINDEX];
			AWADDR_r <= AWADDR_Q[AWQ_RINDEX];
			AWLEN_r <= AWLEN_Q[AWQ_RINDEX];
			AWSIZE_r <= AWSIZE_Q[AWQ_RINDEX];
			AWBURST_r <= AWBURST_Q[AWQ_RINDEX];
			AWLOCK_r <= AWLOCK_Q[AWQ_RINDEX];
			AWCACHE_r <= AWCACHE_Q[AWQ_RINDEX];
			AWPROT_r <= AWPROT_Q[AWQ_RINDEX];
			AWVALID <= 1'b1;
			AWQ_RINDEX = AWQ_RINDEX + 1'b1;	// Increment Read Que Index

			AW_idle <= 1'b0;
			IncreaseWIDEnable <= 1'b0;
		end
		else
		begin
			if(AWREADY == 1'b1 && AWVALID == 1'b1)
			begin
				// We should increase transaction counter
				IncreaseWIDEnable <= 1'b1;
				IncreaseWID <= AWID;

				if(AWQ_empty != 1'b1 && WIDQ_full != 1'b1 && (AW_RANDOM == 1'b1 || RANDOMIZE == 0))
				begin
					// Push WID to WIDQUE for WData Channel
					WID_Q[WIDQ_WINDEX] <= AWID_Q[AWQ_RINDEX];
					WIDQ_WINDEX <= WIDQ_WINDEX + 1'b1;	// Increment Write Que Index

					AWID_r <= AWID_Q[AWQ_RINDEX];
					AWADDR_r <= AWADDR_Q[AWQ_RINDEX];
					AWLEN_r <= AWLEN_Q[AWQ_RINDEX];
					AWSIZE_r <= AWSIZE_Q[AWQ_RINDEX];
					AWBURST_r <= AWBURST_Q[AWQ_RINDEX];
					AWLOCK_r <= AWLOCK_Q[AWQ_RINDEX];
					AWCACHE_r <= AWCACHE_Q[AWQ_RINDEX];
					AWPROT_r <= AWPROT_Q[AWQ_RINDEX];
					AWVALID <= 1'b1;
					AWQ_RINDEX = AWQ_RINDEX + 1'b1;	// Increment Read Que Index
				end
				else
				begin
					AWVALID <= 1'b0;	// invalidate output
					AW_idle <= 1'b1;
				end
			end
			else
				IncreaseWIDEnable <= 1'b0;
		end
	end
end

//
// WD Channel Processing
//
reg WD_idle;
reg WD_RANDOM;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		WD_idle <= 1'b1;
		WIDQ_RINDEX <= 0;
		WVALID <= 1'b0;
		WDQ_RINDEX <= 0;
		WD_RANDOM <= $random/16;
	end
	else
	begin
		if(RANDOMIZE)
			WD_RANDOM <= $random/16;
		if(WD_idle == 1'b1)
		begin
			if(WIDQ_empty != 1'b1 && (RANDOMIZE == 0 || WD_RANDOM == 1'b1))
			begin
				if(WDQ_empty == 1'b1)
				begin
					$display("BUG: WDATA is not sufficient");
					$stop;
				end
				WID_r <= WID_Q[WIDQ_RINDEX];
				WDATA_r <= WDATA_Q[WDQ_RINDEX];
				WSTRB_r <= WSTRB_Q[WDQ_RINDEX];
				WLAST_r <= WLAST_Q[WDQ_RINDEX];
				WVALID <= 1'b1;

				WIDQ_RINDEX <= WIDQ_RINDEX + 1'b1;	// Increment Que Index
				WDQ_RINDEX <= WDQ_RINDEX + 1'b1;		// Increment Que Index

				WD_idle <= 1'b0;
			end
		end
		else
		begin
			if(WVALID == 1'b1 && WREADY == 1'b1)
			begin
				if(WLAST_r == 1'b1)	// last data => proceed next transaction
				begin
					if(WIDQ_empty != 1'b1 && (RANDOMIZE == 0 || WD_RANDOM == 1'b1))
					begin
						if(WDQ_empty == 1'b1)
						begin
							$display("BUG: WDATA is not sufficient");
							$stop;
						end
						WID_r <= WID_Q[WIDQ_RINDEX];
						WDATA_r <= WDATA_Q[WDQ_RINDEX];
						WSTRB_r <= WSTRB_Q[WDQ_RINDEX];
						WLAST_r <= WLAST_Q[WDQ_RINDEX];
						WVALID <= 1'b1;

						WIDQ_RINDEX <= WIDQ_RINDEX + 1'b1;	// Increment Que Index
						WDQ_RINDEX <= WDQ_RINDEX + 1'b1;	// Increment Que Index
					end
					else	// No next transaction present
					begin
						WD_idle <= 1'b1;
						WVALID <= 1'b0;
					end
				end
				else	// WLAST != 1'b1 && WREADY == 1'b1 => proceed next data transfer
				begin
					if(RANDOMIZE == 0 || WD_RANDOM == 1'b1)
					begin
						if(WDQ_empty == 1'b1)
						begin
							$display("BUG: WDATA is not sufficient");
							$stop;
						end
						WDATA_r <= WDATA_Q[WDQ_RINDEX];
						WSTRB_r <= WSTRB_Q[WDQ_RINDEX];
						WLAST_r <= WLAST_Q[WDQ_RINDEX];
						WVALID <= 1'b1;
						WDQ_RINDEX <= WDQ_RINDEX + 1'b1;		// Increment Que Index
					end
					else
						WVALID <= 1'b0;
				end
			end
			else if(WVALID == 1'b0 && WD_idle == 1'b0)	// result of randomization: delayed WDATA
			begin
				if(RANDOMIZE == 0 || WD_RANDOM == 1'b1)
				begin
					if(WDQ_empty == 1'b1)
					begin
						$display("BUG: WDATA is not sufficient");
						$stop;
					end
					WDATA_r <= WDATA_Q[WDQ_RINDEX];
					WSTRB_r <= WSTRB_Q[WDQ_RINDEX];
					WLAST_r <= WLAST_Q[WDQ_RINDEX];
					WVALID <= 1'b1;
					WDQ_RINDEX <= WDQ_RINDEX + 1'b1;		// Increment Que Index
				end
			end
		end
	end
end

//
// Write Response Channel
//
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		BREADY <= 1'b1;
		DecreaseWIDEnable <= 1'b0;
		DecreaseWID <= 0;
	end
	else
	begin
		if(RANDOMIZE)
			BREADY <= $random/16;
		if(BVALID == 1'b1 && BREADY == 1'b1)
		begin
			if(BRESP != `RESP_OKAY)
			begin
				$display("Write Response is not OKAY(ID:%h)", BID);
				$stop;
			end

			// decrease transaction counter
			DecreaseWID <= BID;
			DecreaseWIDEnable <= 1'b1;
		end
		else
			DecreaseWIDEnable <= 1'b0;
	end
end

//
// AR Channel
//
reg AR_idle;
reg AR_RANDOM;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		AR_idle <= 1'b1;
		ARID_r <= 0;
		ARADDR_r <= 0;
		ARLEN_r <= 0;
		ARSIZE_r <= 0;
		ARBURST_r <= 0;
		ARLOCK_r <= 0;
		ARCACHE_r <= 0;
		ARPROT_r <= 0;
		ARVALID <= 1'b0;
		ARQ_RINDEX <= 0;
		AR_RANDOM <= 1;

		IncreaseRIDEnable <= 1'b0;
		IncreaseRID <= 0;
	end
	else
	begin
		if(RANDOMIZE)
			AR_RANDOM <= $random/16;

		if(AR_idle == 1'b1 && ARQ_empty != 1'b1 && (RANDOMIZE == 0 || AR_RANDOM == 1'b1))
		begin
			ARID_r <= ARID_Q[ARQ_RINDEX];
			ARADDR_r <= ARADDR_Q[ARQ_RINDEX];
			ARLEN_r <= ARLEN_Q[ARQ_RINDEX];
			ARSIZE_r <= ARSIZE_Q[ARQ_RINDEX];
			ARBURST_r <= ARBURST_Q[ARQ_RINDEX];
			ARLOCK_r <= ARLOCK_Q[ARQ_RINDEX];
			ARCACHE_r <= ARCACHE_Q[ARQ_RINDEX];
			ARPROT_r <= ARPROT_Q[ARQ_RINDEX];
			ARVALID <= 1'b1;
			ARQ_RINDEX = ARQ_RINDEX + 1'b1;	// Increment Read Que Index

			AR_idle <= 1'b0;
			IncreaseRIDEnable <= 1'b0;
		end
		else
		begin
			if(ARVALID == 1'b1 && ARREADY == 1'b1)
			begin
				// We should increase transaction counter
				IncreaseRIDEnable <= 1'b1;
				IncreaseRID <= ARID;

				if(ARQ_empty != 1'b1 && (RANDOMIZE == 0 || AR_RANDOM == 1'b1))
				begin
					ARID_r <= ARID_Q[ARQ_RINDEX];
					ARADDR_r <= ARADDR_Q[ARQ_RINDEX];
					ARLEN_r <= ARLEN_Q[ARQ_RINDEX];
					ARSIZE_r <= ARSIZE_Q[ARQ_RINDEX];
					ARBURST_r <= ARBURST_Q[ARQ_RINDEX];
					ARLOCK_r <= ARLOCK_Q[ARQ_RINDEX];
					ARCACHE_r <= ARCACHE_Q[ARQ_RINDEX];
					ARPROT_r <= ARPROT_Q[ARQ_RINDEX];
					ARVALID <= 1'b1;
					ARQ_RINDEX = ARQ_RINDEX + 1'b1;	// Increment Read Que Index
				end
				else
				begin
					ARVALID <= 1'b0;	// invalidate output
					AR_idle <= 1'b1;
				end
			end
			else
				IncreaseRIDEnable <= 1'b0;
		end
	end
end

//
// RD Channel
//
reg [DATA_WIDTH-1:0] LAST_READ_DATA;
always @(posedge ACLK or negedge ARESETn)
	if(!ARESETn)
		LAST_READ_DATA <= 0;
	else if(RVALID == 1'b1 && RREADY == 1'b1)
		LAST_READ_DATA <= RDATA;

integer i_rd;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		RREADY <= 1'b1;		// always 1
		for(i_rd = 0; i_rd < RDQ_LEN; i_rd = i_rd+1)
			RDQ_RINDEX[i_rd] <= 0;

		DecreaseRIDEnable <= 1'b0;
		DecreaseRID <= 0;
	end
	else
	begin
		if(RANDOMIZE)
			RREADY <= $random/16;
		if(RVALID == 1'b1 && RREADY == 1'b1)
		begin
			if(RRESP != `RESP_OKAY)
			begin
				$display("Read Response is not OKAY(ID:%h)", RID);
				$stop;
			end

			if(RDQ_Empty(RID) == 1'b1)
			begin
				$display("BUG: Read Data is not sufficient : %h %h %h", RID, RDQ_RINDEX[RID], RDQ_WINDEX[RID]);
				$stop;
			end
			// Check Read Data
			if((RDATA&RDM_Q[RID][RDQ_RINDEX[RID]]) !== (RDATA_Q[RID][RDQ_RINDEX[RID]]&RDM_Q[RID][RDQ_RINDEX[RID]]))
			begin
				$display("Read Data(%h) is not correspondent with expected value(%h with mask %h)(ID:%h)", RDATA, RDATA_Q[RID][RDQ_RINDEX[RID]], RDM_Q[RID][RDQ_RINDEX[RID]], RID);
				$stop;
			end
			RDQ_RINDEX[RID] <= RDQ_RINDEX[RID] + 1'b1;	// Increase Que Index

			if(RLAST == 1'b1)
			begin
				// decrease transaction counter here
				DecreaseRIDEnable <= 1'b1;
				DecreaseRID <= RID;
			end
			else
				DecreaseRIDEnable <= 1'b0;
		end
		else
			DecreaseRIDEnable <= 1'b0;
	end
end

//
// Transaction Counter Management
//

// Write Transaction Counter for each WID
integer i_wid_temp;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		for(i_wid_temp = 0; i_wid_temp < WID_LEN; i_wid_temp = i_wid_temp+1)
			WTRANS_CNT[i_wid_temp] <= 0;
	end
	else
	begin
		case({IncreaseWIDEnable, DecreaseWIDEnable})
		2'b10: WTRANS_CNT[IncreaseWID] <= WTRANS_CNT[IncreaseWID] + 1'b1;
		2'b01:
		begin
			if(WTRANS_CNT[DecreaseWID] == 0)
			begin
				$display("Received More Write Response than Requested.(WID:%h)", DecreaseWID);
				$stop;
			end
			else
				WTRANS_CNT[DecreaseWID] <= WTRANS_CNT[DecreaseWID] - 1'b1;
		end
		2'b11:
		begin
			if(DecreaseWID != IncreaseWID)
			begin
				WTRANS_CNT[IncreaseWID] <= WTRANS_CNT[IncreaseWID] + 1'b1;
				if(WTRANS_CNT[DecreaseWID] == 0)
				begin
					$display("Received More Write Response than Requested.(WID:%h)", DecreaseWID);
					$stop;
				end
				else
					WTRANS_CNT[DecreaseWID] <= WTRANS_CNT[DecreaseWID] - 1'b1;
			end
		end
		endcase
	end
end

function IsWIDIdle;
	input [WID_WIDTH-1:0] wid_to_check;
	reg   [AWQ_WIDTH-1:0]  TEMP_I;
	begin
		IsWIDIdle = 1'b1;
		if(WTRANS_CNT[wid_to_check] != 0)	// check transaction counter
			IsWIDIdle = 1'b0;

		// Check Request Que
		for(TEMP_I = AWQ_RINDEX; TEMP_I != AWQ_WINDEX; TEMP_I = TEMP_I + 1)
		begin
			if(AWID_Q[TEMP_I] == wid_to_check)
				IsWIDIdle = 1'b0;
		end
		
		// Check Current Request
		if(AWVALID == 1'b1 && AWID == wid_to_check)
			IsWIDIdle = 1'b0;

		if(IncreaseWIDEnable == 1'b1 && IncreaseWID == wid_to_check)
			IsWIDIdle = 1'b0;
	end
endfunction

function IsWriteIdle;
	input dummy;
	integer temp_i;
	begin
		IsWriteIdle = 1'b1;

		for(temp_i = 0; temp_i < WID_LEN; temp_i = temp_i + 1)
			if(WTRANS_CNT[temp_i] != 0)
				IsWriteIdle = 1'b0;

		if(AWQ_RINDEX != AWQ_WINDEX)
			IsWriteIdle = 1'b0;

		if(AWVALID == 1'b1)
			IsWriteIdle = 1'b0;

		if(IncreaseWIDEnable == 1'b1)
			IsWriteIdle = 1'b0;
	end
endfunction

// Read Transaction Counter for each RID
integer i_rid_temp;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		for(i_rid_temp = 0; i_rid_temp < RID_LEN; i_rid_temp = i_rid_temp+1)
			RTRANS_CNT[i_rid_temp] <= 0;
	end
	else
	begin
		case({IncreaseRIDEnable, DecreaseRIDEnable})
		2'b10: RTRANS_CNT[IncreaseRID] <= RTRANS_CNT[IncreaseRID] + 1'b1;
		2'b01:
		begin
			if(RTRANS_CNT[DecreaseRID] == 0)
			begin
				$display("Received More Last Read Response than Requested.(RID:%h)", DecreaseRID);
				$stop;
			end
			else
				RTRANS_CNT[DecreaseRID] <= RTRANS_CNT[DecreaseRID] - 1'b1;
		end
		2'b11:
		begin
			if(DecreaseRID != IncreaseRID)
			begin
				RTRANS_CNT[IncreaseRID] <= RTRANS_CNT[IncreaseRID] + 1'b1;
				if(RTRANS_CNT[DecreaseRID] == 0)
				begin
					$display("Received More Last Read Response than Requested.(RID:%h)", DecreaseRID);
					$stop;
				end
				else
					RTRANS_CNT[DecreaseRID] <= RTRANS_CNT[DecreaseRID] - 1'b1;
			end
		end
		endcase
	end
end

function IsRIDIdle;
	input [RID_WIDTH-1:0] rid_to_check;
	reg   [ARQ_WIDTH-1:0]  TEMP_I;
	begin
		IsRIDIdle = 1'b1;
		if(RTRANS_CNT[rid_to_check] != 0)	// check transaction counter
			IsRIDIdle = 1'b0;

		// Check Request Que
		for(TEMP_I = ARQ_RINDEX; TEMP_I != ARQ_WINDEX; TEMP_I = TEMP_I + 1)
		begin
			if(ARID_Q[TEMP_I] == rid_to_check)
				IsRIDIdle = 1'b0;
		end
		
		// Check Current Request
		if(ARVALID == 1'b1 && ARID == rid_to_check)
			IsRIDIdle = 1'b0;

		if(IncreaseRIDEnable == 1'b1 && IncreaseRID == rid_to_check)
			IsRIDIdle = 1'b0;
	end
endfunction

function IsReadIdle;
	input dummy;
	integer temp_i;
	begin
		IsReadIdle = 1'b1;

		for(temp_i = 0; temp_i < RID_LEN; temp_i = temp_i + 1)
			if(RTRANS_CNT[temp_i] != 0)
				IsReadIdle = 1'b0;

		if(ARQ_RINDEX != ARQ_WINDEX)
			IsReadIdle = 1'b0;

		if(ARVALID == 1'b1)
			IsReadIdle = 1'b0;

		if(IncreaseRIDEnable == 1'b1)
			IsReadIdle = 1'b0;
	end
endfunction

//
// Idle counter
//
reg ResetIdleCnt;
reg [CNT_WIDTH-1:0] IdleCnt;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		IdleCnt <= MAXIMUM_IDLE_CNT;
	else
	begin
		if(((ARVALID&ARREADY) == 0 &&
			(AWVALID&AWREADY) == 0 &&
			(WVALID&WREADY) == 0 &&
			(RVALID&RREADY) == 0 &&
			(BVALID&BREADY) == 0) && ~ResetIdleCnt)
		begin
			if(IdleCnt != 0)
				IdleCnt <= IdleCnt - 1;
			else
			begin
				$display("Master hasn't process any transaction for too long cycles");
				$stop;
			end
		end
		else
			IdleCnt <= MAXIMUM_IDLE_CNT;
	end
end

// ARSIZE/AWSIZE
`define SIZE_BYTE	3'b000
`define SIZE_HWORD	3'b001
`define SIZE_WORD	3'b010
`define SIZE_DWORD	3'b011

// AWBURST/ARBURST
`define BURST_FIXED	2'b00
`define BURST_INCR	2'b01
`define BURST_WRAP	2'b10

// ARLOCK/AWLOCK signal
`define NORMAL_ACCESS		2'b00
`define EXCLUSIVE_ACCESS	2'b01
`define LOCKED_ACCESS		2'b10

// CACHE signal
`define NO_CACHE			4'b0000

// PROT signal
`define NO_PROTECTION		3'b000

// Task for simulation start
task start_sim;
	integer i;
	begin
		// initialization que write index
		ResetIdleCnt = 0;
		AWQ_WINDEX = 0;
		WDQ_WINDEX = 0;
		ARQ_WINDEX = 0;
		for(i = 0; i < RDQ_LEN; i = i+1)
			RDQ_WINDEX[i] = 0;
		repeat(1) @(posedge ACLK);

		while(ARESETn != 1) @(posedge ACLK);	// wait until ARESETn get high

		@(posedge ACLK);
	end
endtask

// Task for address write channel
task awrite;
	input [WID_WIDTH-1:0] awid;
	input [31:0] awaddr;
	input [3:0]  awlen;
	input [2:0]  awsize;
	input [1:0]  awburst;
		begin
			while(AWQ_full(0) == 1'b1) @(posedge ACLK);
			while(WDQ_HaveSpace(awlen) == 1'b0) @(posedge ACLK);
			AWID_Q[AWQ_WINDEX] = awid;
			AWADDR_Q[AWQ_WINDEX] = awaddr;
			AWLEN_Q[AWQ_WINDEX] = awlen;
			AWSIZE_Q[AWQ_WINDEX] = awsize;
			AWBURST_Q[AWQ_WINDEX] = awburst;
			AWLOCK_Q[AWQ_WINDEX] = `NORMAL_ACCESS;
			AWCACHE_Q[AWQ_WINDEX] = `NO_CACHE;
			AWPROT_Q[AWQ_WINDEX] = `NO_PROTECTION;

			AWQ_WINDEX = AWQ_WINDEX + 1'b1;
		end
endtask

task awrite_full;
	input [WID_WIDTH-1:0] awid;
	input [31:0] awaddr;
	input [3:0]  awlen;
	input [2:0]  awsize;
	input [1:0]  awburst;
	input [1:0]  awlock;
	input [3:0]  awcache;
	input [2:0]  awprot;
		begin
			while(AWQ_full(0) == 1'b1) @(posedge ACLK);
			while(WDQ_HaveSpace(awlen) == 1'b0) @(posedge ACLK);
			AWID_Q[AWQ_WINDEX] = awid;
			AWADDR_Q[AWQ_WINDEX] = awaddr;
			AWLEN_Q[AWQ_WINDEX] = awlen;
			AWSIZE_Q[AWQ_WINDEX] = awsize;
			AWBURST_Q[AWQ_WINDEX] = awburst;
			AWLOCK_Q[AWQ_WINDEX] = awlock;
			AWCACHE_Q[AWQ_WINDEX] = awcache;
			AWPROT_Q[AWQ_WINDEX] = awprot;

			AWQ_WINDEX = AWQ_WINDEX + 1'b1;
		end
endtask

// Task for write data channel
task wdata;
	input [DATA_WIDTH-1:0] wdata;
	input [NUM_BYTE-1:0]   wstrb;
	input                  wlast;
		begin
			while(WDQ_full(0) == 1'b1) @(posedge ACLK);
			WDATA_Q[WDQ_WINDEX] = wdata;
			WSTRB_Q[WDQ_WINDEX] = wstrb;
			WLAST_Q[WDQ_WINDEX] = wlast;

			WDQ_WINDEX = WDQ_WINDEX + 1'b1;
		end
endtask

// Task for address read channel
task aread;
	input [RID_WIDTH-1:0] arid;
	input [31:0] araddr;
	input [3:0]  arlen;
	input [2:0]  arsize;
	input [1:0]  arburst;
		begin
			while(ARQ_full(0) == 1'b1) @(posedge ACLK);
			while(RDQ_HaveSpace(arid, arlen) == 1'b0) @(posedge ACLK);
			ARID_Q[ARQ_WINDEX] = arid;
			ARADDR_Q[ARQ_WINDEX] = araddr;
			ARLEN_Q[ARQ_WINDEX] = arlen;
			ARSIZE_Q[ARQ_WINDEX] = arsize;
			ARBURST_Q[ARQ_WINDEX] = arburst;
			ARLOCK_Q[ARQ_WINDEX] = `NORMAL_ACCESS;
			ARCACHE_Q[ARQ_WINDEX] = `NO_CACHE;
			ARPROT_Q[ARQ_WINDEX] = `NO_PROTECTION;

			ARQ_WINDEX = ARQ_WINDEX + 1'b1;
		end
endtask

task aread_full;
	input [RID_WIDTH-1:0] arid;
	input [31:0] araddr;
	input [3:0]  arlen;
	input [2:0]  arsize;
	input [1:0]  arburst;
	input [1:0]  arlock;
	input [3:0]  arcache;
	input [2:0]  arprot;
		begin
			while(ARQ_full(0) == 1'b1) @(posedge ACLK);
			while(RDQ_HaveSpace(arid, arlen) == 1'b0) @(posedge ACLK);
			ARID_Q[ARQ_WINDEX] = arid;
			ARADDR_Q[ARQ_WINDEX] = araddr;
			ARLEN_Q[ARQ_WINDEX] = arlen;
			ARSIZE_Q[ARQ_WINDEX] = arsize;
			ARBURST_Q[ARQ_WINDEX] = arburst;
			ARLOCK_Q[ARQ_WINDEX] = arlock;
			ARCACHE_Q[ARQ_WINDEX] = arcache;
			ARPROT_Q[ARQ_WINDEX] = arprot;

			ARQ_WINDEX = ARQ_WINDEX + 1'b1;
		end
endtask

// Task for read data channel
task rdata;
	input [RID_WIDTH-1:0]  rid;
	input [DATA_WIDTH-1:0] rdata;
	input [DATA_WIDTH-1:0] rdata_mask;
		begin
			while(RDQ_Full(rid) == 1'b1) @(posedge ACLK);
			RDATA_Q[rid][RDQ_WINDEX[rid]] = rdata;
			RDM_Q[rid][RDQ_WINDEX[rid]] = rdata_mask;

			RDQ_WINDEX[rid] = RDQ_WINDEX[rid] + 1'b1;
		end
endtask

task wait_until_write_finished;
	while(IsWriteIdle(0) != 1'b1)	@(posedge ACLK);
endtask

task wait_until_wid_finished;
	input [WID_WIDTH-1:0] wid_to_check;
	begin
	#UNITDELAY;
	while(IsWIDIdle(wid_to_check) != 1'b1)
	begin
		@(posedge ACLK);
		#UNITDELAY;
	end
	end
endtask

task wait_until_read_finished;
	while(IsReadIdle(0) != 1'b1)	@(posedge ACLK);
endtask

task wait_until_rid_finished;
	input [RID_WIDTH-1:0] rid_to_check;
	begin
	#UNITDELAY;
	while(IsRIDIdle(rid_to_check) != 1'b1)
	begin
		@(posedge ACLK);
		#UNITDELAY;
	end
	end
endtask

task wait_until_idle;
	while(IsWriteIdle(0) != 1'b1 || IsReadIdle(0) != 1'b1)
		@(posedge ACLK);
endtask

task wait_cycle;
	input [31:0] cycle_to_wait;
	begin
		ResetIdleCnt = 1;
		while(cycle_to_wait != 0)
			@(posedge ACLK)	cycle_to_wait = cycle_to_wait - 1;
		ResetIdleCnt = 0;
	end
endtask

task wait_infinitely;
begin
	ResetIdleCnt = 1;
	while(1) @(posedge ACLK);
end
endtask

task finish_sim;
	begin
		wait_until_idle;	// wait until queing request finished
		$display("End of Simulation without Error");
		$finish;
	end
endtask
		
parameter SRAM_ADDR=32'h00000000;
parameter DMA2D_ADDR = 32'h20001000;

parameter DMA2D_SRCADDR = DMA2D_ADDR+12'h000;
parameter DMA2D_DSTADDR = DMA2D_ADDR+12'h004;
parameter DMA2D_BYTECNT = DMA2D_ADDR+12'h008;
parameter DMA2D_LINECNT = DMA2D_ADDR+12'h00C;
parameter DMA2D_ADDRUPD = DMA2D_ADDR+12'h010;
parameter DMA2D_STATUS  = DMA2D_ADDR+12'h014;

parameter SRC_ADDR = 32'h00000000;	// 0
parameter DST_ADDR = 32'h00001FF0;	// 8 KB

task read_word;
	input [31:0] addr;
	output [31:0] read_data;
	begin
		aread(0, addr, 0, `SIZE_WORD, `BURST_INCR);
		rdata(0, 32'd0, 32'd0);
		wait_until_rid_finished(0);
		read_data = LAST_READ_DATA;
	end
endtask

task write_word;
	input [31:0] addr;
	input [31:0] data;
	begin
		awrite(0, addr, 0, `SIZE_WORD, `BURST_INCR);
		wdata(data, 4'b1111, 1);
		wait_until_wid_finished(0);
	end
endtask
		
//
// Real Transaction Part
//
integer src_addr_index;	/* 0 ~ 3 */
integer dst_addr_index;		/* 0 ~ 3 */
integer bytecnt_index;		/* 1 ~ 4 */
integer linecnt_index;		/* 0 ~ 3 */
integer src_addr_upd_index;		/* 0 ~ 3 */
integer dst_addr_upd_index;		/* 0 ~ 3 */

reg [31:0] SrcAddr;
reg [31:0] DstAddr;
reg [15:0] ByteCnt;
reg [15:0] LineCnt;
reg [15:0] SrcAddrUpd;
reg [15:0] DstAddrUpd;
reg [15:0] CntArray[7:0];

reg [31:0] WADDR_START;
reg [31:0] WADDR_END;

initial
begin
	start_sim;

	DMATestDataLoad(SRC_ADDR, 64*64);	// 64*64 byte load
	wait_until_write_finished;

	CntArray[0] = 1;
	CntArray[1] = 2;
	CntArray[2] = 3;
	CntArray[3] = 4;
	CntArray[4] = 32;
	CntArray[5] = 33;
	CntArray[6] = 34;
	CntArray[7] = 35;

	// minus SrcAddrUpd, plus DstAddrUpd case
		SrcAddr = SRC_ADDR + 64*63;
		DstAddr = DST_ADDR;
		ByteCnt = 33;
		LineCnt = 63;
		SrcAddrUpd = -(64+33);
		DstAddrUpd = 3;
		$display("Special Test : byte_count(%2d) line_cnt(%2d) SrcUpd(%1d) DstUpd(%1d)", ByteCnt, LineCnt, SrcAddrUpd, DstAddrUpd);

		WADDR_START = DstAddr;
		WADDR_END = DstAddr + (ByteCnt+DstAddrUpd)*(LineCnt+1);
		// Register Writing
		write_word(DMA2D_SRCADDR, SrcAddr);
		write_word(DMA2D_DSTADDR, DstAddr);
		write_word(DMA2D_BYTECNT, {16'h0000, ByteCnt});
		write_word(DMA2D_LINECNT, {LineCnt, ByteCnt});
		write_word(DMA2D_ADDRUPD, {SrcAddrUpd, DstAddrUpd});
		write_word(DMA2D_STATUS, 32'h80000003);			// Start DMA

		ResetIdleCnt = 1;
		while(tb.Dma2D.Enabled != 0) @(posedge ACLK);
		ResetIdleCnt = 0;

		DMATestDataTest(64*63, DstAddr, ByteCnt, LineCnt, SrcAddrUpd, DstAddrUpd);
		wait_until_rid_finished(0);

		DMATestDataClear(DST_ADDR, 64*64);
		wait_until_write_finished;
	
	// plus SrcAddrUpd, minus DstAddrUpd case
		SrcAddr = SRC_ADDR;
		DstAddr = DST_ADDR+64*63;
		ByteCnt = 33;
		LineCnt = 63;
		SrcAddrUpd = 3;
		DstAddrUpd = -(64+33);
		$display("Special Test : byte_count(%2d) line_cnt(%2d) SrcUpd(%1d) DstUpd(%1d)", ByteCnt, LineCnt, SrcAddrUpd, DstAddrUpd);

		WADDR_START = DST_ADDR;
		WADDR_END = DST_ADDR+64*64;
		// Register Writing
		write_word(DMA2D_SRCADDR, SrcAddr);
		write_word(DMA2D_DSTADDR, DstAddr);
		write_word(DMA2D_BYTECNT, {16'h0000, ByteCnt});
		write_word(DMA2D_LINECNT, {LineCnt, ByteCnt});
		write_word(DMA2D_ADDRUPD, {SrcAddrUpd, DstAddrUpd});
		write_word(DMA2D_STATUS, 32'h80000003);			// Start DMA

		ResetIdleCnt = 1;
		while(tb.Dma2D.Enabled != 0) @(posedge ACLK);
		ResetIdleCnt = 0;

		DMATestDataTestReverse(0, DstAddr, ByteCnt, LineCnt, SrcAddrUpd, DstAddrUpd);
		wait_until_rid_finished(0);

		DMATestDataClear(DST_ADDR, 64*64);
		wait_until_write_finished;
	
	// minus SrcAddrUpd, minus DstAddrUpd case
		SrcAddr = SRC_ADDR+64*63;
		DstAddr = DST_ADDR+64*63;
		ByteCnt = 33;
		LineCnt = 63;
		SrcAddrUpd = -(64+33);
		DstAddrUpd = -(64+33);
		$display("Special Test : byte_count(%2d) line_cnt(%2d) SrcUpd(%1d) DstUpd(%1d)", ByteCnt, LineCnt, SrcAddrUpd, DstAddrUpd);

		WADDR_START = DST_ADDR;
		WADDR_END = DST_ADDR+64*64;
		// Register Writing
		write_word(DMA2D_SRCADDR, SrcAddr);
		write_word(DMA2D_DSTADDR, DstAddr);
		write_word(DMA2D_BYTECNT, {16'h0000, ByteCnt});
		write_word(DMA2D_LINECNT, {LineCnt, ByteCnt});
		write_word(DMA2D_ADDRUPD, {SrcAddrUpd, DstAddrUpd});
		write_word(DMA2D_STATUS, 32'h80000003);			// Start DMA

		ResetIdleCnt = 1;
		while(tb.Dma2D.Enabled != 0) @(posedge ACLK);
		ResetIdleCnt = 0;

		DMATestDataTest(0, DST_ADDR, ByteCnt, LineCnt, 31, 31);
		wait_until_rid_finished(0);

		DMATestDataClear(DST_ADDR, 64*64);
		wait_until_write_finished;
	

//	src_addr_index = 0;
//	dst_addr_index = 0;
//	bytecnt_index = 1;
//	linecnt_index = 2;
//	SrcAddrUpd = 2;
//	DstAddrUpd = 2;

	
	for(src_addr_index = 0; src_addr_index < 4; src_addr_index = src_addr_index + 1)
	for(dst_addr_index = 0; dst_addr_index < 4; dst_addr_index = dst_addr_index + 1)
	for(bytecnt_index = 0; bytecnt_index < 8; bytecnt_index = bytecnt_index + 1)
	for(linecnt_index = 0; linecnt_index < 8; linecnt_index = linecnt_index + 1)
	for(SrcAddrUpd = 0; SrcAddrUpd < 4; SrcAddrUpd = SrcAddrUpd + 1)
	for(DstAddrUpd = 0; DstAddrUpd < 4; DstAddrUpd = DstAddrUpd + 1)
	begin
		SrcAddr = SRC_ADDR + src_addr_index;
		DstAddr = DST_ADDR + dst_addr_index;
		ByteCnt = CntArray[bytecnt_index];
		LineCnt = CntArray[linecnt_index]-1;

		WADDR_START = DstAddr;
		WADDR_END = DstAddr + (ByteCnt+DstAddrUpd)*(LineCnt+1);

		$display("Starting Test : saddr_i(%1d) daddr_i(%1d) byte_count(%2d) line_cnt(%2d) SrcUpd(%1d) DstUpd(%1d)", src_addr_index, dst_addr_index, ByteCnt, LineCnt, SrcAddrUpd, DstAddrUpd);
		// Register Writing
		write_word(DMA2D_SRCADDR, SrcAddr);
		write_word(DMA2D_DSTADDR, DstAddr);
		write_word(DMA2D_BYTECNT, {16'h0000, ByteCnt});
		write_word(DMA2D_LINECNT, {LineCnt, ByteCnt});
		write_word(DMA2D_ADDRUPD, {SrcAddrUpd, DstAddrUpd});
		write_word(DMA2D_STATUS, 32'h80000003);			// Start DMA

		ResetIdleCnt = 1;
		while(tb.Dma2D.Enabled != 0) @(posedge ACLK);
		ResetIdleCnt = 0;

		DMATestDataTest(src_addr_index, DstAddr, ByteCnt, LineCnt, SrcAddrUpd, DstAddrUpd);
		wait_until_rid_finished(0);

		DMATestDataClear(DST_ADDR, 64*64);
		wait_until_write_finished;
	end

	repeat(100) @(posedge ACLK);

	finish_sim;
end

task DMATestDataLoad;
	input [31:0] StartAddr;
	input [31:0] Len;
	integer i;
	reg   [31:0] Addr;
	reg   [3:0]  wstrb;
	reg   [31:0] data;
begin
	for(i = 0; i < Len; i = i + 1)
	begin
		data[7:0] = i;
		Addr = StartAddr + i;
		case(Addr[1:0])
		2'b00:
		begin
			wstrb = 4'b0001;
			data[31:0] = { 24'hxxxxxx, data[7:0]};
		end
		2'b01:
		begin
			wstrb = 4'b0010;
			data[31:0] = { 16'hxxxx, data[7:0], 8'hxx};
		end
		2'b10:
		begin
			wstrb = 4'b0100;
			data[31:0] = { 8'hxx, data[7:0], 16'hxxxx};
		end
		2'b11:
		begin
			wstrb = 4'b1000;
			data[31:0] = { data[7:0], 24'hxxxxxx};
		end
		endcase

		awrite($random, StartAddr + i, 0, `SIZE_BYTE, `BURST_INCR);
		wdata(data , wstrb, 1);
	end
end
endtask

task DataTestByte;
	input [31:0] Addr;
	input [7:0] data;

	reg   [3:0] wstrb;
	reg   [31:0] data32;
begin
	case(Addr[1:0])
	2'b00:
	begin
		wstrb = 4'b0001;
		data32[31:0] = { 24'hxxxxxx, data[7:0]};
	end
	2'b01:
	begin
		wstrb = 4'b0010;
		data32[31:0] = { 16'hxxxx, data[7:0], 8'hxx};
	end
	2'b10:
	begin
		wstrb = 4'b0100;
		data32[31:0] = { 8'hxx, data[7:0], 16'hxxxx};
	end
	2'b11:
	begin
		wstrb = 4'b1000;
		data32[31:0] = { data[7:0], 24'hxxxxxx};
	end
	endcase

	aread(0, Addr, 0, `SIZE_BYTE, `BURST_INCR);
	rdata(0, data32, {{8{wstrb[3]}}, {8{wstrb[2]}}, {8{wstrb[1]}}, {8{wstrb[0]}}});
end
endtask

task DMATestDataTest;
	input [31:0] SrcAddrIndex;	// Start Data element
	input [31:0] DstAddr;	// DMA Destination address
	input [15:0] ByteCnt;	// ByteCnt(more than 1)
	input [15:0] LineCnt;	// LineCnt
	input [15:0] SrcAddrUpd;	// Src Address Update 
	input [15:0] DstAddrUpd;		// Destination address update
	integer i;
	integer j;
begin

	// Check if Region before DstAddr(64byte) contains not valid data.
	for(i = 0; i < 64; i = i + 1)
		DataTestByte(DstAddr-i-1, 8'hxx);

	for(j = 0; j <= LineCnt; j = j + 1)
	begin

		// Check if valid data exist
		for(i = 0; i < ByteCnt; i = i + 1)
			DataTestByte(DstAddr+i, SrcAddrIndex[7:0]+i);

		// Check if no valid data exist where garbage area
		for(i = 0; i < DstAddrUpd; i = i + 1)
			DataTestByte(DstAddr + ByteCnt + i, 8'hxx);

		DstAddr = DstAddr + ByteCnt + {{16{DstAddrUpd[15]}}, DstAddrUpd};
		SrcAddrIndex = SrcAddrIndex + ByteCnt + {{16{SrcAddrUpd[15]}}, SrcAddrUpd};
	end

	for(i = 0; i < 64; i = i + 1)
		DataTestByte(DstAddr+i, 8'hxx);

end
endtask

task DMATestDataTestReverse;
	input [31:0] SrcAddrIndex;	// Start Data element
	input [31:0] DstAddr;	// DMA Destination address
	input [15:0] ByteCnt;	// ByteCnt(more than 1)
	input [15:0] LineCnt;	// LineCnt
	input [15:0] SrcAddrUpd;	// Src Address Update 
	input [15:0] DstAddrUpd;		// Destination address update
	integer i;
	integer j;
	reg   [15:0] minusDstAddrUpd;
begin

	// Check if Region before DstAddr(64byte) contains not valid data.
	for(i = 0; i < 64; i = i + 1)
		DataTestByte(DstAddr+ByteCnt+i+1, 8'hxx);

	for(j = 0; j <= LineCnt; j = j + 1)
	begin

		// Check if valid data exist
		for(i = 0; i < ByteCnt; i = i + 1)
			DataTestByte(DstAddr+i, SrcAddrIndex[7:0]+i);

		// Check if no valid data exist where garbage area

		if(DstAddrUpd[15] == 0)
		begin
			for(i = 0; i < DstAddrUpd; i = i + 1)
				DataTestByte(DstAddr + ByteCnt + i, 8'hxx);

			DstAddr = DstAddr + ByteCnt + {{16{DstAddrUpd[15]}}, DstAddrUpd};
			SrcAddrIndex = SrcAddrIndex + ByteCnt + {{16{SrcAddrUpd[15]}}, SrcAddrUpd};
		end
		else
		begin
			DstAddr = DstAddr + ByteCnt + {{16{DstAddrUpd[15]}}, DstAddrUpd};
			SrcAddrIndex = SrcAddrIndex + ByteCnt + {{16{SrcAddrUpd[15]}}, SrcAddrUpd};
			minusDstAddrUpd = (~DstAddrUpd)+1;

			for(i = 0; i < (minusDstAddrUpd - 2*ByteCnt); i = i + 1)
				DataTestByte(DstAddr+ByteCnt+i, 8'hxx);
		end
	end

	for(i = 0; i < (minusDstAddrUpd-ByteCnt); i = i + 1)
		DataTestByte(DstAddr+i, 8'hxx);

end
endtask

task DMATestDataClear;
	input [31:0] StartAddr;
	input [31:0] Len;
	DMATestDataClearAndTest(0, StartAddr, Len);
endtask

task DMATestDataClearTest;
	input [31:0] StartAddr;
	input [31:0] Len;
	DMATestDataClearAndTest(1, StartAddr, Len);
endtask

task DMATestDataClearAndTest;
	input        mode;
	input [31:0] StartAddr;
	input [31:0] Len;
	integer i;
	reg   [31:0] Addr;
	reg   [3:0]  wstrb;
	reg   [31:0] data;
begin
	for(i = 0; i < Len; i = i + 1)
	begin
		data[7:0] = i;
		Addr = StartAddr + i;
		case(Addr[1:0])
		2'b00:
		begin
			wstrb = 4'b0001;
			data[31:0] = 32'hxxxxxxxx;
		end
		2'b01:
		begin
			wstrb = 4'b0010;
			data[31:0] = 32'hxxxxxxxx;
		end
		2'b10:
		begin
			wstrb = 4'b0100;
			data[31:0] = 32'hxxxxxxxx;
		end
		2'b11:
		begin
			wstrb = 4'b1000;
			data[31:0] = 32'hxxxxxxxx;
		end
		endcase
		if(mode == 0)
		begin
			awrite($random, StartAddr + i, 0, `SIZE_BYTE, `BURST_INCR);
			wdata(data , wstrb, 1);
		end
		else
		begin
			aread(0, StartAddr+i, 0, `SIZE_BYTE, `BURST_INCR);
			rdata(0, data, {{8{wstrb[3]}}, {8{wstrb[2]}}, {8{wstrb[1]}}, {8{wstrb[0]}}});
		end
	end
end
endtask

endmodule
