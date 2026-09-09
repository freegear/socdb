module memregif(
	RESETn,
	CLK,
	CS,
	EXT_SFR_DOUT,
	EXT_SFR_WR,
	EXT_SFR_DIN,
	// Register Output
	Cpu_Rdy,
	Cpu_err,
	Rdy_sel,

	NandMode,
	NandRAM0_Sel,
	NandRAM1_Sel,
	MMCRAM_Sel0,
	MMCRAM_Sel1,

	TransferBlkAddr,
	TransferSize,
	TransferStart,
	TransferEnd	
 );
input 			RESETn;
input 			CLK;
input	[6:0]	CS;
input	[7:0]	EXT_SFR_DOUT;
input			EXT_SFR_WR;
output	[7:0]	EXT_SFR_DIN;

output			Cpu_Rdy;
output			Cpu_err;
output			Rdy_sel;

output			NandMode;
output	[5:0]	NandRAM0_Sel;
output	[5:0]	NandRAM1_Sel;

output			MMCRAM_Sel0;
output			MMCRAM_Sel1;

output	[10:0]		TransferBlkAddr;
output	[9:0]	TransferSize;
output			TransferStart;
input			TransferEnd;

reg 	[7:0]	EXT_SFR_DIN;
reg		[5:0]	NandRAM0_Sel;
reg		[5:0]	NandRAM1_Sel;
reg				MMCRAM_Sel0;
reg				MMCRAM_Sel1;
reg				NandMode;
reg				Cpu_Rdy;
reg				Cpu_err;
reg				Rdy_sel;
reg				TransferDone;

wire	NandRAM0_Sel_w;
wire	NandRAM1_Sel_w;
wire	NandRAM0_Sel_r;
wire	NandRAM1_Sel_r;
wire	MMCRAMCtrl_w;
wire	MMCRAMCtrl_r;
wire	TransferBlkAddrL_w;
wire	TransferBlkAddrH_w;
wire	TransferSizeL_w   ;
wire	TransferSizeH_w   ;

wire	TransferBlkAddrL_r;
wire	TransferBlkAddrH_r;
wire	TransferSizeL_r   ;
wire	TransferSizeH_r   ;


assign	NandRAM0_Sel_w 	= CS[1] & (EXT_SFR_WR==1'b1);
assign	NandRAM1_Sel_w 	= CS[2] & (EXT_SFR_WR==1'b1);
assign	NandRAM0_Sel_r 	= CS[1];
assign	NandRAM1_Sel_r 	= CS[2];

assign	MMCRAMCtrl_w	= CS[0] & (EXT_SFR_WR==1'b1);
assign 	MMCRAMCtrl_r	= CS[0];

assign	TransferBlkAddrL_w 	= CS[3] & (EXT_SFR_WR == 1'b1);
assign	TransferBlkAddrH_w 	= CS[4] & (EXT_SFR_WR == 1'b1);
assign	TransferSizeL_w 	= CS[5] & (EXT_SFR_WR == 1'b1);
assign	TransferSizeH_w 	= CS[6] & (EXT_SFR_WR == 1'b1);

assign	TransferBlkAddrL_r 	= CS[3];
assign	TransferBlkAddrH_r 	= CS[4];
assign	TransferSizeL_r 	= CS[5];
assign	TransferSizeH_r 	= CS[6];

reg			TransferStart;
reg	[9:0]	TransferSize;
reg	[10:0]	TransferBlkAddr;

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	TransferStart <= 0;	
	else if (MMCRAMCtrl_w)
	TransferStart <= EXT_SFR_DOUT[0];
	else 
	TransferStart <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	TransferBlkAddr <= 0;
	else if (TransferBlkAddrL_w)
	TransferBlkAddr[7:0] <= EXT_SFR_DOUT[7:0];
	else if (TransferBlkAddrH_w)
	TransferBlkAddr[10:8] <= EXT_SFR_DOUT[2:0];
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	TransferSize <= 0;
	else if (TransferSizeL_w)
	TransferSize[7:0] <= EXT_SFR_DOUT[7:0];
	else if (TransferSizeH_w)
	TransferSize[9:8] <= EXT_SFR_DOUT[1:0];
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
	Cpu_Rdy <= 0;
	else if (MMCRAMCtrl_w)
	Cpu_Rdy <= EXT_SFR_DOUT[5];
	else
	Cpu_Rdy <= 0;
end

always @(posedge CLK or negedge RESETn)                                    
begin     
    if (!RESETn)
    TransferDone <= 0;
	else if (MMCRAMCtrl_w & EXT_SFR_DOUT[1])
	TransferDone <= 0;
    else if (TransferEnd)
    TransferDone <= 1;  
end           

always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	Cpu_err		<= 0;
	else if (MMCRAMCtrl_w)
	Cpu_err		<= EXT_SFR_DOUT[3];
	else
	Cpu_err		<= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	MMCRAM_Sel0 <= 0;
	MMCRAM_Sel1 <= 0;
	NandMode	<= 0;
	Rdy_sel		<= 0;
	end
	else if (MMCRAMCtrl_w)
	begin
	MMCRAM_Sel0 <= EXT_SFR_DOUT[6];
	MMCRAM_Sel1 <= EXT_SFR_DOUT[7];
	NandMode	<= EXT_SFR_DOUT[2];
	Rdy_sel		<= EXT_SFR_DOUT[4];
	end
end

always @(	NandRAM0_Sel_r or 
			NandRAM1_Sel_r or 
			MMCRAMCtrl_r or
			TransferBlkAddrL_r or
			TransferBlkAddrH_r or
			TransferSizeL_r    or
			TransferSizeH_r    or
			NandRAM0_Sel or 
			NandRAM1_Sel or 
			TransferBlkAddr or
			TransferSize or
			MMCRAM_Sel1 or MMCRAM_Sel0 or NandMode or TransferDone or Rdy_sel )//or Cpu_err)
begin
	case(1'b1)
	NandRAM0_Sel_r 	:EXT_SFR_DIN= {2'b00, NandRAM0_Sel};
	NandRAM1_Sel_r 	:EXT_SFR_DIN= {2'b00, NandRAM1_Sel};
	TransferBlkAddrL_r : EXT_SFR_DIN = TransferBlkAddr[7:0];
	TransferBlkAddrH_r : EXT_SFR_DIN = {5'd0,TransferBlkAddr[10:8]};
	TransferSizeL_r : EXT_SFR_DIN = TransferSize[7:0];
	TransferSizeH_r : EXT_SFR_DIN = {6'd0,TransferSize[9:8]};
	MMCRAMCtrl_r	:EXT_SFR_DIN = {MMCRAM_Sel1,
									MMCRAM_Sel0,
									1'b0, 
									Rdy_sel, 
									1'b0,//Cpu_err,
									NandMode,
									TransferDone,
									1'b0 };
//	default : EXT_SFR_DIN = 8'd0;
	endcase
end

endmodule

