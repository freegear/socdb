
`timescale 1ns/10ps

module SDRAi (
    		ARESETB,
    		PORESETB,
    		ACLK,
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
    		
    		RQFull,
    		WQFull,
    		
    		BA_STS,
    		BA_AA,
    		BA_REQ,
    		BA_TT,
    		BA_RW,
    		BA_ID,
    		BA_PM,
    		
    		SD_DQE,
    		SD_DQI,
    		SD_DQO,
    		SD_DQM
);

`include "../Rtl/SDRPara.v"

input    		ARESETB;  // asynchronous reset
input			PORESETB;
input    		ACLK;
input    		FCLK;

// Write Command
input  [AW:0]	AWAddr;
input  [ID:0] 	AWId;
input  [BL:0] 	AWLen;
input	[1:0]	AWBurst;	// 0: fix, 1: inc, 2: wrap
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
output [DW:0] 	RData; // data output
output [ID:0] 	RId;
output [1:0]	RResp;

output			RQFull;
output			WQFull;

// Controller
input  [13:0]   BA_STS; // status
output			BA_REQ;
output [AW:0]	BA_AA;
output [BL:0]   BA_TT;
output [ID:0]	BA_ID;
output			BA_RW;
output			BA_PM;

// SDRAM
output    		SD_DQE; // dq output enable
input  [DW:0]	SD_DQI; // data input
output [DW:0] 	SD_DQO; // data output
output [BW:0]	SD_DQM;
//-------------------------------------------------------------
reg [ID:0] 		BId;

reg    			SD_DQE;
wire[DW:0]		SD_DQO;
wire[BW:0]		SD_DQM;

//reg 			RValid;
//reg [1:0] 		RResp;

reg        		ReadLatchEnFd;
reg [DW:0] 		RdDataMemFd;
reg [DW:0] 		RdDataMem;

reg        		iDelayReadFlag;
reg        		RdDataRdy;

reg        		iDelayReadLast;
reg				RdLastMem;

reg [ID:0] 		iDelayReadId;
reg [ID:0]		RdIdMem;

// Command Acknology
wire DiValid = BA_STS[0];
wire DoValid = BA_STS[1];
wire QueEmp  = BA_STS[2];	// RAS/CAS Queue Empty
wire QueFul  = BA_STS[3];	// RAS/CAS Queue Full
wire QueErr  = BA_STS[4];	// RAS/CAS Queue Error
wire RdLast  = BA_STS[5];
wire [ID:0] RdId = BA_STS[9:6];
wire [ID:0] WrId = BA_STS[13:10];

reg  AckQue;
always @(negedge ARESETB or posedge ACLK)
  	if (!ARESETB) AckQue <= 1'b0;
  	else          AckQue <= ~QueFul;

wire AWQWrite, AWQRead;
wire iAWQRead;
wire AWQFull;
wire AWQEmpty;
wire [AWQW:0]	AWQWrData = {AWBurst, AWId, AWLen, AWAddr};
wire [AWQW:0]	AWQRdData;

wire ARQWrite, ARQRead;
wire iARQRead;
wire ARQFull;
wire ARQEmpty;
wire [ARQW:0]	ARQWrData = {ARBurst, ARId, ARLen, ARAddr};
wire [ARQW:0]	ARQRdData;

wire WQWrite, WQRead;
wire iWQRead;
wire WQFull;
wire WQEmpty;
//wire [WQW:0]	WQWrData = {WId, ~WStrb, WData};
wire [WQW:0]	WQWrData = {~WStrb, WData};
wire [WQW:0]	WQRdData;

wire WBLQWrite, WBLQRead;
wire iWBLQRead;
wire WBLQFull;
wire WBLQEmpty;
wire [WBLQW:0]	WBLQWrData;
wire [WBLQW:0]	WBLQRdData;

wire RQWrite, RQRead;
wire iRQRead;
wire RQFull;
wire RQEmpty;
wire [RQW:0]	RQWrData = {RdIdMem, RdDataMem};
wire [RQW:0]	RQRdData;

wire RBLQWrite, RBLQRead;
wire iRBLQRead;
wire RBLQFull;
wire RBLQEmpty;
wire [RBLQW:0]	RBLQWrData;
wire [RBLQW:0]	RBLQRdData;

parameter W_IDLE = 3'b001;
parameter W_WREQ = 3'b010;
parameter W_WSPI = 3'b100;

