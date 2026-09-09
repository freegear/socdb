
`timescale 1ns/1ns

module PlaneMixer(
				Clk, 
				nRST,
				LcdClk, 
				FIFOClear,
				PlaneMixerEn,
				GPlaneEn,
				VPlaneEn,
				CPlaneEn,
				PrioritySel,
				
				LcdXSize,
				LcdYSize,

				GPlaneChromaKeyEn,
				VPlaneChromaKeyEn,
				CPlaneChromaKeyEn,
				GPlaneChromaKey,
				VPlaneChromaKey,
				CPlaneChromaKey,
				
				GPlaneXPos,
				GPlaneYPos,
				GPlaneXSize,
				GPlaneYSize,
				VPlaneXPos,
				VPlaneYPos,
				VPlaneXSize,
				VPlaneYSize,
				CPlaneXPos,
				CPlaneYPos,
				CPlaneXSize,
				CPlaneYSize,
				
				GPlaneDataRequest,
				VPlaneDataRequest,
				CPlaneDataRequest,
				GPlaneDataValid,
				VPlaneDataValid,
				CPlaneDataValid,
				GPlaneDataIn,
				VPlaneDataIn,
				CPlaneDataIn,
				BPlaneDataIn,
				VPlaneDataHold,
				
				LcdDataRequest,
				MixerDataValid,
				MixerDataOut,
				
				MixFIFOOverRun,
				MixFIFOUnderRun
				
);

`include "DmPara.v"

// System
input			Clk; 
input			nRST;
input			LcdClk; 
input			FIFOClear;
input			PlaneMixerEn;
input			GPlaneEn;
input			VPlaneEn;
input			CPlaneEn;
input			PrioritySel;	// 0 : V > G, 1 : G > V

// LCD Display Size Max 2048x2048
input [XW:0] 	LcdXSize;
input [YW:0] 	LcdYSize;

// Chroma Key
input 			GPlaneChromaKeyEn;
input 			VPlaneChromaKeyEn;
input 			CPlaneChromaKeyEn;
input [23:0]	GPlaneChromaKey;
input [23:0]	VPlaneChromaKey;
input [23:0]	CPlaneChromaKey;

// Plane X/Y Cordinate
input [XW:0] 	GPlaneXPos;	// Graphic Plane
input [YW:0] 	GPlaneYPos;
input [XW:0] 	GPlaneXSize;
input [YW:0] 	GPlaneYSize;

input [XW:0] 	VPlaneXPos;	// Video Plane
input [YW:0] 	VPlaneYPos;
input [XW:0] 	VPlaneXSize;
input [YW:0] 	VPlaneYSize;

input [XW:0] 	CPlaneXPos;	// Cursor Plane
input [YW:0] 	CPlaneYPos;
input [XW:0] 	CPlaneXSize;	// max 64x64
input [YW:0] 	CPlaneYSize;

// Plane Normalized Input Data(32Bit ARGB 8888)
output		 	GPlaneDataRequest;
output		 	VPlaneDataRequest;
output		 	CPlaneDataRequest;

input		 	GPlaneDataValid;
input		 	VPlaneDataValid;
input		 	CPlaneDataValid;
input [31:0] 	GPlaneDataIn;	// ARGB
input [31:0] 	VPlaneDataIn;	// ARGB
input [31:0] 	CPlaneDataIn;	// ARGB
input [23:0] 	BPlaneDataIn;	// RGB
input			VPlaneDataHold;

// Mixer Output Valid Data(24Bit RGB888)
input			LcdDataRequest;
output  		MixerDataValid;
output [23:0]	MixerDataOut;

// FIFO Status
output			MixFIFOOverRun;
output			MixFIFOUnderRun;
//-------------------------------------------------------------------------------
// BackGround Plane
wire 			BPlaneRequestX;
wire 			BPlaneRequestY;
wire		 	BPlaneDataRequest;

wire 		 	BPlaneDataValid = BPlaneDataRequest;

