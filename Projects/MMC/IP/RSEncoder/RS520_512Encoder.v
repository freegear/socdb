// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name        : RS520_512Encoder.v
// File Revision    : 1.0 
// Reveision history: 
//  ------------------------------------------------------------
//  Purpose         : Reed Solomon Encoder 520 _ 512
// ==============================================================================
//`define OPTIMIZE
module RS520_512Encoder
(	
	RESETn,
	CLK,
	Start,
	Wait,
	DATA,
	PARITY7,
	PARITY6,
	PARITY5,
	PARITY4,
	PARITY3,
	PARITY2,
	PARITY1,
	PARITY0
);

input			RESETn;
input 			CLK;
input			Start;
input			Wait;
`ifdef OPTIMIZE
input	[7:0]	DATA;
`else
input	[9:0]	DATA;
`endif
output	[9:0]	PARITY7;
output	[9:0]	PARITY6;
output	[9:0]	PARITY5;
output	[9:0]	PARITY4;
output	[9:0]	PARITY3;
output	[9:0]	PARITY2;
output	[9:0]	PARITY1;
output	[9:0]	PARITY0;

/*
parameter [9:0] generator7 = 10'd255;
parameter [9:0] generator6 = 10'd778;
parameter [9:0] generator5 = 10'd427;
parameter [9:0] generator4 = 10'd1006;
parameter [9:0] generator3 = 10'd29 ;
parameter [9:0] generator2 = 10'd677;
parameter [9:0] generator1 = 10'd665;
parameter [9:0] generator0 = 10'd400;
*/

wire [9:0]	generator0;
wire [9:0]	generator1;
wire [9:0]	generator2;
wire [9:0]	generator3;
wire [9:0]	generator4;
wire [9:0]	generator5;
wire [9:0]	generator6;
wire [9:0]	generator7;


assign generator0= 10'd400 ;
assign generator1= 10'd665 ;
assign generator2= 10'd677 ;
assign generator3= 10'd29 ;
assign generator4= 10'd1006;
assign generator5= 10'd427 ;
assign generator6= 10'd778 ;
assign generator7= 10'd255 ;



// Generator Polynomial
// 255x^7  + 778x^6 + 427x^5 + 1006x^4 + 29x^3 + 677x^2 + 665x + 400

wire 	[9:0]	indata;
wire	[9:0]	indata7;
wire	[9:0]	indata6;
wire	[9:0]	indata5;
wire	[9:0]	indata4;
wire	[9:0]	indata3;
wire	[9:0]	indata2;
wire	[9:0]	indata1;
wire	[9:0]	indata0;

wire	[9:0]	indat7;
wire	[9:0]	indat6;
wire	[9:0]	indat5;
wire	[9:0]	indat4;
wire	[9:0]	indat3;
wire	[9:0]	indat2;
wire	[9:0]	indat1;

reg		[9:0]	parity7;
reg		[9:0]	parity6;
reg		[9:0]	parity5;
reg		[9:0]	parity4;
reg		[9:0]	parity3;
reg		[9:0]	parity2;
reg		[9:0]	parity1;
reg		[9:0]	parity0;


assign PARITY7 = parity7;
assign PARITY6 = parity6;
assign PARITY5 = parity5;
assign PARITY4 = parity4;
assign PARITY3 = parity3;
assign PARITY2 = parity2;
assign PARITY1 = parity1;
assign PARITY0 = parity0;


`ifdef OPTIMIZE
XORDATA 	XORPARITY7 (.indata1(DATA), .indata2(parity7), .outdata(indata));
`else
assign indata = DATA ^ parity7;
`endif


BinMult10	BM0 (	
			.indata1(indata),
       		.indata2(generator7), 
			.outdata(indat7)
		) ; //나중에 최적화할 것

BinMult10	BM1 (	
			.indata1(indata), 
			.indata2(generator6), 
			.outdata(indat6)
		) ; //나중에 최적화할 것

BinMult10	BM2 (	
			.indata1(indata), 
			.indata2(generator5), 
			.outdata(indat5)
		) ; //나중에 최적화할 것

BinMult10	BM3 (	
			.indata1(indata), 
			.indata2(generator4), 
			.outdata(indat4)
		) ; //나중에 최적화할 것

BinMult10	BM4 (	
			.indata1(indata), 
			.indata2(generator3), 
			.outdata(indat3)
		) ; //나중에 최적화할 것

BinMult10	BM5 (	
			.indata1(indata), 
			.indata2(generator2), 
			.outdata(indat2)
		) ; //나중에 최적화할 것

BinMult10	BM6 (	
			.indata1(indata), 
			.indata2(generator1), 
			.outdata(indat1)
		) ; //나중에 최적화할 것

