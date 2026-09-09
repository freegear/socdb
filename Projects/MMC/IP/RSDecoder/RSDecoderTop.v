// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : RSDecoderTop.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : RS Decoder Top
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module RSDecoderTop(
		RESETn,
		CLK,
		CS,
		EXT_SFR_DIN, 
		EXT_SFR_DOUT, 
		EXT_SFR_ADDR, 
		EXT_SFR_WR,
		NandReadData,
		RSDe_Start,
		RSDe_Wait,
		SyndProcess,
		DecodeEndCnt,

		BigBlk,
		SmallBlk,
		SmallBlk2,
		SmallBlk3


);
input 			RESETn;
input			CLK;
input			CS;
output	[7:0]	EXT_SFR_DIN;
input 	[7:0]	EXT_SFR_DOUT;
input 	[7:0]	EXT_SFR_ADDR;
input			EXT_SFR_WR;

input	[7:0]	NandReadData;
input			RSDe_Start;
input			RSDe_Wait;
input			SyndProcess;
output	[2:0]	DecodeEndCnt;
	
input			BigBlk;
input			SmallBlk;
input			SmallBlk2;
input			SmallBlk3;

wire  [9:0]	parity0_0;
wire  [9:0]	parity0_1;
wire  [9:0]	parity0_2;
wire  [9:0]	parity0_3;
wire  [9:0]	parity0_4;
wire  [9:0]	parity0_5;
wire  [9:0]	parity0_6;
wire  [9:0]	parity0_7;

wire  [9:0]	parity1_0;
wire  [9:0]	parity1_1;
wire  [9:0]	parity1_2;
wire  [9:0]	parity1_3;
wire  [9:0]	parity1_4;
wire  [9:0]	parity1_5;
wire  [9:0]	parity1_6;
wire  [9:0]	parity1_7;

wire  [9:0]	parity2_0;
wire  [9:0]	parity2_1;
wire  [9:0]	parity2_2;
wire  [9:0]	parity2_3;
wire  [9:0]	parity2_4;
wire  [9:0]	parity2_5;
wire  [9:0]	parity2_6;
wire  [9:0]	parity2_7;

wire  [9:0]	parity3_0;
wire  [9:0]	parity3_1;
wire  [9:0]	parity3_2;
wire  [9:0]	parity3_3;
wire  [9:0]	parity3_4;
wire  [9:0]	parity3_5;
wire  [9:0]	parity3_6;
wire  [9:0]	parity3_7;

wire	[9:0]	CEPosition0_0;
wire	[9:0]	CEPosition0_1;
wire	[9:0]	CEPosition0_2;
wire	[9:0]	CEPosition0_3;
wire	[9:0]	CEValue0_0	 ;
wire	[9:0]	CEValue0_1	 ;
wire	[9:0]	CEValue0_2	 ;
wire	[9:0]	CEValue0_3	 ;
wire	[9:0]	CEPosition1_0;
wire	[9:0]	CEPosition1_1;
wire	[9:0]	CEPosition1_2;
wire	[9:0]	CEPosition1_3;
wire	[9:0]	CEValue1_0	 ;
wire	[9:0]	CEValue1_1	 ;
wire	[9:0]	CEValue1_2	 ;
wire	[9:0]	CEValue1_3	 ;
wire	[9:0]	CEPosition2_0;
wire	[9:0]	CEPosition2_1;
wire	[9:0]	CEPosition2_2;
wire	[9:0]	CEPosition2_3;
wire	[9:0]	CEValue2_0	 ;
wire	[9:0]	CEValue2_1	 ;
wire	[9:0]	CEValue2_2	 ;
wire	[9:0]	CEValue2_3	 ;
wire	[9:0]	CEPosition3_0;
wire	[9:0]	CEPosition3_1;
wire	[9:0]	CEPosition3_2;
wire	[9:0]	CEPosition3_3;
wire	[9:0]	CEValue3_0	 ;
wire	[9:0]	CEValue3_1	 ;
wire	[9:0]	CEValue3_2	 ;
wire	[9:0]	CEValue3_3	 ;

wire	[3:0]	EUncorrectable;

