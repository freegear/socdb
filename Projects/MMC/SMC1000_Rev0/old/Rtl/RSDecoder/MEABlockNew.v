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
				EPOrder,
				CSearchStart);

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

output [3:0] EPOrder;

output		CSearchStart;


reg [9:0]	Mue4;
reg [9:0]	Mue3;
reg [9:0]	Mue2;
reg [9:0]	Mue1;
reg [9:0]	Mue0;

reg [9:0] lambda4;
reg [9:0] lambda3;
reg [9:0] lambda2;
reg [9:0] lambda1;
reg [9:0] lambda0;

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

wire	EndMEA;

assign EndMEA= (orderR < orderL)? 1 : 0 ;

// MEA State
// MEA IDLE -> MEA CALC -> MEA_END

`define MEA_IDLE 	3'b001
`define	MEA_CALC 	3'b010
`define MEA_END		3'b100

reg	[2:0]	MEAState;
reg	[2:0]	NextMEAState;

always @(MEAState or MEAStart or EndMEA)
begin
	NextMEAState = MEAState;
	case (MEAState)
	`MEA_IDLE : if (MEAStart) NextMEAState = `MEA_CALC;
	`MEA_CALC :	if (EndMEA) NextMEAState = `MEA_END;
	`MEA_END  : NextMEAState = `MEA_IDLE;
	default   : NextMEAState = `MEA_IDLE;
	endcase
end

always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	MEAState <= `MEA_IDLE;	
	else
	MEAState <= NextMEAState;
end

assign CSearchStart = (MEAState == `MEA_END);

assign CompR_Q = (orderR >= orderQ)? 1: 0;  // Compare OrderR OrderQ

always @(SYND7 or SYND6 or SYND5 or SYND4 or
	   	SYND3 or SYND2 or SYND1 or SYND0 or	CompR_Q or 
		Q0 or Q1 or Q2 or Q3 or	Q4 or Q5 or Q6 or Q7 or 
		R0 or R1 or R2 or R3 or R4 or R5 or R6 or R7 or 
		MEAStart or MEAState)
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
	else if ((MEAState == `MEA_CALC)&(~EndMEA))
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
	R8 or R7 or R6 or R5 or R4 or R3 or R2 or R1 or R0 or MEAState or EndMEA)
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
	else if ((MEAState ==`MEA_CALC)&(~EndMEA))
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



