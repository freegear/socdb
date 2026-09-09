// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name        : MEABlock.v
// File Revision    : 1.0 
// Reveision history: 
//  ------------------------------------------------------------
//  Purpose         : Euclid Argorithm Block
// ==============================================================================
module MEABlock (
				RESETn, 
				CLK, 
				MEAStart, 
				SYND0, 
				SYND1, 
				SYND2, 
				SYND3,
				SYND4, 
				SYND5, 
				SYND6, 
				SYND7,
				EP0, 
				EP1, 
				EP2, 
				EP3, 
				EP4, 
				EV0,
				EV1, 
				EV2, 
				EV3, 
				EV4
		);

input RESETn;
input CLK;
input MEAStart;

input [9:0]	SYND0;
input [9:0]	SYND1;
input [9:0]	SYND2;
input [9:0]	SYND3;
input [9:0]	SYND4;
input [9:0]	SYND5;
input [9:0]	SYND6;
input [9:0]	SYND7;


output [9:0] EP0;
output [9:0] EP1;
output [9:0] EP2;
output [9:0] EP3;
output [9:0] EP4;

output [9:0] EV0;
output [9:0] EV1;
output [9:0] EV2;
output [9:0] EV3;
output [9:0] EV4;

reg [9:0]	Mue[4:0];
reg [9:0] lambda[4:0];

wire [9:0]	ErrorEven;
wire [9:0]	ErrorOdd;

reg [9:0] NextQ[7:0];
reg [9:0] NextR[8:0];
reg [9:0] Q[8:0];
reg [9:0] R[8:0];

wire [9:0] R_Value0;
wire [9:0] R_Value1;
wire [9:0] R_Value2;
wire [9:0] R_Value3;
wire [9:0] R_Value4;
wire [9:0] R_Value5;
wire [9:0] R_Value6;
wire [9:0] R_Value7;
wire [9:0] R_Value8;


wire [9:0] L_Value0;
wire [9:0] L_Value1;
wire [9:0] L_Value2;
wire [9:0] L_Value3;
wire [9:0] L_Value4;


reg [9:0] Nextlambda[4:0];
reg [9:0] NextMue[4:0];

reg [9:0] R_in[8:0];
reg [9:0] Q_in[8:0];
reg [9:0] lambda_in[4:0];
reg [9:0] mue_in[4:0];

// debug signal
//
//
wire [9:0] Q_sig0;
wire [9:0] Q_sig1;
wire [9:0] Q_sig2;
wire [9:0] Q_sig3;
wire [9:0] Q_sig4;
wire [9:0] Q_sig5;
wire [9:0] Q_sig6;
wire [9:0] Q_sig7;
wire [9:0] Q_sig8;
assign Q_sig0 = Q[0];
assign Q_sig1 = Q[1];
assign Q_sig2 = Q[2];
assign Q_sig3 = Q[3];
assign Q_sig4 = Q[4];
assign Q_sig5 = Q[5];
assign Q_sig6 = Q[6];
assign Q_sig7 = Q[7];
assign Q_sig8 = Q[8];
wire [9:0] R_sig0;
wire [9:0] R_sig1;
wire [9:0] R_sig2;
wire [9:0] R_sig3;
wire [9:0] R_sig4;
wire [9:0] R_sig5;
wire [9:0] R_sig6;
wire [9:0] R_sig7;
wire [9:0] R_sig8;
assign R_sig0 = R[0];
assign R_sig1 = R[1];
assign R_sig2 = R[2];
assign R_sig3 = R[3];
assign R_sig4 = R[4];
assign R_sig5 = R[5];
assign R_sig6 = R[6];
assign R_sig7 = R[7];
assign R_sig8 = R[8];

wire [9:0]	Mue_sig0;
wire [9:0]	Mue_sig1;
wire [9:0]	Mue_sig2;
wire [9:0]	Mue_sig3;
wire [9:0]	Mue_sig4;
assign Mue_sig0 = Mue[0];
assign Mue_sig1 = Mue[1];
assign Mue_sig2 = Mue[2];
assign Mue_sig3 = Mue[3];
assign Mue_sig4 = Mue[4];

wire [9:0]	lambda_sig0;
wire [9:0]	lambda_sig1;
wire [9:0]	lambda_sig2;
wire [9:0]	lambda_sig3;
wire [9:0]	lambda_sig4;
assign lambda_sig0 = lambda[0];
assign lambda_sig1 = lambda[1];
assign lambda_sig2 = lambda[2];
assign lambda_sig3 = lambda[3];
assign lambda_sig4 = lambda[4];

