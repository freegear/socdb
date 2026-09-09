
`timescale 1ns/10ps

module VifReg(
			PCLK,
			PRESETB,
    		PSEL, 
    		PENABLE, 
    		PADDR, 
    		PWRITE, 
    		PWDATA, 
			PRDATA,
			
			Field,
			VBlank,
			HBlank,
			
			FrameEnd,
			FrameStart,
			VifInt,
			FIFOOverRun,
			FieldPCLK1,

`ifdef DOWNSCALER
			PreFilterEn,
			DnScaleEn,
			ScaleXRatio,
			ScaleYRatio
			DmaHSize, 
			DmaVSize,
`endif

			DmaEn,
			DmaAdr,
			HStart, 
			VStart,
			HSize, 
			VSize,
			WrOffset,
			YCOrder,
			DmaI2PEn,
			FIFOClear			
);

`include "VifPara.v"

input         	PCLK;
input         	PRESETB;
              	
input  [ 9:2] 	PADDR;
input         	PWRITE;
input         	PSEL;
input         	PENABLE;
input  [31:0] 	PWDATA;
output [31:0] 	PRDATA;

input			HBlank;
input			VBlank;
input			Field;

input			FrameEnd;
input			FrameStart;
input			FIFOOverRun;
output			FieldPCLK1;
output			VifInt;

input	[ADDR_WIDTH-3:0] DmaAdr;
output	DmaEn;
output	[ImageSize-1:0] HStart;
output	[ImageSize-1:0] VStart;
output	[ImageSize-1:0] HSize;
output	[ImageSize-1:0] VSize;
output	[ADDR_WIDTH-3:0] WrOffset;
output	[1:0]   YCOrder;
output			DmaI2PEn;
output			FIFOClear;

`ifdef DOWNSCALER
output	[ImageSize-1:0] DmaHSize;
output	[ImageSize-1:0] DmaVSize;
output 			PreFilterEn;
output 			DnScaleEn;
output [15:0] 	ScaleXRatio;
output [15:0] 	ScaleYRatio;
`endif
//------------------------------------------------------------------------------
wire rVIFRegWr   	=  PWRITE;
wire rVIFRegRd   	= ~PWRITE;
wire rVIFRegSel  	=  PSEL & ~PENABLE;

wire rVIFCTLSel 	= rVIFRegSel & (PADDR == VIFCTL[9:2]);	// Control Register
wire rVIFSTSSel 	= rVIFRegSel & (PADDR == VIFSTS[9:2]);	// Status Register
wire rVIFSPOSSel 	= rVIFRegSel & (PADDR == VIFSPOS[9:2]);	// Source Position
wire rVIFSSIZSel 	= rVIFRegSel & (PADDR == VIFSSIZ[9:2]);	// Source Size
wire rVIFADDRSel 	= rVIFRegSel & (PADDR == VIFADDR[9:2]);	// Dma Offset
wire rVIFDSIZSel 	= rVIFRegSel & (PADDR == VIFDSIZ[9:2]);
wire rVIFSCONSel	= rVIFRegSel & (PADDR == VIFSCON[9:2]);
wire rSRATIOSel		= rVIFRegSel & (PADDR == VIFSRAT[9:2]);

wire rVIFCTLWr  	= rVIFCTLSel 	 & rVIFRegWr;
wire rVIFSPOSWr  	= rVIFSPOSSel 	 & rVIFRegWr;
wire rVIFSSIZWr  	= rVIFSSIZSel 	 & rVIFRegWr;
wire rVIFADDRWr  	= rVIFADDRSel 	 & rVIFRegWr;
wire rVIFDSIZWr  	= rVIFDSIZSel 	 & rVIFRegWr;
wire rVIFSCONWr		= rVIFSCONSel	 & rVIFRegWr;
wire rSRATIOWr		= rSRATIOSel 	 & rVIFRegWr;

