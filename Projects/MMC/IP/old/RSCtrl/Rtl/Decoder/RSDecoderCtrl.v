module RSDecoderCtrl(
			RESETn,
			CLK,
			FA,
			FO,
			NSFRWE,
			NSFROE,		
			RSDec_FI,
			NandReadData,
			NandReadWait
			
);
input 			RESETn;
input			CLK;
input	[7:0]	FA;
input	[7:0]	FO;
input			NSFRWE;
input			NSFROE;
output	[7:0]	RSDec_FI;
input	[7:0]	NandReadData;
input		NandReadWait;


RSDecRegif RSregif(
	.RESETn		(RESETn		),
	.CLK		(CLK		),
	.FA			(FA			),
	.FO			(FO			),
	.NSFRWE		(NSFRWE		),
	.NSFROE		(NSFROE		),
	.SyndCalStart (SyndCalStart),
	
	.RSDec_FI	(RSDec_FI	)
);





SYNDCal syndrom_calculate	
		(
		.RESETn			(RESETn			),
		.CLK			(CLK			),
		.SyndCalStart	(SyndCalStart	),
		.NandReadWait	(NandReadWait	),
		.data			({2'b00,NandReadData}),
		.SYND0			(SYND0			),
		.SYND1			(SYND1			),
		.SYND2			(SYND2			),
		.SYND3			(SYND3			),
		.SYND4			(SYND4			),
		.SYND5			(SYND5			),
		.SYND6			(SYND6			),
		.SYND7			(SYND7			)
		);

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
		.EV4			(EV4			)
		);


CSearch CSearch(	
		.CLK			(CLK		), 
		.RESETn			(RESETn		), 
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
		.ErrDet			(ErrDet		)
		);

endmodule