wire [9:0] NextQ_sig0;
wire [9:0] NextQ_sig1;
wire [9:0] NextQ_sig2;
wire [9:0] NextQ_sig3;
wire [9:0] NextQ_sig4;
wire [9:0] NextQ_sig5;
wire [9:0] NextQ_sig6;
wire [9:0] NextQ_sig7;
assign NextQ_sig0 =NextQ[0];
assign NextQ_sig1 =NextQ[1];
assign NextQ_sig2 =NextQ[2];
assign NextQ_sig3 =NextQ[3];
assign NextQ_sig4 =NextQ[4];
assign NextQ_sig5 =NextQ[5];
assign NextQ_sig6 =NextQ[6];
assign NextQ_sig7 =NextQ[7];

wire [9:0] NextR_sig0;
wire [9:0] NextR_sig1;
wire [9:0] NextR_sig2;
wire [9:0] NextR_sig3;
wire [9:0] NextR_sig4;
wire [9:0] NextR_sig5;
wire [9:0] NextR_sig6;
wire [9:0] NextR_sig7;
wire [9:0] NextR_sig8;
assign NextR_sig0 =NextR[0];
assign NextR_sig1 =NextR[1];
assign NextR_sig2 =NextR[2];
assign NextR_sig3 =NextR[3];
assign NextR_sig4 =NextR[4];
assign NextR_sig5 =NextR[5];
assign NextR_sig6 =NextR[6];
assign NextR_sig7 =NextR[7];
assign NextR_sig8 =NextR[8];


wire [9:0] Nextlambda_sig0;
wire [9:0] Nextlambda_sig1;
wire [9:0] Nextlambda_sig2;
wire [9:0] Nextlambda_sig3;
wire [9:0] Nextlambda_sig4;

assign Nextlambda_sig0 = Nextlambda[0];
assign Nextlambda_sig1 = Nextlambda[1];
assign Nextlambda_sig2 = Nextlambda[2];
assign Nextlambda_sig3 = Nextlambda[3];
assign Nextlambda_sig4 = Nextlambda[4];

wire [9:0] NextMue_sig0;
wire [9:0] NextMue_sig1;
wire [9:0] NextMue_sig2;
wire [9:0] NextMue_sig3;
wire [9:0] NextMue_sig4;

assign NextMue_sig0 = NextMue[0];
assign NextMue_sig1 = NextMue[1];
assign NextMue_sig2 = NextMue[2];
assign NextMue_sig3 = NextMue[3];
assign NextMue_sig4 = NextMue[4];


wire [9:0] R_in_sig0 = R_in[0];
wire [9:0] R_in_sig1 = R_in[1];
wire [9:0] R_in_sig2 = R_in[2];
wire [9:0] R_in_sig3 = R_in[3];
wire [9:0] R_in_sig4 = R_in[4];
wire [9:0] R_in_sig5 = R_in[5];
wire [9:0] R_in_sig6 = R_in[6];
wire [9:0] R_in_sig7 = R_in[7];
wire [9:0] R_in_sig8 = R_in[8];

wire [9:0] Q_in_sig0 = Q_in[0];
wire [9:0] Q_in_sig1 = Q_in[1];
wire [9:0] Q_in_sig2 = Q_in[2];
wire [9:0] Q_in_sig3 = Q_in[3];
wire [9:0] Q_in_sig4 = Q_in[4];
wire [9:0] Q_in_sig5 = Q_in[5];
wire [9:0] Q_in_sig6 = Q_in[6];
wire [9:0] Q_in_sig7 = Q_in[7];
wire [9:0] Q_in_sig8 = Q_in[8];



wire [9:0] lambda_in_sig0 = lambda_in[0];
wire [9:0] lambda_in_sig1 = lambda_in[1];
wire [9:0] lambda_in_sig2 = lambda_in[2];
wire [9:0] lambda_in_sig3 = lambda_in[3];
wire [9:0] lambda_in_sig4 = lambda_in[4];

wire [9:0] mue_in_sig0 = mue_in[0];
wire [9:0] mue_in_sig1 = mue_in[1];
wire [9:0] mue_in_sig2 = mue_in[2];
wire [9:0] mue_in_sig3 = mue_in[3];
wire [9:0] mue_in_sig4 = mue_in[4];


