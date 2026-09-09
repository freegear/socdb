/*****************************************************************

		         Timer_pwm testbench

*****************************************************************/


`timescale 1 ns/ 100ps

// define control signal ADDR = 0x08
`define	IVT	1'b1	// invert signal (1= invert)
`define	ICS	1'b1	// input clock source ( 0 => internal 1=> External)
`define	OMS	3'd1	// operation mode
`define	CL	1'b0	// clear
`define	TEN	1'b1	// timer enalbe


module tb_timer_pwm;

  reg         PCLK        ;     // APB system clock
  reg         PRESETn     ;     // APB system reset
  reg         PENABLE     ;     // Data valid strobe 
  reg         PSEL        ;     // Module select signal
  reg         PWRITE      ;     // Write/nRead signal
  reg  [11:0] PADDR       ;     // Address (used bits only)
  reg  [31:0] PWDATA      ;     // Read data
  wire [31:0] PRDATA      ;     // Write data

  reg	      TCLK         ;
  reg  [7:0]  TCAP         ;
  wire        INT_TPOUT    ;
  wire        INT_TOF      ;     //Overflow[16'hFFFF Interrupt
  wire        INT_TMC      ;     //Match Interrupt To Interrupt 


  wire [31:0] CON	; 	// control setting reg. 0x8
  wire [31:0] PRE	; 	// Timer prescaler reg. 0x4
  wire [31:0] DAT	; 	// Timer Data reg. 	0x0
  wire [31:0] CNT	; 	// Timer count reg. 	0xc
  wire [31:0] PWM	; 	// PWM end reg.		0x10

  assign	CON = {23'd0, `TEN, `CL, `OMS, `ICS, `IVT, 1'b0}; 
  assign	PRE = {24'd0, 8'd6};
  assign	DAT = {16'd0, 16'd11050};
  assign	CNT = {28'd0, 4'd0};
  assign	PWM = {16'd0, 16'd30000};

  always
	#5	PCLK = ~PCLK;	

  always
	#90	TCLK = ~TCLK;	


initial
begin
	
  PCLK 		= 0    ;     // APB system clock
  PRESETn 	= 0    ;     // APB system reset
  PENABLE 	= 0    ;     // Data valid strobe 
  PSEL   	= 0    ;     // Module select signal
  PWRITE  	= 0    ;     // Write/nRead signal
  PADDR  	= 0    ;     // Address (used bits only)
  PWDATA  	= 0    ;     // Read data
  TCAP		= 0    ;
  TCLK		= 0    ;

  #600	 PRESETn	= 1;

$display ( "****************************************************");
$display ( "Timer_pwm simulation________________________________");
$display ( "____________________________________________________");

	case(`IVT)
		1'b0:  $display ( "Normal output signal");
        	1'b1:  $display ( "Output signal inverter");
	endcase

	case(`ICS)
		1'b0:  $display ( "Internal input source clock");
        	1'b1:  $display ( "External output source clock");
	endcase

	case(`OMS)
		3'd0:  $display ( "Internal mode operation");
        	3'd1:  $display ( "Match & Overflow  mode");
        	3'd2:  $display ( "PWM mode");
		3'd4:  $display ( "Capture on falling edge mode");
		3'd5:  $display ( "Capture on rising edge mode");
		3'd6:  $display ( "Capture on both edge mode");
	endcase

	case(`TEN)
		1'b0:  $display ( "Disable");
        	1'b1:  $display ( "Enable");
	endcase

	apb_write(32'h0, DAT);
	apb_write(32'h4, PRE);
	apb_write(32'hC, CNT);
	apb_write(32'h10, PWM);
	apb_write(32'h8, CON);



#900	TCAP[3] = 1'b1;
	TCAP[4] = 1'b1;
	TCAP[5] = 1'b1;

#900	TCAP[5] = 1'b0;
	TCAP[4] = 1'b0;
	TCAP[3] = 1'b0;

#100	apb_read(32'h0);
#100	apb_read(32'h4);
#100	apb_read(32'h8);
#100	apb_read(32'hC);
#100	apb_read(32'h10);

end

        // TASK for write and read 
        task apb_write; // write
                input [31:0] reg_addr;
                input [31:0] reg_write;
                begin
                        @(negedge PCLK);
                                PENABLE = 1'b0;
                        @(posedge PCLK);
			                  #2
                                PSEL = 1'b1;
                                PWRITE = 1'b1;
                                PADDR = reg_addr;
                                PWDATA = reg_write;
	
                        @(posedge PCLK)

                        #2      PENABLE = 1'b1;

                        @(posedge PCLK)

                        #2      $display($time, " << address [%h]      write data [%h] >> ", reg_addr, reg_write);
                                PENABLE = 1'b0;
                                PSEL    = 1'b0;
                                PWDATA  = 32'dz;
                end
        endtask

        task apb_read; // read
                input [31:0] reg_addr;
                begin
                        @(negedge PCLK);
                                PENABLE = 1'b0;
                        @(posedge PCLK);
                        #2      PSEL = 1'b1;
                                PWRITE = 1'b0;
                                PADDR = reg_addr;
                        @(posedge PCLK)
                        #2      PENABLE = 1'b1;
                        @(posedge PCLK)
                              $display($time, " << address [%h]      read data [%h] >> ", reg_addr, PRDATA );
                        #2        PENABLE = 1'b0;
                                PSEL = 1'b0;
                end
        endtask



timer_pwm U0_APB_Timers_EXA0
(
//APB
	.PCLK(PCLK)         ,
	.PRESETn(PRESETn)   ,
	.PENABLE(PENABLE)   ,
	.PSEL(PSEL)         ,
	.PWRITE(PWRITE)     ,
	.PADDR(PADDR[4:2])       ,
	.PWDATA(PWDATA[15:0])     ,
	.PRDATA(PRDATA)     ,

//Function
	.TCLK(TCLK)         ,
	.TCAP(TCAP[5:3])         ,
	.INT_TPOUT(INT_TPOUT)       ,
	.INT_TOF(INT_TOF)   ,
	.INT_TMC(INT_TMC)   ,


	.SCANENABLE(1'b0)       ,
	.SCANINPCLK(1'b1)       ,
	.SCANOUTPCLK()
);

endmodule

