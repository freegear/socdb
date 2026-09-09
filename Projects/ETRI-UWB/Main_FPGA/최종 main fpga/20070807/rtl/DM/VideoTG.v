`timescale 1ns / 1ps

module VideoTG (
			VClk,
			nRST,
			LCDEn,			//0 : Video, 1 : LCD
			SyncGenEn,
`ifdef BYPASS
			VideoBP,
			VideoBPAck,		// Release SyncGeneration
			VideoBPEn,
			VideoBPWait,
`endif
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
			
			VSyncOut,
			HSyncOut,
			DataEn,
			DataRequest,

            BT656Field,
            BT656VSync,
            BT601Blank,
            DmInitial,

			EvenField,
			FrameStart,
			FrameRst,
			MixerEn
);         

`include "DmPara.v"

input		 VClk;
input		 nRST;
input		 LCDEn;
input		 SyncGenEn;
`ifdef BYPASS
input		 VideoBP;
input		 VideoBPAck;
output		 VideoBPEn;
input [11:0] VideoBPWait;
`endif

input [ 7:0] LCDHFP;
input [ 7:0] LCDHBP;
input [ 8:0] LCDHSW;
input [XW:0] LCDCPL;
input [ 5:0] LCDVSW;
input [ 7:0] LCDVFP;
input [ 7:0] LCDVBP;
input [YW:0] LCDLPS;

input		 LCDIVS;
input		 LCDIHS;
input		 LCDIEO;

output		 VSyncOut;
output		 HSyncOut;
output		 DataEn;
output		 DataRequest;

//by kwoly /////
output       BT656Field;
output       BT656VSync;
output       BT601Blank;
output       DmInitial;

output		 EvenField;
output		 FrameStart;
output		 FrameRst;
output		 MixerEn;
//-------------------------------------------------------------------
reg  [YW:0] VCount;
reg  [XW:0] HCount;
reg         iVSyncOut;
reg         iHSyncOut;
reg 		iDataEn;
reg			MixerEn;
reg			DataEn;
reg 		DataRequest;
wire 		iDataRequest;
wire		IncVCount;

reg		 	VSyncOut;
reg		 	HSyncOut;

wire		FrameEnd;
//-------------------------------------------------------------------
//Active Video
//NTSC(22~261/285~524) PAL(23~310/336~623)
parameter V_IDLE = 5'b00001;
parameter V_VVSW = 5'b00010;
parameter V_VVBP = 5'b00100;
parameter V_VLPS = 5'b01000;
parameter V_VVFP = 5'b10000;

reg [4:0]  CurStV, NxtStV;

wire  tVdle  = CurStV[0];
wire  tVvsw  = CurStV[1];
wire  tVvbp  = CurStV[2];
wire  tVlps  = CurStV[3];
wire  tVvfp  = CurStV[4];

wire  nVdle  = NxtStV[0];
wire  nVvsw  = NxtStV[1];
wire  nVvbp  = NxtStV[2];
wire  nVlps  = NxtStV[3];

parameter H_IDLE = 5'b00001;
parameter H_HHSW = 5'b00010;
parameter H_HHBP = 5'b00100;
parameter H_HCPL = 5'b01000;
parameter H_HHFP = 5'b10000;

reg [4:0]  CurStH, NxtStH;

wire  tHdle  = CurStH[0];
wire  tHhsw  = CurStH[1];
wire  tHhbp  = CurStH[2];
wire  tHcpl  = CurStH[3];
wire  tHhfp  = CurStH[4];

wire  nHhsw  = NxtStH[1];
wire  nHcpl  = NxtStH[3];

reg			iVBPPlusOne;
wire		VBPPlusOne;
//-------------------------------------------------------------------
wire [10:0] HTotal = ((LCDHSW + LCDHFP + LCDHBP + LCDCPL)>>1);	// 858*2
wire [10:0] VTotal = ((LCDVSW + LCDVFP + LCDVBP + LCDLPS));	// 525
//-------------------------------------------------------------------
wire 		HSWEnd;
wire 		HBPEnd;
wire 		CPLEnd;
wire 		HFPEnd;

wire 		VSWEnd;
wire 		VBPEnd;
wire 		LPSEnd;
wire 		VFPEnd;

wire		HBPSkip;
wire   		HFPSkip;

wire		VBPSkip;
wire   		VFPSkip;

