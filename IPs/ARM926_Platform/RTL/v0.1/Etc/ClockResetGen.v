
// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : ClockResetGen.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose            : Clock & Reset generator for Bus & APB
//                     : Not intended for synthesis.
//  --========================================================================--
//
//  2006.11.15 : Add CPUClkEn signal
//
//
//



`timescale 1ns/10ps

module ClockResetGen 
  (
   Clock_i,
   Reset_i,
   ensrst     ,
   
   DDRClk,
   nDDRClk,
   CPUClk,
   BUSClk,
   nBUSClk,
   APBClk,
   BUSClkEn,
   PCLKEn,
   RESET_o,
   RESET_CPU
   );

   parameter CPU2BUSClockRatio = 2;	// 2 or 1
   parameter BUS2APBClockRatio = 1;
   
   parameter ClockDelay = 0.5;
   parameter CombDelay = 1;
   
   input 	 Clock_i;
   input 	 Reset_i;
   input 	 ensrst;
   
   output 	 DDRClk;
   output 	 nDDRClk;
   output 	 CPUClk;
   output 	 BUSClk;
   output 	 nBUSClk;
   output 	 APBClk;
   output 	 BUSClkEn;
   output 	 PCLKEn;
   output 	 RESET_o;
   output 	 RESET_CPU;
   
   //--------------------------------------------------------
   wire      ResetAll;
   
   wire 	 RESET_CPU;
   wire 	 RESET_o;
   

   assign 	 ResetAll = ensrst & Reset_i;
   
assign #0.1 nDDRClk = ~DDRClk;
assign #ClockDelay DDRClk  = Clock_i;
assign #0.1 nBUSClk = ~BUSClk;

reg  BUSClk_reg;


initial BUSClk_reg = 0;

always @(posedge Clock_i) begin
/*  if(!ResetAll)
	BUSClk_reg <= Clock_i;
  else*/
	BUSClk_reg <= ~BUSClk_reg;
end // always


assign #ClockDelay BUSClk = BUSClk_reg;
assign #CombDelay BUSClkEn = (CPU2BUSClockRatio == 1) ? 1'b1 : ~BUSClk_reg;
//   assign 		  BUSClkEn = BUSClk;
      
assign #ClockDelay CPUClk = (CPU2BUSClockRatio == 2) ? Clock_i : BUSClk_reg;
//   assign 		  CPUClk = ~Clock_i;
   
   

reg  [31:0] APBClk_cnt;
reg         APBClk_div;

always @(posedge BUSClk_reg or negedge ResetAll)
begin
	if(!ResetAll)
	begin
		APBClk_cnt <= {32{1'b0}};
		APBClk_div <= 1'b0;
	end
	else
	begin
		if(APBClk_cnt == 0) APBClk_cnt <= (BUS2APBClockRatio - 1);
		else APBClk_cnt <= APBClk_cnt - 1;

		if(APBClk_cnt < (BUS2APBClockRatio>>1)) APBClk_div <= 1'b0;
		else APBClk_div <= 1'b1;
	end
end

assign #(2*CombDelay) PCLKEn = (APBClk_cnt == 0);

assign #ClockDelay APBClk = (BUS2APBClockRatio == 1) ? BUSClk_reg : APBClk_div;

   reg [15:0] 	   reset_dly;

   always@(negedge Clock_i or negedge ResetAll) begin
	  if(!ResetAll)
		reset_dly <= {16{1'b0}};
	  else reset_dly <= {reset_dly[14:0],1'b1};
   end // always
   
   
   assign RESET_o = reset_dly[12];
   assign RESET_CPU = reset_dly[15];

endmodule
