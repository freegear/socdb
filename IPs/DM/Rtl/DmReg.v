
`include "DmDef.v"

module DmReg(	
				ACLK,
				ARESETn,
				LCDCLK,
				PCLK,
				PRESETB,
    			PSEL, 
    			PENABLE, 
    			PADDR, 
    			PWRITE, 
    			PWDATA, 
				PRDATA,
				
				CurFIFOUnderRun,
				GraFIFOUnderRun,
				VidFIFOUnderRun,
				MixFIFOUnderRun,
				CDMAOverRun,
				GDMAOverRun,
				VDMAOverRun,
				
				DmInt,
				FrameStart,
				FrameEnd,
				FrameEvenField,
				
				CDMARAddr,
				GDMARAddr,
				VDMARAddr,
				
				LCDIPC,
				LCDPDIV,

// Plane Mixer
				SWReset,
				PrioritySel,
				BPlaneDataIn,
				CPlaneXPos,
				CPlaneYPos,
				GPlaneXPos,
				GPlaneYPos,
				VPlaneXPos,
				VPlaneYPos,
				MixerXSize,
				MixerYSize,

// Cursor Plane
				CPlaneEn,
				CPlaneN2PUpEn,
				CPlaneChromaKeyEn,
				CPlaneChromaKey,
				CPlanePixFormat,
				CPlaneAlphaMode,
				CPlaneAlphaValue,
				CPlaneXRef,
				CPlaneXSize,
				CPlaneYSize,
				CPlaneStartAddr,
				CPlaneStartAddr2,
				CPlaneAddrSwEn,
				CPlaneAddrSwVal,

// Palette Memory
				CPlanePalMemWrite,
				CPlanePalMemWrAddr,
				CPlanePalMemWrData,
				CPlanePalMemRead,
				CPlanePalMemRdData,
				
// Graphic Plane
				GPlaneEn,
				ColorBarSel,
				GPlaneN2PUpEn,
				GPlaneChromaKeyEn,
				GPlaneChromaKey,
				GPlanePixFormat,
				GPlaneAlphaMode,
				GPlaneAlphaValue,
				GPlaneXRef,
				GPlaneXSize,
				GPlaneYSize,
				GPlaneStartAddr,
				GPlaneGammaEn,

// Palette Memory
				GPlanePalMemWrite,
				GPlanePalMemWrAddr,
				GPlanePalMemWrData,
				GPlanePalMemRead,
				GPlanePalMemRdData,
				
				GPlaneGamma10, 
				GPlaneGamma0F, 
				GPlaneGamma0E, 
				GPlaneGamma0D, 
				GPlaneGamma0C, 
				GPlaneGamma0B, 
				GPlaneGamma0A, 
				GPlaneGamma09, 
				GPlaneGamma08, 
				GPlaneGamma07, 
				GPlaneGamma06, 
				GPlaneGamma05, 
				GPlaneGamma04, 
				GPlaneGamma03, 
				GPlaneGamma02, 
				GPlaneGamma01, 
				GPlaneGamma00,

// Video Plane
				VPlaneEn,
				VPlaneInterlaceEn,
				VPlaneN2PUpEn,
				VPlaneChromaKeyEn,
				VPlaneChromaKey,
				VPlanePixFormat,
				VPlaneAlphaMode,
				VPlaneAlphaValue,
				VPlaneXRef,
				VPlaneXSize,
				VPlaneYSize,
				VPlaneStartAddr,
				VPlaneStartAddr2,
				VPlaneGammaEn,

`ifdef SCALER
				PreFilterEn,
				DnScaleEn,
				UpScaleEn,
				ScaleInXSize,
				ScaleInYSize,
				ScaleXRatio,
				ScaleYRatio,
`endif

				VPlaneGamma10, 
				VPlaneGamma0F, 
				VPlaneGamma0E, 
				VPlaneGamma0D, 
				VPlaneGamma0C, 
				VPlaneGamma0B, 
				VPlaneGamma0A, 
				VPlaneGamma09, 
				VPlaneGamma08, 
				VPlaneGamma07, 
				VPlaneGamma06, 
				VPlaneGamma05, 
				VPlaneGamma04, 
				VPlaneGamma03, 
				VPlaneGamma02, 
				VPlaneGamma01, 
				VPlaneGamma00,

// Video Time Gen.
				VideoSyncEnPCLK,
				VideoOutEn,
`ifdef BYPASS
				VideoBP,
				VideoBPWait,
`endif

// LCD Time Gen.
				LCDBPP,
				LCDBGR,
				LCDHFP,
				LCDHBP,
				LCDHSW,
				LCDCPL,
				LCDVSW,
				LCDVFP,
				LCDVBP,
				LCDLPS,
				LCDIVS,
				LCDIHS,
				LCDIEO,
				LCDPwrEn,
				LCDEn
);

`include "DmPara.v"

input			ACLK;
input			ARESETn;

input			LCDCLK;

input         	PCLK;
input         	PRESETB;
              	
input  [ 9:2] 	PADDR;
input         	PWRITE;
input         	PSEL;
input         	PENABLE;
input  [31:0] 	PWDATA;
output [31:0] 	PRDATA;

input			CurFIFOUnderRun;
input			GraFIFOUnderRun;
input			VidFIFOUnderRun;
input			MixFIFOUnderRun;
input			CDMAOverRun;
input			GDMAOverRun;
input			VDMAOverRun;

output			DmInt;
input			FrameStart;
input			FrameEnd;
input			FrameEvenField;

input  [AW:0]	CDMARAddr;
input  [AW:0]	GDMARAddr;
input  [AW:0]	VDMARAddr;

output			LCDIPC;
output [ 2:0]	LCDPDIV;

// Plane Mixer
output 			SWReset;

output		  	PrioritySel;
output [23:0] 	BPlaneDataIn;
output [XW:0] 	CPlaneXPos;
output [YW:0] 	CPlaneYPos;
output [XW:0] 	GPlaneXPos;
output [YW:0] 	GPlaneYPos;
output [XW:0] 	VPlaneXPos;
output [YW:0] 	VPlaneYPos;
output [XW:0]	MixerXSize;
output [YW:0]	MixerYSize;

// Cursor Plane
output			CPlaneEn;
output			CPlaneN2PUpEn;
output 		  	CPlaneChromaKeyEn;
output [23:0] 	CPlaneChromaKey;
output [ 1:0] 	CPlanePixFormat;
output [ 1:0] 	CPlaneAlphaMode;
output [ 7:0] 	CPlaneAlphaValue;
output [CW+1:0]	CPlaneXRef;
output [CW:0] 	CPlaneXSize;
output [CW:0] 	CPlaneYSize;
output [AW:0] 	CPlaneStartAddr, CPlaneStartAddr2;
output			CPlaneAddrSwEn;
output [ 5:0]	CPlaneAddrSwVal;

// Palette Memory
output		  	CPlanePalMemWrite;
output [ 7:0] 	CPlanePalMemWrAddr;
output [31:0] 	CPlanePalMemWrData;
output			CPlanePalMemRead;
input  [31:0] 	CPlanePalMemRdData;

// Graphic Plane
output			GPlaneEn;
output			ColorBarSel;
output			GPlaneN2PUpEn;
output 			GPlaneChromaKeyEn;
output [23:0] 	GPlaneChromaKey;
output [ 2:0]	GPlanePixFormat;
output [ 1:0]	GPlaneAlphaMode;
output [ 7:0] 	GPlaneAlphaValue;
output [GW+1:0]	GPlaneXRef;
output [GW:0] 	GPlaneXSize;
output [GW:0] 	GPlaneYSize;
output [AW:0] 	GPlaneStartAddr;
output			GPlaneGammaEn;

// Palette Memory
output		  	GPlanePalMemWrite;
output [ 7:0] 	GPlanePalMemWrAddr;
output [31:0] 	GPlanePalMemWrData;
output			GPlanePalMemRead;
input  [31:0] 	GPlanePalMemRdData;

output [23:0] 	GPlaneGamma10; 
output [23:0] 	GPlaneGamma0F; 
output [23:0] 	GPlaneGamma0E; 
output [23:0] 	GPlaneGamma0D; 
output [23:0] 	GPlaneGamma0C; 
output [23:0] 	GPlaneGamma0B; 
output [23:0] 	GPlaneGamma0A; 
output [23:0] 	GPlaneGamma09; 
output [23:0] 	GPlaneGamma08; 
output [23:0] 	GPlaneGamma07; 
output [23:0] 	GPlaneGamma06; 
output [23:0] 	GPlaneGamma05; 
output [23:0] 	GPlaneGamma04; 
output [23:0] 	GPlaneGamma03; 
output [23:0] 	GPlaneGamma02; 
output [23:0] 	GPlaneGamma01; 
output [23:0] 	GPlaneGamma00;

// Video Plane
output			VPlaneEn;
output			VPlaneInterlaceEn;
output			VPlaneN2PUpEn;
output 		  	VPlaneChromaKeyEn;
output [23:0] 	VPlaneChromaKey;
output [ 1:0] 	VPlanePixFormat;
output [ 1:0] 	VPlaneAlphaMode;
output [ 7:0] 	VPlaneAlphaValue;
output [VW+1:0]	VPlaneXRef;
output [VW:0] 	VPlaneXSize;
output [VW:0] 	VPlaneYSize;
output [AW:0] 	VPlaneStartAddr;
output [AW:0] 	VPlaneStartAddr2;
output		  	VPlaneGammaEn;