// test signal end



wire	CompR_Q;
wire [3:0] orderQ;
wire [3:0] orderR;
wire [3:0] orderL;
wire [3:0] orderM;
wire [9:0] R_val0_0;
wire [9:0] R_val0_1;

wire [9:0] R_val1_0;
wire [9:0] R_val1_1;

wire [9:0] R_val2_0;
wire [9:0] R_val2_1;

wire [9:0] R_val3_0;
wire [9:0] R_val3_1;

wire [9:0] R_val4_0;
wire [9:0] R_val4_1;

wire [9:0] R_val5_0;
wire [9:0] R_val5_1;

wire [9:0] R_val6_0;
wire [9:0] R_val6_1;

wire [9:0] R_val7_0;
wire [9:0] R_val7_1;

wire [9:0] R_val8_0;
wire [9:0] R_val8_1;

wire [9:0] L_val0_0;
wire [9:0] L_val0_1;

wire [9:0] L_val1_0;
wire [9:0] L_val1_1;

wire [9:0] L_val2_0;
wire [9:0] L_val2_1;

wire [9:0] L_val3_0;
wire [9:0] L_val3_1;

wire [9:0] L_val4_0;
wire [9:0] L_val4_1;

assign CompR_Q = (orderR >= orderQ)? 1: 0;  // Compare OrderR OrderQ

always @(SYND7 or SYND6 or SYND5 or SYND4 or
	   	SYND3 or SYND2 or SYND1 or SYND0 or 
		CompR_Q or Q[0] or Q[1] or Q[2] or Q[3] or 
		Q[4] or Q[5] or Q[6] or Q[7] or 
		R[0] or R[1] or R[2] or R[3] or R[4] or R[5] or R[6] or R[7] or MEAStart)
begin
		NextQ[7] = Q[7];
		NextQ[6] = Q[6];
		NextQ[5] = Q[5];
		NextQ[4] = Q[4];
		NextQ[3] = Q[3];
		NextQ[2] = Q[2];
		NextQ[1] = Q[1];
		NextQ[0] = Q[0];
	if (MEAStart) // MEA Start
		begin // Error 발생시 syndrom 값을 옮겨옴
		NextQ[7] = SYND7;	
		NextQ[6] = SYND6;	
		NextQ[5] = SYND5;	
		NextQ[4] = SYND4;	
		NextQ[3] = SYND3;	
		NextQ[2] = SYND2;	
		NextQ[1] = SYND1;	
		NextQ[0] = SYND0;	
		end
	else
		begin
			if (CompR_Q) // R의 차수가 더 크거나 같은 경우
			begin
			NextQ[7] = Q[7];
			NextQ[6] = Q[6];
			NextQ[5] = Q[5];
			NextQ[4] = Q[4];
			NextQ[3] = Q[3];
			NextQ[2] = Q[2];
			NextQ[1] = Q[1];
			NextQ[0] = Q[0];
			end
			else // Q의 차수가 더큰 경우
			begin
			NextQ[7] = R[7];
			NextQ[6] = R[6];
			NextQ[5] = R[5];
			NextQ[4] = R[4];
			NextQ[3] = R[3];
			NextQ[2] = R[2];
			NextQ[1] = R[1];
			NextQ[0] = R[0];
			end
		end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	Q[8] = 0;
	Q[7] = 0;
	Q[6] = 0;
	Q[5] = 0;
	Q[4] = 0;
	Q[3] = 0;
	Q[2] = 0;
	Q[1] = 0;
	Q[0] = 0;
	end
	else
	begin
	Q[8] = 10'd0;
	Q[7] = NextQ[7];
	Q[6] = NextQ[6];
	Q[5] = NextQ[5];
	Q[4] = NextQ[4];
	Q[3] = NextQ[3];
	Q[2] = NextQ[2];
	Q[1] = NextQ[1];
	Q[0] = NextQ[0];
	end
end
/////////////////////////////////////////////////////////////

always @(MEAStart or R_Value0 or R_Value1 or R_Value2 or R_Value3 or 
		R_Value4 or R_Value5 or R_Value6 or R_Value7 or R_Value8 or
		R[8] or R[7] or R[6] or R[5] or R[4] or R[3] or R[2] or R[1] or R[0])
