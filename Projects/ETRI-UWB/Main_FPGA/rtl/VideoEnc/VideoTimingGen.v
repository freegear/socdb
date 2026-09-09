// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : VideoTimingGen.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is Timing genreation in VideoEnc
// =======================================================================

`timescale 1ns/10ps

module VideoTimingGen
(
    //Interface signal 
    CLK,       // 27Mhz clock input
    RESETn,
    HSYNCn,
    VSYNCn,

    //Setting Signal input
    ENABLE,
    EN_SQPIXEL,
    EN_NONINTERLACE,
    EN_INTERNAL_PATTERN,

    OUT_MODE,

    BURST_WID,
    HSYNC_WID,

    MASTER_SLAVE_SEL,
    INTERMODE_SEL,

    //Control output
    ACT_DISPLAY_SYN,
    ACT_DISPLAY_ADDR,
    ACT_DISPLAY_INTER,
    F_COUNTER_INTER,
    H_COUNTER_INTER,
    V_COUNTER_INTER,
    HSYNC_ENABLE,
    BURST_ENABLE,
    BURST_ENABLE_ADDR,
    RESET_ADDR,
    BURST_ID,
    NTSC_PAL,
    BURST_NTSC_PAL
);

// =======================================================================
//  Defined Level 
// -----------------------------------------------------------------------
parameter HSYNC_LOW_NTSC=  16;
parameter HSYNC_LOW_PAL =  16;

parameter YSCALE_NTSC =    605; 
parameter USCALE_NTSC =    516;
parameter VSCALE_NTSC =    718;

parameter YSCALE_NTSCJ =   654; 
parameter USCALE_NTSCJ =   558;
parameter VSCALE_NTSCJ =   787;

parameter YSCALE_PAL   =  640; 
parameter USCALE_PAL   =  546;
parameter VSCALE_PAL   =  770;

parameter BLANK_VALUE_NTSC=    240;

parameter BLANK_VALUE_PAL =    252;

parameter BLANK_VALUE_C   =    512;

parameter BLACK_VALUE_NTSC=    282;
parameter BLACK_VALUE_PAL =    252;  

/* Pixel & Line define */
//WorkBook 4.Timingcounterblock.4.i
parameter TOTAL_PIXEL_NTSC=        1716;
parameter TOTAL_PIXEL_PAL =        1728;
parameter TOTAL_PIXEL_SQ_NTSC=     1560;
parameter TOTAL_PIXEL_SQ_PAL =     1888;

parameter TOTAL_PIXEL_NTSCM1=        1715;
parameter TOTAL_PIXEL_PALM1 =        1727;
parameter TOTAL_PIXEL_SQ_NTSCM1=     1559;
parameter TOTAL_PIXEL_SQ_PALM1 =     1887;


parameter TOTAL_LINE_NTSC    =     525;
parameter TOTAL_LINE_PAL     =     625;
parameter TOTAL_DISPLAY_LINE_NTSC= 480;
parameter TOTAL_DISPLAY_LINE_PAL=  576;

parameter TOTAL_LINE_NTSC_NOINTER =        262;
parameter TOTAL_LINE_PAL_NOINTER  =        312;
parameter TOTAL_DISPLAY_LINE_NTSC_NOINTER= 240;
parameter TOTAL_DISPLAY_LINE_PAL_NOINTER=  288;

parameter CHANGE_FIELDS0_NTSC  =   525;
parameter CHANGE_FIELDS1_NTSC  =   263;

parameter CHANGE_FIELDS0_NTSC_NOINTER  =   252;

parameter CHANGE_FIELDS0_PAL  =    625;     
parameter CHANGE_FIELDS1_PAL  =    313;

parameter CHANGE_FIELDS0_PAL_NOINTER  =    312;     


parameter ACTIVE_TOTAL_PIXEL_NTSC_RGB=     2160; /* Active 720 Lines */
parameter ACTIVE_TOTAL_PIXEL_PAL_RGB =     2160; /* Active 720 Lines */
parameter ACTIVE_TOTAL_PIXEL_SQ_NTSC_RGB = 1920; /* Active 640 Lines */
parameter ACTIVE_TOTAL_PIXEL_SQ_PAL_RGB  = 2304; /* Active 768 Lines */

parameter BURST_MAX_NTSC    =      112;
parameter BURST_MAX_PAL     =      117;

parameter HSYNC_START_NTSC  =      16*2;    
parameter HSYNC_START_NTSC_HALF  = HSYNC_START_NTSC + (TOTAL_PIXEL_NTSC/2);    
parameter HSYNC_WIDTH_NTSC    =      125+HSYNC_START_NTSC;    
parameter HSYNC_WIDTH_NTSCP2  =      125+HSYNC_START_NTSC+2;    
parameter HSYNC_WIDTH_NTSCP1  =      125+HSYNC_START_NTSC+1;    
parameter HSYNC_WIDTH_NTSCM2  =      125+HSYNC_START_NTSC-2;    
parameter HSYNC_WIDTH_NTSCM1  =      125+HSYNC_START_NTSC-1;    


parameter HSYNC_REMAIN_NTSC =      (TOTAL_PIXEL_NTSC/2) - HSYNC_WIDTH_NTSC;
parameter HSYNC_REMAIN_NTSC1=      (TOTAL_PIXEL_NTSC) - HSYNC_WIDTH_NTSC;
parameter HSYNC_WIDTH_NTSC1 =      (TOTAL_PIXEL_NTSC/2)+125+HSYNC_START_NTSC;    
parameter HSYNC_WIDTH_NTSC_HALF  = (124/2)+HSYNC_START_NTSC ;    
parameter HSYNC_WIDTH_NTSC_HALF1 = (TOTAL_PIXEL_NTSC/2)+HSYNC_WIDTH_NTSC_HALF;    

parameter BURST_START_NTSC  =      170;
parameter BURST_WIDTH_NTSC  =      66 + BURST_START_NTSC;

parameter BURST_WIDTH_NTSCP1  =      66 + BURST_START_NTSC+1;
parameter BURST_WIDTH_NTSCM1  =      66 + BURST_START_NTSC-1;


parameter COLOR_START_NTSC  =      276;        
parameter HSYNC_SLOPE_NTSC  =      4;
parameter BURST_SLOPE_NTSC  =      8;

parameter HSYNC_START_SQ_NTSC  =   22*2;    
parameter HSYNC_START_SQ_NTSC_HALF=HSYNC_START_SQ_NTSC + (TOTAL_PIXEL_SQ_NTSC/2) ;    

parameter HSYNC_WIDTH_SQ_NTSC  	 =   121 + HSYNC_START_SQ_NTSC;    
parameter HSYNC_WIDTH_SQ_NTSCP2  =   121 + HSYNC_START_SQ_NTSC+2;    
parameter HSYNC_WIDTH_SQ_NTSCP1  =   121 + HSYNC_START_SQ_NTSC+1;    
parameter HSYNC_WIDTH_SQ_NTSCM2  =   121 + HSYNC_START_SQ_NTSC-2;    
parameter HSYNC_WIDTH_SQ_NTSCM1  =   121 + HSYNC_START_SQ_NTSC-1;    

parameter HSYNC_WIDTH_SQ_NTSC1 =   (TOTAL_PIXEL_SQ_NTSC/2)+121 + HSYNC_START_SQ_NTSC;    
parameter HSYNC_WIDTH_SQ_NTSC_HALF  =  (120/2)+ HSYNC_START_SQ_NTSC;    
parameter HSYNC_WIDTH_SQ_NTSC_HALF1 =  (TOTAL_PIXEL_SQ_NTSC/2)+HSYNC_WIDTH_SQ_NTSC_HALF;    
parameter BURST_START_SQ_NTSC  =   168;
parameter BURST_WIDTH_SQ_NTSC  =   66  +BURST_START_SQ_NTSC;

parameter BURST_WIDTH_SQ_NTSCP1  =   66  +BURST_START_SQ_NTSC+1;
parameter BURST_WIDTH_SQ_NTSCM1  =   66  +BURST_START_SQ_NTSC-1;

parameter COLOR_START_SQ_NTSC  =   280;        
parameter HSYNC_SLOPE_SQ_NTSC  =   4;
parameter HSYNC_REMAIN_SQ_NTSC =   (TOTAL_PIXEL_SQ_NTSC/2) - HSYNC_WIDTH_SQ_NTSC;
parameter HSYNC_REMAIN_SQ_NTSC1=   (TOTAL_PIXEL_SQ_NTSC) - HSYNC_WIDTH_SQ_NTSC;
parameter BLANK_VALUE_7_5      =   42;

parameter HSYNC_START_PAL      =   12*2;
parameter HSYNC_START_PAL_HALF =   HSYNC_START_PAL + (TOTAL_PIXEL_PAL/2);
parameter HSYNC_WIDTH_PAL      =   133 + HSYNC_START_PAL;

parameter HSYNC_WIDTH_PALP2      =   133 + HSYNC_START_PAL+2;
parameter HSYNC_WIDTH_PALP1      =   133 + HSYNC_START_PAL+1;
parameter HSYNC_WIDTH_PALM2      =   133 + HSYNC_START_PAL-2;
parameter HSYNC_WIDTH_PALM1      =   133 + HSYNC_START_PAL-1;



parameter HSYNC_WIDTH_PAL1     =   (TOTAL_PIXEL_PAL/2) + 133 + HSYNC_START_PAL;
parameter HSYNC_WIDTH_PAL_HALF =   (132/2)+ HSYNC_START_PAL;
parameter HSYNC_WIDTH_PAL_HALF1=   HSYNC_WIDTH_PAL_HALF+(TOTAL_PIXEL_PAL/2) ;
parameter BURST_START_PAL      =   170;
parameter BURST_WIDTH_PAL      =   66 + BURST_START_PAL      ;


parameter BURST_WIDTH_PALP1      =   66 + BURST_START_PAL+1      ;
parameter BURST_WIDTH_PALM1      =   66 + BURST_START_PAL-1      ;

parameter COLOR_START_PAL      =   288;
parameter HSYNC_SLOPE_PAL      =   7;
parameter BURST_SLOPE_PAL      =   8;
parameter HSYNC_REMAIN_PAL     =   (TOTAL_PIXEL_PAL/2) - HSYNC_WIDTH_PAL;
parameter HSYNC_REMAIN_PAL1    =   (TOTAL_PIXEL_PAL) - HSYNC_WIDTH_PAL;

parameter HSYNC_START_SQ_PAL   =   21*2;
parameter HSYNC_START_SQ_PAL_HALF   =   HSYNC_START_SQ_PAL +  (TOTAL_PIXEL_SQ_PAL/2);
parameter HSYNC_WIDTH_SQ_PAL   =   144 + HSYNC_START_SQ_PAL;


parameter HSYNC_WIDTH_SQ_PALP2   =   144 + HSYNC_START_SQ_PAL+2;
parameter HSYNC_WIDTH_SQ_PALP1   =   144 + HSYNC_START_SQ_PAL+1;
parameter HSYNC_WIDTH_SQ_PALM2   =   144 + HSYNC_START_SQ_PAL-2;
parameter HSYNC_WIDTH_SQ_PALM1   =   144 + HSYNC_START_SQ_PAL-1;


parameter HSYNC_WIDTH_SQ_PAL1  =   (TOTAL_PIXEL_SQ_PAL/2)+144+HSYNC_START_SQ_PAL;
parameter HSYNC_WIDTH_SQ_PAL_HALF = (144/2) + HSYNC_START_SQ_PAL;
parameter HSYNC_WIDTH_SQ_PAL_HALF1= HSYNC_WIDTH_SQ_PAL_HALF +(TOTAL_PIXEL_SQ_PAL/2);
parameter BURST_START_SQ_PAL   =   202;
parameter BURST_WIDTH_SQ_PAL   =   72+ BURST_START_SQ_PAL   ;
parameter BURST_WIDTH_SQ_PALP1   =   72+ BURST_START_SQ_PAL+1   ;
parameter BURST_WIDTH_SQ_PALM1   =   72+ BURST_START_SQ_PAL-1   ;
parameter COLOR_START_SQ_PAL   =   352;
parameter HSYNC_SLOPE_SQ_PAL   =   7;
parameter BURST_SLOPE_SQ_PAL   =   8;
parameter BLANK_VALUE_0        =   0;
parameter HSYNC_REMAIN_SQ_PAL  =   (TOTAL_PIXEL_SQ_PAL/2) - HSYNC_WIDTH_SQ_PAL;
parameter HSYNC_REMAIN_SQ_PAL1 =   (TOTAL_PIXEL_SQ_PAL) - HSYNC_WIDTH_SQ_PAL;

/* Equalizing area 0~3 */
parameter EQUALIZING_AREA0_START_NTSC  =   523;
parameter EQUALIZING_AREA0_END_NTSC    =   525;
parameter EQUALIZING_AREA1_START_NTSC  =   4;
parameter EQUALIZING_AREA1_END_NTSC    =   6;
parameter EQUALIZING_AREA2_START_NTSC  =   261;
parameter EQUALIZING_AREA2_END_NTSC    =   262;
parameter EQUALIZING_AREA3_START_NTSC  =   267;
parameter EQUALIZING_AREA3_END_NTSC    =   268;

parameter EQUALIZING_AREA0_START_NTSC_NOINTER  =   260;
parameter EQUALIZING_AREA0_END_NTSC_NOINTER    =   262;
parameter EQUALIZING_AREA1_START_NTSC_NOINTER  =   4;
parameter EQUALIZING_AREA1_END_NTSC_NOINTER    =   6;

parameter EQUALIZING_AREA0_START_PAL  =    624;      
parameter EQUALIZING_AREA0_END_PAL    =    625;
parameter EQUALIZING_AREA1_START_PAL  =    4;
parameter EQUALIZING_AREA1_END_PAL    =    5;
parameter EQUALIZING_AREA2_START_PAL  =    311;
parameter EQUALIZING_AREA2_END_PAL    =    312;
parameter EQUALIZING_AREA3_START_PAL  =    316;
parameter EQUALIZING_AREA3_END_PAL    =    317;

parameter EQUALIZING_AREA0_START_PAL_NOINTER   =   311;
parameter EQUALIZING_AREA0_END_PAL_NOINTER     =   312; 
parameter EQUALIZING_AREA1_START_PAL_NOINTER   =   4;
parameter EQUALIZING_AREA1_END_PAL_NOINTER     =   5;

parameter EQUALIZING_AREA0_START_MPAL  =   523;
parameter EQUALIZING_AREA0_END_MPAL    =   525;
parameter EQUALIZING_AREA1_START_MPAL  =   4;
parameter EQUALIZING_AREA1_END_MPAL    =   6;
parameter EQUALIZING_AREA2_START_MPAL  =   261;
parameter EQUALIZING_AREA2_END_MPAL    =   262;
parameter EQUALIZING_AREA3_START_MPAL  =   267;
parameter EQUALIZING_AREA3_END_MPAL    =   268;


/* Serration area 0~1 */
parameter SERRATION_AREA0_START_NTSC   =   1;
parameter SERRATION_AREA0_END_NTSC     =   3;
parameter SERRATION_AREA1_START_NTSC   =   264;
parameter SERRATION_AREA1_END_NTSC     =   265;

parameter SERRATION_AREA0_START_NTSC_NOINTER  =    1;
parameter SERRATION_AREA0_END_NTSC_NOINTER    =    3;

parameter SERRATION_AREA0_START_PAL   =    1;
parameter SERRATION_AREA0_END_PAL     =    2;
parameter SERRATION_AREA1_START_PAL   =    314;
parameter SERRATION_AREA1_END_PAL     =    315;

parameter SERRATION_AREA0_START_PAL_NOINTER  =     1;
parameter SERRATION_AREA0_END_PAL_NOINTER    =     2;

parameter SERRATION_AREA0_START_MPAL   =   1;
parameter SERRATION_AREA0_END_MPAL     =   3;
parameter SERRATION_AREA1_START_MPAL   =   264 ;
parameter SERRATION_AREA1_END_MPAL     =   265;


/* Serration and Equalizing area 0  include active video*/
parameter SERREQ_AREA0_NTSC            =   260;
parameter SERREQ_AREA0_PAL             =   623;

parameter SERREQ_AREA0_MPAL            =   260;

/* Serration and Equalizing area 1 non-active video*/
parameter SERREQ_AREA1_NTSC            =   266;
parameter SERREQ_AREA1_PAL             =   3;

parameter SERREQ_AREA1_PAL_NOINTER     =   3;

parameter SERREQ_AREA1_MPAL            =   266;

/* Equalizing and Serration area */
parameter EQSERR_AREA0_NTSC            =   263;
parameter EQSERR_AREA0_PAL             =   313;

parameter EQSERR_AREA0_MPAL            =   263;

/* Equalizing and blank area */
parameter EQBLANK_AREA0_NTSC           =   269;
parameter EQBLANK_AREA0_PAL            =   318;

parameter EQBLANK_AREA0_MPAL           =   269;

/* burst disable area field 1 ~ field 8 */
parameter BURST_AREA1_START_NTSC   =   1;
parameter BURST_AREA1_END_NTSC     =   6;
parameter BURST_AREA2_START_NTSC   =   261;
parameter BURST_AREA2_END_NTSC     =   269;
parameter BURST_AREA3_START_NTSC   =   523;
parameter BURST_AREA3_END_NTSC     =   525;

parameter BURST_AREA1_START_NTSC_NOINTER   =   1;
parameter BURST_AREA1_END_NTSC_NOINTER     =   6;
parameter BURST_AREA2_START_NTSC_NOINTER   =   260;
parameter BURST_AREA2_END_NTSC_NOINTER     =   262;

parameter BURST_AREA1_START_PAL0   =   1;
parameter BURST_AREA1_END_PAL0     =   6;
parameter BURST_AREA2_START_PAL0   =   310;
parameter BURST_AREA2_END_PAL0     =   318;
parameter BURST_AREA3_START_PAL0   =   623;
parameter BURST_AREA3_END_PAL0     =   625 ;

parameter BURST_AREA1_START_PAL1   =   1;
parameter BURST_AREA1_END_PAL1     =   5;
parameter BURST_AREA2_START_PAL1   =   311;
parameter BURST_AREA2_END_PAL1     =   319;
parameter BURST_AREA3_START_PAL1   =   622;
parameter BURST_AREA3_END_PAL1     =   625 ;

parameter BURST_AREA1_START_PAL0_NOINTER  =    1;
parameter BURST_AREA1_END_PAL0_NOINTER    =    6;
parameter BURST_AREA2_START_PAL0_NOINTER  =    311;
parameter BURST_AREA2_END_PAL0_NOINTER    =    312;

parameter BURST_AREA1_START_MPAL0   =   1;
parameter BURST_AREA1_END_MPAL0     =   8;
parameter BURST_AREA2_START_MPAL0   =   260;
parameter BURST_AREA2_END_MPAL0     =   270;
parameter BURST_AREA3_START_MPAL0   =   523;
parameter BURST_AREA3_END_MPAL0     =   525 ;

parameter BURST_AREA1_START_MPAL1   =   1;
parameter BURST_AREA1_END_MPAL1     =   7;
parameter BURST_AREA2_START_MPAL1   =   259;
parameter BURST_AREA2_END_MPAL1     =   269;
parameter BURST_AREA3_START_MPAL1   =   522;
parameter BURST_AREA3_END_MPAL1     =   525 ;

parameter BURST_AREA1_START_MPAL_NOINTER   =   1;
parameter BURST_AREA1_END_MPAL_NOINTER     =   6;
parameter BURST_AREA2_START_MPAL_NOINTER   =   260;
parameter BURST_AREA2_END_MPAL_NOINTER     =   262;

/* Active video area */
parameter ACTIVE_FIELD1_START_NTSC  =  20;
parameter ACTIVE_FIELD1_END_NTSC    =  259;
parameter ACTIVE_FIELD2_START_NTSC  =  283;
parameter ACTIVE_FIELD2_END_NTSC    =  522;

parameter ACTIVE_FIELD1_START_NTSC_NOINTER =  20;
parameter ACTIVE_FIELD1_END_NTSC_NOINTER   =  259;

parameter ACTIVE_FIELD1_START_PAL   = 23;
parameter ACTIVE_FIELD1_END_PAL     = 310;
parameter ACTIVE_FIELD2_START_PAL   = 336;
parameter ACTIVE_FIELD2_END_PAL     = 623;

parameter ACTIVE_FIELD1_START_PAL_NOINTER =  23;
parameter ACTIVE_FIELD1_END_PAL_NOINTER   =  310;

parameter ACTIVE_TOTAL_PIXEL_NTSC    = 1440+COLOR_START_NTSC; /* Active 720 Lines */
parameter ACTIVE_TOTAL_PIXEL_PAL     = 1440+COLOR_START_PAL; /* Active 720 Lines */
parameter ACTIVE_TOTAL_PIXEL_SQ_NTSC = 1280+COLOR_START_SQ_NTSC; /* Active 640 Lines */
parameter ACTIVE_TOTAL_PIXEL_SQ_PAL  = 1536+COLOR_START_SQ_PAL; /* Active 768 Lines */

// =======================================================================
// Output format define
// -----------------------------------------------------------------------
parameter NTSCM = 3'b000;
parameter NTSCJ = 3'b001;
parameter NTSC4 = 3'b010;
parameter PALM  = 3'b011;
parameter PAL   = 3'b100;
parameter PALNc = 3'b101;
parameter PALN  = 3'b110;
////////////////////////////

// =======================================================================
// Input & Ouput define
// -----------------------------------------------------------------------
input  CLK;
input  RESETn;

input  HSYNCn;
input  VSYNCn;

input  ENABLE;
input  EN_SQPIXEL;
input  EN_NONINTERLACE;
input  EN_INTERNAL_PATTERN;


input  [2:0]   OUT_MODE;
input  [1:0]   BURST_WID;
input  [2:0]   HSYNC_WID;
input  MASTER_SLAVE_SEL;
input  [1:0]   INTERMODE_SEL;


output  ACT_DISPLAY_SYN;
output  ACT_DISPLAY_ADDR;
output  ACT_DISPLAY_INTER;
output  [4:0]   F_COUNTER_INTER;
output  [10:0]  H_COUNTER_INTER;
output  [9:0]   V_COUNTER_INTER;
output  HSYNC_ENABLE;
output  BURST_ENABLE;
output  BURST_ENABLE_ADDR;
output  RESET_ADDR;
output  BURST_ID;
output  NTSC_PAL;
output  BURST_NTSC_PAL;

// =======================================================================
// Register & Wire define
// -----------------------------------------------------------------------
//parameter selection
reg [10:0] HSYNC_START; 
reg [10:0] HSYNC_START_HALF; 
reg [10:0] HSYNC_REMAIN; 
reg [10:0] HSYNC_REMAIN1; 
reg [10:0] HSYNC_WIDTH;
reg [10:0] HSYNC_WIDTH_HALF;
reg [10:0] HSYNC_WIDTH1;
reg [10:0] HSYNC_WIDTH_HALF1;
reg [10:0] BURST_START;
reg [10:0] BURST_WIDTH;
reg [10:0] COLOR_START;
reg [10:0] HSYNC_SLOPE;
reg [10:0] ACTIVE_TOTAL_PIXEL;

/* Equalizing area 0~2 */
reg [9:0] EQUALIZING_AREA0_START;  
reg [9:0] EQUALIZING_AREA0_END;  
reg [9:0] EQUALIZING_AREA1_START;  
reg [9:0] EQUALIZING_AREA1_END;  
reg [9:0] EQUALIZING_AREA2_START;  
reg [9:0] EQUALIZING_AREA2_END;  
reg [9:0] EQUALIZING_AREA3_START;  
reg [9:0] EQUALIZING_AREA3_END;  

/* Serration area 0~1 */
reg [9:0] SERRATION_AREA0_START;
reg [9:0] SERRATION_AREA0_END;
reg [9:0] SERRATION_AREA1_START;
reg [9:0] SERRATION_AREA1_END;

/* Serration and Equalizing area 0  include active video*/
reg [9:0] SERREQ_AREA0;

/* Serration and Equalizing area 1 non-active video*/
reg [9:0] SERREQ_AREA1;

/* Equalizing and Serration area */
reg [9:0] EQSERR_AREA0;

/* Equalizing and blank area */
reg [9:0] EQBLANK_AREA0;

/* burst disable area field 1 ~ field 8 */
reg [9:0] BURST_AREA1_START0;
reg [9:0] BURST_AREA1_END0;
reg [9:0] BURST_AREA2_START0;
reg [9:0] BURST_AREA2_END0;
reg [9:0] BURST_AREA3_START0;
reg [9:0] BURST_AREA3_END0;

reg [9:0] BURST_AREA1_START1;
reg [9:0] BURST_AREA1_END1;
reg [9:0] BURST_AREA2_START1;
reg [9:0] BURST_AREA2_END1;
reg [9:0] BURST_AREA3_START1;
reg [9:0] BURST_AREA3_END1;

/* Active video area */
reg[9:0] ACTIVE_FIELD1_START;
reg[9:0] ACTIVE_FIELD1_END;
reg[9:0] ACTIVE_FIELD2_START;
reg[9:0] ACTIVE_FIELD2_END;


reg [4:0]   FIELD_CNT;
reg [10:0]  H_CNT;
reg [9:0]   V_CNT;

reg [10:0]  TOTAL_PIXEL;  
reg [9:0]   TOTAL_LINE;  
reg [9:0]   TOTAL_DISPLAY_LINE;
reg [4:0]   FIELD_OVER;

assign NTSC_PAL = ((OUT_MODE == NTSCM) ||
                   (OUT_MODE == NTSCJ) ||
                   (OUT_MODE == NTSC4) ||
                   (OUT_MODE == PALM)) ? 1'b0 : 1'b1; // NTSC_PAL = 0 --> NTSC mode
                                                      //          = 1 --> PAL mode


wire   MPAL = (OUT_MODE == PALM) ? 1'b1 : 1'b0; //MPAL mode 

// =======================================================================
//  Sync Level generation
// -----------------------------------------------------------------------

always @(  EN_SQPIXEL   or
           NTSC_PAL     or
           HSYNC_WID    ) begin

    case({NTSC_PAL, EN_SQPIXEL, HSYNC_WID}) // synopsys parallel_case 
        5'b00000: begin  /* NTSC mode / EN_SQPIXEL = 0 / HSYNC == 000 */
                    HSYNC_WIDTH = HSYNC_WIDTH_NTSCM2;
                  end
        5'b00001: begin  /* NTSC mode / EN_SQPIXEL = 0 / HSYNC == 001 */
                    HSYNC_WIDTH = HSYNC_WIDTH_NTSCM1;
                  end
        5'b00010: begin  /* NTSC mode / EN_SQPIXEL = 0 / HSYNC == 010 */
                    HSYNC_WIDTH = HSYNC_WIDTH_NTSC;
                  end
        5'b00011: begin  /* NTSC mode / EN_SQPIXEL = 0 / HSYNC == 011 */
                    HSYNC_WIDTH = HSYNC_WIDTH_NTSCP1;
                  end
        5'b00100: begin  /* NTSC mode / EN_SQPIXEL = 0 / HSYNC == 100 */
                    HSYNC_WIDTH = HSYNC_WIDTH_NTSCP2;
                  end
        5'b01000: begin  /* NTSC mode / EN_SQPIXEL = 1 / HSYNC == 000 */
                    HSYNC_WIDTH = HSYNC_WIDTH_SQ_NTSCM2;
                  end
        5'b01001: begin  /* NTSC mode / EN_SQPIXEL = 1 / HSYNC == 001 */
                    HSYNC_WIDTH = HSYNC_WIDTH_SQ_NTSCM1;
                  end
        5'b01010: begin  /* NTSC mode / EN_SQPIXEL = 1 / HSYNC == 010 */
                    HSYNC_WIDTH = HSYNC_WIDTH_SQ_NTSC;
                  end
        5'b01011: begin  /* NTSC mode / EN_SQPIXEL = 1 / HSYNC == 011 */
                    HSYNC_WIDTH = HSYNC_WIDTH_SQ_NTSCP1;
                  end
        5'b01100: begin  /* NTSC mode / EN_SQPIXEL = 1 / HSYNC == 100 */
                    HSYNC_WIDTH = HSYNC_WIDTH_SQ_NTSCP2;
                  end

        5'b10000: begin  /* PAL mode / EN_SQPIXEL = 0 / HSYNC == 000 */
                    HSYNC_WIDTH = HSYNC_WIDTH_PALM2;
                  end
        5'b10001: begin  /* PAL mode / EN_SQPIXEL = 0 / HSYNC == 001 */
                    HSYNC_WIDTH = HSYNC_WIDTH_PALM1;
                  end
        5'b10010: begin  /* PAL mode / EN_SQPIXEL = 0 / HSYNC == 010 */
                    HSYNC_WIDTH = HSYNC_WIDTH_PAL;
                  end
        5'b10011: begin  /* PAL mode / EN_SQPIXEL = 0 / HSYNC == 011 */
                    HSYNC_WIDTH = HSYNC_WIDTH_PALP1;
                  end
        5'b10100: begin  /* PAL mode / EN_SQPIXEL = 0 / HSYNC == 100 */
                    HSYNC_WIDTH = HSYNC_WIDTH_PALP2;
                  end
        5'b11000: begin  /* PAL mode / EN_SQPIXEL = 1 / HSYNC == 000 */
                    HSYNC_WIDTH = HSYNC_WIDTH_SQ_PALM2;
                  end
        5'b11001: begin  /* PAL mode / EN_SQPIXEL = 1 / HSYNC == 001 */
                    HSYNC_WIDTH = HSYNC_WIDTH_SQ_PALM1;
                  end
        5'b11010: begin  /* PAL mode / EN_SQPIXEL = 1 / HSYNC == 010 */
                    HSYNC_WIDTH = HSYNC_WIDTH_SQ_PAL;
                  end
        5'b11011: begin  /* PAL mode / EN_SQPIXEL = 1 / HSYNC == 011 */
                    HSYNC_WIDTH = HSYNC_WIDTH_SQ_PALP1;
                  end
        5'b11100: begin  /* PAL mode / EN_SQPIXEL = 1 / HSYNC == 100 */
                    HSYNC_WIDTH = HSYNC_WIDTH_SQ_PALP2;
                  end

        default:    HSYNC_WIDTH = 0;
    endcase
end

always @(  EN_SQPIXEL   or
           NTSC_PAL     or
           BURST_WID    ) begin

    case({NTSC_PAL, EN_SQPIXEL, BURST_WID}) // synopsys parallel_case 
        4'b0000: begin /* NTSC mode / EN_SQPIXEL = 0 / BURST == 00 */
                    BURST_WIDTH = BURST_WIDTH_NTSCM1;
                 end
        4'b0001: begin /* NTSC mode / EN_SQPIXEL = 0 / BURST == 01 */
                    BURST_WIDTH = BURST_WIDTH_NTSC;
                 end
        4'b0010: begin /* NTSC mode / EN_SQPIXEL = 0 / BURST == 10 */
                    BURST_WIDTH = BURST_WIDTH_NTSCP1;
                 end
        4'b0100: begin /* NTSC mode / EN_SQPIXEL = 1 / BURST == 00 */
                    BURST_WIDTH = BURST_WIDTH_SQ_NTSCM1;
                 end
        4'b0101: begin /* NTSC mode / EN_SQPIXEL = 1 / BURST == 01 */
                    BURST_WIDTH = BURST_WIDTH_SQ_NTSC;
                 end
        4'b0110: begin /* NTSC mode / EN_SQPIXEL = 1 / BURST == 10 */
                    BURST_WIDTH = BURST_WIDTH_SQ_NTSCP1;
                 end
        4'b1000: begin /* PAL mode / EN_SQPIXEL = 0 / BURST == 00 */
                    BURST_WIDTH = BURST_WIDTH_PALM1;
                 end
        4'b1001: begin /* PAL mode / EN_SQPIXEL = 0 / BURST == 01 */
                    BURST_WIDTH = BURST_WIDTH_PAL;
                 end
        4'b1010: begin /* PAL mode / EN_SQPIXEL = 0 / BURST == 10 */
                    BURST_WIDTH = BURST_WIDTH_PALP1;
                 end
        4'b1100: begin /* PAL mode / EN_SQPIXEL = 1 / BURST == 00 */
                    BURST_WIDTH = BURST_WIDTH_SQ_PALM1;
                 end
        4'b1101: begin /* PAL mode / EN_SQPIXEL = 1 / BURST == 01 */
                    BURST_WIDTH = BURST_WIDTH_SQ_PAL;
                 end
        4'b1110: begin /* PAL mode / EN_SQPIXEL = 1 / BURST == 10 */
                    BURST_WIDTH = BURST_WIDTH_SQ_PALP1;
                 end
        default:    BURST_WIDTH = 0;

    endcase

end

always @(  EN_SQPIXEL   or
           NTSC_PAL     or
           OUT_MODE     or
           MPAL         or
           EN_NONINTERLACE
        ) begin
        
    case({NTSC_PAL, EN_NONINTERLACE, MPAL, EN_SQPIXEL}) // synopsys parallel_case full_case

        4'b0000: begin /* NTSC Interlace MPAL=0 Square=0 */

                    /////////////////////////////////////////////////////////////////
                    // NTSC normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_NTSC;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_NTSC;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_NTSC;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_NTSC;

                    /////////////////////////////////////////////////////////////////
                    // NTSC Interlace 
                    
                    FIELD_OVER   = 4'd4;
                    TOTAL_LINE  = TOTAL_LINE_NTSC;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_NTSC;

                    /* Equalizing area 0~2 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_NTSC;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_NTSC;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_NTSC;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_NTSC;  
                    EQUALIZING_AREA2_START = EQUALIZING_AREA2_START_NTSC;  
                    EQUALIZING_AREA2_END   = EQUALIZING_AREA2_END_NTSC;  
                    EQUALIZING_AREA3_START = EQUALIZING_AREA3_START_NTSC;  
                    EQUALIZING_AREA3_END   = EQUALIZING_AREA3_END_NTSC;  

                    /* Serration area 0~1 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_NTSC;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_NTSC;
                    SERRATION_AREA1_START = SERRATION_AREA1_START_NTSC;
                    SERRATION_AREA1_END   = SERRATION_AREA1_END_NTSC;

                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_NTSC;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_NTSC;
                    ACTIVE_FIELD2_START = ACTIVE_FIELD2_START_NTSC;
                    ACTIVE_FIELD2_END   = ACTIVE_FIELD2_END_NTSC;

                    /////////////////////////////////////////////////////////////////
                    // MPAL == 0 

                    BURST_AREA1_START0 = BURST_AREA1_START_NTSC;
                    BURST_AREA1_END0   = BURST_AREA1_END_NTSC;
                    BURST_AREA2_START0 = BURST_AREA2_START_NTSC;
                    BURST_AREA2_END0   = BURST_AREA2_END_NTSC;
                    BURST_AREA3_START0 = BURST_AREA3_START_NTSC;
                    BURST_AREA3_END0   = BURST_AREA3_END_NTSC;

                    BURST_AREA1_START1 = 10'd0;
                    BURST_AREA1_END1   = 10'd0;
                    BURST_AREA2_START1 = 10'd0;
                    BURST_AREA2_END1   = 10'd0;
                    BURST_AREA3_START1 = 10'd0;
                    BURST_AREA3_END1   = 10'd0;

                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 0 

                    HSYNC_START = HSYNC_START_NTSC; 
                    BURST_START = BURST_START_NTSC;
                    COLOR_START = COLOR_START_NTSC;
                    HSYNC_SLOPE = HSYNC_SLOPE_NTSC;
                    TOTAL_PIXEL = TOTAL_PIXEL_NTSCM1;
                    HSYNC_START_HALF = HSYNC_START_NTSC_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_NTSC_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_NTSC;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_NTSC; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_NTSC1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_NTSC1;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_NTSC_HALF1;

                 end

        4'b0001: begin /* NTSC Interlace MPAL=0 Square=1 */

                    /////////////////////////////////////////////////////////////////
                    // NTSC normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_NTSC;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_NTSC;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_NTSC;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_NTSC;

                    /////////////////////////////////////////////////////////////////
                    // NTSC Interlace 
                    FIELD_OVER   = 4'd4;
                    TOTAL_LINE  = TOTAL_LINE_NTSC;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_NTSC;

                    /* Equalizing area 0~2 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_NTSC;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_NTSC;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_NTSC;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_NTSC;  
                    EQUALIZING_AREA2_START = EQUALIZING_AREA2_START_NTSC;  
                    EQUALIZING_AREA2_END   = EQUALIZING_AREA2_END_NTSC;  
                    EQUALIZING_AREA3_START = EQUALIZING_AREA3_START_NTSC;  
                    EQUALIZING_AREA3_END   = EQUALIZING_AREA3_END_NTSC;  

                    /* Serration area 0~1 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_NTSC;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_NTSC;
                    SERRATION_AREA1_START = SERRATION_AREA1_START_NTSC;
                    SERRATION_AREA1_END   = SERRATION_AREA1_END_NTSC;

                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_NTSC;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_NTSC;
                    ACTIVE_FIELD2_START = ACTIVE_FIELD2_START_NTSC;
                    ACTIVE_FIELD2_END   = ACTIVE_FIELD2_END_NTSC;


                    /////////////////////////////////////////////////////////////////
                    // MPAL == 0 

                    BURST_AREA1_START0 = BURST_AREA1_START_NTSC;
                    BURST_AREA1_END0   = BURST_AREA1_END_NTSC;
                    BURST_AREA2_START0 = BURST_AREA2_START_NTSC;
                    BURST_AREA2_END0   = BURST_AREA2_END_NTSC;
                    BURST_AREA3_START0 = BURST_AREA3_START_NTSC;
                    BURST_AREA3_END0   = BURST_AREA3_END_NTSC;

                    BURST_AREA1_START1 = 10'd0;
                    BURST_AREA1_END1   = 10'd0;
                    BURST_AREA2_START1 = 10'd0;
                    BURST_AREA2_END1   = 10'd0;
                    BURST_AREA3_START1 = 10'd0;
                    BURST_AREA3_END1   = 10'd0;

                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 1 

                    HSYNC_START = HSYNC_START_SQ_NTSC; 
                    BURST_START = BURST_START_SQ_NTSC;
                    COLOR_START = COLOR_START_SQ_NTSC;
                    HSYNC_SLOPE = HSYNC_SLOPE_SQ_NTSC;
                    TOTAL_PIXEL = TOTAL_PIXEL_SQ_NTSCM1;
                    HSYNC_START_HALF = HSYNC_START_SQ_NTSC_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_SQ_NTSC_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_SQ_NTSC;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_SQ_NTSC; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_SQ_NTSC1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_SQ_NTSC1;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_SQ_NTSC_HALF1;

                end

        4'b0010: begin /* NTSC Interlace MPAL=1 Square=0 */

                    /////////////////////////////////////////////////////////////////
                    // NTSC normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_NTSC;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_NTSC;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_NTSC;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_NTSC;

                    /////////////////////////////////////////////////////////////////
                    // NTSC Interlace 
                    FIELD_OVER   = 4'd4;
                    TOTAL_LINE  = TOTAL_LINE_NTSC;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_NTSC;

                    /* Equalizing area 0~2 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_NTSC;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_NTSC;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_NTSC;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_NTSC;  
                    EQUALIZING_AREA2_START = EQUALIZING_AREA2_START_NTSC;  
                    EQUALIZING_AREA2_END   = EQUALIZING_AREA2_END_NTSC;  
                    EQUALIZING_AREA3_START = EQUALIZING_AREA3_START_NTSC;  
                    EQUALIZING_AREA3_END   = EQUALIZING_AREA3_END_NTSC;  

                    /* Serration area 0~1 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_NTSC;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_NTSC;
                    SERRATION_AREA1_START = SERRATION_AREA1_START_NTSC;
                    SERRATION_AREA1_END   = SERRATION_AREA1_END_NTSC;

                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_NTSC;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_NTSC;
                    ACTIVE_FIELD2_START = ACTIVE_FIELD2_START_NTSC;
                    ACTIVE_FIELD2_END   = ACTIVE_FIELD2_END_NTSC;

                    /////////////////////////////////////////////////////////////////
                    // MPAL == 1 

                        BURST_AREA1_START0 = BURST_AREA1_START_MPAL0;
                        BURST_AREA1_END0   = BURST_AREA1_END_MPAL0;
                        BURST_AREA2_START0 = BURST_AREA2_START_MPAL0;
                        BURST_AREA2_END0   = BURST_AREA2_END_MPAL0;
                        BURST_AREA3_START0 = BURST_AREA3_START_MPAL0;
                        BURST_AREA3_END0   = BURST_AREA3_END_MPAL0;

                        BURST_AREA1_START1 = BURST_AREA1_START_MPAL1;
                        BURST_AREA1_END1   = BURST_AREA1_END_MPAL1;
                        BURST_AREA2_START1 = BURST_AREA2_START_MPAL1;
                        BURST_AREA2_END1   = BURST_AREA2_END_MPAL1;
                        BURST_AREA3_START1 = BURST_AREA3_START_MPAL1;
                        BURST_AREA3_END1   = BURST_AREA3_END_MPAL1;


                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 0 

                    HSYNC_START = HSYNC_START_NTSC; 
                    BURST_START = BURST_START_NTSC;
                    COLOR_START = COLOR_START_NTSC;
                    HSYNC_SLOPE = HSYNC_SLOPE_NTSC;
                    TOTAL_PIXEL = TOTAL_PIXEL_NTSCM1;
                    HSYNC_START_HALF = HSYNC_START_NTSC_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_NTSC_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_NTSC;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_NTSC; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_NTSC1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_NTSC1;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_NTSC_HALF1;

                end

        4'b0011: begin /* NTSC Interlace MPAL=1 Square=1 */

                    /////////////////////////////////////////////////////////////////
                    // NTSC normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_NTSC;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_NTSC;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_NTSC;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_NTSC;

                    /////////////////////////////////////////////////////////////////
                    // NTSC Interlace 

                    FIELD_OVER   = 4'd4;
                    TOTAL_LINE  = TOTAL_LINE_NTSC;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_NTSC;

                    /* Equalizing area 0~2 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_NTSC;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_NTSC;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_NTSC;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_NTSC;  
                    EQUALIZING_AREA2_START = EQUALIZING_AREA2_START_NTSC;  
                    EQUALIZING_AREA2_END   = EQUALIZING_AREA2_END_NTSC;  
                    EQUALIZING_AREA3_START = EQUALIZING_AREA3_START_NTSC;  
                    EQUALIZING_AREA3_END   = EQUALIZING_AREA3_END_NTSC;  

                    /* Serration area 0~1 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_NTSC;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_NTSC;
                    SERRATION_AREA1_START = SERRATION_AREA1_START_NTSC;
                    SERRATION_AREA1_END   = SERRATION_AREA1_END_NTSC;

                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_NTSC;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_NTSC;
                    ACTIVE_FIELD2_START = ACTIVE_FIELD2_START_NTSC;
                    ACTIVE_FIELD2_END   = ACTIVE_FIELD2_END_NTSC;


                    /////////////////////////////////////////////////////////////////
                    // MPAL == 1 

                        BURST_AREA1_START0 = BURST_AREA1_START_MPAL0;
                        BURST_AREA1_END0   = BURST_AREA1_END_MPAL0;
                        BURST_AREA2_START0 = BURST_AREA2_START_MPAL0;
                        BURST_AREA2_END0   = BURST_AREA2_END_MPAL0;
                        BURST_AREA3_START0 = BURST_AREA3_START_MPAL0;
                        BURST_AREA3_END0   = BURST_AREA3_END_MPAL0;

                        BURST_AREA1_START1 = BURST_AREA1_START_MPAL1;
                        BURST_AREA1_END1   = BURST_AREA1_END_MPAL1;
                        BURST_AREA2_START1 = BURST_AREA2_START_MPAL1;
                        BURST_AREA2_END1   = BURST_AREA2_END_MPAL1;
                        BURST_AREA3_START1 = BURST_AREA3_START_MPAL1;
                        BURST_AREA3_END1   = BURST_AREA3_END_MPAL1;

                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 1 

                    HSYNC_START = HSYNC_START_SQ_NTSC; 
                    BURST_START = BURST_START_SQ_NTSC;
                    COLOR_START = COLOR_START_SQ_NTSC;
                    HSYNC_SLOPE = HSYNC_SLOPE_SQ_NTSC;
                    TOTAL_PIXEL = TOTAL_PIXEL_SQ_NTSCM1;
                    HSYNC_START_HALF = HSYNC_START_SQ_NTSC_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_SQ_NTSC_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_SQ_NTSC;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_SQ_NTSC; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_SQ_NTSC1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_SQ_NTSC1;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_SQ_NTSC_HALF1;

                end


       4'b0100: begin /* NTSC Non-Interlace MPAL=0 Square=0 */

                    /////////////////////////////////////////////////////////////////
                    // NTSC normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_NTSC;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_NTSC;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_NTSC;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_NTSC;

                    /////////////////////////////////////////////////////////////////
                    // NTSC Non-Interlace 

                    FIELD_OVER   = 4'd1;
                    TOTAL_LINE  = TOTAL_LINE_NTSC_NOINTER;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_NTSC_NOINTER;

                    /* Equalizing area 0~1 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_NTSC_NOINTER;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_NTSC_NOINTER;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_NTSC_NOINTER;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_NTSC_NOINTER;  
                    EQUALIZING_AREA2_START = 0;
                    EQUALIZING_AREA2_END   = 0;
                    EQUALIZING_AREA3_START = 0;
                    EQUALIZING_AREA3_END   = 0;

                    /* Serration area 0 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_NTSC_NOINTER;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_NTSC_NOINTER;
                    SERRATION_AREA1_START = 0;
                    SERRATION_AREA1_END   = 0;

                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_NTSC_NOINTER;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_NTSC_NOINTER;
                    ACTIVE_FIELD2_START = 0;
                    ACTIVE_FIELD2_END   = 0;


                    /////////////////////////////////////////////////////////////////
                    // MPAL == 0 

                        BURST_AREA1_START0 = BURST_AREA1_START_NTSC_NOINTER;
                        BURST_AREA1_END0   = BURST_AREA1_END_NTSC_NOINTER;
                        BURST_AREA2_START0 = BURST_AREA2_START_NTSC_NOINTER;
                        BURST_AREA2_END0   = BURST_AREA2_END_NTSC_NOINTER;
                        BURST_AREA3_START0 = 0;
                        BURST_AREA3_END0   = 0;

                        BURST_AREA1_START1 = 10'd0;
                        BURST_AREA1_END1   = 10'd0;
                        BURST_AREA2_START1 = 10'd0;
                        BURST_AREA2_END1   = 10'd0;
                        BURST_AREA3_START1 = 10'd0;
                        BURST_AREA3_END1   = 10'd0;
                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 0 

                    HSYNC_START = HSYNC_START_NTSC; 
                    BURST_START = BURST_START_NTSC;
                    COLOR_START = COLOR_START_NTSC;
                    HSYNC_SLOPE = HSYNC_SLOPE_NTSC;
                    TOTAL_PIXEL = TOTAL_PIXEL_NTSCM1;
                    HSYNC_START_HALF = HSYNC_START_NTSC_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_NTSC_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_NTSC;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_NTSC; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_NTSC1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_NTSC1;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_NTSC_HALF1;

                end

       4'b0101: begin /* NTSC Non-Interlace MPAL=0 Square=1 */

                    /////////////////////////////////////////////////////////////////
                    // NTSC normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_NTSC;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_NTSC;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_NTSC;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_NTSC;

                    /////////////////////////////////////////////////////////////////
                    // NTSC Non-Interlace 

                    FIELD_OVER   = 4'd1;
                    TOTAL_LINE  = TOTAL_LINE_NTSC_NOINTER;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_NTSC_NOINTER;

                    /* Equalizing area 0~1 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_NTSC_NOINTER;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_NTSC_NOINTER;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_NTSC_NOINTER;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_NTSC_NOINTER;  
                    EQUALIZING_AREA2_START = 0;
                    EQUALIZING_AREA2_END   = 0;
                    EQUALIZING_AREA3_START = 0;
                    EQUALIZING_AREA3_END   = 0;

                    /* Serration area 0 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_NTSC_NOINTER;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_NTSC_NOINTER;
                    SERRATION_AREA1_START = 0;
                    SERRATION_AREA1_END   = 0;

                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_NTSC_NOINTER;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_NTSC_NOINTER;
                    ACTIVE_FIELD2_START = 0;
                    ACTIVE_FIELD2_END   = 0;


                    /////////////////////////////////////////////////////////////////
                    // MPAL == 0 

                        BURST_AREA1_START0 = BURST_AREA1_START_NTSC_NOINTER;
                        BURST_AREA1_END0   = BURST_AREA1_END_NTSC_NOINTER;
                        BURST_AREA2_START0 = BURST_AREA2_START_NTSC_NOINTER;
                        BURST_AREA2_END0   = BURST_AREA2_END_NTSC_NOINTER;
                        BURST_AREA3_START0 = 0;
                        BURST_AREA3_END0   = 0;

                        BURST_AREA1_START1 = 10'd0;
                        BURST_AREA1_END1   = 10'd0;
                        BURST_AREA2_START1 = 10'd0;
                        BURST_AREA2_END1   = 10'd0;
                        BURST_AREA3_START1 = 10'd0;
                        BURST_AREA3_END1   = 10'd0;
                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 1 

                    HSYNC_START = HSYNC_START_SQ_NTSC; 
                    BURST_START = BURST_START_SQ_NTSC;
                    COLOR_START = COLOR_START_SQ_NTSC;
                    HSYNC_SLOPE = HSYNC_SLOPE_SQ_NTSC;
                    TOTAL_PIXEL = TOTAL_PIXEL_SQ_NTSCM1;
                    HSYNC_START_HALF = HSYNC_START_SQ_NTSC_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_SQ_NTSC_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_SQ_NTSC;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_SQ_NTSC; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_SQ_NTSC1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_SQ_NTSC1;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_SQ_NTSC_HALF1;


                end

        4'b0110: begin /* NTSC Non-Interlace MPAL=1 Square=0 */

                    /////////////////////////////////////////////////////////////////
                    // NTSC normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_NTSC;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_NTSC;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_NTSC;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_NTSC;

                    /////////////////////////////////////////////////////////////////
                    // NTSC Non-Interlace 

                    FIELD_OVER   = 4'd1;
                    TOTAL_LINE  = TOTAL_LINE_NTSC_NOINTER;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_NTSC_NOINTER;

                    /* Equalizing area 0~1 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_NTSC_NOINTER;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_NTSC_NOINTER;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_NTSC_NOINTER;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_NTSC_NOINTER;  
                    EQUALIZING_AREA2_START = 0;
                    EQUALIZING_AREA2_END   = 0;
                    EQUALIZING_AREA3_START = 0;
                    EQUALIZING_AREA3_END   = 0;

                    /* Serration area 0 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_NTSC_NOINTER;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_NTSC_NOINTER;
                    SERRATION_AREA1_START = 0;
                    SERRATION_AREA1_END   = 0;

                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_NTSC_NOINTER;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_NTSC_NOINTER;
                    ACTIVE_FIELD2_START = 0;
                    ACTIVE_FIELD2_END   = 0;


                    /////////////////////////////////////////////////////////////////
                    // MPAL == 1 
                        
                        BURST_AREA1_START0 = BURST_AREA1_START_MPAL_NOINTER;
                        BURST_AREA1_END0   = BURST_AREA1_END_MPAL_NOINTER;
                        BURST_AREA2_START0 = BURST_AREA2_START_MPAL_NOINTER;
                        BURST_AREA2_END0   = BURST_AREA2_END_MPAL_NOINTER;
                        BURST_AREA3_START0 = 0;
                        BURST_AREA3_END0   = 0;

                        BURST_AREA1_START1 = 10'd0;
                        BURST_AREA1_END1   = 10'd0;
                        BURST_AREA2_START1 = 10'd0;
                        BURST_AREA2_END1   = 10'd0;
                        BURST_AREA3_START1 = 10'd0;
                        BURST_AREA3_END1   = 10'd0;
                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 0 

                    HSYNC_START = HSYNC_START_NTSC; 
                    BURST_START = BURST_START_NTSC;
                    COLOR_START = COLOR_START_NTSC;
                    HSYNC_SLOPE = HSYNC_SLOPE_NTSC;
                    TOTAL_PIXEL = TOTAL_PIXEL_NTSCM1;
                    HSYNC_START_HALF = HSYNC_START_NTSC_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_NTSC_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_NTSC;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_NTSC; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_NTSC1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_NTSC1;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_NTSC_HALF1;

                end

        4'b0111: begin /* NTSC Non-Interlace MPAL=1 Square=1 */

                    /////////////////////////////////////////////////////////////////
                    // NTSC normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_NTSC;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_NTSC;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_NTSC;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_NTSC;

                    /////////////////////////////////////////////////////////////////
                    // NTSC Non-Interlace 

                    FIELD_OVER   = 4'd1;
                    TOTAL_LINE  = TOTAL_LINE_NTSC_NOINTER;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_NTSC_NOINTER;

                    /* Equalizing area 0~1 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_NTSC_NOINTER;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_NTSC_NOINTER;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_NTSC_NOINTER;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_NTSC_NOINTER;  
                    EQUALIZING_AREA2_START = 0;
                    EQUALIZING_AREA2_END   = 0;
                    EQUALIZING_AREA3_START = 0;
                    EQUALIZING_AREA3_END   = 0;

                    /* Serration area 0 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_NTSC_NOINTER;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_NTSC_NOINTER;
                    SERRATION_AREA1_START = 0;
                    SERRATION_AREA1_END   = 0;

                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_NTSC_NOINTER;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_NTSC_NOINTER;
                    ACTIVE_FIELD2_START = 0;
                    ACTIVE_FIELD2_END   = 0;

                    /////////////////////////////////////////////////////////////////
                    // MPAL == 1 

                        BURST_AREA1_START0 = BURST_AREA1_START_MPAL_NOINTER;
                        BURST_AREA1_END0   = BURST_AREA1_END_MPAL_NOINTER;
                        BURST_AREA2_START0 = BURST_AREA2_START_MPAL_NOINTER;
                        BURST_AREA2_END0   = BURST_AREA2_END_MPAL_NOINTER;
                        BURST_AREA3_START0 = 0;
                        BURST_AREA3_END0   = 0;

                        BURST_AREA1_START1 = 10'd0;
                        BURST_AREA1_END1   = 10'd0;
                        BURST_AREA2_START1 = 10'd0;
                        BURST_AREA2_END1   = 10'd0;
                        BURST_AREA3_START1 = 10'd0;
                        BURST_AREA3_END1   = 10'd0;
                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 1 

                    HSYNC_START = HSYNC_START_SQ_NTSC; 
                    BURST_START = BURST_START_SQ_NTSC;
                    COLOR_START = COLOR_START_SQ_NTSC;
                    HSYNC_SLOPE = HSYNC_SLOPE_SQ_NTSC;
                    TOTAL_PIXEL = TOTAL_PIXEL_SQ_NTSCM1;
                    HSYNC_START_HALF = HSYNC_START_SQ_NTSC_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_SQ_NTSC_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_SQ_NTSC;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_SQ_NTSC; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_SQ_NTSC1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_SQ_NTSC1;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_SQ_NTSC_HALF1;

                end


        4'b1000: begin /* PAL Interlace MPAL=0 Square=0 */

                    /////////////////////////////////////////////////////////////////
                    // PAL normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_PAL;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_PAL;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_PAL;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_PAL;

                    /////////////////////////////////////////////////////////////////
                    // PAL Interlace 

                    FIELD_OVER   = 4'd8;
                    TOTAL_LINE  = TOTAL_LINE_PAL;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_PAL;


                    /* Equalizing area 0~1 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_PAL;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_PAL;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_PAL;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_PAL;  
                    EQUALIZING_AREA2_START = EQUALIZING_AREA2_START_PAL;  
                    EQUALIZING_AREA2_END   = EQUALIZING_AREA2_END_PAL;  
                    EQUALIZING_AREA3_START = EQUALIZING_AREA3_START_PAL;  
                    EQUALIZING_AREA3_END   = EQUALIZING_AREA3_END_PAL;  

                    /* Serration area 0 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_PAL;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_PAL;
                    SERRATION_AREA1_START = SERRATION_AREA1_START_PAL;
                    SERRATION_AREA1_END   = SERRATION_AREA1_END_PAL;

                    /* burst disable area field 1 ~ field 8 */
                    BURST_AREA1_START0  = BURST_AREA1_START_PAL0;
                    BURST_AREA1_END0    = BURST_AREA1_END_PAL0;
                    BURST_AREA2_START0  = BURST_AREA2_START_PAL0;
                    BURST_AREA2_END0    = BURST_AREA2_END_PAL0;
                    BURST_AREA3_START0  = BURST_AREA3_START_PAL0;
                    BURST_AREA3_END0    = BURST_AREA3_END_PAL0;

                    BURST_AREA1_START1  = BURST_AREA1_START_PAL1;
                    BURST_AREA1_END1    = BURST_AREA1_END_PAL1;
                    BURST_AREA2_START1  = BURST_AREA2_START_PAL1;
                    BURST_AREA2_END1    = BURST_AREA2_END_PAL1;
                    BURST_AREA3_START1  = BURST_AREA3_START_PAL1;
                    BURST_AREA3_END1    = BURST_AREA3_END_PAL1;
                    
                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_PAL;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_PAL;
                    ACTIVE_FIELD2_START = ACTIVE_FIELD2_START_PAL;
                    ACTIVE_FIELD2_END   = ACTIVE_FIELD2_END_PAL;

                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 0 

                    HSYNC_START = HSYNC_START_PAL; 
                    BURST_START = BURST_START_PAL;
                    COLOR_START = COLOR_START_PAL;
                    HSYNC_SLOPE = HSYNC_SLOPE_PAL;
                    TOTAL_PIXEL = TOTAL_PIXEL_PALM1;
                    HSYNC_START_HALF = HSYNC_START_PAL_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_PAL_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_PAL;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_PAL; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_PAL1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_PAL1;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_PAL_HALF1;

                 end
        4'b1001: begin /* PAL Interlace MPAL=0 Square=1 */

                    /////////////////////////////////////////////////////////////////
                    // PAL normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_PAL;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_PAL;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_PAL;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_PAL;

                    /////////////////////////////////////////////////////////////////
                    // PAL Interlace 

                    FIELD_OVER   = 4'd8;
                    TOTAL_LINE  = TOTAL_LINE_PAL;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_PAL;


                    /* Equalizing area 0~1 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_PAL;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_PAL;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_PAL;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_PAL;  
                    EQUALIZING_AREA2_START = EQUALIZING_AREA2_START_PAL;  
                    EQUALIZING_AREA2_END   = EQUALIZING_AREA2_END_PAL;  
                    EQUALIZING_AREA3_START = EQUALIZING_AREA3_START_PAL;  
                    EQUALIZING_AREA3_END   = EQUALIZING_AREA3_END_PAL;  

                    /* Serration area 0 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_PAL;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_PAL;
                    SERRATION_AREA1_START = SERRATION_AREA1_START_PAL;
                    SERRATION_AREA1_END   = SERRATION_AREA1_END_PAL;

                    /* burst disable area field 1 ~ field 8 */
                    BURST_AREA1_START0  = BURST_AREA1_START_PAL0;
                    BURST_AREA1_END0    = BURST_AREA1_END_PAL0;
                    BURST_AREA2_START0  = BURST_AREA2_START_PAL0;
                    BURST_AREA2_END0    = BURST_AREA2_END_PAL0;
                    BURST_AREA3_START0  = BURST_AREA3_START_PAL0;
                    BURST_AREA3_END0    = BURST_AREA3_END_PAL0;

                    BURST_AREA1_START1  = BURST_AREA1_START_PAL1;
                    BURST_AREA1_END1    = BURST_AREA1_END_PAL1;
                    BURST_AREA2_START1  = BURST_AREA2_START_PAL1;
                    BURST_AREA2_END1    = BURST_AREA2_END_PAL1;
                    BURST_AREA3_START1  = BURST_AREA3_START_PAL1;
                    BURST_AREA3_END1    = BURST_AREA3_END_PAL1;
                    
                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_PAL;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_PAL;
                    ACTIVE_FIELD2_START = ACTIVE_FIELD2_START_PAL;
                    ACTIVE_FIELD2_END   = ACTIVE_FIELD2_END_PAL;

                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 1 
                    HSYNC_START = HSYNC_START_SQ_PAL; 
                    BURST_START = BURST_START_SQ_PAL;
                    COLOR_START = COLOR_START_SQ_PAL;
                    HSYNC_SLOPE = HSYNC_SLOPE_SQ_PAL;
                    TOTAL_PIXEL = TOTAL_PIXEL_SQ_PALM1;
                    HSYNC_START_HALF = HSYNC_START_SQ_PAL_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_SQ_PAL_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_SQ_PAL;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_SQ_PAL; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_SQ_PAL1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_SQ_PAL;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_SQ_PAL_HALF;

                 end

        4'b1010: begin /* PAL Interlace MPAL=1 Square=0 */

                    /////////////////////////////////////////////////////////////////
                    // PAL normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_PAL;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_PAL;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_PAL;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_PAL;

                    /////////////////////////////////////////////////////////////////
                    // PAL Interlace 

                    FIELD_OVER   = 4'd8;
                    TOTAL_LINE  = TOTAL_LINE_PAL;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_PAL;


                    /* Equalizing area 0~1 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_PAL;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_PAL;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_PAL;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_PAL;  
                    EQUALIZING_AREA2_START = EQUALIZING_AREA2_START_PAL;  
                    EQUALIZING_AREA2_END   = EQUALIZING_AREA2_END_PAL;  
                    EQUALIZING_AREA3_START = EQUALIZING_AREA3_START_PAL;  
                    EQUALIZING_AREA3_END   = EQUALIZING_AREA3_END_PAL;  

                    /* Serration area 0 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_PAL;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_PAL;
                    SERRATION_AREA1_START = SERRATION_AREA1_START_PAL;
                    SERRATION_AREA1_END   = SERRATION_AREA1_END_PAL;

                    /* burst disable area field 1 ~ field 8 */
                    BURST_AREA1_START0  = BURST_AREA1_START_PAL0;
                    BURST_AREA1_END0    = BURST_AREA1_END_PAL0;
                    BURST_AREA2_START0  = BURST_AREA2_START_PAL0;
                    BURST_AREA2_END0    = BURST_AREA2_END_PAL0;
                    BURST_AREA3_START0  = BURST_AREA3_START_PAL0;
                    BURST_AREA3_END0    = BURST_AREA3_END_PAL0;

                    BURST_AREA1_START1  = BURST_AREA1_START_PAL1;
                    BURST_AREA1_END1    = BURST_AREA1_END_PAL1;
                    BURST_AREA2_START1  = BURST_AREA2_START_PAL1;
                    BURST_AREA2_END1    = BURST_AREA2_END_PAL1;
                    BURST_AREA3_START1  = BURST_AREA3_START_PAL1;
                    BURST_AREA3_END1    = BURST_AREA3_END_PAL1;
                    
                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_PAL;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_PAL;
                    ACTIVE_FIELD2_START = ACTIVE_FIELD2_START_PAL;
                    ACTIVE_FIELD2_END   = ACTIVE_FIELD2_END_PAL;

                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 0 

                    HSYNC_START = HSYNC_START_PAL; 
                    BURST_START = BURST_START_PAL;
                    COLOR_START = COLOR_START_PAL;
                    HSYNC_SLOPE = HSYNC_SLOPE_PAL;
                    TOTAL_PIXEL = TOTAL_PIXEL_PALM1;
                    HSYNC_START_HALF = HSYNC_START_PAL_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_PAL_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_PAL;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_PAL; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_PAL1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_PAL1;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_PAL_HALF1;

                 end
        4'b1011: begin /* PAL Interlace MPAL=1 Square=1 */

                    /////////////////////////////////////////////////////////////////
                    // PAL normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_PAL;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_PAL;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_PAL;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_PAL;

                    /////////////////////////////////////////////////////////////////
                    // PAL Interlace 

                    FIELD_OVER   = 4'd8;
                    TOTAL_LINE  = TOTAL_LINE_PAL;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_PAL;

                    /* Equalizing area 0~1 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_PAL;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_PAL;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_PAL;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_PAL;  
                    EQUALIZING_AREA2_START = EQUALIZING_AREA2_START_PAL;  
                    EQUALIZING_AREA2_END   = EQUALIZING_AREA2_END_PAL;  
                    EQUALIZING_AREA3_START = EQUALIZING_AREA3_START_PAL;  
                    EQUALIZING_AREA3_END   = EQUALIZING_AREA3_END_PAL;  

                    /* Serration area 0 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_PAL;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_PAL;
                    SERRATION_AREA1_START = SERRATION_AREA1_START_PAL;
                    SERRATION_AREA1_END   = SERRATION_AREA1_END_PAL;

                    /* burst disable area field 1 ~ field 8 */
                    BURST_AREA1_START0  = BURST_AREA1_START_PAL0;
                    BURST_AREA1_END0    = BURST_AREA1_END_PAL0;
                    BURST_AREA2_START0  = BURST_AREA2_START_PAL0;
                    BURST_AREA2_END0    = BURST_AREA2_END_PAL0;
                    BURST_AREA3_START0  = BURST_AREA3_START_PAL0;
                    BURST_AREA3_END0    = BURST_AREA3_END_PAL0;

                    BURST_AREA1_START1  = BURST_AREA1_START_PAL1;
                    BURST_AREA1_END1    = BURST_AREA1_END_PAL1;
                    BURST_AREA2_START1  = BURST_AREA2_START_PAL1;
                    BURST_AREA2_END1    = BURST_AREA2_END_PAL1;
                    BURST_AREA3_START1  = BURST_AREA3_START_PAL1;
                    BURST_AREA3_END1    = BURST_AREA3_END_PAL1;
                    
                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_PAL;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_PAL;
                    ACTIVE_FIELD2_START = ACTIVE_FIELD2_START_PAL;
                    ACTIVE_FIELD2_END   = ACTIVE_FIELD2_END_PAL;

                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 1 
                    HSYNC_START = HSYNC_START_SQ_PAL; 
                    BURST_START = BURST_START_SQ_PAL;
                    COLOR_START = COLOR_START_SQ_PAL;
                    HSYNC_SLOPE = HSYNC_SLOPE_SQ_PAL;
                    TOTAL_PIXEL = TOTAL_PIXEL_SQ_PALM1;
                    HSYNC_START_HALF = HSYNC_START_SQ_PAL_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_SQ_PAL_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_SQ_PAL;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_SQ_PAL; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_SQ_PAL1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_SQ_PAL;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_SQ_PAL_HALF;

                 end


        4'b1100: begin /* PAL Non-Interlace MPAL=0 Square=0 */

                    /////////////////////////////////////////////////////////////////
                    // PAL normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_PAL;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_PAL;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_PAL;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_PAL;

                    /////////////////////////////////////////////////////////////////
                    // PAL Non-Interlace 
                    
                    FIELD_OVER   = 4'd1;
                    TOTAL_LINE  = TOTAL_LINE_PAL_NOINTER;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_PAL_NOINTER;

                    /* Equalizing area 0~1 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_PAL_NOINTER;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_PAL_NOINTER;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_PAL_NOINTER;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_PAL_NOINTER;  
                    EQUALIZING_AREA2_START = 0;
                    EQUALIZING_AREA2_END   = 0;
                    EQUALIZING_AREA3_START = 0;
                    EQUALIZING_AREA3_END   = 0;

                    /* Serration area 0 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_PAL_NOINTER;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_PAL_NOINTER;
                    SERRATION_AREA1_START = 0;
                    SERRATION_AREA1_END   = 0;

                    /* burst disable area field 1 ~ field 8 */
                    BURST_AREA1_START0 = BURST_AREA1_START_PAL0_NOINTER;
                    BURST_AREA1_END0   = BURST_AREA1_END_PAL0_NOINTER;
                    BURST_AREA2_START0 = BURST_AREA2_START_PAL0_NOINTER;
                    BURST_AREA2_END0   = BURST_AREA2_END_PAL0_NOINTER;
                    BURST_AREA3_START0 = 0;
                    BURST_AREA3_END0   = 0;

                    BURST_AREA1_START1 = 10'd0;
                    BURST_AREA1_END1   = 10'd0;
                    BURST_AREA2_START1 = 10'd0;
                    BURST_AREA2_END1   = 10'd0;
                    BURST_AREA3_START1 = 10'd0;
                    BURST_AREA3_END1   = 10'd0;

                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_PAL_NOINTER;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_PAL_NOINTER;
                    ACTIVE_FIELD2_START = 0;
                    ACTIVE_FIELD2_END   = 0;

                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 0 

                    HSYNC_START = HSYNC_START_PAL; 
                    BURST_START = BURST_START_PAL;
                    COLOR_START = COLOR_START_PAL;
                    HSYNC_SLOPE = HSYNC_SLOPE_PAL;
                    TOTAL_PIXEL = TOTAL_PIXEL_PALM1;
                    HSYNC_START_HALF = HSYNC_START_PAL_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_PAL_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_PAL;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_PAL; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_PAL1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_PAL1;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_PAL_HALF1;

                 end
        4'b1101: begin /* PAL Non-Interlace MPAL=0 Square=1 */

                    /////////////////////////////////////////////////////////////////
                    // PAL normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_PAL;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_PAL;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_PAL;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_PAL;

                    /////////////////////////////////////////////////////////////////
                    // PAL Non-Interlace 

                    FIELD_OVER   = 4'd1;
                    TOTAL_LINE  = TOTAL_LINE_PAL_NOINTER;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_PAL_NOINTER;

                    /* Equalizing area 0~1 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_PAL_NOINTER;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_PAL_NOINTER;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_PAL_NOINTER;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_PAL_NOINTER;  
                    EQUALIZING_AREA2_START = 0;
                    EQUALIZING_AREA2_END   = 0;
                    EQUALIZING_AREA3_START = 0;
                    EQUALIZING_AREA3_END   = 0;

                    /* Serration area 0 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_PAL_NOINTER;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_PAL_NOINTER;
                    SERRATION_AREA1_START = 0;
                    SERRATION_AREA1_END   = 0;

                    /* burst disable area field 1 ~ field 8 */
                    BURST_AREA1_START0 = BURST_AREA1_START_PAL0_NOINTER;
                    BURST_AREA1_END0   = BURST_AREA1_END_PAL0_NOINTER;
                    BURST_AREA2_START0 = BURST_AREA2_START_PAL0_NOINTER;
                    BURST_AREA2_END0   = BURST_AREA2_END_PAL0_NOINTER;
                    BURST_AREA3_START0 = 0;
                    BURST_AREA3_END0   = 0;
        
                    BURST_AREA1_START1 = 10'd0;
                    BURST_AREA1_END1   = 10'd0;
                    BURST_AREA2_START1 = 10'd0;
                    BURST_AREA2_END1   = 10'd0;
                    BURST_AREA3_START1 = 10'd0;
                    BURST_AREA3_END1   = 10'd0;
                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_PAL_NOINTER;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_PAL_NOINTER;
                    ACTIVE_FIELD2_START = 0;
                    ACTIVE_FIELD2_END   = 0;

                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 1 
                    HSYNC_START = HSYNC_START_SQ_PAL; 
                    BURST_START = BURST_START_SQ_PAL;
                    COLOR_START = COLOR_START_SQ_PAL;
                    HSYNC_SLOPE = HSYNC_SLOPE_SQ_PAL;
                    TOTAL_PIXEL = TOTAL_PIXEL_SQ_PALM1;
                    HSYNC_START_HALF = HSYNC_START_SQ_PAL_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_SQ_PAL_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_SQ_PAL;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_SQ_PAL; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_SQ_PAL1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_SQ_PAL;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_SQ_PAL_HALF;

                 end

        4'b1110: begin /* PAL Non-Interlace MPAL=1 Square=0 */

                    /////////////////////////////////////////////////////////////////
                    // PAL normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_PAL;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_PAL;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_PAL;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_PAL;

                    /////////////////////////////////////////////////////////////////
                    // PAL Non-Interlace 

                    FIELD_OVER   = 4'd1;
                    TOTAL_LINE  = TOTAL_LINE_PAL_NOINTER;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_PAL_NOINTER;

                    /* Equalizing area 0~1 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_PAL_NOINTER;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_PAL_NOINTER;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_PAL_NOINTER;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_PAL_NOINTER;  
                    EQUALIZING_AREA2_START = 0;
                    EQUALIZING_AREA2_END   = 0;
                    EQUALIZING_AREA3_START = 0;
                    EQUALIZING_AREA3_END   = 0;

                    /* Serration area 0 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_PAL_NOINTER;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_PAL_NOINTER;
                    SERRATION_AREA1_START = 0;
                    SERRATION_AREA1_END   = 0;

                    /* burst disable area field 1 ~ field 8 */
                    BURST_AREA1_START0 = BURST_AREA1_START_PAL0_NOINTER;
                    BURST_AREA1_END0   = BURST_AREA1_END_PAL0_NOINTER;
                    BURST_AREA2_START0 = BURST_AREA2_START_PAL0_NOINTER;
                    BURST_AREA2_END0   = BURST_AREA2_END_PAL0_NOINTER;
                    BURST_AREA3_START0 = 0;
                    BURST_AREA3_END0   = 0;

                    BURST_AREA1_START1 = 10'd0;
                    BURST_AREA1_END1   = 10'd0;
                    BURST_AREA2_START1 = 10'd0;
                    BURST_AREA2_END1   = 10'd0;
                    BURST_AREA3_START1 = 10'd0;
                    BURST_AREA3_END1   = 10'd0;

                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_PAL_NOINTER;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_PAL_NOINTER;
                    ACTIVE_FIELD2_START = 0;
                    ACTIVE_FIELD2_END   = 0;

                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 0 

                    HSYNC_START = HSYNC_START_PAL; 
                    BURST_START = BURST_START_PAL;
                    COLOR_START = COLOR_START_PAL;
                    HSYNC_SLOPE = HSYNC_SLOPE_PAL;
                    TOTAL_PIXEL = TOTAL_PIXEL_PALM1;
                    HSYNC_START_HALF = HSYNC_START_PAL_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_PAL_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_PAL;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_PAL; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_PAL1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_PAL1;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_PAL_HALF1;

                 end
        4'b1111: begin /* PAL Non-Interlace MPAL=1 Square=1 */

                    /////////////////////////////////////////////////////////////////
                    // PAL normal

                    /* Serration and Equalizing area 0  include active video*/
                    SERREQ_AREA0 = SERREQ_AREA0_PAL;
                    /* Serration and Equalizing area 1 non-active video*/
                    SERREQ_AREA1 = SERREQ_AREA1_PAL;
                    /* Equalizing and Serration area */
                    EQSERR_AREA0 = EQSERR_AREA0_PAL;
                    /* Equalizing and blank area */
                    EQBLANK_AREA0 = EQBLANK_AREA0_PAL;

                    /////////////////////////////////////////////////////////////////
                    // PAL Non-Interlace 

                    FIELD_OVER   = 4'd1;
                    TOTAL_LINE  = TOTAL_LINE_PAL_NOINTER;
                    TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_PAL_NOINTER;

                    /* Equalizing area 0~1 */
                    EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_PAL_NOINTER;  
                    EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_PAL_NOINTER;  
                    EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_PAL_NOINTER;  
                    EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_PAL_NOINTER;  
                    EQUALIZING_AREA2_START = 0;
                    EQUALIZING_AREA2_END   = 0;
                    EQUALIZING_AREA3_START = 0;
                    EQUALIZING_AREA3_END   = 0;

                    /* Serration area 0 */
                    SERRATION_AREA0_START = SERRATION_AREA0_START_PAL_NOINTER;
                    SERRATION_AREA0_END   = SERRATION_AREA0_END_PAL_NOINTER;
                    SERRATION_AREA1_START = 0;
                    SERRATION_AREA1_END   = 0;

                    /* burst disable area field 1 ~ field 8 */
                    BURST_AREA1_START0 = BURST_AREA1_START_PAL0_NOINTER;
                    BURST_AREA1_END0   = BURST_AREA1_END_PAL0_NOINTER;
                    BURST_AREA2_START0 = BURST_AREA2_START_PAL0_NOINTER;
                    BURST_AREA2_END0   = BURST_AREA2_END_PAL0_NOINTER;
                    BURST_AREA3_START0 = 0;
                    BURST_AREA3_END0   = 0;

                    BURST_AREA1_START1 = 10'd0;
                    BURST_AREA1_END1   = 10'd0;
                    BURST_AREA2_START1 = 10'd0;
                    BURST_AREA2_END1   = 10'd0;
                    BURST_AREA3_START1 = 10'd0;
                    BURST_AREA3_END1   = 10'd0;

                    /* Active video area */
                    ACTIVE_FIELD1_START = ACTIVE_FIELD1_START_PAL_NOINTER;
                    ACTIVE_FIELD1_END   = ACTIVE_FIELD1_END_PAL_NOINTER;
                    ACTIVE_FIELD2_START = 0;
                    ACTIVE_FIELD2_END   = 0;

                    /////////////////////////////////////////////////////////////////
                    // EN_SQPIXEL == 1 
                    HSYNC_START = HSYNC_START_SQ_PAL; 
                    BURST_START = BURST_START_SQ_PAL;
                    COLOR_START = COLOR_START_SQ_PAL;
                    HSYNC_SLOPE = HSYNC_SLOPE_SQ_PAL;
                    TOTAL_PIXEL = TOTAL_PIXEL_SQ_PALM1;
                    HSYNC_START_HALF = HSYNC_START_SQ_PAL_HALF;
                    HSYNC_WIDTH_HALF = HSYNC_WIDTH_SQ_PAL_HALF;
                    ACTIVE_TOTAL_PIXEL =ACTIVE_TOTAL_PIXEL_SQ_PAL;  

                    HSYNC_REMAIN  = HSYNC_REMAIN_SQ_PAL; 
                    HSYNC_REMAIN1 = HSYNC_REMAIN_SQ_PAL1; 

                    HSYNC_WIDTH1 = HSYNC_WIDTH_SQ_PAL;
                    HSYNC_WIDTH_HALF1 = HSYNC_WIDTH_SQ_PAL_HALF;

                 end
    endcase

end

// =======================================================================
//  Timing Counter Generation
// -----------------------------------------------------------------------
wire H_SET;   // setting H_CNT to start point NTSC 
              // or PAL in slavemode
wire H_SET_MASTER; 
wire H_SET_M; // in  master mode
wire SETMUX;
reg  HSYNCn_d;
reg  H_SET_MASTER_d /* synthesis syn_preserve =1 */; 

reg  VSYNCn_d;
reg  VSET_d;
reg  VSET_1d;
wire VSET = !VSYNCn & VSYNCn_d;
wire V_SET0; //field change even->odd
wire V_SET1; //field change odd ->even
wire V_SET0_d;
wire V_SET0_1d;

wire  F_UP_odd;
wire  F_UP_even;

reg   STABLE;
reg   NxSTABLE_EXT;

always @(ENABLE or
         STABLE or
         FIELD_CNT or
         F_UP_odd or
         F_UP_even )
begin
    
    NxSTABLE_EXT = 0;
    case(STABLE)

        1'b0: begin // UnSTABLE
                if(ENABLE && (FIELD_CNT == 0) && F_UP_odd) begin
                    NxSTABLE_EXT = 1'b1; //STABLE state
                end
                else begin
                    NxSTABLE_EXT = 1'b0; //UnSTABLE
                end
              end

        1'b1: begin //STABLE 
                if(ENABLE & FIELD_CNT[0] & F_UP_odd) begin
                    NxSTABLE_EXT = 1'b0; //STABLE state
                end
                else if(ENABLE & !FIELD_CNT[0] & F_UP_even) begin
                    NxSTABLE_EXT = 1'b0; //STABLE state
                end
                else begin
                    NxSTABLE_EXT =  1'b1;
                end
              end
    endcase
end


always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) STABLE <= 0;
    else        STABLE <= NxSTABLE_EXT;
end

wire NxSTABLE = (SETMUX) ? NxSTABLE_EXT : ENABLE;

// =======================================================================
//  Horizontal Counter Generation
// -----------------------------------------------------------------------
/* Horizontal pixel counter */

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        HSYNCn_d <= 1'b0;
        H_SET_MASTER_d <= 1'b0;
    end
    else begin
        HSYNCn_d <= HSYNCn;
        H_SET_MASTER_d <= H_SET_MASTER;
    end
end

assign H_SET_MASTER = (H_CNT == TOTAL_PIXEL) ? 1'b0 : 1'b1;
assign H_SET_M = H_SET_MASTER_d & !H_SET_MASTER;

assign SETMUX = (EN_INTERNAL_PATTERN) ? 1'b0 : MASTER_SLAVE_SEL;
assign H_SET=(SETMUX) ? (!HSYNCn & HSYNCn_d) : 1'b0;
             // MASTER_SLAVE_SEL == 1 --> Slave mode

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        H_CNT <= 0;
    end
    else if(NxSTABLE)begin
        if(!ENABLE)
            H_CNT <= 0;
        else if(H_SET)
            H_CNT <= HSYNC_START;
        else if(H_CNT == TOTAL_PIXEL)
            H_CNT <= 0;
        else
            H_CNT <= H_CNT + 1;
    end
    else begin
        H_CNT <= 0;
    end
end

// =======================================================================
//  Vertical counter gen.
// -----------------------------------------------------------------------
/* Vertical Line counter */
always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        VSYNCn_d <= 1'b0;
        VSET_d   <= 1'b0;
        VSET_1d  <= 1'b0;
    end
    else begin
        VSYNCn_d <= VSYNCn;
        VSET_d   <= VSET;
        VSET_1d  <= VSET_d;
    end
end

//applied for mode2
assign V_SET0 = (SETMUX) ? (VSET & H_SET )  : 1'b0; 
              //field change even->odd
assign V_SET1 = (SETMUX) ? (VSET & !H_SET)  : 1'b0; 
              //field change odd ->even
assign V_SET0_d  = (SETMUX) ? (VSET_d  & H_SET)  : 1'b0; 
assign V_SET0_1d = (SETMUX) ? (VSET_1d & H_SET)  : 1'b0; 

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        V_CNT <= 0;
    end
    else if(NxSTABLE)begin
        if(!ENABLE)
            V_CNT <= 9'd1;
        else if(V_SET0)
            V_CNT <= 9'd1;
        else if(V_SET0_d)
            V_CNT <= 9'd1;
        else if(V_SET0_1d)
            V_CNT <= 9'd1;
        else if(V_SET1 & !EN_NONINTERLACE)
            V_CNT <= EQSERR_AREA0;
        else if((V_CNT == TOTAL_LINE) && (H_CNT == TOTAL_PIXEL))
            V_CNT <= 9'd1;
        else if(H_CNT == TOTAL_PIXEL)
            V_CNT <= V_CNT + 1;
    end
    else begin
        V_CNT <= 0;
    end
end

// =======================================================================
//  Field counter gen.
// -----------------------------------------------------------------------
/* Field counter */
assign  F_UP_odd  = (SETMUX) ? V_SET0 : ((V_CNT == 9'd1)         && H_SET_M); 
assign  F_UP_even = (SETMUX) ? V_SET1 : ((V_CNT == EQSERR_AREA0) && H_SET_M); 

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        FIELD_CNT <= 4'd0;
    end
    else if(NxSTABLE)begin
        if(!ENABLE) begin
            FIELD_CNT <= 4'd0;
        end
        else if(F_UP_odd && (FIELD_CNT == FIELD_OVER)) begin
            FIELD_CNT <= 4'd1;
        end
        else if(F_UP_odd) begin
            FIELD_CNT <= FIELD_CNT + 4'd1;
        end
        else if(F_UP_even && (FIELD_CNT == FIELD_OVER) && EN_NONINTERLACE) begin
            FIELD_CNT <= 4'd1;
        end
        else if(F_UP_even) begin
            FIELD_CNT <= FIELD_CNT + 4'd1;
        end
    end
    else begin
        FIELD_CNT <= 4'd0;
    end
end

// =======================================================================
//  Hsync puls generation
// -----------------------------------------------------------------------
/* HSYNC_ENABLE generation */
reg EQ;    //Equalizing 
reg SE;    //Serration
reg SEEQ0; //Serration & Equliaing area 0 with active video
reg SEEQ1; //Serration & Equliaing area 1 with non-active video
reg EQSE;  //Equalizing & Serration area
reg EQBL;  //Equalizing & Blank area
reg NORMAL;//normal area
reg EN_HSYNC;

always @(
        /* Equalizing area 0~2 */
        EQUALIZING_AREA0_START or  
        EQUALIZING_AREA0_END or  
        EQUALIZING_AREA1_START or  
        EQUALIZING_AREA1_END or  
        EQUALIZING_AREA2_START or  
        EQUALIZING_AREA2_END or  
        EQUALIZING_AREA3_START or  
        EQUALIZING_AREA3_END or  

        /* Serration area 0~1 */
        SERRATION_AREA0_START or
        SERRATION_AREA0_END or
        SERRATION_AREA1_START or
        SERRATION_AREA1_END or

        /* Serration and Equalizing area 0  include active video*/
        SERREQ_AREA0 or

        /* Serration and Equalizing area 1 non-active video*/
        SERREQ_AREA1 or

        /* Equalizing and Serration area */
        EQSERR_AREA0 or

        /* Equalizing and blank area */
        EQBLANK_AREA0 or

        V_CNT
        ) begin

        NORMAL  = 1'b0;
        EQBL    = 1'b0;
        EQSE    = 1'b0;
        SEEQ1   = 1'b0;
        SEEQ0   = 1'b0;
        SE      = 1'b0;
        EQ      = 1'b0;

        /* Equalizing area 0~2 */
        if((V_CNT >= EQUALIZING_AREA0_START  && V_CNT <= EQUALIZING_AREA0_END ) ||
           (V_CNT >= EQUALIZING_AREA1_START  && V_CNT <= EQUALIZING_AREA1_END ) ||
           (V_CNT >= EQUALIZING_AREA2_START  && V_CNT <= EQUALIZING_AREA2_END ) ||
           (V_CNT >= EQUALIZING_AREA3_START  && V_CNT <= EQUALIZING_AREA3_END )) begin 

           EQ = 1'b1;
           NORMAL = 1'b0;
        end

        /* Serration area 0~1 */
        else if((V_CNT >= SERRATION_AREA0_START  && V_CNT <= SERRATION_AREA0_END ) ||
                (V_CNT >= SERRATION_AREA1_START  && V_CNT <= SERRATION_AREA1_END )) begin

           SE = 1'b1;
           NORMAL = 1'b0;
        end

        /* Serration and Equalizing area 0  include active video*/
        else if(V_CNT == SERREQ_AREA0) begin
           SEEQ0 = 1'b1;
           NORMAL = 1'b0;
        end

        /* Serration and Equalizing area 1 non-active video*/
        else if(V_CNT == SERREQ_AREA1) begin
           SEEQ1 = 1'b1;
           NORMAL = 1'b0;
        end

        /* Equalizing and Serration area */
        else if(V_CNT == EQSERR_AREA0) begin
           EQSE = 1'b1;
           NORMAL = 1'b0;
        end

        /* Equalizing and blank area */
        else if(V_CNT == EQBLANK_AREA0) begin
           EQBL = 1'b1;
           NORMAL = 1'b0;
        end
        else begin
           NORMAL = 1'b1;
           EQBL = 1'b0;
           EQSE = 1'b0;
           SEEQ1 = 1'b0;
           SEEQ0 = 1'b0;
           SE = 1'b0;
           EQ = 1'b0;
        end
end


always @(
        EQ or    //Equalizing 
        SE or    //Serration
        SEEQ0 or //Serration & Equliaing area 0 with active video
        SEEQ1 or //Serration & Equliaing area 1 with non-active video
        EQSE  or //Equalizing & Serration area
        EQBL  or //Equalizing & Blank area
        NORMAL or
        H_CNT or
        HSYNC_START or
        HSYNC_WIDTH_HALF or
        HSYNC_WIDTH or
        HSYNC_REMAIN or
        HSYNC_START_HALF or
        HSYNC_WIDTH_HALF1 or
        HSYNC_WIDTH1 or
        HSYNC_REMAIN1
        ) begin

    if(H_CNT == 10'd0) begin
        EN_HSYNC = 1'b0;
    end
    else if(H_CNT >= HSYNC_START && H_CNT < HSYNC_WIDTH_HALF) begin
        EN_HSYNC = 1'b1;
    end

    else if(H_CNT >= HSYNC_WIDTH_HALF && H_CNT < HSYNC_WIDTH) begin
        if(EQ || EQSE || EQBL)
            EN_HSYNC = 1'b0;
        else
            EN_HSYNC = 1'b1;
    end

    else if(H_CNT >= HSYNC_WIDTH && H_CNT < HSYNC_REMAIN) begin
        if(SE || SEEQ1)// || SEEQ0 || SEEQ1 )
            EN_HSYNC = 1'b1;
        else
            EN_HSYNC = 1'b0;
    end

    else if(H_CNT >= HSYNC_REMAIN && H_CNT < HSYNC_START_HALF) begin
        EN_HSYNC = 1'b0;
    end

    else if(H_CNT >= HSYNC_START_HALF && H_CNT < HSYNC_WIDTH_HALF1) begin
        if(NORMAL || EQBL)
            EN_HSYNC = 1'b0;
        else
            EN_HSYNC = 1'b1;
    end

    else if(H_CNT >= HSYNC_WIDTH_HALF1 && H_CNT < HSYNC_WIDTH1) begin

        if(EQ || EQBL || NORMAL || SEEQ0 || SEEQ1 )
            EN_HSYNC = 1'b0;
        else
            EN_HSYNC = 1'b1;
    end

    else if(H_CNT >= HSYNC_WIDTH1 && H_CNT < HSYNC_REMAIN1) begin
        if(SE || EQSE)
            EN_HSYNC = 1'b1;
        else
            EN_HSYNC = 1'b0;
    end

    else if(H_CNT >= HSYNC_REMAIN1) begin // && H_CNT < HSYNC_START_HALF) begin
        EN_HSYNC = 1'b0;
    end
    else begin /* Test point */
        EN_HSYNC = 1'b0;
    end

end

/* BURST_ENABLE generation */
reg BURST_AREA;
reg EN_BURST;    

assign BURST_NTSC_PAL =   ((OUT_MODE == NTSCM) ||
                         (OUT_MODE == NTSCJ) ||
                         (OUT_MODE == NTSC4)) ? 1'b0 : 1'b1; 

wire FIELD_AREA0    =   ((FIELD_CNT == 1) ||
                         (FIELD_CNT == 2) ||
                         (FIELD_CNT == 5) ||
                         (FIELD_CNT == 6)) ? 1'b1 : 1'b0; 
                         
always @(
        /* burst disable area field 1 ~ field 8 */
        BURST_AREA1_START0 or
        BURST_AREA1_END0 or
        BURST_AREA2_START0 or
        BURST_AREA2_END0 or
        BURST_AREA3_START0 or
        BURST_AREA3_END0 or

        BURST_AREA1_START1 or
        BURST_AREA1_END1 or
        BURST_AREA2_START1 or
        BURST_AREA2_END1 or
        BURST_AREA3_START1 or
        BURST_AREA3_END1 or

        V_CNT     or
        FIELD_AREA0 or
        BURST_NTSC_PAL

        ) begin

        BURST_AREA = 1'b0;

        if((FIELD_AREA0 && BURST_NTSC_PAL) || ((!FIELD_AREA0 | FIELD_AREA0) && !BURST_NTSC_PAL)) begin
            if((V_CNT >= BURST_AREA1_START0      && V_CNT <= BURST_AREA1_END0   ) ||
               (V_CNT >= BURST_AREA2_START0      && V_CNT <= BURST_AREA2_END0   ) ||
               (V_CNT >= BURST_AREA3_START0      && V_CNT <= BURST_AREA3_END0   )) begin

                BURST_AREA = 1'b0;
            end
            else
                BURST_AREA = 1'b1;
        end
        else begin
            if((V_CNT >= BURST_AREA1_START1      && V_CNT <= BURST_AREA1_END1   ) ||
               (V_CNT >= BURST_AREA2_START1      && V_CNT <= BURST_AREA2_END1   ) ||
               (V_CNT >= BURST_AREA3_START1      && V_CNT <= BURST_AREA3_END1   )) begin

                BURST_AREA = 1'b0;
            end
            else
                BURST_AREA = 1'b1;
        end

end

always @(
        BURST_AREA or    
        H_CNT or
        BURST_START or
        BURST_WIDTH 
        ) begin

    if(H_CNT == 10'd0) begin
        EN_BURST = 1'b0;
    end
    else if(H_CNT >= BURST_START && H_CNT <= BURST_WIDTH)begin

        if(BURST_AREA)
            EN_BURST = 1'b1;
        else
            EN_BURST = 1'b0;
    end
    else begin
        EN_BURST = 1'b0;
    end

end

// =======================================================================
//  Timing Enable generation
// -----------------------------------------------------------------------
/* BURST_ENABLE generation */
reg BURST_PH_ID;

always @(
        V_CNT[0]    or
        FIELD_AREA0 or
        BURST_NTSC_PAL or
        EN_NONINTERLACE
        ) begin

        if(EN_NONINTERLACE) begin
            if(BURST_NTSC_PAL) begin 
                //PAL mode
                BURST_PH_ID = V_CNT[0];
            end
            else begin
                //NTSC mode
                BURST_PH_ID = V_CNT[0];
            end
        end
        else begin
            
            //PAL mode
            if(FIELD_AREA0 && BURST_NTSC_PAL) begin
                BURST_PH_ID = V_CNT[0];
            end
            else if(!FIELD_AREA0 && BURST_NTSC_PAL) begin
                BURST_PH_ID = ~V_CNT[0];
            end
            //NTSC mode
            else if(FIELD_AREA0 && !BURST_NTSC_PAL) begin
                BURST_PH_ID = V_CNT[0];
            end
            else if(!FIELD_AREA0 && !BURST_NTSC_PAL) begin
                BURST_PH_ID = ~V_CNT[0];
            end
            else
                BURST_PH_ID = 1'b0;
        end
end


/* DISPLAY_ENABLE generation */
reg DISPLAY_AREA;
reg EN_DISPLAY;    


always @(
        ACTIVE_FIELD1_START or
        ACTIVE_FIELD2_START or
        ACTIVE_FIELD1_END or
        ACTIVE_FIELD2_END or
        V_CNT
        ) begin

        DISPLAY_AREA = 1'b0;

        /* Equalizing area 0~2 */
        if((V_CNT >= ACTIVE_FIELD1_START && V_CNT <= ACTIVE_FIELD1_END) ||
           (V_CNT >= ACTIVE_FIELD2_START && V_CNT <= ACTIVE_FIELD2_END)) begin 
           DISPLAY_AREA = 1'b1;
        end
        else begin
           DISPLAY_AREA = 1'b0;
        end
end

always @(
        COLOR_START or    
        ACTIVE_TOTAL_PIXEL or
        DISPLAY_AREA or
        H_CNT or
        COLOR_START or
        ACTIVE_TOTAL_PIXEL or
        DISPLAY_AREA  or
        HSYNC_START_HALF or
        SEEQ0
        ) begin

    if(H_CNT == 10'd0) begin
        EN_DISPLAY = 1'b0;
    end
    else if((H_CNT >= COLOR_START && H_CNT < ACTIVE_TOTAL_PIXEL) && DISPLAY_AREA && !SEEQ0)begin
        EN_DISPLAY = 1'b1;
    end
    else if((H_CNT >= COLOR_START && H_CNT < HSYNC_START_HALF) && DISPLAY_AREA && SEEQ0)begin
        EN_DISPLAY = 1'b1;
    end
    else begin
        EN_DISPLAY = 1'b0;
    end
end




/* delay sync signal for synthesizer */

wire FIELD_RESET = (FIELD_CNT == 5'd1) ? 1'b1 : 1'b0;
reg  rFIELD_RESET;
wire FIELD_RESET_ADDR = (FIELD_RESET & !rFIELD_RESET) ? 1'b1 : 1'b0;

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        rFIELD_RESET <= 1'b0;
    end
    else begin
        rFIELD_RESET <= FIELD_RESET;
    end
end

reg FIELD_RESET_ADDR_0d ;
reg FIELD_RESET_ADDR_1d /* synthesis syn_preserve =1 */;
reg FIELD_RESET_ADDR_2d /* synthesis syn_preserve =1 */;
reg FIELD_RESET_ADDR_3d /* synthesis syn_preserve =1 */;
reg FIELD_RESET_ADDR_4d /* synthesis syn_preserve =1 */;
reg FIELD_RESET_ADDR_5d /* synthesis syn_preserve =1 */;
reg FIELD_RESET_ADDR_6d /* synthesis syn_preserve =1 */;
reg FIELD_RESET_ADDR_7d /* synthesis syn_preserve =1 */;
reg FIELD_RESET_ADDR_8d /* synthesis syn_preserve =1 */;
reg FIELD_RESET_ADDR_9d /* synthesis syn_preserve =1 */;
reg FIELD_RESET_ADDR_10d /* synthesis syn_preserve =1 */;
reg FIELD_RESET_ADDR_11d /* synthesis syn_preserve =1 */;
//reg FIELD_RESET_ADDR_12d /* synthesis syn_preserve =1 */;
//reg FIELD_RESET_ADDR_13d /* synthesis syn_preserve =1 */;
//reg FIELD_RESET_ADDR_14d /* synthesis syn_preserve =1 */;
//reg FIELD_RESET_ADDR_15d /* synthesis syn_preserve =1 */;
//reg FIELD_RESET_ADDR_16d /* synthesis syn_preserve =1 */;
//reg FIELD_RESET_ADDR_17d /* synthesis syn_preserve =1 */;

reg BURST_ID_0d /* synthesis syn_preserve =1 */;
reg BURST_ID_1d /* synthesis syn_preserve =1 */;
reg BURST_ID_2d /* synthesis syn_preserve =1 */;
reg BURST_ID_3d /* synthesis syn_preserve =1 */; 
reg BURST_ID_4d /* synthesis syn_preserve =1 */; 
reg BURST_ID_5d /* synthesis syn_preserve =1 */; 
reg BURST_ID_6d /* synthesis syn_preserve =1 */; 
reg BURST_ID_7d /* synthesis syn_preserve =1 */; 
reg BURST_ID_8d /* synthesis syn_preserve =1 */; 
reg BURST_ID_9d /* synthesis syn_preserve =1 */; 
reg BURST_ID_10d /* synthesis syn_preserve =1 */; 
reg BURST_ID_11d /* synthesis syn_preserve =1 */; 
reg BURST_ID_12d /* synthesis syn_preserve =1 */; 
reg BURST_ID_13d /* synthesis syn_preserve =1 */; 
reg BURST_ID_14d /* synthesis syn_preserve =1 */; 
reg BURST_ID_15d /* synthesis syn_preserve =1 */; 
reg BURST_ID_16d /* synthesis syn_preserve =1 */; 
reg BURST_ID_17d /* synthesis syn_preserve =1 */; 

reg EN_DISPLAY_0d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_1d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_2d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_3d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_4d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_5d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_6d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_7d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_8d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_9d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_10d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_11d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_12d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_13d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_14d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_15d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_16d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_17d /* synthesis syn_preserve =1 */;
reg EN_DISPLAY_18d /* synthesis syn_preserve =1 */;
//reg EN_DISPLAY_19d /* synthesis syn_preserve =1 */;
//reg EN_DISPLAY_20d /* synthesis syn_preserve =1 */;
//reg EN_DISPLAY_21d /* synthesis syn_preserve =1 */;
//reg EN_DISPLAY_22d /* synthesis syn_preserve =1 */;
//reg EN_DISPLAY_23d /* synthesis syn_preserve =1 */;
//reg EN_DISPLAY_24d /* synthesis syn_preserve =1 */;

reg EN_BURST_0d /* synthesis syn_preserve =1 */;
reg EN_BURST_1d /* synthesis syn_preserve =1 */;
reg EN_BURST_2d /* synthesis syn_preserve =1 */;
reg EN_BURST_3d /* synthesis syn_preserve =1 */;
reg EN_BURST_4d /* synthesis syn_preserve =1 */;
reg EN_BURST_5d /* synthesis syn_preserve =1 */;
reg EN_BURST_6d /* synthesis syn_preserve =1 */;
reg EN_BURST_7d /* synthesis syn_preserve =1 */;
reg EN_BURST_8d /* synthesis syn_preserve =1 */;
reg EN_BURST_9d /* synthesis syn_preserve =1 */;
reg EN_BURST_10d /* synthesis syn_preserve =1 */;
reg EN_BURST_11d /* synthesis syn_preserve =1 */;
reg EN_BURST_12d /* synthesis syn_preserve =1 */;
reg EN_BURST_13d /* synthesis syn_preserve =1 */;
reg EN_BURST_14d /* synthesis syn_preserve =1 */;
reg EN_BURST_15d /* synthesis syn_preserve =1 */;
reg EN_BURST_16d /* synthesis syn_preserve =1 */;
reg EN_BURST_17d /* synthesis syn_preserve =1 */;
reg EN_BURST_18d /* synthesis syn_preserve =1 */;
reg EN_BURST_19d /* synthesis syn_preserve =1 */;
reg EN_BURST_20d /* synthesis syn_preserve =1 */;
reg EN_BURST_21d /* synthesis syn_preserve =1 */;
reg EN_BURST_22d /* synthesis syn_preserve =1 */;
reg EN_BURST_23d /* synthesis syn_preserve =1 */;
reg EN_BURST_24d /* synthesis syn_preserve =1 */;
reg EN_BURST_25d /* synthesis syn_preserve =1 */;

//reg EN_BURST_26d /* synthesis syn_preserve =1 */;
//reg EN_BURST_27d /* synthesis syn_preserve =1 */;
//reg EN_BURST_28d /* synthesis syn_preserve =1 */;
//reg EN_BURST_29d /* synthesis syn_preserve =1 */;
//reg EN_BURST_30d /* synthesis syn_preserve =1 */;
//reg EN_BURST_31d /* synthesis syn_preserve =1 */;

reg EN_HSYNC_0d /* synthesis syn_preserve =1 */;
reg EN_HSYNC_1d /* synthesis syn_preserve =1 */;
reg EN_HSYNC_2d /* synthesis syn_preserve =1 */;
reg EN_HSYNC_3d /* synthesis syn_preserve =1 */;
reg EN_HSYNC_4d /* synthesis syn_preserve =1 */;
reg EN_HSYNC_5d /* synthesis syn_preserve =1 */;
reg EN_HSYNC_6d /* synthesis syn_preserve =1 */;
reg EN_HSYNC_7d /* synthesis syn_preserve =1 */;
reg EN_HSYNC_8d /* synthesis syn_preserve =1 */;
reg EN_HSYNC_9d /* synthesis syn_preserve =1 */;
reg EN_HSYNC_10d /* synthesis syn_preserve =1 */;
reg EN_HSYNC_11d /* synthesis syn_preserve =1 */;
//reg EN_HSYNC_12d /* synthesis syn_preserve =1 */;
//reg EN_HSYNC_13d /* synthesis syn_preserve =1 */;
//reg EN_HSYNC_14d /* synthesis syn_preserve =1 */;
//reg EN_HSYNC_15d /* synthesis syn_preserve =1 */;
//reg EN_HSYNC_16d /* synthesis syn_preserve =1 */;
//reg EN_HSYNC_17d /* synthesis syn_preserve =1 */;

/* output interface block */
assign  ACT_DISPLAY_INTER = EN_DISPLAY_0d ;
assign  F_COUNTER_INTER = FIELD_CNT;
assign  H_COUNTER_INTER = H_CNT;
assign  V_COUNTER_INTER = V_CNT;

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin

        EN_DISPLAY_0d <= 0;
        EN_DISPLAY_1d <= 0;
        EN_DISPLAY_2d <= 0;
        EN_DISPLAY_3d <= 0;
        EN_DISPLAY_4d <= 0;
        EN_DISPLAY_5d <= 0;
        EN_DISPLAY_6d <= 0;
        EN_DISPLAY_7d <= 0;
        EN_DISPLAY_8d <= 0;
        EN_DISPLAY_9d <= 0;
        EN_DISPLAY_10d <= 0;
        EN_DISPLAY_11d <= 0;
        EN_DISPLAY_12d <= 0;
        EN_DISPLAY_13d <= 0;
        EN_DISPLAY_14d <= 0;
        EN_DISPLAY_15d <= 0;
        EN_DISPLAY_16d <= 0;
        EN_DISPLAY_17d <= 0;
        EN_DISPLAY_18d <= 0;
        /*
        EN_DISPLAY_19d <= 0;
        EN_DISPLAY_20d <= 0;
        EN_DISPLAY_21d <= 0;
        EN_DISPLAY_22d <= 0;
        EN_DISPLAY_23d <= 0;
        EN_DISPLAY_24d <= 0;
        */

        EN_BURST_0d <= 0;
        EN_BURST_1d <= 0;
        EN_BURST_2d <= 0;
        EN_BURST_3d <= 0;
        EN_BURST_4d <= 0;
        EN_BURST_5d <= 0;
        EN_BURST_6d <= 0;
        EN_BURST_7d <= 0;
        EN_BURST_8d <= 0;
        EN_BURST_9d <= 0;
        EN_BURST_10d <= 0;
        EN_BURST_11d <= 0;
        EN_BURST_12d <= 0;
        EN_BURST_13d <= 0;
        EN_BURST_14d <= 0;
        EN_BURST_15d <= 0;
        EN_BURST_16d <= 0;
        EN_BURST_17d <= 0;
        EN_BURST_18d <= 0;
        EN_BURST_19d <= 0;
        EN_BURST_20d <= 0;
        EN_BURST_21d <= 0;
        EN_BURST_22d <= 0;
        EN_BURST_23d <= 0;
        EN_BURST_24d <= 0;
        EN_BURST_25d <= 0;
        /*
        EN_BURST_26d <= 0;
        EN_BURST_27d <= 0;
        EN_BURST_28d <= 0;
        EN_BURST_29d <= 0;
        EN_BURST_30d <= 0;
        EN_BURST_31d <= 0;
        */

        EN_HSYNC_0d <= 0;
        EN_HSYNC_1d <= 0;
        EN_HSYNC_2d <= 0;
        EN_HSYNC_3d <= 0;
        EN_HSYNC_4d <= 0;
        EN_HSYNC_5d <= 0;
        EN_HSYNC_6d <= 0;
        EN_HSYNC_7d <= 0;
        EN_HSYNC_8d <= 0;
        EN_HSYNC_9d <= 0;
        EN_HSYNC_10d <= 0;
        EN_HSYNC_11d <= 0;
        /*
        EN_HSYNC_12d <= 0;
        EN_HSYNC_13d <= 0;
        EN_HSYNC_14d <= 0;
        EN_HSYNC_15d <= 0;
        EN_HSYNC_16d <= 0;
        EN_HSYNC_17d <= 0;
        EN_HSYNC_18d <= 0;
        EN_HSYNC_19d <= 0;
        EN_HSYNC_20d <= 0;
        EN_HSYNC_21d <= 0;
        EN_HSYNC_22d <= 0;
        EN_HSYNC_23d <= 0;
        EN_HSYNC_24d <= 0;
        */

        FIELD_RESET_ADDR_0d <= 0;
        FIELD_RESET_ADDR_1d <= 0;
        FIELD_RESET_ADDR_2d <= 0;
        FIELD_RESET_ADDR_3d <= 0;
        FIELD_RESET_ADDR_4d <= 0;
        FIELD_RESET_ADDR_5d <= 0;
        FIELD_RESET_ADDR_6d <= 0;
        FIELD_RESET_ADDR_7d <= 0;
        FIELD_RESET_ADDR_8d <= 0;
        FIELD_RESET_ADDR_9d <= 0;
        FIELD_RESET_ADDR_10d <= 0;
        FIELD_RESET_ADDR_11d <= 0;
        /*
        FIELD_RESET_ADDR_12d <= 0;
        FIELD_RESET_ADDR_13d <= 0;
        FIELD_RESET_ADDR_14d <= 0;
        FIELD_RESET_ADDR_15d <= 0;
        FIELD_RESET_ADDR_16d <= 0;
        FIELD_RESET_ADDR_17d <= 0;
        FIELD_RESET_ADDR_18d <= 0;
        FIELD_RESET_ADDR_19d <= 0;
        FIELD_RESET_ADDR_20d <= 0;
        FIELD_RESET_ADDR_21d <= 0;
        FIELD_RESET_ADDR_22d <= 0;
        FIELD_RESET_ADDR_23d <= 0;
        FIELD_RESET_ADDR_24d <= 0;
        */

        BURST_ID_0d <= 0; 
        BURST_ID_1d <= 0; 
        BURST_ID_2d <= 0; 
        BURST_ID_3d <= 0; 
        BURST_ID_4d <= 0; 
        BURST_ID_5d <= 0; 
        BURST_ID_6d <= 0; 
        BURST_ID_7d <= 0; 
        BURST_ID_8d <= 0; 
        BURST_ID_9d <= 0; 
        BURST_ID_10d <= 0; 
        BURST_ID_11d <= 0; 
        BURST_ID_12d <= 0; 
        BURST_ID_13d <= 0; 
        BURST_ID_14d <= 0; 
        BURST_ID_15d <= 0; 
        BURST_ID_16d <= 0; 
        BURST_ID_17d <= 0; 
        /*
        BURST_ID_18d <= 0; 
        BURST_ID_19d <= 0; 
        BURST_ID_20d <= 0; 
        BURST_ID_21d <= 0; 
        BURST_ID_22d <= 0; 
        BURST_ID_23d <= 0; 
        BURST_ID_24d <= 0; 
        BURST_ID_25d <= 0; 
        BURST_ID_26d <= 0; 
        BURST_ID_27d <= 0; 
        BURST_ID_28d <= 0; 
        */

    end
    else begin

        EN_DISPLAY_0d <=  EN_DISPLAY;
        EN_DISPLAY_1d <=  EN_DISPLAY_0d ;
        EN_DISPLAY_2d <=  EN_DISPLAY_1d ;
        EN_DISPLAY_3d <=  EN_DISPLAY_2d ;
        EN_DISPLAY_4d <=  EN_DISPLAY_3d ;
        EN_DISPLAY_5d <=  EN_DISPLAY_4d ;
        EN_DISPLAY_6d <=  EN_DISPLAY_5d ;
        EN_DISPLAY_7d <=  EN_DISPLAY_6d ;
        EN_DISPLAY_8d <=  EN_DISPLAY_7d ;
        EN_DISPLAY_9d <=  EN_DISPLAY_8d ;
        EN_DISPLAY_10d <=  EN_DISPLAY_9d ;
        EN_DISPLAY_11d <=  EN_DISPLAY_10d ;
        EN_DISPLAY_12d <=  EN_DISPLAY_11d ;
        EN_DISPLAY_13d <=  EN_DISPLAY_12d ;
        EN_DISPLAY_14d <=  EN_DISPLAY_13d ;
        EN_DISPLAY_15d <=  EN_DISPLAY_14d ;
        EN_DISPLAY_16d <=  EN_DISPLAY_15d ;
        EN_DISPLAY_17d <=  EN_DISPLAY_16d ;
        EN_DISPLAY_18d <=  EN_DISPLAY_17d ;
        /*
        EN_DISPLAY_19d <=  EN_DISPLAY_18d ;
        EN_DISPLAY_20d <=  EN_DISPLAY_19d ;
        EN_DISPLAY_21d <=  EN_DISPLAY_20d ;
        EN_DISPLAY_22d <=  EN_DISPLAY_21d ;
        EN_DISPLAY_23d <=  EN_DISPLAY_22d ;
        EN_DISPLAY_24d <=  EN_DISPLAY_23d ;
        */

        EN_BURST_0d <= EN_BURST;
        EN_BURST_1d <=  EN_BURST_0d ;
        EN_BURST_2d <=  EN_BURST_1d ;
        EN_BURST_3d <=  EN_BURST_2d ;
        EN_BURST_4d <=  EN_BURST_3d ;
        EN_BURST_5d <=  EN_BURST_4d ;
        EN_BURST_6d <=  EN_BURST_5d ;
        EN_BURST_7d <=  EN_BURST_6d ;
        EN_BURST_8d <=  EN_BURST_7d ;
        EN_BURST_9d <=  EN_BURST_8d ;
        EN_BURST_10d <=  EN_BURST_9d ;
        EN_BURST_11d <=  EN_BURST_10d ;
        EN_BURST_12d <=  EN_BURST_11d ;
        EN_BURST_13d <=  EN_BURST_12d ;
        EN_BURST_14d <=  EN_BURST_13d ;
        EN_BURST_15d <=  EN_BURST_14d ;
        EN_BURST_16d <=  EN_BURST_15d ;
        EN_BURST_17d <=  EN_BURST_16d ;
        EN_BURST_18d <=  EN_BURST_17d ;
        EN_BURST_19d <=  EN_BURST_18d ;
        EN_BURST_20d <=  EN_BURST_19d ;
        EN_BURST_21d <=  EN_BURST_20d ;
        EN_BURST_22d <=  EN_BURST_21d ;
        EN_BURST_23d <=  EN_BURST_22d ;
        EN_BURST_24d <=  EN_BURST_23d ;
        EN_BURST_25d <=  EN_BURST_24d ;
        /*
        EN_BURST_26d <=  EN_BURST_25d ;
        EN_BURST_27d <=  EN_BURST_26d ;
        EN_BURST_28d <=  EN_BURST_27d ;
        EN_BURST_29d <=  EN_BURST_28d ;
        EN_BURST_30d <=  EN_BURST_29d ;
        EN_BURST_31d <=  EN_BURST_30d ;
        */

        EN_HSYNC_0d <=  EN_HSYNC ;
        EN_HSYNC_1d <=  EN_HSYNC_0d ;
        EN_HSYNC_2d <=  EN_HSYNC_1d ;
        EN_HSYNC_3d <=  EN_HSYNC_2d ;
        EN_HSYNC_4d <=  EN_HSYNC_3d ;
        EN_HSYNC_5d <=  EN_HSYNC_4d ;
        EN_HSYNC_6d <=  EN_HSYNC_5d ;
        EN_HSYNC_7d <=  EN_HSYNC_6d ;
        EN_HSYNC_8d <=  EN_HSYNC_7d ;
        EN_HSYNC_9d <=  EN_HSYNC_8d ;
        EN_HSYNC_10d <=  EN_HSYNC_9d ;
        EN_HSYNC_11d <=  EN_HSYNC_10d ;
        /*
        EN_HSYNC_12d <=  EN_HSYNC_11d ;
        EN_HSYNC_13d <=  EN_HSYNC_12d ;
        EN_HSYNC_14d <=  EN_HSYNC_13d ;
        EN_HSYNC_15d <=  EN_HSYNC_14d ;
        EN_HSYNC_16d <=  EN_HSYNC_15d ;
        EN_HSYNC_17d <=  EN_HSYNC_16d ;
        EN_HSYNC_18d <=  EN_HSYNC_17d ;
        EN_HSYNC_19d <=  EN_HSYNC_18d ;
        EN_HSYNC_20d <=  EN_HSYNC_19d ;
        EN_HSYNC_21d <=  EN_HSYNC_20d ;
        EN_HSYNC_22d <=  EN_HSYNC_21d ;
        EN_HSYNC_23d <=  EN_HSYNC_22d ;
        EN_HSYNC_24d <=  EN_HSYNC_23d ;
        */

        FIELD_RESET_ADDR_0d <= FIELD_RESET_ADDR;
        FIELD_RESET_ADDR_1d <=FIELD_RESET_ADDR_0d;
        FIELD_RESET_ADDR_2d <=FIELD_RESET_ADDR_1d;
        FIELD_RESET_ADDR_3d <=FIELD_RESET_ADDR_2d;
        FIELD_RESET_ADDR_4d <=FIELD_RESET_ADDR_3d;
        FIELD_RESET_ADDR_5d <=FIELD_RESET_ADDR_4d;
        FIELD_RESET_ADDR_6d <=FIELD_RESET_ADDR_5d;
        FIELD_RESET_ADDR_7d <=FIELD_RESET_ADDR_6d;
        FIELD_RESET_ADDR_8d <=FIELD_RESET_ADDR_7d;
        FIELD_RESET_ADDR_9d <=FIELD_RESET_ADDR_8d;
        FIELD_RESET_ADDR_10d <=FIELD_RESET_ADDR_9d;
        FIELD_RESET_ADDR_11d <=FIELD_RESET_ADDR_10d;
        /*
        FIELD_RESET_ADDR_12d <=FIELD_RESET_ADDR_11d;
        FIELD_RESET_ADDR_13d <=FIELD_RESET_ADDR_12d;
        FIELD_RESET_ADDR_14d <=FIELD_RESET_ADDR_13d;
        FIELD_RESET_ADDR_15d <=FIELD_RESET_ADDR_14d;
        FIELD_RESET_ADDR_16d <=FIELD_RESET_ADDR_15d;
        FIELD_RESET_ADDR_17d <=FIELD_RESET_ADDR_16d;
        FIELD_RESET_ADDR_18d <=FIELD_RESET_ADDR_17d;
        FIELD_RESET_ADDR_19d <=FIELD_RESET_ADDR_18d;
        FIELD_RESET_ADDR_20d <=FIELD_RESET_ADDR_19d;
        FIELD_RESET_ADDR_21d <=FIELD_RESET_ADDR_20d;
        FIELD_RESET_ADDR_22d <=FIELD_RESET_ADDR_21d;
        FIELD_RESET_ADDR_23d <=FIELD_RESET_ADDR_22d;
        FIELD_RESET_ADDR_24d <=FIELD_RESET_ADDR_23d;
        */

        BURST_ID_0d <= BURST_PH_ID; 
        BURST_ID_1d <= BURST_ID_0d; 
        BURST_ID_2d <= BURST_ID_1d; 
        BURST_ID_3d <= BURST_ID_2d; 
        BURST_ID_4d <= BURST_ID_3d; 
        BURST_ID_5d <= BURST_ID_4d; 
        BURST_ID_6d <= BURST_ID_5d; 
        BURST_ID_7d <= BURST_ID_6d; 
        BURST_ID_8d <= BURST_ID_7d; 
        BURST_ID_9d <= BURST_ID_8d; 
        BURST_ID_10d <= BURST_ID_9d; 
        BURST_ID_11d <= BURST_ID_10d; 
        BURST_ID_12d <= BURST_ID_11d; 
        BURST_ID_13d <= BURST_ID_12d; 
        BURST_ID_14d <= BURST_ID_13d; 
        BURST_ID_15d <= BURST_ID_14d; 
        BURST_ID_16d <= BURST_ID_15d; 
        BURST_ID_17d <= BURST_ID_16d; 
        /*
        BURST_ID_18d <= BURST_ID_17d; 
        BURST_ID_19d <= BURST_ID_18d; 
        BURST_ID_20d <= BURST_ID_19d; 
        BURST_ID_21d <= BURST_ID_20d; 
        BURST_ID_22d <= BURST_ID_21d; 
        BURST_ID_23d <= BURST_ID_22d; 
        BURST_ID_24d <= BURST_ID_23d; 
        BURST_ID_25d <= BURST_ID_24d; 
        BURST_ID_26d <= BURST_ID_25d; 
        BURST_ID_28d <= BURST_ID_27d; 
        */
    end
end

// =======================================================================
// Output assign 
// -----------------------------------------------------------------------

/*
assign  HSYNC_ENABLE    = EN_HSYNC_17d;
assign  BURST_ENABLE    = EN_BURST_17d;
assign  BURST_ID        = BURST_ID_17d;
assign  ACT_DISPLAY_SYN = EN_DISPLAY_17d;
assign  RESET_ADDR      = FIELD_RESET_ADDR_17d;
assign  ACT_DISPLAY_ADDR  = EN_DISPLAY_16d | EN_DISPLAY_24d;
assign  BURST_ENABLE_ADDR = EN_BURST_16d   | EN_BURST_31d;
*/

assign  HSYNC_ENABLE    = EN_HSYNC_11d;
assign  BURST_ENABLE    = EN_BURST_11d;
assign  BURST_ID        = BURST_ID_11d;
assign  ACT_DISPLAY_SYN = EN_DISPLAY_11d;
assign  RESET_ADDR      = FIELD_RESET_ADDR_11d;
assign  ACT_DISPLAY_ADDR  = EN_DISPLAY_10d | EN_DISPLAY_18d;
assign  BURST_ENABLE_ADDR = EN_BURST_10d   | EN_BURST_25d;

endmodule