// Graphic Plane
wire 			GPlaneRequestX;
wire 			GPlaneRequestY;
wire		 	GPlaneDataRequest;

// Video Plane
wire 			VPlaneRequestX;
wire 			VPlaneRequestY;
wire		 	VPlaneDataRequest;

// Cursor Plane
wire 			CPlaneRequestX;
wire 			CPlaneRequestY;
wire		 	CPlaneDataRequest;

reg 			CPlaneDataValidD1, CPlaneDataValidD2;
reg [31:0] 		CPlaneDataInD1, CPlaneDataInD2;

reg 			VPlaneDataValidD1;
reg [31:0] 		VPlaneDataInD1;

reg 			GPlaneDataValidD1;
reg [31:0] 		GPlaneDataInD1;

// Mixer Count
reg [XW:0] 		MixXCount;
reg [YW:0] 		MixYCount;

wire 			MixXCountEnd;
wire 			MixYCountEnd;
wire 			MixXCountInc;

// Alpha Blending
wire [ 7:0] 	P1AlphaValue;
wire [ 7:0] 	P2AlphaValue;
wire [ 7:0] 	P3AlphaValue;

wire [ 7:0] 	P1AlphaBLendSrcR;
wire [ 7:0] 	P1AlphaBLendSrcG;
wire [ 7:0] 	P1AlphaBLendSrcB;
wire [ 7:0] 	P2AlphaBLendSrcR;
wire [ 7:0] 	P2AlphaBLendSrcG;
wire [ 7:0] 	P2AlphaBLendSrcB;
wire [ 7:0] 	P3AlphaBLendSrcR;
wire [ 7:0] 	P3AlphaBLendSrcG;
wire [ 7:0] 	P3AlphaBLendSrcB;

wire [ 7:0] 	P1AlphaBLendDesR;
wire [ 7:0] 	P1AlphaBLendDesG;
wire [ 7:0] 	P1AlphaBLendDesB;
wire [ 7:0] 	P2AlphaBLendDesR;
wire [ 7:0] 	P2AlphaBLendDesG;
wire [ 7:0] 	P2AlphaBLendDesB;
wire [ 7:0] 	P3AlphaBLendDesR;
wire [ 7:0] 	P3AlphaBLendDesG;
wire [ 7:0] 	P3AlphaBLendDesB;
            	
wire [16:0] 	P1AlphaBLendR;
wire [16:0] 	P1AlphaBLendG;
wire [16:0] 	P1AlphaBLendB;
wire [16:0] 	P2AlphaBLendR;
wire [16:0] 	P2AlphaBLendG;
wire [16:0] 	P2AlphaBLendB;
wire [16:0] 	P3AlphaBLendR;
wire [16:0] 	P3AlphaBLendG;
wire [16:0] 	P3AlphaBLendB;

wire [ 8:0] 	P1AlphaBLendSumR;
wire [ 8:0] 	P1AlphaBLendSumG;
wire [ 8:0] 	P1AlphaBLendSumB;
wire [ 8:0] 	P2AlphaBLendSumR;
wire [ 8:0] 	P2AlphaBLendSumG;
wire [ 8:0] 	P2AlphaBLendSumB;
wire [ 8:0] 	P3AlphaBLendSumR;
wire [ 8:0] 	P3AlphaBLendSumG;
wire [ 8:0] 	P3AlphaBLendSumB;

wire [ 7:0] 	P1AlphaBLendRndR;
wire [ 7:0] 	P1AlphaBLendRndG;
wire [ 7:0] 	P1AlphaBLendRndB;
wire [ 7:0] 	P2AlphaBLendRndR;
wire [ 7:0] 	P2AlphaBLendRndG;
wire [ 7:0] 	P2AlphaBLendRndB;
wire [ 7:0] 	P3AlphaBLendRndR;
wire [ 7:0] 	P3AlphaBLendRndG;
wire [ 7:0] 	P3AlphaBLendRndB;

