`timescale 1ns/10ps

module BT656If(
			nRST,
			VClk,
			Clk,
			VData,
			DmaEn,
			DmaEnVCLK,
			HSize,
			VSize,
			HStart,
			VStart,
			YCOrder,

			DmaEnable,
			DmaStart,

`ifdef BYPASS
			VideoBPReq,
			VideoBPAck,
`endif
	
			FIFOWrEn,
			FIFOWrData,

`ifdef DOWNSCALER
			HOut, 
			YOut, 
			COut,
`endif
			HEnd,
			
			FIFOClear,
			VsyncEnd,
			
			HBlank,
			VBlank,
			Field
);

`include "VifPara.v"

// System
input		nRST;
input		Clk;

// BT656 Video Interface
input		VClk;
input [7:0] VData;

`ifdef BYPASS
input		VideoBPReq;
output		VideoBPAck;
`endif

input		DmaEn;
input		DmaEnVCLK;
input [ImageSize-1:0] HSize;
input [ImageSize-1:0] VSize;
input [ImageSize-1:0] HStart;
input [ImageSize-1:0] VStart;
input [1:0] YCOrder;

output		FIFOWrEn;
output [DATA_WIDTH-1:0] FIFOWrData;

output		DmaEnable;
output		DmaStart;
output		HBlank;
output		VBlank;
output		Field;
output		HEnd;

output		FIFOClear;
output		VsyncEnd;

`ifdef DOWNSCALER
output  	HOut;
output [7:0]YOut, COut;
`endif
//-------------------------------------------------------------
reg [7:0] 	VDS;
reg [7:0] 	VDS2;

reg [ImageSize-1:0]	HCount;
reg [ImageSize-1:0]	VCount;
reg			HDisable;
reg 		VDisable;

reg	[2:0] 	FFReg;
reg	[1:0] 	ooReg;

reg			HBlank;
reg			VBlank;
reg			Field;

reg			HBlankD1;
reg			VBlankD1;

wire 		HSyncEnd   = ( HBlank & ~HBlankD1 & (HCount!=0));
wire 		HSyncStart = (~HBlank &  HBlankD1);

reg	[1:0] 	PixCount;

