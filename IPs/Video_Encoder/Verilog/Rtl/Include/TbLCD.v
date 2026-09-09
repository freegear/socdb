
/*-----------------------------------------------------------------------
 Test History
 1. Cursor Plane
 	- Pixel Format
 	RGB332			: OK
 	ARGB1555		: OK
 
 2. Graphic Plane
 	- Pixel Format
 	8bit 			: Not Yet -> Use Palette Memory
 	RGB565 			: OK
 	ARGB1555 		: Same as Cursor Plane
 	RGB888 			: OK
 	ARGB8888
 	- Gamma			: OK

 3. Vidoe Plane
 	CbYCrY 			: OK
 	- Scaler
 		Up 			: OK(max 640x480 to 1920x1440)
 		Down 		: OK(min 640x480 to 160x120 at LcdClk is divide by 8 SysClk)
 					     max 1152x864 to 576x432 at LcdClk is divide by 6 SysClk
 	- Gamma			: OK

 4. LCD Output Format
 	RGB565			: OK
 	RGB666			:
 	RGB888			: OK

 6. Plane Mixer
 	- Priority 		: OK
 	- Alpha Blending: OK
 	- LCD Positioning : OK
 	- Chroma Key	: Not Test Yet.
 
 5. SDRAM 			: OK
 
 6. 64Bit AXI		: Not Yet.
 	- Need 64Bit Bus(입력 데이타 레잇이 절반으로 줄어드므로 FIFO를 수정해야하고, 의미없는 짓이다.
 					 아니면, 뒷단의 Plane 쪽의 데이타 처리를 2개씩하는 걸루 수정해야 한다.)
 	- Should Modify DMA FIFO 32 to 64
-----------------------------------------------------------------------*/

`timescale 1ns/10ps

`define CHIP			// Internal Memory Select

//`define GETCurSor		// Get 32bit Image
//`define GET64			// Get 64bit Image

//`define DEBUG
//`define GRAPHIC
`define STROBE

//`define SDRAM		// DDR SDRAM

//`define UP
`define BP

//`define AXI64			// 64Bit AXI
//`define BWTEST		// Bandwidth Test

//`define VIDEO
`define NTSC
//`define PAL

//`define BT656

module TbLCD;

`ifdef VIDEO
`ifdef NTSC
parameter LCDX = 720;
parameter LCDY = 240;
`else
parameter LCDX = 720;
parameter LCDY = 288;
`endif
`else
parameter LCDX = 640;//800;
parameter LCDY = 480;//600;
`endif

// Active Line
//NTSC(22~261/285~524) PAL(23~310/336~623)

// NTSC
parameter [10:0] ImageXStart = 0;
parameter [10:0] ImageYStart = 21-10;

`ifdef VIDEO
parameter [10:0] ImageXSize = LCDX;
parameter [10:0] ImageYSize = LCDY; // Interlace, If Progressive then 480
`else
parameter [10:0] ImageXSize = 640;
parameter [10:0] ImageYSize = 480;
`endif

parameter [10:0] DmaXSize = 320;
parameter [10:0] DmaYSize = 120;

wire  ScaleEn   = 1'b1;
wire  ScalePfEn = 1'b0;
wire  [15:0] ScaleHR = ((DmaXSize+1)*65536)/(ImageXSize+1);
wire  [15:0] ScaleVR = ((DmaYSize+1)*65536)/(ImageYSize+1);

parameter CursorX  = 64;
parameter CursorY  = 54;
parameter GraphicX = 348;//160;
parameter GraphicY = 285;//120;
`ifdef UP
parameter VideoX   = 320;
parameter VideoY   = 240;
`else
parameter VideoX   = 640;
parameter VideoY   = 480;
`endif

//parameter CKP1 = 3.76/2;
parameter CKP1 = 2.5;	// 200MHz

