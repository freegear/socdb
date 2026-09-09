
module VideoFIFO (RdClk, WrClk, nRST, Flush, FlushWrClk, WrData, WriteEn, RdData, ReadEn,
			Full, Empty, EmptyN, Level);

parameter AW = 6;
parameter DW = 32;
parameter N  = 8;

input			RdClk, WrClk, nRST, Flush, FlushWrClk;
input	[DW-1:0]WrData;
input			WriteEn;
output	[DW-1:0]RdData;
input			ReadEn;
output			Full; 
output			Empty, EmptyN;
output	[1:0]	Level;

`include "VifPara.v"

// Local Wires

reg		[AW:0]		WrPtr;
wire	[AW:0]		WrPtr_pl1;
reg		[AW:0]		RdPtr;
wire	[AW:0]		RdPtr_pl1;
reg		[AW:0]		WrPtr_s, RdPtr_s;
wire	[AW:0]		Diff;
reg		[AW:0]		DiffRDel;
reg					Full, Empty, EmptyN;
reg		[1:0]		Level;
reg					ReadEnDelay;

// Memory Block
`ifdef CHIP

wire CENA = ~(ReadEn | ReadEnDelay);

RF2SH64x32 WQL(
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
	if(!nRST)		WrPtr <= {AW+1{1'b0}};
	else
	if(FlushWrClk)	WrPtr <= {AW+1{1'b0}};
	else
	if(WriteEn)		WrPtr <= WrPtr_pl1;

assign WrPtr_pl1 = WrPtr + { {AW{1'b0}}, 1'b1};

always @(posedge RdClk or negedge nRST)
	if(!nRST)		RdPtr <= {AW+1{1'b0}};
	else
	if(Flush)		RdPtr <= {AW+1{1'b0}};
	else
	if(ReadEn)		RdPtr <= RdPtr_pl1;

assign RdPtr_pl1 = RdPtr + {{AW{1'b0}}, 1'b1};

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
	if (!nRST) 	ReadEnDelay <= 0;
	else		ReadEnDelay <= ReadEn;
	
always @(negedge nRST or posedge RdClk)
	if (!nRST) 	DiffRDel <= 0;
	else		DiffRDel <= Diff;

always @(negedge nRST or posedge RdClk)
	if (!nRST) 	EmptyN <= 0;
	else		EmptyN <= (DiffRDel < N) | ((DiffRDel==N) & (ReadEn | ReadEnDelay));

always @(negedge nRST or posedge RdClk)
	if (!nRST) 	Empty <= 0;
	else		Empty <= (WrPtr_s == RdPtr) | (ReadEn & (WrPtr_s == RdPtr_pl1));

always @(negedge nRST or posedge WrClk)
	if (!nRST)	Full <= 0;
	else		Full <= ((WrPtr[AW-1:0] == RdPtr_s[AW-1:0]) & (WrPtr[AW] != RdPtr_s[AW])) |
				(WriteEn & (WrPtr_pl1[AW-1:0] == RdPtr_s[AW-1:0]) & (WrPtr_pl1[AW] != RdPtr_s[AW]));

assign Diff = WrPtr-RdPtr;

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