always @(MEAStart or L_Value0 or L_Value1 or L_Value2 or L_Value3 or 
L_Value4 or lambda4 or lambda3 or lambda2 or lambda1 or lambda0 or MEAState or EndMEA)
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
	else if ((MEAState == `MEA_CALC)&(~EndMEA))
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
	lambda4 <= 0;	lambda3 <= 0;	lambda2 <= 0;
	lambda1 <= 0;	lambda0 <= 0;
	end
	else
	begin
	lambda4 <= Nextlambda4;	
	lambda3 <= Nextlambda3;	lambda2 <= Nextlambda2;	
	lambda1 <= Nextlambda1;	lambda0 <= Nextlambda0;
	end
end



always @(Mue0 or Mue1 or Mue2 or Mue3 or Mue4 or 
lambda0 or lambda1 or lambda2 or lambda3 or lambda4 or MEAStart or
Mue4 or Mue3 or Mue2 or Mue1 or Mue0 or CompR_Q or MEAState or EndMEA)
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
	else if ((MEAState == `MEA_CALC)&(~EndMEA))
	begin
		if (CompR_Q) // R차수가 더 크거나 같은 경우
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
		if ((orderQ-orderR) == 1)
			begin
				R_in0 = 0;
				R_in1 = R0;
				R_in2 = R1;
				R_in3 = R2;
				R_in4 = R3;
				R_in5 = R4;
				R_in6 = R5;
				R_in7 = R6;
				R_in8 = R7;
			end
		else if ((orderQ-orderR) == 2)
			begin
				R_in0 = 0;
				R_in1 = 0;
				R_in2 = R0;
				R_in3 = R1;
				R_in4 = R2;
				R_in5 = R3;
				R_in6 = R4;
				R_in7 = R5;
				R_in8 = R6;
			end
		else if ((orderQ-orderR) == 3)
			begin
				R_in0 = 0;
				R_in1 = 0;
				R_in2 = 0;
				R_in3 = R0;
				R_in4 = R1;
				R_in5 = R2;
				R_in6 = R3;
				R_in7 = R4;
				R_in8 = R5;
			end
		else if ((orderQ-orderR) == 4)
			begin
				R_in0 = 0;
				R_in1 = 0;
				R_in2 = 0;
				R_in3 = 0;
				R_in4 = R0;
				R_in5 = R1;
				R_in6 = R2;
				R_in7 = R3;
				R_in8 = R4;
			end
		else if ((orderQ-orderR) == 5)
			begin
				R_in0 = 0;
				R_in1 = 0;
				R_in2 = 0;
				R_in3 = 0;
				R_in4 = 0;
				R_in5 = R0;
				R_in6 = R1;
				R_in7 = R2;
				R_in8 = R3;
			end
		else if ((orderQ-orderR) == 6)
			begin
				R_in0 = 0;
				R_in1 = 0;
				R_in2 = 0;
				R_in3 = 0;
				R_in4 = 0;
				R_in5 = 0;
				R_in6 = R0;
				R_in7 = R1;
				R_in8 = R2;
			end
		else if ((orderQ-orderR) == 7)
			begin
				R_in0 = 0;
				R_in1 = 0;
				R_in2 = 0;
				R_in3 = 0;
				R_in4 = 0;
				R_in5 = 0;
				R_in6 = 0;
				R_in7 = R0;
				R_in8 = R1;
			end
	/*	else if ((orderQ-orderR) == 8)
			begin
				R_in0 = 0;
				R_in1 = 0;
				R_in2 = 0;
				R_in3 = 0;
				R_in4 = 0;
				R_in5 = 0;
				R_in6 = 0;
				R_in7 = 0;
				R_in8 = 1;
			end*/
		else
			begin
				R_in0 = 0;
				R_in1 = 0;
				R_in2 = 0;
				R_in3 = 0;
				R_in4 = 0;
				R_in5 = 0;
				R_in6 = 0;
				R_in7 = 0;
				R_in8 = 0;
			end




		/*if (0-(orderQ-orderR) ==0)		R_in0 = R0;
		else							R_in0 = 0;

		if		(1-(orderQ-orderR) < 0)	R_in1 = 0;
		else if	(1-(orderQ-orderR) ==0)	R_in1 = R0;
		else if (1-(orderQ-orderR) ==1)	R_in1 = R1; 
		else							R_in1 = 0; 	// Revision
			
		if		(2-(orderQ-orderR) < 0)	R_in2 = 0;
		else if (2-(orderQ-orderR) ==0)	R_in2 = R0;
		else if (2-(orderQ-orderR) ==1)	R_in2 = R1;
		else if (2-(orderQ-orderR) ==2)	R_in2 = R2;
		else							R_in2 = 0; 	// Revision
			
		if		(3-(orderQ-orderR) < 0)	R_in3 = 0;
		else if	(3-(orderQ-orderR) ==0)	R_in3 = R0;
		else if (3-(orderQ-orderR) ==1)	R_in3 = R1;                    
		else if (3-(orderQ-orderR) ==2)	R_in3 = R2;                    
		else if (3-(orderQ-orderR) ==3)	R_in3 = R3;                    
		else							R_in3 = 0; // Revision

		if		(4-(orderQ-orderR) < 0)	R_in4 = 0;
		else if	(4-(orderQ-orderR) ==0)	R_in4 = R0;
		else if (4-(orderQ-orderR) ==1)	R_in4 = R1;                    
		else if (4-(orderQ-orderR) ==2)	R_in4 = R2;                    
		else if (4-(orderQ-orderR) ==3)	R_in4 = R3;                    
		else if (4-(orderQ-orderR) ==4)	R_in4 = R4;                    
		else							R_in4 = 0;

		if		(5-(orderQ-orderR) < 0)	R_in5 = 0;
		else if (5-(orderQ-orderR) ==0)	R_in5 = R0;
		else if (5-(orderQ-orderR) ==1)	R_in5 = R1;                    
		else if (5-(orderQ-orderR) ==2)	R_in5 = R2;                    
		else if (5-(orderQ-orderR) ==3)	R_in5 = R3;                    
		else if (5-(orderQ-orderR) ==4)	R_in5 = R4;                    
		else if (5-(orderQ-orderR) ==5)	R_in5 = R5;  
		else							R_in5 = 0;                  

		if		(6-(orderQ-orderR) < 0)	R_in6 = 0;
		else if	(6-(orderQ-orderR) ==0)	R_in6 = R0;
		else if (6-(orderQ-orderR) ==1)	R_in6 = R1;                    
		else if (6-(orderQ-orderR) ==2)	R_in6 = R2;                    
		else if (6-(orderQ-orderR) ==3)	R_in6 = R3;                    
		else if (6-(orderQ-orderR) ==4)	R_in6 = R4;                    
		else if (6-(orderQ-orderR) ==5)	R_in6 = R5;                    
		else if (6-(orderQ-orderR) ==6)	R_in6 = R6;                    
		else							R_in6 = 0;                  

		if		(7-(orderQ-orderR) < 0)	R_in7 = 0;
		else if (7-(orderQ-orderR) ==0)	R_in7 = R0;
		else if (7-(orderQ-orderR) ==1)	R_in7 = R1;                    
		else if (7-(orderQ-orderR) ==2)	R_in7 = R2;                    
		else if (7-(orderQ-orderR) ==3)	R_in7 = R3;                    
		else if (7-(orderQ-orderR) ==4)	R_in7 = R4;                    
		else if (7-(orderQ-orderR) ==5)	R_in7 = R5;                    
		else if (7-(orderQ-orderR) ==6)	R_in7 = R6;                    
		else if (7-(orderQ-orderR) ==7)	R_in7 = R7;                    
		else 							R_in7 = 0;
	
		if		(8-(orderQ-orderR) < 0)	R_in8 = 0;
		else if (8-(orderQ-orderR) ==0)	R_in8 = R0;
		else if (8-(orderQ-orderR) ==1)	R_in8 = R1;                    
		else if (8-(orderQ-orderR) ==2)	R_in8 = R2;                    
		else if (8-(orderQ-orderR) ==3)	R_in8 = R3;                    
		else if (8-(orderQ-orderR) ==4)	R_in8 = R4;                    
		else if (8-(orderQ-orderR) ==5)	R_in8 = R5;                    
		else if (8-(orderQ-orderR) ==6)	R_in8 = R6;                    
		else if (8-(orderQ-orderR) ==7)	R_in8 = R7;                    
		else if (8-(orderQ-orderR) ==8)	R_in8 = R8;
		else 							R_in8 = 0;*/
	end
