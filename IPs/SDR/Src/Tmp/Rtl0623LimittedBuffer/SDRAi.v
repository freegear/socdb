
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
output [DMW:0]	SD_DQM;
//-------------------------------------------------------------
reg [ID:0] 		BId;

wire[DW:0]		SD_DQO;
wire[DMW:0]		SD_DQM;

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

reg  AckMem;
always @(negedge ARESETB or posedge ACLK)
  	if (!ARESETB) AckMem <= 1'b0;
  	else          AckMem <= ~QueFul;

wire WQWrite, WQRead;
wire iWQRead;
wire WQFull;
wire WQHFull;
wire WQEmpty;
//wire [WQW:0]	WQWrData = {WId, ~WStrb, WData};
wire [WQW:0]	WQWrData = {~WStrb, WData};
wire [WQW:0]	WQRdData;

wire WBLQWrite, WBLQRead;
wire iWBLQRead;
wire WBLQFull;
wire WBLQEmpty;
wire [WBLQW:0]	WBLQWrData = {WriteLatBB, WriteLatA0[BL:0], WriteLatTT};
wire [WBLQW:0]	WBLQRdData;

wire RQWrite, RQRead;
wire iRQRead;
wire RQFull;
wire RQHFull;
wire RQEmpty;
wire [RQW:0]	RQWrData = {RdIdMem, RdDataMem};
wire [RQW:0]	RQRdData;

wire RBLQWrite, RBLQRead;
wire iRBLQRead;
wire RBLQFull;
wire RBLQEmpty;
wire [RBLQW:0]	RBLQWrData = {ARBurst, ARAddr[BL:0], ARLen};
wire [RBLQW:0]	RBLQRdData;

parameter W_IDLE = 4'b0001;
parameter W_WACK = 4'b0010;
parameter W_WREQ = 4'b0100;
parameter W_WSPI = 4'b1000;

reg [3:0]  CurStW, NxtStW;

wire  tWIdle  = CurStW[0];
wire  tWWAck  = CurStW[1];
wire  tWWReq  = CurStW[2];
wire  tWWSpi  = CurStW[3];

parameter R_IDLE = 3'b001;
parameter R_RREQ = 3'b010;
parameter R_RSPI = 3'b100;

reg [2:0]  CurStR, NxtStR;

wire  tRIdle  = CurStR[0];
wire  tRRReq  = CurStR[1];
wire  tRRSpi  = CurStR[2];

parameter R_DIDLE = 2'b01;
parameter R_DREQ  = 2'b10;

reg [1:0]  CurStRD, NxtStRD;

wire  tRDIdle = CurStRD[0];
wire  tRDReq  = CurStRD[1];

wire  nRDIdle = NxtStRD[0];
wire  nRDReq  = NxtStRD[1];

wire WriteAck;
wire ReadAck;

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

wire		iARReady;
wire		iAWReady;
wire		iWReady;
wire		RespAck;
//-------------------------------------------------------------
// Write Command Path
reg [WQCD+1:0] WrMaskCnt;

assign  iAWReady = tWIdle & ~QueErr & AWValid & WLast & iWReady;
//assign  iAWReady =  tWIdle & ~WQFull & ~QueErr & AWValid & WLast & iWReady;
assign  AWReady  =  iAWReady;

// Write Control State Machine
always @(negedge ARESETB or posedge ACLK)
  	if (!ARESETB) CurStW <= W_IDLE;
  	else          CurStW <= NxtStW;

always @(tWIdle or tWWAck or tWWReq or tWWSpi or RespAck or iAWReady or WriteAck or WPageMisCon) begin
  	NxtStW = W_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tWIdle  : 	if (iAWReady)			NxtStW = W_WACK;	// Write Command Ack.
  	  	          	else        			NxtStW = W_IDLE;

  	  	tWWAck  : 	if (RespAck)            NxtStW = W_WREQ;	// All WData Received
  	  	          	else        			NxtStW = W_WACK;

  	  	tWWReq  : 	if (WriteAck) begin
  	  					if (WPageMisCon)	NxtStW = W_WSPI;
  	  					else				NxtStW = W_IDLE;
  	  				end
  	  	          	else        			NxtStW = W_WREQ;

  	  	tWWSpi  : 	if (iAWReady)			NxtStW = W_WACK;
  	  	          	else if (WriteAck)		NxtStW = W_IDLE;
  	  	          	else        			NxtStW = W_WSPI;

  	  	default :               			NxtStW = W_IDLE;
  	endcase