reg [2:0]  CurStW, NxtStW;

wire  tWIdle  = CurStW[0];
wire  tWWReq  = CurStW[1];
wire  tWWSpi  = CurStW[2];

wire  nWIdle  = NxtStW[0];
wire  nWWReq  = NxtStW[1];
wire  nWWSpi  = NxtStW[2];

parameter S_IDLE = 2'b01;
parameter S_RESP = 2'b10;

reg [1:0]  CurStS, NxtStS;

wire  tSIdle  = CurStS[0];
wire  tSResp  = CurStS[1];

parameter R_IDLE = 3'b001;
parameter R_RREQ = 3'b010;
parameter R_RSPI = 3'b100;

reg [2:0]  CurStR, NxtStR;

wire  tRIdle  = CurStR[0];
wire  tRRReq  = CurStR[1];
wire  tRRSpi  = CurStR[2];

wire  nRIdle  = NxtStR[0];
wire  nRRReq  = NxtStR[1];
wire  nRRSpi  = NxtStR[2];

parameter R_DIDLE = 2'b01;
parameter R_DREQ  = 2'b10;

reg [1:0]  CurStRD, NxtStRD;

wire  tRDIdle = CurStRD[0];
wire  tRDReq  = CurStRD[1];

wire  nRDIdle = NxtStRD[0];
wire  nRDReq  = NxtStRD[1];

wire WrReqEn;
wire RdReqEn;
wire WriteAck;
wire ReadAck;
wire RespAck;
wire WriteAckSpi;
wire ReadAckSpi;

wire WCmdLatch;
wire RCmdLatch;

wire       WPageMisCon;
wire [CAW+1:0] WPageMisCal;
wire [AW:0] WSpi2Addr;
wire [BL:0] WSpi2Len;
wire [AW:0] WSpi1Addr;
wire [BL:0] WSpi1Len;

wire       RPageMisCon;
wire [CAW+1:0] RPageMisCal;
wire [AW:0] RSpi2Addr;
wire [BL:0] RSpi2Len;
wire [AW:0] RSpi1Addr;
wire [BL:0] RSpi1Len;

reg [AW:0]	WriteLatA0;
wire[AW:0]	WriteLatAA;
reg [BL:0]  WriteLatTT;
reg [ID:0]	WriteLatID;
reg  [1:0]	WriteLatBB;

reg [AW:0]	ReadLatA0;
wire[AW:0]	ReadLatAA;
reg [BL:0]  ReadLatTT;
reg [ID:0]	ReadLatID;
reg  [1:0]	ReadLatBB;

wire [AW:0]	WriteReqAA;
wire [BL:0] WriteReqTT;
wire [ID:0]	WriteReqID;
wire		WriteReqRW;
wire		WriteRequest;

wire [AW:0]	ReadReqAA;
wire [BL:0] ReadReqTT;
wire [ID:0]	ReadReqID;
wire		ReadReqRW;
wire		ReadRequest;

wire		iWReady;
//-------------------------------------------------------------
// Write Command Path
wire    iAWReady = ~AWQFull & ~WQFull;
assign  AWReady  =  iAWReady;

assign  AWQWrite =  iAWReady & AWValid;
assign  iAWQRead =  tWWReq & WriteAck;
assign  AWQRead  =  iAWQRead;

SDRAWQ WCmdBuf (
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.WriteEn	(AWQWrite), 
			.ReadEn		(AWQRead), 
			.WrData		(AWQWrData), 
			.RdData		(AWQRdData), 
			.FullFlag	(AWQFull), 
			.EmptyFlag	(AWQEmpty)
);

// Write Control State Machine
always @(negedge ARESETB or posedge ACLK)
  	if (!ARESETB) CurStW <= W_IDLE;
  	else          CurStW <= NxtStW;

always @(tWIdle or tWWReq or tWWSpi or WrReqEn or WriteAck or WPageMisCon or WriteAckSpi) begin
  	NxtStW = W_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tWIdle  : 	if (WrReqEn)			NxtStW = W_WREQ;
  	  	          	else        			NxtStW = W_IDLE;
  	  	          	            
  	  	tWWReq  : 	if (WriteAck) begin
  	  					if (WPageMisCon)	NxtStW = W_WSPI;
  	  					else				NxtStW = W_IDLE;
  	  				end
  	  	          	else        			NxtStW = W_WREQ;
                                    		
  	  	tWWSpi  : 	if (WrReqEn)			NxtStW = W_WREQ;
  	  	          	else if (WriteAckSpi)	NxtStW = W_IDLE;
  	  	          	else        			NxtStW = W_WSPI;
  	  	                            		
  	  	default :               			NxtStW = W_IDLE;
  	endcase
