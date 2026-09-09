// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : RSDecRegif.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : RS Decoder Register Interface
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module RSDecRegif(
	RESETn,
	CLK,
	CS,	
	EXT_SFR_ADDR,
	EXT_SFR_DOUT,
	EXT_SFR_WR,

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

	ECorrectEnd	 ,
	EUncorrectable	,	

	EXT_SFR_DIN
);

input			RESETn;
input			CLK;
input			CS;
input	[6:0]	EXT_SFR_ADDR;
input	[7:0]	EXT_SFR_DOUT;
input			EXT_SFR_WR;

output	[9:0]	parity0_0;	
output	[9:0]	parity0_1;	
output	[9:0]	parity0_2;	
output	[9:0]	parity0_3;	
output	[9:0]	parity0_4;	
output	[9:0]	parity0_5;	
output	[9:0]	parity0_6;	
output	[9:0]	parity0_7;	

output	[9:0]	parity1_0;	
output	[9:0]	parity1_1;	
output	[9:0]	parity1_2;	
output	[9:0]	parity1_3;	
output	[9:0]	parity1_4;	
output	[9:0]	parity1_5;	
output	[9:0]	parity1_6;	
output	[9:0]	parity1_7;	

output	[9:0]	parity2_0;	
output	[9:0]	parity2_1;	
output	[9:0]	parity2_2;	
output	[9:0]	parity2_3;	
output	[9:0]	parity2_4;	
output	[9:0]	parity2_5;	
output	[9:0]	parity2_6;	
output	[9:0]	parity2_7;	

output	[9:0]	parity3_0;	
output	[9:0]	parity3_1;	
output	[9:0]	parity3_2;	
output	[9:0]	parity3_3;	
output	[9:0]	parity3_4;	
output	[9:0]	parity3_5;	
output	[9:0]	parity3_6;	
output	[9:0]	parity3_7;	


input [9:0]	CEPosition0_0;
input [9:0]	CEPosition0_1;
input [9:0]	CEPosition0_2;
input [9:0]	CEPosition0_3;
input [9:0]	CEValue0_0   ;
input [9:0]	CEValue0_1   ;
input [9:0]	CEValue0_2   ;
input [9:0]	CEValue0_3   ;
input [9:0]	CEPosition1_0;
input [9:0]	CEPosition1_1;
input [9:0]	CEPosition1_2;
input [9:0]	CEPosition1_3;
input [9:0]	CEValue1_0   ;
input [9:0]	CEValue1_1   ;
input [9:0]	CEValue1_2   ;
input [9:0]	CEValue1_3   ;
input [9:0]	CEPosition2_0;
input [9:0]	CEPosition2_1;
input [9:0]	CEPosition2_2;
input [9:0]	CEPosition2_3;
input [9:0]	CEValue2_0   ;
input [9:0]	CEValue2_1   ;
input [9:0]	CEValue2_2   ;
input [9:0]	CEValue2_3   ;
input [9:0]	CEPosition3_0;
input [9:0]	CEPosition3_1;
input [9:0]	CEPosition3_2;
input [9:0]	CEPosition3_3;
input [9:0]	CEValue3_0;
input [9:0]	CEValue3_1;
input [9:0]	CEValue3_2;
input [9:0]	CEValue3_3;
input		ECorrectEnd;

input [3:0]	EUncorrectable;

output	[5:0]	EXT_SFR_DIN;

reg	[9:0]	parity0_0;	
reg	[9:0]	parity0_1;	
reg	[9:0]	parity0_2;	
reg	[9:0]	parity0_3;	
reg	[9:0]	parity0_4;	
reg	[9:0]	parity0_5;	
reg	[9:0]	parity0_6;	
reg	[9:0]	parity0_7;	

reg	[9:0]	parity1_0;	
reg	[9:0]	parity1_1;	
reg	[9:0]	parity1_2;	
reg	[9:0]	parity1_3;	
reg	[9:0]	parity1_4;	
reg	[9:0]	parity1_5;	
reg	[9:0]	parity1_6;	
reg	[9:0]	parity1_7;	

