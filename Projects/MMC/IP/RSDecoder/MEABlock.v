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
				EV4,
				//MEA_Ing,
				CSearchStart	);

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

//output		MEA_Ing;
output		CSearchStart;

//reg	[9:0]	Mue[4:0];

reg [9:0]	Mue4;
reg [9:0]	Mue3;
reg [9:0]	Mue2;
reg [9:0]	Mue1;
reg [9:0]	Mue0;

//reg [9:0] lambda[4:0];
reg [9:0] lambda4;
reg [9:0] lambda3;
reg [9:0] lambda2;
reg [9:0] lambda1;
reg [9:0] lambda0;

wire [9:0]	ErrorEven;
wire [9:0]	ErrorOdd;

/*reg [9:0] NextQ[7:0];
reg [9:0] NextR[8:0];
reg [9:0] Q[8:0];
reg [9:0] R[8:0];
*/

reg [9:0] NextQ7;
reg [9:0] NextQ6;
reg [9:0] NextQ5;
reg [9:0] NextQ4;
reg [9:0] NextQ3;
reg [9:0] NextQ2;
reg [9:0] NextQ1;
reg [9:0] NextQ0;

reg [9:0] NextR8;
reg [9:0] NextR7;
reg [9:0] NextR6;
reg [9:0] NextR5;
reg [9:0] NextR4;
reg [9:0] NextR3;
reg [9:0] NextR2;
reg [9:0] NextR1;
reg [9:0] NextR0;

reg [9:0] Q8;
reg [9:0] Q7;
reg [9:0] Q6;
reg [9:0] Q5;
reg [9:0] Q4;
reg [9:0] Q3;
reg [9:0] Q2;
reg [9:0] Q1;
reg [9:0] Q0;
reg [9:0] R8;
reg [9:0] R7;
reg [9:0] R6;
reg [9:0] R5;
reg [9:0] R4;
reg [9:0] R3;
reg [9:0] R2;
reg [9:0] R1;
reg [9:0] R0;

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

/*
reg [9:0] Nextlambda[4:0];
reg [9:0] NextMue[4:0];

reg [9:0] R_in[8:0];
reg [9:0] Q_in[8:0];
reg [9:0] lambda_in[4:0];
reg [9:0] mue_in[4:0];*/

reg [9:0] Nextlambda4;
reg [9:0] Nextlambda3;
reg [9:0] Nextlambda2;
reg [9:0] Nextlambda1;
reg [9:0] Nextlambda0;
reg [9:0] NextMue4;
reg [9:0] NextMue3;
reg [9:0] NextMue2;
reg [9:0] NextMue1;
reg [9:0] NextMue0;

reg [9:0] R_in8;
reg [9:0] R_in7;
reg [9:0] R_in6;
reg [9:0] R_in5;
reg [9:0] R_in4;
reg [9:0] R_in3;
reg [9:0] R_in2;
reg [9:0] R_in1;
reg [9:0] R_in0;

reg [9:0] Q_in8;
reg [9:0] Q_in7;
reg [9:0] Q_in6;
reg [9:0] Q_in5;
reg [9:0] Q_in4;
reg [9:0] Q_in3;
reg [9:0] Q_in2;
reg [9:0] Q_in1;
reg [9:0] Q_in0;
reg [9:0] lambda_in4;
reg [9:0] lambda_in3;
reg [9:0] lambda_in2;
reg [9:0] lambda_in1;
reg [9:0] lambda_in0;
reg [9:0] mue_in4;
reg [9:0] mue_in3;
reg [9:0] mue_in2;
reg [9:0] mue_in1;
reg [9:0] mue_in0;

// debug signal
//
//
/*
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
*/
/*
wire [9:0] R_in_sig0 = R_in[0];
wire [9:0] R_in_sig1 = R_in[1];
wire [9:0] R_in_sig2 = R_in[2];
wire [9:0] R_in_sig3 = R_in[3];
wire [9:0] R_in_sig4 = R_in[4];
wire [9:0] R_in_sig5 = R_in[5];
wire [9:0] R_in_sig6 = R_in[6];
wire [9:0] R_in_sig7 = R_in[7];
wire [9:0] R_in_sig8 = R_in[8];
*/
/*
wire [9:0] Q_in_sig0 = Q_in[0];
wire [9:0] Q_in_sig1 = Q_in[1];
wire [9:0] Q_in_sig2 = Q_in[2];
wire [9:0] Q_in_sig3 = Q_in[3];
wire [9:0] Q_in_sig4 = Q_in[4];
wire [9:0] Q_in_sig5 = Q_in[5];
wire [9:0] Q_in_sig6 = Q_in[6];
wire [9:0] Q_in_sig7 = Q_in[7];
wire [9:0] Q_in_sig8 = Q_in[8];
*/

/*
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
*/

// test signal end



wire	CompR_Q;
wire [3:0] orderQ;
wire [3:0] orderR;
reg  [3:0] orderL;
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
		CompR_Q or Q0 or Q1 or Q2 or Q3 or 
		Q4 or Q5 or Q6 or Q7 or 
		R0 or R1 or R2 or R3 or R4 or R5 or R6 or R7 or MEAStart)
