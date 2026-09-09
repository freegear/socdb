
module MixerFIFO (
				 RdClk, WrClk, nRST, Flush, FlushRdClk, WrData, WriteEn, RdData, ReadEn,
				 Full, Empty, Level, FullN);

`include "DmDef.v"

parameter AW = 6;
parameter DW = 24;
parameter N  = 16;	// Minimum 8
parameter MaxSize = 1<<AW;

input			RdClk, WrClk, nRST, Flush, FlushRdClk;
input	[DW-1:0]WrData;
input			WriteEn;
output	[DW-1:0]RdData;
input			ReadEn;
output			Full; 
output			Empty, FullN;
output	[1:0]	Level;

// Local Wires

reg		[AW:0]		WrPtr;
wire	[AW:0]		WrPtr_pl1;
reg		[AW:0]		RdPtr;
wire	[AW:0]		RdPtr_pl1;
reg		[AW:0]		WrPtr_s, RdPtr_s;
wire	[AW:0]		Diff;
reg		[AW:0]		DiffWDel;
reg					Full, Empty, FullN;
reg		[1:0]		Level;
reg					WriteEnDelay;

// Memory Block
`ifdef CHIP

wire nReadEnable = 1'b0 ;
reg DelayReadEn;
always @(negedge nRST or posedge RdClk) 
  if (!nRST) DelayReadEn <= 0;
  else       DelayReadEn <= ReadEn;

wire CENA = ~(ReadEn | DelayReadEn);

RF2SH64x24 WQL(
	.QA		(RdData),
	.AA		(RdPtr[AW-1:0]),
	.CLKA	(RdClk),
	.CENA	(CENA),
	.AB		(WrPtr[AW-1:0]),
	.DB		(WrData),
	.CLKB	(WrClk),
	.CENB	(~WriteEn)
);
`else

reg [DW-1:0] FIFO[0:{AW{1'b1}}];
integer i;

always @(posedge WrClk)
    if (WriteEn) FIFO[WrPtr[AW-1:0]] <= WrData;
    else         FIFO[WrPtr[AW-1:0]] <= FIFO[WrPtr[AW-1:0]];

//assign RdData = FIFO[RdCnt];

reg [DW-1:0] RdData;
always @(posedge RdClk) RdData <= FIFO[RdPtr[AW-1:0]];
`endif

// Read/Write Pointers Logic

always @(posedge WrClk or negedge nRST)
	if(!nRST)		WrPtr <= #1 {AW+1{1'b0}};
	else
	if(Flush)		WrPtr <= #1 {AW+1{1'b0}};
	else
	if(WriteEn)		WrPtr <= #1 WrPtr_pl1;

assign WrPtr_pl1 = WrPtr + { {AW{1'b0}}, 1'b1};

always @(posedge RdClk or negedge nRST)
	if(!nRST)		RdPtr <= #1 {AW+1{1'b0}};
	else
	if(FlushRdClk)	RdPtr <= #1 {AW+1{1'b0}};
	else
	if(ReadEn)		RdPtr <= #1 RdPtr_pl1;

assign RdPtr_pl1 = RdPtr + { {AW{1'b0}}, 1'b1};

// Synchronization Logic

// write pointer
always @(negedge nRST or posedge RdClk)	
	if (!nRST)	WrPtr_s <= 0;
	else		WrPtr_s <= WrPtr;

// read pointer
always @(negedge nRST or posedge WrClk)	
	if (!nRST)	RdPtr_s <= 0;
	else		RdPtr_s <= RdPtr;

// Registered Full & Empty Flags

always @(negedge nRST or posedge RdClk)
	if (!nRST) 	Empty <= 0;
	else		Empty <= (WrPtr_s == RdPtr) | (ReadEn & (WrPtr_s == RdPtr_pl1));

always @(negedge nRST or posedge WrClk)
	if (!nRST)	Full <= 0;
	else		Full <= ((WrPtr[AW-1:0] == RdPtr_s[AW-1:0]) & (WrPtr[AW] != RdPtr_s[AW])) |
				(WriteEn & (WrPtr_pl1[AW-1:0] == RdPtr_s[AW-1:0]) & (WrPtr_pl1[AW] != RdPtr_s[AW]));

assign Diff = WrPtr-RdPtr;

always @(negedge nRST or posedge WrClk)
	if (!nRST) 	WriteEnDelay <= 0;
	else		WriteEnDelay <= WriteEn;
	
always @(negedge nRST or posedge WrClk)
	if (!nRST) 	DiffWDel <= 0;
	else		DiffWDel <= Diff;

always @(negedge nRST or posedge WrClk)
	if (!nRST) 	FullN <= 0;
	else		FullN <= (DiffWDel > MaxSize-N) | ((DiffWDel==MaxSize-N) & (WriteEn | WriteEnDelay));

always @(negedge nRST or posedge WrClk)
	if (!nRST)	Level <= 0;
	else		Level <= {2{Diff[AW]}} | Diff[AW-1:AW-2];

// synopsys translate_off
always @(posedge WrClk)
	if(WriteEn & Full)
		$display("%m WARNING: Writing while FIFO is FULL (%t)",$time);

always @(posedge RdClk)
	if(ReadEn & Empty)
		$display("%m WARNING: Reading while FIFO is EMPTY (%t)",$time);
// synopsys translate_on

endmodule