output [23:0] 	VPlaneGamma10; 
output [23:0] 	VPlaneGamma0F; 
output [23:0] 	VPlaneGamma0E; 
output [23:0] 	VPlaneGamma0D; 
output [23:0] 	VPlaneGamma0C; 
output [23:0] 	VPlaneGamma0B; 
output [23:0] 	VPlaneGamma0A; 
output [23:0] 	VPlaneGamma09; 
output [23:0] 	VPlaneGamma08; 
output [23:0] 	VPlaneGamma07; 
output [23:0] 	VPlaneGamma06; 
output [23:0] 	VPlaneGamma05; 
output [23:0] 	VPlaneGamma04; 
output [23:0] 	VPlaneGamma03; 
output [23:0] 	VPlaneGamma02; 
output [23:0] 	VPlaneGamma01; 
output [23:0] 	VPlaneGamma00;

`ifdef SCALER
output 			PreFilterEn;
output 			DnScaleEn;
output 			UpScaleEn;
output [VW:0]	ScaleInXSize;
output [VW:0]	ScaleInYSize;
output [15:0] 	ScaleXRatio;
output [15:0] 	ScaleYRatio;
`endif

// Video Time Gen.
output			VideoSyncEnPCLK;
output			VideoOutEn;
`ifdef BYPASS
output			VideoBP;
output [11:0]	VideoBPWait;
`endif

// LCD Time Gen.
output [ 2:0] 	LCDBPP;
output [ 0:0] 	LCDBGR;
output [ 7:0] 	LCDHFP;
output [ 7:0] 	LCDHBP;
output [ 8:0] 	LCDHSW;
output [XW:0] 	LCDCPL;
output [ 5:0] 	LCDVSW;
output [ 7:0] 	LCDVFP;
output [ 7:0] 	LCDVBP;
output [YW:0] 	LCDLPS;
output        	LCDIVS;
output        	LCDIHS;
output        	LCDIEO;
output		  	LCDPwrEn;
output        	LCDEn;   
//-------------------------------------------------------------------------------
// Plane Mixer
reg			SWReset;
reg			DmStartIntEn;
reg			DmEndIntEn;
reg			DmErrIntEn;
reg 		PrioritySel;	// 0 : V > G; 1 : G > V
reg  [23:0] BPlaneDataIn; // BackGround is White
reg [XW:0] 	CPlaneXPosR;
reg [YW:0] 	CPlaneYPosR;
reg [XW:0] 	GPlaneXPosR;
reg [YW:0] 	GPlaneYPosR;
reg [XW:0] 	VPlaneXPosR;
reg [YW:0] 	VPlaneYPosR;
reg [XW:0] 	CPlaneXPos;
reg [YW:0] 	CPlaneYPos;
reg [XW:0] 	GPlaneXPos;
reg [YW:0] 	GPlaneYPos;
reg [XW:0] 	VPlaneXPos;
reg [YW:0] 	VPlaneYPos;
//-------------------------------------------------------------------------------
// Cursor Plane
reg			CPlaneEn;
reg			CPlaneN2PUpEn;
reg  		CPlaneChromaKeyEn;
reg  [23:0] CPlaneChromaKey;
reg  [ 1:0]	CPlanePixFormat;	// 00: 8bit; 1x: 16bit
reg  [ 1:0]	CPlaneAlphaMode;	// 0: No Alpah; 2: Global Alpha; 3: Per-Pixel Alpha
reg  [ 7:0] CPlaneAlphaValue;
reg  [CW+1:0] CPlaneXRefR;
reg  [CW:0] CPlaneXSizeR;
reg  [CW:0] CPlaneYSizeR;
reg  [CW+1:0] CPlaneXRef;
reg  [CW:0] CPlaneXSize;
reg  [CW:0] CPlaneYSize;
reg  [AW:0] CPlaneStartAddr, CPlaneStartAddr2;
reg			CPlaneAddrSwEn;
reg	 [ 5:0] CPlaneAddrSwVal;

// Palette Memory
reg			CPalMemWrite;
reg [ 7:0]	CPalMemWrAddr;
reg [31:0]	CPalMemWrData;
reg			CPalMemRead;
wire		CPlanePalMemRead;
`ifdef PCLKisACLK
wire 	 	CPlanePalMemWrite;
wire [ 7:0] CPlanePalMemWrAddr;
wire [31:0] CPlanePalMemWrData;
`else
reg  	 	CPlanePalMemWrite;
reg  [ 7:0] CPlanePalMemWrAddr;
reg  [31:0] CPlanePalMemWrData;
`endif
//-------------------------------------------------------------------------------
// Graphic Plane
reg			GPlaneEn;
reg			ColorBarSel;
reg			GPlaneN2PUpEn;
reg  		GPlaneChromaKeyEn;
reg  [23:0] GPlaneChromaKey;
reg  [ 2:0]	GPlanePixFormat;	// 0: 8bit; 2: RGB565; 3:ARGB1555; 4:RGB888; 5:ARGB8888
reg  [ 1:0]	GPlaneAlphaMode;	// 0: No Alpah; 2: Global Alpha; 3: Per-Pixel Alpha
reg  [ 7:0] GPlaneAlphaValue;
reg  [GW+1:0] GPlaneXRefR;
reg  [GW:0] GPlaneXSizeR;
reg  [GW:0] GPlaneYSizeR;
reg  [GW+1:0] GPlaneXRef;
reg  [GW:0] GPlaneXSize;
reg  [GW:0] GPlaneYSize;
reg  [AW:0] GPlaneStartAddr;
reg 		GPlaneGammaEn;

// Palette Memory
reg			GPalMemWrite;
reg [ 7:0]	GPalMemWrAddr;
reg [31:0]	GPalMemWrData;
reg			GPalMemRead;
`ifdef PCLKisACLK
wire 	 	GPlanePalMemWrite;
wire		GPlanePalMemRead;
wire [ 7:0] GPlanePalMemWrAddr;
wire [31:0] GPlanePalMemWrData;
`else
reg  	 	GPlanePalMemWrite;
reg 		GPlanePalMemRead;
reg  [ 7:0] GPlanePalMemWrAddr;
reg  [31:0] GPlanePalMemWrData;
`endif

reg  [23:0] GPlaneGamma10; 
reg  [23:0] GPlaneGamma0F; 
reg  [23:0] GPlaneGamma0E; 
reg  [23:0] GPlaneGamma0D; 
reg  [23:0] GPlaneGamma0C; 
reg  [23:0] GPlaneGamma0B; 
reg  [23:0] GPlaneGamma0A; 
reg  [23:0] GPlaneGamma09; 
reg  [23:0] GPlaneGamma08; 
reg  [23:0] GPlaneGamma07; 
reg  [23:0] GPlaneGamma06; 
reg  [23:0] GPlaneGamma05; 
reg  [23:0] GPlaneGamma04; 
reg  [23:0] GPlaneGamma03; 
reg  [23:0] GPlaneGamma02; 
reg  [23:0] GPlaneGamma01; 
reg  [23:0] GPlaneGamma00;
//-------------------------------------------------------------------------------
// Video Plane
reg			VPlaneEn;
reg			VPlaneInterlaceEn;
reg			VPlaneN2PUpEn;
reg  		VPlaneChromaKeyEn;
reg  [23:0] VPlaneChromaKey;
reg  [ 1:0]	VPlanePixFormat;	// 0: Y0CbY1Cr; 1:Y0CrY1Cb; 2:CrY0CbY1; 3:CbY0CrY1
reg  [ 1:0]	VPlaneAlphaMode;	// 0: No Alpah; 2: Global Alpha
reg  [ 7:0] VPlaneAlphaValue;
reg  [VW+1:0] VPlaneXRefR;
reg  [VW:0] VPlaneXSizeR;
reg  [VW:0] VPlaneYSizeR;
reg  [VW+1:0] VPlaneXRef;
reg  [VW:0] VPlaneXSize;
reg  [VW:0] VPlaneYSize;
reg  [AW:0] VPlaneStartAddr;
reg  [AW:0] VPlaneStartAddr2;
reg 		VPlaneGammaEn;

reg  [23:0] VPlaneGamma10; 
reg  [23:0] VPlaneGamma0F; 
reg  [23:0] VPlaneGamma0E; 
reg  [23:0] VPlaneGamma0D; 
reg  [23:0] VPlaneGamma0C; 
reg  [23:0] VPlaneGamma0B; 
reg  [23:0] VPlaneGamma0A; 
reg  [23:0] VPlaneGamma09; 
reg  [23:0] VPlaneGamma08; 
reg  [23:0] VPlaneGamma07; 
reg  [23:0] VPlaneGamma06; 
reg  [23:0] VPlaneGamma05; 
reg  [23:0] VPlaneGamma04; 
reg  [23:0] VPlaneGamma03; 
reg  [23:0] VPlaneGamma02; 
reg  [23:0] VPlaneGamma01; 
reg  [23:0] VPlaneGamma00;

