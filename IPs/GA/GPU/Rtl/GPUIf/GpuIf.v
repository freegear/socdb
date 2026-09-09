
module GpuIf (
				ACLK,
				ARESETn,

				PADDR,
				PWRITE,
				PSEL,
				PENABLE,
				PWDATA,
				PRDATA,

				GpuEndInt,
				GpuErrInt,

				AWID,
				AWADDR,
				AWLEN,
				AWSIZE,
				AWBURST,
				AWLOCK,
				AWCACHE,
				AWPROT,
				AWVALID,
				AWREADY,

				WID,
				WDATA,
				WSTRB,
				WLAST,
				WVALID,
				WREADY,

				BID,
				BRESP,
				BVALID,
				BREADY,

				ARID,
				ARADDR,
				ARLEN,
				ARSIZE,
				ARBURST,
				ARLOCK,
				ARCACHE,
				ARPROT,
				ARVALID,
				ARREADY,

				RID,
				RDATA,
				RRESP,
				RLAST,
				RVALID,
				RREADY,

				DMA0RDataValid,
				DMA0RData,
				DMA0RCmdAck,
				DMA0RCmd,
				DMA0RBurstLen,
				DMA0RAddr,
				DMA0ByteEn,
				
				DMA1RDataValid,
				DMA1RData,
				DMA1RCmdAck,
				DMA1RCmd,
				DMA1RBurstLen,
				DMA1RAddr,
				DMA1ByteEn,
				
				DMA2RDataValid,
				DMA2RData,
				DMA2RCmdAck,
				DMA2RCmd,
				DMA2RBurstLen,
				DMA2RAddr,
				DMA2ByteEn,
				
				DMA3RDataValid,
				DMA3RData,
				DMA3RCmdAck,
				DMA3RCmd,
				DMA3RBurstLen,
				DMA3RAddr,
				DMA3ByteEn,
							
				DnEnable,
				DnAddr,
				DnData,
				DnRData,
				DnWrite,
				
				GpuReset,
				
				SPRCs, 
				SPRWrite,
				SPRAddr,
				SPRDataIn, 
				SPRDataOut
);

