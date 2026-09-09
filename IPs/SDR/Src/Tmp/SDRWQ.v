
`timescale 1ns/10ps

module SDRWQ (nRST, Clk, WriteEn, ReadEn, WrData, RdData, FullFlag, EmptyFlag, 
			  WrapStart, WrapAddr, IncRdCnt);

`include "../Rtl/SDRPara.v"

input         nRST, Clk, WriteEn, ReadEn;
input  [WQW:0] WrData;
output [WQW:0] RdData;
output        FullFlag, EmptyFlag;
input  [WQCD:0] WrapAddr;
input			WrapStart;
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
  else if (ReadEn)  IncRdCnt <= IncRdCnt + 1;

wire [WQCD:0] RdCnt = WrapStart ? WrapAddr : IncRdCnt;

// Counter For Flag Generation
reg [WQCD:0] DatCnt;

always @(negedge nRST or posedge Clk) 
  if (!nRST)    DatCnt <= 0;
  else begin
    case ({ReadEn,WriteEn}) // synopsys parallel_case
      2'b10   : DatCnt <= DatCnt - 1;
      2'b01   : DatCnt <= DatCnt + 1;
      default : DatCnt <= DatCnt;
    endcase
  end

// Generate Full/Empty Signals
assign EmptyFlag = ~|DatCnt;
assign FullFlag  =  &DatCnt;

/*
reg [WQD+1:0] NewDatCnt;
reg [WQD+1:0] DatCnt;

always @(negedge nRST or posedge Clk) 
  if (!nRST) DatCnt <= 1;
  else       DatCnt <= NewDatCnt;

always@(ReadEn or WriteEn or DatCnt)
  case ({ReadEn,WriteEn}) // synopsys parallel_case
    2'b10   : NewDatCnt = {1'b0,DatCnt[WQD+1:1]};
    2'b01   : NewDatCnt = {DatCnt[WQD+1:0],1'b0};
    default : NewDatCnt = DatCnt;
  endcase

// Generate Full/Empty Signals
assign EmptyFlag = DatCnt[0];
assign FullFlag  = DatCnt[WQD+1];
*/

// General Memory Element
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

endmodule