begin
		NextQ7 = Q7;
		NextQ6 = Q6;
		NextQ5 = Q5;
		NextQ4 = Q4;
		NextQ3 = Q3;
		NextQ2 = Q2;
		NextQ1 = Q1;
		NextQ0 = Q0;
	if (MEAStart) // MEA Start
		begin // Error 발생시 syndrom 값을 옮겨옴
		NextQ7 = SYND7;	
		NextQ6 = SYND6;	
		NextQ5 = SYND5;	
		NextQ4 = SYND4;	
		NextQ3 = SYND3;	
		NextQ2 = SYND2;	
		NextQ1 = SYND1;	
		NextQ0 = SYND0;	
		end
	else
		begin
			if (CompR_Q) // R의 차수가 더 크거나 같은 경우
			begin
			NextQ7 = Q7;
			NextQ6 = Q6;
			NextQ5 = Q5;
			NextQ4 = Q4;
			NextQ3 = Q3;
			NextQ2 = Q2;
			NextQ1 = Q1;
			NextQ0 = Q0;
			end
			else // Q의 차수가 더큰 경우
			begin
			NextQ7 = R7;
			NextQ6 = R6;
			NextQ5 = R5;
			NextQ4 = R4;
			NextQ3 = R3;
			NextQ2 = R2;
			NextQ1 = R1;
			NextQ0 = R0;
			end
		end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	Q8 <= 0;
	Q7 <= 0;
	Q6 <= 0;
	Q5 <= 0;
	Q4 <= 0;
	Q3 <= 0;
	Q2 <= 0;
	Q1 <= 0;
	Q0 <= 0;
	end
	else
	begin
	Q8 <= 10'd0;
	Q7 <= NextQ7;
	Q6 <= NextQ6;
	Q5 <= NextQ5;
	Q4 <= NextQ4;
	Q3 <= NextQ3;
	Q2 <= NextQ2;
	Q1 <= NextQ1;
	Q0 <= NextQ0;
	end
end
/////////////////////////////////////////////////////////////

always @(MEAStart or R_Value0 or R_Value1 or R_Value2 or R_Value3 or 
		R_Value4 or R_Value5 or R_Value6 or R_Value7 or R_Value8 or
		R8 or R7 or R6 or R5 or R4 or R3 or R2 or R1 or R0)
begin
	NextR8 = R8;
	NextR7 = R7;
	NextR6 = R6;
	NextR5 = R5;
	NextR4 = R4;
	NextR3 = R3;
	NextR2 = R2;
	NextR1 = R1;
	NextR0 = R0;

	
	if (MEAStart) // MEA start
	begin
	NextR8 = 1;
	NextR7 = 0;
	NextR6 = 0;
	NextR5 = 0;
	NextR4 = 0;
	NextR3 = 0;
	NextR2 = 0;
	NextR1 = 0;
	NextR0 = 0;
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
	NextR8 = R_Value8;
	NextR7 = R_Value7;
	NextR6 = R_Value6;
	NextR5 = R_Value5;
	NextR4 = R_Value4;
	NextR3 = R_Value3;
	NextR2 = R_Value2;
	NextR1 = R_Value1;
	NextR0 = R_Value0;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	R8 <=0;	R7 <=0;	R6 <=0;	R5 <=0;
	R4 <=0;	R3 <=0;	R2 <=0;	R1 <=0;	R0 <=0;
	end
	else
	begin
	R8 <= NextR8;	R7 <= NextR7;	R6 <= NextR6;
	R5 <= NextR5;	R4 <= NextR4;	R3 <= NextR3;
	R2 <= NextR2;	R1 <= NextR1;	R0 <= NextR0;
	end
end



always @(MEAStart or L_Value0 or L_Value1 or L_Value2 or L_Value3 or L_Value4 or
		lambda4 or lambda3 or lambda2 or lambda1 or lambda0)
begin
	Nextlambda4 = lambda4;
	Nextlambda3 = lambda3;
	Nextlambda2 = lambda2;
	Nextlambda1 = lambda1;
	Nextlambda0 = lambda0;

	if (MEAStart) // MEA Start
	begin
	Nextlambda4 = 0;
	Nextlambda3 = 0;
	Nextlambda2 = 0;
	Nextlambda1 = 0;
	Nextlambda0 = 0;
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
	Nextlambda4 = L_Value4;
	Nextlambda3 = L_Value3;
	Nextlambda2 = L_Value2;
	Nextlambda1 = L_Value1;
	Nextlambda0 = L_Value0;
	end
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	/*lambda[7] = 0;	lambda[6] = 0;	lambda[5] = 0;*/
	lambda4 <= 0;	lambda3 <= 0;	lambda2 <= 0;
	lambda1 <= 0;	lambda0 <= 0;
	end
	else
	begin
	/*lambda[7] = Nextlambda[7];	lambda[6] = Nextlambda[6];	
	lambda[5] = Nextlambda[5];*/	lambda4 <= Nextlambda4;	
	lambda3 <= Nextlambda3;	lambda2 <= Nextlambda2;	
	lambda1 <= Nextlambda1;	lambda0 <= Nextlambda0;
	end
end



always @(Mue0 or Mue1 or Mue2 or Mue3 or Mue4 or 
		lambda0 or lambda1 or lambda2 or lambda3 or lambda4 or MEAStart or
		Mue4 or Mue3 or Mue2 or Mue1 or Mue0 or CompR_Q )
