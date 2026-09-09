
module VScInF ( 
			Clk, nRST, 
			XSize, YSize, ReqHold,
			ScaleInEn, InData, InValid, 
			OutData, OutValid,
			ScaleEnd,
			ScaleAddr0,
			ScaleRdData0,
			ScaleWrite0,
			ScaleWrData0,
			ScaleAddr1,
			ScaleRdData1,
			ScaleWrite1,
			ScaleWrData1
);

`include "DmPara.v"

input 		Clk;
input		nRST;

input		ScaleInEn;
input[XW:0]	XSize;
input[YW:0]	YSize;
output		ReqHold;

input		InValid;
input[15:0]	InData;

output		OutValid;
output[15:0]OutData;
output      ScaleEnd;

output [XW:0] ScaleAddr0;
input  [15:0] ScaleRdData0;
output		  ScaleWrite0;
output [15:0] ScaleWrData0;
output [XW:0] ScaleAddr1;
input  [15:0] ScaleRdData1;
output		  ScaleWrite1;
output [15:0] ScaleWrData1;
//-------------------------------------------------------
reg			PPSel;

reg [YW:0]	YCount;
reg			IncYCount;
wire		ScaleEnd;
wire		AddrHold;

// line memory
wire [XW:0] ScaleAddr0;
wire [15:0] ScaleRdData0;
wire		ScaleWrite0;
wire [15:0]	ScaleWrData0;
wire [XW:0] ScaleAddr1;
wire [15:0] ScaleRdData1;
wire		ScaleWrite1;
wire[15:0]	ScaleWrData1;

reg			OutValid;
wire [15:0] OutData;
//-------------------------------------------------------
// line memory 0 control
reg [XW+1:0]RdAddr0;
reg [XW:0]  WrAddr0;
reg			Read0;

reg 		ReadEnd0;
reg         RdAddrSel0;

reg [XW+1:0]RdAddr1;
reg [XW:0]  WrAddr1;
reg			Read1;

reg [XW+1:0]XCount1;

reg  		ReadEnd1;
reg 		RdAddrSel1;

reg         XRCountEnd0;
reg         XRCountEnd1;
reg         XWCountEnd0;
reg         XWCountEnd1;

reg			ReadStart0D1;
reg			ReadStart0D2;

reg			ReadStart1D1;
reg			ReadStart1D2;

reg         CondiPPd1;
reg         CondiPPd2;

wire        PP1st   = ~PPSel;
wire        PP2nd   =  PPSel;

wire        EqYCount   = (YCount == YSize + 1'b1);

wire        EqWCount0  = (WrAddr0 == XSize -1) & PP1st;
wire        EqRCount1  = (XCount1[XW+1:1] == XSize -1) & PP1st;
//wire        EqRCount1  = (XCount1 == XSize -1) & PP1st;

wire        EqWCount1  = (WrAddr1 == XSize -1) & PP2nd;
wire        EqRCount0  = (RdAddr0[XW+1:1] == XSize -1) & PP2nd;
//wire        EqRCount0  = (RdAddr0 == XSize -1) & PP2nd;

wire        ReadStart0 = ReadStart0D1 & ~ReadStart0D2;
wire        ReadStart1 = ReadStart1D1 & ~ReadStart1D2;

wire        ClearStAddr0 = ReadEnd0 & ~XRCountEnd0;
wire        ClearStAddr1 = ReadEnd1 & ~XRCountEnd1;

wire		XCountEnd0;
wire		XCountEnd1;

wire		IncPPCount   = (CondiPPd1 & ~CondiPPd2) | ((YCount == YSize - 1'b1) & IncYCount);

always @(negedge nRST or posedge Clk)
  	if  (!nRST) begin
  			    ReadStart0D1 <= 1'b0;
  			    ReadStart0D2 <= 1'b0;
  			    end
  	else        begin
  			    ReadStart0D1 <= (WrAddr1>8) & PP2nd; // should be more 8
  			    ReadStart0D2 <= ReadStart0D1;
  			    end

always @(negedge nRST or posedge Clk)
  if      (!nRST)   ReadEnd0 <= 1'b0;
  else              ReadEnd0 <= EqRCount0;

// write memory control
assign ScaleWrite0  = InValid & PP1st;
assign ScaleWrData0 = InData;

always @(negedge nRST or posedge Clk)
  	if      (!nRST)     	WrAddr0 <= 0;
  	else if (EqWCount0 | ScaleEnd)    
  			      			WrAddr0 <= 0;
  	else if (ScaleWrite0) 	WrAddr0 <= WrAddr0 + 1;

// read memory control
always @(negedge nRST or posedge Clk)
	if      (!nRST)      	Read0 <= 1'b0;
	else if (!ScaleInEn)   	Read0 <= 1'b0;
	else if (ReadEnd0) 		Read0 <= 1'b0;
	else if (ReadStart0) 	Read0 <= 1'b1;
	else                 	Read0 <= Read0;

//y address gen
always @(negedge nRST or posedge Clk)
  	if      (!nRST)     RdAddr0 <= 0;
  	else if (ClearStAddr0 | ScaleEnd) 
  						RdAddr0 <= 0;
  	else if (Read0)  	RdAddr0 <= RdAddr0 + 1;

always @(negedge nRST or posedge Clk)
  	if      (!nRST)      RdAddrSel0 <= 1'b0;
  	else if (ClearStAddr0) RdAddrSel0 <= 1'b0;
  	else if (ReadStart0) RdAddrSel0 <= 1'b1;
  	else                 RdAddrSel0 <= RdAddrSel0;

assign ScaleAddr0 = (RdAddrSel0) ? RdAddr0[XW+1:1] : WrAddr0;
//assign ScaleAddr0 = (RdAddrSel0) ? RdAddr0 : WrAddr0;
//-------------------------------------------------------
// line memory 1 control
wire			WaitEnd;
reg  [3:0]		WaitCount;
always @(negedge nRST or posedge Clk)
	if      (!nRST)   			WaitCount <= 0;
	else if (!ScaleInEn | Read1)WaitCount <= 0;
	else if (YCount == YSize)	WaitCount <= WaitCount + 1;

assign WaitEnd = &WaitCount;

always @(negedge nRST or posedge Clk)
  	if  (!nRST) begin
  			    ReadStart1D1 <= 1'b0;
  			    ReadStart1D2 <= 1'b0;
  			    end
  	else  begin
  			    ReadStart1D1 <= ((WrAddr0>8) | (WaitEnd & YCount == YSize)) & PP1st;
  			    ReadStart1D2 <= ReadStart1D1;
  			    end

always @(negedge nRST or posedge Clk)
  if      (!nRST)   ReadEnd1 <= 1'b0;
  else              ReadEnd1 <= EqRCount1;

// write memory control
assign ScaleWrite1  = InValid & PP2nd;
assign ScaleWrData1 = InData;

always @(negedge nRST or posedge Clk)
  	if      (!nRST)       WrAddr1 <= 0;
  	else if (EqWCount1 | ScaleEnd)    
  			      		  WrAddr1 <= 0;
  	else if (ScaleWrite1) WrAddr1 <= WrAddr1 + 1;

// read memory control
always @(negedge nRST or posedge Clk)
  	if      (!nRST)      	Read1 <= 1'b0;
  	else if (!ScaleInEn)   	Read1 <= 1'b0;
  	else if (EqYCount)    	Read1 <= 1'b0;
  	else if (ReadEnd1) 		Read1 <= 1'b0;
  	else if (ReadStart1) 	Read1 <= 1'b1;
  	else                 	Read1 <= Read1;

//y address gen
always @(negedge nRST or posedge Clk)
  	if      (!nRST)       	XCount1 <= 0;
  	else if (ClearStAddr1 | ScaleEnd) 
  							XCount1 <= 0;
  	else if (Read1) 		XCount1 <= XCount1 + 1;

always @(negedge nRST or posedge Clk)
  	if      (!nRST)       	RdAddr1 <= 0;
  	else if (ClearStAddr1 | ScaleEnd) 
  							RdAddr1 <= 0;
  	else if (AddrHold)		RdAddr1 <= RdAddr1;
  	else if (Read1) 		RdAddr1 <= RdAddr1 + 1;

always @(negedge nRST or posedge Clk)
  	if      (!nRST)      	RdAddrSel1 <= 1'b0;
  	else if (ClearStAddr1) 	RdAddrSel1 <= 1'b0;
  	else if (ReadStart1) 	RdAddrSel1 <= 1'b1;
  	else                 	RdAddrSel1 <= RdAddrSel1;

assign ScaleAddr1 = (RdAddrSel1) ? RdAddr1[XW+1:1] : WrAddr1;
//assign ScaleAddr1 = (RdAddrSel1) ? RdAddr1 : WrAddr1;
//-------------------------------------------------------
assign ScaleEnd = EqYCount;

always @(negedge nRST or posedge Clk)
  	if      (!nRST) 		XRCountEnd0 <= 1'b0;
  	else if ( !ScaleInEn)  	XRCountEnd0 <= 1'b0; 
  	else if ( ReadStart1) 	XRCountEnd0 <= 1'b0;
  	else if ( ReadEnd0)   	XRCountEnd0 <= 1'b1;
  	else                  	XRCountEnd0 <= XRCountEnd0;

always @(negedge nRST or posedge Clk)
  	if      (!nRST) 		XRCountEnd1 <= 1'b0;
  	else if ( !ScaleInEn)   XRCountEnd1 <= 1'b0; 
  	else if ( ReadStart0) 	XRCountEnd1 <= 1'b0;
  	else if ( ReadEnd1)   	XRCountEnd1 <= 1'b1;
  	else                  	XRCountEnd1 <= XRCountEnd1;

always @(negedge nRST or posedge Clk)
  	if      (!nRST) 		XWCountEnd0 <= 1'b0;
  	else if ( !ScaleInEn)   XWCountEnd0 <= 1'b0; 
  	else if ( ReadStart0) 	XWCountEnd0 <= 1'b0;
  	else if ( EqWCount0)  	XWCountEnd0 <= 1'b1;
  	else                  	XWCountEnd0 <= XWCountEnd0;

always @(negedge nRST or posedge Clk)
  	if      (!nRST) 		XWCountEnd1 <= 1'b0;
  	else if ( !ScaleInEn)   XWCountEnd1 <= 1'b0; 
  	else if ( ReadStart1) 	XWCountEnd1 <= 1'b0;
  	else if ( EqWCount1)  	XWCountEnd1 <= 1'b1;
  	else                  	XWCountEnd1 <= XWCountEnd1;

assign XCountEnd0 = XWCountEnd0 & XRCountEnd1;
assign XCountEnd1 = XWCountEnd1 & XRCountEnd0;

always @(negedge nRST or posedge Clk)
  	if  (!nRST) begin
  				CondiPPd1 <= 1'b0;
  				CondiPPd2 <= 1'b0;
  				end
  	else   begin
  				CondiPPd1 <= XCountEnd0 | XCountEnd1;
  				CondiPPd2 <= CondiPPd1;
  				end

always @(negedge nRST or posedge Clk)
  	if      (!nRST)    		PPSel <= 1'b0;
  	else if ( !ScaleInEn) 	PPSel <= 1'b0;
  	else if ( IncPPCount) 	PPSel <= PPSel + 1'b1;

// vertical counter
reg ClearStAddr;
always @(negedge nRST or posedge Clk)
  	if      (!nRST)    	ClearStAddr  <= 1'b0;
  	else               	ClearStAddr  <= ClearStAddr0 | ClearStAddr1;

always @(negedge nRST or posedge Clk)
  	if      (!nRST)    	IncYCount  <= 1'b0;
  	else               	IncYCount  <= ClearStAddr;

always @(negedge nRST or posedge Clk)
  	if      (!nRST)      	YCount <= 0;
  	else if ( !ScaleInEn)   YCount <= 0;
  	else if ( IncYCount) 	YCount <= YCount + 1'b1;
//-------------------------------------------------------
assign AddrHold  = ~|YCount;

always @(negedge nRST or posedge Clk)
  	if  (!nRST)	OutValid  <= 1'b0;
  	else        OutValid  <= (~AddrHold & Read1) | Read0;

assign OutData = PPSel ? ScaleRdData0 : ScaleRdData1;
//-------------------------------------------------------
// If Write is faster than Read
reg  ReqHold0;
reg  ReqHold1;

always @(negedge nRST or posedge Clk)
  	if      (!nRST) 		ReqHold0 <= 1'b0;
  	else if ( XRCountEnd1)  ReqHold0 <= 1'b0; 
  	else if ( XWCountEnd0)	ReqHold0 <= 1'b1;
  	else                  	ReqHold0 <= ReqHold0;

always @(negedge nRST or posedge Clk)
  	if      (!nRST) 		ReqHold1 <= 1'b0;
  	else if ( XRCountEnd0)  ReqHold1 <= 1'b0; 
  	else if ( XWCountEnd1)	ReqHold1 <= 1'b1;
  	else                  	ReqHold1 <= ReqHold1;

assign ReqHold = ReqHold0 | ReqHold1;

endmodule