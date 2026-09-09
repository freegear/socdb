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
	EXT_BK_ADDR,
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
input	[6:0]	EXT_BK_ADDR;
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

output	[7:0]	EXT_SFR_DIN;

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

// 00h
`define RSDEC_PARITY0_0L_ADDR		7'h01
`define RSDEC_PARITY0_1L_ADDR		7'h02
`define RSDEC_PARITY0_2L_ADDR		7'h03
`define RSDEC_PARITY0_3L_ADDR		7'h04
`define RSDEC_PARITY0_03H_ADDR		7'h05
`define RSDEC_PARITY0_4L_ADDR		7'h06
`define RSDEC_PARITY0_5L_ADDR		7'h07
// 08h
`define RSDEC_PARITY0_6L_ADDR		7'h09
`define RSDEC_PARITY0_7L_ADDR		7'h0A
`define RSDEC_PARITY0_47H_ADDR		7'h0B

`define RSDEC_PARITY1_0L_ADDR		7'h0C
`define RSDEC_PARITY1_1L_ADDR		7'h0D
`define RSDEC_PARITY1_2L_ADDR		7'h0E
`define RSDEC_PARITY1_3L_ADDR		7'h0F
// 10h
`define RSDEC_PARITY1_03H_ADDR		7'h11
`define RSDEC_PARITY1_4L_ADDR		7'h12
`define RSDEC_PARITY1_5L_ADDR		7'h13
`define RSDEC_PARITY1_6L_ADDR		7'h14
`define RSDEC_PARITY1_7L_ADDR		7'h15
`define RSDEC_PARITY1_47H_ADDR		7'h16

`define RSDEC_PARITY2_0L_ADDR		7'h17
// 18h
`define RSDEC_PARITY2_1L_ADDR		7'h19
`define RSDEC_PARITY2_2L_ADDR		7'h1A
`define RSDEC_PARITY2_3L_ADDR		7'h1B
`define RSDEC_PARITY2_03H_ADDR		7'h1C
`define RSDEC_PARITY2_4L_ADDR		7'h1D
`define RSDEC_PARITY2_5L_ADDR		7'h1E
`define RSDEC_PARITY2_6L_ADDR		7'h1F
// 20h
`define RSDEC_PARITY2_7L_ADDR		7'h21
`define RSDEC_PARITY2_47H_ADDR		7'h22

`define RSDEC_PARITY3_0L_ADDR		7'h23
`define RSDEC_PARITY3_1L_ADDR		7'h24
`define RSDEC_PARITY3_2L_ADDR		7'h25
`define RSDEC_PARITY3_3L_ADDR		7'h26
`define RSDEC_PARITY3_03H_ADDR		7'h27
// 28h
`define RSDEC_PARITY3_4L_ADDR		7'h29
`define RSDEC_PARITY3_5L_ADDR		7'h2A
`define RSDEC_PARITY3_6L_ADDR		7'h2B
`define RSDEC_PARITY3_7L_ADDR		7'h2C
`define RSDEC_PARITY3_47H_ADDR		7'h2D

`define	CEPosition0_0L_ADDR		7'h2E
`define	CEPosition0_1L_ADDR		7'h2F
// 30h
`define	CEPosition0_2L_ADDR		7'h31
`define	CEPosition0_3L_ADDR		7'h32
`define	CEPosition0_03H_ADDR	7'h33

`define	CEValue0_0L_ADDR   		7'h34
`define	CEValue0_1L_ADDR   		7'h35
`define	CEValue0_2L_ADDR   		7'h36
`define	CEValue0_3L_ADDR   		7'h37
// 38h
`define	CEValue0_03H_ADDR   	7'h39

`define	CEPosition1_0L_ADDR		7'h3A
`define	CEPosition1_1L_ADDR		7'h3B	
`define	CEPosition1_2L_ADDR		7'h3C
`define	CEPosition1_3L_ADDR		7'h3D
`define	CEPosition1_03H_ADDR	7'h3E
`define	CEValue1_0L_ADDR   		7'h3F
// 40h
`define	CEValue1_1L_ADDR   		7'h41
`define	CEValue1_2L_ADDR   		7'h42
`define	CEValue1_3L_ADDR   		7'h43
`define	CEValue1_03H_ADDR  		7'h44

