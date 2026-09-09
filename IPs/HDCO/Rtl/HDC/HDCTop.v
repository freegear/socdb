// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from Richentech
// ALL RIGHTS RESERVED RichenTech
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : HDCTop.v
// File Revision       : 0.1 (don't apply to chip)
// -------------------------------------------------------------------
// Purpose            : This module is HDCTop 
// ===================================================================

module HDCTop
(
//  APB bus
    PCLK     ,
    RESETn  ,

    PENABLE  , 
    PSEL     , 
    PWRITE   , 
    PADDR    ,  //[7:2]  used
    PWDATA   ,  //[31:0] used
    PRDATA   ,  //[31:0] used

//input
    CLK,       // 27Mhz or 74.25Mhz clock input
    HSYNCn,
    VSYNCn,
    BLANKn,
    Rin,
    Gin,
    Bin,

    DAC0_ENABLE,
    DAC1_ENABLE,
    DAC2_ENABLE,

    DAC0_DATA,
    DAC1_DATA,
    DAC2_DATA,

    //Test platform used 
    HD_MODE
    );

// =======================================================================
// Input & Ouput define
// -----------------------------------------------------------------------
//APB bus//////////////////////
input   PCLK;
input   RESETn;

input	[7:2]	PADDR;
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

output [1:0] HD_MODE;


// =======================================================================
// Wire define
// -----------------------------------------------------------------------

wire HD_ENABLE;
wire EnSYNC_PbPr;
wire [7:0] LUMA_AMP;
wire [7:0] Pr_AMP;
wire [7:0] Pb_AMP;

wire [9:0] YH0to1_1;
wire [9:0] YH0to1_2;
wire [9:0] YH0to1_3;
wire [9:0] YH0to2_1;
wire [9:0] YH0to2_2;
wire [9:0] YH0to2_3;
wire [9:0] YH2to1_1;
wire [9:0] YH2to1_2;
wire [9:0] YH2to1_3;

wire [9:0] YLevel00;
wire [9:0] YLevel01;
wire [9:0] YLevel02;

wire [9:0] PH0to1_1;
wire [9:0] PH0to1_2;
wire [9:0] PH0to1_3;
wire [9:0] PH0to2_1;
wire [9:0] PH0to2_2;
wire [9:0] PH0to2_3;
wire [9:0] PH2to1_1;
wire [9:0] PH2to1_2;
wire [9:0] PH2to1_3;

wire [9:0] PLevel00;
wire [9:0] PLevel01;
wire [9:0] PLevel02;

wire [11:0] ACT_DISPLAY;
wire [11:0] H1;
wire [11:0] H2;
wire [11:0] H3;
wire [11:0] H4;
wire [11:0] H5;
wire [11:0] H6;
wire [11:0] H7;
wire [11:0] H8;
wire [11:0] H9;
wire [11:0] H10;

wire [9:0] YR_para; 
wire [9:0] YG_para; 
wire [9:0] YB_para; 
                   
wire [9:0] PbR_para; 
wire [9:0] PbG_para; 
wire [9:0] PbB_para; 
                   
wire [9:0] PrR_para; 
wire [9:0] PrG_para; 
wire [9:0] PrB_para; 

wire EN_INTERNAL_PATTERN;
wire EnDAC0;
wire EnDAC1;
wire EnDAC2;

assign  DAC0_ENABLE = EnDAC0;
assign  DAC1_ENABLE = EnDAC1;
assign  DAC2_ENABLE = EnDAC2;
// =======================================================================
// APB interface block
// -----------------------------------------------------------------------

