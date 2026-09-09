// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : HDCCore.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is Core block in HD-Components 
// =======================================================================

module HDCCore(

    //Interface signal 
    CLK,       // 27Mhz or 74.25Mhz clock input
    RESETn,
    HSYNCn,
    VSYNCn,
    BLANKn,

    //Setting Signal input
    HD_ENABLE,
    HD_MODE,
    EN_INTERNAL_PATTERN,
    EnSYNC_PbPr,
    LUMA_AMP,
    Pr_AMP,
    Pb_AMP,

    EnDAC0,
    EnDAC1,
    EnDAC2,

    YH0to1_1,
    YH0to1_2,
    YH0to1_3,
    YH0to2_1,
    YH0to2_2,
    YH0to2_3,
    YH2to1_1,
    YH2to1_2,
    YH2to1_3,

    YLevel00,
    YLevel01,
    YLevel02,

    PH0to1_1,
    PH0to1_2,
    PH0to1_3,
    PH0to2_1,
    PH0to2_2,
    PH0to2_3,
    PH2to1_1,
    PH2to1_2,
    PH2to1_3,

    PLevel00,
    PLevel01,
    PLevel02,

    H1, 
    H2,
    H3,
    H4,
    H5,
    H6,
    H7,
    H8,
    H9,
    H10,

    ACT_DISPLAY,

    YRpara,
    YGpara,
    YBpara,

    PbRpara,
    PbGpara,
    PbBpara,

    PrRpara,
    PrGpara,
    PrBpara,

    Rin,
    Gin,
    Bin,

    DAC0_Luminace,
    DAC1_Pb,
    DAC2_Pr
    );

// =======================================================================
// Input & Ouput define
// -----------------------------------------------------------------------
input  CLK;
input  RESETn;
input  HSYNCn;
input  VSYNCn;
input  BLANKn;

input  HD_ENABLE;
input  EN_INTERNAL_PATTERN;
input  [1:0] HD_MODE;
input  EnSYNC_PbPr;

input EnDAC0;
input EnDAC1;
input EnDAC2;

input [7:0] LUMA_AMP;
input [7:0] Pb_AMP;
input [7:0] Pr_AMP;

input  [11:0] H1;
input  [11:0] H2;
input  [11:0] H3;
input  [11:0] H4;
input  [11:0] H5;
input  [11:0] H6;
input  [11:0] H7;
input  [11:0] H8;
input  [11:0] H9;
input  [11:0] H10;
input  [11:0] ACT_DISPLAY;

input [9:0] YRpara; 
input [9:0] YGpara; 
input [9:0] YBpara; 
                   
input [9:0] PbRpara; 
input [9:0] PbGpara; 
input [9:0] PbBpara; 
                   
input [9:0] PrRpara; 
input [9:0] PrGpara; 
input [9:0] PrBpara; 

input [7:0] Rin;
input [7:0] Gin;
input [7:0] Bin;

input [9:0] YH0to1_1;
input [9:0] YH0to1_2;
input [9:0] YH0to1_3;
input [9:0] YH0to2_1;
input [9:0] YH0to2_2;
input [9:0] YH0to2_3;
input [9:0] YH2to1_1;
input [9:0] YH2to1_2;
input [9:0] YH2to1_3;

input [9:0] YLevel00;
input [9:0] YLevel01;
input [9:0] YLevel02;

input [9:0] PH0to1_1;
input [9:0] PH0to1_2;
input [9:0] PH0to1_3;
input [9:0] PH0to2_1;
input [9:0] PH0to2_2;
input [9:0] PH0to2_3;
input [9:0] PH2to1_1;
input [9:0] PH2to1_2;
input [9:0] PH2to1_3;

input [9:0] PLevel00;
input [9:0] PLevel01;
input [9:0] PLevel02;

output [9:0] DAC0_Luminace;
output [9:0] DAC1_Pb;
output [9:0] DAC2_Pr;


wire [1:0] OUT_LEVEL;
wire       ACT_DISPLAY_SYN;
wire [9:0] Y;
wire [9:0] Pb;
wire [9:0] Pr;

wire [7:0] Rgen;
wire [7:0] Ggen;
wire [7:0] Bgen;

