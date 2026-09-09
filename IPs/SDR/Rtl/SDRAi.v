
`timescale 1ns/10ps

//`define LIMIT

module SDRAi (
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
    		
    		RQFull,
    		WQFull,
    		
    	//	BA_STS,
	DiValid,
	DoValid,
	QueEmp,	// RAS/CAS Queue Empty
	QueFul,	// RAS/CAS Queue Full
	QueErr,	// RAS/CAS Queue Error
	RdLast,
	RdId,
	WrId,
	Port16Bit,
	ColAddrSiz,
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

`include "SDRPara.v"

input    		ARESETB;  // asynchronous reset
input			PORESETB;
input    		ACLK;
input    		nACLK;
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
//input  [16:0]   BA_STS; // status
input 			DiValid;
input 			DoValid;
input 			QueEmp;	// RAS/CAS Queue Empty
input 			QueFul;	// RAS/CAS Queue Full
input 			QueErr;	// RAS/CAS Queue Error
input 			RdLast;
input [ID:0] 	RdId;
input [ID:0] 	WrId;
input 			Port16Bit;
input [1:0] 	ColAddrSiz;

output			BA_REQ;
output [AW:0]	BA_AA;
output [TL:0]   BA_TT;
output [ID:0]	BA_ID;
output			BA_RW;
output			BA_PM;

// SDRAM
output    		SD_DQE; // dq output enable
input  [DW:0]	SD_DQI; // data input
output [DW:0] 	SD_DQO; // data output
output [DMW:0]	SD_DQM;
//-------------------------------------------------------------
wire [ID:0] 	BId;
wire 			BValid;

reg [DW:0]		SD_DQO;
reg [DMW:0]		SD_DQM;

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
reg			 	RdAddrHold;
reg			 	In16BitSel;

// Command Acknology
/*
wire DiValid = BA_STS[0];
wire DoValid = BA_STS[1];
wire QueEmp  = BA_STS[2];	// RAS/CAS Queue Empty
wire QueFul  = BA_STS[3];	// RAS/CAS Queue Full
wire QueErr  = BA_STS[4];	// RAS/CAS Queue Error
wire RdLast  = BA_STS[5];
wire [ID:0] RdId = BA_STS[9:6];
wire [ID:0] WrId = BA_STS[13:10];
wire Port16Bit = BA_STS[14];
wire [1:0] ColAddrSiz = BA_STS[16:15];
*/
 
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

wire AckMem = ~QueFul;

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
wire WBLQHFull;
wire WBLQFull;
wire WBLQEmpty;
wire [WBLQW:0]	WBLQWrData = {WriteLatBB, WriteLatA0[BL:0], WriteLatTT};
wire [WBLQW:0]	WBLQRdData;

wire BBLQWrite, BBLQRead;
wire iBBLQRead;
wire BBLQFull;
wire BBLQHFull;
wire BBLQEmpty;
wire [ID:0] BBLQWrData = {WId};
wire [ID:0] BBLQRdData;

wire RQWrite, RQRead;
wire iRQRead;
wire RQFull;
wire RQHFull;
wire RQEmpty;
wire [RQW:0]	RQWrData = {RdIdMem, RdDataMem};
wire [RQW:0]	RQRdData;

wire RBLQWrite, RBLQRead;
wire iRBLQRead;
wire RBLQHFull;
wire RBLQFull;
wire RBLQEmpty;
wire [RBLQW:0]	RBLQWrData = {ARBurst, ARAddr[BL:0], ARLen};
wire [RBLQW:0]	RBLQRdData;

parameter W_IDLE = 4'b0001;
parameter W_WDAT = 4'b0010;
parameter W_WREQ = 4'b0100;
parameter W_WSPI = 4'b1000;

reg [3:0]  CurStW, NxtStW;

wire  tWIdle  = CurStW[0];
wire  tWWDat  = CurStW[1];
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

reg	 [CAW:0]   PageEnd;
reg	        WPageMisCon;
reg  [CAW+1:0] WPageMisCal;
reg  [AW:0] WSpi2Addr;
wire [BL:0] WSpi2Len;
wire [AW:0] WSpi1Addr;
wire [BL:0] WSpi1Len;

reg	        RPageMisCon;
reg  [CAW+1:0] RPageMisCal;
reg  [AW:0] RSpi2Addr;
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
wire		iWValid;
wire		iARValid;
wire		iAWValid;
wire		WDatAck;

reg 		DelayiWQRead;
reg 		DelayxWQRead;
//-------------------------------------------------------------
// Write Command Path
assign  iAWReady = ~BBLQFull & ~WBLQFull & ~WQFull & ~QueErr & ~QueFul & (tWIdle | tWWSpi);

assign  AWReady  =  iAWReady;
assign  iAWValid =  iAWReady & AWValid;

// Write Control State Machine
always @(negedge ARESETB or posedge ACLK)
  	if (!ARESETB) CurStW <= W_IDLE;
  	else          CurStW <= NxtStW;

always @(tWIdle or tWWDat or tWWReq or tWWSpi or WDatAck or iAWValid or WriteAck or WPageMisCon) begin
  	NxtStW = W_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tWIdle  : 	if (iAWValid)			NxtStW = W_WDAT;	// Write Command Ack.
  	  	          	else        			NxtStW = W_IDLE;

  	  	tWWDat  : 	if (WDatAck)			NxtStW = W_WREQ;	// All WData Received
  	  	          	else        			NxtStW = W_WDAT;

        tWWReq  :   if (WriteAck) begin     
                        if (WPageMisCon)    NxtStW = W_WSPI;
                        else                NxtStW = W_IDLE;
                    end
                    else                    NxtStW = W_WREQ;

        tWWSpi  :   if (iAWValid)           NxtStW = W_WDAT;
                    else if (WriteAck)      NxtStW = W_IDLE;
                    else                    NxtStW = W_WSPI;

  	  	default :               			NxtStW = W_IDLE;
  	endcase
end

assign WDatAck  = WLast & iWValid;
assign WriteAck = AckMem;

// Page Miss Condition
always @(Port16Bit or ColAddrSiz or WriteLatAA or WriteLatTT)
	if(Port16Bit) begin
        case (ColAddrSiz) // synopsys parallel_case
            2'b00   :	WPageMisCal = WriteLatAA[CAW-4:0]+WriteLatTT;
            2'b01   :	WPageMisCal = WriteLatAA[CAW-3:0]+WriteLatTT;
            2'b10   :	WPageMisCal = WriteLatAA[CAW-2:0]+WriteLatTT;
            default :	WPageMisCal = WriteLatAA[CAW-1:0]+WriteLatTT;
		endcase
	end
	else begin
        case (ColAddrSiz) // synopsys parallel_case
            2'b00   :	WPageMisCal = WriteLatAA[CAW-3:0]+WriteLatTT;
            2'b01   :	WPageMisCal = WriteLatAA[CAW-2:0]+WriteLatTT;
            2'b10   :	WPageMisCal = WriteLatAA[CAW-1:0]+WriteLatTT;
            default :	WPageMisCal = WriteLatAA[CAW-0:0]+WriteLatTT;
		endcase
	end

always @(Port16Bit or ColAddrSiz or WPageMisCal)
	if(Port16Bit) begin
        case (ColAddrSiz) // synopsys parallel_case
            2'b00   :	WPageMisCon = WPageMisCal[CAW-4+1];
            2'b01   :	WPageMisCon = WPageMisCal[CAW-3+1];
            2'b10   :	WPageMisCon = WPageMisCal[CAW-2+1];
            default :	WPageMisCon = WPageMisCal[CAW-1+1];
		endcase
	end
	else begin
        case (ColAddrSiz) // synopsys parallel_case
            2'b00   :	WPageMisCon = WPageMisCal[CAW-3+1];
            2'b01   :	WPageMisCon = WPageMisCal[CAW-2+1];
            2'b10   :	WPageMisCon = WPageMisCal[CAW-1+1];
            default :	WPageMisCon = WPageMisCal[CAW-0+1];
		endcase
	end

always @(Port16Bit or ColAddrSiz)
	case (ColAddrSiz) // synopsys parallel_case
		2'b00   :	PageEnd = {CAW-3+1{1'b1}};	// 255, Depend On Page Size
		2'b01   :	PageEnd = {CAW-2+1{1'b1}};	// 511
		2'b10   :	PageEnd = {CAW-1+1{1'b1}};	// 1023
		default :	PageEnd = {CAW-0+1{1'b1}};	// 2047
	endcase

// Calculate Spilit Address
assign WSpi1Addr = WriteLatAA;
assign WSpi1Len  = WPageMisCon ? WriteLatTT-WSpi2Len-1 : WriteLatTT;

always @(ColAddrSiz or WriteLatAA)
	case (ColAddrSiz) // synopsys parallel_case
	    2'b00   :   WSpi2Addr = {WriteLatAA[AW:CAW-4+1]+1, {CAW-4+1{1'b0}}};
	    2'b01   :   WSpi2Addr = {WriteLatAA[AW:CAW-3+1]+1, {CAW-3+1{1'b0}}};
	    2'b10   :   WSpi2Addr = {WriteLatAA[AW:CAW-2+1]+1, {CAW-2+1{1'b0}}};
	    default :   WSpi2Addr = {WriteLatAA[AW:CAW-1+1]+1, {CAW-1+1{1'b0}}};
	endcase

assign WSpi2Len  = WPageMisCal-PageEnd-1;

// Calculate Wrap
reg [BL:0] WrWrapAALow;
always@(WriteLatBB or WriteLatA0 or WriteLatTT) 
	if (WriteLatBB == 2) begin
		case(WriteLatTT) // synopsys parallel_case
			4'd1    :  	WrWrapAALow = {WriteLatA0[BL:1], 1'b0}; // WrWrap Burst 2
			4'd3    :  	WrWrapAALow = {WriteLatA0[BL:2], 2'b0}; // WrWrap Burst 4
			4'd7    :  	WrWrapAALow = {WriteLatA0[BL],   3'b0}; // WrWrap Burst 8
			default :  	WrWrapAALow =                    4'b0 ; // WrWrap Burst 16
		endcase
	end
	else		   		WrWrapAALow = WriteLatA0[BL:0]; 		// Increment

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) WriteLatBB <= 0;
  	else if (iAWValid) WriteLatBB <= AWBurst;

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) WriteLatA0 <= 0;
  	else if (iAWValid) WriteLatA0 <= AWAddr;

assign WriteLatAA = {WriteLatA0[AW:BL+1], WrWrapAALow};

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) WriteLatTT <= 0;
  	else if (iAWValid) WriteLatTT <= AWLen;

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) WriteLatID <= 0;
  	else if (iAWValid) WriteLatID <= AWId;

assign WriteReqRW   = tWWReq | tWWSpi;
assign WriteRequest = tWWReq | tWWSpi;
assign WriteReqID   = WriteLatID;
assign WriteReqAA   = tWWReq ? WSpi1Addr : tWWSpi ? WSpi2Addr : 0;
assign WriteReqTT   = tWWReq ? WSpi1Len  : tWWSpi ? WSpi2Len  : 0;
//-------------------------------------------------------------
// Write Response Path
assign iBBLQRead = BReady;

assign BValid  = ~BBLQEmpty;
assign BId     = BBLQRdData;

// No Need WId, because not support interleaved Data Write
assign BResp    = 2'b0;

SDRBLQ #(BBLQCD, BBLQD, ID) BBLBuf(
            .nRST       (ARESETB),
            .Clk        (ACLK),
            .WriteEn    (BBLQWrite),
            .ReadEn     (BBLQRead),
            .WrData     (BBLQWrData),
            .RdData     (BBLQRdData),
            .FullFlag   (BBLQFull),
            .HFullFlag  (BBLQHFull),
            .EmptyFlag  (BBLQEmpty)
);

assign BBLQWrite = WDatAck   & ~BBLQFull;
assign BBLQRead  = iBBLQRead & ~BBLQEmpty;
//-------------------------------------------------------------
reg [BL:0]   WBurstCnt;
reg [BL:0]   LatchedWBL;
reg [WQCD:0] WrWrapCnt;
reg [BL:0]   WrWrapAddrSt;
reg 		 WrAddrHold;
wire[WQCD:0] WQIncAddr;

assign WBLQWrite  = ~WBLQFull & tWWDat & WDatAck;
assign iWBLQRead  = ~WBLQEmpty & iWQRead & (WBurstCnt == 0) & ~WrAddrHold;
assign WBLQRead   = iWBLQRead;

always@(negedge ARESETB or posedge ACLK)
    if      (!ARESETB)  WBurstCnt <= 0;
    else if (iWBLQRead) WBurstCnt <= WBLQRdData[BL:0];
    else if  (iWQRead) begin
		if (WrAddrHold) WBurstCnt <= WBurstCnt;
		else			WBurstCnt <= WBurstCnt - 1;
    end

always@(negedge ARESETB or posedge ACLK) 
    if      (!ARESETB)  LatchedWBL <= 0;
    else if (iWBLQRead) LatchedWBL <= WBLQRdData[BL:0];

always@(negedge ARESETB or posedge ACLK) 
    if      (!ARESETB)  WrAddrHold <= 0;
	else if (Port16Bit & iWQRead)   
						WrAddrHold <= WrAddrHold + 1;

always @(negedge ARESETB or posedge ACLK)
    if      (!ARESETB) begin
                            WrWrapAddrSt = 0;
                            WrWrapCnt   <= 0;
    end
    else if (iWBLQRead) begin
        if (WBLQRdData[WBLQW:WBLQW-1] == 2) begin
            case(WBLQRdData[BL:0]) // synopsys parallel_case
                4'd1    :   WrWrapAddrSt = {3'b0, WBLQRdData[BL+1]};      // WrWrap Burst 2
                4'd3    :   WrWrapAddrSt = {2'b0, WBLQRdData[BL+2:BL+1]}; // WrWrap Burst 4
                4'd7    :   WrWrapAddrSt = {1'b0, WBLQRdData[BL+3:BL+1]}; // WrWrap Burst 8
                default :   WrWrapAddrSt =        WBLQRdData[BL+4:BL+1];  // WrWrap Burst 16
            endcase
        end
        else                WrWrapAddrSt = 0; // Increment
        if (WrWrapAddrSt!=0)WrWrapCnt   <= WQIncAddr + (WBLQRdData[BL:0]+1 - WrWrapAddrSt);
        else                WrWrapCnt   <= WQIncAddr;
    end
    else if (iWQRead) begin
        if (~WrAddrHold & WrWrapAddrSt!=0 & ((LatchedWBL+1 - WrWrapAddrSt) == WBurstCnt))	// Wrap Arround
                            WrWrapCnt   <= WrWrapCnt - LatchedWBL;
        else begin
			if (WrAddrHold) WrWrapCnt   <= WrWrapCnt;
			else            WrWrapCnt   <= WrWrapCnt + 1;
		end
    end

SDRBLQ #(WBLQCD, WBLQD, WBLQW) WBLBuf(
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.WriteEn	(WBLQWrite), 
			.ReadEn		(WBLQRead), 
			.WrData		(WBLQWrData), 
			.RdData		(WBLQRdData), 
			.HFullFlag	(WBLQHFull), 
			.FullFlag	(WBLQFull), 
			.EmptyFlag	(WBLQEmpty)
);

assign  iWReady = ~WQFull & AckMem & tWWDat;// & ~WBLQFull;

assign  iWValid = iWReady & WValid;
assign  WReady  = iWReady;

assign  WQWrite = iWValid;
assign  iWQRead = ~WQEmpty & DiValid;
assign  WQRead  = iWQRead;

SDRWQ WDatBuf (
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.WriteEn	(WQWrite), 
			.ReadEn		(WQRead), 
			.AddrHold	(WrAddrHold), 
			.DelayReadEn(DelayiWQRead), 
			.WrData		(WQWrData), 
			.RdData		(WQRdData), 
			.FullFlag	(WQFull), 
			.HFullFlag	(WQHFull), 
			.EmptyFlag	(WQEmpty),
			.WrapCnt	(WrWrapCnt),
			.IncRdCnt	(WQIncAddr)
);

always@(negedge ARESETB or posedge ACLK) 
	if (!ARESETB) DelayiWQRead <= 1'b0;
	else          DelayiWQRead <= iWQRead;

always@(negedge ARESETB or posedge ACLK) 
	if (!ARESETB) DelayxWQRead <= 1'b0;
	else          DelayxWQRead <= DelayiWQRead;

reg Out16BitSel;
always@(negedge ARESETB or posedge ACLK) 
    if      (!ARESETB)  Out16BitSel <= 0;
	else if (Port16Bit & DelayxWQRead)   
						Out16BitSel <= Out16BitSel + 1;

assign SD_DQE = DelayxWQRead;
//assign SD_DQM = DelayxWQRead ? WQRdData[DW+BW+1:DW+1] : 0;
//assign SD_DQO = WQRdData[DW:0];

always @(Port16Bit or DelayxWQRead or Out16BitSel or WQRdData)
	if (DelayxWQRead) begin
		if (!Port16Bit)			SD_DQM = WQRdData[DW+BW+1:DW+1];
		else begin
			if (Out16BitSel)	SD_DQM = WQRdData[DW+BW+1:DW+1+2];
			else				SD_DQM = WQRdData[DW+1+1 : DW+1];
		end
	end
	else						SD_DQM = 0;

always @(Port16Bit or DelayxWQRead or Out16BitSel or WQRdData)
	if (DelayxWQRead) begin
		if (!Port16Bit)			SD_DQO = WQRdData[DW:0];
		else begin
			if (Out16BitSel)	SD_DQO = WQRdData[DW:(DW+1)/2];
			else				SD_DQO = WQRdData[((DW+1)/2)-1 : 0];
		end
	end
	else						SD_DQO = 0;
//-------------------------------------------------------------
// Read Command Path
`ifdef LIMIT
reg [RQCD+1:0] RdMaskCnt;
always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) 	RdMaskCnt <= 0;
  	else if (iARValid) 	RdMaskCnt <= RdMaskCnt + ARLen + 1;
  	else if (iRQRead)  	RdMaskCnt <= RdMaskCnt - 1;