wire rVIFCTLRd  	= rVIFCTLSel 	 & rVIFRegRd;
wire rVIFSTSRd  	= rVIFSTSSel 	 & rVIFRegRd;
wire rVIFSPOSRd  	= rVIFSPOSSel 	 & rVIFRegRd;
wire rVIFSSIZRd  	= rVIFSSIZSel 	 & rVIFRegRd;
wire rVIFADDRRd  	= rVIFADDRSel 	 & rVIFRegRd;
wire rVIFDSIZRd  	= rVIFDSIZSel 	 & rVIFRegRd;
wire rVIFSCONRd		= rVIFSCONSel	 & rVIFRegRd;
wire rSRATIORd		= rSRATIOSel 	 & rVIFRegRd;
//------------------------------------------------------------------------------
reg 		VifStatIntEn;
reg			VifEndIntEn;
reg			VifErrIntEn;
reg			DmaEn;
reg			FIFOClear;
reg	[1:0]   YCOrder;
reg			DmaI2PEn;
reg	[ImageSize-1:0] HSize;
reg	[ImageSize-1:0] VSize;
reg	[ImageSize-1:0] HStart;
reg	[ImageSize-1:0] VStart;
reg	[ADDR_WIDTH-3:0] WrOffset;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		DmaI2PEn	 <= 0;
        YCOrder 	 <= 0;
        VifStatIntEn <= 0;
        VifEndIntEn  <= 0;
        VifErrIntEn  <= 0;
        DmaEn   	 <= 0;
	end
	else if (rVIFCTLWr) begin
		DmaI2PEn	 <= PWDATA[6];
	    YCOrder 	 <= PWDATA[5:4];
        VifErrIntEn  <= PWDATA[3];
        VifStatIntEn <= PWDATA[2];
        VifEndIntEn  <= PWDATA[1];
	    DmaEn   	 <= PWDATA[0];
	end

always @(negedge PRESETB or posedge PCLK)
	if 	(!PRESETB) FIFOClear <= 0;
	else if (rVIFCTLWr & PWDATA[7])
        		   FIFOClear <= 1;
    else		   FIFOClear <= 0;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		HStart <= 0;
		VStart <= 11;
	end
	else if (rVIFSPOSWr) begin
		HStart <= PWDATA[21:11];
	    VStart <= PWDATA[10: 0];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		HSize <= 720;
		VSize <= 240;
	end
	else if (rVIFSSIZWr) begin
		HSize <= PWDATA[21:11];
	    VSize <= PWDATA[10: 0];
	end

`ifdef DOWNSCALER
reg	[ImageSize-1:0] DmaHSize;
reg	[ImageSize-1:0] DmaVSize;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		DmaHSize <= 720;
		DmaVSize <= 240;
	end
	else if (rVIFDSIZWr) begin
		DmaHSize <= PWDATA[21:11];
	    DmaVSize <= PWDATA[10: 0];
	end
`endif

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 	 WrOffset <= 0;
	else if (rVIFADDRWr) WrOffset <= PWDATA[ADDR_WIDTH-1:2];

`ifdef DOWNSCALER
reg 		PreFilterEn;
reg 		DnScaleEn;
reg [15:0] 	ScaleXRatio;
reg [15:0] 	ScaleYRatio;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        PreFilterEn <= 0;
        DnScaleEn	<= 0;
	end
	else if (rVIFSCONWr) begin
	    PreFilterEn	<= PWDATA[30];
	    DnScaleEn	<= PWDATA[0];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        ScaleXRatio <= 16'hffff;
        ScaleYRatio <= 16'hffff;
	end
	else if (rSRATIOWr) begin
	    ScaleXRatio <= PWDATA[31:16];
	    ScaleYRatio <= PWDATA[15:0];
	end
`endif
//------------------------------------------------------------------------------
`ifdef PCLKisACLK // If ACLK = PCLK
wire		FrameStartPCLK  = FrameStart;
wire		FrameEndPCLK    = FrameEnd;
wire		FIFOOverRunPCLK = FIFOOverRun;
`else // If PCLK = 2 x ACLK
reg			FrameStartPCLK;
reg			FIFOOverRunPCLK;
reg			FrameEndPCLK;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
			FrameStartPCLK  <= 0;
			FIFOOverRunPCLK <= 0;
			FrameEndPCLK    <= 0;
	end
	else begin
			FrameStartPCLK  <= FrameStart;
			FIFOOverRunPCLK <= FIFOOverRun;
			FrameEndPCLK    <= FrameEnd;
	end