begin
	NextMue4 = Mue4;
	NextMue3 = Mue3;
	NextMue2 = Mue2;
	NextMue1 = Mue1;
	NextMue0 = Mue0;
	
	if (MEAStart) // MEA Start
	begin
	NextMue4 = 0;
	NextMue3 = 0;
	NextMue2 = 0;
	NextMue1 = 0;
	NextMue0 = 1;
	end
	else if (CompR_Q) // R차수가 더 크거나 같은 경우
	begin
		NextMue4 = Mue4;
		NextMue3 = Mue3;
		NextMue2 = Mue2;
		NextMue1 = Mue1;
		NextMue0 = Mue0;
	end
	else 
	begin
		NextMue4 = lambda4;
		NextMue3 = lambda3;
		NextMue2 = lambda2;
		NextMue1 = lambda1;
		NextMue0 = lambda0;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	Mue4 <= 0 ;
	Mue3 <= 0 ;	
	Mue2 <= 0 ;	
	Mue1 <= 0 ;	
	Mue0 <= 0 ;
	end
	else
	begin
	Mue4 <= NextMue4;
	Mue3 <= NextMue3;	
	Mue2 <= NextMue2;
	Mue1 <= NextMue1;
	Mue0 <= NextMue0;
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


always @(CompR_Q or R0 or R1 or R2 or R3 or 
		R4 or R5 or R6 or R7 or R8 or orderR or orderQ )
begin
	if (CompR_Q)
	begin
		R_in0 = R0;
		R_in1 = R1;
		R_in2 = R2;
		R_in3 = R3;
		R_in4 = R4;
		R_in5 = R5;
		R_in6 = R6;
		R_in7 = R7;
		R_in8 = R8;
	end
	else
	begin
			if (0-(orderQ-orderR) ==0)
				R_in0 = R0;
			else
				R_in0 = 0;
	
			if (1-(orderQ-orderR) >=0)
				begin
				if (1-(orderQ-orderR) ==0)
//				R_in1 = R[(1-(orderQ-orderR))];
				R_in1 = R0;
				else if (1-(orderQ-orderR) ==1)
				R_in1 = R1; 
				else if (1-(orderQ-orderR) ==2)
				R_in1 = R2; 
				else if (1-(orderQ-orderR) ==3)
				R_in1 = R3; 
				else if (1-(orderQ-orderR) ==4)
				R_in1 = R4; 
				else if (1-(orderQ-orderR) ==5)
				R_in1 = R5; 
				else if (1-(orderQ-orderR) ==6)
				R_in1 = R6; 
				else if (1-(orderQ-orderR) ==7)
				R_in1 = R7; 
				else if (1-(orderQ-orderR) ==8)
				R_in1 = R8; 
				end
			else
				R_in1 = 0;

			if (2-(orderQ-orderR) >=0)
				begin
//				R_in2 = R[(2-(orderQ-orderR))];
				if (1-(orderQ-orderR) ==0)
				R_in2 = R0;
				else if (1-(orderQ-orderR) ==1)
				R_in2 = R1;                    
				else if (1-(orderQ-orderR) ==2)
				R_in2 = R2;                    
				else if (1-(orderQ-orderR) ==3)
				R_in2 = R3;                    
				else if (1-(orderQ-orderR) ==4)
				R_in2 = R4;                    
				else if (1-(orderQ-orderR) ==5)
				R_in2 = R5;                    
				else if (1-(orderQ-orderR) ==6)
				R_in2 = R6;                    
				else if (1-(orderQ-orderR) ==7)
				R_in2 = R7;                    
				else if (1-(orderQ-orderR) ==8)
				R_in2 = R8;
				end
			else
				R_in2 = 0;

			if (3-(orderQ-orderR) >=0)
				begin
//				R_in3 = R[(3-(orderQ-orderR))];
				if (1-(orderQ-orderR) ==0)
				R_in3 = R0;
				else if (1-(orderQ-orderR) ==1)
				R_in3 = R1;                    
				else if (1-(orderQ-orderR) ==2)
				R_in3 = R2;                    
				else if (1-(orderQ-orderR) ==3)
				R_in3 = R3;                    
				else if (1-(orderQ-orderR) ==4)
				R_in3 = R4;                    
				else if (1-(orderQ-orderR) ==5)
				R_in3 = R5;                    
				else if (1-(orderQ-orderR) ==6)
				R_in3 = R6;                    
				else if (1-(orderQ-orderR) ==7)
				R_in3 = R7;                    
				else if (1-(orderQ-orderR) ==8)
				R_in3 = R8;
				end
			else
				R_in3 = 0;

			if (4-(orderQ-orderR) >=0)
				begin
//		R_in4 = R[(4-(orderQ-orderR))];
				if (1-(orderQ-orderR) ==0)
				R_in4 = R0;
				else if (1-(orderQ-orderR) ==1)
				R_in4 = R1;                    
				else if (1-(orderQ-orderR) ==2)
				R_in4 = R2;                    
				else if (1-(orderQ-orderR) ==3)
				R_in4 = R3;                    
				else if (1-(orderQ-orderR) ==4)
				R_in4 = R4;                    
				else if (1-(orderQ-orderR) ==5)
				R_in4 = R5;                    
				else if (1-(orderQ-orderR) ==6)
				R_in4 = R6;                    
				else if (1-(orderQ-orderR) ==7)
				R_in4 = R7;                    
				else if (1-(orderQ-orderR) ==8)
				R_in4 = R8;
				end
			else
				R_in4 = 0;
		
			if (5-(orderQ-orderR) >=0)
				begin