BinMult10	BM7 (	
			.indata1(indata), 
			.indata2(generator0), 
			.outdata(indata0)
		) ; //나중에 최적화할 것


assign 		indata7 = parity6 ^ indat7;
assign 		indata6	= parity5 ^ indat6;
assign 		indata5	= parity4 ^ indat5;
assign 		indata4	= parity3 ^ indat4;
assign 		indata3	= parity2 ^ indat3;
assign 		indata2	= parity1 ^ indat2;
assign 		indata1	= parity0 ^ indat1;

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
		parity7 <= 0;
		parity6 <= 0;
		parity5 <= 0;
		parity4 <= 0;
		parity3 <= 0;
		parity2 <= 0;
		parity1 <= 0;
		parity0 <= 0;
	end
	else if (Start)
	begin
		parity7 <= 0;
		parity6 <= 0;
		parity5 <= 0;
		parity4 <= 0;
		parity3 <= 0;
		parity2 <= 0;
		parity1 <= 0;
		parity0 <= 0;
	end
	else if (Wait)
	begin
		parity7 <= parity7;
		parity6 <= parity6;
		parity5 <= parity5;
		parity4 <= parity4;
		parity3 <= parity3;
		parity2 <= parity2;
		parity1 <= parity1;
		parity0 <= parity0;
	end
	else
	begin
		parity7 <= indata7;
		parity6 <= indata6;
		parity5 <= indata5;
		parity4 <= indata4;
		parity3 <= indata3;
		parity2 <= indata2;
		parity1 <= indata1;
		parity0 <= indata0;
	end
end

endmodule




module XORDATA (indata1, indata2, outdata);
input	[7:0]	indata1;
input 	[9:0]	indata2;
output	[9:0]	outdata;

assign outdata[0] = indata1[0] ^ indata2[0];
assign outdata[1] = indata1[1] ^ indata2[1];
assign outdata[2] = indata1[2] ^ indata2[2];
assign outdata[3] = indata1[3] ^ indata2[3];
assign outdata[4] = indata1[4] ^ indata2[4];
assign outdata[5] = indata1[5] ^ indata2[5];
assign outdata[6] = indata1[6] ^ indata2[6];
assign outdata[7] = indata1[7] ^ indata2[7];
assign outdata[8] = indata2[8];// 0 ^ indata2[8]
assign outdata[9] = indata2[9];// 0 ^ indata2[9]

endmodule




module BinMult8(indata1, indata2, outdata);
// indata1 is 8 bit data
// indata2 is 10 bit for generator function
input [7:0] indata1;
input [9:0] indata2;

output [9:0] outdata;

assign outdata[0] = ( 	indata1[0]&indata2[0] ^ 
			indata1[7]&indata2[3]^ 
			indata1[6]&indata2[4]^ 
			indata1[5]&indata2[5]^ 
			indata1[4]&indata2[6]^ 
			indata1[3]&indata2[7]^ 
			indata1[2]&indata2[8]^ 
			indata1[1]&indata2[9]);

assign outdata[1] = (	indata1[1]&indata2[0]^ 
			indata1[0]&indata2[1]^
			indata1[7]&indata2[4]^
			indata1[6]&indata2[5]^
			indata1[5]&indata2[6]^
			indata1[4]&indata2[7]^
			indata1[3]&indata2[8]^
			indata1[2]&indata2[9]);


assign outdata[2] = (	indata1[2]&indata2[0]^
			indata1[1]&indata2[1]^
			indata1[0]&indata2[2]^
			indata1[7]&indata2[5]^
			indata1[6]&indata2[6]^
			indata1[5]&indata2[7]^
			indata1[4]&indata2[8]^
			indata1[3]&indata2[9]);

assign outdata[3] = (	indata1[3]&indata2[0]^
			indata1[2]&indata2[1]^
			indata1[1]&indata2[2]^
			indata1[0]&indata2[3]^
			indata1[7]&indata2[3]^
			indata1[6]&indata2[4]^
			indata1[5]&indata2[5]^
			indata1[4]&indata2[6]^
			indata1[3]&indata2[7]^
			indata1[2]&indata2[8]^
			indata1[1]&indata2[9]^
			indata1[7]&indata2[6]^
			indata1[6]&indata2[7]^
			indata1[5]&indata2[8]^
			indata1[4]&indata2[9]);

assign outdata[4] = (	indata1[4]&indata2[0]^ 
			indata1[3]&indata2[1]^
			indata1[2]&indata2[2]^
			indata1[1]&indata2[3]^
			indata1[0]&indata2[4]^
			indata1[7]&indata2[4]^
			indata1[6]&indata2[5]^
			indata1[5]&indata2[6]^
			indata1[4]&indata2[7]^
			indata1[3]&indata2[8]^
			indata1[2]&indata2[9]^
			indata1[7]&indata2[7]^
			indata1[6]&indata2[8]^
			indata1[5]&indata2[9]);

