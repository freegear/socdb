
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
			LCDHSync,
			LCDVSync,
			LCDDataEn,
			LCDData,
			
			DmErrInt
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
output 			LCDHSync;
output 			LCDVSync;
output 			LCDDataEn;
output [23:0] 	LCDData;

output			DmErrInt;
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
wire		DmIntEn;
wire		PrioritySel;
wire [23:0] BPlaneDataIn;

wire [XW:0] CPlaneXPos;
wire [YW:0] CPlaneYPos;
wire [XW:0] GPlaneXPos;
wire [YW:0] GPlaneYPos;
wire [XW:0] VPlaneXPos;
wire [YW:0] VPlaneYPos;

// Cursor Plane
wire		CPlaneEn;
wire 		CPlaneChromaKeyEn;
wire [23:0] CPlaneChromaKey;
wire [ 0:0]	CPlanePixFormat;
wire [ 1:0]	CPlaneAlphaMode;
wire [ 7:0] CPlaneAlphaValue;
wire [XW:0] CPlaneXStart;
wire [YW:0] CPlaneYStart;
wire [ 9:0] CPlaneXRef;
wire [XW:0] CPlaneXSize;
wire [YW:0] CPlaneYSize;
wire [AW:0] CPlaneStartAddr;
wire		CPlaneAddrSwEn;
wire [ 5:0] CPlaneAddrSwVal;

// Graphic Plane
wire		GPlaneEn;
wire 		GPlaneChromaKeyEn;
wire [23:0] GPlaneChromaKey;
wire [ 2:0]	GPlanePixFormat;
wire [ 1:0]	GPlaneAlphaMode;
wire [ 7:0] GPlaneAlphaValue;
wire [XW:0] GPlaneXStart;
wire [YW:0] GPlaneYStart;
wire [ 9:0] GPlaneXRef;
wire [XW:0] GPlaneXSize;
wire [YW:0] GPlaneYSize;
wire [AW:0] GPlaneStartAddr;
wire		GPlaneGammaEn;

// Palette Memory
wire		PalMemRead;
wire [23:0] PalMemRdData;
wire		PalMemWrite;
wire [ 7:0] PalMemWrAddr;
wire [23:0] PalMemWrData;

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
wire 		VPlaneChromaKeyEn;
wire [23:0] VPlaneChromaKey;
wire [ 1:0]	VPlanePixFormat;
wire [ 1:0]	VPlaneAlphaMode;
wire [ 7:0] VPlaneAlphaValue;
wire [XW:0] VPlaneXStart;
wire [YW:0] VPlaneYStart;
wire [ 9:0] VPlaneXRef;
wire [XW:0] VPlaneXSize;
wire [YW:0] VPlaneYSize;
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
wire [ 1:0] LCDBPP;
wire [ 0:0] LCDBGR;
wire [ 7:0] LCDHFP;
wire [ 7:0] LCDHBP;
wire [ 7:0] LCDHSW;
wire [XW:0] LCDCPL;
wire [ 5:0] LCDVSW;
wire [ 7:0] LCDVFP;
wire [ 7:0] LCDVBP;
wire [YW:0] LCDLPS;
wire       	LCDIVS;
wire       	LCDIHS;
wire       	LCDIEO;
wire       	LCDLEEn; 
wire [ 6:0] LCDLEDel;
wire		LCDPwrEn;
wire       	LCDEn;   
wire [1:0] 	LCDVComp;

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

wire [XW:0] CPlaneXSizeRef;
wire [XW:0] GPlaneXSizeRef;
wire [XW:0] VPlaneXSizeRef;

`ifdef SCALER
wire 		PreFilterEn;
wire 		DnScaleEn;
wire 		UpScaleEn;
wire [XW:0]	ScaleInXSize;
wire [YW:0]	ScaleInYSize;
wire [15:0] ScaleXRatio;
wire [15:0] ScaleYRatio;
`endif

wire [23:0] MixerDataOut;

// LCD Interface
wire 		PlaneMixerEn;
wire 		FrameRst;
wire 		FrameStart;
wire 		VCompStat;

wire 		PlaneMixerEnLCD;
wire 		FrameRstLCD;
wire 		FrameStartLCD;
wire 		VCompStatLCD;

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
				
				.DmErrInt			(DmErrInt),
				
// Plane Mixer
				.SWReset			(SWReset),
				.DmIntEn			(DmIntEn),
				.PrioritySel		(PrioritySel),
				.BPlaneDataIn		(BPlaneDataIn),
				.CPlaneXPos			(CPlaneXPos),
				.CPlaneYPos			(CPlaneYPos),
				.GPlaneXPos			(GPlaneXPos),
				.GPlaneYPos			(GPlaneYPos),
				.VPlaneXPos			(VPlaneXPos),
				.VPlaneYPos			(VPlaneYPos),

