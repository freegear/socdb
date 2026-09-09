/*****************************************************************
		         IntSRAMController Simple testbench
*****************************************************************/
`timescale 1 ns/ 10ps
module tb_IntSRAMController;

parameter CLK_HALFPERIOD=5;

parameter DATA_WIDTH = 32;	// only support 32 now
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;

parameter CNT_WIDTH = 32;		// I think it is sufficient

// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;

`define SIZE_BYTE	3'b000
`define SIZE_HWORD	3'b001
`define SIZE_WORD	3'b010
`define SIZE_DWORD	3'b011

`define BURST_FIXED	2'b00
`define BURST_INCR	2'b01
`define BURST_WRAP	2'b10

reg         ACLK        ;     // APB system clock
reg         ARESETn     ;     // APB system reset

reg  [WID_WIDTH-1:0]  AWID;
reg  [31:0]           AWADDR;
reg  [3:0]            AWLEN;
reg  [2:0]            AWSIZE;
reg  [1:0]            AWBURST;
reg                   AWVALID;
wire                  AWREADY;

reg  [WID_WIDTH-1:0]  WID;
reg  [DATA_WIDTH-1:0] WDATA;
reg  [NUM_BYTE-1:0]   WSTRB;
reg                   WLAST;
reg                   WVALID;
wire                  WREADY;

wire [WID_WIDTH-1:0]  BID;
wire [1:0]            BRESP;
wire                  BVALID;
reg                   BREADY;

reg  [RID_WIDTH-1:0]  ARID;
reg  [31:0]           ARADDR;
reg  [3:0]            ARLEN;
reg  [2:0]            ARSIZE;
reg  [1:0]            ARBURST;
reg                   ARVALID;
wire                  ARREADY;

wire [RID_WIDTH-1:0]  RID;
wire [DATA_WIDTH-1:0] RDATA;
wire [1:0]            RRESP;
wire                  RLAST;
wire                  RVALID;
reg                   RREADY;


reg  [31:0]           READErr;

always #CLK_HALFPERIOD	ACLK = ~ACLK;

