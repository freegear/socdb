/// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TBFM_DTSDI002.v
// File Revision       : 1.0
// -----------------------------------------------------------------------------
// Purpose             : Verify HW for the DTSDI002 system[BFM Model]
// --=========================================================================--

`timescale 1ns/1ps

// Top level - no I/O
module TbDTSDI002 ();

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------

// The following default frequency settings are specified. The required clock
//  period should be uncommented for use, or a new frequency specified. This
//  setting will depend on the operating frequency of the core used in the
//  system.

//  `define PERIOD 7.5 // 133.3 MHz
//  `define PERIOD 7.518 // 133.0 MHz
//  `define PERIOD 10 // 100.0 MHz
//  `define PERIOD 15 //  66.6 MHz
//  `define PERIOD 15.152 // 66.0 MHz
//  `define PERIOD 20 //  50.0 MHz
//  `define PERIOD 25 //  40.0 MHz
//  `define PERIOD 30 //  33.3 MHz
//  `define PERIOD 40 //  25.0 MHz
    `define PERIOD 13 //72Mhz[13.89]=> real 76Mhz
//    `define PERIOD 13.89 //72Mhz[13.89]
  `define PHASETIME (`PERIOD / 2)

parameter  ExtInt = 8       ; //External Interrupt
parameter  AI_Bit = 8       ; //A/D Converter AI
parameter  Data_Width = 8   ; //Bidirectional

//==============================================================================
// Instruction
//
//==============================================================================
//Internal Stimulus[FileReader]
//Power & Clock Test: BFM Sim
//EINT & HRESTN 
//defparam DTSDI002.PWCLK =1'b1 ;
//Only HRESTN
//defparam DTSDI002.PWCLK =1'b0 ;
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
// External signals
  reg                ARM_OSCi   ;        // External clock in
  reg                ARM_RESETi ;        // Power on reset input
  reg                BOOT_MODE  ;
  reg  [ExtInt-1:0]  EINT       ;
  reg  [AI_Bit-1:0]  AIN        ;
  reg                TCLK0      ;        // External Timers Clock
  reg                TCLK1      ;
  reg                TCLK2      ;
  reg                TCLK3      ;
  reg                TCLK4      ;
  reg                TCLK5      ;
  reg                TCLK6      ;
  reg                TCLK7      ;
  reg  [ExtInt-1:0]  TCAP       ;
  
  reg  [31:0] SMDATAIN;    // Data from Memory to SMC       
  
  wire [31:0] SMDATAOUT;   // Data Bus output from SMC to Memory
  wire [3:0]  nSMDATAEN;   // Tri-state I/O pad enable for the byte lanes of
                             //  external memory data bus
  wire [25:0] SMADDR;      // External Memory address bus
  wire [7:0]  SMCS;        // Memory bank Chip Select output pins
  wire [3:0]  nSMBLS;      // Memory device Byte lane enables
  wire        nSMOEN;      // Memory Output Enable 
//  External signals
//  reg         ARM_OSCi;           // External clock in
//  reg         ARM_RESETi;           // Power on reset input

// GPIO signals
  wire [7:0]  GPIN;             // Inputs                   
  wire [7:0]  GPOUT;            // Outputs                  
  wire [7:0]  nGPEN;            // Output enable            
  wire [7:0]  nGPAFEN;          // H/w ctrl enable          
  wire [7:0]  GPAFOUT;          // H/w ctrl input           
  wire [7:0]  GPAFIN;           // H/w ctrl output

// Tube signals
  wire [31:0] TubeData;         // Tube model for system messages
  wire [3:0]  TubeWriteEnable;
  wire [3:0]  TubeChipSelect;

 //Test
  reg        TEST_MODE ;
  reg        POCLK     ;
// Scan signals
  wire        SCANENABLE;       // Scan Test Mode Enable         
  wire        SCANINHCLK;       // Scan Chain Input (HCLK)
  wire        SCANOUTHCLK;      // Scan Chain Output (HCLK)
  wire        SCANINPCLK;       // Scan Chain Input (PCLK)
  wire        SCANOUTPCLK;      // Scan Chain Output (PCLK)

//DTSDI
wire [30:0] XA           ;
reg	    Douten	 ;

reg         GPAD_En0     ;
//reg         GPAD_En1     ;
reg [7:0]   GPAD_En1     ;
reg         GPAD_En2     ;
reg         GPAD_En3     ;
	
reg  [1:0]  Datain	 ;

reg  [7:0]  GPADatain0   ;
reg  [7:0]  GPADatain1   ;
reg  [7:0]  GPADatain2   ;
reg  [7:0]  GPADatain3   ;	 
 
tri  [1:0]  i_SDA	 ;
tri  [1:0]  i_SCL	 ;	

