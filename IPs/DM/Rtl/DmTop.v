// =================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from RichenTech           
//  ALL RIGHTS RESERVED RichenTech                                
// -----------------------------------------------------------------
// Version and Release information: 
//                                  
//      Ver3.00 : MixerFIFO.v memory model -> register
// 
// File Name           : DDRTop.v 
// File Revision       : 3.00 - CT2000 (TSMC) 
//  ----------------------------------------------------------------
//  Purpose            : Display module Top block
//                       
//  ----------------------------------------------------------------

module DmTop(
   			ACLK,
   			ARESETn,
   			
   			ARID  ,
   			ARADDR,
   			ARLEN ,
   			ARSIZE,
   			ARBURST,
   			ARLOCK ,
   			ARCACHE,
   			ARPROT ,
   			ARVALID,
   			ARREADY,
   			
   			RID   ,
   			RDATA ,
   			RRESP ,
   			RLAST ,
   			RVALID,
   			RREADY,
   			
   			PCLK,
			PRESETB,
    		PSEL, 
    		PENABLE, 
    		PADDR, 
    		PWRITE, 
    		PWDATA, 
			PRDATA,

			LCDCLK,
			LCDCLKo,
			LCDHSync,
			LCDVSync,
			LCDDataEn,
			LCDData,
			LCDBPP,
			
			BT656Field,
            BT656VSync,
            BT601Blank,
            DmInitial,
			
`ifdef BYPASS
			VideoBPReq,
			VideoBPAck,
			VIFDataRequest,
			VIFDataValid,
			VIFDataIn,
			FIFOClearBT,
`endif			
			LCDPDIV,
			VideoSyncEnPCLK,
			VideoOutEn,
			
			DmInt
);

`include "DmDef.v"
`include "DmPara.v"

input 			ACLK;
input 			ARESETn;

// AXI Signals
output [IW:0]	ARID;
output [31:0]	ARADDR;
output [3:0] 	ARLEN;
output [2:0] 	ARSIZE;
output [1:0] 	ARBURST;
output [1:0] 	ARLOCK;
output [3:0] 	ARCACHE;
output [2:0] 	ARPROT;
output 		 	ARVALID;
input 		 	ARREADY;

input [IW:0] 	RID;
input [DW:0] 	RDATA;
input [1:0]  	RRESP;
input 		 	RLAST;
input 		 	RVALID;
output 		 	RREADY;

input         	PCLK;
input         	PRESETB;

input  [ 9:2] 	PADDR;
input         	PWRITE;
input         	PSEL;
input         	PENABLE;
input  [31:0] 	PWDATA;
output [31:0] 	PRDATA;

input 			LCDCLK;
output			LCDCLKo;
output 			LCDHSync;
output 			LCDVSync;
output 			LCDDataEn;
output [23:0] 	LCDData;
output [ 2:0]	LCDBPP;

output       	BT656Field;
output       	BT656VSync;
output       	BT601Blank;
output       	DmInitial;

`ifdef BYPASS
// External Video Bypass Mode Interface
output			VideoBPReq;
input			VideoBPAck;
output			VIFDataRequest;
input			VIFDataValid;
input  [DW:0] 	VIFDataIn;
output			FIFOClearBT;
`endif

output [ 2:0]	LCDPDIV;	// LCD Clock Divide
output			VideoSyncEnPCLK;	// When Low, Video Clock is External 27MHz Clock
output			VideoOutEn;

output			DmInt;
//-------------------------------------------------------------------------------
// Register Interface
wire [IW:0]	DmaRid;
wire       	DmaRd;
wire [31:0]	DmaRaddr;
wire [4:0] 	DmaRsize;
wire [BW:0]	DmaRbe;
wire [DW:0]	DmaRdata;
wire 		DmaRvalid;
wire 		DmaRbusy;
wire [IW:0]	DmaRdid;
wire		DmaRlast;

// Plane Mixer
wire		SWReset;
wire		PrioritySel;
wire [23:0] BPlaneDataIn;

wire [XW:0] CPlaneXPos;
wire [YW:0] CPlaneYPos;
wire [XW:0] GPlaneXPos;
wire [YW:0] GPlaneYPos;
wire [XW:0] VPlaneXPos;
wire [YW:0] VPlaneYPos;
wire [XW:0]	MixerXSize;
wire [YW:0]	MixerYSize;

// Cursor Plane
wire		CPlaneEn;
wire 		CPlaneChromaKeyEn;
wire [23:0] CPlaneChromaKey;
wire [ 1:0]	CPlanePixFormat;
wire [ 1:0]	CPlaneAlphaMode;
wire [ 7:0] CPlaneAlphaValue;
wire [CW+1:0] CPlaneXRef;
wire [CW:0] CPlaneXSize;
wire [CW:0] CPlaneYSize;
wire [AW:0] CPlaneStartAddr, CPlaneStartAddr2;
wire		CPlaneAddrSwEn;
wire [ 5:0] CPlaneAddrSwVal;

// Cursor Palette Memory
wire		CPlanePalMemRead;
wire [31:0] CPlanePalMemRdData;
wire		CPlanePalMemWrite;
wire [ 7:0] CPlanePalMemWrAddr;
wire [31:0] CPlanePalMemWrData;

