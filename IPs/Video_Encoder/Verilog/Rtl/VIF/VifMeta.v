
module VifMeta (
		VCLK, ARESETB,
		DmaEn, HSize, VSize, HStart, VStart, YCOrder,
		ScalePfEn, ScaleEn, ScaleHR, ScaleVR,
		
		DmaEnSyncVClk, 	HSizeSyncVClk, VSizeSyncVClk, HStartSyncVClk, VStartSyncVClk, 
		YCOrderSyncVClk,
		ScalePfEnSyncVClk, ScaleEnSyncVClk, ScaleHRSyncVClk, ScaleVRSyncVClk
);

`include "VifPara.v"

input	VCLK, ARESETB;

input 	DmaEn;
input 	[ImageSize-1:0] HStart;
input 	[ImageSize-1:0] VStart;
input 	[ImageSize-1:0] HSize;
input 	[ImageSize-1:0] VSize;
input 	[1:0]  YCOrder;

input         ScalePfEn;
input         ScaleEn;
input  [15:0] ScaleHR;
input  [15:0] ScaleVR;

output 	DmaEnSyncVClk;
output 	[ImageSize-1:0] HSizeSyncVClk;
output 	[ImageSize-1:0] VSizeSyncVClk;
output 	[ImageSize-1:0] HStartSyncVClk;
output 	[ImageSize-1:0] VStartSyncVClk;
output 	[1:0]  YCOrderSyncVClk;

output         ScalePfEnSyncVClk;
output         ScaleEnSyncVClk;
output  [15:0] ScaleHRSyncVClk;
output  [15:0] ScaleVRSyncVClk;

reg 	DmaEnSyncVClk0;
reg 	[ImageSize-1:0] HSizeSyncVClk0;
reg 	[ImageSize-1:0] VSizeSyncVClk0;
reg 	[ImageSize-1:0] HStartSyncVClk0;
reg 	[ImageSize-1:0] VStartSyncVClk0;
reg 	[1:0]  YCOrderSyncVClk0;

reg 	DmaEnSyncVClk;
reg 	[ImageSize-1:0] HSizeSyncVClk;
reg 	[ImageSize-1:0] VSizeSyncVClk;
reg 	[ImageSize-1:0] HStartSyncVClk;
reg 	[ImageSize-1:0] VStartSyncVClk;
reg 	[1:0]  YCOrderSyncVClk;

always @(negedge ARESETB or posedge VCLK)
	if (!ARESETB) begin
			DmaEnSyncVClk0 <= 1'b0;
			HSizeSyncVClk0 <= 1'b0;
			VSizeSyncVClk0 <= 1'b0;
			HStartSyncVClk0 <= 1'b0;
			VStartSyncVClk0 <= 1'b0;
			YCOrderSyncVClk0 <= 1'b0;
	end
	else begin
			DmaEnSyncVClk0 <= DmaEn;
			HSizeSyncVClk0 <= HSize;
			VSizeSyncVClk0 <= VSize;
			HStartSyncVClk0 <= HStart;
			VStartSyncVClk0 <= VStart;
			YCOrderSyncVClk0 <= YCOrder;
	end

always @(negedge ARESETB or posedge VCLK)
	if (!ARESETB) begin
			DmaEnSyncVClk <= 1'b0;
			HSizeSyncVClk <= 1'b0;
			VSizeSyncVClk <= 1'b0;
			HStartSyncVClk <= 1'b0;
			VStartSyncVClk <= 1'b0;
			YCOrderSyncVClk <= 2'b0;
	end
	else begin
			DmaEnSyncVClk <= DmaEnSyncVClk0;
			HSizeSyncVClk <= HSizeSyncVClk0;
			VSizeSyncVClk <= VSizeSyncVClk0;
			HStartSyncVClk <= HStartSyncVClk0;
			VStartSyncVClk <= VStartSyncVClk0;
			YCOrderSyncVClk <= YCOrderSyncVClk0;
	end

reg         ScalePfEnSyncVClk0;
reg         ScaleEnSyncVClk0;
reg  [15:0] ScaleHRSyncVClk0;
reg  [15:0] ScaleVRSyncVClk0;

reg         ScalePfEnSyncVClk;
reg         ScaleEnSyncVClk;
reg  [15:0] ScaleHRSyncVClk;
reg  [15:0] ScaleVRSyncVClk;

always @(negedge ARESETB or posedge VCLK)
	if (!ARESETB) begin
			ScalePfEnSyncVClk0 <= 1'b0;
			ScaleEnSyncVClk0 <= 1'b0;
			ScaleHRSyncVClk0 <= 1'b0;
			ScaleVRSyncVClk0 <= 1'b0;
	end
	else begin
			ScalePfEnSyncVClk0 <= ScalePfEn;
			ScaleEnSyncVClk0 <= ScaleEn;
			ScaleHRSyncVClk0 <= ScaleHR;
			ScaleVRSyncVClk0 <= ScaleVR;
	end

always @(negedge ARESETB or posedge VCLK)
	if (!ARESETB) begin
			ScalePfEnSyncVClk <= 1'b0;
			ScaleEnSyncVClk <= 1'b0;
			ScaleHRSyncVClk <= 1'b0;
			ScaleVRSyncVClk <= 1'b0;
	end
	else begin
			ScalePfEnSyncVClk <= ScalePfEnSyncVClk;
			ScaleEnSyncVClk <= ScaleEnSyncVClk0;
			ScaleHRSyncVClk <= ScaleHRSyncVClk0;
			ScaleVRSyncVClk <= ScaleVRSyncVClk0;
	end

endmodule