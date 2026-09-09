// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : RTCCore.v
// File Revision       : 0.1
// -------------------------------------------------------------------
// Purpose            : This module is RTC Core block
// ===================================================================

`timescale 1ns/10ps

module RTCCore(

//input
    CLK,       // 32khz clock input
    RESETn,

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

//==================================================================
// Input & output signal
//__________________________________________________________________
input   CLK; // 32khz clock
input   RESETn;

//Register Setting value ////////
input  RTC_ENABLE;
input  SET_32_CNT;
input  MODE_APM;
input  EN_COMP;
input  STOP_RTC;
input  CLEAR;
input  ALARM;
    
input  [1:0]   PERIOD;
input  EN_INT_TIMER;
input  EN_INT_ALARM;
input  [15:0]  RTC_COMP;

//Setting timer
input  [3:0]   SET_SEC0;
input  [2:0]   SET_SEC1;
input  [3:0]   SET_MIN0;
input  [2:0]   SET_MIN1;
input  [3:0]   SET_HOUR0;
input  [2:0]   SET_HOUR1;
input  SET_PMAM;
input  [3:0]   SET_DAY0;
input  [1:0]   SET_DAY1;
input  [3:0]   SET_MON0;
input  SET_MON1;
input  [3:0]   SET_YEAR0;
input  [3:0]   SET_YEAR1;
input  [2:0]   SET_WEEK;

//Alarm value
input  [3:0]   AL_SEC0;
input  [2:0]   AL_SEC1;
input  [3:0]   AL_MIN0;
input  [2:0]   AL_MIN1;
input  [3:0]   AL_HOUR0;
input  [2:0]   AL_HOUR1;
input  AL_PMAM;
input  [3:0]   AL_DAY0;
input  [1:0]   AL_DAY1;
input  [3:0]   AL_MON0;
input  AL_MON1;
input  [3:0]   AL_YEAR0;
input  [3:0]   AL_YEAR1;

input  WR_SEC;
input  WR_MIN;
input  WR_HOUR;
input  WR_DAY;
input  WR_MON;
input  WR_YEAR;
input  WR_WEEK;

//Read value
output  [3:0]   RD_SEC0;
output  [2:0]   RD_SEC1;
output  [3:0]   RD_MIN0;
output  [2:0]   RD_MIN1;
output  [3:0]   RD_HOUR0;
output  [2:0]   RD_HOUR1;
output  RD_PMAM;
output  [3:0]   RD_DAY0;
output  [1:0]   RD_DAY1;
output  [3:0]   RD_MON0;
output  RD_MON1;
output  [3:0]   RD_YEAR0;
output  [3:0]   RD_YEAR1;
output  [2:0]   RD_WEEK;

output  TimeAlarm2APB;
output  SecAlarm2APB;
output  MinAlarm2APB;
output  HourAlarm2APB;
output  DayAlarm2APB;
output  RUN2APB;
output  BUSY2APB;

output  IntTimer2APB;
output  IntAlarm2APB;


//==================================================================
// Wire & Reg
//__________________________________________________________________

reg [14:0] ClkCnt;
reg [3:0]  SecCnt0;
reg [3:0]  MinCnt0;
reg [3:0]  HourCnt0;
reg [2:0]  SecCnt1;
reg [2:0]  MinCnt1;
reg [2:0]  HourCnt1;
reg HourCnt2;

reg [3:0]  DayCnt0;
reg [2:0]  WeekCnt;
reg [3:0]  MonCnt0;
reg [3:0]  YearCnt0;
reg [1:0]  DayCnt1;
reg MonCnt1;
reg [3:0]  YearCnt1;
reg        ZeroFlag;

reg  SecUp0;
wire DayUp0;
reg  BUSY2APB;

reg AlarmSec;
reg AlarmMin;
reg AlarmHour;
reg AlarmDay;

wire AlSec = ((AL_SEC0 == SecCnt0) && (AL_SEC1 == SecCnt1))     ? 1'b1 : 1'b0;
wire AlMin = ((AL_MIN0 == MinCnt0) && (AL_MIN1 == MinCnt1))     ? 1'b1 : 1'b0;
wire AlHour= ((AL_HOUR0 == HourCnt0) && (AL_HOUR1 == HourCnt1)) ? 1'b1 : 1'b0;
wire AlPMAM= (AL_PMAM == HourCnt2) ? 1'b1 : 1'b0;
wire AlDay = ((AL_DAY0  == DayCnt0)  && (AL_DAY1 == DayCnt1))   ? 1'b1 : 1'b0;
wire AlMON = ((AL_MON0  == MonCnt0)  && (AL_MON1 == MonCnt1))   ? 1'b1 : 1'b0;
wire AlYear= ((AL_YEAR0 == YearCnt0) && (AL_YEAR1 == YearCnt1))   ? 1'b1 : 1'b0;

wire AlarmSig = AlSec & AlMin & AlHour & AlPMAM & AlDay & AlMON & AlYear;

reg  [3:0] MaxHour0Num; 
wire [3:0] MaxHour1Num = (MODE_APM) ? 4'd1 : 4'd2; 
wire MinUp0T = ((SecCnt1 == 4'd5) && (SecCnt0 == 4'd9)) ? SecUp0 : 1'b0;
wire MinUp1T = (MinCnt0 == 4'd9) ? MinUp0T : 1'b0;
wire HourUp0T = ((MinCnt1  == 3'd5) && (MinCnt0  == 4'd9)) ? MinUp1T : 1'b0;
wire HourUp1T = (HourCnt0 == MaxHour0Num)                  ? HourUp0T : 1'b0;

//==================================================================
// Status
//__________________________________________________________________

assign RUN2APB = STOP_RTC & RTC_ENABLE;

//==================================================================
// Busy signal generation
//__________________________________________________________________

always @(posedge CLK or negedge RESETn) begin
    
    if(!RESETn) begin
        BUSY2APB <= 1'b0;
    end
    else begin
        BUSY2APB <= SecUp0;
    end

end

//==================================================================
// Alarm signal generation
//__________________________________________________________________

reg  IntTimer2APB;
reg  IntAlarm2APB;

assign  SecAlarm2APB  = (EN_INT_TIMER) ? AlarmSec  : 1'b0;
assign  MinAlarm2APB  = (EN_INT_TIMER) ? AlarmMin  : 1'b0;
assign  HourAlarm2APB = (EN_INT_TIMER) ? AlarmHour : 1'b0;
assign  DayAlarm2APB  = (EN_INT_TIMER) ? AlarmDay  : 1'b0;


always @(EN_INT_TIMER or PERIOD or 
         AlarmSec or
         AlarmMin or 
         AlarmHour or
         AlarmDay ) begin

        case({EN_INT_TIMER, PERIOD}) 
            3'b100: IntTimer2APB = AlarmSec;
            3'b101: IntTimer2APB = AlarmMin;
            3'b110: IntTimer2APB = AlarmHour;
            3'b111: IntTimer2APB = AlarmDay;
            default:IntTimer2APB = 1'b0;
        endcase
end

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        AlarmSec <= 1'b0;
        AlarmMin <= 1'b0;
        AlarmHour<= 1'b0;
        AlarmDay <= 1'b0;
    end
    else begin
        AlarmSec <= SecUp0;
        AlarmMin <= MinUp0T;
        AlarmHour<= HourUp0T;
        AlarmDay <= DayUp0;
    end
end

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        IntAlarm2APB <= 1'b0;
    end
    else begin
        if(AlarmSig)       IntAlarm2APB <= 1'b1;
        //else if(ALARM)     IntAlarm2APB <= 1'b0; //clear interrupt
        else if(!AlarmSig) IntAlarm2APB <= 1'b0; //clear interrupt
    end
end

//==================================================================
// 32Khz Clock counter 
//__________________________________________________________________

wire [14:0] MaxCnt    = 15'h7fff;
wire [14:0] MaxCnt1dn = 15'h7ffe;
wire [14:0] CompDATA  = RTC_COMP[14:0];
wire [14:0] SetValue  = (EN_COMP) ? (CompDATA) : 16'd0;

wire        Hup = ((SecCnt0 == 4'd9) && (SecCnt1 == 3'd5) &&
                   (MinCnt0 == 4'd9) && (MinCnt1 == 3'd5)) ? 1'b1 : 1'b0;


reg UpFlag;

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        SecUp0 <= 1'b0;
        UpFlag <= 1'b0;
    end
    else if(STOP_RTC && (ClkCnt == MaxCnt1dn) && !Hup) begin
        if(UpFlag) SecUp0 <= 1'b0;
        else       SecUp0 <= 1'b1;
        UpFlag <= 1'b0;
    end
    else if(STOP_RTC && (ClkCnt == MaxCnt1dn) && Hup && !UpFlag) begin
        SecUp0 <= 1'b1;
        //Applay to UpFlag when negative value is setted in RTC_COMP register
        // 7ffe --> -3 --> -2 --> -1 --> 0
        //          ________________
        // ________/                \__________ :: upflag
        //
        if(CompDATA[14]) UpFlag <= 1'b1;
        else             UpFlag <= 1'b0;
    end
    else if(STOP_RTC && (ClkCnt == MaxCnt1dn) && Hup && UpFlag ) begin
        SecUp0 <= 1'b0;
        UpFlag <= 1'b0;
    end
    else begin
        SecUp0 <= 1'b0;
    end
end

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        ClkCnt <= 15'd0;
        ZeroFlag <= 1'b0;
    end
    else if(!RTC_ENABLE) begin
        ClkCnt <= 15'd0;
    end
    else if(!CLEAR) begin
        ClkCnt <= 15'd0;
    end
    else if(SET_32_CNT) begin
        ClkCnt <= RTC_COMP;
    end
    // Normal action block
    else if(STOP_RTC && (ClkCnt == MaxCnt) && !Hup) begin
        ClkCnt   <= 15'd0;
        if(ZeroFlag) begin
                     ZeroFlag <= 1'b0;
        end
    end
    //RET_COMP register value setting if EN_COMP is "HIGH"
    //RT_COMP action block -->  Hup == 'HIGH'
    else if((ClkCnt == MaxCnt ) && Hup && !ZeroFlag &&
            STOP_RTC  
           ) begin
        ClkCnt   <= SetValue;
        ZeroFlag <= 1'b1;
    end
    else if(STOP_RTC) begin
        ClkCnt   <= ClkCnt + 15'd1;
    end
    else begin
        ClkCnt   <= ClkCnt;
    end

end

//==================================================================
// Secounds Clock counter 
//__________________________________________________________________

reg SecUp1;
always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        SecCnt0 <= 0;
        SecUp1  <= 0;
    end
    else begin
        if(!CLEAR)  begin
            SecCnt0 <= 0;
            SecUp1  <= 0;
        end
        else if(SecUp0 && WR_SEC)  begin
            SecCnt0 <= SET_SEC0;
        end
        else if(SecUp0 && (SecCnt0 == 4'd9))  begin
            SecCnt0 <= 6'd0;
            SecUp1  <= 1;
        end
        else if(SecUp0)  begin
            SecCnt0 <= SecCnt0 + 6'd1;
        end
        else if(WR_SEC)  begin
            SecCnt0 <= SET_SEC0;
        end
        else begin
            SecCnt0 <= SecCnt0;
            SecUp1  <= 0;
        end
    end
end


wire SecUp1T = (SecCnt0 == 4'd9) ? SecUp0 : 1'b0;
always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        SecCnt1 <= 0;
    end
    else begin
        if(!CLEAR)  begin
            SecCnt1 <= 0;
        end
        else if(SecUp1T && WR_SEC)  begin
            SecCnt1 <= SET_SEC1;
        end
        else if(SecUp1T && (SecCnt1 == 3'd5))  begin
            SecCnt1 <= 6'd0;
        end
        else if(SecUp1T)  begin
            SecCnt1 <= SecCnt1 + 6'd1;
        end
        else if(WR_SEC)  begin
            SecCnt1 <= SET_SEC1;
        end
        else begin
            SecCnt1 <= SecCnt1;
        end
    end
end


//==================================================================
// Minutes Clock counter 
//__________________________________________________________________

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        MinCnt0 <= 0;
    end
    else begin
        if(!CLEAR)  begin
            MinCnt0 <= 0;
        end
        else if(MinUp0T && WR_MIN)  begin
            MinCnt0 <= SET_MIN0;
        end
        else if(MinUp0T && (MinCnt0 == 4'd9))  begin
            MinCnt0 <= 6'd0;
        end
        else if(MinUp0T)  begin
            MinCnt0 <= MinCnt0 + 6'd1;
        end
        else if(WR_MIN)  begin
            MinCnt0 <= SET_MIN0;
        end
        else begin
            MinCnt0 <= MinCnt0;
        end
    end
end

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        MinCnt1 <= 0;
    end
    else begin
        if(!CLEAR)  begin
            MinCnt1 <= 0;
        end
        else if(MinUp1T && WR_MIN)  begin
            MinCnt1 <= SET_MIN1;
        end
        else if(MinUp1T && (MinCnt1 == 3'd5))  begin
            MinCnt1 <= 6'd0;
        end
        else if(MinUp1T)  begin
            MinCnt1 <= MinCnt1 + 6'd1;
        end
        else if(WR_MIN)  begin
            MinCnt1 <= SET_MIN1;
        end
        else begin
            MinCnt1 <= MinCnt1;
        end
    end
end

//==================================================================
// Hour Clock counter 
//__________________________________________________________________

always @( MODE_APM or HourCnt1) begin

    case({MODE_APM, HourCnt1}) 

        4'b0000: MaxHour0Num = 4'd9; // hourcnt1 == 0
        4'b1000: MaxHour0Num = 4'd9;
        
        4'b0001: MaxHour0Num = 4'd9; // hourcnt1 == 1   12 --> 0 
        4'b1001: MaxHour0Num = 4'd2;

        4'b0010: MaxHour0Num = 4'd3; // hourcnt1 == 2   24 --> 0
        4'b1010: MaxHour0Num = 4'd3;

        default: MaxHour0Num = 4'd0;
    endcase
end


always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        HourCnt0 <= 0;
    end
    else begin
        if(!CLEAR)  begin
            HourCnt0 <= 0;
        end
        else if(HourUp0T && WR_HOUR)  begin
            HourCnt0 <= SET_HOUR0;
        end
        else if(HourUp0T && (HourCnt0 == MaxHour0Num))  begin
            if(MODE_APM && (HourCnt0 == 4'd9)) HourCnt0 <= 3'd0; //12hour mode
            else if(MODE_APM) HourCnt0 <= 3'd1; //12hour mode
            else              HourCnt0 <= 3'd0; //24hour mode
        end
        else if(HourUp0T)  begin
            HourCnt0 <= HourCnt0 + 6'd1;
        end
        else if(WR_HOUR)  begin
            HourCnt0 <= SET_HOUR0;
        end
        else if((HourCnt0 == 0) && (HourCnt1 == 0) && !HourUp1T && 
                 MODE_APM // 12hour mode
               )  begin
            HourCnt0 <= 3'd1;
        end
        else begin
            HourCnt0 <= HourCnt0;
        end
    end
end

wire AmPmUpT0 = AmPmUpdate(HourUp0T, HourCnt0, HourCnt1);

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        HourCnt1 <= 0;
    end
    else begin
        if(!CLEAR)  begin
            HourCnt1 <= 0;
        end
        else if(HourUp1T && WR_HOUR)  begin
            HourCnt1 <= SET_HOUR1;
        end
        else if(HourUp1T && (HourCnt1 == MaxHour1Num))  begin
            HourCnt1 <= 3'd0;
        end
        else if(HourUp1T)  begin
            HourCnt1 <= HourCnt1 + 3'd1;
        end
        else if(WR_HOUR)  begin
            HourCnt1 <= SET_HOUR1;
        end
        else begin
            HourCnt1 <= HourCnt1;
        end
    end
end

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        HourCnt2 <= 1'b0;
    end
    else begin
        if(!CLEAR)  begin
            HourCnt2 <= 0;
        end
        else if(AmPmUpT0 && WR_HOUR)  begin
            HourCnt2 <= SET_PMAM;
        end
        else if(WR_HOUR)  begin
            HourCnt2 <= SET_PMAM;
        end
        else if(AmPmUpT0 & MODE_APM) begin
            HourCnt2 <= ~HourCnt2;
        end
        else if(AmPmUpT0 & !MODE_APM) begin
            HourCnt2 <= ~HourCnt2;
        end
    end
end

reg HourCnt2_d;
assign  DayUp0 = HourCnt2 & AmPmUpT0;

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        HourCnt2_d <= 1'b0;
    end 
    else begin
        HourCnt2_d <= HourCnt2;
    end
end


//==================================================================
// Day Clock counter 
//__________________________________________________________________

wire EvenOddMonth  =  (MonCnt0[0])            ? 1'b1 : 1'b0; // 1--> 31 0--> 30
wire EvenOddMonthT =  ((MonCnt0>7) | MonCnt1) ? ~EvenOddMonth :EvenOddMonth; 
wire LeapMonth    = ((MonCnt0  == 4'd2) && (!MonCnt1) && 
                     (YearCnt0[1:0] == 2'd0)) 
                    ? 1'b1 : 1'b0; 
wire FebMonth     = ((MonCnt0  == 4'd2) && (!MonCnt1)) ? 1'b1 : 1'b0;

wire [3:0] MaxDay0Num = MaxDay0(EvenOddMonthT, LeapMonth, DayCnt1, FebMonth); 
wire [1:0] MaxDay1Num = (FebMonth) ? 2'd2 : 2'd3; 


wire DayUp1T = (DayCnt0 == MaxDay0Num) ? DayUp0 : 1'b0;
always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        DayCnt0 <= 0;
    end
    else begin
        if(!CLEAR)  begin
            DayCnt0 <= 0;
        end
        else if(DayUp0 && WR_DAY)  begin
            DayCnt0 <= SET_DAY0;
        end
        else if(DayUp0 && (DayCnt0 == MaxDay0Num))  begin
            if(DayCnt0 == 4'd9) DayCnt0 <= 4'd0; 
            else                DayCnt0 <= 4'd1;
        end
        else if(DayUp0)  begin
            DayCnt0 <= DayCnt0 + 4'd1;
        end
        else if(WR_DAY)  begin
            DayCnt0 <= SET_DAY0;
        end
        else if((DayCnt0 == 0) && (DayCnt1 == 0) &&
                (!DayUp1T)
                )  begin
            DayCnt0 <= 1;
        end
        else begin
            DayCnt0 <= DayCnt0;
        end
    end
end

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        DayCnt1 <= 0;
    end
    else begin

        if (!CLEAR) begin
            DayCnt1 <= 4'd0;
        end
        else if(DayUp1T && WR_DAY)  begin
            DayCnt1 <= SET_DAY1;
        end
        else if(DayUp1T && (DayCnt1 == MaxDay1Num))  begin
            DayCnt1 <= 4'd0;
        end
        else if(DayUp1T)  begin
            DayCnt1 <= DayCnt1 + 4'd1;
        end
        else if(WR_DAY)  begin
            DayCnt1 <= SET_DAY1;
        end
        else begin
            DayCnt1 <= DayCnt1;
        end
    end
end

//==================================================================
// Week Clock counter 
//__________________________________________________________________

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        WeekCnt <= 0;
    end
    else begin
        if(!CLEAR)  begin
            WeekCnt <= 0;
        end
        else if(DayUp0 && WR_DAY)  begin
            WeekCnt <= SET_WEEK;
        end
        else if(DayUp0 && (WeekCnt == 3'd6))  begin
            WeekCnt <= 3'd0;
        end
        else if(DayUp0)  begin
            WeekCnt <= WeekCnt + 3'd1;
        end
        else if(WR_DAY)  begin
            WeekCnt <= SET_WEEK;
        end
        else begin
            WeekCnt <= WeekCnt;
        end
    end
end


//==================================================================
// Months Clock counter 
//__________________________________________________________________

wire [3:0] MaxMon0Num = (MonCnt1)  ? 4'd2 : 4'd9; 

wire    MonUp0T = (DayCnt1 == MaxDay1Num) ? DayUp1T : 1'b0;
wire    MonUp1T = (MonCnt0 == MaxMon0Num) ? MonUp0T : 1'b0;

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        MonCnt0 <= 0;
    end
    else begin
        if((MonCnt0 == 0) && (MonCnt1 == 0))  begin
            MonCnt0 <= 1;
        end
        else if(!CLEAR)  begin
            MonCnt0 <= 0;
        end
        else if(MonUp0T && WR_MON)  begin
            MonCnt0 <= SET_MON0;
        end
        else if(MonUp0T && (MonCnt0 == MaxMon0Num))  begin
            MonCnt0 <= 4'd1;
        end
        else if(MonUp0T)  begin
            MonCnt0 <= MonCnt0 + 4'd1;
        end
        else if(WR_MON)  begin
            MonCnt0 <= SET_MON0;
        end
        else begin
            MonCnt0 <= MonCnt0;
        end
    end
end

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        MonCnt1 <= 0;
    end
    else begin

        if (!CLEAR) begin
            MonCnt1 <= 1'b0;
        end
        else if(MonUp1T && WR_MON)  begin
            MonCnt1 <= SET_MON1;
        end
        else if(MonUp1T && (MonCnt1 == 1'b1))  begin
            MonCnt1 <= 1'd0;
        end
        else if(MonUp1T)  begin
            MonCnt1 <= 1'd1;
        end
        else if(WR_MON)  begin
            MonCnt1 <= SET_MON1;
        end
        else begin
            MonCnt1 <= MonCnt1;
        end
    end
end


//==================================================================
// Years Clock counter 
//__________________________________________________________________

reg YearUp1;

wire YearUp0T = (MonCnt1 == 1'b1)  ? MonUp1T : 1'b0;
wire YearUp1T = (YearCnt0 == 4'd9) ? YearUp0T: 1'b0 ;

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        YearCnt0 <= 0;
        YearUp1  <= 0;
    end
    else begin
        if(!CLEAR)  begin
            YearCnt0 <= 0;
            YearUp1  <= 0;
        end
        else if(YearUp0T && WR_YEAR)  begin
            YearCnt0 <= SET_YEAR0;
        end
        else if(YearUp0T && (YearCnt0 == 4'd9))  begin
            YearCnt0 <= 4'd0;
            YearUp1  <= 1;
        end
        else if(YearUp0T)  begin
            YearCnt0 <= YearCnt0 + 4'd1;
        end
        else if(WR_YEAR)  begin
            YearCnt0 <= SET_YEAR0;
        end
        else begin
            YearCnt0 <= YearCnt0;
            YearUp1  <= 0;
        end
    end
end


always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        YearCnt1 <= 0;
    end
    else begin
        if(!CLEAR)  begin
            YearCnt1 <= 0;
        end
        else if(YearUp1T && WR_YEAR)  begin
            YearCnt1 <= SET_YEAR1;
        end
        else if(YearUp1T && (YearCnt1 == 4'd9))  begin
            YearCnt1 <= 4'd0;
        end
        else if(YearUp1T)  begin
            YearCnt1 <= YearCnt1 + 4'd1;
        end
        else if(WR_YEAR)  begin
            YearCnt1 <= SET_YEAR1;
        end
        else begin
            YearCnt1 <= YearCnt1;
        end
    end
end

//==================================================================
//  Function MaxDay 
//__________________________________________________________________

function  [3:0]MaxDay0;
    input EvenOddMonth;
    input LeapMon;
    input [1:0] Day1;
    input Feb;
    begin
        case({EvenOddMonth, LeapMon, Day1, Feb})

            5'b00110: MaxDay0 = 4'd0; // EvenOdd 0 -> 30 Leap = 0 Day1=3
            5'b10110: MaxDay0 = 4'd1; // EvenOdd 1 -> 31 Leap = 0 Day1=3
            5'b01101: MaxDay0 = 4'd9; // EvenOdd 0 -> 29 Leap = 1 Day1=3 Feb
            5'b00101: MaxDay0 = 4'd8; // EvenOdd 0 -> 28 Leap = 0 Day1=3 Feb
            default:  MaxDay0 = 4'd9;

        endcase
    end
endfunction

//==================================================================
//  AmPm udate 
//__________________________________________________________________

function    AmPmUpdate;

    input   Up;
    input   [3:0]   HourCnt0;
    input   [2:0]   HourCnt1;
    begin

        if((HourCnt1 == 3'd1) && (HourCnt0 == 4'd1))begin
            AmPmUpdate = Up;
        end
        else if((HourCnt1 == 3'd2) && (HourCnt0 == 4'd3))begin
            AmPmUpdate = Up;
        end
        else begin
            AmPmUpdate = 1'b0;
        end
    end
endfunction


//==================================================================
// Ouput assign 
//__________________________________________________________________

assign  RD_SEC0 = SecCnt0;
assign  RD_SEC1 = SecCnt1;
assign  RD_MIN0 = MinCnt0;
assign  RD_MIN1 = MinCnt1;
assign  RD_HOUR0 = HourCnt0;
assign  RD_HOUR1 = HourCnt1;
assign  RD_PMAM = HourCnt2;
assign  RD_DAY0 = DayCnt0;
assign  RD_DAY1 = DayCnt1;
assign  RD_MON0 = MonCnt0;
assign  RD_MON1 = MonCnt1;
assign  RD_YEAR0 = YearCnt0;
assign  RD_YEAR1 = YearCnt1;
assign  RD_WEEK = WeekCnt;
//__________________________________________________________________
//==================================================================

endmodule