//				R_in5 = R[(5-(orderQ-orderR))];
				if (1-(orderQ-orderR) ==0)
				R_in5 = R0;
				else if (1-(orderQ-orderR) ==1)
				R_in5 = R1;                    
				else if (1-(orderQ-orderR) ==2)
				R_in5 = R2;                    
				else if (1-(orderQ-orderR) ==3)
				R_in5 = R3;                    
				else if (1-(orderQ-orderR) ==4)
				R_in5 = R4;                    
				else if (1-(orderQ-orderR) ==5)
				R_in5 = R5;                    
				else if (1-(orderQ-orderR) ==6)
				R_in5 = R6;                    
				else if (1-(orderQ-orderR) ==7)
				R_in5 = R7;                    
				else if (1-(orderQ-orderR) ==8)
				R_in5 = R8;
				end
			else
				R_in5 = 0;

			if (6-(orderQ-orderR) >=0)
				begin
//				R_in6 = R[(6-(orderQ-orderR))];
				if (1-(orderQ-orderR) ==0)
				R_in6 = R0;
				else if (1-(orderQ-orderR) ==1)
				R_in6 = R1;                    
				else if (1-(orderQ-orderR) ==2)
				R_in6 = R2;                    
				else if (1-(orderQ-orderR) ==3)
				R_in6 = R3;                    
				else if (1-(orderQ-orderR) ==4)
				R_in6 = R4;                    
				else if (1-(orderQ-orderR) ==5)
				R_in6 = R5;                    
				else if (1-(orderQ-orderR) ==6)
				R_in6 = R6;                    
				else if (1-(orderQ-orderR) ==7)
				R_in6 = R7;                    
				else if (1-(orderQ-orderR) ==8)
				R_in6 = R8;
				end
			else
				R_in6 = 0;

			if (7-(orderQ-orderR) >=0)
				begin
//				R_in7 = R[(7-(orderQ-orderR))];
				if (1-(orderQ-orderR) ==0)
				R_in7 = R0;
				else if (1-(orderQ-orderR) ==1)
				R_in7 = R1;                    
				else if (1-(orderQ-orderR) ==2)
				R_in7 = R2;                    
				else if (1-(orderQ-orderR) ==3)
				R_in7 = R3;                    
				else if (1-(orderQ-orderR) ==4)
				R_in7 = R4;                    
				else if (1-(orderQ-orderR) ==5)
				R_in7 = R5;                    
				else if (1-(orderQ-orderR) ==6)
				R_in7 = R6;                    
				else if (1-(orderQ-orderR) ==7)
				R_in7 = R7;                    
				else if (1-(orderQ-orderR) ==8)
				R_in7 = R8;
				end
			else
				R_in7 = 0;
	
			if (8-(orderQ-orderR) >=0)
				begin
//				R_in8 = R[(8-(orderQ-orderR))];
				if (1-(orderQ-orderR) ==0)
				R_in8 = R0;
				else if (1-(orderQ-orderR) ==1)
				R_in8 = R1;                    
				else if (1-(orderQ-orderR) ==2)
				R_in8 = R2;                    
				else if (1-(orderQ-orderR) ==3)
				R_in8 = R3;                    
				else if (1-(orderQ-orderR) ==4)
				R_in8 = R4;                    
				else if (1-(orderQ-orderR) ==5)
				R_in8 = R5;                    
				else if (1-(orderQ-orderR) ==6)
				R_in8 = R6;                    
				else if (1-(orderQ-orderR) ==7)
				R_in8 = R7;                    
				else if (1-(orderQ-orderR) ==8)
				R_in8 = R8;
				end
			else
				R_in8 = 0;
	end
end


always @(CompR_Q or Q0 or Q1 or Q2 or Q3 or Q4 or
 Q5 or Q6 or Q7 or Q8 or orderR or orderQ )
begin
	if (CompR_Q)
	begin
			
		if (0-(orderR-orderQ) ==0)
			Q_in0 = Q0;
			else
			Q_in0 = 0;

		if (1-(orderR-orderQ) >=0)
			begin
