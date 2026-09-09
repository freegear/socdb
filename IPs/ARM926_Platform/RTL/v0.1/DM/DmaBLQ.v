
`timescale 1ns/10ps

module DmaBLQ (
				nRST, Clk, WriteEn, ReadEn, WrData, RdData, 
				QFullFlag, HFullFlag, FullFlag, EmptyFlag);

parameter BLQCD  = 0;
parameter BLQD   = 1;
parameter BLQW   = 9;	// Q Width

input         nRST, Clk, WriteEn, ReadEn;
input  [BLQW:0] WrData;
output [BLQW:0] RdData;
output        QFullFlag, HFullFlag, FullFlag, EmptyFlag;

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
assign HFullFlag =   DatCnt >= ({BLQCD+1{1'b1}}) -1; // Remain Max. 1 Burst Data Writable
assign QFullFlag =   DatCnt >= ({BLQCD+1{1'b1}}) -2; // Remain Max. 2 Burst Data Writable
//assign HFullFlag =   DatCnt[BLQCD];
//assign QFullFlag =   DatCnt[BLQCD-1];

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
wire ReadExceedWrite;

assign ReadExceedWrite = RdCnt > WrCnt;

always @(posedge Clk)
	if(FullFlag & WriteEn)
		$display("%m ERROR: Burst Lengh Buffer FULL (%t)",$time);

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
