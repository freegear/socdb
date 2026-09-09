// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name        : CSearch.v
// File Revision    : 1.0 
// Reveision history: 
//  ------------------------------------------------------------
//  Purpose         :  Chien Search Block
// ==============================================================================


module CSearch (	CLK, 
					RESETn, 
					SearchStart,
					ErrPosit4, 
					ErrPosit3, 
					ErrPosit2, 
					ErrPosit1, 
					ErrPosit0, 
					ErrVal4, 
					ErrVal3, 
					ErrVal2, 
					ErrVal1, 
					ErrVal0,
					CorrectErrorPosition0,
					CorrectErrorPosition1,
					CorrectErrorPosition2,
					CorrectErrorPosition3,
					CorrectErrorValue0,
					CorrectErrorValue1,
					CorrectErrorValue2,
					CorrectErrorValue3,
					ErrorCorrectEnd,
					ErrorUncorrectable
				);
input CLK;
input RESETn;
input SearchStart;

input [9:0] ErrPosit4; // Error Position
input [9:0] ErrPosit3; // Error Position
input [9:0] ErrPosit2; // Error Position
input [9:0] ErrPosit1; // Error Position
input [9:0] ErrPosit0; // Error Position
input [9:0] ErrVal4; // Error Value
input [9:0] ErrVal3; // Error Value
input [9:0] ErrVal2; // Error Value
input [9:0] ErrVal1; // Error Value
input [9:0] ErrVal0; // Error Value
output[9:0]	CorrectErrorPosition0;
output[9:0]	CorrectErrorPosition1;
output[9:0]	CorrectErrorPosition2;
output[9:0]	CorrectErrorPosition3;
output[9:0]	CorrectErrorValue0;
output[9:0]	CorrectErrorValue1;
output[9:0]	CorrectErrorValue2;
output[9:0]	CorrectErrorValue3;
output		ErrorCorrectEnd;
output		ErrorUncorrectable;


reg [9:0] NextEP1;
reg [9:0] NextEP2;
reg [9:0] NextEP3;
reg [9:0] NextEP4;

reg [9:0] NextEV1;
reg [9:0] NextEV2;
reg [9:0] NextEV3;
reg [9:0] NextEV4;

reg [9:0] EP1_in;
reg [9:0] EP2_in;
reg [9:0] EP3_in;
reg [9:0] EP4_in;
reg [9:0] EP0;
reg [9:0] EP1;
reg [9:0] EP2;
reg [9:0] EP3;
reg [9:0] EP4;
reg [9:0] EV1_in;
reg [9:0] EV2_in;
reg [9:0] EV3_in;
reg [9:0] EV4_in;
reg [9:0] EV0;
reg [9:0] EV1;
reg [9:0] EV2;
reg [9:0] EV3;
reg [9:0] EV4;
reg [9:0] EP_CNT;
reg [9:0] NextEP_CNT;

reg [9:0]	CorrectErrorPosition0;
reg [9:0]	CorrectErrorPosition1;
reg [9:0]	CorrectErrorPosition2;
reg [9:0]	CorrectErrorPosition3;
reg [9:0]	CorrectErrorValue0;
reg [9:0]	CorrectErrorValue1;
reg [9:0]	CorrectErrorValue2;
reg [9:0]	CorrectErrorValue3;

wire	[9:0]	NextEP1_OUT;
wire	[9:0]	NextEP2_OUT;
wire	[9:0]	NextEP3_OUT;
wire	[9:0]	NextEP4_OUT;

wire	[9:0]	NextEV1_OUT;
wire	[9:0]	NextEV2_OUT;
wire	[9:0]	NextEV3_OUT;
wire	[9:0]	NextEV4_OUT;



// Multi cycle path
//
//
//  EP의 초기값은  
//  (EP0)* 1^502 => EP0  
//  (EP1)* 2^502 => 947;// 2^502
//  (EP2)* 4^502 => 718;// 4^502 
//  (EP3)* 8^502 => 624;// 8^502 
//  (EP4)* 16^502 => 498;// 16^502  

//`ifndef ONECYCLE
//BinMult EP0Mult (.indata(EP0), .indata2(EP0_in), .outdata(NextEP0));
BinMult10 EP1Mult (.indata1(EP1), .indata2(EP1_in), .outdata(NextEP1_OUT));
BinMult10 EP2Mult (.indata1(EP2), .indata2(EP2_in), .outdata(NextEP2_OUT));
BinMult10 EP3Mult (.indata1(EP3), .indata2(EP3_in), .outdata(NextEP3_OUT));
BinMult10 EP4Mult (.indata1(EP4), .indata2(EP4_in), .outdata(NextEP4_OUT));

//BinMult EV0Mult (.indata(EV0), .indata2(EV0_in), .outdata(NextEV0));
BinMult10 EV1Mult (.indata1(EV1), .indata2(EV1_in), .outdata(NextEV1_OUT));
BinMult10 EV2Mult (.indata1(EV2), .indata2(EV2_in), .outdata(NextEV2_OUT));
BinMult10 EV3Mult (.indata1(EV3), .indata2(EV3_in), .outdata(NextEV3_OUT));
BinMult10 EV4Mult (.indata1(EV4), .indata2(EV4_in), .outdata(NextEV4_OUT));

always @(ErrPosit0)
begin
	EP0 = ErrPosit0;
end

always @(ErrVal0)
begin
	EV0 = ErrVal0;
end



// CSearch State Machine
// Idle/ Start /Search /End 

`define 	CSEARCH_IDLE	4'b0001
`define 	CSEARCH_START	4'b0001
`define 	CSEARCH_SEARCH	4'b0001
`define 	CSEARCH_END		4'b0001


reg	[3:0]	NextCSearchState;
reg	[3:0]	CSearchState;

