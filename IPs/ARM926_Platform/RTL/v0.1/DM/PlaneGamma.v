
module PlaneGamma( Clk, nRST, GammaEn, 
			RegGamma10, RegGamma0F, RegGamma0E, RegGamma0D, RegGamma0C, 
		 	RegGamma0B, RegGamma0A, RegGamma09, RegGamma08, 
		 	RegGamma07, RegGamma06, RegGamma05, RegGamma04, 
		 	RegGamma03, RegGamma02, RegGamma01, RegGamma00,
		 	
		 	GammaValidIn,  RGammaIn,  GGammaIn,  BGammaIn,
		 	GammaValidOut, RGammaOut, GGammaOut, BGammaOut
);

input Clk, nRST, GammaEn;
input [23:0] RegGamma10, RegGamma0F, RegGamma0E, RegGamma0D, RegGamma0C; 
input [23:0] RegGamma0B, RegGamma0A, RegGamma09, RegGamma08; 
input [23:0] RegGamma07, RegGamma06, RegGamma05, RegGamma04; 
input [23:0] RegGamma03, RegGamma02, RegGamma01, RegGamma00;

input		 GammaValidIn;
input  [7:0] RGammaIn;
input  [7:0] GGammaIn;
input  [7:0] BGammaIn;
output		 GammaValidOut;
output [7:0] RGammaOut;
output [7:0] GGammaOut;
output [7:0] BGammaOut;

reg		  GammaValidOut;
reg [7:0] RGammaLUT[0:16];
reg [7:0] GGammaLUT[0:16];
reg [7:0] BGammaLUT[0:16];

always @(RegGamma10 or RegGamma0F or RegGamma0E or RegGamma0D or RegGamma0C or 
		 RegGamma0B or RegGamma0A or RegGamma09 or RegGamma08 or 
		 RegGamma07 or RegGamma06 or RegGamma05 or RegGamma04 or 
		 RegGamma03 or RegGamma02 or RegGamma01 or RegGamma00)
begin
	RGammaLUT[16] = RegGamma10[23:16]; GGammaLUT[16] = RegGamma10[15: 8]; BGammaLUT[16] = RegGamma10[ 7: 0];
	RGammaLUT[15] = RegGamma0F[23:16]; GGammaLUT[15] = RegGamma0F[15: 8]; BGammaLUT[15] = RegGamma0F[ 7: 0];
	RGammaLUT[14] = RegGamma0E[23:16]; GGammaLUT[14] = RegGamma0E[15: 8]; BGammaLUT[14] = RegGamma0E[ 7: 0];
	RGammaLUT[13] = RegGamma0D[23:16]; GGammaLUT[13] = RegGamma0D[15: 8]; BGammaLUT[13] = RegGamma0D[ 7: 0];
	RGammaLUT[12] = RegGamma0C[23:16]; GGammaLUT[12] = RegGamma0C[15: 8]; BGammaLUT[12] = RegGamma0C[ 7: 0];
	RGammaLUT[11] = RegGamma0B[23:16]; GGammaLUT[11] = RegGamma0B[15: 8]; BGammaLUT[11] = RegGamma0B[ 7: 0];
	RGammaLUT[10] = RegGamma0A[23:16]; GGammaLUT[10] = RegGamma0A[15: 8]; BGammaLUT[10] = RegGamma0A[ 7: 0];
	RGammaLUT[9]  = RegGamma09[23:16]; GGammaLUT[9]  = RegGamma09[15: 8]; BGammaLUT[9]  = RegGamma09[ 7: 0];
	RGammaLUT[8]  = RegGamma08[23:16]; GGammaLUT[8]  = RegGamma08[15: 8]; BGammaLUT[8]  = RegGamma08[ 7: 0];
	RGammaLUT[7]  = RegGamma07[23:16]; GGammaLUT[7]  = RegGamma07[15: 8]; BGammaLUT[7]  = RegGamma07[ 7: 0];
	RGammaLUT[6]  = RegGamma06[23:16]; GGammaLUT[6]  = RegGamma06[15: 8]; BGammaLUT[6]  = RegGamma06[ 7: 0];
	RGammaLUT[5]  = RegGamma05[23:16]; GGammaLUT[5]  = RegGamma05[15: 8]; BGammaLUT[5]  = RegGamma05[ 7: 0];
	RGammaLUT[4]  = RegGamma04[23:16]; GGammaLUT[4]  = RegGamma04[15: 8]; BGammaLUT[4]  = RegGamma04[ 7: 0];
	RGammaLUT[3]  = RegGamma03[23:16]; GGammaLUT[3]  = RegGamma03[15: 8]; BGammaLUT[3]  = RegGamma03[ 7: 0];
	RGammaLUT[2]  = RegGamma02[23:16]; GGammaLUT[2]  = RegGamma02[15: 8]; BGammaLUT[2]  = RegGamma02[ 7: 0];
	RGammaLUT[1]  = RegGamma01[23:16]; GGammaLUT[1]  = RegGamma01[15: 8]; BGammaLUT[1]  = RegGamma01[ 7: 0];
	RGammaLUT[0]  = RegGamma00[23:16]; GGammaLUT[0]  = RegGamma00[15: 8]; BGammaLUT[0]  = RegGamma00[ 7: 0];