reg  [23:0] 	P1AlphaBLendData;
reg  	 		P1AlphaBLendValid;
reg  [23:0] 	P2AlphaBLendData;
reg  	 		P2AlphaBLendValid;
reg  [23:0] 	P3AlphaBLendData;
reg  	 		P3AlphaBLendValid;

// Chroma Key
wire			P1ChromaKeyEn;
wire			P2ChromaKeyEn;
wire			P3ChromaKeyEn;

wire [23:0] 	P1ChromaKeySrc;
wire [23:0] 	P2ChromaKeySrc;
wire [23:0] 	P3ChromaKeySrc;

wire [23:0] 	P1ChromaKeyDes;
wire [23:0] 	P2ChromaKeyDes;
wire [23:0] 	P3ChromaKeyDes;

wire [23:0] 	P1ChromaKeyData;
wire [23:0] 	P2ChromaKeyData;
wire [23:0] 	P3ChromaKeyData;

wire			P1DataSel;
wire			P2DataSel;
wire			P3DataSel;

// Mixer FIFO
wire 			MixFIFOWrite;
wire [23:0] 	MixFIFOWrData;
wire			MixFIFORead;
wire [23:0] 	MixFIFORdData;

wire			MixFIFOEmpty;
wire			MixFIFOFull;
wire			MixFIFOHalfFull;
wire [1:0] 		MixFIFOLevel;
//-------------------------------------------------------------------------------
// Plane Hold
wire PlaneHold  = VPlaneDataHold;// | CPlaneDataHold | GPlaneDataHold ;

// Plane Mask
assign BPlaneRequestX = (MixXCount >= 0) & (MixXCount < (LcdXSize)) & BPlaneRequestY & PlaneMixerEn;
assign BPlaneRequestY = (MixYCount >= 0) & (MixYCount < (LcdYSize));

assign GPlaneRequestX = (MixXCount >= GPlaneXPos) & (MixXCount < (GPlaneXPos + GPlaneXSize)) & GPlaneRequestY & PlaneMixerEn & GPlaneEn;
assign GPlaneRequestY = (MixYCount >= GPlaneYPos) & (MixYCount < (GPlaneYPos + GPlaneYSize));

assign VPlaneRequestX = (MixXCount >= VPlaneXPos) & (MixXCount < (VPlaneXPos + VPlaneXSize)) & VPlaneRequestY & PlaneMixerEn & VPlaneEn;
assign VPlaneRequestY = (MixYCount >= VPlaneYPos) & (MixYCount < (VPlaneYPos + VPlaneYSize));

assign CPlaneRequestX = (MixXCount >= CPlaneXPos) & (MixXCount < (CPlaneXPos + CPlaneXSize)) & CPlaneRequestY & PlaneMixerEn & CPlaneEn;
assign CPlaneRequestY = (MixYCount >= CPlaneYPos) & (MixYCount < (CPlaneYPos + CPlaneYSize));

// Pipeline구조이므로 FIFO가 Full나기 전에 미리 data가 들어오는 것을 막아준다.
//assign BPlaneDataRequest = BPlaneRequestX & ~MixFIFOHalfFull;// & ~PlaneHold;
assign BPlaneDataRequest = (BPlaneRequestX & ~MixFIFOHalfFull) | (MixXCountEnd & MixFIFOHalfFull);
assign GPlaneDataRequest =  GPlaneRequestX & ~MixFIFOHalfFull;// & ~PlaneHold;
assign VPlaneDataRequest =  VPlaneRequestX & ~MixFIFOHalfFull;// & ~PlaneHold;
assign CPlaneDataRequest =  CPlaneRequestX & ~MixFIFOHalfFull;// & ~PlaneHold;
//-------------------------------------------------------------------------------
// Display Pixel Count
assign MixXCountEnd = (MixXCount == LcdXSize-1) | FIFOClear;	// Counter Cleared By Frame Reset
assign MixYCountEnd = (MixYCount == LcdYSize)   | FIFOClear;
assign MixXCountInc = PlaneMixerEn & BPlaneDataRequest;