`ifdef SCALER
reg 		PreFilterEn;
reg 		DnScaleEn;
reg 		UpScaleEn;
reg [VW:0]	ScaleInXSizeR;
reg [VW:0]	ScaleInYSizeR;
reg [15:0] 	ScaleXRatioR;
reg [15:0] 	ScaleYRatioR;
reg [VW:0]	ScaleInXSize;
reg [VW:0]	ScaleInYSize;
reg [15:0] 	ScaleXRatio;
reg [15:0] 	ScaleYRatio;
`endif
//------------------------------------------------------------------------------
wire rWrite   =  PWRITE;
wire rRead    = ~PWRITE;
wire rSelect  =  PSEL & ~PENABLE;

wire rDMCONSel 		= rSelect & (PADDR == DMCON[9:2]);	// Control Register
wire rDMSTSSel 		= rSelect & (PADDR == DMSTS[9:2]);  
wire rCCONSel    	= rSelect & (PADDR == CCON[9:2]);  
wire rCBLNDSel   	= rSelect & (PADDR == CBLND[9:2]);  
wire rCBMODSel   	= rSelect & (PADDR == CBMOD[9:2]);  
wire rCBASESel   	= rSelect & (PADDR == CBASE[9:2]);  
wire rCPALASel   	= rSelect & (PADDR == CPALA[9:2]);  
wire rCPALMSel   	= rSelect & (PADDR == CPALM[9:2]);  
wire rCADDRSel   	= rSelect & (PADDR == CADDR[9:2]);  
wire rCADDR2Sel   	= rSelect & (PADDR == CADDR2[9:2]);  
wire rCBLINKSel   	= rSelect & (PADDR == CBLINK[9:2]);  
wire rBGCOLSel   	= rSelect & (PADDR == BGCOL[9:2]);  
wire rGCONSel    	= rSelect & (PADDR == GCON[9:2]);  
wire rGBLNDSel   	= rSelect & (PADDR == GBLND[9:2]);  
wire rGBMODSel   	= rSelect & (PADDR == GBMOD[9:2]);  
wire rGBASESel   	= rSelect & (PADDR == GBASE[9:2]);  
wire rGADDRSel   	= rSelect & (PADDR == GADDR[9:2]);  
wire rGPALASel   	= rSelect & (PADDR == GPALA[9:2]);  
wire rGPALMSel   	= rSelect & (PADDR == GPALM[9:2]);  
wire rGGAMMA00Sel 	= rSelect & (PADDR == GGAMMA00[9:2]);
wire rGGAMMA01Sel 	= rSelect & (PADDR == GGAMMA01[9:2]);
wire rGGAMMA02Sel 	= rSelect & (PADDR == GGAMMA02[9:2]);
wire rGGAMMA03Sel 	= rSelect & (PADDR == GGAMMA03[9:2]);
wire rGGAMMA04Sel 	= rSelect & (PADDR == GGAMMA04[9:2]);
wire rGGAMMA05Sel 	= rSelect & (PADDR == GGAMMA05[9:2]);
wire rGGAMMA06Sel 	= rSelect & (PADDR == GGAMMA06[9:2]);
wire rGGAMMA07Sel 	= rSelect & (PADDR == GGAMMA07[9:2]);
wire rGGAMMA08Sel 	= rSelect & (PADDR == GGAMMA08[9:2]);
wire rGGAMMA09Sel 	= rSelect & (PADDR == GGAMMA09[9:2]);
wire rGGAMMA0ASel 	= rSelect & (PADDR == GGAMMA0A[9:2]);
wire rGGAMMA0BSel 	= rSelect & (PADDR == GGAMMA0B[9:2]);
wire rGGAMMA0CSel 	= rSelect & (PADDR == GGAMMA0C[9:2]);
wire rGGAMMA0DSel 	= rSelect & (PADDR == GGAMMA0D[9:2]);
wire rGGAMMA0ESel 	= rSelect & (PADDR == GGAMMA0E[9:2]);
wire rGGAMMA0FSel 	= rSelect & (PADDR == GGAMMA0F[9:2]);
wire rGGAMMA10Sel 	= rSelect & (PADDR == GGAMMA10[9:2]);
wire rVCONSel    	= rSelect & (PADDR == VCON[9:2]);        
wire rVBLNDSel   	= rSelect & (PADDR == VBLND[9:2]);   
wire rVBMODSel   	= rSelect & (PADDR == VBMOD[9:2]);   
wire rVBASESel   	= rSelect & (PADDR == VBASE[9:2]);   
wire rVADDRSel   	= rSelect & (PADDR == VADDR[9:2]);   
wire rVADDR2Sel   	= rSelect & (PADDR == VADDR2[9:2]);   
wire rVGAMMA00Sel 	= rSelect & (PADDR == VGAMMA00[9:2]);
wire rVGAMMA01Sel 	= rSelect & (PADDR == VGAMMA01[9:2]);
wire rVGAMMA02Sel 	= rSelect & (PADDR == VGAMMA02[9:2]);
wire rVGAMMA03Sel 	= rSelect & (PADDR == VGAMMA03[9:2]);
wire rVGAMMA04Sel 	= rSelect & (PADDR == VGAMMA04[9:2]);
wire rVGAMMA05Sel 	= rSelect & (PADDR == VGAMMA05[9:2]);
wire rVGAMMA06Sel 	= rSelect & (PADDR == VGAMMA06[9:2]);
wire rVGAMMA07Sel 	= rSelect & (PADDR == VGAMMA07[9:2]);
wire rVGAMMA08Sel 	= rSelect & (PADDR == VGAMMA08[9:2]);
wire rVGAMMA09Sel 	= rSelect & (PADDR == VGAMMA09[9:2]);
wire rVGAMMA0ASel 	= rSelect & (PADDR == VGAMMA0A[9:2]);
wire rVGAMMA0BSel 	= rSelect & (PADDR == VGAMMA0B[9:2]);
wire rVGAMMA0CSel 	= rSelect & (PADDR == VGAMMA0C[9:2]);
wire rVGAMMA0DSel 	= rSelect & (PADDR == VGAMMA0D[9:2]);
wire rVGAMMA0ESel 	= rSelect & (PADDR == VGAMMA0E[9:2]);
wire rVGAMMA0FSel 	= rSelect & (PADDR == VGAMMA0F[9:2]);
wire rVGAMMA10Sel 	= rSelect & (PADDR == VGAMMA10[9:2]);
wire rLCDCONSel  	= rSelect & (PADDR == LCDCON[9:2]);
wire rVIDCONSel  	= rSelect & (PADDR == VIDCON[9:2]);
wire rHSYNC0Sel		= rSelect & (PADDR == HSYNC0[9:2]);      
wire rHSYNC1Sel		= rSelect & (PADDR == HSYNC1[9:2]);      
wire rVSYNC0Sel		= rSelect & (PADDR == VSYNC0[9:2]);
wire rVSYNC1Sel		= rSelect & (PADDR == VSYNC1[9:2]);
wire rSCONSel		= rSelect & (PADDR == SCON[9:2]);
wire rSSIZESel		= rSelect & (PADDR == SSIZE[9:2]);
wire rSRATIOSel		= rSelect & (PADDR == SRATIO[9:2]);

