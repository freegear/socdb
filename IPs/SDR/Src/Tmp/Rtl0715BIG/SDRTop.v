
`timescale 1ns/10ps

module SDRTop(
    		ARESETB,
    		PORESETB,
    		ACLK,
    		nACLK,
    		FCLK,
    		
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
    		
			PCLK,
			PRESETB,
    		PSEL, 
    		PENABLE, 
    		PADDR, 
    		PWRITE, 
    		PWDATA, 
			PRDATA
);


`include "../Rtl/SDRPara.v"

input    		ARESETB;  // asynchronous reset
input			PORESETB;
input    		ACLK;
input    		nACLK;
input    		FCLK;

// Write Command
input  [AW:0]	AWAddr;
input  [ID:0] 	AWId;
input  [BL:0] 	AWLen;
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
input  [AW:0]	ARAddr;
input  [ID:0] 	ARId;
input  [BL:0] 	ARLen;
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
input  [DW:0]	SD_DQI; // data input
output [DW:0] 	SD_DQO; // data output
output [BW:0]	SD_DQM;
//-------------------------------------------------------------
/*
wire			nACLK;
wire			PCLK;

reg				PCLKReg;
always @(negedge PORESETB or posedge ACLK)
	if (!PORESETB) 	PCLKReg <= 0;
	else			PCLKReg <= PCLKReg + 1;

INVX2 ACKBUF(.A(ACLK),  	.Y(nACLK));
BUFX2 PCKBUF(.A(PCLKReg),  	.Y(PCLK));
*/

// Controller
wire [16:0]   	BA_STS; // status
wire [AW:0]		BA_AA;
wire			BA_REQ;
wire [TL:0]   	BA_TT;
wire [ID:0]		BA_ID;
wire			BA_RW;
wire			BA_PM;

wire			RReadyS;
wire			RLastS;
wire          	RValidS;
wire [DW:0] 	RDataS;
wire [ID:0] 	RIdS;
wire [ 1:0]  	RRespS;
//-------------------------------------------------------------
SDRRDS SDRRDS(
		.ACLK         	(ACLK), 
		.ARESETn      	(ARESETB), 
		.INFORMATION_S	({RRespS, RLastS, RDataS, RIdS}),
		.VALID_S      	(RValidS),
		.READY_S      	(RReadyS),
		.INFORMATION_R	({RResp, RLast, RData, RId}),
		.VALID_R      	(RValid),
		.READY_R      	(RReady)
);

// AXI Interface
SDRAi SDRAi(
		.ACLK		(ACLK), 
		.nACLK		(nACLK), 
		.ARESETB	(ARESETB),
		.PORESETB	(PORESETB),
		.FCLK		(FCLK),

		.AWAddr		(AWAddr),
		.AWLen		(AWLen),
		.AWValid	(AWValid),
		.AWReady	(AWReady),
		.AWId		(AWId),
		.AWBurst	(AWBurst),
	
		.WLast		(WLast),
		.WStrb  	(WStrb),
		.WData   	(WData),
		.WValid		(WValid),
		.WReady		(WReady),
		.WId		(WId),

		.BResp 		(BResp),
    	.BValid		(BValid),
    	.BReady		(BReady),
    	.BId		(BId),
    	
		.ARAddr		(ARAddr),
		.ARLen		(ARLen),
		.ARValid	(ARValid),
		.ARReady	(ARReady),
		.ARId		(ARId),
		.ARBurst	(ARBurst),

		.RReady		(RReadyS),
		.RValid		(RValidS),
		.RLast		(RLastS),
		.RData   	(RDataS),
		.RId		(RIdS),
		.RResp		(RRespS),

    	.RQFull		(RQFull),
    	.WQFull		(WQFull),
    
		.BA_STS		(BA_STS),
		.BA_AA   	(BA_AA),
		.BA_TT   	(BA_TT),
		.BA_REQ  	(BA_REQ),
		.BA_RW   	(BA_RW),
		.BA_ID		(BA_ID),
		.BA_PM		(BA_PM),

		.SD_DQE		(SD_DQE),
		.SD_DQI		(SD_DQI), 
		.SD_DQO		(SD_DQO),
		.SD_DQM		(SD_DQM)
);
//-------------------------------------------------------------
// SDRAM Controller
SDRCtl SDRCtl(
		.ACLK		(ACLK), 
		.PORESETB	(PORESETB),
		.ARESETB	(ARESETB),
		
		.BA_AA   	(BA_AA),
		.BA_TT   	(BA_TT),
		.BA_RW   	(BA_RW),
		.BA_REQ  	(BA_REQ),
		.BA_ID		(BA_ID),
		.BA_PM		(BA_PM),
		.BA_STS		(BA_STS),
		
		.PCLK		(PCLK), 
		.PRESETB	(PRESETB),
		.PENABLE 	(PENABLE), 
		.PSEL    	(PSEL), 
		.PWRITE  	(PWRITE), 
		.PADDR   	(PADDR), 
		.PWDATA  	(PWDATA),
		.PRDATA  	(PRDATA),

    	.RQFull		(RQFull),
    	.WQFull		(WQFull & WReady), // Write Buff Full & OverWrite
 		
		.SD_CSB		(SD_CSB), 
		.SD_RASB	(SD_RASB), 
		.SD_CASB	(SD_CASB), 
		.SD_WEB		(SD_WEB), 
		.SD_CKE		(SD_CKE), 
		.SD_BADDR	(SD_BADDR), 
		.SD_ADDR	(SD_ADDR)
);
//-------------------------------------------------------------
endmodule
