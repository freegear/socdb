module RSDecRegif(
	RESETn,
	CLK,
	FA,
	FO,
	NSFRWE,
	NSFROE,

	parity0_0,	
	parity0_1,	
	parity0_2,	
	parity0_3,	
	parity0_4,	
	parity0_5,	
	parity0_6,	
	parity0_7,	

	parity1_0,	
	parity1_1,	
	parity1_2,	
	parity1_3,	
	parity1_4,	
	parity1_5,	
	parity1_6,	
	parity1_7,	

	parity2_0,	
	parity2_1,	
	parity2_2,	
	parity2_3,	
	parity2_4,	
	parity2_5,	
	parity2_6,	
	parity2_7,	

	parity3_0,	
	parity3_1,	
	parity3_2,	
	parity3_3,	
	parity3_4,	
	parity3_5,	
	parity3_6,	
	parity3_7,	

	SyndCal_Ing,
	MEA_Ing,

	CEPosition0_0,
	CEPosition0_1,
	CEPosition0_2,
	CEPosition0_3,
	CEValue0_0	 ,
	CEValue0_1	 ,
	CEValue0_2	 ,
	CEValue0_3	 ,
	CEPosition1_0,
	CEPosition1_1,
	CEPosition1_2,
	CEPosition1_3,
	CEValue1_0	 ,
	CEValue1_1	 ,
	CEValue1_2	 ,
	CEValue1_3	 ,
	CEPosition2_0,
	CEPosition2_1,
	CEPosition2_2,
	CEPosition2_3,
	CEValue2_0	 ,
	CEValue2_1	 ,
	CEValue2_2	 ,
	CEValue2_3	 ,
	CEPosition3_0,
	CEPosition3_1,
	CEPosition3_2,
	CEPosition3_3,
	CEValue3_0	 ,
	CEValue3_1	 ,
	CEValue3_2	 ,
	CEValue3_3	 ,

	ECorrectEnd	 ,
	EUncorrectable	,	

	RSDec_FI
);

input			RESETn;
input			CLK;

input	[7:0]	FA;
input	[7:0]	FO;
input			NSFRWE;
input			NSFROE;

output	[9:0]	parity0_0;	
output	[9:0]	parity0_1;	
output	[9:0]	parity0_2;	
output	[9:0]	parity0_3;	
output	[9:0]	parity0_4;	
output	[9:0]	parity0_5;	
output	[9:0]	parity0_6;	
output	[9:0]	parity0_7;	

output	[9:0]	parity1_0;	
output	[9:0]	parity1_1;	
output	[9:0]	parity1_2;	
output	[9:0]	parity1_3;	
output	[9:0]	parity1_4;	
output	[9:0]	parity1_5;	
output	[9:0]	parity1_6;	
output	[9:0]	parity1_7;	

output	[9:0]	parity2_0;	
output	[9:0]	parity2_1;	
output	[9:0]	parity2_2;	
output	[9:0]	parity2_3;	
output	[9:0]	parity2_4;	
output	[9:0]	parity2_5;	
output	[9:0]	parity2_6;	
output	[9:0]	parity2_7;	

output	[9:0]	parity3_0;	
output	[9:0]	parity3_1;	
output	[9:0]	parity3_2;	
output	[9:0]	parity3_3;	
output	[9:0]	parity3_4;	
output	[9:0]	parity3_5;	
output	[9:0]	parity3_6;	
output	[9:0]	parity3_7;	

input			SyndCal_Ing;
input			MEA_Ing;

input [9:0]	CEPosition0_0;
input [9:0]	CEPosition0_1;
input [9:0]	CEPosition0_2;
input [9:0]	CEPosition0_3;
input [9:0]	CEValue0_0   ;
input [9:0]	CEValue0_1   ;
input [9:0]	CEValue0_2   ;
input [9:0]	CEValue0_3   ;
input [9:0]	CEPosition1_0;
input [9:0]	CEPosition1_1;
input [9:0]	CEPosition1_2;
input [9:0]	CEPosition1_3;
input [9:0]	CEValue1_0   ;
input [9:0]	CEValue1_1   ;
input [9:0]	CEValue1_2   ;
input [9:0]	CEValue1_3   ;
input [9:0]	CEPosition2_0;
input [9:0]	CEPosition2_1;
input [9:0]	CEPosition2_2;
input [9:0]	CEPosition2_3;
input [9:0]	CEValue2_0   ;
input [9:0]	CEValue2_1   ;
input [9:0]	CEValue2_2   ;
input [9:0]	CEValue2_3   ;
input [9:0]	CEPosition3_0;
input [9:0]	CEPosition3_1;
input [9:0]	CEPosition3_2;
input [9:0]	CEPosition3_3;
input [9:0]	CEValue3_0;
input [9:0]	CEValue3_1;
input [9:0]	CEValue3_2;
input [9:0]	CEValue3_3;
input			ECorrectEnd;