VideoEncAPBinterace VideoEncAPBinterace 
(

//  APB bus
    .PCLK    (PCLK    ),
    .RESETn  (RESETn  ),

    .PENABLE  (PENABLE  ), 
    .PSEL     (PSEL     ), 
    .PWRITE   (PWRITE   ), 
    .PADDR    (PADDR    ),  //[7:2]  used
    .PWDATA   (PWDATA   ),  //[31:0] used
    .PRDATA   (PRDATA   ),  //[31:0] used

//input

    .CLK(CLK),       // 27Mhz or 74.25Mhz clock input

    .FIELD_CNT(8'd0),
    .H_CNT(11'd0),
    .V_CNT(10'd0),

//Register setting value output for Video Encoder
    .ENABLE(),
    .EN_DAC0(EnDAC0),
    .EN_DAC1(EnDAC1),
    .EN_DAC2(EnDAC2),
    .EN_DAC34(),
    .BYPIDAC(),
    .BIASTEST0(),
    .BIASTEST1(),

    .EN_SQPIXEL(),
    .EN_NONINTERLACE(),
    .EN_RESET_SCH(),
    .EN_INTERNAL_PATTERN(EN_INTERNAL_PATTERN),
    .EN_COLOR_KILL(),

    .OUT_MODE(),

    .OUT_ENABLE(),
    .OUT_16BIT(),
    .INV_CbCr(),
    .INV_FIELD(),
    .INV_BLANK(),
    .INV_HSYNC(),

    .COLOR_PATTERN_MODE(),
    .LUMA_FILTER_SEL(),
    .CHRO_FILTER_SEL(),
    .CHRO_DELAY(),
    .LUMA_DELAY(),
    .BURST_WID(),
    .HSYNC_WID(),

    .SUB_PHASE(),
    .SUB_REQ(),

    .SATURATION_YLEV(),
    .SATURATION_CLEV(),
    .HUE_LEV(),
    .BURST_STEP(),
    .BLACK_VALUE(),
    .BLANK_VALUE(),
    .BRIGHT_LEV(),
    .HSYNC_STEP(),
    .BURST_CAL(),

//Register setting value output for HD components

    .HD_ENABLE(HD_ENABLE),
    .HD_MODE(HD_MODE),
    .EnSYNC_PbPr(EnSYNC_PbPr),
    .LUMA_AMP(LUMA_AMP),
    .Pr_AMP(Pr_AMP),
    .Pb_AMP(Pb_AMP),

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

    .ACT_DISPLAY(ACT_DISPLAY),

    .YR_para(YR_para),
    .YG_para(YG_para),
    .YB_para(YB_para),

    .PbR_para(PbR_para),
    .PbG_para(PbG_para),
    .PbB_para(PbB_para),

    .PrR_para(PrR_para),
    .PrG_para(PrG_para),
    .PrB_para(PrB_para)

);


// =======================================================================
// HDC core block
// -----------------------------------------------------------------------

HDCCore HDCCore(

    //Interface signal 
    .CLK(CLK),       // 27Mhz or 74.25Mhz clock input
    .RESETn(RESETn),
    .HSYNCn(HSYNCn),
    .VSYNCn(VSYNCn),
    .BLANKn(BLANKn),

    //Setting Signal input
    .HD_ENABLE(HD_ENABLE),
    .HD_MODE(HD_MODE),
    .EN_INTERNAL_PATTERN(EN_INTERNAL_PATTERN),
    .EnSYNC_PbPr(EnSYNC_PbPr),
    .LUMA_AMP(LUMA_AMP),
    .Pr_AMP(Pr_AMP),
    .Pb_AMP(Pb_AMP),

    .EnDAC0(EnDAC0),
    .EnDAC1(EnDAC1),
    .EnDAC2(EnDAC2),

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

    .ACT_DISPLAY(ACT_DISPLAY),

    .YRpara(YR_para),
    .YGpara(YG_para),
    .YBpara(YB_para),

    .PbRpara(PbR_para),
    .PbGpara(PbG_para),
    .PbBpara(PbB_para),

    .PrRpara(PrR_para),
    .PrGpara(PrG_para),
    .PrBpara(PrB_para),

    .Rin(Rin),
    .Gin(Gin),
    .Bin(Bin),

    .DAC0_Luminace(DAC0_DATA),
    .DAC1_Pb(DAC1_DATA),
    .DAC2_Pr(DAC2_DATA)
    );


endmodule