end

assign WrReqEn     = WLast  & iWReady & ~AWQEmpty;
assign WriteAck    = AckQue & ~AWQEmpty;
assign WriteAckSpi = AckQue;
assign WCmdLatch   = WrReqEn;

// Page Miss Condition
assign WPageMisCal = WriteLatAA[CAW:0]+WriteLatTT;
assign WPageMisCon = WPageMisCal[CAW+1];

// Calculate Spilit Address
assign WSpi1Addr = WriteLatAA;
assign WSpi1Len  = WPageMisCon ? WriteLatTT-WSpi2Len-1 : WriteLatTT;

assign WSpi2Addr = {WriteLatAA[AW:CAW+1]+1, {CAW+1{1'b0}}};
assign WSpi2Len  = WPageMisCal-{CAW+1{1'b1}}-1;

// Calculate Wrap
reg [BL:0] WrWrapAA5_2;
always@(WriteLatBB or WriteLatA0 or WriteLatTT) 
	if (WriteLatBB == 2) begin
		case(WriteLatTT) // synopsys parallel_case
			4'd1    :  	WrWrapAA5_2 = {WriteLatA0[BL:1], 1'b0}; // WrWrap Burst 2
			4'd3    :  	WrWrapAA5_2 = {WriteLatA0[BL:2], 2'b0}; // WrWrap Burst 4
			4'd7    :  	WrWrapAA5_2 = {WriteLatA0[BL],   3'b0}; // WrWrap Burst 8
			default :  	WrWrapAA5_2 =                    4'b0 ; // WrWrap Burst 16
		endcase
	end
	else		   		WrWrapAA5_2 = WriteLatA0[BL:0]; 		// Increment

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) 	WriteLatBB <= 0;
  	else if (WCmdLatch) WriteLatBB <= AWQRdData[AWQW:AWQW-1];

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) 	WriteLatA0 <= 0;
  	else if (WCmdLatch) WriteLatA0 <= AWQRdData[AW:0];

assign WriteLatAA = {WriteLatA0[AW:BL+1], WrWrapAA5_2};

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) 	WriteLatTT <= 0;
  	else if (WCmdLatch) WriteLatTT <= AWQRdData[AW+BL+1:AW+1];

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) 	WriteLatID <= 0;
  	else if (WCmdLatch) WriteLatID <= AWQRdData[AW+BL+ID+2:AW+ID+2];

assign WriteReqRW   = tWWReq | tWWSpi;
assign WriteRequest = tWWReq | tWWSpi;
assign WriteReqID   = WriteLatID;
assign WriteReqAA   = tWWReq ? WSpi1Addr : tWWSpi ? WSpi2Addr : 0;
assign WriteReqTT   = tWWReq ? WSpi1Len  : tWWSpi ? WSpi2Len  : 0;
//-------------------------------------------------------------
// Write Response Path
always @(negedge ARESETB or posedge ACLK)
  	if (!ARESETB) CurStS <= S_IDLE;
  	else          CurStS <= NxtStS;

always @(tSIdle or tSResp or RespAck or BReady) begin
  	NxtStS = S_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tSIdle  : 	if (RespAck)	NxtStS = S_RESP;
  	  	          	else        	NxtStS = S_IDLE;
  	  	          	            
  	  	tSResp  : 	if (BReady)		NxtStS = S_IDLE;
  	  	          	else    		NxtStS = S_RESP;

  	  	default :               	NxtStS = S_IDLE;
  	endcase
end

assign RespAck  = ~tWWReq & ~tWWSpi & WLast & iWReady;

assign BValid   = tSResp;
// No Need WId, because not support interleaved Data Write
assign BResp    = 2'b0;

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) BId <= 0;
  	else if (RespAck)  BId <= AWQRdData[AW+BL+ID+2:AW+ID+2];