// Cursor Plane
				.CPlaneEn			(CPlaneEn),
				.CPlaneChromaKeyEn	(CPlaneChromaKeyEn),
				.CPlaneChromaKey	(CPlaneChromaKey),
				.CPlanePixFormat	(CPlanePixFormat),
				.CPlaneAlphaMode	(CPlaneAlphaMode),
				.CPlaneAlphaValue	(CPlaneAlphaValue),
				.CPlaneXStart		(CPlaneXStart),
				.CPlaneYStart		(CPlaneYStart),
				.CPlaneXRef			(CPlaneXRef),
				.CPlaneXSize		(CPlaneXSize),
				.CPlaneYSize		(CPlaneYSize),
				.CPlaneStartAddr	(CPlaneStartAddr),
				.CPlaneAddrSwEn		(CPlaneAddrSwEn),
				.CPlaneAddrSwVal	(CPlaneAddrSwVal),

// Graphic Plane
				.GPlaneEn			(GPlaneEn),
				.GPlaneChromaKeyEn	(GPlaneChromaKeyEn),
				.GPlaneChromaKey	(GPlaneChromaKey),
				.GPlanePixFormat	(GPlanePixFormat),
				.GPlaneAlphaMode	(GPlaneAlphaMode),
				.GPlaneAlphaValue	(GPlaneAlphaValue),
				.GPlaneXStart		(GPlaneXStart),
				.GPlaneYStart		(GPlaneYStart),
				.GPlaneXRef			(GPlaneXRef),
				.GPlaneXSize		(GPlaneXSize),
				.GPlaneYSize		(GPlaneYSize),
				.GPlaneStartAddr	(GPlaneStartAddr),
				.GPlaneGammaEn		(GPlaneGammaEn),

