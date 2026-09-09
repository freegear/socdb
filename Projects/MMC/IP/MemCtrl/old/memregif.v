module memregif(
	RESETn,
	CLK,
	FA,
	FO,
	NSFRWE,
	NSFROE,
	MEM_FI,
	// Register Output
	NandRAM_Sel,
	MMCRAM_Sel0,
	MMCRAM_Sel1,

	MMCReadStart,	
	MMCWriteStart,	
	MMCTransferEnd,	
	MMCBLKSIZE,
	NandStart0,
	NandStart1,
	NandReadWrite0,
	NandReadWrite1,

	Bypass0,
	Bypass1,
	
	RSMode0,
	RSMode1,
	
	NandTransferEnd0,
	NandTransferEnd1,
	NandReqSplitSize0,
	NandReqSplitSize1
 );
input 			RESETn;
input 			CLK;
input	[7:0]	FA;
input	[7:0]	FO;
input			NSFRWE;
input			NSFROE;
output	[7:0]	MEM_FI;

output	[5:0]	NandRAM_Sel;
output			MMCRAM_Sel0;
output			MMCRAM_Sel1;
output			MMCReadStart;
output			MMCWriteStart;	
input			MMCTransferEnd;	
output			MMCBLKSIZE;	
output			NandStart0;	
output			NandStart1;	
output			NandReadWrite0;
output			NandReadWrite1;	

output			Bypass0;
output			Bypass1;

output			RSMode0;
output			RSMode1;

input			NandTransferEnd0;
input			NandTransferEnd1;


output	[5:0]	NandReqSplitSize0;
output	[5:0]	NandReqSplitSize1;

reg 	[7:0]	MEM_FI;
reg 	[7:0]	NextMEM_FI;
reg		[5:0]	CpuRAM_Sel;
reg		[5:0]	NandRAM_Sel;
reg				MMCRAM_Sel0;
reg				MMCRAM_Sel1;

reg				MMCBLKSIZE;
reg		[5:0]	NandReqSplitSize;

reg				MMCReadStart;
reg				MMCWriteStart;

reg		[9:0]	Cpu_Size;

reg				NandStart;
reg				NandReadWrite;
reg				RSEn_Enable;
reg				RSDe_Enable;


`define CPURAMSEL_ADDR	8'b00000000
`define NANDRAMSEL_ADDR	8'b00000001
`define MMCRAMCTRL_ADDR	8'b00000010
`define MMCBLKSIZE_ADDR	8'b00000011
`define NandReqSplitSize_ADDR	8'b00000100

wire	CpuRAM_Sel_w ;
wire	NandRAM_Sel_w;
wire	CpuRAM_Sel_r ;
wire	NandRAM_Sel_r;
wire	MMCBLKSIZE_w ;
wire	NandReqSplitSize_w;
wire	MMCRAMCtrl_w;

assign	CpuRAM_Sel_w 	= (FA==`CPURAMSEL_ADDR) & (NSFRWE==0);
assign	NandRAM_Sel_w 	= (FA==`NANDRAMSEL_ADDR) & (NSFRWE==0);
assign	CpuRAM_Sel_r 	= (FA==`CPURAMSEL_ADDR) & (NSFROE==0);
assign	NandRAM_Sel_r 	= (FA==`NANDRAMSEL_ADDR) & (NSFROE==0);
assign	MMCBLKSIZE_w 	= (FA==`MMCBLKSIZE_ADDR) & (NSFRWE==0);

assign	NandReqSplitSize_w = (FA==`NandReqSplitSize_ADDR) & (NSFRWE==0);

assign MMCRAMCtrl_w		= (FA==`MMCRAMCTRL_ADDR) & (NSFRWE==0);


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	MMCBLKSIZE <= 0;
	else if (MMCBLKSIZE_w)
	MMCBLKSIZE <= FO[0];
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	MMCReadStart <= 0;	
	else if (MMCRAMCtrl_w)
	MMCReadStart <= FO[0];
	else 
	MMCReadStart <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	MMCWriteStart <= 0;	
	else if (MMCRAMCtrl_w)
	MMCWriteStart <= FO[1];
	else
	MMCWriteStart <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NandReqSplitSize <= 0;
	else if (NandReqSplitSize_w)
	NandReqSplitSize <= FO[5:0];
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CpuRAM_Sel <= 0;
	else if (CpuRAM_Sel_w)
	CpuRAM_Sel <= FO[5:0];
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NandRAM_Sel <= 0;
	else if (NandRAM_Sel_w)
	NandRAM_Sel <= FO[5:0];
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	MMCRAM_Sel0 <= 0;
	else if (CpuRAM_Sel_w)
	MMCRAM_Sel0 <= FO[6];
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	MMCRAM_Sel1 <= 0;
	else if (CpuRAM_Sel_w)
	MMCRAM_Sel1 <= FO[7];
end



always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NandStart <= 0;
	else if (NandRAM_Sel_w)
	NandStart <= FO[0];
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NandReadWrite <= 0;
	else if (NandRAM_Sel_w)
	NandReadWrite <= FO[1];
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	RSEn_Enable <= 0;
	else if (NandRAM_Sel_w)
	RSEn_Enable <= FO[3];
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	RSDe_Enable <= 0;
	else if (NandRAM_Sel_w)
	RSDe_Enable <= FO[4];
end




always @(MEM_FI or CpuRAM_Sel_r or NandRAM_Sel_r or CpuRAM_Sel or NandRAM_Sel)
begin
	NextMEM_FI=MEM_FI;
	case(1'b1)
	CpuRAM_Sel_r 	:NextMEM_FI= {2'b00, CpuRAM_Sel};
	NandRAM_Sel_r 	:NextMEM_FI= {2'b00, NandRAM_Sel};
	endcase
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	MEM_FI <= 0;
	else
	MEM_FI <= NextMEM_FI;
end 
endmodule