always @(CSearchState or SearchStart or EP_CNT)
begin
	NextCSearchState = CSearchState;
	case (CSearchState)
	`CSEARCH_IDLE 	:	
			begin
			if (SearchStart)
				NextCSearchState = `CSEARCH_START;	
			end	
	`CSEARCH_START	:
				NextCSearchState = `CSEARCH_SEARCH;	
	`CSEARCH_SEARCH	:
			begin
			if (EP_CNT == 520)
				NextCSearchState = `CSEARCH_END;	
			end
	`CSEARCH_END		:
				NextCSearchState = `CSEARCH_IDLE;
	endcase
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CSearchState <= `CSEARCH_IDLE;
	else
	CSearchState <=	NextCSearchState;
end


always @(/*EP0 or */EP1 or EP2 or EP3 or EP4 or 
		ErrPosit4 or ErrPosit3 or ErrPosit2 or ErrPosit1 /*or ErrPosit0 */or 
		SearchStart or NextEP4_OUT or NextEP3_OUT or NextEP2_OUT or NextEP1_OUT)
begin
//	NextEP0 = EP0;
	NextEP1 = EP1;
	NextEP2 = EP2;
	NextEP3 = EP3;
	NextEP4 = EP4;
	
	if (SearchStart)
		begin
		NextEP4 = ErrPosit4; 
		NextEP3 = ErrPosit3; 
		NextEP2 = ErrPosit2; 
		NextEP1 = ErrPosit1; 
//		NextEP0 = ErrPosit0; 
		end
	else
		begin
		NextEP4 = NextEP4_OUT; 
		NextEP3 = NextEP3_OUT; 
		NextEP2 = NextEP2_OUT; 
		NextEP1 = NextEP1_OUT; 
		end
end


always @(/*EV0 or*/ EV1 or EV2 or EV3 or EV4 or 
		ErrVal4 or ErrVal3 or ErrVal2 or ErrVal1  /*or ErrVal0*/  or 
		NextEV4_OUT or NextEV3_OUT or NextEV2_OUT or NextEV1_OUT /*or NextEV0_OUT*/)
begin
//	NextEV0 = EV0;
	NextEV1 = EV1;
	NextEV2 = EV2;
	NextEV3 = EV3;
	NextEV4 = EV4;
	
	if (SearchStart)
		begin
		NextEV4 = ErrVal4; 
		NextEV3 = ErrVal3; 
		NextEV2 = ErrVal2; 
		NextEV1 = ErrVal1; 
//		NextEV0 = ErrVal0; 
		end
	else 
		begin
		NextEV4 = NextEV4_OUT; 
		NextEV3 = NextEV3_OUT; 
		NextEV2 = NextEV2_OUT; 
		NextEV1 = NextEV1_OUT; 
//		NextEV0 = NextEV0_OUT; 
		end
end



always @(SearchStart)
begin
	if (SearchStart)
	begin
//	EP0_in = 1;
	EP1_in = 947;// 2^502
	EP2_in = 718;// 4^502
	EP3_in = 624;// 8^502
	EP4_in = 498;// 16^502
	end
	else
	begin
//	EP0_in = 1 ;
	EP1_in = 2;
	EP2_in = 4;
	EP3_in = 8;
	EP4_in = 16;
	end
end



always @(posedge CLK or negedge RESETn)
begin
	if (RESETn)
	begin
//	EP0 <= 0;
	EP1 <= 0;
	EP2 <= 0;
	EP3 <= 0;
	EP4 <= 0;
	end
	else
	begin
//	EP0 <= NextEP0;
	EP1 <= NextEP1;
	EP2 <= NextEP2;
	EP3 <= NextEP3;
	EP4 <= NextEP4;
	end
end

always @(SearchStart)
begin
	if (SearchStart)
	begin
//	EV0_in = 1;
	EV1_in = 947;// 2^502
	EV2_in = 718;// 4^502
	EV3_in = 624;// 8^502
	EV4_in = 498;// 16^502
	end
	else
	begin
//	EV0_in = 1 ;
	EV1_in = 2;
	EV2_in = 4;
	EV3_in = 8;
	EV4_in = 16;
	end
end
always @(posedge CLK or negedge RESETn)
begin
	if (RESETn)
	begin
//	EV0 <= 0;
	EV1 <= 0;
	EV2 <= 0;
	EV3 <= 0;
	EV4 <= 0;
	end
	else
	begin
//	EV0 <= NextEV0;
	EV1 <= NextEV1;
	EV2 <= NextEV2;
	EV3 <= NextEV3;
	EV4 <= NextEV4;
	end
end
// Error Position Counter
always @(EP_CNT or CSearchState)
begin
	NextEP_CNT = EP_CNT;
	if (CSearchState == `CSEARCH_IDLE)
	NextEP_CNT = 0;
	else if (CSearchState == `CSEARCH_SEARCH)
	NextEP_CNT = EP_CNT + 1;
end



always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	EP_CNT <= 0;
	else
	EP_CNT <= NextEP_CNT;
end

wire [9:0] ErrOdd;
wire [9:0] ErrEven;
wire 		ErrDet;
wire[9:0]	ErrValue;
assign ErrOdd = EP3 ^ EP1;
assign ErrEven = EP4 ^ EP2 ^ EP0;

assign ErrDet = ((ErrOdd ^ ErrEven)==0)? 1 : 0 ;
assign ErrValue = EV4 ^ EV3 ^ EV2 ^ EV1 ^ EV0;

wire	[9:0]	CorrectValue;
CorrectError	CorrectError(
		.ErrDet			(ErrDet		 ), 
		.ErrOdd			(ErrOdd		 ), 
		.ErrValue		(ErrValue	 ), 
		.CorrectValue	(CorrectValue)
		);


// Error Correctable ? 
// ErrDet not generate ==> Uncorrectable Error
reg [2:0] 	NextErrDetCnt;
reg	[2:0]	ErrDetCnt;
always @(ErrDetCnt or CSearchState or ErrDet)
begin
	NextErrDetCnt = ErrDetCnt;
	if (CSearchState == `CSEARCH_IDLE)
	NextErrDetCnt = 0;
	else if ((CSearchState == `CSEARCH_SEARCH)&& (ErrDet))
	NextErrDetCnt = ErrDetCnt + 1;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ErrDetCnt = 0;
	else
	ErrDetCnt = NextErrDetCnt;
end

wire	NextErrorUncorrectable;
reg		ErrorUncorrectable;
assign	NextErrorUncorrectable = (CSearchState == `CSEARCH_END) && (ErrDetCnt == 0);

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ErrorUncorrectable <= 0;
	else
	ErrorUncorrectable <= NextErrorUncorrectable;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CorrectErrorPosition0 <= 0;
	else if (ErrDet & (ErrDetCnt==0))
	CorrectErrorPosition0 <= EP_CNT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CorrectErrorPosition1 <= 0;
	else if ((ErrDet)&&(ErrDetCnt==1))
	CorrectErrorPosition1 <= EP_CNT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CorrectErrorPosition2 <= 0;
	else if ((ErrDet)&&(ErrDetCnt==2))
	CorrectErrorPosition2 <= EP_CNT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CorrectErrorPosition3 <= 0;
	else if ((ErrDet)&&(ErrDetCnt==3))
	CorrectErrorPosition3 <= EP_CNT;
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CorrectErrorValue0 <= 0;
	else if ((ErrDet)&&(ErrDetCnt==0))
	CorrectErrorValue0 <= CorrectValue;
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CorrectErrorValue1 <= 0;
	else if ((ErrDet)&&(ErrDetCnt==1))
	CorrectErrorValue1 <= CorrectValue;
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CorrectErrorValue2 <= 0;
	else if ((ErrDet)&&(ErrDetCnt==2))
	CorrectErrorValue2 <= CorrectValue;
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CorrectErrorValue3 <= 0;
	else if ((ErrDet)&&(ErrDetCnt==3))
	CorrectErrorValue3 <= CorrectValue;
end

assign ErrorCorrectEnd = (CSearchState == `CSEARCH_END);
//`else

//`endif

endmodule

module CorrectError(ErrDet, ErrOdd, ErrValue, CorrectValue);
input ErrDet;
input [9:0]	ErrOdd;
input [9:0] ErrValue;
output [9:0] CorrectValue;

wire	[9:0]	InversErrOdd;
InverseValue InverseVal(.indata(ErrOdd), .outdata(InversErrOdd));
BinMult10  ErrCorrect (.indata1(InversErrOdd), .indata2(ErrValue), .outdata(CorrectValue));

endmodule

// 입력 데이터의 역원구하기
module InverseValue(indata, outdata);
input [9:0] indata;
output[9:0] outdata;

reg [9:0] outdata;

// indata ^ 1023 => indata ^ - 1
// present ROM table -> 수식 일반화하여 적용할 것
always @(indata)
begin
case (indata)
 0 : outdata = 0; 
 1 : outdata = 1; 
 2 : outdata = 516; 
 3 : outdata = 1016; 
 4 : outdata = 258; 
 5 : outdata = 687; 
 6 : outdata = 508; 
 7 : outdata = 734; 
 8 : outdata = 129; 
 9 : outdata = 589; 
 10 : outdata = 851; 
 11 : outdata = 184; 
 12 : outdata = 254; 
 13 : outdata = 232; 
 14 : outdata = 367; 
 15 : outdata = 610; 
 16 : outdata = 580; 
 17 : outdata = 478; 
 18 : outdata = 802; 
 19 : outdata = 214; 
 20 : outdata = 941; 
 21 : outdata = 242; 
 22 : outdata = 92; 
 23 : outdata = 88; 
 24 : outdata = 127; 
 25 : outdata = 977; 
 26 : outdata = 116; 
 27 : outdata = 572; 
 28 : outdata = 691; 
 29 : outdata = 104; 
 30 : outdata = 305; 
 31 : outdata = 399; 
 32 : outdata = 290; 
 33 : outdata = 133; 
 34 : outdata = 239; 
 35 : outdata = 765; 
 36 : outdata = 401; 
 37 : outdata = 632; 
 38 : outdata = 107; 
 39 : outdata = 991; 
 40 : outdata = 978; 
 41 : outdata = 423; 
 42 : outdata = 121; 
 43 : outdata = 335; 
 44 : outdata = 46; 
 45 : outdata = 531; 
 46 : outdata = 44; 
 47 : outdata = 530; 
 48 : outdata = 571; 
 49 : outdata = 395; 
 50 : outdata = 1004; 
 51 : outdata = 845; 
 52 : outdata = 58; 
 53 : outdata = 949; 
 54 : outdata = 286; 
 55 : outdata = 231; 
 56 : outdata = 861; 
 57 : outdata = 975; 
 58 : outdata = 52; 
 59 : outdata = 948; 
 60 : outdata = 668; 
 61 : outdata = 1001; 
 62 : outdata = 707; 
 63 : outdata = 937; 
 64 : outdata = 145; 
 65 : outdata = 359; 
 66 : outdata = 582; 
 67 : outdata = 135; 
 68 : outdata = 627; 
 69 : outdata = 473; 
 70 : outdata = 890; 
 71 : outdata = 672; 
 72 : outdata = 716; 
 73 : outdata = 738; 
 74 : outdata = 316; 
 75 : outdata = 325; 
 76 : outdata = 561; 
 77 : outdata = 364; 
 78 : outdata = 1003; 
 79 : outdata = 296; 
 80 : outdata = 489; 
 81 : outdata = 253; 
 82 : outdata = 727; 
 83 : outdata = 894; 
 84 : outdata = 568; 
 85 : outdata = 315; 
 86 : outdata = 675; 
 87 : outdata = 563; 
 88 : outdata = 23; 
 89 : outdata = 93; 
 90 : outdata = 781; 
 91 : outdata = 308; 
 92 : outdata = 22; 
 93 : outdata = 89; 
 94 : outdata = 265; 
 95 : outdata = 660; 
 96 : outdata = 793; 
 97 : outdata = 629; 
 98 : outdata = 705; 
 99 : outdata = 900; 
 100 : outdata = 502; 
 101 : outdata = 427; 
 102 : outdata = 930; 
 103 : outdata = 310; 
 104 : outdata = 29; 
 105 : outdata = 690; 
 106 : outdata = 990; 
 107 : outdata = 38; 
 108 : outdata = 143; 
 109 : outdata = 337; 
 110 : outdata = 631; 
 111 : outdata = 559; 
 112 : outdata = 938; 
 113 : outdata = 521; 
 114 : outdata = 995; 
 115 : outdata = 574; 
 116 : outdata = 26; 
 117 : outdata = 573; 
 118 : outdata = 474; 
 119 : outdata = 497; 
 120 : outdata = 334; 
 121 : outdata = 42; 
 122 : outdata = 1008; 
 123 : outdata = 157; 
 124 : outdata = 869; 
 125 : outdata = 197; 
 126 : outdata = 976; 
 127 : outdata = 24; 
 128 : outdata = 588; 
 129 : outdata = 8; 
 130 : outdata = 695; 
 131 : outdata = 747; 
 132 : outdata = 291; 
 133 : outdata = 33; 
 134 : outdata = 583; 
 135 : outdata = 67; 
 136 : outdata = 829; 
 137 : outdata = 810; 
 138 : outdata = 744; 
 139 : outdata = 993; 
 140 : outdata = 445; 
 141 : outdata = 908; 
 142 : outdata = 336; 
 143 : outdata = 108; 
 144 : outdata = 358; 
 145 : outdata = 64; 
 146 : outdata = 369; 
 147 : outdata = 512; 
 148 : outdata = 158; 
 149 : outdata = 490; 
 150 : outdata = 678; 
 151 : outdata = 819; 
 152 : outdata = 796; 
 153 : outdata = 175; 
 154 : outdata = 182; 
 155 : outdata = 206; 
 156 : outdata = 1009; 
 157 : outdata = 123; 
 158 : outdata = 148; 
 159 : outdata = 491; 
 160 : outdata = 752; 
 161 : outdata = 319; 
 162 : outdata = 634; 
 163 : outdata = 467; 
 164 : outdata = 879; 
 165 : outdata = 380; 
 166 : outdata = 447; 
 167 : outdata = 240; 
 168 : outdata = 284; 
 169 : outdata = 789; 
 170 : outdata = 665; 
 171 : outdata = 872; 
 172 : outdata = 853; 
 173 : outdata = 766; 
 174 : outdata = 797; 
 175 : outdata = 153; 
 176 : outdata = 527; 
 177 : outdata = 485; 
 178 : outdata = 554; 
 179 : outdata = 288; 
 180 : outdata = 898; 
 181 : outdata = 710; 
 182 : outdata = 154; 
 183 : outdata = 207; 
 184 : outdata = 11; 
 185 : outdata = 850; 
 186 : outdata = 552; 
 187 : outdata = 617; 
 188 : outdata = 640; 
 189 : outdata = 997; 
 190 : outdata = 330; 
 191 : outdata = 952; 
 192 : outdata = 904; 
 193 : outdata = 914; 
 194 : outdata = 830; 
 195 : outdata = 221; 
 196 : outdata = 868; 
 197 : outdata = 125; 
 198 : outdata = 450; 
 199 : outdata = 608; 
 200 : outdata = 251; 
 201 : outdata = 615; 
 202 : outdata = 721; 
 203 : outdata = 741; 
 204 : outdata = 465; 
 205 : outdata = 515; 
 206 : outdata = 155; 
 207 : outdata = 183; 
 208 : outdata = 522; 
 209 : outdata = 799; 
 210 : outdata = 345; 
 211 : outdata = 943; 
 212 : outdata = 495; 
 213 : outdata = 1006; 
 214 : outdata = 19; 
 215 : outdata = 803; 
 216 : outdata = 579; 
 217 : outdata = 784; 
 218 : outdata = 684; 
 219 : outdata = 601; 
 220 : outdata = 831; 
 221 : outdata = 195; 
 222 : outdata = 787; 
 223 : outdata = 482; 
 224 : outdata = 469; 
 225 : outdata = 396; 
 226 : outdata = 768; 
 227 : outdata = 564; 
 228 : outdata = 1013; 
 229 : outdata = 279; 
 230 : outdata = 287; 
 231 : outdata = 55; 
 232 : outdata = 13; 
 233 : outdata = 255; 
 234 : outdata = 794; 
 235 : outdata = 972; 
 236 : outdata = 237; 
 237 : outdata = 236; 
 238 : outdata = 764; 
 239 : outdata = 34; 
 240 : outdata = 167; 
 241 : outdata = 446; 
 242 : outdata = 21; 
 243 : outdata = 940; 
 244 : outdata = 504; 
 245 : outdata = 298; 
 246 : outdata = 586; 
 247 : outdata = 983; 
 248 : outdata = 950; 
 249 : outdata = 534; 
 250 : outdata = 614; 
 251 : outdata = 200; 
 252 : outdata = 488; 
 253 : outdata = 81; 
 254 : outdata = 12; 
 255 : outdata = 233; 
 256 : outdata = 294; 
 257 : outdata = 928; 
 258 : outdata = 4; 
 259 : outdata = 686; 
 260 : outdata = 863; 
 261 : outdata = 416; 
 262 : outdata = 881; 
 263 : outdata = 968; 
 264 : outdata = 661; 
 265 : outdata = 94; 
 266 : outdata = 532; 
 267 : outdata = 498; 
 268 : outdata = 807; 
 269 : outdata = 959; 
 270 : outdata = 549; 
 271 : outdata = 719; 
 272 : outdata = 922; 
 273 : outdata = 441; 
 274 : outdata = 405; 
 275 : outdata = 877; 
 276 : outdata = 372; 
 277 : outdata = 356; 
 278 : outdata = 1012; 
 279 : outdata = 229; 
 280 : outdata = 730; 
 281 : outdata = 333; 
 282 : outdata = 454; 
 283 : outdata = 677; 
 284 : outdata = 168; 
 285 : outdata = 788; 
 286 : outdata = 54; 
 287 : outdata = 230; 
 288 : outdata = 179; 
 289 : outdata = 555; 
 290 : outdata = 32; 
 291 : outdata = 132; 
 292 : outdata = 700; 
 293 : outdata = 492; 
 294 : outdata = 256; 
 295 : outdata = 929; 
 296 : outdata = 79; 
 297 : outdata = 1002; 
 298 : outdata = 245; 
 299 : outdata = 505; 
 300 : outdata = 339; 
 301 : outdata = 911; 
 302 : outdata = 925; 
 303 : outdata = 778; 
 304 : outdata = 398; 
 305 : outdata = 30; 
 306 : outdata = 595; 
 307 : outdata = 500; 
 308 : outdata = 91; 
 309 : outdata = 780; 
 310 : outdata = 103; 
 311 : outdata = 931; 
 312 : outdata = 1020; 
 313 : outdata = 944; 
 314 : outdata = 569; 
 315 : outdata = 85; 
 316 : outdata = 74; 
 317 : outdata = 324; 
 318 : outdata = 753; 
 319 : outdata = 161; 
 320 : outdata = 376; 
 321 : outdata = 743; 
 322 : outdata = 667; 
 323 : outdata = 649; 
 324 : outdata = 317; 
 325 : outdata = 75; 
 326 : outdata = 749; 
 327 : outdata = 409; 
 328 : outdata = 947; 
 329 : outdata = 551; 
 330 : outdata = 190; 
 331 : outdata = 953; 
 332 : outdata = 731; 
 333 : outdata = 281; 
 334 : outdata = 120; 
 335 : outdata = 43; 
 336 : outdata = 142; 
 337 : outdata = 109; 
 338 : outdata = 910; 
 339 : outdata = 300; 
 340 : outdata = 840; 
 341 : outdata = 645; 
 342 : outdata = 436; 
 343 : outdata = 518; 
 344 : outdata = 942; 
 345 : outdata = 210; 
 346 : outdata = 383; 
 347 : outdata = 477; 
 348 : outdata = 906; 
 349 : outdata = 419; 
 350 : outdata = 584; 
 351 : outdata = 413; 
 352 : outdata = 771; 
 353 : outdata = 857; 
 354 : outdata = 758; 
 355 : outdata = 362; 
 356 : outdata = 277; 
 357 : outdata = 373; 
 358 : outdata = 144; 
 359 : outdata = 65; 
 360 : outdata = 449; 
 361 : outdata = 751; 
 362 : outdata = 355; 
 363 : outdata = 759; 
 364 : outdata = 77; 
 365 : outdata = 560; 
 366 : outdata = 611; 
 367 : outdata = 14; 
 368 : outdata = 513; 
 369 : outdata = 146; 
 370 : outdata = 425; 
 371 : outdata = 754; 
 372 : outdata = 276; 
 373 : outdata = 357; 
 374 : outdata = 816; 
 375 : outdata = 896; 
 376 : outdata = 320; 
 377 : outdata = 742; 
 378 : outdata = 1014; 
 379 : outdata = 708; 
 380 : outdata = 165; 
 381 : outdata = 878; 
 382 : outdata = 476; 
 383 : outdata = 346; 
 384 : outdata = 452; 
 385 : outdata = 697; 
 386 : outdata = 457; 
 387 : outdata = 1023; 
 388 : outdata = 415; 
 389 : outdata = 606; 
 390 : outdata = 618; 
 391 : outdata = 965; 
 392 : outdata = 434; 
 393 : outdata = 966; 
 394 : outdata = 570; 
 395 : outdata = 49; 
 396 : outdata = 225; 
 397 : outdata = 468; 
 398 : outdata = 304; 
 399 : outdata = 31; 
 400 : outdata = 633; 
 401 : outdata = 36; 
 402 : outdata = 823; 
 403 : outdata = 885; 
 404 : outdata = 876; 
 405 : outdata = 274; 
 406 : outdata = 886; 
 407 : outdata = 643; 
 408 : outdata = 748; 
 409 : outdata = 327; 
 410 : outdata = 773; 
 411 : outdata = 737; 
 412 : outdata = 585; 
 413 : outdata = 351; 
 414 : outdata = 607; 
 415 : outdata = 388; 
 416 : outdata = 261; 
 417 : outdata = 862; 
 418 : outdata = 907; 
 419 : outdata = 349; 
 420 : outdata = 680; 
 421 : outdata = 955; 
 422 : outdata = 979; 
 423 : outdata = 41; 
 424 : outdata = 755; 
 425 : outdata = 370; 
 426 : outdata = 503; 
 427 : outdata = 101; 
 428 : outdata = 525; 
 429 : outdata = 957; 
 430 : outdata = 917; 
 431 : outdata = 834; 
 432 : outdata = 805; 
 433 : outdata = 926; 
 434 : outdata = 392; 
 435 : outdata = 967; 
 436 : outdata = 342; 
 437 : outdata = 519; 
 438 : outdata = 808; 
 439 : outdata = 762; 
 440 : outdata = 923; 
 441 : outdata = 273; 
 442 : outdata = 613; 
 443 : outdata = 812; 
 444 : outdata = 909; 
 445 : outdata = 140; 
 446 : outdata = 241; 
 447 : outdata = 166; 
 448 : outdata = 750; 
 449 : outdata = 360; 
 450 : outdata = 198; 
 451 : outdata = 609; 
 452 : outdata = 384; 
 453 : outdata = 696; 
 454 : outdata = 282; 
 455 : outdata = 676; 
 456 : outdata = 1022; 
 457 : outdata = 386; 
 458 : outdata = 655; 
 459 : outdata = 713; 
 460 : outdata = 651; 
 461 : outdata = 544; 
 462 : outdata = 543; 
 463 : outdata = 866; 
 464 : outdata = 514; 
 465 : outdata = 204; 
 466 : outdata = 635; 
 467 : outdata = 163; 
 468 : outdata = 397; 
 469 : outdata = 224; 
 470 : outdata = 486; 
 471 : outdata = 688; 
 472 : outdata = 626; 
 473 : outdata = 69; 
 474 : outdata = 118; 
 475 : outdata = 496; 
 476 : outdata = 382; 
 477 : outdata = 347; 
 478 : outdata = 17; 
 479 : outdata = 581; 
 480 : outdata = 599; 
 481 : outdata = 761; 
 482 : outdata = 223; 
 483 : outdata = 786; 
 484 : outdata = 526; 
 485 : outdata = 177; 
 486 : outdata = 470; 
 487 : outdata = 689; 
 488 : outdata = 252; 
 489 : outdata = 80; 
 490 : outdata = 149; 
 491 : outdata = 159; 
 492 : outdata = 293; 
 493 : outdata = 701; 
 494 : outdata = 1007; 
 495 : outdata = 212; 
 496 : outdata = 475; 
 497 : outdata = 119; 
 498 : outdata = 267; 
 499 : outdata = 533; 
 500 : outdata = 307; 
 501 : outdata = 594; 
 502 : outdata = 100; 
 503 : outdata = 426; 
 504 : outdata = 244; 
 505 : outdata = 299; 
 506 : outdata = 556; 
 507 : outdata = 756; 
 508 : outdata = 6; 
 509 : outdata = 735; 
 510 : outdata = 624; 
 511 : outdata = 912; 
 512 : outdata = 147; 
 513 : outdata = 368; 
 514 : outdata = 464; 
 515 : outdata = 205; 
 516 : outdata = 2; 
 517 : outdata = 1017; 
 518 : outdata = 343; 
 519 : outdata = 437; 
 520 : outdata = 939; 
 521 : outdata = 113; 
 522 : outdata = 208; 
 523 : outdata = 798; 
 524 : outdata = 956; 
 525 : outdata = 428; 
 526 : outdata = 484; 
 527 : outdata = 176; 
 528 : outdata = 846; 
 529 : outdata = 670; 
 530 : outdata = 47; 
 531 : outdata = 45; 
 532 : outdata = 266; 
 533 : outdata = 499; 
 534 : outdata = 249; 
 535 : outdata = 951; 
 536 : outdata = 919; 
 537 : outdata = 865; 
 538 : outdata = 987; 
 539 : outdata = 859; 
 540 : outdata = 790; 
 541 : outdata = 659; 
 542 : outdata = 867; 
 543 : outdata = 462; 
 544 : outdata = 461; 
 545 : outdata = 650; 
 546 : outdata = 728; 
 547 : outdata = 592; 
 548 : outdata = 718; 
 549 : outdata = 270; 
 550 : outdata = 946; 
 551 : outdata = 329; 
 552 : outdata = 186; 
 553 : outdata = 616; 
 554 : outdata = 178; 
 555 : outdata = 289; 
 556 : outdata = 506; 
 557 : outdata = 757; 
 558 : outdata = 630; 
 559 : outdata = 111; 
 560 : outdata = 365; 
 561 : outdata = 76; 
 562 : outdata = 674; 
 563 : outdata = 87; 
 564 : outdata = 227; 
 565 : outdata = 769; 
 566 : outdata = 854; 
 567 : outdata = 620; 
 568 : outdata = 84; 
 569 : outdata = 314; 
 570 : outdata = 394; 
 571 : outdata = 48; 
 572 : outdata = 27; 
 573 : outdata = 117; 
 574 : outdata = 115; 
 575 : outdata = 994; 
 576 : outdata = 605; 
 577 : outdata = 971; 
 578 : outdata = 785; 
 579 : outdata = 216; 
 580 : outdata = 16; 
 581 : outdata = 479; 
 582 : outdata = 66; 
 583 : outdata = 134; 
 584 : outdata = 350; 
 585 : outdata = 412; 
 586 : outdata = 246; 
 587 : outdata = 982; 
 588 : outdata = 128; 
 589 : outdata = 9; 
 590 : outdata = 980; 
 591 : outdata = 623; 
 592 : outdata = 547; 
 593 : outdata = 729; 
 594 : outdata = 501; 
 595 : outdata = 306; 
 596 : outdata = 638; 
 597 : outdata = 934; 
 598 : outdata = 760; 
 599 : outdata = 480; 
 600 : outdata = 685; 
 601 : outdata = 219; 
 602 : outdata = 963; 
 603 : outdata = 889; 
 604 : outdata = 970; 
 605 : outdata = 576; 
 606 : outdata = 389; 
 607 : outdata = 414; 
 608 : outdata = 199; 
 609 : outdata = 451; 
 610 : outdata = 15; 
 611 : outdata = 366; 
 612 : outdata = 813; 
 613 : outdata = 442; 
 614 : outdata = 250; 
 615 : outdata = 201; 
 616 : outdata = 553; 
 617 : outdata = 187; 
 618 : outdata = 390; 
 619 : outdata = 964; 
 620 : outdata = 567; 
 621 : outdata = 855; 
 622 : outdata = 981; 
 623 : outdata = 591; 
 624 : outdata = 510; 
 625 : outdata = 913; 
 626 : outdata = 472; 
 627 : outdata = 68; 
 628 : outdata = 792; 
 629 : outdata = 97; 
 630 : outdata = 558; 
 631 : outdata = 110; 
 632 : outdata = 37; 
 633 : outdata = 400; 
 634 : outdata = 162; 
 635 : outdata = 466; 
 636 : outdata = 892; 
 637 : outdata = 849; 
 638 : outdata = 596; 
 639 : outdata = 935; 
 640 : outdata = 188; 
 641 : outdata = 996; 
 642 : outdata = 887; 
 643 : outdata = 407; 
 644 : outdata = 841; 
 645 : outdata = 341; 
 646 : outdata = 832; 
 647 : outdata = 921; 
 648 : outdata = 666; 
 649 : outdata = 323; 
 650 : outdata = 545; 
 651 : outdata = 460; 
 652 : outdata = 882; 
 653 : outdata = 723; 
 654 : outdata = 712; 
 655 : outdata = 458; 
 656 : outdata = 989; 
 657 : outdata = 1010; 
 658 : outdata = 791; 
 659 : outdata = 541; 
 660 : outdata = 95; 
 661 : outdata = 264; 
 662 : outdata = 984; 
 663 : outdata = 843; 
 664 : outdata = 873; 
 665 : outdata = 170; 
 666 : outdata = 648; 
 667 : outdata = 322; 
 668 : outdata = 60; 
 669 : outdata = 1000; 
 670 : outdata = 529; 
 671 : outdata = 847; 
 672 : outdata = 71; 
 673 : outdata = 891; 
 674 : outdata = 562; 
 675 : outdata = 86; 
 676 : outdata = 455; 
 677 : outdata = 283; 
 678 : outdata = 150; 
 679 : outdata = 818; 
 680 : outdata = 420; 
 681 : outdata = 954; 
 682 : outdata = 838; 
 683 : outdata = 826; 
 684 : outdata = 218; 
 685 : outdata = 600; 
 686 : outdata = 259; 
 687 : outdata = 5; 
 688 : outdata = 471; 
 689 : outdata = 487; 
 690 : outdata = 105; 
 691 : outdata = 28; 
 692 : outdata = 699; 
 693 : outdata = 724; 
 694 : outdata = 746; 
 695 : outdata = 130; 
 696 : outdata = 453; 
 697 : outdata = 385; 
 698 : outdata = 725; 
 699 : outdata = 692; 
 700 : outdata = 292; 
 701 : outdata = 493; 
 702 : outdata = 714; 
 703 : outdata = 777; 
 704 : outdata = 901; 
 705 : outdata = 98; 
 706 : outdata = 936; 
 707 : outdata = 62; 
 708 : outdata = 379; 
 709 : outdata = 1015; 
 710 : outdata = 181; 
 711 : outdata = 899; 
 712 : outdata = 654; 
 713 : outdata = 459; 
 714 : outdata = 702; 
 715 : outdata = 776; 
 716 : outdata = 72; 
 717 : outdata = 739; 
 718 : outdata = 548; 
 719 : outdata = 271; 
 720 : outdata = 740; 
 721 : outdata = 202; 
 722 : outdata = 883; 
 723 : outdata = 653; 
 724 : outdata = 693; 
 725 : outdata = 698; 
 726 : outdata = 895; 
 727 : outdata = 82; 
 728 : outdata = 546; 
 729 : outdata = 593; 
 730 : outdata = 280; 
 731 : outdata = 332; 
 732 : outdata = 821; 
 733 : outdata = 903; 
 734 : outdata = 7; 
 735 : outdata = 509; 
 736 : outdata = 772; 
 737 : outdata = 411; 
 738 : outdata = 73; 
 739 : outdata = 717; 
 740 : outdata = 720; 
 741 : outdata = 203; 
 742 : outdata = 377; 
 743 : outdata = 321; 
 744 : outdata = 138; 
 745 : outdata = 992; 
 746 : outdata = 694; 
 747 : outdata = 131; 
 748 : outdata = 408; 
 749 : outdata = 326; 
 750 : outdata = 448; 
 751 : outdata = 361; 
 752 : outdata = 160; 
 753 : outdata = 318; 
 754 : outdata = 371; 
 755 : outdata = 424; 
 756 : outdata = 507; 
 757 : outdata = 557; 
 758 : outdata = 354; 
 759 : outdata = 363; 
 760 : outdata = 598; 
 761 : outdata = 481; 
 762 : outdata = 439; 
 763 : outdata = 809; 
 764 : outdata = 238; 
 765 : outdata = 35; 
 766 : outdata = 173; 
 767 : outdata = 852; 
 768 : outdata = 226; 
 769 : outdata = 565; 
 770 : outdata = 856; 
 771 : outdata = 352; 
 772 : outdata = 736; 
 773 : outdata = 410; 
 774 : outdata = 1019; 
 775 : outdata = 874; 
 776 : outdata = 715; 
 777 : outdata = 703; 
 778 : outdata = 303; 
 779 : outdata = 924; 
 780 : outdata = 309; 
 781 : outdata = 90; 
 782 : outdata = 998; 
 783 : outdata = 871; 
 784 : outdata = 217; 
 785 : outdata = 578; 
 786 : outdata = 483; 
 787 : outdata = 222; 
 788 : outdata = 285; 
 789 : outdata = 169; 
 790 : outdata = 540; 
 791 : outdata = 658; 
 792 : outdata = 628; 
 793 : outdata = 96; 
 794 : outdata = 234; 
 795 : outdata = 973; 
 796 : outdata = 152; 
 797 : outdata = 174; 
 798 : outdata = 523; 
 799 : outdata = 209; 
 800 : outdata = 824; 
 801 : outdata = 933; 
 802 : outdata = 18; 
 803 : outdata = 215; 
 804 : outdata = 927; 
 805 : outdata = 432; 
 806 : outdata = 958; 
 807 : outdata = 268; 
 808 : outdata = 438; 
 809 : outdata = 763; 
 810 : outdata = 137; 
 811 : outdata = 828; 
 812 : outdata = 443; 
 813 : outdata = 612; 
 814 : outdata = 837; 
 815 : outdata = 960; 
 816 : outdata = 374; 
 817 : outdata = 897; 
 818 : outdata = 679; 
 819 : outdata = 151; 
 820 : outdata = 902; 
 821 : outdata = 732; 
 822 : outdata = 884; 
 823 : outdata = 402; 
 824 : outdata = 800; 
 825 : outdata = 932; 
 826 : outdata = 683; 
 827 : outdata = 839; 
 828 : outdata = 811; 
 829 : outdata = 136; 
 830 : outdata = 194; 
 831 : outdata = 220; 
 832 : outdata = 646; 
 833 : outdata = 920; 
 834 : outdata = 431; 
 835 : outdata = 916; 
 836 : outdata = 961; 
 837 : outdata = 814; 
 838 : outdata = 682; 
 839 : outdata = 827; 
 840 : outdata = 340; 
 841 : outdata = 644; 
 842 : outdata = 985; 
 843 : outdata = 663; 
 844 : outdata = 1005; 
 845 : outdata = 51; 
 846 : outdata = 528; 
 847 : outdata = 671; 
 848 : outdata = 893; 
 849 : outdata = 637; 
 850 : outdata = 185; 
 851 : outdata = 10; 
 852 : outdata = 767; 
 853 : outdata = 172; 
 854 : outdata = 566; 
 855 : outdata = 621; 
 856 : outdata = 770; 
 857 : outdata = 353; 
 858 : outdata = 986; 
 859 : outdata = 539; 
 860 : outdata = 974; 
 861 : outdata = 56; 
 862 : outdata = 417; 
 863 : outdata = 260; 
 864 : outdata = 918; 
 865 : outdata = 537; 
 866 : outdata = 463; 
 867 : outdata = 542; 
 868 : outdata = 196; 
 869 : outdata = 124; 
 870 : outdata = 999; 
 871 : outdata = 783; 
 872 : outdata = 171; 
 873 : outdata = 664; 
 874 : outdata = 775; 
 875 : outdata = 1018; 
 876 : outdata = 404; 
 877 : outdata = 275; 
 878 : outdata = 381; 
 879 : outdata = 164; 
 880 : outdata = 969; 
 881 : outdata = 262; 
 882 : outdata = 652; 
 883 : outdata = 722; 
 884 : outdata = 822; 
 885 : outdata = 403; 
 886 : outdata = 406; 
 887 : outdata = 642; 
 888 : outdata = 962; 
 889 : outdata = 603; 
 890 : outdata = 70; 
 891 : outdata = 673; 
 892 : outdata = 636; 
 893 : outdata = 848; 
 894 : outdata = 83; 
 895 : outdata = 726; 
 896 : outdata = 375; 
 897 : outdata = 817; 
 898 : outdata = 180; 
 899 : outdata = 711; 
 900 : outdata = 99; 
 901 : outdata = 704; 
 902 : outdata = 820; 
 903 : outdata = 733; 
 904 : outdata = 192; 
 905 : outdata = 915; 
 906 : outdata = 348; 
 907 : outdata = 418; 
 908 : outdata = 141; 
 909 : outdata = 444; 
 910 : outdata = 338; 
 911 : outdata = 301; 
 912 : outdata = 511; 
 913 : outdata = 625; 
 914 : outdata = 193; 
 915 : outdata = 905; 
 916 : outdata = 835; 
 917 : outdata = 430; 
 918 : outdata = 864; 
 919 : outdata = 536; 
 920 : outdata = 833; 
 921 : outdata = 647; 
 922 : outdata = 272; 
 923 : outdata = 440; 
 924 : outdata = 779; 
 925 : outdata = 302; 
 926 : outdata = 433; 
 927 : outdata = 804; 
 928 : outdata = 257; 
 929 : outdata = 295; 
 930 : outdata = 102; 
 931 : outdata = 311; 
 932 : outdata = 825; 
 933 : outdata = 801; 
 934 : outdata = 597; 
 935 : outdata = 639; 
 936 : outdata = 706; 
 937 : outdata = 63; 
 938 : outdata = 112; 
 939 : outdata = 520; 
 940 : outdata = 243; 
 941 : outdata = 20; 
 942 : outdata = 344; 
 943 : outdata = 211; 
 944 : outdata = 313; 
 945 : outdata = 1021; 
 946 : outdata = 550; 
 947 : outdata = 328; 
 948 : outdata = 59; 
 949 : outdata = 53; 
 950 : outdata = 248; 
 951 : outdata = 535; 
 952 : outdata = 191; 
 953 : outdata = 331; 
 954 : outdata = 681; 
 955 : outdata = 421; 
 956 : outdata = 524; 
 957 : outdata = 429; 
 958 : outdata = 806; 
 959 : outdata = 269; 
 960 : outdata = 815; 
 961 : outdata = 836; 
 962 : outdata = 888; 
 963 : outdata = 602; 
 964 : outdata = 619; 
 965 : outdata = 391; 
 966 : outdata = 393; 
 967 : outdata = 435; 
 968 : outdata = 263; 
 969 : outdata = 880; 
 970 : outdata = 604; 
 971 : outdata = 577; 
 972 : outdata = 235; 
 973 : outdata = 795; 
 974 : outdata = 860; 
 975 : outdata = 57; 
 976 : outdata = 126; 
 977 : outdata = 25; 
 978 : outdata = 40; 
 979 : outdata = 422; 
 980 : outdata = 590; 
 981 : outdata = 622; 
 982 : outdata = 587; 
 983 : outdata = 247; 
 984 : outdata = 662; 
 985 : outdata = 842; 
 986 : outdata = 858; 
 987 : outdata = 538; 
 988 : outdata = 1011; 
 989 : outdata = 656; 
 990 : outdata = 106; 
 991 : outdata = 39; 
 992 : outdata = 745; 
 993 : outdata = 139; 
 994 : outdata = 575; 
 995 : outdata = 114; 
 996 : outdata = 641; 
 997 : outdata = 189; 
 998 : outdata = 782; 
 999 : outdata = 870; 
 1000 : outdata = 669; 
 1001 : outdata = 61; 
 1002 : outdata = 297; 
 1003 : outdata = 78; 
 1004 : outdata = 50; 
 1005 : outdata = 844; 
 1006 : outdata = 213; 
 1007 : outdata = 494; 
 1008 : outdata = 122; 
 1009 : outdata = 156; 
 1010 : outdata = 657; 
 1011 : outdata = 988; 
 1012 : outdata = 278; 
 1013 : outdata = 228; 
 1014 : outdata = 378; 
 1015 : outdata = 709; 
 1016 : outdata = 3; 
 1017 : outdata = 517; 
 1018 : outdata = 875; 
 1019 : outdata = 774; 
 1020 : outdata = 312; 
 1021 : outdata = 945; 
 1022 : outdata = 456; 
 1023 : outdata = 387; 
endcase
end

endmodule
