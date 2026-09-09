// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : VideoEncAPBinterface.v
// File Revision       : 0.1
// -------------------------------------------------------------------
// Purpose            : This module is APBinterface
// ===================================================================

// Added Output control regster Feb.15.2007
// Added Output 8bit 16bit mode Feb.21.2007
// Added HDC output register May.1.2007

`timescale 1ns/10ps

`define VideoEncADDRREG0  6'b000000      //0x00   status register addr.
`define VideoEncADDRREG1  6'b000001      //0x04   Control register addr.
`define VideoEncADDRREG2  6'b000010      //0x08   Internal register addr.
`define VideoEncADDRREG3  6'b000011      //0x0C   Subcarrier adjust phase register addr.
`define VideoEncADDRREG4  6'b000100      //0x10   Subcarrier frequency step register addr.

`define VideoEncADDRREG5  6'b000101      //0x14   Image modify function reg.
`define VideoEncADDRREG6  6'b000110      //0x18   Out Level control0
`define VideoEncADDRREG7  6'b000111      //0x1C   Out Level control1


`define HD_ADDRREG0  6'b001100      //0x30   
`define HD_ADDRREG1  6'b001101      //0x34   
`define HD_ADDRREG2  6'b001110      //0x38   
`define HD_ADDRREG3  6'b001111      //0x3C   
`define HD_ADDRREG4  6'b010000      //0x40   
`define HD_ADDRREG5  6'b010001      //0x44   
`define HD_ADDRREG6  6'b010010      //0x48   
`define HD_ADDRREG7  6'b010011      //0x4C   

`define HD_ADDRREG8   6'b010100     //0x50   
`define HD_ADDRREG9   6'b010101     //0x54   
`define HD_ADDRREG10  6'b010110     //0x58   
`define HD_ADDRREG11  6'b010111     //0x5C   
`define HD_ADDRREG12  6'b011000     //0x60   
`define HD_ADDRREG13  6'b011001     //0x64   
`define HD_ADDRREG14  6'b011010     //0x68   
`define HD_ADDRREG15  6'b011011     //0x6C   
`define HD_ADDRREG16  6'b011100     //0x70   
`define HD_ADDRREG17  6'b011101     //0x74   
`define HD_ADDRREG18  6'b011110     //0x78   
`define HD_ADDRREG19  6'b011111     //0x7C   

module VideoEncAPBinterace 
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

    FIELD_CNT,
    H_CNT,
    V_CNT,

//Register setting value output for Video Encoder
    ENABLE,
    EN_DAC0,
    EN_DAC1,
    EN_DAC2,
    EN_DAC34,
    BYPIDAC,
    BIASTEST0,
    BIASTEST1,

    EN_SQPIXEL,
    EN_NONINTERLACE,
    EN_RESET_SCH,
    EN_INTERNAL_PATTERN,
    EN_COLOR_KILL,

    OUT_MODE,

    OUT_ENABLE,
    OUT_16BIT,
    INV_CbCr,
    INV_FIELD,
    INV_BLANK,
    INV_HSYNC,

    COLOR_PATTERN_MODE,
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
    BLACK_VALUE,
    BLANK_VALUE,
    BRIGHT_LEV,
    HSYNC_STEP,
    BURST_CAL,

//Register setting value output for HD components

    HD_ENABLE,
    HD_MODE,
    EnSYNC_PbPr,
    LUMA_AMP,
    Pr_AMP,
    Pb_AMP,

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

    YR_para,
    YG_para,
    YB_para,

    PbR_para,
    PbG_para,
    PbB_para,

    PrR_para,
    PrG_para,
    PrB_para

);

parameter StepNTSC  = 32'h21F07C1F;
parameter StepPALM  = 32'h21E6EFE3;
parameter StepNTSC4 = 32'h2A098ACB;
parameter StepPALNc = 32'h21F69446;

parameter BLACK_VALUE_75    = 283;
parameter BLACK_VALUE_NORMAL= 252; 
parameter BLANK_VALUE_NTSC  = 240;
parameter BLANK_VALUE_PAL   = 252;

parameter BURST_MAX_NTSC    = 115 ;
parameter BURST_MAX_PAL     = 123 ;

//Output format define///////
parameter NTSCM = 3'b000;
parameter NTSCJ = 3'b001;
parameter NTSC4 = 3'b010;
parameter PALM  = 3'b011;
parameter PAL   = 3'b100;
parameter PALNc = 3'b101;
parameter PALN  = 3'b110;
////////////////////////////


//APB bus//////////////////////
input   PCLK;
input   RESETn;

input	[7:2]	PADDR;
input	[31:0]	PWDATA;
input	PSEL;
input	PWRITE;
input	PENABLE;

output	[31:0]	PRDATA;

wire  	[31:0]	PRDATA;
wire    Valid;
wire    READOP  = PENABLE && PSEL && !PWRITE ;  // Read operation
wire    WRITEOP = PENABLE && PSEL && PWRITE  ;  // Write operation

assign  Valid = (PSEL & (!PENABLE));
/////////////////////////////////


input   CLK;
input   [7:0]   FIELD_CNT;
input   [10:0]  H_CNT;
input   [9:0]   V_CNT;

output  ENABLE;
output  EN_DAC0;
output  EN_DAC1;
output  EN_DAC2;
output  EN_DAC34;
output  BYPIDAC;
output  BIASTEST0;
output  BIASTEST1;
output  EN_SQPIXEL;
output  EN_NONINTERLACE;
output  EN_RESET_SCH;
output  EN_INTERNAL_PATTERN;
output  EN_COLOR_KILL;
output  [2:0]   COLOR_PATTERN_MODE;
output  [2:0]   OUT_MODE;

output  OUT_ENABLE;
output  INV_CbCr;
output  OUT_16BIT;
output  INV_FIELD;
output  INV_BLANK;
output  INV_HSYNC;

output  [1:0]   LUMA_FILTER_SEL;
output  [1:0]   CHRO_FILTER_SEL;
output  [2:0]   CHRO_DELAY;
output  [2:0]   LUMA_DELAY;
output  [1:0]   BURST_WID;
output  [2:0]   HSYNC_WID;

output  [15:0]  SUB_PHASE;
output  [31:0]  SUB_REQ;

output [7:0] SATURATION_YLEV;
output [7:0] SATURATION_CLEV;
output [7:0] HUE_LEV;
output [5:0] BRIGHT_LEV;

output [4:0] BURST_STEP;
output [9:0] BLACK_VALUE;
output [9:0] BLANK_VALUE;
output [7:0] HSYNC_STEP;
output [7:0] BURST_CAL;


///////////////////////////////////////////////////
//Register setting value output for HD components//
///////////////////////////////////////////////////
output HD_ENABLE;
output [1:0] HD_MODE;
output EnSYNC_PbPr;
output [7:0] LUMA_AMP;
output [7:0] Pr_AMP;
output [7:0] Pb_AMP;

output [9:0] YH0to1_1;
output [9:0] YH0to1_2;
output [9:0] YH0to1_3;
output [9:0] YH0to2_1;
output [9:0] YH0to2_2;
output [9:0] YH0to2_3;
output [9:0] YH2to1_1;
output [9:0] YH2to1_2;
output [9:0] YH2to1_3;

output [9:0] YLevel00;
output [9:0] YLevel01;
output [9:0] YLevel02;

output [9:0] PH0to1_1;
output [9:0] PH0to1_2;
output [9:0] PH0to1_3;
output [9:0] PH0to2_1;
output [9:0] PH0to2_2;
output [9:0] PH0to2_3;
output [9:0] PH2to1_1;
output [9:0] PH2to1_2;
output [9:0] PH2to1_3;

output [9:0] PLevel00;
output [9:0] PLevel01;
output [9:0] PLevel02;

output [11:0] ACT_DISPLAY;
output [11:0] H1;
output [11:0] H2;
output [11:0] H3;
output [11:0] H4;
output [11:0] H5;
output [11:0] H6;
output [11:0] H7;
output [11:0] H8;
output [11:0] H9;
output [11:0] H10;

output [9:0] YR_para; 
output [9:0] YG_para; 
output [9:0] YB_para; 
                   
output [9:0] PbR_para; 
output [9:0] PbG_para; 
output [9:0] PbB_para; 
                   
output [9:0] PrR_para; 
output [9:0] PrG_para; 
output [9:0] PrB_para; 


//==================================================================
// Register 
//__________________________________________________________________

reg   [7:0]   rFIELD_CNT/* synthesis syn_preserve =1 */;
reg   [10:0]  rH_CNT/* synthesis syn_preserve =1 */;
reg   [9:0]   rV_CNT/* synthesis syn_preserve =1 */;
reg   rENABLE;
reg   rOUT_ENABLE;
reg   rOUT_16BIT;
reg   rINV_CbCr;
reg   rINV_FIELD;
reg   rINV_BLANK;
reg   rINV_HSYNC;

reg   [7:0] rSATURATION_YLEV;
reg   [7:0] rSATURATION_CLEV;
reg   [7:0] rHUE_LEV;
reg   [5:0] rBRIGHT_LEV;

reg   [9:0] rBLACK_VALUE;
reg   [9:0] rBLANK_VALUE;
reg   [7:0] rHSYNC_STEP;
reg   [7:0] rBURST_CAL;
reg   [4:0] rBURST_STEP;

reg   [7:0]   rFIELD_CNT_d/* synthesis syn_preserve =1 */;
reg   [10:0]  rH_CNT_d/* synthesis syn_preserve =1 */;
reg   [9:0]   rV_CNT_d/* synthesis syn_preserve =1 */;
reg   rENABLE_d;
reg   rOUT_ENABLE_d;
reg   rOUT_16BIT_d;
reg   rINV_CbCr_d;
reg   rINV_FIELD_d;
reg   rINV_BLANK_d;
reg   rINV_HSYNC_d;

reg   [7:0] rSATURATION_YLEV_d;
reg   [7:0] rSATURATION_CLEV_d;
reg   [7:0] rHUE_LEV_d;
reg   [5:0] rBRIGHT_LEV_d;

reg   [9:0] rBLACK_VALUE_d;
reg   [9:0] rBLANK_VALUE_d;
reg   [7:0] rHSYNC_STEP_d;
reg   [7:0] rBURST_CAL_d;
reg   [4:0] rBURST_STEP_d;

reg   [7:0]   rFIELD_CNT_1d/* synthesis syn_preserve =1 */;
reg   [10:0]  rH_CNT_1d/* synthesis syn_preserve =1 */;
reg   [9:0]   rV_CNT_1d/* synthesis syn_preserve =1 */;

reg  rEN_DAC34;
reg  rBYPIDAC;
reg  rBIASTEST0 ;
reg  rBIASTEST1 ;
reg  rEN_DAC0;
reg  rEN_DAC1;
reg  rEN_DAC2;
reg  rEN_SQPIXEL;
reg  rEN_NONINTERLACE;
reg  rEN_REST_SCH;
reg  rEN_INTERNAL_PATTERN;
reg  rEN_COLOR_KILL;

reg  [2:0]   rCOLOR_PATTERN_MODE;
reg  [2:0]   rOUT_MODE;
reg  [1:0]   rLUMA_FILTER_SEL;
reg  [1:0]   rCHRO_FILTER_SEL;
reg  [2:0]   rCHRO_DELAY;
reg  [2:0]   rLUMA_DELAY;
reg  [1:0]   rBURST_WID;
reg  [2:0]   rHSYNC_WID;
reg  [15:0]  rSUB_PHASE;
reg  [31:0]  rSUB_REQ;

reg  rBIASTEST0_d ;
reg  rBIASTEST1_d ;
reg  rEN_DAC34_d;
reg  rBYPIDAC_d;
reg  rEN_DAC0_d;
reg  rEN_DAC1_d;
reg  rEN_DAC2_d;
reg  rEN_SQPIXEL_d;
reg  rEN_NONINTERLACE_d;
reg  rEN_REST_SCH_d;
reg  rEN_INTERNAL_PATTERN_d;
reg  rEN_COLOR_KILL_d;

reg  [2:0]   rCOLOR_PATTERN_MODE_d;
reg  [2:0]   rOUT_MODE_d;
reg  [1:0]   rLUMA_FILTER_SEL_d;
reg  [1:0]   rCHRO_FILTER_SEL_d;
reg  [2:0]   rCHRO_DELAY_d;
reg  [2:0]   rLUMA_DELAY_d;
reg  [1:0]   rBURST_WID_d;
reg  [2:0]   rHSYNC_WID_d;
reg  [15:0]  rSUB_PHASE_d;
reg  [31:0]  rSUB_REQ_d;

reg  rEN_DAC0_1d;
reg  rEN_DAC1_1d;
reg  rEN_DAC2_1d;

reg  rBIASTEST0_1d;
reg  rBIASTEST1_1d;

reg  rEN_DAC34_1d;
reg  rBYPIDAC_1d;

reg  rEN_SQPIXEL_1d;
reg  rEN_NONINTERLACE_1d;
reg  rEN_REST_SCH_1d;
reg  rEN_INTERNAL_PATTERN_1d;
reg  rEN_COLOR_KILL_1d;

reg  [2:0]   rCOLOR_PATTERN_MODE_1d;
reg  [2:0]   rOUT_MODE_1d;
reg  [1:0]   rLUMA_FILTER_SEL_1d;
reg  [1:0]   rCHRO_FILTER_SEL_1d;
reg  [2:0]   rCHRO_DELAY_1d;
reg  [2:0]   rLUMA_DELAY_1d;
reg  [1:0]   rBURST_WID_1d;
reg  [2:0]   rHSYNC_WID_1d;
reg  [15:0]  rSUB_PHASE_1d;
reg  [31:0]  rSUB_REQ_1d;

//APB sync register
reg rHD_ENABLE;
reg [1:0] rHD_MODE;
reg rEnSYNC_PbPr;
reg [7:0] rLUMA_AMP;
reg [7:0] rPr_AMP;
reg [7:0] rPb_AMP;

reg [9:0] rYH0to1_1;
reg [9:0] rYH0to1_2;
reg [9:0] rYH0to1_3;
reg [9:0] rYH0to2_1;
reg [9:0] rYH0to2_2;
reg [9:0] rYH0to2_3;
reg [9:0] rYH2to1_1;
reg [9:0] rYH2to1_2;
reg [9:0] rYH2to1_3;

reg [9:0] rYLevel00;
reg [9:0] rYLevel01;
reg [9:0] rYLevel02;

reg [9:0] rPH0to1_1;
reg [9:0] rPH0to1_2;
reg [9:0] rPH0to1_3;
reg [9:0] rPH0to2_1;
reg [9:0] rPH0to2_2;
reg [9:0] rPH0to2_3;
reg [9:0] rPH2to1_1;
reg [9:0] rPH2to1_2;
reg [9:0] rPH2to1_3;

reg [9:0] rPLevel00;
reg [9:0] rPLevel01;
reg [9:0] rPLevel02;

reg [11:0] rACT_DISPLAY;
reg [11:0] rH1;
reg [11:0] rH2;
reg [11:0] rH3;
reg [11:0] rH4;
reg [11:0] rH5;
reg [11:0] rH6;
reg [11:0] rH7;
reg [11:0] rH8;
reg [11:0] rH9;
reg [11:0] rH10;

reg [9:0] rYR_para; 
reg [9:0] rYG_para; 
reg [9:0] rYB_para; 
                   
reg [9:0] rPbR_para; 
reg [9:0] rPbG_para; 
reg [9:0] rPbB_para; 
                   
reg [9:0] rPrR_para; 
reg [9:0] rPrG_para; 
reg [9:0] rPrB_para; 

//Video clock sync register
reg       rHD_ENABLE_1d;
reg [1:0] rHD_MODE_1d;
reg       rEnSYNC_PbPr_1d;
reg [7:0] rLUMA_AMP_1d;
reg [7:0] rPr_AMP_1d;
reg [7:0] rPb_AMP_1d;

reg [9:0] rYH0to1_1_1d;
reg [9:0] rYH0to1_2_1d;
reg [9:0] rYH0to1_3_1d;
reg [9:0] rYH0to2_1_1d;
reg [9:0] rYH0to2_2_1d;
reg [9:0] rYH0to2_3_1d;
reg [9:0] rYH2to1_1_1d;
reg [9:0] rYH2to1_2_1d;
reg [9:0] rYH2to1_3_1d;

reg [9:0] rYLevel00_1d;
reg [9:0] rYLevel01_1d;
reg [9:0] rYLevel02_1d;

reg [9:0] rPH0to1_1_1d;
reg [9:0] rPH0to1_2_1d;
reg [9:0] rPH0to1_3_1d;
reg [9:0] rPH0to2_1_1d;
reg [9:0] rPH0to2_2_1d;
reg [9:0] rPH0to2_3_1d;
reg [9:0] rPH2to1_1_1d;
reg [9:0] rPH2to1_2_1d;
reg [9:0] rPH2to1_3_1d;

reg [9:0] rPLevel00_1d;
reg [9:0] rPLevel01_1d;
reg [9:0] rPLevel02_1d;

reg [11:0] rACT_DISPLAY_1d;
reg [11:0] rH1_1d;
reg [11:0] rH2_1d;
reg [11:0] rH3_1d;
reg [11:0] rH4_1d;
reg [11:0] rH5_1d;
reg [11:0] rH6_1d;
reg [11:0] rH7_1d;
reg [11:0] rH8_1d;
reg [11:0] rH9_1d;
reg [11:0] rH10_1d;

reg [9:0] rYR_para_1d; 
reg [9:0] rYG_para_1d; 
reg [9:0] rYB_para_1d; 
                   
reg [9:0] rPbR_para_1d; 
reg [9:0] rPbG_para_1d; 
reg [9:0] rPbB_para_1d; 
                   
reg [9:0] rPrR_para_1d; 
reg [9:0] rPrG_para_1d; 
reg [9:0] rPrB_para_1d; 

reg       rHD_ENABLE_d;
reg [1:0] rHD_MODE_d;
reg       rEnSYNC_PbPr_d;
reg [7:0] rLUMA_AMP_d;
reg [7:0] rPr_AMP_d;
reg [7:0] rPb_AMP_d;

reg [9:0] rYH0to1_1_d;
reg [9:0] rYH0to1_2_d;
reg [9:0] rYH0to1_3_d;
reg [9:0] rYH0to2_1_d;
reg [9:0] rYH0to2_2_d;
reg [9:0] rYH0to2_3_d;
reg [9:0] rYH2to1_1_d;
reg [9:0] rYH2to1_2_d;
reg [9:0] rYH2to1_3_d;

reg [9:0] rYLevel00_d;
reg [9:0] rYLevel01_d;
reg [9:0] rYLevel02_d;

reg [9:0] rPH0to1_1_d;
reg [9:0] rPH0to1_2_d;
reg [9:0] rPH0to1_3_d;
reg [9:0] rPH0to2_1_d;
reg [9:0] rPH0to2_2_d;
reg [9:0] rPH0to2_3_d;
reg [9:0] rPH2to1_1_d;
reg [9:0] rPH2to1_2_d;
reg [9:0] rPH2to1_3_d;

reg [9:0] rPLevel00_d;
reg [9:0] rPLevel01_d;
reg [9:0] rPLevel02_d;

reg [11:0] rACT_DISPLAY_d;
reg [11:0] rH1_d;
reg [11:0] rH2_d;
reg [11:0] rH3_d;
reg [11:0] rH4_d;
reg [11:0] rH5_d;
reg [11:0] rH6_d;
reg [11:0] rH7_d;
reg [11:0] rH8_d;
reg [11:0] rH9_d;
reg [11:0] rH10_d;

reg [9:0] rYR_para_d; 
reg [9:0] rYG_para_d; 
reg [9:0] rYB_para_d; 
                   
reg [9:0] rPbR_para_d; 
reg [9:0] rPbG_para_d; 
reg [9:0] rPbB_para_d; 
                   
reg [9:0] rPrR_para_d; 
reg [9:0] rPrG_para_d; 
reg [9:0] rPrB_para_d; 

//==================================================================
// Output assign 
//__________________________________________________________________

assign  EN_DAC0 = rEN_DAC0_1d;
assign  EN_DAC1 = rEN_DAC1_1d;
assign  EN_DAC2 = rEN_DAC2_1d;
assign  EN_DAC34 =  rEN_DAC34_1d;
assign  BYPIDAC  =  rBYPIDAC_1d;
assign  BIASTEST0 = rBIASTEST0_1d; 
assign  BIASTEST1 = rBIASTEST1_1d; 

assign  EN_SQPIXEL = rEN_SQPIXEL_1d ;
assign  EN_NONINTERLACE = rEN_NONINTERLACE_1d ;
assign  EN_RESET_SCH = rEN_REST_SCH_1d;
assign  EN_INTERNAL_PATTERN = rEN_INTERNAL_PATTERN_1d;
assign  EN_COLOR_KILL = rEN_COLOR_KILL_1d;
assign  COLOR_PATTERN_MODE = rCOLOR_PATTERN_MODE_1d; 

assign  OUT_MODE = rOUT_MODE_1d;

assign  LUMA_FILTER_SEL = rLUMA_FILTER_SEL_1d;
assign  CHRO_FILTER_SEL = rCHRO_FILTER_SEL_1d;
assign  CHRO_DELAY = rCHRO_DELAY_1d;
assign  LUMA_DELAY = rLUMA_DELAY_1d;
assign  BURST_WID  = rBURST_WID_1d;
assign  HSYNC_WID  = rHSYNC_WID_1d;

assign  SUB_PHASE = rSUB_PHASE_1d;
assign  SUB_REQ   = rSUB_REQ_1d;
assign  ENABLE    = rENABLE_d;

assign SATURATION_YLEV  = rSATURATION_YLEV_d;
assign SATURATION_CLEV  = rSATURATION_CLEV_d;
assign HUE_LEV          = rHUE_LEV_d;
assign BRIGHT_LEV       = rBRIGHT_LEV_d;

assign BURST_STEP   = rBURST_STEP_d;
assign BLACK_VALUE  = rBLACK_VALUE_d;
assign BLANK_VALUE  = rBLANK_VALUE_d;
assign HSYNC_STEP   = rHSYNC_STEP_d ;
assign BURST_CAL    = rBURST_CAL_d;

assign  OUT_ENABLE   = rOUT_ENABLE_d;
assign  INV_CbCr     = rINV_CbCr_d  ;
assign  OUT_16BIT    = rOUT_16BIT_d;
assign  INV_FIELD    = rINV_FIELD_d ;
assign  INV_BLANK    = rINV_BLANK_d ;
assign  INV_HSYNC    = rINV_HSYNC_d ;


assign  HD_ENABLE =rHD_ENABLE_1d;
assign  HD_MODE   =rHD_MODE_1d;   
assign  EnSYNC_PbPr =rEnSYNC_PbPr_1d;
assign  LUMA_AMP =rLUMA_AMP_1d; 
assign  Pr_AMP   =rPr_AMP_1d; 
assign  Pb_AMP   =rPb_AMP_1d;

assign  YH0to1_1 =rYH0to1_1_1d; 
assign  YH0to1_2 =rYH0to1_2_1d; 
assign  YH0to1_3 =rYH0to1_3_1d; 
assign  YH0to2_1 =rYH0to2_1_1d; 
assign  YH0to2_2 =rYH0to2_2_1d; 
assign  YH0to2_3 =rYH0to2_3_1d; 
assign  YH2to1_1 =rYH2to1_1_1d; 
assign  YH2to1_2 =rYH2to1_2_1d; 
assign  YH2to1_3 =rYH2to1_3_1d; 

assign  YLevel00 =rYLevel00_1d; 
assign  YLevel01 =rYLevel01_1d; 
assign  YLevel02 =rYLevel02_1d; 

assign  PH0to1_1 =rPH0to1_1_1d; 
assign  PH0to1_2 =rPH0to1_2_1d; 
assign  PH0to1_3 =rPH0to1_3_1d; 
assign  PH0to2_1 =rPH0to2_1_1d; 
assign  PH0to2_2 =rPH0to2_2_1d; 
assign  PH0to2_3 =rPH0to2_3_1d; 
assign  PH2to1_1 =rPH2to1_1_1d; 
assign  PH2to1_2 =rPH2to1_2_1d; 
assign  PH2to1_3 =rPH2to1_3_1d; 

assign  PLevel00 =rPLevel00_1d; 
assign  PLevel01 =rPLevel01_1d; 
assign  PLevel02 =rPLevel02_1d; 

assign  H1 =rH1_1d;  
assign  H2 =rH2_1d; 
assign  H3 =rH3_1d; 
assign  H4 =rH4_1d; 
assign  H5 =rH5_1d; 
assign  H6 =rH6_1d; 
assign  H7 =rH7_1d; 
assign  H8 =rH8_1d; 
assign  H9 =rH9_1d; 
assign  H10 =rH10_1d; 

assign  ACT_DISPLAY =rACT_DISPLAY_1d; 

assign  YR_para =rYR_para_1d; 
assign  YG_para =rYG_para_1d; 
assign  YB_para =rYB_para_1d; 

assign  PbR_para =rPbR_para_1d; 
assign  PbG_para =rPbG_para_1d; 
assign  PbB_para =rPbB_para_1d; 

assign  PrR_para =rPrR_para_1d; 
assign  PrG_para =rPrG_para_1d; 
assign  PrB_para =rPrB_para_1d; 


//==================================================================
// Output Latch
// __________________________________________________________________

always @(posedge PCLK or negedge RESETn) begin

    if(!RESETn) begin
        rFIELD_CNT <= 0;
        rH_CNT     <= 0;
        rV_CNT     <= 0;

        rFIELD_CNT_d <= 0;
        rH_CNT_d     <= 0;
        rV_CNT_d     <= 0;

        rFIELD_CNT_1d<= 0;
        rH_CNT_1d    <= 0;
        rV_CNT_1d    <= 0;

    end
    else    begin
        rFIELD_CNT    <= FIELD_CNT;
        rFIELD_CNT_d  <= rFIELD_CNT;
        rFIELD_CNT_1d <= rFIELD_CNT_d;

        rH_CNT        <= H_CNT;
        rH_CNT_d      <= rH_CNT;
        rH_CNT_1d     <= rH_CNT_d;

        rV_CNT        <= V_CNT;
        rV_CNT_d      <= rV_CNT;
        rV_CNT_1d     <= rV_CNT_d;

    end
end

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        
        rHD_ENABLE_1d <= 0;
        rHD_MODE_1d <= 0;
        rEnSYNC_PbPr_1d <= 0;
        rLUMA_AMP_1d <= 0;
        rPr_AMP_1d <= 0;
        rPb_AMP_1d <= 0;

        rYH0to1_1_1d <= 0;
        rYH0to1_2_1d <= 0;
        rYH0to1_3_1d <= 0;
        rYH0to2_1_1d <= 0;
        rYH0to2_2_1d <= 0;
        rYH0to2_3_1d <= 0;
        rYH2to1_1_1d <= 0;
        rYH2to1_2_1d <= 0;
        rYH2to1_3_1d <= 0;

        rYLevel00_1d <= 0;
        rYLevel01_1d <= 0;
        rYLevel02_1d <= 0;

        rPH0to1_1_1d <= 0;
        rPH0to1_2_1d <= 0;
        rPH0to1_3_1d <= 0;
        rPH0to2_1_1d <= 0;
        rPH0to2_2_1d <= 0;
        rPH0to2_3_1d <= 0;
        rPH2to1_1_1d <= 0;
        rPH2to1_2_1d <= 0;
        rPH2to1_3_1d <= 0;

        rPLevel00_1d <= 0;
        rPLevel01_1d <= 0;
        rPLevel02_1d <= 0;

        rACT_DISPLAY_1d <= 0;
        rH1_1d <= 0;
        rH2_1d <= 0;
        rH3_1d <= 0;
        rH4_1d <= 0;
        rH5_1d <= 0;
        rH6_1d <= 0;
        rH7_1d <= 0;
        rH8_1d <= 0;
        rH9_1d <= 0;
        rH10_1d <= 0;

        rYR_para_1d <= 0; 
        rYG_para_1d <= 0; 
        rYB_para_1d <= 0; 
                   
        rPbR_para_1d <= 0; 
        rPbG_para_1d <= 0; 
        rPbB_para_1d <= 0; 
                   
        rPrR_para_1d <= 0; 
        rPrG_para_1d <= 0; 
        rPrB_para_1d <= 0; 

        rHD_ENABLE_d <= 0;
        rHD_MODE_d <= 0;
        rEnSYNC_PbPr_d <= 0;
        rLUMA_AMP_d <= 0;
        rPr_AMP_d <= 0;
        rPb_AMP_d <= 0;

        rYH0to1_1_d <= 0;
        rYH0to1_2_d <= 0;
        rYH0to1_3_d <= 0;
        rYH0to2_1_d <= 0;
        rYH0to2_2_d <= 0;
        rYH0to2_3_d <= 0;
        rYH2to1_1_d <= 0;
        rYH2to1_2_d <= 0;
        rYH2to1_3_d <= 0;

        rYLevel00_d <= 0;
        rYLevel01_d <= 0;
        rYLevel02_d <= 0;

        rPH0to1_1_d <= 0;
        rPH0to1_2_d <= 0;
        rPH0to1_3_d <= 0;
        rPH0to2_1_d <= 0;
        rPH0to2_2_d <= 0;
        rPH0to2_3_d <= 0;
        rPH2to1_1_d <= 0;
        rPH2to1_2_d <= 0;
        rPH2to1_3_d <= 0;

        rPLevel00_d <= 0;
        rPLevel01_d <= 0;
        rPLevel02_d <= 0;

        rACT_DISPLAY_d <= 0;
        rH1_d <= 0;
        rH2_d <= 0;
        rH3_d <= 0;
        rH4_d <= 0;
        rH5_d <= 0;
        rH6_d <= 0;
        rH7_d <= 0;
        rH8_d <= 0;
        rH9_d <= 0;
        rH10_d <= 0;

        rYR_para_d <= 0; 
        rYG_para_d <= 0; 
        rYB_para_d <= 0; 
                   
        rPbR_para_d <= 0; 
        rPbG_para_d <= 0; 
        rPbB_para_d <= 0; 
                   
        rPrR_para_d <= 0; 
        rPrG_para_d <= 0; 
        rPrB_para_d <= 0; 
    end
    else begin

        //1 dealay//////////////////////
        rHD_ENABLE_d <= rHD_ENABLE;
        rHD_MODE_d <=rHD_MODE  ;
        rEnSYNC_PbPr_d <=rEnSYNC_PbPr  ;
        rLUMA_AMP_d <=rLUMA_AMP  ;
        rPr_AMP_d <=rPr_AMP  ;
        rPb_AMP_d <=rPb_AMP  ;

        rYH0to1_1_d <=rYH0to1_1  ;
        rYH0to1_2_d <=rYH0to1_2  ;
        rYH0to1_3_d <=rYH0to1_3  ;
        rYH0to2_1_d <=rYH0to2_1  ;
        rYH0to2_2_d <=rYH0to2_2  ;
        rYH0to2_3_d <=rYH0to2_3  ;
        rYH2to1_1_d <=rYH2to1_1  ;
        rYH2to1_2_d <=rYH2to1_2  ;
        rYH2to1_3_d <=rYH2to1_3  ;

        rYLevel00_d <=rYLevel00  ;
        rYLevel01_d <=rYLevel01  ;
        rYLevel02_d <=rYLevel02  ;

        rPH0to1_1_d <=rPH0to1_1  ;
        rPH0to1_2_d <=rPH0to1_2  ;
        rPH0to1_3_d <=rPH0to1_3  ;
        rPH0to2_1_d <=rPH0to2_1  ;
        rPH0to2_2_d <=rPH0to2_2  ;
        rPH0to2_3_d <=rPH0to2_3  ;
        rPH2to1_1_d <=rPH2to1_1  ;
        rPH2to1_2_d <=rPH2to1_2  ;
        rPH2to1_3_d <=rPH2to1_3  ;

        rPLevel00_d <=rPLevel00  ;
        rPLevel01_d <=rPLevel01  ;
        rPLevel02_d <=rPLevel02  ;

        rACT_DISPLAY_d <=rACT_DISPLAY  ;
        rH1_d <=rH1  ;
        rH2_d <=rH2  ;
        rH3_d <=rH3  ;
        rH4_d <=rH4  ;
        rH5_d <=rH5  ;
        rH6_d <=rH6  ;
        rH7_d <=rH7  ;
        rH8_d <=rH8  ;
        rH9_d <=rH9  ;
        rH10_d <=rH10  ;

        rYR_para_d <=rYR_para  ; 
        rYG_para_d <=rYG_para  ; 
        rYB_para_d <=rYB_para  ; 
                   
        rPbR_para_d <=rPbR_para  ; 
        rPbG_para_d <=rPbG_para  ; 
        rPbB_para_d <=rPbB_para  ; 
                   
        rPrR_para_d <=rPrR_para  ; 
        rPrG_para_d <=rPrG_para  ; 
        rPrB_para_d <=rPrB_para  ; 


        //2 dealay//////////////////////
        rHD_ENABLE_1d <= rHD_ENABLE_d ;
        rHD_MODE_1d <=rHD_MODE_d   ;
        rEnSYNC_PbPr_1d <=rEnSYNC_PbPr_d   ;
        rLUMA_AMP_1d <=rLUMA_AMP_d   ;
        rPr_AMP_1d <=rPr_AMP_d   ;
        rPb_AMP_1d <=rPb_AMP_d   ;

        rYH0to1_1_1d <=rYH0to1_1_d   ;
        rYH0to1_2_1d <=rYH0to1_2_d   ;
        rYH0to1_3_1d <=rYH0to1_3_d   ;
        rYH0to2_1_1d <=rYH0to2_1_d   ;
        rYH0to2_2_1d <=rYH0to2_2_d   ;
        rYH0to2_3_1d <=rYH0to2_3_d   ;
        rYH2to1_1_1d <=rYH2to1_1_d   ;
        rYH2to1_2_1d <=rYH2to1_2_d   ;
        rYH2to1_3_1d <=rYH2to1_3_d   ;

        rYLevel00_1d <=rYLevel00_d   ;
        rYLevel01_1d <=rYLevel01_d   ;
        rYLevel02_1d <=rYLevel02_d   ;

        rPH0to1_1_1d <=rPH0to1_1_d   ;
        rPH0to1_2_1d <=rPH0to1_2_d   ;
        rPH0to1_3_1d <=rPH0to1_3_d   ;
        rPH0to2_1_1d <=rPH0to2_1_d   ;
        rPH0to2_2_1d <=rPH0to2_2_d   ;
        rPH0to2_3_1d <=rPH0to2_3_d   ;
        rPH2to1_1_1d <=rPH2to1_1_d   ;
        rPH2to1_2_1d <=rPH2to1_2_d   ;
        rPH2to1_3_1d <=rPH2to1_3_d   ;

        rPLevel00_1d <=rPLevel00_d   ;
        rPLevel01_1d <=rPLevel01_d   ;
        rPLevel02_1d <=rPLevel02_d   ;

        rACT_DISPLAY_1d <=rACT_DISPLAY_d   ;
        rH1_1d <=rH1_d   ;
        rH2_1d <=rH2_d   ;
        rH3_1d <=rH3_d   ;
        rH4_1d <=rH4_d   ;
        rH5_1d <=rH5_d   ;
        rH6_1d <=rH6_d   ;
        rH7_1d <=rH7_d   ;
        rH8_1d <=rH8_d   ;
        rH9_1d <=rH9_d   ;
        rH10_1d <=rH10_d   ;

        rYR_para_1d <=rYR_para_d   ; 
        rYG_para_1d <=rYG_para_d   ; 
        rYB_para_1d <=rYB_para_d   ; 
                   
        rPbR_para_1d <=rPbR_para_d   ; 
        rPbG_para_1d <=rPbG_para_d   ; 
        rPbB_para_1d <=rPbB_para_d   ; 
                   
        rPrR_para_1d <=rPrR_para_d   ; 
        rPrG_para_1d <=rPrG_para_d   ; 
        rPrB_para_1d <=rPrB_para_d   ; 

    end
end
    
always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        rENABLE_d       <= 1'b0;

        rOUT_ENABLE_d   <= 1'b0;
        rINV_CbCr_d     <= 1'b0;
        rOUT_16BIT_d    <= 1'b0;
        rINV_FIELD_d    <= 1'b0;
        rINV_BLANK_d    <= 1'b0;
        rINV_HSYNC_d    <= 1'b0;

        rSATURATION_YLEV_d <= 0;
        rSATURATION_CLEV_d <= 0;
        rHUE_LEV_d <= 0;
        rBRIGHT_LEV_d <= 0;

        rBLACK_VALUE_d <= 0;
        rBLANK_VALUE_d <= 0;
        rHSYNC_STEP_d <= 0;
        rBURST_CAL_d  <= 0;
        rBURST_STEP_d <= 0;

        rEN_DAC34_d     <= 1'b0;
        rBYPIDAC_d      <= 1'b0;

        rBIASTEST0_d    <= 1'b0;
        rBIASTEST1_d    <= 1'b0;

        rEN_DAC0_d      <= 1'b0;
        rEN_DAC1_d      <= 1'b0;
        rEN_DAC2_d      <= 1'b0;
        rEN_SQPIXEL_d   <= 1'b0;
        rEN_NONINTERLACE_d <= 1'b0;
        rEN_REST_SCH_d  <= 1'b0;
        rEN_INTERNAL_PATTERN_d  <= 1'b0;
        rEN_COLOR_KILL_d <= 1'b0;

        rCOLOR_PATTERN_MODE_d    <= 3'b000;
        rOUT_MODE_d           <= 3'b000;
        rLUMA_FILTER_SEL_d    <= 2'b00;
        rCHRO_FILTER_SEL_d    <= 2'b00;
        rCHRO_DELAY_d         <= 3'b000;
        rLUMA_DELAY_d         <= 3'b000;
        rBURST_WID_d          <= 2'b01;
        rHSYNC_WID_d          <= 2'b01;
        rSUB_PHASE_d          <= 15'd0;
        rSUB_REQ_d            <= 32'd0;

        rBIASTEST0_1d    <= 1'b0;
        rBIASTEST1_1d    <= 1'b0;
        rEN_DAC34_1d     <= 1'b0;
        rBYPIDAC_1d      <= 1'b0;
        rEN_DAC0_1d      <= 1'b0;
        rEN_DAC1_1d      <= 1'b0;
        rEN_DAC2_1d      <= 1'b0;
        rEN_SQPIXEL_1d   <= 1'b0;
        rEN_NONINTERLACE_1d <= 1'b0;
        rEN_REST_SCH_1d  <= 1'b0;
        rEN_INTERNAL_PATTERN_1d  <= 1'b0;
        rEN_COLOR_KILL_1d <= 1'b0;

        rCOLOR_PATTERN_MODE_1d <= 3'b000;
        rOUT_MODE_1d           <= 3'b000;
        rLUMA_FILTER_SEL_1d    <= 2'b00;
        rCHRO_FILTER_SEL_1d    <= 2'b00;
        rCHRO_DELAY_1d         <= 3'b000;
        rLUMA_DELAY_1d         <= 3'b000;
        rBURST_WID_1d          <= 2'b01;
        rHSYNC_WID_1d          <= 2'b01;
        rSUB_PHASE_1d          <= 15'd0;
        rSUB_REQ_1d            <= 32'd0;

    end
    else    begin
        rENABLE_d       <= rENABLE;

        rSATURATION_YLEV_d <= rSATURATION_YLEV;
        rSATURATION_CLEV_d <= rSATURATION_CLEV;
        rHUE_LEV_d        <= rHUE_LEV;
        rBRIGHT_LEV_d     <= rBRIGHT_LEV;

        rBLACK_VALUE_d    <= rBLACK_VALUE;
        rBLANK_VALUE_d    <= rBLANK_VALUE;
        rHSYNC_STEP_d      <= rHSYNC_STEP;
        rBURST_CAL_d       <= rBURST_CAL;
        rBURST_STEP_d      <= rBURST_STEP;


        rOUT_16BIT_d    <= rOUT_16BIT;
        rOUT_ENABLE_d   <= rOUT_ENABLE;
        rINV_CbCr_d     <= rINV_CbCr;
        rINV_FIELD_d    <= rINV_FIELD;
        rINV_BLANK_d    <= rINV_BLANK;
        rINV_HSYNC_d    <= rINV_HSYNC;

        rEN_DAC0_d      <= rEN_DAC0;
        rEN_DAC0_1d     <= rEN_DAC0_d;

        rBIASTEST0_d    <= rBIASTEST0;
        rBIASTEST0_1d   <= rBIASTEST0_d;

        rBIASTEST1_d    <= rBIASTEST1;
        rBIASTEST1_1d   <= rBIASTEST1_d;

        rEN_DAC34_d     <= rEN_DAC34;
        rEN_DAC34_1d    <= rEN_DAC34_d;
        rBYPIDAC_d      <= rBYPIDAC;
        rBYPIDAC_1d     <= rBYPIDAC_d;

        rEN_DAC1_d      <= rEN_DAC1;
        rEN_DAC1_1d     <= rEN_DAC1_d;

        rEN_DAC2_d      <= rEN_DAC2;
        rEN_DAC2_1d     <= rEN_DAC2_d;

        rEN_SQPIXEL_d   <= rEN_SQPIXEL;
        rEN_SQPIXEL_1d  <= rEN_SQPIXEL_d;

        rEN_NONINTERLACE_d  <= rEN_NONINTERLACE;
        rEN_NONINTERLACE_1d <= rEN_NONINTERLACE_d;

        rEN_REST_SCH_d   <= rEN_REST_SCH;
        rEN_REST_SCH_1d  <= rEN_REST_SCH_d;

        rEN_INTERNAL_PATTERN_d  <= rEN_INTERNAL_PATTERN;
        rEN_INTERNAL_PATTERN_1d <= rEN_INTERNAL_PATTERN_d;

        rEN_COLOR_KILL_d    <= rEN_COLOR_KILL;
        rEN_COLOR_KILL_1d   <= rEN_COLOR_KILL_d;

        rCOLOR_PATTERN_MODE_d  <= rCOLOR_PATTERN_MODE;
        rCOLOR_PATTERN_MODE_1d <= rCOLOR_PATTERN_MODE_d;

        rOUT_MODE_d     <= rOUT_MODE;
        rOUT_MODE_1d    <= rOUT_MODE_d;

        rLUMA_FILTER_SEL_d    <= rLUMA_FILTER_SEL;
        rLUMA_FILTER_SEL_1d   <= rLUMA_FILTER_SEL_d;

        rCHRO_FILTER_SEL_d    <= rCHRO_FILTER_SEL;
        rCHRO_FILTER_SEL_1d   <= rCHRO_FILTER_SEL_d;

        rCHRO_FILTER_SEL_d    <= rCHRO_FILTER_SEL;
        rCHRO_FILTER_SEL_1d   <= rCHRO_FILTER_SEL_d;

        rCHRO_DELAY_d         <= rCHRO_DELAY;
        rCHRO_DELAY_1d        <= rCHRO_DELAY_d;

        rLUMA_DELAY_d         <= rLUMA_DELAY;
        rLUMA_DELAY_1d        <= rLUMA_DELAY_d;

        rBURST_WID_d          <= rBURST_WID;
        rBURST_WID_1d         <= rBURST_WID_d;

        rHSYNC_WID_d          <= rHSYNC_WID;
        rHSYNC_WID_1d         <= rHSYNC_WID_d;

        rSUB_PHASE_d          <= rSUB_PHASE;
        rSUB_PHASE_1d         <= rSUB_PHASE_d;

        rSUB_REQ_d            <= rSUB_REQ;
        rSUB_REQ_1d           <= rSUB_REQ_d;
    end
end


//==================================================================
// APB interface
// __________________________________________________________________
// INTERFACE READ & WRITE
// register write 

always @(negedge RESETn or posedge PCLK)	begin
	if(!RESETn) begin
        rENABLE     <= 1'b0;
        rEN_DAC0    <= 1'b0;
        rEN_DAC1    <= 1'b0;
        rEN_DAC2    <= 1'b0;

        rEN_DAC34   <= 1'b1;
        rBYPIDAC    <= 1'b0;
        rBIASTEST0  <= 1'b0;
        rBIASTEST1  <= 1'b0;

        rEN_SQPIXEL <= 1'b0;
        rEN_NONINTERLACE   <= 1'b0;
        rEN_REST_SCH    <= 1'b0;
        rEN_INTERNAL_PATTERN    <= 1'b0;
        rEN_COLOR_KILL <= 1'b0;

        rCOLOR_PATTERN_MODE <= 3'b000;
        rOUT_MODE           <= 3'b000;
        rLUMA_FILTER_SEL    <= 2'b00;
        rCHRO_FILTER_SEL    <= 2'b00;
        rCHRO_DELAY         <= 3'b000;
        rLUMA_DELAY         <= 3'b000;
        rBURST_WID          <= 2'b01;
        rHSYNC_WID          <= 3'b010;
        rSUB_PHASE          <= 15'd0;
        rSUB_REQ            <= 32'd0;

        rOUT_ENABLE         <= 1'b0;
        rOUT_16BIT          <= 1'b0;
        rINV_CbCr           <= 1'b0;
        rINV_FIELD          <= 1'b0;
        rINV_BLANK          <= 1'b0;
        rINV_HSYNC          <= 1'b0;

        rSATURATION_YLEV    <= 8'd128;
        rSATURATION_CLEV    <= 8'd128;
        rHUE_LEV            <= 8'd0;
        rBRIGHT_LEV         <= 6'd0;

        rBLACK_VALUE        <= 0;
        rBLANK_VALUE        <= 0;
        rHSYNC_STEP         <= 0;
        rBURST_CAL          <= 8'd128;
        rBURST_STEP         <= 0;

        rHD_ENABLE <= 0;
        rHD_MODE <= 0;
        rEnSYNC_PbPr <= 0;
        rLUMA_AMP <= 0;
        rPr_AMP <= 0;
        rPb_AMP <= 0;

        rYH0to1_1 <= 0;
        rYH0to1_2 <= 0;
        rYH0to1_3 <= 0;
        rYH0to2_1 <= 0;
        rYH0to2_2 <= 0;
        rYH0to2_3 <= 0;
        rYH2to1_1 <= 0;
        rYH2to1_2 <= 0;
        rYH2to1_3 <= 0;

        rYLevel00 <= 0;
        rYLevel01 <= 0;
        rYLevel02 <= 0;

        rPH0to1_1 <= 0;
        rPH0to1_2 <= 0;
        rPH0to1_3 <= 0;
        rPH0to2_1 <= 0;
        rPH0to2_2 <= 0;
        rPH0to2_3 <= 0;
        rPH2to1_1 <= 0;
        rPH2to1_2 <= 0;
        rPH2to1_3 <= 0;

        rPLevel00 <= 0;
        rPLevel01 <= 0;
        rPLevel02 <= 0;

        rACT_DISPLAY <= 0;
        rH1 <= 0;
        rH2 <= 0;
        rH3 <= 0;
        rH4 <= 0;
        rH5 <= 0;
        rH6 <= 0;
        rH7 <= 0;
        rH8 <= 0;
        rH9 <= 0;
        rH10 <= 0;

        rYR_para <= 0; 
        rYG_para <= 0; 
        rYB_para <= 0; 
                   
        rPbR_para <= 0; 
        rPbG_para <= 0; 
        rPbB_para <= 0; 
                   
        rPrR_para <= 0; 
        rPrG_para <= 0; 
        rPrB_para <= 0; 

	end
	else	begin
		if(WRITEOP && (PADDR[7:2] == `VideoEncADDRREG0)) begin
            rENABLE     <= PWDATA[31];
            rOUT_ENABLE <= PWDATA[30];
        end
		else if(WRITEOP && (PADDR[7:2] == `VideoEncADDRREG1)) begin

            rOUT_MODE  <= PWDATA[31:29];
            rEN_DAC0   <= PWDATA[0];
            rEN_DAC1   <= PWDATA[1];
            rEN_DAC2   <= PWDATA[2];
            rEN_DAC34  <= PWDATA[7];
            rBYPIDAC   <= PWDATA[8];
            rBIASTEST0 <= PWDATA[9];
            rBIASTEST1 <= PWDATA[10];

            rEN_NONINTERLACE    <= PWDATA[26];
            rEN_SQPIXEL         <= PWDATA[25];
            rOUT_16BIT          <= PWDATA[24];
            rINV_CbCr           <= PWDATA[6];
            rINV_FIELD          <= PWDATA[5];
            rINV_BLANK          <= PWDATA[4];
            rINV_HSYNC          <= PWDATA[3];

            case(PWDATA[31:29])// synopsys parallel_case
                NTSCM: begin
                    rBLACK_VALUE<= BLACK_VALUE_75;
                    rBLANK_VALUE<= BLANK_VALUE_NTSC;
                    //rSATURATION_CLEV    <= 8'd144;
                    //rSATURATION_YLEV    <= 8'd144;
                    rSATURATION_CLEV    <= 8'd128;
                    rSATURATION_YLEV    <= 8'd128;
                    rSUB_REQ            <= 32'h21F07C1F;
                    rBURST_STEP         <= 5'd14;
                    rHSYNC_STEP         <= 8'hC8;
                end
                NTSCJ: begin
                    rBLACK_VALUE<= BLACK_VALUE_NORMAL;
                    rBLANK_VALUE<= BLANK_VALUE_NTSC;
                    //rSATURATION_CLEV    <= 8'd144;
                    //rSATURATION_YLEV    <= 8'd144;
                    rSATURATION_CLEV    <= 8'd128;
                    rSATURATION_YLEV    <= 8'd128;
                    rSUB_REQ            <= 32'h21F07C1F;
                    rBURST_STEP         <= 5'd14;
                    rHSYNC_STEP         <= 8'hC8;
                end
                PALM:  begin
                    rBLACK_VALUE<= BLACK_VALUE_75;
                    rBLANK_VALUE<= BLANK_VALUE_PAL;
                    //rSATURATION_CLEV    <= 8'd144;
                    //rSATURATION_YLEV    <= 8'd144;
                    rSATURATION_CLEV    <= 8'd128;
                    rSATURATION_YLEV    <= 8'd128;
                    rSUB_REQ            <= 32'h21E6EFE3;
                    rBURST_STEP         <= 5'd14;
                    rHSYNC_STEP         <= 8'hC8;
                end
                NTSC4:  begin
                    rBLACK_VALUE<= BLACK_VALUE_75;
                    rBLANK_VALUE<= BLANK_VALUE_NTSC;
                    //rSATURATION_CLEV    <= 8'd144;
                    //rSATURATION_YLEV    <= 8'd144;
                    rSATURATION_CLEV    <= 8'd128;
                    rSATURATION_YLEV    <= 8'd128;
                    rSUB_REQ            <= 32'h2A098ACB;
                    rBURST_STEP         <= 5'd14;
                    rHSYNC_STEP         <= 8'hC8;
                end
                PAL:  begin
                    rBLACK_VALUE<= BLACK_VALUE_NORMAL;
                    rBLANK_VALUE<= BLANK_VALUE_PAL;
                    //rSATURATION_CLEV    <= 8'd136; 
                    //rSATURATION_YLEV    <= 8'd136;
                    rSATURATION_CLEV    <= 8'd128;
                    rSATURATION_YLEV    <= 8'd128;
                    rSUB_REQ            <= 32'h2A098ACB;
                    rBURST_STEP         <= 5'd15;
                    rHSYNC_STEP         <= 8'hDE;
                end
                PALNc:  begin
                    rBLACK_VALUE<= BLACK_VALUE_NORMAL;
                    rBLANK_VALUE<= BLANK_VALUE_PAL;
                    //rSATURATION_CLEV    <= 8'd136; 
                    //rSATURATION_YLEV    <= 8'd136;
                    rSATURATION_CLEV    <= 8'd128;
                    rSATURATION_YLEV    <= 8'd128;
                    rSUB_REQ            <= 32'h21F69446;
                    rBURST_STEP         <= 5'd15;
                    rHSYNC_STEP         <= 8'hDE;
                end
                PALN:  begin
                    rBLACK_VALUE<= BLACK_VALUE_NORMAL;
                    rBLANK_VALUE<= BLANK_VALUE_PAL;
                    //rSATURATION_CLEV    <= 8'd136; 
                    //rSATURATION_YLEV    <= 8'd136;
                    rSATURATION_CLEV    <= 8'd128;
                    rSATURATION_YLEV    <= 8'd128;
                    rSUB_REQ            <= 32'h2A098ACB;
                    rBURST_STEP         <= 5'd15;
                    rHSYNC_STEP         <= 8'hDE;
                end
                default: begin
                    rBLACK_VALUE<= 10'd0;
                    rBLANK_VALUE<= 10'd0;
                    rSUB_REQ    <= 32'h21F07C1F;
                    rBURST_STEP         <= 5'd15;
                    rHSYNC_STEP         <= 8'hDE;
                    rSATURATION_CLEV    <= 8'd128;
                    rSATURATION_YLEV    <= 8'd128;
                end
            endcase
        end
        else if(WRITEOP && (PADDR[7:2] == `VideoEncADDRREG2)) begin   
            rLUMA_FILTER_SEL    <= PWDATA[7:6];
            rCHRO_FILTER_SEL    <= PWDATA[5:4];
            rEN_REST_SCH        <= PWDATA[12];
            rEN_COLOR_KILL      <= PWDATA[11];
            rCOLOR_PATTERN_MODE <= {PWDATA[15], PWDATA[14:13]};
            rEN_INTERNAL_PATTERN<= PWDATA[16];
            rCHRO_DELAY         <= PWDATA[20:18];
            rLUMA_DELAY         <= PWDATA[23:21];
            rBURST_WID          <= PWDATA[25:24];
            rHSYNC_WID          <= PWDATA[28:26];
        end
        else if(WRITEOP && (PADDR[7:2] == `VideoEncADDRREG3)) begin   
            rSUB_PHASE          <= PWDATA[15:0];
        end
        else if(WRITEOP && (PADDR[7:2] == `VideoEncADDRREG4)) begin   
            rSUB_REQ            <= PWDATA[31:0];
        end
        else if(WRITEOP && (PADDR[7:2] == `VideoEncADDRREG5)) begin   
            rBRIGHT_LEV         <= PWDATA[29:24];
            rHUE_LEV            <= PWDATA[23:16];
            rSATURATION_CLEV    <= PWDATA[15:8];
            rSATURATION_YLEV    <= PWDATA[7:0];
        end
        else if(WRITEOP && (PADDR[7:2] == `VideoEncADDRREG6)) begin   
            rBLANK_VALUE        <= PWDATA[25:16];
            rBLACK_VALUE        <= PWDATA[9:0];
        end
        else if(WRITEOP && (PADDR[7:2] == `VideoEncADDRREG7)) begin   
            rBURST_STEP          <= PWDATA[20:16];
            rBURST_CAL           <= PWDATA[15:8];
            rHSYNC_STEP          <= PWDATA[7:0];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG0)) begin   
            rHD_ENABLE   <= PWDATA[31];
            rHD_MODE     <= PWDATA[30:29];
            rEnSYNC_PbPr <= PWDATA[28];
            rLUMA_AMP    <= PWDATA[7:0];
            rPr_AMP      <= PWDATA[23:16];
            rPb_AMP      <= PWDATA[15:8];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG1)) begin   
            rYH0to1_1 <= PWDATA[9:0];
            rYH0to1_2 <= PWDATA[19:10];
            rYH0to1_3 <= PWDATA[29:20];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG2)) begin   
            rYH0to2_1 <= PWDATA[9:0];
            rYH0to2_2 <= PWDATA[19:10];
            rYH0to2_3 <= PWDATA[29:20];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG3)) begin   
            rYH2to1_1 <= PWDATA[9:0];
            rYH2to1_2 <= PWDATA[19:10];
            rYH2to1_3 <= PWDATA[29:20];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG4)) begin   
            rYLevel00<= PWDATA[9:0];
            rYLevel01<= PWDATA[19:10];
            rYLevel02<= PWDATA[29:20];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG5)) begin   
            rPH0to1_1 <= PWDATA[9:0];
            rPH0to1_2 <= PWDATA[19:10];
            rPH0to1_3 <= PWDATA[29:20];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG6)) begin   
            rPH0to2_1 <= PWDATA[9:0];
            rPH0to2_2 <= PWDATA[19:10];
            rPH0to2_3 <= PWDATA[29:20];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG7)) begin   
            rPH2to1_1 <= PWDATA[9:0];
            rPH2to1_2 <= PWDATA[19:10];
            rPH2to1_3 <= PWDATA[29:20];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG8)) begin   
            rPLevel00<= PWDATA[9:0];
            rPLevel01<= PWDATA[19:10];
            rPLevel02<= PWDATA[29:20];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG9)) begin   
            rH1 <= PWDATA[11:0];
            rH2 <= PWDATA[23:12];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG10)) begin   
            rH3 <= PWDATA[11:0];
            rH4 <= PWDATA[23:12];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG11)) begin   
            rH5 <= PWDATA[11:0];
            rH6 <= PWDATA[23:12];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG12)) begin   
            rH7 <= PWDATA[11:0];
            rH8 <= PWDATA[23:12];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG13)) begin   
            rH9  <= PWDATA[11:0];
            rH10 <= PWDATA[23:12];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG14)) begin   
            rACT_DISPLAY <= PWDATA[11:0];
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG15)) begin   
            rYR_para <= PWDATA[9:0]; 
            rYG_para <= PWDATA[19:10]; 
            rYB_para <= PWDATA[29:20]; 
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG16)) begin   
            rPbR_para <= PWDATA[9:0]; 
            rPbG_para <= PWDATA[19:10]; 
            rPbB_para <= PWDATA[29:20]; 
        end
        else if(WRITEOP && (PADDR[7:2] == `HD_ADDRREG17)) begin   
            rPrR_para <= PWDATA[9:0]; 
            rPrG_para <= PWDATA[19:10]; 
            rPrB_para <= PWDATA[29:20]; 
        end
    end
