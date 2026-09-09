// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : DecoderCtrl.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : RS Decoder Top
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module	DecoderCtrl(
		CLK,
		RESETn,
		RSDe_First_Start,
		RSDe_Start,
		RSDe_Wait,
		SyndProcess,
		DecodeEndCnt,
	
		//BlkCnt,
		BigBlk,
		SmallBlk,
		SmallBlk2,
		SmallBlk3,
		
		CorrectErrorPosition0,
		CorrectErrorPosition1,
		CorrectErrorPosition2,
		CorrectErrorPosition3,
		CorrectErrorValue0	 ,
		CorrectErrorValue1	 ,
		CorrectErrorValue2	 ,
		CorrectErrorValue3	 ,
		ErrorCorrectEnd		 ,
		ErrorUncorrectable	 ,

		CEPosition0_0,
		CEPosition0_1,
		CEPosition0_2,
		CEPosition0_3,
		CEValue0_0	 ,
		CEValue0_1	 ,
		CEValue0_2	 ,
		CEValue0_3	 ,
		CEPosition1_0,
		CEPosition1_1,
		CEPosition1_2,
		CEPosition1_3,
		CEValue1_0	 ,
		CEValue1_1	 ,
		CEValue1_2	 ,
		CEValue1_3	 ,
		CEPosition2_0,
		CEPosition2_1,
		CEPosition2_2,
		CEPosition2_3,
		CEValue2_0	 ,
		CEValue2_1	 ,
		CEValue2_2	 ,
		CEValue2_3	 ,
		CEPosition3_0,
		CEPosition3_1,
		CEPosition3_2,
		CEPosition3_3,
		CEValue3_0	 ,
		CEValue3_1	 ,
		CEValue3_2	 ,
		CEValue3_3	 ,


		parity0_0,	
		parity0_1,	
		parity0_2,	
		parity0_3,	
		parity0_4,	
		parity0_5,	
		parity0_6,	
		parity0_7,	
		
		parity1_0,	
		parity1_1,	
		parity1_2,	
		parity1_3,	
		parity1_4,	
		parity1_5,	
		parity1_6,	
		parity1_7,	
		
		parity2_0,	
		parity2_1,	
		parity2_2,	
		parity2_3,	
		parity2_4,	
		parity2_5,	
		parity2_6,	
		parity2_7,	
		
		parity3_0,	
		parity3_1,	
		parity3_2,	
		parity3_3,	
		parity3_4,	
		parity3_5,	
		parity3_6,	
		parity3_7,	
		
		NandReadData,
		data,
		MEAStart	,
		SyndCalStart	,
		SyndIsNotZero	,
		EUncorrectable		

);
input		CLK;
input		RESETn;
input		RSDe_First_Start;
input		RSDe_Start;
input		RSDe_Wait;
input		SyndProcess;
output	[2:0]	DecodeEndCnt;

//input	[2:0] BlkCnt;
input		BigBlk;
input		SmallBlk;
input		SmallBlk2;
input		SmallBlk3;
		
		
input [9:0]	CorrectErrorPosition0;
input [9:0]	CorrectErrorPosition1;
input [9:0]	CorrectErrorPosition2;
input [9:0]	CorrectErrorPosition3;
input [9:0]	CorrectErrorValue0	 ;
input [9:0]	CorrectErrorValue1	 ;
input [9:0]	CorrectErrorValue2	 ;
input [9:0]	CorrectErrorValue3	 ;
input 		ErrorCorrectEnd		 ;
input 		ErrorUncorrectable	 ;

output [9:0]	CEPosition0_0;
output [9:0]	CEPosition0_1;
output [9:0]	CEPosition0_2;
output [9:0]	CEPosition0_3;
output [9:0]	CEValue0_0   ;
output [9:0]	CEValue0_1   ;
output [9:0]	CEValue0_2   ;
output [9:0]	CEValue0_3   ;
output [9:0]	CEPosition1_0;
output [9:0]	CEPosition1_1;
output [9:0]	CEPosition1_2;
output [9:0]	CEPosition1_3;
output [9:0]	CEValue1_0   ;
output [9:0]	CEValue1_1   ;
output [9:0]	CEValue1_2   ;
output [9:0]	CEValue1_3   ;
output [9:0]	CEPosition2_0;
output [9:0]	CEPosition2_1;
output [9:0]	CEPosition2_2;
output [9:0]	CEPosition2_3;
output [9:0]	CEValue2_0   ;
output [9:0]	CEValue2_1   ;
output [9:0]	CEValue2_2   ;
output [9:0]	CEValue2_3   ;
output [9:0]	CEPosition3_0;
output [9:0]	CEPosition3_1;
output [9:0]	CEPosition3_2;
output [9:0]	CEPosition3_3;
output [9:0]	CEValue3_0;
output [9:0]	CEValue3_1;
output [9:0]	CEValue3_2;
output [9:0]	CEValue3_3;



