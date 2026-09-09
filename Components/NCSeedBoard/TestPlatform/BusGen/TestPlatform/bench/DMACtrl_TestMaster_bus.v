//START// ======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TestMaster.v
// File Revision       : 0.1
//  ----------------------------------------------------------------------
//  Purpose     : This module is programmable AXI master signal generator.
//              : This is behavioral model.(You cannot synthesize this)
//  ======================================================================

`timescale 1ns/10ps


`define RANDOM_WID    1
`define RANDOM_RID    1
`define WRITE_ENABLE  1
`define READ_ENABLE  1
`define SLAVE0_S    32'h40000000
`define SLAVE0_E    32'h80000000
`define SLAVE1_S    32'h20000000
`define SLAVE1_E    32'h30000000
`define SLAVE2_S    32'h30000000
`define SLAVE2_E    32'h40000000
`define SLAVE3_S    32'h0
`define SLAVE3_E    32'h10000000
`define SLAVE4_S    32'h10000000
`define SLAVE4_E    32'h20000000

module DMACtrl_TestMaster 
(
		MASTER_ID,	// Master identification

		ACLK     , 
		ARESETn  , 
		// Write Address Channel
		AWID     ,
		AWADDR   ,
		AWLEN    ,
		AWSIZE   ,
		AWBURST  ,
//disable lock port
//disable cache port
//disable protect port
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
//disable lock port
//disable cache port
//disable protect port
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
parameter DATA_WIDTH = 32;	// only support 32 now
parameter WID_WIDTH = 4;	// AWID/WID/BID width
parameter RID_WIDTH = 4;	// ARID/RID width
parameter RANDOMIZE = 1;	// VALID & READY timing is random
parameter MAXIMUM_IDLE_CNT = 500000;	// maximum idle cycle without generating error

parameter AWQ_WIDTH = 4;	// AW Request Que(4 bit : que length 16)
parameter WDQ_WIDTH = 8;	// WD Data Que(16*16)

parameter ARQ_WIDTH = 4;	// AR Request Que
parameter RDQ_WIDTH = 8;	// RD DAta Que for each ARID

parameter CNT_WIDTH = 32;   // I think it is sufficient

// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;
parameter AWQ_LEN = {AWQ_WIDTH{1'b1}}+1;
parameter WDQ_LEN = {WDQ_WIDTH{1'b1}}+1;
parameter ARQ_LEN = {ARQ_WIDTH{1'b1}}+1;
parameter RDQ_LEN = {RDQ_WIDTH{1'b1}}+1;
parameter RID_LEN = {RID_WIDTH{1'b1}}+1;
parameter WID_LEN = {WID_WIDTH{1'b1}}+1;


parameter BUS_WID = 32;
parameter ADDR_WID= 32;
parameter MASTERID_WID= 1;
parameter SLAVEID_WID= 3;
parameter AWLEN_WID= 4;
parameter AWSIZE_WID= 3;
parameter AWBURST_WID= 2;
parameter AWLOCK_WID= 2;
parameter AWCACHE_WID= 4;
parameter AWPROT_WID= 3;
parameter WSTRB_WID= 4;
parameter BRESP_WID= 2;
parameter RRESP_WID= 2;
parameter ARLEN_WID= 4;
parameter ARBURST_WID= 2;
parameter ARLOCK_WID= 2;
parameter ARCACHE_WID= 4;
parameter ARPROT_WID= 3;
parameter MASTER_WID= 3;
parameter SLAVE_WID= 3;
parameter SLAVE_NUM= 6;
parameter MASTER_NUM= 4;
parameter SELMASTER_WID= 2;
parameter Wr_REQDEPTH_WID= 2;
parameter Rd_REQDEPTH_WID= 2;
parameter WrPermit_SLAVECNTWID= 2;
parameter RdPermit_SLAVECNTWID= 1;
parameter ARSIZE_WID= 3;

//parameter TADDR_AWIDTH=12;
parameter TADDR_AWIDTH=8;
parameter TNUM_ADATA=1<<TADDR_AWIDTH;
parameter AREA_MIN = MASTER_WID + TADDR_AWIDTH;   
parameter BLANK = 27 - (AREA_MIN) + 1;
parameter B2 = 8 - MASTER_WID;

wire      [BLANK-1:0] AreaBLANK = {BLANK{1'b0}};

`define RESP_OKAY	2'b00

