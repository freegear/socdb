
module OR1200Reg(
	Clk, nRST,
	SPRCs, SPRWrite, SPRAddr, SPRDataIn, SPRDataOut,
	CQRead, CQWrite, CQWrData, CQFull, CQEmpty,
	CBRead, CBData, CBEmpty, RE, RSA, LEN
);

`include "GpuPara.v"

input			Clk;
input			nRST;

input			SPRCs, SPRWrite;
input	[31:0]	SPRAddr, SPRDataIn; 
output	[31:0]	SPRDataOut;

input			CQWrite;
input	[31:0]	CQWrData;
output			CQFull, CQEmpty;
output			CQRead;

output			CBRead;
input 	[31:0]	CBData;
input			CBEmpty;

output			RE ;
output	[ 4:0]	LEN;	// Read
output	[31:0]	RSA;
//------------------------------------------------------------------------------
wire			CQRead;
wire	[31:0]	CQRdData;
//------------------------------------------------------------------------------
wire rCQCONSel = SPRCs & (SPRAddr[7:0] == CQCON[9:2]);
wire rCQSTSSel = SPRCs & (SPRAddr[7:0] == CQSTS[9:2]);  
wire rCQDATSel = SPRCs & (SPRAddr[7:0] == CQDAT[9:2]);  
wire rCBCONSel = SPRCs & (SPRAddr[7:0] == CBCON[9:2]);  
wire rCBRSASel = SPRCs & (SPRAddr[7:0] == CBRSA[9:2]);  
wire rCBDATSel = SPRCs & (SPRAddr[7:0] == CBDAT[9:2]);  

wire rCQCONWr  = rCQCONSel	& SPRWrite;
wire rCQSTSWr  = rCQSTSSel	& SPRWrite; 
wire rCQDATWr  = rCQDATSel	& SPRWrite; 
wire rCBCONWr  = rCBCONSel	& SPRWrite;
wire rCBRSAWr  = rCBRSASel	& SPRWrite;

wire rCQCONRd  = rCQCONSel	& ~SPRWrite;
wire rCQSTSRd  = rCQSTSSel	& ~SPRWrite; 
wire rCQDATRd  = rCQDATSel	& ~SPRWrite; 
wire rCBCONRd  = rCBCONSel	& ~SPRWrite;
wire rCBRSARd  = rCBRSASel	& ~SPRWrite;
wire rCBDATRd  = rCBDATSel	& ~SPRWrite;
//------------------------------------------------------------------------------
assign	CQRead     = rCQDATRd;
//------------------------------------------------------------------------------
// Command Queue
GpuCmdQ GpuCmdQ(
				.nRST 			(nRST), 
				.Clk 			(Clk), 
				.WriteEn		(CQWrite), 
				.ReadEn			(CQRead), 
				.WrData			(CQWrData), 
				.RdData			(CQRdData), 
				.QFullFlag		(), 
				.HFullFlag		(), 
				.FullFlag		(CQFull), 
				.EmptyFlag		(CQEmpty)
);
//------------------------------------------------------------------------------
// Command Buffer
reg			RE ;
reg	[ 4:0]	LEN; 
always @(negedge nRST or posedge Clk)
	if (!nRST) begin
        RE   <= 0;
        LEN  <= 0;
	end
	else if (rCBCONWr) begin
	    RE   <= SPRDataIn[8];
	    LEN  <= SPRDataIn[4:0];
	end
	else if (RE) begin
	    RE   <= 1'b0;
	    LEN  <= LEN;
	end
//------------------------------------------------------------------------------
// Main Memory에서 Read할 Command의 시작 주소
reg	[31:0]	RSA;
//------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
	if (!nRST) begin
        RSA <= 0;
	end
	else if (rCBRSAWr) begin
	    RSA <= SPRDataIn;
	end
//------------------------------------------------------------------------------
reg		rCBDATRdD;
always @(negedge nRST or posedge Clk)
	if (!nRST) 	rCBDATRdD <= 0;
	else			rCBDATRdD <= rCBDATRd;

assign CBRead = rCBDATRd & ~rCBDATRdD;
//------------------------------------------------------------------------------
// Read Path
reg	[31:0]	SPRDataOut;
always @(rCQSTSRd or rCQDATRd or rCBDATRd or rCBCONRd or
		 CQFull or CQEmpty or CQRdData or CBData or CBEmpty)
	case(1'b1) // synopsys parallel_case full_case
		rCQSTSRd : SPRDataOut = {20'b0, 1'b0, 1'b0, 1'b0, CQFull, CQEmpty, 1'b0};
		rCQDATRd : SPRDataOut = {CQRdData};
		rCBCONRd : SPRDataOut = {CBEmpty, 30'b0};
		rCBRSARd : SPRDataOut = RSA;
		rCBDATRd : SPRDataOut = {CBData};
	endcase
//------------------------------------------------------------------------------
endmodule