tri [7:0]   EINT_Gpio0   ;
tri [7:0]   TCAP_Gpio1   ;
tri [7:0]   PWM_Gpio2    ;
tri [7:0]   UART_Gpio3   ;

assign i_SDA = Douten ? Datain : 2'bZZ ;
assign i_SCL = Douten ? Datain : 2'bZZ ;

assign EINT_Gpio0 = GPAD_En0 ? GPADatain0 : 8'bzzzz_zzzz ;
//assign TCAP_Gpio1 = GPAD_En1 ? GPADatain1 : 8'bzzzz_zzzz ;
//ODD => Input, Even => Output
assign TCAP_Gpio1[7] = GPAD_En1[7] ? GPADatain1[7] : 1'bz ;
assign TCAP_Gpio1[6] = GPAD_En1[6] ? GPADatain1[6] : 1'bz ;
assign TCAP_Gpio1[5] = GPAD_En1[5] ? GPADatain1[5] : 1'bz ;
assign TCAP_Gpio1[4] = GPAD_En1[4] ? GPADatain1[4] : 1'bz ;
assign TCAP_Gpio1[3] = GPAD_En1[3] ? GPADatain1[3] : 1'bz ;
assign TCAP_Gpio1[2] = GPAD_En1[2] ? GPADatain1[2] : 1'bz ;
assign TCAP_Gpio1[1] = GPAD_En1[1] ? GPADatain1[1] : 1'bz ;
assign TCAP_Gpio1[0] = GPAD_En1[0] ? GPADatain1[0] : 1'bz ;

assign PWM_Gpio2  = GPAD_En2 ? GPADatain2 : 8'bzzzz_zzzz ;
assign UART_Gpio3 = GPAD_En3 ? GPADatain3 : 8'bzzzz_zzzz ;


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

`include "./task_dtsdi.v"
 DTSDI002Top  DTSDI002Top  
    ( 
   
     .ARM_OSCi      (ARM_OSCi   ),
     .ARM_RESETi    (ARM_RESETi ),
     .BOOT_MODE     (BOOT_MODE  ),
     .EINT          (EINT       ),
     .AIN           (AIN        ),
     
     
     .TCLK0         (TCLK0      ),
     .TCLK1         (TCLK1      ),
     .TCLK2         (TCLK2      ),
     .TCLK3         (TCLK3      ),
     .TCLK4         (TCLK4      ),
     .TCLK5         (TCLK5      ),
     .TCLK6         (TCLK6      ),
     .TCLK7         (TCLK7      ),
     .TCAP          (TCAP       ),
     //I2C
     .I2C0_SCL      (i_SCL      ),
     .I2C0_SDA      (i_SDA      ),
     
     //Gpio
     .EINT_Gpio0     (EINT_Gpio0 ),
     .TCAP_Gpio1     (TCAP_Gpio1 ),
     .PWM_Gpio2      (PWM_Gpio2  ),
     .UART_Gpio3     (UART_Gpio3 ),

     .SMDATAIN    (SMDATAIN),
     .SMDATAOUT   (SMDATAOUT),
     .nSMDATAEN   (nSMDATAEN ),
     .SMADDR      (SMADDR),
     .SMCS        (SMCS),
     .nSMBLS      (nSMBLS),
     .nSMOEN      (nSMOEN),

     .TESTREQA    (TESTREQA),
     .TESTREQB    (TESTREQB),
     .TESTACK     (TESTACK),
     
     .ARM_TRST    (ARM_TRST ),
     .ARM_TCK     (ARM_TCK  ),
     .ARM_TDI     (ARM_TDI  ),
     .ARM_TMS     (ARM_TMS  ),
     .ARM_TDO     (ARM_TDO  ),

     .COMMRX      (COMMRX),
     .COMMTX      (COMMTX),

     .GPIN        (GPIN),
     .GPOUT       (GPOUT),
     .nGPEN       (nGPEN),
     .nGPAFEN     (nGPAFEN),
     .GPAFOUT     (GPAFOUT),
     .GPAFIN      (GPAFIN),

     //TEST
     .TEST_MODE   (TEST_MODE),
     // Scan test dummy signals; not connected until scan insertion
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINHCLK),  // Scan Chain Input (HCLK)
     .SCANOUTHCLK (SCANOUTHCLK), // Scan Chain Output (HCLK)
     .SCANINPCLK  (SCANINPCLK),  // Scan Chain Input (PCLK)
     .SCANOUTPCLK (SCANOUTPCLK)  // Scan Chain Output (PCLK)
    );
      

// Write to GPIO data register with bit 7 high to write to Tube.
// TubeData(7) is tied low, which implies that not all ASCII codes can be 
// written to the Tube. However 00-7F does cover all alpha-numeric characters
// and control codes
  assign TubeData[31:7] = {25{1'b0}};
  assign TubeData[6:0] = GPOUT[6:0];
  
  assign TubeChipSelect = 4'b0000;             // Tube always selected
  assign TubeWriteEnable = {3'b000,GPOUT[7]};  // Tube uses XWEN(0)
  
// GPIO inputs unused
  assign GPIN    = {8{1'b0}};
  assign nGPAFEN = {8{1'b1}};
  assign GPAFOUT = {8{1'b0}};

// Scan signals unused
  assign SCANENABLE = 1'b0;
  assign SCANINHCLK = 1'b0;
  assign SCANINPCLK = 1'b0;  

//ADD
 assign XA[30:26] = {5{1'b0}};


// This controls the clock generation for the system
  always 
    begin : p_ClockGenComb
      ARM_OSCi <= 1'b0;
      #`PHASETIME;
      ARM_OSCi <= 1'b1;
      #`PHASETIME;
    end

