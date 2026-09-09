
`timescale 1ns/10ps

module DDRTop(
    		ARESETB,
    		nPOR,
    		MCLK,
    		nMCLK,
    		ACLK,
    		nACLK,
    		
			AWAddr,
			AWId,
			AWLen,
			AWValid,
			AWReady,
			AWBurst,
    		
    		WLast,
    		WStrb,
    		WData,
    		WValid,
    		WReady,
    		WId,
    		
    		BResp,
    		BValid,
    		BReady,
    		BId,
    		
			ARAddr,
			ARId,
			ARLen,
			ARValid,
			ARReady,
			ARBurst,
    		
    		RData,
    		RValid,
    		RReady,
    		RLast,
    		RId,
    		RResp,
    		
    		SD_CKE,
    		SD_CSB,
    		SD_RASB,
    		SD_CASB,
    		SD_WEB,
    		SD_BADDR,
    		SD_ADDR,
    		SD_DQE,
    		SD_DQI,
    		SD_DQO,
    		SD_DQM,
    		SD_DQSE,
    		SD_DQSO,
    		SD_DQSI,
    		nSD_DQSI,
    		
			PCLK,
			PRESETB,
    		PSEL, 
    		PENABLE, 
    		PADDR, 
    		PWRITE, 
    		PWDATA, 
			PRDATA
);


`include "DDRPara.v"

input    		ARESETB;  // asynchronous reset
input			nPOR;
input			MCLK;
input			nMCLK;
input    		ACLK;
input			nACLK;

// Write Command
input  [31:0]	AWAddr;
input  [ID:0] 	AWId;
input  [BBL:0] 	AWLen;
input	[1:0]	AWBurst;
input			AWValid;
output			AWReady;

// Write Data
input			WLast;
input  [BW:0] 	WStrb;
input  [ID:0] 	WId;
input  [DW:0] 	WData ; // data input
input			WValid;
output			WReady;

// Write Response
output [ID:0] 	BId;
output [1:0]	BResp;
input			BReady;
output			BValid;

// Read Command
input  [31:0]	ARAddr;
input  [ID:0] 	ARId;
input  [BBL:0] 	ARLen;
input	[1:0]	ARBurst;
input			ARValid;
output			ARReady;

// Read Data
input			RReady;
output			RLast;
output          RValid;
output [DW:0] 	RData;
output [ID:0] 	RId;
output [ 1:0]  	RResp;

// Register
input         	PCLK;
input         	PRESETB;
              	
input  [ 7:2] 	PADDR;
input         	PWRITE;
input         	PSEL;
input         	PENABLE;
input  [31:0] 	PWDATA;
output [31:0] 	PRDATA;

// SDRAM
output    		SD_CKE  ; // clock enable
output    		SD_CSB  ; // chip select
output    		SD_RASB ; // row address strobe
output    		SD_CASB ; // column address strobe
output    		SD_WEB  ; // write enable
output [BAW:0]  SD_BADDR; // bank address
output [RAW:0]  SD_ADDR ; // address
output    		SD_DQE; // dq output enable
input  [MDW:0]	SD_DQI; // data input
output [MDW:0] 	SD_DQO; // data output
output [DMW:0]	SD_DQM;
output			SD_DQSE;
output [DMW:0]	SD_DQSO;
input  [DMW:0]	SD_DQSI;
input  [DMW:0]	nSD_DQSI;
//-------------------------------------------------------------
// Controller
wire [14:0]   	BA_STS; // status
wire [AW:0]		BA_AA;
wire			BA_REQ;
wire [BL:0]   	BA_TT;
wire [ID:0]		BA_ID;
wire			BA_RW;
wire			BA_PM;
wire			SDREnStatus;
//-------------------------------------------------------------
wire  [31:0]	AWAddrM;
wire  [ID:0] 	AWIdM;
wire  [BBL:0] 	AWLenM;
wire	[1:0]	AWBurstM;
wire			AWValidM;
wire			AWReadyM;
wire			WLastM;
wire  [BW:0] 	WStrbM;
wire  [ID:0] 	WIdM;
wire  [DW:0] 	WDataM;
wire			WValidM;
wire			WReadyM;
wire [ID:0] 	BIdM;
wire [1:0]		BRespM;
wire			BReadyM;
wire			BValidM;

