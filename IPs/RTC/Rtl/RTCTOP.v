// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : RTCTOP.v
// File Revision       : 0.1
// -------------------------------------------------------------------
// Purpose            : This module is RTC top
// ===================================================================

`timescale 1ns/10ps

module RTCTOP
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

    INT_TIMER,
    INT_ALARM,

    IntTimer_32K,
    IntAlarm_32K,

//input
    CLK        // 32khz clock input
);

input   PCLK;
input   PRESETn;

input	[9:2]	PADDR;
input	[31:0]	PWDATA;
input	PSEL;
input	PWRITE;
input	PENABLE;

output	[31:0]	PRDATA;
output  INT_TIMER;
output  INT_ALARM;

output  IntTimer_32K;
output  IntAlarm_32K;

input   CLK;

//Wire 
wire  RTC_ENABLE;
wire  [15:0]    RTC_COMP;
wire  SET_32_CNT;
wire  MODE_APM;
wire  EN_COMP;
wire  STOP_RTC;
wire  CLEAR;
wire  ALARM;

wire  EN_INT_TIMER;
wire  EN_INT_ALARM;
    
wire  [1:0]   PERIOD;

//Setting timer
wire  [3:0]   SET_SEC0;
wire  [2:0]   SET_SEC1;
wire  [3:0]   SET_MIN0;
wire  [2:0]   SET_MIN1;
wire  [3:0]   SET_HOUR0;
wire  [2:0]   SET_HOUR1;
wire  SET_PMAM;

wire  [3:0]   SET_DAY0;
wire  [1:0]   SET_DAY1;
wire  [3:0]   SET_MON0;
wire  SET_MON1;

wire  [3:0]   SET_YEAR0;
wire  [3:0]   SET_YEAR1;
wire  [2:0]   SET_WEEK;

//Alarm value
wire  [3:0]   AL_SEC0;
wire  [2:0]   AL_SEC1;
wire  [3:0]   AL_MIN0;
wire  [2:0]   AL_MIN1;
wire  [3:0]   AL_HOUR0;
wire  [2:0]   AL_HOUR1;
wire  AL_PMAM;

wire  [3:0]   AL_DAY0;
wire  [1:0]   AL_DAY1;
wire  [3:0]   AL_MON0;
wire  AL_MON1;
wire  [3:0]   AL_YEAR0;
wire  [3:0]   AL_YEAR1;

wire  WR_SEC;
wire  WR_MIN;
wire  WR_HOUR;
wire  WR_DAY;
wire  WR_MON;
wire  WR_YEAR;
wire  WR_WEEK;

//Read value
wire  [3:0]   RD_SEC0;
wire  [2:0]   RD_SEC1;
wire  [3:0]   RD_MIN0;
wire  [2:0]   RD_MIN1;
wire  [3:0]   RD_HOUR0;
wire  [2:0]   RD_HOUR1;
wire  RD_PMAM;

wire  [3:0]   RD_DAY0;
wire  [1:0]   RD_DAY1;
wire  [3:0]   RD_MON0;
wire  RD_MON1;

wire  [3:0]   RD_YEAR0;
wire  [3:0]   RD_YEAR1;
wire  [2:0]   RD_WEEK;

wire  TimeAlarm2APB;
wire  SecAlarm2APB;
wire  MinAlarm2APB;
wire  HourAlarm2APB;
wire  DayAlarm2APB;
wire  RUN2APB;
wire  BUSY2APB;

wire  IntTimer2APB;
wire  IntAlarm2APB;


RTCAPBinterface  RTCAPBinterface
(

//  APB bus
    .PCLK     (PCLK     ),
    .PRESETn  (PRESETn  ),

    .PENABLE  (PENABLE  ), 
    .PSEL     (PSEL     ), 
    .PWRITE   (PWRITE   ), 
    .PADDR    (PADDR    ),  //[9:2]  used
    .PWDATA   (PWDATA   ),  //[31:0] used
    .PRDATA   (PRDATA   ),  //[31:0] used

    .IntTimer(INT_TIMER),
    .IntAlarm(INT_ALARM),


    .IntTimer_32K(IntTimer_32K),
    .IntAlarm_32K(IntAlarm_32K),
//input
    .CLK(CLK),       // 32khz clock input

//Register Setting
    .RTC_ENABLE(RTC_ENABLE),
    .SET_32_CNT(SET_32_CNT),
    .MODE_APM(MODE_APM),
    .EN_COMP(EN_COMP),
    .STOP_RTC(STOP_RTC),

    .CLEAR(CLEAR),
    .ALARM(ALARM),
    
    .PERIOD(PERIOD),
    .EN_INT_TIMER(EN_INT_TIMER),
    .EN_INT_ALARM(EN_INT_ALARM),
    .RTC_COMP(RTC_COMP),

    .SET_SEC0(SET_SEC0),
    .SET_SEC1(SET_SEC1),
    .SET_MIN0(SET_MIN0),
    .SET_MIN1(SET_MIN1),
    .SET_HOUR0(SET_HOUR0),
    .SET_HOUR1(SET_HOUR1),
    .SET_PMAM(SET_PMAM),
    .SET_DAY0(SET_DAY0),
    .SET_DAY1(SET_DAY1),
    .SET_MON0(SET_MON0),
    .SET_MON1(SET_MON1),
    .SET_YEAR0(SET_YEAR0),
    .SET_YEAR1(SET_YEAR1),
    .SET_WEEK(SET_WEEK),

    .AL_SEC0(AL_SEC0),
    .AL_SEC1(AL_SEC1),
    .AL_MIN0(AL_MIN0),
    .AL_MIN1(AL_MIN1),
    .AL_HOUR0(AL_HOUR0),
    .AL_HOUR1(AL_HOUR1),
    .AL_PMAM(AL_PMAM),
    .AL_DAY0(AL_DAY0),
    .AL_DAY1(AL_DAY1),
    .AL_MON0(AL_MON0),
    .AL_MON1(AL_MON1),
    .AL_YEAR0(AL_YEAR0),
    .AL_YEAR1(AL_YEAR1),

    .WR_SEC(WR_SEC),
    .WR_MIN(WR_MIN),
    .WR_HOUR(WR_HOUR),
    .WR_DAY(WR_DAY),
    .WR_MON(WR_MON),
    .WR_YEAR(WR_YEAR),
    .WR_WEEK(WR_WEEK),

//Rd data
    .RD_SEC0(RD_SEC0),
    .RD_SEC1(RD_SEC1),
    .RD_MIN0(RD_MIN0),
    .RD_MIN1(RD_MIN1),
    .RD_HOUR0(RD_HOUR0),
    .RD_HOUR1(RD_HOUR1),
    .RD_PMAM(RD_PMAM),
    .RD_DAY0(RD_DAY0),
    .RD_DAY1(RD_DAY1),
    .RD_MON0(RD_MON0),
    .RD_MON1(RD_MON1),
    .RD_YEAR0(RD_YEAR0),
    .RD_YEAR1(RD_YEAR1),
    .RD_WEEK(RD_WEEK),

    .TimeAlarm2APB(TimeAlarm2APB),
    .SecAlarm2APB(SecAlarm2APB),
    .MinAlarm2APB(MinAlarm2APB),
    .HourAlarm2APB(HourAlarm2APB),
    .DayAlarm2APB(DayAlarm2APB),
    .RUN2APB(RUN2APB),
    .BUSY2APB(BUSY2APB),

    .IntTimer2APB(IntTimer2APB),
    .IntAlarm2APB(IntAlarm2APB)
);

RTCCore  RTCCore
(

//input
    .CLK(CLK),       // 32khz clock input
    .RESETn(PRESETn),

//Register Setting
    .RTC_ENABLE(RTC_ENABLE),
    .SET_32_CNT(SET_32_CNT),
    .MODE_APM(MODE_APM),
    .EN_COMP(EN_COMP),
    .STOP_RTC(STOP_RTC),

    .CLEAR(CLEAR),
    .ALARM(ALARM),
    
    .PERIOD(PERIOD),
    .EN_INT_TIMER(EN_INT_TIMER),
    .EN_INT_ALARM(EN_INT_ALARM),
    .RTC_COMP(RTC_COMP),

    .SET_SEC0(SET_SEC0),
    .SET_SEC1(SET_SEC1),
    .SET_MIN0(SET_MIN0),
    .SET_MIN1(SET_MIN1),
    .SET_HOUR0(SET_HOUR0),
    .SET_HOUR1(SET_HOUR1),
    .SET_PMAM(SET_PMAM),
    .SET_DAY0(SET_DAY0),
    .SET_DAY1(SET_DAY1),
    .SET_MON0(SET_MON0),
    .SET_MON1(SET_MON1),
    .SET_YEAR0(SET_YEAR0),
    .SET_YEAR1(SET_YEAR1),
    .SET_WEEK(SET_WEEK),

    .AL_SEC0(AL_SEC0),
    .AL_SEC1(AL_SEC1),
    .AL_MIN0(AL_MIN0),
    .AL_MIN1(AL_MIN1),
    .AL_HOUR0(AL_HOUR0),
    .AL_HOUR1(AL_HOUR1),
    .AL_PMAM(AL_PMAM),
    .AL_DAY0(AL_DAY0),
    .AL_DAY1(AL_DAY1),
    .AL_MON0(AL_MON0),
    .AL_MON1(AL_MON1),
    .AL_YEAR0(AL_YEAR0),
    .AL_YEAR1(AL_YEAR1),

    .WR_SEC(WR_SEC),
    .WR_MIN(WR_MIN),
    .WR_HOUR(WR_HOUR),
    .WR_DAY(WR_DAY),
    .WR_MON(WR_MON),
    .WR_YEAR(WR_YEAR),
    .WR_WEEK(WR_WEEK),

//Rd data
    .RD_SEC0(RD_SEC0),
    .RD_SEC1(RD_SEC1),
    .RD_MIN0(RD_MIN0),
    .RD_MIN1(RD_MIN1),
    .RD_HOUR0(RD_HOUR0),
    .RD_HOUR1(RD_HOUR1),
    .RD_PMAM(RD_PMAM),
    .RD_DAY0(RD_DAY0),
    .RD_DAY1(RD_DAY1),
    .RD_MON0(RD_MON0),
    .RD_MON1(RD_MON1),
    .RD_YEAR0(RD_YEAR0),
    .RD_YEAR1(RD_YEAR1),
    .RD_WEEK(RD_WEEK),

    .TimeAlarm2APB(TimeAlarm2APB),
    .SecAlarm2APB(SecAlarm2APB),
    .MinAlarm2APB(MinAlarm2APB),
    .HourAlarm2APB(HourAlarm2APB),
    .DayAlarm2APB(DayAlarm2APB),
    .RUN2APB(RUN2APB),
    .BUSY2APB(BUSY2APB),

    .IntTimer2APB(IntTimer2APB),
    .IntAlarm2APB(IntAlarm2APB)
);


endmodule