wire rDMCONWr  		= rDMCONSel  	& rWrite;
//wire rDMSTSWr 	= rDMSTSSel  	& rWrite; 
wire rCCONWr    	= rCCONSel     	& rWrite;
wire rCBLNDWr    	= rCBLNDSel    	& rWrite;
wire rCBMODWr    	= rCBMODSel    	& rWrite;
wire rCBASEWr    	= rCBASESel    	& rWrite;
wire rCADDRWr    	= rCADDRSel    	& rWrite;
wire rCPALAWr    	= rCPALASel     & rWrite;
wire rCPALMWr    	= rCPALMSel     & rWrite;
wire rCADDR2Wr    	= rCADDR2Sel    & rWrite;
wire rCBLINKWr    	= rCBLINKSel   	& rWrite;
wire rBGCOLWr    	= rBGCOLSel    	& rWrite;
wire rGCONWr    	= rGCONSel     	& rWrite;
wire rGBLNDWr   	= rGBLNDSel    	& rWrite;
wire rGBMODWr   	= rGBMODSel    	& rWrite;
wire rGBASEWr   	= rGBASESel    	& rWrite;
wire rGADDRWr   	= rGADDRSel    	& rWrite;
wire rGPALAWr   	= rGPALASel    	& rWrite;
wire rGPALMWr   	= rGPALMSel    	& rWrite;
wire rGGAMMA00Wr 	= rGGAMMA00Sel 	& rWrite;
wire rGGAMMA01Wr 	= rGGAMMA01Sel 	& rWrite;
wire rGGAMMA02Wr 	= rGGAMMA02Sel 	& rWrite;
wire rGGAMMA03Wr 	= rGGAMMA03Sel 	& rWrite;
wire rGGAMMA04Wr 	= rGGAMMA04Sel 	& rWrite;
wire rGGAMMA05Wr 	= rGGAMMA05Sel 	& rWrite;
wire rGGAMMA06Wr 	= rGGAMMA06Sel 	& rWrite;
wire rGGAMMA07Wr 	= rGGAMMA07Sel 	& rWrite;
wire rGGAMMA08Wr 	= rGGAMMA08Sel 	& rWrite;
wire rGGAMMA09Wr 	= rGGAMMA09Sel 	& rWrite;
wire rGGAMMA0AWr 	= rGGAMMA0ASel 	& rWrite;
wire rGGAMMA0BWr 	= rGGAMMA0BSel 	& rWrite;
wire rGGAMMA0CWr 	= rGGAMMA0CSel 	& rWrite;
wire rGGAMMA0DWr 	= rGGAMMA0DSel 	& rWrite;
wire rGGAMMA0EWr 	= rGGAMMA0ESel 	& rWrite;
wire rGGAMMA0FWr 	= rGGAMMA0FSel 	& rWrite;
wire rGGAMMA10Wr 	= rGGAMMA10Sel 	& rWrite;
wire rVCONWr    	= rVCONSel     	& rWrite;     
wire rVBLNDWr   	= rVBLNDSel    	& rWrite;
wire rVBMODWr   	= rVBMODSel    	& rWrite;
wire rVBASEWr   	= rVBASESel    	& rWrite;
wire rVADDRWr   	= rVADDRSel    	& rWrite;
wire rVADDR2Wr   	= rVADDR2Sel    & rWrite;
wire rVGAMMA00Wr 	= rVGAMMA00Sel 	& rWrite;
wire rVGAMMA01Wr 	= rVGAMMA01Sel 	& rWrite;
wire rVGAMMA02Wr 	= rVGAMMA02Sel 	& rWrite;
wire rVGAMMA03Wr 	= rVGAMMA03Sel 	& rWrite;
wire rVGAMMA04Wr 	= rVGAMMA04Sel 	& rWrite;
wire rVGAMMA05Wr 	= rVGAMMA05Sel 	& rWrite;
wire rVGAMMA06Wr 	= rVGAMMA06Sel 	& rWrite;
wire rVGAMMA07Wr 	= rVGAMMA07Sel 	& rWrite;
wire rVGAMMA08Wr 	= rVGAMMA08Sel 	& rWrite;
wire rVGAMMA09Wr 	= rVGAMMA09Sel 	& rWrite;
wire rVGAMMA0AWr 	= rVGAMMA0ASel 	& rWrite;
wire rVGAMMA0BWr 	= rVGAMMA0BSel 	& rWrite;
wire rVGAMMA0CWr 	= rVGAMMA0CSel 	& rWrite;
wire rVGAMMA0DWr 	= rVGAMMA0DSel 	& rWrite;
wire rVGAMMA0EWr 	= rVGAMMA0ESel 	& rWrite;
wire rVGAMMA0FWr 	= rVGAMMA0FSel 	& rWrite;
wire rVGAMMA10Wr 	= rVGAMMA10Sel 	& rWrite;
wire rLCDCONWr  	= rLCDCONSel   	& rWrite;
wire rVIDCONWr  	= rVIDCONSel   	& rWrite;
wire rHSYNC0Wr		= rHSYNC0Sel   	& rWrite;
wire rHSYNC1Wr		= rHSYNC1Sel   	& rWrite;
wire rVSYNC0Wr		= rVSYNC0Sel   	& rWrite;
wire rVSYNC1Wr		= rVSYNC1Sel   	& rWrite;
wire rSCONWr		= rSCONSel	 	& rWrite;
wire rSSIZEWr		= rSSIZESel	 	& rWrite;
wire rSRATIOWr		= rSRATIOSel 	& rWrite;

wire rDMCONRd  		= rDMCONSel  	& rRead;
wire rDMSTSRd 		= rDMSTSSel  	& rRead; 
wire rCCONRd    	= rCCONSel     	& rRead;
wire rCBLNDRd    	= rCBLNDSel    	& rRead;
wire rCBMODRd    	= rCBMODSel    	& rRead;
wire rCBASERd    	= rCBASESel    	& rRead;
wire rCADDRRd    	= rCADDRSel    	& rRead;
wire rCPALARd    	= rCPALASel     & rRead;
wire rCPALMRd    	= rCPALMSel     & rRead;
wire rCADDR2Rd    	= rCADDR2Sel    & rRead;
wire rCBLINKRd    	= rCBLINKSel   	& rRead;
wire rBGCOLRd    	= rBGCOLSel    	& rRead;
wire rGCONRd    	= rGCONSel     	& rRead;
wire rGBLNDRd   	= rGBLNDSel    	& rRead;
wire rGBMODRd   	= rGBMODSel    	& rRead;
wire rGBASERd   	= rGBASESel    	& rRead;
wire rGADDRRd   	= rGADDRSel    	& rRead;
wire rGPALARd   	= rGPALASel    	& rRead;
wire rGPALMRd   	= rGPALMSel    	& rRead;
wire rGGAMMA00Rd 	= rGGAMMA00Sel 	& rRead;
wire rGGAMMA01Rd 	= rGGAMMA01Sel 	& rRead;
wire rGGAMMA02Rd 	= rGGAMMA02Sel 	& rRead;
wire rGGAMMA03Rd 	= rGGAMMA03Sel 	& rRead;
wire rGGAMMA04Rd 	= rGGAMMA04Sel 	& rRead;
wire rGGAMMA05Rd 	= rGGAMMA05Sel 	& rRead;
wire rGGAMMA06Rd 	= rGGAMMA06Sel 	& rRead;
wire rGGAMMA07Rd 	= rGGAMMA07Sel 	& rRead;
wire rGGAMMA08Rd 	= rGGAMMA08Sel 	& rRead;
wire rGGAMMA09Rd 	= rGGAMMA09Sel 	& rRead;
wire rGGAMMA0ARd 	= rGGAMMA0ASel 	& rRead;
wire rGGAMMA0BRd 	= rGGAMMA0BSel 	& rRead;
wire rGGAMMA0CRd 	= rGGAMMA0CSel 	& rRead;
wire rGGAMMA0DRd 	= rGGAMMA0DSel 	& rRead;
wire rGGAMMA0ERd 	= rGGAMMA0ESel 	& rRead;
wire rGGAMMA0FRd 	= rGGAMMA0FSel 	& rRead;
wire rGGAMMA10Rd 	= rGGAMMA10Sel 	& rRead;
wire rVCONRd    	= rVCONSel     	& rRead;     
wire rVBLNDRd   	= rVBLNDSel    	& rRead;
wire rVBMODRd   	= rVBMODSel    	& rRead;
wire rVBASERd   	= rVBASESel    	& rRead;
wire rVADDRRd   	= rVADDRSel    	& rRead;
wire rVADDR2Rd   	= rVADDR2Sel    & rRead;
wire rVGAMMA00Rd 	= rVGAMMA00Sel 	& rRead;
wire rVGAMMA01Rd 	= rVGAMMA01Sel 	& rRead;
wire rVGAMMA02Rd 	= rVGAMMA02Sel 	& rRead;
wire rVGAMMA03Rd 	= rVGAMMA03Sel 	& rRead;
wire rVGAMMA04Rd 	= rVGAMMA04Sel 	& rRead;
wire rVGAMMA05Rd 	= rVGAMMA05Sel 	& rRead;
wire rVGAMMA06Rd 	= rVGAMMA06Sel 	& rRead;
wire rVGAMMA07Rd 	= rVGAMMA07Sel 	& rRead;
wire rVGAMMA08Rd 	= rVGAMMA08Sel 	& rRead;
wire rVGAMMA09Rd 	= rVGAMMA09Sel 	& rRead;
wire rVGAMMA0ARd 	= rVGAMMA0ASel 	& rRead;
wire rVGAMMA0BRd 	= rVGAMMA0BSel 	& rRead;
wire rVGAMMA0CRd 	= rVGAMMA0CSel 	& rRead;
wire rVGAMMA0DRd 	= rVGAMMA0DSel 	& rRead;
wire rVGAMMA0ERd 	= rVGAMMA0ESel 	& rRead;
wire rVGAMMA0FRd 	= rVGAMMA0FSel 	& rRead;
wire rVGAMMA10Rd 	= rVGAMMA10Sel 	& rRead;
wire rLCDCONRd  	= rLCDCONSel   	& rRead;
wire rVIDCONRd  	= rVIDCONSel   	& rRead;
wire rHSYNC0Rd		= rHSYNC0Sel   	& rRead;      
wire rHSYNC1Rd		= rHSYNC1Sel   	& rRead;      
wire rVSYNC0Rd		= rVSYNC0Sel   	& rRead;
wire rVSYNC1Rd		= rVSYNC1Sel   	& rRead;
wire rSCONRd		= rSCONSel	 	& rRead;
wire rSSIZERd		= rSSIZESel	 	& rRead;
wire rSRATIORd		= rSRATIOSel 	& rRead;
//------------------------------------------------------------------------------
// Master Control Register
always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 	SWReset <= 0;
	else if (rDMCONWr) 	SWReset <= PWDATA[7];
	else if	(SWReset)	SWReset <= 0;
	else				SWReset <= SWReset;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        DmEndIntEn  <= 0;
        DmStartIntEn <= 0;
        DmErrIntEn  <= 0;
        PrioritySel <= 0;
	end
	else if (rDMCONWr) begin
	    DmEndIntEn  <= PWDATA[0];
	    DmStartIntEn <= PWDATA[1];
	    DmErrIntEn  <= PWDATA[2];
	    PrioritySel <= PWDATA[3];
	end
