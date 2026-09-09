// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : RTCAPBinterface.v
// File Revision       : 0.1
// -------------------------------------------------------------------
// Purpose            : This module is APBinterface
// ===================================================================


`timescale 1ns/10ps


`define RTCAPBADDR0 8'h00   //0x00 RTC control
`define RTCAPBADDR1 8'h01   //0x04 RTC status register
`define RTCAPBADDR2 8'h02   //0x08 RTC interrupt
`define RTCAPBADDR3 8'h03   //0x0C RTC compensation

`define RTCAPBADDR8  8'h08   //0x20 Seconds setting
`define RTCAPBADDR9  8'h09   //0x24 Minutes setting
`define RTCAPBADDR10 8'd10   //0x28 Hours setting
`define RTCAPBADDR11 8'd11   //0x2C Days setting
`define RTCAPBADDR12 8'd12   //0x30 Months setting
`define RTCAPBADDR13 8'd13   //0x34 Years setting
`define RTCAPBADDR14 8'd14   //0x38 Week setting

`define RTCAPBADDR16 8'd16   //0x40 Alarm seconds
`define RTCAPBADDR17 8'd17   //0x04 Alarm minutes
`define RTCAPBADDR18 8'd18   //0x08 Alarm hours
`define RTCAPBADDR19 8'd19   //0x0C Alarm days
`define RTCAPBADDR20 8'd20   //0x50 Alarm months
`define RTCAPBADDR21 8'd21   //0x54 Alarm years


module RTCAPBinterface
(

//  APB bus
    PCLK     ,
    PRESETn  ,

    PENABLE  , 
    PSEL     , 
    PWRITE   , 
    PADDR    ,  //[9:2]  used
    PWDATA   ,  //[31:0] used
    PRDATA   ,  //[31:0] used

    IntTimer,
    IntAlarm,

    IntTimer_32K,
    IntAlarm_32K,
//input
    CLK,       // 32khz clock input

//Register Setting
    RTC_ENABLE,
    SET_32_CNT,
    MODE_APM,
    EN_COMP,
    STOP_RTC,

    CLEAR,
    ALARM,
    
    PERIOD,
    EN_INT_TIMER,
    EN_INT_ALARM,
    RTC_COMP,

    SET_SEC0,
    SET_SEC1,
    SET_MIN0,
    SET_MIN1,
    SET_HOUR0,
    SET_HOUR1,
    SET_PMAM,
    SET_DAY0,
    SET_DAY1,
    SET_MON0,
    SET_MON1,
    SET_YEAR0,
    SET_YEAR1,
    SET_WEEK,

    AL_SEC0,
    AL_SEC1,
    AL_MIN0,
    AL_MIN1,
    AL_HOUR0,
    AL_HOUR1,
    AL_PMAM,
    AL_DAY0,
    AL_DAY1,
    AL_MON0,
    AL_MON1,
    AL_YEAR0,
    AL_YEAR1,

    WR_SEC,
    WR_MIN,
    WR_HOUR,
    WR_DAY,
    WR_MON,
    WR_YEAR,
    WR_WEEK,

//Rd data
    RD_SEC0,
    RD_SEC1,
    RD_MIN0,
    RD_MIN1,
    RD_HOUR0,
    RD_HOUR1,
    RD_PMAM,
    RD_DAY0,
    RD_DAY1,
    RD_MON0,
    RD_MON1,
    RD_YEAR0,
    RD_YEAR1,
    RD_WEEK,

    TimeAlarm2APB,
    SecAlarm2APB,
    MinAlarm2APB,
    HourAlarm2APB,
    DayAlarm2APB,
    RUN2APB,
    BUSY2APB,

    IntTimer2APB,
    IntAlarm2APB
);

//APB bus//////////////////////
input   PCLK;
input   PRESETn;

input	[9:2]	PADDR;
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

output  IntTimer;
output  IntAlarm;
output  IntTimer_32K;
output  IntAlarm_32K;

/////////////////////////////////

input   CLK; // 32khz clock


//Register Setting value ////////
output  RTC_ENABLE;
output  SET_32_CNT;
output  MODE_APM;
output  EN_COMP;
output  STOP_RTC;

output  CLEAR;
output  ALARM;
    
output  [1:0]   PERIOD;
output  EN_INT_TIMER;
output  EN_INT_ALARM;
output  [15:0]  RTC_COMP;

//Setting timer
output  [3:0]   SET_SEC0;
output  [2:0]   SET_SEC1;

output  [3:0]   SET_MIN0;
output  [2:0]   SET_MIN1;
    
output  [3:0]   SET_HOUR0;
output  [2:0]   SET_HOUR1;
output  SET_PMAM;

output  [3:0]   SET_DAY0;
output  [1:0]   SET_DAY1;

output  [3:0]   SET_MON0;
output  SET_MON1;

output  [3:0]   SET_YEAR0;
output  [3:0]   SET_YEAR1;
output  [2:0]   SET_WEEK;

//Alarm value
output  [3:0]   AL_SEC0;
output  [2:0]   AL_SEC1;

output  [3:0]   AL_MIN0;
output  [2:0]   AL_MIN1;
    
output  [3:0]   AL_HOUR0;
output  [2:0]   AL_HOUR1;
output  AL_PMAM;