// Palette Memory
				.PalMemWrite 		(PalMemWrite ),
				.PalMemWrAddr		(PalMemWrAddr),
				.PalMemWrData		(PalMemWrData),
				.PalMemRead 		(PalMemRead),
				.PalMemRdData 		(PalMemRdData),

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
				.VPlaneChromaKeyEn	(VPlaneChromaKeyEn),
				.VPlaneChromaKey	(VPlaneChromaKey),
				.VPlanePixFormat	(VPlanePixFormat),
				.VPlaneAlphaMode	(VPlaneAlphaMode),
				.VPlaneAlphaValue	(VPlaneAlphaValue),
				.VPlaneXStart		(VPlaneXStart),
				.VPlaneYStart		(VPlaneYStart),
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
				.LCDLEEn			(LCDLEEn), 
				.LCDLEDel			(LCDLEDel),
				.LCDPwrEn			(LCDPwrEn),
				.LCDEn				(LCDEn),   
				.LCDVComp			(LCDVComp)
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
				
				.Req1				(GDMARCmd), 
				.Ack1				(GDMARCmdAck),
				.Valid1				(GDMARDataValid), 
				.BLen1				(GDMARBurstLen), 
				.Addr1				(GDMARAddr),
				            		
				.Req2				(VDMARCmd), 
				.Ack2				(VDMARCmdAck),
				.Valid2				(VDMARDataValid), 
				.BLen2				(VDMARBurstLen), 
				.Addr2				(VDMARAddr),
				            		
				.Req3				(1'b0), 
				.Valid3				( ), 
				.BLen3				(5'b0), 
				.Addr3				({AW+1{1'b0}}),
        		
				.ValidID			(DmaRdid), 
				.RLast				(DmaRlast),
				.Valid  			(DmaRvalid), 
				.RdData 			(DmaRdata),

				.RLast0				(CDMARLast),
				.RLast1				(GDMARLast),
				.RLast2				(VDMARLast),
				.RLast3				(),
				
				.RdData0			(CDMARData), 
				.RdData1			(GDMARData), 
				.RdData2			(VDMARData), 
				.RdData3			(), 
                                	
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
				.FrameStart			(FrameStart),
				
				.VPlaneStartAddr	(VPlaneStartAddr),
				.VPlaneStartAddr2	(VPlaneStartAddr2),
				.VPlaneXSize		(VPlaneXSizeRef),
`ifdef SCALER
				.VPlaneYSize		(ScaleInYSize),
`else
				.VPlaneYSize		(VPlaneYSize),
`endif
				.VPlaneXStart		(VPlaneXStart),
				.VPlaneYStart		(VPlaneYStart),
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
				
				.GPlaneStartAddr	(GPlaneStartAddr),
				.GPlaneXSize		(GPlaneXSizeRef),
				.GPlaneYSize		(GPlaneYSize),
				.GPlanePixFormat	(GPlanePixFormat),
				.GPlaneXStart		(GPlaneXStart),
				.GPlaneYStart		(GPlaneYStart),
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
				
				.PalMemWrite 		(PalMemWrite),
				.PalMemWrAddr		(PalMemWrAddr),
				.PalMemWrData		(PalMemWrData),
				.PalMemRead 		(PalMemRead),
				.PalMemRdData 		(PalMemRdData),
				
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
				
				.CPlaneAddrSwEn		(CPlaneAddrSwEn),
				.CPlaneAddrSwVal	(CPlaneAddrSwVal),
				.CPlaneStartAddr	(CPlaneStartAddr),
				.CPlaneXSize		(CPlaneXSizeRef),
				.CPlaneYSize		(CPlaneYSize),
				.CPlanePixFormat	(CPlanePixFormat),
				.CPlaneXStart		(CPlaneXStart),
				.CPlaneYStart		(CPlaneYStart),
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
				.PlaneMixerEn		(PlaneMixerEn),
				.GPlaneEn			(GPlaneEn),
				.VPlaneEn			(VPlaneEn),
				.CPlaneEn			(CPlaneEn),
				.PrioritySel		(PrioritySel),
				
				.LcdXSize			(LCDCPL+1'b1),
				.LcdYSize			(LCDLPS+1'b1),
				
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
				
				.LcdDataRequest		(LcdDataRequest),
				.MixerDataValid		(),
				.MixerDataOut		(MixerDataOut),
				
				.MixFIFOOverRun		(MixFIFOOverRun),
				.MixFIFOUnderRun	(MixFIFOUnderRun)
);
//-------------------------------------------------------------------------------
LcdTG LcdTG(
				.LCDCLK				(LCDCLK), 
				.nLCDRST			(ARESETn),
				.HFP				(LCDHFP),
				.HBP				(LCDHBP),
				.HSW				(LCDHSW),
				.CPL				(LCDCPL),
				.VSW				(LCDVSW),
				.VFP				(LCDVFP),
				.VBP				(LCDVBP),
				.LPS				(LCDLPS),
				.IVS				(LCDIVS),
				.IHS				(LCDIHS),
				.IEO				(LCDIEO),
				.BCD				(1'b1), // fix
				.LEEn				(LCDLEEn),
				.LEDel				(LCDLEDel),
				.LcdPwrEn			(LCDPwrEn),
				.LcdEn				(LCDEn),
				.LcdVComp			(LCDVComp),
				.BusMBESyncLcdClk	(1'b0),
				.FrRstAckSyncLcdClk	(1'b1),
				.VCompAckSyncLcdClk	(1'b1),
				.NextRising			(1'b0),
        		
				.FifoEn 			(LcdDataRequest),
        		.UnpackEn			(PlaneMixerEnLCD),
        		.FrameRst			(FrameRstLCD),
        		.FrameStart			(FrameStartLCD),
        		.VCompStat			(VCompStatLCD),

				.TFTPDEn			(TFTPDEn),
        		
        		.LCDLPint			(LCDHSync),	// HSYNC       
        		.LCDFPint			(LCDVSync),	// VSYNC      
        		.LCDDEint			(LCDDataEn)	// Data Enable
);

LcdSyncSysClk LcdSyncSysClk(
				.SysClk				(ACLK),
				.nRST				(ARESETn),
				.SWReset			(SWReset),
				.FrameStart			(FrameStartLCD),
				.FrameRst			(FrameRstLCD),
				.VCompStat			(VCompStatLCD),
				.PlaneMixerEn		(PlaneMixerEnLCD),

				.FrStSyncSysClk		(FrameStart),
				.FrRstSyncSysClk	(FrameRst),
				.VCStatSyncSysClk	(VCompStat),
				.PlaneMixerEnSyncSysClk(PlaneMixerEn)
);

LcdOutMux LcdOutMux(
				.LCDCLK				(LCDCLK),
				.LcdBPP				(LCDBPP),
				.LcdBGR				(LCDBGR),
				.TFTPDEn			(TFTPDEn),
				.CLPOWERint			(LCDPwrEn),
				.LcdEn				(LCDEn),
				.PixelRed			(MixerDataOut[23:16]),
				.PixelGreen			(MixerDataOut[15:8]),
				.PixelBlue			(MixerDataOut[7:0]),
				.LCDLDint			(LCDData)
);
//-------------------------------------------------------------------------------

endmodule