always @(negedge nRST or posedge Clk)
	if      (!nRST)   		MixXCount <= 0;
	else if (MixXCountEnd) 	MixXCount <= 0;
//	else if (PlaneHold) 	MixXCount <= MixXCount;
	else if (MixXCountInc)	MixXCount <= MixXCount + 1;

always @(negedge nRST or posedge Clk)
	if      (!nRST)   		MixYCount <= 0;
	else if (MixYCountEnd) 	MixYCount <= 0;
	else if (MixXCountEnd) 	MixYCount <= MixYCount + 1;
//-------------------------------------------------------------------------------
// Alpha Blending(B-G-V-C)
assign P1AlphaValue     = ~PrioritySel ?  GPlaneDataIn[31:24]   :  VPlaneDataIn[31:24];
assign P2AlphaValue     = ~PrioritySel ?  VPlaneDataInD1[31:24] :  GPlaneDataInD1[31:24];
assign P3AlphaValue     =  CPlaneDataInD2[31:24];

assign P1AlphaBLendSrcR = ~PrioritySel ? GPlaneDataIn[23:16] : VPlaneDataIn[23:16];
assign P1AlphaBLendSrcG = ~PrioritySel ? GPlaneDataIn[15: 8] : VPlaneDataIn[15: 8];
assign P1AlphaBLendSrcB = ~PrioritySel ? GPlaneDataIn[ 7: 0] : VPlaneDataIn[ 7: 0];
assign P1AlphaBLendDesR = BPlaneDataIn[23:16];
assign P1AlphaBLendDesG = BPlaneDataIn[15: 8];
assign P1AlphaBLendDesB = BPlaneDataIn[ 7: 0];

assign P2AlphaBLendSrcR = ~PrioritySel ? VPlaneDataInD1[23:16] : GPlaneDataInD1[23:16];
assign P2AlphaBLendSrcG = ~PrioritySel ? VPlaneDataInD1[15: 8] : GPlaneDataInD1[15: 8];
assign P2AlphaBLendSrcB = ~PrioritySel ? VPlaneDataInD1[ 7: 0] : GPlaneDataInD1[ 7: 0];
assign P2AlphaBLendDesR = P1AlphaBLendData[23:16];
assign P2AlphaBLendDesG = P1AlphaBLendData[15: 8];
assign P2AlphaBLendDesB = P1AlphaBLendData[ 7: 0];

assign P3AlphaBLendSrcR = CPlaneDataInD2[23:16];
assign P3AlphaBLendSrcG = CPlaneDataInD2[15: 8];
assign P3AlphaBLendSrcB = CPlaneDataInD2[ 7: 0];
assign P3AlphaBLendDesR = P2AlphaBLendData[23:16];
assign P3AlphaBLendDesG = P2AlphaBLendData[15: 8];
assign P3AlphaBLendDesB = P2AlphaBLendData[ 7: 0];

//out = (alpha)x(source) + (1 - alpha)(destination)		: 2 multiplier
//out = (alpha)x(source - destination) + destination	: 1 multiplier
//						Source								Destination
//															2's complement
assign P1AlphaBLendR =  P1AlphaValue * (P1AlphaBLendSrcR + (~P1AlphaBLendDesR + 1));
assign P1AlphaBLendG =  P1AlphaValue * (P1AlphaBLendSrcG + (~P1AlphaBLendDesG + 1));
assign P1AlphaBLendB =  P1AlphaValue * (P1AlphaBLendSrcB + (~P1AlphaBLendDesB + 1));
assign P2AlphaBLendR =  P2AlphaValue * (P2AlphaBLendSrcR + (~P2AlphaBLendDesR + 1));
assign P2AlphaBLendG =  P2AlphaValue * (P2AlphaBLendSrcG + (~P2AlphaBLendDesG + 1));
assign P2AlphaBLendB =  P2AlphaValue * (P2AlphaBLendSrcB + (~P2AlphaBLendDesB + 1));
assign P3AlphaBLendR =  P3AlphaValue * (P3AlphaBLendSrcR + (~P3AlphaBLendDesR + 1));
assign P3AlphaBLendG =  P3AlphaValue * (P3AlphaBLendSrcG + (~P3AlphaBLendDesG + 1));
assign P3AlphaBLendB =  P3AlphaValue * (P3AlphaBLendSrcB + (~P3AlphaBLendDesB + 1));