output  [3:0]   AL_DAY0;
output  [1:0]   AL_DAY1;

output  [3:0]   AL_MON0;
output  AL_MON1;

output  [3:0]   AL_YEAR0;
output  [3:0]   AL_YEAR1;

output  WR_SEC;
output  WR_MIN;
output  WR_HOUR;
output  WR_DAY;
output  WR_MON;
output  WR_YEAR;
output  WR_WEEK;


//Read value
input  [3:0]   RD_SEC0;
input  [2:0]   RD_SEC1;

input  [3:0]   RD_MIN0;
input  [2:0]   RD_MIN1;
    
input  [3:0]   RD_HOUR0;
input  [2:0]   RD_HOUR1;
input  RD_PMAM;

input  [3:0]   RD_DAY0;
input  [1:0]   RD_DAY1;

input  [3:0]   RD_MON0;
input  RD_MON1;

input  [3:0]   RD_YEAR0;
input  [3:0]   RD_YEAR1;
input  [2:0]   RD_WEEK;

input  TimeAlarm2APB;
input  SecAlarm2APB;
input  MinAlarm2APB;
input  HourAlarm2APB;
input  DayAlarm2APB;
input  RUN2APB;
input  BUSY2APB;

input  IntTimer2APB;
input  IntAlarm2APB;

//==================================================================
// Register 
//__________________________________________________________________

// clock domain
reg  rRTC_ENABLE;
reg  rSET_32_CNT;
reg  rMODE_APM;
reg  rEN_COMP;
reg  rSTOP_RTC;

reg  rCLEAR;
reg  rALARM;
    
reg  [1:0]   rPERIOD;
reg  rEN_INT_TIMER;
reg  rEN_INT_ALARM;
reg  [15:0]  rRTC_COMP;

reg  [3:0]   rSET_SEC0;
reg  [2:0]   rSET_SEC1;

reg  [3:0]   rSET_MIN0;
reg  [2:0]   rSET_MIN1;
    
reg  [3:0]   rSET_HOUR0;
reg  [2:0]   rSET_HOUR1;
reg  rSET_PMAM;

reg  [3:0]   rSET_DAY0;
reg  [1:0]   rSET_DAY1;

reg  [3:0]   rSET_MON0;
reg  rSET_MON1;

reg  [3:0]   rSET_YEAR0;
reg  [3:0]   rSET_YEAR1;
reg  [2:0]   rSET_WEEK;

//Alarm value
reg  [3:0]   rAL_SEC0;
reg  [2:0]   rAL_SEC1;

reg  [3:0]   rAL_MIN0;
reg  [2:0]   rAL_MIN1;
    
reg  [3:0]   rAL_HOUR0;
reg  [2:0]   rAL_HOUR1;
reg  rAL_PMAM;

reg  [3:0]   rAL_DAY0;
reg  [1:0]   rAL_DAY1;

reg  [3:0]   rAL_MON0;
reg  rAL_MON1;

reg  [3:0]   rAL_YEAR0;
reg  [3:0]   rAL_YEAR1;

//==================================================================
// Interrupt domain change 
//__________________________________________________________________

wire StartEdgIntTimer; //period alarm detect signal
wire StartEdgIntAlarm; //alarm detect signal
wire EndEdgIntTimer;   //period alarm detect signal
wire EndEdgIntAlarm;   //alarm detect signal

reg rINT_TIMER;
reg rINT_ALARM;
reg rINT_TIMER_d;
reg rINT_ALARM_d;
reg rINT_TIMER_1d;
reg rINT_ALARM_1d;

reg  IntTimer_32K;
reg  IntAlarm_32K;
reg  FirstChAlarm_32K;
reg  FirstChTimer_32K;

reg  IntTimer;
reg  IntAlarm;
reg  FirstChAlarm_APB;
reg  FirstChTimer_APB;
//__________________________________________________________________
//
// Interrupt domain change (32Khz --> APB clock)
//
//  APB clock domain interrupt generation for interrupt controller
//  controlled in APB frequency
//__________________________________________________________________

always @(posedge PCLK or negedge PRESETn) begin

    if(!PRESETn) begin
        rINT_TIMER <= 0;
        rINT_ALARM <= 0;
        rINT_TIMER_d <= 0;
        rINT_ALARM_d <= 0;
    end
    else begin
        rINT_TIMER   <= IntTimer2APB;
        rINT_ALARM   <= IntAlarm2APB;
        rINT_TIMER_d <= rINT_TIMER;
        rINT_ALARM_d <= rINT_ALARM;
        rINT_TIMER_1d <= rINT_TIMER_d;
        rINT_ALARM_1d <= rINT_ALARM_d;
    end
end

assign StartEdgIntTimer = rINT_TIMER_d  & !rINT_TIMER_1d ;
assign StartEdgIntAlarm = rINT_ALARM_d  & !rINT_ALARM_1d ;
assign EndEdgIntTimer   = !rINT_TIMER_d & rINT_TIMER_1d ;
assign EndEdgIntAlarm   = !rINT_ALARM_d & rINT_ALARM_1d ;

