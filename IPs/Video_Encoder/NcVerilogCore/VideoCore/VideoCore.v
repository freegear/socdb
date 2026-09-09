// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : VideoCore.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is Video encoder Core module
// =======================================================================
`timescale 1ns/10ps

module VideoCore
(
// =======================================================================
// -----------------------------------------------------------------------
// Referance Setting value --> Spec. 1.2.2.3.Mode setting value
// NTSC setting value
//
//    бс EN_DAC0 = 1'b1
//    бс EN_DAC1 = 1'b1
//    бс EN_DAC2 = 1'b1
//    бс EN_SQPIXEL = 1'b0
//    бс EN_NONINTERLACE = 1'b0
//    бс EN_RESET_SCH = 1'b1
//    бс EN_INTERNAL_PATTERN = 1'b0
//    бс EN_COLOR_KILL = 1'b0
//    бс COLOR_PATTERN_MODE = 3'b000
//    бс MODE = 3'b000 
//    бс LUMA_FILTER_SEL = 2'00
//    бс CHRO_FILTER_SEL = 2'b00
//    бс CHRO_DELAY = 3'b000
//    бс LUMA_DELAY  = 3'b000
//    бс BURST_WID = 2'b01
//    бс HSYNC_WID = 3'b010
//    бс SUB_PHASE = 16'd0 
//    бс SUB_REQ = 32'h21F07C1F 
//
//    бс SATURATION_YLEV = 8'd144
//    бс SATURATION_CLEV = 8'd144
//    бс HUE_LEV = 8'd0
//    бс BURST_STEP = 5'd14
//    бс BURST_CAL = 8'd128
//    бс BLACK_VALUE = 10'd282
//    бс BLANK_VALUE = 10'd240
//    бс HSYNC_STEP = 8'd200
//    бс BRIGHT_LEV = 6'd0
//
//    бс ENABLE = 1'b1

// PAL setting value
//    бс EN_DAC0 = 1'b1
//    бс EN_DAC1 = 1'b1
//    бс EN_DAC2 = 1'b1
//    бс EN_SQPIXEL = 1'b0
//    бс EN_NONINTERLACE = 1'b0
//    бс EN_RESET_SCH = 1'b1
//    бс EN_INTERNAL_PATTERN = 1'b0
//    бс EN_COLOR_KILL = 1'b0
//    бс COLOR_PATTERN_MODE = 3'b000
//    бс MODE = 3'b100 
//    бс LUMA_FILTER_SEL = 2'00
//    бс CHRO_FILTER_SEL = 2'b00
//    бс CHRO_DELAY = 3'b000
//    бс LUMA_DELAY  = 3'b000
//    бс BURST_WID = 2'b01
//    бс HSYNC_WID = 3'b010
//    бс SUB_PHASE = 16'd0 
//    бс SUB_REQ = 32'h2A098ACB
//
//    бс SATURATION_YLEV = 8'd136
//    бс SATURATION_CLEV = 8'd136
//    бс HUE_LEV = 8'd0
//    бс BURST_STEP = 5'd15
//    бс BURST_CAL = 8'd128
//    бс BLACK_VALUE = 10'd252
//    бс BLANK_VALUE = 10'd252
//    бс HSYNC_STEP = 8'd222
//    бс BRIGHT_LEV = 6'd0
//
//    бс ENABLE = 1'b1

// -----------------------------------------------------------------------
// =======================================================================

// input
    CLK,       // 27Mhz clock input
    RESETn,
    HSYNCn,
    VSYNCn,
    BLANKn,
    Rin,
    Gin,
    Bin,

// Setting input
    ENABLE,
    EN_DAC0,
    EN_DAC1,
    EN_DAC2,
    EN_SQPIXEL,
    EN_NONINTERLACE,
    EN_RESET_SCH,
    EN_INTERNAL_PATTERN,
    EN_COLOR_KILL,
    COLOR_PATTERN_MODE,

    MODE,

    LUMA_FILTER_SEL,
    CHRO_FILTER_SEL,
    CHRO_DELAY,
    LUMA_DELAY,
    BURST_WID,
    HSYNC_WID,

    SUB_PHASE,
    SUB_REQ,

    SATURATION_YLEV,
    SATURATION_CLEV,
    HUE_LEV,
    BURST_STEP,
    BURST_CAL,
    BLACK_VALUE,
    BLANK_VALUE,
    HSYNC_STEP,
    BRIGHT_LEV,

// output
    DAC0_ENABLE,
    DAC1_ENABLE,
    DAC2_ENABLE,

    DAC0_DATA, //Composite output
    DAC1_DATA, //Luminance S-Video output
    DAC2_DATA, //Chrominance S-Video output

    F_COUNTER_INTER, //Field counter
    H_COUNTER_INTER, //Hsync counter
    V_COUNTER_INTER  //Vsync counter
);

//Input ///////////////////////
input   CLK; //27Mhz Clock
input   RESETn;
input   HSYNCn;
input   VSYNCn;
input   BLANKn;

input   [7:0]   Rin;
input   [7:0]   Gin;
input   [7:0]   Bin;

//Output //////////////////////
output  [9:0]   DAC0_DATA;
output  [9:0]   DAC1_DATA;
output  [9:0]   DAC2_DATA;

output  DAC0_ENABLE;
output  DAC1_ENABLE;
output  DAC2_ENABLE;

output  [4:0]   F_COUNTER_INTER;
output  [10:0]  H_COUNTER_INTER;
output  [9:0]   V_COUNTER_INTER;

/* Setting input */
input  ENABLE;
input  EN_DAC0;
input  EN_DAC1;
input  EN_DAC2;
input  EN_SQPIXEL;
input  EN_NONINTERLACE;
input  EN_RESET_SCH;
input  EN_INTERNAL_PATTERN;
input  EN_COLOR_KILL;
input  [2:0]   COLOR_PATTERN_MODE;

input  [2:0]   MODE;

input  [1:0]   LUMA_FILTER_SEL;
input  [1:0]   CHRO_FILTER_SEL;
input  [2:0]   CHRO_DELAY;
input  [2:0]   LUMA_DELAY;
input  [1:0]   BURST_WID;
input  [2:0]   HSYNC_WID;

input  [15:0]  SUB_PHASE;
input  [31:0]  SUB_REQ;

input [7:0] SATURATION_YLEV ;
input [7:0] SATURATION_CLEV ;
input [7:0] HUE_LEV ;
input [4:0] BURST_STEP ;
input [7:0] BURST_CAL;
input [9:0] BLACK_VALUE ;
input [9:0] BLANK_VALUE ;
input [7:0] HSYNC_STEP   ;
input [5:0] BRIGHT_LEV  ;

endmodule