// Graphic Plane
wire		GPlaneEn;
wire 		GPlaneChromaKeyEn;
wire [23:0] GPlaneChromaKey;
wire [ 2:0]	GPlanePixFormat;
wire [ 1:0]	GPlaneAlphaMode;
wire [ 7:0] GPlaneAlphaValue;
wire [GW+1:0] GPlaneXRef;
wire [GW:0] GPlaneXSize;
wire [GW:0] GPlaneYSize;
wire [AW:0] GPlaneStartAddr;
wire		GPlaneGammaEn;

// Graphic Palette Memory
wire		GPlanePalMemRead;
wire [31:0] GPlanePalMemRdData;
wire		GPlanePalMemWrite;
wire [ 7:0] GPlanePalMemWrAddr;
wire [31:0] GPlanePalMemWrData;

wire [23:0] GPlaneGamma10; 
wire [23:0] GPlaneGamma0F; 
wire [23:0] GPlaneGamma0E; 
wire [23:0] GPlaneGamma0D; 
wire [23:0] GPlaneGamma0C; 
wire [23:0] GPlaneGamma0B; 
wire [23:0] GPlaneGamma0A; 
wire [23:0] GPlaneGamma09; 
wire [23:0] GPlaneGamma08; 
wire [23:0] GPlaneGamma07; 
wire [23:0] GPlaneGamma06; 
wire [23:0] GPlaneGamma05; 
wire [23:0] GPlaneGamma04; 
wire [23:0] GPlaneGamma03; 
wire [23:0] GPlaneGamma02; 
wire [23:0] GPlaneGamma01; 
wire [23:0] GPlaneGamma00;

// Video Plane
wire		VPlaneEn;
wire		VPlaneInterlaceEn;
wire		VPlaneN2PUpEn;
wire 		VPlaneChromaKeyEn;
wire [23:0] VPlaneChromaKey;
wire [ 1:0]	VPlanePixFormat;
wire [ 1:0]	VPlaneAlphaMode;
wire [ 7:0] VPlaneAlphaValue;
wire [VW+1:0] VPlaneXRef;
wire [VW:0] VPlaneXSize;
wire [VW:0] VPlaneYSize;
wire [AW:0] VPlaneStartAddr;
wire [AW:0] VPlaneStartAddr2;
wire		VPlaneGammaEn;

wire [23:0] VPlaneGamma10; 
wire [23:0] VPlaneGamma0F; 
wire [23:0] VPlaneGamma0E; 
wire [23:0] VPlaneGamma0D; 
wire [23:0] VPlaneGamma0C; 
wire [23:0] VPlaneGamma0B; 
wire [23:0] VPlaneGamma0A; 
wire [23:0] VPlaneGamma09; 
wire [23:0] VPlaneGamma08; 
wire [23:0] VPlaneGamma07; 
wire [23:0] VPlaneGamma06; 
wire [23:0] VPlaneGamma05; 
wire [23:0] VPlaneGamma04; 
wire [23:0] VPlaneGamma03; 
wire [23:0] VPlaneGamma02; 
wire [23:0] VPlaneGamma01; 
wire [23:0] VPlaneGamma00;

// LCD Time Gen.
wire [ 2:0] LCDBPP;
wire [ 0:0] LCDBGR;
wire [ 7:0] LCDHFP;
wire [ 7:0] LCDHBP;
wire [ 8:0] LCDHSW;
wire [XW:0] LCDCPL;
wire [ 5:0] LCDVSW;
wire [ 7:0] LCDVFP;
wire [ 7:0] LCDVBP;
wire [YW:0] LCDLPS;
wire       	LCDIVS;
wire       	LCDIHS;
wire       	LCDIEO;
wire		LCDPwrEn;
wire       	LCDEn;   

// Internal Module Interface
wire 		CDMARDataValid;
wire 		CDMARCmd;
wire 		CDMARCmdAck;
wire [ 4:0]	CDMARBurstLen;
wire [AW:0] CDMARAddr;

wire 		CPlaneDataRequest;
wire 		CPlaneDataValid;
wire [31:0] CPlaneDataIn;

wire [DW:0] CDMADataIn;
wire 		CDMADataValid;
wire 		CDMADataRequest;

wire 		GDMARDataValid;
wire 		GDMARCmd;
wire 		GDMARCmdAck;
wire [ 4:0]	GDMARBurstLen;
wire [AW:0] GDMARAddr;

wire 		GPlaneDataRequest;
wire 		GPlaneDataValid;
wire [31:0] GPlaneDataIn;

wire [DW:0] GDMADataIn;
wire 		GDMADataValid;
wire 		GDMADataRequest;

wire 		VDMARDataValid;
wire 		VDMARCmd;
wire 		VDMARCmdAck;
wire [ 4:0]	VDMARBurstLen;
wire [AW:0] VDMARAddr;

wire 		VPlaneDataRequest;
wire 		VPlaneDataValid;
wire [31:0] VPlaneDataIn;

wire [DW:0] VDMADataIn;
wire 		VDMADataValid;
wire 		VDMADataRequest;

wire [DW:0] GDMARData;
wire [DW:0] CDMARData;
wire [DW:0] VDMARData;