begin
	NextR[8] = R[8];
	NextR[7] = R[7];
	NextR[6] = R[6];
	NextR[5] = R[5];
	NextR[4] = R[4];
	NextR[3] = R[3];
	NextR[2] = R[2];
	NextR[1] = R[1];
	NextR[0] = R[0];

	
	if (MEAStart) // MEA start
	begin
	NextR[8] = 1;
	NextR[7] = 0;
	NextR[6] = 0;
	NextR[5] = 0;
	NextR[4] = 0;
	NextR[3] = 0;
	NextR[2] = 0;
	NextR[1] = 0;
	NextR[0] = 0;
	end
	/*else if () // R 차수가 더 높을 경우 
	//R = BinMult(Q[OrderQ], R[j])^BinMult(R[OrderR], Q[j-(OrderR-OrderQ)])
	begin
	NextR[8] = ;
	NextR[7] = ;
	NextR[6] = ;
	NextR[5] = ;
	NextR[4] = ;
	NextR[3] = ;
	NextR[2] = ;
	NextR[1] = ;
	NextR[0] = ;
	end*/ 
	else  // Q의 차수가 더 높은 경우
//temp[j] = BinMult(R[OrderR],Q[j]) ^ BinMult(Q[OrderQ],R[j-(OrderQ-OrderR)]);
	begin
	NextR[8] = R_Value8;
	NextR[7] = R_Value7;
	NextR[6] = R_Value6;
	NextR[5] = R_Value5;
	NextR[4] = R_Value4;
	NextR[3] = R_Value3;
	NextR[2] = R_Value2;
	NextR[1] = R_Value1;
	NextR[0] = R_Value0;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	R[8] <=0;	R[7] <=0;	R[6] <=0;	R[5] <=0;
	R[4] <=0;	R[3] <=0;	R[2] <=0;	R[1] <=0;	R[0] <=0;
	end
	else
	begin
	R[8] <= NextR[8];	R[7] <= NextR[7];	R[6] <= NextR[6];
	R[5] <= NextR[5];	R[4] <= NextR[4];	R[3] <= NextR[3];
	R[2] <= NextR[2];	R[1] <= NextR[1];	R[0] <= NextR[0];
	end
end



always @(MEAStart or L_Value0 or L_Value1 or L_Value2 or L_Value3 or L_Value4 or
		lambda[4] or lambda[3] or lambda[2] or lambda[1] or lambda[0])
begin
	Nextlambda[4] = lambda[4];
	Nextlambda[3] = lambda[3];
	Nextlambda[2] = lambda[2];
	Nextlambda[1] = lambda[1];
	Nextlambda[0] = lambda[0];

	if (MEAStart) // MEA Start
	begin
	Nextlambda[4] = 0;
	Nextlambda[3] = 0;
	Nextlambda[2] = 0;
	Nextlambda[1] = 0;
	Nextlambda[0] = 0;
	end
/*	else if () // R 차수가 더 크거나 같은 경우
	begin
	Nextlambda[4] = ;
	Nextlambda[3] = ;
	Nextlambda[2] = ;
	Nextlambda[1] = ;
	Nextlambda[0] = ;
	end*/
	else // Q 차수가 더 높은 경우
	//BinMult(R[OrderR],mue[j]) ^ BinMult(Q[OrderQ],lambda[(j-(OrderQ - OrderR))]);
	begin
	Nextlambda[4] = L_Value4;
	Nextlambda[3] = L_Value3;
	Nextlambda[2] = L_Value2;
	Nextlambda[1] = L_Value1;
	Nextlambda[0] = L_Value0;
	end
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	/*lambda[7] = 0;	lambda[6] = 0;	lambda[5] = 0;*/
	lambda[4] = 0;	lambda[3] = 0;	lambda[2] = 0;
	lambda[1] = 0;	lambda[0] = 0;
	end
	else
	begin
	/*lambda[7] = Nextlambda[7];	lambda[6] = Nextlambda[6];	
	lambda[5] = Nextlambda[5];*/	lambda[4] = Nextlambda[4];	
	lambda[3] = Nextlambda[3];	lambda[2] = Nextlambda[2];	
	lambda[1] = Nextlambda[1];	lambda[0] = Nextlambda[0];
	end
end