initial
begin
	
	READErr		= 0;
	ACLK 		= 0;     // clock
	ARESETn 	= 0;     // reset

	AWVALID     = 0;
	WVALID      = 0;
	BREADY      = 1;	// always high
	
	ARVALID     = 0;
	RREADY      = 1;	// always high

	repeat(10) @(posedge ACLK);
	ARESETn	= 1;

	awrite(0, 0, 6, `SIZE_WORD, `BURST_INCR);
	writedata(32'h00000001, {(NUM_BYTE){1'b1}}, 0);
	writedata(32'h00000002, {(NUM_BYTE){1'b1}}, 0);
	writedata(32'h00000003, {(NUM_BYTE){1'b1}}, 0);
	writedata(32'h00000004, {(NUM_BYTE){1'b1}}, 0);
	writedata(32'h00000005, {(NUM_BYTE){1'b1}}, 0);
	writedata(32'h00000006, {(NUM_BYTE){1'b1}}, 1);

	aread(0, 32'h00000000, 4, `SIZE_WORD, `BURST_INCR);
	readdata_check(32'h00000001);
	readdata_check(32'h00000002);
	readdata_check(32'h00000003);
	readdata_check(32'h00000004);

	aread(0, 32'h00000000, 4, `SIZE_WORD, `BURST_INCR);
	RREADY = 0;
	repeat(2) @(posedge ACLK);
	#1 RREADY = 1;
	readdata_check(32'h00000001);
	RREADY = 0;
	repeat(2) @(posedge ACLK);
	#1 RREADY = 1;
	readdata_check(32'h00000002);
	readdata_check(32'h00000003);
	readdata_check(32'h00000004);

	aread(0, 32'h00000000, 4, `SIZE_WORD, `BURST_WRAP);
	RREADY = 0;
	repeat(2) @(posedge ACLK);
	#1 RREADY = 1;
	readdata_check(32'h00000001);
	RREADY = 0;
	repeat(2) @(posedge ACLK);
	#1 RREADY = 1;
	readdata_check(32'h00000002);
	readdata_check(32'h00000003);
	readdata_check(32'h00000004);

	aread(0, 32'h00000008, 4, `SIZE_WORD, `BURST_WRAP);
	RREADY = 0;
	repeat(2) @(posedge ACLK);
	#1 RREADY = 1;
	readdata_check(32'h00000003);
	RREADY = 0;
	repeat(2) @(posedge ACLK);
	#1 RREADY = 1;
	readdata_check(32'h00000004);
	readdata_check(32'h00000001);
	readdata_check(32'h00000002);

	aread(0, 32'h00000008, 4, `SIZE_WORD, `BURST_INCR);
	RREADY = 0;
	repeat(2) @(posedge ACLK);
	#1 RREADY = 1;
	readdata_check(32'h00000003);
	RREADY = 0;
	repeat(2) @(posedge ACLK);
	#1 RREADY = 1;
	readdata_check(32'h00000004);
	readdata_check(32'h00000005);
	readdata_check(32'h00000006);

	if(READErr != 0)
		$display("Simulation Ended with Error");
	else
		$display("Simulation Ended without Error");
	$finish;
end

// TASK for write and read 
task awrite; // address write channel start
	input [WID_WIDTH-1:0] wid;
	input [31:0] awaddr;
	input [3:0]  len;
	input [2:0]  awsize;
	input [1:0]  awburst;
		begin
			@(negedge ACLK);
			AWID = wid;
			AWADDR = awaddr;
			AWLEN = len-1;
			AWSIZE = awsize;
			AWBURST = awburst;
			AWVALID = 1'b1;
			@(posedge ACLK);
			while(AWREADY == 1'b0) @(posedge ACLK);
			#1 AWVALID = 1'b0;
		end
endtask

task writedata;	// write data channel
	input [DATA_WIDTH-1:0] wdata;
	input [NUM_BYTE-1:0] wstrb;
	input wlast;
		begin
			@(negedge ACLK);
			WDATA = wdata;
			WSTRB = wstrb;
			WLAST = wlast;
			WVALID = 1'b1;
			@(posedge ACLK);
			while(WREADY == 1'b0) @(posedge ACLK);
			#1 WVALID = 1'b0;
		end
endtask

task aread; // address read channel start
	input [RID_WIDTH-1:0] rid;
	input [31:0] araddr;
	input [3:0]  len;
	input [2:0]  arsize;
	input [1:0]  arburst;
		begin
			@(negedge ACLK);
			ARID = rid;
			ARADDR = araddr;
			ARLEN = len-1;
			ARSIZE = arsize;
			ARBURST = arburst;
			ARVALID = 1'b1;
			@(posedge ACLK);
			while(ARREADY == 1'b0) @(posedge ACLK);
			#1 ARVALID = 1'b0;
		end
endtask

reg [DATA_WIDTH-1:0] READ_DATA;
task readdata_check;	// write data channel
	input [DATA_WIDTH-1:0] rdata;
		begin
			@(posedge ACLK);
			while(RVALID == 1'b0) @(posedge ACLK);
			if(RDATA != rdata)
			begin
				READErr = READErr + 1'b1;
				$display($time, " Read Error : Read %h when %h expected ", RDATA, rdata);
			end
			#1;
		end
endtask

wire [31:0]           MEMADDR;
wire [DATA_WIDTH-1:0] MEMRDATA;
wire [DATA_WIDTH-1:0] MEMWDATA;
wire                  MEMCEn;
wire [NUM_BYTE-1:0]   MEMWEn;

IntSRAMController IntSRAMController
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWID),
		.AWADDR(AWADDR),
		.AWLEN(AWLEN),
		.AWSIZE(AWSIZE),
		.AWBURST(AWBURST),
		.AWVALID(AWVALID),
		.AWREADY(AWREADY),

		.WID(WID),
		.WDATA(WDATA),
		.WSTRB(WSTRB),
		.WLAST(WLAST),
		.WVALID(WVALID),
		.WREADY(WREADY),

		.BID(BID),
		.BRESP(BRESP),
		.BVALID(BVALID),
		.BREADY(BREADY),

		.ARID(ARID),
		.ARADDR(ARADDR),
		.ARLEN(ARLEN),
		.ARSIZE(ARSIZE),
		.ARBURST(ARBURST),
		.ARVALID(ARVALID),
		.ARREADY(ARREADY),

		// Read Data Channel
		.RID(RID),
		.RDATA(RDATA),
		.RRESP(RRESP),
		.RLAST(RLAST),
		.RVALID(RVALID),
		.RREADY(RREADY),

		.MEMADDR(MEMADDR[29:0]),
		.MEMCEn(MEMCEn),
		.MEMWEn(MEMWEn),
		.MEMRDATA(MEMRDATA),
		.MEMWDATA(MEMWDATA)
);

SSRAM32bit #(12) SRAM
(
		.CLK(ACLK),
		.ADDR(MEMADDR[11:0]),
		.CEn(MEMCEn),
		.WEn(MEMWEn),
		.RDATA(MEMRDATA),
		.WDATA(MEMWDATA)
);

endmodule