`endif

wire VifStartInt = VifStatIntEn & FrameStartPCLK;
wire VifEndInt   = VifEndIntEn  & FrameEndPCLK;
wire VifErrInt   = VifErrIntEn  & FIFOOverRunPCLK;

assign VifInt = VifStartInt | VifEndInt | VifErrInt;

wire ClearErrSts = rVIFSTSRd;
reg 		FrameStartSts;
reg 		FrameEndSts;
reg 		VifErrSts;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 			FrameStartSts <= 1'b0;
	else if (ClearErrSts)		FrameStartSts <= 1'b0;
	else if (FrameStartPCLK & VifStatIntEn) 	
								FrameStartSts <= 1'b1;
	else						FrameStartSts <= FrameStartSts;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 			FrameEndSts <= 1'b0;
	else if (ClearErrSts)		FrameEndSts <= 1'b0;
	else if (FrameEndPCLK & VifEndIntEn) 	
								FrameEndSts <= 1'b1;
	else						FrameEndSts <= FrameEndSts;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 			VifErrSts <= 1'b0;
	else if (ClearErrSts)		VifErrSts <= 1'b0;
	else if (FIFOOverRunPCLK & VifErrIntEn) 	
								VifErrSts <= 1'b1;
	else						VifErrSts <= VifErrSts;
//------------------------------------------------------------------------------
// Field/VBlank/HBlank
reg		FieldPCLK0;
reg		FieldPCLK1;

always @(negedge PRESETB or posedge PCLK)	// Meta. FF
  if (!PRESETB) begin
  		FieldPCLK0 <= 1'b0;
  		FieldPCLK1 <= 1'b0;
  end
  else begin
  	 	FieldPCLK0 <= Field;
  	 	FieldPCLK1 <= FieldPCLK0;
end

reg		VBlankPCLK0;
reg		VBlankPCLK1;

always @(negedge PRESETB or posedge PCLK)	// Meta. FF
  if (!PRESETB) begin
  		VBlankPCLK0 <= 1'b0;
  		VBlankPCLK1 <= 1'b0;
  end
  else begin
  	 	VBlankPCLK0 <= VBlank;
  	 	VBlankPCLK1 <= VBlankPCLK0;
end

reg		HBlankPCLK0;
reg		HBlankPCLK1;

always @(negedge PRESETB or posedge PCLK)	// Meta. FF
  if (!PRESETB) begin
  		HBlankPCLK0 <= 1'b0;
  		HBlankPCLK1 <= 1'b0;
  end
  else begin
  	 	HBlankPCLK0 <= HBlank;
  	 	HBlankPCLK1 <= HBlankPCLK0;
end
//------------------------------------------------------------------------------
wire [31:0] rVIFCTLData = {20'b0, 1'b0, HBlankPCLK1, VBlankPCLK1, FieldPCLK1, 
						   1'b0, DmaI2PEn, YCOrder, VifErrIntEn, VifStatIntEn, VifEndIntEn, DmaEn};

wire [31:0] rVIFSPOSData = {10'b0, HStart, VStart};
wire [31:0] rVIFSSIZData = {10'b0, HSize, VSize};
wire [31:0] rVIFADDRData = {DmaAdr, 2'b0};

reg [31:0] 	PRDATA;
always @(negedge PRESETB or posedge PCLK)
	if 	(!PRESETB)		  PRDATA <= 32'b0;
	else begin
		case(1'b1) // synopsys parallel_case
    	  	rVIFCTLRd  	: PRDATA <= rVIFCTLData;
    	  	rVIFSTSRd   : PRDATA <= {29'b0, VifErrSts, FrameStartSts, FrameEndSts};
    	  	rVIFSPOSRd  : PRDATA <= rVIFSPOSData;
    	  	rVIFSSIZRd  : PRDATA <= rVIFSSIZData;
    	  	rVIFADDRRd  : PRDATA <= rVIFADDRData;
`ifdef DOWNSCALER
    	  	rVIFDSIZRd  : PRDATA <= {10'b0, DmaHSize, DmaVSize};
  			rVIFSCONRd	: PRDATA <= {1'b0, PreFilterEn, 29'b0, DnScaleEn};
  			rSRATIORd	: PRDATA <= {ScaleXRatio, ScaleYRatio};
`endif
  		  	default 	: PRDATA <= PRDATA;
    	endcase
    end
//------------------------------------------------------------------------------
endmodule