wire  [31:0]	ARAddrM;
wire  [ID:0] 	ARIdM;
wire  [BBL:0] 	ARLenM;
wire	[1:0]	ARBurstM;
wire			ARValidM;
wire			ARReadyM;
wire			RReadyM;
wire			RLastM;
wire           	RValidM;
wire [DW:0] 	RDataM;
wire [ID:0] 	RIdM;
wire [1:0]		RRespM;
//-------------------------------------------------------------
wire  [31:0]	AWAddrT;
wire  [ID:0] 	AWIdT;
wire  [BBL:0] 	AWLenT;
wire	[1:0]	AWBurstT;
wire			AWValidT;
wire			AWReadyT;
wire			WLastT;
wire  [BW:0] 	WStrbT;
wire  [ID:0] 	WIdT;
wire  [DW:0] 	WDataT;
wire			WValidT;
wire			WReadyT;
wire [ID:0] 	BIdT;
//wire [1:0]		BRespT;
wire			BReadyT;
wire			BValidT;

wire  [31:0]	ARAddrT;
wire  [ID:0] 	ARIdT;
wire  [BBL:0] 	ARLenT;
wire	[1:0]	ARBurstT;
wire			ARValidT;
wire			ARReadyT;

wire			RReadyT;
wire			RLastT;
wire          	RValidT;
wire [DW:0] 	RDataT;
wire [ID:0] 	RIdT;
//wire [ 1:0]  	RRespT;

DDRRds #(32 + 4 + 4 + 2) WCmdSlice(
		.ACLK         	(ACLK), 
		.ARESETn      	(ARESETB), 
		.INFORMATION_S	({AWAddr, AWId, AWLen, AWBurst}),
		.READY_S      	(AWReady),
		.VALID_S      	(AWValid),
		.INFORMATION_R	({AWAddrT, AWIdT, AWLenT, AWBurstT}),
		.READY_R      	(AWReadyT),
		.VALID_R      	(AWValidT)
);

DDRRds #(4 + 4 + 32) WDatSlice(
		.ACLK         	(ACLK), 
		.ARESETn      	(ARESETB), 
		.INFORMATION_S	({WStrb, WId, WData}),
		.READY_S      	(WReady),
		.VALID_S      	(WValid),
		.INFORMATION_R	({WStrbT, WIdT, WDataT}),
		.READY_R      	(WReadyT),
		.VALID_R      	(WValidT)
);

//DDRRds #(4 + 2) WRespSlice(
DDRRds #(4) WRespSlice(
		.ACLK         	(ACLK), 
		.ARESETn      	(ARESETB), 
		//.INFORMATION_S	({BIdT, BRespT}),
		.INFORMATION_S	({BIdT}),
		.READY_S      	(BReadyT),
		.VALID_S      	(BValidT),
		//.INFORMATION_R	({BId, BResp}),
		.INFORMATION_R	({BId}),
		.READY_R      	(BReady),
		.VALID_R      	(BValid)
);

DDRRds #(32 + 4 + 4 + 2) RCmdSlice(
		.ACLK         	(ACLK), 
		.ARESETn      	(ARESETB), 
		.INFORMATION_S	({ARAddr, ARId, ARLen, ARBurst}),
		.VALID_S      	(ARValid),
		.READY_S      	(ARReady),
		.INFORMATION_R	({ARAddrT, ARIdT, ARLenT, ARBurstT}),
		.VALID_R      	(ARValidT),
		.READY_R      	(ARReadyT)
);