always @(posedge PCLK or negedge PRESETn) begin

    if(!PRESETn) begin
        IntTimer<= 0;
        IntAlarm<= 0;
    end
    else begin

        //Alarm check and clear
        if(StartEdgIntAlarm) begin
            IntAlarm <= 1'b1;
        end
        else if(rALARM) begin
            IntAlarm <= 1'b0;
        end
        else if(EndEdgIntAlarm) begin
            IntAlarm<= 1'b0;
        end

        //Alarm check and clear
        if(StartEdgIntTimer) begin
            IntTimer<= 1'b1;
        end
        else if(rALARM) begin
            IntTimer<= 1'b0;
        end
        else if(EndEdgIntTimer   ) begin
            IntTimer<= 1'b0;
        end
    end
end

//__________________________________________________________________
//
// Interrupt make
//
//  32Khz domain interrupt generation for Power block which is 
//  controlled in 32Khz frequency
//__________________________________________________________________

always @(posedge CLK or negedge PRESETn) begin

    if(!PRESETn) begin
        IntTimer_32K <= 0;
        IntAlarm_32K <= 0;
        FirstChAlarm_32K <= 0;
        FirstChTimer_32K <= 0;
    end
    else begin

        //Alarm check and clear
        if(IntAlarm_32K  & ALARM) begin
            IntAlarm_32K <= 1'b0;
            FirstChAlarm_32K <= 1;
        end
        else if(!FirstChAlarm_32K & IntAlarm2APB) begin
            IntAlarm_32K <= 1'b1;
        end
        else if(FirstChAlarm_32K & IntAlarm2APB) begin
            IntAlarm_32K <= 1'b0;
            FirstChAlarm_32K <= 1;
        end
        else if(!IntAlarm2APB) begin
            IntAlarm_32K <= 1'b0;
            FirstChAlarm_32K <= 0;
        end

        //Alarm check and clear
        if(IntTimer_32K & ALARM) begin
            IntTimer_32K <= 1'b0;
            FirstChTimer_32K <= 1;
        end
        else if(!FirstChTimer_32K & IntTimer2APB) begin
            IntTimer_32K <= 1'b1;
        end
        else if(FirstChTimer_32K & IntTimer2APB) begin
            IntTimer_32K <= 1'b0;
            FirstChTimer_32K <= 1;
        end
        else if(!IntTimer2APB) begin
            IntTimer_32K <= 1'b0;
        end
    end
end
//__________________________________________________________________

//==================================================================
// Read domain change 32Khz --> APB clock domain 
//__________________________________________________________________

//32Khz domain
//1delay domain Clock PCLK
reg  [3:0]   rRD_SEC0_d;
reg  [2:0]   rRD_SEC1_d;
reg  [3:0]   rRD_MIN0_d;
reg  [2:0]   rRD_MIN1_d;
reg  [3:0]   rRD_HOUR0_d;
reg  [2:0]   rRD_HOUR1_d;
reg  rRD_PMAM_d;
reg  [3:0]   rRD_DAY0_d;
reg  [1:0]   rRD_DAY1_d;
reg  [3:0]   rRD_MON0_d;
reg  rRD_MON1_d;
reg  [3:0]   rRD_YEAR0_d;
reg  [3:0]   rRD_YEAR1_d;
reg  [2:0]   rRD_WEEK_d;

reg  rTimeAlarm2APB_d;
reg  rSecAlarm2APB_d;
reg  rMinAlarm2APB_d;
reg  rHourAlarm2APB_d;
reg  rDayAlarm2APB_d;
reg  rRUN2APB_d;
reg  rBUSY2APB_d;

//__________________________________________________________________
//
// SEC LSB chage checker
//__________________________________________________________________
reg  rRDSEC_LSB_1d;
reg  rRDSEC_LSB_2d;
reg  rRDSEC_LSB_3d;

wire SECchangeEdge = rRDSEC_LSB_2d ^ rRDSEC_LSB_3d;
always @(posedge PCLK or negedge PRESETn) begin

    if(!PRESETn) begin
        rRDSEC_LSB_1d <= 1'b0;
        rRDSEC_LSB_2d <= 1'b0;
        rRDSEC_LSB_3d <= 1'b0;
    end
    else begin
        rRDSEC_LSB_1d <= RD_SEC0[0];
        rRDSEC_LSB_2d <= rRDSEC_LSB_1d ;
        rRDSEC_LSB_3d <= rRDSEC_LSB_2d ;
    end
end
//__________________________________________________________________


//__________________________________________________________________
//
// Latch the data from core block by using PCLK
//__________________________________________________________________