assign P1AlphaBLendSumR = P1AlphaBLendR[16:8] + P1AlphaBLendDesR;
assign P1AlphaBLendSumG = P1AlphaBLendG[16:8] + P1AlphaBLendDesG;
assign P1AlphaBLendSumB = P1AlphaBLendB[16:8] + P1AlphaBLendDesB;
assign P2AlphaBLendSumR = P2AlphaBLendR[16:8] + P2AlphaBLendDesR;
assign P2AlphaBLendSumG = P2AlphaBLendG[16:8] + P2AlphaBLendDesG;
assign P2AlphaBLendSumB = P2AlphaBLendB[16:8] + P2AlphaBLendDesB;
assign P3AlphaBLendSumR = P3AlphaBLendR[16:8] + P3AlphaBLendDesR;
assign P3AlphaBLendSumG = P3AlphaBLendG[16:8] + P3AlphaBLendDesG;
assign P3AlphaBLendSumB = P3AlphaBLendB[16:8] + P3AlphaBLendDesB;

// Round				 if overflow			limit
assign P1AlphaBLendRndR = P1AlphaBLendSumR[8] ? 8'd255 : P1AlphaBLendSumR[7:0];
assign P1AlphaBLendRndG = P1AlphaBLendSumG[8] ? 8'd255 : P1AlphaBLendSumG[7:0];
assign P1AlphaBLendRndB = P1AlphaBLendSumB[8] ? 8'd255 : P1AlphaBLendSumB[7:0];
assign P2AlphaBLendRndR = P2AlphaBLendSumR[8] ? 8'd255 : P2AlphaBLendSumR[7:0];
assign P2AlphaBLendRndG = P2AlphaBLendSumG[8] ? 8'd255 : P2AlphaBLendSumG[7:0];
assign P2AlphaBLendRndB = P2AlphaBLendSumB[8] ? 8'd255 : P2AlphaBLendSumB[7:0];
assign P3AlphaBLendRndR = P3AlphaBLendSumR[8] ? 8'd255 : P3AlphaBLendSumR[7:0];
assign P3AlphaBLendRndG = P3AlphaBLendSumG[8] ? 8'd255 : P3AlphaBLendSumG[7:0];
assign P3AlphaBLendRndB = P3AlphaBLendSumB[8] ? 8'd255 : P3AlphaBLendSumB[7:0];

assign P1ChromaKeyEn  = ~PrioritySel ? GPlaneChromaKeyEn : VPlaneChromaKeyEn;
assign P2ChromaKeyEn  = ~PrioritySel ? VPlaneChromaKeyEn : GPlaneChromaKeyEn;
assign P3ChromaKeyEn  = CPlaneChromaKeyEn;

assign P1ChromaKeySrc = ~PrioritySel ? GPlaneDataIn   : VPlaneDataIn  ;
assign P2ChromaKeySrc = ~PrioritySel ? VPlaneDataInD1 : GPlaneDataInD1;
assign P3ChromaKeySrc = CPlaneDataInD2;

assign P1ChromaKeyDes = ~PrioritySel ? GPlaneChromaKey : VPlaneChromaKey;
assign P2ChromaKeyDes = ~PrioritySel ? VPlaneChromaKey : GPlaneChromaKey;
assign P3ChromaKeyDes = CPlaneChromaKey;