wire [CW:0] CPlaneXSizeRef;
wire [GW:0] GPlaneXSizeRef;
wire [VW:0] VPlaneXSizeRef;

`ifdef SCALER
wire 		PreFilterEn;
wire 		DnScaleEn;
wire 		UpScaleEn;
wire [VW:0]	ScaleInXSize;
wire [VW:0]	ScaleInYSize;
wire [15:0] ScaleXRatio;
wire [15:0] ScaleYRatio;
`endif

wire [23:0] MixerDataOut;

// LCD Interface
wire 		PlaneMixerEn;
wire 		FrameRst;
wire 		FrameStart;

wire 		PlaneMixerEnVID;
wire 		FrameRstVID;
wire 		FrameStartVID;

wire		VideoSyncEnPCLK;

// FIFO Error Status Interrupt
wire		CurFIFOOverRun;
wire		CurFIFOUnderRun;
wire		VidFIFOOverRun;
wire		VidFIFOUnderRun;
wire		GraFIFOOverRun;
wire		GraFIFOUnderRun;
wire		MixFIFOOverRun;
wire		MixFIFOUnderRun;

wire		CDMAOverRun;
wire		CDMAUnderRun;
wire		GDMAOverRun;
wire		GDMAUnderRun;
wire		VDMAOverRun;
wire		VDMAUnderRun;
//-------------------------------------------------------------------------------
`ifdef BYPASS
wire		VideoBPEn;
wire [11:0]	VideoBPWait;

assign		VideoBPReq  = VideoBPEn;
assign 		FIFOClearBT = FrameRst & VideoBPEn;
`endif
//-------------------------------------------------------------------------------
wire		LCDIPC;
assign LCDCLKo = LCDIPC ? ~LCDCLK : LCDCLK;
//-------------------------------------------------------------------------------
// Register
DmReg DmReg(
   				.ACLK            	(ACLK),
   				.ARESETn           	(ARESETn),

				.LCDCLK				(LCDCLK),
				
				.PCLK				(PCLK),
				.PRESETB			(PRESETB),
    			.PSEL				(PSEL), 
    			.PENABLE			(PENABLE), 
    			.PADDR				(PADDR), 
    			.PWRITE				(PWRITE), 
    			.PWDATA				(PWDATA), 
				.PRDATA				(PRDATA),

				.CurFIFOUnderRun	(CurFIFOUnderRun),
				.GraFIFOUnderRun	(GraFIFOUnderRun),
				.VidFIFOUnderRun	(VidFIFOUnderRun),
				.MixFIFOUnderRun	(MixFIFOUnderRun),
				.CDMAOverRun		(CDMAOverRun),
				.GDMAOverRun		(GDMAOverRun),
				.VDMAOverRun		(VDMAOverRun),
				
				.DmInt				(DmInt),

				.FrameStart			(FrameStart),
				.FrameEnd			(FrameRst),
				.FrameEvenField		(FrameEvenField),
				
				.CDMARAddr			(CDMARAddr),
				.GDMARAddr			(GDMARAddr),
				.VDMARAddr			(VDMARAddr),
				
				.LCDIPC				(LCDIPC),
				.LCDPDIV			(LCDPDIV),

// Plane Mixer
				.SWReset			(SWReset),
				.PrioritySel		(PrioritySel),
				.BPlaneDataIn		(BPlaneDataIn),
				.CPlaneXPos			(CPlaneXPos),
				.CPlaneYPos			(CPlaneYPos),
				.GPlaneXPos			(GPlaneXPos),
				.GPlaneYPos			(GPlaneYPos),
				.VPlaneXPos			(VPlaneXPos),
				.VPlaneYPos			(VPlaneYPos),
				.MixerXSize			(MixerXSize),
				.MixerYSize			(MixerYSize),

// Cursor Plane
				.CPlaneEn			(CPlaneEn),
				.CPlaneChromaKeyEn	(CPlaneChromaKeyEn),
				.CPlaneChromaKey	(CPlaneChromaKey),
				.CPlanePixFormat	(CPlanePixFormat),
				.CPlaneAlphaMode	(CPlaneAlphaMode),
				.CPlaneAlphaValue	(CPlaneAlphaValue),
				.CPlaneXRef			(CPlaneXRef),
				.CPlaneXSize		(CPlaneXSize),
				.CPlaneYSize		(CPlaneYSize),
				.CPlaneStartAddr	(CPlaneStartAddr),
				.CPlaneStartAddr2	(CPlaneStartAddr2),
				.CPlaneAddrSwEn		(CPlaneAddrSwEn),
				.CPlaneAddrSwVal	(CPlaneAddrSwVal),
				.CPlaneN2PUpEn		(CPlaneN2PUpEn),

// Palette Memory
				.CPlanePalMemWrite 	(CPlanePalMemWrite ),
				.CPlanePalMemWrAddr	(CPlanePalMemWrAddr),
				.CPlanePalMemWrData	(CPlanePalMemWrData),
				.CPlanePalMemRead 	(CPlanePalMemRead),
				.CPlanePalMemRdData (CPlanePalMemRdData),

// Graphic Plane
				.ColorBarSel		(ColorBarSel),
				.GPlaneEn			(GPlaneEn),
				.GPlaneChromaKeyEn	(GPlaneChromaKeyEn),
				.GPlaneChromaKey	(GPlaneChromaKey),
				.GPlanePixFormat	(GPlanePixFormat),
				.GPlaneAlphaMode	(GPlaneAlphaMode),
				.GPlaneAlphaValue	(GPlaneAlphaValue),
				.GPlaneXRef			(GPlaneXRef),
				.GPlaneXSize		(GPlaneXSize),
				.GPlaneYSize		(GPlaneYSize),
				.GPlaneStartAddr	(GPlaneStartAddr),
				.GPlaneGammaEn		(GPlaneGammaEn),
				.GPlaneN2PUpEn		(GPlaneN2PUpEn),

// Palette Memory
				.GPlanePalMemWrite 	(GPlanePalMemWrite ),
				.GPlanePalMemWrAddr	(GPlanePalMemWrAddr),
				.GPlanePalMemWrData	(GPlanePalMemWrData),
				.GPlanePalMemRead 	(GPlanePalMemRead),
				.GPlanePalMemRdData (GPlanePalMemRdData),

				.GPlaneGamma10		(GPlaneGamma10), 
				.GPlaneGamma0F		(GPlaneGamma0F), 
				.GPlaneGamma0E		(GPlaneGamma0E), 
				.GPlaneGamma0D		(GPlaneGamma0D), 
				.GPlaneGamma0C		(GPlaneGamma0C), 
				.GPlaneGamma0B		(GPlaneGamma0B), 
				.GPlaneGamma0A		(GPlaneGamma0A), 
				.GPlaneGamma09		(GPlaneGamma09), 
				.GPlaneGamma08		(GPlaneGamma08), 
				.GPlaneGamma07		(GPlaneGamma07), 
				.GPlaneGamma06		(GPlaneGamma06), 
				.GPlaneGamma05		(GPlaneGamma05), 
				.GPlaneGamma04		(GPlaneGamma04), 
				.GPlaneGamma03		(GPlaneGamma03), 
				.GPlaneGamma02		(GPlaneGamma02), 
				.GPlaneGamma01		(GPlaneGamma01), 
				.GPlaneGamma00		(GPlaneGamma00),

// Video Plane
				.VPlaneEn			(VPlaneEn),
				.VPlaneInterlaceEn	(VPlaneInterlaceEn),
				.VPlaneN2PUpEn		(VPlaneN2PUpEn),
				.VPlaneChromaKeyEn	(VPlaneChromaKeyEn),
				.VPlaneChromaKey	(VPlaneChromaKey),
				.VPlanePixFormat	(VPlanePixFormat),
				.VPlaneAlphaMode	(VPlaneAlphaMode),
				.VPlaneAlphaValue	(VPlaneAlphaValue),
				.VPlaneXRef			(VPlaneXRef),
				.VPlaneXSize		(VPlaneXSize),
				.VPlaneYSize		(VPlaneYSize),
				.VPlaneStartAddr	(VPlaneStartAddr),
				.VPlaneStartAddr2	(VPlaneStartAddr2),
				.VPlaneGammaEn		(VPlaneGammaEn),

`ifdef SCALER
				.PreFilterEn		(PreFilterEn),
				.DnScaleEn			(DnScaleEn),
				.UpScaleEn			(UpScaleEn),
				.ScaleInXSize		(ScaleInXSize),
				.ScaleInYSize		(ScaleInYSize),
				.ScaleXRatio		(ScaleXRatio),
				.ScaleYRatio		(ScaleYRatio),
`endif

				.VPlaneGamma10		(VPlaneGamma10), 
				.VPlaneGamma0F		(VPlaneGamma0F), 
				.VPlaneGamma0E		(VPlaneGamma0E), 
				.VPlaneGamma0D		(VPlaneGamma0D), 
				.VPlaneGamma0C		(VPlaneGamma0C), 
				.VPlaneGamma0B		(VPlaneGamma0B), 
				.VPlaneGamma0A		(VPlaneGamma0A), 
				.VPlaneGamma09		(VPlaneGamma09), 
				.VPlaneGamma08		(VPlaneGamma08), 
				.VPlaneGamma07		(VPlaneGamma07), 
				.VPlaneGamma06		(VPlaneGamma06), 
				.VPlaneGamma05		(VPlaneGamma05), 
				.VPlaneGamma04		(VPlaneGamma04), 
				.VPlaneGamma03		(VPlaneGamma03), 
				.VPlaneGamma02		(VPlaneGamma02), 
				.VPlaneGamma01		(VPlaneGamma01), 
				.VPlaneGamma00		(VPlaneGamma00),

// Video Time Gen.
				.VideoSyncEnPCLK	(VideoSyncEnPCLK),
				.VideoOutEn			(VideoOutEn),

`ifdef BYPASS
				.VideoBP			(VideoBP),
				.VideoBPWait		(VideoBPWait),
`endif

// LCD Time Gen.
				.LCDBPP				(LCDBPP),
				.LCDBGR				(LCDBGR),
				.LCDHFP				(LCDHFP),
				.LCDHBP				(LCDHBP),
				.LCDHSW				(LCDHSW),
				.LCDCPL				(LCDCPL),
				.LCDVSW				(LCDVSW),
				.LCDVFP				(LCDVFP),
				.LCDVBP				(LCDVBP),
				.LCDLPS				(LCDLPS),
				.LCDIVS				(LCDIVS),
				.LCDIHS				(LCDIHS),
				.LCDIEO				(LCDIEO),
				.LCDPwrEn			(LCDPwrEn),
				.LCDEn				(LCDEn)
);
//-------------------------------------------------------------------------------
// AXI Master Read DMA
DmARIf DmARIf(
   				.ACLK            	(ACLK),
   				.ARESETn           	(ARESETn),

   				.ARID           	(ARID),
   				.ARADDR         	(ARADDR),
   				.ARLEN          	(ARLEN),
   				.ARSIZE         	(ARSIZE),
   				.ARBURST        	(ARBURST),
   				.ARLOCK         	(ARLOCK),
   				.ARCACHE        	(ARCACHE),
   				.ARPROT         	(ARPROT),
   				.ARVALID        	(ARVALID),
   				.ARREADY        	(ARREADY),

   				.RID            	(RID),
   				.RDATA          	(RDATA),
   				.RRESP          	(RRESP),
   				.RLAST          	(RLAST),
   				.RVALID         	(RVALID),
   				.RREADY         	(RREADY),

   				.grd            	(DmaRd),
   				.graddr         	(DmaRaddr),
   				.grsize         	(DmaRsize),
   				.grbe           	(DmaRbe),
   				.grdata         	(DmaRdata),
   				.grvalid        	(DmaRvalid),
   				.grbusy         	(DmaRbusy),
   				.grid				(DmaRid),
   				.grdid				(DmaRdid),
   				.grlast				(DmaRlast)
);
//-------------------------------------------------------------------------------
// Read DMA Aribter
DmRDmaArb DmRDmaArb(
				.nRST				(ARESETn), 
				.Clk 				(ACLK),
				.FrameRst			(FrameRst),
        		
				.Req0				(CDMARCmd),
				.Ack0				(CDMARCmdAck),
				.Valid0				(CDMARDataValid), 
				.BLen0				(CDMARBurstLen), 
				.Addr0				(CDMARAddr),
				.RLast0				(CDMARLast),
				.RdData0			(CDMARData), 
				
				.Req1				(GDMARCmd), 
				.Ack1				(GDMARCmdAck),
				.Valid1				(GDMARDataValid), 
				.BLen1				(GDMARBurstLen), 
				.Addr1				(GDMARAddr),
				.RLast1				(GDMARLast),
				.RdData1			(GDMARData), 
				            		
				.Req2				(VDMARCmd), 
				.Ack2				(VDMARCmdAck),
				.Valid2				(VDMARDataValid), 
				.BLen2				(VDMARBurstLen), 
				.Addr2				(VDMARAddr),
				.RLast2				(VDMARLast),
				.RdData2			(VDMARData), 

				.ValidID			(DmaRdid), 
				.RLast				(DmaRlast),
				.Valid  			(DmaRvalid), 
				.RdData 			(DmaRdata),
                                	
				.RdReq  			(DmaRd), 
				.RdAck				(DmaRbusy),
				.ReqID				(DmaRid), 
				.Addr  				(DmaRaddr), 
				.BLen				(DmaRsize)
);
//-------------------------------------------------------------------------------
// Video Plane
VideoDma VideoDma(
				.Clk 				(ACLK), 
				.nRST				(ARESETn),
				.FIFOClear			(FrameRst),
				.VPlaneEn			(VPlaneEn),
				.VPlaneInterlaceEn	(VPlaneInterlaceEn),
				.VPlaneN2PUpEn		(VPlaneN2PUpEn),
				.FrameStart			(FrameStart),
`ifdef BYPASS
				.VideoBPEn			(VideoBPEn),
				.VIFDataRequest		(VIFDataRequest),
				.VIFDataValid		(VIFDataValid),
				.VIFDataIn			(VIFDataIn),
`endif
				
				.VPlaneStartAddr	(VPlaneStartAddr),
				.VPlaneStartAddr2	(VPlaneStartAddr2),
				.VPlaneXSize		(VPlaneXSizeRef),
`ifdef SCALER
				.VPlaneYSize		(ScaleInYSize),
`else
				.VPlaneYSize		(VPlaneYSize),
`endif
				.VPlaneXRef			(VPlaneXRef),

				.VDMARDataValid		(VDMARDataValid),
				.VDMARLast			(VDMARLast),
				.VDMARData			(VDMARData),
				.VDMARCmdAck		(VDMARCmdAck),
				.VDMARCmd			(VDMARCmd),
				.VDMARBurstLen		(VDMARBurstLen),
				.VDMARAddr			(VDMARAddr),
								
				.VDMADataRequest	(VDMADataRequest),
				.VDMADataValid		(VDMADataValid),
				.VDMADataIn			(VDMADataIn),
				.VideoEn			(VideoEn),
				
				.VDMAOverRun		(VDMAOverRun),
				.VDMAUnderRun		(VDMAUnderRun)
);

VideoPlane VideoPlane(
				.Clk 				(ACLK), 
				.nRST				(ARESETn),
				.FIFOClear			(FrameRst),
				.VPlaneEn			(VPlaneEn),
				.FrameStart			(FrameStart),
				
				.VDMADataRequest	(VDMADataRequest),
				.VDMADataValid		(VDMADataValid),
				.VDMADataIn			(VDMADataIn),
				.VideoEn			(VideoEn),
				
				.VPlaneGammaEn		(VPlaneGammaEn),
				.VPlanePixFormat	(VPlanePixFormat),
				.VPlaneAlphaMode	(VPlaneAlphaMode),
				.VPlaneAlphaValue	(VPlaneAlphaValue),
				.VPlaneXSize		(VPlaneXSize),
				.VPlaneYSize		(VPlaneYSize),
				.VPlaneXSizeRef		(VPlaneXSizeRef),
`ifdef SCALER
				.PreFilterEn		(PreFilterEn),
				.DnScaleEn			(DnScaleEn),
				.UpScaleEn			(UpScaleEn),
				.ScaleInXSize		(ScaleInXSize),
				.ScaleInYSize		(ScaleInYSize),
				.ScaleXRatio		(ScaleXRatio),
				.ScaleYRatio		(ScaleYRatio),
`endif
				.VPlaneGamma10		(VPlaneGamma10), 
				.VPlaneGamma0F		(VPlaneGamma0F), 
				.VPlaneGamma0E		(VPlaneGamma0E), 
				.VPlaneGamma0D		(VPlaneGamma0D), 
				.VPlaneGamma0C		(VPlaneGamma0C), 
		 		.VPlaneGamma0B		(VPlaneGamma0B), 
		 		.VPlaneGamma0A		(VPlaneGamma0A), 
		 		.VPlaneGamma09		(VPlaneGamma09), 
		 		.VPlaneGamma08		(VPlaneGamma08), 
		 		.VPlaneGamma07		(VPlaneGamma07), 
		 		.VPlaneGamma06		(VPlaneGamma06), 
		 		.VPlaneGamma05		(VPlaneGamma05), 
		 		.VPlaneGamma04		(VPlaneGamma04), 
		 		.VPlaneGamma03		(VPlaneGamma03), 
		 		.VPlaneGamma02		(VPlaneGamma02), 
		 		.VPlaneGamma01		(VPlaneGamma01), 
		 		.VPlaneGamma00		(VPlaneGamma00),
		 	
				.VPlaneDataRequest	(VPlaneDataRequest),
				.VPlaneDataValid	(VPlaneDataValid),
				.VPlaneDataIn		(VPlaneDataIn),
				.VPlaneDataHold		(VPlaneDataHold),
				
				.VidFIFOOverRun		(VidFIFOOverRun),
				.VidFIFOUnderRun	(VidFIFOUnderRun)
);
//-------------------------------------------------------------------------------
// Graphic Plane
GraphicDma GraphicDma(
				.Clk 				(ACLK), 
				.nRST				(ARESETn),
				.FIFOClear			(FrameRst),
				.GPlaneEn			(GPlaneEn),
				.FrameStart			(FrameStart),
				.ColorBarSel		(ColorBarSel),
				.GPlaneN2PUpEn		(GPlaneN2PUpEn),
				
				.GPlaneStartAddr	(GPlaneStartAddr),
				.GPlaneXSize		(GPlaneXSizeRef),
				.GPlaneYSize		(GPlaneYSize),
				.GPlanePixFormat	(GPlanePixFormat),
				.GPlaneXRef			(GPlaneXRef),

				.GDMARDataValid		(GDMARDataValid),
				.GDMARLast			(GDMARLast),
				.GDMARData			(GDMARData),
				.GDMARCmd			(GDMARCmd),
				.GDMARCmdAck		(GDMARCmdAck),
				.GDMARBurstLen		(GDMARBurstLen),
				.GDMARAddr			(GDMARAddr),
								
				.GDMADataRequest	(GDMADataRequest),
				.GDMADataValid		(GDMADataValid),
				.GDMADataIn			(GDMADataIn),
				.GraphicEn			(GraphicEn),
				
				.GDMAOverRun		(GDMAOverRun),
				.GDMAUnderRun		(GDMAUnderRun)
);

GraphicPlane GraphicPlane(
				.Clk 				(ACLK), 
				.nRST				(ARESETn),
				.FIFOClear			(FrameRst),
				.GPlaneEn			(GPlaneEn),
				.FrameStart			(FrameStart),
				
				.GDMADataRequest	(GDMADataRequest),
				.GDMADataValid		(GDMADataValid),
				.GDMADataIn			(GDMADataIn),
				.GraphicEn			(GraphicEn),
				
				.PalMemWrite 		(GPlanePalMemWrite),
				.PalMemWrAddr		(GPlanePalMemWrAddr),
				.PalMemWrData		(GPlanePalMemWrData),
				.PalMemRead 		(GPlanePalMemRead),
				.PalMemRdData 		(GPlanePalMemRdData),
				
				.GPlaneGammaEn		(GPlaneGammaEn),
				.GPlanePixFormat	(GPlanePixFormat),
				.GPlaneAlphaMode	(GPlaneAlphaMode),
				.GPlaneAlphaValue	(GPlaneAlphaValue),
				.GPlaneXSize		(GPlaneXSize),
				.GPlaneYSize		(GPlaneYSize),
				.GPlaneXSizeRef		(GPlaneXSizeRef),
				
				.GPlaneGamma10		(GPlaneGamma10), 
				.GPlaneGamma0F		(GPlaneGamma0F), 
				.GPlaneGamma0E		(GPlaneGamma0E), 
				.GPlaneGamma0D		(GPlaneGamma0D), 
				.GPlaneGamma0C		(GPlaneGamma0C), 
		 		.GPlaneGamma0B		(GPlaneGamma0B), 
		 		.GPlaneGamma0A		(GPlaneGamma0A), 
		 		.GPlaneGamma09		(GPlaneGamma09), 
		 		.GPlaneGamma08		(GPlaneGamma08), 
		 		.GPlaneGamma07		(GPlaneGamma07), 
		 		.GPlaneGamma06		(GPlaneGamma06), 
		 		.GPlaneGamma05		(GPlaneGamma05), 
		 		.GPlaneGamma04		(GPlaneGamma04), 
		 		.GPlaneGamma03		(GPlaneGamma03), 
		 		.GPlaneGamma02		(GPlaneGamma02), 
		 		.GPlaneGamma01		(GPlaneGamma01), 
		 		.GPlaneGamma00		(GPlaneGamma00),
		 	
				.GPlaneDataRequest	(GPlaneDataRequest),
				.GPlaneDataValid	(GPlaneDataValid),
				.GPlaneDataIn		(GPlaneDataIn),
				
				.GraFIFOOverRun		(GraFIFOOverRun),
				.GraFIFOUnderRun	(GraFIFOUnderRun)
);
//-------------------------------------------------------------------------------
// Cursor Plane
CursorDma CursorDma(
				.Clk 				(ACLK), 
				.nRST				(ARESETn),
				.FIFOClear			(FrameRst),
				.CPlaneEn			(CPlaneEn),
				.FrameStart			(FrameStart),
				.CPlaneN2PUpEn		(CPlaneN2PUpEn),
				
				.CPlaneAddrSwEn		(CPlaneAddrSwEn),
				.CPlaneAddrSwVal	(CPlaneAddrSwVal),
				.CPlaneStartAddr	(CPlaneStartAddr),
				.CPlaneStartAddr2	(CPlaneStartAddr2),
				.CPlaneXSize		(CPlaneXSizeRef),
				.CPlaneYSize		(CPlaneYSize),
				.CPlanePixFormat	(CPlanePixFormat),
				.CPlaneXRef			(CPlaneXRef),

				.CDMARDataValid		(CDMARDataValid),
				.CDMARLast			(CDMARLast),
				.CDMARData			(CDMARData),
				.CDMARCmd			(CDMARCmd),
				.CDMARCmdAck		(CDMARCmdAck),
				.CDMARBurstLen		(CDMARBurstLen),
				.CDMARAddr			(CDMARAddr),
								
				.CDMADataRequest	(CDMADataRequest),
				.CDMADataValid		(CDMADataValid),
				.CDMADataIn			(CDMADataIn),
				.CursorEn			(CursorEn),
				
				.CDMAOverRun		(CDMAOverRun),
				.CDMAUnderRun		(CDMAUnderRun)
);

CursorPlane CursorPlane(
				.Clk 				(ACLK), 
				.nRST				(ARESETn),
				.FIFOClear			(FrameRst),
				.CPlaneEn			(CPlaneEn),
				.FrameStart			(FrameStart),
				
				.CDMADataRequest	(CDMADataRequest),
				.CDMADataValid		(CDMADataValid),
				.CDMADataIn			(CDMADataIn),
				.CursorEn			(CursorEn),
				
				.PalMemWrite 		(CPlanePalMemWrite),
				.PalMemWrAddr		(CPlanePalMemWrAddr),
				.PalMemWrData		(CPlanePalMemWrData),
				.PalMemRead 		(CPlanePalMemRead),
				.PalMemRdData 		(CPlanePalMemRdData),
				
				.CPlanePixFormat	(CPlanePixFormat),
				.CPlaneAlphaMode	(CPlaneAlphaMode),
				.CPlaneAlphaValue	(CPlaneAlphaValue),
				.CPlaneXSize		(CPlaneXSize),
				.CPlaneYSize		(CPlaneYSize),
				.CPlaneXSizeRef		(CPlaneXSizeRef),
				
				.CPlaneDataRequest	(CPlaneDataRequest),
				.CPlaneDataValid	(CPlaneDataValid),
				.CPlaneDataIn		(CPlaneDataIn),
				
				.CurFIFOOverRun		(CurFIFOOverRun),
				.CurFIFOUnderRun	(CurFIFOUnderRun)
);
//-------------------------------------------------------------------------------
PlaneMixer PlaneMixer(
				.Clk				(ACLK), 
				.nRST				(ARESETn),
				.LcdClk				(LCDCLK), 
				.FIFOClear			(FrameRst),
				.FIFOClearVID		(FrameRstVID),
				.PlaneMixerEn		(PlaneMixerEn),
				.PrioritySel		(PrioritySel),
				
				.LcdXSize			(MixerXSize),
				.LcdYSize			(MixerYSize),
				
				.GPlaneChromaKeyEn	(GPlaneChromaKeyEn),
				.VPlaneChromaKeyEn	(VPlaneChromaKeyEn),
				.CPlaneChromaKeyEn	(CPlaneChromaKeyEn),
				.GPlaneChromaKey	(GPlaneChromaKey),
				.VPlaneChromaKey	(VPlaneChromaKey),
				.CPlaneChromaKey	(CPlaneChromaKey),
				
				.GPlaneXPos			(GPlaneXPos),
				.GPlaneYPos			(GPlaneYPos),
				.GPlaneXSize		(GPlaneXSize),
				.GPlaneYSize		(GPlaneYSize),
				
				.VPlaneXPos			(VPlaneXPos),
				.VPlaneYPos			(VPlaneYPos),
				.VPlaneXSize 		(VPlaneXSize),
				.VPlaneYSize 		(VPlaneYSize),
				
				.CPlaneXPos			(CPlaneXPos),
				.CPlaneYPos			(CPlaneYPos),
				.CPlaneXSize		(CPlaneXSize),
				.CPlaneYSize		(CPlaneYSize),
				
				.GPlaneDataRequest	(GPlaneDataRequest),
				.VPlaneDataRequest	(VPlaneDataRequest),
				.CPlaneDataRequest	(CPlaneDataRequest),
				
				.GPlaneDataValid	(GPlaneDataValid),
				.VPlaneDataValid	(VPlaneDataValid),
				.CPlaneDataValid	(CPlaneDataValid),
				
				.GPlaneDataIn		(GPlaneDataIn),
				.VPlaneDataIn		(VPlaneDataIn),
				.CPlaneDataIn		(CPlaneDataIn),
				.BPlaneDataIn		(BPlaneDataIn),
				
				.VPlaneDataHold		(VPlaneDataHold),
				
				.LcdDataRequest		(DataRequest),
				.MixerDataValid		(),
				.MixerDataOut		(MixerDataOut),

				.MixFIFOOverRun		(MixFIFOOverRun),
				.MixFIFOUnderRun	(MixFIFOUnderRun)
);
//-------------------------------------------------------------------------------
wire VidDataRequest ;
wire LCDVSyncVid;   
wire LCDHSyncVid;   
wire LCDDataEnVid;  

assign DataRequest = VidDataRequest;
assign LCDVSync    = LCDVSyncVid;
assign LCDHSync    = LCDHSyncVid;
assign LCDDataEn   = LCDDataEnVid;

VideoTG VideoTG(
				.VClk  				(LCDCLK),
				.nRST   			(ARESETn),
				
				.LCDEn				(LCDEn),
				.SyncGenEn  		(LCDPwrEn),
`ifdef BYPASS
				.VideoBP			(VideoBP),
				.VideoBPEn			(VideoBPEn),
				.VideoBPAck			(VideoBPAck),
				.VideoBPWait		(VideoBPWait),
`endif
				.LCDIVS				(LCDIVS),
				.LCDIHS				(LCDIHS),
				.LCDIEO				(LCDIEO),

				.LCDHFP				(LCDHFP),
				.LCDHBP				(LCDHBP),
				.LCDHSW				(LCDHSW),
				.LCDCPL				(LCDCPL),
				.LCDVSW				(LCDVSW),
				.LCDVFP				(LCDVFP),
				.LCDVBP				(LCDVBP),
				.LCDLPS				(LCDLPS),
				
				.BT656Field			(BT656Field),
            	.BT656VSync			(BT656VSync),
            	.BT601Blank			(BT601Blank),
            	.DmInitial 			(DmInitial),

				.VSyncOut   		(LCDVSyncVid),
				.HSyncOut   		(LCDHSyncVid),
				.DataEn				(LCDDataEnVid),
				.DataRequest		(VidDataRequest),
				
				.EvenField			(EvenField),
				.FrameStart			(FrameStartVID),
				.FrameRst			(FrameRstVID),
				.MixerEn			(PlaneMixerEnVID)
);

LcdSyncSysClk LcdSyncSysClk(
				.SysClk				(ACLK),
				.nRST				(ARESETn),
				.SWReset			(SWReset),
				.FrameStart			(FrameStartVID),
				.FrameRst			(FrameRstVID),
				.PlaneMixerEn		(PlaneMixerEnVID),
				.EvenField			(EvenField),

				.FrStSyncSysClk		(FrameStart),
				.FrRstSyncSysClk	(FrameRst),
				.PlaneMixerEnSyncSysClk(PlaneMixerEn),
				.EvenFieldSyncSysClk(FrameEvenField)
);

LcdOutMux LcdOutMux(
				.LCDCLK				(LCDCLK),
				.nRST				(ARESETn),
				.LcdBPP				(LCDBPP),
				.LcdBGR				(LCDBGR),
				.CLPOWERint			(LCDPwrEn),
				.PixelRed			(MixerDataOut[23:16]),
				.PixelGreen			(MixerDataOut[15:8]),
				.PixelBlue			(MixerDataOut[7:0]),
				.LCDLDint			(LCDData)
);
//-------------------------------------------------------------------------------

endmodule
