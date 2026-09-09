
// Down Scaler Output Control

module DnScWc(
			VCLK, nRST, 

//`ifdef DOWNSCALER
			YCOrder,
			ScaleHRef, ScaleHOut, ScaleYOut, ScaleCOut
//`endif
);

`include "VifPara.v"

input	VCLK, nRST;
//`ifdef DOWNSCALER
input	[1:0] YCOrder;
input	ScaleHRef, ScaleHOut;
input	[7:0] ScaleYOut, ScaleCOut;
//`endif

`ifdef DOWNSCALER
reg ScaleOutValid;
always @(negedge nRST or posedge VCLK)
	if 		(!nRST)	ScaleOutValid <= 0;
	else if (ScaleHOut)	
   					ScaleOutValid <= ScaleOutValid + 1;

reg ScaleOutSel;
always @(negedge nRST or posedge VCLK)
	if 		(!nRST)	ScaleOutSel <= 0;
	else if (!ScaleHRef)
					ScaleOutSel <= 0;
	else if (ScaleOutValid)	
   					ScaleOutSel <= ScaleOutSel + 1;

/*
2'b00 : {Cr0, YY1, Cb0, YY0};
2'b01 : {Cb0, YY1, Cr0, YY0};
2'b10 : {YY1, Cb0, YY0, Cr0};
2'b11 : {YY1, Cr0, YY0, Cb0};
*/
	
reg [DATA_WIDTH-1:0] ScaleOut32;
always @(negedge nRST or posedge VCLK)
	if 	(!nRST)	ScaleOut32 <= 0;
	else if (ScaleOutValid) begin
		if (!ScaleOutSel)	begin
			case(YCOrder) // synopsys parallel_case
				2'b00 : begin
   				ScaleOut32[15: 8] <= ScaleCOut;	// CB
   				ScaleOut32[ 7: 0] <= ScaleYOut;	// Y0
   				end
				2'b01 : begin
   				ScaleOut32[31:24] <= ScaleCOut;	// CB
   				ScaleOut32[ 7: 0] <= ScaleYOut;	// Y0
   				end
				2'b10 : begin
   				ScaleOut32[23:16] <= ScaleCOut;	// CB
   				ScaleOut32[15: 8] <= ScaleYOut;	// Y0
   				end
				2'b11 : begin
   				ScaleOut32[ 7: 0] <= ScaleCOut;	// CB
   				ScaleOut32[15: 8] <= ScaleYOut;	// Y0
   				end
   			endcase
   		end
   		else begin
			case(YCOrder) // synopsys parallel_case
				2'b00 : begin
   				ScaleOut32[31:24] <= ScaleCOut;	// CR
   				ScaleOut32[23:16] <= ScaleYOut;	// Y1
   				end
				2'b01 : begin
   				ScaleOut32[15: 8] <= ScaleCOut;	// CR
   				ScaleOut32[23:16] <= ScaleYOut;	// Y1
   				end
				2'b10 : begin
   				ScaleOut32[ 7: 0] <= ScaleCOut;	// CR
   				ScaleOut32[31:24] <= ScaleYOut;	// Y1
   				end
				2'b11 : begin
   				ScaleOut32[23:16] <= ScaleCOut;	// CR
   				ScaleOut32[31:24] <= ScaleYOut;	// Y1
   				end
   			endcase
   		end
   	end

reg ScaleOut32Valid;
always @(negedge nRST or posedge VCLK)
	if 	(!nRST)	ScaleOut32Valid <= 0;
	else 		ScaleOut32Valid <= ScaleOutValid & ScaleOutSel;
`endif


endmodule