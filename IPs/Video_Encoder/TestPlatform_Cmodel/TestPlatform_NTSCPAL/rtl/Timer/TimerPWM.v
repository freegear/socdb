
module TimerPWM (
		PCLK         , 
		PRESETn      , 
		PENABLE      , 
		PSELTimer    , 
		PSELPWM0     , 
		PSELPWM1     , 
		PSELPWM2     , 
		PSELPWM3     , 
		PWRITE       , 
		PADDR        ,
		PWDATA       ,
		PRDATATimer  ,
		PRDATAPWM0   ,
		PRDATAPWM1   ,
		PRDATAPWM2   ,
		PRDATAPWM3   ,
		
		TCLK         ,
		TCAP         ,
		TimerOut     ,
		TimerTOFInt  ,
		TimerTMCInt  ,   
		PWM0Out      ,
		PWM1Out      ,
		PWM2Out      ,
		PWM3Out
);

input         PCLK;     // APB system clock
input         PRESETn;     // APB system reset
input         PENABLE;     // Data valid strobe 
input         PSELTimer;
input         PSELPWM0;
input         PSELPWM1;
input         PSELPWM2;
input         PSELPWM3;
input         PWRITE;     // Write/nRead signal
input  [7:2]  PADDR;     // Address (used bits only)

input  [15:0] PWDATA;
output [31:0] PRDATATimer;
output [31:0] PRDATAPWM0;
output [31:0] PRDATAPWM1;
output [31:0] PRDATAPWM2;
output [31:0] PRDATAPWM3;

input  [ 7:0] TCLK;
input  [ 7:0] TCAP;

output [ 7:0] TimerOut;
output [ 7:0] TimerTOFInt;     //Overflow Interrupt
output [ 7:0] TimerTMCInt;     //Match Interrupt

output [ 7:0] PWM0Out;
output [ 7:0] PWM1Out;
output [ 7:0] PWM2Out;
output [ 7:0] PWM3Out;

wire PSELTimer0 = PSELTimer & ~PADDR[7] & ~PADDR[6] & ~PADDR[5]; // 0x8400
wire PSELTimer1 = PSELTimer & ~PADDR[7] & ~PADDR[6] &  PADDR[5]; // 0x8420
wire PSELTimer2 = PSELTimer & ~PADDR[7] &  PADDR[6] & ~PADDR[5]; // 0x8440
wire PSELTimer3 = PSELTimer & ~PADDR[7] &  PADDR[6] &  PADDR[5]; // 0x8460
wire PSELTimer4 = PSELTimer &  PADDR[7] & ~PADDR[6] & ~PADDR[5]; // 0x8480
wire PSELTimer5 = PSELTimer &  PADDR[7] & ~PADDR[6] &  PADDR[5]; // 0x84A0
wire PSELTimer6 = PSELTimer &  PADDR[7] &  PADDR[6] & ~PADDR[5]; // 0x84C0
wire PSELTimer7 = PSELTimer &  PADDR[7] &  PADDR[6] &  PADDR[5]; // 0x84E0

wire PSELPWM00  = PSELPWM0  & ~PADDR[7] & ~PADDR[6] & ~PADDR[5]; // 0x8500
wire PSELPWM01  = PSELPWM0  & ~PADDR[7] & ~PADDR[6] &  PADDR[5]; // 0x8520
wire PSELPWM02  = PSELPWM0  & ~PADDR[7] &  PADDR[6] & ~PADDR[5]; // 0x8540
wire PSELPWM03  = PSELPWM0  & ~PADDR[7] &  PADDR[6] &  PADDR[5]; // 0x8560
wire PSELPWM04  = PSELPWM0  &  PADDR[7] & ~PADDR[6] & ~PADDR[5]; // 0x8580
wire PSELPWM05  = PSELPWM0  &  PADDR[7] & ~PADDR[6] &  PADDR[5]; // 0x85A0
wire PSELPWM06  = PSELPWM0  &  PADDR[7] &  PADDR[6] & ~PADDR[5]; // 0x85C0
wire PSELPWM07  = PSELPWM0  &  PADDR[7] &  PADDR[6] &  PADDR[5]; // 0x85E0

