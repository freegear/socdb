//-------------------------------------------------------------------------------
// Plane Mixer
wire		IntEn = 1;
wire		ErrIntEn = 1;
wire		PrioritySel = 1;			// 0 : V > G, 1 : G > V
wire [23:0] BPlaneDataIn = 24'hffffff;// Black //ffffff; 	// BackGround is White
wire [10:0] CPlaneXPos   = 30;			// Cursor Plane
wire [10:0] CPlaneYPos   = 30;
wire [10:0] GPlaneXPos   = 0;
wire [10:0] GPlaneYPos   = 0;
`ifdef UP
wire [10:0] VPlaneXPos   = 0;
wire [10:0] VPlaneYPos   = 0;
`else
`ifdef BP
wire [10:0] VPlaneXPos   = 0;
wire [10:0] VPlaneYPos   = 0;
`else
wire [10:0] VPlaneXPos   = 200;
wire [10:0] VPlaneYPos   = 200;
`endif
`endif
//-------------------------------------------------------------------------------
// Cursor Plane
wire		CPlaneEn = 0;
wire 		CPlaneChromaKeyEn = 0;
wire [23:0] CPlaneChromaKey = 24'hffffff;
wire [ 1:0]	CPlanePixFormat = 2'b01;		// 00: 8bit palette, 01 : RGB232, 10: ARGB1555, 11: RGB565
wire [ 1:0]	CPlaneAlphaMode = 2'b10;	// 0: No Alpah, 2: Global Alpha, 3: Per-Pixel Alpha
wire [ 7:0] CPlaneAlphaValue = 8'hff;
wire [ 9:0] CPlaneXStart = 0;			// Cursor Plane
wire [ 9:0] CPlaneYStart = 0;
wire [ 9:0] CPlaneXSize = CursorX-4;			// max 64x64
wire [ 9:0] CPlaneYSize = CursorY-4;

wire [ 9:0] CPlaneXStartRef = CPlanePixFormat[1] ? {1'b0, CPlaneXStart[ 9:1]} : {2'b0, CPlaneXStart[ 9:2]};
wire [ 9:0] CPlaneXRefRef   = CPlanePixFormat[1] ? {1'b0, CursorX[ 9:1]}      : {2'b0, CursorX[ 9:2]};
wire [ 9:0] CPlaneXSizeRef  = CPlanePixFormat[1] ? {1'b0, CPlaneXSize[ 9:1]}  : {2'b0, CPlaneXSize[ 9:2]};
wire [31:0] CDMAStartAddr0  = (CPlaneXStartRef + ((CPlaneYStart * CPlaneXRefRef))<<2);

wire [10:0] CPlaneXRef       = CPlaneXRefRef - CPlaneXSizeRef;	// Source Size Should be Larger than Display Size
//wire [31:0] CPlaneStartAddr  = CDMAStartAddr0 + 0 *4;
//wire [31:0] CPlaneStartAddr2 = CDMAStartAddr0 + CursorX * CursorY *4;
wire [31:0] CPlaneStartAddr  = 32'h40000000 + CDMAStartAddr0;
wire [31:0] CPlaneStartAddr2 = 32'h40000000 + CDMAStartAddr0 + ((CursorX * CursorY)<<2);

wire		CPlaneAddrSwEn  = 1;
wire [ 5:0] CPlaneAddrSwVal = 2;
//-------------------------------------------------------------------------------
// Graphic Plane
wire		GPlaneEn = 1;
wire 		GPlaneChromaKeyEn = 0;
wire [23:0] GPlaneChromaKey = 24'hffffff;
wire [ 2:0]	GPlanePixFormat = 2;		// 0: 8bit, 2: RGB565, 3:ARGB1555, 4:RGB888, 5:ARGB8888
wire [ 1:0]	GPlaneAlphaMode = 2'd2;	// 0: No Alpah, 2: Global Alpha, 3: Per-Pixel Alpha
wire [ 7:0] GPlaneAlphaValue = 8'hff;
wire [10:0] GPlaneXStart = 0;//4;
wire [10:0] GPlaneYStart = 0;//2;
wire [10:0] GPlaneXSize  = GraphicX;//-10;
wire [10:0] GPlaneYSize  = GraphicY;//-5;

reg  [10:0] 	GPlaneXSizeRef;
reg  [10:0]		GPlaneXStartRef;
reg  [10:0] 	GPlaneXRefRef;