always @(posedge PCLK or negedge PRESETn) begin

    if(!PRESETn) begin

        rTimeAlarm2APB_d <= 0;
        rSecAlarm2APB_d <= 0;
        rMinAlarm2APB_d <= 0;
        rHourAlarm2APB_d <= 0;
        rDayAlarm2APB_d <= 0;
        rRUN2APB_d <= 0;
        rBUSY2APB_d <= 0;

        rRD_SEC0_d <= 0;
        rRD_SEC1_d <= 0;
        rRD_MIN0_d <= 0;
        rRD_MIN1_d <= 0;
        rRD_HOUR0_d <= 0;
        rRD_HOUR1_d <= 0;
        rRD_PMAM_d <= 0;
        rRD_DAY0_d <= 0;
        rRD_DAY1_d <= 0;
        rRD_MON0_d <= 0;
        rRD_MON1_d <= 0;
        rRD_YEAR0_d <= 0;
        rRD_YEAR1_d <= 0;
        rRD_WEEK_d <= 0;

    end
    else if(SECchangeEdge) begin 
        rRD_SEC0_d  <= RD_SEC0 ;
        rRD_SEC1_d  <= RD_SEC1 ;
        rRD_MIN0_d  <= RD_MIN0 ;
        rRD_MIN1_d  <= RD_MIN1 ;
        rRD_HOUR0_d <= RD_HOUR0 ;
        rRD_HOUR1_d <= RD_HOUR1 ;
        rRD_PMAM_d  <= RD_PMAM ;
        rRD_DAY0_d  <= RD_DAY0 ;
        rRD_DAY1_d  <= RD_DAY1 ;
        rRD_MON0_d  <= RD_MON0 ;
        rRD_MON1_d  <= RD_MON1 ;
        rRD_YEAR0_d <= RD_YEAR0 ;
        rRD_YEAR1_d <= RD_YEAR1 ;
        rRD_WEEK_d  <= RD_WEEK;

        rTimeAlarm2APB_d    <= TimeAlarm2APB ;
        rSecAlarm2APB_d     <= SecAlarm2APB ;
        rMinAlarm2APB_d     <= MinAlarm2APB ;
        rHourAlarm2APB_d    <= HourAlarm2APB ;
        rDayAlarm2APB_d     <= DayAlarm2APB ;
        rRUN2APB_d          <= RUN2APB ;
        rBUSY2APB_d         <= BUSY2APB ;

    end

end

//==================================================================
// Setting assign
//__________________________________________________________________

assign SET_SEC0 =rSET_SEC0  ;
assign SET_SEC1 =rSET_SEC1 ;
assign SET_MIN0 =rSET_MIN0 ;
assign SET_MIN1 =rSET_MIN1 ;
assign SET_HOUR0=rSET_HOUR0;
assign SET_HOUR1=rSET_HOUR1;
assign SET_PMAM =rSET_PMAM ;
assign SET_DAY0 =rSET_DAY0 ;
assign SET_DAY1 =rSET_DAY1 ;
assign SET_MON0 =rSET_MON0 ;
assign SET_MON1 =rSET_MON1 ;
assign SET_YEAR0=rSET_YEAR0;
assign SET_YEAR1=rSET_YEAR1;
assign SET_WEEK =rSET_WEEK ;

//==================================================================
// Domain change  
//__________________________________________________________________
//Register Setting value ////////
reg  RTC_ENABLE;
reg  SET_32_CNT;
reg  MODE_APM;
reg  EN_COMP;
reg  STOP_RTC;
reg  CLEAR;
reg  ALARM;
reg  EN_INT_TIMER;
reg  EN_INT_ALARM;
reg  [15:0]  RTC_COMP;
reg  [1:0]   PERIOD;

//Alarm value
reg  [3:0]   AL_SEC0;
reg  [2:0]   AL_SEC1;
reg  [3:0]   AL_MIN0;
reg  [2:0]   AL_MIN1;
reg  [3:0]   AL_HOUR0;
reg  [2:0]   AL_HOUR1;
reg  AL_PMAM;
reg  [3:0]   AL_DAY0;
reg  [1:0]   AL_DAY1;
reg  [3:0]   AL_MON0;
reg  AL_MON1;
reg  [3:0]   AL_YEAR0;
reg  [3:0]   AL_YEAR1;

//Register Setting value ////////
reg  rRTC_ENABLE_d;
reg  rSET_32_CNT_d;
reg  rMODE_APM_d;
reg  rEN_COMP_d;
reg  rSTOP_RTC_d;
reg  rCLEAR_d;
reg  rALARM_d;
reg  [1:0]   rPERIOD_d;
reg  rEN_INT_TIMER_d;
reg  rEN_INT_ALARM_d;
reg  [15:0]  rRTC_COMP_d;

reg  WR_SEC_d;
reg  WR_MIN_d;
reg  WR_HOUR_d;
reg  WR_DAY_d;
reg  WR_MON_d;
reg  WR_YEAR_d;
reg  WR_WEEK_d;

reg  WR_SEC_1d;
reg  WR_MIN_1d;
reg  WR_HOUR_1d;
reg  WR_DAY_1d;
reg  WR_MON_1d;
reg  WR_YEAR_1d;
reg  WR_WEEK_1d;

reg  WR_SEC_2d;
reg  WR_MIN_2d;
reg  WR_HOUR_2d;
reg  WR_DAY_2d;
reg  WR_MON_2d;
reg  WR_YEAR_2d;
reg  WR_WEEK_2d;

assign  WR_SEC = WR_SEC_1d   & !WR_SEC_2d;
assign  WR_MIN = WR_MIN_1d   & !WR_MIN_2d;
assign  WR_HOUR = WR_HOUR_1d & !WR_HOUR_2d;
assign  WR_DAY  = WR_DAY_1d  & !WR_DAY_2d  ;
assign  WR_MON  = WR_MON_1d  & !WR_MON_2d  ;
assign  WR_YEAR = WR_YEAR_1d & !WR_YEAR_2d ;
assign  WR_WEEK = WR_WEEK_1d & !WR_WEEK_2d ;

