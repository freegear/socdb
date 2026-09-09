
// =================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from RichenTech           
//  ALL RIGHTS RESERVED RichenTech                                
// -----------------------------------------------------------------
// Version and Release information: 
//                                  
//      Ver3.00 : VifPara.v memory model 
// 
// File Name           : VifTop.v 
// File Revision       : 3.00 - CT2000 (TSMC) 
//  ----------------------------------------------------------------
//  Purpose            : Display module Top block
//                       
//  ----------------------------------------------------------------



`timescale 1ns/10ps

module VifTop(
			VCLK		,
			VDATA		,
			
`ifdef BYPASS			
			VideoBPReq,
			VideoBPAck,
			
			VIFDataRequest,
			VIFDataValid,
			VIFDataIn,
			FIFOClearBT,
`endif			
    		PCLK,
    		PENABLE		,
    		PSEL   		,
    		PWRITE 		,
    		PADDR  		,
    		PWDATA 		,
    		PRDATA 		,
    		
    		VifInt,
    		
			ARESETB		,
			ACLK		,
			AWID        ,
			AWADDR      ,
			AWLEN       ,
			AWSIZE      ,
			AWBURST     ,
			AWLOCK      ,
			AWCACHE     ,
			AWPROT      ,
			AWVALID     ,
			AWREADY     ,
			            
			WID         ,
			WDATA       ,
			WSTRB       ,
			WLAST       ,
			WVALID      ,
			WREADY      ,
			            
			BID         ,
			BRESP       ,
			BVALID      ,
			BREADY
);

`include "VifPara.v"

// System Register
input         PENABLE;
input         PSEL   ;
input         PWRITE ;
input  [ 9:2] PADDR  ;
input  [31:0] PWDATA ;
output [31:0] PRDATA ;

output		  VifInt;

// BT656 Video Interface
input		  VCLK;
input 	[7:0] VDATA;

`ifdef BYPASS
// Display Module Interface
input		VideoBPReq;
output		VideoBPAck;
input		VIFDataRequest;
output		VIFDataValid;
output	[DATA_WIDTH-1:0] VIFDataIn;
input		FIFOClearBT;
`endif

// AXI Signals
input	ARESETB;
input	ACLK, PCLK;

output [WID_WIDTH-1:0] AWID;
output [31:0] 	AWADDR;
output [3:0] 	AWLEN;
output [2:0] 	AWSIZE;
output [1:0] 	AWBURST;
output [1:0] 	AWLOCK;
output [3:0] 	AWCACHE;
output [2:0] 	AWPROT;
output 			AWVALID;
input 			AWREADY;

output [WID_WIDTH-1:0] WID;
output [DATA_WIDTH-1:0] WDATA;
output [NUM_BYTE-1:0]   WSTRB;
output           WLAST;
output 			WVALID;
input 			WREADY;

input [WID_WIDTH-1:0] BID;
input [1:0] 		 BRESP;
input 				 BVALID;
output 				 BREADY;
//-------------------------------------------------------
wire	DmaI2PEn;
wire	[ImageSize-1:0] HStart;
wire	[ImageSize-1:0] VStart;
wire	[ImageSize-1:0] HSize;
wire	[ImageSize-1:0] VSize;
`ifdef DOWNSCALER
wire	[ImageSize-1:0] DmaHSize;
wire	[ImageSize-1:0] DmaVSize;
`endif
wire	[ADDR_WIDTH-3:0] WrOffset;
wire	[1:0] YCOrder;
wire 	DmaEnSyncVClk;
wire 	[ImageSize-1:0] HStartSyncVClk;
wire 	[ImageSize-1:0] VStartSyncVClk;
wire 	[ImageSize-1:0] HSizeSyncVClk;
wire 	[ImageSize-1:0] VSizeSyncVClk;
wire 	[1:0]  YCOrderSyncVClk;
wire	FIFOClearReg, FIFOClearDma, FIFOClearExt;
wire	FIFOClear = FIFOClearReg | FIFOClearDma | FIFOClearExt; 

wire	DmaEnable;
wire	DmaStart;
wire	HBlank;
wire	VBlank;
wire	Field;

wire	DmaRdy;
wire	[ADDR_WIDTH-3:0] DmaAdr;
wire	[DATA_WIDTH-1:0] DmaDat;
wire	DmaReq;
wire	[3:0] DmaLen;
wire	[NUM_BYTE-1:0] DmaBeb;

