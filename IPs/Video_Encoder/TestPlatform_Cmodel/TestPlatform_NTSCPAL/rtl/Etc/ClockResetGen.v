
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

`timescale 1ns/10ps
module ClockResetGen (
	Clock_i,
	Reset_i,
	
	DDRClk,
	nDDRClk,
	CPUClk,
	BUSClk,
	nBUSClk,
	APBClk,
	BUSClkEn,
	PCLKEn,
	RESET_o
);

parameter CPU2BUSClockRatio = 1;	// 2 or 1
parameter BUS2APBClockRatio = 1;

parameter ClockDelay = 0.5;
parameter CombDelay = 1;

input  Clock_i;
input  Reset_i;
output DDRClk;
output nDDRClk;
output CPUClk;
output BUSClk;
output nBUSClk;
output APBClk;
output BUSClkEn;
output PCLKEn;
output RESET_o;

assign #0.1 nDDRClk = ~DDRClk;
assign #ClockDelay DDRClk  = Clock_i;
assign #0.1 nBUSClk = ~BUSClk;

reg BUSClk_reg;

initial BUSClk_reg = 0;

always @(posedge Clock_i)
	BUSClk_reg <= ~BUSClk_reg;

assign #ClockDelay BUSClk = BUSClk_reg;

assign #ClockDelay CPUClk = (CPU2BUSClockRatio == 2) ? Clock_i : BUSClk_reg;
assign #CombDelay BUSClkEn = (CPU2BUSClockRatio == 1) ? 1'b1 : (BUSClk_reg == 0);

reg  [31:0] APBClk_cnt;
reg         APBClk_div;

always @(posedge BUSClk_reg or negedge Reset_i)
begin
	if(!Reset_i)
	begin
		APBClk_cnt <= 0;
		APBClk_div <= 0;
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

// Reset : No intend for synthesis !!!
assign RESET_o = Reset_i;

endmodule