//-------------------------------------------------------------
// Read Command Path
wire    iARReady = tRIdle & ~ARQFull & ~RQFull;
assign  ARReady  = iARReady;
assign  ARQWrite = iARReady & ARValid;
assign  iARQRead = tRRReq & ReadAck;
assign  ARQRead  = iARQRead;

SDRARQ RCmdBuf (
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.WriteEn	(ARQWrite), 
			.ReadEn		(ARQRead), 
			.WrData		(ARQWrData), 
			.RdData		(ARQRdData), 
			.FullFlag	(ARQFull), 
			.EmptyFlag	(ARQEmpty)
);

// Read Control State Machine
always @(negedge ARESETB or posedge ACLK)
  	if (!ARESETB) CurStR <= R_IDLE;
  	else          CurStR <= NxtStR;

always @(tRIdle or tRRReq or tRRSpi or RdReqEn or ReadAck or RPageMisCon or ReadAckSpi) begin
  	NxtStR = R_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tRIdle  : 	if (RdReqEn)			NxtStR = R_RREQ;
  	  	          	else        			NxtStR = R_IDLE;
  	  	          	            
  	  	tRRReq  : 	if (ReadAck) begin
  	  					if (RPageMisCon)	NxtStR = R_RSPI;
  	  					else				NxtStR = R_IDLE;
  	  				end
  	  	          	else        			NxtStR = R_RREQ;
   	  				                		
  	  	tRRSpi  : 	if (ReadAckSpi)			NxtStR = R_IDLE;
  	  	          	else        			NxtStR = R_RSPI;
 	  	                            		
  	  	default :               			NxtStR = R_IDLE;
  	endcase
end

assign RdReqEn    = ~ARQEmpty & ~RQFull;
assign ReadAck    = ~ARQEmpty & AckQue & tWIdle; // Read Mask When Write Request
assign ReadAckSpi =  AckQue & tWIdle;
assign RCmdLatch  =  tRIdle & RdReqEn;

assign RPageMisCal = ReadLatAA[CAW:0]+ReadLatTT;
assign RPageMisCon = RPageMisCal[CAW+1];

assign RSpi1Addr = ReadLatAA;
assign RSpi1Len  = RPageMisCon ? ReadLatTT-RSpi2Len-1 : ReadLatTT;

assign RSpi2Addr = {ReadLatAA[AW:CAW+1]+1, {CAW+1{1'b0}}};
assign RSpi2Len  = RPageMisCal-{CAW+1{1'b1}}-1;
reg [BL:0] RdWrapAA5_2;

always@(ReadLatBB or ReadLatA0 or ReadLatTT) 
	if (ReadLatBB == 2) begin
		case(ReadLatTT) // synopsys parallel_case
			4'd1    :  	RdWrapAA5_2 = {ReadLatA0[BL:1], 1'b0}; // RdWrap Burst 2
			4'd3    :  	RdWrapAA5_2 = {ReadLatA0[BL:2], 2'b0}; // RdWrap Burst 4
			4'd7    :  	RdWrapAA5_2 = {ReadLatA0[BL],   3'b0}; // RdWrap Burst 8
			default :  	RdWrapAA5_2 =                   4'b0 ; // RdWrap Burst 16
		endcase
	end
	else		   		RdWrapAA5_2 = ReadLatA0[BL:0]; 		// Increment

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) 	ReadLatBB <= 0;
  	else if (RCmdLatch) ReadLatBB <= ARQRdData[ARQW:ARQW-1];

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) 	ReadLatA0 <= 0;
  	else if (RCmdLatch) ReadLatA0 <= ARQRdData[AW:0];

assign ReadLatAA = {ReadLatA0[AW:BL+1], RdWrapAA5_2};

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) 	ReadLatTT <= 0;
  	else if (RCmdLatch) ReadLatTT <= ARQRdData[AW+BL+1:AW+1];

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) 	ReadLatID <= 0;
  	else if (RCmdLatch) ReadLatID <= ARQRdData[AW+BL+ID+2:AW+ID+2];

