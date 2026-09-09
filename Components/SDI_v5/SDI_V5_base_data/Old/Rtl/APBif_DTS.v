// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APBif_DTS.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose            : Converts AHB peripheral transfers to APB transfers
//  --========================================================================--
// APB address map is:
//
// 0x01FF_8200 - 0x01FF_8300 UART                          (PSELS2)  
// 0x01FF_8300 - 0x01FF_8400 I2C0~1                        (PSELS3)
// 0x01FF_8400 - 0x01FF_8500 Timer 0  ~ 7                  (PSELS4)
// 0x01FF_8500 - 0x01FF_8600 PWM   0  ~ 7                  (PSELS5)  
// 0x01FF_8600 - 0x01FF_8700 PWM   8  ~ 15                 (PSELS6)
// 0x01FF_8700 - 0x01FF_8800 PWM   16 ~ 23                 (PSELS7)  
// 0x01FF_8800 - 0x01FF_8900 PWM   24 ~ 31                 (PSELS8) 
// 0x01FF_8900 - 0x01FF_8A00 WDT                           (PSELS9)
// 0x01FF_8A00 - 0x01FF_8B00 GPIO                          (PSELS10)
// 0x01FF_8B00 - 0x01FF_8C00 VIV                           (PSELS11)
// 0x01FF_8C00 - 0x01FF_8D00 ADC IF                        (PSELS12)
// 0x01FF_8D00 - 0x01FF_8E00 Power manager                 (PSELS13)

`timescale 1ns/1ps

module APBif_DTS
  (
   // AHB interface
   HCLK,
   HRESETn,
   HADDR,
   HTRANS,
   HWRITE,
   HWDATA,
   HSEL,
   HREADY,

   HRDATA,
   HREADYOUT,
   HRESP,

   // APB interface
   PRDATA,

   PWDATA,
   PENABLE,
   PSELS0,
   PSELS1,
   PSELS2,
   PSELS3,
   //Timers
  // PSELS4,
   PSELS4X0,
   PSELS4X1,
   PSELS4X2,
   PSELS4X3,
   PSELS4X4,
   PSELS4X5,
   PSELS4X6,
   PSELS4X7,
   
   //PSELS5,
   
   PSELS5X0 , //PWM0_0 ~ PWM0_7
   PSELS5X1 ,
   PSELS5X2 ,
   PSELS5X3 ,
   PSELS5X4 ,
   PSELS5X5 ,
   PSELS5X6 ,
   PSELS5X7 ,
   
  // PSELS6,
   PSELS6X0 , //PWM1_0 ~ PWM1_7
   PSELS6X1 ,
   PSELS6X2 ,
   PSELS6X3 ,
   PSELS6X4 ,
   PSELS6X5 ,
   PSELS6X6 ,
   PSELS6X7 , 
      
   //PSELS7,
   PSELS7X0 , //PWM2_0 ~ PWM2_7
   PSELS7X1 ,
   PSELS7X2 ,
   PSELS7X3 ,
   PSELS7X4 ,
   PSELS7X5 ,
   PSELS7X6 ,
   PSELS7X7 , 
      
   //PSELS8,
   PSELS8X0 , //PWM3_0 ~ PWM3_7
   PSELS8X1 ,
   PSELS8X2 ,
   PSELS8X3 ,
   PSELS8X4 ,
   PSELS8X5 ,
   PSELS8X6 ,
   PSELS8X7 , 
   
   PSELS9,
   PSELS10,
   PSELS11,
   PSELS12, //ADC
   PSELS13, //Power Manager
   //PSELS14,
   //PSELS15,
   PADDR,
   PWRITE,
   
   // Scan test dummy signals; not connected until scan insertion 
   SCANENABLE,   // Scan Test Mode Enbl
   SCANINHCLK,   // Scan Chain Input   
   SCANOUTHCLK   // Scan Chain Output      
   );
    
    
  input         HCLK;
  input         HRESETn;
  input  [31:0] HADDR;
  input  [1:0]  HTRANS;
  input         HWRITE;
  input  [31:0] HWDATA;
  input         HSEL;
  input         HREADY;

  input         SCANENABLE;
  input         SCANINHCLK;

  output [31:0] HRDATA;
  output        HREADYOUT;
  output [1:0]  HRESP;

  output        SCANOUTHCLK;

  input  [31:0] PRDATA;

  output [31:0] PWDATA;
  output        PENABLE;
  output        PSELS0;
  output        PSELS1;
  output        PSELS2;
  output        PSELS3;
  
 // output        PSELS4   ; //Timers
  output        PSELS4X0 ;
  output        PSELS4X1 ;
  output        PSELS4X2 ;
  output        PSELS4X3 ;
  output        PSELS4X4 ;
  output        PSELS4X5 ;
  output        PSELS4X6 ;
  output        PSELS4X7 ;
  
  //output        PSELS5;
  output        PSELS5X0 ; //PWM0_0 ~ PWM0_7
  output        PSELS5X1 ;
  output        PSELS5X2 ;
  output        PSELS5X3 ;
  output        PSELS5X4 ;
  output        PSELS5X5 ;
  output        PSELS5X6 ;
  output        PSELS5X7 ;
  
  //output        PSELS6;
  output        PSELS6X0 ; //PWM1_0 ~ PWM1_7
  output        PSELS6X1 ;
  output        PSELS6X2 ;
  output        PSELS6X3 ;
  output        PSELS6X4 ;
  output        PSELS6X5 ;
  output        PSELS6X6 ;
  output        PSELS6X7 ;
  
  //output        PSELS7;
  output        PSELS7X0 ;//PWM2_0 ~ PWM2_7
  output        PSELS7X1 ;
  output        PSELS7X2 ;
  output        PSELS7X3 ;
  output        PSELS7X4 ;
  output        PSELS7X5 ;
  output        PSELS7X6 ;
  output        PSELS7X7 ;
 
  //output        PSELS8;
  output        PSELS8X0 ;//PWM3_0 ~ PWM3_7
  output        PSELS8X1 ;
  output        PSELS8X2 ;
  output        PSELS8X3 ;
  output        PSELS8X4 ;
  output        PSELS8X5 ;
  output        PSELS8X6 ;
  output        PSELS8X7 ;
  
  
  
  output        PSELS9;
  output        PSELS10;
  output        PSELS11;
  output        PSELS12;
  output        PSELS13;
  //output        PSELS14;
  //output        PSELS15;
  output [11:0] PADDR;
  //output [7:0] PADDR;
  output        PWRITE;

// Block Overview
//
//   The 16-Slot APB Bridge provides an interface between the high-speed AHB 
// domain and the low-power APB domain. The Bridge appears as a slave on AHB, 
// whereas on APB, it is the master. Read and write transfers on the AHB are 
// converted into corresponding transfers on the APB. As the APB is not 
// pipelined, wait states are added during transfers to and from the APB when 
// the AHB is required to wait for the APB protocol.
//
// The AHB to APB Bridge comprises of a state machine, which is used to control
// the generation of the APB and AHB output signals, and the address decoding 
// logic which is used to generate the APB peripheral select lines. 
// All registers used in the system are clocked from the rising edge of the 
// system clock HCLK, and use the asynchronous reset HRESETn. 
//
// APBIF states:
//  ST_IDLE     is APB bus idle state entered on reset
//  ST_READ     is read setup
//  ST_RENABLE  is read enable
//  ST_WWAIT    is write wait state
//  ST_WRITE    is write setup
//  ST_WENABLE  is write enable
//  ST_WRITEP   is write setup with pending transfer
//  ST_WENABLEP is write enable with pending transfer

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
  `define ST_IDLE 4'b0000
  `define ST_READ 4'b0001
  `define ST_RENABLE 4'b0100
  `define ST_WWAIT 4'b1001
  `define ST_WRITE 4'b1010
  `define ST_WENABLE 4'b1110
  `define ST_WRITEP 4'b1011
  `define ST_WENABLEP 4'b1111

// EASY Peripherals address decoding values:
//HADDR[11:8]0x01FF_8200 ~ 0x01FF_8E00 
//Example:GPIO:0x01FF_8A00 ~ 0x01FF_8AFF :A:1010
  `define S0BASE  4'b0000
  `define S1BASE  4'b0001
  `define S2BASE  4'b0010
  `define S3BASE  4'b0011
  `define S4BASE  4'b0100 //0x01FF_8400~0x01FF_8400
  `define S5BASE  4'b0101
  `define S6BASE  4'b0110
  `define S7BASE  4'b0111
  `define S8BASE  4'b1000
  `define S9BASE  4'b1001
  `define S10BASE 4'b1010
  `define S11BASE 4'b1011
  `define S12BASE 4'b1100
  `define S13BASE 4'b1101
  `define S14BASE 4'b1110
  `define S15BASE 4'b1111

//Sub Address[Timers]
//0.==0001_0000 :0x00 ~ 0x10
//1.==0011_0000 :0x20 ~ 0x30
//2.==0101_0000 :0x40 ~ 0x50
//3.==0110_0000 :0x60 ~ 0x70
//4.==1001_0000 :0x80 ~ 0x90
//5.==1011_0000 :0xA0 ~ 0xB0
//6.==1101_0000 :0xC0 ~ 0xD0
//7.==1111_0000 :0xE0 ~ 0xF0

  `define SubADD0 3'b000 //0x00 HADDR[7:5]
  `define SubADD1 3'b001 //0x20 HADDR[7:5]
  `define SubADD2 3'b010 //0x40 HADDR[7:5]
  `define SubADD3 3'b011 //0x60 HADDR[7:5]
  `define SubADD4 3'b100 //0x80 HADDR[7:5]
  `define SubADD5 3'b101 //0xA0 HADDR[7:5]
  `define SubADD6 3'b110 //0xC0 HADDR[7:5]
  `define SubADD7 3'b111 //0xE0 HADDR[7:5]
  
  
    

// HTRANS transfer type signal encoding:
  `define TRN_IDLE 2'b00
  `define TRN_BUSY 2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ 2'b11

// HRESP transfer response signal encoding:
  `define RSP_OKAY 2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  
