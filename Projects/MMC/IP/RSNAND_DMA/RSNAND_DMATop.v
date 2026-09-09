// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : RSNAND_DMATop.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : RS & NAND DMA Controller Top
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module RSNAND_DMATop
(	RESETn,
	CLK,
	CS,
	EXT_SFR_DIN, 
	EXT_SFR_DOUT, 
	EXT_SFR_ADDR, 
	EXT_SFR_WR,
                                    
	RSEn_Wait,
	RSDe_Wait,
	DecodeEndCnt,
	SyndProcess,

	NandREQ, // Nand DATA request
	TransferEnd,
	BigBlk	,
	SmallBlk  ,
	SmallBlk2 ,
	SmallBlk3 ,

	Nand_WEn,
	Nand_REn,

	RAM_ADDR,

	RAM_WEn,
	RAM_REn,
	
	RSEn_Start,
	RSDe_Start

);

input 	RESETn;
input	CLK;
input	CS;
output	[7:0]	EXT_SFR_DIN;
input 	[7:0]	EXT_SFR_DOUT;
input 	[7:0]	EXT_SFR_ADDR;
input		EXT_SFR_WR;

//input	DecodeEnd;
input	[2:0]	DecodeEndCnt; // From Decoder Module
output	RSEn_Wait;
output	RSDe_Wait; // Previous Decoding Not Complete
output	SyndProcess;

input	NandREQ;
output	TransferEnd;
output	BigBlk;
output	SmallBlk;
output	SmallBlk2;
output	SmallBlk3;


output	Nand_WEn;
output	Nand_REn;

output	[10:0]	RAM_ADDR;

output 	RAM_WEn;
output	RAM_REn;

output	RSEn_Start;
output	RSDe_Start;

wire	[3:0]	SplitSize;
wire	[10:0]	StartAddr;
wire			Start;		
wire	[10:0]	Size;	
wire			Mode;	
wire			Bypass;

RSNAND_DMA NANDDMA
(	
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	                                
	.Start			(Start			),
	.Size			(Size			),
	.Mode			(Mode			),
	.Bypass			(Bypass			),
	.RSDe_Wait		(RSDe_Wait		),
	.RSEn_Wait		(RSEn_Wait		),
	.DecodeEndCnt	(DecodeEndCnt	),
	.SyndProcess	(SyndProcess	),
	                                
	.NandREQ		(NandREQ		), // Nand DATA request
	.SplitSize		(SplitSize		), // Nand 1 time request DATA Transfer Size
	.StartAddr		(StartAddr		),
	.TransferEnd	(TransferEnd	),
	.BigBlk			(BigBlk			),
	.SmallBlk		(SmallBlk		),
	.SmallBlk2		(SmallBlk2		),
	.SmallBlk3		(SmallBlk3		),
                                    
	.Nand_WEn		(Nand_WEn		),
	.Nand_REn		(Nand_REn		),
                                    
	.RAM_ADDR		(RAM_ADDR		),
                                    
	.RAM_WEn		(RAM_WEn		),
	.RAM_REn		(RAM_REn		),
                                    
	.RSEn_Start		(RSEn_Start		),
	.RSDe_Start		(RSDe_Start		)

);


RSNAND_DMA_regif DMARegif
(	
	.CLK			(CLK			),
	.RESETn			(RESETn			),
    
	.CS				(CS				),                                
	.EXT_SFR_DIN	(EXT_SFR_DIN	), 
	.EXT_SFR_DOUT	(EXT_SFR_DOUT	), 
	.EXT_SFR_ADDR	(EXT_SFR_ADDR[2:0]), 
	.EXT_SFR_WR		(EXT_SFR_WR		),
                                    
	.Start			(Start			),
	.Size			(Size			),
	.Mode			(Mode			),
	.Bypass			(Bypass			),
	.SplitSize		(SplitSize		),
	.StartAddr		(StartAddr		)

);

endmodule