end


always @(CompR_Q or Q0 or Q1 or Q2 or Q3 or Q4 or
 Q5 or Q6 or Q7 or Q8 or orderR or orderQ )
begin
	if (CompR_Q)
	begin
		if (orderR==orderQ)
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

		else if ((orderR-orderQ) == 1)
			begin
			Q_in0 = 0;
			Q_in1 = Q0;
			Q_in2 = Q1;
			Q_in3 = Q2;
			Q_in4 = Q3;
			Q_in5 = Q4;
			Q_in6 = Q5;
			Q_in7 = Q6;
			Q_in8 = Q7;
			end
		else if ((orderR-orderQ) == 2)
			begin
			Q_in0 = 0;
			Q_in1 = 0;
			Q_in2 = Q0;
			Q_in3 = Q1;
			Q_in4 = Q2;
			Q_in5 = Q3;
			Q_in6 = Q4;
			Q_in7 = Q5;
			Q_in8 = Q6;
			end
		else if ((orderR-orderQ) == 3)
			begin
			Q_in0 = 0;
			Q_in1 = 0;
			Q_in2 = 0;
			Q_in3 = Q0;
			Q_in4 = Q1;
			Q_in5 = Q2;
			Q_in6 = Q3;
			Q_in7 = Q4;
			Q_in8 = Q5;
			end
		else if ((orderR-orderQ) == 4)
			begin
			Q_in0 = 0;
			Q_in1 = 0;
			Q_in2 = 0;
			Q_in3 = 0;
			Q_in4 = Q0;
			Q_in5 = Q1;
			Q_in6 = Q2;
			Q_in7 = Q3;
			Q_in8 = Q4;
			end
		else if ((orderR-orderQ) == 5)
			begin
			Q_in0 = 0;
			Q_in1 = 0;
			Q_in2 = 0;
			Q_in3 = 0;
			Q_in4 = 0;
			Q_in5 = Q0;
			Q_in6 = Q1;
			Q_in7 = Q2;
			Q_in8 = Q3;
			end
		else if ((orderR-orderQ) == 6)
			begin
			Q_in0 = 0;
			Q_in1 = 0;
			Q_in2 = 0;
			Q_in3 = 0;
			Q_in4 = 0;
			Q_in5 = 0;
			Q_in6 = Q0;
			Q_in7 = Q1;
			Q_in8 = Q2;
			end
		else if ((orderR-orderQ) == 7)
			begin
			Q_in0 = 0;
			Q_in1 = 0;
			Q_in2 = 0;
			Q_in3 = 0;
			Q_in4 = 0;
			Q_in5 = 0;
			Q_in6 = 0;
			Q_in7 = Q0;
			Q_in8 = Q1;
			end
		else if ((orderR-orderQ) == 8)
			begin
			Q_in0 = 0;
			Q_in1 = 0;
			Q_in2 = 0;
			Q_in3 = 0;
			Q_in4 = 0;
			Q_in5 = 0;
			Q_in6 = 0;
			Q_in7 = 0;
			Q_in8 = Q0;
			end
		else 
			begin
			Q_in0 = 0;
			Q_in1 = 0;
			Q_in2 = 0;
			Q_in3 = 0;
			Q_in4 = 0;
			Q_in5 = 0;
			Q_in6 = 0;
			Q_in7 = 0;
			Q_in8 = 0;
			end

	
		/*
		if 		(0-(orderR-orderQ) ==0)	Q_in0 = Q0;
		else							Q_in0 = 0;

		if 		(1-(orderR-orderQ) < 0)	Q_in1 = 0;
		else if (1-(orderR-orderQ) ==0)	Q_in1 = Q0;
		else if (1-(orderR-orderQ) ==1)	Q_in1 = Q1;
		else							Q_in1 = 0;

		if 		(2-(orderR-orderQ) < 0)	Q_in2 = 0;
		else if (2-(orderR-orderQ) ==0)	Q_in2 = Q0;
		else if (2-(orderR-orderQ) ==1)	Q_in2 = Q1;                    
		else if (2-(orderR-orderQ) ==2)	Q_in2 = Q2;                    
		else							Q_in2 = 0;

		if 		(3-(orderR-orderQ) < 0) Q_in3 = 0;
		else if	(3-(orderR-orderQ) ==0)	Q_in3 = Q0;
		else if (3-(orderR-orderQ) ==1)	Q_in3 = Q1;
		else if (3-(orderR-orderQ) ==2)	Q_in3 = Q2;
		else if (3-(orderR-orderQ) ==3)	Q_in3 = Q3;
		else							Q_in3 = 0;

		if 		(4-(orderR-orderQ) < 0) Q_in4 = 0;
		else if (4-(orderR-orderQ) ==0)	Q_in4 = Q0;
		else if (4-(orderR-orderQ) ==1)	Q_in4 = Q1;                    
		else if (4-(orderR-orderQ) ==2)	Q_in4 = Q2;                    
		else if (4-(orderR-orderQ) ==3)	Q_in4 = Q3;                    
		else if (4-(orderR-orderQ) ==4)	Q_in4 = Q4;                    
		else							Q_in4 = 0;

		if 		(5-(orderR-orderQ) < 0) Q_in5 = 0;
		else if (5-(orderR-orderQ) ==0)	Q_in5 = Q0;
		else if (5-(orderR-orderQ) ==1)	Q_in5 = Q1;                    
		else if (5-(orderR-orderQ) ==2)	Q_in5 = Q2;                    
		else if (5-(orderR-orderQ) ==3)	Q_in5 = Q3;                    
		else if (5-(orderR-orderQ) ==4)	Q_in5 = Q4;                    
		else if (5-(orderR-orderQ) ==5)	Q_in5 = Q5;                    
		else							Q_in5 = 0;

		if 		(6-(orderR-orderQ) < 0) Q_in6 = 0;
		else if (6-(orderR-orderQ) ==0)	Q_in6 = Q0;
		else if (6-(orderR-orderQ) ==1)	Q_in6 = Q1;                    
		else if (6-(orderR-orderQ) ==2)	Q_in6 = Q2;                    
		else if (6-(orderR-orderQ) ==3)	Q_in6 = Q3;                    
		else if (6-(orderR-orderQ) ==4)	Q_in6 = Q4;                    
		else if (6-(orderR-orderQ) ==5)	Q_in6 = Q5;                    
		else if (6-(orderR-orderQ) ==6)	Q_in6 = Q6;                    
		else							Q_in6 = 0;

		if 		(7-(orderR-orderQ) < 0) Q_in7 = 0;
		else if (7-(orderR-orderQ) ==0)	Q_in7 = Q0;
		else if (7-(orderR-orderQ) ==1)	Q_in7 = Q1;                    
		else if (7-(orderR-orderQ) ==2)	Q_in7 = Q2;                    
		else if (7-(orderR-orderQ) ==3)	Q_in7 = Q3;                    
		else if (7-(orderR-orderQ) ==4)	Q_in7 = Q4;                    
		else if (7-(orderR-orderQ) ==5)	Q_in7 = Q5;                    
		else if (7-(orderR-orderQ) ==6)	Q_in7 = Q6;                    
		else if (7-(orderR-orderQ) ==7)	Q_in7 = Q7;                    
		else							Q_in7 = 0;

		if 		(8-(orderR-orderQ) < 0)	Q_in8 = 0;
		else if (8-(orderR-orderQ) ==0)	Q_in8 = R0;
		else if (8-(orderR-orderQ) ==1)	Q_in8 = Q1;                    
		else if (8-(orderR-orderQ) ==2)	Q_in8 = Q2;                    
		else if (8-(orderR-orderQ) ==3)	Q_in8 = Q3;                    
		else if (8-(orderR-orderQ) ==4)	Q_in8 = Q4;                    
		else if (8-(orderR-orderQ) ==5)	Q_in8 = Q5;                    
		else if (8-(orderR-orderQ) ==6)	Q_in8 = Q6;                    
		else if (8-(orderR-orderQ) ==7)	Q_in8 = Q7;                    
		else if (8-(orderR-orderQ) ==8)	Q_in8 = R8;
		else							Q_in8 = 0;
		*/
	end
	else
	begin
		Q_in0 = Q0;		Q_in1 = Q1;		Q_in2 = Q2;		Q_in3 = Q3;
		Q_in4 = Q4;		Q_in5 = Q5;		Q_in6 = Q6;		Q_in7 = Q7;
		Q_in8 = Q8;
	end
end

reg	[9:0] Q_ordered;
always @(orderQ or Q0 or Q1 or Q2 or Q3 or Q4 or Q5 or Q6 or Q7 /*or Q8*/)
begin
	if 		(orderQ==0)	Q_ordered = Q0;
	else if (orderQ==1)	Q_ordered = Q1;
	else if (orderQ==2)	Q_ordered = Q2;
	else if (orderQ==3)	Q_ordered = Q3;
	else if (orderQ==4)	Q_ordered = Q4;
	else if (orderQ==5)	Q_ordered = Q5;
	else if (orderQ==6)	Q_ordered = Q6;
	else if (orderQ==7)	Q_ordered = Q7;
//	else if (orderQ==8)	Q_ordered = Q8;
	else				Q_ordered = 0;
end

reg	[9:0] R_ordered;
always @(orderR or R0 or R1 or R2 or R3 or R4 or R5 or R6 or R7 or R8)
begin
	if 		(orderR==0)	R_ordered = R0;
	else if (orderR==1)	R_ordered = R1;
	else if (orderR==2)	R_ordered = R2;
	else if (orderR==3)	R_ordered = R3;
	else if (orderR==4)	R_ordered = R4;
	else if (orderR==5)	R_ordered = R5;
	else if (orderR==6)	R_ordered = R6;
	else if (orderR==7)	R_ordered = R7;
	else if (orderR==8)	R_ordered = R8;
	else				R_ordered = 0;
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
		if ((orderQ-orderR)==1)
			begin
			lambda_in0 = 0;
			lambda_in1 = lambda0;
			lambda_in2 = lambda1;
			lambda_in3 = lambda2;
			lambda_in4 = lambda3;
			end
		else if ((orderQ-orderR) == 2)
			begin
			lambda_in0 = 0;
			lambda_in1 = 0;
			lambda_in2 = lambda0;
			lambda_in3 = lambda1;
			lambda_in4 = lambda2;
			end
		else if ((orderQ-orderR) == 3)
			begin
			lambda_in0 = 0;
			lambda_in1 = 0;
			lambda_in2 = 0;
			lambda_in3 = lambda0;
			lambda_in4 = lambda1;
			end
		else if ((orderQ-orderR) == 4)
			begin
			lambda_in0 = 0;
			lambda_in1 = 0;
			lambda_in2 = 0;
			lambda_in3 = 0;
			lambda_in4 = lambda0;
			end
		else
			begin
			lambda_in0 = 0;
			lambda_in1 = 0;
			lambda_in2 = 0;
			lambda_in3 = 0;
			lambda_in4 = 0;
			end
/*
		if (0-(orderQ-orderR) ==0)		lambda_in0 = lambda0;
		else							lambda_in0 = 0;

		if 		(1-(orderQ-orderR) < 0)	lambda_in1 = 0;
		else if (1-(orderQ-orderR) ==0)	lambda_in1 = lambda0;
		else if (1-(orderQ-orderR) ==1)	lambda_in1 = lambda1;
		else							lambda_in1 = 0;

		if 		(2-(orderQ-orderR) < 0) lambda_in2 = 0;
		else if (2-(orderQ-orderR) ==0)	lambda_in2 = lambda0;
		else if (2-(orderQ-orderR) ==1)	lambda_in2 = lambda1;
		else if (2-(orderQ-orderR) ==2)	lambda_in2 = lambda2;
		else 							lambda_in2 = 0;

		if 		(3-(orderQ-orderR) < 0) lambda_in3 = 0;
		else if (3-(orderQ-orderR) ==0)	lambda_in3 = lambda0;
		else if (3-(orderQ-orderR) ==1)	lambda_in3 = lambda1;
		else if (3-(orderQ-orderR) ==2)	lambda_in3 = lambda2;
		else if (3-(orderQ-orderR) ==3)	lambda_in3 = lambda3;
		else			lambda_in3 = 0;

		if 		(4-(orderQ-orderR) < 0)	lambda_in4 = 0;
		else if (4-(orderQ-orderR) ==0)	lambda_in4 = lambda0;
		else if (4-(orderQ-orderR) ==1)	lambda_in4 = lambda1;
		else if (4-(orderQ-orderR) ==2)	lambda_in4 = lambda2;
		else if (4-(orderQ-orderR) ==3)	lambda_in4 = lambda3;
		else if (4-(orderQ-orderR) ==4)	lambda_in4 = lambda4;
		else							lambda_in4 = 0;*/
	end
end

always @(CompR_Q or Mue0 or Mue1 or Mue2 or Mue3 or Mue4 or orderR or orderQ)
begin
	if (CompR_Q)// R차수가 높거나 같은 경우
	begin
		if (orderR==orderQ)
			begin
			mue_in0 = Mue0;
			mue_in1 = Mue1;
			mue_in2 = Mue2;
			mue_in3 = Mue3;
			mue_in4 = Mue4;
			end
		else if ((orderR-orderQ)==1)
			begin
			mue_in0 = 0;
			mue_in1 = Mue0;
			mue_in2 = Mue1;
			mue_in3 = Mue2;
			mue_in4 = Mue3;
			end
		else if ((orderR-orderQ)==2)
			begin
			mue_in0 = 0;
			mue_in1 = 0;
			mue_in2 = Mue0;
			mue_in3 = Mue1;
			mue_in4 = Mue2;
			end
		else if ((orderR-orderQ)==3)
			begin
			mue_in0 = 0;
			mue_in1 = 0;
			mue_in2 = 0;
			mue_in3 = Mue0;
			mue_in4 = Mue1;
			end
		else if ((orderR-orderQ)==4)
			begin
			mue_in0 = 0;
			mue_in1 = 0;
			mue_in2 = 0;
			mue_in3 = 0;
			mue_in4 = Mue0;
			end
		else
			begin
			mue_in0 = 0;
			mue_in1 = 0;
			mue_in2 = 0;
			mue_in3 = 0;
			mue_in4 = 0;
			end
/*		if 		(0-(orderR-orderQ) ==0)	mue_in0 = Mue0;
		else							mue_in0 = 0;

		if 		(1-(orderR-orderQ) < 0) mue_in1 = 0;
		else if (1-(orderR-orderQ) ==0)	mue_in1 = Mue0;
		else if (1-(orderR-orderQ) ==1)	mue_in1 = Mue1;
		else							mue_in1 = 0;
		
		if 		(2-(orderR-orderQ) < 0) mue_in2 = 0;
		else if (2-(orderR-orderQ) ==0)	mue_in2 = Mue0;
		else if (2-(orderR-orderQ) ==1)	mue_in2 = Mue1;
		else if (2-(orderR-orderQ) ==2)	mue_in2 = Mue2;
		else							mue_in2 = 0;

		if 		(3-(orderR-orderQ) < 0) mue_in3 = 0;
		else if (3-(orderR-orderQ) ==0)	mue_in3 = Mue0;
		else if (3-(orderR-orderQ) ==1)	mue_in3 = Mue1;
		else if (3-(orderR-orderQ) ==2)	mue_in3 = Mue2;
		else if (3-(orderR-orderQ) ==3)	mue_in3 = Mue3;
		else							mue_in3 = 0;

		if 		(4-(orderR-orderQ) < 0) mue_in4 = 0;
		else if (4-(orderR-orderQ) ==0)	mue_in4 = Mue0;
		else if (4-(orderR-orderQ) ==1)	mue_in4 = Mue1;
		else if (4-(orderR-orderQ) ==2)	mue_in4 = Mue2;
		else if (4-(orderR-orderQ) ==3)	mue_in4 = Mue3;
		else if (4-(orderR-orderQ) ==4)	mue_in4 = Mue4;
		else							mue_in4 = 0;*/
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

assign EV0= R0;
assign EV1= R1;
assign EV2= R2;
assign EV3= R3;
assign EV4= R4;
assign EP0= lambda0;
assign EP1= lambda1;
assign EP2= lambda2;
assign EP3= lambda3;
assign EP4= lambda4;
assign EPOrder = orderL;

order7 ordQ(
			.indata1(Q1),
			.indata2(Q2),
			.indata3(Q3),
			.indata4(Q4),
			.indata5(Q5),
			.indata6(Q6),
			.indata7(Q7),
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
/*
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
*/

wire	outdata1;
wire	outdata2;
wire	outdata3;
wire	outdata4;
wire	outdata5;
wire	outdata6;
wire	outdata7;
wire	outdata8;

OR10BIT data1(.indata(indata1),.outdata(outdata1));
OR10BIT data2(.indata(indata2),.outdata(outdata2));
OR10BIT data3(.indata(indata3),.outdata(outdata3));
OR10BIT data4(.indata(indata4),.outdata(outdata4));
OR10BIT data5(.indata(indata5),.outdata(outdata5));
OR10BIT data6(.indata(indata6),.outdata(outdata6));
OR10BIT data7(.indata(indata7),.outdata(outdata7));
OR10BIT data8(.indata(indata8),.outdata(outdata8));

always @(outdata1 or outdata2 or outdata3 or outdata4 or outdata5 or outdata6 or outdata7 or outdata8)
begin
	if (outdata8)
		outdata = 8;
	else if (outdata7)
		outdata = 7;
	else if (outdata6)
		outdata = 6;
	else if (outdata5)
		outdata = 5;
	else if (outdata4)
		outdata = 4;
	else if (outdata3)
		outdata = 3;
	else if (outdata2)
		outdata = 2;
	else if (outdata1)
		outdata = 1;
	else 
		outdata = 0;
end

endmodule



module order7(
				indata1 , 
				indata2 , 
				indata3 , 
				indata4 , 
				indata5 , 
				indata6 , 
				indata7 , 
				outdata);

input [9:0]		indata1;
input [9:0]		indata2;
input [9:0]		indata3;
input [9:0]		indata4;
input [9:0]		indata5;
input [9:0]		indata6;
input [9:0]		indata7;
output [3:0]	outdata;

reg [3:0] outdata;
/*
always @(indata1 or indata2 or indata3 or indata4 or indata5 or indata6 or indata7)
begin
	if (indata7)
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
*/
wire	outdata1;
wire	outdata2;
wire	outdata3;
wire	outdata4;
wire	outdata5;
wire	outdata6;
wire	outdata7;

OR10BIT data1(.indata(indata1),.outdata(outdata1));
OR10BIT data2(.indata(indata2),.outdata(outdata2));
OR10BIT data3(.indata(indata3),.outdata(outdata3));
OR10BIT data4(.indata(indata4),.outdata(outdata4));
OR10BIT data5(.indata(indata5),.outdata(outdata5));
OR10BIT data6(.indata(indata6),.outdata(outdata6));
OR10BIT data7(.indata(indata7),.outdata(outdata7));


always @(outdata1 or outdata2 or outdata3 or outdata4 or outdata5 or outdata6 or outdata7)
begin
	if (outdata7)
		outdata = 7;
	else if (outdata6)
		outdata = 6;
	else if (outdata5)
		outdata = 5;
	else if (outdata4)
		outdata = 4;
	else if (outdata3)
		outdata = 3;
	else if (outdata2)
		outdata = 2;
	else if (outdata1)
		outdata = 1;
	else 
		outdata = 0;
end


endmodule


module OR10BIT (indata, outdata);
input [9:0] indata;
output		outdata;

assign outdata = (	indata[0]|
					indata[1]|
					indata[2]|
					indata[3]|
					indata[4]|
					indata[5]|
					indata[6]|
					indata[7]|
					indata[8]|
					indata[9]);

endmodule
