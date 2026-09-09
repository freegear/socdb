
`timescale 1ns/10ps

module SDRBLQ (nRST, Clk, WriteEn, ReadEn, WrData, RdData, FullFlag, EmptyFlag);

`include "../Rtl/SDRPara.v"

input         nRST, Clk, WriteEn, ReadEn;
input  [BLQW:0] WrData;
output [BLQW:0] RdData;
output        FullFlag, EmptyFlag;

reg [BLQCD:0] WrCnt;
reg [BLQCD:0] RdCnt;

// Write Gray Counter
always @(negedge nRST or posedge Clk)
  if      (!nRST)   WrCnt <= 0;
  else if (WriteEn) WrCnt <= WrCnt + 1;

// Read Gray Counter
always @(negedge nRST or posedge Clk)
  if      (!nRST)   RdCnt <= 0;
  else if (ReadEn)  RdCnt <= RdCnt + 1;

// Counter For Flag Generation

reg [BLQD+1:0] NewDatCnt;
reg [BLQD+1:0] DatCnt;

always @(negedge nRST or posedge Clk) 
  if (!nRST) DatCnt <= 1;
  else       DatCnt <= NewDatCnt;

always@(ReadEn or WriteEn or DatCnt)
  case ({ReadEn,WriteEn}) // synopsys parallel_case
    2'b10   : NewDatCnt = {1'b0,DatCnt[BLQD+1:1]};
    2'b01   : NewDatCnt = {DatCnt[BLQD+1:0],1'b0};
    default : NewDatCnt = DatCnt;
  endcase

// Generate Full/Empty Signals
assign EmptyFlag = DatCnt[0];
assign FullFlag  = DatCnt[BLQD+1];

reg [BLQW:0] FIFO[0:BLQD];
integer i;

always @(negedge nRST or posedge Clk)
  if (!nRST) begin
    for (i=0; i<=BLQD; i=i+1) FIFO[i] <= 0;
  end
  else begin
    if (WriteEn) FIFO[WrCnt] <= WrData;
    else         FIFO[WrCnt] <= FIFO[WrCnt];
  end

assign RdData = FIFO[RdCnt];

endmodule
