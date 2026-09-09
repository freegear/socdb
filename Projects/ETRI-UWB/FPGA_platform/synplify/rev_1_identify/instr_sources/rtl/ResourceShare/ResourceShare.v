// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : ResourceShare.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : Resource Share(DMA mux & Pin mux & Etc)
//  =============================================================================

`timescale 1ns/1ps

module ResourceShare 
(
		//APB
		PCLK, 
		PRESETn, 
		PENABLE, 
		PSEL, 
		PWRITE, 
		PADDR, 
		PWDATA,
		PRDATA,
		
		DMAMux,			// 8 Channel DMA mux
		I2SInputMux,	// I2S Input Mux(FPGA Test Only ?)
		WaveROMHAddr,	// WaveROM High Address 3 bit
		WaveROMOwner,	// CS0(WaveROM) Onwership(SYSTEM or SEIP)
		SRAMOwner		// Internal SRAM Ownership(SYSTEM or SEIP)
);

//APB
input          PCLK    ;     // APB system clock
input          PRESETn ;     // APB system reset
input          PENABLE ;     // Data valid strobe 
input          PSEL    ;     // Module select signal
input          PWRITE  ;     // Write/nRead signal
input  [ 4:2]  PADDR   ;     // Address (used bits only)
input  [31:0]  PWDATA  ;     // Read data
output [31:0]  PRDATA  ;     // Write data

// Input/Output
output [31:0]  DMAMux;
output [ 1:0]  I2SInputMux;
output [ 2:0]  WaveROMHAddr;
output         WaveROMOwner;
output         SRAMOwner;

// register map
`define SYSCTRL_SRAMOWNER_ADDR	3'b000
`define SYSCTRL_DMAMUX_ADDR		3'b001
 
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

  //APB Signal
wire        PCLK;
wire        PRESETn;
wire        PENABLE;
wire        PSEL;
wire        PWRITE;
wire [ 4:2] PADDR;
wire [31:0] PWDATA;
  
reg  [31:0] DMAMux;
reg  [ 1:0] I2SInputMux;
reg  [ 2:0] WaveROMHAddr;
reg         WaveROMOwner;
reg         SRAMOwner;

reg  [31:0] PRDATA;

wire APBWrite;
assign APBWrite = PSEL & (~PENABLE) & PWRITE;

wire APBRead;
assign APBRead = PSEL & (~PENABLE) & (~PWRITE);

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		DMAMux   <= 32'h76543210;
		I2SInputMux  <= 0;
		WaveROMHAddr <= 0;
		WaveROMOwner <= 0;
		SRAMOwner <= 0;
	end
	else
	begin
		if(APBWrite)
		begin
			case(PADDR[4:2])
			`SYSCTRL_SRAMOWNER_ADDR:
				begin
					WaveROMHAddr <= PWDATA[6:4];
					I2SInputMux  <= PWDATA[3:2];
					WaveROMOwner <= PWDATA[1];
					SRAMOwner    <= PWDATA[0];
				end
			`SYSCTRL_DMAMUX_ADDR:    DMAMux  <= PWDATA;
			endcase
		end
	end
end

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		PRDATA <= 32'd0;
	else
	begin
		if(APBRead)
		begin
			case(PADDR[4:2])
			`SYSCTRL_SRAMOWNER_ADDR: PRDATA <= {25'd0, WaveROMHAddr, I2SInputMux, WaveROMOwner, SRAMOwner};
			`SYSCTRL_DMAMUX_ADDR:    PRDATA <= DMAMux;
			default: PRDATA <= 32'd0;
			endcase
		end
	end
end

endmodule