wire	[9:0]	EP0;
wire	[9:0]	EP1;
wire	[9:0]	EP2;
wire	[9:0]	EP3;
wire	[9:0]	EP4;
wire	[9:0]	EV0;
wire	[9:0]	EV1;
wire	[9:0]	EV2;
wire	[9:0]	EV3;
wire	[9:0]	EV4;

wire	[9:0]	SYND0;
wire	[9:0]	SYND1;
wire	[9:0]	SYND2;
wire	[9:0]	SYND3;
wire	[9:0]	SYND4;
wire	[9:0]	SYND5;
wire	[9:0]	SYND6;
wire	[9:0]	SYND7;



wire	[9:0]	CorrectErrorPosition0;
wire	[9:0]	CorrectErrorPosition1;
wire	[9:0]	CorrectErrorPosition2;
wire	[9:0]	CorrectErrorPosition3;
wire	[9:0]	CorrectErrorValue0	 ;
wire	[9:0]	CorrectErrorValue1	 ;
wire	[9:0]	CorrectErrorValue2	 ;
wire	[9:0]	CorrectErrorValue3	 ;

wire	[9:0]	data;
wire			ErrorCorrectEnd;

RSDecRegif RSDecRegif(
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	.CS				(CS				),
	.EXT_SFR_ADDR	(EXT_SFR_ADDR[6:0]),
	.EXT_SFR_DOUT	(EXT_SFR_DOUT	),
	.EXT_SFR_WR		(EXT_SFR_WR		),
                                    
	.parity0_0		(parity0_0		),	
	.parity0_1		(parity0_1		),	
	.parity0_2		(parity0_2		),	
	.parity0_3		(parity0_3		),	
	.parity0_4		(parity0_4		),	
	.parity0_5		(parity0_5		),	
	.parity0_6		(parity0_6		),	
	.parity0_7		(parity0_7		),	
                                    
	.parity1_0		(parity1_0		),	
	.parity1_1		(parity1_1		),	
	.parity1_2		(parity1_2		),	
	.parity1_3		(parity1_3		),	
	.parity1_4		(parity1_4		),	
	.parity1_5		(parity1_5		),	
	.parity1_6		(parity1_6		),	
	.parity1_7		(parity1_7		),	
                                    
	.parity2_0		(parity2_0		),	
	.parity2_1		(parity2_1		),	
	.parity2_2		(parity2_2		),	
	.parity2_3		(parity2_3		),	
	.parity2_4		(parity2_4		),	
	.parity2_5		(parity2_5		),	
	.parity2_6		(parity2_6		),	
	.parity2_7		(parity2_7		),	
                                    
	.parity3_0		(parity3_0		),	
	.parity3_1		(parity3_1		),	
	.parity3_2		(parity3_2		),	
	.parity3_3		(parity3_3		),	
	.parity3_4		(parity3_4		),	
	.parity3_5		(parity3_5		),	
	.parity3_6		(parity3_6		),	
	.parity3_7		(parity3_7		),	
                                    
	.CEPosition0_0	(CEPosition0_0	),
	.CEPosition0_1	(CEPosition0_1	),
	.CEPosition0_2	(CEPosition0_2	),
	.CEPosition0_3	(CEPosition0_3	),
	.CEValue0_0	 	(CEValue0_0	 	),
	.CEValue0_1	 	(CEValue0_1	 	),
	.CEValue0_2	 	(CEValue0_2	 	),
	.CEValue0_3	 	(CEValue0_3	 	),
	.CEPosition1_0	(CEPosition1_0	),
	.CEPosition1_1	(CEPosition1_1	),
	.CEPosition1_2	(CEPosition1_2	),
	.CEPosition1_3	(CEPosition1_3	),
	.CEValue1_0	 	(CEValue1_0	 	),
	.CEValue1_1	 	(CEValue1_1	 	),
	.CEValue1_2	 	(CEValue1_2	 	),
	.CEValue1_3	 	(CEValue1_3	 	),
	.CEPosition2_0	(CEPosition2_0	),
	.CEPosition2_1	(CEPosition2_1	),
	.CEPosition2_2	(CEPosition2_2	),
	.CEPosition2_3	(CEPosition2_3	),
	.CEValue2_0	 	(CEValue2_0	 	),
	.CEValue2_1	 	(CEValue2_1	 	),
	.CEValue2_2	 	(CEValue2_2	 	),
	.CEValue2_3	 	(CEValue2_3	 	),
	.CEPosition3_0	(CEPosition3_0	),
	.CEPosition3_1	(CEPosition3_1	),
	.CEPosition3_2	(CEPosition3_2	),
	.CEPosition3_3	(CEPosition3_3	),
	.CEValue3_0	 	(CEValue3_0	 	),
	.CEValue3_1	 	(CEValue3_1	 	),
	.CEValue3_2	 	(CEValue3_2	 	),
	.CEValue3_3	 	(CEValue3_3	 	),
	                                
	.ECorrectEnd	(ECorrectEnd	),
	.EUncorrectable	(EUncorrectable	),	
                                    
	.EXT_SFR_DIN	(EXT_SFR_DIN	)
);