//				Q_in1 = Q[(1-(orderR-orderQ))];
				if (1-(orderR-orderQ) ==0)
				Q_in1 = Q0;
				else if (1-(orderR-orderQ) ==1)
				Q_in1 = Q1;
				else if (1-(orderR-orderQ) ==2)
				Q_in1 = Q2;
				else if (1-(orderR-orderQ) ==3)
				Q_in1 = Q3;
				else if (1-(orderR-orderQ) ==4)
				Q_in1 = Q4;
				else if (1-(orderR-orderQ) ==5)
				Q_in1 = Q5;
				else if (1-(orderR-orderQ) ==6)
				Q_in1 = Q6;
				else if (1-(orderR-orderQ) ==7)
				Q_in1 = Q7;
				else if (1-(orderR-orderQ) ==8)
				Q_in1 = Q8;
			end
			else
				Q_in1 = 0;

		if (2-(orderR-orderQ) >=0)
			begin
			//	Q_in2 = Q[(2-(orderR-orderQ))];
				if (1-(orderR-orderQ) ==0)
				Q_in2 = Q0;
				else if (1-(orderR-orderQ) ==1)
				Q_in2 = Q1;                    
				else if (1-(orderR-orderQ) ==2)
				Q_in2 = Q2;                    
				else if (1-(orderR-orderQ) ==3)
				Q_in2 = Q3;                    
				else if (1-(orderR-orderQ) ==4)
				Q_in2 = Q4;                    
				else if (1-(orderR-orderQ) ==5)
				Q_in2 = Q5;                    
				else if (1-(orderR-orderQ) ==6)
				Q_in2 = Q6;                    
				else if (1-(orderR-orderQ) ==7)
				Q_in2 = Q7;                    
				else if (1-(orderR-orderQ) ==8)
				Q_in2 = Q8;
			end
			else
				Q_in2 = 0;

		if (3-(orderR-orderQ) >=0)
			begin
			//	Q_in3 = Q[(3-(orderR-orderQ))];
				if (1-(orderR-orderQ) ==0)
				Q_in3 = Q0;
				else if (1-(orderR-orderQ) ==1)
				Q_in3 = Q1;                    
				else if (1-(orderR-orderQ) ==2)
				Q_in3 = Q2;                    
				else if (1-(orderR-orderQ) ==3)
				Q_in3 = Q3;                    
				else if (1-(orderR-orderQ) ==4)
				Q_in3 = Q4;                    
				else if (1-(orderR-orderQ) ==5)
				Q_in3 = Q5;                    
				else if (1-(orderR-orderQ) ==6)
				Q_in3 = Q6;                    
				else if (1-(orderR-orderQ) ==7)
				Q_in3 = Q7;                    
				else if (1-(orderR-orderQ) ==8)
				Q_in3 = Q8;
			end
			else
				Q_in3 = 0;

		if (4-(orderR-orderQ) >=0)
			begin
			//	Q_in4 = Q[(4-(orderR-orderQ))];
				if (1-(orderR-orderQ) ==0)
				Q_in4 = Q0;
				else if (1-(orderR-orderQ) ==1)
				Q_in4 = Q1;                    
				else if (1-(orderR-orderQ) ==2)
				Q_in4 = Q2;                    
				else if (1-(orderR-orderQ) ==3)
				Q_in4 = Q3;                    
				else if (1-(orderR-orderQ) ==4)
				Q_in4 = Q4;                    
				else if (1-(orderR-orderQ) ==5)
				Q_in4 = Q5;                    
				else if (1-(orderR-orderQ) ==6)
				Q_in4 = Q6;                    
				else if (1-(orderR-orderQ) ==7)
				Q_in4 = Q7;                    
				else if (1-(orderR-orderQ) ==8)
				Q_in4 = Q8;
			end
			else
				Q_in4 = 0;

		if (5-(orderR-orderQ) >=0)
			begin
//				Q_in5 = Q[(5-(orderR-orderQ))];
				if (1-(orderR-orderQ) ==0)
				Q_in5 = Q0;
				else if (1-(orderR-orderQ) ==1)
				Q_in5 = Q1;                    
				else if (1-(orderR-orderQ) ==2)
				Q_in5 = Q2;                    
				else if (1-(orderR-orderQ) ==3)
				Q_in5 = Q3;                    
				else if (1-(orderR-orderQ) ==4)
				Q_in5 = Q4;                    
				else if (1-(orderR-orderQ) ==5)
				Q_in5 = Q5;                    
				else if (1-(orderR-orderQ) ==6)
				Q_in5 = Q6;                    
				else if (1-(orderR-orderQ) ==7)
				Q_in5 = Q7;                    
				else if (1-(orderR-orderQ) ==8)
				Q_in5 = Q8;
			end
			else
				Q_in5 = 0;

		if (6-(orderR-orderQ) >=0)
			begin
//				Q_in6 = Q[(6-(orderR-orderQ))];
				if (1-(orderR-orderQ) ==0)
				Q_in6 = Q0;
				else if (1-(orderR-orderQ) ==1)
				Q_in6 = Q1;                    
				else if (1-(orderR-orderQ) ==2)
				Q_in6 = Q2;                    
				else if (1-(orderR-orderQ) ==3)
				Q_in6 = Q3;                    
				else if (1-(orderR-orderQ) ==4)
				Q_in6 = Q4;                    
				else if (1-(orderR-orderQ) ==5)
				Q_in6 = Q5;                    
				else if (1-(orderR-orderQ) ==6)
				Q_in6 = Q6;                    
				else if (1-(orderR-orderQ) ==7)
				Q_in6 = Q7;                    
				else if (1-(orderR-orderQ) ==8)
				Q_in6 = Q8;
			end
			else
				Q_in6 = 0;

		if (7-(orderR-orderQ) >=0)
			begin
			//	Q_in7 = Q[(7-(orderR-orderQ))];
				if (1-(orderR-orderQ) ==0)
				Q_in7 = Q0;
				else if (1-(orderR-orderQ) ==1)
				Q_in7 = Q1;                    
				else if (1-(orderR-orderQ) ==2)
				Q_in7 = Q2;                    
				else if (1-(orderR-orderQ) ==3)
				Q_in7 = Q3;                    
				else if (1-(orderR-orderQ) ==4)
				Q_in7 = Q4;                    
				else if (1-(orderR-orderQ) ==5)
				Q_in7 = Q5;                    
				else if (1-(orderR-orderQ) ==6)
				Q_in7 = Q6;                    
				else if (1-(orderR-orderQ) ==7)
				Q_in7 = Q7;                    
				else if (1-(orderR-orderQ) ==8)
				Q_in7 = Q8;
			end
			else
				Q_in7 = 0;

		if (8-(orderR-orderQ) >=0)
			begin
			//	Q_in8 = Q[(8-(orderR-orderQ))];
				if (1-(orderR-orderQ) ==0)
				Q_in8 = R0;
				else if (1-(orderR-orderQ) ==1)
				Q_in8 = Q1;                    
				else if (1-(orderR-orderQ) ==2)
				Q_in8 = Q2;                    
				else if (1-(orderR-orderQ) ==3)
				Q_in8 = Q3;                    
				else if (1-(orderR-orderQ) ==4)
				Q_in8 = Q4;                    
				else if (1-(orderR-orderQ) ==5)
				Q_in8 = Q5;                    
				else if (1-(orderR-orderQ) ==6)
				Q_in8 = Q6;                    
				else if (1-(orderR-orderQ) ==7)
				Q_in8 = Q7;                    
				else if (1-(orderR-orderQ) ==8)
				Q_in8 = R8;
			end
			else
				Q_in8 = 0;

	end
	else
	begin
		Q_in0 = Q0;
		Q_in1 = Q1;
		Q_in2 = Q2;
		Q_in3 = Q3;
		Q_in4 = Q4;
		Q_in5 = Q5;
		Q_in6 = Q6;
		Q_in7 = Q7;
		Q_in8 = Q8;
	end
