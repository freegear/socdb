/*****************************************************************
		         TestMaster Simple testbench
*****************************************************************/
`timescale 1 ns/ 10ps
module tb;

parameter CLK_HALFPERIOD=5;
parameter WID_WIDTH=4;
parameter RID_WIDTH=4;

parameter DATA_WIDTH = 32;	// only support 32 now

// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;

reg         CLK        ;     // system clock
reg         RESETn     ;     // system reset

wire [31:0]           HADDR;
wire [1:0]            HTRANS;
wire                  HWRITE;
wire [2:0]            HSIZE;
wire [2:0]            HBURST;
wire [3:0]            HPROT;
wire                  HLOCK;
wire [31:0]           HWDATA;
wire [31:0]           HRDATA;
wire                  HREADY;
wire [1:0]            HRESP;
reg                   HSEL;

reg  [WID_WIDTH-1:0]  AWID;
wire [31:0]           AWADDR;
wire [3:0]            AWLEN;
wire [2:0]            AWSIZE;
wire [1:0]            AWBURST;
wire                  AWVALID;
wire                  AWREADY;

reg  [WID_WIDTH-1:0]  WID;
wire [DATA_WIDTH-1:0] WDATA;
wire [NUM_BYTE-1:0]   WSTRB;
wire                  WLAST;
wire                  WVALID;
wire                  WREADY;

wire [WID_WIDTH-1:0]  BID;
wire [1:0]            BRESP;
wire                  BVALID;
wire                  BREADY;

reg  [RID_WIDTH-1:0]  ARID;
wire [31:0]           ARADDR;
wire [3:0]            ARLEN;
wire [2:0]            ARSIZE;
wire [1:0]            ARBURST;
wire                  ARVALID;
wire                  ARREADY;

wire [RID_WIDTH-1:0]  RID;
wire [DATA_WIDTH-1:0] RDATA;
wire [1:0]            RRESP;
wire                  RLAST;
wire                  RVALID;
wire                  RREADY;

always #CLK_HALFPERIOD	CLK = ~CLK;

initial CLK 		= 0;     // clock
initial
begin
	RESETn 	= 0;     // reset
	repeat(10) @(posedge CLK);
	RESETn	= 1;
end

initial
begin
	HSEL = 1;
	AWID = 0;
	WID = 0;
	ARID = 0;
end

AHBTestMaster AHBTestMaster
(
		.HCLK(CLK),
		.HRESETn(RESETn),

		.HADDR(HADDR),
		.HTRANS(HTRANS),
		.HWRITE(HWRITE),
		.HSIZE(HSIZE),
		.HBURST(HBURST),
		.HPROT(HPROT),
		.HLOCK(HLOCK),
		.HWDATA(HWDATA),
		.HRDATA(HRDATA),
		.HREADY(HREADY),
		.HRESP(HRESP)
);

AHB2AXIBridge AHB2AXIBridge
(
		.CLK(CLK),
		.RESETn(RESETn),

		.HADDR(HADDR),
		.HTRANS(HTRANS),
		.HWRITE(HWRITE),
		.HSIZE(HSIZE),
		.HBURST(HBURST),
		.HPROT(HPROT),
		.HWDATA(HWDATA),
		.HRDATA(HRDATA),
		.HREADY_IN(HREADY),
		.HREADY_OUT(HREADY),
		.HRESP(HRESP),

		.HSEL(HSEL),
		.HMASTLOCK(HLOCK),

		.AWADDR(AWADDR),
		.AWLEN(AWLEN),
		.AWSIZE(AWSIZE),
		.AWBURST(AWBURST),
		.AWLOCK(),
		.AWCACHE(),
		.AWPROT(),
		.AWVALID(AWVALID),
		.AWREADY(AWREADY),

		.WDATA(WDATA),
		.WSTRB(WSTRB),
		.WLAST(WLAST),
		.WVALID(WVALID),
		.WREADY(WREADY),

		.BRESP(BRESP),
		.BVALID(BVALID),
		.BREADY(BREADY),

		.ARADDR(ARADDR),
		.ARLEN(ARLEN),
		.ARSIZE(ARSIZE),
		.ARBURST(ARBURST),
		.ARLOCK(),
		.ARCACHE(),
		.ARPROT(),
		.ARVALID(ARVALID),
		.ARREADY(ARREADY),

		// Read Data Channel
		.RDATA(RDATA),
		.RRESP(RRESP),
		.RLAST(RLAST),
		.RVALID(RVALID),
		.RREADY(RREADY)
);

wire [31:0] MEMADDR;
wire [31:0] MEMRDATA;
wire [31:0] MEMWDATA;
wire        MEMCEn;
wire [3:0]  MEMWEn;
IntSRAMController IntSRAMController
(
		.ACLK(CLK),
		.ARESETn(RESETn),

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
		.CLK(CLK),
		.ADDR(MEMADDR[11:0]),
		.CEn(MEMCEn),
		.WEn(MEMWEn),
		.RDATA(MEMRDATA),
		.WDATA(MEMWDATA)
);

endmodule