always @(Mue[0] or Mue[1] or Mue[2] or Mue[3] or Mue[4] or 
		lambda[0] or lambda[1] or lambda[2] or lambda[3] or lambda[4] or MEAStart or
		Mue[4] or Mue[3] or Mue[2] or Mue[1] or Mue[0] or CompR_Q )
begin
	NextMue[4] = Mue[4];
	NextMue[3] = Mue[3];
	NextMue[2] = Mue[2];
	NextMue[1] = Mue[1];
	NextMue[0] = Mue[0];
	
	if (MEAStart) // MEA Start
	begin
	NextMue[4] = 0;
	NextMue[3] = 0;
	NextMue[2] = 0;
	NextMue[1] = 0;
	NextMue[0] = 1;
	end
	else if (CompR_Q) // R차수가 더 크거나 같은 경우
	begin
		NextMue[4] = Mue[4];
		NextMue[3] = Mue[3];
		NextMue[2] = Mue[2];
		NextMue[1] = Mue[1];
		NextMue[0] = Mue[0];
	end
	else 
	begin
		NextMue[4] = lambda[4];
		NextMue[3] = lambda[3];
		NextMue[2] = lambda[2];
		NextMue[1] = lambda[1];
		NextMue[0] = lambda[0];
	end
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	Mue[4] <= 0 ;	Mue[3] <= 0 ;	Mue[2] <= 0 ;	Mue[1] <= 0 ;	Mue[0] <= 0 ;
	end
	else
	begin
	Mue[4] <= NextMue[4];	Mue[3] <= NextMue[3];	
	Mue[2] <= NextMue[2];	Mue[1] <= NextMue[1];	Mue[0] <= NextMue[0];
	end
end





// R 차수가 더 높을 경우 
//R[j] = BinMult(Q[OrderQ], R[j])^
//	  BinMult(R[OrderR], Q[j-(OrderR-OrderQ)])
// Q의 차수가 더 높은 경우
//R[j] = BinMult(Q[OrderQ],R[j-(OrderQ-OrderR)])^
//			BinMult(R[OrderR],Q[j]) ^ 
//assign R_Value0 = R_val0_0^ R_val0_1 ;     
//BinMult10 RCAL0_0 (.indata1(Q[orderQ]), .indata2(R_in[0]), .outdata(R_val0_0));
//BinMult10 RCAL0_1 (.indata1(R[orderR]), .indata2(Q_in[0]), .outdata(R_val0_1));


always @(CompR_Q or R[0] or R[1] or R[2] or R[3] or 
		R[4] or R[5] or R[6] or R[7] or R[8] or orderR or orderQ )
begin
	if (CompR_Q)
	begin
		R_in[0] = R[0];
		R_in[1] = R[1];
		R_in[2] = R[2];
		R_in[3] = R[3];
		R_in[4] = R[4];
		R_in[5] = R[5];
		R_in[6] = R[6];
		R_in[7] = R[7];
		R_in[8] = R[8];
	end
	else
	begin
			if (0-(orderQ-orderR) ==0)
				R_in[0] = R[0];
			else
				R_in[0] = 0;
	
			if (1-(orderQ-orderR) >=0)
				R_in[1] = R[(1-(orderQ-orderR))];
			else
				R_in[1] = 0;

			if (2-(orderQ-orderR) >=0)
				R_in[2] = R[(2-(orderQ-orderR))];
			else
				R_in[2] = 0;

			if (3-(orderQ-orderR) >=0)
				R_in[3] = R[(3-(orderQ-orderR))];
			else
				R_in[3] = 0;

			if (4-(orderQ-orderR) >=0)
				R_in[4] = R[(4-(orderQ-orderR))];
			else
				R_in[4] = 0;
		
			if (5-(orderQ-orderR) >=0)
				R_in[5] = R[(5-(orderQ-orderR))];
			else
				R_in[5] = 0;

			if (6-(orderQ-orderR) >=0)
				R_in[6] = R[(6-(orderQ-orderR))];
			else
				R_in[6] = 0;

			if (7-(orderQ-orderR) >=0)
				R_in[7] = R[(7-(orderQ-orderR))];
			else
				R_in[7] = 0;
	
			if (8-(orderQ-orderR) >=0)
				R_in[8] = R[(8-(orderQ-orderR))];
			else
				R_in[8] = 0;
	end
end


