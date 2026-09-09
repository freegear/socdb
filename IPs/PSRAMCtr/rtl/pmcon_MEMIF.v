// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name        : pmcon_APBmemIF.v
// File Revision    : 0.1 
//  -----------------------------------------------------------------------------
//  Purpose         : Pseudo SRAM controller  AMBA3 APB interface
//  =============================================================================

// This module is PSRAM controller Memory Interface module. ( Ready APB)

`timescale 1ns/1ps

module pmcon_MEMIF (
		PSEL,
		PENABLE,
		PREADY,
		PWRITE,
		PRDATA,
		//---------
		DataRWAvail,
		Read,
		Write,
		PSRAMRDATA//,
	);

/// 4Mbyte addressing (LSB bit omit)

input 		PSEL;
input 		PENABLE;

output		PREADY; // AMBA3 APB Signal  
input 		PWRITE;
output	[31:0]	PRDATA;

input		DataRWAvail;
output		Read;
output		Write;
input	[31:0]	PSRAMRDATA;


assign	Read 	= (PSEL&~PENABLE&~PWRITE); // read request signal
assign	Write 	= (PSEL&~PENABLE&PWRITE);  // Write request signal



// Generate PREADY signal
assign PREADY = DataRWAvail;

// PSRAM DATA Register PRDATA output
assign PRDATA = PSRAMRDATA;

endmodule

