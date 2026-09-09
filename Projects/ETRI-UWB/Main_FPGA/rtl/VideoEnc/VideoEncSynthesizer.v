// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : VideoEncSynthesizer.v
// File Revision       : 0.1
// ----------------------------------------------------------------
// Purpose            : This module makes the output signal that is 
//						composite, Y and C in video Encoder
// =================================================================

`timescale 1ns/10ps

module VideoEncSynthesizer(
    CLK,
    RESETn,

    //input
    HSYNC_ENABLE,
    BURST_ENABLE,
    ACT_DISPLAY_SYN,
    EN_COLOR_KILL,
    Filtered_Y,
    Filtered_U,
    Filtered_V,
    CHRO_DELAY,
    LUMA_DELAY,
    NTSC_PAL,
    BURST_NTSC_PAL,
    OUT_MODE,
    BURST_ID,
    SATURATION_YLEV,
    SATURATION_CLEV,

    RESET_ADDR,
    BRIGHT_LEV,
    BURST_STEP,
    BURST_CAL,
    BLACK_VALUE,
    BLANK_VALUE,
    HSYNC_STEP,

    SIN,
    COS,

	ENABLE,
    EN_DAC0,
    EN_DAC1,
    EN_DAC2,

    //output
    Composite2DAC0,
    Y2DAC1,
    C2DAC2

);

//Output format define///////
parameter NTSCM = 3'b000;
parameter NTSCJ = 3'b001;
parameter NTSC4 = 3'b010;
parameter PALM  = 3'b011;
parameter PAL   = 3'b100;
parameter PALNc = 3'b101;
parameter PALN  = 3'b110;
////////////////////////////

parameter BLACK_VALUE_75    = 282;
parameter BLACK_VALUE_NORMAL= 252; 

parameter BLANK_VALUE_NTSC  = 240;
parameter BLANK_VALUE_PAL   = 252;

parameter HSYNC_SLOPE_NTSC  = 4;
parameter HSYNC_SLOPE_PAL   = 7;

/*
parameter BURST_MAX_NTSC    = 112 ;
parameter BURST_MAX_PAL     = 117 ;
*/

/*
parameter BURST_MAX_NTSC    = 115 ;
parameter BURST_MAX_NTSC_P1 = 116 ;
parameter BURST_MAX_NTSC_P2 = 117 ;
parameter BURST_MAX_NTSC_P3 = 118 ;
parameter BURST_MAX_NTSC_P4 = 119 ;
parameter BURST_MAX_NTSC_M1 = 114 ;
parameter BURST_MAX_NTSC_M2 = 113 ;
parameter BURST_MAX_NTSC_M3 = 112 ;
parameter BURST_MAX_NTSC_M4 = 111 ;

parameter BURST_MAX_PAL     = 123 ;
parameter BURST_MAX_PAL_P1  = 124 ;
parameter BURST_MAX_PAL_P2  = 125 ;
parameter BURST_MAX_PAL_P3  = 126 ;
parameter BURST_MAX_PAL_P4  = 127 ;

parameter BURST_MAX_PAL_M1  = 122 ;
parameter BURST_MAX_PAL_M2  = 121 ;
parameter BURST_MAX_PAL_M3  = 120 ;
parameter BURST_MAX_PAL_M4  = 119 ;


parameter BURST_STEP_NTSC   = BURST_MAX_NTSC /8;
parameter BURST_STEP_PAL    = BURST_MAX_PAL  /8;
parameter HSYNC_STEP_NTSC   = (BLANK_VALUE_NTSC - 16)/HSYNC_SLOPE_NTSC;
parameter HSYNC_STEP_PAL    = (BLANK_VALUE_NTSC - 16)/HSYNC_SLOPE_PAL;

parameter BURST_STEP_NTSC0  = BURST_STEP_NTSC   ;
parameter BURST_STEP_NTSC1  = BURST_STEP_NTSC*2 ;
parameter BURST_STEP_NTSC2  = BURST_STEP_NTSC*3 ;
parameter BURST_STEP_NTSC3  = BURST_STEP_NTSC*4 ;
parameter BURST_STEP_NTSC4  = BURST_STEP_NTSC*5 ;
parameter BURST_STEP_NTSC5  = BURST_STEP_NTSC*6 ;
parameter BURST_STEP_NTSC6  = BURST_STEP_NTSC*7 ;
parameter BURST_STEP_NTSC7  = BURST_STEP_NTSC*8 ;

parameter BURST_STEP_PAL0  = BURST_STEP_PAL   ;
parameter BURST_STEP_PAL1  = BURST_STEP_PAL*2 ;
parameter BURST_STEP_PAL2  = BURST_STEP_PAL*3 ;
parameter BURST_STEP_PAL3  = BURST_STEP_PAL*4 ;
parameter BURST_STEP_PAL4  = BURST_STEP_PAL*5 ;
parameter BURST_STEP_PAL5  = BURST_STEP_PAL*6 ;
parameter BURST_STEP_PAL6  = BURST_STEP_PAL*7 ;
parameter BURST_STEP_PAL7  = BURST_STEP_PAL*8 ;

parameter HSYNC_STEP_NTSC0  = BLANK_VALUE_NTSC - HSYNC_STEP_NTSC*1;
parameter HSYNC_STEP_NTSC1  = BLANK_VALUE_NTSC - HSYNC_STEP_NTSC*2;
parameter HSYNC_STEP_NTSC2  = BLANK_VALUE_NTSC - HSYNC_STEP_NTSC*3;
parameter HSYNC_STEP_NTSC3  = 16;

parameter HSYNC_STEP_PAL0  = BLANK_VALUE_PAL - HSYNC_STEP_PAL*1;
parameter HSYNC_STEP_PAL1  = BLANK_VALUE_PAL - HSYNC_STEP_PAL*2;
parameter HSYNC_STEP_PAL2  = BLANK_VALUE_PAL - HSYNC_STEP_PAL*3;
parameter HSYNC_STEP_PAL3  = BLANK_VALUE_PAL - HSYNC_STEP_PAL*4;
parameter HSYNC_STEP_PAL4  = BLANK_VALUE_PAL - HSYNC_STEP_PAL*5;
parameter HSYNC_STEP_PAL5  = BLANK_VALUE_PAL - HSYNC_STEP_PAL*6;
parameter HSYNC_STEP_PAL6  = 16;
*/

input CLK;
input RESETn;

input HSYNC_ENABLE;
input BURST_ENABLE;
input ACT_DISPLAY_SYN;
input EN_COLOR_KILL;
input [9:0] Filtered_Y;
input [9:0] Filtered_U;
input [9:0] Filtered_V;
input [2:0] CHRO_DELAY;
input [2:0] LUMA_DELAY;
input NTSC_PAL;
input BURST_NTSC_PAL;
input [2:0] OUT_MODE;

input BURST_ID;

input [10:0] SIN;
input [10:0] COS;


input  [7:0] BURST_CAL;
input  [7:0] SATURATION_YLEV;
input  [7:0] SATURATION_CLEV;
input  ENABLE;
input  EN_DAC0;
input  EN_DAC1;
input  EN_DAC2;

output [9:0] Composite2DAC0;
output [9:0] Y2DAC1;
output [9:0] C2DAC2;

reg [9:0] Y2DAC1;
reg [9:0] C2DAC2;

wire [3:0] BURST_SLOPE = 4'd8;
reg  [2:0] HSYNC_SLOPE;


/*
reg  [9:0] BLACK_VALUE;
reg  [9:0] BLANK_VALUE;
*/

//reg    [9:0] BURST_MAX;
input  RESET_ADDR;
input  [5:0] BRIGHT_LEV;
input  [4:0] BURST_STEP;
input  [9:0] BLACK_VALUE;
input  [9:0] BLANK_VALUE;
input  [7:0] HSYNC_STEP;

//wire    [9:0] HSYNC_LOW = {5'd0, iHSYNC_LOW[4:0]};
wire	EnDAC0 = ENABLE & EN_DAC0;
wire	EnDAC1 = ENABLE & EN_DAC1;
wire	EnDAC2 = ENABLE & EN_DAC2;

// =====================================================================
// delay Burst enable / Active dispalay enable 
// ---------------------------------------------------------------------
// for sync with Y and C, dealy BURST and Active display 
 
reg BURST_ENABLE_0d /* synthesis syn_preserve =1 */;
reg BURST_ENABLE_1d /* synthesis syn_preserve =1 */;
reg BURST_ENABLE_2d /* synthesis syn_preserve =1 */;

reg ACT_DISPLAY_SYN_0d /* synthesis syn_preserve =1 */;
reg ACT_DISPLAY_SYN_1d /* synthesis syn_preserve =1 */;
reg ACT_DISPLAY_SYN_2d /* synthesis syn_preserve =1 */;
reg ACT_DISPLAY_SYN_3d /* synthesis syn_preserve =1 */;
reg ACT_DISPLAY_SYN_4d /* synthesis syn_preserve =1 */;

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        BURST_ENABLE_0d <= 0;
        BURST_ENABLE_1d <= 0;
        BURST_ENABLE_2d <= 0;
        ACT_DISPLAY_SYN_0d <= 0;
        ACT_DISPLAY_SYN_1d <= 0;
        ACT_DISPLAY_SYN_2d <= 0;
    end
    else begin
        BURST_ENABLE_0d <= BURST_ENABLE;
        BURST_ENABLE_1d <= BURST_ENABLE_0d;
        BURST_ENABLE_2d <= BURST_ENABLE_1d;

        ACT_DISPLAY_SYN_0d <= ACT_DISPLAY_SYN;
        ACT_DISPLAY_SYN_1d <= ACT_DISPLAY_SYN_0d;
        ACT_DISPLAY_SYN_2d <= ACT_DISPLAY_SYN_1d;
        ACT_DISPLAY_SYN_3d <= ACT_DISPLAY_SYN_2d;
        ACT_DISPLAY_SYN_4d <= ACT_DISPLAY_SYN_3d;
    end

end

// =======================================================================
// Burst / Hsync step counter
// -----------------------------------------------------------------------

//wire   [4:0]   BURST_STEP   = 14;//NTSC
//wire   [4:0]   BURST_STEP   = 15;//PAL
//wire   [7:0]   HSYNC_STEP  = 8'hC8;//NTSC
//wire   [7:0]   HSYNC_STEP  = 8'hDE;//PAL
//wire   [7:0]   BURST_CAL = 8'b10000000;

reg  [4:0] OldBurstStep;
reg  [3:0] StCnt;
reg  [1:0] CalState;
reg  [1:0] NxCalState;
reg  [8:0] AddB;
reg  [9:0] OldBLANK_VALUE;
reg  [7:0] OldHSYNC_STEP ;

wire ChValue = (OldHSYNC_STEP  == HSYNC_STEP) ? 1'b0 : 1'b1;

always @(ChValue or CalState or StCnt or NTSC_PAL or RESET_ADDR) begin

    NxCalState = 1'b0;
    case (CalState)
        2'd0 : begin
                if(RESET_ADDR | ChValue) NxCalState = 2'd1;
                else                     NxCalState = 2'd0;
               end
        2'd1: begin
                if(StCnt == 4'd7)     NxCalState = 2'd2;
                else                  NxCalState = 1'd1;
              end
        2'd2: begin
                NxCalState = 2'd3;
              end
        2'd3: begin
                if((StCnt == 4'd12) && !NTSC_PAL) NxCalState = 2'b0;
                else if((StCnt == 4'd15) &&  NTSC_PAL) NxCalState = 2'b0;
                else                              NxCalState = 2'd3;
              end
        
    endcase
end

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn)  CalState <= 0;
    else         CalState <= NxCalState;
end

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        StCnt <= 0;
    end
    else if(CalState==2'd0) StCnt <= 0;
    else                    StCnt <= StCnt + 1;
end

always @(CalState or BURST_STEP or HSYNC_STEP) begin
    case(CalState)
        2'd0:AddB = {3'b000, BURST_STEP};
        2'd1:AddB = {3'b000, BURST_STEP};
        2'd2:AddB = {HSYNC_STEP[7], HSYNC_STEP};
        2'd3:AddB = {HSYNC_STEP[7], HSYNC_STEP};
    endcase
end

reg  [8:0] BURST_STEP0;
reg  [8:0] BURST_STEP1;
reg  [8:0] BURST_STEP2;
reg  [8:0] BURST_STEP3;
reg  [8:0] BURST_STEP4;
reg  [8:0] BURST_STEP5;
reg  [8:0] BURST_STEP6;
reg  [8:0] BURST_STEP7;
reg  [8:0] ZeroBurstReg;

reg  [8:0] HSYNC_STEP0;
reg  [8:0] HSYNC_STEP1;
reg  [8:0] HSYNC_STEP2;
reg  [8:0] HSYNC_STEP3;
reg  [8:0] HSYNC_STEP4;
reg  [8:0] HSYNC_STEP5;
reg  [8:0] HSYNC_STEP6;

wire [8:0]  NxBurstStep     = ZeroBurstReg + AddB;


reg  [8:0] MULB;
reg  [9:0] MULA;

wire [17:0] ResultMUL       = MULA * MULB;
wire [17:0] YSatuUp         = ResultMUL;
wire [8:0]  NxBurstCalStep  = ResultMUL[15:7]; 

always @(ACT_DISPLAY_SYN or Filtered_Y or 
         SATURATION_YLEV or NxBurstStep or
         BURST_CAL
        ) begin

        if(ACT_DISPLAY_SYN) begin
            MULA = Filtered_Y;
            MULB = SATURATION_YLEV;
        end
        else begin
            MULA = {1'b0, NxBurstStep};
            MULB = {1'b0, BURST_CAL};
        end

end

//wire [16:0] TNxBurstCalStep = NxBurstStep * BURST_CAL; 
//wire [8:0]  NxBurstCalStep  = TNxBurstCalStep[15:7]; 

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        BURST_STEP0 <= 0;
        BURST_STEP1 <= 0;
        BURST_STEP2 <= 0;
        BURST_STEP3 <= 0;
        BURST_STEP4 <= 0;
        BURST_STEP5 <= 0;
        BURST_STEP6 <= 0;
        BURST_STEP7 <= 0;

        HSYNC_STEP0 <= 0;
        HSYNC_STEP1 <= 0;
        HSYNC_STEP2 <= 0;
        HSYNC_STEP3 <= 0;
        HSYNC_STEP4 <= 0;
        HSYNC_STEP5 <= 0;
        HSYNC_STEP6 <= 0;
        ZeroBurstReg <= 0;
    end
    else if(CalState==2'd0) begin
        ZeroBurstReg <= 0;
    end
    else if(CalState==2'd1) begin
        ZeroBurstReg <= NxBurstStep;
        case(StCnt[2:0])// synopsys parallel_case full_case
            3'd0:   BURST_STEP0 <= NxBurstCalStep; // NxBurstStep;
            3'd1:   BURST_STEP1 <= NxBurstCalStep;
            3'd2:   BURST_STEP2 <= NxBurstCalStep;
            3'd3:   BURST_STEP3 <= NxBurstCalStep;
            3'd4:   BURST_STEP4 <= NxBurstCalStep;
            3'd5:   BURST_STEP5 <= NxBurstCalStep;
            3'd6:   BURST_STEP6 <= NxBurstCalStep;
            3'd7:   BURST_STEP7 <= NxBurstCalStep;
        endcase
    end
    else if(CalState==2'd2) ZeroBurstReg <= BLANK_VALUE[8:0];
    else if(CalState==2'd3) begin
        ZeroBurstReg <= NxBurstStep;
        case(StCnt[2:0])// synopsys parallel_case full_case
            3'd1:   HSYNC_STEP0 <= NxBurstStep;
            3'd2:   HSYNC_STEP1 <= NxBurstStep;
            3'd3:   HSYNC_STEP2 <= NxBurstStep;
            3'd4:   HSYNC_STEP3 <= NxBurstStep;
            3'd5:   HSYNC_STEP4 <= NxBurstStep;
            3'd6:   HSYNC_STEP5 <= NxBurstStep;
            3'd7:   HSYNC_STEP6 <= NxBurstStep;
        endcase
    end

end


always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        OldHSYNC_STEP  <= 0;
    end
    else begin
        OldHSYNC_STEP  <= HSYNC_STEP;
    end

end

// =====================================================================
// HSYNC slope max counter mux and Blank /Black value mux
// ---------------------------------------------------------------------

always @(NTSC_PAL) begin
    case(NTSC_PAL) // synopsys parallel_case full_case 
        1'b0: begin /* NTSC */
                HSYNC_SLOPE = HSYNC_SLOPE_NTSC;
                //BURST_MAX   = BURST_MAX_NTSC;
              end
        1'b1: begin /* PAL */
                HSYNC_SLOPE = HSYNC_SLOPE_PAL;
                //BURST_MAX   = BURST_MAX_PAL;
              end
    endcase
end

/*
always @(NTSC_PAL or BURST_LEV) begin
    case({NTSC_PAL, BURST_LEV}) // synopsys parallel_case full_case 
        4'b0000: BURST_MAX = BURST_MAX_NTSC_M4;  
        4'b0001: BURST_MAX = BURST_MAX_NTSC_M3;  
        4'b0010: BURST_MAX = BURST_MAX_NTSC_M2;  
        4'b0011: BURST_MAX = BURST_MAX_NTSC_M1;  
        4'b0100: BURST_MAX = BURST_MAX_NTSC;  
        4'b0101: BURST_MAX = BURST_MAX_NTSC_P1;  
        4'b0110: BURST_MAX = BURST_MAX_NTSC_P2;  
        4'b0111: BURST_MAX = BURST_MAX_NTSC_P3;  
        4'b1000: BURST_MAX = BURST_MAX_PAL_M4;  
        4'b1001: BURST_MAX = BURST_MAX_PAL_M3;  
        4'b1010: BURST_MAX = BURST_MAX_PAL_M2;  
        4'b1011: BURST_MAX = BURST_MAX_PAL_M1;  
        4'b1100: BURST_MAX = BURST_MAX_PAL;  
        4'b1101: BURST_MAX = BURST_MAX_PAL_P1;  
        4'b1110: BURST_MAX = BURST_MAX_PAL_P2;  
        4'b1111: BURST_MAX = BURST_MAX_PAL_P3;  
    endcase
end
*/

/*
always @(OUT_MODE) begin
    case(OUT_MODE) // synopsys parallel_case 

        NTSCM: begin
                BLACK_VALUE = BLACK_VALUE_75;
                BLANK_VALUE = BLANK_VALUE_NTSC;
               end
        NTSCJ: begin
                BLACK_VALUE = BLACK_VALUE_NORMAL;
                BLANK_VALUE = BLANK_VALUE_NTSC;
               end
        NTSC4: begin
                BLACK_VALUE = BLACK_VALUE_75;
                BLANK_VALUE = BLANK_VALUE_NTSC;
               end
        PALM:  begin
                BLACK_VALUE = BLACK_VALUE_75;
                BLANK_VALUE = BLANK_VALUE_PAL;
               end
        PAL:   begin
                BLACK_VALUE = BLACK_VALUE_NORMAL;
                BLANK_VALUE = BLANK_VALUE_PAL;
               end
        PALNc: begin
                BLACK_VALUE = BLACK_VALUE_NORMAL;
                BLANK_VALUE = BLANK_VALUE_PAL;
               end
        PALN:  begin
                BLACK_VALUE = BLACK_VALUE_75;
                BLANK_VALUE = BLANK_VALUE_PAL;
               end
        default: 
               begin
                BLACK_VALUE = BLACK_VALUE_75;
                BLANK_VALUE = BLANK_VALUE_NTSC;
               end
    endcase
end
*/
// =====================================================================

reg [4:0] HsyncSlopCnt;
reg [4:0] BurstSlopCnt;

/* HsynSlopeCnt */
always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        HsyncSlopCnt <= 0;
    end
    else begin
        if(HSYNC_ENABLE && (HSYNC_SLOPE != HsyncSlopCnt)) begin
            HsyncSlopCnt <= HsyncSlopCnt + 1;
        end
        else if(HSYNC_ENABLE && (HSYNC_SLOPE <= HsyncSlopCnt)) begin
            HsyncSlopCnt <= HsyncSlopCnt;
        end
        else if(!HSYNC_ENABLE && (HsyncSlopCnt != 0)) begin
            HsyncSlopCnt <= HsyncSlopCnt - 1;
        end
        else if(!HSYNC_ENABLE && (HsyncSlopCnt == 0)) begin
            HsyncSlopCnt <= 0;
        end
    end
end

/* BurstSlopeCnt */
always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        BurstSlopCnt <= 0;
    end
    else begin
        if(BURST_ENABLE_2d && (BURST_SLOPE != BurstSlopCnt)) begin
            BurstSlopCnt <= BurstSlopCnt + 1;
        end
        else if(BURST_ENABLE_2d && (BURST_SLOPE == BurstSlopCnt)) begin
            BurstSlopCnt <= BurstSlopCnt;
        end
        else if(!BURST_ENABLE_2d && (BurstSlopCnt != 0)) begin
            BurstSlopCnt <= BurstSlopCnt - 1;
        end
        else if(!BURST_ENABLE_2d && (BurstSlopCnt == 0)) begin
            BurstSlopCnt <= 0;
        end
    end
end

// =====================================================================
// Y signal generation 
// ---------------------------------------------------------------------

reg [10:0] NextY;
reg [9:0]  SyncY;
reg [9:0]  SyncY_0d /* synthesis syn_preserve =1 */;
reg [9:0]  SyncY_1d /* synthesis syn_preserve =1 */;
reg [9:0]  SyncY_2d /* synthesis syn_preserve =1 */;
reg [9:0]  SyncY_3d /* synthesis syn_preserve =1 */;
reg [9:0]  SyncY_4d /* synthesis syn_preserve =1 */; //0 delay
reg [9:0]  SyncY_5d /* synthesis syn_preserve =1 */; //1
reg [9:0]  SyncY_6d /* synthesis syn_preserve =1 */; //2
reg [9:0]  SyncY_7d /* synthesis syn_preserve =1 */; //3
reg [9:0]  SyncY_8d /* synthesis syn_preserve =1 */; //4

//wire [17:0] YSatuUp      = Filtered_Y * SATURATION_YLEV;
wire [10:0] BrightY      = YSatuUp[17:7] + 
                           {BRIGHT_LEV[5],
                            BRIGHT_LEV[5],
                            BRIGHT_LEV[5],
                            BRIGHT_LEV[5:0], 2'd0};//, 1'd0}; 

wire [9:0]  YSaturation = (BrightY > 11'd739) ?  // over flow
                         ((BRIGHT_LEV[5]) ? 10'd0 : 10'd740) : //under flow
                           BrightY[9:0]; 

always @(ACT_DISPLAY_SYN or 
         HsyncSlopCnt or 
         BLANK_VALUE or
         BLACK_VALUE or
         YSaturation or
         NTSC_PAL or
         //HSYNC_LOW

         HSYNC_STEP0 or
         HSYNC_STEP1 or
         HSYNC_STEP2 or
         HSYNC_STEP3 or
         HSYNC_STEP4 or
         HSYNC_STEP5 or
         HSYNC_STEP6 

         ) begin

    if(ACT_DISPLAY_SYN) begin
        NextY = BLACK_VALUE + YSaturation; 
    end
    else if(!NTSC_PAL & !ACT_DISPLAY_SYN) begin // NTSC 
        case(HsyncSlopCnt)
            5'd0: NextY = BLANK_VALUE; 
            5'd1: NextY = {1'b0, HSYNC_STEP0}; 
            5'd2: NextY = {1'b0, HSYNC_STEP1}; 
            5'd3: NextY = {1'b0, HSYNC_STEP2}; 
            default: NextY ={1'b0, HSYNC_STEP3}; 
        endcase
    end
    else if(NTSC_PAL & !ACT_DISPLAY_SYN) begin  // PAL 
        case(HsyncSlopCnt)
            5'd0: NextY = BLANK_VALUE; 
            5'd1: NextY = {1'b0, HSYNC_STEP0}; 
            5'd2: NextY = {1'b0, HSYNC_STEP1}; 
            5'd3: NextY = {1'b0, HSYNC_STEP2}; 
            5'd4: NextY = {1'b0, HSYNC_STEP3}; 
            5'd5: NextY = {1'b0, HSYNC_STEP4}; 
            5'd6: NextY = {1'b0, HSYNC_STEP5}; 
            default: NextY = {1'b0, HSYNC_STEP6} ; 
        endcase
    end

    /*
    else if(!NTSC_PAL & !ACT_DISPLAY_SYN) begin // NTSC 
        case(HsyncSlopCnt)
            5'd0: NextY = BLANK_VALUE; 
            5'd1: NextY = HSYNC_STEP_NTSC0; 
            5'd2: NextY = HSYNC_STEP_NTSC1; 
            5'd3: NextY = HSYNC_STEP_NTSC2; 
            //default: NextY =HSYNC_STEP_NTSC3; 
            default: NextY =HSYNC_LOW; 
        endcase
    end
    else if(NTSC_PAL & !ACT_DISPLAY_SYN) begin  // PAL 
        case(HsyncSlopCnt)
            5'd0: NextY = BLANK_VALUE; 
            5'd1: NextY = HSYNC_STEP_PAL0; 
            5'd2: NextY = HSYNC_STEP_PAL1; 
            5'd3: NextY = HSYNC_STEP_PAL2; 
            5'd4: NextY = HSYNC_STEP_PAL3; 
            5'd5: NextY = HSYNC_STEP_PAL4; 
            5'd6: NextY = HSYNC_STEP_PAL5; 
            default: NextY =HSYNC_LOW; 
        endcase
    end
    */
end

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        SyncY    <= 0;
        SyncY_0d <= 0;
        SyncY_1d <= 0;
        SyncY_2d <= 0;
        SyncY_3d <= 0;
        SyncY_4d <= 0;

        SyncY_5d <= 0;
        SyncY_6d <= 0;
        SyncY_7d <= 0;
        SyncY_8d <= 0;
    end
    else begin
        SyncY    <= NextY;
        SyncY_0d <= SyncY;
        SyncY_1d <= SyncY_0d;
        SyncY_2d <= SyncY_1d;
        SyncY_3d <= SyncY_2d;
        SyncY_4d <= SyncY_3d;
        SyncY_5d <= SyncY_4d; // 1 delay
        SyncY_6d <= SyncY_5d; // 2
        SyncY_7d <= SyncY_6d; // 3
        SyncY_8d <= SyncY_7d; // 4
    end
end

reg  	[9:0] Y2DAC;

always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn) begin
		Y2DAC1 <= 0;
	end
	else if(EnDAC1) begin
		Y2DAC1 <= Y2DAC;
    end
    else begin
		Y2DAC1 <= 0;
    end
end

always @(LUMA_DELAY or 
		 ENABLE	or
         SyncY_4d   or
         SyncY_5d   or
         SyncY_6d   or
         SyncY_7d   or
         SyncY_8d) begin

    case({ENABLE, LUMA_DELAY}) // synopsys parallel_case 
        4'b1000: Y2DAC =  SyncY_4d; // 0 delay
        4'b1001: Y2DAC =  SyncY_5d; // 1 delay
        4'b1010: Y2DAC =  SyncY_6d; // 2 delay
        4'b1011: Y2DAC =  SyncY_7d; // 3 delay
        4'b1100: Y2DAC =  SyncY_8d; // 4 delay
        default: Y2DAC =  0; // disable  
    endcase
end

/* Sin and Cos gen */
//wire  [10:0] UnsignSIN = {1'b0, SIN[9:0]};
//wire  [10:0] UnsignCOS = {1'b0, COS[9:0]};

/* Burst Envelope x Sin */
// ===================================================================
// C signal generation
// -------------------------------------------------------------------

reg [9:0] NextU;
reg [9:0] NextV;
reg [8:0] RegU;
reg [8:0] RegV;
wire [17:0] MULU;
wire [17:0] MULV;

wire [18:0] SignedMULU;
wire [18:0] SignedMULV;
wire [9:0] RoundU; 
wire [9:0] RoundV; 
reg [9:0] rRoundU; 
reg [9:0] rRoundV; 
reg [9:0] NormalC;
reg  [9:0] RoundC_0d;
reg  [9:0] RoundC_1d;
reg  [9:0] RoundC_2d;
reg  [9:0] RoundC_3d;
reg  [9:0] RoundC_4d;

wire [9:0] UnSigFiltered_U = (Filtered_U[9]) ?  (~Filtered_U + 10'd1) : Filtered_U;
wire [9:0] UnSigFiltered_V = (Filtered_V[9]) ?  (~Filtered_V + 10'd1) : Filtered_V;

/*
wire [17:0] MulUnSigFiltered_U = UnSigFiltered_U * SATURATION_LEV;
wire [17:0] MulUnSigFiltered_V = UnSigFiltered_V * SATURATION_LEV; 
wire [9:0] LimUnSigFiltered_U = SatuOut(MulUnSigFiltered_U);
wire [9:0] LimUnSigFiltered_V = SatuOut(MulUnSigFiltered_V); 
*/

always @(ACT_DISPLAY_SYN_2d or 
         BurstSlopCnt or 
         UnSigFiltered_U or
         UnSigFiltered_V or
         /*
         LimUnSigFiltered_U or
         LimUnSigFiltered_V or
         Filtered_U or
         Filtered_V or
         BURST_MAX or
         */
         BURST_STEP0 or
         BURST_STEP1 or
         BURST_STEP2 or
         BURST_STEP3 or
         BURST_STEP4 or
         BURST_STEP5 or
         BURST_STEP6 or
         BURST_STEP7 or

         NTSC_PAL) begin

    if(ACT_DISPLAY_SYN_2d)       begin

        NextU = UnSigFiltered_U ; 
        NextV = UnSigFiltered_V ; 
        /*
        NextU = LimUnSigFiltered_U ; 
        NextV = LimUnSigFiltered_V ; 
        if(Filtered_U[9]) begin
            NextU = ~Filtered_U + 10'd1; 
        end else
            NextU = Filtered_U; 

        if(Filtered_V[9]) begin
            NextV = ~Filtered_V + 10'd1; 
        end else
            NextV = Filtered_V; 
        */

    end
    //else if(!NTSC_PAL & !ACT_DISPLAY_SYN_2d) begin //NTSC
    else if(!ACT_DISPLAY_SYN_2d) begin 
        NextV = 0;
        case(BurstSlopCnt) // synopsys parallel_case 
            5'd0: NextU = 0; 
            5'd1: NextU = {1'b0,BURST_STEP0};//BURST_STEP_NTSC0; 
            5'd2: NextU = {1'b0,BURST_STEP1};//BURST_STEP_NTSC1; 
            5'd3: NextU = {1'b0,BURST_STEP2};//BURST_STEP_NTSC2; 
            5'd4: NextU = {1'b0,BURST_STEP3};//BURST_STEP_NTSC3; 
            5'd5: NextU = {1'b0,BURST_STEP4};//BURST_STEP_NTSC4; 
            5'd6: NextU = {1'b0,BURST_STEP5};//BURST_STEP_NTSC5; 
            5'd7: NextU = {1'b0,BURST_STEP6};//BURST_STEP_NTSC6; 
            5'd8: NextU = {1'b0,BURST_STEP7};//BURST_MAX; 
            default: NextU =0; 
        endcase
    end
    /*
    else if(NTSC_PAL & !ACT_DISPLAY_SYN_2d) begin  // PAL 
        NextV = 0;
        case(BurstSlopCnt) // synopsys parallel_case 
            5'd0: NextU = 0; 
            5'd1: NextU = BURST_STEP_PAL0; 
            5'd2: NextU = BURST_STEP_PAL1; 
            5'd3: NextU = BURST_STEP_PAL2; 
            5'd4: NextU = BURST_STEP_PAL3; 
            5'd5: NextU = BURST_STEP_PAL4; 
            5'd6: NextU = BURST_STEP_PAL5; 
            5'd7: NextU = BURST_STEP_PAL6; 
            5'd8: NextU = BURST_MAX; 
            default: NextU = 0; 
        endcase
    end
    */
	else begin
		NextU = 0;
		NextV = 0;
	end

end

reg SignU;
reg SignV;

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        RegU  <= 0;
        RegV  <= 0;
        SignU <= 0;
        SignV <= 0;
    end
    else begin
        RegU <= NextU[8:0];
        RegV <= NextV[8:0];
        SignU <= Filtered_U[9];
        SignV <= Filtered_V[9];
    end
end

assign MULU = RegU * SIN[9:0];
assign MULV = RegV * COS[9:0];

assign SignedMULU = SignUV(MULU, SignU, SIN[10]);
assign SignedMULV = SignUV(MULV, SignV, COS[10]);

assign RoundU = SignedMULU[18:9];
assign RoundV = SignedMULV[18:9];

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        rRoundU <= 0;
        rRoundV <= 0;
    end
    else begin
        rRoundU <= RoundU;
        rRoundV <= RoundV;
    end
end

always @(BURST_NTSC_PAL or
         rRoundU or rRoundV or 
         BURST_ID
        ) begin

    case({BURST_NTSC_PAL, BURST_ID})

        2'b10: begin /* PAL BURST_ID = 0 */
                NormalC = rRoundU - rRoundV;
               end
        default: begin 
                NormalC = rRoundU + rRoundV;
               end
    endcase
end

wire [9:0]  UnSigNormal    = (NormalC[9]) ? (~NormalC + 10'd1) : NormalC;
wire [17:0] SatuNormalCMul = UnSigNormal * SATURATION_CLEV;
wire [9:0]  UnSigSatuNormal= SatuOut(SatuNormalCMul);
wire [9:0]  SigSatuNormal  = (NormalC[9]) ? (~UnSigSatuNormal + 10'd1) : UnSigSatuNormal; 
wire [9:0]  SatuNormal     = (ACT_DISPLAY_SYN_4d) ? SigSatuNormal : NormalC;

reg  [9:0] C2DAC;

always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn) begin
		C2DAC2 <= 0;
	end
	else if(EnDAC2)begin
		C2DAC2 <= C2DAC + 512;
	end
    else begin
		C2DAC2 <= 0;
    end
end

always @(CHRO_DELAY or 
		 ENABLE	or
         RoundC_0d  or
         RoundC_1d  or
         RoundC_2d  or
         RoundC_3d  or
         RoundC_4d ) begin  

    case({ENABLE, CHRO_DELAY}) // synopsys parallel_case 
        4'b1000: C2DAC = RoundC_0d;
        4'b1001: C2DAC = RoundC_1d;
        4'b1010: C2DAC = RoundC_2d;
        4'b1011: C2DAC = RoundC_3d;
        4'b1100: C2DAC = RoundC_4d;
        default: C2DAC = 0;
    endcase
end

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        RoundC_0d <= 0;
        RoundC_1d <= 0;
        RoundC_2d <= 0;
        RoundC_3d <= 0;
        RoundC_4d <= 0;
    end
    else begin
        //RoundC_0d <= NormalC;
        RoundC_0d <= SatuNormal;
        RoundC_1d <= RoundC_0d;
        RoundC_2d <= RoundC_1d;
        RoundC_3d <= RoundC_2d;
        RoundC_4d <= RoundC_3d;
    end
end

// =====================================================================
// CVBS signal generation 
// ---------------------------------------------------------------------
wire [11:0] AddCvbs;
wire [9:0]  cvbs;
wire [10:0] cvbsB;
reg  [9:0]  cvbs_0d;
reg  [9:0]  cvbs_1d;


assign AddCvbs = {C2DAC[9], C2DAC[9], C2DAC} + {2'b0,Y2DAC};
assign cvbsB   = CvbsOut(AddCvbs);

//assign cvbsB = (EN_COLOR_KILL) ? {1'b0,Y2DAC} : ({C2DAC[9], C2DAC} + {Y2DAC[9],Y2DAC});
//assign cvbs  = CvbsOut(cvbsB);
assign Composite2DAC0 = (EnDAC0) ? cvbs_0d : 0;

assign cvbs = (EN_COLOR_KILL) ? {Y2DAC} : (cvbsB);

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        cvbs_0d <= 0;
    end
    else begin
        cvbs_0d <= cvbs;
    end
end

// =====================================================================
// UV add signal function
// ---------------------------------------------------------------------
function  [18:0] SignUV;
    input [17:0] A;
    input SignA;
    input SignB;
    begin
        if(SignA ^ SignB) begin
            SignUV = ~A + 19'd1;
        end
        else begin
            SignUV = A;
        end
    end
endfunction

// =====================================================================
// Ov saturation 
// ---------------------------------------------------------------------
function  [9:0] SatuOut;
    input [17:0] In;
    begin
        if(In[17:7] > 10'd500) begin 
            SatuOut = 10'd500;
        end
        else begin 
            SatuOut = In[16:7];
        end
    end
endfunction

// =====================================================================
// Ov saturation 
// ---------------------------------------------------------------------
function [9:0]CvbsOut;
    input [11:0] In;
    begin
        if(In > 1023 && In[11]) begin
            CvbsOut = 10'd0;
        end
        else if(In > 1023 && !In[11]) begin
            CvbsOut = 10'd1023;
        end
        else begin
            CvbsOut = In[9:0];
        end
    end
endfunction
endmodule
