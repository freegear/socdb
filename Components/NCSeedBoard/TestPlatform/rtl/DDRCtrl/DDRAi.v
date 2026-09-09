
`timescale 1ns/10ps

module DDRAi (
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
    		SD_DQM,
    		SD_DQSE,
    		SD_DQSO,
    		SD_DQSI0,
    		SD_DQSI1,
    		nSD_DQSI0,
    		nSD_DQSI1
);

`include "DDRPara.v"

input    		ARESETB;  // asynchronous reset
input			nPOR;
input			MCLK;
input			nMCLK;
input    		ACLK;
input			nACLK;

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
input  [14:0]   BA_STS; // status
output			BA_REQ;
output [AW:0]	BA_AA;
output [BL:0]   BA_TT;
output [ID:0]	BA_ID;
output			BA_RW;
output			BA_PM;

// DDR SDRAM
output    		SD_DQE; // dq output enable
input  [MDW:0]	SD_DQI; // data input
output [MDW:0] 	SD_DQO; // data output
output [DMW:0]	SD_DQM;
output			SD_DQSE;
output [DMW:0]	SD_DQSO;
input         	SD_DQSI0;
input         	SD_DQSI1;
input           nSD_DQSI0;
input           nSD_DQSI1;
//-------------------------------------------------------------
wire  			BValid;
wire [ID:0] 	BId;

reg				SD_DQE;
reg [MDW:0]		SD_DQO;
reg [DMW:0]		SD_DQM;
reg 			SD_DQSE;
reg	[DMW:0]		SD_DQSO;

wire[DW:0] 		RdDataMem;

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
wire DqsoValid = BA_STS[10];
wire [1:0] ColAddrSiz = BA_STS[12:11];
wire RdDataInSel = BA_STS[13];
wire RdDataPol 	 = BA_STS[14];

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
wire [WQW:0]	WQWrData = {~WStrb, WData};
wire [WQW:0]	WQRdData;

wire WBLQWrite, WBLQRead;
wire iWBLQRead;
wire WBLQFull;
wire WBLQHFull;
wire WBLQEmpty;
wire [WBLQW:0]	WBLQWrData = {WriteLatBB, WriteLatA0[BL:0], WriteLatTT};
wire [WBLQW:0]	WBLQRdData;

wire BBLQWrite, BBLQRead;
wire iBBLQRead;
wire BBLQFull;
wire BBLQHFull;
wire BBLQEmpty;
wire [ID:0]	BBLQWrData = {WId};
wire [ID:0]	BBLQRdData;

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
wire RBLQHFull;
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

wire 		WriteAck;
wire 		ReadAck;

wire       WIncMisCon;
wire [BL+1:0]  WIncMisCal;
reg  [AW:0] WSpi2Addr;
wire [BL:0] WSpi2Len;
wire [AW:0] WSpi1Addr;
wire [BL:0] WSpi1Len;

wire       RIncMisCon;
wire [BL+1:0]  RIncMisCal;
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
//-------------------------------------------------------------
// Write Command Path
assign  iAWReady =  ~BBLQHFull & ~WBLQHFull & ~WQFull & ~QueErr & ~QueFul & (tWIdle | tWWSpi);
assign  AWReady  =  iAWReady;
assign  iAWValid =  iAWReady & AWValid;

// Write Control State Machine
always @(negedge ARESETB or posedge ACLK)
  	if (!ARESETB) CurStW <= W_IDLE;
  	else          CurStW <= NxtStW;

always @(tWIdle or tWWDat or tWWReq or tWWSpi or WDatAck or iAWValid or WriteAck or WIncMisCon) begin
  	NxtStW = W_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tWIdle  : 	if (iAWValid)			NxtStW = W_WDAT;	// Write Command Ack.
  	  	          	else        			NxtStW = W_IDLE;

  	  	tWWDat  : 	if (WDatAck)			NxtStW = W_WREQ;	// All WData Received
  	  	          	else        			NxtStW = W_WDAT;

  	  	tWWReq  : 	if (WriteAck) begin
  	  					if (WIncMisCon)		NxtStW = W_WSPI;
  	  					else 				NxtStW = W_IDLE;
  	  				end
  	  	          	else        			NxtStW = W_WREQ;

  	  	tWWSpi  : 	if (iAWValid)			NxtStW = W_WDAT;
  	  	          	else if (WriteAck)		NxtStW = W_IDLE;
  	  	          	else        			NxtStW = W_WSPI;

  	  	default :               			NxtStW = W_IDLE;
  	endcase