`ifdef DOWNSCALER
wire         ScalePfEn, DnScaleEn;
wire         ScaleEn = DnScaleEn & DmaEnable & ~VBlank;
wire         ScaleHIn;
wire  [ 7:0] ScaleYIn;
wire  [ 7:0] ScaleCIn;
wire  [15:0] ScaleHR;
wire  [15:0] ScaleVR;

wire         ScaleHOut;
wire  [ 7:0] ScaleYOut;
wire  [ 7:0] ScaleCOut;

wire         ScalePfEnSyncVClk;
wire         ScaleEnSyncVClk;
wire  [15:0] ScaleHRSyncVClk;
wire  [15:0] ScaleVRSyncVClk;
`endif

wire	FIFOEmpty, FIFOFull, FIFOAlmostEmpty;
wire	FIFOHalfFull;
wire	FIFORead;
wire  [DATA_WIDTH-1:0]   FIFORdData;

wire	FIFOWrite;
wire	[DATA_WIDTH-1:0] FIFOWrData;

wire	FIFOReadVIF;

`ifdef BYPASS
reg		VideoBPAckACLK0;
reg		VideoBPAckACLK;
always @(negedge ARESETB or posedge ACLK)
	if (!ARESETB) 	VideoBPAckACLK0 <= 0;
	else			VideoBPAckACLK0 <= VideoBPAck;

always @(negedge ARESETB or posedge ACLK)
	if (!ARESETB) 	VideoBPAckACLK <= 0;
	else			VideoBPAckACLK <= VideoBPAckACLK0;

assign FIFOClearExt = FIFOClearBT & VideoBPAckACLK;

reg	[3:0]	ReadEnCnt;	// dummy due to FIFO
wire		FirstReadEn = (ReadEnCnt == 13);

always @(negedge ARESETB or posedge ACLK)
	if (!ARESETB) 	ReadEnCnt <= 0;
	else if (FIFOClear)
					ReadEnCnt <= 0;
	else if (FirstReadEn)
					ReadEnCnt <= ReadEnCnt;
	else if (FIFOWrite & ~FIFOFull & VIFDataRequest)			
					ReadEnCnt <= ReadEnCnt+1;

assign FIFORead     = VideoBPAckACLK ? VIFDataRequest & ~FIFOEmpty & ~(FIFOWrite & FIFOAlmostEmpty) & FirstReadEn
									 : FIFOReadVIF;
assign VIFDataValid = VideoBPAckACLK & FIFORead;
assign VIFDataIn    = FIFORdData;
`else
assign FIFOClearExt = 1'b0;
assign FIFORead     = FIFOReadVIF;
`endif

reg  FIFOOverRun1;
reg  FIFOOverRun2;
reg  FIFOOverRun;

wire FIFOOverRun0 = FIFOWrite & FIFOFull;

always @(negedge ARESETB or posedge VCLK)
	if (!ARESETB) 	FIFOOverRun1 <= 0;
	else 			FIFOOverRun1 <= FIFOOverRun0;

always @(negedge ARESETB or posedge PCLK)	// Meta. FF
	if (!ARESETB) 	FIFOOverRun2 <= 0;
	else 			FIFOOverRun2 <= FIFOOverRun0 | FIFOOverRun1;

always @(negedge ARESETB or posedge PCLK)	// Meta. FF
	if (!ARESETB) 	FIFOOverRun  <= 0;
	else 			FIFOOverRun  <= FIFOOverRun1;

//-------------------------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

always @(FIFOOverRun0)
	if(FIFOOverRun0) begin
		$display("%m ERROR: Video Interface FIFO Error (%t)",$time);
		$stop;
	end
// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on
// -----------------------------------------------------------------------------
//-------------------------------------------------------
// Register Interface
VifReg VifReg(
		.PCLK			(PCLK), 
		.PRESETB		(ARESETB),
		.PENABLE 		(PENABLE), 
		.PSEL    		(PSEL), 
		.PWRITE  		(PWRITE), 
		.PADDR   		(PADDR), 
		.PWDATA  		(PWDATA),
		.PRDATA  		(PRDATA),

`ifdef DOWNSCALER
		.DmaHSize		(DmaHSize),
		.DmaVSize		(DmaVSize),
		.PreFilterEn	(ScalePfEn),
		.DnScaleEn		(DnScaleEn),
		.ScaleXRatio	(ScaleHR),
		.ScaleYRatio	(ScaleVR),
