// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : tb.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is RTC test bench module
// =======================================================================

`timescale 1ns/1ps
`define NCSIM

//`define TEST_COMP
//`define TEST_STOP
//`define TEST_CLEAR
//`define TEST_SET_32
//`define TEST_UPCNT
//`define TEST_MINUPCNT
//`define TEST_HOURUPCNT
//`define TEST_DAYUPCNT
`define TEST_TIMER
`define TEST_ALARM

//`define MODE24_12

//Register setting value /////////////////////////////////////////////////
//modify this area for setting register

`define ENABLE      1'b1
`define SET_32_CNT  1'b0

`ifdef MODE24_12
`define MODE_APM    1'b1 // 1--> 12 mode / 0 --> 24 mode
`else
`define MODE_APM    1'b0 // 1--> 12 mode / 0 --> 24 mode
`endif

`define STOP_RTC    1'b1

`ifdef TEST_COMP
`define EN_COMP     1'b1
`else
`define EN_COMP     1'b0
`endif

`define ALARM       1'b0
`define CLEAR       1'b1

`define PERIOD      2'b00
`define EN_INT_TIMER   1'b1
`define EN_INT_ALARM   1'b1

//`define RTC_COMP    16'hFFEB
`define RTC_COMP    16'h100
//`define RTC_COMP    16'h0000

`ifdef MODE24_12
`define SET_SEC0    4'd4
`define SET_SEC1    3'd5
`define SET_MIN0    4'd9
`define SET_MIN1    3'd5
`define SET_HOUR0   4'd1
`define SET_HOUR1   3'd1
`define SET_PMAM    1'b1
`define SET_DAY0    4'd1
`define SET_DAY1    2'd3        
`define SET_MON0    4'd2
`define SET_MON1    1'd1        
`define SET_YEAR0   4'd7
`define SET_YEAR1   4'd0
`define SET_WEEK    3'd0
`else
`define SET_SEC0    4'd4
`define SET_SEC1    3'd5
`define SET_MIN0    4'd9
`define SET_MIN1    3'd5
`define SET_HOUR0   4'd3
`define SET_HOUR1   3'd2
`define SET_PMAM    1'b1
`define SET_DAY0    4'd1
`define SET_DAY1    2'd3        
`define SET_MON0    4'd2
`define SET_MON1    1'd1        
`define SET_YEAR0   4'd7
`define SET_YEAR1   4'd0
`define SET_WEEK    3'd0
`endif

`ifdef MODE24_12
`define ALSET_SEC0    4'd3
`define ALSET_SEC1    3'd0
`define ALSET_MIN0    4'd0
`define ALSET_MIN1    3'd0
`define ALSET_HOUR0   4'd2
`define ALSET_HOUR1   3'd1
`define ALSET_PMAM    1'b0
`define ALSET_DAY0    4'd1
`define ALSET_DAY1    2'd0        
`define ALSET_MON0    4'd1
`define ALSET_MON1    1'd0        
`define ALSET_YEAR0   4'd8
`define ALSET_YEAR1   4'd0
`else
`define ALSET_SEC0    4'd3
`define ALSET_SEC1    3'd0
`define ALSET_MIN0    4'd0
`define ALSET_MIN1    3'd0
`define ALSET_HOUR0   4'd0
`define ALSET_HOUR1   3'd0
`define ALSET_PMAM    1'b0
`define ALSET_DAY0    4'd1
`define ALSET_DAY1    2'd0        
`define ALSET_MON0    4'd1
`define ALSET_MON1    1'd0        
`define ALSET_YEAR0   4'd8
`define ALSET_YEAR1   4'd0
`endif


//ADDRESS//
`define RTC_ADDRREG00  32'h00   //0x00   RTC_CTRL register addr.
`define RTC_ADDRREG04  32'h04   //0x00   RTC_STATUS register addr.
`define RTC_ADDRREG08  32'h08   //0x00   RTC_INT register addr.
`define RTC_ADDRREG0C  32'h0C   //0x00   RTC_COMP register addr.