wire PSELPWM10  = PSELPWM1  & ~PADDR[7] & ~PADDR[6] & ~PADDR[5]; // 0x8600
wire PSELPWM11  = PSELPWM1  & ~PADDR[7] & ~PADDR[6] &  PADDR[5]; // 0x8620
wire PSELPWM12  = PSELPWM1  & ~PADDR[7] &  PADDR[6] & ~PADDR[5]; // 0x8640
wire PSELPWM13  = PSELPWM1  & ~PADDR[7] &  PADDR[6] &  PADDR[5]; // 0x8660
wire PSELPWM14  = PSELPWM1  &  PADDR[7] & ~PADDR[6] & ~PADDR[5]; // 0x8680
wire PSELPWM15  = PSELPWM1  &  PADDR[7] & ~PADDR[6] &  PADDR[5]; // 0x86A0
wire PSELPWM16  = PSELPWM1  &  PADDR[7] &  PADDR[6] & ~PADDR[5]; // 0x86C0
wire PSELPWM17  = PSELPWM1  &  PADDR[7] &  PADDR[6] &  PADDR[5]; // 0x86E0

wire PSELPWM20  = PSELPWM2  & ~PADDR[7] & ~PADDR[6] & ~PADDR[5]; // 0x8700
wire PSELPWM21  = PSELPWM2  & ~PADDR[7] & ~PADDR[6] &  PADDR[5]; // 0x8720
wire PSELPWM22  = PSELPWM2  & ~PADDR[7] &  PADDR[6] & ~PADDR[5]; // 0x8740
wire PSELPWM23  = PSELPWM2  & ~PADDR[7] &  PADDR[6] &  PADDR[5]; // 0x8760
wire PSELPWM24  = PSELPWM2  &  PADDR[7] & ~PADDR[6] & ~PADDR[5]; // 0x8780
wire PSELPWM25  = PSELPWM2  &  PADDR[7] & ~PADDR[6] &  PADDR[5]; // 0x87A0
wire PSELPWM26  = PSELPWM2  &  PADDR[7] &  PADDR[6] & ~PADDR[5]; // 0x87C0
wire PSELPWM27  = PSELPWM2  &  PADDR[7] &  PADDR[6] &  PADDR[5]; // 0x87E0

wire PSELPWM30  = PSELPWM3  & ~PADDR[7] & ~PADDR[6] & ~PADDR[5]; // 0x8800
wire PSELPWM31  = PSELPWM3  & ~PADDR[7] & ~PADDR[6] &  PADDR[5]; // 0x8820
wire PSELPWM32  = PSELPWM3  & ~PADDR[7] &  PADDR[6] & ~PADDR[5]; // 0x8840
wire PSELPWM33  = PSELPWM3  & ~PADDR[7] &  PADDR[6] &  PADDR[5]; // 0x8860
wire PSELPWM34  = PSELPWM3  &  PADDR[7] & ~PADDR[6] & ~PADDR[5]; // 0x8880
wire PSELPWM35  = PSELPWM3  &  PADDR[7] & ~PADDR[6] &  PADDR[5]; // 0x88A0
wire PSELPWM36  = PSELPWM3  &  PADDR[7] &  PADDR[6] & ~PADDR[5]; // 0x88C0
wire PSELPWM37  = PSELPWM3  &  PADDR[7] &  PADDR[6] &  PADDR[5]; // 0x88E0

wire [31:0] PRDATATimer0;
wire [31:0] PRDATATimer1;
wire [31:0] PRDATATimer2;
wire [31:0] PRDATATimer3;
wire [31:0] PRDATATimer4;
wire [31:0] PRDATATimer5;
wire [31:0] PRDATATimer6;
wire [31:0] PRDATATimer7;

wire [31:0] PRDATAPWM00;
wire [31:0] PRDATAPWM01;
wire [31:0] PRDATAPWM02;
wire [31:0] PRDATAPWM03;
wire [31:0] PRDATAPWM04;
wire [31:0] PRDATAPWM05;
wire [31:0] PRDATAPWM06;
wire [31:0] PRDATAPWM07;

wire [31:0] PRDATAPWM10;
wire [31:0] PRDATAPWM11;
wire [31:0] PRDATAPWM12;
wire [31:0] PRDATAPWM13;
wire [31:0] PRDATAPWM14;
wire [31:0] PRDATAPWM15;
wire [31:0] PRDATAPWM16;
wire [31:0] PRDATAPWM17;