assign outdata[5] = (	indata1[5]&indata2[0]^
			indata1[4]&indata2[1]^
			indata1[3]&indata2[2]^
			indata1[2]&indata2[3]^ 
			indata1[1]&indata2[4]^ 
			indata1[0]&indata2[5]^ 
			indata1[7]&indata2[5]^
			indata1[6]&indata2[6]^
			indata1[5]&indata2[7]^
			indata1[4]&indata2[8]^
			indata1[3]&indata2[9]^
			indata1[7]&indata2[8]^
			indata1[6]&indata2[9]);

assign outdata[6] = (	indata1[6]&indata2[0]^ 
			indata1[5]&indata2[1]^
			indata1[4]&indata2[2]^
			indata1[3]&indata2[3]^
			indata1[2]&indata2[4]^
			indata1[1]&indata2[5]^
			indata1[0]&indata2[6]^
			indata1[7]&indata2[6]^
			indata1[6]&indata2[7]^
			indata1[5]&indata2[8]^
			indata1[4]&indata2[9]^
			indata1[7]&indata2[9]);

assign outdata[7] = (	indata1[7]&indata2[0]^
			indata1[6]&indata2[1]^
			indata1[5]&indata2[2]^
			indata1[4]&indata2[3]^
			indata1[3]&indata2[4]^
			indata1[2]&indata2[5]^
			indata1[1]&indata2[6]^
			indata1[0]&indata2[7]^
			indata1[7]&indata2[7]^
			indata1[6]&indata2[8]^
			indata1[5]&indata2[9]);

assign outdata[8] = (	indata1[7]&indata2[1]^
			indata1[6]&indata2[2]^
			indata1[5]&indata2[3]^
			indata1[4]&indata2[4]^ 
			indata1[3]&indata2[5]^
			indata1[2]&indata2[6]^
			indata1[1]&indata2[7]^
			indata1[0]&indata2[8]^
			indata1[7]&indata2[8]^
			indata1[6]&indata2[9]);

assign outdata[9] = ( 	indata1[7]&indata2[2]^
		 	indata1[6]&indata2[3]^
		 	indata1[5]&indata2[4]^
		 	indata1[4]&indata2[5]^
		 	indata1[3]&indata2[6]^
		 	indata1[2]&indata2[7]^
		 	indata1[1]&indata2[8]^
		 	indata1[0]&indata2[9]^
		 	indata1[7]&indata2[9]);
endmodule

// GF(1023) Multiply Unit
// Primitive Polynomial is 1033 (x^10 + x^3 + 1)
module BinMult10(indata1, indata2, outdata);
input [9:0] 	indata1;
input [9:0]	indata2;
output [9:0]	outdata;

assign outdata[0] = (	indata1[0]&indata2[0] ^ 
			indata1[9]&indata2[1]^ 
			indata1[8]&indata2[2]^ 
			indata1[7]&indata2[3]^ 
			indata1[6]&indata2[4]^ 
			indata1[5]&indata2[5]^ 
			indata1[4]&indata2[6]^ 
			indata1[3]&indata2[7]^ 
			indata1[2]&indata2[8]^ 
			indata1[1]&indata2[9]^ 
			indata1[9]&indata2[8]^ 
			indata1[8]&indata2[9]);

assign outdata[1] = (	indata1[1]&indata2[0]^ 
			indata1[0]&indata2[1]^
			indata1[9]&indata2[2]^ 
			indata1[8]&indata2[3]^
			indata1[7]&indata2[4]^
			indata1[6]&indata2[5]^
			indata1[5]&indata2[6]^
			indata1[4]&indata2[7]^
			indata1[3]&indata2[8]^
			indata1[2]&indata2[9]^
			indata1[9]&indata2[9]);

assign outdata[2] = (	indata1[2]&indata2[0]^
			indata1[1]&indata2[1]^
			indata1[0]&indata2[2]^
			indata1[9]&indata2[3]^
			indata1[8]&indata2[4]^
			indata1[7]&indata2[5]^
			indata1[6]&indata2[6]^
			indata1[5]&indata2[7]^
			indata1[4]&indata2[8]^
			indata1[3]&indata2[9]);