assign  iARReady = tRIdle & ~QueErr & (RdMaskCnt <= ((RQD+1)/2)) & ~RBLQHFull;
`else
//assign  iARReady = tRIdle & ~QueErr & ~QueFul & ~RQHFull & ~RBLQFull & tWIdle;
assign  iARReady = tRIdle & ~QueErr & ~QueFul & ~RQHFull & ~RBLQFull;
`endif

assign  ARReady  = iARReady;
assign  iARValid = iARReady & ARValid;

// Read Control State Machine
always @(negedge ARESETB or posedge ACLK)
  	if (!ARESETB) CurStR <= R_IDLE;
  	else          CurStR <= NxtStR;

always @(tRIdle or tRRReq or tRRSpi or iARValid or ReadAck or RPageMisCon) begin
  	NxtStR = R_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tRIdle  : 	if (iARValid)			NxtStR = R_RREQ;
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

always @(Port16Bit or ColAddrSiz or ReadLatAA or ReadLatTT)
    if(Port16Bit) begin
        case (ColAddrSiz) // synopsys parallel_case
            2'b00   :   RPageMisCal = ReadLatAA[CAW-4:0]+ReadLatTT;
            2'b01   :   RPageMisCal = ReadLatAA[CAW-3:0]+ReadLatTT;
            2'b10   :   RPageMisCal = ReadLatAA[CAW-2:0]+ReadLatTT;
            default :   RPageMisCal = ReadLatAA[CAW-1:0]+ReadLatTT;
		endcase
    end
    else begin
        case (ColAddrSiz) // synopsys parallel_case
            2'b00   :   RPageMisCal = ReadLatAA[CAW-3:0]+ReadLatTT;
            2'b01   :   RPageMisCal = ReadLatAA[CAW-2:0]+ReadLatTT;
            2'b10   :   RPageMisCal = ReadLatAA[CAW-1:0]+ReadLatTT;
            default :   RPageMisCal = ReadLatAA[CAW-0:0]+ReadLatTT;
		endcase
    end

