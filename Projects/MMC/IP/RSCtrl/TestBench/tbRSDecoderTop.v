module tbRSDecoderTop;


reg		RESETn;
reg		CLK;
reg		FA;
reg		FO;
reg		NSFRWE			;
reg		NSFROE			;
wire [7:0]	RSDec_FI;
reg  [9:0]	NandReadData;
reg			RSDe_Start;
reg			RSDe_Wait;

initial 
begin
	RESETn = 0;
	CLK  = 0;

end

always #5 CLK = ~CLK;

initial
begin
	#100
	RESETn = 1;

	`force uRSDecoder.De
end





RSDecoderTop uRSDecoder(
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	.FA				(FA				),
	.FO				(FO				),
	.NSFRWE			(NSFRWE			),
	.NSFROE			(NSFROE			),
	.RSDec_FI		(RSDec_FI		),
	.NandReadData	(NandReadData	),
	.RSDe_Start		(RSDe_Start		),
	.RSDe_Wait		(RSDe_Wait		)
);



endmodule