end


reg	[9:0] Q_ordered;
always @(orderQ or Q0 or Q1 or Q2 or Q3 or Q4 or Q5 or Q6 or Q7 or Q8)
begin
	if (orderQ==0)
	Q_ordered = Q0;
	else if (orderQ==1)
	Q_ordered = Q1;
	else if (orderQ==2)
	Q_ordered = Q2;
	else if (orderQ==3)
	Q_ordered = Q3;
	else if (orderQ==4)
	Q_ordered = Q4;
	else if (orderQ==5)
	Q_ordered = Q5;
	else if (orderQ==6)
	Q_ordered = Q6;
	else if (orderQ==7)
	Q_ordered = Q7;
	else if (orderQ==8)
	Q_ordered = Q8;
	else
	Q_ordered = 0;
end

reg	[9:0] R_ordered;
always @(orderR or R0 or R1 or R2 or R3 or R4 or R5 or R6 or R7 or R8)
begin
	if (orderR==0)
	R_ordered = R0;
	else if (orderR==1)
	R_ordered = R1;
	else if (orderR==2)
	R_ordered = R2;
	else if (orderR==3)
	R_ordered = R3;
	else if (orderR==4)
	R_ordered = R4;
	else if (orderR==5)
	R_ordered = R5;
	else if (orderR==6)
	R_ordered = R6;
	else if (orderR==7)
	R_ordered = R7;
	else if (orderR==8)
	R_ordered = R8;
	else
	R_ordered = 0;
end


assign R_Value0 = R_val0_0^ R_val0_1 ;     
BinMult10 RCAL0_0 (.indata1(Q_ordered), .indata2(R_in0), .outdata(R_val0_0));
BinMult10 RCAL0_1 (.indata1(R_ordered), .indata2(Q_in0), .outdata(R_val0_1));

assign R_Value1 = R_val1_0^ R_val1_1 ;     
BinMult10 RCAL1_0 (.indata1(Q_ordered), .indata2(R_in1), .outdata(R_val1_0));
BinMult10 RCAL1_1 (.indata1(R_ordered), .indata2(Q_in1), .outdata(R_val1_1));

assign R_Value2 = R_val2_0^ R_val2_1 ;     
BinMult10 RCAL2_0 (.indata1(Q_ordered), .indata2(R_in2), .outdata(R_val2_0));
BinMult10 RCAL2_1 (.indata1(R_ordered), .indata2(Q_in2), .outdata(R_val2_1));

assign R_Value3 = R_val3_0^ R_val3_1 ;     
BinMult10 RCAL3_0 (.indata1(Q_ordered), .indata2(R_in3), .outdata(R_val3_0));
BinMult10 RCAL3_1 (.indata1(R_ordered), .indata2(Q_in3), .outdata(R_val3_1));

assign R_Value4 = R_val4_0^ R_val4_1 ;     
BinMult10 RCAL4_0 (.indata1(Q_ordered), .indata2(R_in4), .outdata(R_val4_0));
BinMult10 RCAL4_1 (.indata1(R_ordered), .indata2(Q_in4), .outdata(R_val4_1));

assign R_Value5 = R_val5_0^ R_val5_1 ;    
BinMult10 RCAL5_0 (.indata1(Q_ordered), .indata2(R_in5), .outdata(R_val5_0));
BinMult10 RCAL5_1 (.indata1(R_ordered), .indata2(Q_in5), .outdata(R_val5_1));

assign R_Value6 = R_val6_0^ R_val6_1 ;     
BinMult10 RCAL6_0 (.indata1(Q_ordered), .indata2(R_in6), .outdata(R_val6_0));
BinMult10 RCAL6_1 (.indata1(R_ordered), .indata2(Q_in6), .outdata(R_val6_1));

assign R_Value7 = R_val7_0^ R_val7_1 ;     
BinMult10 RCAL7_0 (.indata1(Q_ordered), .indata2(R_in7), .outdata(R_val7_0));
BinMult10 RCAL7_1 (.indata1(R_ordered), .indata2(Q_in7), .outdata(R_val7_1));