reg  AlWR_SEC_d;
reg  AlWR_MIN_d;
reg  AlWR_HOUR_d;
reg  AlWR_DAY_d;
reg  AlWR_MON_d;
reg  AlWR_YEAR_d;

reg  AlWR_SEC_1d;
reg  AlWR_MIN_1d;
reg  AlWR_HOUR_1d;
reg  AlWR_DAY_1d;
reg  AlWR_MON_1d;
reg  AlWR_YEAR_1d;

reg  AlWR_SEC_2d;
reg  AlWR_MIN_2d;
reg  AlWR_HOUR_2d;
reg  AlWR_DAY_2d;
reg  AlWR_MON_2d;
reg  AlWR_YEAR_2d;

wire  AlWR_SEC  = AlWR_SEC_1d  & !AlWR_SEC_2d;
wire  AlWR_MIN  = AlWR_MIN_1d  & !AlWR_MIN_2d;
wire  AlWR_HOUR = AlWR_HOUR_1d & !AlWR_HOUR_2d;
wire  AlWR_DAY  = AlWR_DAY_1d  & !AlWR_DAY_2d  ;
wire  AlWR_MON  = AlWR_MON_1d  & !AlWR_MON_2d  ;
wire  AlWR_YEAR = AlWR_YEAR_1d & !AlWR_YEAR_2d ;

//Setting timer

reg WrHOUR;
reg WrMIN;
reg WrSEC;
reg WrDAY;
reg WrMON;
reg WrYEAR;
reg WrWEEK;

reg AlWrHOUR;
reg AlWrMIN;
reg AlWrSEC;
reg AlWrDAY;
reg AlWrMON;
reg AlWrYEAR;


always @(posedge CLK or negedge PRESETn) begin : p_PCLKtoCLKDomain

    if(!PRESETn) begin

        WR_SEC_2d <= 0;
        WR_MIN_2d <= 0;
        WR_HOUR_2d <= 0;
        WR_DAY_2d <= 0;
        WR_MON_2d <= 0;
        WR_YEAR_2d <= 0;
        WR_WEEK_2d <= 0;

        WR_SEC_1d <= 0;
        WR_MIN_1d <= 0;
        WR_HOUR_1d <= 0;
        WR_DAY_1d <= 0;
        WR_MON_1d <= 0;
        WR_YEAR_1d <= 0;
        WR_WEEK_1d <= 0;

        WR_SEC_d <= 0;
        WR_MIN_d <= 0;
        WR_HOUR_d <= 0;
        WR_DAY_d  <= 0;
        WR_MON_d  <= 0;
        WR_YEAR_d <= 0;
        WR_WEEK_d <= 0;

        AlWR_SEC_d  <= 0;
        AlWR_MIN_d  <= 0;
        AlWR_HOUR_d <= 0;
        AlWR_DAY_d  <= 0;
        AlWR_MON_d  <= 0;
        AlWR_YEAR_d <= 0;
        
        AlWR_SEC_1d <= 0;
        AlWR_MIN_1d <= 0;
        AlWR_HOUR_1d<= 0;
        AlWR_DAY_1d <= 0;
        AlWR_MON_1d <= 0;
        AlWR_YEAR_1d<= 0;
        
        AlWR_SEC_2d <= 0;
        AlWR_MIN_2d <= 0;
        AlWR_HOUR_2d<= 0;
        AlWR_DAY_2d <= 0;
        AlWR_MON_2d <= 0;
        AlWR_YEAR_2d<= 0;

//setting register
        RTC_ENABLE <= 0;
        SET_32_CNT <= 0;
        MODE_APM <= 0;
        EN_COMP <= 0;
        STOP_RTC <= 0;
        CLEAR <= 1;
        ALARM <= 0;
        PERIOD <= 0;
        EN_INT_TIMER <= 0;
        EN_INT_ALARM <= 0;
        RTC_COMP <= 0;

//Alarm value
        AL_SEC0 <= 0;
        AL_SEC1 <= 0;
        AL_MIN0 <= 0;
        AL_MIN1 <= 0;
        AL_HOUR0 <= 0;
        AL_HOUR1 <= 0;
        AL_PMAM <= 0;
        AL_DAY0 <= 0;
        AL_DAY1 <= 0;
        AL_MON0 <= 0;
        AL_MON1 <= 0;
        AL_YEAR0 <= 0;
        AL_YEAR1 <= 0;

