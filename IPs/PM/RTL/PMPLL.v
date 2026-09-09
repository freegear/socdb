module PMPLL (
   				ExtClk,
   				ExtResetb,
   				TestMode,

				tPMSlow,
				MPllPD,
				MPllFR,
				MPllODR,
				MPllRR,
				
				MPllClk
);

input         	ExtClk;			//External Clock
input			ExtResetb;		//External Reset#
input         	TestMode;

input			tPMSlow;
input 			MPllPD;
input  [7:0] 	MPllFR;
input  [4:0] 	MPllRR;
input  [1:0] 	MPllODR;

output			MPllClk;
//------------------------------------------------------------------
// USB PLL
PG13E3G MPll(
			.BP			(tPMSlow),
		 	.OEB		(MPllPD),	// PLL Output Enable #
		 	.PD			(MPllPD),	// PowerDown
		 	.FIN		(ExtClk),
			.FOUT		(MPllClk),
			.AVDD		(),
			.AVSS		(),
			.DVDD		(),
			.DVSS		(),
		 	.F0			(MPllFR[0]),
		 	.F1			(MPllFR[1]),
		 	.F2			(MPllFR[2]),
		 	.F3			(MPllFR[3]),
		 	.F4			(MPllFR[4]),
		 	.F5			(MPllFR[5]),
		 	.F6			(MPllFR[6]),
		 	.F7			(MPllFR[7]),
		 	.OD0		(MPllODR[0]),
		 	.OD1		(MPllODR[1]),
		 	.R0			(MPllRR[0]),
		 	.R1			(MPllRR[1]),
		 	.R2			(MPllRR[2]),
		 	.R3			(MPllRR[3]),
		 	.R4			(MPllRR[4])
);

endmodule