assign R_Value8 = R_val8_0^ R_val8_1 ;     
BinMult10 RCAL8_0 (.indata1(Q_ordered), .indata2(R_in8), .outdata(R_val8_0));
BinMult10 RCAL8_1 (.indata1(R_ordered), .indata2(Q_in8), .outdata(R_val8_1));


// R차수가 더 높을 때
//lambda[j] = BinMult(Q[OrderQ], lambda[j])^BinMult(R[OrderR], mue[j-(OrderR-OrderQ)]) ;
// Q차수가 더 높을 때
//lambda[j] = BinMult(Q[OrderQ],lambda[(j-(OrderQ - OrderR))]) ^ BinMult(R[OrderR],mue[j]) ^;	
//


always @(CompR_Q or lambda0 or lambda1 or lambda2 or 
		lambda3 or lambda4 or orderQ or orderR )
begin
	if (CompR_Q)
	begin
	lambda_in0 = lambda0;
	lambda_in1 = lambda1;
	lambda_in2 = lambda2;
	lambda_in3 = lambda3;
	lambda_in4 = lambda4;
	end
	else
	begin

		if (0-(orderQ-orderR) ==0)
			lambda_in0 = lambda0;
		else
			lambda_in0 = 0;

		if (1-(orderQ-orderR) >=0)
			begin
//			lambda_in1 = lambda[(1-(orderQ-orderR))];
				if (1-(orderQ-orderR) ==0)
				lambda_in1 = lambda0;
				else if (1-(orderQ-orderR) ==1)
				lambda_in1 = lambda1;
				else if (1-(orderQ-orderR) ==2)
				lambda_in1 = lambda2;
				else if (1-(orderQ-orderR) ==3)
				lambda_in1 = lambda3;
				else if (1-(orderQ-orderR) ==4)
				lambda_in1 = lambda4;
			end
		else
			lambda_in1 = 0;

		if (2-(orderQ-orderR) >=0)
			begin
//			lambda_in2 = lambda[(2-(orderQ-orderR))];
				if (1-(orderQ-orderR) ==0)
				lambda_in2 = lambda0;
				else if (1-(orderQ-orderR) ==1)
				lambda_in2 = lambda1;
				else if (1-(orderQ-orderR) ==2)
				lambda_in2 = lambda2;
				else if (1-(orderQ-orderR) ==3)
				lambda_in2 = lambda3;
				else if (1-(orderQ-orderR) ==4)
				lambda_in2 = lambda4;
			end
		else
			lambda_in2 = 0;

		if (3-(orderQ-orderR) >=0)
			begin
//			lambda_in3 = lambda[(3-(orderQ-orderR))];
				if (1-(orderQ-orderR) ==0)
				lambda_in3 = lambda0;
				else if (1-(orderQ-orderR) ==1)
				lambda_in3 = lambda1;
				else if (1-(orderQ-orderR) ==2)
				lambda_in3 = lambda2;
				else if (1-(orderQ-orderR) ==3)
				lambda_in3 = lambda3;
				else if (1-(orderQ-orderR) ==4)
				lambda_in3 = lambda4;
			end
		else
			lambda_in3 = 0;

		if (4-(orderQ-orderR) >=0)
			begin
//			lambda_in4 = lambda[(4-(orderQ-orderR))];
				if (1-(orderQ-orderR) ==0)
				lambda_in4 = lambda0;
				else if (1-(orderQ-orderR) ==1)
				lambda_in4 = lambda1;
				else if (1-(orderQ-orderR) ==2)
				lambda_in4 = lambda2;
				else if (1-(orderQ-orderR) ==3)
				lambda_in4 = lambda3;
				else if (1-(orderQ-orderR) ==4)
				lambda_in4 = lambda4;
			end
		else
			lambda_in4 = 0;
	end

end


always @(CompR_Q or Mue0 or Mue1 or Mue2 or Mue3 or Mue4 or orderR or orderQ)
begin
	if (CompR_Q)// R차수가 높거나 같은 경우
	begin
		if (0-(orderR-orderQ) ==0)
			mue_in0 = Mue0;
		else
			mue_in0 = 0;

		if (1-(orderR-orderQ) >=0)
			begin
//			mue_in1 = Mue[(1-(orderR-orderQ))];
				if (1-(orderR-orderQ) ==0)
				mue_in1 = Mue0;
				else if (1-(orderR-orderQ) ==1)
				mue_in1 = Mue1;
				else if (1-(orderR-orderQ) ==2)
				mue_in1 = Mue2;
				else if (1-(orderR-orderQ) ==3)
				mue_in1 = Mue3;
				else if (1-(orderR-orderQ) ==4)
				mue_in1 = Mue4;
			end
		else
			mue_in1 = 0;
		
		if (2-(orderR-orderQ) >=0)
			begin
//			mue_in2 = Mue[(2-(orderR-orderQ))];
				if (1-(orderR-orderQ) ==0)
				mue_in2 = Mue0;
				else if (1-(orderR-orderQ) ==1)
				mue_in2 = Mue1;
				else if (1-(orderR-orderQ) ==2)
				mue_in2 = Mue2;
				else if (1-(orderR-orderQ) ==3)
				mue_in2 = Mue3;
				else if (1-(orderR-orderQ) ==4)
				mue_in2 = Mue4;
			end
		else
			mue_in2 = 0;

		if (3-(orderR-orderQ) >=0)
			begin
