
`timescale 1ns/1ns

module CursorDma(
				Clk, 
				nRST,
				FIFOClear,
				CPlaneEn,
				FrameStart,
				CPlaneN2PUpEn,
				
				CPlaneStartAddr,
				CPlaneStartAddr2,
				CPlaneXSize,
				CPlaneYSize,
				CPlanePixFormat,
				CPlaneAddrSwEn,
				CPlaneAddrSwVal,
				CPlaneXRef,

				CDMARDataValid,
				CDMARLast,
				CDMARData,
				CDMARCmd,
				CDMARCmdAck,
				CDMARBurstLen,
				CDMARAddr,
								
				CDMADataRequest,
				CDMADataValid,
				CDMADataIn,
				CursorEn,
				
				CDMAOverRun,
				CDMAUnderRun
);

`include "DmPara.v"

// System
input			Clk; 
input			nRST;
input			FIFOClear;
input			CPlaneEn;
input			FrameStart;
input			CPlaneN2PUpEn;

// Plane X/Y Cordinate
input [AW:0] 	CPlaneStartAddr, CPlaneStartAddr2;
input [CW:0] 	CPlaneXSize;
input [CW:0] 	CPlaneYSize;
input [CW+1:0] 	CPlaneXRef;
input [ 1:0]	CPlanePixFormat;	// 00: 8bit, 1x: 16bit
input			CPlaneAddrSwEn;
input [ 5:0]	CPlaneAddrSwVal;

// Cursor DMA
input			CDMARDataValid;
input			CDMARLast;
input [DW:0]	CDMARData;
input			CDMARCmdAck;
output			CDMARCmd;
output [ 4:0]	CDMARBurstLen;
output [AW:0]	CDMARAddr;

// Cursor DMA FIFO
input		 	CDMADataRequest;
output		 	CDMADataValid;
output [DW:0] 	CDMADataIn;
input			CursorEn;

output			CDMAOverRun;
output			CDMAUnderRun;
//-------------------------------------------------------------------------------
parameter C_IDLE = 4'b0001;
parameter C_DREQ = 4'b0010;
parameter C_DCAL = 4'b0100;
parameter C_DEND = 4'b1000;

reg [3:0]  CurStC, NxtStC;

wire  tCIdle  = CurStC[0];
wire  tCDReq  = CurStC[1];
wire  tCDCal  = CurStC[2];
wire  tCDEnd  = CurStC[3];

// Cursor Plane
wire 			CursorDmaEn;
wire		 	CDMADataRequest;

reg	[ 5:0]		CBFrameCnt;	// Cursor Blink Frame Count
wire			CBFrameCntInc;
wire			CBFrameCntEnd;
reg				CDMARAddrSel;

// Cursor Count
reg [ 2:0]		N2PUpCnt;	// NTSC480 to PAL576 Up Scale Count 5 -> 6, insert 1 line each 6 line
wire			N2PUpCntEnd   = N2PUpCnt == 6;
wire			N2PUpAddrHold = N2PUpCnt == 5;

reg [CW:0] 		YDmaReqCnt;
reg [CW:0] 		XDmaReqCnt;
reg [ 3:0] 		BurstSiz;

wire 			CBLQWrite, CBLQRead;
wire 			iCBLQRead;
wire 			CBLQHFull, CBLQQFull;
wire 			CBLQFull;
wire 			CBLQEmpty;
wire [CBLQW:0]	CBLQWrData = BurstSiz;
wire [CBLQW:0]	CBLQRdData;
reg  [3:0] 		BurstCnt;
wire  			BurstEnd;

// Cursor DMA
wire 			CDMARCmd;
reg  [ 4:0]		CDMARBurstLen;
reg  [AW:0]		CDMARAddr;

// Cursor DMA FIFO
reg				CDMARDataValidD;
wire 			CurFIFOWrite;
reg  [DW:0] 	CurFIFOWrData;
wire 			CurFIFORead;
wire [DW:0] 	CurFIFORdData;

wire			CurFIFOAlmostEmpty;
wire			CurFIFOEmpty;
wire			CurFIFOFull;
wire			CurFIFOHalfFull;