end

//wire [7:0] RGammaOut = (RGammaLUT[RGammaIn[7:4]] + (RGammaLUT[RGammaIn[7:4]+1] - (RGammaLUT[RGammaIn[7:4]])/16)*RGammaIn[3:0]
//						Always Greater
wire [7:0] debug1 = RGammaLUT[RGammaIn[7:4]+1] - RGammaLUT[RGammaIn[7:4]];
wire [7:0] debug2 = RGammaLUT[RGammaIn[3:0]];

wire [11:0] RGammaAx    = GammaEn ? (RGammaLUT[RGammaIn[7:4]+1] - (RGammaLUT[RGammaIn[7:4]]) * RGammaIn[3:0]) : 0;
wire [11:0] GGammaAx    = GammaEn ? (GGammaLUT[GGammaIn[7:4]+1] - (GGammaLUT[GGammaIn[7:4]]) * GGammaIn[3:0]) : 0;
wire [11:0] BGammaAx    = GammaEn ? (BGammaLUT[BGammaIn[7:4]+1] - (BGammaLUT[BGammaIn[7:4]]) * BGammaIn[3:0]) : 0;

// Multiply Result(Upper 8)
wire [ 7:0] RGammaAxMul = RGammaAx[11:4];
wire [ 7:0] GGammaAxMul = GGammaAx[11:4];
wire [ 7:0] BGammaAxMul = BGammaAx[11:4];

// Divide by 16, Right Shift 4
wire [ 7:0] RGammaAxD16 = ({4'b0, RGammaAxMul[7:4]});
wire [ 7:0] GGammaAxD16 = ({4'b0, GGammaAxMul[7:4]});
wire [ 7:0] BGammaAxD16 = ({4'b0, BGammaAxMul[7:4]});

wire [ 8:0] RGammaOutAx = GammaEn ? (RGammaLUT[RGammaIn[7:4]] + RGammaAxD16): 0;
wire [ 8:0] GGammaOutAx = GammaEn ? (GGammaLUT[GGammaIn[7:4]] + GGammaAxD16): 0;
wire [ 8:0] BGammaOutAx = GammaEn ? (BGammaLUT[BGammaIn[7:4]] + BGammaAxD16): 0;

reg  [ 7:0] RGammaOut;
reg  [ 7:0] GGammaOut;
reg  [ 7:0] BGammaOut;
always @(negedge nRST or posedge Clk)
	if (!nRST)  begin
				RGammaOut <= 0;
				GGammaOut <= 0;
				BGammaOut <= 0;
				GammaValidOut <= 0;
	end
	else  begin
		if (GammaEn) begin // if OverFlow
				RGammaOut <= RGammaOutAx[8] ? 8'hff : RGammaOutAx[7:0];
				GGammaOut <= GGammaOutAx[8] ? 8'hff : GGammaOutAx[7:0];
				BGammaOut <= BGammaOutAx[8] ? 8'hff : BGammaOutAx[7:0];
		end
		else begin
				RGammaOut <= RGammaIn;
				GGammaOut <= GGammaIn;
				BGammaOut <= BGammaIn;
		end
				GammaValidOut <= GammaValidIn;
	end

endmodule