end

assign RespAck     = BReady;
assign WriteAck    = AckMem;

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
  	if 		(!ARESETB) WriteLatBB <= 0;
  	else if (iAWReady) WriteLatBB <= AWBurst;

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) WriteLatA0 <= 0;
  	else if (iAWReady) WriteLatA0 <= AWAddr;

assign WriteLatAA = {WriteLatA0[AW:BL+1], WrWrapAA5_2};

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) WriteLatTT <= 0;
  	else if (iAWReady) WriteLatTT <= AWLen;

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) WriteLatID <= 0;
  	else if (iAWReady) WriteLatID <= AWId;

assign WriteReqRW   = tWWReq | tWWSpi;
assign WriteRequest = tWWReq | tWWSpi;
assign WriteReqID   = WriteLatID;
assign WriteReqAA   = tWWReq ? WSpi1Addr : tWWSpi ? WSpi2Addr : 0;
assign WriteReqTT   = tWWReq ? WSpi1Len  : tWWSpi ? WSpi2Len  : 0;
//-------------------------------------------------------------
// Write Response Path
assign BValid   = tWWAck;
// No Need WId, because not support interleaved Data Write
//assign BResp    = tWWAck ? 2'b0 : 2'b11;
assign BResp    = 2'b0;

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) BId <= 0;
  	else if (iAWReady) BId <= WId;
//-------------------------------------------------------------
// Write Data Path
reg [BL:0]   WBurstCnt;
reg [BL:0]   WBLCnt;
reg [BL:0]   LatchedWBL;
reg [WQCD:0] WrWrapCnt;
reg [BL:0]   WrWrapAddrSt;
wire         WrWrapEn;
wire         WrWrapArround;

assign WBLQWrite  = ~WBLQFull & tWWReq & WriteAck;

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

wire [WQCD:0] WQIncAddr;

assign WrWrapEn      = (WrWrapAddrSt != 0);
assign WrWrapArround = WrWrapEn & ((LatchedWBL+1 - WrWrapAddrSt) == WBLCnt) & iWQRead;

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

//assign  iWReady = ~WQFull & WValid & AckMem & ~tWWAck & ~tWWReq & ~WBLQFull;
assign  iWReady = (WrMaskCnt <= ((WQD+1)/2)) & WValid & AckMem & ~tWWAck & ~tWWReq & ~WBLQFull;

assign  WReady  = iWReady;

assign  WQWrite = iWReady;
assign  iWQRead = ~WQEmpty & DiValid;
assign  WQRead  = iWQRead;

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) WrMaskCnt <= 0;
  	else if (iAWReady) WrMaskCnt <= WrMaskCnt + AWLen + 1;
  	else if (iWQRead)  WrMaskCnt <= WrMaskCnt - 1;

SDRWQ WDatBuf (
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.WriteEn	(WQWrite), 
			.ReadEn		(WQRead), 
			.WrData		(WQWrData), 
			.RdData		(WQRdData), 
			.FullFlag	(WQFull), 
			.HFullFlag	(WQHFull), 
			.EmptyFlag	(WQEmpty),
			.WrapEn		(WrWrapEn),
			.WrapCnt	(WrWrapCnt),
			.IncRdCnt	(WQIncAddr)
);

reg DelayiWQRead;
always@(negedge ARESETB or posedge ACLK) 
	if (!ARESETB) DelayiWQRead <= 1'b0;
	else          DelayiWQRead <= iWQRead;

assign SD_DQE = DelayiWQRead;
assign SD_DQM = DelayiWQRead ? WQRdData[DW+BW+1:DW+1] : 0;
assign SD_DQO = WQRdData[DW:0];
//-------------------------------------------------------------
// Read Command Path
reg [RQCD+1:0] RdMaskCnt;
always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) RdMaskCnt <= 0;
  	else if (iARReady) RdMaskCnt <= RdMaskCnt + ARLen + 1;
  	else if (iRQRead)  RdMaskCnt <= RdMaskCnt - 1;