`define	CEPosition2_0L_ADDR		7'h45
`define	CEPosition2_1L_ADDR		7'h46
`define	CEPosition2_2L_ADDR		7'h47
// 48h
`define	CEPosition2_3L_ADDR		7'h49
`define	CEPosition2_03H_ADDR	7'h4A

`define	CEValue2_0L_ADDR   		7'h4B
`define	CEValue2_1L_ADDR   		7'h4C
`define	CEValue2_2L_ADDR   		7'h4D
`define	CEValue2_3L_ADDR   		7'h4E
`define	CEValue2_03H_ADDR  		7'h4F
// 50h
`define	CEPosition3_0L_ADDR		7'h51
`define	CEPosition3_1L_ADDR		7'h52
`define	CEPosition3_2L_ADDR		7'h53
`define	CEPosition3_3L_ADDR		7'h54
`define	CEPosition3_03H_ADDR	7'h55

`define	CEValue3_0L_ADDR   		7'h56
`define	CEValue3_1L_ADDR   		7'h57
// 58h
`define	CEValue3_2L_ADDR   		7'h59
`define	CEValue3_3L_ADDR   		7'h5A
`define	CEValue3_03H_ADDR  		7'h5B
   
`define	RSDecoderStatus_ADDR  	7'h5C



wire    RSDEC_STATUS        = (EXT_BK_ADDR == `RSDecoderStatus_ADDR)? 1'b1 : 1'b0;

