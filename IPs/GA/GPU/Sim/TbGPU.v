
`timescale 1ns/10ps

module TbGPU;

parameter CKP1 = 3.76;

parameter DLY  = 0.2;

parameter II = 4-1;		// ID Width
parameter DD = 32-1;	// Data Width
parameter BB = 4-1;		// Byte Width

reg	 Clk, nRST;
wire ACLK = Clk;
wire ARESETn = nRST;
wire ARESETB = nRST;

reg  [II:0] AWID;
reg  [31:0] AWADDR;
reg  [3:0]  AWLEN;
reg  [2:0]  AWSIZE;
reg  [1:0]  AWBURST;
reg         AWVALID;
wire        AWREADY;

reg  [II:0] WID;
reg  [DD:0] WDATA;
reg  [BB:0] WSTRB;
wire        WLAST;
reg         WVALID;
wire        WREADY;

wire [II:0] BID;
wire [1:0]  BRESP;
wire        BVALID;
reg         BREADY;

wire [II:0] ARID;
wire [31:0] ARADDR;
wire [3:0]  ARLEN;
wire [2:0]  ARSIZE;
wire [1:0]  ARBURST;
wire        ARVALID;
wire        ARREADY;

wire [II:0] RID;
wire [DD:0] RDATA;
wire [1:0]  RRESP;
wire        RLAST;
wire        RVALID;
wire        RREADY;

wire [II:0]  ARID64;
wire [31:0]  ARADDR64;
wire [3:0]   ARLEN64;
wire [2:0]   ARSIZE64;
wire [1:0]   ARBURST64;
wire         ARVALID64;
wire         ARREADY64;

wire [II:0]  RID64;
wire [63:0]  RDATA64;
wire [1:0]   RRESP64;
wire         RLAST64;
wire         RVALID64;
wire         RREADY64;

reg         PENABLE;
reg  [ 1:0] PSEL;
reg         PWRITE;
reg  [ 9:2] PADDR;
reg  [31:0] PWDATA;
wire [31:0] PRDATA;

// Read DMA Arbiter Interface
wire 		DMA0RDataValid;
wire  [ 7:0]DMA0ByteEn;
wire  [63:0]DMA0RData;
wire 		DMA0RCmdAck;
wire 		DMA0RCmd = 0;
wire [ 4:0]	DMA0RBurstLen = 0;
wire [31:0]	DMA0RAddr = 0;

wire  		DMA1RDataValid;
wire  [ 7:0]DMA1ByteEn;
wire  [63:0]DMA1RData;
wire  		DMA1RCmdAck;
wire 		DMA1RCmd = 0;
wire  [ 4:0]DMA1RBurstLen = 0;
wire  [31:0]DMA1RAddr = 0;

wire   		DMA2RDataValid;
wire  [ 7:0]DMA2ByteEn;
wire  [63:0]DMA2RData;
wire   		DMA2RCmdAck;
wire 		DMA2RCmd = 0;
wire  [ 4:0]DMA2RBurstLen = 0;
wire  [31:0]DMA2RAddr = 0;

wire   		DMA3RDataValid;
wire  [ 7:0]DMA3ByteEn;
wire  [63:0]DMA3RData;
wire   		DMA3RCmdAck;
wire 		DMA3RCmd = 0;
wire  [ 4:0]DMA3RBurstLen = 0;
wire  [31:0]DMA3RAddr = 0;

// Queue Memory Interface(Download)
wire [10:0]	DnAddr;
wire [31:0]	DnData;
wire [31:0]	DnRData;
wire 		DnWrite;
wire 		DnEnable;

wire		GpuReset;

// GPU SPR Interface
wire		SPRCs; 
wire		SPRWrite;
wire [31:0]	SPRAddr; 
wire [31:0]	SPRDataIn; 
wire [31:0]	SPRDataOut;
//------------------------------------------------------------------------------
`include "./Include/AxiRWTask.v"
`include "./Include/PeriRWTask.v"
`include "./Include/GpuSim.v"
`include "./Include/GpuRegSet.v"
`include "./Include/ImageWrTask.v"
//-------------------------------------------------------------------------------
// OR1200
or1200_top	GPU(
				.clk_i				(Clk), 
				.rst_i				(GpuReset | ~nRST), 
				.pic_ints_i 		(0),

				.dn_enable			(DnEnable),
				.dn_addr			(DnAddr),
				.dn_wdat			(DnData),
				.dn_rdat			(DnRData),
				.dn_write			(DnWrite),
				
    			.spr_addr			(SPRAddr), 
    			.spr_dat_cpu		(SPRDataIn), 
    			.spr_cs_gpu			(SPRCs), 
    			.spr_we				(SPRWrite), 
    			.spr_dat_tt			(SPRDataOut)
);
//-------------------------------------------------------------------------------
// Display Module Top
GpuIf GpuIf(
   				.ACLK            	(Clk),
   				.ARESETn           	(nRST),

   				.ARID           	(ARID),
   				.ARADDR         	(ARADDR64),
   				.ARLEN          	(ARLEN64),
   				.ARSIZE         	(ARSIZE64),
   				.ARBURST        	(ARBURST64),
   				.ARLOCK         	(ARLOCK64),
   				.ARCACHE        	(ARCACHE64),
   				.ARPROT         	(ARPROT64),
   				.ARVALID        	(ARVALID64),
   				.ARREADY        	(ARREADY64),

   				.RID            	(RID),
   				.RDATA          	(RDATA64),
   				.RRESP          	(RRESP64),
   				.RLAST          	(RLAST64),
   				.RVALID         	(RVALID64),
   				.RREADY         	(RREADY64),

    			.PSEL				(PSEL[1]), 
    			.PENABLE			(PENABLE), 
    			.PADDR				(PADDR), 
    			.PWRITE				(PWRITE), 
    			.PWDATA				(PWDATA), 
				.PRDATA				(PRDATA),
				
				.DMA0RDataValid		(DMA0RDataValid),
				.DMA0RData			(DMA0RData),
				.DMA0RCmdAck		(DMA0RCmdAck),
				.DMA0RCmd			(DMA0RCmd),
				.DMA0RBurstLen		(DMA0RBurstLen),
				.DMA0RAddr			(DMA0RAddr),
				.DMA0ByteEn			(DMA0ByteEn),
				
				.DMA1RDataValid		(DMA1RDataValid),
				.DMA1RData			(DMA1RData),
				.DMA1RCmdAck		(DMA1RCmdAck),
				.DMA1RCmd			(DMA1RCmd),
				.DMA1RBurstLen		(DMA1RBurstLen),
				.DMA1RAddr			(DMA1RAddr),
				.DMA1ByteEn			(DMA1ByteEn),
				
				.DMA2RDataValid		(DMA2RDataValid),
				.DMA2RData			(DMA2RData),
				.DMA2RCmdAck		(DMA2RCmdAck),
				.DMA2RCmd			(DMA2RCmd),
				.DMA2RBurstLen		(DMA2RBurstLen),
				.DMA2RAddr			(DMA2RAddr),
				.DMA2ByteEn			(DMA2ByteEn),
				
				.DMA3RDataValid		(DMA3RDataValid),
				.DMA3RData			(DMA3RData),
				.DMA3RCmdAck		(DMA3RCmdAck),
				.DMA3RCmd			(DMA3RCmd),
				.DMA3RBurstLen		(DMA3RBurstLen),
				.DMA3RAddr			(DMA3RAddr),
				.DMA3ByteEn			(DMA3ByteEn),
							
				.DnEnable			(DnEnable),
				.DnAddr				(DnAddr),
				.DnData				(DnData),
				.DnRData			(DnRData),
				.DnWrite			(DnWrite),
				
				.GpuReset			(GpuReset),
				
				.SPRCs				(SPRCs), 
				.SPRWrite			(SPRWrite),
				.SPRAddr			(SPRAddr),
				.SPRDataIn			(SPRDataIn), 
				.SPRDataOut			(SPRDataOut)
);
//-------------------------------------------------------------------------------
Converter64to32 Gpu64to32(
				.ACLK				(ACLK),
				.ARESETn			(ARESETn),
/*
				//.AWID64				(AWID64),
				.AWADDR64			(AWADDR64),
				.AWLEN64			(AWLEN64),
				.AWSIZE64			(AWSIZE64),
				.AWBURST64			(AWBURST64),
				.AWVALID64			(AWVALID64),
				.AWREADY64			(AWREADY64),
        		            		
				//.WID64				(WID64),
				.WDATA64			(WDATA64),
				.WSTRB64			(WSTRB64),
				.WLAST64			(WLAST64),
				.WVALID64			(WVALID64),
				.WREADY64			(WREADY64),
        		            		
				//.BID64				(BID64),
				.BRESP64			(BRESP64),
				.BVALID64			(BVALID64),
				.BREADY64			(BREADY64),
				

				//.AWID32				(AWID),
				.AWADDR32			(AWADDR),
				.AWLEN32			(AWLEN),
				.AWSIZE32			(AWSIZE),
				.AWBURST32			(AWBURST),
				.AWVALID32			(AWVALID),
				.AWREADY32			(AWREADY),
        		            		
				//.WID32				(WID),
				.WDATA32			(WDATA),
				.WSTRB32			(WSTRB),
				.WLAST32			(WLAST),
				.WVALID32			(WVALID),
				.WREADY32			(WREADY),
        		            		
				//.BID32				(BID),
				.BRESP32			(BRESP),
				.BVALID32			(BVALID),
				.BREADY32			(BREADY),
*/

				.ARADDR64			(ARADDR64),
				.ARLEN64			(ARLEN64),
				.ARSIZE64			(ARSIZE64),
				.ARBURST64			(ARBURST64),
				.ARVALID64			(ARVALID64),
				.ARREADY64			(ARREADY64),
				            		
				.RDATA64			(RDATA64),
				.RRESP64			(RRESP64),
				.RLAST64			(RLAST64),
				.RVALID64			(RVALID64),
				.RREADY64			(RREADY64),
				            		
				.ARADDR32			(ARADDR),
				.ARLEN32			(ARLEN),
				.ARSIZE32			(ARSIZE),
				.ARBURST32			(ARBURST),
				.ARVALID32			(ARVALID),
				.ARREADY32			(ARREADY),
				            		
				.RDATA32			(RDATA),
				.RRESP32			(RRESP),
				.RLAST32			(RLAST),
				.RVALID32			(RVALID),
				.RREADY32			(RREADY)
);
//-------------------------------------------------------------------------------
wire [31:0] MEMADDR;
wire [DD:0] MEMRDATA;
wire [DD:0] MEMWDATA;
wire        MEMCEn;
wire [BB:0] MEMWEn;

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