// =======================================================================
//  RGB 2 YPbPr conversion
// -----------------------------------------------------------------------
HDCRGB2YPbPr HDCRGB2YPbPr
(
    .CLK(CLK),       
    .RESETn(RESETn),

    //Input
    .EN_INTERNAL_PATTERN(EN_INTERNAL_PATTERN),
    .HD_MODE(HD_MODE),
    .BLANKn(BLANKn),

    .YRpara(YRpara),
    .YGpara(YGpara),
    .YBpara(YBpara),

    .PbRpara(PbRpara),
    .PbGpara(PbGpara),
    .PbBpara(PbBpara),

    .PrRpara(PrRpara),
    .PrGpara(PrGpara),
    .PrBpara(PrBpara),

    .Rin(Rin),
    .Gin(Gin),
    .Bin(Bin),

    .Rgen(Rgen),
    .Ggen(Ggen),
    .Bgen(Bgen),

    //Output
    .Y(Y),
    .Pb(Pb),
    .Pr(Pr)
);


// =======================================================================
// Timimg Generation block
// -----------------------------------------------------------------------
HDCTimerGen HDCTimerGen
(
    //Interface signal 
    .CLK(CLK),       // 27Mhz or 74.25Mhz clock input
    .RESETn(RESETn),
    .HSYNCn(HSYNCn),
    .VSYNCn(VSYNCn),

    //Setting Signal input
    .ENABLE(HD_ENABLE),
    .HD_MODE(HD_MODE),
    .EN_INTERNAL_PATTERN(EN_INTERNAL_PATTERN),

    .ACT_DISPLAY(ACT_DISPLAY),
    .H1(H1), 
    .H2(H2), 
    .H3(H3), 
    .H4(H4), 
    .H5(H5), 
    .H6(H6), 
    .H7(H7), 
    .H8(H8), 
    .H9(H9), 
    .H10(H10),

    .OUT_LEVEL(OUT_LEVEL),
    .ACT_DISPLAY_SYN(ACT_DISPLAY_SYN)
);

// =======================================================================
// Colorbar Generation block
// -----------------------------------------------------------------------
HDCColorGen HDCColorGen(
    .CLK(CLK),
    .RESETn(RESETn),

    .ACT_DISPLAY(ACT_DISPLAY_SYN),
    .HD_MODE(HD_MODE),
    .EN_INTERNAL_PATTERN(EN_INTERNAL_PATTERN),

    .Rgen(Rgen),
    .Ggen(Ggen),
    .Bgen(Bgen)
);

// =======================================================================
// Timimg Generation block
// -----------------------------------------------------------------------
HDCOutGen HDCOutGen
(
    //Interface signal 
    .CLK(CLK),       // 27Mhz or 74.25Mhz clock input
    .RESETn(RESETn),

    .HD_MODE(HD_MODE),
    .ENABLE(HD_ENABLE),
    .EnSYNCPbPr(EnSYNC_PbPr),
    .EnDAC0(EnDAC0),
    .EnDAC1(EnDAC1),
    .EnDAC2(EnDAC2),

    .Y(Y),
    .Pb(Pb),
    .Pr(Pr),

    .YH0to1_1(YH0to1_1),
    .YH0to1_2(YH0to1_2),
    .YH0to1_3(YH0to1_3),
    .YH0to2_1(YH0to2_1),
    .YH0to2_2(YH0to2_2),
    .YH0to2_3(YH0to2_3),
    .YH2to1_1(YH2to1_1),
    .YH2to1_2(YH2to1_2),
    .YH2to1_3(YH2to1_3),

    .YLevel00(YLevel00),
    .YLevel01(YLevel01),
    .YLevel02(YLevel02),

    .PH0to1_1(PH0to1_1),
    .PH0to1_2(PH0to1_2),
    .PH0to1_3(PH0to1_3),
    .PH0to2_1(PH0to2_1),
    .PH0to2_2(PH0to2_2),
    .PH0to2_3(PH0to2_3),
    .PH2to1_1(PH2to1_1),
    .PH2to1_2(PH2to1_2),
    .PH2to1_3(PH2to1_3),

    .PLevel00(PLevel00),
    .PLevel01(PLevel01),
    .PLevel02(PLevel02),

    .LUMA_AMP(LUMA_AMP),
    .Pb_AMP(Pb_AMP),
    .Pr_AMP(Pr_AMP),

    .OUT_LEVEL(OUT_LEVEL),
    .ACT_DISPLAY_SYN(ACT_DISPLAY_SYN),

    .DAC0_Luminace(DAC0_Luminace),
    .DAC1_Pb(DAC1_Pb),
    .DAC2_Pr(DAC2_Pr)
);
// -----------------------------------------------------------------------
endmodule
