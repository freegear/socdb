// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DmacRegFile4ChPOR.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : DMA Controler Register File(4 Channel) : Power On Reset 
//  =============================================================================
`timescale 1ns/1ps

module DmacRegFile4ChPOR (
	// APB interface
	PCLK, 
	PRESETn, 
	PENABLE, 
	PSEL,
	PWRITE, 
	PADDR, 
	PWDATA,
	PRDATA,

	DMA_BOOT,
	DMA_BOOT_SRC,
	DMA_BOOT_DST,
	DMA_BOOT_CTRL,

	Active,		// Input  : Indicate active channel(Status register)
	DMAReq,		// Input  : Indicate Dma request asserted(Status register)
	Enabled,	// Output : Channel Enable/Disable indication
	Memory2Memory,	// Output : indicate if memory-to-memory transfer(i.e. no dma request)

	// Register Output
	Control,
	SrcAddr,
	DestAddr,
	Descriptor,

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
input  [6:2]  PADDR;
input  [31:0] PWDATA;
output [31:0] PRDATA;

input         DMA_BOOT;
input  [31:0] DMA_BOOT_SRC;
input  [31:0] DMA_BOOT_DST;
input  [31:0] DMA_BOOT_CTRL;

input  [3:0]  Active;
input  [3:0]  DMAReq;
output [3:0]  Enabled;
output [3:0]  Memory2Memory;

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

output [3:0]  Interrupt;
// Register Output
output [31:0] Descriptor;
output [31:0] SrcAddr;
output [31:0] DestAddr;
output [31:0] Control;

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

//
// Muxes
//

// PSEL
reg  [3:0] PSELInternal;
always @(PSEL or PADDR)
begin
	PSELInternal = 0;
	case(PADDR[6:5])
	2'b00 : PSELInternal = {3'b000, PSEL};
	2'b01 : PSELInternal = {2'b00, PSEL, 1'b0};
	2'b10 : PSELInternal = {1'b0, PSEL, 2'b00};
	2'b11 : PSELInternal = {PSEL, 3'b000};
	endcase
end

reg  [31:0] PRDATA;
wire [31:0] PRDATA0;
wire [31:0] PRDATA1;
wire [31:0] PRDATA2;
wire [31:0] PRDATA3;
// PRDATA
always @(PADDR or PRDATA0 or PRDATA1 or PRDATA2 or PRDATA3)
begin
	case(PADDR[6:5])
	2'b00: PRDATA = PRDATA0;
	2'b01: PRDATA = PRDATA1;
	2'b10: PRDATA = PRDATA2;
	2'b11: PRDATA = PRDATA3;
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
wire [31:0] Control2;
wire [31:0] SrcAddr2;
wire [31:0] DestAddr2;
wire [31:0] Descriptor2;
wire [31:0] Control3;
wire [31:0] SrcAddr3;
wire [31:0] DestAddr3;
wire [31:0] Descriptor3;
// Register ouptut to Engine
always @(Active or 
		Control0 or SrcAddr0 or DestAddr0 or Descriptor0 or
		Control1 or SrcAddr1 or DestAddr1 or Descriptor1 or
		Control2 or SrcAddr2 or DestAddr2 or Descriptor2 or
		Control3 or SrcAddr3 or DestAddr3 or Descriptor3 
)
begin
	case(Active)	// synopsys full_case
	4'b0001:
	begin
		Control    = Control0;
		SrcAddr    = SrcAddr0;
		DestAddr   = DestAddr0;
		Descriptor = Descriptor0;
	end
	4'b0010:
	begin
		Control    = Control1;
		SrcAddr    = SrcAddr1;
		DestAddr   = DestAddr1;
		Descriptor = Descriptor1;
	end
	4'b0100:
	begin
		Control    = Control2;
		SrcAddr    = SrcAddr2;
		DestAddr   = DestAddr2;
		Descriptor = Descriptor2;
	end
	4'b1000:
	begin
		Control    = Control3;
		SrcAddr    = SrcAddr3;
		DestAddr   = DestAddr3;
		Descriptor = Descriptor3;
	end
	4'b0000:
	begin
		Control    = 32'hxxxxxxxx;
		SrcAddr    = 32'hxxxxxxxx;
		DestAddr   = 32'hxxxxxxxx;
		Descriptor = 32'hxxxxxxxx;
	end
	endcase
end

wire   Channel0;
assign Channel0 = Active[0];
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
assign Channel1 = Active[1];
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

wire   Channel2;
assign Channel2 = Active[2];
wire   ControlWE2;
wire   SrcAddrWE2;
wire   DestAddrWE2;
wire   DescriptorWE2;
wire   StartInterrupt2;
wire   EndInterrupt2;
wire   StopInterrupt2;
wire   ErrorInterrupt2;
assign ControlWE2      = Channel2 & ControlWE;
assign SrcAddrWE2      = Channel2 & SrcAddrWE;
assign DestAddrWE2     = Channel2 & DestAddrWE;
assign DescriptorWE2   = Channel2 & DescriptorWE;
assign StartInterrupt2 = Channel2 & StartInterruptIn;
assign EndInterrupt2   = Channel2 & EndInterruptIn;
assign StopInterrupt2  = Channel2 & StopInterruptIn;
assign ErrorInterrupt2 = Channel2 & ErrorInterruptIn;

wire   Channel3;
wire   ControlWE3;
wire   SrcAddrWE3;
wire   DestAddrWE3;
wire   DescriptorWE3;
wire   StartInterrupt3;
wire   EndInterrupt3;
wire   StopInterrupt3;
wire   ErrorInterrupt3;
assign Channel3 = Active[3];
assign ControlWE3      = Channel3 & ControlWE;
assign SrcAddrWE3      = Channel3 & SrcAddrWE;
assign DestAddrWE3     = Channel3 & DestAddrWE;
assign DescriptorWE3   = Channel3 & DescriptorWE;
assign StartInterrupt3 = Channel3 & StartInterruptIn;
assign EndInterrupt3   = Channel3 & EndInterruptIn;
assign StopInterrupt3  = Channel3 & StopInterruptIn;
assign ErrorInterrupt3 = Channel3 & ErrorInterruptIn;

// Channel0 Register
DmacChRegPOR Channel0Reg(
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.PENABLE(PENABLE),
	.PSEL(PSELInternal[0]),
	.PWRITE(PWRITE),
	.PADDR(PADDR[4:2]),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA0),

	.DMA_BOOT(DMA_BOOT),
	.DMA_BOOT_SRC(DMA_BOOT_SRC),
	.DMA_BOOT_DST(DMA_BOOT_DST),
	.DMA_BOOT_CTRL(DMA_BOOT_CTRL),

	.Active(Active[0]),
	.DMAReq(DMAReq[0]),
	.Enabled(Enabled[0]),
	.Memory2Memory(Memory2Memory[0]),

	.Control(Control0),
	.SrcAddr(SrcAddr0),
	.DestAddr(DestAddr0),
	.Descriptor(Descriptor0),

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
	.DMAReq(DMAReq[1]),
	.Enabled(Enabled[1]),
	.Memory2Memory(Memory2Memory[1]),

	.Control(Control1),
	.SrcAddr(SrcAddr1),
	.DestAddr(DestAddr1),
	.Descriptor(Descriptor1),

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

// Channel2 Register
DmacChReg Channel2Reg(
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.PENABLE(PENABLE),
	.PSEL(PSELInternal[2]),
	.PWRITE(PWRITE),
	.PADDR(PADDR[4:2]),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA2),

	.Active(Active[2]),
	.DMAReq(DMAReq[2]),
	.Enabled(Enabled[2]),
	.Memory2Memory(Memory2Memory[2]),

	.Control(Control2),
	.SrcAddr(SrcAddr2),
	.DestAddr(DestAddr2),
	.Descriptor(Descriptor2),

	.ControlWE(ControlWE2),
	.SrcAddrWE(SrcAddrWE2),
	.DestAddrWE(DestAddrWE2),
	.DescriptorWE(DescriptorWE2),

	.ControlWData(ControlWData),
	.SrcAddrWData(SrcAddrWData),
	.DestAddrWData(DestAddrWData),
	.DescriptorWData(DescriptorWData),

	.StartInterruptIn(StartInterrupt2),
	.EndInterruptIn(EndInterrupt2),
	.ErrorInterruptIn(ErrorInterrupt2),
	.StopInterruptIn(StopInterrupt2),

	.Interrupt(Interrupt[2])
);

// Channel3 Register
DmacChReg Channel3Reg(
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.PENABLE(PENABLE),
	.PSEL(PSELInternal[3]),
	.PWRITE(PWRITE),
	.PADDR(PADDR[4:2]),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA3),

	.Active(Active[3]),
	.DMAReq(DMAReq[3]),
	.Enabled(Enabled[3]),
	.Memory2Memory(Memory2Memory[3]),

	.Control(Control3),
	.SrcAddr(SrcAddr3),
	.DestAddr(DestAddr3),
	.Descriptor(Descriptor3),

	.ControlWE(ControlWE3),
	.SrcAddrWE(SrcAddrWE3),
	.DestAddrWE(DestAddrWE3),
	.DescriptorWE(DescriptorWE3),

	.ControlWData(ControlWData),
	.SrcAddrWData(SrcAddrWData),
	.DestAddrWData(DestAddrWData),
	.DescriptorWData(DescriptorWData),

	.StartInterruptIn(StartInterrupt3),
	.EndInterruptIn(EndInterrupt3),
	.ErrorInterruptIn(ErrorInterrupt3),
	.StopInterruptIn(StopInterrupt3),

	.Interrupt(Interrupt[3])
);

endmodule
