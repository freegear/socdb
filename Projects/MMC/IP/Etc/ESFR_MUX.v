// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : ESFR_MUX.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : ESFR Select Decoder & Mux
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module ESFR_MUX(
	RESETn,
	CLK,
	EXT_SFR_ADDR,
	EXT_SFR_WR,
	EXT_SFR_DOUT,	
	EXT_SFR_DIN,

	//Nand Setting Registers
	/*
	IOWidthPinIn0,
	NandWidthPinIn0,
	BootCfgPinIn0,
	OutDtmnPinIn0,

	IOWidthPinIn1,
	NandWidthPinIn1,
	BootCfgPinIn1,
	OutDtmnPinIn1,
	*/
	MEM_CTRL_DIN, 
	WAP_REG_DIN,
	STATIC_DIN,
	NAND_DMA0_DIN,
	NAND_DMA1_DIN,
	NAND_CTRL0_DIN,
	NAND_CTRL1_DIN,
	RS_ENC0_DIN,
	RS_ENC1_DIN,
	RS_DEC0_DIN,
	RS_DEC1_DIN,

	MEM_CTRL_CS, 
	WAP_REG_CS,
	STATIC_CS,
	NAND_DMA0_CS,
	NAND_DMA1_CS,
	NAND_CTRL0_CS,
	NAND_CTRL1_CS,
	RS_ENC0_CS,
	RS_ENC1_CS,
	RS_DEC0_CS,
	RS_DEC1_CS
);

input			RESETn;
input			CLK;
input	[7:0]	EXT_SFR_ADDR;
input			EXT_SFR_WR;
input	[7:0]	EXT_SFR_DOUT;
output	[7:0]	EXT_SFR_DIN;
/*
output			IOWidthPinIn0;
output			NandWidthPinIn0;
output	[1:0]	BootCfgPinIn0;
output			OutDtmnPinIn0;

output			IOWidthPinIn1;
output			NandWidthPinIn1;
output	[1:0]	BootCfgPinIn1;
output			OutDtmnPinIn1;
*/
input	[7:0]	MEM_CTRL_DIN; 
input	[7:0]	WAP_REG_DIN;
input	[7:0]	STATIC_DIN;
input	[7:0]	NAND_DMA0_DIN;
input	[7:0]	NAND_DMA1_DIN;
input	[7:0]	NAND_CTRL0_DIN;
input	[7:0]	NAND_CTRL1_DIN;
input	[7:0]	RS_ENC0_DIN;
input	[7:0]	RS_ENC1_DIN;
input	[7:0]	RS_DEC0_DIN;
input	[7:0]	RS_DEC1_DIN;

output			MEM_CTRL_CS;
output			WAP_REG_CS;
output			STATIC_CS;
output			NAND_DMA0_CS;
output			NAND_DMA1_CS;
output			NAND_CTRL0_CS;
output			NAND_CTRL1_CS;
output			RS_ENC0_CS;
output			RS_ENC1_CS;
output			RS_DEC0_CS;
output			RS_DEC1_CS;

wire		MEM_CTRL_CS;
wire		WAP_REG_CS;
wire		STATIC_CS;
wire		NAND_DMA0_CS;
wire		NAND_DMA1_CS;
wire		NAND_CTRL0_CS;
wire		NAND_CTRL1_CS;
wire		RS_ENC0_CS;
wire		RS_ENC1_CS;
wire		RS_DEC0_CS;
wire		RS_DEC1_CS;

reg	[7:0]	EXT_SFR_DIN;
reg	[2:0]	PageMode;

wire		General_Mode	= (PageMode ==3'b000);
wire		RSEnc_Mode		= (PageMode ==3'b001);
wire		RSDec0_Mode		= (PageMode ==3'b010);
wire		RSDec1_Mode		= (PageMode ==3'b011);
wire		Static_Mode		= (PageMode ==3'b100);
wire		PageMode_w = (EXT_SFR_ADDR == 8'b11111111) && (EXT_SFR_WR);


assign		MEM_CTRL_CS = (General_Mode) & (EXT_SFR_ADDR[7:2]==6'b100000);
assign		NAND_DMA0_CS= (General_Mode) & (EXT_SFR_ADDR[7:3]==5'b10001);
assign		NAND_DMA1_CS= (General_Mode) & (EXT_SFR_ADDR[7:3]==5'b10010);
assign		NAND_CTRL0_CS=(General_Mode) & (EXT_SFR_ADDR[7:4]==4'b1010);
assign		NAND_CTRL1_CS=(General_Mode) & (EXT_SFR_ADDR[7:4]==4'b1011);
assign		WAP_REG_CS	= (General_Mode) & (EXT_SFR_ADDR[7:4]==4'b1100);

assign		RS_ENC0_CS	= (RSEnc_Mode) & (EXT_SFR_ADDR[7:6]==2'b10);
assign		RS_ENC1_CS	= (RSEnc_Mode) & (EXT_SFR_ADDR[7:6]==2'b11);

assign		RS_DEC0_CS	= (RSDec0_Mode) & (EXT_SFR_ADDR[7]);
assign		RS_DEC1_CS	= (RSDec1_Mode) & (EXT_SFR_ADDR[7]);

assign		STATIC_CS	= (Static_Mode)&(EXT_SFR_ADDR[7]);


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	PageMode <= 0;
	else if (PageMode_w)
	PageMode <= EXT_SFR_DOUT[7:5];
end

// Output Mux
always @( 
MEM_CTRL_CS or NAND_DMA0_CS or NAND_DMA1_CS or 
NAND_CTRL0_CS or NAND_CTRL1_CS or WAP_REG_CS or 
RS_ENC0_CS or RS_ENC1_CS or RS_DEC0_CS or RS_DEC1_CS or 
STATIC_CS or MEM_CTRL_DIN or WAP_REG_DIN or STATIC_DIN or
NAND_DMA0_DIN or NAND_DMA1_DIN or RS_ENC0_DIN or 
RS_ENC1_DIN or RS_DEC0_DIN or RS_DEC1_DIN)
begin
	case (1'b1)
		MEM_CTRL_CS : 	EXT_SFR_DIN = MEM_CTRL_DIN;
		WAP_REG_CS	: 	EXT_SFR_DIN = WAP_REG_DIN;
		STATIC_CS	: 	EXT_SFR_DIN = STATIC_DIN;
		NAND_DMA0_CS:  	EXT_SFR_DIN = NAND_DMA0_DIN;
		NAND_DMA1_CS:  	EXT_SFR_DIN = NAND_DMA1_DIN;
		NAND_CTRL0_CS:	EXT_SFR_DIN = NAND_CTRL0_DIN;
	    NAND_CTRL1_CS:  EXT_SFR_DIN = NAND_CTRL1_DIN;
		RS_ENC0_CS	: 	EXT_SFR_DIN = RS_ENC0_DIN;
		RS_ENC1_CS	: 	EXT_SFR_DIN = RS_ENC1_DIN;
		RS_DEC0_CS	: 	EXT_SFR_DIN = RS_DEC0_DIN;
	    RS_DEC1_CS	: 	EXT_SFR_DIN = RS_DEC1_DIN;
	default	:	EXT_SFR_DIN = 8'd0;
	endcase
end


endmodule