//Register Setting value ////////
        rRTC_ENABLE_d <= 0;
        rSET_32_CNT_d <= 0;
        rMODE_APM_d <= 0;
        rEN_COMP_d <= 0;
        rSTOP_RTC_d <= 0;
        rCLEAR_d <= 1;
        rALARM_d <= 0;
        rPERIOD_d <= 0;
        rEN_INT_TIMER_d <= 0;
        rEN_INT_ALARM_d <= 0;
        rRTC_COMP_d <= 0;

    end
    else begin

        WR_SEC_2d  <= WR_SEC_1d  ;
        WR_MIN_2d  <= WR_MIN_1d  ;
        WR_HOUR_2d <= WR_HOUR_1d ;
        WR_DAY_2d  <= WR_DAY_1d  ;
        WR_MON_2d  <= WR_MON_1d  ;
        WR_YEAR_2d <= WR_YEAR_1d ;
        WR_WEEK_2d <= WR_WEEK_1d ;

        WR_SEC_1d  <= WR_SEC_d  ;
        WR_MIN_1d  <= WR_MIN_d  ;
        WR_HOUR_1d <= WR_HOUR_d ;
        WR_DAY_1d  <= WR_DAY_d  ;
        WR_MON_1d  <= WR_MON_d  ;
        WR_YEAR_1d <= WR_YEAR_d ;
        WR_WEEK_1d <= WR_WEEK_d ;

        WR_SEC_d  <= WrSEC;
        WR_MIN_d  <= WrMIN;
        WR_HOUR_d <= WrHOUR;
        WR_DAY_d  <= WrDAY;
        WR_MON_d  <= WrMON;
        WR_YEAR_d <= WrYEAR;
        WR_WEEK_d <= WrWEEK;

        AlWR_SEC_d  <= AlWrSEC;
        AlWR_MIN_d  <= AlWrMIN;
        AlWR_HOUR_d <= AlWrHOUR;
        AlWR_DAY_d  <= AlWrDAY;
        AlWR_MON_d  <= AlWrMON;
        AlWR_YEAR_d <= AlWrYEAR;
        
        AlWR_SEC_1d <= AlWR_SEC_d ;
        AlWR_MIN_1d <= AlWR_MIN_d ;
        AlWR_HOUR_1d<= AlWR_HOUR_d;
        AlWR_DAY_1d <= AlWR_DAY_d ;
        AlWR_MON_1d <= AlWR_MON_d ;
        AlWR_YEAR_1d<= AlWR_YEAR_d;
        
        AlWR_SEC_2d <= AlWR_SEC_1d ;
        AlWR_MIN_2d <= AlWR_MIN_1d ;
        AlWR_HOUR_2d<= AlWR_HOUR_1d;
        AlWR_DAY_2d <= AlWR_DAY_1d ;
        AlWR_MON_2d <= AlWR_MON_1d ;
        AlWR_YEAR_2d<= AlWR_YEAR_1d;

//Register Setting value ////////
        rRTC_ENABLE_d <= rRTC_ENABLE;
        rSET_32_CNT_d <= rSET_32_CNT;
        rMODE_APM_d <= rMODE_APM;
        rEN_COMP_d <= rEN_COMP;
        rSTOP_RTC_d <= rSTOP_RTC;
        rCLEAR_d <= rCLEAR;
        rALARM_d <= rALARM;
        rPERIOD_d <= rPERIOD;
        rEN_INT_TIMER_d <= rEN_INT_TIMER;
        rEN_INT_ALARM_d <= rEN_INT_ALARM;
        rRTC_COMP_d <= rRTC_COMP;

//setting register
        RTC_ENABLE <= rRTC_ENABLE_d;
        SET_32_CNT <= rSET_32_CNT_d;
        MODE_APM <= rMODE_APM_d;
        EN_COMP <= rEN_COMP_d;
        STOP_RTC <= rSTOP_RTC_d;
        CLEAR <= rCLEAR_d;
        ALARM <= rALARM_d;
        PERIOD <= rPERIOD_d;
        EN_INT_TIMER <= rEN_INT_TIMER_d;
        EN_INT_ALARM <= rEN_INT_ALARM_d;
        RTC_COMP <= rRTC_COMP_d;

//Alarm value
        if(AlWR_SEC) begin
            AL_SEC0 <= rAL_SEC0;
            AL_SEC1 <= rAL_SEC1;
        end
        if(AlWR_MIN) begin
            AL_MIN0 <= rAL_MIN0;
            AL_MIN1 <= rAL_MIN1;
        end
        if(AlWR_HOUR) begin
            AL_HOUR0 <= rAL_HOUR0;
            AL_HOUR1 <= rAL_HOUR1;
            AL_PMAM <= rAL_PMAM;
        end
        if(AlWR_DAY) begin
            AL_DAY0 <= rAL_DAY0;
            AL_DAY1 <= rAL_DAY1;
        end
        if(AlWR_MON) begin
            AL_MON0 <= rAL_MON0;
            AL_MON1 <= rAL_MON1;
        end
        if(AlWR_YEAR) begin
            AL_YEAR0 <= rAL_YEAR0;
            AL_YEAR1 <= rAL_YEAR1;
        end
    end

end

//==================================================================
// APB interface
//__________________________________________________________________
// INTERFACE READ & WRITE
// register write 