//DDRRds #(2 + 1 + 32 + 4) RDatSlice(
DDRRds #(1 + 32 + 4) RDatSlice(
		.ACLK         	(ACLK), 
		.ARESETn      	(ARESETB), 
		//.INFORMATION_S	({RRespT, RLastT, RDataT, RIdT}),
		.INFORMATION_S	({RLastT, RDataT, RIdT}),
		.VALID_S      	(RValidT),
		.READY_S      	(RReadyT),
		.INFORMATION_R	({RLast, RData, RId}),
		.VALID_R      	(RValid),
		.READY_R      	(RReady)
);
//-------------------------------------------------------------
// AXI Burst DownSizer Bridge
DDRSpi DDRSpi(
		.ACLK			(ACLK),
		.ARESETn		(ARESETB),

        /*            	
		.AWADDR_M		(AWAddr),
		.AWLEN_M		(AWLen),
		.AWVALID_M		(AWValid),
		.AWREADY_M		(AWReady),
		.AWID_M			(AWId),
		.AWBURST_M		(AWBurst),
	                	
		.WLAST_M		(WLast),
		.WSTRB_M  		(WStrb),
		.WDATA_M   		(WData),
		.WVALID_M		(WValid),
		.WREADY_M		(WReady),
		.WID_M			(WId),
                    	
		.BRESP_M 		(BResp),
    	.BVALID_M		(BValid),
    	.BREADY_M		(BReady),
    	.BID_M			(BId),
        */            	

		.AWADDR_M		(AWAddrT),
		.AWLEN_M		(AWLenT),
		.AWVALID_M		(AWValidT),
		.AWREADY_M		(AWReadyT),
		.AWID_M			(AWIdT),
		.AWBURST_M		(AWBurstT),
	                	
		.WLAST_M		(WLastT),
		.WSTRB_M  		(WStrbT),
		.WDATA_M   		(WDataT),
		.WVALID_M		(WValidT),
		.WREADY_M		(WReadyT),
		.WID_M			(WIdT),
                    	
		//.BRESP_M 		(BRespT),
		.BRESP_M 		(BResp),
    	.BVALID_M		(BValidT),
    	.BREADY_M		(BReadyT),
    	.BID_M			(BIdT),
                    	
		.ARADDR_M		(ARAddrT),
		.ARLEN_M		(ARLenT),
		.ARVALID_M		(ARValidT),
		.ARREADY_M		(ARReadyT),
		.ARID_M			(ARIdT),
		.ARBURST_M		(ARBurstT),
                    	
		.RREADY_M		(RReadyT),
		.RVALID_M		(RValidT),
		.RLAST_M		(RLastT),
		.RDATA_M   		(RDataT),
		.RID_M			(RIdT),
		//.RRESP_M		(RRespT),
		.RRESP_M		(RResp),

// Slave    	            	
		.AWADDR_S		(AWAddrM),
		.AWLEN_S		(AWLenM),
		.AWVALID_S		(AWValidM),
		.AWREADY_S		(AWReadyM),
		.AWID_S			(AWIdM),
		.AWBURST_S		(AWBurstM),
	                	
		.WLAST_S		(WLastM),
		.WSTRB_S  		(WStrbM),
		.WDATA_S   		(WDataM),
		.WVALID_S		(WValidM),
		.WREADY_S		(WReadyM),
		.WID_S			(WIdM),
                    	
		.BRESP_S 		(BRespM),
    	.BVALID_S		(BValidM),
    	.BREADY_S		(BReadyM),
    	.BID_S			(BIdM),
                    	
		.ARADDR_S		(ARAddrM),
		.ARLEN_S		(ARLenM),
		.ARVALID_S		(ARValidM),
		.ARREADY_S		(ARReadyM),
		.ARID_S			(ARIdM),
		.ARBURST_S		(ARBurstM),
                    	
		.RREADY_S		(RReadyM),
		.RVALID_S		(RValidM),
		.RLAST_S		(RLastM),
		.RDATA_S   		(RDataM),
		.RID_S			(RIdM),
		.RRESP_S		(RRespM)
);

