// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : SMC_REG.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : sram controller
//  =============================================================================
`timescale 1ns/10ps
`include "SMC.vh"
module SMC_REG(
    BOOT_WIDTH  ,

	PCLK		,
	PRESETn 	,
	PADDR   	,
	PSEL    	,
	PENABLE 	,
	PWRITE  	,
	PWDATA  	,
	PRDATA  	,

	SRAM_START	,
	BANK_SEL	,
	            
	ADDR_SETUP  ,
	ADDR_HOLD   ,
	CS_SETUP    ,
	CS_HOLD     ,
	ACC_CYCLE   ,
	BUS_WIDTH   ,
	ADDR_SHIFT  );
input [1:0]             BOOT_WIDTH   ;	// 00 : 8 bit, 01 : 16bit, 10 : 32bit

input		 			PCLK		;
input		 			PRESETn 	;
input [5:2]	 			PADDR   	;
input		 			PSEL    	;
input 		 			PENABLE 	;
input 		 			PWRITE  	;
input [31:0] 			PWDATA  	;
output[31:0] 			PRDATA  	;

input					SRAM_START	;
input [`BANK_SIZE-1:0]	BANK_SEL	;

output[2:0]				ADDR_SETUP 	;
output[2:0]				ADDR_HOLD  	;
output[2:0]				CS_SETUP   	;
output[2:0]	 			CS_HOLD    	;
output[3:0]				ACC_CYCLE  	; 
output[1:0]				BUS_WIDTH  	;
output[1:0]				ADDR_SHIFT 	;		

// INTERNAL SIGNAL
reg[19:0]	bank_reg[`BANK_SIZE-1:0];
//reg[15:0]	bank_reg[`BANK_SIZE-1:0];

wire		reg_wr;
wire		reg_rd;
//reg[15:0]	bank_reg_out;
reg[19:0]	bank_reg_out;

assign	reg_wr = (PSEL & PENABLE & PWRITE);
assign  reg_rd = (PSEL & PENABLE & ~PWRITE);


// bank0 reg : 0x01FF8100
// bank1 reg : 0x01FF8104
// bank2 reg : 0x01FF8108
// bank3 reg : 0x01FF810C

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn) begin
		//       addr_setup,cs_setup,acc_cycle,cs_hold,addr_hold,bus_width,addr_shift)
		bank_reg[0]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111,    BOOT_WIDTH,     BOOT_WIDTH};
//		bank_reg[0]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111};
		bank_reg[1]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111,    2'b01,     2'b01};	// halfword with 1 shift
//		bank_reg[1]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111};
		bank_reg[2]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111,    2'b01,     2'b01};	// halfword with 1 shift
//		bank_reg[2]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111};
		bank_reg[3]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111,    2'b01,     2'b01};	// halfword with 1 shift
//		bank_reg[3]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111};
		bank_reg[4]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111,    2'b01,     2'b01};	// halfword with 1 shift
//		bank_reg[4]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111};
		bank_reg[5]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111,    2'b01,     2'b01};	// halfword with 1 shift
//		bank_reg[5]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111};
		bank_reg[6]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111,    2'b01,     2'b01};	// halfword with 1 shift
//		bank_reg[6]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111};
		bank_reg[7]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111,    2'b01,     2'b01};	// halfword with 1 shift
//		bank_reg[7]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111};
		bank_reg[8]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111,    2'b01,     2'b01};	// halfword with 1 shift
//		bank_reg[8]<={3'b111,  3'b111,  4'b1111, 3'b111,   3'b111};
	end
	else begin
		if(reg_wr) begin
			case(PADDR[5:2])
			4'b0000: bank_reg[0] <= PWDATA[19:4];
			4'b0001: bank_reg[1] <= PWDATA[19:4];
			4'b0010: bank_reg[2] <= PWDATA[19:4];
			4'b0011: bank_reg[3] <= PWDATA[19:4];
			4'b0100: bank_reg[4] <= PWDATA[19:4];
			4'b0101: bank_reg[5] <= PWDATA[19:4];
			4'b0110: bank_reg[6] <= PWDATA[19:4];
			4'b0111: bank_reg[7] <= PWDATA[19:4];
			default: bank_reg[8] <= PWDATA[19:4];
			endcase
		end
	end
end

always @(BANK_SEL or bank_reg[0] or bank_reg[1] or bank_reg[2] or bank_reg[3] or bank_reg[4] or SRAM_START)
begin
//	if(!SRAM_START) begin
		case(BANK_SEL)
			9'b000000001: bank_reg_out <= bank_reg[0];//ibank_reg0;
			9'b000000010: bank_reg_out <= bank_reg[1];//ibank_reg1;
			9'b000000100: bank_reg_out <= bank_reg[2];//ibank_reg2;
			9'b000001000: bank_reg_out <= bank_reg[3];//ibank_reg3;
			9'b000010000: bank_reg_out <= bank_reg[4];//ibank_reg3;
			9'b000100000: bank_reg_out <= bank_reg[5];//ibank_reg3;
			9'b001000000: bank_reg_out <= bank_reg[6];//ibank_reg3;
			9'b010000000: bank_reg_out <= bank_reg[7];//ibank_reg3;
			default: bank_reg_out <= bank_reg[8];//ibank_reg4;
		endcase
//	end
//	else
//		bank_reg_out<=bank_reg_out;
end

assign PRDATA	  = (reg_rd == 1) ?  {((PADDR[5] == 0) ? bank_reg[PADDR[4:2]] : bank_reg[8]), 4'b0000} : 0;
/*
assign ADDR_SETUP = bank_reg_out[15:13];
assign CS_SETUP   = bank_reg_out[12:10];
assign ACC_CYCLE  = bank_reg_out[ 9:6 ];
assign CS_HOLD	  = bank_reg_out[ 5:3 ];
assign ADDR_HOLD  = bank_reg_out[ 2:0 ];
//assign BUS_WIDTH  = bank_reg_out[ 3:2 ];
//assign ADDR_SHIFT = bank_reg_out[ 1:0 ];
assign BUS_WIDTH  = 2'b00;	// always byte
assign ADDR_SHIFT = 2'b00;	// no address shift
*/
assign ADDR_SETUP = bank_reg_out[19:17];
assign CS_SETUP   = bank_reg_out[16:14];
assign ACC_CYCLE  = bank_reg_out[13:10];
assign CS_HOLD	  = bank_reg_out[ 9:7 ];
assign ADDR_HOLD  = bank_reg_out[ 6:4 ];
assign BUS_WIDTH  = bank_reg_out[ 3:2 ];
assign ADDR_SHIFT = bank_reg_out[ 1:0 ];

endmodule