reg	[9:0]	parity2_0;	
reg	[9:0]	parity2_1;	
reg	[9:0]	parity2_2;	
reg	[9:0]	parity2_3;	
reg	[9:0]	parity2_4;	
reg	[9:0]	parity2_5;	
reg	[9:0]	parity2_6;	
reg	[9:0]	parity2_7;	

reg	[9:0]	parity3_0;	
reg	[9:0]	parity3_1;	
reg	[9:0]	parity3_2;	
reg	[9:0]	parity3_3;	
reg	[9:0]	parity3_4;	
reg	[9:0]	parity3_5;	
reg	[9:0]	parity3_6;	
reg	[9:0]	parity3_7;	


`define RSDEC_ADDR					7'h00
`define RSDEC_PARITY0_0L_ADDR		7'h01
`define RSDEC_PARITY0_1L_ADDR		7'h02
`define RSDEC_PARITY0_2L_ADDR		7'h03
`define RSDEC_PARITY0_3L_ADDR		7'h04
`define RSDEC_PARITY0_03H_ADDR		7'h05
`define RSDEC_PARITY0_4L_ADDR		7'h06
`define RSDEC_PARITY0_5L_ADDR		7'h07
`define RSDEC_PARITY0_6L_ADDR		7'h08
`define RSDEC_PARITY0_7L_ADDR		7'h09
`define RSDEC_PARITY0_47H_ADDR		7'h0A

`define RSDEC_PARITY1_0L_ADDR		7'h0B
`define RSDEC_PARITY1_1L_ADDR		7'h0C
`define RSDEC_PARITY1_2L_ADDR		7'h0D
`define RSDEC_PARITY1_3L_ADDR		7'h0E
`define RSDEC_PARITY1_03H_ADDR		7'h0F
`define RSDEC_PARITY1_4L_ADDR		7'h10
`define RSDEC_PARITY1_5L_ADDR		7'h11
`define RSDEC_PARITY1_6L_ADDR		7'h12
`define RSDEC_PARITY1_7L_ADDR		7'h13
`define RSDEC_PARITY1_47H_ADDR		7'h14

`define RSDEC_PARITY2_0L_ADDR		7'h15
`define RSDEC_PARITY2_1L_ADDR		7'h16
`define RSDEC_PARITY2_2L_ADDR		7'h17
`define RSDEC_PARITY2_3L_ADDR		7'h18
`define RSDEC_PARITY2_03H_ADDR		7'h19
`define RSDEC_PARITY2_4L_ADDR		7'h1A
`define RSDEC_PARITY2_5L_ADDR		7'h1B
`define RSDEC_PARITY2_6L_ADDR		7'h1C
`define RSDEC_PARITY2_7L_ADDR		7'h1D
`define RSDEC_PARITY2_47H_ADDR		7'h1E

`define RSDEC_PARITY3_0L_ADDR		7'h1F
`define RSDEC_PARITY3_1L_ADDR		7'h20
`define RSDEC_PARITY3_2L_ADDR		7'h21
`define RSDEC_PARITY3_3L_ADDR		7'h22
`define RSDEC_PARITY3_03H_ADDR		7'h23
`define RSDEC_PARITY3_4L_ADDR		7'h24
`define RSDEC_PARITY3_5L_ADDR		7'h25
`define RSDEC_PARITY3_6L_ADDR		7'h26
`define RSDEC_PARITY3_7L_ADDR		7'h27
`define RSDEC_PARITY3_47H_ADDR		7'h28

`define	CEPosition0_0L_ADDR		7'h29
`define	CEPosition0_1L_ADDR		7'h2A
`define	CEPosition0_2L_ADDR		7'h2B
`define	CEPosition0_3L_ADDR		7'h2C
`define	CEPosition0_03H_ADDR	7'h2D


`define	CEValue0_0L_ADDR   		7'h2E
`define	CEValue0_1L_ADDR   		7'h2F
`define	CEValue0_2L_ADDR   		7'h30
`define	CEValue0_3L_ADDR   		7'h31
`define	CEValue0_03H_ADDR   	7'h32

`define	CEPosition1_0L_ADDR		7'h33
`define	CEPosition1_1L_ADDR		7'h34	
`define	CEPosition1_2L_ADDR		7'h35
`define	CEPosition1_3L_ADDR		7'h36
`define	CEPosition1_03H_ADDR	7'h37

