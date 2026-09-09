/*****************************************************************

		         Timer_pwm testbench

*****************************************************************/


`timescale 1 ns/ 100ps

// define control signal ADDR = 0x00
`define	ADEN	      1'b1	
`define READ_START  1'b0
`define STBY        1'b1
`define ASEL        3'd0
`define EN_INTb     1'b0
`define FLAG        1'b0


module tb_adc_control;

  reg         PCLK        ;     // APB system clock
  reg         PRESETn     ;     // APB system reset
  reg         PENABLE     ;     // Data valid strobe 
  reg         PSEL        ;     // Module select signal
  reg         PWRITE      ;     // Write/nRead signal
  reg  [11:0] PADDR       ;     // Address (used bits only)
  reg  [31:0] PWDATA      ;     // Read data
  reg         CLK_ADCCLK  ;
  wire [31:0] PRDATA      ;     // Write data
  wire        INT_ADC     ;

  reg SCANENABLE;
  reg SCANINPCLK;
  reg SCANOUTPCLK;  

  reg AVDD    ;
  reg DVDD    ;
  reg CH0     ;
  reg CH1     ;
  reg CH2     ;
  reg CH3     ;
  reg CH4     ;
  reg CH5     ;
  reg CH6     ;
  reg CH7     ;
  reg DIFF    ; //normal = 0
  reg AVSS    ;
  reg DVSS    ;


  integer INSTRUC_CNT;

  wire  [31:0]  ADCCON  =     { 16'd0, `FLAG, `EN_INTb, 8'd0, `ASEL, `STBY, `READ_START, `ADEN };

  wire  [31:0]  ADCCON_EN00 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b000, `STBY, `READ_START, `ADEN }; 
  wire  [31:0]  ADCCON_EN01 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b001, `STBY, `READ_START, `ADEN }; 
  wire  [31:0]  ADCCON_EN02 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b010, `STBY, `READ_START, `ADEN }; 
  wire  [31:0]  ADCCON_EN03 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b011, `STBY, `READ_START, `ADEN }; 
  wire  [31:0]  ADCCON_EN04 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b100, `STBY, `READ_START, `ADEN }; 
  wire  [31:0]  ADCCON_EN05 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b101, `STBY, `READ_START, `ADEN }; 
  wire  [31:0]  ADCCON_EN06 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b110, `STBY, `READ_START, `ADEN }; 
  wire  [31:0]  ADCCON_EN07 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b111, `STBY, `READ_START, `ADEN }; 

  wire  [31:0]  ADCCON_EN08 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b111, `STBY, 1'b1, 1'b0  }; 
  wire  [31:0]  ADCCON_EN09 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b110, `STBY, 1'b1, 1'b0  };  
  wire  [31:0]  ADCCON_EN10 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b101, `STBY, 1'b1, 1'b0  };   
  wire  [31:0]  ADCCON_EN11 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b100, `STBY, 1'b1, 1'b0  };    
  wire  [31:0]  ADCCON_EN12 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b011, `STBY, 1'b1, 1'b0  };    
  wire  [31:0]  ADCCON_EN13 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b010, `STBY, 1'b1, 1'b0  };    
  wire  [31:0]  ADCCON_EN14 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b001, `STBY, 1'b1, 1'b0  };    
  wire  [31:0]  ADCCON_EN15 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b000, `STBY, 1'b1, 1'b0  };    

  wire  [31:0]  ADCCON_EN16 = { 16'd0, `FLAG, `EN_INTb, 8'd0,3'b000, 1'b1, 1'b1, 1'b0  };    

  always
	#5	PCLK = ~PCLK;	

  always
	#20	CLK_ADCCLK = ~CLK_ADCCLK;	


initial
begin
	
  PCLK 		= 0  ;     // APB system clock
  PRESETn	= 0  ;     // APB system reset
  PENABLE	= 0  ;     // Data valid strobe 
  PSEL   	= 0  ;     // Module select signal
  PWRITE 	= 0  ;     // Write/nRead signal
  PADDR  	= 0  ;     // Address (used bits only)
  PWDATA 	= 0  ;     // Read data
  CLK_ADCCLK  = 0;
  INSTRUC_CNT = 0;

  SCANENABLE    = 0;
  SCANINPCLK    = 0;
  SCANOUTPCLK   = 0;
  
  //analog input
  AVDD = 1;
  DVDD = 1;
  CH0 = 1;
  CH1 = 1;
  CH2 = 1;
  CH3 = 1;
  CH4 = 1;
  CH5 = 1;
  CH6 =1 ;
  CH7 = 1;
  DIFF=0;     //normal = 0
  AVSS = 0;
  DVSS =0;


  #600	 PRESETn	= 1;

$display ( "____________________________________________________");
$display ( "ADC Control simulation______________________________");
$display ( "____________________________________________________");

	apb_write(32'h0, ADCCON_EN00);

  INSTRUC_CNT = 1;

end

always  @(posedge PCLK)
begin
  if(INT_ADC)
  begin
    case(INSTRUC_CNT)

      0:
        begin
          apb_read(32'd4);
	        apb_write(32'h0, ADCCON_EN00);
          INSTRUC_CNT = INSTRUC_CNT + 1;
        end

      1:
        begin
          apb_read(32'd4);
	        apb_write(32'h0, ADCCON_EN01);
          INSTRUC_CNT = INSTRUC_CNT + 1;
        end

      2:
        begin
          apb_read(32'd4);
	        apb_write(32'h0, ADCCON_EN02);
          INSTRUC_CNT = INSTRUC_CNT + 1;
        end

      3:
        begin
          apb_read(32'd4);
	        apb_write(32'h0, ADCCON_EN03);
          INSTRUC_CNT = INSTRUC_CNT + 1;
        end

      4:
        begin
          apb_read(32'd4);
	        apb_write(32'h0, ADCCON_EN04);
          INSTRUC_CNT = INSTRUC_CNT + 1;
        end

      5:
        begin
          apb_read(32'd4);
	        apb_write(32'h0, ADCCON_EN05);
          INSTRUC_CNT = INSTRUC_CNT + 1;
        end

      6:
        begin
          apb_read(32'd4);
	        apb_write(32'h0, ADCCON_EN06);
          INSTRUC_CNT = INSTRUC_CNT + 1;
        end


      7:
        begin
          apb_read(32'd4);
	        apb_write(32'h0, ADCCON_EN07);
          INSTRUC_CNT = INSTRUC_CNT + 1;
        end


      8:
        begin
          apb_read(32'd4);
          $display($time, " READ START mode");
	        apb_write(32'h0, ADCCON_EN08);
          INSTRUC_CNT = INSTRUC_CNT + 1;
          apb_read(32'd4);

        end

      9:
        begin
	        apb_write(32'h0, ADCCON_EN09);
          INSTRUC_CNT = INSTRUC_CNT + 1;
          apb_read(32'd4);
        end

      10:
        begin
	        apb_write(32'h0, ADCCON_EN10);
          INSTRUC_CNT = INSTRUC_CNT + 1;
          $display($time, " ADCCON_EN09 = 0x6 Data output");
          apb_read(32'd4);
          $display($time, " READ Data from  0x00");
          apb_read(32'd0);
        end

      11:
        begin
	        apb_write(32'h0, ADCCON_EN11);
          INSTRUC_CNT = INSTRUC_CNT + 1;
          $display($time, " ADCCON_EN10 = 0x5 Data output");
          apb_read(32'd4);
          $display($time, " READ Data from  0x00");
          apb_read(32'd0);
        end

        
      12:
        begin
	        apb_write(32'h0, ADCCON_EN11);
          INSTRUC_CNT = INSTRUC_CNT + 1;
          //apb_read(32'd0);
          $display($time, " Finish");
        end

    endcase
  end
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



top_adc U0_top_adc(

    //APB interface
    .PCLK(PCLK)           , 
    .PRESETn(PRESETn)     , 
    .PENABLE(PENABLE)     , 
    .PSEL(PSEL)           , 
    .PWRITE(PWRITE)       , 
    .PADDR(PADDR[3:2])         , 
    .PWDATA(PWDATA[15:0])       , 
    .PRDATA(PRDATA)       ,
    
    .INT_ADC(INT_ADC)     ,
    .CLK_ADCCLK(CLK_ADCCLK)   ,


    //analog
    .AVDD(AVDD)  ,
    .DVDD(DVDD)  ,
    .CH0(CH0)    ,
    .CH1(CH1)    ,
    .CH2(CH2)    ,
    .CH3(CH3)    ,
    .CH4(CH4)    ,
    .CH5(CH5)    ,
    .CH6(CH6)    ,
    .CH7(CH7)    ,
    .DIFF(DIFF)    , //normal = 0
    .AVSS(AVSS)    ,
    .DVSS(DVSS)    ,

    .SCANENABLE(SCANENABLE)  , 
    .SCANINPCLK(SCANINPCLK)   , 
    .SCANOUTPCLK(SCANOUTPCLK) 

);

endmodule

