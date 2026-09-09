
`timescale 1ns/10ps

module SDRRQ (nRST, nClk, Clk, WriteEn, ReadEn, WrData, RdData, FullFlag, HFullFlag, EmptyFlag, 
			  WrapCnt, IncRdCnt, AddrHold);

`include "../Rtl/SDRPara.v"

input         nRST, nClk, Clk, WriteEn, ReadEn, AddrHold;
input  [RQW:0] WrData;
output [RQW:0] RdData;
output        FullFlag, HFullFlag, EmptyFlag;
input  [RQCD:0] WrapCnt;
output [RQCD:0] IncRdCnt;

reg [RQCD:0] WrCnt;
reg [RQCD:0] IncRdCnt;

// Write Gray Counter
always @(negedge nRST or posedge Clk)
  if      (!nRST)   WrCnt <= 0;
  else if (AddrHold)WrCnt <= WrCnt;
  else if (WriteEn) WrCnt <= WrCnt + 1;

// Read Gray Counter
always @(negedge nRST or posedge Clk)
  if      (!nRST)   IncRdCnt <= 0;
  else if (ReadEn)  IncRdCnt <= IncRdCnt + 1;

wire [RQCD:0] RdCnt = WrapCnt;

// Counter For Flag Generation
reg [RQCD:0] DatCnt;

always @(negedge nRST or posedge Clk) 
  if (!nRST)    DatCnt <= 0;
  else begin
    case ({ReadEn,WriteEn & ~AddrHold}) // synopsys parallel_case
      2'b10   : DatCnt <= DatCnt - 1;
      2'b01   : DatCnt <= DatCnt + 1;
      default : DatCnt <= DatCnt;
    endcase
  end

// Generate Full/Empty Signals
assign EmptyFlag = ~|DatCnt & ~AddrHold;
//assign FullFlag  =  &DatCnt;
assign FullFlag  =  &DatCnt & ~AddrHold;//[RQCD:1] & ~DatCnt[0];
//assign HFullFlag =   DatCnt[RQCD];
assign HFullFlag =   DatCnt[RQCD-1] & ~AddrHold;

/*
// Counter For Flag Generation
reg [RQD+1:0] NewDatCnt;
reg [RQD+1:0] DatCnt;

always @(negedge nRST or posedge Clk) 
  if (!nRST) DatCnt <= 1;
  else       DatCnt <= NewDatCnt;

always@(ReadEn or WriteEn or DatCnt)
  case ({ReadEn,WriteEn}) // synopsys parallel_case
    2'b10   : NewDatCnt = {1'b0,DatCnt[RQD+1:1]};
    2'b01   : NewDatCnt = {DatCnt[RQD+1:0],1'b0};
    default : NewDatCnt = DatCnt;
  endcase

// Generate Full/Empty Signals
assign EmptyFlag = DatCnt[0];
assign HFullFlag = |DatCnt[RQD:(RQD+1)/2];
assign FullFlag  = DatCnt[RQD+1];
*/

reg DelayReadEn;
always @(negedge nRST or posedge Clk) 
  if (!nRST) DelayReadEn <= 0;
  else       DelayReadEn <= ReadEn;

wire CEA = ReadEn | DelayReadEn;
 
RF2SH256x32 RQL(
	.QA		(RdData[DW:0]),
	.AA		(RdCnt),
	.CLKA	(nClk),
	.CENA	(~CEA),
	.AB		(WrCnt),
	.DB		(WrData[DW:0]),
	.CLKB	(Clk),
	.CENB	(~WriteEn)
);

RF2SH256x4 RQH(
	.QA		(RdData[RQW:DW+1]),
	.AA		(RdCnt),
	.CLKA	(nClk),
	.CENA	(~CEA),
	.AB		(WrCnt),
	.DB		(WrData[RQW:DW+1]),
	.CLKB	(Clk),
	.CENB	(~WriteEn)
);

/*
reg [RQW:0] FIFO[0:RQD];
integer i;

always @(negedge nRST or posedge Clk)
  if (!nRST) begin
    for (i=0; i<=RQD; i=i+1) FIFO[i] <= 0;
  end
  else begin
    if (WriteEn) FIFO[WrCnt] <= WrData;
    else         FIFO[WrCnt] <= FIFO[WrCnt];
  end

//assign RdData = FIFO[RdCnt];

reg [RQW:0] RdData;
//always @(negedge nRST or posedge Clk)
always @(negedge nRST or negedge Clk)
  if (!nRST) RdData <= 0;
  else       RdData <= FIFO[RdCnt];
*/

endmodule
