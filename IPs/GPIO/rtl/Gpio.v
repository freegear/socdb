// ==============================================================================
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : Gpio.v
// File Revision       : 3.0 CT500(TSMC)
//  -----------------------------------------------------------------------------
//  Purpose            : 64bit Gpio
//  =============================================================================

`timescale 1ns/1ps

`define EXT_INT_SUPPORT
module Gpio 
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
		
`ifdef EXT_INT_SUPPORT
		Interrupt,
`endif

		// GPIO input
		GpioIn,
		
		// GPIO output enable(active high)
		GpioOutEn,
		
		// GPIO output
		GpioOut

);

//APB
input          PCLK    ;     // APB system clock
input          PRESETn ;     // APB system reset
input          PENABLE ;     // Data valid strobe 
input          PSEL    ;     // Module select signal
input          PWRITE  ;     // Write/nRead signal
`ifdef EXT_INT_SUPPORT
input  [ 4:2]  PADDR   ;     // Address (used bits only)
`else
input  [ 3:2]  PADDR   ;     // Address (used bits only)
`endif
input  [31:0]  PWDATA  ;     // Read data
output [31:0]  PRDATA  ;     // Write data

// Input/Output
input  [31:0]  GpioIn;
output [31:0]  GpioOutEn;		// active high
output [31:0]  GpioOut;

`ifdef EXT_INT_SUPPORT
output Interrupt;
`endif


`ifdef EXT_INT_SUPPORT
// register map
`define GPIO_OE_ADDR	3'b000
`define GPIO_IN_ADDR	3'b001
`define GPIO_OUT_ADDR	3'b010

`define GPIO_INTSTAT	3'b011		// interrupt status
`define GPIO_INTMASK	3'b100		// interrupt mask
`define GPIO_INTLEVEL	3'b101		// interrupt level(1)/edge(0)
`define GPIO_INTPOL		3'b110		// interrupt polarity active high(1)/acitve low(0)
`define GPIO_INTBEDGE	3'b111		// interrupt both edge detect(1)
`else
`define GPIO_OE_ADDR	2'b00
`define GPIO_IN_ADDR	2'b01
`define GPIO_OUT_ADDR	2'b10
`endif
 
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
  
reg  [31:0] GpioOutEn;
reg  [31:0] GpioOut;

`ifdef EXT_INT_SUPPORT
reg  [31:0] IntStat;
reg  [31:0] IntEn;
reg  [31:0] IntLevel;
reg  [31:0] IntPol;
reg  [31:0] IntBEdge;
`endif

reg  [31:0] PRDATA;

wire APBWrite;
assign APBWrite = PSEL & (~PENABLE) & PWRITE;

wire APBRead;
assign APBRead = PSEL & (~PENABLE) & (~PWRITE);

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		GpioOutEn <= 32'd0;
		GpioOut   <= 32'h12345678;
`ifdef EXT_INT_SUPPORT
		IntLevel  <= 0;
		IntEn   <= 32'h00000000;
		IntPol    <= 0;
		IntBEdge   <= 0;
`endif
	end
	else
	begin
		if(APBWrite)
		begin
`ifdef EXT_INT_SUPPORT
			case(PADDR[4:2])
			`GPIO_OE_ADDR: GpioOutEn  <= PWDATA;
			`GPIO_OUT_ADDR: GpioOut   <= PWDATA;
			`GPIO_INTMASK: IntEn <= PWDATA;
			`GPIO_INTLEVEL: IntLevel <= PWDATA;
			`GPIO_INTPOL: IntPol <= PWDATA;
			`GPIO_INTBEDGE: IntBEdge <= PWDATA;
			endcase