// Input/Output Signals
  wire        HCLK;
  wire        HRESETn;
  wire [31:0] HADDR;
  wire [1:0]  HTRANS;
  wire        HWRITE;
  wire [31:0] HWDATA;
  wire        HSEL;
  wire        HREADY;
  wire        SCANENABLE;
  wire        SCANINHCLK;
  wire [31:0] PRDATA;
  wire [31:0] HRDATA;
  wire        HREADYOUT;
  wire [1:0]  HRESP;
  wire        SCANOUTHCLK;
  wire        PSELS0;
  wire        PSELS1;
  wire        PSELS2;
  wire        PSELS3;
 
  wire        PSELS4   ;
  wire        PSELS4X0 ; //Timers
  wire        PSELS4X1 ;
  wire        PSELS4X2 ;
  wire        PSELS4X3 ;
  wire        PSELS4X4 ;
  wire        PSELS4X5 ;
  wire        PSELS4X6 ;
  wire        PSELS4X7 ;
  
  wire        PSELS5X0 ;//PWM0_0 ~ PWM0_7
  wire        PSELS5X1 ;
  wire        PSELS5X2 ;
  wire        PSELS5X3 ;
  wire        PSELS5X4 ;
  wire        PSELS5X5 ;
  wire        PSELS5X6 ;
  wire        PSELS5X7 ;
  
  wire        PSELS6X0 ;//PWM1_0 ~ PWM1_7
  wire        PSELS6X1 ;
  wire        PSELS6X2 ;
  wire        PSELS6X3 ;
  wire        PSELS6X4 ;
  wire        PSELS6X5 ;
  wire        PSELS6X6 ;
  wire        PSELS6X7 ;
  
  wire        PSELS7X0 ;//PWM2_0 ~ PWM2_7
  wire        PSELS7X1 ;
  wire        PSELS7X2 ;
  wire        PSELS7X3 ;
  wire        PSELS7X4 ;
  wire        PSELS7X5 ;
  wire        PSELS7X6 ;
  wire        PSELS7X7 ;
 
  wire        PSELS8X0 ;//PWM3_0 ~ PWM3_7
  wire        PSELS8X1 ;
  wire        PSELS8X2 ;
  wire        PSELS8X3 ;
  wire        PSELS8X4 ;
  wire        PSELS8X5 ;
  wire        PSELS8X6 ;
  wire        PSELS8X7 ;
  
  wire        PSELS5;
  wire        PSELS6;
  wire        PSELS7;
  wire        PSELS8;
  wire        PSELS9;
  wire        PSELS10;
  wire        PSELS11;
  wire        PSELS12;
  wire        PSELS13;
  wire        PSELS14;
  wire        PSELS15;
  
 // reg  [7:0] PADDR;
  reg  [11:0] PADDR;
  reg  [31:0] PWDATA;        // Registered APB outputs
  reg         PENABLE;
  reg         PWRITE;