`ifdef UP
parameter CKPL = CKP1*4;
`else
`ifdef BP
`ifdef BWTEST
parameter CKPL = CKP1*12; // Maximum BandWidth
`else
parameter CKPL = CKP1*4;
`endif
`else
parameter CKPL = CKP1*8;
`endif
`endif

parameter CKPV = 37.03/2;	// 27MHz
parameter CKPP = CKP1*4;

parameter SDLY = CKP1/2;	// Pad Delay
parameter DLY  = 0.2;

parameter II = 4-1;		// ID Width
parameter DD = 32-1;	// Data Width
parameter BB = 4-1;		// Byte Width

reg			MCLK;
reg 		Clk, LcdClk, nRST;
reg 		PCLK;

wire 		ACLK = Clk;
wire 		ARESETn = nRST;
wire 		ARESETB = nRST;

reg			VCLK;

`ifdef BT656
wire [II:0] AWID;
wire [31:0] AWADDR;
wire [3:0]  AWLEN;
wire [2:0]  AWSIZE;
wire [1:0]  AWBURST;
wire        AWVALID;
wire        AWREADY;

wire [II:0] WID;
wire [DD:0] WDATA;
wire [BB:0] WSTRB;
wire        WLAST;
wire        WVALID;
wire        WREADY;

wire [II:0] BID;
wire [1:0]  BRESP;
wire        BVALID;
wire        BREADY;
`else
reg  [II:0] AWID;
reg  [31:0] AWADDR;
reg  [3:0]  AWLEN;
reg  [2:0]  AWSIZE;
reg  [1:0]  AWBURST;
reg         AWVALID;
wire        AWREADY;

reg  [II:0] WID;
reg  [DD:0] WDATA;
reg  [BB:0] WSTRB;
wire        WLAST;
reg         WVALID;
wire        WREADY;

wire [II:0] BID;
wire [1:0]  BRESP;
wire        BVALID;
reg         BREADY;
`endif

wire [II:0] ARID;
wire [31:0] ARADDR;
wire [3:0]  ARLEN;
wire [2:0]  ARSIZE;
wire [1:0]  ARBURST;
wire        ARVALID;
wire        ARREADY;

wire [II:0] RID;
wire [DD:0] RDATA;
wire [1:0]  RRESP;
wire        RLAST;
wire        RVALID;
wire        RREADY;

wire [II:0] ARID64;
wire [31:0] ARADDR64;
wire [3:0]  ARLEN64;
wire [2:0]  ARSIZE64;
wire [1:0]  ARBURST64;
wire        ARVALID64;
wire        ARREADY64;

wire [II:0] RID64;
wire [63:0] RDATA64;
wire [1:0]  RRESP64;
wire        RLAST64;
wire        RVALID64;
wire        RREADY64;

reg         PENABLE;
reg  [ 2:0] PSEL;
reg         PWRITE;
reg  [ 9:2] PADDR;
reg  [31:0] PWDATA;
wire [31:0] PRDATA0;
wire [31:0] PRDATA1;
wire [31:0] PRDATA2;
wire [31:0] PRDATA = PSEL[0] ? PRDATA0 : PSEL[1] ? PRDATA1 : PSEL[2] ? PRDATA2 : 0;

wire		DmErrInt;

wire 		LCDHSync;
wire 		LCDVSync;
wire 		LCDDataEn;
wire [23:0] LCDData;
//------------------------------------------------------------------------------
parameter MDW  = 16 -1; 		// Data Width
parameter DMW  = 2 -1;  		// Dqm Width
parameter BAW  = 2 -1;	 		// Bank Address Width
parameter RAW  = 13 -1; 		// Row Address Width
parameter CAW  = 11 -1;	 		// Colomn Address Width

wire         SDclk;
wire [RAW:0] #SDLY SDadr;
wire [BAW:0] #SDLY SDba;
wire         #SDLY SDcsb;
wire         #SDLY SDrasb;
wire         #SDLY SDcasb;
wire         #SDLY SDweb;
wire [DMW:0] #SDLY SDdqm;
wire		 #SDLY SDcke;

wire         #SDLY SDdate;
wire [MDW:0] SDdati;
wire [MDW:0] SDdato;
tri  [MDW:0] SDdat;

assign #SDLY SDdat  = SDdate ? SDdato : {MDW+1{1'bz}};
assign #CKP1 SDdati = SDdat;

wire 		 #SDLY SDdqse;
tri  [DMW:0] SDdqs;
wire [DMW:0] SDdqso;
wire [DMW:0] SDdqsi;

