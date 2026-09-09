// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APB_Gpio.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : Gpio
//  =============================================================================

`timescale 1ns/1ps

module Gpio 
(
		//APB
		PCLK         , 
		PRESETn      , 
		PENABLE      , 
		PSEL         , 
		PWRITE       , 
		PADDR        , 
		PWDATA       ,
		PRDATA       ,
		
		// GPIO input
		GpioIn       ,
		
		// GPIO output enable(active high)
		GpioOutEn    ,
		
		// GPIO output
		GpioOut
);
//APB
  input          PCLK    ;     // APB system clock
  input          PRESETn ;     // APB system reset
  input          PENABLE ;     // Data valid strobe 
  input          PSEL    ;     // Module select signal
  input          PWRITE  ;     // Write/nRead signal
  input  [ 7:2]  PADDR   ;     // Address (used bits only)
  input  [31:0]  PWDATA  ;     // Read data
  output [31:0]  PRDATA  ;     // Write data

// Input/Output
  input  [15:0]  GpioIn;
  output [15:0]  GpioOutEn;		// active high
  output [15:0]  GpioOut;

// ADDRESS mapping
// PADDR[3:2] == "00" : Output Enable register
// PADDR[3:2] == "01" : GPIO Input(Read Only)
// PADDR[3:2] == "10" : GPIO output(Write Only)

`define GPIO_OE_ADDR	2'b00
`define GPIO_IN_ADDR	2'b01
`define GPIO_OUT_ADDR	2'b10
 
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

  //APB Signal
  wire        PCLK         ;
  wire        PRESETn      ;
  wire        PENABLE      ;
  wire        PSEL         ;
  wire        PWRITE       ;
  wire [ 7:2] PADDR       ;
  wire [31:0] PWDATA       ;
  
  reg  [15:0] GpioOutEn;
  reg  [15:0] GpioOut;
  reg  [31:0] PRDATA_reg;

reg [31:0] reg_array[31:0];

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		GpioOutEn <= 16'd0;
		GpioOut <= 16'h1233;
	end
	else
	begin
		if(PSEL & (~PENABLE) & PWRITE)
		begin
			if(PADDR[7] == 0)
			begin
				case(PADDR[3:2])
				`GPIO_OE_ADDR: GpioOutEn <= PWDATA[15:0];
				`GPIO_OUT_ADDR: GpioOut <= PWDATA[15:0];
				endcase
			end
			else
			begin
				reg_array[PADDR[6:2]] <= PWDATA[31:0];
			end
		end
	end
end

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		PRDATA_reg <= 32'd0;
	else
	begin
		if(PSEL & (~PENABLE) & (~PWRITE))
		begin
			if(PADDR[7] == 0)
			begin
				case(PADDR[3:2])
				`GPIO_OE_ADDR: PRDATA_reg <= {16'h0000, GpioOutEn};
				`GPIO_IN_ADDR: PRDATA_reg <= {16'h0000, GpioIn};
				`GPIO_OUT_ADDR: PRDATA_reg <= {16'h0000, GpioOut};
				default: PRDATA_reg <= 32'd0;
				endcase
			end
			else
			begin
				PRDATA_reg <= reg_array[PADDR[6:2]];
			end
		end
	end
end

assign PRDATA = {PRDATA_reg};

endmodule

