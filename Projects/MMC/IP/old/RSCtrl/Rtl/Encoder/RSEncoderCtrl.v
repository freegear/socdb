
// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name        : RSEncoderCtrl.v
// File Revision    : 1.0 
// Reveision history: 
//  ------------------------------------------------------------
//  Purpose         : Reed Solomon Encoder Controller
// ==============================================================================
module RSEncoderCtrl
(	
	RESETn,
	CLK,
	DATA,
	EnCode_Start,
	EnCode_Wait,
	EnCode_End,
	NFBlockSize,
	
	PARITY0_7,
	PARITY0_6,
	PARITY0_5,
	PARITY0_4,
	PARITY0_3,
	PARITY0_2,
	PARITY0_1,
	PARITY0_0,

	PARITY1_7,
	PARITY1_6,
	PARITY1_5,
	PARITY1_4,
	PARITY1_3,
	PARITY1_2,
	PARITY1_1,
	PARITY1_0,

	PARITY2_7,
	PARITY2_6,
	PARITY2_5,
	PARITY2_4,
	PARITY2_3,
	PARITY2_2,
	PARITY2_1,
	PARITY2_0,

	PARITY3_7,
	PARITY3_6,
	PARITY3_5,
	PARITY3_4,
	PARITY3_3,
	PARITY3_2,
	PARITY3_1,
	PARITY3_0
);


input 			RESETn;
input			CLK;
input	[7:0]	DATA;

input			EnCode_Start;
input			EnCode_Wait;
output			EnCode_End;
input			NFBlockSize;

output	[9:0]	PARITY0_7;
output	[9:0] 	PARITY0_6;
output	[9:0] 	PARITY0_5;
output	[9:0] 	PARITY0_4;
output	[9:0] 	PARITY0_3;
output	[9:0] 	PARITY0_2;
output	[9:0] 	PARITY0_1;
output	[9:0] 	PARITY0_0;

output	[9:0] 	PARITY1_7;
output	[9:0] 	PARITY1_6;
output	[9:0] 	PARITY1_5;
output	[9:0] 	PARITY1_4;
output	[9:0] 	PARITY1_3;
output	[9:0] 	PARITY1_2;
output	[9:0] 	PARITY1_1;
output	[9:0] 	PARITY1_0;

output	[9:0] 	PARITY2_7;
output	[9:0] 	PARITY2_6;
output	[9:0] 	PARITY2_5;
output	[9:0] 	PARITY2_4;
output	[9:0] 	PARITY2_3;
output	[9:0] 	PARITY2_2;
output	[9:0] 	PARITY2_1;
output	[9:0] 	PARITY2_0;

output	[9:0] 	PARITY3_7;
output	[9:0] 	PARITY3_6;
output	[9:0] 	PARITY3_5;
output	[9:0] 	PARITY3_4;
output	[9:0] 	PARITY3_3;
output	[9:0] 	PARITY3_2;
output	[9:0] 	PARITY3_1;
output	[9:0] 	PARITY3_0;


reg	[9:0]	PARITY0_7;
reg	[9:0] 	PARITY0_6;
reg	[9:0] 	PARITY0_5;
reg	[9:0] 	PARITY0_4;
reg	[9:0] 	PARITY0_3;
reg	[9:0] 	PARITY0_2;
reg	[9:0] 	PARITY0_1;
reg	[9:0] 	PARITY0_0;

reg	[9:0] 	PARITY1_7;
reg	[9:0] 	PARITY1_6;
reg	[9:0] 	PARITY1_5;
reg	[9:0] 	PARITY1_4;
reg	[9:0] 	PARITY1_3;
reg	[9:0] 	PARITY1_2;
reg	[9:0] 	PARITY1_1;
reg	[9:0] 	PARITY1_0;

reg	[9:0] 	PARITY2_7;
reg	[9:0] 	PARITY2_6;
reg	[9:0] 	PARITY2_5;
reg	[9:0] 	PARITY2_4;
reg	[9:0] 	PARITY2_3;
reg	[9:0] 	PARITY2_2;
reg	[9:0] 	PARITY2_1;
reg	[9:0] 	PARITY2_0;

reg	[9:0] 	PARITY3_7;
reg	[9:0] 	PARITY3_6;
reg	[9:0] 	PARITY3_5;
reg	[9:0] 	PARITY3_4;
reg	[9:0] 	PARITY3_3;
reg	[9:0] 	PARITY3_2;
reg	[9:0] 	PARITY3_1;
reg	[9:0] 	PARITY3_0;






`define RS_IDLE 	4'b0001
`define RS_START 	4'b0010
`define RS_ENCODE 	4'b0100
`define RS_WAIT 	4'b1000

reg [3:0]	NextRS_State;
reg [3:0]	RS_State;

reg [9:0]	DataCnt;
reg [9:0]	NextDataCnt;

reg [2:0]	BlkCnt;
reg [2:0]	NextBlkCnt;

// NFBlockSize : 0= 512 , 1 = 2048


wire	Start;
wire	Wait;

wire [9:0] PARITY7;
wire [9:0] PARITY6;
wire [9:0] PARITY5;
wire [9:0] PARITY4;
wire [9:0] PARITY3;
wire [9:0] PARITY2;
wire [9:0] PARITY1;
wire [9:0] PARITY0;



assign EnCode_End = NFBlockSize ? (BlkCnt==4)&(DataCnt==0):(DataCnt==0);
assign Start = (RS_State == `RS_START);
assign Wait = (RS_State == `RS_WAIT);