assign  iARReady = tRIdle & ~QueErr & ARValid & (RdMaskCnt <= ((RQD+1)/2)) & ~RBLQFull;
//assign  iARReady = tRIdle & ~QueErr & ARValid & ~RQHFull & ~RBLQFull;
assign  ARReady  = iARReady;

// Read Control State Machine
always @(negedge ARESETB or posedge ACLK)
  	if (!ARESETB) CurStR <= R_IDLE;
  	else          CurStR <= NxtStR;

always @(tRIdle or tRRReq or tRRSpi or iARReady or ReadAck or RPageMisCon) begin
  	NxtStR = R_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tRIdle  : 	if (iARReady)			NxtStR = R_RREQ;
  	  	          	else        			NxtStR = R_IDLE;
  	  	          	            
  	  	tRRReq  : 	if (ReadAck) begin
  	  					if (RPageMisCon)	NxtStR = R_RSPI;
  	  					else				NxtStR = R_IDLE;
  	  				end
  	  	          	else        			NxtStR = R_RREQ;
   	  				                		
  	  	tRRSpi  : 	if (ReadAck)			NxtStR = R_IDLE;
  	  	          	else        			NxtStR = R_RSPI;
 	  	                            		
  	  	default :               			NxtStR = R_IDLE;
  	endcase
end

assign ReadAck    =  AckMem & ~(tWWReq | tWWSpi); // Read Mask When Write Request

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
  	if 		(!ARESETB) ReadLatBB <= 0;
  	else if (iARReady) ReadLatBB <= ARBurst;

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) ReadLatA0 <= 0;
  	else if (iARReady) ReadLatA0 <= ARAddr;

assign ReadLatAA = {ReadLatA0[AW:BL+1], RdWrapAA5_2};

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) ReadLatTT <= 0;
  	else if (iARReady) ReadLatTT <= ARLen;

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) ReadLatID <= 0;
  	else if (iARReady) ReadLatID <= ARId;

assign ReadReqRW   = tRRReq | tRRSpi;
assign ReadRequest = tRRReq | tRRSpi;
assign ReadReqID   = ReadLatID;
assign ReadReqAA   = tRRReq ? RSpi1Addr : tRRSpi ? RSpi2Addr : 0;
assign ReadReqTT   = tRRReq ? RSpi1Len  : tRRSpi ? RSpi2Len  : 0;
//-------------------------------------------------------------
// Command Mux. to Controller
assign BA_PM  = tRRReq & RPageMisCon;	// Read Last Mask at Page Miss Condition
assign BA_REQ = WriteRequest |  ReadRequest;
assign BA_RW  = WriteReqRW   | ~ReadRequest;
assign BA_AA  = WriteRequest ? WriteReqAA : ReadRequest ? ReadReqAA : 0;
assign BA_TT  = WriteRequest ? WriteReqTT : ReadRequest ? ReadReqTT : 0;
assign BA_ID  = WriteRequest ? WriteReqID : ReadRequest ? ReadReqID : 0;

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

assign RBLQWrite  = ~RBLQFull & iARReady;

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
assign RdWrapArround = RdWrapEn & (RdWrapAddrSt == RBLCnt) & iRQRead;

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
		else		   		RdWrapAddrSt = 0;				// Increment
		if (RdWrapAddrSt!=0)RdWrapCnt 	<= RQIncAddr + RdWrapAddrSt;
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
wire ReadDatEn  = (RdLastCnt > 0)  & ~RBLQEmpty & ~RQEmpty;

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
			.HFullFlag	(RQHFull), 
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
wire WriteReq = BA_REQ & AckMem &  BA_RW;
wire ReadReq  = BA_REQ & AckMem & ~BA_RW;

integer RLastMemCnt;
integer RLastCnt;
always @(negedge ARESETB or posedge ACLK)
	if (!ARESETB) 		RLastMemCnt <= 0;
	else if (RdLastMem) RLastMemCnt <= RLastMemCnt+1;

always @(negedge ARESETB or posedge ACLK)
	if (!ARESETB) 	RLastCnt <= 0;
	else if (RLast) RLastCnt <= RLastCnt+1;

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
