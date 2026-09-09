// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : RSEncRegif.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : RS Encoder Register Inferface
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module RSEncRegif(
	RESETn,
	CLK,
	CS,
	EXT_SFR_DIN, 
	EXT_SFR_DOUT, 
	EXT_BK_ADDR, 
	EXT_SFR_WR,
	//PARITYACCESS
	RSEn_End,
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


input	RESETn;
input	CLK;
input			CS;
output	[7:0]	EXT_SFR_DIN;
input 	[7:0]	EXT_SFR_DOUT;
input 	[5:0]	EXT_BK_ADDR;
input		    EXT_SFR_WR;

input			RSEn_End;
output			NFBlockSize;

input	[9:0]	PARITY0_7;
input	[9:0] 	PARITY0_6;
input	[9:0] 	PARITY0_5;
input	[9:0] 	PARITY0_4;
input	[9:0] 	PARITY0_3;
input	[9:0] 	PARITY0_2;
input	[9:0] 	PARITY0_1;
input	[9:0] 	PARITY0_0;

input	[9:0] 	PARITY1_7;
input	[9:0] 	PARITY1_6;
input	[9:0] 	PARITY1_5;
input	[9:0] 	PARITY1_4;
input	[9:0] 	PARITY1_3;
input	[9:0] 	PARITY1_2;
input	[9:0] 	PARITY1_1;
input	[9:0] 	PARITY1_0;

input	[9:0] 	PARITY2_7;
input	[9:0] 	PARITY2_6;
input	[9:0] 	PARITY2_5;
input	[9:0] 	PARITY2_4;
input	[9:0] 	PARITY2_3;
input	[9:0] 	PARITY2_2;
input	[9:0] 	PARITY2_1;
input	[9:0] 	PARITY2_0;

input	[9:0] 	PARITY3_7;
input	[9:0] 	PARITY3_6;
input	[9:0] 	PARITY3_5;
input	[9:0] 	PARITY3_4;
input	[9:0] 	PARITY3_3;
input	[9:0] 	PARITY3_2;
input	[9:0] 	PARITY3_1;
input	[9:0] 	PARITY3_0;


reg		[7:0]	EXT_SFR_DIN;

reg				NFBlockSize;

`define PARITY0_0L_ADDR		6'h01
`define PARITY0_1L_ADDR		6'h02
`define PARITY0_2L_ADDR		6'h03
`define PARITY0_3L_ADDR		6'h04
`define PARITY0_03H_ADDR	6'h05
`define PARITY0_4L_ADDR		6'h06
`define PARITY0_5L_ADDR		6'h07
// 08h
`define PARITY0_6L_ADDR		6'h09
`define PARITY0_7L_ADDR		6'h0A
`define PARITY0_47H_ADDR	6'h0B

`define PARITY1_0L_ADDR		6'h0C
`define PARITY1_1L_ADDR		6'h0D
`define PARITY1_2L_ADDR		6'h0E
`define PARITY1_3L_ADDR		6'h0F
// 10h
`define PARITY1_03H_ADDR	6'h11
`define PARITY1_4L_ADDR		6'h12
`define PARITY1_5L_ADDR		6'h13
`define PARITY1_6L_ADDR		6'h14
`define PARITY1_7L_ADDR		6'h15
`define PARITY1_47H_ADDR	6'h16

`define PARITY2_0L_ADDR		6'h17
// 18h
`define PARITY2_1L_ADDR		6'h19
`define PARITY2_2L_ADDR		6'h1A
`define PARITY2_3L_ADDR		6'h1B
`define PARITY2_03H_ADDR	6'h1C
`define PARITY2_4L_ADDR		6'h1D
`define PARITY2_5L_ADDR		6'h1E
`define PARITY2_6L_ADDR		6'h1F
// 20h
`define PARITY2_7L_ADDR		6'h21
`define PARITY2_47H_ADDR	6'h22

`define PARITY3_0L_ADDR		6'h23
`define PARITY3_1L_ADDR		6'h24
`define PARITY3_2L_ADDR		6'h25
`define PARITY3_3L_ADDR		6'h26
`define PARITY3_03H_ADDR	6'h27
// 28h
`define PARITY3_4L_ADDR		6'h29
`define PARITY3_5L_ADDR		6'h2A
`define PARITY3_6L_ADDR		6'h2B
`define PARITY3_7L_ADDR		6'h2C
`define PARITY3_47H_ADDR	6'h2D
`define RSEncoderCtrl_ADDR	6'h2E

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn) NFBlockSize <= 1'b0;
	else if ((EXT_BK_ADDR==`RSEncoderCtrl_ADDR)& EXT_SFR_WR & (CS==1'b1))
	  NFBlockSize <= EXT_SFR_DOUT[0];
end

always 	@(EXT_BK_ADDR or PARITY0_0 or PARITY0_1 or PARITY0_2 or
PARITY0_3 or PARITY0_4 or PARITY0_5 or PARITY0_6 or PARITY0_7 or 
PARITY1_0 or PARITY1_1 or PARITY1_2 or PARITY1_3 or PARITY1_4 or
PARITY1_5 or PARITY1_6 or PARITY1_7 or PARITY2_0 or PARITY2_1 or 
PARITY2_2 or PARITY2_3 or PARITY2_4 or PARITY2_5 or PARITY2_6 or 
PARITY2_7 or PARITY3_0 or PARITY3_1 or PARITY3_2 or PARITY3_3 or 
PARITY3_4 or PARITY3_5 or PARITY3_6 or PARITY3_7 or NFBlockSize)			
begin
	case(EXT_BK_ADDR)	//synopsys parallel_case
		`PARITY0_0L_ADDR : EXT_SFR_DIN = PARITY0_0[7:0];
		`PARITY0_1L_ADDR : EXT_SFR_DIN = PARITY0_1[7:0];
		`PARITY0_2L_ADDR : EXT_SFR_DIN = PARITY0_2[7:0];
		`PARITY0_3L_ADDR : EXT_SFR_DIN = PARITY0_3[7:0];
		`PARITY0_03H_ADDR : EXT_SFR_DIN ={PARITY0_3[9:8],PARITY0_2[9:8],PARITY0_1[9:8],PARITY0_0[9:8]};
		`PARITY0_4L_ADDR : EXT_SFR_DIN = PARITY0_4[7:0];
		`PARITY0_5L_ADDR : EXT_SFR_DIN = PARITY0_5[7:0];
		`PARITY0_6L_ADDR : EXT_SFR_DIN = PARITY0_6[7:0];
		`PARITY0_7L_ADDR : EXT_SFR_DIN = PARITY0_7[7:0];
		`PARITY0_47H_ADDR : EXT_SFR_DIN = {PARITY0_7[9:8],PARITY0_6[9:8],PARITY0_5[9:8],PARITY0_4[9:8]};
             
		`PARITY1_0L_ADDR : EXT_SFR_DIN = PARITY1_0[7:0];
		`PARITY1_1L_ADDR : EXT_SFR_DIN = PARITY1_1[7:0];
		`PARITY1_2L_ADDR : EXT_SFR_DIN = PARITY1_2[7:0];
		`PARITY1_3L_ADDR : EXT_SFR_DIN = PARITY1_3[7:0];
		`PARITY1_03H_ADDR : EXT_SFR_DIN ={PARITY1_3[9:8],PARITY1_2[9:8],PARITY1_1[9:8],PARITY1_0[9:8]};
		`PARITY1_4L_ADDR : EXT_SFR_DIN = PARITY1_4[7:0];
		`PARITY1_5L_ADDR : EXT_SFR_DIN = PARITY1_5[7:0];
		`PARITY1_6L_ADDR : EXT_SFR_DIN = PARITY1_6[7:0];
		`PARITY1_7L_ADDR : EXT_SFR_DIN = PARITY1_7[7:0];
		`PARITY1_47H_ADDR : EXT_SFR_DIN = {PARITY1_7[9:8],PARITY1_6[9:8],PARITY1_5[9:8],PARITY1_4[9:8]};
              
		`PARITY2_0L_ADDR : EXT_SFR_DIN = PARITY2_0[7:0];
		`PARITY2_1L_ADDR : EXT_SFR_DIN = PARITY2_1[7:0];
		`PARITY2_2L_ADDR : EXT_SFR_DIN = PARITY2_2[7:0];
		`PARITY2_3L_ADDR : EXT_SFR_DIN = PARITY2_3[7:0];
		`PARITY2_03H_ADDR : EXT_SFR_DIN ={PARITY2_3[9:8],PARITY2_2[9:8],PARITY2_1[9:8],PARITY2_0[9:8]};
		`PARITY2_4L_ADDR : EXT_SFR_DIN = PARITY2_4[7:0];
		`PARITY2_5L_ADDR : EXT_SFR_DIN = PARITY2_5[7:0];
		`PARITY2_6L_ADDR : EXT_SFR_DIN = PARITY2_6[7:0];
		`PARITY2_7L_ADDR : EXT_SFR_DIN = PARITY2_7[7:0];
		`PARITY2_47H_ADDR : EXT_SFR_DIN = {PARITY2_7[9:8],PARITY2_6[9:8],PARITY2_5[9:8],PARITY2_4[9:8]};
              
		`PARITY3_0L_ADDR : EXT_SFR_DIN = PARITY3_0[7:0];
		`PARITY3_1L_ADDR : EXT_SFR_DIN = PARITY3_1[7:0];
		`PARITY3_2L_ADDR : EXT_SFR_DIN = PARITY3_2[7:0];
		`PARITY3_3L_ADDR : EXT_SFR_DIN = PARITY3_3[7:0];
		`PARITY3_03H_ADDR : EXT_SFR_DIN ={PARITY3_3[9:8],PARITY3_2[9:8],PARITY3_1[9:8],PARITY3_0[9:8]};
		`PARITY3_4L_ADDR : EXT_SFR_DIN = PARITY3_4[7:0];
		`PARITY3_5L_ADDR : EXT_SFR_DIN = PARITY3_5[7:0];
		`PARITY3_6L_ADDR : EXT_SFR_DIN = PARITY3_6[7:0];
		`PARITY3_7L_ADDR : EXT_SFR_DIN = PARITY3_7[7:0];
		`PARITY3_47H_ADDR : EXT_SFR_DIN = {PARITY3_7[9:8],PARITY3_6[9:8],PARITY3_5[9:8],PARITY3_4[9:8]};

		`RSEncoderCtrl_ADDR	: EXT_SFR_DIN = {7'b0000000, NFBlockSize};
		default		: EXT_SFR_DIN	= 8'h00;
		endcase
end

endmodule // RSEncRegif

