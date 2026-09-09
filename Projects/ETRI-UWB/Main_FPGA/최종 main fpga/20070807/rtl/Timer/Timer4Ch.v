
module Timer4Ch (
		PCLK         , 
		PRESETn      , 
		PENABLE      , 
		PSEL         , 
		PWRITE       , 
		PADDR        ,
		PWDATA       ,
		PRDATA       ,
		
		TimerTMCInt
);

input         PCLK;     // APB system clock
input         PRESETn;     // APB system reset
input         PENABLE;     // Data valid strobe 
input         PSEL;
input         PWRITE;     // Write/nRead signal
input  [5:2]  PADDR;     // Address (used bits only)

input  [31:0] PWDATA;
output [31:0] PRDATA;

output [ 3:0] TimerTMCInt;     //Match Interrupt

wire PSELTimer0 = PSEL & ~PADDR[5] & ~PADDR[4];
wire PSELTimer1 = PSEL & ~PADDR[5] &  PADDR[4];
wire PSELTimer2 = PSEL & PADDR[5] & ~PADDR[4];
wire PSELTimer3 = PSEL & PADDR[5] &  PADDR[4];

wire [31:0] PRDATATimer0;
wire [31:0] PRDATATimer1;
wire [31:0] PRDATATimer2;
wire [31:0] PRDATATimer3;

reg  [31:0] PRDATA;

always @(PSELTimer0   or PSELTimer1   or PSELTimer2   or PSELTimer3 or 
         PRDATATimer0 or PRDATATimer1 or PRDATATimer2 or PRDATATimer3) 
  case(1'b1) // synopsys parallel_case
    PSELTimer0 : PRDATA = PRDATATimer0;
    PSELTimer1 : PRDATA = PRDATATimer1;
    PSELTimer2 : PRDATA = PRDATATimer2;
    PSELTimer3 : PRDATA = PRDATATimer3;
    default    : PRDATA = 32'b0;
  endcase

//Timers0~3

timer_pwm uTimer0 
(
     .PCLK         (PCLK            ), 
     .PRESETn      (PRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELTimer0      ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[3:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATATimer0    ),

     .INT_TMC      (TimerTMCInt[0]  )
);


timer_pwm uTimer1 
(
     .PCLK         (PCLK            ), 
     .PRESETn      (PRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELTimer1      ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[3:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATATimer1    ),

     .INT_TMC      (TimerTMCInt[1]  )
);


timer_pwm uTimer2 
(
     .PCLK         (PCLK            ), 
     .PRESETn      (PRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELTimer2      ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[3:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATATimer2    ),

     .INT_TMC      (TimerTMCInt[2]  )
);

timer_pwm uTimer3 
(
     .PCLK         (PCLK            ), 
     .PRESETn      (PRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELTimer3      ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[3:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATATimer3    ),

     .INT_TMC      (TimerTMCInt[3]  )
);

endmodule
