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
	EXT_SFR_WR,
                                    
	RSEn_Wait,
	RSDe_Wait,
	DecodeEndCnt,
	SyndProcess,

	NandREQ, // Nand DATA request
	TransferDone,
	TransferEnd,
	//BlkCnt		,
	BigBlk	,
	SmallBlk  ,
	SmallBlk2 ,
	SmallBlk3 ,
	
	Nand_WEn,
	Nand_REn,

	RAM_ADDR,

	RAM_WEn,
//	RAM_REn,
	
	BlockStart,
	RSParityCatch,
	RSEn_Start,
	RSDe_First_Start,
	RSDe_Start

);

input 	RESETn;
input	CLK;
input	[4:0]	CS;
output	[7:0]	EXT_SFR_DIN;
input 	[7:0]	EXT_SFR_DOUT;
input		EXT_SFR_WR;

//input	DecodeEnd;
input	[2:0]	DecodeEndCnt; // From Decoder Module
output	RSEn_Wait;
output	RSDe_Wait; // Previous Decoding Not Complete
output	SyndProcess;

input	NandREQ;
output	TransferDone;
output	TransferEnd;

//output	[2:0]	BlkCnt;

output	BigBlk;
output	SmallBlk;
output	SmallBlk2;
output	SmallBlk3;


output	Nand_WEn;
output	Nand_REn;

output	[10:0]	RAM_ADDR;

output 	RAM_WEn;
//output	RAM_REn;

output	BlockStart;
output	RSParityCatch;
output	RSEn_Start;
output	RSDe_First_Start;
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
//	.BlkCnt			(BlkCnt			),
	.BigBlk			(BigBlk			),
	.SmallBlk		(SmallBlk		),
	.SmallBlk2		(SmallBlk2		),
	.SmallBlk3		(SmallBlk3		),
                                  
	.Nand_WEn		(Nand_WEn		),
	.Nand_REn		(Nand_REn		),
                                    
	.RAM_ADDR		(RAM_ADDR		),
                                    
	.RAM_WEn		(RAM_WEn		),
//	.RAM_REn		(RAM_REn		),
                                    
	.BlockStart		(BlockStart		),
	.RSParityCatch	(RSParityCatch	),
	.RSEn_Start		(RSEn_Start		),
	.RSDe_First_Start(RSDe_First_Start),
	.RSDe_Start		(RSDe_Start		)

);


RSNAND_DMA_regif DMARegif
(	
	.CLK			(CLK			),
	.RESETn			(RESETn			),
    
	.CS				(CS				),                                
	.EXT_SFR_DIN	(EXT_SFR_DIN	), 
	.EXT_SFR_DOUT	(EXT_SFR_DOUT	), 
	.EXT_SFR_WR		(EXT_SFR_WR		),
                                    
	.Start			(Start			),
	.Size			(Size			),
	.Mode			(Mode			),
	.Bypass			(Bypass			),
	.TransferEnd	(TransferEnd	),
	.SplitSize		(SplitSize		),
	.StartAddr		(StartAddr		),
	.TransferDone	(TransferDone	)

);

endmodule