assign #SDLY SDdqs  = SDdqse ? SDdqso : {DMW+1{1'bz}};
assign #(CKP1+1) SDdqsi = SDdqs;	// Input Pad Delay

assign SDclk  = ACLK;
//------------------------------------------------------------------------------
`ifdef BYPASS
wire		VIFDataRequest;
wire	    VIFDataValid;
wire [31:0] VIFDataIn;
`endif
//------------------------------------------------------------------------------
integer i, j, k;

`ifndef BT656
`include "./Include/AxiRWTask.v"
`endif
`include "./Include/PeriRWTask.v"
`include "./Include/LcdSim.v"
`include "./Include/LcdRegSet.v"

wire FrameRst = DmTop.FrameRst;

parameter CImageSize = CursorX*CursorY/4;
parameter GImageSize = GraphicX*GraphicY;
`ifdef NTSC
parameter VImageSize = VideoX*VideoY/2;
`else
parameter VImageSize = VideoX*(VideoY-48)/2;
`endif
reg  [31:0] CTestData [0:CImageSize-1];
reg  [31:0] GTestData [0:GImageSize-1];
reg  [31:0] VTestData [0:VImageSize-1];

parameter WBS = 8;	// Image Write Burst Size

integer 	CImageAddr;
integer 	GImageAddr;
integer 	VImageAddr;
reg 		IncCImageAddr;
reg 		IncGImageAddr;
reg 		IncVImageAddr;
//------------------------------------------------------------------------------
`ifdef GETCurSor
`include "./Include/GetCursor.v"
`endif

`ifdef GET64
`include "./Include/Get64Set.v"
`endif
//------------------------------------------------------------------------------
initial begin
//   $readmemh ("./Image/Cursor32.txt", CTestData);
   $readmemh ("./Image/Cursor32_8.txt", CTestData);
end

initial begin
//   $readmemh ("./Image/Graphic32.txt", GTestData);
   $readmemh ("./Image/rgb888.txt", GTestData);
//   $readmemh ("./Image/rgb888_ck.txt", GTestData);
end

initial begin
`ifdef UP
   $readmemh ("./Image/VDataQVGA.txt", VTestData);
`else
   $readmemh ("./Image/VDataVGA.txt", VTestData);
//   $readmemh ("./Image/VDataMega.txt", VTestData);
`endif
end

wire VideoBPAck;

`ifndef BT656
`include "./Include/ImageWrTask.v"
wire LCDCLK = LcdClk;
`else
`ifdef BYPASS
wire LCDCLK = VideoBPAck ? VCLK : LcdClk;
`else
wire LCDCLK = LcdClk;
`endif
`endif

wire	LCDCLKo;
//-------------------------------------------------------------------------------
// Display Module Top
//initial force DmTop.TGSEL = 1;

DmTop DmTop(
   				.ACLK            	(Clk),
   				.ARESETn           	(nRST),
				.LCDCLK				(LCDCLK),
				.LCDCLKo			(LCDCLKo),

`ifdef AXI64
   				.ARID           	(ARID[1:0]),
   				.ARADDR         	(ARADDR64),
   				.ARLEN          	(ARLEN64),
   				.ARSIZE         	(ARSIZE64),
   				.ARBURST        	(ARBURST64),
   				.ARLOCK         	(ARLOCK64),
   				.ARCACHE        	(ARCACHE64),
   				.ARPROT         	(ARPROT64),
   				.ARVALID        	(ARVALID64),
   				.ARREADY        	(ARREADY64),

   				.RID            	(RID[1:0]),
   				.RDATA          	(RDATA64),
   				.RRESP          	(RRESP64),
   				.RLAST          	(RLAST64),
   				.RVALID         	(RVALID64),
   				.RREADY         	(RREADY64),
