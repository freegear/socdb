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
// Purpose            : This module is luminance low pass filter
// =======================================================================
`timescale 1ns / 10ps

module VideoEncYLowFilter (CLK, 
              RESETn, 
              LUMA_FILTER_SEL, 
              DATAIN, 
              DATAOUT);
   input CLK; 
   input RESETn; 
   input[1:0] LUMA_FILTER_SEL; 
   input[9:0] DATAIN; 
   output[9:0] DATAOUT; 

// =======================================================================
// Wire & Reg assign 
// -----------------------------------------------------------------------

reg[9:0] rDATAOUT; 
reg[9:0] DATAOUT; 
reg rSIG;

wire [9:0] OvDATA;

wire [22:0] NTSCDoutY;
wire [20:0] PALDoutY;

wire [20:0] NTSCDoutY_N0;
//wire [20:0] NTSCDoutY_N1;

wire [20:0] PALDoutY_N0;
//wire [19:0] PALDoutY_N1;

wire [10:0] NTSCInY_N1;
wire [10:0] PALInY_N1;

wire EnNTSCY;
wire EnPALY;
wire EnNTSC_No;
wire EnPAL_No;

// =======================================================================
// Output generation
// -----------------------------------------------------------------------

always @(LUMA_FILTER_SEL or
         NTSCDoutY or
         PALDoutY or
         //NTSCDoutY_N1 or
         PALDoutY_N0
        ) begin

    case(LUMA_FILTER_SEL) 
        2'b00: rDATAOUT <= NTSCDoutY[21:10];          
        2'b01: rDATAOUT <= PALDoutY[17:8];        
        //2'b10: rDATAOUT <= NTSCDoutY_N1[17:8];    
        //2'b11: rDATAOUT <= PALDoutY_N1[17:8];     
        2'b10: rDATAOUT <= NTSCDoutY[21:10];    
        2'b11: rDATAOUT <= PALDoutY[17:8];     
    endcase

    case(LUMA_FILTER_SEL) 
        2'b00: rSIG <= NTSCDoutY[22];          
        2'b01: rSIG <= PALDoutY[20];        
        //2'b10: rSIG <= NTSCDoutY_N1[20];    
        //2'b11: rSIG <= PALDoutY_N1[19];     
        2'b10: rSIG <= NTSCDoutY[22];    
        2'b11: rSIG <= PALDoutY[20];     
    endcase

end

assign OvDATA = (rSIG) ? 0:rDATAOUT;

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        DATAOUT <= 0;
    end
    else
    begin
        DATAOUT <= OvDATA;
    end
end

// =======================================================================
// Filter Enable generation
// -----------------------------------------------------------------------

assign EnNTSC_No  = (LUMA_FILTER_SEL == 2'b10) ? 1'b1 : 1'b0;
assign EnPAL_No   = (LUMA_FILTER_SEL == 2'b11) ? 1'b1 : 1'b0;
assign EnNTSCY    = ((LUMA_FILTER_SEL == 2'b00) || EnNTSC_No) ? 1'b1 : 1'b0; 
assign EnPALY     = ((LUMA_FILTER_SEL == 2'b01) || EnPAL_No ) ? 1'b1 : 1'b0;

assign NTSCInY_N1 = (EnNTSC_No) ? {NTSCDoutY_N0[20], NTSCDoutY_N0[17:8]} : {1'b0, DATAIN[9:0]};
assign PALInY_N1  = (EnPAL_No)  ? {PALDoutY_N0[20],  PALDoutY_N0[17:8]} : {1'b0, DATAIN[9:0]};

// =======================================================================
// Low pass filter
// -----------------------------------------------------------------------

NTSC_YFilter NTSC_YFilter  (
            .CLK(CLK),
            .CLK_EN(EnNTSCY),
            //.CLK_EN(1'b1),
            //.DataIn({1'b0, DATAIN[9:0]}),
            .DataIn(NTSCInY_N1),
            .DOut(NTSCDoutY)
);

PAL_YFilter PAL_YFilter  (
            .CLK(CLK),
            .CLK_EN(EnPALY),
            //.CLK_EN(1'b1),
            //.DataIn({1'b0, DATAIN[9:0]}),
            .DataIn(PALInY_N1),
            .DOut(PALDoutY)
);

NTSC_N0 NTSC_N0 (
            .CLK(CLK),
            .CLK_EN(EnNTSC_No),
            //.CLK_EN(1'b1),
            .DataIn({1'b0, DATAIN[9:0]}),
            .DOut(NTSCDoutY_N0)
);

PAL_N0 PAL_N0 (
            .CLK(CLK),
            .CLK_EN(EnPAL_No),
            //.CLK_EN(1'b1),
            .DataIn({1'b0, DATAIN[9:0]}),
            .DOut(PALDoutY_N0)
);

/*
NTSC_N1 NTSC_N1 (
            .CLK(CLK),
            .CLK_EN(EnNTSC_No),
            //.CLK_EN(1'b1),
            .DataIn(NTSCInY_N1),
            .Dout(NTSCDoutY_N1)
);

PAL_N1 PAL_N1 (
            .CLK(CLK),
            .CLK_EN(EnPAL_No),
            //.CLK_EN(1'b1),
            .DataIn(PALInY_N1),
            .Dout(PALDoutY_N1)
);
*/

endmodule