SSRAM32bit #(24) SRAM
(
		.CLK(ACLK),
		.ADDR(MEMADDR[23:0]),
		.CEn(MEMCEn),
		.WEn(MEMWEn),
		.RDATA(MEMRDATA),
		.WDATA(MEMWDATA)
);
//-------------------------------------------------------------------------------
always #CKP1 Clk = ~Clk;
//-------------------------------------------------------------------------------
// Initialize
initial begin
  nRST   = 1;
  Clk    = 0;
end
//-------------------------------------------------------------------------------
// Main Routine
initial begin
  	repeat(10) @(posedge Clk);
    nRST = 1'b0;
  	repeat(10) @(posedge Clk);
  	#(3) nRST = 1'b1;
  	$display ("Reset Disabled, Simulation Start NOW >>>");

  	GpuRegSet;	// GPU Register Set

  	CmdBW;		// Main Memory Write for Command Buffer Write
  	
  				// GPU Process
  	
	//while (GpuIf.			
  	repeat(3000) @(posedge Clk);
  	$stop;
end
//-------------------------------------------------------------------------------
`ifdef TIMING
initial $sdf_annotate("../Syn/Sdf/GpuIf.noscan.sdf", GpuIf);
`endif
//------------------------------------------------------
`ifdef WAVE
initial begin
  $shm_open("TbGPU.shm");
  $shm_probe(TbGPU, "ASC");
end
`endif
//------------------------------------------------------
endmodule