`endif

		.FrameEnd		(FIFOClearDma | FIFOClearExt),
		.FrameStart		(DmaStart),
		.VifInt			(VifInt),
		.FIFOOverRun	(FIFOOverRun),
		.FIFOUnderRun	(FIFOUnderRun),
		.FieldPCLK1		(FieldPCLK1),

		.HBlank			(HBlank),
		.VBlank			(VBlank),
		.Field      	(Field),
	
		.DmaEn			(DmaEn),
		.DmaAdr			(DmaAdr),

		.HStart			(HStart),
		.VStart			(VStart),
		.HSize			(HSize),
		.VSize			(VSize),
		.WrOffset		(WrOffset),
		.YCOrder		(YCOrder),
		.DmaI2PEn		(DmaI2PEn),
		.FIFOClear		(FIFOClearReg)
);
//-------------------------------------------------------
// MetaStable FilpFlop System to Video Clock
VifMeta VifMeta(
		.VCLK			(VCLK), 
		.ARESETB		(ARESETB),
		.DmaEn			(DmaEn), 
		.HStart			(HStart), 
		.VStart			(VStart), 
		.HSize			(HSize), 
		.VSize			(VSize), 
		.YCOrder		(YCOrder),

`ifdef DOWNSCALER
		.ScalePfEn		(ScalePfEn), 
		.ScaleEn		(ScaleEn), 
		.ScaleHR		(ScaleHR), 
		.ScaleVR		(ScaleVR),

		.ScalePfEnSyncVClk(ScalePfEnSyncVClk), 
		.ScaleEnSyncVClk(ScaleEnSyncVClk), 
		.ScaleHRSyncVClk(ScaleHRSyncVClk), 
		.ScaleVRSyncVClk(ScaleVRSyncVClk),
`endif
		.DmaEnSyncVClk	(DmaEnSyncVClk), 	
		.HStartSyncVClk	(HStartSyncVClk), 
		.VStartSyncVClk	(VStartSyncVClk), 
		.HSizeSyncVClk	(HSizeSyncVClk), 
		.VSizeSyncVClk	(VSizeSyncVClk), 
		.YCOrderSyncVClk(YCOrderSyncVClk)
);
//-------------------------------------------------------
// BT656 Video Interface
BT656If BT656If(
		.nRST			(ARESETB),
		.Clk			(ACLK),
		.VClk			(VCLK),
		.VData			(VDATA),
		.DmaEn			(DmaEn),
		.DmaEnVCLK		(DmaEnSyncVClk),
		.HSize			(HSizeSyncVClk),
		.VSize			(VSizeSyncVClk),
		.HStart			(HStartSyncVClk), 
		.VStart			(VStartSyncVClk), 
		.YCOrder		(YCOrderSyncVClk),
		.DmaEnable		(DmaEnable),
		.DmaStart		(DmaStart),
		.HEnd			(HEnd),

`ifdef BYPASS
		.VideoBPReq		(VideoBPReq),
		.VideoBPAck		(VideoBPAck),
`endif
		
		.FIFOClear		(FIFOClearVCLK),
		.VsyncEnd		(FIFOClearDma),

`ifdef DOWNSCALER
		.HOut			(ScaleHIn),
		.YOut			(ScaleYIn),
		.COut			(ScaleCIn),