reg 		iVSyncD0;
reg 		iVSyncD1;
//--------------------------------------------------------------------------------
`ifdef BYPASS
reg			VideoBPEn;
always @(negedge nRST or posedge VClk)
	if (!nRST)	VideoBPEn <= 0;
	else if (FrameEnd)
	   			VideoBPEn <= VideoBP;

reg  [15:0] WaitCnt;
wire		WaitCntEnd = (WaitCnt == {VideoBPWait, 4'b0});
always @(negedge nRST or posedge VClk)
	if (!nRST)	WaitCnt <= 0;
	else if (!VideoBPAck)	
				WaitCnt <= 0;	
	else begin
		if (WaitCntEnd)
				WaitCnt <= WaitCnt;
		else if (tVvsw)
				WaitCnt <= WaitCnt+1;
	end

wire VideoBPAckDelay = VideoBPAck & WaitCntEnd;

reg			SyncGenHold;
always @(negedge nRST or posedge VClk)
	if (!nRST)	SyncGenHold <= 0;
	else if (VideoBPAckDelay)
				SyncGenHold <= 0;
	else if (FrameEnd)
	   			SyncGenHold <= VideoBP;
`else
wire		SyncGenHold = 1'b0;
`endif
//--------------------------------------------------------------------------------
always@(negedge nRST or posedge VClk)
	if (!nRST)HCount <= 0;
	else if (!SyncGenEn | SyncGenHold)
	   		  HCount <= 0;
	else begin
   		   if (HSWEnd | HBPEnd | CPLEnd | HFPEnd)
		   	  HCount <= 0;
   		   else
   		      HCount <= HCount + 1'b1;
	end

always@(negedge nRST or posedge VClk)
	if (!nRST)VCount <= 0;
	else if (!SyncGenEn | SyncGenHold)
	       	  VCount <= 0;
	else begin
		if (VSWEnd | VBPEnd | LPSEnd | VFPEnd)
		   	  VCount <= 0;
		else begin
		   if (IncVCount)
		      VCount <= VCount + 1'b1;
		   else
		      VCount <= VCount;
		end
	end

assign IncVCount = HFPSkip ? CPLEnd : HFPEnd;
//--------------------------------------------------------------------------------
assign HSWEnd = tHhsw & (HCount == {1'b0, LCDHSW}-1);
assign HBPEnd = tHhbp & (HCount == {2'b0, LCDHBP}-1);
assign CPLEnd = tHcpl & (HCount ==        LCDCPL -1);
assign HFPEnd = tHhfp & (HCount == {2'b0, LCDHFP}-1);

assign HBPSkip = (LCDHBP == 0);
assign HFPSkip = (LCDHFP == 0);

always @(negedge nRST or posedge VClk)
  	if (!nRST) 	CurStH <= H_IDLE;
  	else        CurStH <= NxtStH;

always @(tHdle or tHhsw or tHhbp or tHcpl or tHhfp or SyncGenEn or
		HSWEnd or HBPEnd or CPLEnd or HFPEnd or HBPSkip or HFPSkip) begin
  	NxtStH = H_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tHdle  : 	if (SyncGenEn)		NxtStH = H_HHSW;
  	  	          	else        		NxtStH = H_IDLE;
                                        	
  	  	tHhsw  : 	if (HSWEnd)	begin
  	  					if (HBPSkip)	NxtStH = H_HCPL;
  	  					else			NxtStH = H_HHBP;
  	  				end
  	  				else				NxtStH = H_HHSW;
                                        	
  	  	tHhbp  : 	if (HBPEnd)			NxtStH = H_HCPL;
  	  				else    			NxtStH = H_HHBP;
		                            	    	
  	  	tHcpl  : 	if (CPLEnd) begin
  	  					if (HFPSkip) begin
  	  						if (!SyncGenEn)
  	  									NxtStH = H_IDLE;
  	  						else		NxtStH = H_HHSW;
  	  					end
  	  					else   			NxtStH = H_HHFP;
  	  				end
  	  				else				NxtStH = H_HCPL;
                                    	    	
		tHhfp	:	if (HFPEnd)	begin
						if (!SyncGenEn)	NxtStH = H_IDLE;
						else			NxtStH = H_HHSW;
					end
					else				NxtStH = H_HHFP;
                                    	
  	  	default :               		NxtStH = H_IDLE;
  	endcase
end
//--------------------------------------------------------------------------------
assign VSWEnd = tVvsw & (VCount == {4'b0, LCDVSW});
assign VBPEnd = VBPPlusOne ? (tVvbp & VCount == {2'b0, LCDVBP}+1) : (tVvbp & VCount == {2'b0, LCDVBP});
assign LPSEnd = tVlps & (VCount == LCDLPS);
assign VFPEnd = tVvfp & (VCount == {2'b0, LCDVFP});

assign VBPSkip = (LCDVBP == 0);
assign VFPSkip = (LCDVFP == 0);

always @(negedge nRST or posedge VClk)
  	if (!nRST) 	CurStV <= V_IDLE;
  	else        CurStV <= NxtStV;

always @(tVdle or tVvsw or tVvbp or tVlps or tVvfp or SyncGenEn or
		VSWEnd or VBPEnd or LPSEnd or VFPEnd or VBPSkip or VFPSkip) begin
  	NxtStV = V_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tVdle  : 	if (SyncGenEn)		NxtStV = V_VVSW;
  	  	          	else        		NxtStV = V_IDLE;
                                        	
  	  	tVvsw  : 	if (VSWEnd)	begin
  	  					if (VBPSkip)	NxtStV = V_VLPS;
  	  					else			NxtStV = V_VVBP;
  	  				end
  	  				else				NxtStV = V_VVSW;
                                        	
  	  	tVvbp  : 	if (VBPEnd)			NxtStV = V_VLPS;
  	  				else    			NxtStV = V_VVBP;
		                            	    	
  	  	tVlps  : 	if (LPSEnd) begin
  	  					if (VFPSkip)begin
							if (!SyncGenEn)	
										NxtStV = V_IDLE;
							else		NxtStV = V_VVSW;
						end
  	  					else			NxtStV = V_VVFP;
  	  				end
  	  				else				NxtStV = V_VLPS;
                                    	    	
		tVvfp	:	if (VFPEnd)	begin
						if (!SyncGenEn)	NxtStV = V_IDLE;
						else			NxtStV = V_VVSW;
					end
					else				NxtStV = V_VVFP;
                                    	
  	  	default :               		NxtStV = V_IDLE;
  	endcase
end
//--------------------------------------------------------------------------------
// Signal Generation
always @(negedge nRST or posedge VClk)
	if (!nRST)	iHSyncOut <= 0;
	else		iHSyncOut <= tHhsw;

always @(negedge nRST or posedge VClk)
	if (!nRST) 	iVSyncOut <= 0;
	else begin
		if (VBPPlusOne) begin
			if (tHcpl & HCount == {1'b0, LCDCPL[XW:1]}) // Half Indicate Odd Field
				iVSyncOut <= nVvsw;
		end
		else	iVSyncOut <= nVvsw;
	end

always @(negedge nRST or posedge VClk)
	if (!nRST) iDataEn <= 1'b0;
	else if (!SyncGenEn | SyncGenHold)
	   		   iDataEn <= 1'b0;
	else       iDataEn <= nVlps & nHcpl;

assign iDataRequest = LCDEn ? iDataEn : iDataEn & ~HCount[0];

always @(negedge nRST or posedge VClk)
	if (!nRST) 	DataRequest <= 1'b0;
	else		DataRequest <= iDataRequest;

always @(negedge nRST or posedge VClk)
	if (!nRST) 	MixerEn <= 1'b0;
	else		MixerEn <= tVlps;

always @(negedge nRST or posedge VClk)
	if (!nRST)	iVBPPlusOne <= 0;
//	else if (~nVvbp & tVvbp)
	else if (~nVlps & tVlps)
				iVBPPlusOne <= iVBPPlusOne + 1;

assign VBPPlusOne = ~LCDEn & iVBPPlusOne;
//--------------------------------------------------------------------------------
always @(negedge nRST or posedge VClk)
	if (!nRST)  iVSyncD0 <= 0;
	else		iVSyncD0 <= iVSyncOut;

always @(negedge nRST or posedge VClk)
	if (!nRST)  iVSyncD1 <= 0;
	else		iVSyncD1 <= iVSyncD0;

/*
assign FrameStart = ~iVSyncOut &  iVSyncD0;// & ~VBPPlusOne;
assign FrameEnd   =  iVSyncOut & ~iVSyncD0 & ~VBPPlusOne;
assign FrameRst   =  iVSyncOut & ~iVSyncD0;
*/
// For FPGA, Video Clock is faster than PCLK
assign FrameStart = ~iVSyncOut &  iVSyncD1;// & ~VBPPlusOne;
assign FrameEnd   =  iVSyncOut & ~iVSyncD1 & ~VBPPlusOne;
assign FrameRst   =  iVSyncOut & ~iVSyncD1;

assign EvenField   = ~VBPPlusOne;	// Even Field Status
//--------------------------------------------------------------------------------
always @(negedge nRST or posedge VClk)
	if (!nRST) 	DataEn <= 1'b0;
	else		DataEn <= DataRequest^LCDIEO;

always @(negedge nRST or posedge VClk)
	if (!nRST)  HSyncOut <= 0;
	else		HSyncOut <= iHSyncOut^LCDIHS;

always @(negedge nRST or posedge VClk)
	if (!nRST)  VSyncOut <= 0;
	else begin
		if (LCDEn)
				VSyncOut <= iVSyncD1^LCDIVS;
		else	VSyncOut <= iVSyncOut^LCDIVS;
	end

//-------------------------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
integer DataCnt;
integer VDataCnt;

wire HDataEnd = DataCnt==(LCDCPL+1)/2 -1;

always @(negedge nRST or posedge DataEn)
	if (!nRST)	DataCnt <= 0;
	else if (HDataEnd)
				DataCnt <= 0;
	else		DataCnt <= DataCnt + 1;

always @(negedge nRST or posedge HDataEnd)
	if (!nRST)	VDataCnt <= 0;
	else if (VDataCnt==LCDLPS -1)
				VDataCnt <= 0;
	else		VDataCnt <= VDataCnt + 1;



wire NTSCSel = 1;

integer VCountRef;
always@(negedge nRST or posedge VClk)
	if (!nRST)
	   VCountRef <= 0;
	else if (!SyncGenEn | SyncGenHold)
	   VCountRef <= 0;
	else begin
		if (!NTSCSel) begin
		   if ((VCountRef == 524) & CPLEnd)
		      VCountRef <= 0;
		   else begin
		      if (CPLEnd)
		         VCountRef <= VCountRef + 1'b1;
		      else
		         VCountRef <= VCountRef;
		   end
		end
		else begin
		   if ((VCountRef == 624) & CPLEnd)
		      VCountRef <= 0;
		   else begin
		      if (CPLEnd)
		         VCountRef <= VCountRef + 1'b1;
		      else
		         VCountRef <= VCountRef;
		   end
		end
	end

reg VSyncRef;
always@(negedge nRST or posedge VClk)
	if (!nRST)	VSyncRef <= 1'b0;
	else if (!SyncGenEn | SyncGenHold)
	   			VSyncRef <= 1'b0;
	else begin
   		if (!NTSCSel) begin
   		   if (VCountRef == 0) begin
   		      if (tHcpl & HCount == 1)
   		         VSyncRef <= 1'b1;
   		      else
   		         VSyncRef <= VSyncRef;
   		   end
   		   else if (VCountRef == 3) begin		// LCDVSW
   		      if (tHcpl & HCount == 1)
   		         VSyncRef <= 1'b0;
   		      else
   		         VSyncRef <= VSyncRef;
   		   end
   		   else if (VCountRef == 262) begin	// LCDVSW + (LCDVBP +1) + LCDLPS
   		      if (tHcpl & HCount == 615)
   		         VSyncRef <= 1'b1;
   		      else
   		         VSyncRef <= VSyncRef;
   		   end
   		   else if (VCountRef == 265) begin	// LCDVSW + (LCDVBP +1) + LCDLPS + LCDVSW
   		      if (tHcpl & HCount == 615)
   		         VSyncRef <= 1'b0;
   		      else
   		         VSyncRef <= VSyncRef;
   		   end
   		   else
   		      VSyncRef <= VSyncRef;
   		end
   		else begin
   		   if (VCountRef == 0) begin
   		      if (tHcpl & HCount == 1)
   		         VSyncRef <= 1'b1;
   		      else
   		         VSyncRef <= VSyncRef;
   		   end
   		   else if (VCountRef == 3) begin
   		      if (tHcpl & HCount == 1)
   		         VSyncRef <= 1'b0;
   		      else
   		         VSyncRef <= VSyncRef;
   		   end
   		   else if (VCountRef == 312) begin
   		      if (tHcpl & HCount == 609)
   		         VSyncRef <= 1'b1;
   		      else
   		         VSyncRef <= VSyncRef;
   		   end
   		   else if (VCountRef == 315) begin
   		      if (tHcpl & HCount == 609)
   		         VSyncRef <= 1'b0;
   		      else
   		         VSyncRef <= VSyncRef;
   		   end
   		   else
   		      VSyncRef <= VSyncRef;
   		end
	end
// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// BT656 format sync signal output
// -----------------------------------------------------------------------------

assign BT656Field = nVvsw;  // Field output
assign BT656VSync = nVlps;  // Filed converting signal
assign BT601Blank = iDataEn;// Blank signal
assign DmInitial = tHhfp ;

// -----------------------------------------------------------------------------

endmodule