always @(GPlanePixFormat or GPlaneXSize)
	case(GPlanePixFormat)
		2, 3 : GPlaneXSizeRef = {1'b0, GPlaneXSize[10:1]}; // 16bit, /2
		0    : GPlaneXSizeRef = {2'b0, GPlaneXSize[10:2]}; // 8bit, /4
		4    : GPlaneXSizeRef =  	   GPlaneXSize[10:0] ; // 32bit
	endcase

always @(GPlanePixFormat or GPlaneXStart)
	case(GPlanePixFormat)
		2, 3 : GPlaneXStartRef = {1'b0, GPlaneXStart[10:1]}; // 16bit, /2
		0    : GPlaneXStartRef = {2'b0, GPlaneXStart[10:2]}; // 8bit, /4
		4  	 : GPlaneXStartRef =  	    GPlaneXStart[10:0] ; // 32bit
	endcase

always @(GPlanePixFormat or GraphicX)
	case(GPlanePixFormat)
		2, 3 : GPlaneXRefRef = {1'b0, GraphicX[10:1]}; // 16bit, /2
		0    : GPlaneXRefRef = {2'b0, GraphicX[10:2]}; // 8bit, /4
		4    : GPlaneXRefRef = {	  GraphicX[10:0]}; // 32bit
	endcase

wire [11:0] GPlaneXRef   = GPlaneXRefRef - GPlaneXSizeRef;// + GPlaneXRefRef;	// Source Stride
wire [31:0] GPlaneStartAddr = 32'h40100000 + ((GPlaneXStartRef + (GPlaneYStart * GPlaneXRefRef))<<2);
wire		GPlaneGammaEn = 0;

// Palette Memory
reg  [ 7:0] GPalMemData;
reg  [ 7:0] CPalMemData;

// Graphic Gamma(Slope 1.4)
wire [23:0] GPlaneGamma10 = {3{8'd255}}; 
wire [23:0] GPlaneGamma0F = {3{8'd244}}; 
wire [23:0] GPlaneGamma0E = {3{8'd232}}; 
wire [23:0] GPlaneGamma0D = {3{8'd220}}; 
wire [23:0] GPlaneGamma0C = {3{8'd208}}; 
wire [23:0] GPlaneGamma0B = {3{8'd195}}; 
wire [23:0] GPlaneGamma0A = {3{8'd182}}; 
wire [23:0] GPlaneGamma09 = {3{8'd169}}; 
wire [23:0] GPlaneGamma08 = {3{8'd156}}; 
wire [23:0] GPlaneGamma07 = {3{8'd141}}; 
wire [23:0] GPlaneGamma06 = {3{8'd127}}; 
wire [23:0] GPlaneGamma05 = {3{8'd111}}; 
wire [23:0] GPlaneGamma04 = {3{8'd95}} ; 
wire [23:0] GPlaneGamma03 = {3{8'd77}} ; 
wire [23:0] GPlaneGamma02 = {3{8'd57}} ; 
wire [23:0] GPlaneGamma01 = {3{8'd35}} ; 
wire [23:0] GPlaneGamma00 = {3{8'd0}}  ;
//-------------------------------------------------------------------------------
// Video Plane
wire		VPlaneEn = 1;
//`ifdef BT656
//wire		VPlaneInterlaceEn = 1;
//`else
wire		VPlaneInterlaceEn = 1; // Interlace Source Video to Progressive Display
`ifdef PAL
wire		VPlaneN2PUpEn = 1;
`else
wire		VPlaneN2PUpEn = 0;
`endif
//`endif
wire 		VPlaneChromaKeyEn = 0;
wire [23:0] VPlaneChromaKey = 24'hffffff;
wire [ 1:0]	VPlanePixFormat = 3;		// 0: Y0CbY1Cr, 1:Y0CrY1Cb, 2:CrY0CbY1, 3:CbY0CrY1
wire [ 1:0]	VPlaneAlphaMode = 2'b00;	// 0: No Alpah, 2: Global Alpha
wire [ 7:0] VPlaneAlphaValue = 8'hff;
wire		VPlaneGammaEn = 0;

wire [23:0] VPlaneGamma10 = {3{8'd255}}; 
wire [23:0] VPlaneGamma0F = {3{8'd244}}; 
wire [23:0] VPlaneGamma0E = {3{8'd232}}; 
wire [23:0] VPlaneGamma0D = {3{8'd220}}; 
wire [23:0] VPlaneGamma0C = {3{8'd208}}; 
wire [23:0] VPlaneGamma0B = {3{8'd195}}; 
wire [23:0] VPlaneGamma0A = {3{8'd182}}; 
wire [23:0] VPlaneGamma09 = {3{8'd169}}; 
wire [23:0] VPlaneGamma08 = {3{8'd156}}; 
wire [23:0] VPlaneGamma07 = {3{8'd141}}; 
wire [23:0] VPlaneGamma06 = {3{8'd127}}; 
wire [23:0] VPlaneGamma05 = {3{8'd111}}; 
wire [23:0] VPlaneGamma04 = {3{8'd95}} ; 
wire [23:0] VPlaneGamma03 = {3{8'd77}} ; 
wire [23:0] VPlaneGamma02 = {3{8'd57}} ; 
wire [23:0] VPlaneGamma01 = {3{8'd35}} ; 
wire [23:0] VPlaneGamma00 = {3{8'd0}}  ;

wire [10:0] VPlaneXStart = 0;
wire [10:0] VPlaneYStart = 0;
`ifdef UP
wire [10:0] VPlaneXSize = 960;
wire [10:0] VPlaneYSize = 720;
wire 		PreFilterEn = 1;
wire 		DnScaleEn = 0;
wire 		UpScaleEn = 1;
`else 
`ifdef VIDEO
wire [10:0] VPlaneXSize = VideoX;
wire [10:0] VPlaneYSize = VideoY;
wire 		PreFilterEn = 0;
wire 		DnScaleEn = 0;
wire 		UpScaleEn = 0;
`else
`ifdef BP
wire [10:0] VPlaneXSize = 480;
wire [10:0] VPlaneYSize = 272;
wire 		PreFilterEn = 0;
wire 		DnScaleEn = 0;
wire 		UpScaleEn = 0;
`else
wire [10:0] VPlaneXSize = 320;
wire [10:0] VPlaneYSize = 240;
wire 		PreFilterEn = 0;
wire 		DnScaleEn = 1;
wire 		UpScaleEn = 0;
`endif
`endif
`endif
wire [10:0]	ScaleInXSize = VideoX;
wire [10:0]	ScaleInYSize = VideoY;

wire [15:0] UpScaleXRatio = ((ScaleInXSize+1)*65536)/(VPlaneXSize+1);
wire [15:0] UpScaleYRatio = ((ScaleInYSize+1)*65536)/(VPlaneYSize+1);
wire [15:0] DnScaleXRatio = ((VPlaneXSize+1)*65536) /(ScaleInXSize+1);
wire [15:0] DnScaleYRatio = ((VPlaneYSize+1)*65536) /(ScaleInYSize+1);

wire [15:0] ScaleXRatio = UpScaleEn ? UpScaleXRatio : DnScaleXRatio; 
wire [15:0] ScaleYRatio = UpScaleEn ? UpScaleYRatio : DnScaleYRatio; 

wire [10:0]	VPlaneXSizeRef  = {1'b0, VPlaneXSize[10:1]}; // 16bit, /2
wire [10:0] VPlaneXStartRef = {1'b0, VPlaneXStart[10:1]};
wire [10:0] VPlaneXRefRef   = {1'b0, VideoX[10:1]};

wire [11:0] VPlaneXRef      = VPlaneXRefRef - VPlaneXSizeRef;

wire [31:0] VPlaneStartAddr = 32'h40200000 + ((VPlaneXStartRef + (VPlaneYStart * VPlaneXRefRef))<<2);
wire [31:0] VPlaneStartAddr2 = VPlaneStartAddr + ((VideoX/2*VideoY/2)<<2);	// 2pixel per 32bit data
//-------------------------------------------------------------------------------
`ifdef VIDEO
wire		VideoSyncEn = 1'b1;
`else
wire		VideoSyncEn = 1'b0;
`endif
/*
`ifdef BT656
wire		VideoBP		= 1'b1;
`else
wire		VideoBP		= 1'b0;
`endif
wire [11:0]	VideoBPWait = 63;
*/
//-------------------------------------------------------------------------------
wire [10:0] LCDXSize = UpScaleEn ? VPlaneXSize : LCDX;
wire [10:0] LCDYSize = UpScaleEn ? VPlaneYSize : LCDY;

wire		LCDPwrEn = 1;

`ifdef VIDEO
wire       	LCDEn = 0;

    `ifdef NTSC

        `ifdef BT601
wire [ 7:0] LCDHFP = (16*2) - 1;    
wire [ 7:0] LCDHBP = (122*2)-121;   
wire [ 8:0] LCDHSW = 122;			
wire [10:0] LCDCPL = LCDXSize*2;	
wire [ 5:0] LCDVSW = 3;
wire [10:0] LCDLPS = LCDYSize;
wire [ 7:0] LCDVBP = 16;
wire [ 7:0] LCDVFP = 3;
wire       	LCDIVS = 1;         
wire       	LCDIHS = 1; 
        
wire       	LCDIEO = 0;         
wire       	LCDBCD = 1;         
wire [2:0] 	LCDBPP = 5;
wire		LCDBGR = 0;
        `elsif BT601_2
wire [ 7:0] LCDHFP = (16*2) - 1;    
wire [ 7:0] LCDHBP = (122*2)-121;   
wire [ 8:0] LCDHSW = 122;			
wire [10:0] LCDCPL = LCDXSize*2;	
wire [ 5:0] LCDVSW = 3;
wire [10:0] LCDLPS = LCDYSize;
wire [ 7:0] LCDVBP = 16;
wire [ 7:0] LCDVFP = 3;
wire       	LCDIVS = 1;         
wire       	LCDIHS = 1; 
        
wire       	LCDIEO = 0;         
wire       	LCDBCD = 1;         
wire [2:0] 	LCDBPP = 6;
wire		LCDBGR = 0;
        `else

            `ifdef BT656
wire [ 7:0] LCDHFP = 1;    
wire [ 7:0] LCDHBP = (122*2)-121;   
wire [ 8:0] LCDHSW = 122+30;			
wire [10:0] LCDCPL = LCDXSize*2;	
wire [ 5:0] LCDVSW = 3;
wire [10:0] LCDLPS = LCDYSize;
wire [ 7:0] LCDVBP = 16;
wire [ 7:0] LCDVFP = 3;
wire       	LCDIVS = 1;         
wire       	LCDIHS = 1; 
        
wire       	LCDIEO = 0;         
wire       	LCDBCD = 1;         
wire [2:0] 	LCDBPP = 4;
wire		LCDBGR = 0;
            `else
wire [ 7:0] LCDHFP = (16*2) - 1;    
wire [ 7:0] LCDHBP = (122*2)-121;   
wire [ 8:0] LCDHSW = 122;			
wire [10:0] LCDCPL = LCDXSize*2;	
wire [ 5:0] LCDVSW = 3;
wire [10:0] LCDLPS = LCDYSize;
wire [ 7:0] LCDVBP = 16;
wire [ 7:0] LCDVFP = 3;
wire       	LCDIVS = 1;         
wire       	LCDIHS = 1; 
        
wire       	LCDIEO = 0;         
wire       	LCDBCD = 1;         
wire [2:0] 	LCDBPP = 2;
wire		LCDBGR = 0;

            `endif
        `endif

    `else

        `ifdef BT601

wire [ 7:0] LCDHFP = (12*2)-1; 
wire [ 7:0] LCDHBP = (132*2)-131;
wire [ 8:0] LCDHSW = 132;		
wire [10:0] LCDCPL = LCDXSize*2;	
wire [ 5:0] LCDVSW = 2;
wire [10:0] LCDLPS = LCDYSize;
wire [ 7:0] LCDVBP = 20;
wire [ 7:0] LCDVFP = 2;
wire       	LCDIVS = 1;         
wire       	LCDIHS = 1; 

wire       	LCDIEO = 0;         
wire       	LCDBCD = 1;         
wire [2:0] 	LCDBPP = 5;
wire		LCDBGR = 0;


        `elsif BT601_2
wire [ 7:0] LCDHFP = (12*2)-1; 
wire [ 7:0] LCDHBP = (132*2)-131;
wire [ 8:0] LCDHSW = 132;		
wire [10:0] LCDCPL = LCDXSize*2;	
wire [ 5:0] LCDVSW = 2;
wire [10:0] LCDLPS = LCDYSize;
wire [ 7:0] LCDVBP = 20;
wire [ 7:0] LCDVFP = 2;
wire       	LCDIVS = 1;         
wire       	LCDIHS = 1; 

wire       	LCDIEO = 0;         
wire       	LCDBCD = 1;         
wire [2:0] 	LCDBPP = 6;

        `else

            `ifdef BT656
wire [ 7:0] LCDHFP = 1; 
wire [ 7:0] LCDHBP = (132*2)-131;
wire [ 8:0] LCDHSW = 132+22;		
wire [10:0] LCDCPL = LCDXSize*2;	
wire [ 5:0] LCDVSW = 2;
wire [10:0] LCDLPS = LCDYSize;
wire [ 7:0] LCDVBP = 20;
wire [ 7:0] LCDVFP = 2;
wire       	LCDIVS = 1;         
wire       	LCDIHS = 1; 

wire       	LCDIEO = 0;         
wire       	LCDBCD = 1;         
wire [2:0] 	LCDBPP = 4;
wire		LCDBGR = 0;
            `else
wire [ 7:0] LCDHFP = (12*2)-1; 
wire [ 7:0] LCDHBP = (132*2)-131;
wire [ 8:0] LCDHSW = 132;		
wire [10:0] LCDCPL = LCDXSize*2;	
wire [ 5:0] LCDVSW = 2;
wire [10:0] LCDLPS = LCDYSize;
wire [ 7:0] LCDVBP = 20;
wire [ 7:0] LCDVFP = 2;
wire       	LCDIVS = 1;         
wire       	LCDIHS = 1; 

wire       	LCDIEO = 0;         
wire       	LCDBCD = 1;         
wire [2:0] 	LCDBPP = 2;
wire		LCDBGR = 0;
            `endif
        `endif

    `endif

`else
wire       	LCDEn = 1;
wire [7:0] 	LCDHFP = 2;        	// Horizontal front porch value
wire [7:0] 	LCDHBP = 2;        	// Horizontal back porch value
wire [7:0] 	LCDHSW = 41;       	// Horizontal sync width value
wire [10:0] LCDCPL = LCDXSize; 	// LcdCP clocks per line
wire [5:0] 	LCDVSW = 4;       	// Vertical sync width value
wire [7:0] 	LCDVFP = 4;        	// Vertical front porch value
wire [7:0] 	LCDVBP = 10;        	// Vertical back porch value
wire [10:0] LCDLPS = LCDYSize; 	// Lines per screen value
wire       	LCDIVS = 1;          	// Invert vertical sync
wire       	LCDIHS = 1;          	// Invert horizontal sync

wire       	LCDIEO = 0;          	// Invert output enable for TFT
wire [2:0] 	LCDBPP = 0; 			// 0:16, 1:18, 2:24bit
wire		LCDBGR = 0;

//wire [7:0] 	LCDHFP = 2-1;        	// Horizontal front porch value
//wire [7:0] 	LCDHBP = 2-1;        	// Horizontal back porch value
//wire [7:0] 	LCDHSW = 28-1;       	// Horizontal sync width value
//wire [10:0] LCDCPL = LCDXSize-1; 	// LcdCP clocks per line
//wire [5:0] 	LCDVSW = 10-1;       	// Vertical sync width value
//wire [7:0] 	LCDVFP = 5-1;        	// Vertical front porch value
//wire [7:0] 	LCDVBP = 10-1;        	// Vertical back porch value
//wire [10:0] LCDLPS = LCDYSize-1; 	// Lines per screen value
//wire       	LCDIVS = 0;          	// Invert vertical sync
//wire       	LCDIHS = 0;          	// Invert horizontal sync
//wire       	LCDIEO = 0;          	// Invert output enable for TFT
//wire       	LCDBCD = 1;          	// Bypass Panel clock divider - pixel every clock
//wire       	LCDLEEn = 1;         	// Enable Line-End signal generation
//wire [6:0] 	LCDLEDel = 0;        	// Line-End signal delay value
//wire		LCDPwrEn = 1;
//wire       	LCDEn = 1;            	// Lcd Controller enable bit 
//wire [1:0] 	LCDVComp = 0;         	// Vertical compare interrupt value
//wire [1:0] 	LCDBPP = 0; 			// 0:16, 1:18, 2:24bit
//wire		LCDBGR = 0;
`endif
//-------------------------------------------------------------------------------