always @(CompR_Q or Q[0] or Q[1] or Q[2] or Q[3] or Q[4] or Q[5] or Q[6] or Q[7] or Q[8] or orderR or orderQ )
begin
	if (CompR_Q)
	begin
			
		if (0-(orderR-orderQ) ==0)
			Q_in[0] = Q[0];
			else
			Q_in[0] = 0;

		if (1-(orderR-orderQ) >=0)
				Q_in[1] = Q[(1-(orderR-orderQ))];
			else
				Q_in[1] = 0;

		if (2-(orderR-orderQ) >=0)
				Q_in[2] = Q[(2-(orderR-orderQ))];
			else
				Q_in[2] = 0;

		if (3-(orderR-orderQ) >=0)
				Q_in[3] = Q[(3-(orderR-orderQ))];
			else
				Q_in[3] = 0;

		if (4-(orderR-orderQ) >=0)
				Q_in[4] = Q[(4-(orderR-orderQ))];
			else
				Q_in[4] = 0;

		if (5-(orderR-orderQ) >=0)
				Q_in[5] = Q[(5-(orderR-orderQ))];
			else
				Q_in[5] = 0;

		if (6-(orderR-orderQ) >=0)
				Q_in[6] = Q[(6-(orderR-orderQ))];
			else
				Q_in[6] = 0;

		if (7-(orderR-orderQ) >=0)
				Q_in[7] = Q[(7-(orderR-orderQ))];
			else
				Q_in[7] = 0;

		if (8-(orderR-orderQ) >=0)
				Q_in[8] = Q[(8-(orderR-orderQ))];
			else
				Q_in[8] = 0;

	end
	else
	begin
		Q_in[0] = Q[0];
		Q_in[1] = Q[1];
		Q_in[2] = Q[2];
		Q_in[3] = Q[3];
		Q_in[4] = Q[4];
		Q_in[5] = Q[5];
		Q_in[6] = Q[6];
		Q_in[7] = Q[7];
		Q_in[8] = Q[8];
	end
end


assign R_Value0 = R_val0_0^ R_val0_1 ;     
BinMult10 RCAL0_0 (.indata1(Q[orderQ]), .indata2(R_in[0]), .outdata(R_val0_0));
BinMult10 RCAL0_1 (.indata1(R[orderR]), .indata2(Q_in[0]), .outdata(R_val0_1));

assign R_Value1 = R_val1_0^ R_val1_1 ;     
BinMult10 RCAL1_0 (.indata1(Q[orderQ]), .indata2(R_in[1]), .outdata(R_val1_0));
BinMult10 RCAL1_1 (.indata1(R[orderR]), .indata2(Q_in[1]), .outdata(R_val1_1));

assign R_Value2 = R_val2_0^ R_val2_1 ;     
BinMult10 RCAL2_0 (.indata1(Q[orderQ]), .indata2(R_in[2]), .outdata(R_val2_0));
BinMult10 RCAL2_1 (.indata1(R[orderR]), .indata2(Q_in[2]), .outdata(R_val2_1));

assign R_Value3 = R_val3_0^ R_val3_1 ;     
BinMult10 RCAL3_0 (.indata1(Q[orderQ]), .indata2(R_in[3]), .outdata(R_val3_0));
BinMult10 RCAL3_1 (.indata1(R[orderR]), .indata2(Q_in[3]), .outdata(R_val3_1));

assign R_Value4 = R_val4_0^ R_val4_1 ;     
BinMult10 RCAL4_0 (.indata1(Q[orderQ]), .indata2(R_in[4]), .outdata(R_val4_0));
BinMult10 RCAL4_1 (.indata1(R[orderR]), .indata2(Q_in[4]), .outdata(R_val4_1));

assign R_Value5 = R_val5_0^ R_val5_1 ;    
BinMult10 RCAL5_0 (.indata1(Q[orderQ]), .indata2(R_in[5]), .outdata(R_val5_0));
BinMult10 RCAL5_1 (.indata1(R[orderR]), .indata2(Q_in[5]), .outdata(R_val5_1));

assign R_Value6 = R_val6_0^ R_val6_1 ;     
BinMult10 RCAL6_0 (.indata1(Q[orderQ]), .indata2(R_in[6]), .outdata(R_val6_0));
BinMult10 RCAL6_1 (.indata1(R[orderR]), .indata2(Q_in[6]), .outdata(R_val6_1));