assign P1ChromaKeyData = (P1ChromaKeySrc != P1ChromaKeyDes) ? P1ChromaKeySrc : BPlaneDataIn;
assign P2ChromaKeyData = (P2ChromaKeySrc != P2ChromaKeyDes) ? P2ChromaKeySrc : P1AlphaBLendData;
assign P3ChromaKeyData = (P3ChromaKeySrc != P3ChromaKeyDes) ? P3ChromaKeySrc : P2AlphaBLendData;

assign P1DataSel       = ~PrioritySel ? BPlaneDataValid   & GPlaneDataValid   : BPlaneDataValid   & VPlaneDataValid  ;
assign P2DataSel       = ~PrioritySel ? P1AlphaBLendValid & VPlaneDataValidD1 : P1AlphaBLendValid & GPlaneDataValidD1;
assign P3DataSel       = P2AlphaBLendValid & CPlaneDataValidD2;

always @(negedge nRST or posedge Clk)
	if (!nRST)	begin
				VPlaneDataValidD1 <= 0;
				VPlaneDataInD1    <= 0;
				GPlaneDataValidD1 <= 0;
				GPlaneDataInD1    <= 0;
	end
	else		begin
				VPlaneDataValidD1 <= VPlaneDataValid;
				VPlaneDataInD1    <= VPlaneDataIn;
				GPlaneDataValidD1 <= GPlaneDataValid;
				GPlaneDataInD1    <= GPlaneDataIn;
	end

always @(negedge nRST or posedge Clk)
	if (!nRST)	begin
				CPlaneDataValidD1 <= 0;
				CPlaneDataValidD2 <= 0;
				CPlaneDataInD1 <= 0;
				CPlaneDataInD2 <= 0;
	end
	else		begin
				CPlaneDataValidD1 <= CPlaneDataValid;
				CPlaneDataValidD2 <= CPlaneDataValidD1;
				CPlaneDataInD1 <= CPlaneDataIn;
				CPlaneDataInD2 <= CPlaneDataInD1;
	end

always @(negedge nRST or posedge Clk)
	if (!nRST)	P1AlphaBLendValid <= 0;
	else if (FIFOClear)
				P1AlphaBLendValid <= 0;
	else		P1AlphaBLendValid <= BPlaneDataValid;

always @(negedge nRST or posedge Clk)
	if (!nRST)	P2AlphaBLendValid <= 0;
	else if (FIFOClear)
				P2AlphaBLendValid <= 0;
	else		P2AlphaBLendValid <= P1AlphaBLendValid;

always @(negedge nRST or posedge Clk)
	if (!nRST)	P3AlphaBLendValid <= 0;
	else if (FIFOClear)
				P3AlphaBLendValid <= 0;
	else		P3AlphaBLendValid <= P2AlphaBLendValid;

always @(negedge nRST or posedge Clk)
	if (!nRST)  				P1AlphaBLendData <= 0;
	else begin
		if (!P1DataSel)			P1AlphaBLendData <= BPlaneDataIn;
		else begin
			if (P1ChromaKeyEn) 	P1AlphaBLendData <= P1ChromaKeyData;
			else				P1AlphaBLendData <= {P1AlphaBLendRndR, 
													 P1AlphaBLendRndG, 
													 P1AlphaBLendRndB};
		end
	end

always @(negedge nRST or posedge Clk)
	if (!nRST)  				P2AlphaBLendData <= 0;
	else begin
		if (!P2DataSel)			P2AlphaBLendData <= P1AlphaBLendData;
		else begin
			if (P2ChromaKeyEn)	P2AlphaBLendData <= P2ChromaKeyData;
			else				P2AlphaBLendData <= {P2AlphaBLendRndR, 
													 P2AlphaBLendRndG, 
													 P2AlphaBLendRndB};
		end
	end