end

reg  [31:0] nextPRDATA      ;    // Mux, Register and Enable for PRDATA
reg  [31:0] ReadRegs        ;
reg  [31:0] iPRDATA         ;
wire ReadRegEn;

assign  ReadRegEn = (Valid & (~PWRITE));
assign  PRDATA = (PSEL) ? iPRDATA : 32'd0;

always @ (PADDR or ReadRegs )
begin : p_ReadMuxComb
    nextPRDATA = ReadRegs;  // Read as zero default
end

always @ (PADDR or 
          rENABLE or 
          rV_CNT_1d or
          rH_CNT_1d or
          rFIELD_CNT_1d or
          rOUT_MODE or
          rEN_NONINTERLACE or
          rEN_SQPIXEL or
          rEN_DAC2 or
          rEN_DAC1 or
          rEN_DAC0 or

          rHSYNC_WID or
          rBURST_WID or 
          rLUMA_DELAY or 
          rCHRO_DELAY or 
          rEN_INTERNAL_PATTERN or 
          rEN_REST_SCH or 
          rLUMA_FILTER_SEL or 
          rCHRO_FILTER_SEL or
          rSUB_PHASE or
          rSUB_REQ or
          rCOLOR_PATTERN_MODE or
          rEN_COLOR_KILL or

          rBRIGHT_LEV or
          rHUE_LEV or
          rSATURATION_CLEV or
          rSATURATION_YLEV or
          rBLANK_VALUE or
          rBLACK_VALUE or
          rBURST_STEP or
          rHSYNC_STEP or
          rBURST_CAL or

          rOUT_ENABLE or
          rINV_CbCr   or
          rOUT_16BIT  or
          rINV_FIELD  or
          rINV_BLANK  or
          rINV_HSYNC  or

          rEN_DAC34   or
          rBYPIDAC    or
          rBIASTEST0  or
          rBIASTEST1  or

          rHD_ENABLE or
          rHD_MODE or
          rEnSYNC_PbPr or
        rLUMA_AMP or
        rPr_AMP or
        rPb_AMP or

        rYH0to1_1 or
        rYH0to1_2 or
        rYH0to1_3 or
        rYH0to2_1 or
        rYH0to2_2 or
        rYH0to2_3 or
        rYH2to1_1 or
        rYH2to1_2 or
        rYH2to1_3 or

        rYLevel00 or
        rYLevel01 or
        rYLevel02 or

        rPH0to1_1 or
        rPH0to1_2 or
        rPH0to1_3 or
        rPH0to2_1 or
        rPH0to2_2 or
        rPH0to2_3 or
        rPH2to1_1 or
        rPH2to1_2 or
        rPH2to1_3 or

        rPLevel00 or
        rPLevel01 or
        rPLevel02 or
        
        rACT_DISPLAY or
        rH1 or
        rH2 or
        rH3 or
        rH4 or
        rH5 or
        rH6 or
        rH7 or
        rH8 or
        rH9 or
        rH10 or

        rYR_para or 
        rYG_para or 
        rYB_para or 
                   
        rPbR_para or 
        rPbG_para or 
        rPbB_para or 
                   
        rPrR_para or 
        rPrG_para or 
        rPrB_para 

         )