assign ReadReqRW   = tRRReq | tRRSpi;
assign ReadRequest = tRRReq | tRRSpi;
assign ReadReqID   = ReadLatID;
assign ReadReqAA   = tRRReq ? RSpi1Addr : tRRSpi ? RSpi2Addr : 0;
assign ReadReqTT   = tRRReq ? RSpi1Len  : tRRSpi ? RSpi2Len  : 0;
//-------------------------------------------------------------
// Command Mux. to Controller
assign BA_PM  = tRRSpi & RPageMisCon;
assign BA_REQ = WriteRequest |  ReadRequest;
assign BA_RW  = WriteReqRW   | ~ReadRequest;
assign BA_AA  = WriteRequest ? WriteReqAA : ReadRequest ? ReadReqAA : 0;
assign BA_TT  = WriteRequest ? WriteReqTT : ReadRequest ? ReadReqTT : 0;
assign BA_ID  = WriteRequest ? WriteReqID : ReadRequest ? ReadReqID : 0;
//-------------------------------------------------------------
// Write Data Path
reg [BL:0]   WBurstCnt;
reg [BL:0]   WBLCnt;
reg [BL:0]   LatchedWBL;
reg [WQCD:0] WrWrapCnt;
reg [BL:0]   WrWrapAddrSt;
wire         WrWrapEn;
wire         WrWrapArround;
reg			 DelayiWBLQRead;

assign WBLQWrite  = ~WBLQFull & iAWQRead;
assign WBLQWrData = {AWQRdData[AWQW:AWQW-1], AWQRdData[BL:0], AWQRdData[AW+BL+1:AW+1]};

assign iWBLQRead  = ~WBLQEmpty & iWQRead & (WBurstCnt == 0);
assign WBLQRead   = iWBLQRead;

always@(negedge ARESETB or posedge ACLK) 
	if   	(!ARESETB) 	WBurstCnt <= 0;
	else if (iWBLQRead)	WBurstCnt <= WBLQRdData[BL:0];
	else begin
		if  (iWQRead)	WBurstCnt <= WBurstCnt - 1;
		else			WBurstCnt <= WBurstCnt;
	end

always@(negedge ARESETB or posedge ACLK) 
	if   	(!ARESETB) 	WBLCnt <= 0;
	else if (iWBLQRead)	WBLCnt <= WBLQRdData[BL:0];
	else begin
		if (!WrWrapEn)	WBLCnt <= 0;
		else begin
			if (iWQRead)WBLCnt <= WBLCnt - 1;
			else		WBLCnt <= WBLCnt;
		end
	end

always@(negedge ARESETB or posedge ACLK) 
	if   	(!ARESETB) 	LatchedWBL <= 0;
	else if (iWBLQRead)	LatchedWBL <= WBLQRdData[BL:0];

always@(negedge ARESETB or posedge ACLK) 
	if   	(!ARESETB) 	DelayiWBLQRead <= 0;
	else 				DelayiWBLQRead <= iWBLQRead;

wire [WQCD:0] WQIncAddr;

assign WrWrapEn      = (WrWrapAddrSt != 0);
assign WrWrapArround = ((LatchedWBL+1 - WrWrapAddrSt) == WBLCnt) & iWQRead;

always @(negedge ARESETB or posedge ACLK)
  	if      (!ARESETB) begin
  				  	  		WrWrapCnt <= 0;
  				  	  		WrWrapAddrSt = 0;
    end
	else if (iWBLQRead) begin
		if (WBLQRdData[WBLQW:WBLQW-1] == 2) begin
			case(WBLQRdData[BL:0]) // synopsys parallel_case
				4'd1    :  	WrWrapAddrSt = {3'b0, WBLQRdData[4]}; // WrWrap Burst 2
				4'd3    :  	WrWrapAddrSt = {2'b0, WBLQRdData[5:4]}; // WrWrap Burst 4
				4'd7    :  	WrWrapAddrSt = {1'b0, WBLQRdData[6:4]}; // WrWrap Burst 8
				default :  	WrWrapAddrSt = WBLQRdData[7:4]; // WrWrap Burst 16
			endcase
		end
		else		   		WrWrapAddrSt = 0; // Increment
		if (WrWrapAddrSt!=0)WrWrapCnt 	<= WQIncAddr + (WBLQRdData[BL:0]+1 - WrWrapAddrSt);
		else			 	WrWrapCnt 	<= WQIncAddr;
	end  
  	else if (WrWrapArround) WrWrapCnt 	<= WrWrapCnt - LatchedWBL;
  	else if (iWQRead)		WrWrapCnt 	<= WrWrapCnt + 1;


SDRWBLQ WBLBuf (
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.WriteEn	(WBLQWrite), 
			.ReadEn		(WBLQRead), 
			.WrData		(WBLQWrData), 
			.RdData		(WBLQRdData), 
			.FullFlag	(WBLQFull), 
			.EmptyFlag	(WBLQEmpty)
);