always @(negedge PRESETn or posedge PCLK)	begin
	if(!PRESETn) begin
        //Adjust timer signal
        WrHOUR <= 0;
        WrMIN <= 0;
        WrSEC <= 0;
        WrDAY <= 0;
        WrMON <= 0;
        WrYEAR <= 0;
        WrWEEK <= 0;
        rCLEAR <= 1;
        rALARM <= 0;

        AlWrHOUR <= 0;
        AlWrMIN  <= 0;
        AlWrSEC  <= 0;
        AlWrDAY  <= 0;
        AlWrMON  <= 0;
        AlWrYEAR <= 0;

    end
    else begin

		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR8 )) begin
            WrSEC <= 1'b1;
        end
        else if(WR_SEC) begin
            WrSEC <= 1'b0;
        end
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR9 )) begin
            WrMIN <= 1'b1;
        end
        else if(WR_MIN) begin
            WrMIN <= 1'b0;
        end
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR10 )) begin
            WrHOUR <= 1'b1;
        end
        else if(WR_HOUR) begin
            WrHOUR <= 1'b0;
        end
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR11 )) begin
            WrDAY <= 1'b1;
        end
        else if(WR_DAY) begin
            WrDAY <= 1'b0;
        end
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR12 )) begin
            WrMON <= 1'b1;
        end
        else if(WR_MON) begin
            WrMON <= 1'b0;
        end
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR13 )) begin
            WrYEAR <= 1'b1;
        end
        else if(WR_YEAR) begin
            WrYEAR <= 1'b0;
        end
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR14 )) begin
            WrWEEK <= 1'b1;
        end
        else if(WR_WEEK) begin
            WrWEEK <= 1'b0;
        end

		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR1 )) begin
            rCLEAR <= PWDATA[7];
        end
        else if(!CLEAR) begin
            rCLEAR <= 1'b1;
        end

		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR1 )) begin
            rALARM <= PWDATA[6];
        end
        else if(ALARM) begin
            rALARM <= 1'b0;
        end

        //Alarm seconds
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR16)) begin
            AlWrSEC  <= 1;
        end
        else if(AlWR_SEC  ) begin
            AlWrSEC  <= 0;
        end

        //Alarm minute
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR17)) begin
            AlWrMIN  <= 1;
        end
        else if(AlWR_MIN  ) begin
            AlWrMIN  <= 0;
        end

        //Alarm hours
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR18)) begin
            AlWrHOUR <= 1;
        end
        else if(AlWR_HOUR ) begin
            AlWrHOUR <= 0;
        end

        //Alarm days
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR19)) begin
            AlWrDAY  <= 1;
        end
        else if(AlWR_DAY  ) begin
            AlWrDAY  <= 0;
        end

        //Alarm months
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR20)) begin
            AlWrMON  <= 1;
        end
        else if(AlWR_MON  ) begin
            AlWrMON  <= 0;
        end

        //Alarm years
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR21)) begin
            AlWrYEAR <= 1;
        end
        else if(AlWR_YEAR ) begin
            AlWrYEAR <= 0;
        end

    end
end