`include "GpuPara.v"

input			ACLK;
input			ARESETn;

// AXI APB Slave Interface
input  [ 9:2] 	PADDR;
input         	PWRITE;
input         	PSEL;
input         	PENABLE;
input  [31:0] 	PWDATA;
output [31:0] 	PRDATA;

output			GpuEndInt;
output			GpuErrInt;
				
// AXI Master Interface
output [IW:0] 	AWID;
output [31:0] 	AWADDR;
output [3:0] 	AWLEN;
output [2:0] 	AWSIZE;
output [1:0] 	AWBURST;
output [1:0] 	AWLOCK;
output [3:0] 	AWCACHE;
output [2:0] 	AWPROT;
output 			AWVALID;
input 			AWREADY;

output [IW:0] 	WID;
output [DW:0] 	WDATA;
output [BW:0]   WSTRB;
output          WLAST;
output 			WVALID;
input 			WREADY;

input [IW:0] 	BID;
input [1:0] 	BRESP;
input 			BVALID;
output 			BREADY;

output [IW:0] 	ARID;
output [31:0] 	ARADDR;
output [3:0] 	ARLEN;
output [2:0] 	ARSIZE;
output [1:0] 	ARBURST;
output [1:0] 	ARLOCK;
output [3:0] 	ARCACHE;
output [2:0] 	ARPROT;
output 			ARVALID;
input 			ARREADY;

input [IW:0]  	RID;
input [DW:0] 	RDATA;
input [1:0] 	RRESP;
input 			RLAST;
input 			RVALID;
output 			RREADY;

// Read DMA Arbiter Interface
output			DMA0RDataValid;
output [BW:0]	DMA0ByteEn;
output [DW:0]	DMA0RData;
output			DMA0RCmdAck;
input			DMA0RCmd;
input [ 4:0]	DMA0RBurstLen;
input [31:0]	DMA0RAddr;

output 			DMA1RDataValid;
output [BW:0]	DMA1ByteEn;
output [DW:0]	DMA1RData;
output 			DMA1RCmdAck;
input			DMA1RCmd;
input   [ 4:0]	DMA1RBurstLen;
input   [31:0]	DMA1RAddr;

output  		DMA2RDataValid;
output [BW:0]	DMA2ByteEn;
output [DW:0]	DMA2RData;
output  		DMA2RCmdAck;
input			DMA2RCmd;
input    [ 4:0]	DMA2RBurstLen;
input    [31:0]	DMA2RAddr;

output  		DMA3RDataValid;
output [BW:0]	DMA3ByteEn;
output [DW:0]	DMA3RData;
output  		DMA3RCmdAck;
input			DMA3RCmd;
input    [ 4:0]	DMA3RBurstLen;
input    [31:0]	DMA3RAddr;

// Queue Memory Interface(Download)
output			DnEnable;
output	[10:0]	DnAddr;
output	[31:0]	DnData;
input	[31:0]	DnRData;
output			DnWrite;

output			GpuReset;

// GPU SPR Interface
input			SPRCs; 
input			SPRWrite;
input	[31:0]	SPRAddr; 
input	[31:0]	SPRDataIn; 
output	[31:0]	SPRDataOut;
//-------------------------------------------------------------------------------
wire			gwr;
wire	[31:0] 	gwaddr;
wire	[4:0] 	gwsize; // if 0, 1byte
wire	[BW:0]  gwbe;
wire	[DW:0] 	gwdata;
wire 			gwready;
wire 			gwbusy;

wire            grd;
wire	[31:0] 	graddr;
wire	[4:0] 	grsize;
wire 	[BW:0]  grbe;
wire 	[DW:0] 	grdata;
wire 			grvalid;
wire 			grbusy; 
wire	[IW:0]	grid, grdid;
//-------------------------------------------------------------------------------
// Command Queue
wire	[3:0]	IC, EC;
wire	 		FL, EM, RF;
wire	[31:0]	CQData;
wire			CQWrite;

// Read DMA Command Buffer
wire			RE;
wire	[ 4:0]	LEN; 
wire			ED;
wire	[31:0]	RSA;

wire			CBRead;
wire 	[31:0]	CBData;
wire			CBEmpty;

// Read DMA Arbiter
wire			DMARDataValid;
wire 	[DW:0]	DMARData;
wire			DMARCmdAck;
wire			DMARCmd;
wire 	[ 4:0]	DMARBurstLen;
wire 	[31:0]	DMARAddr;
//-------------------------------------------------------------------------------
// AXI APB Slave
GpuReg GpuReg (
				.ACLK			(ACLK),
				.ARESETn		(ARESETn),
    			.PSEL			(PSEL), 
    			.PENABLE		(PENABLE), 
    			.PADDR			(PADDR), 
    			.PWRITE			(PWRITE), 
    			.PWDATA			(PWDATA), 
				.PRDATA			(PRDATA),
				
				.IC				(IC), 
				.EC				(EC), 
				.FL				(FL), 
				.EM				(EM), 
				.RF				(RF),
				.CQWrite		(CQWrite), 
				.CQData			(CQData),

				.RE				(RE), 
				.LEN			(LEN), 
				.ED				(ED), 
				
				.DnEnable		(DnEnable), 
				.DnWrite		(DnWrite), 
				.DnAddr			(DnAddr), 
				.DnData			(DnData),
				.DnRData		(DnRData),

				.GpuReset		(GpuReset),
				
				.EndInt			(GpuEndInt), 
				.ErrInt 		(GpuErrInt)
);
//-------------------------------------------------------------------------------
// AXI Master Write DMA Interface
ga_axiw ga_axiw (
	  			.clk    		(ACLK),
	  			.rstb   		(ARESETn),
	  			        		
	  			.AWID   		(AWID),
	  			.AWADDR 		(AWADDR),
	  			.AWLEN  		(AWLEN),
	  			.AWSIZE 		(AWSIZE),
	  			.AWBURST		(AWBURST),
	  			.AWLOCK 		(AWLOCK),
	  			.AWCACHE		(AWCACHE),
	  			.AWPROT 		(AWPROT),
	  			.AWVALID		(AWVALID),
	  			.AWREADY		(AWREADY),
	  			        		
	  			.WID    		(WID),
	  			.WDATA  		(WDATA),
	  			.WSTRB  		(WSTRB),
	  			.WLAST  		(WLAST),
	  			.WVALID 		(WVALID),
	  			.WREADY 		(WREADY),
	  			        		
	  			.BID    		(BID),
	  			.BRESP  		(BRESP),
	  			.BVALID 		(BVALID),
	  			.BREADY 		(BREADY),
	  			        		
	  			.gwr    		(gwr),
	  			.gwaddr 		(gwaddr),
	  			.gwsize 		(gwsize),
	  			.gwbe   		(gwbe),
	  			.gwdata 		(gwdata),
	  			.gwready		(gwready),
	  			.gwbusy 		(gwbusy)
);
//-------------------------------------------------------------------------------
// AXI Master Read DMA Interface
ga_axir ga_axir (
				.clk    		(ACLK),
				.rstb   		(ARESETn),
				        		
				.ARID   		(ARID),
				.ARADDR 		(ARADDR),
				.ARLEN  		(ARLEN),
				.ARSIZE 		(ARSIZE),
				.ARBURST		(ARBURST),
				.ARLOCK 		(ARLOCK),
				.ARCACHE		(ARCACHE),
				.ARPROT 		(ARPROT),
				.ARVALID		(ARVALID),
				.ARREADY		(ARREADY),
				        		
				.RID    		(RID),
				.RDATA  		(RDATA),
				.RRESP  		(RRESP),
				.RLAST  		(RLAST),
				.RVALID 		(RVALID),
				.RREADY 		(RREADY),
				        		
				.grd    		(grd),
				.graddr 		(graddr),
				.grid			(grid),
				.grdid			(grdid),
				.grsize 		(grsize),
				.grbe   		(grbe),
				.grdata 		(grdata),
				.grvalid		(grvalid),
				.grbusy 		(grbusy)
);
//-------------------------------------------------------------------------------
// Read DMA Arbiter
GpuRDmaArb GpuRDmaArb(
				.nRST			(ARESETn), 
				.Clk 			(ACLK),
        		
				.Req0			(DMA0RCmd),
				.Ack0			(DMA0RCmdAck),
				.Valid0			(DMA0RDataValid), 
				.BLen0			(DMA0RBurstLen), 
				.Addr0			(DMA0RAddr),
				.ByteEn0		(DMA0ByteEn),
				
				.Req1			(DMA1RCmd), 
				.Ack1			(DMA1RCmdAck),
				.Valid1			(DMA1RDataValid), 
				.BLen1			(DMA1RBurstLen), 
				.Addr1			(DMA1RAddr),
				.ByteEn1		(DMA1ByteEn),
				            	
				.Req2			(DMA2RCmd), 
				.Ack2			(DMA2RCmdAck),
				.Valid2			(DMA2RDataValid), 
				.BLen2			(DMA2RBurstLen), 
				.Addr2			(DMA2RAddr),
				.ByteEn2		(DMA2ByteEn),
				            	
				.Req3			(DMA3RCmd), 
				.Ack3			(DMA3RCmdAck),
				.Valid3			(DMA3RDataValid), 
				.BLen3			(DMA3RBurstLen), 
				.Addr3			(DMA3RAddr),
				.ByteEn3		(DMA3ByteEn),
 				            	
				.Req4			(DMARCmd), 
				.Ack4			(DMARCmdAck),
				.Valid4			(DMARDataValid), 
				.BLen4			(DMARBurstLen), 
				.Addr4			(DMARAddr),

				.RdData0		(DMA0RData), 
				.RdData1		(DMA1RData), 
				.RdData2		(DMA2RData), 
				.RdData3		(DMA3RData), 
				.RdData4		(DMARData), 
         		
				.ValidID		(grdid), 
				.Valid  		(grvalid), 
				.RdData 		(grdata),
				.RdReq  		(grd), 
				.RdAck			(grbusy),
				.ReqID			(grid), 
				.Addr  			(graddr), 
				.BLen			(grsize),
				.ByteEn			(grbe)
);
//-------------------------------------------------------------------------------
// Read DMA for Command Buffer
GpuRDma GpuRDma (
				.Clk			(ACLK), 
				.nRST			(ARESETn),
				.FIFOClear		(1'b0),
				
				.CBClear		(CQRead),

				.CBStartAddr	(RSA),
				.CBSize			(LEN),
				.CBDmaEn		(RE),

				.DMARDataValid	(DMARDataValid),
				.DMARData		(DMARData),
				.DMARCmd		(DMARCmd),
				.DMARCmdAck		(DMARCmdAck),
				.DMARBurstLen	(DMARBurstLen),
				.DMARAddr		(DMARAddr),
				
				.CBReadRequest	(CBRead),
				.CBReadData		(CBData),
				.CBEmpty		(CBEmpty)
);
//-------------------------------------------------------------------------------
// GPU Register & Command Queue
OR1200Reg OR1200Reg (
				.Clk			(ACLK), 
				.nRST 			(ARESETn),

				.SPRCs			(SPRCs), 
				.SPRWrite		(SPRWrite), 
				.SPRAddr		(SPRAddr), 
				.SPRDataIn		(SPRDataIn), 
				.SPRDataOut		(SPRDataOut),
				
				.CQWrite		(CQWrite), 
				.CQWrData		(CQData), 
				.CQFull			(FL), 
				.CQEmpty		(EM),
				.CQRead			(CQRead),

				.CBRead			(CBRead),
				.CBData			(CBData),
				.CBEmpty		(CBEmpty),

				.RSA			(RSA),
				.RE				(RE), 
				.LEN			(LEN)
);
//-------------------------------------------------------------------------------

endmodule
