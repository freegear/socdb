
`timescale 1ns/10ps

module DDRBLQ (nRST, Clk, WriteEn, ReadEn, WrData, RdData, HFullFlag, FullFlag, EmptyFlag);

parameter BLQCD  = 0;
parameter BLQD   = 1;
parameter BLQW   = 9;	// Q Width

input         nRST, Clk, WriteEn, ReadEn;
input  [BLQW:0] WrData;
output [BLQW:0] RdData;
output        HFullFlag, FullFlag, EmptyFlag;

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
/*
assign EmptyFlag = (WrCnt == RdCnt);
assign FullFlag  = (WrCnt[BLQCD-1:0] == RdCnt[BLQCD-1:0]) & (WrCnt[BLQCD] != RdCnt[BLQCD]);

wire [BLQCD:0] Diff = WrCnt-RdCnt;

reg [1:0] Level;
always @(posedge Clk)
	Level <= {2{Diff[BLQCD]}} | Diff[BLQCD-1:BLQCD-2];

//assign HFullFlag = (Level==2'b10);// 50 ~ 75%
assign HFullFlag = (Level==2'b11);// 75 ~ 100%
*/

reg [BLQCD:0] DatCnt;

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
//assign HFullFlag =   DatCnt[BLQCD];
assign HFullFlag =   DatCnt>=({BLQCD+1{1'b1}}) -1;//(BLQD-1);

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

//-------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

wire ReadExceedWrite = RdCnt > WrCnt;

always @(posedge Clk)
	if(FullFlag & WriteEn)
		$display("%m ERROR: Burst Lengh Buffer FULL (%t)",$time);

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