`define RTC_ADDRREG20  32'h20   //0x00   ADJ_SECs register addr.
`define RTC_ADDRREG24  32'h24   //0x00   ADJ_MINUTES register addr.
`define RTC_ADDRREG28  32'h28   //0x00   ADJ_HOURS register addr.
`define RTC_ADDRREG2C  32'h2C   //0x00   ADJ_DAYS register addr.
`define RTC_ADDRREG30  32'h30   //0x00   ADJ_MONTHS register addr.
`define RTC_ADDRREG34  32'h34   //0x00   ADJ_YEARS register addr.
`define RTC_ADDRREG38  32'h38   //0x00   ADJ_WEEK register addr.

`define RTC_ADDRREG40  32'h40   //0x00   ALSET_SECs register addr.
`define RTC_ADDRREG44  32'h44   //0x00   ALSET_MINUTES register addr.
`define RTC_ADDRREG48  32'h48   //0x00   ALSET_HOURS register addr.
`define RTC_ADDRREG4C  32'h4C   //0x00   ALSET_DAYS register addr.
`define RTC_ADDRREG50  32'h50   //0x00   ALSET_MONTHS register addr.
`define RTC_ADDRREG54  32'h54   //0x00   ALSET_YEARS register addr.

//////////////////////////////////////////////////////////////////////////

module tb;

parameter PERIOD1=10.83;    // 24MHz
parameter PERIOD2=580.52;   // 32Khz
parameter PHASETIME1=(PERIOD1 / 2);
parameter PHASETIME2=(PERIOD2 / 2);
parameter SDLY=2;

wire  [31:0] Address_00h_DATA; 
wire  [31:0] Address_04h_DATA; 
wire  [31:0] Address_08h_DATA; 
wire  [31:0] Address_0Ch_DATA; 
wire  [31:0] Address_20h_DATA; 
wire  [31:0] Address_24h_DATA; 
wire  [31:0] Address_28h_DATA; 
wire  [31:0] Address_2Ch_DATA; 
wire  [31:0] Address_30h_DATA; 
wire  [31:0] Address_34h_DATA; 
wire  [31:0] Address_38h_DATA; 
wire  [31:0] Address_40h_DATA; 
wire  [31:0] Address_44h_DATA; 
wire  [31:0] Address_48h_DATA; 
wire  [31:0] Address_4Ch_DATA; 
wire  [31:0] Address_50h_DATA; 
wire  [31:0] Address_54h_DATA; 

assign  Address_00h_DATA = {`ENABLE,
                             25'd0,
                            `SET_32_CNT,
                             1'b0,
                            `MODE_APM,
                            `EN_COMP,
                             1'b0,
                            `STOP_RTC };