always @(Port16Bit or ColAddrSiz or RPageMisCal)
    if(Port16Bit) begin
        case (ColAddrSiz) // synopsys parallel_case
            2'b00   :   RPageMisCon = RPageMisCal[CAW-4+1];
            2'b01   :   RPageMisCon = RPageMisCal[CAW-3+1];
            2'b10   :   RPageMisCon = RPageMisCal[CAW-2+1];
            default :   RPageMisCon = RPageMisCal[CAW-1+1];
		endcase
    end
    else begin
        case (ColAddrSiz) // synopsys parallel_case
            2'b00   :   RPageMisCon = RPageMisCal[CAW-3+1];
            2'b01   :   RPageMisCon = RPageMisCal[CAW-2+1];
            2'b10   :   RPageMisCon = RPageMisCal[CAW-1+1];
            default :   RPageMisCon = RPageMisCal[CAW-0+1];
		endcase
    end

assign RSpi1Addr = ReadLatAA;
assign RSpi1Len  = RPageMisCon ? ReadLatTT-RSpi2Len-1 : ReadLatTT;

always @(ColAddrSiz or ReadLatAA)
	case (ColAddrSiz) // synopsys parallel_case
	    2'b00   :   RSpi2Addr = {ReadLatAA[AW:CAW-4+1]+1, {CAW-4+1{1'b0}}};
	    2'b01   :   RSpi2Addr = {ReadLatAA[AW:CAW-3+1]+1, {CAW-3+1{1'b0}}};
	    2'b10   :   RSpi2Addr = {ReadLatAA[AW:CAW-2+1]+1, {CAW-2+1{1'b0}}};
	    default :   RSpi2Addr = {ReadLatAA[AW:CAW-1+1]+1, {CAW-1+1{1'b0}}};
	endcase

assign RSpi2Len  = RPageMisCal-PageEnd-1;

reg [BL:0] RdWrapAALow;

always@(ReadLatBB or ReadLatA0 or ReadLatTT) 
	if (ReadLatBB == 2) begin
		case(ReadLatTT) // synopsys parallel_case
			4'd1    :  	RdWrapAALow = {ReadLatA0[BL:1], 1'b0}; // RdWrap Burst 2
			4'd3    :  	RdWrapAALow = {ReadLatA0[BL:2], 2'b0}; // RdWrap Burst 4
			4'd7    :  	RdWrapAALow = {ReadLatA0[BL],   3'b0}; // RdWrap Burst 8
			default :  	RdWrapAALow =                   4'b0 ; // RdWrap Burst 16
		endcase
	end
	else		   		RdWrapAALow = ReadLatA0[BL:0]; 		   // Increment

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) ReadLatBB <= 0;
  	else if (iARValid) ReadLatBB <= ARBurst;

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) ReadLatA0 <= 0;
  	else if (iARValid) ReadLatA0 <= ARAddr;