input	[9:0]	parity0_0;
input	[9:0]	parity0_1;
input	[9:0]	parity0_2;
input	[9:0]	parity0_3;
input	[9:0]	parity0_4;
input	[9:0]	parity0_5;
input	[9:0]	parity0_6;
input	[9:0]	parity0_7;
input	[9:0]	parity1_0;
input	[9:0]	parity1_1;
input	[9:0]	parity1_2;
input	[9:0]	parity1_3;
input	[9:0]	parity1_4;
input	[9:0]	parity1_5;
input	[9:0]	parity1_6;
input	[9:0]	parity1_7;
input	[9:0]	parity2_0;
input	[9:0]	parity2_1;
input	[9:0]	parity2_2;
input	[9:0]	parity2_3;
input	[9:0]	parity2_4;
input	[9:0]	parity2_5;
input	[9:0]	parity2_6;
input	[9:0]	parity2_7;
input	[9:0]	parity3_0;
input	[9:0]	parity3_1;
input	[9:0]	parity3_2;
input	[9:0]	parity3_3;
input	[9:0]	parity3_4;
input	[9:0]	parity3_5;
input	[9:0]	parity3_6;
input	[9:0]	parity3_7;

input	[7:0]	NandReadData;
output	[9:0]	data;
output			SyndCalStart;
output			MEAStart;
input	SyndIsNotZero	;

output [3:0]	EUncorrectable;

reg		[3:0]	EUncorrectable;
reg	[10:0]	DataCnt;
reg	[10:0]	NextDataCnt;
reg	[9:0]	data;

wire	[2:0]	DecodeEndCnt;
// Block Cnt for 2048 or 512 byte block

reg	[2:0]	NextBlkCnt;
reg	[2:0]	BlkCnt;
assign DecodeEndCnt = BlkCnt;

always @(/*RSDe_Start*/ RSDe_First_Start or SmallBlk or BigBlk or SmallBlk2 or SmallBlk3 or ErrorCorrectEnd)
begin
	NextBlkCnt = BlkCnt;
	if /*(RSDe_Start)*/(RSDe_First_Start)
	begin
		if (BigBlk)
		NextBlkCnt = 4;	
		else if (SmallBlk3)
		NextBlkCnt = 3;
		else if (SmallBlk2)
		NextBlkCnt = 2;
		else if (SmallBlk)
		NextBlkCnt = 1;
	end
	else if (ErrorCorrectEnd)
		NextBlkCnt = BlkCnt -1 ;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	BlkCnt <= 0;
	else
	BlkCnt <= NextBlkCnt;
end


always @(DataCnt or RSDe_Start or RSDe_Wait or SyndProcess)
begin
	NextDataCnt = DataCnt;
	if (RSDe_Start)
	NextDataCnt = 520;
	else if (RSDe_Wait)
	NextDataCnt = DataCnt;
	else if (SyndProcess)
	NextDataCnt = DataCnt - 1;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	DataCnt <= 0;
	else
	DataCnt <= NextDataCnt;
end


assign MEAStart = (DataCnt == 0)&&(SyndIsNotZero);

reg	[9:0]	CEPosition0_0;
reg	[9:0]	CEPosition0_1;
reg	[9:0]	CEPosition0_2;
reg	[9:0]	CEPosition0_3;
reg	[9:0]	CEValue0_0;
reg	[9:0]	CEValue0_1;
reg	[9:0]	CEValue0_2;
reg	[9:0]	CEValue0_3;
reg	[9:0]	CEPosition1_0;
reg	[9:0]	CEPosition1_1;
reg	[9:0]	CEPosition1_2;
reg	[9:0]	CEPosition1_3;
reg	[9:0]	CEValue1_0;
reg	[9:0]	CEValue1_1;
reg	[9:0]	CEValue1_2;
reg	[9:0]	CEValue1_3;
reg	[9:0]	CEPosition2_0;
reg	[9:0]	CEPosition2_1;
reg	[9:0]	CEPosition2_2;
reg	[9:0]	CEPosition2_3;
reg	[9:0]	CEValue2_0;
reg	[9:0]	CEValue2_1;
reg	[9:0]	CEValue2_2;
reg	[9:0]	CEValue2_3;
reg	[9:0]	CEPosition3_0;
reg	[9:0]	CEPosition3_1;
reg	[9:0]	CEPosition3_2;
reg	[9:0]	CEPosition3_3;
reg	[9:0]	CEValue3_0;
reg	[9:0]	CEValue3_1;
reg	[9:0]	CEValue3_2;
reg	[9:0]	CEValue3_3;


