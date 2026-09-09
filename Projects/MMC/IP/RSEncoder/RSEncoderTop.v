// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : RSEncoderTop.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : RS Encoder Top
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module RSEncoderTop (
	RESETn,
	CLK,
	CS,	
	EXT_SFR_DIN, 
	EXT_SFR_DOUT, 
	EXT_SFR_ADDR, 
	EXT_SFR_WR,
	NandRAM_DATAo,
	RSEn_Start,
	RSEn_Wait,
	RSEn_End
);

input			RESETn;
input			CLK;

input			CS;
output	[7:0]	EXT_SFR_DIN;
input 	[7:0]	EXT_SFR_DOUT;
input 	[7:0]	EXT_SFR_ADDR;
input		EXT_SFR_WR;

`ifdef OPTIMIZE
input	[7:0]	NandRAM_DATAo;
`else
input	[9:0]	NandRAM_DATAo;
`endif
input			RSEn_Start;
input			RSEn_Wait;
output			RSEn_End;

wire	[9:0]	PARITY0_7;
wire	[9:0]	PARITY0_6;
wire	[9:0]	PARITY0_5;
wire	[9:0]	PARITY0_4;
wire	[9:0]	PARITY0_3;
wire	[9:0]	PARITY0_2;
wire	[9:0]	PARITY0_1;
wire	[9:0]	PARITY0_0;

wire	[9:0]	PARITY1_7;
wire	[9:0]	PARITY1_6;
wire	[9:0]	PARITY1_5;
wire	[9:0]	PARITY1_4;
wire	[9:0]	PARITY1_3;
wire	[9:0]	PARITY1_2;
wire	[9:0]	PARITY1_1;
wire	[9:0]	PARITY1_0;

wire	[9:0]	PARITY2_7;
wire	[9:0]	PARITY2_6;
wire	[9:0]	PARITY2_5;
wire	[9:0]	PARITY2_4;
wire	[9:0]	PARITY2_3;
wire	[9:0]	PARITY2_2;
wire	[9:0]	PARITY2_1;
wire	[9:0]	PARITY2_0;

wire	[9:0]	PARITY3_7;
wire	[9:0]	PARITY3_6;
wire	[9:0]	PARITY3_5;
wire	[9:0]	PARITY3_4;
wire	[9:0]	PARITY3_3;
wire	[9:0]	PARITY3_2;
wire	[9:0]	PARITY3_1;
wire	[9:0]	PARITY3_0;

RSEncRegif RSEncRegif
(
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	.CS				(CS				),
	.EXT_SFR_ADDR	(EXT_SFR_ADDR[5:0]),
	.EXT_SFR_DOUT	(EXT_SFR_DOUT	),
	.EXT_SFR_WR		(EXT_SFR_WR		),
	.EXT_SFR_DIN	(EXT_SFR_DIN	),
	//PARITYACCESS   /PARITYACCESS
	.RSEn_End		(RSEn_End		),
	.NFBlockSize	(NFBlockSize	),
                                    
	.PARITY0_7		(PARITY0_7		),
	.PARITY0_6		(PARITY0_6		),
	.PARITY0_5		(PARITY0_5		),
	.PARITY0_4		(PARITY0_4		),
	.PARITY0_3		(PARITY0_3		),
	.PARITY0_2		(PARITY0_2		),
	.PARITY0_1		(PARITY0_1		),
	.PARITY0_0		(PARITY0_0		),
                                    
	.PARITY1_7		(PARITY1_7		),
	.PARITY1_6		(PARITY1_6		),
	.PARITY1_5		(PARITY1_5		),
	.PARITY1_4		(PARITY1_4		),
	.PARITY1_3		(PARITY1_3		),
	.PARITY1_2		(PARITY1_2		),
	.PARITY1_1		(PARITY1_1		),
	.PARITY1_0		(PARITY1_0		),
                                    
	.PARITY2_7		(PARITY2_7		),
	.PARITY2_6		(PARITY2_6		),
	.PARITY2_5		(PARITY2_5		),
	.PARITY2_4		(PARITY2_4		),
	.PARITY2_3		(PARITY2_3		),
	.PARITY2_2		(PARITY2_2		),
	.PARITY2_1		(PARITY2_1		),
	.PARITY2_0		(PARITY2_0		),
                                    
	.PARITY3_7		(PARITY3_7		),
	.PARITY3_6		(PARITY3_6		),
	.PARITY3_5		(PARITY3_5		),
	.PARITY3_4		(PARITY3_4		),
	.PARITY3_3		(PARITY3_3		),
	.PARITY3_2		(PARITY3_2		),
	.PARITY3_1		(PARITY3_1		),
	.PARITY3_0		(PARITY3_0		)
);


RSEncoderCtrl RSEncoderCtrl
(	
	.RESETn			(RESETn		),
	.CLK			(CLK		),
	.DATA			(NandRAM_DATAo), // From Nand Selected RAM
	.RSEn_Start		(RSEn_Start	),
	.RSEn_Wait		(RSEn_Wait	),
	.RSEn_End		(RSEn_End	),
	.NFBlockSize	(NFBlockSize),

	.PARITY0_7		(PARITY0_7	),
	.PARITY0_6		(PARITY0_6	),
	.PARITY0_5		(PARITY0_5	),
	.PARITY0_4		(PARITY0_4	),
	.PARITY0_3		(PARITY0_3	),
	.PARITY0_2		(PARITY0_2	),
	.PARITY0_1		(PARITY0_1	),
	.PARITY0_0		(PARITY0_0	),
                                
	.PARITY1_7		(PARITY1_7	),
	.PARITY1_6		(PARITY1_6	),
	.PARITY1_5		(PARITY1_5	),
	.PARITY1_4		(PARITY1_4	),
	.PARITY1_3		(PARITY1_3	),
	.PARITY1_2		(PARITY1_2	),
	.PARITY1_1		(PARITY1_1	),
	.PARITY1_0		(PARITY1_0	),
                                
	.PARITY2_7		(PARITY2_7	),
	.PARITY2_6		(PARITY2_6	),
	.PARITY2_5		(PARITY2_5	),
	.PARITY2_4		(PARITY2_4	),
	.PARITY2_3		(PARITY2_3	),
	.PARITY2_2		(PARITY2_2	),
	.PARITY2_1		(PARITY2_1	),
	.PARITY2_0		(PARITY2_0	),
                                
	.PARITY3_7		(PARITY3_7	),
	.PARITY3_6		(PARITY3_6	),
	.PARITY3_5		(PARITY3_5	),
	.PARITY3_4		(PARITY3_4	),
	.PARITY3_3		(PARITY3_3	),
	.PARITY3_2		(PARITY3_2	),
	.PARITY3_1		(PARITY3_1	),
	.PARITY3_0		(PARITY3_0	)
);

endmodule