assign  Address_04h_DATA = { 24'd0,
                            `CLEAR,
                            `ALARM,
                             6'd0 };
                            
assign  Address_08h_DATA = {28'd0,`EN_INT_ALARM, `EN_INT_TIMER, `PERIOD};
assign  Address_0Ch_DATA = {16'd0, `RTC_COMP};

assign  Address_20h_DATA = {25'd0, `SET_SEC1, `SET_SEC0 };
assign  Address_24h_DATA = {25'd0, `SET_MIN1, `SET_MIN0 };
assign  Address_28h_DATA = {25'd0, `SET_PMAM, `SET_HOUR1, `SET_HOUR0 }; 
assign  Address_2Ch_DATA = {25'd0, `SET_DAY1, `SET_DAY0 };
assign  Address_30h_DATA = {27'd0, `SET_MON1, `SET_MON0 };
assign  Address_34h_DATA = {24'd0, `SET_YEAR1, `SET_YEAR0 }; 
assign  Address_38h_DATA = {30'd0, `SET_WEEK };

assign  Address_40h_DATA = {25'd0, `ALSET_SEC1, `ALSET_SEC0 };
assign  Address_44h_DATA = {25'd0, `ALSET_MIN1, `ALSET_MIN0 };
assign  Address_48h_DATA = {24'd0, `ALSET_PMAM, `ALSET_HOUR1, `ALSET_HOUR0 }; 
assign  Address_4Ch_DATA = {25'd0, `ALSET_DAY1, `ALSET_DAY0 };
assign  Address_50h_DATA = {27'd0, `ALSET_MON1, `ALSET_MON0 };
assign  Address_54h_DATA = {24'd0, `ALSET_YEAR1, `ALSET_YEAR0 }; 


reg   RESETn;
reg   Clock;
reg   Clock_32K;

reg	[9:2]	PADDR;
reg	[31:0]	PWDATA;
reg	PSEL;
reg	PWRITE;
reg	PENABLE;


reg [7:0] MSEC;
reg [7:0] MMIN;
reg [7:0] MHOUR;
reg [7:0] MDAY;
reg [7:0] MMONTH;
reg [7:0] MYEAR;
reg [7:0] MWEEK;
reg [3:0] STATUS;


wire  [31:0]	PRDATA;
wire  INT_TIMER;
wire  INT_ALARM;
reg   StartS;
wire IntTimer_32K;
wire IntAlarm_32K;

always #PHASETIME1 Clock     = ~Clock;
always #PHASETIME2 Clock_32K = ~Clock_32K;

integer    DumpTime;
initial begin
    DumpTime  = $fopen("./Dump/DumpTime.out");
end

`ifdef NCSIM

initial begin
  $shm_open("./RTC.shm");
  //$shm_probe(Top.RTCCore, "AS");
  $shm_probe(Top, "AS");
  //$shm_probe("AS");
end

`endif


`ifdef TEST_TIMER
//Period interrupt //////////////////////////////////////////
reg  INT_TIMER_d;
wire IntTimer = INT_TIMER & !INT_TIMER_d;

always @(posedge Clock or negedge RESETn) begin
    if(!RESETn) begin
        INT_TIMER_d <= 1'b0;
    end
    else begin
        INT_TIMER_d <= INT_TIMER;
    end
end

always @(posedge Clock) begin
    if(IntTimer & StartS)  begin
        $display($time, "\n____________________________TimerInterrupt \n");
        apb_read(`RTC_ADDRREG20);
        apb_read(`RTC_ADDRREG24);
        apb_read(`RTC_ADDRREG28);
        apb_read(`RTC_ADDRREG2C);
        apb_read(`RTC_ADDRREG30);
        apb_read(`RTC_ADDRREG34);
        apb_read(`RTC_ADDRREG38);
        apb_read(`RTC_ADDRREG04);

#100    apb_write(`RTC_ADDRREG04, { 24'd0,
                                   `CLEAR,
                                    1'b1, // interrupt clear
                                    6'd0 });


        $fwrite(DumpTime,"____________TimeInt\n");
        print_time;
    end
end
////////////////////////////////////////////////////////////
`endif

`ifdef TEST_ALARM
//Alarm interrupt //////////////////////////////////////////
reg  INT_ALARM_d;
wire IntAlarm = INT_ALARM & !INT_ALARM_d;

always @(posedge Clock or negedge RESETn) begin
    if(!RESETn) begin
        INT_ALARM_d <= 1'b0;
    end
    else begin
        INT_ALARM_d <= INT_ALARM;
    end
end

always @(posedge Clock) begin
    if(IntAlarm & StartS)  begin
        $display($time, "\n____________________________AlarmIntterupt \n");
        apb_read(`RTC_ADDRREG20);
        apb_read(`RTC_ADDRREG24);
        apb_read(`RTC_ADDRREG28);
        apb_read(`RTC_ADDRREG2C);
        apb_read(`RTC_ADDRREG30);
        apb_read(`RTC_ADDRREG34);
        apb_read(`RTC_ADDRREG38);
        apb_read(`RTC_ADDRREG04);

#100    apb_write(`RTC_ADDRREG04, { 24'd0,
                                   `CLEAR,
                                    1'b1, // interrupt clear
                                    6'd0 });
        $fwrite(DumpTime,"____________AlarmInt\n");
        print_time;
    end
end
////////////////////////////////////////////////////////////
`endif

`ifdef TEST_DAYUPCNT

integer TestCnt_DayUp;
initial TestCnt_DayUp= 0;

always  @(negedge Clock_32K) begin

    if(TestCnt_DayUp == 9900) begin
        TestCnt_DayUp = 9900;
    end
    else begin
        TestCnt_DayUp = TestCnt_DayUp + 1;
    end
end

always @(TestCnt_DayUp) begin

    if(TestCnt_DayUp == 9900) begin
        force Top.RTCCore.CLK   = Clock;
        force Top.RTCCore.DayUp0  = Top.RTCCore.SecUp0;
    end
end

`endif


`ifdef TEST_HOURUPCNT

integer TestCnt_HourUp;
initial TestCnt_HourUp= 0;

always  @(negedge Clock_32K) begin

    if(TestCnt_HourUp == 9900) begin
        TestCnt_HourUp = 9900;
    end
    else begin
        TestCnt_HourUp = TestCnt_HourUp + 1;
    end
end

always @(TestCnt_HourUp) begin

    if(TestCnt_HourUp == 9900) begin
        force Top.RTCCore.CLK   = Clock;
        force Top.RTCCore.HourUp0T  = Top.RTCCore.SecUp0;
    end
end

`endif


`ifdef TEST_MINUPCNT

integer TestCnt_MinUp;
initial TestCnt_MinUp= 0;

always  @(negedge Clock_32K) begin

    if(TestCnt_MinUp == 9900) begin
        TestCnt_MinUp = 9900;
    end
    else begin
        TestCnt_MinUp = TestCnt_MinUp + 1;
    end
end

always @(TestCnt_MinUp) begin

    if(TestCnt_MinUp == 9900) begin
        force Top.RTCCore.CLK   = Clock;
        force Top.RTCCore.SecCnt0  = 9;
        force Top.RTCCore.SecCnt1  = 5;
    end
end

`endif

`ifdef TEST_UPCNT

integer TestCnt_Up;
initial TestCnt_Up= 0;

always  @(negedge Clock_32K) begin

    if(TestCnt_Up == 9000) begin
        TestCnt_Up = 9000;
    end
    else begin
        TestCnt_Up = TestCnt_Up + 1;
    end
end

always @(TestCnt_Up) begin

    if(TestCnt_Up == 9000)
        force Top.RTCCore.CLK   = Clock;
end
`endif

`ifdef TEST_SET_32

integer TestCnt_SET_32;
initial TestCnt_SET_32= 0;

always  @(negedge Clock_32K) begin

    if(TestCnt_SET_32 == 100) begin
        TestCnt_SET_32 = TestCnt_SET_32 + 1;
        apb_write(`RTC_ADDRREG00,{`ENABLE,     //Stop action
                                   25'd0,
                                  //`SET_32_CNT,
                                   1'b0,
                                   1'b0,
                                  `MODE_APM,
                                  `EN_COMP,
                                   1'b0,
                                   1'b0
                                  //`STOP_RTC 
                                  });
    end
    else if(TestCnt_SET_32 == 2500) begin

        TestCnt_SET_32 = TestCnt_SET_32 + 1;
        apb_write(`RTC_ADDRREG00,{`ENABLE,     //Stop action
                                   25'd0,
                                  //`SET_32_CNT,
                                   1'b1,
                                   1'b0,
                                  `MODE_APM,
                                  `EN_COMP,
                                   1'b0,
                                  //`STOP_RTC 
                                   1'b0
                                  });

    end
    else if(TestCnt_SET_32 == 5500) begin
        TestCnt_SET_32 = TestCnt_SET_32 + 1;
        apb_write(`RTC_ADDRREG00,{`ENABLE,     //Stop action
                                   25'd0,
                                  //`SET_32_CNT,
                                   1'b1,
                                   1'b0,
                                  `MODE_APM,
                                  `EN_COMP,
                                   1'b0,
                                  //`STOP_RTC 
                                   1'b1
                                  });
    end
    else if(TestCnt_SET_32 == 6500) begin
        TestCnt_SET_32 = 0;
        apb_write(`RTC_ADDRREG00,{`ENABLE,     //Stop action
                                   25'd0,
                                  //`SET_32_CNT,
                                   1'b0,
                                   1'b0,
                                  `MODE_APM,
                                  `EN_COMP,
                                   1'b0,
                                  //`STOP_RTC 
                                   1'b1
                                  });
    end
    else begin
        TestCnt_SET_32 = TestCnt_SET_32 + 1;
    end

end

`endif

`ifdef TEST_CLEAR
integer TestCnt_Clear;
initial TestCnt_Clear= 0;

always  @(negedge Clock_32K) begin

    if(TestCnt_Clear == 5000) begin
        TestCnt_Clear = 0;

        apb_write(`RTC_ADDRREG04,{24'd0,     //Clear 
                                  1'b0,
                                 `ALARM,
                                  6'd0 });

    end
    else begin
        TestCnt_Clear = TestCnt_Clear + 1;
    end

end
`endif

`ifdef TEST_STOP
integer TestCnt_Stop;
initial TestCnt_Stop= 0;

always  @(negedge Clock_32K) begin

    if(TestCnt_Stop == 5000) begin
        TestCnt_Stop = TestCnt_Stop + 1;
        apb_write(`RTC_ADDRREG00,{`ENABLE,     //Stop action
                                   25'd0,
                                  `SET_32_CNT,
                                   1'b0,
                                  `MODE_APM,
                                  `EN_COMP,
                                   1'b0,
                                   1'b0});
    end
    else if(TestCnt_Stop == 9000) begin
        TestCnt_Stop = 0;
        apb_write(`RTC_ADDRREG00,{`ENABLE,     //Start action
                                   25'd0,
                                  `SET_32_CNT,
                                   1'b0,
                                  `MODE_APM,
                                  `EN_COMP,
                                   1'b0,
                                   1'b1});
    end
    else begin
        TestCnt_Stop = TestCnt_Stop + 1;
    end

end

`endif

`ifdef TEST_COMP

integer TestCnt;
initial TestCnt = 0;

always @(negedge Clock) begin

    if(TestCnt == 99999) begin
        TestCnt = 0;
        force Top.RTCCore.ClkCnt   = 15'h7ffC;
        force Top.RTCCore.SecCnt0  = 9;
        force Top.RTCCore.SecCnt1  = 5;
        force Top.RTCCore.MinCnt0  = 9;
        force Top.RTCCore.MinCnt1  = 5;
        force Top.RTCCore.UpFlag   = 0;
        force Top.RTCCore.ZeroFlag   = 0;
    end
    else begin
        TestCnt = TestCnt + 1;
        release Top.RTCCore.ClkCnt;
        release Top.RTCCore.SecCnt0 ;
        release Top.RTCCore.SecCnt1 ;
        release Top.RTCCore.MinCnt0; 
        release Top.RTCCore.MinCnt1;
        release Top.RTCCore.UpFlag;
        release Top.RTCCore.ZeroFlag;
    end

end

`endif




initial begin

    PENABLE = 0    ;     // Data valid strobe 
    PSEL   	= 0    ;     // Module select signal
    PWRITE  = 0    ;     // Write/nRead signal
    PADDR  	= 0    ;     // Address (used bits only)
    PWDATA  = 0    ;     // Read data

end
  
//Clock&Reset generation
initial begin
    Clock = 0;
    Clock_32K = 0;
end

//APB register setting
initial begin

    StartS = 0;
	RESETn = 1'b0;
	repeat(100) @(posedge Clock);
	#(SDLY) RESETn = 1'b1;

    apb_write(`RTC_ADDRREG20, Address_20h_DATA);
    apb_write(`RTC_ADDRREG24, Address_24h_DATA);
    apb_write(`RTC_ADDRREG28, Address_28h_DATA);
    apb_write(`RTC_ADDRREG2C, Address_2Ch_DATA);
    apb_write(`RTC_ADDRREG30, Address_30h_DATA);
    apb_write(`RTC_ADDRREG34, Address_34h_DATA);
    apb_write(`RTC_ADDRREG38, Address_38h_DATA);

    apb_write(`RTC_ADDRREG40, Address_40h_DATA);
    apb_write(`RTC_ADDRREG44, Address_44h_DATA);
    apb_write(`RTC_ADDRREG48, Address_48h_DATA);
    apb_write(`RTC_ADDRREG4C, Address_4Ch_DATA);
    apb_write(`RTC_ADDRREG50, Address_50h_DATA);
    apb_write(`RTC_ADDRREG54, Address_54h_DATA);

    apb_write(`RTC_ADDRREG0C, Address_0Ch_DATA);
    apb_write(`RTC_ADDRREG08, Address_08h_DATA);
    apb_write(`RTC_ADDRREG04, Address_04h_DATA);
    apb_write(`RTC_ADDRREG00, Address_00h_DATA);

    StartS = 1;

end

wire    PCLK = Clock;
wire    CLK  = Clock_32K;
wire    PRESETn = RESETn;


RTCTOP Top
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

    .INT_TIMER(INT_TIMER),
    .INT_ALARM(INT_ALARM),

    .IntTimer_32K(IntTimer_32K),
    .IntAlarm_32K(IntAlarm_32K),

//input
    .CLK(CLK)        // 32khz clock input
);

// TASK register setting ////////////////////////////////////////////

task register_time_set; 
begin

    apb_write(`RTC_ADDRREG20, Address_20h_DATA);
    apb_write(`RTC_ADDRREG24, Address_24h_DATA);
    apb_write(`RTC_ADDRREG28, Address_28h_DATA);
    apb_write(`RTC_ADDRREG2C, Address_2Ch_DATA);
    apb_write(`RTC_ADDRREG30, Address_30h_DATA);
    apb_write(`RTC_ADDRREG34, Address_34h_DATA);
    apb_write(`RTC_ADDRREG38, Address_38h_DATA);

end
endtask


// TASK for write and read //////////////////////////////////////////

task  apb_write; // write
input [31:0] reg_addr;
input [31:0] reg_write;
begin
    @(negedge PCLK);
    PENABLE = 1'b0;
    @(posedge PCLK);
	#2
        PSEL = 1'b1;
        PWRITE = 1'b1;
        PADDR = reg_addr[9:2];
        PWDATA = reg_write;
	
    @(posedge PCLK)

    #2  PENABLE = 1'b1;

    @(posedge PCLK)

    #2  $display($time, " << address [%h]      write data [%h] >> ", reg_addr, reg_write);
        PENABLE = 1'b0;
        PSEL    = 1'b0;
        PWDATA  = 32'dz;
end
endtask

task  apb_read; // read
input [31:0] reg_addr;
begin
    @(negedge PCLK);
    PENABLE = 1'b0;

    @(posedge PCLK);
        #2  PSEL = 1'b1;
            PWRITE = 1'b0;
            PADDR = reg_addr[9:2];
    @(posedge PCLK)
        #2  PENABLE = 1'b1;
    @(posedge PCLK)
            $display($time, " << address [%h]      read data [%h] >> ", reg_addr, PRDATA );
            mem_time(reg_addr, PRDATA);
            
        #2  PENABLE = 1'b0;
            PSEL = 1'b0;
end
endtask

task mem_time;
input [31:0] addr;
input [31:0] data;
begin
    case(addr)
        `RTC_ADDRREG20: MSEC = data; 
        `RTC_ADDRREG24: MMIN = data;
        `RTC_ADDRREG28: MHOUR= data;
        `RTC_ADDRREG2C: MDAY = data;
        `RTC_ADDRREG30: MMONTH= data;
        `RTC_ADDRREG34: MYEAR= data;
        `RTC_ADDRREG38: MWEEK= data;
        `RTC_ADDRREG04: STATUS= data[5:2];
    endcase
end
endtask

task print_time;
begin

    $display("YEAR[%h]/ MONTH[%h]/ DAY[%h]/ WEEK[%h]/ AMPM[%h]/ HOUR[%h]/ MIN[%h] / SEC[%h]\n",
                MYEAR, MMONTH, MDAY, MWEEK, MHOUR[7], MHOUR[6:0], MMIN, MSEC);

    $fwrite(DumpTime,"Alarm  Day[%d] / Hour[%d] / Min[%d] / Sec[%d] \n",STATUS[3],STATUS[2],STATUS[1],STATUS[0]);
    $fwrite(DumpTime,
                "YEAR[%h]/ MONTH[%h]/ DAY[%h]/ WEEK[%h]/ AMPM[%h]/ HOUR[%h]/ MIN[%h] / SEC[%h]\n",
                MYEAR, MMONTH, MDAY, MWEEK, MHOUR[7], MHOUR[6:0], MMIN, MSEC);
end
endtask

//////////////////////////////////////////////////////////////////


endmodule