assign ReadLatAA = {ReadLatA0[AW:BL+1], RdWrapAALow};

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) ReadLatTT <= 0;
  	else if (iARValid) ReadLatTT <= ARLen;

always @(negedge ARESETB or posedge ACLK)
  	if 		(!ARESETB) ReadLatID <= 0;
  	else if (iARValid) ReadLatID <= ARId;

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
assign BA_ID  = WriteRequest ? WriteReqID : ReadRequest ? ReadReqID : 0;
assign BA_TT  = WriteRequest ? Port16Bit ? WriteReqTT*2+1 : WriteReqTT : 
				ReadRequest  ? Port16Bit ? ReadReqTT*2+1  : ReadReqTT  :
				0;

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
    if (!ARESETB) 		 	 RdDataMem <= 0;
    else begin
		if (!Port16Bit)	 	 RdDataMem <= RdDataMemFd;
		else begin
			if (!In16BitSel) RdDataMem[((DW+1)/2)-1:0] <= RdDataMemFd[((DW+1)/2)-1:0];
			else			 RdDataMem[DW:(DW+1)/2]    <= RdDataMemFd[((DW+1)/2)-1:0];
		end
	end

always@(negedge ARESETB or posedge ACLK) 
    if      (!ARESETB)  	 In16BitSel <= 0;
	else if (iDelayReadFlag) In16BitSel <= In16BitSel + 1;

