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
	DATA, // From Nand Selected RAM
	RSEn_Start,
	RSEn_Wait,
	TransferEnd,
	BlockStart,	
	RSParityCatch,

	
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
//`ifdef		OPTIMIZE
input	[7:0]	DATA; // From Nand Selected RAM
//`else
//input	[9:0]	DATA; // From Nand Selected RAM
//`endif
input			RSEn_Start;
input			RSEn_Wait;
input			TransferEnd;
input			BlockStart;
input			RSParityCatch;

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

reg	[1:0]	BlkCnt;

wire [9:0] PARITY7;
wire [9:0] PARITY6;
wire [9:0] PARITY5;
wire [9:0] PARITY4;
wire [9:0] PARITY3;
wire [9:0] PARITY2;
wire [9:0] PARITY1;
wire [9:0] PARITY0;

always @(posedge CLK or negedge RESETn)
begin
	if	(!RESETn)
		BlkCnt <= 0;
	else if (BlockStart)
		BlkCnt <= 0;
	else if (RSParityCatch)
		BlkCnt <= BlkCnt +1;
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
	else if (BlkCnt==0 & RSParityCatch)
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
	else if (BlkCnt==1 & RSParityCatch)
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
	else if (BlkCnt==2 & RSParityCatch)
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
	else if (BlkCnt==3 & RSParityCatch)
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
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	.Start			(RSEn_Start		),
	.Wait			(RSEn_Wait		),
	.TransferEnd	(TransferEnd	),
	.DATA			(DATA			),
	.PARITY7		(PARITY7		),
	.PARITY6		(PARITY6		),
	.PARITY5		(PARITY5		),
	.PARITY4		(PARITY4		),
	.PARITY3		(PARITY3		),
	.PARITY2		(PARITY2		),
	.PARITY1		(PARITY1		),
	.PARITY0		(PARITY0		)
);
endmodule
