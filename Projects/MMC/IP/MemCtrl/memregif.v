module memregif(
	RESETn,
	CLK,
	CS,
	EXT_SFR_ADDR,
	EXT_SFR_DOUT,
	EXT_SFR_WR,
	EXT_SFR_DIN,
	// Register Output
	NandMode,
	NandRAM0_Sel,
	NandRAM1_Sel,
	MMCRAM_Sel0,
	MMCRAM_Sel1,

	MMCReadStart,	
	MMCWriteStart,	
	MMCTransferEnd
 );
input 			RESETn;
input 			CLK;
input			CS;
input	[1:0]	EXT_SFR_ADDR;
input	[7:0]	EXT_SFR_DOUT;
input			EXT_SFR_WR;
output	[7:0]	EXT_SFR_DIN;

output			NandMode;
output	[5:0]	NandRAM0_Sel;
output	[5:0]	NandRAM1_Sel;

output			MMCRAM_Sel0;
output			MMCRAM_Sel1;
output			MMCReadStart;
output			MMCWriteStart;	
input			MMCTransferEnd;	

reg 	[7:0]	EXT_SFR_DIN;
reg		[5:0]	NandRAM0_Sel;
reg		[5:0]	NandRAM1_Sel;
reg				MMCRAM_Sel0;
reg				MMCRAM_Sel1;
reg				MMCReadStart;
reg				MMCWriteStart;
reg				NandMode;


`define MMCRAMCTRL_ADDR		2'b01
`define NANDRAMSEL0_ADDR	2'b10
`define NANDRAMSEL1_ADDR	2'b11

wire	NandRAM0_Sel_w;
wire	NandRAM1_Sel_w;
wire	NandRAM0_Sel_r;
wire	NandRAM1_Sel_r;
wire	MMCRAMCtrl_w;
wire	MMCRAMCtrl_r;

assign	NandRAM0_Sel_w 	= (EXT_SFR_ADDR==`NANDRAMSEL0_ADDR) & (EXT_SFR_WR==1'b1) & (CS == 1'b1);
assign	NandRAM1_Sel_w 	= (EXT_SFR_ADDR==`NANDRAMSEL1_ADDR) & (EXT_SFR_WR==1'b1) & (CS == 1'b1);
assign	NandRAM0_Sel_r 	= (EXT_SFR_ADDR==`NANDRAMSEL0_ADDR);
assign	NandRAM1_Sel_r 	= (EXT_SFR_ADDR==`NANDRAMSEL1_ADDR);

assign	MMCRAMCtrl_w	= (EXT_SFR_ADDR==`MMCRAMCTRL_ADDR) & (EXT_SFR_WR==0) & (CS == 1'b1);
assign 	MMCRAMCtrl_r	= (EXT_SFR_ADDR==`MMCRAMCTRL_ADDR) ;
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	MMCReadStart <= 0;	
	else if (MMCRAMCtrl_w)
	MMCReadStart <= EXT_SFR_DOUT[0];
	else 
	MMCReadStart <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	MMCWriteStart <= 0;	
	else if (MMCRAMCtrl_w)
	MMCWriteStart <= EXT_SFR_DOUT[1];
	else
	MMCWriteStart <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NandRAM0_Sel <= 0;
	else if (NandRAM0_Sel_w)
	NandRAM0_Sel <= EXT_SFR_DOUT[5:0];
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NandRAM1_Sel <= 0;
	else if (NandRAM1_Sel_w)
	NandRAM1_Sel <= EXT_SFR_DOUT[5:0];
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	MMCRAM_Sel0 <= 0;
	MMCRAM_Sel1 <= 0;
	NandMode	<= 0;
	end
	else if (MMCRAMCtrl_w)
	begin
	MMCRAM_Sel0 <= EXT_SFR_DOUT[6];
	MMCRAM_Sel1 <= EXT_SFR_DOUT[7];
	NandMode	<= EXT_SFR_DOUT[3];
	end
end

always @(NandRAM0_Sel_r or NandRAM1_Sel_r or NandRAM0_Sel or 
NandRAM1_Sel or MMCRAM_Sel1 or MMCRAM_Sel0 or NandMode)
begin
	case(1'b1)
	NandRAM0_Sel_r 	:EXT_SFR_DIN= {2'b00, NandRAM0_Sel};
	NandRAM1_Sel_r 	:EXT_SFR_DIN= {2'b00, NandRAM1_Sel};
	MMCRAMCtrl_r	:EXT_SFR_DIN = {MMCRAM_Sel1,MMCRAM_Sel0,2'b00,NandMode,3'b000 };
	default : EXT_SFR_DIN = 8'd0;
	endcase
end

endmodule

