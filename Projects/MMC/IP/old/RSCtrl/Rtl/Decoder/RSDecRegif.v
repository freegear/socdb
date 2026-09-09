module RSDecRegif(
	RESETn,
	CLK,
	FA,
	FO,
	NSFRWE,
	NSFROE,
	RSDec_FI,
	SyndCalStart

);

input	RESETn;
input	CLK;

input	[7:0]	FA;
input	[7:0]	FO;
input			NSFRWE;
input			NSFROE;

output	[7:0]	RSDec_FI;
output			SyndCalStart;


`define RSDEC_ADDR	8'b00000000

wire	RSDEC_w;
wire	RSDEC_r;

assign	RSDEC_w 	= (FA==`RSDEC_ADDR) & (NSFRWE==0);
assign	RSDEC_r 	= (FA==`RSDEC_ADDR) & (NSFROE==0);

reg	[7:0]	RSDEC;
reg	[7:0]	RSDec_FI;
reg	[7:0]	NextRSDec_FI;


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	RSDEC <= 0;
	else if (RSDEC_w)
	RSDEC <= FO;
end

always @(RSDec_FI or RSDEC)
begin
	NextRSDec_FI=RSDec_FI;
	case(1'b1)
	RSDEC_r 	:NextRSDec_FI= RSDEC;
	endcase
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	RSDec_FI <= 0;
	else
	RSDec_FI <= NextRSDec_FI;
end 
endmodule
