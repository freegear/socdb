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

//Test EN_DAC2 == 1'b0;

module VideoCore
(

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

    DAC0_DATA,
    DAC1_DATA,
    DAC2_DATA,

    F_COUNTER_INTER,
    H_COUNTER_INTER,
    V_COUNTER_INTER
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

//wire   [7:0] BRIGHT_LEV = 8'b11111111;
//wire   [7:0] BRIGHT_LEV = 8'd0;
wire  ENABLE_PIXEL;
wire   [7:0]   Rout;
wire   [7:0]   Gout;
wire   [7:0]   Bout;

wire   [7:0]   Rgen;
wire   [7:0]   Ggen;
wire   [7:0]   Bgen;

wire  ACT_DISPLAY_SYN;
wire  ACT_DISPLAY_ADDR;
wire  ACT_DISPLAY_INTER;
wire  HSYNC_ENABLE;
wire  BURST_ENABLE;
wire  BURST_ENABLE_ADDR;
wire  RESET_ADDR;
wire  BURST_ID;
wire  NTSC_PAL;
wire  BURST_NTSC_PAL;

wire [9:0] YFilter;
wire [9:0] UFilter;
wire [9:0] VFilter;

wire [9:0] Filtered_Y;
wire [9:0] Filtered_U;
wire [9:0] Filtered_V;

wire [10:0] SIN;
wire [10:0] COS;

assign	DAC0_ENABLE = EN_DAC0;
assign  DAC1_ENABLE = EN_DAC1;
assign  DAC2_ENABLE = EN_DAC2;

VideoEncInterace VideoEncInput
(

	.CLK(CLK),
	.RESETn(RESETn),
    //input signal
    //.HSYNCn(HSYNCn),
    //.VSYNCn(VSYNCn),
    .BLANKn(BLANKn),
    .Rin(Rin),
    .Gin(Gin),
    .Bin(Bin),

    //output signal
    //.ENABLE_PIXEL(ENABLE_PIXEL),
    .ACT_DISPLAY_INTER(ACT_DISPLAY_INTER),
    .Rout(Rout),
    .Gout(Gout),
    .Bout(Bout)

    //setting signal
    /* not used slave mode */
    /* **************************
    H_COUNTER,
    V_COUNTER.
    RISING_F_DELAY,
    FALLING_F_DELAY
    ***************************** */
    
);

VideoTimingGen TimingGen
(
    //Interface signal 
    .CLK(CLK),       // 27Mhz clock input
    .RESETn(RESETn),
    .HSYNCn(HSYNCn),
    .VSYNCn(VSYNCn),

    //Setting Signal input
    .ENABLE(ENABLE),
    .EN_SQPIXEL(EN_SQPIXEL),
    .EN_NONINTERLACE(EN_NONINTERLACE),
    .EN_INTERNAL_PATTERN(EN_INTERNAL_PATTERN),

    .OUT_MODE(MODE),

    .BURST_WID(BURST_WID),
    .HSYNC_WID(HSYNC_WID),

    .MASTER_SLAVE_SEL(1'b1), //1--> slave mode
    .INTERMODE_SEL(2'd0),

    //Control output
    .ACT_DISPLAY_SYN(ACT_DISPLAY_SYN),
    .ACT_DISPLAY_ADDR(ACT_DISPLAY_ADDR),
    .ACT_DISPLAY_INTER(ACT_DISPLAY_INTER),
    .F_COUNTER_INTER(F_COUNTER_INTER),
    .H_COUNTER_INTER(H_COUNTER_INTER),
    .V_COUNTER_INTER(V_COUNTER_INTER),
    .HSYNC_ENABLE(HSYNC_ENABLE),
    .BURST_ENABLE(BURST_ENABLE),
    .BURST_ENABLE_ADDR(BURST_ENABLE_ADDR),
    .RESET_ADDR(RESET_ADDR),
    .BURST_ID(BURST_ID),
    .NTSC_PAL(NTSC_PAL),
    .BURST_NTSC_PAL(BURST_NTSC_PAL)
);

VideoEncColorGen ColorGen
(
    .CLK(CLK),
    .RESETn(RESETn),

    .ACT_DISPLAY_INTER(ACT_DISPLAY_INTER),
    .COLOR_PATTERN_MODE(COLOR_PATTERN_MODE),
    .EN_SQPIXEL(EN_SQPIXEL),
    .NTSC_PAL(NTSC_PAL),
    //.EN_INTERNAL_PATTERN(EN_INTERNAL_PATTERN), TEST remove
    .EN_INTERNAL_PATTERN(1'b1),

    .Rgen(Rgen),
    .Ggen(Ggen),
    .Bgen(Bgen)
);


VideoEncRGB2YUV RGB2YUV
(
    //.CLK(CLK),       // 27Mhz clock input
    //.RESETn(RESETn),

    //Input
	//.EN_DAC2(EN_DAC2), //TEST next remove
    .EN_INTERNAL_PATTERN(EN_INTERNAL_PATTERN),
    .Rin(Rout),
    .Gin(Gout),
    .Bin(Bout),

    .Rgen(Rgen),
    .Ggen(Ggen),
    .Bgen(Bgen),

    .OUT_MODE(MODE),

    //Output
    .Y(YFilter),
    .U(UFilter),
    .V(VFilter)
);

VideoEncSubAddrGen SubAddrGen(
    .CLK(CLK),
    .RESETn(RESETn),

    //Input
    .SUB_REQ(SUB_REQ),
    .SUB_PHASE(SUB_PHASE),
    .OUT_MODE(MODE),
    .EN_RESET_SCH(EN_RESET_SCH),
    .HUE_LEV(HUE_LEV),

    .ACT_DISPLAY_SYN(ACT_DISPLAY_ADDR),
    .BURST_ENABLE(BURST_ENABLE_ADDR),
    .RESET_ADDR(RESET_ADDR),
    .BURST_ID(BURST_ID),

    //Output
    .COS(COS),
    .SIN(SIN)
);


VideoEncYLowFilter YLowFilter (
    .CLK(CLK), 
    .RESETn(RESETn), 
    .LUMA_FILTER_SEL(LUMA_FILTER_SEL), 
    .DATAIN(YFilter), 
    .DATAOUT(Filtered_Y)
);

VideoEncCLowFilter ULowFilter(
    .CLK(CLK), 
    .RESETn(RESETn), 
    .LUMA_FILTER_SEL(LUMA_FILTER_SEL), 
    .CHRO_FILTER_SEL(CHRO_FILTER_SEL), 
    .DATAIN(UFilter), 
    .DATAOUT(Filtered_U )
);

VideoEncCLowFilter VLowFilter(
    .CLK(CLK), 
    .RESETn(RESETn), 
    .LUMA_FILTER_SEL(LUMA_FILTER_SEL), 
    .CHRO_FILTER_SEL(CHRO_FILTER_SEL), 
    .DATAIN(VFilter), 
    .DATAOUT(Filtered_V)
);


VideoEncSynthesizer SyntheSizer(

    .CLK(CLK),
    .RESETn(RESETn),

    //input
    .HSYNC_ENABLE(HSYNC_ENABLE),
    .BURST_ENABLE(BURST_ENABLE),
    .ACT_DISPLAY_SYN(ACT_DISPLAY_SYN),
    .EN_COLOR_KILL(EN_COLOR_KILL),
    .Filtered_Y(Filtered_Y),
    .Filtered_U(Filtered_U),
    .Filtered_V(Filtered_V),
    .CHRO_DELAY(CHRO_DELAY),
    .LUMA_DELAY(LUMA_DELAY),
    .NTSC_PAL(NTSC_PAL),
    .BURST_NTSC_PAL(BURST_NTSC_PAL),
    .OUT_MODE(MODE),
    .BURST_ID(BURST_ID),
    .SATURATION_YLEV(SATURATION_YLEV),
    .SATURATION_CLEV(SATURATION_CLEV),
    .SIN(SIN),
    .COS(COS),

    .RESET_ADDR(RESET_ADDR),
    .BRIGHT_LEV(BRIGHT_LEV),
    .BURST_STEP(BURST_STEP),
    .BURST_CAL(BURST_CAL),
    .BLACK_VALUE(BLACK_VALUE),
    .BLANK_VALUE(BLANK_VALUE),
    .HSYNC_STEP(HSYNC_STEP),

	.ENABLE(ENABLE),
    .EN_DAC0(EN_DAC0),
    .EN_DAC1(EN_DAC1),
    .EN_DAC2(EN_DAC2),


    //output
    .Composite2DAC0(DAC0_DATA),
    .Y2DAC1(DAC1_DATA),
    .C2DAC2(DAC2_DATA)

);
endmodule
