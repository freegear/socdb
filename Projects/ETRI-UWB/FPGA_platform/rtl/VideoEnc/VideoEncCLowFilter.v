// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : 
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is chrominace low pass 
// =======================================================================

`timescale 1ns / 10ps
module VideoEncCLowFilter
			 (CLK, 
              RESETn, 
              LUMA_FILTER_SEL,
              CHRO_FILTER_SEL, 
              DATAIN, 
              DATAOUT);
   
   input CLK; 
   input RESETn; 
   input[1:0] CHRO_FILTER_SEL; 
   input[1:0] LUMA_FILTER_SEL; 
   input[9:0] DATAIN; 
   output[9:0] DATAOUT; 
   
// =======================================================================
// Wire & Reg assign 
// -----------------------------------------------------------------------

wire    [19:0]  Cr065Dout;
wire    [19:0]  Cr135Dout;
wire    En065;
wire    En135;

reg     [9:0]  DOUT_0d;
reg     [9:0]  DOUT_1d;
reg     [9:0]  DOUT_2d;
reg     [9:0]  DOUT_3d;
reg     [9:0]  DOUT_4d;
reg     [9:0]  DOUT_5d;
reg     [9:0]  DOUT_6d;
reg     [9:0]  DOUT_7d;

// =======================================================================
// Filter Enable generation
// -----------------------------------------------------------------------

assign En065 = (CHRO_FILTER_SEL[1]) ? 1'b0 : 1'b1;
assign En135 = !En065;

assign DATAOUT = (LUMA_FILTER_SEL[1]) ? DOUT_7d : DOUT_2d;

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        DOUT_0d <= 0;
    end
    else begin
        if(En065)   DOUT_0d <= Cr065Dout[17:8];
        else        DOUT_0d <= Cr135Dout[17:8];
    end
end

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        DOUT_1d <= 0;
        DOUT_2d <= 0;
        DOUT_3d <= 0;
        DOUT_4d <= 0;
        DOUT_5d <= 0;
        DOUT_6d <= 0;
        DOUT_7d <= 0;
    end
    else begin
        DOUT_1d <= DOUT_0d;
        DOUT_2d <= DOUT_1d;
        DOUT_3d <= DOUT_2d;
        DOUT_4d <= DOUT_3d;
        DOUT_5d <= DOUT_4d;
        DOUT_6d <= DOUT_5d;
        DOUT_7d <= DOUT_6d;
    end
end



// =======================================================================
// Low pass filter
// -----------------------------------------------------------------------

C065  C065  (
            .CLK(CLK),
            .CLK_EN(En065),
            //.CLK_EN(1'b1),
            .DataIn(DATAIN[9:0]),
            //.DataIn(NTSCInY_N1),
            .DOut(Cr065Dout)
            );

C135  C135  (
            .CLK(CLK),
            .CLK_EN(En135),
            //.CLK_EN(1'b1),
            .DataIn(DATAIN[9:0]),
            //.DataIn(NTSCInY_N1),
            .DOut(Cr135Dout)
            );

endmodule
