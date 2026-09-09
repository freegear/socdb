// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : 
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is luminance low pass filter
// =======================================================================
`timescale 1ns / 10ps

module VideoEncYLowFilter (CLK, 
              RESETn, 
              CHRO_FILTER_SEL,
              LUMA_FILTER_SEL, 
              DATAIN, 
              DATAOUT);
   input CLK; 
   input RESETn; 
   input [1:0] LUMA_FILTER_SEL; 
   input [1:0] CHRO_FILTER_SEL;
   input [9:0] DATAIN; 
   output[9:0] DATAOUT; 

// =======================================================================
// Wire & Reg assign 
// -----------------------------------------------------------------------

reg[9:0] rDATAOUT; 
reg[9:0] DATAOUT; 

wire [11:0] NTSCDoutY;
wire [9:0]  PASSDATA;
wire [9:0]  OvDATA;

reg  [9:0]  Delay0;
reg  [9:0]  Delay1;
reg  [9:0]  Delay2;

reg  [9:0] FilterIn;
// =======================================================================
// Output generation
// -----------------------------------------------------------------------

assign OvDATA = (NTSCDoutY[10]) ? 0 : NTSCDoutY[9:0];

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) DATAOUT <= 0;
    else        DATAOUT <= OvDATA;
end


always @(CHRO_FILTER_SEL, Delay2, DATAIN, LUMA_FILTER_SEL) begin

    if(CHRO_FILTER_SEL[1] & !LUMA_FILTER_SEL[1] & LUMA_FILTER_SEL[0]) begin
        FilterIn = Delay2;
    end
    else if(CHRO_FILTER_SEL[1] & LUMA_FILTER_SEL[1] & !LUMA_FILTER_SEL[0]) begin
        FilterIn = Delay2;
    end
    else begin
        FilterIn = DATAIN;
    end

end

// =======================================================================
// Low pass filter
// -----------------------------------------------------------------------
LuFILTERCore  LuFILTERCore(

                .CLK(CLK),
                .RESETn(RESETn),

                .FilterSel(LUMA_FILTER_SEL), //01 --> NTSC notch  10 --> PAL notch
                .DataIn(PASSDATA),
                .DataOut(NTSCDoutY)
       );

NotchFILTERCore NotchFILTERCore(

                .CLK(CLK),
                .RESETn(RESETn),

                .YFilterSel(LUMA_FILTER_SEL), //01 --> NTSC notch  10 --> PAL notch
                .CFilterSel(CHRO_FILTER_SEL), 
                .DataIn(FilterIn),
                .DataOut(PASSDATA)
       );

// =======================================================================
// Low pass filter
// -----------------------------------------------------------------------
always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        Delay0 <= 0;
        Delay1 <= 0;
        Delay2 <= 0;
    end
    else begin

        Delay0 <= DATAIN ;
        Delay1 <= Delay0 ;
        Delay2 <= Delay1;
    end
end

endmodule
