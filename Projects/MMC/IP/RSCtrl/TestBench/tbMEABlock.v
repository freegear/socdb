module tbMEABlock;

reg RESETn;
reg CLK;
reg MEAStart;


reg [9:0] SYND0;
reg [9:0] SYND1;
reg [9:0] SYND2;
reg [9:0] SYND3;
reg [9:0] SYND4;
reg [9:0] SYND5;
reg [9:0] SYND6;
reg [9:0] SYND7;
wire [9:0] EP0; 
wire [9:0] EP1; 	
wire [9:0] EP2; 
wire [9:0] EP3; 
wire [9:0] EP4;
wire [9:0] EV0;
wire [9:0] EV1;
wire [9:0] EV2;
wire [9:0] EV3;
wire [9:0] EV4;



initial
begin
	RESETn 	= 0;
	CLK	= 0;
	MEAStart   = 0;
	#120 RESETn = 1;

end

always 
begin
	#10 CLK = ~CLK;
end

initial
begin
	SYND0 =3;
        SYND1 =0;
        SYND2 =432;
        SYND3 =731;
        SYND4 =641;
        SYND5 =185;
        SYND6 =140;
        SYND7 =110;
	#120
	@(posedge CLK); 
	MEAStart = 1;
	@(posedge CLK); 
	MEAStart = 0;

	
end


MEABlock MEA	      ( 
			.RESETn	(RESETn), 
			.CLK	(CLK), 
			.MEAStart(MEAStart),
			.SYND0	(SYND0), 
			.SYND1	(SYND1), 
			.SYND2	(SYND2), 
			.SYND3	(SYND3),	
			.SYND4	(SYND4), 
			.SYND5	(SYND5), 
			.SYND6	(SYND6), 
			.SYND7	(SYND7), 
			.EP0	(EP0), 
			.EP1	(EP1), 	
			.EP2	(EP2), 
			.EP3	(EP3), 
			.EP4	(EP4),
		       	.EV0	(EV0),
		       	.EV1	(EV1),
		       	.EV2	(EV2),
		       	.EV3	(EV3),
			.EV4	(EV4)
			);

endmodule
