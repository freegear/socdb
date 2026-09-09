// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name        : SYNDCal.v
// File Revision    : 1.1 
// Reveision history: 
//  -----------------------------------------------------------------------------
//  Purpose         : Syndrom Calculation block
// ==============================================================================

module SYNDCal(
		RESETn,
		CLK,
		start,
		data,
		SYND0,
		SYND1,
		SYND2,
		SYND3,
		SYND4,
		SYND5,
		SYND6,
		SYND7
		);

input 		RESETn;
input 		CLK;
input 		start;
//`ifndef OPTIMIZE
input [9:0] 	data;
//`else
//input [7:0] 	data;
//`endif
output [9:0] 	SYND0;
output [9:0] 	SYND1;
output [9:0] 	SYND2;
output [9:0] 	SYND3;
output [9:0] 	SYND4;
output [9:0] 	SYND5;
output [9:0] 	SYND6;
output [9:0] 	SYND7;

parameter [9:0] groot0 =1;

parameter [9:0] groot1 =2;
parameter [9:0] groot2 =4;
parameter [9:0] groot3 =8;
parameter [9:0] groot4 =16;
parameter [9:0] groot5 =32;
parameter [9:0] groot6 =64;
parameter [9:0] groot7 =128;

reg [9:0] SYND0;
reg [9:0] SYND1;
reg [9:0] SYND2;
reg [9:0] SYND3;
reg [9:0] SYND4;
reg [9:0] SYND5;
reg [9:0] SYND6;
reg [9:0] SYND7;

reg [9:0] NextSYND0;
reg [9:0] NextSYND1;
reg [9:0] NextSYND2;
reg [9:0] NextSYND3;
reg [9:0] NextSYND4;
reg [9:0] NextSYND5;
reg [9:0] NextSYND6;
reg [9:0] NextSYND7;

reg [9:0] datain;

wire [9:0] mult0;
wire [9:0] mult1;
wire [9:0] mult2;
wire [9:0] mult3;
wire [9:0] mult4;
wire [9:0] mult5;
wire [9:0] mult6;
wire [9:0] mult7;


always @(start or data or mult0 or mult1 or mult2 or 
	mult3 or mult4 or mult5 or mult6 or mult7)
begin
	if (start)
	begin
		NextSYND0 = data;
		NextSYND1 = data;
		NextSYND2 = data;
		NextSYND3 = data;
		NextSYND4 = data;
		NextSYND5 = data;
		NextSYND6 = data;
		NextSYND7 = data;
	end
	else
	begin
		//NextSYND0 = data ^ mult0;
		NextSYND0 = data ^ SYND0;
		NextSYND1 = data ^ mult1;
		NextSYND2 = data ^ mult2;
		NextSYND3 = data ^ mult3;
		NextSYND4 = data ^ mult4;
		NextSYND5 = data ^ mult5;
		NextSYND6 = data ^ mult6;
		NextSYND7 = data ^ mult7;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
		begin
		SYND0 = 0;
		SYND1 = 0;
		SYND2 = 0;
		SYND3 = 0;
		SYND4 = 0;
		SYND5 = 0;
		SYND6 = 0;
		SYND7 = 0;
		end
	else
		begin
		SYND0 = NextSYND0;
		SYND1 = NextSYND1;
		SYND2 = NextSYND2;
		SYND3 = NextSYND3;
		SYND4 = NextSYND4;
		SYND5 = NextSYND5;
		SYND6 = NextSYND6;
		SYND7 = NextSYND7;
		end
end

//BinMult10	BM0 ( .indata1(SYND0), .indata2(groot0), .outdata(mult0)) ;// 최적화 필요 
BinMult10	BM1 ( .indata1(SYND1), .indata2(groot1), .outdata(mult1)) ;
BinMult10	BM2 ( .indata1(SYND2), .indata2(groot2), .outdata(mult2)) ;
BinMult10	BM3 ( .indata1(SYND3), .indata2(groot3), .outdata(mult3)) ;
BinMult10	BM4 ( .indata1(SYND4), .indata2(groot4), .outdata(mult4)) ;
BinMult10	BM5 ( .indata1(SYND5), .indata2(groot5), .outdata(mult5)) ;
BinMult10	BM6 ( .indata1(SYND6), .indata2(groot6), .outdata(mult6)) ;
BinMult10	BM7 ( .indata1(SYND7), .indata2(groot7), .outdata(mult7)) ;
endmodule