assign R_Value7 = R_val7_0^ R_val7_1 ;     
BinMult10 RCAL7_0 (.indata1(Q[orderQ]), .indata2(R_in[7]), .outdata(R_val7_0));
BinMult10 RCAL7_1 (.indata1(R[orderR]), .indata2(Q_in[7]), .outdata(R_val7_1));

assign R_Value8 = R_val8_0^ R_val8_1 ;     
BinMult10 RCAL8_0 (.indata1(Q[orderQ]), .indata2(R_in[8]), .outdata(R_val8_0));
BinMult10 RCAL8_1 (.indata1(R[orderR]), .indata2(Q_in[8]), .outdata(R_val8_1));


// R차수가 더 높을 때
//lambda[j] = BinMult(Q[OrderQ], lambda[j])^BinMult(R[OrderR], mue[j-(OrderR-OrderQ)]) ;
// Q차수가 더 높을 때
//lambda[j] = BinMult(Q[OrderQ],lambda[(j-(OrderQ - OrderR))]) ^ BinMult(R[OrderR],mue[j]) ^;	
//


always @(CompR_Q or lambda[0] or lambda[1] or lambda[2] or 
		lambda[3] or lambda[4] or orderQ or orderR )
begin
	if (CompR_Q)
	begin
	lambda_in[0] = lambda[0];
	lambda_in[1] = lambda[1];
	lambda_in[2] = lambda[2];
	lambda_in[3] = lambda[3];
	lambda_in[4] = lambda[4];
	end
	else
	begin

		if (0-(orderQ-orderR) ==0)
			lambda_in[0] = lambda[0];
		else
			lambda_in[0] = 0;

		if (1-(orderQ-orderR) >=0)
			lambda_in[1] = lambda[(1-(orderQ-orderR))];
		else
			lambda_in[1] = 0;

		if (2-(orderQ-orderR) >=0)
			lambda_in[2] = lambda[(2-(orderQ-orderR))];
		else
			lambda_in[2] = 0;

		if (3-(orderQ-orderR) >=0)
			lambda_in[3] = lambda[(3-(orderQ-orderR))];
		else
			lambda_in[3] = 0;

		if (4-(orderQ-orderR) >=0)
			lambda_in[4] = lambda[(4-(orderQ-orderR))];
		else
			lambda_in[4] = 0;
	end

end


always @(CompR_Q or Mue[0] or Mue[1] or Mue[2] or Mue[3] or Mue[4] or orderR or orderQ)
begin
	if (CompR_Q)// R차수가 높거나 같은 경우
	begin
		if (0-(orderR-orderQ) ==0)
			mue_in[0] = Mue[0];
		else
			mue_in[0] = 0;

		if (1-(orderR-orderQ) >=0)
			mue_in[1] = Mue[(1-(orderR-orderQ))];
		else
			mue_in[1] = 0;
		
		if (2-(orderR-orderQ) >=0)
			mue_in[2] = Mue[(2-(orderR-orderQ))];
		else
			mue_in[2] = 0;

		if (3-(orderR-orderQ) >=0)
			mue_in[3] = Mue[(3-(orderR-orderQ))];
		else
			mue_in[3] = 0;

		if (4-(orderR-orderQ) >=0)
			mue_in[4] = Mue[(4-(orderR-orderQ))];
		else
			mue_in[4] = 0;
	end
	else
	begin
	mue_in[0] = Mue[0];
	mue_in[1] = Mue[1];
	mue_in[2] = Mue[2];
	mue_in[3] = Mue[3];
	mue_in[4] = Mue[4];
	end
end

 assign L_Value0 = L_val0_0 ^ L_val0_1;
 BinMult10 LCAL0_0 (.indata1(Q[orderQ]), .indata2(lambda_in[0]), .outdata(L_val0_0));
 BinMult10 LCAL0_1 (.indata1(R[orderR]), .indata2(mue_in[0]), .outdata(L_val0_1));

 assign L_Value1 = L_val1_0 ^ L_val1_1;
 BinMult10 LCAL1_0 (.indata1(Q[orderQ]), .indata2(lambda_in[1]), .outdata(L_val1_0));
 BinMult10 LCAL1_1 (.indata1(R[orderR]), .indata2(mue_in[1]), .outdata(L_val1_1));

 assign L_Value2 = L_val2_0 ^ L_val2_1;
 BinMult10 LCAL2_0 (.indata1(Q[orderQ]), .indata2(lambda_in[2]), .outdata(L_val2_0));
 BinMult10 LCAL2_1 (.indata1(R[orderR]), .indata2(mue_in[2]), .outdata(L_val2_1));

 assign L_Value3 = L_val3_0 ^ L_val3_1;
 BinMult10 LCAL3_0 (.indata1(Q[orderQ]), .indata2(lambda_in[3]), .outdata(L_val3_0));
 BinMult10 LCAL3_1 (.indata1(R[orderR]), .indata2(mue_in[3]), .outdata(L_val3_1));

 assign L_Value4 = L_val4_0 ^ L_val4_1;
 BinMult10 LCAL4_0 (.indata1(Q[orderQ]), .indata2(lambda_in[4]), .outdata(L_val4_0));
 BinMult10 LCAL4_1 (.indata1(R[orderR]), .indata2(mue_in[4]), .outdata(L_val4_1));