//External Timers Clock
  always 
    begin : p_TCLK0Gen 
      TCLK0 <= 1'b0;
      #(`PHASETIME*20);
      TCLK0 <= 1'b1;
      #(`PHASETIME*20);
    end


  always 
    begin : p_TCLK1Gen 
      TCLK1 <= 1'b0;
      #(`PHASETIME*40);
      TCLK1 <= 1'b1;
      #(`PHASETIME*40);
    end  
    
    
  always 
    begin : p_TCLK2Gen 
      TCLK2 <= 1'b0;
      #(`PHASETIME*45);
      TCLK2 <= 1'b1;
      #(`PHASETIME*45);
    end  

  always 
    begin : p_TCLK3Gen 
      TCLK3 <= 1'b0;
      #(`PHASETIME*80);
      TCLK3 <= 1'b1;
      #(`PHASETIME*80);
    end  

  always 
    begin : p_TCLK4Gen 
      TCLK4 <= 1'b0;
      #(`PHASETIME*120);
      TCLK4 <= 1'b1;
      #(`PHASETIME*120);
    end  
    
    
   always 
    begin : p_TCLK5Gen 
      TCLK5 <= 1'b0;
      #(`PHASETIME*160);
      TCLK5 <= 1'b1;
      #(`PHASETIME*160);
    end     
    
  
    always 
    begin : p_TCLK6Gen 
      TCLK6 <= 1'b0;
      #(`PHASETIME*180);
      TCLK6 <= 1'b1;
      #(`PHASETIME*180);
    end        
    
      always 
    begin : p_TCLK7Gen 
      TCLK7 <= 1'b0;
      #(`PHASETIME*200);
      TCLK7 <= 1'b1;
      #(`PHASETIME*200);
    end  
    
    
// This controls the timing of the Reset signal.
// The loop values should be changed for different reset timing
  initial
    begin : p_RstComb
      ARM_RESETi <= 1'b0;
      begin : reset_loop
        integer i;
        for (i = 1; i <= 20; i = i + 1)
          @ (ARM_OSCi);
      end
      ARM_RESETi <= #1 1'b1; // Hold time for ResetCntl SyncPOR register
     //Power & Clock Management
     /*
       #(`PERIOD*100000);
      ARM_RESETi <= #1 1'b0;
      #(`PERIOD*200);
      ARM_RESETi <= #1 1'b1;
      */   
       end

//Internal Stimulus
//Power & Clock Test: BFM Sim
//defparam DTSDI002.PWCLK =1'b1 ;
//defparam DTSDI002.PWCLK =1'b0 ;
//External Stimulus
initial begin
INIT            ;
//Power & Clock Test
EINT_push (8'd0) ;
//EINT_push(8'd1) ;

//A/D Converter
AIN_Push (8'd1) ;

//Gpio Test
Gpio_EINT(8'hAA);
Gpio_TCAP(8'hBB);
Gpio_PWM (8'hCC);
Gpio_UART(8'hDD);

end
  
always 				
begin : p_TCAP
       #(`PHASETIME*500); 
      TCAP = 8'h00 ;
      #(`PHASETIME*500);
      TCAP = 8'hFF ;
      #(`PHASETIME*500);
      TCAP = 8'h00 ;
      #(`PHASETIME*500);
      TCAP = 8'h38 ;
       #(`PHASETIME*500);      
end 

//vcd gen
// initial begin
//    $dumpfile("EASY_IMAGE.vcd");
//    $dumpvars;
//    end

//initial begin
//$shm_open("graphic.shm");
//$shm_probe(TBEasy_FRBM,"AC");
//end

//ADD 
//if you want make stimulus *.frd , block bellow sentence 
//initial begin
//$shm_open("graphic.shm");
//$shm_probe("AC");
//end

 
endmodule

//  --================================= End ==================================--


