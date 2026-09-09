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

wire [WID_WIDTH-1:0]  AWID;
wire [31:0]           AWADDR;
wire [3:0]            AWLEN;
wire [2:0]            AWSIZE;
wire [1:0]            AWBURST;
wire                  AWVALID;
wire                  AWREADY;

wire [WID_WIDTH-1:0]  WID;
wire [DATA_WIDTH-1:0] WDATA;
wire [NUM_BYTE-1:0]   WSTRB;
wire                  WLAST;
wire                  WVALID;
wire                  WREADY;

wire [WID_WIDTH-1:0]  BID;
wire [1:0]            BRESP;
wire                  BVALID;
wire                  BREADY;

wire [RID_WIDTH-1:0]  ARID;
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

		.AWID(AWID),
		.AWADDR(AWADDR),
		.AWLEN(AWLEN),
		.AWSIZE(AWSIZE),
		.AWBURST(AWBURST),
		.AWLOCK(),
		.AWCACHE(),
		.AWPROT(),
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
		.ARLOCK(),
		.ARCACHE(),
		.ARPROT(),
		.ARVALID(ARVALID),
		.ARREADY(ARREADY),

		// Read Data Channel
		.RID(RID),
		.RDATA(RDATA),
		.RRESP(RRESP),
		.RLAST(RLAST),
		.RVALID(RVALID),
		.RREADY(RREADY)
);

wire [31:0] PADDR;
wire        PWRITE;
wire        PSEL0;
wire        PSEL1;
wire        PSEL2;
wire        PSEL3;
wire        PENABLE;
wire [31:0] PRDATA0;
wire [31:0] PRDATA1;
wire [31:0] PRDATA2;
wire [31:0] PRDATA3;
wire [31:0] PWDATA;
wire        PREADY0;
wire        PREADY1;
wire        PREADY2;
wire        PREADY3;

AXI2APBBridge_PREADY AXI2APBBridge
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
//		.WSTRB(WSTRB),
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

		.PADDR(PADDR[31:0]),
		.PWRITE(PWRITE),
		.PSEL0(PSEL0),
		.PSEL1(PSEL1),
		.PSEL2(PSEL2),
		.PSEL3(PSEL3),
		.PENABLE(PENABLE),
		.PRDATA0(PRDATA0),
		.PRDATA1(PRDATA1),
		.PRDATA2(PRDATA2),
		.PRDATA3(PRDATA3),
		.PREADY0(PREADY0),
		.PREADY1(PREADY1),
		.PREADY2(PREADY2),
		.PREADY3(PREADY3),
		.PWDATA(PWDATA)
);

APB_SRAM #(12) SRAM0
(
		.PCLK(ACLK),
		.PRESETn(ARESETn),
		.PENABLE(PENABLE),
		.PSEL(PSEL0),
		.PWRITE(PWRITE),
		.PADDR(PADDR[12+1:2]),
		.PWDATA(PWDATA),
		.PRDATA(PRDATA0),
		.PREADY(PREADY0)
);

APB_SRAM #(12) SRAM1
(
		.PCLK(ACLK),
		.PRESETn(ARESETn),
		.PENABLE(PENABLE),
		.PSEL(PSEL1),
		.PWRITE(PWRITE),
		.PADDR(PADDR[12+1:2]),
		.PWDATA(PWDATA),
		.PRDATA(PRDATA1),
		.PREADY(PREADY1)
);

APB_SRAM #(12) SRAM2
(
		.PCLK(ACLK),
		.PRESETn(ARESETn),
		.PENABLE(PENABLE),
		.PSEL(PSEL2),
		.PWRITE(PWRITE),
		.PADDR(PADDR[12+1:2]),
		.PWDATA(PWDATA),
		.PRDATA(PRDATA2),
		.PREADY(PREADY2)
);

APB_SRAM #(12) SRAM3
(
		.PCLK(ACLK),
		.PRESETn(ARESETn),
		.PENABLE(PENABLE),
		.PSEL(PSEL3),
		.PWRITE(PWRITE),
		.PADDR(PADDR[12+1:2]),
		.PWDATA(PWDATA),
		.PRDATA(PRDATA3),
		.PREADY(PREADY3)
);

endmodule

