
`timescale 1ns/10ps

module SDRWQ (nRST, Clk, WriteEn, ReadEn, DelayReadEn, WrData, RdData, FullFlag, HFullFlag, EmptyFlag, 
			  WrapCnt, IncRdCnt, AddrHold);

`include "../Rtl/SDRPara.v"

input         nRST, Clk, WriteEn, DelayReadEn, ReadEn, AddrHold;
input  [WQW:0] WrData;
output [WQW:0] RdData;
output        FullFlag, HFullFlag, EmptyFlag;
input  [WQCD:0] WrapCnt;
output [WQCD:0] IncRdCnt;

reg [WQCD:0] WrCnt;
reg [WQCD:0] IncRdCnt;

// Write Gray Counter
always @(negedge nRST or posedge Clk)
  if      (!nRST)   WrCnt <= 0;
  else if (WriteEn) WrCnt <= WrCnt + 1;

// Read Gray Counter
always @(negedge nRST or posedge Clk)
  if      (!nRST)   IncRdCnt <= 0;
  else if (AddrHold)IncRdCnt <= IncRdCnt;
  else if (ReadEn)  IncRdCnt <= IncRdCnt + 1;

wire [WQCD:0] RdCnt = WrapCnt;

// Counter For Flag Generation
reg [WQCD:0] DatCnt;

always @(negedge nRST or posedge Clk) 
  if (!nRST)    DatCnt <= 0;
  else begin
    case ({ReadEn & ~AddrHold, WriteEn}) // synopsys parallel_case
      2'b10   : DatCnt <= DatCnt - 1;
      2'b01   : DatCnt <= DatCnt + 1;
      default : DatCnt <= DatCnt;
    endcase
  end

// Generate Full/Empty Signals
assign EmptyFlag = ~|DatCnt & ~AddrHold;
assign FullFlag  =  &DatCnt & ~AddrHold;//[WQCD:1] & ~DatCnt[0];
assign HFullFlag =   DatCnt[WQCD] & ~AddrHold;

// General Memory Element
wire CEA = ReadEn | DelayReadEn;
 
//RF2SH64x32 WQL(
RF2SH256x32 WQL(
	.QA		(RdData[DW:0]),
	.AA		(RdCnt),
	.CLKA	(Clk),
	.CENA	(~CEA),
	.AB		(WrCnt),
	.DB		(WrData[DW:0]),
	.CLKB	(Clk),
	.CENB	(~WriteEn)
);

//RF2SH64x4 WQH(
RF2SH256x4 WQH(
	.QA		(RdData[WQW:DW+1]),
	.AA		(RdCnt),
	.CLKA	(Clk),
	.CENA	(~CEA),
	.AB		(WrCnt),
	.DB		(WrData[WQW:DW+1]),
	.CLKB	(Clk),
	.CENB	(~WriteEn)
);

/*
reg [WQW:0] FIFO[0:WQD];
integer i;

always @(negedge nRST or posedge Clk)
  if (!nRST) begin
    for (i=0; i<=WQD; i=i+1) FIFO[i] <= 0;
  end
  else begin
    if (WriteEn) FIFO[WrCnt] <= WrData;
    else         FIFO[WrCnt] <= FIFO[WrCnt];
  end

reg [WQW:0] RdData;
always @(negedge nRST or posedge Clk)
  if (!nRST) RdData <= 0;
  else       RdData <= FIFO[RdCnt];
*/

endmodule