`else
   				.ARID           	(ARID[1:0]),
   				.ARADDR         	(ARADDR),
   				.ARLEN          	(ARLEN),
   				.ARSIZE         	(ARSIZE),
   				.ARBURST        	(ARBURST),
   				.ARLOCK         	(ARLOCK),
   				.ARCACHE        	(ARCACHE),
   				.ARPROT         	(ARPROT),
   				.ARVALID        	(ARVALID),
   				.ARREADY        	(ARREADY),

   				.RID            	(RID[1:0]),
   				.RDATA          	(RDATA),
   				.RRESP          	(RRESP),
   				.RLAST          	(RLAST),
   				.RVALID         	(RVALID),
   				.RREADY         	(RREADY),
`endif

				.PCLK				(ACLK),
				.PRESETB			(nRST),
    			.PSEL				(PSEL[1]), 
    			.PENABLE			(PENABLE), 
    			.PADDR				(PADDR), 
    			.PWRITE				(PWRITE), 
    			.PWDATA				(PWDATA), 
				.PRDATA				(PRDATA1),
				
				.LCDHSync			(LCDHSync),
				.LCDVSync			(LCDVSync),
				.LCDDataEn			(LCDDataEn),
				.LCDData  			(LCDData),
`ifdef BYPASS				
				.VideoBPReq			(VideoBPReq),
				.VideoBPAck			(VideoBPAck),
				.VIFDataRequest		(VIFDataRequest),
				.VIFDataValid		(VIFDataValid),
				.VIFDataIn			(VIFDataIn),
				.FIFOClearBT		(FIFOClearBT),
`endif				
				.DmErrInt			(DmErrInt)
);
//-------------------------------------------------------------------------------
`ifdef AXI64
DmR64to32 DmR64to32(
				.ACLK				(ACLK),
				.ARESETn			(ARESETn),
				            		
				.ARADDR64			(ARADDR64),
				.ARLEN64			(ARLEN64),
				.ARSIZE64			(ARSIZE64),
				.ARBURST64			(ARBURST64),
				.ARVALID64			(ARVALID64),
				.ARREADY64			(ARREADY64),
				            		
				.RDATA64			(RDATA64),
				.RRESP64			(RRESP64),
				.RLAST64			(RLAST64),
				.RVALID64			(RVALID64),
				.RREADY64			(RREADY64),
				            		
				.ARADDR32			(ARADDR),
				.ARLEN32			(ARLEN),
				.ARSIZE32			(ARSIZE),
				.ARBURST32			(ARBURST),
				.ARVALID32			(ARVALID),
				.ARREADY32			(ARREADY),
				            		
				.RDATA32			(RDATA),
				.RRESP32			(RRESP),
				.RLAST32			(RLAST),
				.RVALID32			(RVALID),
				.RREADY32			(RREADY)
);
`endif
//-------------------------------------------------------------------------------
`ifdef SDRAM
wire #0.1 nMCLK = ~MCLK;
wire #0.1 nACLK = ~ACLK;
wire [1:0] #0.1 nSDdqsi = ~SDdqsi;

DDRTop DDRTop(
				.ACLK				(ACLK), 
				.nACLK				(nACLK),
				.ARESETB			(ARESETB),
				.nPOR				(ARESETB),
				.MCLK				(MCLK),
				.nMCLK				(nMCLK),
        		            		
				.AWAddr				(AWADDR),
				.AWLen				(AWLEN),
				.AWValid			(AWVALID),
				.AWReady			(AWREADY),
				.AWId				(AWID),
				.AWBurst			(AWBURST),
	    		            		
				.WLast				(WLAST),
				.WStrb  			(WSTRB),
				.WData   			(WDATA),
				.WValid				(WVALID),
				.WReady				(WREADY),
				.WId				(WID),
        		            		
				.BResp 				(BRESP),
    			.BValid				(BVALID),
    			.BReady				(BREADY),
    			.BId				(BID),
    			            		
				.ARAddr				(ARADDR),
				.ARLen				(ARLEN),
				.ARValid			(ARVALID),
				.ARReady			(ARREADY),
				.ARId				({2'b0, ARID[1:0]}),
				.ARBurst			(ARBURST),
        		            		
				.RReady				(RREADY),
				.RValid				(RVALID),
				.RLast				(RLAST),
				.RData   			(RDATA),
				.RId				(RID),
				.RResp				(RRESP),
				            		
				.PCLK				(ACLK), 
				.PRESETB			(ARESETB),
				.PENABLE 			(PENABLE), 
				.PSEL    			(PSEL[0]), 
				.PWRITE  			(PWRITE), 
				.PADDR   			(PADDR[7:2]), 
				.PWDATA  			(PWDATA),
				.PRDATA  			(PRDATA0),
		
				.SD_CSB				(SDcsb), 
				.SD_RASB			(SDrasb), 
				.SD_CASB			(SDcasb), 
				.SD_WEB				(SDweb), 
				.SD_CKE				(SDcke), 
				.SD_BADDR			(SDba), 
				.SD_ADDR			(SDadr),
				.SD_DQE				(SDdate),
				.SD_DQI				(SDdati), 
				.SD_DQO				(SDdato),
				.SD_DQM				(SDdqm),
				.SD_DQSE			(SDdqse),
				.SD_DQSO			(SDdqso),
				.SD_DQSI			(SDdqsi),
				.nSD_DQSI			(nSDdqsi)
);

`ifdef DEBUG
defparam sdram16bit.Debug = 1;
`else
defparam sdram16bit.Debug = 0;
`endif

