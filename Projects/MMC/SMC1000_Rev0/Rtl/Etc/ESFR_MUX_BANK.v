// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : ESFR_MUX_BANK.v 
// File Revision       : 0.1
//  ----------------------------------------------------------------
//  Purpose            : ESFR Select Decoder & Mux
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module   ESFR_MUX_BANK
  (
	RESETn,
	CLK,
	EXT_SFR_ADDR,
	EXT_SFR_WR,
	EXT_SFR_DOUT,	
	EXT_SFR_DIN,
	
	MEM_CTRL_DIN, 
	WAP_REG_DIN,
	NAND_DMA0_DIN,
	NAND_DMA1_DIN,
	NAND_CTRL0_DIN,
	NAND_CTRL1_DIN,
	STATIC_DIN,
	RS_ENC0_DIN,
	RS_ENC1_DIN,
	RS_DEC0_DIN,
	RS_DEC1_DIN,
	
	bank_addr,
	
	MEM_CTRL_CS, 
	WAP_REG_CS,
	NAND_DMA0_CS,
	NAND_DMA1_CS,
	NAND_CTRL0_CS,
	NAND_CTRL1_CS,
	STATIC_CS,
	RS_ENC0_CS,
	RS_ENC1_CS,
	RS_DEC0_CS,
	RS_DEC1_CS
);
	
input			RESETn;
input			CLK;
input [7:0] 		EXT_SFR_ADDR;
input			EXT_SFR_WR;
input [7:0] 		EXT_SFR_DOUT;
output [7:0] 	EXT_SFR_DIN;

input	[7:0]	MEM_CTRL_DIN; 
input	[7:0]	WAP_REG_DIN;
input	[7:0]	NAND_DMA0_DIN;
input	[7:0]	NAND_DMA1_DIN;
input	[7:0]	NAND_CTRL0_DIN;
input	[7:0]	NAND_CTRL1_DIN;
input [7:0] 		STATIC_DIN;
input [7:0] 		RS_ENC0_DIN;
input [7:0] 		RS_ENC1_DIN;
input [7:0] 		RS_DEC0_DIN;
input [7:0] 		RS_DEC1_DIN;

output [10:0] 	bank_addr;

output	[8:0]	MEM_CTRL_CS;
output	[14:0]	WAP_REG_CS;
output	[4:0]	NAND_DMA0_CS;
output	[4:0]	NAND_DMA1_CS;
output	[14:0]	NAND_CTRL0_CS;
output	[14:0]	NAND_CTRL1_CS;

output			STATIC_CS;
output			RS_ENC0_CS;
output			RS_ENC1_CS;
output			RS_DEC0_CS;
output			RS_DEC1_CS;


//-----------------------------------------------------------

wire	[8:0]	MEM_CTRL_CS;
wire	[14:0]	WAP_REG_CS;
wire	[4:0]	NAND_DMA0_CS;
wire	[4:0]	NAND_DMA1_CS;
wire	[14:0]	NAND_CTRL0_CS;
wire	[14:0]	NAND_CTRL1_CS;



wire 			RS_ENC0_CS;
wire 			RS_ENC1_CS;
wire 			RS_DEC0_CS;
wire 			RS_DEC1_CS;
wire 			STATIC_CS;

reg [7:0] 		EXT_SFR_DIN;
reg [7:0] 		PageMode;

wire [10:0] 	bank_addr;
wire 			sel_bank_reg;
wire 			PageMode_w;