input [3:0]	EUncorrectable;

output	[7:0]	RSDec_FI;

`define RSDEC_ADDR					8'b00000000
`define RSDEC_PARITY0_0L_ADDR		8'b00000000
`define RSDEC_PARITY0_0H_ADDR		8'b00000001
`define RSDEC_PARITY0_1L_ADDR		8'b00000010
`define RSDEC_PARITY0_1H_ADDR		8'b00000011
`define RSDEC_PARITY0_2L_ADDR		8'b00000100
`define RSDEC_PARITY0_2H_ADDR		8'b00000101
`define RSDEC_PARITY0_3L_ADDR		8'b00000110
`define RSDEC_PARITY0_3H_ADDR		8'b00000111
`define RSDEC_PARITY0_4L_ADDR		8'b00001000
`define RSDEC_PARITY0_4H_ADDR		8'b00001001
`define RSDEC_PARITY0_5L_ADDR		8'b00001010
`define RSDEC_PARITY0_5H_ADDR		8'b00001011
`define RSDEC_PARITY0_6L_ADDR		8'b00001100
`define RSDEC_PARITY0_6H_ADDR		8'b00001101
`define RSDEC_PARITY0_7L_ADDR		8'b00001110
`define RSDEC_PARITY0_7H_ADDR		8'b00001111

`define RSDEC_PARITY1_0L_ADDR		8'b00010000
`define RSDEC_PARITY1_0H_ADDR		8'b00010001
`define RSDEC_PARITY1_1L_ADDR		8'b00010010
`define RSDEC_PARITY1_1H_ADDR		8'b00010011
`define RSDEC_PARITY1_2L_ADDR		8'b00010100
`define RSDEC_PARITY1_2H_ADDR		8'b00010101
`define RSDEC_PARITY1_3L_ADDR		8'b00010110
`define RSDEC_PARITY1_3H_ADDR		8'b00010111
`define RSDEC_PARITY1_4L_ADDR		8'b00011000
`define RSDEC_PARITY1_4H_ADDR		8'b00011001
`define RSDEC_PARITY1_5L_ADDR		8'b00011010
`define RSDEC_PARITY1_5H_ADDR		8'b00011011
`define RSDEC_PARITY1_6L_ADDR		8'b00011100
`define RSDEC_PARITY1_6H_ADDR		8'b00011101
`define RSDEC_PARITY1_7L_ADDR		8'b00011110
`define RSDEC_PARITY1_7H_ADDR		8'b00011111

`define RSDEC_PARITY2_0L_ADDR		8'b00100000
`define RSDEC_PARITY2_0H_ADDR		8'b00100001
`define RSDEC_PARITY2_1L_ADDR		8'b00100010
`define RSDEC_PARITY2_1H_ADDR		8'b00100011
`define RSDEC_PARITY2_2L_ADDR		8'b00100100
`define RSDEC_PARITY2_2H_ADDR		8'b00100101
`define RSDEC_PARITY2_3L_ADDR		8'b00100110
`define RSDEC_PARITY2_3H_ADDR		8'b00100111
`define RSDEC_PARITY2_4L_ADDR		8'b00101000
`define RSDEC_PARITY2_4H_ADDR		8'b00101001
`define RSDEC_PARITY2_5L_ADDR		8'b00101010
`define RSDEC_PARITY2_5H_ADDR		8'b00101011
`define RSDEC_PARITY2_6L_ADDR		8'b00101100
`define RSDEC_PARITY2_6H_ADDR		8'b00101101
`define RSDEC_PARITY2_7L_ADDR		8'b00101110
`define RSDEC_PARITY2_7H_ADDR		8'b00101111

`define RSDEC_PARITY3_0L_ADDR		8'b00110000
`define RSDEC_PARITY3_0H_ADDR		8'b00110001
`define RSDEC_PARITY3_1L_ADDR		8'b00110010
`define RSDEC_PARITY3_1H_ADDR		8'b00110011
`define RSDEC_PARITY3_2L_ADDR		8'b00110100
`define RSDEC_PARITY3_2H_ADDR		8'b00110101
`define RSDEC_PARITY3_3L_ADDR		8'b00110110
`define RSDEC_PARITY3_3H_ADDR		8'b00110111
`define RSDEC_PARITY3_4L_ADDR		8'b00111000
`define RSDEC_PARITY3_4H_ADDR		8'b00111001
`define RSDEC_PARITY3_5L_ADDR		8'b00111010
`define RSDEC_PARITY3_5H_ADDR		8'b00111011
`define RSDEC_PARITY3_6L_ADDR		8'b00111100
`define RSDEC_PARITY3_6H_ADDR		8'b00111101
`define RSDEC_PARITY3_7L_ADDR		8'b00111110
`define RSDEC_PARITY3_7H_ADDR		8'b00111111

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

always @(FA or parity0_0 or parity0_1 or parity0_2 or
parity0_3 or parity0_4 or parity0_5 or parity0_6 or parity0_7 or 
parity1_0 or parity1_1 or parity1_2 or parity1_3 or parity1_4 or
parity1_5 or parity1_6 or parity1_7 or parity2_0 or parity2_1 or 
parity2_2 or parity2_3 or parity2_4 or parity2_5 or parity2_6 or 
parity2_7 or parity3_0 or parity3_1 or parity3_2 or parity3_3 or 
parity3_4 or parity3_5 or parity3_6 or parity3_7)			
begin
	case(FA)	//synopsys parallel_case
		`RSDEC_PARITY0_0L_ADDR : RSDec_FI = parity0_0[7:0];
		`RSDEC_PARITY0_0H_ADDR : RSDec_FI = {6'b000000, parity0_0[9:8]};
		`RSDEC_PARITY0_1L_ADDR : RSDec_FI = parity0_1[7:0];
		`RSDEC_PARITY0_1H_ADDR : RSDec_FI = {6'b000000, parity0_1[9:8]};
		`RSDEC_PARITY0_2L_ADDR : RSDec_FI = parity0_2[7:0];
		`RSDEC_PARITY0_2H_ADDR : RSDec_FI = {6'b000000, parity0_2[9:8]};
		`RSDEC_PARITY0_3L_ADDR : RSDec_FI = parity0_3[7:0];
		`RSDEC_PARITY0_3H_ADDR : RSDec_FI = {6'b000000, parity0_3[9:8]};
		`RSDEC_PARITY0_4L_ADDR : RSDec_FI = parity0_4[7:0];
		`RSDEC_PARITY0_4H_ADDR : RSDec_FI = {6'b000000, parity0_4[9:8]};
		`RSDEC_PARITY0_5L_ADDR : RSDec_FI = parity0_5[7:0];
		`RSDEC_PARITY0_5H_ADDR : RSDec_FI = {6'b000000, parity0_5[9:8]};
		`RSDEC_PARITY0_6L_ADDR : RSDec_FI = parity0_6[7:0];
		`RSDEC_PARITY0_6H_ADDR : RSDec_FI = {6'b000000, parity0_6[9:8]};
		`RSDEC_PARITY0_7L_ADDR : RSDec_FI = parity0_7[7:0];
		`RSDEC_PARITY0_7H_ADDR : RSDec_FI = {6'b000000, parity0_7[9:8]};

		`RSDEC_PARITY1_0L_ADDR : RSDec_FI = parity1_0[7:0];
		`RSDEC_PARITY1_0H_ADDR : RSDec_FI = {6'b000000, parity1_0[9:8]};
		`RSDEC_PARITY1_1L_ADDR : RSDec_FI = parity1_1[7:0];
		`RSDEC_PARITY1_1H_ADDR : RSDec_FI = {6'b000000, parity1_1[9:8]};
		`RSDEC_PARITY1_2L_ADDR : RSDec_FI = parity1_2[7:0];
		`RSDEC_PARITY1_2H_ADDR : RSDec_FI = {6'b000000, parity1_2[9:8]};
		`RSDEC_PARITY1_3L_ADDR : RSDec_FI = parity1_3[7:0];
		`RSDEC_PARITY1_3H_ADDR : RSDec_FI = {6'b000000, parity1_3[9:8]};
		`RSDEC_PARITY1_4L_ADDR : RSDec_FI = parity1_4[7:0];
		`RSDEC_PARITY1_4H_ADDR : RSDec_FI = {6'b000000, parity1_4[9:8]};
		`RSDEC_PARITY1_5L_ADDR : RSDec_FI = parity1_5[7:0];
		`RSDEC_PARITY1_5H_ADDR : RSDec_FI = {6'b000000, parity1_5[9:8]};
		`RSDEC_PARITY1_6L_ADDR : RSDec_FI = parity1_6[7:0];
		`RSDEC_PARITY1_6H_ADDR : RSDec_FI = {6'b000000, parity1_6[9:8]};
		`RSDEC_PARITY1_7L_ADDR : RSDec_FI = parity1_7[7:0];
		`RSDEC_PARITY1_7H_ADDR : RSDec_FI = {6'b000000, parity1_7[9:8]};

		`RSDEC_PARITY2_0L_ADDR : RSDec_FI = parity2_0[7:0];
		`RSDEC_PARITY2_0H_ADDR : RSDec_FI = {6'b000000, parity2_0[9:8]};
		`RSDEC_PARITY2_1L_ADDR : RSDec_FI = parity2_1[7:0];
		`RSDEC_PARITY2_1H_ADDR : RSDec_FI = {6'b000000, parity2_1[9:8]};
		`RSDEC_PARITY2_2L_ADDR : RSDec_FI = parity2_2[7:0];
		`RSDEC_PARITY2_2H_ADDR : RSDec_FI = {6'b000000, parity2_2[9:8]};
		`RSDEC_PARITY2_3L_ADDR : RSDec_FI = parity2_3[7:0];
		`RSDEC_PARITY2_3H_ADDR : RSDec_FI = {6'b000000, parity2_3[9:8]};
		`RSDEC_PARITY2_4L_ADDR : RSDec_FI = parity2_4[7:0];
		`RSDEC_PARITY2_4H_ADDR : RSDec_FI = {6'b000000, parity2_4[9:8]};
		`RSDEC_PARITY2_5L_ADDR : RSDec_FI = parity2_5[7:0];
		`RSDEC_PARITY2_5H_ADDR : RSDec_FI = {6'b000000, parity2_5[9:8]};
		`RSDEC_PARITY2_6L_ADDR : RSDec_FI = parity2_6[7:0];
		`RSDEC_PARITY2_6H_ADDR : RSDec_FI = {6'b000000, parity2_6[9:8]};
		`RSDEC_PARITY2_7L_ADDR : RSDec_FI = parity2_7[7:0];
		`RSDEC_PARITY2_7H_ADDR : RSDec_FI = {6'b000000, parity2_7[9:8]};

		`RSDEC_PARITY3_0L_ADDR : RSDec_FI = parity3_0[7:0];
		`RSDEC_PARITY3_0H_ADDR : RSDec_FI = {6'b000000, parity3_0[9:8]};
		`RSDEC_PARITY3_1L_ADDR : RSDec_FI = parity3_1[7:0];
		`RSDEC_PARITY3_1H_ADDR : RSDec_FI = {6'b000000, parity3_1[9:8]};
		`RSDEC_PARITY3_2L_ADDR : RSDec_FI = parity3_2[7:0];
		`RSDEC_PARITY3_2H_ADDR : RSDec_FI = {6'b000000, parity3_2[9:8]};
		`RSDEC_PARITY3_3L_ADDR : RSDec_FI = parity3_3[7:0];
		`RSDEC_PARITY3_3H_ADDR : RSDec_FI = {6'b000000, parity3_3[9:8]};
		`RSDEC_PARITY3_4L_ADDR : RSDec_FI = parity3_4[7:0];
		`RSDEC_PARITY3_4H_ADDR : RSDec_FI = {6'b000000, parity3_4[9:8]};
		`RSDEC_PARITY3_5L_ADDR : RSDec_FI = parity3_5[7:0];
		`RSDEC_PARITY3_5H_ADDR : RSDec_FI = {6'b000000, parity3_5[9:8]};
		`RSDEC_PARITY3_6L_ADDR : RSDec_FI = parity3_6[7:0];
		`RSDEC_PARITY3_6H_ADDR : RSDec_FI = {6'b000000, parity3_6[9:8]};
		`RSDEC_PARITY3_7L_ADDR : RSDec_FI = parity3_7[7:0];
		`RSDEC_PARITY3_7H_ADDR : RSDec_FI = {6'b000000, parity3_7[9:8]};

		default		: RSDec_FI	= 8'h00;
		endcase
end

endmodule