ddr sdram16bit (
                   .Dq		(SDdat),
                   .Addr	(SDadr),
                   .Ba		(SDba),
                   .Clk		(SDclk),
                   .Clk_n	(~SDclk),
                   .Cke		(SDcke),
                   .Cs_n	(SDcsb),
                   .Ras_n	(SDrasb),
                   .Cas_n	(SDcasb),
                   .We_n	(SDweb),
                   .Dqs		(SDdqs), 
                   .Dm		(SDdqm)
);
//-------------------------------------------------------------------------------
`else
wire [31:0] MEMADDR;
wire [DD:0] MEMRDATA;
wire [DD:0] MEMWDATA;
wire        MEMCEn;
wire [BB:0] MEMWEn;

IntSRAMController IntSRAMController
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWID),
		.AWADDR(AWADDR),
		.AWLEN(AWLEN),
		.AWSIZE(AWSIZE),
		.AWBURST(AWBURST),
		.AWVALID(AWVALID),
		.AWREADY(AWREADY),

		.WID(WID),
		.WDATA(WDATA),
		.WSTRB(WSTRB),
		.WLAST(WLAST),
		.WVALID(WVALID),
		.WREADY(WREADY),

		.BID(BID),
		.BRESP(BRESP),
		.BVALID(BVALID),
		.BREADY(BREADY),

		.ARID({2'b0, ARID[1:0]}),
		.ARADDR(ARADDR),
		.ARLEN(ARLEN),
		.ARSIZE(ARSIZE),
		.ARBURST(ARBURST),
		.ARVALID(ARVALID),
		.ARREADY(ARREADY),

		// Read Data Channel
		.RID(RID),
		.RDATA(RDATA),
		.RRESP(RRESP),
		.RLAST(RLAST),
		.RVALID(RVALID),
		.RREADY(RREADY),

		.MEMADDR(MEMADDR[29:0]),
		.MEMCEn(MEMCEn),
		.MEMWEn(MEMWEn),
		.MEMRDATA(MEMRDATA),
		.MEMWDATA(MEMWDATA)
);

SSRAM32bit #(24) SRAM
(
		.CLK(ACLK),
		.ADDR(MEMADDR[23:0]),
		.CEn(MEMCEn),
		.WEn(MEMWEn),
		.RDATA(MEMRDATA),
		.WDATA(MEMWDATA)
);
`endif
//-------------------------------------------------------
`include "VifPara.v"
`ifdef BT656

wire F, V, H, T;
wire 	[9:0] VDATA;