`define	CEValue1_0L_ADDR   		7'h38
`define	CEValue1_1L_ADDR   		7'h39
`define	CEValue1_2L_ADDR   		7'h3A
`define	CEValue1_3L_ADDR   		7'h3B
`define	CEValue1_03H_ADDR  		7'h3C

`define	CEPosition2_0L_ADDR		7'h3D
`define	CEPosition2_1L_ADDR		7'h3E
`define	CEPosition2_2L_ADDR		7'h3F
`define	CEPosition2_3L_ADDR		7'h40
`define	CEPosition2_03H_ADDR	7'h41

`define	CEValue2_0L_ADDR   		7'h42
`define	CEValue2_1L_ADDR   		7'h43
`define	CEValue2_2L_ADDR   		7'h44
`define	CEValue2_3L_ADDR   		7'h45
`define	CEValue2_03H_ADDR  		7'h46

`define	CEPosition3_0L_ADDR		7'h47
`define	CEPosition3_1L_ADDR		7'h48
`define	CEPosition3_2L_ADDR		7'h49
`define	CEPosition3_3L_ADDR		7'h4A
`define	CEPosition3_03H_ADDR	7'h4B

`define	CEValue3_0L_ADDR   		7'h4C
`define	CEValue3_1L_ADDR   		7'h4D
`define	CEValue3_2L_ADDR   		7'h4E
`define	CEValue3_3L_ADDR   		7'h4F
`define	CEValue3_03H_ADDR  		7'h50
`define	RSDecoderStatus_ADDR  	7'h51

wire	RSDEC_w;