always@(negedge ARESETB or posedge ACLK) 
    if      (!ARESETB)  	RdAddrHold <= 0;
	else if (Port16Bit & iDelayReadFlag) 	
							RdAddrHold <= RdAddrHold + 1;

reg [BL:0]   RBurstCnt;
reg [BL:0]   LatchedRBL;
reg [RQCD:0] RdWrapCnt;
reg [BL:0]   RdWrapAddrSt;
reg [RBLQCD:0] RdLastCnt;

assign RBLQWrite  = ~RBLQFull & iARValid;

assign iRBLQRead  = nRDReq & ~tRDReq;
assign RBLQRead   = iRBLQRead;

always@(negedge ARESETB or posedge ACLK) 
	if   	(!ARESETB) 	LatchedRBL <= 0;
	else if (iRBLQRead)	LatchedRBL <= RBLQRdData[BL:0];

wire [RQCD:0] RQIncAddr;

always @(negedge ARESETB or posedge ACLK)
  	if      (!ARESETB) begin
  							RdWrapAddrSt = 0;
  							RdWrapCnt   <= 0;
  	end
	else if (iRBLQRead) begin
		if (RBLQRdData[RBLQW:RBLQW-1] == 2) begin
			case(RBLQRdData[BL:0]) // synopsys parallel_case
				4'd1    :  	RdWrapAddrSt = {3'b0, RBLQRdData[BL+1]};      // RdWrap Burst 2
				4'd3    :  	RdWrapAddrSt = {2'b0, RBLQRdData[BL+2:BL+1]}; // RdWrap Burst 4
				4'd7    :  	RdWrapAddrSt = {1'b0, RBLQRdData[BL+3:BL+1]}; // RdWrap Burst 8
				default :  	RdWrapAddrSt = RBLQRdData[BL+4:BL+1];         // RdWrap Burst 16
			endcase
		end
		else		   		RdWrapAddrSt = 0;							  // Increment
		if (RdWrapAddrSt!=0)RdWrapCnt 	<= RQIncAddr + RdWrapAddrSt;
		else				RdWrapCnt 	<= RQIncAddr;
	end
    else if (RQRead) begin
        if (RdWrapAddrSt!=0 & (RdWrapAddrSt == RBurstCnt))
                            RdWrapCnt   <= RdWrapCnt - LatchedRBL;
        else 				RdWrapCnt	<= RdWrapCnt + 1;
    end

