// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APB_SRAM.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : SRAM on APB
//  =============================================================================
`timescale 1ns/1ps

module APB_SRAM(
	// APB interface
	PCLK, 
	PRESETn, 
	PENABLE, 
	PSEL,
	PWRITE, 
	PADDR, 
	PWDATA,
	PRDATA,
	PREADY
);

parameter ADDR_WIDTH = 12;

// APB interface
input         PCLK;
input         PRESETn;
input         PENABLE; 
input         PSEL;
input         PWRITE;
input  [ADDR_WIDTH+1:2]  PADDR;
input  [31:0] PWDATA;
output [31:0] PRDATA;
output        PREADY;

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

wire        PCLK;
wire        PRESETn;
wire        PENABLE;
wire        PSEL;
wire        PWRITE;
wire [ADDR_WIDTH+1:2]  PADDR;
wire [31:0] PWDATA;
reg  [31:0] PRDATA;
reg         PREADY;
  
reg         PREADY_Temp;
always @ (posedge PCLK)
	PREADY_Temp = $random/16;

always @ (posedge PCLK)
	PREADY = PREADY_Temp;

reg  [31:0] mem_array[{ADDR_WIDTH{1'b1}}:0];

//
// APB interface part
//

wire APB_WriteEnable;
assign APB_WriteEnable = PSEL & PENABLE & PWRITE & PREADY;
// Register writing
always @ (posedge PCLK)
begin
	if(APB_WriteEnable)
		mem_array[PADDR[ADDR_WIDTH+1:2]] <= PWDATA[31:0];
end

// Register reading
always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		PRDATA <= 32'h00000000;
	else if(PSEL & (~PWRITE) & PREADY_Temp)
		PRDATA <= mem_array[PADDR[ADDR_WIDTH+1:2]];
	else
		PRDATA <= 32'hxxxxxxxx;	// Test purpose
end
endmodule

