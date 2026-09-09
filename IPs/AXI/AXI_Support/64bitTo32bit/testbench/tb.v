/*****************************************************************
		         TestMaster Simple testbench
*****************************************************************/
`timescale 1 ns/ 10ps
module tb;

parameter CLK_HALFPERIOD=5;

parameter DATA_WIDTH = 32;	// only support 32 now
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;

// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;

reg         ACLK        ;     // APB system clock
reg         ARESETn     ;     // APB system reset

wire [WID_WIDTH-1:0]  AWID64;
wire [31:0]           AWADDR64;
wire [3:0]            AWLEN64;
wire [2:0]            AWSIZE64;
wire [1:0]            AWBURST64;
wire                  AWVALID64;
wire                  AWREADY64;

wire [WID_WIDTH-1:0]  WID64;
wire [63:0]           WDATA64;
wire [7:0]            WSTRB64;
wire                  WLAST64;
wire                  WVALID64;
wire                  WREADY64;

wire [WID_WIDTH-1:0]  BID64;
wire [1:0]            BRESP64;
wire                  BVALID64;
wire                  BREADY64;

wire [RID_WIDTH-1:0]  ARID64;
wire [31:0]           ARADDR64;
wire [3:0]            ARLEN64;
wire [2:0]            ARSIZE64;
wire [1:0]            ARBURST64;
wire                  ARVALID64;
wire                  ARREADY64;

wire [RID_WIDTH-1:0]  RID64;
wire [63:0]           RDATA64;
wire [1:0]            RRESP64;
wire                  RLAST64;
wire                  RVALID64;
wire                  RREADY64;

wire [WID_WIDTH-1:0]  AWID32;
wire [31:0]           AWADDR32;
wire [3:0]            AWLEN32;
wire [2:0]            AWSIZE32;
wire [1:0]            AWBURST32;
wire                  AWVALID32;
wire                  AWREADY32;

wire [WID_WIDTH-1:0]  WID32;
wire [31:0]           WDATA32;
wire [3:0]            WSTRB32;
wire                  WLAST32;
wire                  WVALID32;
wire                  WREADY32;

wire [WID_WIDTH-1:0]  BID32;
wire [1:0]            BRESP32;
wire                  BVALID32;
wire                  BREADY32;

wire [RID_WIDTH-1:0]  ARID32;
wire [31:0]           ARADDR32;
wire [3:0]            ARLEN32;
wire [2:0]            ARSIZE32;
wire [1:0]            ARBURST32;
wire                  ARVALID32;
wire                  ARREADY32;

wire [RID_WIDTH-1:0]  RID32;
wire [31:0]           RDATA32;
wire [1:0]            RRESP32;
wire                  RLAST32;
wire                  RVALID32;
wire                  RREADY32;


always #CLK_HALFPERIOD	ACLK = ~ACLK;

initial ACLK 		= 0;     // clock
initial
begin
	ARESETn 	= 0;     // reset
	repeat(10) @(posedge ACLK);
	ARESETn	= 1;
end

TestMaster TestMaster
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWID64),
		.AWADDR(AWADDR64),
		.AWLEN(AWLEN64),
		.AWSIZE(AWSIZE64),
		.AWBURST(AWBURST64),
		.AWLOCK(),
		.AWCACHE(),
		.AWPROT(),
		.AWVALID(AWVALID64),
		.AWREADY(AWREADY64),

		.WID(WID64),
		.WDATA(WDATA64),
		.WSTRB(WSTRB64),
		.WLAST(WLAST64),
		.WVALID(WVALID64),
		.WREADY(WREADY64),

		.BID(BID64),
		.BRESP(BRESP64),
		.BVALID(BVALID64),
		.BREADY(BREADY64),

		.ARID(ARID64),
		.ARADDR(ARADDR64),
		.ARLEN(ARLEN64),
		.ARSIZE(ARSIZE64),
		.ARBURST(ARBURST64),
		.ARLOCK(),
		.ARCACHE(),
		.ARPROT(),
		.ARVALID(ARVALID64),
		.ARREADY(ARREADY64),

		// Read Data Channel
		.RID(RID64),
		.RDATA(RDATA64),
		.RRESP(RRESP64),
		.RLAST(RLAST64),
		.RVALID(RVALID64),
		.RREADY(RREADY64)
);

Converter64to32 Convert64to32
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWADDR64(AWADDR64),
		.AWLEN64(AWLEN64),
		.AWSIZE64(AWSIZE64),
		.AWBURST64(AWBURST64),
		.AWVALID64(AWVALID64),
		.AWREADY64(AWREADY64),

		.WDATA64(WDATA64),
		.WSTRB64(WSTRB64),
		.WLAST64(WLAST64),
		.WVALID64(WVALID64),
		.WREADY64(WREADY64),

		.BRESP64(BRESP64),
		.BVALID64(BVALID64),
		.BREADY64(BREADY64),

		.ARADDR64(ARADDR64),
		.ARLEN64(ARLEN64),
		.ARSIZE64(ARSIZE64),
		.ARBURST64(ARBURST64),
		.ARVALID64(ARVALID64),
		.ARREADY64(ARREADY64),

		.RDATA64(RDATA64),
		.RRESP64(RRESP64),
		.RLAST64(RLAST64),
		.RVALID64(RVALID64),
		.RREADY64(RREADY64),

		.AWADDR32(AWADDR32),
		.AWLEN32(AWLEN32),
		.AWSIZE32(AWSIZE32),
		.AWBURST32(AWBURST32),
		.AWVALID32(AWVALID32),
		.AWREADY32(AWREADY32),

		.WDATA32(WDATA32),
		.WSTRB32(WSTRB32),
		.WLAST32(WLAST32),
		.WVALID32(WVALID32),
		.WREADY32(WREADY32),

		.BRESP32(BRESP32),
		.BVALID32(BVALID32),
		.BREADY32(BREADY32),

		.ARADDR32(ARADDR32),
		.ARLEN32(ARLEN32),
		.ARSIZE32(ARSIZE32),
		.ARBURST32(ARBURST32),
		.ARVALID32(ARVALID32),
		.ARREADY32(ARREADY32),

		.RDATA32(RDATA32),
		.RRESP32(RRESP32),
		.RLAST32(RLAST32),
		.RVALID32(RVALID32),
		.RREADY32(RREADY32)
);

assign RID64 = 0;
assign BID64 = 0;
assign ARID32 = 0;
assign AWID32 = 0;
assign WID32 = 0;


wire [31:0] MEMADDR;
wire [31:0] MEMRDATA;
wire [31:0] MEMWDATA;
wire        MEMCEn;
wire [3:0]  MEMWEn;
IntSRAMController IntSRAMController
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWID32),
		.AWADDR(AWADDR32),
		.AWLEN(AWLEN32),
		.AWSIZE(AWSIZE32),
		.AWBURST(AWBURST32),
		.AWVALID(AWVALID32),
		.AWREADY(AWREADY32),

		.WID(WID32),
		.WDATA(WDATA32),
		.WSTRB(WSTRB32),
		.WLAST(WLAST32),
		.WVALID(WVALID32),
		.WREADY(WREADY32),

		.BID(BID32),
		.BRESP(BRESP32),
		.BVALID(BVALID32),
		.BREADY(BREADY32),

		.ARID(ARID32),
		.ARADDR(ARADDR32),
		.ARLEN(ARLEN32),
		.ARSIZE(ARSIZE32),
		.ARBURST(ARBURST32),
		.ARVALID(ARVALID32),
		.ARREADY(ARREADY32),

		// Read Data Channel
		.RID(RID32),
		.RDATA(RDATA32),
		.RRESP(RRESP32),
		.RLAST(RLAST32),
		.RVALID(RVALID32),
		.RREADY(RREADY32),

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