SDRBLQ #(RBLQCD, RBLQD, RBLQW) RBLBuf(
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.WriteEn	(RBLQWrite), 
			.ReadEn		(RBLQRead), 
			.WrData		(RBLQWrData), 
			.RdData		(RBLQRdData), 
			.HFullFlag	(RBLQHFull), 
			.FullFlag	(RBLQFull), 
			.EmptyFlag	(RBLQEmpty)
);

always@(negedge ARESETB or posedge ACLK) 
	if   	(!ARESETB) 	RBurstCnt <= 0;
	else if (iRBLQRead)	RBurstCnt <= RBLQRdData[BL:0];
	else if (RQRead) 	RBurstCnt <= RBurstCnt - 1;

wire ReadCntEnd = (RBurstCnt == 0) &  RQRead;
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
assign  RQRead  =  iRQRead;// & RReady;

SDRRQ RDatBuf (
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.nClk		(nACLK), 
			.AddrHold	(RdAddrHold), 
			.WriteEn	(RQWrite), 
			.ReadEn		(RQRead), 
			.WrData		(RQWrData), 
			.RdData		(RQRdData), 
			.FullFlag	(RQFull), 
			.HFullFlag	(RQHFull), 
			.EmptyFlag	(RQEmpty),
			.WrapCnt	(RdWrapCnt),
			.IncRdCnt	(RQIncAddr)
);

assign  RValid = iRQRead;
//assign  RResp  = iRQRead ? 2'b0 : 2'b11;
assign  RResp  = 2'b0;

assign  RData  = RQRdData;
assign  RId	   = RQRdData[RQW:RQW-ID];
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

wire WrWrapArround = WrWrapAddrSt!=0 & ((LatchedWBL+1 - WrWrapAddrSt) == WBurstCnt);

wire WrWrapEn = (WrWrapAddrSt!=0);
wire RdWrapEn = (RdWrapAddrSt!=0);

/*
reg WBLQError;
always @(negedge ARESETB or posedge ACLK)
	if (!ARESETB) 	WBLQError <= 0;
	else  begin		WBLQError <= WBLQFull & tWWReq & WriteAck;
		$display("Note : Write Length Buffer Full: %t", $time);
		//$stop;
	end
*/

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