wire			ReqMask = CPlanePixFormat[1] ? ~CBLQHFull : ~CBLQQFull;
reg 			CDMAEn;
wire			GoDMARequest = ReqMask & CDMAEn;
wire			XDmaReqEnd   = XDmaReqCnt == CPlaneXSize;
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
  	if (!nRST) 	CurStC <= C_IDLE;
  	else if (FIFOClear)
  				CurStC <= C_IDLE;
  	else        CurStC <= NxtStC;

always @(tCIdle or tCDReq or tCDCal or tCDEnd or CDMAEn or
		CursorDmaEn or GoDMARequest or CDMARCmdAck or XDmaReqEnd) begin
  	NxtStC = C_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tCIdle  : 	if (CursorDmaEn)		NxtStC = C_DCAL;
  	  	          	else        			NxtStC = C_IDLE;

		tCDCal	:	if (!CDMAEn)			NxtStC = C_IDLE;
  	  				else if (XDmaReqEnd)	NxtStC = C_DEND;
  	  				else if (GoDMARequest)	NxtStC = C_DREQ;
  	  				else					NxtStC = C_DCAL;

  	  	tCDReq  : 	if (CDMARCmdAck) 		NxtStC = C_DCAL;
  	  				else					NxtStC = C_DREQ;

  	  	tCDEnd  : 	if (!CDMAEn)			NxtStC = C_IDLE;
  	  				else 					NxtStC = C_DCAL;

  	  	default :               			NxtStC = C_IDLE;
  	endcase
end
//-------------------------------------------------------------------------------
assign CursorDmaEn = CPlaneEn & FrameStart;
assign CDMARCmd = tCDReq;
wire   CDMAEnd = YDmaReqCnt == CPlaneYSize;

always @(negedge nRST or posedge Clk)
	if 		(!nRST)	CDMAEn <= 0;
	else if (CDMAEnd | FIFOClear)
					CDMAEn <= 0;
	else if (CursorDmaEn)
					CDMAEn <= 1;
	else			CDMAEn <= CDMAEn;

always @(negedge nRST or posedge Clk)
	if 		(!nRST) begin
					N2PUpCnt	<= 0;
	end
	else if (FIFOClear | (tCIdle & CursorDmaEn) | N2PUpCntEnd) begin
					N2PUpCnt	<= 0;
	end
	else if (tCDCal & XDmaReqEnd) begin
		if (CPlaneN2PUpEn)
					N2PUpCnt	<= N2PUpCnt + 1;
	end

always @(negedge nRST or posedge Clk)
begin
	if 		(!nRST) begin
					BurstSiz 	<= 0;
					CDMARAddr  	<= 0;
					XDmaReqCnt 	<= 0;
					YDmaReqCnt	<= 0;
	end
	else if (FIFOClear) begin
					BurstSiz 	<= 0;
					XDmaReqCnt 	<= 0;
					YDmaReqCnt	<= 0;
	end
	else if (tCIdle & CursorDmaEn) begin // Initial Load Register Value
					BurstSiz 	<= CPlaneMaxBL;
					XDmaReqCnt 	<= 0;
					YDmaReqCnt	<= 0;
			if (CDMARAddrSel) 
					CDMARAddr   <= CPlaneStartAddr2;
			else 	CDMARAddr   <= CPlaneStartAddr;
	end
	else if (tCDCal) begin
		if (CPlaneXSize-XDmaReqCnt > CPlaneMaxBL)
					BurstSiz 	<= CPlaneMaxBL;
		else 		BurstSiz 	<= CPlaneXSize-XDmaReqCnt;
	end
	else if (tCDReq & CDMARCmdAck) begin
		if (BurstSiz == 0)	
					CDMARAddr  	<= CDMARAddr + 1;
		else 		CDMARAddr  	<= CDMARAddr + BurstSiz;
					XDmaReqCnt	<= XDmaReqCnt + BurstSiz;
	end
	else if (tCDEnd) begin
//					CDMARAddr  	<= CDMARAddr + CPlaneXRef;
			if (N2PUpAddrHold)
					//CDMARAddr 	<= CDMARAddr + CPlaneXRef - (CPlaneXSize + CPlaneXRef);
					CDMARAddr 	<= CDMARAddr - CPlaneXSize;
			else
					CDMARAddr 	<= CDMARAddr + CPlaneXRef;

					XDmaReqCnt 	<= 0;
					YDmaReqCnt	<= YDmaReqCnt+1;
	end
	else if	(CDMAEnd) YDmaReqCnt	<= 0;
