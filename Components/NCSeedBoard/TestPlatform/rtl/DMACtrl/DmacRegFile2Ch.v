// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DmacRegFile2Ch.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : DMA Controler Register File(2 Channel)
//  =============================================================================
`timescale 1ns/1ps

module DmacRegFile2Ch (
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
input  [5:2]  PADDR;
input  [31:0] PWDATA;
output [31:0] PRDATA;

input  [1:0]  Active;
output [1:0]  Enabled;
output [1:0]  Memory2Memory;

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

output [1:0]  Interrupt;
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

// PSEL
reg  [1:0] PSELInternal;
always @(PSEL or PADDR)
begin
	PSELInternal = 0;
	case(PADDR[5])
	1'b0 : PSELInternal = {1'b0, PSEL};
	1'b1 : PSELInternal = {PSEL, 1'b0};
	endcase
end

reg  [31:0] PRDATA;
wire [31:0] PRDATA0;
wire [31:0] PRDATA1;
// PRDATA
always @(PADDR or PRDATA0 or PRDATA1)
begin
	case(PADDR[5])
	1'b0: PRDATA = PRDATA0;
	1'b1: PRDATA = PRDATA1;
	endcase
end

reg  [31:0] Control;
reg  [31:0] SrcAddr;
reg  [31:0] DestAddr;
reg  [31:0] Descriptor;

wire [31:0] Control0;
wire [31:0] SrcAddr0;
wire [31:0] DestAddr0;
wire [31:0] Descriptor0;
wire [31:0] Control1;
wire [31:0] SrcAddr1;
wire [31:0] DestAddr1;
wire [31:0] Descriptor1;
// Register ouptut to Engine
always @(Active or 
		Control0 or SrcAddr0 or DestAddr0 or Descriptor0 or
		Control1 or SrcAddr1 or DestAddr1 or Descriptor1
)
begin
	case(Active)	// synopsys full_case
	2'b01:
	begin
		Control    = Control0;
		SrcAddr    = SrcAddr0;
		DestAddr   = DestAddr0;
		Descriptor = Descriptor0;
	end
	2'b10:
	begin
		Control    = Control1;
		SrcAddr    = SrcAddr1;
		DestAddr   = DestAddr1;
		Descriptor = Descriptor1;
	end
	2'b00:
	begin
		Control    = 32'hxxxxxxxx;
		SrcAddr    = 32'hxxxxxxxx;
		DestAddr   = 32'hxxxxxxxx;
		Descriptor = 32'hxxxxxxxx;
	end
	endcase
end

wire   Channel0;
assign Channel0 = (Active == 2'b01);
wire   ControlWE0;
wire   SrcAddrWE0;
wire   DestAddrWE0;
wire   DescriptorWE0;
wire   StartInterrupt0;
wire   EndInterrupt0;
wire   StopInterrupt0;
wire   ErrorInterrupt0;
assign ControlWE0      = Channel0 & ControlWE;
assign SrcAddrWE0      = Channel0 & SrcAddrWE;
assign DestAddrWE0     = Channel0 & DestAddrWE;
assign DescriptorWE0   = Channel0 & DescriptorWE;
assign StartInterrupt0 = Channel0 & StartInterruptIn;
assign EndInterrupt0   = Channel0 & EndInterruptIn;
assign StopInterrupt0  = Channel0 & StopInterruptIn;
assign ErrorInterrupt0 = Channel0 & ErrorInterruptIn;

wire   Channel1;
assign Channel1 = (Active == 2'b10);
wire   ControlWE1;
wire   SrcAddrWE1;
wire   DestAddrWE1;
wire   DescriptorWE1;
wire   StartInterrupt1;
wire   EndInterrupt1;
wire   StopInterrupt1;
wire   ErrorInterrupt1;
assign ControlWE1      = Channel1 & ControlWE;
assign SrcAddrWE1      = Channel1 & SrcAddrWE;
assign DestAddrWE1     = Channel1 & DestAddrWE;
assign DescriptorWE1   = Channel1 & DescriptorWE;
assign StartInterrupt1 = Channel1 & StartInterruptIn;
assign EndInterrupt1   = Channel1 & EndInterruptIn;
assign StopInterrupt1  = Channel1 & StopInterruptIn;
assign ErrorInterrupt1 = Channel1 & ErrorInterruptIn;

// Channel0 Register
DmacChReg Channel0Reg(
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.PENABLE(PENABLE),
	.PSEL(PSELInternal[0]),
	.PWRITE(PWRITE),
	.PADDR(PADDR[4:2]),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA0),

	.Active(Active[0]),
	.Enabled(Enabled[0]),
	.Memory2Memory(Memory2Memory[0]),

	.Control(Control0),
	.SrcAddr(SrcAddr0),
	.DestAddr(DestAddr0),
	.Descriptor(Descriptor0),
	.Status(),

	.ControlWE(ControlWE0),
	.SrcAddrWE(SrcAddrWE0),
	.DestAddrWE(DestAddrWE0),
	.DescriptorWE(DescriptorWE0),

	.ControlWData(ControlWData),
	.SrcAddrWData(SrcAddrWData),
	.DestAddrWData(DestAddrWData),
	.DescriptorWData(DescriptorWData),

	.StartInterruptIn(StartInterrupt0),
	.EndInterruptIn(EndInterrupt0),
	.ErrorInterruptIn(ErrorInterrupt0),
	.StopInterruptIn(StopInterrupt0),

	.Interrupt(Interrupt[0])
);

// Channel1 Register
DmacChReg Channel1Reg(
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.PENABLE(PENABLE),
	.PSEL(PSELInternal[1]),
	.PWRITE(PWRITE),
	.PADDR(PADDR[4:2]),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA1),

	.Active(Active[1]),
	.Enabled(Enabled[1]),
	.Memory2Memory(Memory2Memory[1]),

	.Control(Control1),
	.SrcAddr(SrcAddr1),
	.DestAddr(DestAddr1),
	.Descriptor(Descriptor1),
	.Status(),

	.ControlWE(ControlWE1),
	.SrcAddrWE(SrcAddrWE1),
	.DestAddrWE(DestAddrWE1),
	.DescriptorWE(DescriptorWE1),

	.ControlWData(ControlWData),
	.SrcAddrWData(SrcAddrWData),
	.DestAddrWData(DestAddrWData),
	.DescriptorWData(DescriptorWData),

	.StartInterruptIn(StartInterrupt1),
	.EndInterruptIn(EndInterrupt1),
	.ErrorInterruptIn(ErrorInterrupt1),
	.StopInterruptIn(StopInterrupt1),

	.Interrupt(Interrupt[1])
);

endmodule
