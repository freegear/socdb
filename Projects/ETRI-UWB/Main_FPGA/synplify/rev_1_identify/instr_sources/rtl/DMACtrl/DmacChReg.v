// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DmacChReg.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : DMA Controler Channel Register
//  =============================================================================
`timescale 1ns/1ps

module DmacChReg (
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
	DMAReq,		// Input  : Indicate DMAReq asserted(Status register)
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
input  [4:2]  PADDR;
input  [31:0] PWDATA;
output [31:0] PRDATA;

input         Active;
input         DMAReq;
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

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

wire        PCLK;
wire        PRESETn;
wire        PENABLE;
wire        PSEL;
wire        PWRITE;
wire [4:2]  PADDR;
wire [31:0] PWDATA;
reg  [31:0] PRDATA;

// 5 programmable register
wire [31:0] Descriptor;
reg  [31:0] SrcAddr;
reg  [31:0] DestAddr;
wire [31:0] Control;
wire [31:0] Status;

// Descriptor Register
reg  [31:2] DescriptorAddr;
reg         DescriptorEnd;

// Control Register
reg         StartIntEn;
reg         EndIntEn;
reg         MtoM;
reg         SrcIncr;
reg  [1:0]  SrcWidth;
reg         DstIncr;
reg  [1:0]  DstWidth;
reg  [2:0]  Size;
reg  [19:0] Length;

// Status Register
reg         Enable;
reg         StopIntEn;
reg         StopInt;
reg         StartInt;
reg         EndInt;
reg         ErrInt;
wire        Enabled;
assign      Enabled = Enable & (~StopInt) & ~(ErrInt);

// address for each register
parameter SrcAddrAddr    = 3'b000;
parameter DestAddrAddr   = 3'b001;
parameter ControlAddr    = 3'b010;
parameter DescAddr       = 3'b011;
parameter StatusAddr     = 3'b100;
//
// APB interface part
//
wire APB_WriteEnable;
wire APB_ReadEnable;

assign APB_WriteEnable = PSEL & (~PENABLE) & PWRITE;
assign APB_ReadEnable  = PSEL & (~PENABLE) & (~PWRITE);

// Register writings

// Descriptor Register
always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		DescriptorAddr <= 0;
		DescriptorEnd  <= 0;
	end
	else if(APB_WriteEnable & PADDR == DescAddr)
	begin
		DescriptorAddr <= PWDATA[31:2];
		DescriptorEnd  <= PWDATA[0];
	end
	else if(DescriptorWE == 1'b1)
	begin
		DescriptorAddr <= DescriptorWData[31:2];
		DescriptorEnd  <= DescriptorWData[0];
	end
end
assign Descriptor = {DescriptorAddr[31:2], 1'b0, DescriptorEnd};

always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		SrcAddr <= 0;
	else if(APB_WriteEnable & PADDR == SrcAddrAddr)
		SrcAddr <= PWDATA[31:0];
	else if(SrcAddrWE == 1'b1)
		SrcAddr <= SrcAddrWData;
end

always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		DestAddr <= 0;
	else if(APB_WriteEnable & PADDR == DestAddrAddr)
		DestAddr <= PWDATA[31:0];
	else if(DestAddrWE == 1'b1)
		DestAddr <= DestAddrWData;
end

always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		StartIntEn <= 0;
		EndIntEn   <= 0;
		MtoM       <= 0;
		SrcIncr    <= 0;
		SrcWidth   <= 0;
		DstIncr    <= 0;
		DstWidth   <= 0;
		Size       <= 0;
		Length     <= 0;
	end
	else if(APB_WriteEnable & PADDR == ControlAddr)
	begin
		StartIntEn <= PWDATA[31];
		EndIntEn   <= PWDATA[30];
		MtoM       <= PWDATA[29];
		SrcIncr    <= PWDATA[28];
		SrcWidth   <= PWDATA[27:26];
		DstIncr    <= PWDATA[25];
		DstWidth   <= PWDATA[24:23];
		Size       <= PWDATA[22:20];
		Length     <= PWDATA[19:0];
	end
	else if(ControlWE == 1'b1)
	begin
		StartIntEn <= ControlWData[31];
		EndIntEn   <= ControlWData[30];
		MtoM       <= ControlWData[29];
		SrcIncr    <= ControlWData[28];
		SrcWidth   <= ControlWData[27:26];
		DstIncr    <= ControlWData[25];
		DstWidth   <= ControlWData[24:23];
		Size       <= ControlWData[22:20];
		Length     <= ControlWData[19:0];
	end
end
assign Control = {StartIntEn, EndIntEn, MtoM, SrcIncr, SrcWidth, DstIncr, DstWidth, Size, Length};


wire StartIntEnable;
wire EndIntEnable;
wire StopIntEnable;

assign StartIntEnable = Control[31];
assign EndIntEnable = Control[30];
assign StopIntEnable = Status[4];

always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		Enable <= 0;
		StopIntEn <= 0;
		StopInt <= 0;
		StartInt <= 0;
		EndInt <= 0;
		ErrInt <= 0;
	end
	else if(APB_WriteEnable & PADDR == StatusAddr)
	begin
		Enable <= PWDATA[31];
		StopIntEn <= PWDATA[4];
		if(PWDATA[3] == 1)
			StopInt <= 0;
		if(PWDATA[2] == 1)
			StartInt <= 0;
		if(PWDATA[1] == 1)
			EndInt <= 0;
		if(PWDATA[0] == 1)
			ErrInt <= 0;
	end
	else
	begin
//		if(StopInterruptIn == 1 || ErrorInterruptIn == 1)
//			Enable <= 0;
		ErrInt   <= ErrInt   | ErrorInterruptIn;
		EndInt   <= EndInt   | (EndInterruptIn&EndIntEn);
		StartInt <= StartInt | (StartInterruptIn&StartIntEn);
		StopInt  <= StopInt  | StopInterruptIn;
	end
end

assign Status = {Enable, 3'b000, Active, DMAReq, 1'b0, 20'h00000, StopIntEn, StopInt, StartInt, EndInt, ErrInt};
assign Memory2Memory = MtoM;

assign Interrupt = ErrInt|EndInt|StartInt|(StopInt&StopIntEn);

// Register reading
always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		PRDATA <= 32'h00000000;
	else if(PSEL & (~PENABLE) & (~PWRITE))
	begin
		case(PADDR)
		DescAddr     : PRDATA <= Descriptor;
		SrcAddrAddr  : PRDATA <= SrcAddr;
		DestAddrAddr : PRDATA <= DestAddr;
		ControlAddr  : PRDATA <= Control;
		default      : PRDATA <= Status;
		endcase
	end
end

endmodule
