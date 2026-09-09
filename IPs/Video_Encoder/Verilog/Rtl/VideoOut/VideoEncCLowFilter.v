// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : VideoEncCLowFilter.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is chrominance low pass 
// =======================================================================
// Not Vhdl filter

`timescale 1ns / 10ps
module VideoEncCLowFilter
			 (CLK, 
              RESETn, 
              CHRO_FILTER_SEL, 
              DATAIN, 
              DATAOUT);
   
   input CLK; 
   input RESETn; 
   input [1:0] CHRO_FILTER_SEL; 
   input [9:0] DATAIN; 
   output[9:0] DATAOUT; 
   
// =======================================================================
// Wire & Reg assign 
// -----------------------------------------------------------------------

wire    [9:0]  Dout;
reg     [9:0]  DIN_0d;
reg     [9:0]  DIN_1d;
reg     [9:0]  DIN_2d;
reg     [9:0]  DIN_3d;
wire    [9:0]  FilterIn;

// =======================================================================
// Filter Enable generation
// -----------------------------------------------------------------------
//assign DATAOUT = (CHRO_FILTER_SEL[1] == 1'b0) ? DOUT_8d : DOUT_6d;
//assign FilterIn = (CHRO_FILTER_SEL[1] == 1'b1) ? DIN_1d : DATAIN;
assign DATAOUT  = Dout;
assign FilterIn = (CHRO_FILTER_SEL[1] == 1'b1) ? DIN_0d : DIN_3d;


always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        DIN_0d <= 0;
        DIN_1d <= 0;
        DIN_2d <= 0;
        DIN_3d <= 0;
    end
    else begin
        DIN_0d <= DATAIN;
        DIN_1d <= DIN_0d;
        DIN_2d <= DIN_1d;
        DIN_3d <= DIN_2d;
    end
end

// =======================================================================
// Low pass filter
// -----------------------------------------------------------------------

CFILTERCore CFILTERCore(
    .CLK(CLK),
    .RESETn(RESETn),

    .FilterSel(CHRO_FILTER_SEL[1]), //0 --> 13.5  1--> 0.67
    .DataIn(FilterIn),
    .DataOut(Dout)
    );

// -----------------------------------------------------------------------
endmodule