// Internal Signals
  
  wire        Valid;         // Module is selected with valid transfer 
  wire        ACRegEn;       // Enable for address and control registers 
 // reg  [27:0] HaddrReg;      // HADDR register 
  reg  [11:0] HaddrReg;      // HADDR register 
  reg         HwriteReg;     // HWRITE register 
  wire [11:0] HaddrMux;      // HADDR multiplexer 

  reg  [3:0]  NextState;     // State machine 
  reg  [3:0]  CurrentState;

  wire        HreadyNext;    // HREADYOUT register input 
  reg         iHREADYOUT;    // HREADYOUT register 

  reg         PselS0Int;     // Internal PSELS0 
  reg         PselS1Int;     // Internal PSELS1 
  reg         PselS2Int;     // Internal PSELS2 
  reg         PselS3Int;     // Internal PSELS3 
  //Timers
  reg         PselS4Int;     // Internal PSELS4
   
  reg         PselS4IntX0 ; //Timers0
  reg         PselS4IntX1 ; 
  reg         PselS4IntX2 ; //Timers2
  reg         PselS4IntX3 ; 
  reg         PselS4IntX4 ; //Timers4
  reg         PselS4IntX5 ; 
  reg         PselS4IntX6 ; //Timers6
  reg         PselS4IntX7 ; 
  
  reg         PselS5IntX0 ; //PWM0_0 ~PWM0_7
  reg         PselS5IntX1 ; 
  reg         PselS5IntX2 ;    
  reg         PselS5IntX3 ; 
  reg         PselS5IntX4 ;    
  reg         PselS5IntX5 ; 
  reg         PselS5IntX6 ;    
  reg         PselS5IntX7 ;
  
  reg         PselS6IntX0 ; //PWM1_0 ~PWM1_7
  reg         PselS6IntX1 ; 
  reg         PselS6IntX2 ;    
  reg         PselS6IntX3 ; 
  reg         PselS6IntX4 ;    
  reg         PselS6IntX5 ; 
  reg         PselS6IntX6 ;    
  reg         PselS6IntX7 ;
   
  reg         PselS7IntX0 ; //PWM2_0 ~PWM2_7
  reg         PselS7IntX1 ; 
  reg         PselS7IntX2 ;    
  reg         PselS7IntX3 ; 
  reg         PselS7IntX4 ;    
  reg         PselS7IntX5 ; 
  reg         PselS7IntX6 ;    
  reg         PselS7IntX7 ;
  
  reg         PselS8IntX0 ; //PWM3_0 ~PWM3_7
  reg         PselS8IntX1 ; 
  reg         PselS8IntX2 ;    
  reg         PselS8IntX3 ; 
  reg         PselS8IntX4 ;    
  reg         PselS8IntX5 ; 
  reg         PselS8IntX6 ;    
  reg         PselS8IntX7 ;
  
  reg         PselS5Int;     // Internal PSELS5 
  reg         PselS6Int;     // Internal PSELS6 
  reg         PselS7Int;     // Internal PSELS7 
  reg         PselS8Int;     // Internal PSELS8 
  reg         PselS9Int;     // Internal PSELS9 
  reg         PselS10Int;    // Internal PSELS10 
  reg         PselS11Int;    // Internal PSELS11 
  reg         PselS12Int;    // Internal PSELS12 
  reg         PselS13Int;    // Internal PSELS13 
  reg         PselS14Int;    // Internal PSELS14 
  reg         PselS15Int;    // Internal PSELS15 

  wire        APBEn;         // Enable for APB output registers 

  wire        PWDATAEn;      // PWDATA Register enable 
  wire        PenableNext;   // PENABLE register input 

  reg         PselS0Mux;     // PSEL multiplexer values 
  reg         PselS1Mux;
  reg         PselS2Mux;
  reg         PselS3Mux;

  reg         PselS4Mux  ;
  
  reg         PselS4Mux0 ;   //Timers
  reg         PselS4Mux1 ;
  reg         PselS4Mux2 ;
  reg         PselS4Mux3 ;
  reg         PselS4Mux4 ;
  reg         PselS4Mux5 ;
  reg         PselS4Mux6 ;
  reg         PselS4Mux7 ;
  
  
  reg         PselS5Mux;
  
  reg         PselS5Mux0 ; //PWM0_0 ~PWM0_7
  reg         PselS5Mux1 ;
  reg         PselS5Mux2 ;
  reg         PselS5Mux3 ;
  reg         PselS5Mux4 ;
  reg         PselS5Mux5 ;
  reg         PselS5Mux6 ;
  reg         PselS5Mux7 ;
  
  
  reg         PselS6Mux;
  
  reg         PselS6Mux0 ; //PWM1_0 ~PWM1_7
  reg         PselS6Mux1 ;
  reg         PselS6Mux2 ;
  reg         PselS6Mux3 ;
  reg         PselS6Mux4 ;
  reg         PselS6Mux5 ;
  reg         PselS6Mux6 ;
  reg         PselS6Mux7 ;
  
  
  reg         PselS7Mux;
  
  reg         PselS7Mux0 ; //PWM2_0 ~PWM2_7
  reg         PselS7Mux1 ;
  reg         PselS7Mux2 ;
  reg         PselS7Mux3 ;
  reg         PselS7Mux4 ;
  reg         PselS7Mux5 ;
  reg         PselS7Mux6 ;
  reg         PselS7Mux7 ;
  
  reg         PselS8Mux;
  
  reg         PselS8Mux0 ; //PWM3_0 ~PWM3_7
  reg         PselS8Mux1 ;
  reg         PselS8Mux2 ;
  reg         PselS8Mux3 ;
  reg         PselS8Mux4 ;
  reg         PselS8Mux5 ;
  reg         PselS8Mux6 ;
  reg         PselS8Mux7 ;
    
  reg         PselS9Mux;
  reg         PselS10Mux;
  reg         PselS11Mux;
  reg         PselS12Mux;
  reg         PselS13Mux;
  reg         PselS14Mux;
  reg         PselS15Mux;

  reg         iPSELS0;       //  Internal PSEL outputs 
  reg         iPSELS1;
  reg         iPSELS2;
  reg         iPSELS3;
  
  reg         iPSELS4   ;
  
  reg         iPSELS4X0 ;//Timers
  reg         iPSELS4X1 ;
  reg         iPSELS4X2 ;
  reg         iPSELS4X3 ;
  reg         iPSELS4X4 ;
  reg         iPSELS4X5 ;
  reg         iPSELS4X6 ;
  reg         iPSELS4X7 ; 
  
  reg         iPSELS5;
  
  reg         iPSELS5X0 ;//PWM0_0 ~ PWM0_7
  reg         iPSELS5X1 ;
  reg         iPSELS5X2 ;
  reg         iPSELS5X3 ;
  reg         iPSELS5X4 ;
  reg         iPSELS5X5 ;
  reg         iPSELS5X6 ;
  reg         iPSELS5X7 ; 
  
  reg         iPSELS6;
  
  reg         iPSELS6X0 ;//PWM1_0 ~ PWM1_7
  reg         iPSELS6X1 ;
  reg         iPSELS6X2 ;
  reg         iPSELS6X3 ;
  reg         iPSELS6X4 ;
  reg         iPSELS6X5 ;
  reg         iPSELS6X6 ;
  reg         iPSELS6X7 ; 
    
  reg         iPSELS7;
  
  reg         iPSELS7X0 ;//PWM2_0 ~ PWM2_7
  reg         iPSELS7X1 ;
  reg         iPSELS7X2 ;
  reg         iPSELS7X3 ;
  reg         iPSELS7X4 ;
  reg         iPSELS7X5 ;
  reg         iPSELS7X6 ;
  reg         iPSELS7X7 ; 
    
  reg         iPSELS8;
  
  reg         iPSELS8X0 ;//PWM3_0 ~ PWM3_7
  reg         iPSELS8X1 ;
  reg         iPSELS8X2 ;
  reg         iPSELS8X3 ;
  reg         iPSELS8X4 ;
  reg         iPSELS8X5 ;
  reg         iPSELS8X6 ;
  reg         iPSELS8X7 ; 
      
  reg         iPSELS9;
  reg         iPSELS10;
  reg         iPSELS11;
  reg         iPSELS12;
  reg         iPSELS13;
  reg         iPSELS14;
  reg         iPSELS15;

  reg         PwriteNext;    //  PWRITE register input 


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Valid transfer detection
//------------------------------------------------------------------------------
// Valid AHB transfers only take place when a non-sequential or sequential
//  transfer is shown on HTRANS - an idle or busy transfer should be ignored.

  assign Valid = ((HSEL == 1'b1 && HREADY == 1'b1 && 
                  (HTRANS == `TRN_NONSEQ || HTRANS == `TRN_SEQ)) ? 1'b1 :
                 1'b0);

//------------------------------------------------------------------------------
// Address and control registers
//------------------------------------------------------------------------------
// Registers are used to store the address and control signals from the address
//  phase for use in the data phase of the transfer.
// Only enabled when the HREADY input is HIGH and the module is addressed.

  assign ACRegEn = HSEL & HREADY;

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_ACRegSeq
      if ((!HRESETn))
        begin 
          //HaddrReg <= {28{1'b0}};
          HaddrReg <= {12{1'b0}};
          HwriteReg <= 1'b0;
        end
      else
        begin
          if (ACRegEn)
            begin 
              HaddrReg <= HADDR[11:0];
              HwriteReg <= HWRITE;
            end 
        end 
    end 

// The address source used depends on the source of the current APB transfer. If
//  the transfer is being generated from:
// - the pipeline registers, then the address source is HaddrReg
// - the AHB inputs, the the address source is HADDR.
//
// The HaddrMux multiplexer is used to select the appropriate address source. A
//  new read, sequential read following another read, or a read following a
//  write with no pending transfer are the only transfers that are generated
//  directly from the AHB inputs. All other transfers are generated from the
//  pipeline registers.
  
  assign HaddrMux = ((NextState == `ST_READ &&
                      (CurrentState == `ST_IDLE || 
                       CurrentState == `ST_RENABLE || 
                       //CurrentState == `ST_WENABLE)) ? HADDR :
                       CurrentState == `ST_WENABLE)) ? HADDR[11:0] :
                    HaddrReg);

//------------------------------------------------------------------------------
// Next state logic for APB state machine
//------------------------------------------------------------------------------
// Generates next state from CurrentState and AHB inputs.
// Due to write transfers having an extra setup state, the pending states are
//  used to indicate that there is a transfer in the pipeline that has not been
//  started on the APB.
// Read transfers start immediately, so pending states are not needed.

  always @ (CurrentState or HWRITE or HwriteReg or Valid)
    begin : p_NextStateComb

      case (CurrentState)
        `ST_IDLE :                 // Idle state
          if (Valid)
            if (HWRITE)
              NextState = `ST_WWAIT;
            else
              NextState = `ST_READ;
          else
            NextState = `ST_IDLE;
   
        `ST_READ :                 // Read setup
          NextState = `ST_RENABLE;

        `ST_WWAIT :                // Hold for one cycle before write
          if (Valid)
            NextState = `ST_WRITEP;
          else
            NextState = `ST_WRITE;
   
        `ST_WRITE :                // Write setup
          if (Valid)
            NextState = `ST_WENABLEP;
          else
            NextState = `ST_WENABLE;
   
        `ST_WRITEP :               // Write setup with pending transfer
          NextState = `ST_WENABLEP;

        `ST_RENABLE :              // Read enable
          if (Valid)
            if (HWRITE)
              NextState = `ST_WWAIT;
            else
              NextState = `ST_READ;
          else
            NextState = `ST_IDLE;
   
        `ST_WENABLE :              // Write enable
          if (Valid)
            if (HWRITE)
              NextState = `ST_WWAIT;
            else
              NextState = `ST_READ;
          else
            NextState = `ST_IDLE;
   
        `ST_WENABLEP :             // Write enable with pending transfer
          if (HwriteReg)
            if (Valid)
              NextState = `ST_WRITEP;
            else
              NextState = `ST_WRITE;
          else
            NextState = `ST_READ;
   
        default  :
          NextState = `ST_IDLE;    // Return to idle on FSM error

      endcase
    end 

//------------------------------------------------------------------------------
// State machine
//------------------------------------------------------------------------------
// Changes state on rising edge of HCLK.
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_CurrentStateSeq
      if ((!HRESETn))
        CurrentState <= `ST_IDLE;
      else
        CurrentState <= NextState;
    end 

//------------------------------------------------------------------------------
// HREADYOUT generation
//------------------------------------------------------------------------------
// A registered version of HREADYOUT is used to improve output timing.
// Wait states are inserted during:
//  ST_READ   
//  ST_WRITEP
//  ST_WENABLEP when the currently pending transfer is a read, or
//              when the currently driven AHB transfer is a read.

  assign HreadyNext = ((NextState == `ST_READ || NextState == `ST_WRITEP ||
                        (NextState == `ST_WENABLEP &&
                         (HWRITE == 1'b0 || HwriteReg == 1'b0))) ? 1'b0 :
                      1'b1);

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_iHREADYOUTSeq
      if ((!HRESETn))
        iHREADYOUT <= 1'b1;
      else
        iHREADYOUT <= HreadyNext;
    end 

//------------------------------------------------------------------------------
// APB address decoding for slave devices
//------------------------------------------------------------------------------
// Decodes the address from HaddrMux, which only changes during a read or write
//  cycle.
// When an address is used that is not in any of the ranges specified,
//  operation of the system continues, but no PSEL lines are set, so no
//  peripherals are selected during the read/write transfer.
// Operation of PWDATA, PWRITE, PENABLE and PADDR continues as normal.

  always @ (HaddrMux)
    begin : p_AddressDecodeComb
      // Default values
      PselS0Int = 1'b0;
      PselS1Int = 1'b0;
      PselS2Int = 1'b0;
      PselS3Int = 1'b0;
      PselS4Int = 1'b0;
      PselS5Int = 1'b0;
      PselS6Int = 1'b0;
      PselS7Int = 1'b0;
      PselS8Int = 1'b0;
      PselS9Int = 1'b0;
      PselS10Int = 1'b0;
      PselS11Int = 1'b0;
      PselS12Int = 1'b0;
      PselS13Int = 1'b0;
      PselS14Int = 1'b0;
      PselS15Int = 1'b0;

      case (HaddrMux[11:8])
        `S0BASE : 
          PselS0Int = 1'b1;

        `S1BASE :
           PselS1Int = 1'b1;    

        `S2BASE : 
          PselS2Int = 1'b1;

        `S3BASE : 
          PselS3Int = 1'b1;

        `S4BASE :
          PselS4Int = 1'b1;
          
        `S5BASE : 
          PselS5Int = 1'b1;

        `S6BASE : 
          PselS6Int = 1'b1;

        `S7BASE : 
          PselS7Int = 1'b1;

        `S8BASE : 
          PselS8Int = 1'b1;

        `S9BASE : 
          PselS9Int = 1'b1;

        `S10BASE : 
          PselS10Int = 1'b1;

        `S11BASE : 
          PselS11Int = 1'b1;

        `S12BASE : 
          PselS12Int = 1'b1;

        `S13BASE : 
          PselS13Int = 1'b1;

        `S14BASE : 
          PselS14Int = 1'b1;

        `S15BASE : 
          PselS15Int = 1'b1;
       
      endcase
    end 


//Timer0
 always @ (PselS4Int or HaddrMux)
  begin : p_Timers_SEL0
  PselS4IntX0 = 1'b0 ;
if ( (PselS4Int) && (HaddrMux[7:5]== `SubADD0))
                PselS4IntX0 = 1'b1 ;
           else PselS4IntX0 = 1'b0 ;    
            end

//Timer1
 always @ (PselS4Int or HaddrMux)
  begin : p_Timers_SEL1
  PselS4IntX1 = 1'b0 ;
if ( (PselS4Int) && (HaddrMux[7:5]== `SubADD1))
                PselS4IntX1 = 1'b1 ;
           else PselS4IntX1 = 1'b0 ;    
            end
            
//Timer2
 always @ (PselS4Int or HaddrMux)
  begin : p_Timers_SEL2
  PselS4IntX2 = 1'b0 ;
if ( (PselS4Int) && (HaddrMux[7:5]== `SubADD2))
                PselS4IntX2 = 1'b1 ;
           else PselS4IntX2 = 1'b0 ;    
            end
                        
//Timer3
 always @ (PselS4Int or HaddrMux)
  begin : p_Timers_SEL3
  PselS4IntX3 = 1'b0 ;
if ( (PselS4Int) && (HaddrMux[7:5]== `SubADD3))
                PselS4IntX3 = 1'b1 ;
           else PselS4IntX3 = 1'b0 ;    
            end            

//Timer4
 always @ (PselS4Int or HaddrMux)
  begin : p_Timers_SEL4
  PselS4IntX4 = 1'b0 ;
if ( (PselS4Int) && (HaddrMux[7:5]== `SubADD4))
                PselS4IntX4 = 1'b1 ;
           else PselS4IntX4 = 1'b0 ;    
            end

//Timer5
 always @ (PselS4Int or HaddrMux)
  begin : p_Timers_SEL5
  PselS4IntX5 = 1'b0 ;
if ( (PselS4Int) && (HaddrMux[7:5]== `SubADD5))
                PselS4IntX5 = 1'b1 ;
           else PselS4IntX5 = 1'b0 ;    
            end

//Timer6
 always @ (PselS4Int or HaddrMux)
  begin : p_Timers_SEL6
  PselS4IntX6 = 1'b0 ;
if ( (PselS4Int) && (HaddrMux[7:5]== `SubADD6))
                PselS4IntX6 = 1'b1 ;
           else PselS4IntX6 = 1'b0 ;    
            end


//Timer7
 always @ (PselS4Int or HaddrMux)
  begin : p_Timers_SEL7
  PselS4IntX7 = 1'b0 ;
if ( (PselS4Int) && (HaddrMux[7:5]== `SubADD7))
                PselS4IntX7 = 1'b1 ;
           else PselS4IntX7 = 1'b0 ;    
            end

//===============================================================
// PWM0_0 ~ PWM0_7
//===============================================================

//PWM0_0
 always @ (PselS5Int or HaddrMux)
  begin : p_PWM0_0
  PselS5IntX0 = 1'b0 ;
if ( (PselS5Int) && (HaddrMux[7:5]== `SubADD0))
                PselS5IntX0 = 1'b1 ;
           else PselS5IntX0 = 1'b0 ;    
            end

//PWM0_1
 always @ (PselS5Int or HaddrMux)
  begin : p_PWM0_1
  PselS5IntX1 = 1'b0 ;
if ( (PselS5Int) && (HaddrMux[7:5]== `SubADD1))
                PselS5IntX1 = 1'b1 ;
           else PselS5IntX1 = 1'b0 ;    
            end
                                    

//PWM0_2
 always @ (PselS5Int or HaddrMux)
  begin : p_PWM0_2
  PselS5IntX2 = 1'b0 ;
if ( (PselS5Int) && (HaddrMux[7:5]== `SubADD2))
                PselS5IntX2 = 1'b1 ;
           else PselS5IntX2 = 1'b0 ;    
            end

//PWM0_3
 always @ (PselS5Int or HaddrMux)
  begin : p_PWM0_3
  PselS5IntX3 = 1'b0 ;
if ( (PselS5Int) && (HaddrMux[7:5]== `SubADD3))
                PselS5IntX3 = 1'b1 ;
           else PselS5IntX3 = 1'b0 ;    
            end

//PWM0_4
 always @ (PselS5Int or HaddrMux)
  begin : p_PWM0_4
  PselS5IntX4 = 1'b0 ;
if ( (PselS5Int) && (HaddrMux[7:5]== `SubADD4))
                PselS5IntX4 = 1'b1 ;
           else PselS5IntX4 = 1'b0 ;    
            end

//PWM0_5
 always @ (PselS5Int or HaddrMux)
  begin : p_PWM0_5
  PselS5IntX5 = 1'b0 ;
if ( (PselS5Int) && (HaddrMux[7:5]== `SubADD5))
                PselS5IntX5 = 1'b1 ;
           else PselS5IntX5 = 1'b0 ;    
            end
                           
//PWM0_6
 always @ (PselS5Int or HaddrMux)
  begin : p_PWM0_6
  PselS5IntX6 = 1'b0 ;
if ( (PselS5Int) && (HaddrMux[7:5]== `SubADD6))
                PselS5IntX6 = 1'b1 ;
           else PselS5IntX6 = 1'b0 ;    
            end

//PWM0_7
 always @ (PselS5Int or HaddrMux)
  begin : p_PWM0_7
  PselS5IntX7 = 1'b0 ;
if ( (PselS5Int) && (HaddrMux[7:5]== `SubADD7))
                PselS5IntX7 = 1'b1 ;
           else PselS5IntX7 = 1'b0 ;    
            end

//===============================================================
// PWM1_0 ~ PWM1_7
//===============================================================

//PWM1_0
 always @ (PselS5Int or HaddrMux)
  begin : p_PWM1_0
  PselS6IntX0 = 1'b0 ;
if ( (PselS6Int) && (HaddrMux[7:5]== `SubADD0))
                PselS6IntX0 = 1'b1 ;
           else PselS6IntX0 = 1'b0 ;    
            end

//PWM1_1
 always @ (PselS6Int or HaddrMux)
  begin : p_PWM1_1
  PselS6IntX1 = 1'b0 ;
if ( (PselS6Int) && (HaddrMux[7:5]== `SubADD1))
                PselS6IntX1 = 1'b1 ;
           else PselS6IntX1 = 1'b0 ;    
            end
                                    

//PWM1_2
 always @ (PselS6Int or HaddrMux)
  begin : p_PWM1_2
  PselS6IntX2 = 1'b0 ;
if ( (PselS6Int) && (HaddrMux[7:5]== `SubADD2))
                PselS6IntX2 = 1'b1 ;
           else PselS6IntX2 = 1'b0 ;    
            end

//PWM1_3
 always @ (PselS6Int or HaddrMux)
  begin : p_PWM1_3
  PselS6IntX3 = 1'b0 ;
if ( (PselS6Int) && (HaddrMux[7:5]== `SubADD3))
                PselS6IntX3 = 1'b1 ;
           else PselS6IntX3 = 1'b0 ;    
            end

//PWM1_4
 always @ (PselS6Int or HaddrMux)
  begin : p_PWM1_4
  PselS6IntX4 = 1'b0 ;
if ( (PselS6Int) && (HaddrMux[7:5]== `SubADD4))
                PselS6IntX4 = 1'b1 ;
           else PselS6IntX4 = 1'b0 ;    
            end

//PWM1_5
 always @ (PselS6Int or HaddrMux)
  begin : p_PWM1_5
  PselS6IntX5 = 1'b0 ;
if ( (PselS6Int) && (HaddrMux[7:5]== `SubADD5))
                PselS6IntX5 = 1'b1 ;
           else PselS6IntX5 = 1'b0 ;    
            end
                           
//PWM1_6
 always @ (PselS6Int or HaddrMux)
  begin : p_PWM1_6
  PselS6IntX6 = 1'b0 ;
if ( (PselS6Int) && (HaddrMux[7:5]== `SubADD6))
                PselS6IntX6 = 1'b1 ;
           else PselS6IntX6 = 1'b0 ;    
            end

//PWM1_7
 always @ (PselS6Int or HaddrMux)
  begin : p_PWM1_7
  PselS6IntX7 = 1'b0 ;
if ( (PselS6Int) && (HaddrMux[7:5]== `SubADD7))
                PselS6IntX7 = 1'b1 ;
           else PselS6IntX7 = 1'b0 ;    
            end

//===============================================================
// PWM2_0 ~ PWM2_7
//===============================================================

//PWM2_0
 always @ (PselS7Int or HaddrMux)
  begin : p_PWM2_0
  PselS7IntX0 = 1'b0 ;
if ( (PselS7Int) && (HaddrMux[7:5]== `SubADD0))
                PselS7IntX0 = 1'b1 ;
           else PselS7IntX0 = 1'b0 ;    
            end

//PWM2_1
 always @ (PselS7Int or HaddrMux)
  begin : p_PWM2_1
  PselS7IntX1 = 1'b0 ;
if ( (PselS7Int) && (HaddrMux[7:5]== `SubADD1))
                PselS7IntX1 = 1'b1 ;
           else PselS7IntX1 = 1'b0 ;    
            end
                                    

//PWM2_2
 always @ (PselS7Int or HaddrMux)
  begin : p_PWM2_2
  PselS7IntX2 = 1'b0 ;
if ( (PselS7Int) && (HaddrMux[7:5]== `SubADD2))
                PselS7IntX2 = 1'b1 ;
           else PselS7IntX2 = 1'b0 ;    
            end

//PWM2_3
 always @ (PselS7Int or HaddrMux)
  begin : p_PWM2_3
  PselS7IntX3 = 1'b0 ;
if ( (PselS7Int) && (HaddrMux[7:5]== `SubADD3))
                PselS7IntX3 = 1'b1 ;
           else PselS7IntX3 = 1'b0 ;    
            end

//PWM2_4
 always @ (PselS7Int or HaddrMux)
  begin : p_PWM2_4
  PselS7IntX4 = 1'b0 ;
if ( (PselS7Int) && (HaddrMux[7:5]== `SubADD4))
                PselS7IntX4 = 1'b1 ;
           else PselS7IntX4 = 1'b0 ;    
            end

//PWM2_5
 always @ (PselS7Int or HaddrMux)
  begin : p_PWM2_5
  PselS7IntX5 = 1'b0 ;
if ( (PselS7Int) && (HaddrMux[7:5]== `SubADD5))
                PselS7IntX5 = 1'b1 ;
           else PselS7IntX5 = 1'b0 ;    
            end
                           
//PWM2_6
 always @ (PselS7Int or HaddrMux)
  begin : p_PWM2_6
  PselS7IntX6 = 1'b0 ;
if ( (PselS7Int) && (HaddrMux[7:5]== `SubADD6))
                PselS7IntX6 = 1'b1 ;
           else PselS7IntX6 = 1'b0 ;    
            end

//PWM2_7
 always @ (PselS7Int or HaddrMux)
  begin : p_PWM2_7
  PselS7IntX7 = 1'b0 ;
if ( (PselS7Int) && (HaddrMux[7:5]== `SubADD7))
                PselS7IntX7 = 1'b1 ;
           else PselS7IntX7 = 1'b0 ;    
            end


//===============================================================
// PWM3_0 ~ PWM3_7
//===============================================================

//PWM3_0
 always @ (PselS8Int or HaddrMux)
  begin : p_PWM3_0
  PselS8IntX0 = 1'b0 ;
if ( (PselS8Int) && (HaddrMux[7:5]== `SubADD0))
                PselS8IntX0 = 1'b1 ;
           else PselS8IntX0 = 1'b0 ;    
            end

//PWM3_1
 always @ (PselS8Int or HaddrMux)
  begin : p_PWM3_1
  PselS8IntX1 = 1'b0 ;
if ( (PselS8Int) && (HaddrMux[7:5]== `SubADD1))
                PselS8IntX1 = 1'b1 ;
           else PselS8IntX1 = 1'b0 ;    
            end
                                    

//PWM3_2
 always @ (PselS8Int or HaddrMux)
  begin : p_PWM3_2
  PselS8IntX2 = 1'b0 ;
if ( (PselS8Int) && (HaddrMux[7:5]== `SubADD2))
                PselS8IntX2 = 1'b1 ;
           else PselS8IntX2 = 1'b0 ;    
            end

//PWM3_3
 always @ (PselS8Int or HaddrMux)
  begin : p_PWM3_3
  PselS8IntX3 = 1'b0 ;
if ( (PselS8Int) && (HaddrMux[7:5]== `SubADD3))
                PselS8IntX3 = 1'b1 ;
           else PselS8IntX3 = 1'b0 ;    
            end

//PWM3_4
 always @ (PselS8Int or HaddrMux)
  begin : p_PWM3_4
  PselS8IntX4 = 1'b0 ;
if ( (PselS8Int) && (HaddrMux[7:5]== `SubADD4))
                PselS8IntX4 = 1'b1 ;
           else PselS8IntX4 = 1'b0 ;    
            end

//PWM3_5
 always @ (PselS8Int or HaddrMux)
  begin : p_PWM3_5
  PselS8IntX5 = 1'b0 ;
if ( (PselS8Int) && (HaddrMux[7:5]== `SubADD5))
                PselS8IntX5 = 1'b1 ;
           else PselS8IntX5 = 1'b0 ;    
            end
                           
//PWM3_6
 always @ (PselS8Int or HaddrMux)
  begin : p_PWM3_6
  PselS8IntX6 = 1'b0 ;
if ( (PselS8Int) && (HaddrMux[7:5]== `SubADD6))
                PselS8IntX6 = 1'b1 ;
           else PselS8IntX6 = 1'b0 ;    
            end

//PWM3_7
 always @ (PselS8Int or HaddrMux)
  begin : p_PWM3_7
  PselS8IntX7 = 1'b0 ;
if ( (PselS8Int) && (HaddrMux[7:5]== `SubADD7))
                PselS8IntX7 = 1'b1 ;
           else PselS8IntX7 = 1'b0 ;    
            end

                                    
//------------------------------------------------------------------------------
// APB enable generation
//------------------------------------------------------------------------------
// APBEn is set when starting an access on the APB, and is used to enable the
//  PSEL, PWRITE and PADDR APB output registers.
  
  assign APBEn = ((NextState == `ST_READ || NextState == `ST_WRITE || 
                   NextState == `ST_WRITEP) ? 1'b1 : 
                 1'b0);

//------------------------------------------------------------------------------
// Registered HWDATA for writes (PWDATA)
//------------------------------------------------------------------------------
// Write wait state allows a register to be used to hold PWDATA.
// Register enabled when PWRITE output is set HIGH.

  assign PWDATAEn = PwriteNext;

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_PWDATASeq
      if ((!HRESETn))
        PWDATA <= {32{1'b0}};
      else
        begin
          if (PWDATAEn)
            PWDATA <= HWDATA;
        end
    end 

//------------------------------------------------------------------------------
// PENABLE generation
//------------------------------------------------------------------------------
// PENABLE output is set HIGH during any of the three ENABLE states.

  assign PenableNext = ((NextState == `ST_RENABLE || 
                         NextState == `ST_WENABLE || 
                         NextState == `ST_WENABLEP) ? 1'b1 :
                       1'b0);

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_PENABLESeq
      if ((!HRESETn))
        PENABLE <= 1'b0;
      else
        PENABLE <= PenableNext;
    end 

//------------------------------------------------------------------------------
// iPSEL generation
//------------------------------------------------------------------------------
// Set   outputs with internal values when in READ or WRITE states (APBEn HIGH).
// Reset outputs when APB transfer has ended.
// Hold  outputs at all other times.

  always @ (APBEn or NextState or PselS0Int or PselS1Int or PselS2Int or 
            PselS3Int or PselS4Int or PselS5Int or PselS6Int or 
            PselS7Int or PselS8Int or PselS9Int or PselS10Int or 
            PselS11Int or PselS12Int or PselS13Int or PselS14Int or 
            PselS15Int or iPSELS0 or iPSELS1 or iPSELS2 or iPSELS3 or 
            iPSELS4 or iPSELS5 or iPSELS6 or iPSELS7 or iPSELS8 or 
            iPSELS9 or iPSELS10 or iPSELS11 or iPSELS12 or iPSELS13 or 
            iPSELS14 or iPSELS15 or
            //Timers
            PselS4IntX0 or PselS4IntX1 or PselS4IntX2 or PselS4IntX3 or 
            PselS4IntX4 or PselS4IntX5 or PselS4IntX6 or PselS4IntX7 or
            
            iPSELS4X0 or iPSELS4X1 or iPSELS4X2 or iPSELS4X3 or
            iPSELS4X4 or iPSELS4X5 or iPSELS4X6 or iPSELS4X7 or
            
            //PWM0_0 ~ PWM0_7
            PselS5IntX0 or PselS5IntX1 or PselS5IntX2 or PselS5IntX3 or
            PselS5IntX4 or PselS5IntX5 or PselS5IntX6 or PselS5IntX7 or

            iPSELS5X0 or iPSELS5X1 or iPSELS5X2 or iPSELS5X3 or
            iPSELS5X4 or iPSELS5X5 or iPSELS5X6 or iPSELS5X7 or

            //PWM1_0 ~ PWM1_7                                             
            PselS6IntX0 or PselS6IntX1 or PselS6IntX2 or PselS6IntX3 or   
            PselS6IntX4 or PselS6IntX5 or PselS6IntX6 or PselS6IntX7 or   
                                                                          
            iPSELS6X0 or iPSELS6X1 or iPSELS6X2 or iPSELS6X3 or           
            iPSELS6X4 or iPSELS6X5 or iPSELS6X6 or iPSELS6X7 or           
                                                                          
            //PWM2_0 ~ PWM2_7                                             
            PselS7IntX0 or PselS7IntX1 or PselS7IntX2 or PselS7IntX3 or   
            PselS7IntX4 or PselS7IntX5 or PselS7IntX6 or PselS7IntX7 or   
                                                                          
            iPSELS7X0 or iPSELS7X1 or iPSELS7X2 or iPSELS7X3 or           
            iPSELS7X4 or iPSELS7X5 or iPSELS7X6 or iPSELS7X7 or           
                                                                          
            //PWM3_0 ~ PWM3_7                                             
            PselS8IntX0 or PselS8IntX1 or PselS8IntX2 or PselS8IntX3 or   
            PselS8IntX4 or PselS8IntX5 or PselS8IntX6 or PselS8IntX7 or   
                                                                          
            iPSELS8X0 or iPSELS8X1 or iPSELS8X2 or iPSELS8X3 or           
            iPSELS8X4 or iPSELS8X5 or iPSELS8X6 or iPSELS8X7              
             
             )
    begin : p_PselMuxComb
      if (APBEn)
        begin 
          PselS0Mux  = PselS0Int;
          PselS1Mux  = PselS1Int;
          PselS2Mux  = PselS2Int;
          PselS3Mux  = PselS3Int;
          //Timers   
          PselS4Mux  = PselS4Int;
          
          PselS4Mux0 = PselS4IntX0; 
          PselS4Mux1 = PselS4IntX1; 
          PselS4Mux2 = PselS4IntX2; 
          PselS4Mux3 = PselS4IntX3; 
          PselS4Mux4 = PselS4IntX4; 
          PselS4Mux5 = PselS4IntX5; 
          PselS4Mux6 = PselS4IntX6; 
          PselS4Mux7 = PselS4IntX7; 
          
          PselS5Mux  = PselS5Int;
          
          PselS5Mux0 = PselS5IntX0; //PWM0_0 ~ PWM0_7
          PselS5Mux1 = PselS5IntX1; 
          PselS5Mux2 = PselS5IntX2; 
          PselS5Mux3 = PselS5IntX3; 
          PselS5Mux4 = PselS5IntX4; 
          PselS5Mux5 = PselS5IntX5; 
          PselS5Mux6 = PselS5IntX6; 
          PselS5Mux7 = PselS5IntX7; 
          
          PselS6Mux  = PselS6Int;
          
          PselS6Mux0 = PselS6IntX0; //PWM1_0 ~ PWM1_7
          PselS6Mux1 = PselS6IntX1; 
          PselS6Mux2 = PselS6IntX2; 
          PselS6Mux3 = PselS6IntX3; 
          PselS6Mux4 = PselS6IntX4; 
          PselS6Mux5 = PselS6IntX5; 
          PselS6Mux6 = PselS6IntX6; 
          PselS6Mux7 = PselS6IntX7; 
          
          PselS7Mux  = PselS7Int;
         
          PselS7Mux0 = PselS7IntX0 ; //PWM2_0 ~ PWM2_7
          PselS7Mux1 = PselS7IntX1 ; 
          PselS7Mux2 = PselS7IntX2 ; 
          PselS7Mux3 = PselS7IntX3 ; 
          PselS7Mux4 = PselS7IntX4 ; 
          PselS7Mux5 = PselS7IntX5 ; 
          PselS7Mux6 = PselS7IntX6 ; 
          PselS7Mux7 = PselS7IntX7 ; 
         
          PselS8Mux  = PselS8Int   ;
          
          PselS8Mux0 = PselS8IntX0 ; //PWM3_0 ~ PWM3_7
          PselS8Mux1 = PselS8IntX1 ; 
          PselS8Mux2 = PselS8IntX2 ; 
          PselS8Mux3 = PselS8IntX3 ; 
          PselS8Mux4 = PselS8IntX4 ; 
          PselS8Mux5 = PselS8IntX5 ; 
          PselS8Mux6 = PselS8IntX6 ; 
          PselS8Mux7 = PselS8IntX7 ; 
                            
          PselS9Mux  = PselS9Int;
          PselS10Mux = PselS10Int;
          PselS11Mux = PselS11Int;
          PselS12Mux = PselS12Int;
          PselS13Mux = PselS13Int;
          PselS14Mux = PselS14Int;
          PselS15Mux = PselS15Int;
        end
          else if ((NextState == `ST_IDLE || NextState == `ST_WWAIT))
            begin 
              PselS0Mux  = 1'b0;
              PselS1Mux  = 1'b0;
              PselS2Mux  = 1'b0;
              PselS3Mux  = 1'b0;
              //Timers
              PselS4Mux  = 1'b0;
              
              PselS4Mux0 = 1'b0;
              PselS4Mux1 = 1'b0;
              PselS4Mux2 = 1'b0;
              PselS4Mux3 = 1'b0;
              PselS4Mux4 = 1'b0;
              PselS4Mux5 = 1'b0;
              PselS4Mux6 = 1'b0;
              PselS4Mux7 = 1'b0;
              
              PselS5Mux  = 1'b0;
              
              PselS5Mux0 = 1'b0; //PWM0_0 ~ PWM0_7
              PselS5Mux1 = 1'b0;
              PselS5Mux2 = 1'b0;
              PselS5Mux3 = 1'b0;
              PselS5Mux4 = 1'b0;
              PselS5Mux5 = 1'b0;
              PselS5Mux6 = 1'b0;
              PselS5Mux7 = 1'b0;
                            
              
              PselS6Mux  = 1'b0;
              
              PselS6Mux0 = 1'b0; //PWM1_0 ~ PWM1_7
              PselS6Mux1 = 1'b0;
              PselS6Mux2 = 1'b0;
              PselS6Mux3 = 1'b0;
              PselS6Mux4 = 1'b0;
              PselS6Mux5 = 1'b0;
              PselS6Mux6 = 1'b0;
              PselS6Mux7 = 1'b0;
              
              PselS7Mux  = 1'b0;
              
              PselS7Mux0 = 1'b0; //PWM2_0 ~ PWM2_7
              PselS7Mux1 = 1'b0;
              PselS7Mux2 = 1'b0;
              PselS7Mux3 = 1'b0;
              PselS7Mux4 = 1'b0;
              PselS7Mux5 = 1'b0;
              PselS7Mux6 = 1'b0;
              PselS7Mux7 = 1'b0;
              
              PselS8Mux  = 1'b0;
              
              PselS8Mux0 = 1'b0; //PWM3_0 ~ PWM3_7
              PselS8Mux1 = 1'b0;
              PselS8Mux2 = 1'b0;
              PselS8Mux3 = 1'b0;
              PselS8Mux4 = 1'b0;
              PselS8Mux5 = 1'b0;
              PselS8Mux6 = 1'b0;
              PselS8Mux7 = 1'b0;
              
              
              
              
              PselS9Mux  = 1'b0;
              PselS10Mux = 1'b0;
              PselS11Mux = 1'b0;
              PselS12Mux = 1'b0;
              PselS13Mux = 1'b0;
              PselS14Mux = 1'b0;
              PselS15Mux = 1'b0;
            end
          else
            begin
              PselS0Mux  = iPSELS0   ;
              PselS1Mux  = iPSELS1   ;
              PselS2Mux  = iPSELS2   ;
              PselS3Mux  = iPSELS3   ;
              
              //Timers  
              PselS4Mux  = iPSELS4   ;
              
              PselS4Mux0 = iPSELS4X0 ;
              PselS4Mux1 = iPSELS4X1 ;
              PselS4Mux2 = iPSELS4X2 ;
              PselS4Mux3 = iPSELS4X3 ;
              PselS4Mux4 = iPSELS4X4 ;
              PselS4Mux5 = iPSELS4X5 ;
              PselS4Mux6 = iPSELS4X6 ;
              PselS4Mux7 = iPSELS4X7 ;
              
              PselS5Mux  = iPSELS5   ;
              
              PselS5Mux0 = iPSELS5X0 ; //PWM0_0 ~ PWM0_7
              PselS5Mux1 = iPSELS5X1 ;
              PselS5Mux2 = iPSELS5X2 ;
              PselS5Mux3 = iPSELS5X3 ;
              PselS5Mux4 = iPSELS5X4 ;
              PselS5Mux5 = iPSELS5X5 ;
              PselS5Mux6 = iPSELS5X6 ;
              PselS5Mux7 = iPSELS5X7 ;
              
              PselS6Mux  = iPSELS6   ;
              
              PselS6Mux0 = iPSELS6X0 ; //PWM1_0 ~ PWM1_7
              PselS6Mux1 = iPSELS6X1 ;
              PselS6Mux2 = iPSELS6X2 ;
              PselS6Mux3 = iPSELS6X3 ;
              PselS6Mux4 = iPSELS6X4 ;
              PselS6Mux5 = iPSELS6X5 ;
              PselS6Mux6 = iPSELS6X6 ;
              PselS6Mux7 = iPSELS6X7 ;
              
              PselS7Mux  = iPSELS7;
              
              PselS7Mux0 = iPSELS7X0 ; //PWM2_0 ~ PWM2_7
              PselS7Mux1 = iPSELS7X1 ;
              PselS7Mux2 = iPSELS7X2 ;
              PselS7Mux3 = iPSELS7X3 ;
              PselS7Mux4 = iPSELS7X4 ;
              PselS7Mux5 = iPSELS7X5 ;
              PselS7Mux6 = iPSELS7X6 ;
              PselS7Mux7 = iPSELS7X7 ;
              
              PselS8Mux  = iPSELS8;
              
              PselS8Mux0 = iPSELS8X0 ; //PWM3_0 ~ PWM3_7
              PselS8Mux1 = iPSELS8X1 ;
              PselS8Mux2 = iPSELS8X2 ;
              PselS8Mux3 = iPSELS8X3 ;
              PselS8Mux4 = iPSELS8X4 ;
              PselS8Mux5 = iPSELS8X5 ;
              PselS8Mux6 = iPSELS8X6 ;
              PselS8Mux7 = iPSELS8X7 ;
              
              PselS9Mux  = iPSELS9   ;
              PselS10Mux = iPSELS10  ;
              PselS11Mux = iPSELS11  ;
              PselS12Mux = iPSELS12  ;
              PselS13Mux = iPSELS13  ;
              PselS14Mux = iPSELS14  ;
              PselS15Mux = iPSELS15  ;
            end 
    end 
 
// Drives PSEL outputs with internal multiplexer versions.

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_PSELSeq
      if ((!HRESETn))
        begin 
          iPSELS0  <= 1'b0;
          iPSELS1  <= 1'b0;
          iPSELS2  <= 1'b0;
          iPSELS3  <= 1'b0;
          //Timers
          iPSELS4   <= 1'b0;
          
          iPSELS4X0 <= 1'b0;
          iPSELS4X1 <= 1'b0;
          iPSELS4X2 <= 1'b0;
          iPSELS4X3 <= 1'b0;
          iPSELS4X4 <= 1'b0;
          iPSELS4X5 <= 1'b0;
          iPSELS4X6 <= 1'b0;
          iPSELS4X7 <= 1'b0;
           
   
          iPSELS5  <= 1'b0;
          
          iPSELS5X0 <= 1'b0;  //PWM0_0 ~ PWM0_7
          iPSELS5X1 <= 1'b0;
          iPSELS5X2 <= 1'b0;
          iPSELS5X3 <= 1'b0;
          iPSELS5X4 <= 1'b0;
          iPSELS5X5 <= 1'b0;
          iPSELS5X6 <= 1'b0;
          iPSELS5X7 <= 1'b0;
          
          iPSELS6  <= 1'b0;
          
          iPSELS6X0 <= 1'b0;  //PWM1_0 ~ PWM1_7
          iPSELS6X1 <= 1'b0;
          iPSELS6X2 <= 1'b0;
          iPSELS6X3 <= 1'b0;
          iPSELS6X4 <= 1'b0;
          iPSELS6X5 <= 1'b0;
          iPSELS6X6 <= 1'b0;
          iPSELS6X7 <= 1'b0;
          
          iPSELS7  <= 1'b0;
          
          iPSELS7X0 <= 1'b0;  //PWM2_0 ~ PWM2_7
          iPSELS7X1 <= 1'b0;
          iPSELS7X2 <= 1'b0;
          iPSELS7X3 <= 1'b0;
          iPSELS7X4 <= 1'b0;
          iPSELS7X5 <= 1'b0;
          iPSELS7X6 <= 1'b0;
          iPSELS7X7 <= 1'b0;
          
          iPSELS8  <= 1'b0;
          
          iPSELS8X0 <= 1'b0;  //PWM3_0 ~ PWM3_7
          iPSELS8X1 <= 1'b0;
          iPSELS8X2 <= 1'b0;
          iPSELS8X3 <= 1'b0;
          iPSELS8X4 <= 1'b0;
          iPSELS8X5 <= 1'b0;
          iPSELS8X6 <= 1'b0;
          
          iPSELS9  <= 1'b0;
          iPSELS10 <= 1'b0;
          iPSELS11 <= 1'b0;
          iPSELS12 <= 1'b0;
          iPSELS13 <= 1'b0;
          iPSELS14 <= 1'b0;
          iPSELS15 <= 1'b0;
        end
      else
        begin
          iPSELS0  <= PselS0Mux;
          iPSELS1  <= PselS1Mux;
          iPSELS2  <= PselS2Mux;
          iPSELS3  <= PselS3Mux;
          //Timers
          iPSELS4   <= PselS4Mux  ;
          
          iPSELS4X0 <= PselS4Mux0 ;
          iPSELS4X1 <= PselS4Mux1 ;
          iPSELS4X2 <= PselS4Mux2 ;
          iPSELS4X3 <= PselS4Mux3 ;
          iPSELS4X4 <= PselS4Mux4 ;
          iPSELS4X5 <= PselS4Mux5 ;
          iPSELS4X6 <= PselS4Mux6 ;
          iPSELS4X7 <= PselS4Mux7 ;
          
          
          iPSELS5  <= PselS5Mux;
          
          iPSELS5X0 <= PselS5Mux0 ; //PWM0_0 ~ PWM0_7
          iPSELS5X1 <= PselS5Mux1 ;
          iPSELS5X2 <= PselS5Mux2 ;
          iPSELS5X3 <= PselS5Mux3 ;
          iPSELS5X4 <= PselS5Mux4 ;
          iPSELS5X5 <= PselS5Mux5 ;
          iPSELS5X6 <= PselS5Mux6 ;
          iPSELS5X7 <= PselS5Mux7 ;
          
          iPSELS6  <= PselS6Mux;
         
          iPSELS6X0 <= PselS6Mux0 ; //PWM1_0 ~ PWM1_7
          iPSELS6X1 <= PselS6Mux1 ;
          iPSELS6X2 <= PselS6Mux2 ;
          iPSELS6X3 <= PselS6Mux3 ;
          iPSELS6X4 <= PselS6Mux4 ;
          iPSELS6X5 <= PselS6Mux5 ;
          iPSELS6X6 <= PselS6Mux6 ;
          iPSELS6X7 <= PselS6Mux7 ;
          
          iPSELS7  <= PselS7Mux;
          
          iPSELS7X0 <= PselS7Mux0 ; //PWM2_0 ~ PWM2_7
          iPSELS7X1 <= PselS7Mux1 ;
          iPSELS7X2 <= PselS7Mux2 ;
          iPSELS7X3 <= PselS7Mux3 ;
          iPSELS7X4 <= PselS7Mux4 ;
          iPSELS7X5 <= PselS7Mux5 ;
          iPSELS7X6 <= PselS7Mux6 ;
          iPSELS7X7 <= PselS7Mux7 ;
          
          iPSELS8  <= PselS8Mux;
          
          iPSELS8X0 <= PselS8Mux0 ; //PWM3_0 ~ PWM3_7
          iPSELS8X1 <= PselS8Mux1 ;
          iPSELS8X2 <= PselS8Mux2 ;
          iPSELS8X3 <= PselS8Mux3 ;
          iPSELS8X4 <= PselS8Mux4 ;
          iPSELS8X5 <= PselS8Mux5 ;
          iPSELS8X6 <= PselS8Mux6 ;
          iPSELS8X7 <= PselS8Mux7 ;
          
          iPSELS9  <= PselS9Mux;
          iPSELS10 <= PselS10Mux;
          iPSELS11 <= PselS11Mux;
          iPSELS12 <= PselS12Mux;
          iPSELS13 <= PselS13Mux;
          iPSELS14 <= PselS14Mux;
          iPSELS15 <= PselS15Mux;
        end 
    end 

//------------------------------------------------------------------------------
// Registered HADDR for reads and writes (iPADDR)
//------------------------------------------------------------------------------
// HaddrMux is used, as the generation time of the APB address is different for
//  reads and writes, so both the direct and registered HADDR input need to be
//  used.
// HaddrMux is captured by an APBEn enabled register to generate iPADDR.
// PADDR driven on State Machine change to READ or WRITE, with reset to zero.

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_iPADDRSeq
      if ((!HRESETn))
        PADDR <= {12{1'b0}};
      //PADDR <= {8{1'b0}};
      else
        begin
          if (APBEn)
            PADDR <= HaddrMux[11:0];
           //PADDR <= HaddrMux[7:0]; 
        end 
    end 

//------------------------------------------------------------------------------
// PWRITE generation
//------------------------------------------------------------------------------
// PwriteNext is active when NextState is either ST_WRITE or ST_WRITEP. To avoid
//  a critical path through the main state machine this signal is generated 
//  using CurrentState.
// PwriteNext is captured by an APBEn enabled register to generate PWRITE, and
//  is generated from NextState (set HIGH during a write cycle).
// PWRITE output only changes when APB is accessed.

  always @ (CurrentState or HwriteReg)
    begin : p_PwriteNextComb
      case (CurrentState)
        `ST_WWAIT :
          PwriteNext = 1'b1;

        `ST_WENABLEP : begin
          if (HwriteReg)
            PwriteNext = 1'b1;
          else
            PwriteNext = 1'b0;
        end

        default: 
          PwriteNext = 1'b0;
      endcase
    end 

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_PWRITESeq
      if ((!HRESETn))
        PWRITE <= 1'b0;
      else
        begin
          if (APBEn)
            PWRITE <= PwriteNext;
        end 
    end 

//------------------------------------------------------------------------------
// APB output drivers
//------------------------------------------------------------------------------
// Drive outputs with internal signals.

  assign PSELS0  = iPSELS0;
  assign PSELS1  = iPSELS1;
  assign PSELS2  = iPSELS2;
  assign PSELS3  = iPSELS3;
  //Timers
  assign PSELS4   = iPSELS4   ;
  
  assign PSELS4X0 = iPSELS4X0 ; 
  assign PSELS4X1 = iPSELS4X1 ; 
  assign PSELS4X2 = iPSELS4X2 ; 
  assign PSELS4X3 = iPSELS4X3 ; 
  assign PSELS4X4 = iPSELS4X4 ; 
  assign PSELS4X5 = iPSELS4X5 ; 
  assign PSELS4X6 = iPSELS4X6 ; 
  assign PSELS4X7 = iPSELS4X7 ; 
  
  assign PSELS5  = iPSELS5;
  
  assign PSELS5X0 = iPSELS5X0 ; //PWM0_0 ~ PWM0_7 
  assign PSELS5X1 = iPSELS5X1 ; 
  assign PSELS5X2 = iPSELS5X2 ; 
  assign PSELS5X3 = iPSELS5X3 ; 
  assign PSELS5X4 = iPSELS5X4 ; 
  assign PSELS5X5 = iPSELS5X5 ; 
  assign PSELS5X6 = iPSELS5X6 ; 
  assign PSELS5X7 = iPSELS5X7 ; 
  
  assign PSELS6  = iPSELS6;
 
  assign PSELS6X0 = iPSELS6X0 ; //PWM1_0 ~ PWM1_7 
  assign PSELS6X1 = iPSELS6X1 ; 
  assign PSELS6X2 = iPSELS6X2 ; 
  assign PSELS6X3 = iPSELS6X3 ; 
  assign PSELS6X4 = iPSELS6X4 ; 
  assign PSELS6X5 = iPSELS6X5 ; 
  assign PSELS6X6 = iPSELS6X6 ; 
  assign PSELS6X7 = iPSELS6X7 ; 
 
  assign PSELS7  = iPSELS7;
 
  assign PSELS7X0 = iPSELS7X0 ; //PWM2_0 ~ PWM2_7 
  assign PSELS7X1 = iPSELS7X1 ; 
  assign PSELS7X2 = iPSELS7X2 ; 
  assign PSELS7X3 = iPSELS7X3 ; 
  assign PSELS7X4 = iPSELS7X4 ; 
  assign PSELS7X5 = iPSELS7X5 ; 
  assign PSELS7X6 = iPSELS7X6 ; 
  assign PSELS7X7 = iPSELS7X7 ; 
 
  assign PSELS8  = iPSELS8;
 
  assign PSELS8X0 = iPSELS8X0 ; //PWM2_0 ~ PWM2_7 
  assign PSELS8X1 = iPSELS8X1 ; 
  assign PSELS8X2 = iPSELS8X2 ; 
  assign PSELS8X3 = iPSELS8X3 ; 
  assign PSELS8X4 = iPSELS8X4 ; 
  assign PSELS8X5 = iPSELS8X5 ; 
  assign PSELS8X6 = iPSELS8X6 ; 
  assign PSELS8X7 = iPSELS8X7 ; 
 
  assign PSELS9  = iPSELS9;
  assign PSELS10 = iPSELS10;
  assign PSELS11 = iPSELS11;
  assign PSELS12 = iPSELS12;
  assign PSELS13 = iPSELS13;
  assign PSELS14 = iPSELS14;
  assign PSELS15 = iPSELS15;

//------------------------------------------------------------------------------
// AHB output drivers
//------------------------------------------------------------------------------
// PRDATA is only ever driven during a read, so it can be directly copied to
//  HRDATA to reduce the output data delay onto the AHB.

  assign HRDATA = PRDATA;

// Drives the output port with the internal version, and sets it LOW at all
//  other times when the module is not selected.

  assign HREADYOUT = iHREADYOUT;

// The response will always be OKAY to show that the transfer has been performed
//  successfully.

  assign HRESP = `RSP_OKAY;


endmodule

// --================================= End ===================================--