`endif
		.FIFOWrEn		(FIFOWrite),
		.FIFOWrData		(FIFOWrData),

		.HBlank			(HBlank),
		.VBlank			(VBlank),
		.Field      	(Field)
);
//-------------------------------------------------------
// Down Scaler
`ifdef DOWNSCALER
DnScTop DnScTop(
		.clk       		(VCLK),
		.rstb      		(ARESETB),
		.pf_en     		(ScalePfEnSyncVClk),
		.shratio   		(ScaleHRSyncVClk),
		.svratio   		(ScaleVRSyncVClk),
		.sen       		(ScaleEnSyncVClk),
		.shav      		(ScaleHIn),
		.syin      		(ScaleYIn),
		.scin      		(ScaleCIn),
		.seno      		(ScaleHOut),
		.shavo     		(ScaleHRef),
		.syout     		(ScaleYOut),
		.scout     		(ScaleCOut)
);
`endif
//-------------------------------------------------------
// Dual Port FIFO
`ifdef BYPASS
VideoFIFO #(8, DATA_WIDTH, 8) VideoFIFO(	// 256x32
`else
VideoFIFO #(6, DATA_WIDTH, 8) VideoFIFO(	// 64x32
`endif
		.RdClk			(ACLK),  
		.WrClk			(VCLK),  
		.nRST			(ARESETB),   
		.Flush			(FIFOClear),
		.FlushWrClk		(FIFOClearVCLK),  
		.WriteEn		(FIFOWrite), 
		.WrData			(FIFOWrData), 
		.ReadEn			(FIFORead), 
		.RdData			(FIFORdData), 
		.Full			(FIFOFull),   
		.Empty			(FIFOEmpty),  
		.EmptyN			(FIFOHalfFull)/*, 
		.Level			()*/
);
//-------------------------------------------------------
// Video Write DMA
VifWDma VifWDma(
		.nRST			(ARESETB),
		.Clk			(ACLK),
`ifdef DOWNSCALER
		.HSize			(DmaHSize),
		.VSize			(DmaVSize),
`else
		.HSize			(HSize),
		.VSize			(VSize),
`endif
		.WrOffset		(WrOffset),
		.DmaI2PEn		(DmaI2PEn),
		.FieldPCLK1		(FieldPCLK1),
		.SWReset		(FIFOClear),
		.FIFOEmpty		(FIFOEmpty),
		.FIFOHalfFull	(FIFOHalfFull),
		.FIFORead		(FIFOReadVIF),
		.FIFORdData		(FIFORdData),
		.FIFOUnderRun	(FIFOUnderRun),

`ifdef BYPASS
		.DmaEnable		(DmaEnable & ~VideoBPAckACLK),	// should not work at external bypass mode
`else
		.DmaEnable		(DmaEnable),
`endif
		.HEnd			(HEnd),
		.DmaStart		(DmaStart),
		.DmaAdr			(DmaAdr),
		.DmaDat			(DmaDat),
		.DmaReq			(DmaReq),
		.DmaLen			(DmaLen),
		.DmaBeb			(DmaBeb),
		.DmaRdy     	(DmaRdy),
		.DmaBusy		(DmaBusy)
);
//-------------------------------------------------------
// AXI BUS Master Write Interface
VifAWIf VifAWIf(
   		.clk    		(ACLK),
   		.rstb   		(ARESETB),
   		.AWID   		(AWID),
   		.AWADDR 		(AWADDR),
   		.AWLEN  		(AWLEN),
   		.AWSIZE 		(AWSIZE),
   		.AWBURST		(AWBURST),
   		.AWLOCK 		(AWLOCK),
   		.AWCACHE		(AWCACHE),
   		.AWPROT 		(AWPROT),
   		.AWVALID		(AWVALID),
   		.AWREADY		(AWREADY),
   		.WID    		(WID),
   		.WDATA  		(WDATA),
   		.WSTRB  		(WSTRB),
   		.WLAST  		(WLAST),
   		.WVALID 		(WVALID),
   		.WREADY 		(WREADY),
   		.BID    		(BID),
   		.BRESP  		(BRESP),
   		.BVALID 		(BVALID),
   		.BREADY 		(BREADY),
   		.gwr    		(DmaReq),
   		.gwaddr 		({DmaAdr[ADDR_WIDTH-3:0], 2'b0}),
   		.gwsize 		(DmaLen),
   	//	.gwbe   		({NUM_BYTE{1'b1}}),
   		.gwdata 		(DmaDat),
   		.gwready		(DmaRdy),
   		.gwbusy 		(DmaBusy)  
);
//-------------------------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
integer FIFOWrCount;
always @(negedge ARESETB or posedge ACLK)
	if  	(!ARESETB) 	FIFOWrCount <= 0;
	else if (FIFOWrite & ~FIFOFull)	
						FIFOWrCount <= FIFOWrCount + 1;

/*
integer FIFORdCount;
always @(negedge ARESETB or posedge ACLK)
	if  	(!ARESETB) 	FIFORdCount <= 0;
	else if (VIFDataValid)	
						FIFORdCount <= FIFORdCount + 1;
*/
// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on
// -----------------------------------------------------------------------------

endmodule