//------------------------------------------------------------------------------
// Cursor Plane
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        CPlaneEn			<= 0;
        CPlaneN2PUpEn		<= 0;
        CPlanePixFormat 	<= 0;
        CPlaneXSizeR 		<= 64;
        CPlaneYSizeR 		<= 64;
	end
	else if (rCCONWr) begin
	    CPlaneEn			<= PWDATA[31];
	    CPlaneN2PUpEn		<= PWDATA[29];
	    CPlanePixFormat		<= PWDATA[28:27];
	    CPlaneXSizeR 		<= PWDATA[CW+11:11];
	    CPlaneYSizeR 		<= PWDATA[CW:0];
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
        CPlaneXSize 		<= 64;
        CPlaneYSize 		<= 64;
	end
	else if (FrameStart) begin
	    CPlaneXSize 		<= CPlaneXSizeR;
	    CPlaneYSize 		<= CPlaneYSizeR;
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        CPlaneAlphaValue	<= 0;
        CPlaneChromaKey		<= 0;
	end
	else if (rCBLNDWr) begin
	    CPlaneAlphaValue 	<= PWDATA[31:24];
	    CPlaneChromaKey  	<= PWDATA[23:0];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        CPlaneChromaKeyEn	<= 0;
        CPlaneAlphaMode 	<= 0;
	end
	else if (rCBMODWr) begin
	    CPlaneChromaKeyEn	<= PWDATA[30];
	    CPlaneAlphaMode 	<= PWDATA[28:27];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        CPlaneXPosR		<= 0;
        CPlaneYPosR		<= 0;
	end
	else if (rCBMODWr) begin
	    CPlaneXPosR 	<= PWDATA[XW+YW+1:YW+1];
	    CPlaneYPosR  	<= PWDATA[YW:0];
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
        CPlaneXPos		<= 0;
        CPlaneYPos		<= 0;
	end
	else if (FrameStart) begin
	    CPlaneXPos 		<= CPlaneXPosR;
	    CPlaneYPos  	<= CPlaneYPosR;
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		CPlaneXRefR		<= 0;
	end
	else if (rCBASEWr) begin
		CPlaneXRefR		<= PWDATA[CW+1:0];
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
		CPlaneXRef		<= 0;
	end
	else if (FrameStart) begin
		CPlaneXRef		<= CPlaneXRefR;
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        CPlaneStartAddr <= 0;
	end
	else if (rCADDRWr) begin
	    CPlaneStartAddr <= PWDATA[31:2];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        CPlaneStartAddr2 <= 0;
	end
	else if (rCADDR2Wr) begin
	    CPlaneStartAddr2 <= PWDATA[31:2];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        CPlaneAddrSwEn	<= 0;
        CPlaneAddrSwVal	<= 0;
	end
	else if (rCBLINKWr) begin
	    CPlaneAddrSwEn	<= PWDATA[31];
        CPlaneAddrSwVal	<= PWDATA[5:0];
	end
//------------------------------------------------------------------------------
// Palette Memory
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) CPalMemWrite	<= 0;
	else		  CPalMemWrite  <= rCPALMWr;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) CPalMemRead	<= 0;
	else		  CPalMemRead   <= rCPALMRd;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		CPalMemWrAddr	<= 0;
	end
	else if (rCPALAWr) begin
		CPalMemWrAddr	<= PWDATA[7:0];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        CPalMemWrData	<= 0;
	end
	else if (rCPALMWr) begin
	    CPalMemWrData  	<= PWDATA;
	end

wire IncCPalMemRdAddr = ~rCPALMRd & CPalMemRead;

reg [7:0] CPalMemRdAddr;
always @(negedge PRESETB or posedge PCLK)
    if      (!PRESETB)          CPalMemRdAddr <= 8'b0;
    else if (IncCPalMemRdAddr)  CPalMemRdAddr <= CPalMemRdAddr + 1'b1;

assign CPlanePalMemRead   = rCPALMRd;
`ifdef PCLKisACLK
assign CPlanePalMemWrAddr = CPalMemWrite ? CPalMemWrAddr : CPalMemRdAddr;
assign CPlanePalMemWrData = CPalMemWrData;
assign CPlanePalMemWrite  = CPalMemWrite;
`else
always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
		CPlanePalMemWrite <= 0;
	end
	else begin
		CPlanePalMemWrite <= CPalMemWrite;
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
		CPlanePalMemWrAddr <= 0;
		CPlanePalMemWrData <= 0;
	end
	else begin
		CPlanePalMemWrAddr <= CPalMemWrite ? CPalMemWrAddr : CPalMemRdAddr;
		CPlanePalMemWrData <= CPalMemWrData;
	end
`endif
//------------------------------------------------------------------------------
// BackGround Plane
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        BPlaneDataIn		<= 0;
	end
	else if (rBGCOLWr) begin
	    BPlaneDataIn  		<= PWDATA[23:0];
	end
//------------------------------------------------------------------------------
// Graphic Plane
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        GPlaneEn			<= 0;
        ColorBarSel			<= 0;
        GPlanePixFormat 	<= 0;
        GPlaneGammaEn		<= 0;
        GPlaneN2PUpEn		<= 0;
        GPlaneXSizeR 		<= 2047;
        GPlaneYSizeR 		<= 2047;
	end
	else if (rGCONWr) begin
	    GPlaneEn			<= PWDATA[31];
	    ColorBarSel			<= PWDATA[30];
	    GPlanePixFormat		<= PWDATA[29:27];
	    GPlaneGammaEn		<= PWDATA[26];
	    GPlaneN2PUpEn		<= PWDATA[25];
	    GPlaneXSizeR 		<= PWDATA[GW+GW+1:GW+1];
	    GPlaneYSizeR 		<= PWDATA[GW:0];
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
        GPlaneXSize 		<= 2047;
        GPlaneYSize 		<= 2047;
	end
	else if (FrameStart) begin
	    GPlaneXSize 		<= GPlaneXSizeR;
	    GPlaneYSize 		<= GPlaneYSizeR;
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        GPlaneAlphaValue	<= 0;
        GPlaneChromaKey		<= 0;
	end
	else if (rGBLNDWr) begin
	    GPlaneAlphaValue 	<= PWDATA[31:24];
	    GPlaneChromaKey  	<= PWDATA[23:0];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        GPlaneChromaKeyEn	<= 0;
        GPlaneAlphaMode 	<= 0;
	end
	else if (rGBMODWr) begin
	    GPlaneChromaKeyEn	<= PWDATA[30];
	    GPlaneAlphaMode 	<= PWDATA[28:27];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        GPlaneXPosR		<= 0;
        GPlaneYPosR		<= 0;
	end
	else if (rGBMODWr) begin
	    GPlaneXPosR 	<= PWDATA[XW+YW+1:YW+1];
	    GPlaneYPosR  	<= PWDATA[YW:0];
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
        GPlaneXPos		<= 0;
        GPlaneYPos		<= 0;
	end
	else if (FrameStart) begin
	    GPlaneXPos 		<= GPlaneXPosR;
	    GPlaneYPos  	<= GPlaneYPosR;
	end
	
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		GPlaneXRefR			<= 0;
	end
	else if (rGBASEWr) begin
		GPlaneXRefR			<= PWDATA[GW+1:0];
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
		GPlaneXRef			<= 0;
	end
	else if (FrameStart) begin
		GPlaneXRef			<= GPlaneXRefR;
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        GPlaneStartAddr 	<= 0;
	end
	else if (rGADDRWr) begin
	    GPlaneStartAddr 	<= PWDATA[31:2];
	end
//------------------------------------------------------------------------------
// Palette Memory
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) GPalMemWrite	<= 0;
	else		  GPalMemWrite  <= rGPALMWr;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) GPalMemRead	<= 0;
	else		  GPalMemRead   <= rGPALMRd;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		GPalMemWrAddr	<= 0;
	end
	else if (rGPALAWr) begin
		GPalMemWrAddr	<= PWDATA[7:0];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        GPalMemWrData	<= 0;
	end
	else if (rGPALMWr) begin
	    GPalMemWrData  	<= PWDATA;
	end

wire IncGPalMemRdAddr = ~rGPALMRd & GPalMemRead;

reg [7:0] GPalMemRdAddr;
always @(negedge PRESETB or posedge PCLK)
    if      (!PRESETB)          GPalMemRdAddr <= 8'b0;
    else if (IncGPalMemRdAddr)  GPalMemRdAddr <= GPalMemRdAddr + 1'b1;

`ifdef PCLKisACLK
assign GPlanePalMemWrAddr = GPalMemWrite ? GPalMemWrAddr : GPalMemRdAddr;
assign GPlanePalMemWrData = GPalMemWrData;
assign GPlanePalMemRead   = GPalMemRead;
assign GPlanePalMemWrite  = GPalMemWrite;
`else
always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
		GPlanePalMemRead  <= 0;
		GPlanePalMemWrite <= 0;
	end
	else begin
		GPlanePalMemRead  <= GPalMemRead;
		GPlanePalMemWrite <= GPalMemWrite;
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
		GPlanePalMemWrAddr <= 0;
		GPlanePalMemWrData <= 0;
	end
	else begin
		GPlanePalMemWrAddr <= GPalMemWrite ? GPalMemWrAddr : GPalMemRdAddr;
		GPlanePalMemWrData <= GPalMemWrData;
	end
`endif
//------------------------------------------------------------------------------
// Video Plane
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        VPlaneEn			<= 0;
        VPlaneInterlaceEn	<= 0;
        VPlaneN2PUpEn		<= 0;
        VPlanePixFormat 	<= 0;
        VPlaneGammaEn		<= 0;
        VPlaneXSizeR 		<= 2047;
        VPlaneYSizeR 		<= 2047;
	end
	else if (rVCONWr) begin
	    VPlaneEn			<= PWDATA[31];
	    VPlaneInterlaceEn	<= PWDATA[30];
	    VPlaneN2PUpEn		<= PWDATA[29];
	    VPlanePixFormat		<= PWDATA[28:27];
        VPlaneGammaEn		<= PWDATA[26];
	    VPlaneXSizeR 		<= PWDATA[VW+VW+1:VW+1];
	    VPlaneYSizeR 		<= PWDATA[VW:0];
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
        VPlaneXSize 		<= 2047;
        VPlaneYSize 		<= 2047;
	end
	else if (FrameStart) begin
	    VPlaneXSize 		<= VPlaneXSizeR;
	    VPlaneYSize 		<= VPlaneYSizeR;
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        VPlaneAlphaValue	<= 0;
        VPlaneChromaKey		<= 0;
	end
	else if (rVBLNDWr) begin
	    VPlaneAlphaValue 	<= PWDATA[31:24];
	    VPlaneChromaKey  	<= PWDATA[23:0];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        VPlaneChromaKeyEn	<= 0;
        VPlaneAlphaMode 	<= 0;
	end
	else if (rVBMODWr) begin
	    VPlaneChromaKeyEn	<= PWDATA[30];
	    VPlaneAlphaMode 	<= PWDATA[28:27];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        VPlaneXPosR		<= 0;
        VPlaneYPosR		<= 0;
	end
	else if (rVBMODWr) begin
	    VPlaneXPosR 	<= PWDATA[XW+YW+1:YW+1];
	    VPlaneYPosR  	<= PWDATA[YW:0];
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
        VPlaneXPos		<= 0;
        VPlaneYPos		<= 0;
	end
	else if (FrameStart) begin
	    VPlaneXPos 		<= VPlaneXPosR;
	    VPlaneYPos  	<= VPlaneYPosR;
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		VPlaneXRefR			<= 0;
	end
	else if (rVBASEWr) begin
		VPlaneXRefR			<= PWDATA[VW+1:0];
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
		VPlaneXRef			<= 0;
	end
	else if (FrameStart) begin
		VPlaneXRef			<= VPlaneXRefR;
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        VPlaneStartAddr 	<= 0;
	end
	else if (rVADDRWr) begin
	    VPlaneStartAddr 	<= PWDATA[31:2];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        VPlaneStartAddr2 	<= 0;
	end
	else if (rVADDR2Wr) begin
	    VPlaneStartAddr2 	<= PWDATA[31:2];
	end