// input data (for parity data input)
always @(BlkCnt or DataCnt or NandReadData or 
parity0_0 or parity0_1 or parity0_2 or parity0_3 or 
parity0_4 or parity0_5 or parity0_6 or parity0_7 or 
parity1_0 or parity1_1 or parity1_2 or parity1_3 or 
parity1_4 or parity1_5 or parity1_6 or parity1_7 or 
parity2_0 or parity2_1 or parity2_3 or parity2_4 or
parity2_4 or parity2_5 or parity2_6 or parity2_7 or 
parity3_0 or parity3_1 or parity3_2 or parity3_3 or 
parity3_4 or parity3_5 or parity3_6 or parity3_7) 
begin
	if ((BlkCnt==4) && (DataCnt==8))
	data	= parity0_0;
	else if ((BlkCnt==4) && (DataCnt==7))
	data	= parity0_1;
	else if ((BlkCnt==4) && (DataCnt==6))
	data	= parity0_2;
	else if ((BlkCnt==4) && (DataCnt==5))
	data	= parity0_3;
	else if ((BlkCnt==4) && (DataCnt==4))
	data	= parity0_4;
	else if ((BlkCnt==4) && (DataCnt==3))
	data	= parity0_5;
	else if ((BlkCnt==4) && (DataCnt==2))
	data	= parity0_6;
	else if ((BlkCnt==4) && (DataCnt==1))
	data	= parity0_7;
	else if ((BlkCnt==3) && (DataCnt==8))
	data	= parity1_0;
	else if ((BlkCnt==3) && (DataCnt==7))
	data	= parity1_1;
	else if ((BlkCnt==3) && (DataCnt==6))
	data	= parity1_2;
	else if ((BlkCnt==3) && (DataCnt==5))
	data	= parity1_3;
	else if ((BlkCnt==3) && (DataCnt==4))
	data	= parity1_4;
	else if ((BlkCnt==3) && (DataCnt==3))
	data	= parity1_5;
	else if ((BlkCnt==3) && (DataCnt==2))
	data	= parity1_6;
	else if ((BlkCnt==3) && (DataCnt==1))
	data	= parity1_7;
	else if ((BlkCnt==2) && (DataCnt==8))
	data	= parity2_0;
	else if ((BlkCnt==2) && (DataCnt==7))
	data	= parity2_1;
	else if ((BlkCnt==2) && (DataCnt==6))
	data	= parity2_2;
	else if ((BlkCnt==2) && (DataCnt==5))
	data	= parity2_3;
	else if ((BlkCnt==2) && (DataCnt==4))
	data	= parity2_4;
	else if ((BlkCnt==2) && (DataCnt==3))
	data	= parity2_5;
	else if ((BlkCnt==2) && (DataCnt==2))
	data	= parity2_6;
	else if ((BlkCnt==2) && (DataCnt==1))
	data	= parity2_7;
	else if ((BlkCnt==1) && (DataCnt==8))
	data	= parity3_0;
	else if ((BlkCnt==1) && (DataCnt==7))
	data	= parity3_1;
	else if ((BlkCnt==1) && (DataCnt==6))
	data	= parity3_2;
	else if ((BlkCnt==1) && (DataCnt==5))
	data	= parity3_3;
	else if ((BlkCnt==1) && (DataCnt==4))
	data	= parity3_4;
	else if ((BlkCnt==1) && (DataCnt==3))
	data	= parity3_5;
	else if ((BlkCnt==1) && (DataCnt==2))
	data	= parity3_6;
	else if ((BlkCnt==1) && (DataCnt==1))
	data	= parity3_7;
	else
	data =  {2'b00,NandReadData};
end

always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
	CEPosition0_0		<= 0;
	CEPosition0_1		<= 0;
	CEPosition0_2		<= 0;
	CEPosition0_3		<= 0;
	CEValue0_0	 		<= 0;
	CEValue0_1	 		<= 0;
	CEValue0_2	 		<= 0;
	CEValue0_3	 		<= 0;
	end
	else if (ErrorCorrectEnd&(BlkCnt==1))
	begin
	CEPosition0_0 	<= CorrectErrorPosition0;
	CEPosition0_1 	<= CorrectErrorPosition1;
	CEPosition0_2 	<= CorrectErrorPosition2;
	CEPosition0_3 	<= CorrectErrorPosition3;
	CEValue0_0	 	<= CorrectErrorValue0;
	CEValue0_1	 	<= CorrectErrorValue1;
	CEValue0_2	 	<= CorrectErrorValue2;
	CEValue0_3	 	<= CorrectErrorValue3;
	end
end


always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
	CEPosition1_0		<= 0 ;
	CEPosition1_1		<= 0 ;
	CEPosition1_2		<= 0 ;
	CEPosition1_3		<= 0 ;
	CEValue1_0	 		<= 0;
	CEValue1_1	 		<= 0;
	CEValue1_2	 		<= 0;
	CEValue1_3	 		<= 0;
	end
	else if (ErrorCorrectEnd&(BlkCnt==2))
	begin
	CEPosition1_0 	<=  CorrectErrorPosition0;
	CEPosition1_1 	<=  CorrectErrorPosition1;
	CEPosition1_2 	<=  CorrectErrorPosition2;
	CEPosition1_3 	<=  CorrectErrorPosition3;
	CEValue1_0	 	<= CorrectErrorValue0;
	CEValue1_1	 	<= CorrectErrorValue1;
	CEValue1_2	 	<= CorrectErrorValue2;
	CEValue1_3	 	<= CorrectErrorValue3;
	end
end


always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
	CEPosition2_0		<= 0 ;
	CEPosition2_1		<= 0 ;
	CEPosition2_2		<= 0 ;
	CEPosition2_3		<= 0 ;
	CEValue2_0	 		<= 0;
	CEValue2_1	 		<= 0;
	CEValue2_2	 		<= 0;
	CEValue2_3	 		<= 0;
	end
	else if (ErrorCorrectEnd&(BlkCnt==3))
	begin
	CEPosition2_0 	<=  CorrectErrorPosition0;
	CEPosition2_1 	<=  CorrectErrorPosition1;
	CEPosition2_2 	<=  CorrectErrorPosition2;
	CEPosition2_3 	<=  CorrectErrorPosition3;
	CEValue2_0	 	<= CorrectErrorValue0;
	CEValue2_1	 	<= CorrectErrorValue1;
	CEValue2_2	 	<= CorrectErrorValue2;
	CEValue2_3	 	<= CorrectErrorValue3;
	end
end


always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
	CEPosition3_0		<= 0 ;
	CEPosition3_1		<= 0 ;
	CEPosition3_2		<= 0 ;
	CEPosition3_3		<= 0 ;
	CEValue3_0	 		<= 0;
	CEValue3_1	 		<= 0;
	CEValue3_2	 		<= 0;
	CEValue3_3	 		<= 0;
	end
	else if (ErrorCorrectEnd&(BlkCnt==4))
	begin
	CEPosition3_0 	<=  CorrectErrorPosition0;
	CEPosition3_1 	<=  CorrectErrorPosition1;
	CEPosition3_2 	<=  CorrectErrorPosition2;
	CEPosition3_3 	<=  CorrectErrorPosition3;
	CEValue3_0	 	<= CorrectErrorValue0;
	CEValue3_1	 	<= CorrectErrorValue1;
	CEValue3_2	 	<= CorrectErrorValue2;
	CEValue3_3	 	<= CorrectErrorValue3;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	EUncorrectable <= 0;
	else if (ErrorCorrectEnd & (BlkCnt == 1) & ErrorUncorrectable)
	EUncorrectable <= EUncorrectable | 4'b0001;
	else if (ErrorCorrectEnd & (BlkCnt == 2) & ErrorUncorrectable) 
	EUncorrectable <= EUncorrectable | 4'b0010;
	else if (ErrorCorrectEnd & (BlkCnt == 3) & ErrorUncorrectable) 
	EUncorrectable <= EUncorrectable | 4'b0100;
	else if (ErrorCorrectEnd & (BlkCnt == 4) & ErrorUncorrectable) 
	EUncorrectable <= EUncorrectable | 4'b1000;
end


assign SyndCalStart = RSDe_Start;

endmodule