multigen multigen (
    	.clk        (VCLK),
    	.ce         (1'b1),
    	.rst        (~ARESETB),
    	.std        (3'b0),	// NTSC422
    	.s          (1'b1),
    	.early_v    (1'b1),
    	.q          (VDATA),
    	.field      (F),
    	.v_blank    (V),
    	.h_blank    (H),
    	.trs        (T)
);

reg  [ 7:0] YUV [0:ImageXSize*ImageYSize*2 -1];

integer ImgAddr;

always @(negedge ARESETB or posedge VCLK)
   if (!ARESETB)   			ImgAddr <= 0;
   else if (V) 				ImgAddr <= 0;	// Frame Reset Should be applied
   else if (~V & ~H & ~T & VIF.BT656If.RequestY) 	
   							ImgAddr <= ImgAddr + 1;

initial $readmemh ("./Image/ntsc.yuv", YUV);
//initial $readmemh ("./Image/vga.yuv", YUV);
//initial $readmemh ("./Image/qvga.yuv", YUV);
//initial $readmemh ("./Image/mega.yuv", YUV);

wire [7:0] #3 VDATAm = T ? VDATA[9:2] : YUV[ImgAddr];

VifTop VIF(
				.VCLK			(VCLK), 
				.VDATA			(VDATAm),
`ifdef BYPASS        		
				.VideoBPReq		(VideoBPReq),
				.VideoBPAck		(VideoBPAck),
				.VIFDataRequest	(VIFDataRequest),
				.VIFDataValid	(VIFDataValid),
				.VIFDataIn		(VIFDataIn),
				.FIFOClearBT	(FIFOClearBT),
`endif								
				.PENABLE 		(PENABLE), 
				.PSEL    		(PSEL[2]), 
				.PWRITE  		(PWRITE), 
				.PADDR   		(PADDR), 
				.PWDATA  		(PWDATA),
				.PRDATA  		(PRDATA),
        		            	
				.ACLK			(ACLK), 
				.ARESETB		(ARESETB),
				.AWID			(AWID),
				.AWADDR			(AWADDR),
				.AWLEN			(AWLEN),
				.AWSIZE			(AWSIZE),
				.AWBURST		(AWBURST),
				.AWVALID		(AWVALID),
				.AWREADY		(AWREADY),
        		            	
				.WID			(WID),
				.WDATA			(WDATA),
				.WSTRB			(WSTRB),
				.WLAST			(WLAST),
				.WVALID			(WVALID),
				.WREADY			(WREADY),
        		            	
				.BID			(BID),
				.BRESP			(BRESP),
				.BVALID			(BVALID),
				.BREADY			(BREADY)
);
`endif
//-------------------------------------------------------------------------------
task SdramInit;
begin
  repeat(200) @(posedge ACLK); // 200usec wait
  APBWrite(3'b01, 32'h00000000, 32'h0000_b91a);	// CL2
//  APBWrite(2'b01, 332'h00000000, 32'h0000_b92a); // CL2.5

//  APBWrite(2'b01, 332'h00000004, 32'h0000_0003); // SDRAM Enable & Swap Disable
  APBWrite(3'b01, 32'h00000004, 32'h0000_0011); // SDRAM Enable & Swap Enable

//  APBWrite(2'b01, 332'h00000008, 32'h0001_00FF); // power down enable

//  APBWrite(3'b01, 32'h0000000C, 32'h0007_2080); // 64us, 8 Refresh, Maximum Allowable JEDEC Standard
  APBWrite(2'b01, 32'h0000000C, 32'h0000_0410); // 7.8us, 1 Refresh at 133MHz
end
endtask
//-------------------------------------------------------------------------------
task VifInit;
begin
  APBWrite(3'b100, VIFCTL, 32'h0000_003d);	// DMA Enable
  APBWrite(3'b100, VIFSPOS, {10'b0, ImageXStart, ImageYStart});	// Input Size
  APBWrite(3'b100, VIFSSIZ, {10'b0, ImageXSize, ImageYSize});	// Dma Size
  APBWrite(3'b100, VIFADDR, VPlaneStartAddr);
  APBWrite(3'b100, VIFDSIZ, {10'b0, DmaXSize, DmaYSize});	// Dma Size
  APBWrite(3'b100, VIFSCON, {1'b0, ScalePfEn, 29'b0, ScaleEn});
  APBWrite(3'b100, VIFSRAT, {ScaleHR, ScaleVR});
end
endtask
//-------------------------------------------------------------------------------
always #CKP1 MCLK = ~MCLK;

always @(negedge ARESETB or posedge MCLK) 
  if (!ARESETB) Clk <= 1'b0;
  else          Clk <= #DLY Clk + 1;
  
`ifdef VIDEO
always #CKPV LcdClk = ~LcdClk;
`else
always #CKPL LcdClk = ~LcdClk;
`endif
always #CKPP PCLK   = ~PCLK;

always #CKPV VCLK = ~VCLK;
//-------------------------------------------------------------------------------
// Initialize
initial begin
  nRST   = 1;
  MCLK   = 0;
  LcdClk = 0;
  VCLK   = 1;
  PCLK   = 0;
end
//-------------------------------------------------------------------------------
// Main Routine
initial begin
  	repeat(10) @(posedge MCLK);
    nRST = 1'b0;
  	repeat(10) @(posedge MCLK);
  	#(3) nRST = 1'b1;
  	$display ("Reset Disabled, Simulation Start NOW >>>");
  
  	`ifdef SDRAM
   	SdramInit;
   	`endif
  	repeat(200) @(posedge Clk);

`ifdef BT656
	VifInit;

`ifdef BYPASS
	wait (VideoBPAck);
	repeat(30000) @(posedge Clk);
	APBWrite(2'b10, VIDCON, {VideoSyncEn, 31'b0});// Kill Bypass Mode
`else
  	repeat(300000) @(posedge Clk);
	repeat (1) @(posedge V);
//	APBWrite(3'b100, 32'h00000000, 32'h0000_0000);	// DMA Disable
`endif
`else
	if (CPlaneEn) CurSorW;
	if (GPlaneEn) GraphicW;
	if (VPlaneEn) VideoW;
`endif
	
	LcdRegSet;

`ifdef BWTEST
	repeat(300) begin
	CurSorW;
  	repeat(3000) @(posedge Clk);
	GraphicW;
  	repeat(3000) @(posedge Clk);
	VideoW;
  	repeat(3000) @(posedge Clk);
	end
`endif
  	repeat(300) @(posedge Clk);
	
/*  
  	repeat(1) @(posedge DmTop.FrameStart);
  	force DmTop.LCDLEEn = 1;
  	force DmTop.LCDLEDel = 1;
*/
  	repeat(300) @(posedge Clk);
  	$stop;
end
//-------------------------------------------------------------------------------
`ifdef TIMING
initial $sdf_annotate("../Syn/Sdf/DmTop.noscan.sdf", DmTop);
initial $sdf_annotate("../../MyVIF/Syn/Sdf/VifTop.noscan.sdf", VifTop);
`endif
//-------------------------------------------------------------------------------
`ifdef DEBUG
`include "./Include/DbgOut.v"
`endif
//------------------------------------------------------
`ifdef STROBE

integer LcdRead; // RGB565
`ifdef VIDEO
initial begin
  LcdRead = $fopen("./Result/LcdOut.txt");
  forever @(posedge LCDCLKo) begin
  	if (LCDBPP==0 & ~LCDVSync & ~LCDHSync & DmTop.VideoTG.DataEn & DmTop.VideoTG.MixerEn) 
    	$fdisplay(LcdRead, "%h",{LCDData[23:19], LCDData[15:10],LCDData[ 7: 3]});	// RGB565
    else if (LCDBPP==1 & ~LCDVSync & ~LCDHSync & DmTop.VideoTG.DataEn & DmTop.VideoTG.MixerEn) 
    	$fdisplay(LcdRead, "%h",{LCDData[23:18], LCDData[15:10],LCDData[ 7: 2]});	// RGB666
    else if (LCDBPP==2 & ~LCDVSync & ~LCDHSync & DmTop.VideoTG.DataEn & DmTop.VideoTG.MixerEn) 
    	$fdisplay(LcdRead, "%h",LCDData);	// RGB888
  end
end
`else
initial begin
  LcdRead = $fopen("./Result/LcdOut.txt");
  forever @(posedge LCDCLKo) begin
  	if (LCDBPP==0 & LCDVSync & LCDHSync & LCDDataEn) 
    	$fdisplay(LcdRead, "%h",{LCDData[23:19], LCDData[15:10],LCDData[ 7: 3]});	// RGB565
    else if (LCDBPP==1 & LCDVSync & LCDHSync & LCDDataEn) 
    	$fdisplay(LcdRead, "%h",{LCDData[23:18], LCDData[15:10],LCDData[ 7: 2]});	// RGB666
    else if (LCDBPP==2 & LCDVSync & LCDHSync & LCDDataEn) 
    	$fdisplay(LcdRead, "%h",LCDData);	// RGB888
  end
end
`endif
`endif
//------------------------------------------------------
`ifdef WAVE
initial begin
  $shm_open("TbLCD.shm");
  $shm_probe(TbLCD, "ASC");
end
`endif
//------------------------------------------------------
endmodule
