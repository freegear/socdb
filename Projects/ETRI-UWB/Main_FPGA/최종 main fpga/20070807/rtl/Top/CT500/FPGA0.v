// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : FPGA0.v
// File Revision       : 1.0
// ----------------------------------------------------------------------------
// Purpose            : FPGA0 for ROM interconnection
// --========================================================================--

`timescale 1ns/1ps
module FPGA0 (
		// System Reset & CLK
		nRESET,
		CLK,

		// to FPGA1
		BOOTNAND,
		BOOTCSSWAP,

		// from FPGA1
		ROM_ADDR_FPGA1,
		ROM_DATA_FPGA1,
		ROM_nCS_FPGA1,
		ROM_nOE_FPGA1,

		ROM_ADDR,
		ROM_DATA,
		ROM_CSb,
		ROM_OEb,

		ARMICE_nSRST_FPGA1,
		ARMICE_nTRST_FPGA1,
		ARMICE_TCK_FPGA1,
		ARMICE_RTCK_FPGA1,
		ARMICE_TMS_FPGA1,
		ARMICE_TDI_FPGA1,
		ARMICE_TDO_FPGA1,

		ARMICE_nSRST,
		ARMICE_nTRST,
		ARMICE_TCK,
		ARMICE_RTCK,
		ARMICE_TMS,
		ARMICE_TDI,
		ARMICE_TDO,

		SEIP_ADMCK_FPGA1,
		SEIP_MLRCK_FPGA1,
		SEIP_MSCK_FPGA1,
		SEIP_SDI1_FPGA1,
		SEIP_SDI2_FPGA1,
		SEIP_LRCKO_FPGA1,
		SEIP_SCKO_FPGA1,
		SEIP_SD1O_FPGA1,
		SEIP_SD2O_FPGA1,

		SEIP_ADMCK,
		SEIP_MLRCK,
		SEIP_MSCK,
		SEIP_SDI1,
		SEIP_SDI2,
		SEIP_LRCKO,
		SEIP_SCKO,
		SEIP_SD1O,
		SEIP_SD2O,

		// WAVE ROM Interface
		WAVE_ADDR_FPGA1,
		WAVE_DATA_FPGA1,
		WAVE_nCE_FPGA1,
		WAVE_nWE_FPGA1,
		WAVE_nOE_FPGA1,

		WAVE_ADDR,
		WAVE_DATA,
		WAVE_nCE,
		WAVE_nWE,
		WAVE_nOE,
		WAVE_nWP,		// Write Protection
		WAVE_nBYTE,		// Byte mode enable
		
		UART_TXD_FPGA1,
		UART_RXD_FPGA1,

		MIDI_IN,

		GPIO1,
		// SPI
		SPI_SDO_FPGA1,
		SPI_SDI_FPGA1,
		SPI_SCK_FPGA1,

		SPI_nSS,
		SPI_SDO,
		SPI_SDI,
		SPI_SCK,

		DIP_SW,

		CLK100M_Out
);

input         nRESET;
input         CLK;

output        BOOTNAND;
output        BOOTCSSWAP;

input  [20:0] ROM_ADDR_FPGA1;
output [ 7:0] ROM_DATA_FPGA1;
input         ROM_nCS_FPGA1;
input         ROM_nOE_FPGA1;

output [19:0] ROM_ADDR;
input  [15:0] ROM_DATA;
output        ROM_CSb;
output        ROM_OEb;

inout         ARMICE_nSRST_FPGA1;
output        ARMICE_nTRST_FPGA1;
output        ARMICE_TCK_FPGA1;
input         ARMICE_RTCK_FPGA1;
output        ARMICE_TMS_FPGA1;
output        ARMICE_TDI_FPGA1;
input         ARMICE_TDO_FPGA1;

inout         ARMICE_nSRST;
input         ARMICE_nTRST;
input         ARMICE_TCK;
output        ARMICE_RTCK;
input         ARMICE_TMS;
input         ARMICE_TDI;
output        ARMICE_TDO;

input         SEIP_ADMCK_FPGA1;
input         SEIP_MLRCK_FPGA1;
input         SEIP_MSCK_FPGA1;
output        SEIP_SDI1_FPGA1;
output        SEIP_SDI2_FPGA1;
input         SEIP_LRCKO_FPGA1;
input         SEIP_SCKO_FPGA1;
input         SEIP_SD1O_FPGA1;
input         SEIP_SD2O_FPGA1;

output        SEIP_ADMCK;
output        SEIP_MLRCK;
output        SEIP_MSCK;
input         SEIP_SDI1;
input         SEIP_SDI2;
output        SEIP_LRCKO;
output        SEIP_SCKO;
output        SEIP_SD1O;
output        SEIP_SD2O;

input  [26:0] WAVE_ADDR_FPGA1;
inout  [ 7:0] WAVE_DATA_FPGA1;
input         WAVE_nCE_FPGA1;
input         WAVE_nWE_FPGA1;
input         WAVE_nOE_FPGA1;

output [25:0] WAVE_ADDR;
inout  [ 7:0] WAVE_DATA;
output        WAVE_nCE;
output        WAVE_nWE;
output        WAVE_nOE;
output        WAVE_nWP;
output        WAVE_nBYTE;

input         UART_TXD_FPGA1;
output        UART_RXD_FPGA1;

input         MIDI_IN;

input  [7:0]  GPIO1;
input         SPI_SDO_FPGA1;
output        SPI_SDI_FPGA1;
input         SPI_SCK_FPGA1;

output        SPI_nSS;
output        SPI_SDO;
input         SPI_SDI;
output        SPI_SCK;

input  [ 3:0] DIP_SW;

output        CLK100M_Out;

assign ROM_ADDR = ROM_ADDR_FPGA1[20:1];
assign ROM_CSb = ROM_nCS_FPGA1;
assign ROM_OEb = ROM_nOE_FPGA1;
assign ROM_DATA_FPGA1 = (ROM_CSb == 0 && ROM_OEb == 0) ? ((ROM_ADDR_FPGA1[0] == 0) ? ROM_DATA[7:0] : ROM_DATA[15:8]) : 8'hzz;

assign ARMICE_nTRST_FPGA1 = ARMICE_nTRST;
assign ARMICE_TCK_FPGA1 = ARMICE_TCK;
assign ARMICE_RTCK = ARMICE_RTCK_FPGA1;
assign ARMICE_TMS_FPGA1 = ARMICE_TMS;
assign ARMICE_TDI_FPGA1 = ARMICE_TDI;
assign ARMICE_TDO = ARMICE_TDO_FPGA1;

assign ARMICE_nSRST_FPGA1 = (ARMICE_nSRST === 0 && ARMICE_nSRST_FPGA1 === 1) ? 1'b0 : 1'bz;
assign ARMICE_nSRST       = (ARMICE_nSRST_FPGA1 === 0 && ARMICE_nSRST === 1) ? 1'b0 : 1'bz;

wire   nSYSRESET;
assign nSYSRESET = nRESET & ARMICE_nSRST;
// PLL here
wire        CLK200M;
wire        CLK100M;
wire        CLK50M;

// Clock Generator for FPGA
mypll2x PLL(
	.CLKIN_IN(CLK),
	.CLKDV_OUT(CLK50M),
	.CLKIN_IBUFG_OUT(),
	.CLK0_OUT(CLK100M),
	.CLK2X_OUT(CLK200M),
	.LOCKED_OUT()
);

assign SEIP_ADMCK = SEIP_ADMCK_FPGA1;
assign SEIP_MLRCK = SEIP_MLRCK_FPGA1;
assign SEIP_MSCK = SEIP_MSCK_FPGA1;
assign SEIP_SDI1_FPGA1 = SEIP_SDI1;
assign SEIP_SDI2_FPGA1 = SEIP_SDI2;
assign SEIP_LRCKO = SEIP_LRCKO_FPGA1;
assign SEIP_SCKO = SEIP_SCKO_FPGA1;
assign SEIP_SD1O = SEIP_SD1O_FPGA1;
assign SEIP_SD2O = SEIP_SD2O_FPGA1;

reg [25:0] WAVE_ADDR;
reg        WAVE_nCE;
reg        WAVE_nOE;
reg        WAVE_nWE;
reg [ 7:0] WAVE_DATA_TEMP;

always @(posedge CLK100M or negedge nSYSRESET)
begin
	if(!nSYSRESET)
	begin
		WAVE_ADDR <= 0;
		WAVE_nCE <= 1;
		WAVE_nOE <= 1;
		WAVE_nWE <= 1;
		WAVE_DATA_TEMP <= 0;
	end
	else
	begin
		WAVE_ADDR <= WAVE_ADDR_FPGA1[25:0];
		WAVE_nCE <= WAVE_nCE_FPGA1;
		WAVE_nOE <= WAVE_nOE_FPGA1;
		WAVE_nWE <= WAVE_nWE_FPGA1;
		WAVE_DATA_TEMP <= WAVE_DATA_FPGA1;
	end
end

assign WAVE_DATA = (WAVE_nCE == 0 && WAVE_nWE == 0) ? WAVE_DATA_TEMP : 8'hzz;

/*
assign WAVE_ADDR = WAVE_ADDR_FPGA1[25:0];
assign WAVE_nCE = WAVE_nCE_FPGA1;
assign WAVE_nOE = WAVE_nOE_FPGA1;
assign WAVE_nWE = WAVE_nWE_FPGA1;
assign WAVE_DATA = (WAVE_nCE_FPGA1 == 0 && WAVE_nWE == 0) ? WAVE_DATA_FPGA1 : 8'hzz;
*/
assign WAVE_DATA_FPGA1 = (WAVE_nCE == 0 && WAVE_nOE == 0 && WAVE_nWE != 0) ? WAVE_DATA : 8'hzz;

assign WAVE_nBYTE = 1'b0;			// always BYTE access
assign WAVE_nWP = 1'b1;				// no Write Protection

assign UART_RXD_FPGA1 = MIDI_IN;

wire   SPI_SEL;
assign SPI_SEL = GPIO1[1];
assign SPI_nSS = GPIO1[0];
assign SPI_SDO = SPI_SDO_FPGA1;
assign SPI_SDI_FPGA1 = SPI_SDI;
assign SPI_SCK = SPI_SCK_FPGA1;

assign BOOTNAND  = ~DIP_SW[1];
assign BOOTCSSWAP= DIP_SW[0];

// Clock Output for Test
reg [26:0] CLK100MCnt;
always @(posedge CLK100M or negedge nSYSRESET)
	if(!nSYSRESET)
		CLK100MCnt <= 0;
	else
		CLK100MCnt <= CLK100MCnt + 1;

assign CLK100M_Out = CLK100MCnt[26];

endmodule
