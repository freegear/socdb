
`timescale 1ns/10ps

module SDRRBLQ(nRST, Clk, WriteEn, ReadEn, WrData, RdData, FullFlag, EmptyFlag);

`include "../Rtl/SDRPara.v"

input         nRST, Clk, WriteEn, ReadEn;
input  [RBLQW:0] WrData;
output [RBLQW:0] RdData;
output        FullFlag, EmptyFlag;

reg [RBLQCD:0] WrCnt;
reg [RBLQCD:0] RdCnt;

// Write Gray Counter
always @(negedge nRST or posedge Clk)
  if      (!nRST)   WrCnt <= 0;
  else if (WriteEn) WrCnt <= WrCnt + 1;

// Read Gray Counter
always @(negedge nRST or posedge Clk)
  if      (!nRST)   RdCnt <= 0;
  else if (ReadEn)  RdCnt <= RdCnt + 1;

// Counter For Flag Generation

reg [RBLQD+1:0] NewDatCnt;
reg [RBLQD+1:0] DatCnt;

always @(negedge nRST or posedge Clk) 
  if (!nRST) DatCnt <= 1;
  else       DatCnt <= NewDatCnt;

always@(ReadEn or WriteEn or DatCnt)
  case ({ReadEn,WriteEn}) // synopsys parallel_case
    2'b10   : NewDatCnt = {1'b0,DatCnt[RBLQD+1:1]};
    2'b01   : NewDatCnt = {DatCnt[RBLQD+1:0],1'b0};
    default : NewDatCnt = DatCnt;
  endcase

// Generate Full/Empty Signals
assign EmptyFlag = DatCnt[0];
assign FullFlag  = DatCnt[RBLQD+1];

reg [RBLQW:0] FIFO[0:RBLQD];
integer i;

always @(negedge nRST or posedge Clk)
  if (!nRST) begin
    for (i=0; i<=RBLQD; i=i+1) FIFO[i] <= 0;
  end
  else begin
    if (WriteEn) FIFO[WrCnt] <= WrData;
    else         FIFO[WrCnt] <= FIFO[WrCnt];
  end

assign RdData = FIFO[RdCnt];

endmodule