wire [31:0] PRDATAPWM20;
wire [31:0] PRDATAPWM21;
wire [31:0] PRDATAPWM22;
wire [31:0] PRDATAPWM23;
wire [31:0] PRDATAPWM24;
wire [31:0] PRDATAPWM25;
wire [31:0] PRDATAPWM26;
wire [31:0] PRDATAPWM27;

wire [31:0] PRDATAPWM30;
wire [31:0] PRDATAPWM31;
wire [31:0] PRDATAPWM32;
wire [31:0] PRDATAPWM33;
wire [31:0] PRDATAPWM34;
wire [31:0] PRDATAPWM35;
wire [31:0] PRDATAPWM36;
wire [31:0] PRDATAPWM37;

reg  [31:0] PRDATATimer;
reg  [31:0] PRDATAPWM0;
reg  [31:0] PRDATAPWM1;
reg  [31:0] PRDATAPWM2;
reg  [31:0] PRDATAPWM3;

always @(PSELTimer0   or PSELTimer1   or PSELTimer2   or PSELTimer3 or 
         PSELTimer4   or PSELTimer5   or PSELTimer6   or PSELTimer7 or
         PRDATATimer0 or PRDATATimer1 or PRDATATimer2 or PRDATATimer3 or 
         PRDATATimer4 or PRDATATimer5 or PRDATATimer6 or PRDATATimer7)
  case(1'b1) // synopsys parallel_case
    PSELTimer0 : PRDATATimer = PRDATATimer0;
    PSELTimer1 : PRDATATimer = PRDATATimer1;
    PSELTimer2 : PRDATATimer = PRDATATimer2;
    PSELTimer3 : PRDATATimer = PRDATATimer3;
    PSELTimer4 : PRDATATimer = PRDATATimer4;
    PSELTimer5 : PRDATATimer = PRDATATimer5;
    PSELTimer6 : PRDATATimer = PRDATATimer6;
    PSELTimer7 : PRDATATimer = PRDATATimer7;
    default    : PRDATATimer = 32'b0;
  endcase

always @(PSELPWM00   or PSELPWM01   or PSELPWM02   or PSELPWM03 or 
         PSELPWM04   or PSELPWM05   or PSELPWM06   or PSELPWM07 or
         PRDATAPWM00 or PRDATAPWM01 or PRDATAPWM02 or PRDATAPWM03 or 
         PRDATAPWM04 or PRDATAPWM05 or PRDATAPWM06 or PRDATAPWM07)
  case(1'b1) // synopsys parallel_case
    PSELPWM00 : PRDATAPWM0 = PRDATAPWM00;
    PSELPWM01 : PRDATAPWM0 = PRDATAPWM01;
    PSELPWM02 : PRDATAPWM0 = PRDATAPWM02;
    PSELPWM03 : PRDATAPWM0 = PRDATAPWM03;
    PSELPWM04 : PRDATAPWM0 = PRDATAPWM04;
    PSELPWM05 : PRDATAPWM0 = PRDATAPWM05;
    PSELPWM06 : PRDATAPWM0 = PRDATAPWM06;
    PSELPWM07 : PRDATAPWM0 = PRDATAPWM07;
    default   : PRDATAPWM0 = 32'b0;
  endcase


always @(PSELPWM10   or PSELPWM11   or PSELPWM12   or PSELPWM13 or 
         PSELPWM14   or PSELPWM15   or PSELPWM16   or PSELPWM17 or
         PRDATAPWM10 or PRDATAPWM11 or PRDATAPWM12 or PRDATAPWM13 or 
         PRDATAPWM14 or PRDATAPWM15 or PRDATAPWM16 or PRDATAPWM17)
  case(1'b1) // synopsys parallel_case
    PSELPWM10 : PRDATAPWM1 = PRDATAPWM10;
    PSELPWM11 : PRDATAPWM1 = PRDATAPWM11;
    PSELPWM12 : PRDATAPWM1 = PRDATAPWM12;
    PSELPWM13 : PRDATAPWM1 = PRDATAPWM13;
    PSELPWM14 : PRDATAPWM1 = PRDATAPWM14;
    PSELPWM15 : PRDATAPWM1 = PRDATAPWM15;
    PSELPWM16 : PRDATAPWM1 = PRDATAPWM16;
    PSELPWM17 : PRDATAPWM1 = PRDATAPWM17;
    default   : PRDATAPWM1 = 32'b0;
  endcase

always @(PSELPWM20   or PSELPWM21   or PSELPWM22   or PSELPWM23 or 
         PSELPWM24   or PSELPWM25   or PSELPWM26   or PSELPWM27 or
         PRDATAPWM20 or PRDATAPWM21 or PRDATAPWM22 or PRDATAPWM23 or 
         PRDATAPWM24 or PRDATAPWM25 or PRDATAPWM26 or PRDATAPWM27)
  case(1'b1) // synopsys parallel_case
    PSELPWM20 : PRDATAPWM2 = PRDATAPWM20;
    PSELPWM21 : PRDATAPWM2 = PRDATAPWM21;
    PSELPWM22 : PRDATAPWM2 = PRDATAPWM22;
    PSELPWM23 : PRDATAPWM2 = PRDATAPWM23;
    PSELPWM24 : PRDATAPWM2 = PRDATAPWM24;
    PSELPWM25 : PRDATAPWM2 = PRDATAPWM25;
    PSELPWM26 : PRDATAPWM2 = PRDATAPWM26;
    PSELPWM27 : PRDATAPWM2 = PRDATAPWM27;
    default   : PRDATAPWM2 = 32'b0;
  endcase

always @(PSELPWM30   or PSELPWM31   or PSELPWM32   or PSELPWM33 or 
         PSELPWM34   or PSELPWM35   or PSELPWM36   or PSELPWM37 or
         PRDATAPWM30 or PRDATAPWM31 or PRDATAPWM32 or PRDATAPWM33 or 
         PRDATAPWM34 or PRDATAPWM35 or PRDATAPWM36 or PRDATAPWM37)
  case(1'b1) // synopsys parallel_case
    PSELPWM30 : PRDATAPWM3 = PRDATAPWM30;
    PSELPWM31 : PRDATAPWM3 = PRDATAPWM31;
    PSELPWM32 : PRDATAPWM3 = PRDATAPWM32;
    PSELPWM33 : PRDATAPWM3 = PRDATAPWM33;
    PSELPWM34 : PRDATAPWM3 = PRDATAPWM34;
    PSELPWM35 : PRDATAPWM3 = PRDATAPWM35;
    PSELPWM36 : PRDATAPWM3 = PRDATAPWM36;
    PSELPWM37 : PRDATAPWM3 = PRDATAPWM37;
    default   : PRDATAPWM3 = 32'b0;
  endcase
  
//Timers0~7

timer_pwm uTimer0 
(
     .PCLK         (PCLK            ), 
     .PRESETn      (PRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELTimer0      ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[4:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATATimer0    ),

     .TCLK         (TCLK[0]         ),
     .TCAP         (TCAP[0]       ),
     .INT_TPOUT    (TimerOut[0]     ),
     .INT_TOF      (TimerTOFInt[0]  ),
     .INT_TMC      (TimerTMCInt[0]  )
);


timer_pwm uTimer1 
(
     .PCLK         (PCLK            ), 
     .PRESETn      (PRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELTimer1      ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[4:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATATimer1    ),

     .TCLK         (TCLK[1]         ),
     .TCAP         (TCAP[1]       ),
     .INT_TPOUT    (TimerOut[1]     ),
     .INT_TOF      (TimerTOFInt[1]  ),
     .INT_TMC      (TimerTMCInt[1]  )
);


timer_pwm uTimer2 
(
     .PCLK         (PCLK            ), 
     .PRESETn      (PRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELTimer2      ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[4:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATATimer2    ),

     .TCLK         (TCLK[2]         ),
     .TCAP         (TCAP[2]       ),
     .INT_TPOUT    (TimerOut[2]     ),
     .INT_TOF      (TimerTOFInt[2]  ),
     .INT_TMC      (TimerTMCInt[2]  )
);

timer_pwm uTimer3 
(
     .PCLK         (PCLK            ), 
     .PRESETn      (PRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELTimer3      ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[4:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATATimer3    ),

     .TCLK         (TCLK[3]         ),
     .TCAP         (TCAP[3]       ),
     .INT_TPOUT    (TimerOut[3]     ),
     .INT_TOF      (TimerTOFInt[3]  ),
     .INT_TMC      (TimerTMCInt[3]  )
);

timer_pwm uTimer4 
(
     .PCLK         (PCLK            ), 
     .PRESETn      (PRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELTimer4      ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[4:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATATimer4    ),

     .TCLK         (TCLK[4]         ),
     .TCAP         (TCAP[4]       ),
     .INT_TPOUT    (TimerOut[4]     ),
     .INT_TOF      (TimerTOFInt[4]  ),
     .INT_TMC      (TimerTMCInt[4]  )
);

timer_pwm uTimer5 
(
     .PCLK         (PCLK            ), 
     .PRESETn      (PRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELTimer5      ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[4:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATATimer5    ),

     .TCLK         (TCLK[5]         ),
     .TCAP         (TCAP[5]       ),
     .INT_TPOUT    (TimerOut[5]     ),
     .INT_TOF      (TimerTOFInt[5]  ),
     .INT_TMC      (TimerTMCInt[5]  )
);


timer_pwm uTimer6 
(
     .PCLK         (PCLK            ), 
     .PRESETn      (PRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELTimer6      ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[4:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATATimer6    ),

     .TCLK         (TCLK[6]         ),
     .TCAP         (TCAP[6]       ),
     .INT_TPOUT    (TimerOut[6]     ),
     .INT_TOF      (TimerTOFInt[6]  ),
     .INT_TMC      (TimerTMCInt[6]  )
);

timer_pwm uTimer7 
(
     .PCLK         (PCLK            ), 
     .PRESETn      (PRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELTimer7      ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[4:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATATimer7    ),

     .TCLK         (TCLK[7]         ),
     .TCAP         (TCAP[7]       ),
     .INT_TPOUT    (TimerOut[7]     ),
     .INT_TOF      (TimerTOFInt[7]  ),
     .INT_TMC      (TimerTMCInt[7]  )
);

//======================================================
//PWM0_0 ~ PWM0_7
//====================================================== 
  
timer_pwm uPWM0_0 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM00        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM00      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM0Out[0]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM0_1 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM01        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM01      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM0Out[1]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM0_2 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM02        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM02      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM0Out[2]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM0_3 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM03        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM03      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM0Out[3]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM0_4 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM04        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM04      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM0Out[4]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM0_5 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM05        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM05      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM0Out[5]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM0_6 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM06        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM06      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM0Out[6]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM0_7 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM07        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM07      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM0Out[7]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);


//=======================================================
//PWM1_0 ~ PWM1_7
//=======================================================
timer_pwm uPWM1_0 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM10        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM10      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM1Out[0]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM1_1 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM11        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM11      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM1Out[1]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM1_2 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM12        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM12      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM1Out[2]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM1_3 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM13        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM13      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM1Out[3]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM1_4 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM14        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM14      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM1Out[4]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM1_5 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM15        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM15      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM1Out[5]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM1_6 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM16        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM16      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM1Out[6]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM1_7 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM17        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM17      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM1Out[7]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);


//=======================================================
//PWM2_0 ~ PWM2_7
//=======================================================
timer_pwm uPWM2_0 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM20        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM20      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM2Out[0]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM2_1 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM21        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM21      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM2Out[1]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM2_2 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM22        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM22      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM2Out[2]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM2_3 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM23        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM23      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM2Out[3]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM2_4 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM24        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM24      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM2Out[4]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM2_5 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM25        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM25      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM2Out[5]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM2_6 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM26        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM26      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM2Out[6]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM2_7 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM27        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM27      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM2Out[7]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);


//=======================================================
//PWM3_0 ~ PWM3_7
//=======================================================
timer_pwm uPWM3_0 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM30        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM30      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM3Out[0]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM3_1 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM31        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM31      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM3Out[1]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM3_2 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM32        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM32      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM3Out[2]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM3_3 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM33        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM33      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM3Out[3]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM3_4 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM34        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM34      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM3Out[4]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM3_5 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM35        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM35      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM3Out[5]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM3_6 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM36        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM36      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM3Out[6]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

timer_pwm uPWM3_7 
(
     .PCLK         (PCLK             ), 
     .PRESETn      (PRESETn          ), 
     .PENABLE      (PENABLE          ), 
     .PSEL         (PSELPWM37        ), 
     .PWRITE       (PWRITE           ), 
     .PADDR        (PADDR[4:2]       ), 
     .PWDATA       (PWDATA           ),
     .PRDATA       (PRDATAPWM37      ),

     .TCLK         (1'b0             ),
     .TCAP         (1'b0             ),
     .INT_TPOUT    (PWM3Out[7]       ),
     .INT_TOF      (                 ),
     .INT_TMC      (                 )
);

endmodule