/*
 assign L_Value[5] = L_val5_0 ^ L_val5_1;
 BinMult LCAL5_0 (.indata1(Q[orderQ]), .indata2(), .outdta(L_val5_0));
 BinMult LCAL5_1 (.indata1(Q[orderQ]), .indata2(), .outdta(L_val5_1));

 assign L_Value[6] = L_val6_0 ^ L_val6_1;
 BinMult LCAL6_0 (.indata1(Q[orderQ]), .indata2(), .outdta(L_val6_0));
 BinMult LCAL6_1 (.indata1(Q[orderQ]), .indata2(), .outdta(L_val1));

 assign L_Value[7] = L_val7_0 ^ L_val7_1;
 BinMult LCAL7_0 (.indata1(Q[orderQ]), .indata2(), .outdta(L_val7_0));
 BinMult LCAL7_1 (.indata1(Q[orderQ]), .indata2(), .outdta(L_val7_1));
*/

// polynomial order calculation 






assign EP0= Mue[0];
assign EP1= Mue[1];
assign EP2= Mue[2];
assign EP3= Mue[3];
assign EP4= Mue[4];
assign EV0= lambda[0];
assign EV1= lambda[1];
assign EV2= lambda[2];
assign EV3= lambda[3];
assign EV4= lambda[4];

order8 ordQ(
			.indata1(Q[1]),
			.indata2(Q[2]),
			.indata3(Q[3]),
			.indata4(Q[4]),
			.indata5(Q[5]),
			.indata6(Q[6]),
			.indata7(Q[7]),
			.indata8(0),
			.outdata(orderQ));

order8 ordR(
			.indata1(R[1]),
			.indata2(R[2]),
			.indata3(R[3]),
			.indata4(R[4]),
			.indata5(R[5]),
			.indata6(R[6]),
			.indata7(R[7]),
			.indata8(R[8]),
			.outdata(orderR)
			);
order8 ordL(
			.indata1(lambda[1]),
			.indata2(lambda[2]),
			.indata3(lambda[3]),
			.indata4(lambda[4]),
			.indata5(0),
			.indata6(0),
			.indata7(0),
			.indata8(0),
			.outdata(orderL)
			);
order8 ordM(
			.indata1(Mue[1]), 	
			.indata2(Mue[2]), 	
			.indata3(Mue[3]), 	
			.indata4(Mue[4]), 	
			.indata5(0), 	
			.indata6(0), 	
			.indata7(0), 	
			.indata8(0), 	
			.outdata(orderM)
			);

endmodule


// 차수 계산
module order8(
				indata1 , 
				indata2 , 
				indata3 , 
				indata4 , 
				indata5 , 
				indata6 , 
				indata7 , 
				indata8 , 
				outdata);

input [9:0]		indata1;
input [9:0]		indata2;
input [9:0]		indata3;
input [9:0]		indata4;
input [9:0]		indata5;
input [9:0]		indata6;
input [9:0]		indata7;
input [9:0]		indata8;
output [3:0]	outdata;

reg [3:0] outdata;


always @(indata1 or indata2 or indata3 or indata4 or indata5 or indata6 or indata7 or indata8)
begin
	if (indata8)
		outdata = 8;
	else if (indata7)
		outdata = 7;
	else if (indata6)
		outdata = 6;
	else if (indata5)
		outdata = 5;
	else if (indata4)
		outdata = 4;
	else if (indata3)
		outdata = 3;
	else if (indata2)
		outdata = 2;
	else if (indata1)
		outdata = 1;
	else 
		outdata = 0;
	
end

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