//
// input/output port
//
input [MASTER_WID-1:0] MASTER_ID;
wire  [7:0] wMASTER_ID;

assign wMASTER_ID[MASTER_WID-1:0] = MASTER_ID;
assign wMASTER_ID[7:MASTER_WID]   = {B2{1'b0}};


input  ACLK;
input  ARESETn;

output [WID_WIDTH-1:0]  AWID;
output [31:0]           AWADDR;
output [3:0]            AWLEN;
output [2:0]            AWSIZE;
output [1:0]            AWBURST;
//disable lock port
//disable cache port
//disable protect port
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
//disable lock port
//disable cache port
//disable protect port
output                  ARVALID;
input                   ARREADY;

input  [RID_WIDTH-1:0]  RID;
input  [DATA_WIDTH-1:0] RDATA;
input  [1:0]            RRESP;
input                   RLAST;
input                   RVALID;
output                  RREADY;

//
// all ouput is reg
//
reg    [WID_WIDTH-1:0]  AWID;
reg    [31:0]           AWADDR;
reg    [3:0]            AWLEN;
reg    [2:0]            AWSIZE;
reg    [1:0]            AWBURST;
reg    [1:0]            AWLOCK;
reg    [3:0]            AWCACHE;
reg    [2:0]            AWPROT;
reg                     AWVALID;

reg    [WID_WIDTH-1:0]  WID;
reg    [DATA_WIDTH-1:0] WDATA;
reg    [NUM_BYTE-1:0]   WSTRB;
reg                     WLAST;
reg                     WVALID;

reg                     BREADY;

reg    [RID_WIDTH-1:0]  ARID;
reg    [31:0]           ARADDR;
reg    [3:0]            ARLEN;
reg    [2:0]            ARSIZE;
reg    [1:0]            ARBURST;
reg    [1:0]            ARLOCK;
reg    [3:0]            ARCACHE;
reg    [2:0]            ARPROT;
reg                     ARVALID;

reg                     RREADY;


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
	WDQ_full = (WDQ_RINDEX == (WDQ_WINDEX+1'b1)) ? 1'b1 : 1'b0;
endfunction
function WDQ_HaveSpace;	// check WDQ have sufficient space for data
	input [3:0] reserved_len;
	begin
	WDQ_HaveSpace = (
		(WDQ_RINDEX < WDQ_WINDEX
			&& WDQ_RINDEX > (WDQ_WINDEX+reserved_len+1'b1))
		|| (WDQ_RINDEX > WDQ_WINDEX
			&& WDQ_RINDEX < (WDQ_WINDEX+reserved_len+1'b1))
		)? 1'b0 : 1'b1;
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
function RDQ_HaveSpace;	// check WDQ have sufficient space for data
	input [RID_WIDTH-1:0] rid;
	input [3:0] reserved_len;
	begin
	RDQ_HaveSpace =(
		(RDQ_RINDEX[rid] < RDQ_WINDEX[rid]
			&& RDQ_RINDEX[rid] > (RDQ_WINDEX[rid]+reserved_len+1'b1))
		|| (RDQ_RINDEX[rid] > RDQ_WINDEX[rid]
			&& RDQ_RINDEX[rid] < (RDQ_WINDEX[rid]+reserved_len+1'b1))
		)? 1'b0 : 1'b1;
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
		AWID <= 0;
		AWADDR <= 0;
		AWLEN <= 0;
		AWSIZE <= 0;
		AWBURST <= 0;
		AWLOCK <= 0;
		AWCACHE <= 0;
		AWPROT <= 0;
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

			AWID <= AWID_Q[AWQ_RINDEX];
			AWADDR <= AWADDR_Q[AWQ_RINDEX];
			AWLEN <= AWLEN_Q[AWQ_RINDEX];
			AWSIZE <= AWSIZE_Q[AWQ_RINDEX];
			AWBURST <= AWBURST_Q[AWQ_RINDEX];
			AWLOCK <= AWLOCK_Q[AWQ_RINDEX];
			AWCACHE <= AWCACHE_Q[AWQ_RINDEX];
			AWPROT <= AWPROT_Q[AWQ_RINDEX];
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

					AWID <= AWID_Q[AWQ_RINDEX];
					AWADDR <= AWADDR_Q[AWQ_RINDEX];
					AWLEN <= AWLEN_Q[AWQ_RINDEX];
					AWSIZE <= AWSIZE_Q[AWQ_RINDEX];
					AWBURST <= AWBURST_Q[AWQ_RINDEX];
					AWLOCK <= AWLOCK_Q[AWQ_RINDEX];
					AWCACHE <= AWCACHE_Q[AWQ_RINDEX];
					AWPROT <= AWPROT_Q[AWQ_RINDEX];
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
				WID <= WID_Q[WIDQ_RINDEX];
				WDATA <= WDATA_Q[WDQ_RINDEX];
				WSTRB <= WSTRB_Q[WDQ_RINDEX];
				WLAST <= WLAST_Q[WDQ_RINDEX];
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
				if(WLAST == 1'b1)	// last data => proceed next transaction
				begin
					if(WIDQ_empty != 1'b1 && (RANDOMIZE == 0 || WD_RANDOM == 1'b1))
					begin
						if(WDQ_empty == 1'b1)
						begin
							$display("BUG: WDATA is not sufficient");
							$stop;
						end
						WID <= WID_Q[WIDQ_RINDEX];
						WDATA <= WDATA_Q[WDQ_RINDEX];
						WSTRB <= WSTRB_Q[WDQ_RINDEX];
						WLAST <= WLAST_Q[WDQ_RINDEX];
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
						WDATA <= WDATA_Q[WDQ_RINDEX];
						WSTRB <= WSTRB_Q[WDQ_RINDEX];
						WLAST <= WLAST_Q[WDQ_RINDEX];
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
					WDATA <= WDATA_Q[WDQ_RINDEX];
					WSTRB <= WSTRB_Q[WDQ_RINDEX];
					WLAST <= WLAST_Q[WDQ_RINDEX];
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
		ARID <= 0;
		ARADDR <= 0;
		ARLEN <= 0;
		ARSIZE <= 0;
		ARBURST <= 0;
		ARLOCK <= 0;
		ARCACHE <= 0;
		ARPROT <= 0;
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
			ARID <= ARID_Q[ARQ_RINDEX];
			ARADDR <= ARADDR_Q[ARQ_RINDEX];
			ARLEN <= ARLEN_Q[ARQ_RINDEX];
			ARSIZE <= ARSIZE_Q[ARQ_RINDEX];
			ARBURST <= ARBURST_Q[ARQ_RINDEX];
			ARLOCK <= ARLOCK_Q[ARQ_RINDEX];
			ARCACHE <= ARCACHE_Q[ARQ_RINDEX];
			ARPROT <= ARPROT_Q[ARQ_RINDEX];
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
					ARID <= ARID_Q[ARQ_RINDEX];
					ARADDR <= ARADDR_Q[ARQ_RINDEX];
					ARLEN <= ARLEN_Q[ARQ_RINDEX];
					ARSIZE <= ARSIZE_Q[ARQ_RINDEX];
					ARBURST <= ARBURST_Q[ARQ_RINDEX];
					ARLOCK <= ARLOCK_Q[ARQ_RINDEX];
					ARCACHE <= ARCACHE_Q[ARQ_RINDEX];
					ARPROT <= ARPROT_Q[ARQ_RINDEX];
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
		for(TEMP_I = AWQ_RINDEX; TEMP_I < AWQ_WINDEX; TEMP_I = TEMP_I + 1)
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
		for(TEMP_I = ARQ_RINDEX; TEMP_I < ARQ_WINDEX; TEMP_I = TEMP_I + 1)
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




reg [20:0] CONNECT_SLAVE;

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

        //Connect Slave information
        CONNECT_SLAVE[0] = 1'b1;;
        CONNECT_SLAVE[1] = 1'b1;;
        CONNECT_SLAVE[2] = 1'b1;;
        CONNECT_SLAVE[3] = 1'b1;;
        CONNECT_SLAVE[4] = 1'b1;;
        CONNECT_SLAVE[5] = 1'b1;;
//STATE_END
        ///////////////////////////

		while(ARESETn != 1) @(posedge ACLK);// wait until ARESETn get high
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
			while(AWQ_full() == 1'b1) @(posedge ACLK);
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

// Task for write data channel
task wdata;
	input [DATA_WIDTH-1:0] wdata;
	input [NUM_BYTE-1:0]   wstrb;
	input                  wlast;
		begin
			while(WDQ_full() == 1'b1) @(posedge ACLK);
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
			while(ARQ_full() == 1'b1) @(posedge ACLK);
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
			while(ARQ_full() == 1'b1) @(posedge ACLK);
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
	while(IsWriteIdle() != 1'b1)	@(posedge ACLK);
endtask

task wait_until_wid_finished;
	input [WID_WIDTH-1:0] wid_to_check;
	while(IsWIDIdle(wid_to_check) != 1'b1)	@(posedge ACLK);
endtask

task wait_until_read_finished;
	while(IsReadIdle() != 1'b1)	@(posedge ACLK);
endtask

task wait_until_rid_finished;
	input [RID_WIDTH-1:0] rid_to_check;
	while(IsRIDIdle(rid_to_check) != 1'b1)	@(posedge ACLK);
endtask

task wait_until_idle;
	while(IsWriteIdle() != 1'b1 || IsReadIdle() != 1'b1)
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
		
//
// Real Transaction Part
//
initial
begin
	start_sim;

	//
	// initial data load
	//
    //
    if(`WRITE_ENABLE == 1)
    begin
        $display("Initial Write MasterID [%h]\n", MasterNumber());
	    initial_data_write;

	    wait_until_write_finished;
        $display("End Initial Write[%h]\n", MasterNumber());
    end
    else
        $display("Write Channel disable [%h]\n", MasterNumber());
    

	while (1)
	begin
        random_area_read_write;
        wait_until_idle;
	end

	finish_sim;
end

task delay;
    input   [15:0] maxdelay;
    reg [15:0] i;
    begin

        i = $random;
        while(i > maxdelay)
            i = $random;

        repeat(i)
        begin
            @(posedge ACLK);
        end

    end
endtask

parameter MNUMWID = 10;

function [3:0] MasterNumber;
	MasterNumber = wMASTER_ID[3:0];
endfunction

function [31:0] StartAddress;
	input [SLAVE_WID-1:0] slave_number;
    begin
        case(slave_number)
            3'd0: StartAddress = `SLAVE0_S;
            3'd1: StartAddress = `SLAVE1_S;
            3'd2: StartAddress = `SLAVE2_S;
            3'd3: StartAddress = `SLAVE3_S;
            3'd4: StartAddress = `SLAVE4_S;
        endcase
    end
endfunction


function [31:0] EndAddress;
	input [SLAVE_WID-1:0] slave_number;
    begin
        case(slave_number)
            3'd0: EndAddress = `SLAVE0_E;
            3'd1: EndAddress = `SLAVE1_E;
            3'd2: EndAddress = `SLAVE2_E;
            3'd3: EndAddress = `SLAVE3_E;
            3'd4: EndAddress = `SLAVE4_E;
        endcase
    end
endfunction

function [SLAVE_WID-1:0] AreaCheck;
	input [31:0] address;
    begin

         if((address >= `SLAVE0_S) && ( address < `SLAVE0_E))
            AreaCheck = 0;
        else if((address >= `SLAVE1_S) && ( address < `SLAVE1_E))
            AreaCheck = 1;
        else if((address >= `SLAVE2_S) && ( address < `SLAVE2_E))
            AreaCheck = 2;
        else if((address >= `SLAVE3_S) && ( address < `SLAVE3_E))
            AreaCheck = 3;
        else if((address >= `SLAVE4_S) && ( address < `SLAVE4_E))
            AreaCheck = 4;
        else
            AreaCheck = {SLAVE_WID{1'b1}};
    end
endfunction

function [31:0] SlaveAreaAddr;
    input [19:0] haddr;
	input [31:0] addr;
	//SlaveAreaAddr = {haddr[19:0], 1'b0, MasterNumber(), addr[TADDR_AWIDTH-1:0]};
	SlaveAreaAddr = {haddr[19:0], MasterNumber(), addr[TADDR_AWIDTH-1:0]};
endfunction

function [31:0] SlaveAreaData;
	input [19:0] haddr;
	input [31:0] addr;
	//SlaveAreaData = {haddr[19:0], 1'b0, MasterNumber(), addr[TADDR_AWIDTH-1:0]};
	SlaveAreaData = {haddr[19:0], MasterNumber(), addr[TADDR_AWIDTH-1:0]};
endfunction


task initial_data_write;
integer i;
integer j;
integer k;
integer l;
integer endi;
integer starti;
begin
	for(k = 0; k < SLAVE_NUM ; k = k + 1)
	begin

        if(CONNECT_SLAVE[k] == 1)
        begin

			$display("Connect slave num [%h]/%h \n",MasterNumber(),k);
            starti = StartAddress(k) >> 12;
            endi   = EndAddress(k) >> 12;

            for(i = starti; endi > i; i=i+1)
            begin
                for(l = 0 ; 16'hFF >l ; l=l+(16*4))
                begin
                    delay(700);

                    if(`RANDOM_WID == 1)
			            awrite($random, SlaveAreaAddr(i,l), 16-1, `SIZE_WORD, `BURST_INCR);
                    else
			            awrite(0, SlaveAreaAddr(i,l), 16-1, `SIZE_WORD, `BURST_INCR);

			        for(j = 0; j < 16; j = j+1)
			        begin
				        if(j != 15)
					        wdata(SlaveAreaData(i, ((j*4)+l)) , {NUM_BYTE{1'b1}}, 0);
				        else//Last input
					        wdata(SlaveAreaData(i, ((j*4)+l)), {NUM_BYTE{1'b1}}, 1);
			        end
                end
            end
        end
    end
end
endtask

reg [SLAVE_WID-1:0] before_slave_number0;
reg [SLAVE_WID-1:0] before_slave_number1;

task random_area_read_write;
	reg read_or_write;
	reg [31:0] slave_addr;
	reg [19:0] hslave_addr;
	reg [RID_WIDTH-1:0] rid;
	reg [WID_WIDTH-1:0] wid;
    reg [SLAVE_WID-1:0] slave_number;
	reg [3:0] burst_len;
    reg [3:0] slave_byen;
    reg [31:0] ov_check;

	integer i;
	begin

        if(`READ_ENABLE == 1 && `WRITE_ENABLE == 1)
		    read_or_write = $random;
        else if(`READ_ENABLE == 1 && `WRITE_ENABLE == 0)
		    read_or_write = 0;
        else if(`READ_ENABLE == 0 && `WRITE_ENABLE == 1)
		    read_or_write = 1;

		slave_addr = $random;
		burst_len = $random;

        if(`RANDOM_WID == 1)
		    wid = $random;
        else
            wid = 0;

        if(`RANDOM_RID == 1)
		    rid = $random;
        else
            rid = 0;

        hslave_addr = $random;
        slave_byen = $random;
        slave_addr[3:0] = slave_byen * 4; // 0 4 8 C..

        while(AreaCheck(SlaveAreaAddr(hslave_addr,slave_addr)) 
                        == {SLAVE_WID{1'b1}}) 
        begin
            hslave_addr = $random;
		    slave_addr = $random;
            slave_byen = $random;
            slave_addr[3:0] = slave_byen * 4; // 0 4 8 C..
        end

        ov_check = slave_addr[7:0]+(burst_len*4);


        while((ov_check >> 8) != 0)
        begin
	        burst_len = $random;
            ov_check = slave_addr[7:0]+(burst_len*4);
        end

        slave_number = AreaCheck(SlaveAreaAddr(hslave_addr,slave_addr));
        before_slave_number0 = slave_number;
        before_slave_number1 = before_slave_number0;

        delay(800);
	    $display($time, "  Random Address [%h] /bursrNum [%h]/ Master[%h] \n",
                  SlaveAreaAddr(hslave_addr, slave_addr), burst_len, MasterNumber());

		if(read_or_write == 0)	// read
		begin
			aread(rid, SlaveAreaAddr(hslave_addr, slave_addr), burst_len, `SIZE_WORD, `BURST_INCR);
			rdata(rid, SlaveAreaData(hslave_addr, slave_addr), {DATA_WIDTH{1'b1}});


			i = 1;
			while(burst_len != 0)
			begin
				rdata(rid, SlaveAreaData(hslave_addr, slave_addr+(i*4)), {DATA_WIDTH{1'b1}});
				burst_len = burst_len - 1;
				i = i + 1;
			end
		end
		else 
		begin
			awrite(wid, SlaveAreaAddr(hslave_addr, slave_addr), burst_len, `SIZE_WORD, `BURST_INCR);
			wdata(SlaveAreaData(hslave_addr, slave_addr), {NUM_BYTE{1'b1}}, (burst_len==0));
			i = 1;
			while(burst_len != 0)
			begin
				wdata(SlaveAreaData(hslave_addr, slave_addr+(i*4)), {NUM_BYTE{1'b1}}, (burst_len == 1));
				burst_len = burst_len - 1;
				i = i + 1;
			end
		end
	end
endtask

endmodule
