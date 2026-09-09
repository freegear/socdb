
`timescale 1ns/10ps

module SDRRQ (nRST, nClk, Clk, WriteEn, ReadEn, WrData, RdData, FullFlag, HFullFlag, EmptyFlag, 
			  WrapCnt, IncRdCnt, AddrHold);

`include "SDRPara.v"

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
assign FullFlag  =  &DatCnt & ~AddrHold;
assign HFullFlag =   DatCnt>=({RQCD+1{1'b1}}) -16 & ~AddrHold;
//assign HFullFlag =   DatCnt>(RQD-16) & ~AddrHold;

`ifdef CHIP
reg DelayReadEn;
always @(negedge nRST or posedge Clk) 
  if (!nRST) DelayReadEn <= 0;
  else       DelayReadEn <= ReadEn;

wire CEA = ReadEn | DelayReadEn;
 
RF2SH64x37 RQL(
	.QA		(RdData[RQW:0]),
	.AA		(RdCnt),
	.CLKA	(nClk),
	.CENA	(~CEA),
	.AB		(WrCnt),
	.DB		(WrData[RQW:0]),
	.CLKB	(Clk),
	.CENB	(~WriteEn)
);
`else
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
`endif

endmodule