assign  iWReady = ~WQFull & WValid & AckQue;
assign  WReady  = iWReady;

assign  WQWrite = iWReady;
assign  iWQRead = ~WQEmpty & DiValid;
assign  WQRead  = iWQRead;

SDRWQ WDatBuf (
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.WriteEn	(WQWrite), 
			.ReadEn		(WQRead), 
			.WrData		(WQWrData), 
			.RdData		(WQRdData), 
			.FullFlag	(WQFull), 
			.EmptyFlag	(WQEmpty),
			.WrapEn		(WrWrapEn),
			.WrapCnt	(WrWrapCnt),
			.IncRdCnt	(WQIncAddr)
);

always@(negedge ARESETB or posedge ACLK) 
	if (!ARESETB) SD_DQE <= 1'b0;
	else          SD_DQE <= iWQRead;

assign SD_DQO = WQRdData[DW:0];
assign SD_DQM = WQRdData[DW+BW+1:DW+1];
//-------------------------------------------------------------
// Read Data Path
always@(negedge ARESETB or posedge ACLK) 
    if (!ARESETB) begin
        iDelayReadFlag <= 0;
        RdDataRdy      <= 0;
        iDelayReadLast <= 0;
        RdLastMem	   <= 0;
        iDelayReadId   <= 0;
        RdIdMem	   	   <= 0;
        
    end
    else begin
        iDelayReadFlag <= ReadLatchEnFd;
        RdDataRdy      <= iDelayReadFlag;
        iDelayReadLast <= RdLast;
        RdLastMem      <= iDelayReadLast;
        iDelayReadId   <= RdId;
        RdIdMem	   	   <= iDelayReadId;
    end

always @(negedge ARESETB or posedge FCLK) // Latch enable delay for READ by Feedback Clock
    if (!ARESETB) ReadLatchEnFd <= 1'b0;
    else          ReadLatchEnFd <= DoValid;

always @(negedge ARESETB or posedge FCLK)
    if      (!ARESETB)      RdDataMemFd <= 0;
    else if (ReadLatchEnFd) RdDataMemFd <= SD_DQI;

always @(negedge ARESETB or posedge ACLK)
    if (!ARESETB) RdDataMem <= 0;
    else          RdDataMem <= RdDataMemFd;

reg [BL:0]   RBurstCnt;
reg [BL:0]   RBLCnt;
reg [BL:0]   LatchedRBL;
reg [RQCD:0] RdWrapCnt;
reg [BL:0]   RdWrapAddrSt;
wire         RdWrapEn;
wire         RdWrapArround;

reg [RBLQCD:0] RdLastCnt;

assign RBLQWrite  = ~RBLQFull & iARQRead;
assign RBLQWrData = {ARQRdData[ARQW:ARQW-1], ARQRdData[BL:0], ARQRdData[AW+BL+1:AW+1]};

assign iRBLQRead  = nRDReq & ~tRDReq;
assign RBLQRead   = iRBLQRead;

always@(negedge ARESETB or posedge ACLK) 
	if   	(!ARESETB) 	RBLCnt <= 0;
	else if (iRBLQRead)	RBLCnt <= RBLQRdData[BL:0];
	else begin
		if (!RdWrapEn)	RBLCnt <= 0;
		else begin
			if (iRQRead)RBLCnt <= RBLCnt - 1;
			else		RBLCnt <= RBLCnt;
		end
	end

always@(negedge ARESETB or posedge ACLK) 
	if   	(!ARESETB) 	LatchedRBL <= 0;
	else if (iRBLQRead)	LatchedRBL <= RBLQRdData[BL:0];

assign RdWrapEn      = (RdWrapAddrSt != 0);
assign RdWrapArround = RdWrapEn & ((LatchedRBL+1 - RdWrapAddrSt) == RBLCnt) & iRQRead;

wire [RQCD:0] RQIncAddr;

