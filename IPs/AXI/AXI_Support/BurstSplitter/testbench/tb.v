/*****************************************************************
		         TestMaster Simple testbench
*****************************************************************/
`timescale 1 ns/ 10ps
module tb;

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

wire [WID_WIDTH-1:0]  AWID_M;
wire [31:0]           AWADDR_M;
wire [3:0]            AWLEN_M;
wire [2:0]            AWSIZE_M;
wire [1:0]            AWBURST_M;
wire                  AWVALID_M;
wire                  AWREADY_M;

wire [WID_WIDTH-1:0]  WID_M;
wire [DATA_WIDTH-1:0] WDATA_M;
wire [NUM_BYTE-1:0]   WSTRB_M;
wire                  WLAST_M;
wire                  WVALID_M;
wire                  WREADY_M;

wire [WID_WIDTH-1:0]  BID_M;
wire [1:0]            BRESP_M;
wire                  BVALID_M;
wire                  BREADY_M;

wire [RID_WIDTH-1:0]  ARID_M;
wire [31:0]           ARADDR_M;
wire [3:0]            ARLEN_M;
wire [2:0]            ARSIZE_M;
wire [1:0]            ARBURST_M;
wire                  ARVALID_M;
wire                  ARREADY_M;

wire [RID_WIDTH-1:0]  RID_M;
wire [DATA_WIDTH-1:0] RDATA_M;
wire [1:0]            RRESP_M;
wire                  RLAST_M;
wire                  RVALID_M;
wire                  RREADY_M;

wire [WID_WIDTH-1:0]  AWID_S;
wire [31:0]           AWADDR_S;
wire [3:0]            AWLEN_S;
wire [2:0]            AWSIZE_S;
wire [1:0]            AWBURST_S;
wire                  AWVALID_S;
wire                  AWREADY_S;

wire [WID_WIDTH-1:0]  WID_S;
wire [DATA_WIDTH-1:0] WDATA_S;
wire [NUM_BYTE-1:0]   WSTRB_S;
wire                  WLAST_S;
wire                  WVALID_S;
wire                  WREADY_S;

wire [WID_WIDTH-1:0]  BID_S;
wire [1:0]            BRESP_S;
wire                  BVALID_S;
wire                  BREADY_S;

wire [RID_WIDTH-1:0]  ARID_S;
wire [31:0]           ARADDR_S;
wire [3:0]            ARLEN_S;
wire [2:0]            ARSIZE_S;
wire [1:0]            ARBURST_S;
wire                  ARVALID_S;
wire                  ARREADY_S;

wire [RID_WIDTH-1:0]  RID_S;
wire [DATA_WIDTH-1:0] RDATA_S;
wire [1:0]            RRESP_S;
wire                  RLAST_S;
wire                  RVALID_S;
wire                  RREADY_S;


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

		.AWID(AWID_M),
		.AWADDR(AWADDR_M),
		.AWLEN(AWLEN_M),
		.AWSIZE(AWSIZE_M),
		.AWBURST(AWBURST_M),
		.AWLOCK(),
		.AWCACHE(),
		.AWPROT(),
		.AWVALID(AWVALID_M),
		.AWREADY(AWREADY_M),

		.WID(WID_M),
		.WDATA(WDATA_M),
		.WSTRB(WSTRB_M),
		.WLAST(WLAST_M),
		.WVALID(WVALID_M),
		.WREADY(WREADY_M),

		.BID(BID_M),
		.BRESP(BRESP_M),
		.BVALID(BVALID_M),
		.BREADY(BREADY_M),

		.ARID(ARID_M),
		.ARADDR(ARADDR_M),
		.ARLEN(ARLEN_M),
		.ARSIZE(ARSIZE_M),
		.ARBURST(ARBURST_M),
		.ARLOCK(),
		.ARCACHE(),
		.ARPROT(),
		.ARVALID(ARVALID_M),
		.ARREADY(ARREADY_M),

		// Read Data Channel
		.RID(RID_M),
		.RDATA(RDATA_M),
		.RRESP(RRESP_M),
		.RLAST(RLAST_M),
		.RVALID(RVALID_M),
		.RREADY(RREADY_M)
);

BurstSplitter BurstSplitter
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID_M(AWID_M),
		.AWADDR_M(AWADDR_M),
		.AWLEN_M(AWLEN_M),
//		.AWSIZE(AWSIZE_M),
		.AWBURST_M(AWBURST_M),
		.AWVALID_M(AWVALID_M),
		.AWREADY_M(AWREADY_M),

		.WID_M(WID_M),
		.WDATA_M(WDATA_M),
		.WSTRB_M(WSTRB_M),
		.WLAST_M(WLAST_M),
		.WVALID_M(WVALID_M),
		.WREADY_M(WREADY_M),

		.BID_M(BID_M),
		.BRESP_M(BRESP_M),
		.BVALID_M(BVALID_M),
		.BREADY_M(BREADY_M),

		.ARID_M(ARID_M),
		.ARADDR_M(ARADDR_M),
		.ARLEN_M(ARLEN_M),
//		.ARSIZE(ARSIZE_M),
		.ARBURST_M(ARBURST_M),
		.ARVALID_M(ARVALID_M),
		.ARREADY_M(ARREADY_M),

		// Read Data Channel
		.RID_M(RID_M),
		.RDATA_M(RDATA_M),
		.RRESP_M(RRESP_M),
		.RLAST_M(RLAST_M),
		.RVALID_M(RVALID_M),
		.RREADY_M(RREADY_M),

		.AWID_S(AWID_S),
		.AWADDR_S(AWADDR_S),
		.AWLEN_S(AWLEN_S),
//		.AWSIZE(AWSIZE_S),
		.AWBURST_S(AWBURST_S),
		.AWVALID_S(AWVALID_S),
		.AWREADY_S(AWREADY_S),

		.WID_S(WID_S),
		.WDATA_S(WDATA_S),
		.WSTRB_S(WSTRB_S),
		.WLAST_S(WLAST_S),
		.WVALID_S(WVALID_S),
		.WREADY_S(WREADY_S),

		.BID_S(BID_S),
		.BRESP_S(BRESP_S),
		.BVALID_S(BVALID_S),
		.BREADY_S(BREADY_S),

		.ARID_S(ARID_S),
		.ARADDR_S(ARADDR_S),
		.ARLEN_S(ARLEN_S),
//		.ARSIZE(ARSIZE_S),
		.ARBURST_S(ARBURST_S),
		.ARVALID_S(ARVALID_S),
		.ARREADY_S(ARREADY_S),

		// Read Data Channel
		.RID_S(RID_S),
		.RDATA_S(RDATA_S),
		.RRESP_S(RRESP_S),
		.RLAST_S(RLAST_S),
		.RVALID_S(RVALID_S),
		.RREADY_S(RREADY_S)
);

wire [31:0] MEMADDR;
wire [31:0] MEMRDATA;
wire [31:0] MEMWDATA;
wire        MEMCEn;
wire [3:0]  MEMWEn;
IntSRAMController IntSRAMController
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWID_S),
		.AWADDR(AWADDR_S),
		.AWLEN(AWLEN_S),
		.AWSIZE(`SIZE_WORD),
		.AWBURST(AWBURST_S),
		.AWVALID(AWVALID_S),
		.AWREADY(AWREADY_S),

		.WID(WID_S),
		.WDATA(WDATA_S),
		.WSTRB(WSTRB_S),
		.WLAST(WLAST_S),
		.WVALID(WVALID_S),
		.WREADY(WREADY_S),

		.BID(BID_S),
		.BRESP(BRESP_S),
		.BVALID(BVALID_S),
		.BREADY(BREADY_S),

		.ARID(ARID_S),
		.ARADDR(ARADDR_S),
		.ARLEN(ARLEN_S),
		.ARSIZE(`SIZE_WORD),
		.ARBURST(ARBURST_S),
		.ARVALID(ARVALID_S),
		.ARREADY(ARREADY_S),

		// Read Data Channel
		.RID(RID_S),
		.RDATA(RDATA_S),
		.RRESP(RRESP_S),
		.RLAST(RLAST_S),
		.RVALID(RVALID_S),
		.RREADY(RREADY_S),

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