always @(negedge nRST or posedge Clk)
	if (!nRST)  				P3AlphaBLendData <= 0;
	else begin
		if (!P3DataSel)			P3AlphaBLendData <= P2AlphaBLendData;
		else begin
			if (P3ChromaKeyEn)	P3AlphaBLendData <= P3ChromaKeyData;
			else				P3AlphaBLendData <= {P3AlphaBLendRndR, 
													 P3AlphaBLendRndG, 
													 P3AlphaBLendRndB};
		end
	end

/*
// No Pipeline Case
assign P1AlphaBLendValid = BPlaneDataValid;
assign P1AlphaBLendData  = {P1AlphaBLendR[15:8], P1AlphaBLendG[15:8], P1AlphaBLendB[15:8]};
assign P2AlphaBLendValid = P1AlphaBLendValid;
assign P2AlphaBLendData  = {P2AlphaBLendR[15:8], P2AlphaBLendG[15:8], P2AlphaBLendB[15:8]};
assign P3AlphaBLendValid = P2AlphaBLendValid;
assign P3AlphaBLendData  = {P3AlphaBLendR[15:8], P3AlphaBLendG[15:8], P3AlphaBLendB[15:8]};
always @(negedge nRST or posedge Clk)
	if (!nRST)  MixFIFOWrite <= 0;
	else		MixFIFOWrite <= P2AlphaBLendValid & ~MixFIFOFull;

always @(negedge nRST or posedge Clk)
	if (!nRST)  MixFIFOWrData <= 0;
	else		MixFIFOWrData <= P3AlphaBLendData;
*/
//-------------------------------------------------------------------------------
assign MixFIFOWrite  = P3AlphaBLendValid & ~MixFIFOFull;
assign MixFIFOWrData = P3AlphaBLendData;

MixerFIFO #(6, 24) MixerFIFO(	// 64x24
			.RdClk			(LcdClk), 
			.WrClk			(Clk), 
			.nRST			(nRST), 
			.Flush			(FIFOClear), 
			.WrData			(MixFIFOWrData), 
			.WriteEn		(MixFIFOWrite), 
			.RdData			(MixFIFORdData), 
			.ReadEn			(MixFIFORead),
			.Full			(MixFIFOFull), 
			.Empty			(MixFIFOEmpty), 
			.Level 			(MixFIFOLevel)
);

assign MixFIFOHalfFull = (MixFIFOLevel==3);

assign MixFIFORead = LcdDataRequest & ~MixFIFOEmpty;

//assign MixerDataValid = LcdDataRequest & ~MixFIFOEmpty;
reg MixerDataValid;
always @(negedge nRST or posedge LcdClk)
	if (!nRST)	MixerDataValid <= 0;
	else		MixerDataValid <= LcdDataRequest & ~MixFIFOEmpty;

assign MixerDataOut = MixFIFORdData;
//-------------------------------------------------------------------------------
assign MixFIFOOverRun  = PlaneMixerEn & P3AlphaBLendValid & MixFIFOFull;
assign MixFIFOUnderRun = PlaneMixerEn & LcdDataRequest    & MixFIFOEmpty;
//-------------------------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
always @(MixFIFOOverRun or MixFIFOUnderRun)
	if(MixFIFOOverRun | MixFIFOUnderRun) begin
		$display("%m ERROR: Plane Mixer FIFO Error (%t)",$time);
		$stop;
	end

integer MixerCount;
always @(negedge nRST or posedge Clk)
	if  	(!nRST) 			MixerCount <= 0;
	else if (MixerCount==LcdXSize-1)			MixerCount <= 0;
	else if (MixFIFOWrite)	MixerCount <= MixerCount + 1;

integer MixerRdCount;
always @(negedge nRST or posedge Clk)
	if  	(!nRST) 			MixerRdCount <= 0;
	else if (MixerRdCount==LcdXSize-1)			MixerRdCount <= 0;
	else if (MixFIFORead)	MixerRdCount <= MixerRdCount + 1;
// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on
// -----------------------------------------------------------------------------
endmodule