wire	RSDEC_PARITY0_0L	= (EXT_BK_ADDR == `RSDEC_PARITY0_0L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY0_1L	= (EXT_BK_ADDR == `RSDEC_PARITY0_1L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY0_2L	= (EXT_BK_ADDR == `RSDEC_PARITY0_2L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY0_3L	= (EXT_BK_ADDR == `RSDEC_PARITY0_3L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY0_03H	= (EXT_BK_ADDR == `RSDEC_PARITY0_03H_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY0_4L	= (EXT_BK_ADDR == `RSDEC_PARITY0_4L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY0_5L	= (EXT_BK_ADDR == `RSDEC_PARITY0_5L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY0_6L	= (EXT_BK_ADDR == `RSDEC_PARITY0_6L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY0_7L 	= (EXT_BK_ADDR == `RSDEC_PARITY0_7L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY0_47H	= (EXT_BK_ADDR == `RSDEC_PARITY0_47H_ADDR)? 1'b1 : 1'b0;

wire	RSDEC_PARITY1_0L 	= (EXT_BK_ADDR == `RSDEC_PARITY1_0L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY1_1L 	= (EXT_BK_ADDR == `RSDEC_PARITY1_1L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY1_2L 	= (EXT_BK_ADDR == `RSDEC_PARITY1_2L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY1_3L 	= (EXT_BK_ADDR == `RSDEC_PARITY1_3L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY1_03H	= (EXT_BK_ADDR == `RSDEC_PARITY1_03H_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY1_4L 	= (EXT_BK_ADDR == `RSDEC_PARITY1_4L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY1_5L 	= (EXT_BK_ADDR == `RSDEC_PARITY1_5L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY1_6L 	= (EXT_BK_ADDR == `RSDEC_PARITY1_6L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY1_7L 	= (EXT_BK_ADDR == `RSDEC_PARITY1_7L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY1_47H	= (EXT_BK_ADDR == `RSDEC_PARITY1_47H_ADDR)? 1'b1 : 1'b0;

wire	RSDEC_PARITY2_0L 	= (EXT_BK_ADDR == `RSDEC_PARITY2_0L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY2_1L 	= (EXT_BK_ADDR == `RSDEC_PARITY2_1L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY2_2L 	= (EXT_BK_ADDR == `RSDEC_PARITY2_2L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY2_3L 	= (EXT_BK_ADDR == `RSDEC_PARITY2_3L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY2_03H	= (EXT_BK_ADDR == `RSDEC_PARITY2_03H_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY2_4L 	= (EXT_BK_ADDR == `RSDEC_PARITY2_4L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY2_5L 	= (EXT_BK_ADDR == `RSDEC_PARITY2_5L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY2_6L 	= (EXT_BK_ADDR == `RSDEC_PARITY2_6L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY2_7L 	= (EXT_BK_ADDR == `RSDEC_PARITY2_7L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY2_47H	= (EXT_BK_ADDR == `RSDEC_PARITY2_47H_ADDR)? 1'b1 : 1'b0;

wire	RSDEC_PARITY3_0L 	= (EXT_BK_ADDR == `RSDEC_PARITY3_0L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY3_1L 	= (EXT_BK_ADDR == `RSDEC_PARITY3_1L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY3_2L 	= (EXT_BK_ADDR == `RSDEC_PARITY3_2L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY3_3L 	= (EXT_BK_ADDR == `RSDEC_PARITY3_3L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY3_03H	= (EXT_BK_ADDR == `RSDEC_PARITY3_03H_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY3_4L 	= (EXT_BK_ADDR == `RSDEC_PARITY3_4L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY3_5L 	= (EXT_BK_ADDR == `RSDEC_PARITY3_5L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY3_6L 	= (EXT_BK_ADDR == `RSDEC_PARITY3_6L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY3_7L 	= (EXT_BK_ADDR == `RSDEC_PARITY3_7L_ADDR)? 1'b1 : 1'b0;
wire	RSDEC_PARITY3_47H	= (EXT_BK_ADDR == `RSDEC_PARITY3_47H_ADDR)? 1'b1 : 1'b0;


// CExxx´Â read only
wire    CEPosition0_0L      = (EXT_BK_ADDR == `CEPosition0_0L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition0_1L      = (EXT_BK_ADDR == `CEPosition0_1L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition0_2L      = (EXT_BK_ADDR == `CEPosition0_2L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition0_3L      = (EXT_BK_ADDR == `CEPosition0_3L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition0_03H     = (EXT_BK_ADDR == `CEPosition0_03H_ADDR)? 1'b1 : 1'b0;

wire    CEValue0_0L         = (EXT_BK_ADDR == `CEValue0_0L_ADDR)? 1'b1 : 1'b0;
wire    CEValue0_1L         = (EXT_BK_ADDR == `CEValue0_1L_ADDR)? 1'b1 : 1'b0;
wire    CEValue0_2L         = (EXT_BK_ADDR == `CEValue0_2L_ADDR)? 1'b1 : 1'b0;
wire    CEValue0_3L         = (EXT_BK_ADDR == `CEValue0_3L_ADDR)? 1'b1 : 1'b0;
wire    CEValue0_03H        = (EXT_BK_ADDR == `CEValue0_03H_ADDR)? 1'b1 : 1'b0;

wire    CEPosition1_0L      = (EXT_BK_ADDR == `CEPosition1_0L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition1_1L      = (EXT_BK_ADDR == `CEPosition1_1L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition1_2L      = (EXT_BK_ADDR == `CEPosition1_2L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition1_3L      = (EXT_BK_ADDR == `CEPosition1_3L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition1_03H     = (EXT_BK_ADDR == `CEPosition1_03H_ADDR)? 1'b1 : 1'b0;

wire    CEValue1_0L         = (EXT_BK_ADDR == `CEValue1_0L_ADDR)? 1'b1 : 1'b0;
wire    CEValue1_1L         = (EXT_BK_ADDR == `CEValue1_1L_ADDR)? 1'b1 : 1'b0;
wire    CEValue1_2L         = (EXT_BK_ADDR == `CEValue1_2L_ADDR)? 1'b1 : 1'b0;
wire    CEValue1_3L         = (EXT_BK_ADDR == `CEValue1_3L_ADDR)? 1'b1 : 1'b0;
wire    CEValue1_03H        = (EXT_BK_ADDR == `CEValue1_03H_ADDR)? 1'b1 : 1'b0;

wire    CEPosition2_0L      = (EXT_BK_ADDR == `CEPosition2_0L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition2_1L      = (EXT_BK_ADDR == `CEPosition2_1L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition2_2L      = (EXT_BK_ADDR == `CEPosition2_2L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition2_3L      = (EXT_BK_ADDR == `CEPosition2_3L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition2_03H     = (EXT_BK_ADDR == `CEPosition2_03H_ADDR)? 1'b1 : 1'b0;

wire    CEValue2_0L         = (EXT_BK_ADDR == `CEValue2_0L_ADDR)? 1'b1 : 1'b0;
wire    CEValue2_1L         = (EXT_BK_ADDR == `CEValue2_1L_ADDR)? 1'b1 : 1'b0;
wire    CEValue2_2L         = (EXT_BK_ADDR == `CEValue2_2L_ADDR)? 1'b1 : 1'b0;
wire    CEValue2_3L         = (EXT_BK_ADDR == `CEValue2_3L_ADDR)? 1'b1 : 1'b0;
wire    CEValue2_03H        = (EXT_BK_ADDR == `CEValue2_03H_ADDR)? 1'b1 : 1'b0;

wire    CEPosition3_0L      = (EXT_BK_ADDR == `CEPosition3_0L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition3_1L      = (EXT_BK_ADDR == `CEPosition3_1L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition3_2L      = (EXT_BK_ADDR == `CEPosition3_2L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition3_3L      = (EXT_BK_ADDR == `CEPosition3_3L_ADDR)? 1'b1 : 1'b0;
wire    CEPosition3_03H     = (EXT_BK_ADDR == `CEPosition3_03H_ADDR)? 1'b1 : 1'b0;

wire    CEValue3_0L         = (EXT_BK_ADDR == `CEValue3_0L_ADDR)? 1'b1 : 1'b0;
wire    CEValue3_1L         = (EXT_BK_ADDR == `CEValue3_1L_ADDR)? 1'b1 : 1'b0;
wire    CEValue3_2L         = (EXT_BK_ADDR == `CEValue3_2L_ADDR)? 1'b1 : 1'b0;
wire    CEValue3_3L         = (EXT_BK_ADDR == `CEValue3_3L_ADDR)? 1'b1 : 1'b0;
wire    CEValue3_03H        = (EXT_BK_ADDR == `CEValue3_03H_ADDR)? 1'b1 : 1'b0;

   
wire 	RSDEC_WR;
   
assign	RSDEC_WR = (EXT_SFR_WR) & (CS);

//reg	[7:0]	RSDEC;
reg	[7:0]	EXT_SFR_DIN;
reg	[7:0]	NextEXT_SFR_DIN;
reg			CorrectionEnd;

//always @(posedge CLK or negedge RESETn)
//begin
//	if (!RESETn)
//	RSDEC <= 0;
//	else if (RSDEC_WR)
//	RSDEC <= EXT_SFR_DOUT;
//end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	  CorrectionEnd <= 1'b0;
	else if (RSDEC_WR & RSDEC_STATUS & (EXT_SFR_DOUT[7]==1'b0))
	  CorrectionEnd <= 1'b0;
	else if (ECorrectEnd)
	  CorrectionEnd <= 1'b1;
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	  parity0_0[7:0] <= 8'h00;
	else if (RSDEC_PARITY0_0L & RSDEC_WR)
	  parity0_0[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_1[7:0] <= 8'h00;
	else if (RSDEC_PARITY0_1L & RSDEC_WR)
	parity0_1[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_2[7:0] <= 8'h00;
	else if (RSDEC_PARITY0_2L & RSDEC_WR)
	parity0_2[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_3[7:0] <= 8'h00;
	else if (RSDEC_PARITY0_3L & RSDEC_WR)
	parity0_3[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_4[7:0] <= 8'h00;
	else if (RSDEC_PARITY0_4L & RSDEC_WR)
	parity0_4[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_5[7:0] <= 8'h00;
	else if (RSDEC_PARITY0_5L & RSDEC_WR)
	parity0_5[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_6[7:0] <= 8'h00;
	else if (RSDEC_PARITY0_6L & RSDEC_WR)
	parity0_6[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity0_7[7:0] <= 8'h00;
	else if (RSDEC_PARITY0_7L & RSDEC_WR)
	parity0_7[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_0[7:0] <= 8'h00;
	else if (RSDEC_PARITY1_0L & RSDEC_WR)
	parity1_0[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_1[7:0] <= 8'h00;
	else if (RSDEC_PARITY1_1L & RSDEC_WR)
	parity1_1[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_2[7:0] <= 8'h00;
	else if (RSDEC_PARITY1_2L & RSDEC_WR)
	parity1_2[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_3[7:0] <= 8'h00;
	else if (RSDEC_PARITY1_3L & RSDEC_WR)
	parity1_3[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_4[7:0] <= 8'h00;
	else if (RSDEC_PARITY1_4L & RSDEC_WR)
	parity1_4[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_5[7:0] <= 8'h00;
	else if (RSDEC_PARITY1_5L & RSDEC_WR)
	parity1_5[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_6[7:0] <= 8'h00;
	else if (RSDEC_PARITY1_6L & RSDEC_WR)
	parity1_6[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity1_7[7:0] <= 8'h00;
	else if (RSDEC_PARITY1_7L & RSDEC_WR)
	parity1_7[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_0[7:0] <= 8'h00;
	else if (RSDEC_PARITY2_0L & RSDEC_WR)
	parity2_0[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_1[7:0] <= 8'h00;
	else if (RSDEC_PARITY2_1L & RSDEC_WR)
	parity2_1[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_2[7:0] <= 8'h00;
	else if (RSDEC_PARITY2_2L & RSDEC_WR)
	parity2_2[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_3[7:0] <= 8'h00;
	else if (RSDEC_PARITY2_3L & RSDEC_WR)
	parity2_3[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_4[7:0] <= 8'h00;
	else if (RSDEC_PARITY2_4L & RSDEC_WR)
	parity2_4[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_5[7:0] <= 8'h00;
	else if (RSDEC_PARITY2_5L & RSDEC_WR)
	parity2_5[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_6[7:0] <= 8'h00;
	else if (RSDEC_PARITY2_6L & RSDEC_WR)
	parity2_6[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity2_7[7:0] <= 8'h00;
	else if (RSDEC_PARITY2_7L & RSDEC_WR)
	parity2_7[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_0[7:0] <= 8'h00;
	else if (RSDEC_PARITY3_0L & RSDEC_WR)
	parity3_0[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_1[7:0] <= 8'h00;
	else if (RSDEC_PARITY3_1L & RSDEC_WR)
	parity3_1[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_2[7:0] <= 8'h00;
	else if (RSDEC_PARITY3_2L & RSDEC_WR)
	parity3_2[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_3[7:0] <= 8'h00;
	else if (RSDEC_PARITY3_3L & RSDEC_WR)
	parity3_3[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_4[7:0] <= 8'h00;
	else if (RSDEC_PARITY3_4L & RSDEC_WR)
	parity3_4[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_5[7:0] <= 8'h00;
	else if (RSDEC_PARITY3_5L & RSDEC_WR)
	parity3_5[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_6[7:0] <= 8'h00;
	else if (RSDEC_PARITY3_6L & RSDEC_WR)
	parity3_6[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	parity3_7[7:0] <= 8'h00;
	else if (RSDEC_PARITY3_7L & RSDEC_WR)
	parity3_7[7:0]	<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity0_0[9:8] <= 2'h0;
	parity0_1[9:8] <= 2'h0;
	parity0_2[9:8] <= 2'h0;
	parity0_3[9:8] <= 2'h0;
	end
	else if (RSDEC_PARITY0_03H & RSDEC_WR)
	begin
	parity0_0[9:8]	<= EXT_SFR_DOUT[1:0];
	parity0_1[9:8]	<= EXT_SFR_DOUT[3:2];
	parity0_2[9:8]	<= EXT_SFR_DOUT[5:4];
	parity0_3[9:8]	<= EXT_SFR_DOUT[7:6];
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity0_4[9:8] <= 2'h0;
	parity0_5[9:8] <= 2'h0;
	parity0_6[9:8] <= 2'h0;
	parity0_7[9:8] <= 2'h0;
	end
	else if (RSDEC_PARITY0_47H & RSDEC_WR)
	begin
	parity0_4[9:8]	<= EXT_SFR_DOUT[1:0];
	parity0_5[9:8]	<= EXT_SFR_DOUT[3:2];
	parity0_6[9:8]	<= EXT_SFR_DOUT[5:4];
	parity0_7[9:8]	<= EXT_SFR_DOUT[7:6];
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity1_0[9:8] <= 2'h0;
	parity1_1[9:8] <= 2'h0;
	parity1_2[9:8] <= 2'h0;
	parity1_3[9:8] <= 2'h0;
	end
	else if (RSDEC_PARITY1_03H & RSDEC_WR)
	begin
	parity1_0[9:8]	<= EXT_SFR_DOUT[1:0];
	parity1_1[9:8]	<= EXT_SFR_DOUT[3:2];
	parity1_2[9:8]	<= EXT_SFR_DOUT[5:4];
	parity1_3[9:8]	<= EXT_SFR_DOUT[7:6];
	end
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity1_4[9:8] <= 2'h0;
	parity1_5[9:8] <= 2'h0;
	parity1_6[9:8] <= 2'h0;
	parity1_7[9:8] <= 2'h0;
	end
	else if (RSDEC_PARITY1_47H & RSDEC_WR)
	begin
	parity1_4[9:8]	<= EXT_SFR_DOUT[1:0];
	parity1_5[9:8]	<= EXT_SFR_DOUT[3:2];
	parity1_6[9:8]	<= EXT_SFR_DOUT[5:4];
	parity1_7[9:8]	<= EXT_SFR_DOUT[7:6];
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity2_0[9:8] <= 2'h0;
	parity2_1[9:8] <= 2'h0;
	parity2_2[9:8] <= 2'h0;
	parity2_3[9:8] <= 2'h0;
	end
	else if (RSDEC_PARITY2_03H & RSDEC_WR)
	begin
	parity2_0[9:8]	<= EXT_SFR_DOUT[1:0];
	parity2_1[9:8]	<= EXT_SFR_DOUT[3:2];
	parity2_2[9:8]	<= EXT_SFR_DOUT[5:4];
	parity2_3[9:8]	<= EXT_SFR_DOUT[7:6];
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity2_4[9:8] <= 2'h0;
	parity2_5[9:8] <= 2'h0;
	parity2_6[9:8] <= 2'h0;
	parity2_7[9:8] <= 2'h0;
	end
	else if (RSDEC_PARITY2_47H & RSDEC_WR)
	begin
	parity2_4[9:8]	<= EXT_SFR_DOUT[1:0];
	parity2_5[9:8]	<= EXT_SFR_DOUT[3:2];
	parity2_6[9:8]	<= EXT_SFR_DOUT[5:4];
	parity2_7[9:8]	<= EXT_SFR_DOUT[7:6];
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity3_0[9:8] <= 2'h0;
	parity3_1[9:8] <= 2'h0;
	parity3_2[9:8] <= 2'h0;
	parity3_3[9:8] <= 2'h0;
	end
	else if (RSDEC_PARITY3_03H & RSDEC_WR)
	begin
	parity3_0[9:8]	<= EXT_SFR_DOUT[1:0];
	parity3_1[9:8]	<= EXT_SFR_DOUT[3:2];
	parity3_2[9:8]	<= EXT_SFR_DOUT[5:4];
	parity3_3[9:8]	<= EXT_SFR_DOUT[7:6];
	end
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	parity3_4[9:8] <= 2'h0;
	parity3_5[9:8] <= 2'h0;
	parity3_6[9:8] <= 2'h0;
	parity3_7[9:8] <= 2'h0;
	end
	else if (RSDEC_PARITY3_47H & RSDEC_WR)
	begin
	parity3_4[9:8]	<= EXT_SFR_DOUT[1:0];
	parity3_5[9:8]	<= EXT_SFR_DOUT[3:2];
	parity3_6[9:8]	<= EXT_SFR_DOUT[5:4];
	parity3_7[9:8]	<= EXT_SFR_DOUT[7:6];
	end
end


always @(RSDEC_PARITY0_0L or RSDEC_PARITY0_1L or RSDEC_PARITY0_2L or 
		 RSDEC_PARITY0_3L or RSDEC_PARITY0_03H or
		 RSDEC_PARITY0_4L or RSDEC_PARITY0_5L or RSDEC_PARITY0_6L or
		 RSDEC_PARITY0_7L or RSDEC_PARITY0_47H or
		 RSDEC_PARITY1_0L or RSDEC_PARITY1_1L or RSDEC_PARITY1_2L or 
		 RSDEC_PARITY1_3L or RSDEC_PARITY1_03H or
		 RSDEC_PARITY1_4L or RSDEC_PARITY1_5L or RSDEC_PARITY1_6L or
		 RSDEC_PARITY1_7L or RSDEC_PARITY1_47H or
		 RSDEC_PARITY2_0L or RSDEC_PARITY2_1L or RSDEC_PARITY2_2L or 
		 RSDEC_PARITY2_3L or RSDEC_PARITY2_03H or
		 RSDEC_PARITY2_4L or RSDEC_PARITY2_5L or RSDEC_PARITY2_6L or
		 RSDEC_PARITY2_7L or RSDEC_PARITY2_47H or
		 RSDEC_PARITY3_0L or RSDEC_PARITY3_1L or RSDEC_PARITY3_2L or 
		 RSDEC_PARITY3_3L or RSDEC_PARITY3_03H or
		 RSDEC_PARITY3_4L or RSDEC_PARITY3_5L or RSDEC_PARITY3_6L or
		 RSDEC_PARITY3_7L or RSDEC_PARITY3_47H or
		 CEPosition0_0L or CEPosition0_1L or CEPosition0_2L or 
		 CEPosition0_3L or CEPosition0_03H or
	 	 CEValue0_0L or CEValue0_1L or CEValue0_2L or
		 CEValue0_3L or CEValue0_03H or
		 CEPosition1_0L or CEPosition1_1L or CEPosition1_2L or 
		 CEPosition1_3L or CEPosition1_03H or
	 	 CEValue1_0L or CEValue1_1L or CEValue1_2L or
		 CEValue1_3L or CEValue1_03H or
		 CEPosition2_0L or CEPosition2_1L or CEPosition2_2L or 
		 CEPosition2_3L or CEPosition2_03H or
	 	 CEValue2_0L or CEValue2_1L or CEValue2_2L or
		 CEValue2_3L or CEValue2_03H or
		 CEPosition3_0L or CEPosition3_1L or CEPosition3_2L or 
		 CEPosition3_3L or CEPosition3_03H or
	 	 CEValue3_0L or CEValue3_1L or CEValue2_2L or
		 CEValue3_3L or CEValue3_03H or
		 
		 parity0_0 or parity0_1 or parity0_2 or
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
		 EUncorrectable or CorrectionEnd)  begin
/*
always @(posedge CLK or negedge RESETn) begin
   if(~RESETn) EXT_SFR_DIN <= 8'h00;
   else begin
 */
	  case(1'b1)	//synopsys parallel_case
		RSDEC_PARITY0_0L : EXT_SFR_DIN <= parity0_0[7:0];
		RSDEC_PARITY0_1L : EXT_SFR_DIN <= parity0_1[7:0];
		RSDEC_PARITY0_2L : EXT_SFR_DIN <= parity0_2[7:0];
		RSDEC_PARITY0_3L : EXT_SFR_DIN <= parity0_3[7:0];
		RSDEC_PARITY0_03H : EXT_SFR_DIN <= {parity0_3[9:8],parity0_2[9:8],parity0_1[9:8],parity0_0[9:8]};
		RSDEC_PARITY0_4L : EXT_SFR_DIN <= parity0_4[7:0];
		RSDEC_PARITY0_5L : EXT_SFR_DIN <= parity0_5[7:0];
		RSDEC_PARITY0_6L : EXT_SFR_DIN <= parity0_6[7:0];
		RSDEC_PARITY0_7L : EXT_SFR_DIN <= parity0_7[7:0];
		RSDEC_PARITY0_47H : EXT_SFR_DIN <= {parity0_7[9:8],parity0_6[9:8],parity0_5[9:8], parity0_4[9:8]};
		
		RSDEC_PARITY1_0L : EXT_SFR_DIN <= parity1_0[7:0];
		RSDEC_PARITY1_1L : EXT_SFR_DIN <= parity1_1[7:0];
		RSDEC_PARITY1_2L : EXT_SFR_DIN <= parity1_2[7:0];
		RSDEC_PARITY1_3L : EXT_SFR_DIN <= parity1_3[7:0];
		RSDEC_PARITY1_03H : EXT_SFR_DIN <= {parity1_3[9:8],parity1_2[9:8],parity1_1[9:8],parity1_0[9:8]};
		RSDEC_PARITY1_4L : EXT_SFR_DIN <= parity1_4[7:0];
		RSDEC_PARITY1_5L : EXT_SFR_DIN <= parity1_5[7:0];
		RSDEC_PARITY1_6L : EXT_SFR_DIN <= parity1_6[7:0];
		RSDEC_PARITY1_7L : EXT_SFR_DIN <= parity1_7[7:0];
		RSDEC_PARITY1_47H : EXT_SFR_DIN <= {parity1_7[9:8],parity1_6[9:8],parity1_5[9:8], parity1_4[9:8]};
		
		RSDEC_PARITY2_0L : EXT_SFR_DIN <= parity2_0[7:0];
		RSDEC_PARITY2_1L : EXT_SFR_DIN <= parity2_1[7:0];
		RSDEC_PARITY2_2L : EXT_SFR_DIN <= parity2_2[7:0];
		RSDEC_PARITY2_3L : EXT_SFR_DIN <= parity2_3[7:0];
		RSDEC_PARITY2_03H : EXT_SFR_DIN <= {parity2_3[9:8],parity2_2[9:8],parity2_1[9:8],parity2_0[9:8]};
		RSDEC_PARITY2_4L : EXT_SFR_DIN <= parity2_4[7:0];
		RSDEC_PARITY2_5L : EXT_SFR_DIN <= parity2_5[7:0];
		RSDEC_PARITY2_6L : EXT_SFR_DIN <= parity2_6[7:0];
		RSDEC_PARITY2_7L : EXT_SFR_DIN <= parity2_7[7:0];
		RSDEC_PARITY2_47H : EXT_SFR_DIN <= {parity2_7[9:8],parity2_6[9:8],parity2_5[9:8], parity2_4[9:8]};
		
		RSDEC_PARITY3_0L : EXT_SFR_DIN <= parity3_0[7:0];
		RSDEC_PARITY3_1L : EXT_SFR_DIN <= parity3_1[7:0];
		RSDEC_PARITY3_2L : EXT_SFR_DIN <= parity3_2[7:0];
		RSDEC_PARITY3_3L : EXT_SFR_DIN <= parity3_3[7:0];
		RSDEC_PARITY3_03H : EXT_SFR_DIN <= {parity3_3[9:8],parity3_2[9:8],parity3_1[9:8],parity3_0[9:8]};
		RSDEC_PARITY3_4L : EXT_SFR_DIN <= parity3_4[7:0];
		RSDEC_PARITY3_5L : EXT_SFR_DIN <= parity3_5[7:0];
		RSDEC_PARITY3_6L : EXT_SFR_DIN <= parity3_6[7:0];
		RSDEC_PARITY3_7L : EXT_SFR_DIN <= parity3_7[7:0];
		RSDEC_PARITY3_47H : EXT_SFR_DIN <= {parity3_7[9:8],parity3_6[9:8],parity3_5[9:8], parity3_4[9:8]};
		
		CEPosition0_0L	: EXT_SFR_DIN <= CEPosition0_0[7:0];
		CEPosition0_1L	: EXT_SFR_DIN <= CEPosition0_1[7:0];
		CEPosition0_2L	: EXT_SFR_DIN <= CEPosition0_2[7:0];
		CEPosition0_3L	: EXT_SFR_DIN <= CEPosition0_3[7:0];
		CEPosition0_03H	: EXT_SFR_DIN <= {CEPosition0_3[9:8],CEPosition0_2[9:8],CEPosition0_1[9:8],CEPosition0_0[9:8]};
		
		CEValue0_0L   	: EXT_SFR_DIN <= CEValue0_0[7:0];
		CEValue0_1L   	: EXT_SFR_DIN <= CEValue0_1[7:0];
		CEValue0_2L   	: EXT_SFR_DIN <= CEValue0_2[7:0];
		CEValue0_3L   	: EXT_SFR_DIN <= CEValue0_3[7:0];
		CEValue0_03H   	: EXT_SFR_DIN <= {CEValue0_3[9:8],CEValue0_2[9:8],CEValue0_1[9:8],CEValue0_0[9:8]};
		
		CEPosition1_0L	: EXT_SFR_DIN <= CEPosition1_0[7:0];
		CEPosition1_1L	: EXT_SFR_DIN <= CEPosition1_1[7:0];
		CEPosition1_2L	: EXT_SFR_DIN <= CEPosition1_2[7:0];
		CEPosition1_3L	: EXT_SFR_DIN <= CEPosition1_3[7:0];
		CEPosition1_03H	: EXT_SFR_DIN <= {CEPosition1_3[9:8],CEPosition1_2[9:8],CEPosition1_1[9:8],CEPosition1_0[9:8]};
		
		CEValue1_0L   	: EXT_SFR_DIN <= CEValue1_0[7:0];
		CEValue1_1L   	: EXT_SFR_DIN <= CEValue1_1[7:0];
		CEValue1_2L   	: EXT_SFR_DIN <= CEValue1_2[7:0];
		CEValue1_3L   	: EXT_SFR_DIN <= CEValue1_3[7:0];
		CEValue1_03H  	: EXT_SFR_DIN <= {CEValue1_3[9:8],CEValue1_2[9:8],CEValue1_1[9:8],CEValue1_0[9:8]};
		
		CEPosition2_0L	: EXT_SFR_DIN <= CEPosition2_0[7:0];
		CEPosition2_1L	: EXT_SFR_DIN <= CEPosition2_1[7:0];
		CEPosition2_2L	: EXT_SFR_DIN <= CEPosition2_2[7:0];
		CEPosition2_3L	: EXT_SFR_DIN <= CEPosition2_3[7:0];
		CEPosition2_03H	: EXT_SFR_DIN <= {CEPosition2_3[9:8],CEPosition2_2[9:8],CEPosition2_1[9:8],CEPosition2_0[9:8]};
		
		CEValue2_0L   	: EXT_SFR_DIN <= CEValue2_0[7:0];
		CEValue2_1L   	: EXT_SFR_DIN <= CEValue2_1[7:0];
		CEValue2_2L   	: EXT_SFR_DIN <= CEValue2_2[7:0];
		CEValue2_3L   	: EXT_SFR_DIN <= CEValue2_3[7:0];
		CEValue2_03H  	: EXT_SFR_DIN <= {CEValue2_3[9:8],CEValue2_2[9:8],CEValue2_1[9:8],CEValue2_0[9:8]};
		
		CEPosition3_0L	: EXT_SFR_DIN <= CEPosition3_0[7:0];
		CEPosition3_1L	: EXT_SFR_DIN <= CEPosition3_1[7:0];
		CEPosition3_2L	: EXT_SFR_DIN <= CEPosition3_2[7:0];
		CEPosition3_3L	: EXT_SFR_DIN <= CEPosition3_3[7:0];
		CEPosition3_03H	: EXT_SFR_DIN <= {CEPosition3_3[9:8],CEPosition3_2[9:8],CEPosition3_1[9:8],CEPosition3_0[9:8]};
		
		CEValue3_0L		: EXT_SFR_DIN <= CEValue3_0[7:0];
		CEValue3_1L		: EXT_SFR_DIN <= CEValue3_1[7:0];
		CEValue3_2L		: EXT_SFR_DIN <= CEValue3_2[7:0];
		CEValue3_3L		: EXT_SFR_DIN <= CEValue3_3[7:0];
		CEValue3_03H	: EXT_SFR_DIN <= {CEValue3_3[9:8],CEValue3_2[9:8],CEValue3_1[9:8],CEValue3_0[9:8]};
		RSDEC_STATUS  	: EXT_SFR_DIN <= {CorrectionEnd, 3'h0, EUncorrectable};
		
		default		    : EXT_SFR_DIN <= 8'h00;
	  endcase // case(1'b1)
//   end // else: !if(~RESETn)
end // always @ (posedge CLK or negedge RESETn)
   

endmodule // RSDecRegif