// AXI Interface
DDRAi DDRAi(
		.MCLK			(MCLK),
		.nMCLK			(nMCLK),
		.ACLK			(ACLK),
		.nACLK			(nACLK),
		.ARESETB		(ARESETB),
		.nPOR			(nPOR),
                    	
		.AWAddr			(AWAddrM[AW+2:2]),
		.AWLen			(AWLenM[BL:0]),
		.AWValid		(AWValidM),
		.AWReady		(AWReadyM),
		.AWId			(AWIdM),
		.AWBurst		(AWBurstM),
	                	
		.WLast			(WLastM),
		.WStrb  		(WStrbM),
		.WData   		(WDataM),
		.WValid			(WValidM),
		.WReady			(WReadyM),
		.WId			(WIdM),
                    	
		.BResp 			(BRespM),
    	.BValid			(BValidM),
    	.BReady			(BReadyM),
    	.BId			(BIdM),
    	            	
		.ARAddr			(ARAddrM[AW+2:2]),
		.ARLen			(ARLenM[BL:0]),
		.ARValid		(ARValidM),
		.ARReady		(ARReadyM),
		.ARId			(ARIdM),
		.ARBurst		(ARBurstM),
                    	
		.RReady			(RReadyM),
		.RValid			(RValidM),
		.RLast			(RLastM),
		.RData   		(RDataM),
		.RId			(RIdM),
		.RResp			(RRespM),
                    	
    	.RQFull			(RQFull),
    	.WQFull			(WQFull),
                    	
		.BA_STS			(BA_STS),
		.BA_AA   		(BA_AA),
		.BA_TT   		(BA_TT),
		.BA_REQ  		(BA_REQ),
		.BA_RW   		(BA_RW),
		.BA_ID			(BA_ID),
		.BA_PM			(BA_PM),
                    	
		.SD_DQE			(SD_DQE),
		.SD_DQI			(SD_DQI), 
		.SD_DQO			(SD_DQO),
		.SD_DQM			(SD_DQM),
		.SD_DQSE		(SD_DQSE),
		.SD_DQSO		(SD_DQSO),
`ifdef CHIP
		.nSD_DQSI0		(nSD_DQSI[0]),
		.nSD_DQSI1		(nSD_DQSI[1]),
		.SD_DQSI0		(SD_DQSI[0]),
		.SD_DQSI1		(SD_DQSI[1])
`else	// Can't use DLL of FPGA, So. Give Delay or more delay if need.
		.nSD_DQSI0		(nSD_DQSI[0] & SDREnStatus),
		.nSD_DQSI1		(nSD_DQSI[1] & SDREnStatus),
		.SD_DQSI0		(SD_DQSI[0] & SDREnStatus),
		.SD_DQSI1		(SD_DQSI[1] & SDREnStatus)
`endif
);
//-------------------------------------------------------------
// SDRAM Controller
DDRCtl DDRCtl(
		.ACLK			(ACLK), 
		.nPOR			(nPOR),
		.ARESETB		(ARESETB),
		            	
		.BA_AA   		(BA_AA),
		.BA_TT   		(BA_TT),
		.BA_RW   		(BA_RW),
		.BA_REQ  		(BA_REQ),
		.BA_ID			(BA_ID),
		.BA_PM			(BA_PM),
		.BA_STS			(BA_STS),
		            	
		.PCLK			(PCLK), 
		.PRESETB		(PRESETB),
		.PENABLE 		(PENABLE), 
		.PSEL    		(PSEL), 
		.PWRITE  		(PWRITE), 
		.PADDR   		(PADDR), 
		.PWDATA  		(PWDATA),
		.PRDATA  		(PRDATA),
                    	
    	.RQFull			(RQFull),
    	.WQFull			(WQFull & WReady), // Write Buff Full & OverWrite
    	.SDREnStatus	(SDREnStatus),
 		            	
		.SD_CSB			(SD_CSB), 
		.SD_RASB		(SD_RASB), 
		.SD_CASB		(SD_CASB), 
		.SD_WEB			(SD_WEB), 
		.SD_CKE			(SD_CKE), 
		.SD_BADDR		(SD_BADDR), 
		.SD_ADDR		(SD_ADDR)
);
//-------------------------------------------------------------
endmodule