DecoderCtrl DecoderCtrl (
	.CLK					(CLK	),
	.RESETn					(RESETn	),
	.RSDe_Start				(RSDe_Start),
	.RSDe_Wait				(RSDe_Wait),
	.SyndProcess			(SyndProcess),
	.DecodeEndCnt			(DecodeEndCnt),
	.BigBlk					(BigBlk	  ),
	.SmallBlk				(SmallBlk ),
	.SmallBlk2				(SmallBlk2),
	.SmallBlk3				(SmallBlk3),



	.CorrectErrorPosition0	(CorrectErrorPosition0	),
	.CorrectErrorPosition1	(CorrectErrorPosition1	),
	.CorrectErrorPosition2	(CorrectErrorPosition2	),
	.CorrectErrorPosition3	(CorrectErrorPosition3	),
	.CorrectErrorValue0	 	(CorrectErrorValue0	 	),
	.CorrectErrorValue1	 	(CorrectErrorValue1	 	),
	.CorrectErrorValue2	 	(CorrectErrorValue2	 	),
	.CorrectErrorValue3	 	(CorrectErrorValue3	 	),
	.ErrorCorrectEnd		(ErrorCorrectEnd		),
	.ErrorUncorrectable	 	(ErrorUncorrectable	 	),
                                                    
	.CEPosition0_0			(CEPosition0_0			),
	.CEPosition0_1			(CEPosition0_1			),
	.CEPosition0_2			(CEPosition0_2			),
	.CEPosition0_3			(CEPosition0_3			),
	.CEValue0_0	 			(CEValue0_0	 			),
	.CEValue0_1	 			(CEValue0_1	 			),
	.CEValue0_2	 			(CEValue0_2	 			),
	.CEValue0_3	 			(CEValue0_3	 			),
	.CEPosition1_0			(CEPosition1_0			),
	.CEPosition1_1			(CEPosition1_1			),
	.CEPosition1_2			(CEPosition1_2			),
	.CEPosition1_3			(CEPosition1_3			),
	.CEValue1_0	 			(CEValue1_0	 			),
	.CEValue1_1	 			(CEValue1_1	 			),
	.CEValue1_2	 			(CEValue1_2	 			),
	.CEValue1_3	 			(CEValue1_3	 			),
	.CEPosition2_0			(CEPosition2_0			),
	.CEPosition2_1			(CEPosition2_1			),
	.CEPosition2_2			(CEPosition2_2			),
	.CEPosition2_3			(CEPosition2_3			),
	.CEValue2_0	 			(CEValue2_0	 			),
	.CEValue2_1	 			(CEValue2_1	 			),
	.CEValue2_2	 			(CEValue2_2	 			),
	.CEValue2_3	 			(CEValue2_3	 			),
	.CEPosition3_0			(CEPosition3_0			),
	.CEPosition3_1			(CEPosition3_1			),
	.CEPosition3_2			(CEPosition3_2			),
	.CEPosition3_3			(CEPosition3_3			),
	.CEValue3_0	 			(CEValue3_0	 			),
	.CEValue3_1	 			(CEValue3_1	 			),
	.CEValue3_2	 			(CEValue3_2	 			),
	.CEValue3_3	 			(CEValue3_3	 			),

	.parity0_0				(parity0_0),	
	.parity0_1				(parity0_1),	
	.parity0_2				(parity0_2),	
	.parity0_3				(parity0_3),	
	.parity0_4				(parity0_4),	
	.parity0_5				(parity0_5),	
	.parity0_6				(parity0_6),	
	.parity0_7				(parity0_7),	
                                      
	.parity1_0				(parity1_0),	
	.parity1_1				(parity1_1),	
	.parity1_2				(parity1_2),	
	.parity1_3				(parity1_3),	
	.parity1_4				(parity1_4),	
	.parity1_5				(parity1_5),	
	.parity1_6				(parity1_6),	
	.parity1_7				(parity1_7),	
                                      
	.parity2_0				(parity2_0),	
	.parity2_1				(parity2_1),	
	.parity2_2				(parity2_2),	
	.parity2_3				(parity2_3),	
	.parity2_4				(parity2_4),	
	.parity2_5				(parity2_5),	
	.parity2_6				(parity2_6),	
	.parity2_7				(parity2_7),	
                                      
	.parity3_0				(parity3_0),	
	.parity3_1				(parity3_1),	
	.parity3_2				(parity3_2),	
	.parity3_3				(parity3_3),	
	.parity3_4				(parity3_4),	
	.parity3_5				(parity3_5),	
	.parity3_6				(parity3_6),	
	.parity3_7				(parity3_7),	
	
	.NandReadData			(NandReadData),
	.data					(data),
	
	.MEAStart				(MEAStart),
	                                                
	.SyndCalStart			(SyndCalStart),
	.SyndIsNotZero			(SyndIsNotZero),
	.EUncorrectable			(EUncorrectable	)
);