assign		MEM_CTRL_CS[0] = (EXT_SFR_ADDR[7:0]==8'h84);
assign		MEM_CTRL_CS[1] = (EXT_SFR_ADDR[7:0]==8'h85);
assign		MEM_CTRL_CS[2] = (EXT_SFR_ADDR[7:0]==8'h86);
assign		MEM_CTRL_CS[3] = (EXT_SFR_ADDR[7:0]==8'hE1);
assign		MEM_CTRL_CS[4] = (EXT_SFR_ADDR[7:0]==8'hE2);
assign		MEM_CTRL_CS[5] = (EXT_SFR_ADDR[7:0]==8'hE3);
assign		MEM_CTRL_CS[6] = (EXT_SFR_ADDR[7:0]==8'hE4);
assign		MEM_CTRL_CS[7] = (EXT_SFR_ADDR[7:0]==8'hE5);
assign		MEM_CTRL_CS[8] = (EXT_SFR_ADDR[7:0]==8'hE6);

assign		NAND_DMA0_CS[0]= (EXT_SFR_ADDR[7:0]==8'h8F);
assign		NAND_DMA0_CS[1]= (EXT_SFR_ADDR[7:0]==8'h92);
assign		NAND_DMA0_CS[2]= (EXT_SFR_ADDR[7:0]==8'h93);
assign		NAND_DMA0_CS[3]= (EXT_SFR_ADDR[7:0]==8'h94);
assign		NAND_DMA0_CS[4]= (EXT_SFR_ADDR[7:0]==8'h95);

assign		NAND_DMA1_CS[0]= (EXT_SFR_ADDR[7:0]==8'h96);
assign		NAND_DMA1_CS[1]= (EXT_SFR_ADDR[7:0]==8'h97);
assign		NAND_DMA1_CS[2]= (EXT_SFR_ADDR[7:0]==8'h9A);
assign		NAND_DMA1_CS[3]= (EXT_SFR_ADDR[7:0]==8'h9B);
assign		NAND_DMA1_CS[4]= (EXT_SFR_ADDR[7:0]==8'h9C);

assign		NAND_CTRL0_CS[0]= (EXT_SFR_ADDR[7:0]==8'h9D);
assign		NAND_CTRL0_CS[1]= (EXT_SFR_ADDR[7:0]==8'h9E);
assign		NAND_CTRL0_CS[2]= (EXT_SFR_ADDR[7:0]==8'h9F);
assign		NAND_CTRL0_CS[3]= (EXT_SFR_ADDR[7:0]==8'hA1);
assign		NAND_CTRL0_CS[4]= (EXT_SFR_ADDR[7:0]==8'hA2);
assign		NAND_CTRL0_CS[5]= (EXT_SFR_ADDR[7:0]==8'hA3);
assign		NAND_CTRL0_CS[6]= (EXT_SFR_ADDR[7:0]==8'hA4);
assign		NAND_CTRL0_CS[7]= (EXT_SFR_ADDR[7:0]==8'hA5);
assign		NAND_CTRL0_CS[8]= (EXT_SFR_ADDR[7:0]==8'hA6);
assign		NAND_CTRL0_CS[9]= (EXT_SFR_ADDR[7:0]==8'hA7);
assign		NAND_CTRL0_CS[10]= (EXT_SFR_ADDR[7:0]==8'hAA);
assign		NAND_CTRL0_CS[11]= (EXT_SFR_ADDR[7:0]==8'hAB);
assign		NAND_CTRL0_CS[12]= (EXT_SFR_ADDR[7:0]==8'hAC);
assign		NAND_CTRL0_CS[13]= (EXT_SFR_ADDR[7:0]==8'hAD);
assign		NAND_CTRL0_CS[14]= (EXT_SFR_ADDR[7:0]==8'hAE);

assign		NAND_CTRL1_CS[0]=  (EXT_SFR_ADDR[7:0]==8'hAF);
assign		NAND_CTRL1_CS[1]=  (EXT_SFR_ADDR[7:0]==8'hB1);
assign		NAND_CTRL1_CS[2]=  (EXT_SFR_ADDR[7:0]==8'hB2);
assign		NAND_CTRL1_CS[3]=  (EXT_SFR_ADDR[7:0]==8'hB3);
assign		NAND_CTRL1_CS[4]=  (EXT_SFR_ADDR[7:0]==8'hB4);
assign		NAND_CTRL1_CS[5]=  (EXT_SFR_ADDR[7:0]==8'hB5);
assign		NAND_CTRL1_CS[6]=  (EXT_SFR_ADDR[7:0]==8'hB6);
assign		NAND_CTRL1_CS[7]=  (EXT_SFR_ADDR[7:0]==8'hBA);
assign		NAND_CTRL1_CS[8]=  (EXT_SFR_ADDR[7:0]==8'hBB);
assign		NAND_CTRL1_CS[9]=  (EXT_SFR_ADDR[7:0]==8'hBC);
assign		NAND_CTRL1_CS[10]= (EXT_SFR_ADDR[7:0]==8'hBD);
assign		NAND_CTRL1_CS[11]= (EXT_SFR_ADDR[7:0]==8'hBE);
assign		NAND_CTRL1_CS[12]= (EXT_SFR_ADDR[7:0]==8'hBF);
assign		NAND_CTRL1_CS[13]= (EXT_SFR_ADDR[7:0]==8'hC1);
assign		NAND_CTRL1_CS[14]= (EXT_SFR_ADDR[7:0]==8'hC2);

assign		WAP_REG_CS[0]	=  (EXT_SFR_ADDR[7:0]==8'hC3);
assign		WAP_REG_CS[1]	=  (EXT_SFR_ADDR[7:0]==8'hC5);
assign		WAP_REG_CS[2]	=  (EXT_SFR_ADDR[7:0]==8'hC6);
assign		WAP_REG_CS[3]	=  (EXT_SFR_ADDR[7:0]==8'hC7);
assign		WAP_REG_CS[4]	=  (EXT_SFR_ADDR[7:0]==8'hCE);
assign		WAP_REG_CS[5]	=  (EXT_SFR_ADDR[7:0]==8'hCF);
assign		WAP_REG_CS[6]	=  (EXT_SFR_ADDR[7:0]==8'hD1);
assign		WAP_REG_CS[7]	=  (EXT_SFR_ADDR[7:0]==8'hD2);
assign		WAP_REG_CS[8]	=  (EXT_SFR_ADDR[7:0]==8'hD3);
assign		WAP_REG_CS[9]	=  (EXT_SFR_ADDR[7:0]==8'hD4);
assign		WAP_REG_CS[10]	=  (EXT_SFR_ADDR[7:0]==8'hD5);
assign		WAP_REG_CS[11]	=  (EXT_SFR_ADDR[7:0]==8'hD6);
assign		WAP_REG_CS[12]	=  (EXT_SFR_ADDR[7:0]==8'hD7);
assign		WAP_REG_CS[13]	=  (EXT_SFR_ADDR[7:0]==8'hE7);
assign		WAP_REG_CS[14]	=  (EXT_SFR_ADDR[7:0]==8'hE9);
//assign		WAP_REG_CS[13]	=  (EXT_SFR_ADDR[7:0]==8'hD9);


assign 		bank_addr = {PageMode,EXT_SFR_ADDR[2:0]};
assign      sel_bank_reg = (EXT_SFR_ADDR[7:3] == 5'h1f)? 1'b1 : 1'b0;
assign 		PageMode_w = (EXT_SFR_ADDR == 8'hc0)? 1'b1 : 1'b0;

assign 		RS_ENC0_CS	= (sel_bank_reg) & (bank_addr[10:6]==5'h00);
assign 		RS_ENC1_CS	= (sel_bank_reg) & (bank_addr[10:6]==5'h01);

assign 		RS_DEC0_CS	= (sel_bank_reg) & (bank_addr[10:8]==3'h1);
assign 		RS_DEC1_CS	= (sel_bank_reg) & (bank_addr[10:8]==3'h2);

assign 		STATIC_CS	= (sel_bank_reg) & (bank_addr[10:8]==3'h3);


always @(posedge CLK or negedge RESETn) begin
  if (~RESETn)	PageMode <= 8'h00;
  else if (PageMode_w & EXT_SFR_WR)
	PageMode <= EXT_SFR_DOUT[7:0];
  end

wire	MEM_CTRL_RD_CS =  (	MEM_CTRL_CS[0] | 
							MEM_CTRL_CS[1] | 
							MEM_CTRL_CS[2] | 
							MEM_CTRL_CS[3] | 
							MEM_CTRL_CS[4] | 
							MEM_CTRL_CS[5] | 
							MEM_CTRL_CS[6] | 
							MEM_CTRL_CS[7] | 
							MEM_CTRL_CS[8]);

wire	NAND_DMA0_RD_CS = (	NAND_DMA0_CS[0]|
							NAND_DMA0_CS[1]|
							NAND_DMA0_CS[2]|
							NAND_DMA0_CS[3]|
							NAND_DMA0_CS[4]);

wire	NAND_DMA1_RD_CS = (	NAND_DMA1_CS[0]|
							NAND_DMA1_CS[1]|
							NAND_DMA1_CS[2]| 
							NAND_DMA1_CS[3]|
							NAND_DMA1_CS[4]);

wire NAND_CTRL0_RD_CS =	(	NAND_CTRL0_CS[0]|
							NAND_CTRL0_CS[1]|
							NAND_CTRL0_CS[2]|
							NAND_CTRL0_CS[3]|
							NAND_CTRL0_CS[4]|
							NAND_CTRL0_CS[5]|
							NAND_CTRL0_CS[6]|
							NAND_CTRL0_CS[7]|
							NAND_CTRL0_CS[8]|
							NAND_CTRL0_CS[9]|
							NAND_CTRL0_CS[10]|
							NAND_CTRL0_CS[11]|
							NAND_CTRL0_CS[12]|
							NAND_CTRL0_CS[13]);

wire NAND_CTRL1_RD_CS =	(	NAND_CTRL1_CS[0]|
							NAND_CTRL1_CS[1]|
							NAND_CTRL1_CS[2]|
							NAND_CTRL1_CS[3]|
							NAND_CTRL1_CS[4]|
							NAND_CTRL1_CS[5]|
							NAND_CTRL1_CS[6]|
							NAND_CTRL1_CS[7]|
							NAND_CTRL1_CS[8]|
							NAND_CTRL1_CS[9]|
							NAND_CTRL1_CS[10]|
							NAND_CTRL1_CS[11]|
							NAND_CTRL1_CS[12]|
							NAND_CTRL1_CS[13]);

wire	WAP_REG_RD_CS =	(	WAP_REG_CS[0]|
							WAP_REG_CS[1]|
							WAP_REG_CS[2]|
							WAP_REG_CS[3]|
							WAP_REG_CS[4]|
							WAP_REG_CS[5]|
							WAP_REG_CS[6]|
							WAP_REG_CS[7]|
							WAP_REG_CS[8]|
							WAP_REG_CS[9]|
							WAP_REG_CS[10]|
							WAP_REG_CS[11]|
							WAP_REG_CS[12]|
							WAP_REG_CS[13]|
							WAP_REG_CS[14]);

   // Output Mux
always @(
	MEM_CTRL_RD_CS or NAND_DMA0_RD_CS or NAND_DMA1_RD_CS or 
	NAND_CTRL0_RD_CS or NAND_CTRL1_RD_CS or WAP_REG_RD_CS or 
	RS_ENC0_CS or RS_ENC1_CS or RS_DEC0_CS or RS_DEC1_CS or 
	STATIC_CS or MEM_CTRL_DIN or WAP_REG_DIN or
	NAND_DMA0_DIN or NAND_DMA1_DIN or NAND_CTRL0_DIN or NAND_CTRL1_DIN or
	STATIC_DIN or RS_ENC0_DIN or RS_ENC1_DIN or
	RS_DEC0_DIN or RS_DEC1_DIN or PageMode_w or PageMode) begin
  case (1'b1)
	PageMode_w		: EXT_SFR_DIN = PageMode;
	MEM_CTRL_RD_CS : 	EXT_SFR_DIN = MEM_CTRL_DIN;
	WAP_REG_RD_CS	: 	EXT_SFR_DIN = WAP_REG_DIN;
	NAND_DMA0_RD_CS:  	EXT_SFR_DIN = NAND_DMA0_DIN;
	NAND_DMA1_RD_CS:  	EXT_SFR_DIN = NAND_DMA1_DIN;
	NAND_CTRL0_RD_CS:	EXT_SFR_DIN = NAND_CTRL0_DIN;
    NAND_CTRL1_RD_CS:  EXT_SFR_DIN = NAND_CTRL1_DIN;
	STATIC_CS	: 	EXT_SFR_DIN = STATIC_DIN;
	RS_ENC0_CS	: 	EXT_SFR_DIN = RS_ENC0_DIN;
	RS_ENC1_CS	: 	EXT_SFR_DIN = RS_ENC1_DIN;
	RS_DEC0_CS	: 	EXT_SFR_DIN = RS_DEC0_DIN;
    RS_DEC1_CS	: 	EXT_SFR_DIN = RS_DEC1_DIN;
	default	:	EXT_SFR_DIN = 8'h00;
  endcase
end //always ext_sfr_din
   
   
endmodule // ESFR_MUX_BANK




