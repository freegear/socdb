module RSEncRegif(
	RESETn,
	CLK,
	FA,
	FO,
	NSFRWE,
	NSFROE,
	RSEnc_FI);

input	RESETn;
input	CLK;
input	[7:0]	FA;
input	[7:0]	FO;
input			NSFRWE;
input			NSFROE;
output	[7:0]	RSEnc_FI;


endmodule
