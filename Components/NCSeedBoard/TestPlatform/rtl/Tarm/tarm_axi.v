// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : tarm_axi.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : toy arm with AXI interface.
//  =============================================================================

`timescale 1ns/1ps

module tarm_axi 
(
		ACLK     , 
		ARESETn  , 

		// Interrupt
		ARMnFIQ  ,
		ARMnIRQ  ,

		// Write Address Channel
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
		WDATA    ,
		WSTRB    ,
		WLAST    ,
		WVALID   ,
		WREADY   ,

		// Write Response Channel
		BRESP    ,
		BVALID   ,
		BREADY   ,

		// Read Address Channel
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
		RDATA    ,
		RRESP    ,
		RLAST    ,
		RVALID   ,
		RREADY
);

//
// input/output port
//
input         ACLK;
input         ARESETn;

input         ARMnFIQ;
input         ARMnIRQ;

output [31:0] AWADDR;
output [3:0]  AWLEN;
output [2:0]  AWSIZE;
output [1:0]  AWBURST;
output [1:0]  AWLOCK;
output [3:0]  AWCACHE;
output [2:0]  AWPROT;
output        AWVALID;
input         AWREADY;

output [31:0] WDATA;
output [3:0]  WSTRB;
output        WLAST;
output        WVALID;
input         WREADY;


input  [1:0]  BRESP;
input         BVALID;
output        BREADY;

output [31:0] ARADDR;
output [3:0]  ARLEN;
output [2:0]  ARSIZE;
output [1:0]  ARBURST;
output [1:0]  ARLOCK;
output [3:0]  ARCACHE;
output [2:0]  ARPROT;
output        ARVALID;
input         ARREADY;

input  [31:0] RDATA;
input  [1:0]  RRESP;
input         RLAST;
input         RVALID;
output        RREADY;


wire [31:0] HADDR;
wire [ 1:0] HTRANS;
wire        HWRITE;
wire [2:0]  HSIZE;
wire [2:0]  HBURST;
wire [3:0]  HPROT;
wire [31:0] HWDATA;
wire [31:0] HRDATA;
wire        HREADY_IN;
wire        HREADY_OUT;
wire [1:0]  HRESP;

wire        HSEL;
reg         HMASTLOCK;

wire        HBUSREQ;
wire        HGRANT;
wire        HLOCK;

reg         HBUSREQ_ff;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		HBUSREQ_ff <= 0;
	else
	begin
		HBUSREQ_ff <= HBUSREQ;
		if(HBUSREQ && !HBUSREQ_ff)	// rising edge of BUSREQ
			HMASTLOCK <= HLOCK;
	end
end

assign HGRANT = 1'b1;
assign HREADY_IN = HREADY_OUT;
assign HSEL = 1'b1;

cpu uCPU	// toyARM
(
    .rstcore  (ARESETn),
    .rstcache (ARESETn),
    .clk      (ACLK), 
    .bigend   (1'b0),
    .hivecs   (1'b0),

    .nfiq     (ARMnFIQ), 
    .nirq     (ARMnIRQ), 

    .hbusreq  (HBUSREQ), 
    .hgrant   (HGRANT),	

    .haddr    (HADDR), 
    .htrans   (HTRANS), 
    .hwrite   (HWRITE), 
    .hsize	  (HSIZE),    
    .hburst   (HBURST),
    .hlock    (HLOCK), 
    .hprot    (HPROT),

    .hready   (HREADY_OUT), 

    .hresp    (HRESP), 

    .hwdata   (HWDATA), 
    .hrdata   (HRDATA)
);

AHB2AXIBridge AHB2AXIBridge
(
		.CLK(ACLK),
		.RESETn(ARESETn),

		.HADDR(HADDR),
		.HTRANS(HTRANS),
		.HWRITE(HWRITE),
		.HSIZE(HSIZE),
		.HBURST(HBURST),
		.HPROT(HPROT),
		.HWDATA(HWDATA),
		.HRDATA(HRDATA),
		.HREADY_IN(HREADY_IN),
		.HREADY_OUT(HREADY_OUT),
		.HRESP(HRESP),

		.HSEL(HSEL),
		.HMASTLOCK(HMASTLOCK),

		.AWADDR(AWADDR),
		.AWLEN(AWLEN),
		.AWSIZE(AWSIZE),
		.AWBURST(AWBURST),
		.AWLOCK(AWLOCK),
		.AWCACHE(AWCACHE),
		.AWPROT(AWPROT),
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
		.ARLOCK(ARLOCK),
		.ARCACHE(ARCACHE),
		.ARPROT(ARPROT),
		.ARVALID(ARVALID),
		.ARREADY(ARREADY),

		.RDATA(RDATA),
		.RRESP(RRESP),
		.RLAST(RLAST),
		.RVALID(RVALID),
		.RREADY(RREADY)
);

endmodule
