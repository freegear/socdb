// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name        : BinMult.v
// File Revision    : 1.0 
// Reveision history: 
//  ------------------------------------------------------------
//  Purpose         : Binary Multiply Block
// ==============================================================================

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
