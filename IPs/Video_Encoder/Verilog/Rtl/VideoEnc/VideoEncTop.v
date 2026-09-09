// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : VideoEncTop.v
// File Revision       : 0.1
// -------------------------------------------------------------------
// Purpose            : This module is Video encoder top module
// ===================================================================

// Added Output control regster Feb.15.2007
`timescale 1ns/10ps

module VideoEncTop
(
//  APB bus
    PCLK     ,
    RESETn  ,

    PENABLE  , 
    PSEL     , 
    PWRITE   , 
    PADDR    ,  //[5:2]  used
    PWDATA   ,  //[31:0] used
    PRDATA   ,  //[31:0] used

//input
    CLK,       // 27Mhz clock input
    HSYNCn,
    VSYNCn,
    BLANKn,
    Rin,
    Gin,
    Bin,

//output
    DAC0_ENABLE,
    DAC1_ENABLE,
    DAC2_ENABLE,

    DAC0_DATA,
    DAC1_DATA,
    DAC2_DATA

);

//APB bus//////////////////////
input   PCLK;
input   RESETn;

input	[5:2]	PADDR;
input	[31:0]	PWDATA;
input	PSEL;
input	PWRITE;
input	PENABLE;

output	[31:0]	PRDATA;

//Input ///////////////////////
input   CLK; //27Mhz Clock
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

//Connection wire /////////////

wire [5:0] BRIGHT_LEV;
wire [7:0] SATURATION_YLEV;
wire [7:0] SATURATION_CLEV;
wire [7:0] HUE_LEV;

wire [2:0] BURST_LEV;
wire [9:0] BLACK_VALUE;
wire [9:0] BLANK_VALUE;
wire [4:0] HSYNC_LOW;

//Setting//////////////////////

wire  [4:0]   F_COUNTER_INTER;
wire  [10:0]  H_COUNTER_INTER;
wire  [9:0]   V_COUNTER_INTER;

wire  ENABLE;
wire  EN_DAC0;
wire  EN_DAC1;
wire  EN_DAC2;
wire  EN_SQPIXEL;
wire  EN_NONINTERLACE;
wire  EN_RESET_SCH;
wire  EN_INTERNAL_PATTERN;
wire  EN_COLOR_KILL;
wire  [2:0]   COLOR_PATTERN_MODE;

wire  [2:0]   MODE;

wire  [1:0]   LUMA_FILTER_SEL;
wire  [1:0]   CHRO_FILTER_SEL;
wire  [2:0]   CHRO_DELAY;
wire  [2:0]   LUMA_DELAY;
wire  [1:0]   BURST_WID;
wire  [2:0]   HSYNC_WID;

wire  [15:0]  SUB_PHASE;
wire  [31:0]  SUB_REQ;

wire  OUT_ENABLE;
wire  OUT_16BIT;
wire  INV_CbCr;
wire  INV_FIELD;
wire  INV_BLANK;
wire  INV_HSYNC;



//APB interface block
VideoEncAPBinterace  VideoEncAPB
(

//  APB bus
    .PCLK     (PCLK     ),
    .RESETn  (RESETn  ),

    .PENABLE  (PENABLE  ), 
    .PSEL     (PSEL     ), 
    .PWRITE   (PWRITE   ), 
    .PADDR    (PADDR    ),  //[5:2]  used
    .PWDATA   (PWDATA   ),  //[31:0] used
    .PRDATA   (PRDATA   ),  //[31:0] used


//input

    .CLK(CLK),       // 27Mhz clock input

    .FIELD_CNT({3'd0,F_COUNTER_INTER}),
    .H_CNT(H_COUNTER_INTER),
    .V_CNT(V_COUNTER_INTER),

//Register setting value output 
    .ENABLE(ENABLE),
    .EN_DAC0(EN_DAC0),
    .EN_DAC1(EN_DAC1),
    .EN_DAC2(EN_DAC2),
    .EN_SQPIXEL(EN_SQPIXEL),
    .EN_NONINTERLACE(EN_NONINTERLACE),
    .EN_RESET_SCH(EN_RESET_SCH),
    .EN_INTERNAL_PATTERN(EN_INTERNAL_PATTERN),
    .EN_COLOR_KILL(EN_COLOR_KILL),
    .COLOR_PATTERN_MODE(COLOR_PATTERN_MODE),

    .OUT_MODE(MODE),

    .OUT_ENABLE(OUT_ENABLE),
    .OUT_16BIT(OUT_16BIT),
    .INV_CbCr(INV_CbCr),
    .INV_FIELD(INV_FIELD),
    .INV_BLANK(INV_BLANK),
    .INV_HSYNC(INV_HSYNC),

    .LUMA_FILTER_SEL(LUMA_FILTER_SEL),
    .CHRO_FILTER_SEL(CHRO_FILTER_SEL),
    .CHRO_DELAY(CHRO_DELAY),
    .LUMA_DELAY(LUMA_DELAY),
    .BURST_WID(BURST_WID),
    .HSYNC_WID(HSYNC_WID),

    .SUB_PHASE(SUB_PHASE),
    .SUB_REQ(SUB_REQ),

    .SATURATION_YLEV(SATURATION_YLEV),
    .SATURATION_CLEV(SATURATION_CLEV),
    .HUE_LEV(HUE_LEV),
    .BURST_LEV(BURST_LEV),
    .BLACK_VALUE(BLACK_VALUE),
    .BLANK_VALUE(BLANK_VALUE),
    .BRIGHT_LEV(BRIGHT_LEV),
    .HSYNC_LOW(HSYNC_LOW)

);



VideoCore Core
(

//input
    .CLK(CLK),       // 27Mhz clock input
    .RESETn(RESETn),
    .HSYNCn(HSYNCn),
    .VSYNCn(VSYNCn),
    .BLANKn(BLANKn),
    .Rin(Rin),
    .Gin(Gin),
    .Bin(Bin),

// Setting input
    .ENABLE(ENABLE),
    .EN_DAC0(EN_DAC0),
    .EN_DAC1(EN_DAC1),
    .EN_DAC2(EN_DAC2),
    .EN_SQPIXEL(EN_SQPIXEL),
    .EN_NONINTERLACE(EN_NONINTERLACE),
    .EN_RESET_SCH(EN_RESET_SCH),
    .EN_INTERNAL_PATTERN(EN_INTERNAL_PATTERN),
    .EN_COLOR_KILL(EN_COLOR_KILL),
    .COLOR_PATTERN_MODE(COLOR_PATTERN_MODE),

    .MODE(MODE),

    .LUMA_FILTER_SEL(LUMA_FILTER_SEL),
    .CHRO_FILTER_SEL(CHRO_FILTER_SEL),
    .CHRO_DELAY(CHRO_DELAY),
    .LUMA_DELAY(LUMA_DELAY),
    .BURST_WID(BURST_WID),
    .HSYNC_WID(HSYNC_WID),

    .SUB_PHASE(SUB_PHASE),
    .SUB_REQ(SUB_REQ),

    .SATURATION_YLEV(SATURATION_YLEV),
    .SATURATION_CLEV(SATURATION_CLEV),
    .HUE_LEV(HUE_LEV),
    .BURST_LEV(BURST_LEV),
    .BLACK_VALUE(BLACK_VALUE),
    .BLANK_VALUE(BLANK_VALUE),
    .HSYNC_LOW(HSYNC_LOW),
    .BRIGHT_LEV(BRIGHT_LEV),

//output
    .DAC0_ENABLE(DAC0_ENABLE),
    .DAC1_ENABLE(DAC1_ENABLE),
    .DAC2_ENABLE(DAC2_ENABLE),

    .DAC0_DATA(DAC0_DATA),
    .DAC1_DATA(DAC1_DATA),
    .DAC2_DATA(DAC2_DATA),

    .F_COUNTER_INTER(F_COUNTER_INTER),
    .H_COUNTER_INTER(H_COUNTER_INTER),
    .V_COUNTER_INTER(V_COUNTER_INTER)


);

endmodule