`else
			case(PADDR[3:2])
			`GPIO_OE_ADDR: GpioOutEn  <= PWDATA;
			`GPIO_OUT_ADDR: GpioOut   <= PWDATA;
			endcase
`endif
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
`ifdef EXT_INT_SUPPORT
			case(PADDR[4:2])
			`GPIO_OE_ADDR:  PRDATA <= GpioOutEn[31:0];
			`GPIO_IN_ADDR:  PRDATA <= GpioIn[31:0];
			`GPIO_OUT_ADDR: PRDATA <= GpioOut[31:0];
			`GPIO_INTSTAT:  PRDATA <= IntStat;
			`GPIO_INTMASK:  PRDATA <= IntEn;
			`GPIO_INTLEVEL: PRDATA <= IntLevel;
			`GPIO_INTPOL:   PRDATA <= IntPol;
			`GPIO_INTBEDGE:  PRDATA <= IntBEdge;
			default: PRDATA <= 32'd0;
			endcase
`else
			case(PADDR[3:2])
			`GPIO_OE_ADDR:  PRDATA <= GpioOutEn[31:0];
			`GPIO_IN_ADDR:  PRDATA <= GpioIn[31:0];
			`GPIO_OUT_ADDR: PRDATA <= GpioOut[31:0];
			default: PRDATA <= 32'd0;
			endcase
`endif
		end
	end
end

`ifdef EXT_INT_SUPPORT
// Interrupt related
assign Interrupt = |(IntStat&IntEn);

reg [31:0] GpioInLevel;
reg [31:0] GpioIn1d;
reg [31:0] GpioIn2d;
reg [31:0] GpioIn3d;
reg [31:0] GpioIn4d;

wire [31:0] GpioNextLevel;
wire [31:0] GpioEdge;
wire [31:0] GpioPosEdge;
wire [31:0] GpioNegEdge;

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		GpioInLevel <= 0;
		GpioIn1d <= 0;
		GpioIn2d <= 0;
		GpioIn3d <= 0;
		GpioIn4d <= 0;
	end
	else
	begin
		GpioIn1d <= GpioIn;
		GpioIn2d <= GpioIn1d;
		GpioIn3d <= GpioIn2d;
		GpioIn4d <= GpioIn3d;
		GpioInLevel <= GpioNextLevel;
	end
end

// toggle GpioLevel[x] when (GpioIn2d[x] == GpioIn3d[x] == GpioIn4d[x]) && (GpioIn3d[x] != GpioLevel[x])
wire [31:0] Xor2d3d;
wire [31:0] Xor3d4d;
wire [31:0] DiffBit32;

assign Xor2d3d = GpioIn2d^GpioIn3d;			// 1 when different bit
assign Xor3d4d = GpioIn3d^GpioIn4d;			// 1 when different bit
assign DiffBit32 = Xor2d3d | Xor2d3d;		// 1 when different bit

assign GpioNextLevel = (GpioInLevel&DiffBit32) | (GpioIn3d&(~DiffBit32));
// edge when InLevel[x] != NextLeve[x]
assign GpioEdge = GpioInLevel^GpioNextLevel;
// positive edge when GpioEdge[x] == 1 && InLeve[x] == 0
assign GpioPosEdge = (~GpioInLevel) & GpioEdge;
// neative edge when GpioEdge[x] == 1 && InLeve[x] == 1
assign GpioNegEdge = GpioInLevel & GpioEdge;

wire StatWrite;
assign StatWrite = APBWrite && (PADDR == `GPIO_INTSTAT);

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		IntStat <= 0;
	end
	else
	begin
		// Level Interrupt : IntLevel[x] == 1 && (InLevel[x] == IntPol[x])
		// NegEdge Interrupt : IntLeve[x] == 0 IntBEdge[x] == 0 && IntPol[x] == 0 && GpioNegEdge[x] == 1
		// PosEdge Interrupt : IntLeve[x] == 0 IntBEdge[x] == 0 && IntPol[x] == 1 && GpioPosEdge[x] == 1
		// Edge Interrup : IntLeve[x] == 0 IntBEdge[x] == 1 && IntLevel[x] == 0 && GpioEdge[x] == 1
		IntStat <= (~({32{StatWrite}}&PWDATA))		// APB Write : writing 1 will be intState cleared
			& ((IntStat & (~IntLevel))
			| (IntLevel & (~(GpioInLevel^IntPol)))	// Level
			| ((~IntLevel) & (~IntBEdge) & (~IntPol) & GpioNegEdge)	// NegEdge
			| ((~IntLevel) & (~IntBEdge) & (IntPol) & GpioPosEdge)	// PosEdge
			| ((~IntLevel) & (IntBEdge) & GpioEdge));	// BothEdge
	end
end
`endif

endmodule