wire	RSDEC_PARITY0_0L_w	= (EXT_SFR_ADDR == `RSDEC_PARITY0_0L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY0_1L_w	= (EXT_SFR_ADDR == `RSDEC_PARITY0_1L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY0_2L_w	= (EXT_SFR_ADDR == `RSDEC_PARITY0_2L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY0_3L_w	= (EXT_SFR_ADDR == `RSDEC_PARITY0_3L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY0_03H_w	= (EXT_SFR_ADDR == `RSDEC_PARITY0_03H_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY0_4L_w	= (EXT_SFR_ADDR == `RSDEC_PARITY0_4L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY0_5L_w	= (EXT_SFR_ADDR == `RSDEC_PARITY0_5L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY0_6L_w	= (EXT_SFR_ADDR == `RSDEC_PARITY0_6L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY0_7L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY0_7L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY0_47H_w	= (EXT_SFR_ADDR == `RSDEC_PARITY0_47H_ADDR)	& (CS) & (EXT_SFR_WR);

wire	RSDEC_PARITY1_0L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY1_0L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY1_1L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY1_1L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY1_2L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY1_2L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY1_3L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY1_3L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY1_03H_w	= (EXT_SFR_ADDR == `RSDEC_PARITY1_03H_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY1_4L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY1_4L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY1_5L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY1_5L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY1_6L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY1_6L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY1_7L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY1_7L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY1_47H_w	= (EXT_SFR_ADDR == `RSDEC_PARITY1_47H_ADDR)	& (CS) & (EXT_SFR_WR);

wire	RSDEC_PARITY2_0L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY2_0L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY2_1L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY2_1L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY2_2L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY2_2L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY2_3L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY2_3L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY2_03H_w	= (EXT_SFR_ADDR == `RSDEC_PARITY2_03H_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY2_4L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY2_4L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY2_5L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY2_5L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY2_6L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY2_6L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY2_7L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY2_7L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY2_47H_w	= (EXT_SFR_ADDR == `RSDEC_PARITY2_47H_ADDR)	& (CS) & (EXT_SFR_WR);

wire	RSDEC_PARITY3_0L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY3_0L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY3_1L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY3_1L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY3_2L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY3_2L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY3_3L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY3_3L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY3_03H_w	= (EXT_SFR_ADDR == `RSDEC_PARITY3_03H_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY3_4L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY3_4L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY3_5L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY3_5L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY3_6L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY3_6L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY3_7L_w 	= (EXT_SFR_ADDR == `RSDEC_PARITY3_7L_ADDR)	& (CS) & (EXT_SFR_WR);
wire	RSDEC_PARITY3_47H_w	= (EXT_SFR_ADDR == `RSDEC_PARITY3_47H_ADDR)	& (CS) & (EXT_SFR_WR);


assign	RSDEC_w = (EXT_SFR_ADDR==`RSDEC_ADDR) & (EXT_SFR_WR) & (CS);

//reg	[7:0]	RSDEC;
reg	[7:0]	EXT_SFR_DIN;
reg	[7:0]	NextEXT_SFR_DIN;
reg			CorrectionEnd;

//always @(posedge CLK or negedge RESETn)
//begin
//	if (!RESETn)
//	RSDEC <= 0;
//	else if (RSDEC_w)
//	RSDEC <= EXT_SFR_DOUT;
//end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CorrectionEnd <= 0;
	else if ((RSDEC_w)&(EXT_SFR_DOUT[7]==0))
	CorrectionEnd <= 0;
	else if (ECorrectEnd)
	CorrectionEnd <= 1;
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_0[7:0] <=0;
	else if (RSDEC_PARITY0_0L_w)
	parity0_0[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_1[7:0] <=0;
	else if (RSDEC_PARITY0_1L_w)
	parity0_1[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_2[7:0] <=0;
	else if (RSDEC_PARITY0_2L_w)
	parity0_2[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_3[7:0] <=0;
	else if (RSDEC_PARITY0_3L_w)
	parity0_3[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_4[7:0] <=0;
	else if (RSDEC_PARITY0_4L_w)
	parity0_4[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_5[7:0] <=0;
	else if (RSDEC_PARITY0_5L_w)
	parity0_5[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_6[7:0] <=0;
	else if (RSDEC_PARITY0_6L_w)
	parity0_6[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_7[7:0] <=0;
	else if (RSDEC_PARITY0_7L_w)
	parity0_7[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_0[7:0] <=0;
	else if (RSDEC_PARITY1_0L_w)
	parity1_0[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_1[7:0] <=0;
	else if (RSDEC_PARITY1_1L_w)
	parity1_1[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_2[7:0] <=0;
	else if (RSDEC_PARITY1_2L_w)
	parity1_2[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_3[7:0] <=0;
	else if (RSDEC_PARITY1_3L_w)
	parity1_3[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_4[7:0] <=0;
	else if (RSDEC_PARITY1_4L_w)
	parity1_4[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_5[7:0] <=0;
	else if (RSDEC_PARITY1_5L_w)
	parity1_5[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_6[7:0] <=0;
	else if (RSDEC_PARITY1_6L_w)
	parity1_6[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_7[7:0] <=0;
	else if (RSDEC_PARITY1_7L_w)
	parity1_7[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_0[7:0] <=0;
	else if (RSDEC_PARITY2_0L_w)
	parity2_0[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_1[7:0] <=0;
	else if (RSDEC_PARITY2_1L_w)
	parity2_1[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_2[7:0] <=0;
	else if (RSDEC_PARITY2_2L_w)
	parity2_2[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_3[7:0] <=0;
	else if (RSDEC_PARITY2_3L_w)
	parity2_3[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_4[7:0] <=0;
	else if (RSDEC_PARITY2_4L_w)
	parity2_4[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_5[7:0] <=0;
	else if (RSDEC_PARITY2_5L_w)
	parity2_5[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_6[7:0] <=0;
	else if (RSDEC_PARITY2_6L_w)
	parity2_6[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_7[7:0] <=0;
	else if (RSDEC_PARITY2_7L_w)
	parity2_7[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_0[7:0] <=0;
	else if (RSDEC_PARITY3_0L_w)
	parity3_0[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_1[7:0] <=0;
	else if (RSDEC_PARITY3_1L_w)
	parity3_1[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_2[7:0] <=0;
	else if (RSDEC_PARITY3_2L_w)
	parity3_2[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_3[7:0] <=0;
	else if (RSDEC_PARITY3_3L_w)
	parity3_3[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_4[7:0] <=0;
	else if (RSDEC_PARITY3_4L_w)
	parity3_4[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_5[7:0] <=0;
	else if (RSDEC_PARITY3_5L_w)
	parity3_5[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_6[7:0] <=0;
	else if (RSDEC_PARITY3_6L_w)
	parity3_6[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_7[7:0] <=0;
	else if (RSDEC_PARITY3_7L_w)
	parity3_7[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity0_0[9:8] <=0;
	parity0_1[9:8] <=0;
	parity0_2[9:8] <=0;
	parity0_3[9:8] <=0;
	end
	else if (RSDEC_PARITY0_03H_w)
	begin
	parity0_0[9:8]	<= EXT_SFR_DOUT;
	parity0_1[9:8]	<= EXT_SFR_DOUT;
	parity0_2[9:8]	<= EXT_SFR_DOUT;
	parity0_3[9:8]	<= EXT_SFR_DOUT;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity0_4[9:8] <=0;
	parity0_5[9:8] <=0;
	parity0_6[9:8] <=0;
	parity0_7[9:8] <=0;
	end
	else if (RSDEC_PARITY0_47H_w)
	begin
	parity0_4[9:8]	<= EXT_SFR_DOUT;
	parity0_5[9:8]	<= EXT_SFR_DOUT;
	parity0_6[9:8]	<= EXT_SFR_DOUT;
	parity0_7[9:8]	<= EXT_SFR_DOUT;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity1_0[9:8] <=0;
	parity1_1[9:8] <=0;
	parity1_2[9:8] <=0;
	parity1_3[9:8] <=0;
	end
	else if (RSDEC_PARITY1_03H_w)
	begin
	parity1_0[9:8]	<= EXT_SFR_DOUT;
	parity1_1[9:8]	<= EXT_SFR_DOUT;
	parity1_2[9:8]	<= EXT_SFR_DOUT;
	parity1_3[9:8]	<= EXT_SFR_DOUT;
	end
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity1_4[9:8] <=0;
	parity1_5[9:8] <=0;
	parity1_6[9:8] <=0;
	parity1_7[9:8] <=0;
	end
	else if (RSDEC_PARITY1_47H_w)
	begin
	parity1_4[9:8]	<= EXT_SFR_DOUT;
	parity1_5[9:8]	<= EXT_SFR_DOUT;
	parity1_6[9:8]	<= EXT_SFR_DOUT;
	parity1_7[9:8]	<= EXT_SFR_DOUT;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity2_0[9:8] <=0;
	parity2_1[9:8] <=0;
	parity2_2[9:8] <=0;
	parity2_3[9:8] <=0;
	end
	else if (RSDEC_PARITY2_03H_w)
	begin
	parity2_0[9:8]	<= EXT_SFR_DOUT;
	parity2_1[9:8]	<= EXT_SFR_DOUT;
	parity2_2[9:8]	<= EXT_SFR_DOUT;
	parity2_3[9:8]	<= EXT_SFR_DOUT;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity2_4[9:8] <=0;
	parity2_5[9:8] <=0;
	parity2_6[9:8] <=0;
	parity2_7[9:8] <=0;
	end
	else if (RSDEC_PARITY2_47H_w)
	begin
	parity2_4[9:8]	<= EXT_SFR_DOUT;
	parity2_5[9:8]	<= EXT_SFR_DOUT;
	parity2_6[9:8]	<= EXT_SFR_DOUT;
	parity2_7[9:8]	<= EXT_SFR_DOUT;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity3_0[9:8] <=0;
	parity3_1[9:8] <=0;
	parity3_2[9:8] <=0;
	parity3_3[9:8] <=0;
	end
	else if (RSDEC_PARITY3_03H_w)
	begin
	parity3_0[9:8]	<= EXT_SFR_DOUT;
	parity3_1[9:8]	<= EXT_SFR_DOUT;
	parity3_2[9:8]	<= EXT_SFR_DOUT;
	parity3_3[9:8]	<= EXT_SFR_DOUT;
	end
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity3_4[9:8] <=0;
	parity3_5[9:8] <=0;
	parity3_6[9:8] <=0;
	parity3_7[9:8] <=0;
	end
	else if (RSDEC_PARITY3_47H_w)
	begin
	parity3_4[9:8]	<= EXT_SFR_DOUT;
	parity3_5[9:8]	<= EXT_SFR_DOUT;
	parity3_6[9:8]	<= EXT_SFR_DOUT;
	parity3_7[9:8]	<= EXT_SFR_DOUT;
	end
end


always @(EXT_SFR_ADDR or parity0_0 or parity0_1 or parity0_2 or
parity0_3 or parity0_4 or parity0_5 or parity0_6 or parity0_7 or 
parity1_0 or parity1_1 or parity1_2 or parity1_3 or parity1_4 or
parity1_5 or parity1_6 or parity1_7 or parity2_0 or parity2_1 or 
parity2_2 or parity2_3 or parity2_4 or parity2_5 or parity2_6 or 
parity2_7 or parity3_0 or parity3_1 or parity3_2 or parity3_3 or 
parity3_4 or parity3_5 or parity3_6 or parity3_7 or CEPosition0_0 or
CEPosition0_1 or CEPosition0_2 or CEPosition0_3 or CEPosition1_0 or
CEPosition1_1 or CEPosition1_2 or CEPosition1_3 or CEPosition2_0 or
CEPosition2_1 or CEPosition2_2 or CEPosition2_3 or CEPosition3_0 or
CEPosition3_1 or CEPosition3_2 or CEPosition3_3 or CEValue0_0 or
CEValue0_1 or CEValue0_2 or CEValue0_3 or CEValue1_0 or CEValue1_1 or
CEValue1_2 or CEValue1_3 or CEValue2_0 or CEValue2_1 or CEValue2_2 or 
CEValue2_3 or CEValue3_0 or CEValue3_1 or CEValue3_2 or CEValue3_3 or
EUncorrectable or CorrectionEnd)
begin
	case(EXT_SFR_ADDR)	//synopsys parallel_case
		`RSDEC_PARITY0_0L_ADDR : EXT_SFR_DIN = parity0_0[7:0];
		`RSDEC_PARITY0_1L_ADDR : EXT_SFR_DIN = parity0_1[7:0];
		`RSDEC_PARITY0_2L_ADDR : EXT_SFR_DIN = parity0_2[7:0];
		`RSDEC_PARITY0_3L_ADDR : EXT_SFR_DIN = parity0_3[7:0];
		`RSDEC_PARITY0_03H_ADDR : EXT_SFR_DIN = {parity0_3[9:8],parity0_2[9:8],parity0_1[9:8],parity0_0[9:8]};
		`RSDEC_PARITY0_4L_ADDR : EXT_SFR_DIN = parity0_4[7:0];
		`RSDEC_PARITY0_5L_ADDR : EXT_SFR_DIN = parity0_5[7:0];
		`RSDEC_PARITY0_6L_ADDR : EXT_SFR_DIN = parity0_6[7:0];
		`RSDEC_PARITY0_7L_ADDR : EXT_SFR_DIN = parity0_7[7:0];
		`RSDEC_PARITY0_47H_ADDR : EXT_SFR_DIN = {parity0_7[9:8],parity0_6[9:8],parity0_5[9:8], parity0_4[9:8]};

		`RSDEC_PARITY1_0L_ADDR : EXT_SFR_DIN = parity1_0[7:0];
		`RSDEC_PARITY1_1L_ADDR : EXT_SFR_DIN = parity1_1[7:0];
		`RSDEC_PARITY1_2L_ADDR : EXT_SFR_DIN = parity1_2[7:0];
		`RSDEC_PARITY1_3L_ADDR : EXT_SFR_DIN = parity1_3[7:0];
		`RSDEC_PARITY1_03H_ADDR : EXT_SFR_DIN = {parity1_3[9:8],parity1_2[9:8],parity1_1[9:8],parity1_0[9:8]};
		`RSDEC_PARITY1_4L_ADDR : EXT_SFR_DIN = parity1_4[7:0];
		`RSDEC_PARITY1_5L_ADDR : EXT_SFR_DIN = parity1_5[7:0];
		`RSDEC_PARITY1_6L_ADDR : EXT_SFR_DIN = parity1_6[7:0];
		`RSDEC_PARITY1_7L_ADDR : EXT_SFR_DIN = parity1_7[7:0];
		`RSDEC_PARITY1_47H_ADDR : EXT_SFR_DIN = {parity1_7[9:8],parity1_6[9:8],parity1_5[9:8], parity1_4[9:8]};

		`RSDEC_PARITY2_0L_ADDR : EXT_SFR_DIN = parity2_0[7:0];
		`RSDEC_PARITY2_1L_ADDR : EXT_SFR_DIN = parity2_1[7:0];
		`RSDEC_PARITY2_2L_ADDR : EXT_SFR_DIN = parity2_2[7:0];
		`RSDEC_PARITY2_3L_ADDR : EXT_SFR_DIN = parity2_3[7:0];
		`RSDEC_PARITY2_03H_ADDR : EXT_SFR_DIN = {parity2_3[9:8],parity2_2[9:8],parity2_1[9:8],parity2_0[9:8]};
		`RSDEC_PARITY2_4L_ADDR : EXT_SFR_DIN = parity2_4[7:0];
		`RSDEC_PARITY2_5L_ADDR : EXT_SFR_DIN = parity2_5[7:0];
		`RSDEC_PARITY2_6L_ADDR : EXT_SFR_DIN = parity2_6[7:0];
		`RSDEC_PARITY2_7L_ADDR : EXT_SFR_DIN = parity2_7[7:0];
		`RSDEC_PARITY2_47H_ADDR : EXT_SFR_DIN = {parity2_7[9:8],parity2_6[9:8],parity2_5[9:8], parity2_4[9:8]};

		`RSDEC_PARITY3_0L_ADDR : EXT_SFR_DIN = parity3_0[7:0];
		`RSDEC_PARITY3_1L_ADDR : EXT_SFR_DIN = parity3_1[7:0];
		`RSDEC_PARITY3_2L_ADDR : EXT_SFR_DIN = parity3_2[7:0];
		`RSDEC_PARITY3_3L_ADDR : EXT_SFR_DIN = parity3_3[7:0];
		`RSDEC_PARITY3_03H_ADDR : EXT_SFR_DIN = {parity3_3[9:8],parity3_2[9:8],parity3_1[9:8],parity3_0[9:8]};
		`RSDEC_PARITY3_4L_ADDR : EXT_SFR_DIN = parity3_4[7:0];
		`RSDEC_PARITY3_5L_ADDR : EXT_SFR_DIN = parity3_5[7:0];
		`RSDEC_PARITY3_6L_ADDR : EXT_SFR_DIN = parity3_6[7:0];
		`RSDEC_PARITY3_7L_ADDR : EXT_SFR_DIN = parity3_7[7:0];
		`RSDEC_PARITY3_47H_ADDR : EXT_SFR_DIN = {parity3_7[9:8],parity3_6[9:8],parity3_5[9:8], parity3_4[9:8]};

		`CEPosition0_0L_ADDR	: EXT_SFR_DIN =CEPosition0_0[7:0];
		`CEPosition0_1L_ADDR	: EXT_SFR_DIN =CEPosition0_1[7:0];
		`CEPosition0_2L_ADDR	: EXT_SFR_DIN =CEPosition0_2[7:0];
		`CEPosition0_3L_ADDR	: EXT_SFR_DIN =CEPosition0_3[7:0];
		`CEPosition0_03H_ADDR	: EXT_SFR_DIN ={CEPosition0_3[9:8],CEPosition0_2[9:8],CEPosition0_1[9:8],CEPosition0_0[9:8]};
                                               
		`CEValue0_0L_ADDR   	: EXT_SFR_DIN =CEValue0_0[7:0];
		`CEValue0_1L_ADDR   	: EXT_SFR_DIN =CEValue0_1[7:0];
		`CEValue0_2L_ADDR   	: EXT_SFR_DIN =CEValue0_2[7:0];
		`CEValue0_3L_ADDR   	: EXT_SFR_DIN =CEValue0_3[7:0];
		`CEValue0_03H_ADDR   	: EXT_SFR_DIN ={CEValue0_3[9:8],CEValue0_2[9:8],CEValue0_1[9:8],CEValue0_0[9:8]};
                                               
		`CEPosition1_0L_ADDR	: EXT_SFR_DIN =CEPosition1_0[7:0];
		`CEPosition1_1L_ADDR	: EXT_SFR_DIN =CEPosition1_1[7:0];
		`CEPosition1_2L_ADDR	: EXT_SFR_DIN =CEPosition1_2[7:0];
		`CEPosition1_3L_ADDR	: EXT_SFR_DIN =CEPosition1_3[7:0];
		`CEPosition1_03H_ADDR	: EXT_SFR_DIN ={CEPosition1_3[9:8],CEPosition1_2[9:8],CEPosition1_1[9:8],CEPosition1_0[9:8]};
                                               
		`CEValue1_0L_ADDR   	: EXT_SFR_DIN =CEValue1_0[7:0];
		`CEValue1_1L_ADDR   	: EXT_SFR_DIN =CEValue1_1[7:0];
		`CEValue1_2L_ADDR   	: EXT_SFR_DIN =CEValue1_2[7:0];
		`CEValue1_3L_ADDR   	: EXT_SFR_DIN =CEValue1_3[7:0];
		`CEValue1_03H_ADDR  	: EXT_SFR_DIN ={CEValue1_3[9:8],CEValue1_2[9:8],CEValue1_1[9:8],CEValue1_0[9:8]};
                                               
		`CEPosition2_0L_ADDR	: EXT_SFR_DIN =CEPosition2_0[7:0];
		`CEPosition2_1L_ADDR	: EXT_SFR_DIN =CEPosition2_1[7:0];
		`CEPosition2_2L_ADDR	: EXT_SFR_DIN =CEPosition2_2[7:0];
		`CEPosition2_3L_ADDR	: EXT_SFR_DIN =CEPosition2_3[7:0];
		`CEPosition2_03H_ADDR	: EXT_SFR_DIN ={CEPosition2_3[9:8],CEPosition2_2[9:8],CEPosition2_1[9:8],CEPosition2_0[9:8]};
                                               
		`CEValue2_0L_ADDR   	: EXT_SFR_DIN =CEValue2_0[7:0];
		`CEValue2_1L_ADDR   	: EXT_SFR_DIN =CEValue2_1[7:0];
		`CEValue2_2L_ADDR   	: EXT_SFR_DIN =CEValue2_2[7:0];
		`CEValue2_3L_ADDR   	: EXT_SFR_DIN =CEValue2_3[7:0];
		`CEValue2_03H_ADDR  	: EXT_SFR_DIN ={CEValue2_3[9:8],CEValue2_2[9:8],CEValue2_1[9:8],CEValue2_0[9:8]};
                                               
		`CEPosition3_0L_ADDR	: EXT_SFR_DIN =CEPosition3_0[7:0];
		`CEPosition3_1L_ADDR	: EXT_SFR_DIN =CEPosition3_1[7:0];
		`CEPosition3_2L_ADDR	: EXT_SFR_DIN =CEPosition3_2[7:0];
		`CEPosition3_3L_ADDR	: EXT_SFR_DIN =CEPosition3_3[7:0];
		`CEPosition3_03H_ADDR	: EXT_SFR_DIN ={CEPosition3_3[9:8],CEPosition3_2[9:8],CEPosition3_1[9:8],CEPosition3_0[9:8]};
                                               
		`CEValue3_0L_ADDR  		: EXT_SFR_DIN =CEValue3_0[7:0];
		`CEValue3_1L_ADDR  		: EXT_SFR_DIN =CEValue3_1[7:0];
		`CEValue3_2L_ADDR  		: EXT_SFR_DIN =CEValue3_2[7:0];
		`CEValue3_3L_ADDR  		: EXT_SFR_DIN =CEValue3_3[7:0];
		`CEValue3_03H_ADDR 		: EXT_SFR_DIN ={CEValue3_3[9:8],CEValue3_2[9:8],CEValue3_1[9:8],CEValue3_0[9:8]};
		`RSDecoderStatus_ADDR  	: EXT_SFR_DIN ={CorrectionEnd, 3'd0, EUncorrectable};
                                               
		default		: EXT_SFR_DIN	= 8'h00;
		endcase
end

endmodule