//	mue_in3 = Mue[(3-(orderR-orderQ))];
				if (1-(orderR-orderQ) ==0)
				mue_in3 = Mue0;
				else if (1-(orderR-orderQ) ==1)
				mue_in3 = Mue1;
				else if (1-(orderR-orderQ) ==2)
				mue_in3 = Mue2;
				else if (1-(orderR-orderQ) ==3)
				mue_in3 = Mue3;
				else if (1-(orderR-orderQ) ==4)
				mue_in3 = Mue4;
			end
		else
			mue_in3 = 0;

		if (4-(orderR-orderQ) >=0)
			begin
//			mue_in4 = Mue[(4-(orderR-orderQ))];
				if (1-(orderR-orderQ) ==0)
				mue_in4 = Mue0;
				else if (1-(orderR-orderQ) ==1)
				mue_in4 = Mue1;
				else if (1-(orderR-orderQ) ==2)
				mue_in4 = Mue2;
				else if (1-(orderR-orderQ) ==3)
				mue_in4 = Mue3;
				else if (1-(orderR-orderQ) ==4)
				mue_in4 = Mue4;
			end
		else
			mue_in4 = 0;
	end
	else
	begin
	mue_in0 = Mue0;
	mue_in1 = Mue1;
	mue_in2 = Mue2;
	mue_in3 = Mue3;
	mue_in4 = Mue4;
	end
end

 assign L_Value0 = L_val0_0 ^ L_val0_1;
 BinMult10 LCAL0_0 (.indata1(Q_ordered), .indata2(lambda_in0), .outdata(L_val0_0));
 BinMult10 LCAL0_1 (.indata1(R_ordered), .indata2(mue_in0), .outdata(L_val0_1));

 assign L_Value1 = L_val1_0 ^ L_val1_1;
 BinMult10 LCAL1_0 (.indata1(Q_ordered), .indata2(lambda_in1), .outdata(L_val1_0));
 BinMult10 LCAL1_1 (.indata1(R_ordered), .indata2(mue_in1), .outdata(L_val1_1));

 assign L_Value2 = L_val2_0 ^ L_val2_1;
 BinMult10 LCAL2_0 (.indata1(Q_ordered), .indata2(lambda_in2), .outdata(L_val2_0));
 BinMult10 LCAL2_1 (.indata1(R_ordered), .indata2(mue_in2), .outdata(L_val2_1));

 assign L_Value3 = L_val3_0 ^ L_val3_1;
 BinMult10 LCAL3_0 (.indata1(Q_ordered), .indata2(lambda_in3), .outdata(L_val3_0));
 BinMult10 LCAL3_1 (.indata1(R_ordered), .indata2(mue_in3), .outdata(L_val3_1));

 assign L_Value4 = L_val4_0 ^ L_val4_1;
 BinMult10 LCAL4_0 (.indata1(Q_ordered), .indata2(lambda_in4), .outdata(L_val4_0));
 BinMult10 LCAL4_1 (.indata1(R_ordered), .indata2(mue_in4), .outdata(L_val4_1));

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





wire	[9:0]	EP0;
wire	[9:0]	EP1;
wire	[9:0]	EP2;
wire	[9:0]	EP3;
wire	[9:0]	EP4;
wire	[9:0]	EV0;
wire	[9:0]	EV1;
wire	[9:0]	EV2;
wire	[9:0]	EV3;
wire	[9:0]	EV4;


assign EP0= Mue0;
assign EP1= Mue1;
assign EP2= Mue2;
assign EP3= Mue3;
assign EP4= Mue4;
assign EV0= lambda0;
assign EV1= lambda1;
assign EV2= lambda2;
assign EV3= lambda3;
assign EV4= lambda4;

order8 ordQ(
			.indata1(Q1),
			.indata2(Q2),
			.indata3(Q3),
			.indata4(Q4),
			.indata5(Q5),
			.indata6(Q6),
			.indata7(Q7),
			.indata8(10'd0),
			.outdata(orderQ));

order8 ordR(
			.indata1(R1),
			.indata2(R2),
			.indata3(R3),
			.indata4(R4),
			.indata5(R5),
			.indata6(R6),
			.indata7(R7),
			.indata8(R8),
			.outdata(orderR)
			);



always @(lambda1 or lambda2 or lambda3 or lambda4)
begin
	if (lambda4)
		orderL = 4;
	else if (lambda3)
		orderL = 3;
	else if (lambda2)
		orderL = 2;
	else if (lambda1)
		orderL = 1;
	else 
		orderL = 0;
end
	




/*
order8 ordL(
			.indata1(lambda1),
			.indata2(lambda2),
			.indata3(lambda3),
			.indata4(lambda4),
			.indata5(0),
			.indata6(0),
			.indata7(0),
			.indata8(0),
			.outdata(orderL)
			);*/
/*order8 ordM(
			.indata1(Mue1), 	
			.indata2(Mue2), 	
			.indata3(Mue3), 	
			.indata4(Mue4), 	
			.indata5(0), 	
			.indata6(0), 	
			.indata7(0), 	
			.indata8(0), 	
			.outdata(orderM)
			);
*/
wire	EndMEA;
assign EndMEA= (orderR < orderL)? 1 : 0 ;

assign CSearchStart = EndMEA;
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