end

assign WDatAck  = WLast & iWValid;
assign WriteAck = AckMem;

// Inc Miss(DDR SDRAM Support Only Wrap Burst) Condition
assign WIncMisCal = WriteLatAA[BL:0]+WriteLatTT;
assign WIncMisCon = WIncMisCal[BL+1];

// Calculate Spilit Address
assign WSpi1Addr = WriteLatAA;
assign WSpi1Len  = WIncMisCon  ? WriteLatTT-WSpi2Len-1 : WriteLatTT;

always @(ColAddrSiz or WriteLatAA)
    case (ColAddrSiz) // synopsys parallel_case
        2'b00   :   WSpi2Addr = {WriteLatAA[AW:BL+1]+1, {BL+1{1'b0}}};
        2'b01   :   WSpi2Addr = {WriteLatAA[AW:BL+1]+1, {BL+1{1'b0}}};
        2'b10   :   WSpi2Addr = {WriteLatAA[AW:BL+1]+1, {BL+1{1'b0}}};
        default :   WSpi2Addr = {WriteLatAA[AW:BL+1]+1, {BL+1{1'b0}}};
    endcase

assign WSpi2Len  = WIncMisCal-{BL+1{1'b1}}-1;

// Calculate Wrap
reg [BL:0] WrWrapAALow;
always@(WriteLatBB or WriteLatA0 or WriteLatTT) 
	if (WriteLatBB == 2) begin
		case(WriteLatTT) // synopsys parallel_case
			4'd1    :  	WrWrapAALow = {WriteLatA0[BL:1], 1'b0}; // WrWrap Burst 2
			default :  	WrWrapAALow =  					 2'b0 ; // WrWrap Burst 4
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
//assign WriteLatAA = WriteLatA0;

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

DDRBLQ #(BBLQCD, BBLQD, ID) BBLBuf(
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

assign WBLQWrite  = ~WBLQFull & tWWDat & WDatAck;

assign iWBLQRead  = ~WBLQEmpty & iWQRead & (WBurstCnt == 0);
assign WBLQRead   = iWBLQRead;

always@(negedge ARESETB or posedge ACLK)
    if      (!ARESETB)  WBurstCnt <= 0;
    else if (iWBLQRead) WBurstCnt <= WBLQRdData[BL:0];
    else begin
        if  (iWQRead)   WBurstCnt <= WBurstCnt - 1;
        else            WBurstCnt <= WBurstCnt;
    end

always@(negedge ARESETB or posedge ACLK) 
    if      (!ARESETB)  LatchedWBL <= 0;
    else if (iWBLQRead) LatchedWBL <= WBLQRdData[BL:0];

wire [WQCD:0] WQIncAddr;

always @(negedge ARESETB or posedge ACLK)
    if      (!ARESETB) begin
                            WrWrapCnt <= 0;
                            WrWrapAddrSt = 0;
    end
    else if (iWBLQRead) begin
        if (WBLQRdData[WBLQW:WBLQW-1] == 2) begin
            case(WBLQRdData[BL:0]) // synopsys parallel_case
				4'd1    :  	WrWrapAddrSt = {1'b0, WBLQRdData[BL+1]}; // WrWrap Burst 2
				default :  	WrWrapAddrSt = { 	  WBLQRdData[BL+2:BL+1]}; // WrWrap Burst 4
            endcase
        end
        else                WrWrapAddrSt = 0; // Increment
        if (WrWrapAddrSt!=0)WrWrapCnt   <= WQIncAddr + (WBLQRdData[BL:0]+1 - WrWrapAddrSt);
        else                WrWrapCnt   <= WQIncAddr;
    end
    else if (iWQRead) begin
        if (WrWrapAddrSt!=0 & ((LatchedWBL+1 - WrWrapAddrSt) == WBurstCnt))
                            WrWrapCnt   <= WrWrapCnt - LatchedWBL;
        else                WrWrapCnt   <= WrWrapCnt + 1;
    end

DDRBLQ #(WBLQCD, WBLQD, WBLQW) WBLBuf(
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.WriteEn	(WBLQWrite), 
			.ReadEn		(WBLQRead), 
			.WrData		(WBLQWrData), 
			.RdData		(WBLQRdData), 
			.FullFlag	(WBLQFull), 
			.HFullFlag	(WBLQHFull), 
			.EmptyFlag	(WBLQEmpty)
);

assign  iWReady = ~WQFull & tWWDat & AckMem;// & ~WBLQFull;
assign  iWValid = iWReady & WValid;
assign  WReady  = iWReady;

assign  WQWrite = iWValid;
assign  iWQRead = ~WQEmpty & DiValid;
assign  WQRead  = iWQRead;

DDRWQ WDatBuf (
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.WriteEn	(WQWrite), 
			.ReadEn		(WQRead), 
			.WrData		(WQWrData), 
			.RdData		(WQRdData), 
			.FullFlag	(WQFull), 
			.HFullFlag	(WQHFull), 
			.EmptyFlag	(WQEmpty),
			.WrapCnt	(WrWrapCnt),
			.IncRdCnt	(WQIncAddr)
);
// -----------------------------------------------------------------------------
// DDR Write Data Path
wire  	 	NxtDQSEnOut;
wire  [1:0] NxtDQSOut;
wire        NxtDqsSel;

reg   [3:0] DQMACLKQ;

reg  [31:0] WrDtACLKQ;
reg			DataEnOutQ;
reg			DataEnOutQ2;
reg    		DataEnOutACLKQ;
reg         PosedgeSyncACLK;
reg         UHalfWrdFtch;
reg         NxtUHalfWrdFtch;
reg  [15:0] FtchdHWQ;
reg  [15:0] FtchdHWQ2;
reg  [15:0] NxtFtchdHW;
reg   [1:0] HWMaskQ;
reg   [1:0] HWMaskQ2;
reg   [1:0] NxtHWMask;

reg         DqsSel;
reg   [1:0] DQSOut;
reg         DQSOutGen;
reg  [2:0] 	DqsCnt;

reg			WQDataValid;

always@(negedge ARESETB or posedge ACLK) 
	if (!ARESETB) begin
			WQDataValid 	<= 1'b0;
			DataEnOutACLKQ  <= 1'b0;
	end
	else begin
		    WQDataValid 	<= iWQRead;
		    DataEnOutACLKQ  <= WQDataValid;
	end

always @(negedge ARESETB or posedge ACLK)
    if (!ARESETB) begin
            DQMACLKQ   <= {4{1'b1}};
            WrDtACLKQ  <= {32{1'b0}};
    end
    else begin
        if (WQDataValid) begin
            DQMACLKQ   <= WQRdData[DW+BW+1:DW+1];	// 35:32
            WrDtACLKQ  <= WQRdData[DW:0];
        end 
        else begin
            DQMACLKQ   <= 4'hf;
            WrDtACLKQ  <= WrDtACLKQ;
        end 
    end

// -----------------------------------------------------------------------------
// The PosedgeSyncACLK is used by the DDR data path to ensure that 'first' the
// lower 16 bits are driven and next the higher 16 bits are driven on the
// external 16-bit databus for the DDRs.
// -----------------------------------------------------------------------------
always @(negedge nPOR or posedge ACLK)
  	if (!nPOR)	PosedgeSyncACLK <= 1'b0;
  	else		PosedgeSyncACLK <= 1'b1;

always @(PosedgeSyncACLK or UHalfWrdFtch or WrDtACLKQ or DQMACLKQ)
begin : p_DtPathComb
  	NxtFtchdHW    = 16'b0;
  	NxtHWMask     = 2'b11;
  	NxtUHalfWrdFtch  = 1'b0;
  	if (PosedgeSyncACLK) begin
  	    if (!UHalfWrdFtch) begin
  	        NxtFtchdHW    = WrDtACLKQ[15:0];
  	        NxtHWMask     = DQMACLKQ[1:0];
  	        NxtUHalfWrdFtch = 1'b1;
  	    end
  	    else begin
  	        NxtFtchdHW    = WrDtACLKQ[31:16];
  	        NxtHWMask     = DQMACLKQ[3:2];
  	        NxtUHalfWrdFtch = 1'b0;
  	    end
  	end
end

// -----------------------------------------------------------------------------
// Sequential block for p_DtPathComb (write data path).
// -----------------------------------------------------------------------------
always @(negedge nPOR or posedge nMCLK)
begin : p_DtPathSeq
  	if (!nPOR) begin
  	    FtchdHWQ    <= {16{1'b0}};
  	    HWMaskQ     <= 2'b11;
  	    DataEnOutQ  <= 1'b0;

  	    FtchdHWQ2   <= {16{1'b0}};
  	    HWMaskQ2    <= 2'b11;
  	    DataEnOutQ2 <= 1'b0;
  	
  	    UHalfWrdFtch  <= 1'b0;
  	end
  	else begin
  	    FtchdHWQ    <= NxtFtchdHW;
  	    HWMaskQ     <= NxtHWMask;
  	    DataEnOutQ  <= DataEnOutACLKQ;
  	
  	  	FtchdHWQ2   <= FtchdHWQ;
  	    HWMaskQ2    <= HWMaskQ;
  	    DataEnOutQ2 <= DataEnOutQ;

  	    UHalfWrdFtch  <= NxtUHalfWrdFtch;
  	end
end // p_DtPathSeq

always @(HWMaskQ2 or FtchdHWQ2 or DataEnOutQ2)
begin
	SD_DQM = HWMaskQ2;
	SD_DQO = FtchdHWQ2;
	SD_DQE = DataEnOutQ2;
end
//-------------------------------------------------------------
// DQS Singal Generation
always @(DqsCnt) DQSOutGen = |DqsCnt;	// DDR Burst8 DQS Generation For Write

always @(negedge ARESETB or posedge ACLK)
	if (!ARESETB)	DqsCnt <= 0;
	else if (DqsoValid)
					DqsCnt <= 5;	// if Burst4 then, 3
	else begin
		if (DqsCnt == 0)			
					DqsCnt <= 0;
		else		DqsCnt <= DqsCnt - 1;
	end

// -----------------------------------------------------------------------------
// The signal to indicate the DQS signal needs to be toggled
// -----------------------------------------------------------------------------
assign   NxtDqsSel = DQSOutGen & ~DqsSel;

always @(negedge nPOR or posedge MCLK)
  	if (!nPOR)	DqsSel <= 1'b0;
  	else		DqsSel <= NxtDqsSel;

assign  NxtDQSOut   = {DqsSel, DqsSel};
assign  NxtDQSEnOut = DQSOutGen;

always @(negedge nPOR or posedge MCLK)
  	if (!nPOR)	DQSOut <= {2{1'b0}};
  	else		DQSOut <= NxtDQSOut;

always @(negedge nPOR or posedge MCLK)
  	if (!nPOR)	SD_DQSO <= {2{1'b0}};
  	else		SD_DQSO <= NxtDQSOut;

always @(negedge nPOR or posedge ACLK)
	if (!nPOR) 	SD_DQSE <= 1'b0;
	else 		SD_DQSE <= NxtDQSEnOut;
// -----------------------------------------------------------------------------
// Read Command Path
assign  iARReady = tRIdle & ~QueFul & ~QueErr & ~RQHFull & ~RBLQHFull;
assign  ARReady  = iARReady;
assign  iARValid = iARReady & ARValid;

// Read Control State Machine
always @(negedge ARESETB or posedge ACLK)
  	if (!ARESETB) CurStR <= R_IDLE;
  	else          CurStR <= NxtStR;

always @(tRIdle or tRRReq or tRRSpi or iARValid or ReadAck or RIncMisCon) begin
  	NxtStR = R_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tRIdle  : 	if (iARValid)			NxtStR = R_RREQ;
  	  	          	else        			NxtStR = R_IDLE;
  	  	          	            
  	  	tRRReq  : 	if (ReadAck) begin
  	  					if (RIncMisCon)		NxtStR = R_RSPI;
  	  					else 				NxtStR = R_IDLE;
  	  				end
  	  	          	else        			NxtStR = R_RREQ;
   	  				                		
  	  	tRRSpi  : 	if (ReadAck) 			NxtStR = R_IDLE;
  	  	          	else        			NxtStR = R_RSPI;
 	  	                            		
  	  	default :               			NxtStR = R_IDLE;
  	endcase
end

assign ReadAck    = AckMem & ~(tWWReq | tWWSpi); // Read Mask When Write Request

// Inc Miss Condition
assign RIncMisCal = ReadLatAA[BL:0]+ReadLatTT;
assign RIncMisCon = RIncMisCal[BL+1];

// Calculate Spilit Address
assign RSpi1Addr = ReadLatAA;
assign RSpi1Len  = RIncMisCon  ? ReadLatTT-RSpi2Len-1 : ReadLatTT;

always @(ColAddrSiz or ReadLatAA)
    case (ColAddrSiz) // synopsys parallel_case
        2'b00   :   RSpi2Addr = {ReadLatAA[AW:BL+1]+1, {BL+1{1'b0}}};
        2'b01   :   RSpi2Addr = {ReadLatAA[AW:BL+1]+1, {BL+1{1'b0}}};
        2'b10   :   RSpi2Addr = {ReadLatAA[AW:BL+1]+1, {BL+1{1'b0}}};
        default :   RSpi2Addr = {ReadLatAA[AW:BL+1]+1, {BL+1{1'b0}}};
    endcase

assign RSpi2Len  = RIncMisCal-{BL+1{1'b1}}-1;

reg [BL:0] RdWrapAALow;

always@(ReadLatBB or ReadLatA0 or ReadLatTT) 
	if (ReadLatBB == 2) begin
		case(ReadLatTT) // synopsys parallel_case
			4'd1    :  	RdWrapAALow = {ReadLatA0[BL:1], 1'b0}; // RdWrap Burst 2
			default :  	RdWrapAALow = 					2'b0 ; // RdWrap Burst 4
		endcase
	end
	else		   		RdWrapAALow = ReadLatA0[BL:0]; 		// Increment

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
assign BA_REQ = WriteRequest |  ReadRequest;
assign BA_PM  = tRRReq & RIncMisCon;	// Read Last Mask at Page Miss Condition
assign BA_RW  = WriteReqRW   | ~ReadRequest;
assign BA_AA  = WriteRequest ? WriteReqAA : ReadRequest ? ReadReqAA : 0;
assign BA_TT  = WriteRequest ? WriteReqTT : ReadRequest ? ReadReqTT : 0;
assign BA_ID  = WriteRequest ? WriteReqID : ReadRequest ? ReadReqID : 0;
// -----------------------------------------------------------------------------
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
        iDelayReadFlag <= DoValid;
        RdDataRdy      <= iDelayReadFlag;
        iDelayReadLast <= RdLast;
        RdLastMem      <= iDelayReadLast;
        iDelayReadId   <= RdId;
        RdIdMem	   	   <= iDelayReadId;
    end

// DDR Read Data Path
reg   [7:0] RData1stStgLo;
reg   [7:0] RData1stStgHi;
reg  [31:0] RDatanACLK;
reg  [31:0] RData2ndStg;
reg  [31:0]	R16Data;

wire [31:0] NxtR16Data;
wire [15:0] RData1stStg;
wire [31:0] NxtRData2ndStg;

always @(negedge nPOR or posedge SD_DQSI0)
	if (!nPOR)	RData1stStgLo <= 8'b0;
	else		RData1stStgLo <= SD_DQI[7:0];

always @(negedge nPOR or posedge SD_DQSI1)
	if (!nPOR)	RData1stStgHi <= 8'b0;
	else		RData1stStgHi <= SD_DQI[15:8];

assign RData1stStg    = {RData1stStgHi, RData1stStgLo};
// assign NxtRData2ndStg = RdDataInSel ? {RData1stStg, SD_DQI[15:0]} : {SD_DQI[15:0], RData1stStg};
assign NxtRData2ndStg = {SD_DQI[15:0], RData1stStg};

// -----------------------------------------------------------------------------
// Sequential block for third and first bytelanes of RData2ndStg.
// -----------------------------------------------------------------------------
always @(negedge nPOR or posedge nSD_DQSI0)
	if (!nPOR) begin
	  	RData2ndStg[23:16] <= 8'b0;
	  	RData2ndStg[7:0]   <= 8'b0;
	end
	else begin
	  	RData2ndStg[23:16] <= NxtRData2ndStg[23:16];
	  	RData2ndStg[7:0]   <= NxtRData2ndStg[7:0];
	end

always @(negedge nPOR or posedge nSD_DQSI1)
	if (!nPOR) begin
	  	RData2ndStg[31:24] <= 8'b0;
	  	RData2ndStg[15:8]  <= 8'b0;
	end
	else begin
	  	RData2ndStg[31:24] <= NxtRData2ndStg[31:24];
	  	RData2ndStg[15:8]  <= NxtRData2ndStg[15:8];
	end

always @(negedge nPOR or posedge nACLK)
	if (!nPOR) 	RDatanACLK  <= 32'b0;
	else		RDatanACLK  <= RData2ndStg;

assign NxtR16Data = (RdDataPol) ? RDatanACLK  : RData2ndStg;

always @(negedge nPOR or posedge ACLK)
	if (!nPOR) 	R16Data <= 32'b0;
	else 		R16Data <= NxtR16Data;

assign RdDataMem = R16Data;	// Register Select

reg [BL:0]   RBurstCnt;
reg [BL:0]   RBLCnt;
reg [BL:0]   LatchedRBL;
reg [RQCD:0] RdWrapCnt;
reg [BL:0]   RdWrapAddrSt;
wire         RdWrapEn;
wire         RdWrapArround;

reg [RBLQCD:0] RdLastCnt;

assign RBLQWrite  = ~RBLQFull & iARValid;

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
				4'd1    :  	RdWrapAddrSt = {1'b0, RBLQRdData[BL+1]}; // RdWrap Burst 2
				default :  	RdWrapAddrSt = {	  RBLQRdData[BL+2:BL+1]}; // RdWrap Burst 4
			endcase
		end
		else		   		RdWrapAddrSt = 0;				// Increment
		if (RdWrapAddrSt!=0)RdWrapCnt 	<= RQIncAddr + RdWrapAddrSt;
		else				RdWrapCnt 	<= RQIncAddr;
	end
  	else if (RdWrapArround) RdWrapCnt <= RdWrapCnt - LatchedRBL;
  	else if (iRQRead)  	  	RdWrapCnt <= RdWrapCnt + 1;

DDRBLQ #(RBLQCD, RBLQD, RBLQW) RBLBuf(
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

DDRRQ RDatBuf (
			.nRST		(ARESETB), 
			.Clk		(ACLK), 
			.nClk		(nACLK), 
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
/*
// -----------------------------------------------------------------------------
// Sequential block for Clocking CalibReq and MPMCDC and MPMCCALIBREQ
// -----------------------------------------------------------------------------
reg         iDllCaliReq;
// Internal version of DllCaliReq

reg         DllCalibReqQ2;
// One clock delayed version of DLL calibration requests from memory controller

reg         MPMCDCQ2;
// One clock delayed version of MPMC DLL Control

reg         DllCaliAckQ2;
// One clock delayed version of The DLL Calibration request acknowledge

reg         NxtDllCaliReq;
// D-input of DLL calibration request to the external DLL block
always @(negedge nPOR or posedge ACLK)
begin : p_CalibSeq
  if (!nPOR)
  begin
    MPMCDCQ2           <= 1'b0;
    DllCalibReqQ2      <= 1'b0;
    iDllCaliReq        <= 1'b0;
    DllCaliAckQ2       <= 1'b0;
  end
  else
  begin
    MPMCDCQ2           <= MPMCDC;
    DllCalibReqQ2      <= DllCalibReq;
    iDllCaliReq        <= NxtDllCaliReq;
    DllCaliAckQ2       <= DllCaliAck;
  end
end // p_CalibSeq

// -----------------------------------------------------------------------------
// Detect the rising edge of CalibReq of MPMCDC, and raise the Calibration
// request. Once the falling edge of ACK has been detected, pull the Request
// down.
// -----------------------------------------------------------------------------
always @(MPMCDC or MPMCDCQ2 or DllCalibReq or DllCalibReqQ2 or DllCaliAck or
         DllCaliAckQ2 or iDllCaliReq)
begin : p_CalibComb
  SetMPMCDS           = 1'b0;
  if ((MPMCDC == 1'b1 & MPMCDCQ2 == 1'b0) |
     (DllCalibReq == 1'b1 & DllCalibReqQ2 == 1'b0))
    NxtDllCaliReq    = 1'b1;
  else if (DllCaliAck == 1'b0 & DllCaliAckQ2 == 1'b1)
  begin
    NxtDllCaliReq    = 1'b0;
    SetMPMCDS        = 1'b1;
  end
  else
    NxtDllCaliReq    = iDllCaliReq;
end // p_CalibComb
*/
//-------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
wire WriteReq = BA_REQ & AckMem &  BA_RW;
wire ReadReq  = BA_REQ & AckMem & ~BA_RW;

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
