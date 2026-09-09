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
  input  [31:0]  GpioIn;
  output [31:0]  GpioOutEn;		// active high
  output [31:0]  GpioOut;

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
  
  reg  [31:0] GpioOutEn;
  reg  [31:0] GpioOut;
  reg  [31:0] PRDATA_reg;

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		GpioOutEn <= 32'd0;
		GpioOut <= 32'h00001234;
	end
	else
	begin
		if(PSEL & (~PENABLE) & PWRITE)
		begin
			case(PADDR[3:2])
			`GPIO_OE_ADDR: GpioOutEn <= PWDATA[31:0];
			`GPIO_OUT_ADDR: GpioOut <= PWDATA[31:0];
			endcase
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
			case(PADDR[3:2])
			`GPIO_OE_ADDR: PRDATA_reg <= GpioOutEn;
			`GPIO_IN_ADDR: PRDATA_reg <= GpioIn;
			`GPIO_OUT_ADDR: PRDATA_reg <= GpioOut;
			default: PRDATA_reg <= 32'd0;
			endcase
		end
	end
end

assign PRDATA = {PRDATA_reg};

endmodule