wire		ffFlag  = (VDS==8'hff);
wire		ooFlag  = (VDS==8'h00);
wire		ffFlag2 = (VDS2==8'hff);
wire		ooFlag2 = (VDS2==8'h00);
wire		SAVComp = (FFReg[2]==1'b1) && (ooReg[1:0]==2'b11);
reg 		SAVCompr;
wire		SAVclear = SAVCompr;
reg			DmaEnable;
reg			DmaEnableVCLK;
wire		DmaStart;
        	
wire 		RequestX;
wire 		RequestY;
        	
wire		DataActive;
wire		DataValid;

reg [DATA_WIDTH-1:0] VDataInt;
reg [DATA_WIDTH-1:0] VDataInt2;

wire		VBlankFall;
wire		VBlankRise;
reg			VsyncStart0;
reg			VsyncStart1;
reg			VsyncStart2;
wire		VsyncStart;
reg			VsyncEnd0;
reg			VsyncEnd1;
reg			VsyncEnd2;
wire		VsyncEnd;
//-------------------------------------------------------------
//reg [DATA_WIDTH-1:0] FIFOWrData;
reg 		FIFOWrEn;
reg 		HOut;
reg [7:0] 	YOut;
reg [7:0] 	COut;
reg 		DataActiveD1;
reg 		DataActiveD2;
reg 		HOut0;
//-------------------------------------------------------------
always @(negedge nRST or posedge VClk)
  if (!nRST) begin
  		VDS <= 0;
  		VDS2 <= 0;
  		SAVCompr <= 0;
  end
  else begin
  		VDS  <= VData;
  		VDS2 <= VDS;
  		SAVCompr <= SAVComp;
  end

always @(negedge nRST or posedge VClk)
  if (!nRST) FFReg <= 3'h0;
  else 		 FFReg <= {FFReg[1:0], ffFlag};

always @(negedge nRST or posedge VClk)
  if (!nRST) ooReg <= 2'h0;
  else 		 ooReg <= {ooReg[0], ooFlag};

always @(negedge nRST or posedge VClk)
  if (!nRST) begin
  		HBlank <= 1'b0;
  		VBlank <= 1'b0;
  		Field  <= 1'b0;
  end
  else if (SAVCompr) begin
  		HBlank <= VDS2[4];
  		VBlank <= VDS2[5];
  		Field  <= VDS2[6];
  end

always @(negedge nRST or posedge VClk)
  if (!nRST) HBlankD1 <= 0;
  else 		 HBlankD1 <= HBlank;

always @(negedge nRST or posedge VClk)
  if (!nRST) VBlankD1 <= 1'b0;
  else 		 VBlankD1 <= VBlank;

assign VBlankFall = ~VBlank &  VBlankD1;
assign VBlankRise =  VBlank & ~VBlankD1;

// VSYNC Start
always @(negedge nRST or posedge Clk)	// Meta. FF(VClk -> Clk)
  if (!nRST) VsyncStart0 <= 1'b0;
  else 		 VsyncStart0 <= VBlankFall;

always @(negedge nRST or posedge Clk)	// Meta. FF
  if (!nRST) VsyncStart1 <= 1'b0;
  else 		 VsyncStart1 <= VsyncStart0;

always @(negedge nRST or posedge Clk)	// Meta. FF
  if (!nRST) VsyncStart2 <= 1'b0;
  else 		 VsyncStart2 <= VsyncStart1;

assign VsyncStart = VsyncStart1 | VsyncStart2;

assign DmaStart   = VsyncStart;

// VSYNC End
always @(negedge nRST or posedge Clk)	// Meta. FF
  if (!nRST) VsyncEnd0 <= 1'b0;
  else 		 VsyncEnd0 <= VBlankRise;

always @(negedge nRST or posedge Clk)	// Meta. FF
  if (!nRST) VsyncEnd1 <= 1'b0;
  else 		 VsyncEnd1 <= VsyncEnd0;

always @(negedge nRST or posedge Clk)	// Meta. FF
  if (!nRST) VsyncEnd2 <= 1'b0;
  else 		 VsyncEnd2 <= VsyncEnd1;

assign VsyncEnd    = VsyncEnd1 | VsyncEnd2;

assign FIFOClear   = VBlankRise;

// DMA enable (Vsync)
always @(negedge nRST or posedge VClk)
  if (!nRST)	DmaEnableVCLK <= 1'b0;
  else if (VBlankRise)
  				DmaEnableVCLK <= 1'b0;
  else if (VBlankFall) 
  				DmaEnableVCLK <= DmaEnVCLK;

always @(negedge nRST or posedge Clk)
  if (!nRST)	DmaEnable <= 1'b0;
  else if (VsyncEnd)
  				DmaEnable <= 1'b0;
  else if (VsyncStart) 
  				DmaEnable <= DmaEn;

//YUV422 dot counter
always @(negedge nRST or posedge VClk)
  if (!nRST) 	PixCount <= 2'b0;
  else if (SAVclear) 
  				PixCount <= 2'b0;
  else 			PixCount <= PixCount + 1'b1;

// Hcount, Vcount
wire HEnd  = (HCount=={1'b0, HSize[ImageSize-1:1]});
wire VEnd  = (VCount==VSize-1);
always @(negedge nRST or posedge VClk)
  if (!nRST) begin
  		HCount <= 0;
  		HDisable <= 1'b1;
  end
  else if (HSyncStart) begin
  		HCount <= 0;
  		HDisable <= 1'b1;
  end
  else if (DataValid) begin
  	if (HCount=={ImageSize{1'b1}}) 
  		HCount <= {ImageSize{1'b1}};
  	else 
  		HCount <= HCount + 1;
  	if (HEnd) 
  		HDisable <= 1'b0;
  end

always @(negedge nRST or posedge VClk)
  if (!nRST) begin
  		VCount <= 0;
  		VDisable <= 1'b1;
  end
  else if (VBlankFall) begin
  		VCount <= 0;
  		VDisable <= 1'b1;
  end
  else if (HSyncEnd) begin
  	if (VCount=={ImageSize{1'b1}}) 
  		VCount <= {ImageSize{1'b1}};
  	else 
  		VCount <= VCount + 1;
  	if (VEnd) 
  		VDisable <= 1'b0;
  end

always @(negedge nRST or posedge VClk)
  if (!nRST) begin
  		VDataInt <= 32'h0;
  end
  else if (DmaEnableVCLK) begin
  	// YUV422 packed
  		VDataInt <= {VDS2,VDataInt[31:8]};// Y1 Cr0 Y0 Cb0
  end
//-------------------------------------------------------------
// Data Valid Mask Generation
assign RequestX = (HCount >= HStart[ImageSize-1:1]) & 
				  (HCount < (HStart[ImageSize-1:1] + HSize[ImageSize-1:1])) & RequestY & DmaEnableVCLK;
assign RequestY = (VCount >= VStart) & (VCount < (VStart + VSize));

assign DataActive = RequestX & ~HBlank & ~VBlank;// & HDisable & VDisable;

assign DataValid  = (PixCount==3); // YUV422 packed
//-------------------------------------------------------------
// YCbYCr <-> CbYCrY (422)
wire [7:0] YY1 = VDataInt[31:24];
wire [7:0] Cr0 = VDataInt[23:16];
wire [7:0] YY0 = VDataInt[15:8];
wire [7:0] Cb0 = VDataInt[7:0];

always @(YCOrder or Cr0 or YY1 or Cb0 or YY0)
	case(YCOrder) // synopsys parallel_case
		2'b00 : VDataInt2 = {Cr0, YY1, Cb0, YY0};
		2'b01 : VDataInt2 = {Cb0, YY1, Cr0, YY0};
		2'b10 : VDataInt2 = {YY1, Cb0, YY0, Cr0};
		2'b11 : VDataInt2 = {YY1, Cr0, YY0, Cb0};
	endcase

always @(negedge nRST or posedge VClk)
  if (!nRST) FIFOWrEn <= 0;
  else		 FIFOWrEn <= DataActive & DataValid;

assign FIFOWrData = VDataInt2;
//-------------------------------------------------------------
// BT601 Format for Scaler
reg [DATA_WIDTH-1:0] DnScWrData;

always @(negedge nRST or posedge VClk)
  if      (!nRST)    DnScWrData <= 0;
  else if (FIFOWrEn) DnScWrData <= VDataInt2;

always @(negedge nRST or posedge VClk)
  if   (!nRST) begin
		  	YOut <= 0;
  		  	COut <= 0;
  end
  else begin
  	if (PixCount==1 | PixCount==2) begin
  		case(YCOrder) // synopsys parallel_case
  			2'b00 : begin
		  			YOut <= DnScWrData[ 7: 0]; // Y0
  		  			COut <= DnScWrData[15: 8]; // CB
  					end
  			2'b01 : begin
		  			YOut <= DnScWrData[ 7: 0]; // Y0
  		  			COut <= DnScWrData[31:24]; // CB
  					end
  			2'b10 : begin
		  			YOut <= DnScWrData[15: 8]; // Y0
  		  			COut <= DnScWrData[23:16]; // CB
  					end
  			2'b11 : begin
		  			YOut <= DnScWrData[15: 8]; // Y0
  		  			COut <= DnScWrData[ 7: 0]; // CB
  					end
  		endcase
  	end
  	else begin
  		case(YCOrder) // synopsys parallel_case
  			2'b00 : begin
		  			YOut <= DnScWrData[23:16]; // Y1
  		  			COut <= DnScWrData[31:24]; // CR
  					end
  			2'b01 : begin
		  			YOut <= DnScWrData[23:16]; // Y1
  		  			COut <= DnScWrData[15: 8]; // CR
  					end
  			2'b10 : begin
		  			YOut <= DnScWrData[31:24]; // Y1
  		  			COut <= DnScWrData[ 7: 0]; // CR
  					end
  			2'b11 : begin
		  			YOut <= DnScWrData[31:24]; // Y1
  		  			COut <= DnScWrData[23:16]; // CR
  					end
  		endcase
  	end
  end

always @(negedge nRST or posedge VClk)
  if   (!nRST) begin
  				DataActiveD1 <= 0;
  				DataActiveD2 <= 0;
  end
  else if (DataValid) begin
  		  	   	DataActiveD1 <= DataActive;
  		  	   	DataActiveD2 <= DataActiveD1;
  end

always @(negedge nRST or posedge VClk)
  if   (!nRST) begin
  				HOut0 <= 0;
  				HOut  <= 0;
  end
  else begin
  				HOut0 <= DataActiveD1;
  		 		HOut  <= HOut0;
  end
//-------------------------------------------------------------
`ifdef BYPASS
// External Video Mode
// - Ack. Assert at Frame Start(even field)
reg	VideoBPAck;
always @(negedge nRST or posedge VClk)
  if   (!nRST) 	VideoBPAck <= 0;
  else if (!VideoBPReq)
  				VideoBPAck <= 0;
  else if (VBlankFall & ~Field)
  		  	   	VideoBPAck <= VideoBPReq;
`endif

//-------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
integer HWrCount;

always @(negedge nRST or posedge VClk)
  if 	  (!nRST)    HWrCount <= 0;
  else if (HWrCount==({1'b0, HSize[ImageSize-1:1]}))
  					 HWrCount <= 0;
  else if (FIFOWrEn) HWrCount <= HWrCount+1;

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on
endmodule