always @(negedge ARESETB or posedge ACLK)
  	if      (!ARESETB) begin
  							RdWrapCnt <= 0;
  							RdWrapAddrSt = 0;
  	end
	else if (iRBLQRead) begin
		if (RBLQRdData[RBLQW:RBLQW-1] == 2) begin
			case(RBLQRdData[BL:0]) // synopsys parallel_case
				4'd1    :  	RdWrapAddrSt = {3'b0, RBLQRdData[4]}; // RdWrap Burst 2
				4'd3    :  	RdWrapAddrSt = {2'b0, RBLQRdData[5:4]}; // RdWrap Burst 4
				4'd7    :  	RdWrapAddrSt = {1'b0, RBLQRdData[6:4]}; // RdWrap Burst 8
				default :  	RdWrapAddrSt = RBLQRdData[7:4]; // RdWrap Burst 16
			endcase
		end
		else		   		RdWrapAddrSt = 0;//RBLQRdData[7:4]; // Increment
		if (RdWrapAddrSt!=0)RdWrapCnt 	<= RQIncAddr + (RBLQRdData[BL:0]+1 - RdWrapAddrSt);
		else				RdWrapCnt 	<= RQIncAddr;
	end
  	else if (RdWrapArround) RdWrapCnt <= RdWrapCnt - LatchedRBL;
  	else if (iRQRead)  	  	RdWrapCnt <= RdWrapCnt + 1;

SDRRBLQ RBLBuf (
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.WriteEn	(RBLQWrite), 
			.ReadEn		(RBLQRead), 
			.WrData		(RBLQWrData), 
			.RdData		(RBLQRdData), 
			.FullFlag	(RBLQFull), 
			.EmptyFlag	(RBLQEmpty)
);

always@(negedge ARESETB or posedge ACLK) 
	if   	(!ARESETB) 	RBurstCnt <= 0;
	else if (iRBLQRead)	RBurstCnt <= RBLQRdData[BL:0];
	else begin
		if  (iRQRead)	RBurstCnt <= RBurstCnt - 1;
		else			RBurstCnt <= RBurstCnt;
	end

wire ReadCntEnd = (RBurstCnt == 0) &  iRQRead;
wire ReadDatEn  = (RdLastCnt > 0)  & ~RBLQEmpty;

// Read Data State Machine
always @(negedge ARESETB or posedge ACLK)
  	if (!ARESETB) CurStRD <= R_DIDLE;
  	else          CurStRD <= NxtStRD;

always @(tRDIdle or tRDReq or ReadDatEn or ReadCntEnd) begin
  	NxtStRD = R_DIDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tRDIdle  : 	if (ReadDatEn)	NxtStRD = R_DREQ;
  	  	          	else        	NxtStRD = R_DIDLE;
  	  	          	            
  	  	tRDReq  : 	if (ReadCntEnd)	NxtStRD = R_DIDLE;
  	  	          	else        	NxtStRD = R_DREQ;

  	  	default :               	NxtStRD = R_DIDLE;
  	endcase
end

wire IncRdLastCnt = RdLastMem;
wire DecRdLastCnt = ReadCntEnd;

always @(negedge ARESETB or posedge ACLK)
  	if   (!ARESETB)   RdLastCnt <= 0;
  	else begin
    	case({IncRdLastCnt, DecRdLastCnt}) // synopsys parallel_case
    	  	2'b10   : RdLastCnt <= RdLastCnt + 1;
    	  	2'b01   : RdLastCnt <= RdLastCnt - 1;
    	  	default : RdLastCnt <= RdLastCnt;
    	endcase
  	end

assign  RQWrite = ~RQFull  & RdDataRdy;
assign  iRQRead = ~RQEmpty & RReady & tRDReq;
assign  RQRead  =  iRQRead;

SDRRQ RDatBuf (
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.WriteEn	(RQWrite), 
			.ReadEn		(RQRead), 
			.WrData		(RQWrData), 
			.RdData		(RQRdData), 
			.FullFlag	(RQFull), 
			.EmptyFlag	(RQEmpty),
			.WrapEn		(RdWrapEn),
			.WrapCnt	(RdWrapCnt),
			.IncRdCnt	(RQIncAddr)
);

assign  RValid = iRQRead;
//assign  RResp  = iRQRead ? 2'b0 : 2'b11;
assign  RResp  = 2'b0;

assign  RData  = RQRdData;
assign  RId	   = RQRdData[RQW:RQW-BL];
assign  RLast  = ReadCntEnd;


//-------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
wire WriteReq = BA_REQ & AckQue &  BA_RW;
wire ReadReq  = BA_REQ & AckQue & ~BA_RW;

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule