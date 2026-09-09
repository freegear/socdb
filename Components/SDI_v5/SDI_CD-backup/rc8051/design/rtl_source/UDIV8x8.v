

module UDIV8x8 (
A,
B,
Quotient, 
Remainder
);

input[7:0] 	A;
input[7:0] 	B;
output[7:0] Quotient, Remainder;

reg[7:0]	Quotient, Remainder;
reg[15:0]	wA;
reg[7:0]	notB;

reg[8:0]Compare1, 
		Compare2, 
		Compare3, 
		Compare4, 
		Compare5,
		Compare6,
		Compare7,
		Compare8;

reg[7:0]PartRem1, 
		PartRem2, 
		PartRem3, 
		PartRem4,
		PartRem5,
		PartRem6,
		PartRem7;
		
reg[7:0]		
		PartRem1_Abit, 
		PartRem2_Abit, 
		PartRem3_Abit, 
		PartRem4_Abit,
		PartRem5_Abit,
		PartRem6_Abit,
		PartRem7_Abit;
			
//---------------------------------------------------------------------
//Subtract upper 5-bit of quotient divisor (B) and test for
//a Quotient bit overflow.
//---------------------------------------------------------------------
always @(A or B or wA) begin

wA = {8'b00000000,A};

//--------
//Invert B
//--------
notB = ~B;

//-----1---------------------------------------------------------------
// Ignore MSB of A and test if next 8 MSB bits of A>= divisor(B).
// Quotient[7]=1 if A[14:4] >= B.
//---------------------------------------------------------------------
Compare1 = wA[14:7] + notB + 1;

if(Compare1[8]) begin
	PartRem1 = Compare1[7:0];
	Quotient[7] = 1;
end else begin
	PartRem1 = wA[14:7];
	Quotient[7] = 0;
end
//-----------------------------------------------
//Bring down next dividend bit(bit 6)
//-----------------------------------------------
PartRem1_Abit = {PartRem1[6:0],wA[6]};

//-----2-----------------------------------------
//Subtract if third remainder >= divisor (B)
//-----------------------------------------------
Compare2 = PartRem1_Abit[7:0] + notB + 1;

if(Compare2[8]) begin
	PartRem2 = Compare2[7:0];
	Quotient[6] = 1;
end else begin
	PartRem2 = PartRem1_Abit[7:0];
	Quotient[6] = 0;
end
//-----------------------------------------------
//Bring down next dividend bit(bit 5)
//-----------------------------------------------
PartRem2_Abit = {PartRem2[6:0],wA[5]};

//-----3-----------------------------------------
//Subtract if third remainder >= divisor (B)
//-----------------------------------------------
Compare3 = PartRem2_Abit[7:0] + notB + 1;

if(Compare3[8]) begin
	PartRem3 = Compare3[7:0];
	Quotient[5] = 1;
end else begin
	PartRem3 = PartRem2_Abit[7:0];
	Quotient[5] = 0;
end
//-----------------------------------------------
//Bring down next dividend bit(bit 4)
//-----------------------------------------------
PartRem3_Abit = {PartRem3[6:0],wA[4]};

//-----4-----------------------------------------
//Subtract if third remainder >= divisor (B)
//-----------------------------------------------
Compare4 = PartRem3_Abit[7:0] + notB + 1;

if(Compare4[8]) begin
	PartRem4 = Compare4[7:0];
	Quotient[4] = 1;
end else begin
	PartRem4 = PartRem3_Abit[7:0];
	Quotient[4] = 0;
end
//-----------------------------------------------
//Bring down next dividend bit(bit 3)
//-----------------------------------------------
PartRem4_Abit = {PartRem4[6:0],wA[3]};

//-----5-----------------------------------------
//Subtract if third remainder >= divisor (B)
//-----------------------------------------------
Compare5 = PartRem4_Abit[7:0] + notB + 1;

if(Compare5[8]) begin
	PartRem5 = Compare5[7:0];
	Quotient[3] = 1;
end else begin
	PartRem5 = PartRem4_Abit[7:0];
	Quotient[3] = 0;
end
//-----------------------------------------------
//Bring down next dividend bit(bit 2)
//-----------------------------------------------
PartRem5_Abit = {PartRem5[6:0],wA[2]};

//-----6-----------------------------------------
//Subtract if third remainder >= divisor (B)
//-----------------------------------------------
Compare6 = PartRem5_Abit[7:0] + notB + 1;

if(Compare6[8]) begin
	PartRem6 = Compare6[7:0];
	Quotient[2] = 1;
end else begin
	PartRem6 = PartRem5_Abit[7:0];
	Quotient[2] = 0;
end
//-----------------------------------------------
//Bring down next dividend bit(bit 1)
//-----------------------------------------------
PartRem6_Abit = {PartRem6[6:0],wA[1]};

//-----7-----------------------------------------
//Subtract if third remainder >= divisor (B)
//-----------------------------------------------
Compare7 = PartRem6_Abit[7:0] + notB + 1;

if(Compare7[8]) begin
	PartRem7 = Compare7[7:0];
	Quotient[1] = 1;
end else begin
	PartRem7 = PartRem6_Abit[7:0];
	Quotient[1] = 0;
end

//-----------------------------------------------
//Bring down next dividend bit(bit 0)
//-----------------------------------------------
PartRem7_Abit = {PartRem7[6:0],wA[0]}; //Shift

//-----8-----------------------------------------
//Subtract if third remainder >= divisor (B)
//-----------------------------------------------
Compare8 = PartRem7_Abit[7:0] + notB + 1;

if(Compare8[8]) begin //PartRem7_Abit >= B
	Remainder = Compare8[7:0];
	Quotient[0] = 1;
end else begin
	Remainder = PartRem7_Abit[7:0];
	Quotient[0] = 0;
end
end
endmodule






