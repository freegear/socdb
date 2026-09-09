//###########################################################################
//
// Copyright (C) Eureka Technology Inc.
//
// Confidential & Proprietary Information
//
// All Rights Reserved
//
// The use, modification, or duplication of this product is protected
// according to FAR 12.212 and by Eureka's licensing agreement.
// This design contains confidential and proprietary information which
// are the properties of Eureka Technology Inc.
// Unauthorized use, disclosure, duplication, or reproduction are prohibited.
//
//###########################################################################
//
`timescale 1ns / 100ps

module dff(Q, D, CLK, CLRN, PRN);
input D, CLK, CLRN, PRN;
output Q;
reg Q;
wire intD;
buf (intD, D);
always @(posedge CLK or negedge CLRN or negedge PRN) begin
	if (~CLRN) Q = #1 0;
	else if (~PRN) Q = #1 1;
	else Q = #1 intD;
end
endmodule

module dff2(Q, D, CLK, CLRN, PRN);
input[1:0]	D;
input		CLK, CLRN, PRN;
output[1:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
endmodule

module dff4(Q, D, CLK, CLRN, PRN);
input[3:0]	D;
input		CLK, CLRN, PRN;
output[3:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
endmodule

module dff5(Q, D, CLK, CLRN, PRN);
input[4:0]	D;
input		CLK, CLRN, PRN;
output[4:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
endmodule

module dff7(Q, D, CLK, CLRN, PRN);
input[6:0]	D;
input		CLK, CLRN, PRN;
output[6:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
endmodule

module dff8(Q, D, CLK, CLRN, PRN);
input[7:0]	D;
input		CLK, CLRN, PRN;
output[7:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
endmodule

module dff9(Q, D, CLK, CLRN, PRN);
input[8:0]	D;
input		CLK, CLRN, PRN;
output[8:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
endmodule

module dff10(Q, D, CLK, CLRN, PRN);
input[9:0]	D;
input		CLK, CLRN, PRN;
output[9:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
endmodule

module dff11(Q, D, CLK, CLRN, PRN);
input[10:0]	D;
input		CLK, CLRN, PRN;
output[10:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
endmodule

module dff12(Q, D, CLK, CLRN, PRN);
input[11:0]	D;
input		CLK, CLRN, PRN;
output[11:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
endmodule

module dff13(Q, D, CLK, CLRN, PRN);
input[12:0]	D;
input		CLK, CLRN, PRN;
output[12:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
endmodule

module dff14(Q, D, CLK, CLRN, PRN);
input[13:0]	D;
input		CLK, CLRN, PRN;
output[13:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
endmodule

module dff15(Q, D, CLK, CLRN, PRN);
input[14:0]	D;
input		CLK, CLRN, PRN;
output[14:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
dff U14 (Q[14], D[14], CLK, CLRN, PRN);
endmodule

module dff16(Q, D, CLK, CLRN, PRN);
input[15:0]	D;
input		CLK, CLRN, PRN;
output[15:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
dff U14 (Q[14], D[14], CLK, CLRN, PRN);
dff U15 (Q[15], D[15], CLK, CLRN, PRN);
endmodule

module dff17(Q, D, CLK, CLRN, PRN);
input[16:0]	D;
input		CLK, CLRN, PRN;
output[16:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
dff U14 (Q[14], D[14], CLK, CLRN, PRN);
dff U15 (Q[15], D[15], CLK, CLRN, PRN);
dff U16 (Q[16], D[16], CLK, CLRN, PRN);
endmodule

module dff20(Q, D, CLK, CLRN, PRN);
input[19:0]	D;
input		CLK, CLRN, PRN;
output[19:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
dff U14 (Q[14], D[14], CLK, CLRN, PRN);
dff U15 (Q[15], D[15], CLK, CLRN, PRN);
dff U16 (Q[16], D[16], CLK, CLRN, PRN);
dff U17 (Q[17], D[17], CLK, CLRN, PRN);
dff U18 (Q[18], D[18], CLK, CLRN, PRN);
dff U19 (Q[19], D[19], CLK, CLRN, PRN);
endmodule

module dff22(Q, D, CLK, CLRN, PRN);
input[21:0]	D;
input		CLK, CLRN, PRN;
output[21:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
dff U14 (Q[14], D[14], CLK, CLRN, PRN);
dff U15 (Q[15], D[15], CLK, CLRN, PRN);
dff U16 (Q[16], D[16], CLK, CLRN, PRN);
dff U17 (Q[17], D[17], CLK, CLRN, PRN);
dff U18 (Q[18], D[18], CLK, CLRN, PRN);
dff U19 (Q[19], D[19], CLK, CLRN, PRN);
dff U20 (Q[20], D[20], CLK, CLRN, PRN);
dff U21 (Q[21], D[21], CLK, CLRN, PRN);
endmodule

module dff23(Q, D, CLK, CLRN, PRN);
input[22:0]	D;
input		CLK, CLRN, PRN;
output[22:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
dff U14 (Q[14], D[14], CLK, CLRN, PRN);
dff U15 (Q[15], D[15], CLK, CLRN, PRN);
dff U16 (Q[16], D[16], CLK, CLRN, PRN);
dff U17 (Q[17], D[17], CLK, CLRN, PRN);
dff U18 (Q[18], D[18], CLK, CLRN, PRN);
dff U19 (Q[19], D[19], CLK, CLRN, PRN);
dff U20 (Q[20], D[20], CLK, CLRN, PRN);
dff U21 (Q[21], D[21], CLK, CLRN, PRN);
dff U22 (Q[22], D[22], CLK, CLRN, PRN);
endmodule

module dff24(Q, D, CLK, CLRN, PRN);
input[23:0]	D;
input		CLK, CLRN, PRN;
output[23:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
dff U14 (Q[14], D[14], CLK, CLRN, PRN);
dff U15 (Q[15], D[15], CLK, CLRN, PRN);
dff U16 (Q[16], D[16], CLK, CLRN, PRN);
dff U17 (Q[17], D[17], CLK, CLRN, PRN);
dff U18 (Q[18], D[18], CLK, CLRN, PRN);
dff U19 (Q[19], D[19], CLK, CLRN, PRN);
dff U20 (Q[20], D[20], CLK, CLRN, PRN);
dff U21 (Q[21], D[21], CLK, CLRN, PRN);
dff U22 (Q[22], D[22], CLK, CLRN, PRN);
dff U23 (Q[23], D[23], CLK, CLRN, PRN);
endmodule

module dff25(Q, D, CLK, CLRN, PRN);
input[24:0]	D;
input		CLK, CLRN, PRN;
output[24:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
dff U14 (Q[14], D[14], CLK, CLRN, PRN);
dff U15 (Q[15], D[15], CLK, CLRN, PRN);
dff U16 (Q[16], D[16], CLK, CLRN, PRN);
dff U17 (Q[17], D[17], CLK, CLRN, PRN);
dff U18 (Q[18], D[18], CLK, CLRN, PRN);
dff U19 (Q[19], D[19], CLK, CLRN, PRN);
dff U20 (Q[20], D[20], CLK, CLRN, PRN);
dff U21 (Q[21], D[21], CLK, CLRN, PRN);
dff U22 (Q[22], D[22], CLK, CLRN, PRN);
dff U23 (Q[23], D[23], CLK, CLRN, PRN);
dff U24 (Q[24], D[24], CLK, CLRN, PRN);
endmodule

module dff27(Q, D, CLK, CLRN, PRN);
input[26:0]	D;
input		CLK, CLRN, PRN;
output[26:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
dff U14 (Q[14], D[14], CLK, CLRN, PRN);
dff U15 (Q[15], D[15], CLK, CLRN, PRN);
dff U16 (Q[16], D[16], CLK, CLRN, PRN);
dff U17 (Q[17], D[17], CLK, CLRN, PRN);
dff U18 (Q[18], D[18], CLK, CLRN, PRN);
dff U19 (Q[19], D[19], CLK, CLRN, PRN);
dff U20 (Q[20], D[20], CLK, CLRN, PRN);
dff U21 (Q[21], D[21], CLK, CLRN, PRN);
dff U22 (Q[22], D[22], CLK, CLRN, PRN);
dff U23 (Q[23], D[23], CLK, CLRN, PRN);
dff U24 (Q[24], D[24], CLK, CLRN, PRN);
dff U25 (Q[25], D[25], CLK, CLRN, PRN);
dff U26 (Q[26], D[26], CLK, CLRN, PRN);
endmodule

module dff28(Q, D, CLK, CLRN, PRN);
input[27:0]	D;
input		CLK, CLRN, PRN;
output[27:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
dff U14 (Q[14], D[14], CLK, CLRN, PRN);
dff U15 (Q[15], D[15], CLK, CLRN, PRN);
dff U16 (Q[16], D[16], CLK, CLRN, PRN);
dff U17 (Q[17], D[17], CLK, CLRN, PRN);
dff U18 (Q[18], D[18], CLK, CLRN, PRN);
dff U19 (Q[19], D[19], CLK, CLRN, PRN);
dff U20 (Q[20], D[20], CLK, CLRN, PRN);
dff U21 (Q[21], D[21], CLK, CLRN, PRN);
dff U22 (Q[22], D[22], CLK, CLRN, PRN);
dff U23 (Q[23], D[23], CLK, CLRN, PRN);
dff U24 (Q[24], D[24], CLK, CLRN, PRN);
dff U25 (Q[25], D[25], CLK, CLRN, PRN);
dff U26 (Q[26], D[26], CLK, CLRN, PRN);
dff U27 (Q[27], D[27], CLK, CLRN, PRN);
endmodule

module dff30(Q, D, CLK, CLRN, PRN);
input[29:0]	D;
input		CLK, CLRN, PRN;
output[29:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
dff U14 (Q[14], D[14], CLK, CLRN, PRN);
dff U15 (Q[15], D[15], CLK, CLRN, PRN);
dff U16 (Q[16], D[16], CLK, CLRN, PRN);
dff U17 (Q[17], D[17], CLK, CLRN, PRN);
dff U18 (Q[18], D[18], CLK, CLRN, PRN);
dff U19 (Q[19], D[19], CLK, CLRN, PRN);
dff U20 (Q[20], D[20], CLK, CLRN, PRN);
dff U21 (Q[21], D[21], CLK, CLRN, PRN);
dff U22 (Q[22], D[22], CLK, CLRN, PRN);
dff U23 (Q[23], D[23], CLK, CLRN, PRN);
dff U24 (Q[24], D[24], CLK, CLRN, PRN);
dff U25 (Q[25], D[25], CLK, CLRN, PRN);
dff U26 (Q[26], D[26], CLK, CLRN, PRN);
dff U27 (Q[27], D[27], CLK, CLRN, PRN);
dff U28 (Q[28], D[28], CLK, CLRN, PRN);
dff U29 (Q[29], D[29], CLK, CLRN, PRN);
endmodule

module dff32(Q, D, CLK, CLRN, PRN);
input[31:0]	D;
input		CLK, CLRN, PRN;
output[31:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
dff U6 (Q[6], D[6], CLK, CLRN, PRN);
dff U7 (Q[7], D[7], CLK, CLRN, PRN);
dff U8 (Q[8], D[8], CLK, CLRN, PRN);
dff U9 (Q[9], D[9], CLK, CLRN, PRN);
dff U10 (Q[10], D[10], CLK, CLRN, PRN);
dff U11 (Q[11], D[11], CLK, CLRN, PRN);
dff U12 (Q[12], D[12], CLK, CLRN, PRN);
dff U13 (Q[13], D[13], CLK, CLRN, PRN);
dff U14 (Q[14], D[14], CLK, CLRN, PRN);
dff U15 (Q[15], D[15], CLK, CLRN, PRN);
dff U16 (Q[16], D[16], CLK, CLRN, PRN);
dff U17 (Q[17], D[17], CLK, CLRN, PRN);
dff U18 (Q[18], D[18], CLK, CLRN, PRN);
dff U19 (Q[19], D[19], CLK, CLRN, PRN);
dff U20 (Q[20], D[20], CLK, CLRN, PRN);
dff U21 (Q[21], D[21], CLK, CLRN, PRN);
dff U22 (Q[22], D[22], CLK, CLRN, PRN);
dff U23 (Q[23], D[23], CLK, CLRN, PRN);
dff U24 (Q[24], D[24], CLK, CLRN, PRN);
dff U25 (Q[25], D[25], CLK, CLRN, PRN);
dff U26 (Q[26], D[26], CLK, CLRN, PRN);
dff U27 (Q[27], D[27], CLK, CLRN, PRN);
dff U28 (Q[28], D[28], CLK, CLRN, PRN);
dff U29 (Q[29], D[29], CLK, CLRN, PRN);
dff U30 (Q[30], D[30], CLK, CLRN, PRN);
dff U31 (Q[31], D[31], CLK, CLRN, PRN);
endmodule

module dff6(Q, D, CLK, CLRN, PRN);
input[5:0]	D;
input		CLK, CLRN, PRN;
output[5:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
dff U3 (Q[3], D[3], CLK, CLRN, PRN);
dff U4 (Q[4], D[4], CLK, CLRN, PRN);
dff U5 (Q[5], D[5], CLK, CLRN, PRN);
endmodule

module dff3(Q, D, CLK, CLRN, PRN);
input[2:0]	D;
input		CLK, CLRN, PRN;
output[2:0]	Q;
dff U0 (Q[0], D[0], CLK, CLRN, PRN);
dff U1 (Q[1], D[1], CLK, CLRN, PRN);
dff U2 (Q[2], D[2], CLK, CLRN, PRN);
endmodule

module dffe(Q, D, CLK, CLRN, PRN, EN);
input		D;
input		CLK, CLRN, PRN, EN;
output		Q;
reg		Q;
wire		intD;
buf (intD, D);
always @(posedge CLK or negedge CLRN or negedge PRN) begin
	if (~CLRN) Q = #1 1'b0;
	else if (~PRN) Q = #1 1'b1;
	else if (EN) Q = #1 intD;
	else if (~EN) ;
	else Q = #1 1'bx;
end
endmodule

module dffe2(Q, D, CLK, CLRN, PRN, EN);
input[1:0]	D;
input		CLK, CLRN, PRN, EN;
output[1:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
endmodule

module dffe3(Q, D, CLK, CLRN, PRN, EN);
input[2:0]	D;
input		CLK, CLRN, PRN, EN;
output[2:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
endmodule

module dffe4(Q, D, CLK, CLRN, PRN, EN);
input[3:0]	D;
input		CLK, CLRN, PRN, EN;
output[3:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
endmodule

module dffe5(Q, D, CLK, CLRN, PRN, EN);
input[4:0]	D;
input		CLK, CLRN, PRN, EN;
output[4:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
endmodule

module dffe6(Q, D, CLK, CLRN, PRN, EN);
input[5:0]	D;
input		CLK, CLRN, PRN, EN;
output[5:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
endmodule

module dffe7(Q, D, CLK, CLRN, PRN, EN);
input[6:0]	D;
input		CLK, CLRN, PRN, EN;
output[6:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
dffe U6 (Q[6], D[6], CLK, CLRN, PRN, EN);
endmodule

module dffe8(Q, D, CLK, CLRN, PRN, EN);
input[7:0]	D;
input		CLK, CLRN, PRN, EN;
output[7:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
dffe U6 (Q[6], D[6], CLK, CLRN, PRN, EN);
dffe U7 (Q[7], D[7], CLK, CLRN, PRN, EN);
endmodule

module dffe9(Q, D, CLK, CLRN, PRN, EN);
input[8:0]	D;
input		CLK, CLRN, PRN, EN;
output[8:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
dffe U6 (Q[6], D[6], CLK, CLRN, PRN, EN);
dffe U7 (Q[7], D[7], CLK, CLRN, PRN, EN);
dffe U8 (Q[8], D[8], CLK, CLRN, PRN, EN);
endmodule

module dffe10(Q, D, CLK, CLRN, PRN, EN);
input[9:0]	D;
input		CLK, CLRN, PRN, EN;
output[9:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
dffe U6 (Q[6], D[6], CLK, CLRN, PRN, EN);
dffe U7 (Q[7], D[7], CLK, CLRN, PRN, EN);
dffe U8 (Q[8], D[8], CLK, CLRN, PRN, EN);
dffe U9 (Q[9], D[9], CLK, CLRN, PRN, EN);
endmodule

module dffe12(Q, D, CLK, CLRN, PRN, EN);
input[11:0]	D;
input		CLK, CLRN, PRN, EN;
output[11:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
dffe U6 (Q[6], D[6], CLK, CLRN, PRN, EN);
dffe U7 (Q[7], D[7], CLK, CLRN, PRN, EN);
dffe U8 (Q[8], D[8], CLK, CLRN, PRN, EN);
dffe U9 (Q[9], D[9], CLK, CLRN, PRN, EN);
dffe U10 (Q[10], D[10], CLK, CLRN, PRN, EN);
dffe U11 (Q[11], D[11], CLK, CLRN, PRN, EN);
endmodule

module dffe15(Q, D, CLK, CLRN, PRN, EN);
input[14:0]	D;
input		CLK, CLRN, PRN, EN;
output[14:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
dffe U6 (Q[6], D[6], CLK, CLRN, PRN, EN);
dffe U7 (Q[7], D[7], CLK, CLRN, PRN, EN);
dffe U8 (Q[8], D[8], CLK, CLRN, PRN, EN);
dffe U9 (Q[9], D[9], CLK, CLRN, PRN, EN);
dffe U10 (Q[10], D[10], CLK, CLRN, PRN, EN);
dffe U11 (Q[11], D[11], CLK, CLRN, PRN, EN);
dffe U12 (Q[12], D[12], CLK, CLRN, PRN, EN);
dffe U13 (Q[13], D[13], CLK, CLRN, PRN, EN);
dffe U14 (Q[14], D[14], CLK, CLRN, PRN, EN);
endmodule


module dffe16(Q, D, CLK, CLRN, PRN, EN);
input[15:0]	D;
input		CLK, CLRN, PRN, EN;
output[15:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
dffe U6 (Q[6], D[6], CLK, CLRN, PRN, EN);
dffe U7 (Q[7], D[7], CLK, CLRN, PRN, EN);
dffe U8 (Q[8], D[8], CLK, CLRN, PRN, EN);
dffe U9 (Q[9], D[9], CLK, CLRN, PRN, EN);
dffe U10 (Q[10], D[10], CLK, CLRN, PRN, EN);
dffe U11 (Q[11], D[11], CLK, CLRN, PRN, EN);
dffe U12 (Q[12], D[12], CLK, CLRN, PRN, EN);
dffe U13 (Q[13], D[13], CLK, CLRN, PRN, EN);
dffe U14 (Q[14], D[14], CLK, CLRN, PRN, EN);
dffe U15 (Q[15], D[15], CLK, CLRN, PRN, EN);
endmodule

module dffe18(Q, D, CLK, CLRN, PRN, EN);
input[17:0]	D;
input		CLK, CLRN, PRN, EN;
output[17:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
dffe U6 (Q[6], D[6], CLK, CLRN, PRN, EN);
dffe U7 (Q[7], D[7], CLK, CLRN, PRN, EN);
dffe U8 (Q[8], D[8], CLK, CLRN, PRN, EN);
dffe U9 (Q[9], D[9], CLK, CLRN, PRN, EN);
dffe U10 (Q[10], D[10], CLK, CLRN, PRN, EN);
dffe U11 (Q[11], D[11], CLK, CLRN, PRN, EN);
dffe U12 (Q[12], D[12], CLK, CLRN, PRN, EN);
dffe U13 (Q[13], D[13], CLK, CLRN, PRN, EN);
dffe U14 (Q[14], D[14], CLK, CLRN, PRN, EN);
dffe U15 (Q[15], D[15], CLK, CLRN, PRN, EN);
dffe U16 (Q[16], D[16], CLK, CLRN, PRN, EN);
dffe U17 (Q[17], D[17], CLK, CLRN, PRN, EN);
endmodule

module dffe24(Q, D, CLK, CLRN, PRN, EN);
input[23:0]	D;
input		CLK, CLRN, PRN, EN;
output[23:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
dffe U6 (Q[6], D[6], CLK, CLRN, PRN, EN);
dffe U7 (Q[7], D[7], CLK, CLRN, PRN, EN);
dffe U8 (Q[8], D[8], CLK, CLRN, PRN, EN);
dffe U9 (Q[9], D[9], CLK, CLRN, PRN, EN);
dffe U10 (Q[10], D[10], CLK, CLRN, PRN, EN);
dffe U11 (Q[11], D[11], CLK, CLRN, PRN, EN);
dffe U12 (Q[12], D[12], CLK, CLRN, PRN, EN);
dffe U13 (Q[13], D[13], CLK, CLRN, PRN, EN);
dffe U14 (Q[14], D[14], CLK, CLRN, PRN, EN);
dffe U15 (Q[15], D[15], CLK, CLRN, PRN, EN);
dffe U16 (Q[16], D[16], CLK, CLRN, PRN, EN);
dffe U17 (Q[17], D[17], CLK, CLRN, PRN, EN);
dffe U18 (Q[18], D[18], CLK, CLRN, PRN, EN);
dffe U19 (Q[19], D[19], CLK, CLRN, PRN, EN);
dffe U20 (Q[20], D[20], CLK, CLRN, PRN, EN);
dffe U21 (Q[21], D[21], CLK, CLRN, PRN, EN);
dffe U22 (Q[22], D[22], CLK, CLRN, PRN, EN);
dffe U23 (Q[23], D[23], CLK, CLRN, PRN, EN);
endmodule

module dffe28(Q, D, CLK, CLRN, PRN, EN);
input[27:0]	D;
input		CLK, CLRN, PRN, EN;
output[27:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
dffe U6 (Q[6], D[6], CLK, CLRN, PRN, EN);
dffe U7 (Q[7], D[7], CLK, CLRN, PRN, EN);
dffe U8 (Q[8], D[8], CLK, CLRN, PRN, EN);
dffe U9 (Q[9], D[9], CLK, CLRN, PRN, EN);
dffe U10 (Q[10], D[10], CLK, CLRN, PRN, EN);
dffe U11 (Q[11], D[11], CLK, CLRN, PRN, EN);
dffe U12 (Q[12], D[12], CLK, CLRN, PRN, EN);
dffe U13 (Q[13], D[13], CLK, CLRN, PRN, EN);
dffe U14 (Q[14], D[14], CLK, CLRN, PRN, EN);
dffe U15 (Q[15], D[15], CLK, CLRN, PRN, EN);
dffe U16 (Q[16], D[16], CLK, CLRN, PRN, EN);
dffe U17 (Q[17], D[17], CLK, CLRN, PRN, EN);
dffe U18 (Q[18], D[18], CLK, CLRN, PRN, EN);
dffe U19 (Q[19], D[19], CLK, CLRN, PRN, EN);
dffe U20 (Q[20], D[20], CLK, CLRN, PRN, EN);
dffe U21 (Q[21], D[21], CLK, CLRN, PRN, EN);
dffe U22 (Q[22], D[22], CLK, CLRN, PRN, EN);
dffe U23 (Q[23], D[23], CLK, CLRN, PRN, EN);
dffe U24 (Q[24], D[24], CLK, CLRN, PRN, EN);
dffe U25 (Q[25], D[25], CLK, CLRN, PRN, EN);
dffe U26 (Q[26], D[26], CLK, CLRN, PRN, EN);
dffe U27 (Q[27], D[27], CLK, CLRN, PRN, EN);
endmodule

module dffe32(Q, D, CLK, CLRN, PRN, EN);
input[31:0]	D;
input		CLK, CLRN, PRN, EN;
output[31:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
dffe U6 (Q[6], D[6], CLK, CLRN, PRN, EN);
dffe U7 (Q[7], D[7], CLK, CLRN, PRN, EN);
dffe U8 (Q[8], D[8], CLK, CLRN, PRN, EN);
dffe U9 (Q[9], D[9], CLK, CLRN, PRN, EN);
dffe U10 (Q[10], D[10], CLK, CLRN, PRN, EN);
dffe U11 (Q[11], D[11], CLK, CLRN, PRN, EN);
dffe U12 (Q[12], D[12], CLK, CLRN, PRN, EN);
dffe U13 (Q[13], D[13], CLK, CLRN, PRN, EN);
dffe U14 (Q[14], D[14], CLK, CLRN, PRN, EN);
dffe U15 (Q[15], D[15], CLK, CLRN, PRN, EN);
dffe U16 (Q[16], D[16], CLK, CLRN, PRN, EN);
dffe U17 (Q[17], D[17], CLK, CLRN, PRN, EN);
dffe U18 (Q[18], D[18], CLK, CLRN, PRN, EN);
dffe U19 (Q[19], D[19], CLK, CLRN, PRN, EN);
dffe U20 (Q[20], D[20], CLK, CLRN, PRN, EN);
dffe U21 (Q[21], D[21], CLK, CLRN, PRN, EN);
dffe U22 (Q[22], D[22], CLK, CLRN, PRN, EN);
dffe U23 (Q[23], D[23], CLK, CLRN, PRN, EN);
dffe U24 (Q[24], D[24], CLK, CLRN, PRN, EN);
dffe U25 (Q[25], D[25], CLK, CLRN, PRN, EN);
dffe U26 (Q[26], D[26], CLK, CLRN, PRN, EN);
dffe U27 (Q[27], D[27], CLK, CLRN, PRN, EN);
dffe U28 (Q[28], D[28], CLK, CLRN, PRN, EN);
dffe U29 (Q[29], D[29], CLK, CLRN, PRN, EN);
dffe U30 (Q[30], D[30], CLK, CLRN, PRN, EN);
dffe U31 (Q[31], D[31], CLK, CLRN, PRN, EN);
endmodule

module dffe34(Q, D, CLK, CLRN, PRN, EN);
input[33:0]	D;
input		CLK, CLRN, PRN, EN;
output[33:0]	Q;
dffe U0 (Q[0], D[0], CLK, CLRN, PRN, EN);
dffe U1 (Q[1], D[1], CLK, CLRN, PRN, EN);
dffe U2 (Q[2], D[2], CLK, CLRN, PRN, EN);
dffe U3 (Q[3], D[3], CLK, CLRN, PRN, EN);
dffe U4 (Q[4], D[4], CLK, CLRN, PRN, EN);
dffe U5 (Q[5], D[5], CLK, CLRN, PRN, EN);
dffe U6 (Q[6], D[6], CLK, CLRN, PRN, EN);
dffe U7 (Q[7], D[7], CLK, CLRN, PRN, EN);
dffe U8 (Q[8], D[8], CLK, CLRN, PRN, EN);
dffe U9 (Q[9], D[9], CLK, CLRN, PRN, EN);
dffe U10 (Q[10], D[10], CLK, CLRN, PRN, EN);
dffe U11 (Q[11], D[11], CLK, CLRN, PRN, EN);
dffe U12 (Q[12], D[12], CLK, CLRN, PRN, EN);
dffe U13 (Q[13], D[13], CLK, CLRN, PRN, EN);
dffe U14 (Q[14], D[14], CLK, CLRN, PRN, EN);
dffe U15 (Q[15], D[15], CLK, CLRN, PRN, EN);
dffe U16 (Q[16], D[16], CLK, CLRN, PRN, EN);
dffe U17 (Q[17], D[17], CLK, CLRN, PRN, EN);
dffe U18 (Q[18], D[18], CLK, CLRN, PRN, EN);
dffe U19 (Q[19], D[19], CLK, CLRN, PRN, EN);
dffe U20 (Q[20], D[20], CLK, CLRN, PRN, EN);
dffe U21 (Q[21], D[21], CLK, CLRN, PRN, EN);
dffe U22 (Q[22], D[22], CLK, CLRN, PRN, EN);
dffe U23 (Q[23], D[23], CLK, CLRN, PRN, EN);
dffe U24 (Q[24], D[24], CLK, CLRN, PRN, EN);
dffe U25 (Q[25], D[25], CLK, CLRN, PRN, EN);
dffe U26 (Q[26], D[26], CLK, CLRN, PRN, EN);
dffe U27 (Q[27], D[27], CLK, CLRN, PRN, EN);
dffe U28 (Q[28], D[28], CLK, CLRN, PRN, EN);
dffe U29 (Q[29], D[29], CLK, CLRN, PRN, EN);
dffe U30 (Q[30], D[30], CLK, CLRN, PRN, EN);
dffe U31 (Q[31], D[31], CLK, CLRN, PRN, EN);
dffe U32 (Q[32], D[32], CLK, CLRN, PRN, EN);
dffe U33 (Q[33], D[33], CLK, CLRN, PRN, EN);
endmodule