begin : p_RdRegMuxComb
    case (PADDR) 
    //synopsys parallel_case
        `VideoEncADDRREG0  : ReadRegs  = {rENABLE, rOUT_ENABLE, 1'b0, rV_CNT_1d, rH_CNT_1d, rFIELD_CNT_1d};
        `VideoEncADDRREG1  : ReadRegs  = {rOUT_MODE, 2'b00, 
                                          rEN_NONINTERLACE, 
                                          rEN_SQPIXEL, 
                                          rOUT_16BIT,  13'd0, 

                                          rBIASTEST1,
                                          rBIASTEST0,
                                          rBYPIDAC,
                                          rEN_DAC34,
                                          rINV_CbCr,
                                          rINV_FIELD,
                                          rINV_BLANK,
                                          rINV_HSYNC,

                                          rEN_DAC2, rEN_DAC1, rEN_DAC0 };

        `VideoEncADDRREG2  : ReadRegs  = {3'd0, rHSYNC_WID, rBURST_WID, rLUMA_DELAY, rCHRO_DELAY, 
                                          1'd0,
                                          rEN_INTERNAL_PATTERN,
                                          rCOLOR_PATTERN_MODE,
                                          rEN_REST_SCH, 
                                          rEN_COLOR_KILL, 
                                          3'd0, 
                                          rLUMA_FILTER_SEL, rCHRO_FILTER_SEL, 4'd0};

        `VideoEncADDRREG3  : ReadRegs  = {16'd0, rSUB_PHASE};
        `VideoEncADDRREG4  : ReadRegs  = rSUB_REQ;
        `VideoEncADDRREG5  : ReadRegs  = {2'd0,rBRIGHT_LEV, rHUE_LEV, rSATURATION_CLEV, rSATURATION_YLEV};
        `VideoEncADDRREG6  : ReadRegs  = {6'd0, rBLANK_VALUE, 6'd0, rBLACK_VALUE};
        `VideoEncADDRREG7  : ReadRegs  = {11'd0,rBURST_STEP, rBURST_CAL, rHSYNC_STEP};

        `HD_ADDRREG0: ReadRegs  = {rHD_ENABLE ,rHD_MODE, rEnSYNC_PbPr,
                                   4'd0,
                                   rPr_AMP, rPb_AMP, rLUMA_AMP};

        `HD_ADDRREG1: ReadRegs  = {2'd0, rYH0to1_3, rYH0to1_2, rYH0to1_1}; 
        `HD_ADDRREG2: ReadRegs  = {2'd0, rYH0to2_3, rYH0to2_2, rYH0to2_1}; 
        `HD_ADDRREG3: ReadRegs  = {2'd0, rYH2to1_3, rYH2to1_2, rYH2to1_1}; 
        `HD_ADDRREG4: ReadRegs  = {2'd0, rYLevel02, rYLevel01, rYLevel00}; 

        `HD_ADDRREG5: ReadRegs  = {2'd0, rPH0to1_3, rPH0to1_2, rPH0to1_1}; 
        `HD_ADDRREG6: ReadRegs  = {2'd0, rPH0to2_3, rPH0to2_2, rPH0to2_1}; 
        `HD_ADDRREG7: ReadRegs  = {2'd0, rPH2to1_3, rPH2to1_2, rPH2to1_1}; 
        `HD_ADDRREG8: ReadRegs  = {2'd0, rPLevel02, rPLevel01, rPLevel00}; 

        `HD_ADDRREG9:  ReadRegs  = {8'd0, rH2, rH1}; 
        `HD_ADDRREG10: ReadRegs  = {8'd0, rH4, rH3}; 
        `HD_ADDRREG11: ReadRegs  = {8'd0, rH6, rH5}; 
        `HD_ADDRREG12: ReadRegs  = {8'd0, rH8, rH7}; 
        `HD_ADDRREG13: ReadRegs  = {8'd0, rH10,rH9}; 
        `HD_ADDRREG14: ReadRegs  = {20'd0, rACT_DISPLAY}; 

        `HD_ADDRREG15: ReadRegs  = {2'd0, rYB_para,rYG_para,rYR_para}; 
        `HD_ADDRREG16: ReadRegs  = {2'd0, rPbB_para,rPbG_para,rPbR_para}; 
        `HD_ADDRREG17: ReadRegs  = {2'd0, rPrB_para,rPrG_para,rPrR_para}; 
        
         default  : ReadRegs  = {32{1'b0}};  // Read as zero default

    endcase
end 

always @ (posedge PCLK or negedge RESETn)
begin : p_PrdataSeq
    if ((!RESETn))
        iPRDATA <= {32{1'b0}};
    else if (ReadRegEn)
        iPRDATA <= nextPRDATA;
end

/////////////////////////////////


endmodule