always @(RS_State or EnCode_Start or Start or EnCode_Wait or EnCode_End)
begin
	NextRS_State = RS_State;
	if (EnCode_Start)
	NextRS_State = `RS_START;
	else if (Start)
	NextRS_State = `RS_ENCODE;
	else if (EnCode_Wait)
	NextRS_State = `RS_WAIT;
	else if (EnCode_End & NFBlockSize)
	NextRS_State = `RS_START;
	else if (EnCode_End)
	NextRS_State = `RS_IDLE;
end

always @(posedge CLK or negedge RESETn )
begin
	if (!RESETn)
	RS_State <= `RS_IDLE;
	else	
	RS_State <= NextRS_State;
end


always @(DataCnt or Start or RS_State)
begin
	NextDataCnt = DataCnt;
	if (Start)
	NextDataCnt = 520;
	else if (RS_State == `RS_ENCODE)
	NextDataCnt = DataCnt - 1;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	DataCnt <= 0;
	else
	DataCnt <= NextDataCnt;
end

always @(BlkCnt or NFBlockSize or EnCode_Start)
begin
	NextBlkCnt = BlkCnt;
	if (NFBlockSize & EnCode_Start)
	NextBlkCnt = 4;
	else if (EnCode_Start)
	NextBlkCnt = 1;
	else if (Start)
	NextBlkCnt = BlkCnt - 1;
end 

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	BlkCnt <= 0;
	else
	BlkCnt <= NextBlkCnt;
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	PARITY0_7 <= 0;
	PARITY0_6 <= 0;
	PARITY0_5 <= 0;
	PARITY0_4 <= 0;
	PARITY0_3 <= 0;
	PARITY0_2 <= 0;
	PARITY0_1 <= 0;
	PARITY0_0 <= 0;
	end
	else if (DataCnt==0 & EnCode_End)
	begin
	PARITY0_7 <=  PARITY7;
	PARITY0_6 <=  PARITY6;
	PARITY0_5 <=  PARITY5;
	PARITY0_4 <=  PARITY4;
	PARITY0_3 <=  PARITY3;
	PARITY0_2 <=  PARITY2;
	PARITY0_1 <=  PARITY1;
	PARITY0_0 <=  PARITY0;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	PARITY1_7 <= 0;
	PARITY1_6 <= 0;
	PARITY1_5 <= 0;
	PARITY1_4 <= 0;
	PARITY1_3 <= 0;
	PARITY1_2 <= 0;
	PARITY1_1 <= 0;
	PARITY1_0 <= 0;
	end
	else if (DataCnt==1 & EnCode_End)
	begin
	PARITY1_7 <=  PARITY7;
	PARITY1_6 <=  PARITY6;
	PARITY1_5 <=  PARITY5;
	PARITY1_4 <=  PARITY4;
	PARITY1_3 <=  PARITY3;
	PARITY1_2 <=  PARITY2;
	PARITY1_1 <=  PARITY1;
	PARITY1_0 <=  PARITY0;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	PARITY2_7 <= 0;
	PARITY2_6 <= 0;
	PARITY2_5 <= 0;
	PARITY2_4 <= 0;
	PARITY2_3 <= 0;
	PARITY2_2 <= 0;
	PARITY2_1 <= 0;
	PARITY2_0 <= 0;
	end
	else if (DataCnt==2 & EnCode_End)
	begin
	PARITY2_7 <=  PARITY7;
	PARITY2_6 <=  PARITY6;
	PARITY2_5 <=  PARITY5;
	PARITY2_4 <=  PARITY4;
	PARITY2_3 <=  PARITY3;
	PARITY2_2 <=  PARITY2;
	PARITY2_1 <=  PARITY1;
	PARITY2_0 <=  PARITY0;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	PARITY3_7 <= 0;
	PARITY3_6 <= 0;
	PARITY3_5 <= 0;
	PARITY3_4 <= 0;
	PARITY3_3 <= 0;
	PARITY3_2 <= 0;
	PARITY3_1 <= 0;
	PARITY3_0 <= 0;
	end
	else if (DataCnt==3 & EnCode_End)
	begin
	PARITY3_7 <=  PARITY7;
	PARITY3_6 <=  PARITY6;
	PARITY3_5 <=  PARITY5;
	PARITY3_4 <=  PARITY4;
	PARITY3_3 <=  PARITY3;
	PARITY3_2 <=  PARITY2;
	PARITY3_1 <=  PARITY1;
	PARITY3_0 <=  PARITY0;
	end
end


RS520_512Encoder RSEncoder (	
	.RESETn			(RESETn),
	.CLK			(CLK),
	.Start			(Start),
	.Wait			(Wait),
	.DATA			(DATA),
	.PARITY7		(PARITY7),
	.PARITY6		(PARITY6),
	.PARITY5		(PARITY5),
	.PARITY4		(PARITY4),
	.PARITY3		(PARITY3),
	.PARITY2		(PARITY2),
	.PARITY1		(PARITY1),
	.PARITY0		(PARITY0)
);
/*

// synopsys translate off
reg [8*10:0] NextState;
reg [8*10:0] State;

always @(NextRS_State)
begin
if (NextRS_State == `RS_IDLE)
	NextState = "RS_IDLE";
else if (NextRS_State == `RS_START)
	NextState = "RS_START";
else if (NextRS_State == `RS_ENCODE)
	NextState = "RS_ENCODE";
else if (NextRS_State == `RS_WAIT)
	NextState = "RS_WAIT";
end


always @(RS_State)
begin
if (RS_State == `RS_IDLE)
	State = "RS_IDLE";
else if (RS_State == `RS_START)
	State = "RS_START";
else if (RS_State == `RS_ENCODE)
	State = "RS_ENCODE";
else if (RS_State == `RS_WAIT)
	State = "RS_WAIT";
end

// synopsys translate on
*/
endmodule
