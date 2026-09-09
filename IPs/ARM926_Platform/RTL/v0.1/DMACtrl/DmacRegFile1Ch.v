// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DmacRegFile21h.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : DMA Controler Register File(1 Channel)
//  =============================================================================
`timescale 1ns/1ps

module DmacRegFile1Ch (
	// APB interface
	PCLK, 
	PRESETn, 
	PENABLE, 
	PSEL,
	PWRITE, 
	PADDR, 
	PWDATA,
	PRDATA,

	Active,		// Input  : Indicate active channel(Status register)
	Enabled,	// Output : Channel Enable/Disable indication
	Memory2Memory,	// Output : indicate if memory-to-memory transfer(i.e. no dma request)

	// Register Output
	Control,
	SrcAddr,
	DestAddr,
	Descriptor,
	Status,

	// write interface for other DMA part
	ControlWE,
	SrcAddrWE,
	DestAddrWE,
	DescriptorWE,

	ControlWData,
	SrcAddrWData,
	DestAddrWData,
	DescriptorWData,

	StartInterruptIn,
	EndInterruptIn,
	ErrorInterruptIn,
	StopInterruptIn,

	Interrupt			// Output : Interrupt output
);

// APB interface
input         PCLK;
input         PRESETn;
input         PENABLE; 
input         PSEL;
input         PWRITE;
input  [4:2]  PADDR;
input  [31:0] PWDATA;
output [31:0] PRDATA;

input         Active;
output        Enabled;
output        Memory2Memory;

input         ControlWE;
input         SrcAddrWE;
input         DestAddrWE;
input         DescriptorWE;

input  [31:0] ControlWData;
input  [31:0] SrcAddrWData;
input  [31:0] DestAddrWData;
input  [31:0] DescriptorWData;

input         StartInterruptIn;
input         EndInterruptIn;
input         ErrorInterruptIn;
input         StopInterruptIn;

output        Interrupt;
// Register Output
output [31:0] Descriptor;
output [31:0] SrcAddr;
output [31:0] DestAddr;
output [31:0] Control;
output [31:0] Status;

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

//
// Muxes
//

wire [31:0] Control;
wire [31:0] SrcAddr;
wire [31:0] DestAddr;
wire [31:0] Descriptor;

// Channel0 Register
DmacChReg Channel0Reg(
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.PENABLE(PENABLE),
	.PSEL(PSEL),
	.PWRITE(PWRITE),
	.PADDR(PADDR[4:2]),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA),

	.Active(Active),
	.Enabled(Enabled),
	.Memory2Memory(Memory2Memory),

	.Control(Control),
	.SrcAddr(SrcAddr),
	.DestAddr(DestAddr),
	.Descriptor(Descriptor),
	.Status(),

	.ControlWE(ControlWE),
	.SrcAddrWE(SrcAddrWE),
	.DestAddrWE(DestAddrWE),
	.DescriptorWE(DescriptorWE),

	.ControlWData(ControlWData),
	.SrcAddrWData(SrcAddrWData),
	.DestAddrWData(DestAddrWData),
	.DescriptorWData(DescriptorWData),

	.StartInterruptIn(StartInterruptIn),
	.EndInterruptIn(EndInterruptIn),
	.ErrorInterruptIn(ErrorInterruptIn),
	.StopInterruptIn(StopInterruptIn),

	.Interrupt(Interrupt)
);

endmodule