SYNDCal syndrom_calculate	
		(
		.RESETn			(RESETn			),
		.CLK			(CLK			),
		.SyndCalStart	(SyndCalStart	),
		.NandReadWait	(RSDe_Wait		),
		.data			(data),
		.SYND0			(SYND0			),
		.SYND1			(SYND1			),
		.SYND2			(SYND2			),
		.SYND3			(SYND3			),
		.SYND4			(SYND4			),
		.SYND5			(SYND5			),
		.SYND6			(SYND6			),
		.SYND7			(SYND7			),
		//.SyndCal_Ing	(SyndCal_Ing	),
		.SyndIsNotZero	(SyndIsNotZero	)
		);


MEABlock EuclidBlock
		(
		.RESETn			(RESETn			), 
		.CLK			(CLK			), 
		.MEAStart		(MEAStart		), 
		.SYND0			(SYND0			), 
		.SYND1			(SYND1			), 
		.SYND2			(SYND2			), 
		.SYND3			(SYND3			),
		.SYND4			(SYND4			), 
		.SYND5			(SYND5			), 
		.SYND6			(SYND6			), 
		.SYND7			(SYND7			),
		.EP0			(EP0			), 
		.EP1			(EP1			), 
		.EP2			(EP2			),	 
		.EP3			(EP3			), 
		.EP4			(EP4			), 
		.EV0			(EV0			),
		.EV1			(EV1			), 
		.EV2			(EV2			), 
		.EV3			(EV3			), 
		.EV4			(EV4			),
		//.MEA_Ing		(MEA_Ing		),
		.CSearchStart	(CSearchStart	)
);


CSearch CSearch(	
		.CLK			(CLK		), 
		.RESETn			(RESETn		), 
		.SearchStart	(CSearchStart),
		.ErrPosit4		(EP4		), 
		.ErrPosit3		(EP3		), 
		.ErrPosit2		(EP2		), 
		.ErrPosit1		(EP1		), 
		.ErrPosit0		(EP0		), 
		.ErrVal4		(EV4		), 
		.ErrVal3		(EV3		), 
		.ErrVal2		(EV2		), 
		.ErrVal1		(EV1		), 
		.ErrVal0		(EV0		),
		.CorrectErrorPosition0	(CorrectErrorPosition0	),
		.CorrectErrorPosition1	(CorrectErrorPosition1	),
		.CorrectErrorPosition2	(CorrectErrorPosition2	),
		.CorrectErrorPosition3	(CorrectErrorPosition3	),
		.CorrectErrorValue0		(CorrectErrorValue0		),
		.CorrectErrorValue1		(CorrectErrorValue1		),
		.CorrectErrorValue2		(CorrectErrorValue2		),
		.CorrectErrorValue3		(CorrectErrorValue3		),
		.ErrorCorrectEnd		(ErrorCorrectEnd		),
		.ErrorUncorrectable		(ErrorUncorrectable		)
);


endmodule