assign outdata[3] = (	indata1[3]&indata2[0]^
			indata1[2]&indata2[1]^
			indata1[1]&indata2[2]^
			indata1[0]&indata2[3]^
			indata1[9]&indata2[1]^
			indata1[8]&indata2[2]^
			indata1[7]&indata2[3]^
			indata1[6]&indata2[4]^
			indata1[5]&indata2[5]^
			indata1[4]&indata2[6]^
			indata1[3]&indata2[7]^
			indata1[2]&indata2[8]^
			indata1[1]&indata2[9]^
			indata1[9]&indata2[4]^
			indata1[8]&indata2[5]^
			indata1[7]&indata2[6]^
			indata1[6]&indata2[7]^
			indata1[5]&indata2[8]^
			indata1[4]&indata2[9]^
			indata1[9]&indata2[8]^
			indata1[8]&indata2[9]);

assign outdata[4] = (	indata1[4]&indata2[0]^ 
			indata1[3]&indata2[1]^
			indata1[2]&indata2[2]^
			indata1[1]&indata2[3]^
			indata1[0]&indata2[4]^
			indata1[9]&indata2[2]^
			indata1[8]&indata2[3]^
			indata1[7]&indata2[4]^
			indata1[6]&indata2[5]^
			indata1[5]&indata2[6]^
			indata1[4]&indata2[7]^
			indata1[3]&indata2[8]^
			indata1[2]&indata2[9]^
			indata1[9]&indata2[5]^
			indata1[8]&indata2[6]^ 
			indata1[7]&indata2[7]^
			indata1[6]&indata2[8]^
			indata1[5]&indata2[9]^
			indata1[9]&indata2[9]);

assign outdata[5] = (	indata1[5]&indata2[0]^
			indata1[4]&indata2[1]^
			indata1[3]&indata2[2]^
			indata1[2]&indata2[3]^ 
			indata1[1]&indata2[4]^ 
			indata1[0]&indata2[5]^ 
			indata1[9]&indata2[3]^
			indata1[8]&indata2[4]^
			indata1[7]&indata2[5]^
			indata1[6]&indata2[6]^
			indata1[5]&indata2[7]^
			indata1[4]&indata2[8]^
			indata1[3]&indata2[9]^
			indata1[9]&indata2[6]^
			indata1[8]&indata2[7]^
			indata1[7]&indata2[8]^
			indata1[6]&indata2[9]);

assign outdata[6] = (	indata1[6]&indata2[0]^ 
			indata1[5]&indata2[1]^
			indata1[4]&indata2[2]^
			indata1[3]&indata2[3]^
			indata1[2]&indata2[4]^
			indata1[1]&indata2[5]^
			indata1[0]&indata2[6]^
			indata1[9]&indata2[4]^
			indata1[8]&indata2[5]^
			indata1[7]&indata2[6]^
			indata1[6]&indata2[7]^
			indata1[5]&indata2[8]^
			indata1[4]&indata2[9]^
			indata1[9]&indata2[7]^
			indata1[8]&indata2[8]^
			indata1[7]&indata2[9]);

assign outdata[7] = (	indata1[7]&indata2[0]^
			indata1[6]&indata2[1]^
			indata1[5]&indata2[2]^
			indata1[4]&indata2[3]^
			indata1[3]&indata2[4]^
			indata1[2]&indata2[5]^
			indata1[1]&indata2[6]^
			indata1[0]&indata2[7]^
			indata1[9]&indata2[5]^
			indata1[8]&indata2[6]^
			indata1[7]&indata2[7]^
			indata1[6]&indata2[8]^
			indata1[5]&indata2[9]^
			indata1[9]&indata2[8]^
			indata1[8]&indata2[9]);

assign outdata[8] = (	indata1[8]&indata2[0]^
			indata1[7]&indata2[1]^
			indata1[6]&indata2[2]^
			indata1[5]&indata2[3]^
			indata1[4]&indata2[4]^ 
			indata1[3]&indata2[5]^
			indata1[2]&indata2[6]^
			indata1[1]&indata2[7]^
			indata1[0]&indata2[8]^
			indata1[9]&indata2[6]^
			indata1[8]&indata2[7]^
			indata1[7]&indata2[8]^
			indata1[6]&indata2[9]^
			indata1[9]&indata2[9]);

assign outdata[9] = ( 	indata1[9]&indata2[0]^
		 	indata1[8]&indata2[1]^
		 	indata1[7]&indata2[2]^
		 	indata1[6]&indata2[3]^
		 	indata1[5]&indata2[4]^
		 	indata1[4]&indata2[5]^
		 	indata1[3]&indata2[6]^
		 	indata1[2]&indata2[7]^
		 	indata1[1]&indata2[8]^
		 	indata1[0]&indata2[9]^
		 	indata1[9]&indata2[7]^
		 	indata1[8]&indata2[8]^
		 	indata1[7]&indata2[9]);
endmodule