always @(negedge PRESETn or posedge PCLK)	begin
	if(!PRESETn) begin

        rRTC_ENABLE <= 0;
        rSET_32_CNT <= 0;
        rMODE_APM <= 0;
        rEN_COMP <= 0;
        rSTOP_RTC <= 0;


        rPERIOD <= 0;
        rEN_INT_TIMER <= 0;
        rEN_INT_ALARM <= 0;
        rRTC_COMP <= 0;

        rSET_SEC0 <= 0;
        rSET_SEC1 <= 0;
        
        rSET_MIN0 <= 0;
        rSET_MIN1 <= 0;
    
        rSET_HOUR0 <= 0;
        rSET_HOUR1 <= 0;
        rSET_PMAM <= 0;

        rSET_DAY0 <= 0;
        rSET_DAY1 <= 0;

        rSET_MON0 <= 0;
        rSET_MON1 <= 0;

        rSET_YEAR0 <= 0;
        rSET_YEAR1 <= 0;
        rSET_WEEK <= 0;

        rAL_SEC0 <= 0;
        rAL_SEC1 <= 0;

        rAL_MIN0 <= 0;
        rAL_MIN1 <= 0;
    
        rAL_HOUR0 <= 0;
        rAL_HOUR1 <= 0;
        rAL_PMAM <= 0;

        rAL_DAY0 <= 0;
        rAL_DAY1 <= 0;

        rAL_MON0 <= 0;
        rAL_MON1 <= 0;

        rAL_YEAR0 <= 0;
        rAL_YEAR1 <= 0;

        rSTOP_RTC <= 0;

    end
    else begin
		if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR0 )) begin
            rRTC_ENABLE <= PWDATA[31];
            rSET_32_CNT <= PWDATA[5];
            rMODE_APM <= PWDATA[3];
            rEN_COMP <= PWDATA[2];
            rSTOP_RTC <= PWDATA[0];

        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR2 )) begin
            rPERIOD <= PWDATA[1:0];
            rEN_INT_TIMER <= PWDATA[2];
            rEN_INT_ALARM <= PWDATA[3];
        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR3 )) begin
            rRTC_COMP <= PWDATA[15:0];
        end

		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR8 )) begin
            rSET_SEC0 <= PWDATA[3:0];
            rSET_SEC1 <= PWDATA[6:4];
        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR9 )) begin
            rSET_MIN0 <= PWDATA[3:0];
            rSET_MIN1 <= PWDATA[6:4];
        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR10 )) begin
            rSET_HOUR0 <= PWDATA[3:0];
            rSET_HOUR1 <= PWDATA[6:4];
            rSET_PMAM <= PWDATA[7];
        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR11 )) begin
            rSET_DAY0 <= PWDATA[3:0];
            rSET_DAY1 <= PWDATA[5:4];
        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR12 )) begin
            rSET_MON0 <= PWDATA[3:0];
            rSET_MON1 <= PWDATA[4];
        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR13 )) begin
            rSET_YEAR0 <= PWDATA[3:0];
            rSET_YEAR1 <= PWDATA[7:4];
        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR14 )) begin
            rSET_WEEK <= PWDATA[2:0];
        end
        
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR16 )) begin
            rAL_SEC0 <= PWDATA[3:0];
            rAL_SEC1 <= PWDATA[6:4];
        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR17 )) begin
            rAL_MIN0 <= PWDATA[3:0];
            rAL_MIN1 <= PWDATA[6:4];
        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR18 )) begin
            rAL_HOUR0 <= PWDATA[3:0];
            rAL_HOUR1 <= PWDATA[6:4];
            rAL_PMAM <= PWDATA[7];
        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR19 )) begin
            rAL_DAY0 <= PWDATA[3:0];
            rAL_DAY1 <= PWDATA[5:4];
        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR20 )) begin
            rAL_MON0 <= PWDATA[3:0];
            rAL_MON1 <= PWDATA[4];
        end
		else if(WRITEOP && (PADDR[9:2] == `RTCAPBADDR21 )) begin
            rAL_YEAR0 <= PWDATA[3:0];
            rAL_YEAR1 <= PWDATA[7:4];
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

        rRTC_ENABLE or

        rSET_32_CNT or
        rMODE_APM or
        rEN_COMP or
        rSTOP_RTC or
        rCLEAR or
        rTimeAlarm2APB_d or
        rDayAlarm2APB_d or
        rHourAlarm2APB_d or

        rMinAlarm2APB_d or
        rHourAlarm2APB_d or
        rDayAlarm2APB_d or
        rRUN2APB_d or rSecAlarm2APB_d or
        rBUSY2APB_d or

        rINT_ALARM_d or
        rINT_TIMER_d or
        rPERIOD or
        rRTC_COMP or

        rRD_SEC0_d or
        rRD_SEC1_d or
        rRD_MIN0_d or
        rRD_MIN1_d or
        rRD_HOUR0_d or
        rRD_HOUR1_d or
        rRD_PMAM_d or
        rRD_DAY0_d or
        rRD_DAY1_d or
        rRD_MON0_d or
        rRD_MON1_d or
        rRD_YEAR0_d or
        rRD_YEAR1_d or
        rRD_WEEK_d or

        rAL_SEC0 or
        rAL_SEC1 or
        rAL_MIN0 or
        rAL_MIN1 or
        rAL_HOUR0 or
        rAL_HOUR1 or
        rAL_PMAM or
        rAL_DAY0 or
        rAL_DAY1 or
        rAL_MON0 or
        rAL_MON1 or
        rAL_YEAR0 or
        rAL_YEAR1 


        )
begin : p_RdRegMuxComb
    
    case (PADDR[9:2]) 
    //synopsys parallel_case
        `RTCAPBADDR0: ReadRegs  = {rRTC_ENABLE, 25'd0, rSET_32_CNT, 1'b0,
                                   rMODE_APM, rEN_COMP, 1'b0, rSTOP_RTC};
        `RTCAPBADDR1: ReadRegs  = {24'd0, rCLEAR, rTimeAlarm2APB_d , rDayAlarm2APB_d,
                                   rHourAlarm2APB_d, rMinAlarm2APB_d, 
                                   rSecAlarm2APB_d , rRUN2APB_d, rBUSY2APB_d }; 
        `RTCAPBADDR2: ReadRegs  = {38'd0, rINT_ALARM_d , rINT_TIMER_d, rPERIOD};

        `RTCAPBADDR3: ReadRegs  = {16'd0, rRTC_COMP};

        `RTCAPBADDR8:  ReadRegs  = {25'd0, rRD_SEC1_d, rRD_SEC0_d};
        `RTCAPBADDR9:  ReadRegs  = {25'd0, rRD_MIN1_d, rRD_MIN0_d};
        `RTCAPBADDR10: ReadRegs  = {24'd0, rRD_PMAM_d, rRD_HOUR1_d, rRD_HOUR0_d };
        `RTCAPBADDR11: ReadRegs  = {26'd0, rRD_DAY1_d, rRD_DAY0_d  };
        `RTCAPBADDR12: ReadRegs  = {27'd0, rRD_MON1_d, rRD_MON0_d  };
        `RTCAPBADDR13: ReadRegs  = {24'd0, rRD_YEAR1_d,rRD_YEAR0_d };
        `RTCAPBADDR14: ReadRegs  = {29'd0, rRD_WEEK_d  };

        `RTCAPBADDR16: ReadRegs  = {25'd0, rAL_SEC1, rAL_SEC0};
        `RTCAPBADDR17: ReadRegs  = {25'd0, rAL_MIN1, rAL_MIN0};
        `RTCAPBADDR18: ReadRegs  = {24'd0, rAL_PMAM, rAL_HOUR1, rAL_HOUR0 };
        `RTCAPBADDR19: ReadRegs  = {26'd0, rAL_DAY1, rAL_DAY0  };
        `RTCAPBADDR20: ReadRegs  = {27'd0, rAL_MON1, rAL_MON0  };
        `RTCAPBADDR21: ReadRegs  = {24'd0, rAL_YEAR1,rAL_YEAR0 };
        default:       ReadRegs  = 32'd0;
    endcase

end

always @ (posedge PCLK or negedge PRESETn)
begin : p_PrdataSeq
    if ((!PRESETn))     iPRDATA <= {32{1'b0}};
    else if (ReadRegEn) iPRDATA <= nextPRDATA;
end

endmodule
