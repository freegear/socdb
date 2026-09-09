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

`timescale 1ns/10ps

`define VideoEncADDRREG0  4'b0000      //0x00   status register addr.
`define VideoEncADDRREG1  4'b0001      //0x04   Control register addr.
`define VideoEncADDRREG2  4'b0010      //0x08   Internal register addr.
`define VideoEncADDRREG3  4'b0011      //0x0C   Subcarrier adjust phase register addr.
`define VideoEncADDRREG4  4'b0100      //0x10   Subcarrier frequency step register addr.

`define VideoEncADDRREG5  4'b0101      //0x14   Image modify function reg.
`define VideoEncADDRREG6  4'b0110      //0x18   Out Level control0
`define VideoEncADDRREG7  4'b0111      //0x1C   Out Level control1


module VideoEncAPBinterace 
(

//  APB bus
    PCLK     ,
    RESETn  ,

    PENABLE  , 
    PSEL     , 
    PWRITE   , 
    PADDR    ,  //[4:2]  used
    PWDATA   ,  //[31:0] used
    PRDATA   ,  //[31:0] used

//input

    CLK,       // 27Mhz clock input

    FIELD_CNT,
    H_CNT,
    V_CNT,

//Register setting value output 
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
    BURST_CAL
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

input	[5:2]	PADDR;
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


// =====================================================================
// Level output function 
// ---------------------------------------------------------------------
function  [9:0] BlankLevOut;
    input [2:0] OutMode;
    input [9:0]RegisterSetting;
    begin
        if(RegisterSetting == 10'h0) begin
            case(OutMode)// synopsys parallel_case
                NTSCM: begin
                    BlankLevOut = BLANK_VALUE_NTSC;
                end
                NTSCJ: begin
                    BlankLevOut = BLANK_VALUE_NTSC;
                end
                PALM:  begin
                    BlankLevOut = BLANK_VALUE_PAL;
                end
                NTSC4:  begin
                    BlankLevOut = BLANK_VALUE_NTSC;
                end
                PAL:  begin
                    BlankLevOut = BLANK_VALUE_PAL;
                end
                PALNc:  begin
                    BlankLevOut = BLANK_VALUE_PAL;
                end
                PALN:  begin
                    BlankLevOut = BLANK_VALUE_PAL;
                end
                default: begin
                    BlankLevOut = 10'd0;
                end
            endcase
        end
        else begin
            BlankLevOut = RegisterSetting;
        end
    end
endfunction

// =====================================================================
// Black Level output function 
// ---------------------------------------------------------------------
function  [9:0] BlackLevOut;
    input [2:0] OutMode;
    input [9:0]RegisterSetting;
    begin
        if(RegisterSetting == 10'h0) begin
            case(OutMode)// synopsys parallel_case
                NTSCM: begin
                    BlackLevOut = BLACK_VALUE_75;
                end
                NTSCJ: begin
                    BlackLevOut = BLACK_VALUE_NORMAL;
                end
                PALM:  begin
                    BlackLevOut = BLACK_VALUE_75;
                end
                NTSC4:  begin
                    BlackLevOut = BLACK_VALUE_75;
                end
                PAL:  begin
                    BlackLevOut = BLACK_VALUE_NORMAL;
                end
                PALNc:  begin
                    BlackLevOut = BLACK_VALUE_NORMAL;
                end
                PALN:  begin
                    BlackLevOut = BLACK_VALUE_NORMAL;
                end
                default: begin
                    BlackLevOut = 10'd0;
                end
            endcase
        end
        else begin
            BlackLevOut = RegisterSetting;
        end
    end
endfunction

// =====================================================================
// Sub Step function 
// ---------------------------------------------------------------------
function [31:0] SubStepAddr;
    input [2:0] OutMode;
    input [31:0]RegisterSetting;
    begin
        if(RegisterSetting == 32'h0) begin
            case(OutMode)// synopsys parallel_case
                NTSCM: begin
                    SubStepAddr = StepNTSC;
                end
                NTSCJ: begin
                    SubStepAddr = StepNTSC;
                end
                PALM:  begin
                    SubStepAddr = StepPALM;
                end
                NTSC4:  begin
                    SubStepAddr = StepNTSC4;
                end
                PAL:  begin
                    SubStepAddr = StepNTSC4;
                end
                PALNc:  begin
                    SubStepAddr = StepPALNc;
                end
                default: begin
                    SubStepAddr = 32'd0;
                end
            endcase
        end
        else begin
            SubStepAddr = RegisterSetting;
        end
    end
endfunction


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


	end
	else	begin
		if(WRITEOP && (PADDR[5:2] == `VideoEncADDRREG0)) begin
            rENABLE     <= PWDATA[31];
            rOUT_ENABLE <= PWDATA[30];
        end
		else if(WRITEOP && (PADDR[5:2] == `VideoEncADDRREG1)) begin

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
        else if(WRITEOP && (PADDR[5:2] == `VideoEncADDRREG2)) begin   
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
        else if(WRITEOP && (PADDR[5:2] == `VideoEncADDRREG3)) begin   
            rSUB_PHASE          <= PWDATA[15:0];
        end
        else if(WRITEOP && (PADDR[5:2] == `VideoEncADDRREG4)) begin   
            rSUB_REQ            <= PWDATA[31:0];
        end
        else if(WRITEOP && (PADDR[5:2] == `VideoEncADDRREG5)) begin   
            rBRIGHT_LEV         <= PWDATA[29:24];
            rHUE_LEV            <= PWDATA[23:16];
            rSATURATION_CLEV    <= PWDATA[15:8];
            rSATURATION_YLEV    <= PWDATA[7:0];
        end
        else if(WRITEOP && (PADDR[5:2] == `VideoEncADDRREG6)) begin   
            rBLANK_VALUE        <= PWDATA[25:16];
            rBLACK_VALUE        <= PWDATA[9:0];
        end
        else if(WRITEOP && (PADDR[5:2] == `VideoEncADDRREG7)) begin   
            rBURST_STEP          <= PWDATA[20:16];
            rBURST_CAL          <= PWDATA[15:8];
            rHSYNC_STEP          <= PWDATA[7:0];
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
          rBIASTEST1  

         )
begin : p_RdRegMuxComb
    case (PADDR[5:2]) 
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