end

always @(BurstSiz)
	if (BurstSiz == 0)	CDMARBurstLen = 0;
	else				CDMARBurstLen = {BurstSiz, 2'b0} - 1;	// 32bit Access
//-------------------------------------------------------------------------------
assign CBFrameCntInc = CPlaneEn & CPlaneAddrSwEn & CDMAEnd & CDMAEn;
assign CBFrameCntEnd = CPlaneEn & CPlaneAddrSwEn & CBFrameCnt == CPlaneAddrSwVal;

always@(negedge nRST or posedge Clk)
    if  	(!nRST)			CBFrameCnt <= 0;
    else if (CBFrameCntEnd)	CBFrameCnt <= 0;
    else if (CBFrameCntInc) CBFrameCnt <= CBFrameCnt + 1;

always@(negedge nRST or posedge Clk)
    if  	(!nRST)			CDMARAddrSel <= 0;
    else if (CBFrameCntEnd) CDMARAddrSel <= CDMARAddrSel + 1;
//-------------------------------------------------------------------------------
assign CBLQWrite  = ~CBLQFull  & tCDReq & CDMARCmdAck;
assign iCBLQRead  = ~CBLQEmpty & BurstEnd;
assign CBLQRead   = iCBLQRead;
assign BurstEnd   = CDMADataValid & (BurstCnt == CBLQRdData -1);

always@(negedge nRST or posedge Clk)
    if      (!nRST)  		BurstCnt <= 0;
    else if (iCBLQRead) 	BurstCnt <= 0;
    else if (CDMADataValid)	BurstCnt <= BurstCnt + 1;

DmaBLQ #(CBLQCD, CBLQD, CBLQW) CDMACBLQ(
			.nRST		(nRST), 
			.Flush		(FIFOClear | ~CursorEn),
			.Clk		(Clk), 
			.WriteEn	(CBLQWrite), 
			.ReadEn		(CBLQRead), 
			.WrData		(CBLQWrData), 
			.RdData		(CBLQRdData), 
			.HFullFlag	(CBLQHFull),
			.QFullFlag	(CBLQQFull),
			.FullFlag	(CBLQFull), 
			.EmptyFlag	(CBLQEmpty)
);
//-------------------------------------------------------------------------------
always@(negedge nRST or posedge Clk)
    if  (!nRST)	CDMARDataValidD <= 0;
    else  		CDMARDataValidD <= CDMARDataValid;

assign CurFIFOWrite = CDMARDataValidD & ~CurFIFOFull;

always @(negedge nRST or posedge Clk)
	if  (!nRST)	CurFIFOWrData <= 0;
	else 		CurFIFOWrData <= CDMARData;

//ScFIFO32x32 #(5, CPlaneMaxBL*2, DW+1) CursorFIFO(
ScFIFO64x32 #(6, CPlaneMaxBL*2, DW+1) CursorFIFO(
			.Clk			(Clk), 
			.nRST			(nRST), 
			.FIFOFlush		(FIFOClear | ~CursorEn), 
			.FIFOWrData		(CurFIFOWrData), 
			.FIFOWrite		(CurFIFOWrite), 
			.FIFORdData		(CurFIFORdData), 
			.FIFORead		(CurFIFORead),
			.FIFOHalfFull	(CurFIFOHalfFull), 
			.FIFOFull		(CurFIFOFull), 
			.FIFOEmptyWr	(),
			.FIFOAlmostEmpty(CurFIFOAlmostEmpty),
			.FIFOEmpty		(CurFIFOEmpty)
);

assign CurFIFORead = CDMADataRequest & ~CurFIFOEmpty & ~(CurFIFOWrite & CurFIFOAlmostEmpty);

assign CDMADataValid = CurFIFORead;
assign CDMADataIn = CurFIFORdData;
//-------------------------------------------------------------------------------
assign CDMAOverRun  = CDMARDataValid  & CurFIFOFull;
assign CDMAUnderRun = CDMADataRequest & CurFIFOEmpty;
//-------------------------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
always @(CDMAOverRun)
	if(CDMAOverRun) begin
		$display("%m ERROR: Cursor Plane DMA FIFO Error (%t)",$time);
		$stop;
	end
// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on
// -----------------------------------------------------------------------------
endmodule