//------------------------------------------------------------------------------
// Graphic Gamma
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        					GPlaneGamma00	<= {3{8'd0}};
        					GPlaneGamma01	<= {3{8'd16}};
        					GPlaneGamma02	<= {3{8'd32}};
        					GPlaneGamma03	<= {3{8'd48}};
        					GPlaneGamma04	<= {3{8'd64}};
        					GPlaneGamma05	<= {3{8'd80}};
        					GPlaneGamma06	<= {3{8'd96}};
        					GPlaneGamma07	<= {3{8'd112}};
        					GPlaneGamma08	<= {3{8'd128}};
        					GPlaneGamma09	<= {3{8'd144}};
        					GPlaneGamma0A	<= {3{8'd160}};
        					GPlaneGamma0B	<= {3{8'd176}};
        					GPlaneGamma0C	<= {3{8'd192}};
        					GPlaneGamma0D	<= {3{8'd208}};
        					GPlaneGamma0E	<= {3{8'd224}};
        					GPlaneGamma0F	<= {3{8'd240}};
        					GPlaneGamma10	<= {3{8'd255}};
	end
	else begin
		case(1'b1) // synopsys parallel_case full_case
			rGGAMMA00Wr :  	GPlaneGamma00 	<= PWDATA[23:0];
			rGGAMMA01Wr :  	GPlaneGamma01 	<= PWDATA[23:0];
			rGGAMMA02Wr :  	GPlaneGamma02 	<= PWDATA[23:0];
			rGGAMMA03Wr :  	GPlaneGamma03 	<= PWDATA[23:0];
			rGGAMMA04Wr :  	GPlaneGamma04 	<= PWDATA[23:0];
			rGGAMMA05Wr :  	GPlaneGamma05 	<= PWDATA[23:0];
			rGGAMMA06Wr :  	GPlaneGamma06 	<= PWDATA[23:0];
			rGGAMMA07Wr :  	GPlaneGamma07 	<= PWDATA[23:0];
			rGGAMMA08Wr :  	GPlaneGamma08 	<= PWDATA[23:0];
			rGGAMMA09Wr :  	GPlaneGamma09 	<= PWDATA[23:0];
			rGGAMMA0AWr :  	GPlaneGamma0A 	<= PWDATA[23:0];
			rGGAMMA0BWr :  	GPlaneGamma0B 	<= PWDATA[23:0];
			rGGAMMA0CWr :  	GPlaneGamma0C 	<= PWDATA[23:0];
			rGGAMMA0DWr :  	GPlaneGamma0D 	<= PWDATA[23:0];
			rGGAMMA0EWr :  	GPlaneGamma0E 	<= PWDATA[23:0];
			rGGAMMA0FWr :  	GPlaneGamma0F 	<= PWDATA[23:0];
			rGGAMMA10Wr :  	GPlaneGamma10 	<= PWDATA[23:0];
		endcase
	end

// Video Gamma
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        					VPlaneGamma00	<= {3{8'd0}};
        					VPlaneGamma01	<= {3{8'd16}};
        					VPlaneGamma02	<= {3{8'd32}};
        					VPlaneGamma03	<= {3{8'd48}};
        					VPlaneGamma04	<= {3{8'd64}};
        					VPlaneGamma05	<= {3{8'd80}};
        					VPlaneGamma06	<= {3{8'd96}};
        					VPlaneGamma07	<= {3{8'd112}};
        					VPlaneGamma08	<= {3{8'd128}};
        					VPlaneGamma09	<= {3{8'd144}};
        					VPlaneGamma0A	<= {3{8'd160}};
        					VPlaneGamma0B	<= {3{8'd176}};
        					VPlaneGamma0C	<= {3{8'd192}};
        					VPlaneGamma0D	<= {3{8'd208}};
        					VPlaneGamma0E	<= {3{8'd224}};
        					VPlaneGamma0F	<= {3{8'd240}};
        					VPlaneGamma10	<= {3{8'd255}};
	end
	else begin
		case(1'b1) // synopsys parallel_case full_case
			rVGAMMA00Wr :  	VPlaneGamma00 	<= PWDATA[23:0];
			rVGAMMA01Wr :  	VPlaneGamma01 	<= PWDATA[23:0];
			rVGAMMA02Wr :  	VPlaneGamma02 	<= PWDATA[23:0];
			rVGAMMA03Wr :  	VPlaneGamma03 	<= PWDATA[23:0];
			rVGAMMA04Wr :  	VPlaneGamma04 	<= PWDATA[23:0];
			rVGAMMA05Wr :  	VPlaneGamma05 	<= PWDATA[23:0];
			rVGAMMA06Wr :  	VPlaneGamma06 	<= PWDATA[23:0];
			rVGAMMA07Wr :  	VPlaneGamma07 	<= PWDATA[23:0];
			rVGAMMA08Wr :  	VPlaneGamma08 	<= PWDATA[23:0];
			rVGAMMA09Wr :  	VPlaneGamma09 	<= PWDATA[23:0];
			rVGAMMA0AWr :  	VPlaneGamma0A 	<= PWDATA[23:0];
			rVGAMMA0BWr :  	VPlaneGamma0B 	<= PWDATA[23:0];
			rVGAMMA0CWr :  	VPlaneGamma0C 	<= PWDATA[23:0];
			rVGAMMA0DWr :  	VPlaneGamma0D 	<= PWDATA[23:0];
			rVGAMMA0EWr :  	VPlaneGamma0E 	<= PWDATA[23:0];
			rVGAMMA0FWr :  	VPlaneGamma0F 	<= PWDATA[23:0];
			rVGAMMA10Wr :  	VPlaneGamma10 	<= PWDATA[23:0];
		endcase
	end
//------------------------------------------------------------------------------
`ifdef SCALER
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        UpScaleEn			<= 0;
        PreFilterEn 		<= 0;
        DnScaleEn			<= 0;
	end
	else if (rSCONWr) begin
	    UpScaleEn			<= PWDATA[31];
	    PreFilterEn			<= PWDATA[30];
	    DnScaleEn			<= PWDATA[0];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        ScaleInXSizeR 		<= 2047;
        ScaleInYSizeR 		<= 2047;
	end
	else if (rSSIZEWr) begin
	    ScaleInXSizeR 		<= PWDATA[23:12];
	    ScaleInYSizeR 		<= PWDATA[11:0];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        ScaleXRatioR 		<= 16'hffff;
        ScaleYRatioR 		<= 16'hffff;
	end
	else if (rSRATIOWr) begin
	    ScaleXRatioR 		<= PWDATA[31:16];
	    ScaleYRatioR 		<= PWDATA[15:0];
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
        ScaleInXSize 		<= 2047;
        ScaleInYSize 		<= 2047;
	end
	else if (FrameStart) begin
	    ScaleInXSize 		<= ScaleInXSizeR;
	    ScaleInYSize 		<= ScaleInYSizeR;
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
        ScaleXRatio 		<= 16'hffff;
        ScaleYRatio 		<= 16'hffff;
	end
	else if (FrameStart) begin
	    ScaleXRatio 		<= ScaleXRatioR;
	    ScaleYRatio 		<= ScaleYRatioR;
	end
`endif
//------------------------------------------------------------------------------
reg  [15:0]  LCDTiming0PCLK;
reg  [19:0]  LCDTiming1PCLK;
reg  [15:0]  LCDTiming2PCLK;
reg  [16:0]  LCDTiming3PCLK;
reg  [13:0]  LCDControlPCLK;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
	    LCDTiming0PCLK <= {32{1'b1}};
	    LCDTiming1PCLK <= {21'b1, 11'd2047};
	    LCDTiming2PCLK <= {32{1'b1}};
	    LCDTiming3PCLK <= {21'b1, 11'd2047};
	    LCDControlPCLK <= {1'b0, 2'b0, 4'b0, 2'b11, 4'b0};
	end
	else if (rHSYNC0Wr) begin
	    LCDTiming0PCLK <= PWDATA[15:0];
	end
	else if (rHSYNC1Wr) begin
	    LCDTiming1PCLK <= PWDATA[19:0];
	end
	else if (rVSYNC0Wr) begin
	    LCDTiming2PCLK <= PWDATA[15:0];
	end
	else if (rVSYNC1Wr) begin
	    LCDTiming3PCLK <= PWDATA[16:0];
	end
	else if (rLCDCONWr) begin
	    LCDControlPCLK <= {PWDATA[29], PWDATA[31:30], PWDATA[10:0]};
	end

assign LCDIPC  = LCDControlPCLK[3];
assign LCDPDIV = LCDControlPCLK[2:0];

reg  [12:0]  VIDControlPCLK;
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
	    VIDControlPCLK <= 0;
	end
	else if (rVIDCONWr) begin
	    VIDControlPCLK <= {PWDATA[31], PWDATA[11:0]};
	end

assign VideoSyncEnPCLK = LCDControlPCLK[12];
assign VideoOutEn      = LCDControlPCLK[13];
//-------------------------------------------------------------------------------
wire [XW:0]	MixerXSize;
wire [YW:0]	MixerYSize;

assign MixerXSize = LCDControlPCLK[12] ? LCDTiming1PCLK[10: 0] : (LCDTiming1PCLK[10: 0]>>1);
assign MixerYSize = LCDTiming3PCLK[10: 0];
//------------------------------------------------------------------------------
// LCD TG
// MetaStability 2 FF
LcdReg LcdSyncLcdClk(
 				.LCDCLK			(LCDCLK),
 				.nRST			(PRESETB),

				.VIDControlPCLK	(VIDControlPCLK),
 				.LCDTiming0PCLK	(LCDTiming0PCLK),
 				.LCDTiming1PCLK	(LCDTiming1PCLK),
 				.LCDTiming2PCLK	(LCDTiming2PCLK),
 				.LCDTiming3PCLK	(LCDTiming3PCLK),
 				.LCDControlPCLK (LCDControlPCLK[12:4]),

`ifdef BYPASS
				.VideoBP		(VideoBP),
				.VideoBPWait	(VideoBPWait),
`endif				
 				.LcdEn			(LCDEn),
 				.LcdPwrEn 		(LCDPwrEn),
 				.LcdBPP			(LCDBPP),
 				.BGR			(LCDBGR),
 				.CPL			(LCDCPL),
 				.HSW			(LCDHSW),
 				.HFP			(LCDHFP),
 				.HBP			(LCDHBP),
 				.LPS			(LCDLPS),
 				.VSW			(LCDVSW),
 				.VFP			(LCDVFP),
 				.VBP			(LCDVBP),
 				.IVS			(LCDIVS),
 				.IHS			(LCDIHS),
 				.IEO			(LCDIEO)
);
//------------------------------------------------------------------------------
// Error Status & Interrupt
//------------------------------------------------------------------------------
`ifdef PCLKisACLK // If ACLK = PCLK
wire		CDMAOverRunPCLK = CDMAOverRun;
wire		GDMAOverRunPCLK = GDMAOverRun;
wire		VDMAOverRunPCLK = VDMAOverRun;
wire		CurFIFOUnderRunPCLK = CurFIFOUnderRun;
wire		VidFIFOUnderRunPCLK = VidFIFOUnderRun;
wire		GraFIFOUnderRunPCLK = GraFIFOUnderRun;
wire		MixFIFOUnderRunPCLK = MixFIFOUnderRun;
wire		FrameStartPCLK = FrameStart;
wire		FrameEndPCLK = FrameEnd;
`else // If PCLK = 2 x ACLK
reg			CDMAOverRunD;
reg			GDMAOverRunD;
reg			VDMAOverRunD;
reg			CurFIFOUnderRunD;
reg			VidFIFOUnderRunD;
reg			GraFIFOUnderRunD;
reg			MixFIFOUnderRunD;

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
			CDMAOverRunD <= 0;
			GDMAOverRunD <= 0;
			VDMAOverRunD <= 0;
			CurFIFOUnderRunD <= 0;
			VidFIFOUnderRunD <= 0;
			GraFIFOUnderRunD <= 0;
			MixFIFOUnderRunD <= 0;
	end
	else begin
			CDMAOverRunD <= CDMAOverRun;
			GDMAOverRunD <= GDMAOverRun;
			VDMAOverRunD <= VDMAOverRun;
			CurFIFOUnderRunD <= CurFIFOUnderRun;
			VidFIFOUnderRunD <= VidFIFOUnderRun;
			GraFIFOUnderRunD <= GraFIFOUnderRun;
			MixFIFOUnderRunD <= MixFIFOUnderRun;
	end

reg			CDMAOverRunPCLK;
reg			GDMAOverRunPCLK;
reg			VDMAOverRunPCLK;
reg			CurFIFOUnderRunPCLK;
reg			VidFIFOUnderRunPCLK;
reg			GraFIFOUnderRunPCLK;
reg			MixFIFOUnderRunPCLK;
reg			FrameStartPCLK;
reg			FrameEndPCLK;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
			CDMAOverRunPCLK <= 0;
			GDMAOverRunPCLK <= 0;
			VDMAOverRunPCLK <= 0;
			CurFIFOUnderRunPCLK <= 0;
			VidFIFOUnderRunPCLK <= 0;
			GraFIFOUnderRunPCLK <= 0;
			MixFIFOUnderRunPCLK <= 0;
			FrameStartPCLK <= 0;
			FrameEndPCLK <= 0;
	end
	else begin
			CDMAOverRunPCLK <= CDMAOverRun | CDMAOverRunD;
			GDMAOverRunPCLK <= GDMAOverRun | GDMAOverRunD;
			VDMAOverRunPCLK <= VDMAOverRun | VDMAOverRunD;
			CurFIFOUnderRunPCLK <= CurFIFOUnderRun | CurFIFOUnderRunD;
			VidFIFOUnderRunPCLK <= VidFIFOUnderRun | VidFIFOUnderRunD;
			GraFIFOUnderRunPCLK <= GraFIFOUnderRun | GraFIFOUnderRunD;
			MixFIFOUnderRunPCLK <= MixFIFOUnderRun | MixFIFOUnderRunD;
			FrameStartPCLK <= FrameStart;
			FrameEndPCLK <= FrameEnd;
	end
`endif
//------------------------------------------------------------------------------
wire		PlaneFIFOError = CDMAOverRunPCLK | CurFIFOUnderRunPCLK | 
							 VDMAOverRunPCLK | VidFIFOUnderRunPCLK |
							 GDMAOverRunPCLK | GraFIFOUnderRunPCLK |
							 MixFIFOUnderRunPCLK;

wire		DmErrInt   		= DmErrIntEn   & PlaneFIFOError;
wire		DmFrameStartInt = DmStartIntEn & FrameStartPCLK;
wire		DmFrameEndInt   = DmEndIntEn   & FrameEndPCLK;

assign		DmInt	 		= DmErrInt | DmFrameStartInt | DmFrameEndInt;

wire		ClearErrSts;

reg 		CurFIFOUnderRunSts;
reg 		VidFIFOUnderRunSts;
reg 		GraFIFOUnderRunSts;
reg 		MixFIFOUnderRunSts;
reg 		CDMAOverRunSts;
reg 		VDMAOverRunSts;
reg 		GDMAOverRunSts;
reg 		FrameStartSts;
reg 		FrameEndSts;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 			CurFIFOUnderRunSts <= 1'b0;
	else if (ClearErrSts)		CurFIFOUnderRunSts <= 1'b0;
	else if (CurFIFOUnderRunPCLK & DmErrIntEn)
								CurFIFOUnderRunSts <= 1'b1;
	else						CurFIFOUnderRunSts <= CurFIFOUnderRunSts;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 			GraFIFOUnderRunSts <= 1'b0;
	else if (ClearErrSts)		GraFIFOUnderRunSts <= 1'b0;
	else if (GraFIFOUnderRunPCLK & DmErrIntEn)
								GraFIFOUnderRunSts <= 1'b1;
	else						GraFIFOUnderRunSts <= GraFIFOUnderRunSts;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 			VidFIFOUnderRunSts <= 1'b0;
	else if (ClearErrSts)		VidFIFOUnderRunSts <= 1'b0;
	else if (VidFIFOUnderRunPCLK & DmErrIntEn)
								VidFIFOUnderRunSts <= 1'b1;
	else						VidFIFOUnderRunSts <= VidFIFOUnderRunSts;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 			MixFIFOUnderRunSts <= 1'b0;
	else if (ClearErrSts)		MixFIFOUnderRunSts <= 1'b0;
	else if (MixFIFOUnderRunPCLK & DmErrIntEn)
								MixFIFOUnderRunSts <= 1'b1;
	else						MixFIFOUnderRunSts <= MixFIFOUnderRunSts;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 			CDMAOverRunSts <= 1'b0;
	else if (ClearErrSts)		CDMAOverRunSts <= 1'b0;
	else if (CDMAOverRunPCLK & DmErrIntEn)
								CDMAOverRunSts <= 1'b1;
	else						CDMAOverRunSts <= CDMAOverRunSts;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 			GDMAOverRunSts <= 1'b0;
	else if (ClearErrSts)		GDMAOverRunSts <= 1'b0;
	else if (GDMAOverRunPCLK & DmErrIntEn)
								GDMAOverRunSts <= 1'b1;
	else						GDMAOverRunSts <= GDMAOverRunSts;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 			VDMAOverRunSts <= 1'b0;
	else if (ClearErrSts)		VDMAOverRunSts <= 1'b0;
	else if (VDMAOverRunPCLK & DmErrIntEn)
								VDMAOverRunSts <= 1'b1;
	else						VDMAOverRunSts <= VDMAOverRunSts;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 			FrameStartSts <= 1'b0;
	else if (ClearErrSts)		FrameStartSts <= 1'b0;
	else if (FrameStartPCLK & DmStartIntEn) 	
								FrameStartSts <= 1'b1;
	else						FrameStartSts <= FrameStartSts;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 			FrameEndSts <= 1'b0;
	else if (ClearErrSts)		FrameEndSts <= 1'b0;
	else if (FrameEndPCLK & DmEndIntEn) 		
								FrameEndSts <= 1'b1;
	else						FrameEndSts <= FrameEndSts;
//------------------------------------------------------------------------------
assign ClearErrSts = rDMSTSRd;
//------------------------------------------------------------------------------
// Read Data Mux.
reg [31:0] 	PRDATA;
always @(negedge PRESETB or posedge PCLK)
	if 	(!PRESETB)		  PRDATA <= 32'b0;
	else begin
		case(1'b1) // synopsys parallel_case
    	  	rDMCONRd	: PRDATA <= {PrioritySel, DmErrIntEn, DmStartIntEn, DmEndIntEn};
    	  	rDMSTSRd	: PRDATA <= {FrameEvenField, 5'b0,	// [15]
    	  							 1'b0, CDMAOverRunSts, 
    	  							 GDMAOverRunSts, VDMAOverRunSts,
    	  							 CurFIFOUnderRunSts, GraFIFOUnderRunSts, 
    	  							 VidFIFOUnderRunSts, MixFIFOUnderRunSts,
    	  							 FrameStartSts, FrameEndSts};

			rCCONRd		: PRDATA <= {CPlaneEn, 1'b0, CPlaneN2PUpEn, CPlanePixFormat, 6'b0, CPlaneXSize, 1'b0, CPlaneYSize};
			rCBLNDRd	: PRDATA <= {CPlaneAlphaValue, CPlaneChromaKey};
			rCBMODRd	: PRDATA <= {1'b0, CPlaneChromaKeyEn, 1'b0, CPlaneAlphaMode, 5'b0, CPlaneXPos, CPlaneYPos};
			rCBASERd	: PRDATA <= {CPlaneXRef};
			rCADDRRd	: PRDATA <= {CDMARAddr, 2'b0};
//			rCADDR2Rd	: PRDATA <= {CDMARAddr, 2'b0};
			rCBLINKRd	: PRDATA <= {CPlaneAddrSwEn, 25'b0, CPlaneAddrSwVal};
			rCPALARd	: PRDATA <= {CPalMemWrAddr};
			rCPALMRd	: PRDATA <= {CPlanePalMemRdData};
			
			rBGCOLRd	: PRDATA <= {BPlaneDataIn};
			
			rGCONRd		: PRDATA <= {GPlaneEn, ColorBarSel, GPlanePixFormat, GPlaneGammaEn, GPlaneN2PUpEn, 3'b0, GPlaneXSize, GPlaneYSize};
			rGBLNDRd	: PRDATA <= {GPlaneAlphaValue, GPlaneChromaKey};
			rGBMODRd	: PRDATA <= {1'b0, GPlaneChromaKeyEn, 1'b0, GPlaneAlphaMode, 5'b0, GPlaneXPos, GPlaneYPos};
			rGBASERd	: PRDATA <= {GPlaneXRef};
			rGADDRRd	: PRDATA <= {GDMARAddr, 2'b0};
			rGPALARd	: PRDATA <= {GPalMemWrAddr};
			rGPALMRd	: PRDATA <= {GPlanePalMemRdData};
			
			rVCONRd		: PRDATA <= {VPlaneEn, VPlaneInterlaceEn, VPlaneN2PUpEn, VPlanePixFormat, VPlaneGammaEn, 4'b0, VPlaneXSize, VPlaneYSize};
			rVBLNDRd	: PRDATA <= {VPlaneAlphaValue, VPlaneChromaKey};
			rVBMODRd	: PRDATA <= {1'b0, VPlaneChromaKeyEn, 1'b0, VPlaneAlphaMode, 5'b0, VPlaneXPos, VPlaneYPos};
			rVBASERd	: PRDATA <= {VPlaneXRef};
			rVADDRRd	: PRDATA <= {VDMARAddr, 2'b0};
//			rVADDR2Rd	: PRDATA <= {VDMARAddr, 2'b0};

`ifdef SCALER			
  			rSCONRd		: PRDATA <= {UpScaleEn, PreFilterEn, 29'b0, DnScaleEn};
  			rSSIZERd	: PRDATA <= {10'b0, ScaleInXSize, ScaleInYSize};
  			rSRATIORd	: PRDATA <= {ScaleXRatio, ScaleYRatio};
`endif

			rHSYNC0Rd	: PRDATA <= LCDTiming0PCLK;
			rHSYNC1Rd	: PRDATA <= LCDTiming1PCLK;
			rVSYNC0Rd	: PRDATA <= LCDTiming2PCLK;
			rVSYNC1Rd	: PRDATA <= LCDTiming3PCLK;
			rLCDCONRd	: PRDATA <= LCDControlPCLK;
			rVIDCONRd 	: PRDATA <= VIDControlPCLK;
			
//			rGGAMMA00Rd	: PRDATA <= GPlaneGamma00;
//			rGGAMMA01Rd	: PRDATA <= GPlaneGamma01;
//			rGGAMMA02Rd	: PRDATA <= GPlaneGamma02;
//			rGGAMMA03Rd	: PRDATA <= GPlaneGamma03;
//			rGGAMMA04Rd	: PRDATA <= GPlaneGamma04;
//			rGGAMMA05Rd	: PRDATA <= GPlaneGamma05;
//			rGGAMMA06Rd	: PRDATA <= GPlaneGamma06;
//			rGGAMMA07Rd	: PRDATA <= GPlaneGamma07;
//			rGGAMMA08Rd	: PRDATA <= GPlaneGamma08;
//			rGGAMMA09Rd	: PRDATA <= GPlaneGamma09;
//			rGGAMMA0ARd	: PRDATA <= GPlaneGamma0A;
//			rGGAMMA0BRd	: PRDATA <= GPlaneGamma0B;
//			rGGAMMA0CRd	: PRDATA <= GPlaneGamma0C;
//			rGGAMMA0DRd	: PRDATA <= GPlaneGamma0D;
//			rGGAMMA0ERd	: PRDATA <= GPlaneGamma0E;
//			rGGAMMA0FRd	: PRDATA <= GPlaneGamma0F;
//			rGGAMMA10Rd	: PRDATA <= GPlaneGamma10;
//			rVGAMMA00Rd	: PRDATA <= VPlaneGamma00;
//			rVGAMMA01Rd	: PRDATA <= VPlaneGamma01;
//			rVGAMMA02Rd	: PRDATA <= VPlaneGamma02;
//			rVGAMMA03Rd	: PRDATA <= VPlaneGamma03;
//			rVGAMMA04Rd	: PRDATA <= VPlaneGamma04;
//			rVGAMMA05Rd	: PRDATA <= VPlaneGamma05;
//			rVGAMMA06Rd	: PRDATA <= VPlaneGamma06;
//			rVGAMMA07Rd	: PRDATA <= VPlaneGamma07;
//			rVGAMMA08Rd	: PRDATA <= VPlaneGamma08;
//			rVGAMMA09Rd	: PRDATA <= VPlaneGamma09;
//			rVGAMMA0ARd	: PRDATA <= VPlaneGamma0A;
//			rVGAMMA0BRd	: PRDATA <= VPlaneGamma0B;
//			rVGAMMA0CRd	: PRDATA <= VPlaneGamma0C;
//			rVGAMMA0DRd	: PRDATA <= VPlaneGamma0D;
//			rVGAMMA0ERd	: PRDATA <= VPlaneGamma0E;
//			rVGAMMA0FRd	: PRDATA <= VPlaneGamma0F;
//			rVGAMMA10Rd	: PRDATA <= VPlaneGamma10;
    	  	default  	: PRDATA <= PRDATA;
    	endcase
    end
//------------------------------------------------------------------------------

endmodule
