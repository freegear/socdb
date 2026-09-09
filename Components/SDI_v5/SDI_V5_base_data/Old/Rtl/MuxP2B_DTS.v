// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : MuxP2B_DTS.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose            : Central mux - signals from peripherals to bridge.
//                        Stand-alone module to allow ease of removal if an
//                        alternative interconnection scheme is to be used.
//  --========================================================================--

`timescale 1ns/1ps

module MuxP2B_DTS 
  (
   // Inputs to the Mux
   PSELS0,
   PSELS1,
   PSELS2,
   PSELS3,
   //Timers
   //PSELS4,
   PSELS4X0,
   PSELS4X1,
   PSELS4X2,
   PSELS4X3,
   PSELS4X4,
   PSELS4X5,
   PSELS4X6,
   PSELS4X7,
   
  // PSELS5,
   PSELS5X0 ,//PWM0_0 ~ PWM0_7
   PSELS5X1 ,
   PSELS5X2 ,
   PSELS5X3 ,
   PSELS5X4 ,
   PSELS5X5 ,
   PSELS5X6 ,
   PSELS5X7 ,
   
   //PSELS6,
   PSELS6X0 , //PWM1_0 ~ PWM1_7
   PSELS6X1 ,
   PSELS6X2 ,
   PSELS6X3 ,
   PSELS6X4 ,
   PSELS6X5 ,
   PSELS6X6 ,
   PSELS6X7 , 
   //PSELS7,
   PSELS7X0 ,//PWM2_0 ~ PWM2_7
   PSELS7X1 ,
   PSELS7X2 ,
   PSELS7X3 ,
   PSELS7X4 ,
   PSELS7X5 ,
   PSELS7X6 ,
   PSELS7X7 ,
   //PSELS8,
   PSELS8X0 ,//PWM3_0 ~ PWM3_7
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
   PSELS12,
   PSELS13,
   //PSELS14,
   //PSELS15,

   PRDATAS0,
   PRDATAS1,
   PRDATAS2,
   PRDATAS3,
   //PRDATAS4,
   PRDATAS4X0,//Timers
   PRDATAS4X1,
   PRDATAS4X2,
   PRDATAS4X3,
   PRDATAS4X4,
   PRDATAS4X5,
   PRDATAS4X6,
   PRDATAS4X7,
   
   //PRDATAS5,
   PRDATAS5X0,//PWM0_0 ~ PWM0_7
   PRDATAS5X1,
   PRDATAS5X2,
   PRDATAS5X3,
   PRDATAS5X4,
   PRDATAS5X5,
   PRDATAS5X6,
   PRDATAS5X7,
   
   //PRDATAS6,
   PRDATAS6X0,//PWM1_0 ~ PWM1_7
   PRDATAS6X1,
   PRDATAS6X2,
   PRDATAS6X3,
   PRDATAS6X4,
   PRDATAS6X5,
   PRDATAS6X6,
   PRDATAS6X7,
   
   //PRDATAS7,
   PRDATAS7X0,//PWM2_0 ~ PWM2_7  
   PRDATAS7X1,                   
   PRDATAS7X2,                   
   PRDATAS7X3,                   
   PRDATAS7X4,                   
   PRDATAS7X5,                   
   PRDATAS7X6,                   
   PRDATAS7X7,                   

  //PRDATAS8,
   PRDATAS8X0,//PWM3_0 ~ PWM3_7  
   PRDATAS8X1,                   
   PRDATAS8X2,                   
   PRDATAS8X3,                   
   PRDATAS8X4,                   
   PRDATAS8X5,                   
   PRDATAS8X6,                   
   PRDATAS8X7,                  
   
   PRDATAS9,
   PRDATAS10,
   PRDATAS11,
   PRDATAS12,
   PRDATAS13,
   
   //PRDATAS15,

   // Output from the Mux  
   PRDATA);

//Vector Array
parameter  Vector_Bit     = 49   ; 

  input PSELS0;
  input PSELS1;
  input PSELS2;
  input PSELS3;
  //input 
  //input PSELS4   ;
  
  input PSELS4X0 ;//Timers
  input PSELS4X1 ;
  input PSELS4X2 ;
  input PSELS4X3 ;
  input PSELS4X4 ;
  input PSELS4X5 ;
  input PSELS4X6 ;
  input PSELS4X7 ;
  
  
  //input PSELS5;
  
  input PSELS5X0 ;//PWM0_0 ~ PWM0_7
  input PSELS5X1 ;
  input PSELS5X2 ;
  input PSELS5X3 ;
  input PSELS5X4 ;
  input PSELS5X5 ;
  input PSELS5X6 ;
  input PSELS5X7 ;
  
  //input PSELS6;
  
  input PSELS6X0 ; //PWM1_0 ~ PWM1_7
  input PSELS6X1 ;
  input PSELS6X2 ;
  input PSELS6X3 ;
  input PSELS6X4 ;
  input PSELS6X5 ;
  input PSELS6X6 ;
  input PSELS6X7 ;
  
 // input PSELS7;
  
  input PSELS7X0 ;//PWM2_0 ~ PWM2_7
  input PSELS7X1 ;
  input PSELS7X2 ;
  input PSELS7X3 ;
  input PSELS7X4 ;
  input PSELS7X5 ;
  input PSELS7X6 ;
  input PSELS7X7 ;
  
//  input PSELS8;
  
  input PSELS8X0 ;//PWM3_0 ~ PWM3_7
  input PSELS8X1 ;
  input PSELS8X2 ;
  input PSELS8X3 ;
  input PSELS8X4 ;
  input PSELS8X5 ;
  input PSELS8X6 ;
  input PSELS8X7 ;
  
  
  
  
  
  
  
  
  input PSELS9;
  input PSELS10;
  input PSELS11;
  input PSELS12;
  input PSELS13;
  //input PSELS14;
  //input PSELS15;

  input [31:0] PRDATAS0;
  input [31:0] PRDATAS1;
  input [31:0] PRDATAS2;
  input [31:0] PRDATAS3;
  //input [31:0] PRDATAS4;
  
  input [31:0] PRDATAS4X0;//Timers
  input [31:0] PRDATAS4X1;
  input [31:0] PRDATAS4X2;
  input [31:0] PRDATAS4X3;
  input [31:0] PRDATAS4X4;
  input [31:0] PRDATAS4X5;
  input [31:0] PRDATAS4X6;
  input [31:0] PRDATAS4X7;
  
  //input [31:0] PRDATAS5;
  input [31:0] PRDATAS5X0;//PWM0_0 ~ PWM0_7
  input [31:0] PRDATAS5X1;
  input [31:0] PRDATAS5X2;
  input [31:0] PRDATAS5X3;
  input [31:0] PRDATAS5X4;
  input [31:0] PRDATAS5X5;
  input [31:0] PRDATAS5X6;
  input [31:0] PRDATAS5X7;
  
  // input [31:0] PRDATAS6;
  input [31:0] PRDATAS6X0;//PWM1_0 ~ PWM1_7
  input [31:0] PRDATAS6X1;
  input [31:0] PRDATAS6X2;
  input [31:0] PRDATAS6X3;
  input [31:0] PRDATAS6X4;
  input [31:0] PRDATAS6X5;
  input [31:0] PRDATAS6X6;
  input [31:0] PRDATAS6X7; 
 
 // input [31:0] PRDATAS7;
  input [31:0] PRDATAS7X0;//PWM2_0 ~ PWM2_7
  input [31:0] PRDATAS7X1;
  input [31:0] PRDATAS7X2;
  input [31:0] PRDATAS7X3;
  input [31:0] PRDATAS7X4;
  input [31:0] PRDATAS7X5;
  input [31:0] PRDATAS7X6;
  input [31:0] PRDATAS7X7;
   
 // input [31:0] PRDATAS8;
  input [31:0] PRDATAS8X0;//PWM3_0 ~ PWM3_7
  input [31:0] PRDATAS8X1;
  input [31:0] PRDATAS8X2;
  input [31:0] PRDATAS8X3;
  input [31:0] PRDATAS8X4;
  input [31:0] PRDATAS8X5;
  input [31:0] PRDATAS8X6;
  input [31:0] PRDATAS8X7;
  
  input [31:0] PRDATAS9;
  input [31:0] PRDATAS10;
  input [31:0] PRDATAS11;
  input [31:0] PRDATAS12;
  input [31:0] PRDATAS13;
  
  //input [31:0] PRDATAS15;
    
  output [31:0] PRDATA;

//
// Block Overview
//
//   The Peripheral to Bridge Multiplexor is used to connect the read data 
// output of each APB Slave to the APB Bridge module, using the PSELx signals 
// to select the required data source. 
//
// The Peripheral to Bridge Multiplexor module has a 32-bit wide data path. 
// It is constructed from a parallel arrangement of 32 multiplexors, each 
// taking 16 inputs.
//

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// PselBus encoding. This must be extended if more than sixteen APB peripherals
//  are used in the system.

//  `define PSEL_S0  16'b0000000000000001
//  `define PSEL_S1  16'b0000000000000010
//  `define PSEL_S2  16'b0000000000000100
//  `define PSEL_S3  16'b0000000000001000
//  `define PSEL_S4  16'b0000000000010000 //Timers0
//  `define PSEL_S5  16'b0000000000100000
//  `define PSEL_S6  16'b0000000001000000
//  `define PSEL_S7  16'b0000000010000000
//  `define PSEL_S8  16'b0000000100000000
//  `define PSEL_S9  16'b0000001000000000
//  `define PSEL_S10 16'b0000010000000000
//  `define PSEL_S11 16'b0000100000000000
//  `define PSEL_S12 16'b0001000000000000
//  `define PSEL_S13 16'b0010000000000000
//  `define PSEL_S14 16'b0100000000000000 
//  `define PSEL_S15 16'b1000000000000000
   
   //                               |                   |                   |           
   //                     47   43   39   35   31   27   23   19   15   11   7    3 
  `define PSEL_S0   53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001
  `define PSEL_S1   53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0010
  `define PSEL_S2   53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0100
  `define PSEL_S3   53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1000
   //                               |                   |                   |           
   //                     47   43   39   35   31   27   23   19   15   11   7    3                                                          
  `define PSEL_S4X0 53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001_0000 //Timers0
  `define PSEL_S4X1 53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0010_0000
  `define PSEL_S4X2 53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0100_0000
  `define PSEL_S4X3 53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1000_0000
  `define PSEL_S4X4 53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001_0000_0000
  `define PSEL_S4X5 53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0010_0000_0000
  `define PSEL_S4X6 53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_0100_0000_0000
  `define PSEL_S4X7 53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0000_1000_0000_0000
   //                               |                   |                   |           
   //                     47   43   39   35   31   27   23   19   15   11   7    3
  `define PSEL_S5X0 53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0001_0000_0000_0000 //PWM0_0 ~ PWM0_7
  `define PSEL_S5X1 53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0010_0000_0000_0000
  `define PSEL_S5X2 53'b0_0000_0000_0000_0000_0000_0000_0000_0000_0100_0000_0000_0000
  `define PSEL_S5X3 53'b0_0000_0000_0000_0000_0000_0000_0000_0000_1000_0000_0000_0000
  `define PSEL_S5X4 53'b0_0000_0000_0000_0000_0000_0000_0000_0001_0000_0000_0000_0000
  `define PSEL_S5X5 53'b0_0000_0000_0000_0000_0000_0000_0000_0010_0000_0000_0000_0000
  `define PSEL_S5X6 53'b0_0000_0000_0000_0000_0000_0000_0000_0100_0000_0000_0000_0000
  `define PSEL_S5X7 53'b0_0000_0000_0000_0000_0000_0000_0000_1000_0000_0000_0000_0000
   //                               |                   |                   |           
   //                     47   43   39   35   31   27   23   19   15   11   7    3
  `define PSEL_S6X0 53'b0_0000_0000_0000_0000_0000_0000_0001_0000_0000_0000_0000_0000 //PWM1_0 ~ PWM1_7
  `define PSEL_S6X1 53'b0_0000_0000_0000_0000_0000_0000_0010_0000_0000_0000_0000_0000
  `define PSEL_S6X2 53'b0_0000_0000_0000_0000_0000_0000_0100_0000_0000_0000_0000_0000
  `define PSEL_S6X3 53'b0_0000_0000_0000_0000_0000_0000_1000_0000_0000_0000_0000_0000
  `define PSEL_S6X4 53'b0_0000_0000_0000_0000_0000_0001_0000_0000_0000_0000_0000_0000
  `define PSEL_S6X5 53'b0_0000_0000_0000_0000_0000_0010_0000_0000_0000_0000_0000_0000
  `define PSEL_S6X6 53'b0_0000_0000_0000_0000_0000_0100_0000_0000_0000_0000_0000_0000
  `define PSEL_S6X7 53'b0_0000_0000_0000_0000_0000_1000_0000_0000_0000_0000_0000_0000
   //                               |                   |                   |           
   //                     47   43   39   35   31   27   23   19   15   11   7    3
  `define PSEL_S7X0 53'b0_0000_0000_0000_0000_0001_0000_0000_0000_0000_0000_0000_0000 //PWM2_0 ~ PWM2_7
  `define PSEL_S7X1 53'b0_0000_0000_0000_0000_0010_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S7X2 53'b0_0000_0000_0000_0000_0100_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S7X3 53'b0_0000_0000_0000_0000_1000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S7X4 53'b0_0000_0000_0000_0001_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S7X5 53'b0_0000_0000_0000_0010_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S7X6 53'b0_0000_0000_0000_0100_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S7X7 53'b0_0000_0000_0000_1000_0000_0000_0000_0000_0000_0000_0000_0000
   //                               |                   |                   |           
   //                     47   43   39   35   31   27   23   19   15   11   7    3
  `define PSEL_S8X0 53'b0_0000_0000_0001_0000_0000_0000_0000_0000_0000_0000_0000_0000 //PWM3_0 ~ PWM3_7
  `define PSEL_S8X1 53'b0_0000_0000_0010_0000_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S8X2 53'b0_0000_0000_0100_0000_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S8X3 53'b0_0000_0000_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S8X4 53'b0_0000_0001_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S8X5 53'b0_0000_0010_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S8X6 53'b0_0000_0100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S8X7 53'b0_0000_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
   //                               |                   |                   |           
   //                     47   43   39   35   31   27   23   19   15   11   7    3
  `define PSEL_S9   53'b0_0001_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S10  53'b0_0010_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S11  53'b0_0100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S12  53'b0_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
  `define PSEL_S13  53'b1_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000

//`define PSEL_S5   53'b0_0000_0001_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
  //`define PSEL_S6   53'b0_0000_0010_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
  //`define PSEL_S7   53'b0_0000_0100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
  //`define PSEL_S8   53'b0_0000_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
//------------------------------------------------------------------------------
// Signal declaration
//------------------------------------------------------------------------------
     
// Input/Output Signals
  wire        PSELS0;
  wire        PSELS1;
  wire        PSELS2;
  wire        PSELS3;

  //wire        PSELS4;
  wire        PSELS4X0;
  wire        PSELS4X1;
  wire        PSELS4X2;
  wire        PSELS4X3;
  wire        PSELS4X4;
  wire        PSELS4X5;
  wire        PSELS4X6;
  wire        PSELS4X7;
  
 // wire        PSELS5;
  
  wire        PSELS5X0 ;//PWM0_0 ~ PWM0_7
  wire        PSELS5X1 ;
  wire        PSELS5X2 ;
  wire        PSELS5X3 ;
  wire        PSELS5X4 ;
  wire        PSELS5X5 ;
  wire        PSELS5X6 ;
  wire        PSELS5X7 ;
  
 // wire        PSELS6;
  
  wire        PSELS6X0 ;//PWM1_0 ~ PWM1_7
  wire        PSELS6X1 ;
  wire        PSELS6X2 ;
  wire        PSELS6X3 ;
  wire        PSELS6X4 ;
  wire        PSELS6X5 ;
  wire        PSELS6X6 ;
  wire        PSELS6X7 ;
  
 // wire        PSELS7;
  
  wire        PSELS7X0 ;//PWM2_0 ~ PWM2_7
  wire        PSELS7X1 ;
  wire        PSELS7X2 ;
  wire        PSELS7X3 ;
  wire        PSELS7X4 ;
  wire        PSELS7X5 ;
  wire        PSELS7X6 ;
  wire        PSELS7X7 ;
  
 // wire        PSELS8;
  
  wire        PSELS8X0 ;//PWM3_0 ~ PWM3_7
  wire        PSELS8X1 ;
  wire        PSELS8X2 ;
  wire        PSELS8X3 ;
  wire        PSELS8X4 ;
  wire        PSELS8X5 ;
  wire        PSELS8X6 ;
  wire        PSELS8X7 ;
  
  wire        PSELS9;
  wire        PSELS10;
  wire        PSELS11;
  wire        PSELS12;
  wire        PSELS13;
  
  wire [31:0] PRDATAS0;
  wire [31:0] PRDATAS1;
  wire [31:0] PRDATAS2;
  wire [31:0] PRDATAS3;
   //wire [31:0] PRDATAS4;
  wire [31:0] PRDATAS4X0; //Timers
  wire [31:0] PRDATAS4X1;
  wire [31:0] PRDATAS4X2;
  wire [31:0] PRDATAS4X3;
  wire [31:0] PRDATAS4X4;
  wire [31:0] PRDATAS4X5;
  wire [31:0] PRDATAS4X6;
  wire [31:0] PRDATAS4X7;
  
   //input [31:0] PRDATAS5;
  wire [31:0] PRDATAS5X0;//PWM0_0 ~ PWM0_7
  wire [31:0] PRDATAS5X1;
  wire [31:0] PRDATAS5X2;
  wire [31:0] PRDATAS5X3;
  wire [31:0] PRDATAS5X4;
  wire [31:0] PRDATAS5X5;
  wire [31:0] PRDATAS5X6;
  wire [31:0] PRDATAS5X7;
  
  // input [31:0] PRDATAS6;
  wire [31:0] PRDATAS6X0;//PWM1_0 ~ PWM1_7
  wire [31:0] PRDATAS6X1;
  wire [31:0] PRDATAS6X2;
  wire [31:0] PRDATAS6X3;
  wire [31:0] PRDATAS6X4;
  wire [31:0] PRDATAS6X5;
  wire [31:0] PRDATAS6X6;
  wire [31:0] PRDATAS6X7; 
 
 // input [31:0] PRDATAS7;
  wire [31:0] PRDATAS7X0;//PWM2_0 ~ PWM2_7
  wire [31:0] PRDATAS7X1;
  wire [31:0] PRDATAS7X2;
  wire [31:0] PRDATAS7X3;
  wire [31:0] PRDATAS7X4;
  wire [31:0] PRDATAS7X5;
  wire [31:0] PRDATAS7X6;
  wire [31:0] PRDATAS7X7;
   
 // input [31:0] PRDATAS8;
  wire [31:0] PRDATAS8X0;//PWM3_0 ~ PWM3_7
  wire [31:0] PRDATAS8X1;
  wire [31:0] PRDATAS8X2;
  wire [31:0] PRDATAS8X3;
  wire [31:0] PRDATAS8X4;
  wire [31:0] PRDATAS8X5;
  wire [31:0] PRDATAS8X6;
  wire [31:0] PRDATAS8X7;  
    
  wire [31:0] PRDATAS9;
  wire [31:0] PRDATAS10;
  wire [31:0] PRDATAS11;
  wire [31:0] PRDATAS12;
  wire [31:0] PRDATAS13;
  
  
  

  reg  [31:0] PRDATA;

// Internal Signals
 // wire [15:0] PselBus;  // PSEL input bus
  wire [Vector_Bit-1:0] PselBus;  // PSEL input bus

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// PSEL bus
//------------------------------------------------------------------------------
// The internal PSEL bus is made up of the individual PSEL inputs.

   assign PselBus = {//PSELS15,
                     //PSELS14,
                     
                     PSELS13  ,//52   :Power Manager
                     PSELS12  ,//51 :ADC
                     PSELS11  ,//50 
                     PSELS10  ,  
                     PSELS9   ,
                     //PSELS8   ,//47
                     //PSELS7   , 
                     //PSELS6   ,
                     //PSELS5   ,//44 
                   //{32{1'b0}} ,//43 PWM  
                  
                     PSELS8X7 ,
                     PSELS8X6 ,
                     PSELS8X5 ,
                     PSELS8X4 ,
                     PSELS8X3 ,
                     PSELS8X2 ,
                     PSELS8X1 , 
                     PSELS8X0 ,
                     //========
                     PSELS7X7 ,
                     PSELS7X6 ,
                     PSELS7X5 ,
                     PSELS7X4 ,
                     PSELS7X3 ,
                     PSELS7X2 ,
                     PSELS7X1 , 
                     PSELS7X0 ,
                     //========
                     PSELS6X7 ,
                     PSELS6X6 ,
                     PSELS6X5 ,
                     PSELS6X4 ,
                     PSELS6X3 ,
                     PSELS6X2 ,
                     PSELS6X1 , 
                     PSELS6X0 ,
                     //=======
                     PSELS5X7 ,
                     PSELS5X6 ,
                     PSELS5X5 ,
                     PSELS5X4 ,
                     PSELS5X3 ,
                     PSELS5X2 ,
                     PSELS5X1 , 
                     PSELS5X0 ,
                     //======= 
                     PSELS4X7 ,//11
                     PSELS4X6 ,
                     PSELS4X5 ,
                     PSELS4X4 ,
                     PSELS4X3 ,//7
                     PSELS4X2 ,
                     PSELS4X1 ,
                     PSELS4X0 , //Timers
                     //=======                    
                     PSELS3   , //3
                     PSELS2   ,
                     PSELS1   ,
                     PSELS0     //0
                     };

//------------------------------------------------------------------------------
// Multiplexers
//------------------------------------------------------------------------------
// Multiplexers controlling read data from peripherals to the bridge.

// This module only needs to be as wide as the widest peripheral read data bus,
//  but in this default system it is set to the full 32 bits.
// The default all zeros case is not strictly required, but may aid debugging by
//  ensuring that the read data bus is zero when no peripherals are being
//  accessed.

  always @ (PselBus or PRDATAS0 or PRDATAS1 or PRDATAS2 or PRDATAS3 or 
            //PRDATAS5 or 
            //PRDATAS6 or
            //PRDATAS7 or 
            //PRDATAS8 or 
            PRDATAS9 or PRDATAS10 or
            PRDATAS11 or PRDATAS12 or PRDATAS13 or
            //Timers
            PRDATAS4X0 or PRDATAS4X1 or PRDATAS4X2 or PRDATAS4X3 or
            PRDATAS4X4 or PRDATAS4X5 or PRDATAS4X6 or PRDATAS4X7 or
            
            //PWM0_0 ~ PWM0_7
            PRDATAS5X0 or PRDATAS5X1 or PRDATAS5X2 or PRDATAS5X3 or
            PRDATAS5X4 or PRDATAS5X5 or PRDATAS5X6 or PRDATAS5X7 or 
            
            //PWM1_0 ~ PWM1_7
            PRDATAS6X0 or PRDATAS6X1 or PRDATAS6X2 or PRDATAS6X3 or
            PRDATAS6X4 or PRDATAS6X5 or PRDATAS6X6 or PRDATAS6X7 or  
            
            //PWM2_0 ~ PWM2_7
            PRDATAS7X0 or PRDATAS7X1 or PRDATAS7X2 or PRDATAS7X3 or
            PRDATAS7X4 or PRDATAS7X5 or PRDATAS7X6 or PRDATAS7X7 or  
            
            //PWM3_0 ~ PWM3_7
            PRDATAS8X0 or PRDATAS8X1 or PRDATAS8X2 or PRDATAS8X3 or
            PRDATAS8X4 or PRDATAS8X5 or PRDATAS8X6 or PRDATAS8X7   
            
            ) 
            //or PRDATAS14 or PRDATAS15)
    begin : p_PRDATAComb
      case (PselBus)
        `PSEL_S0 : 
          PRDATA = PRDATAS0;

        `PSEL_S1 : 
          PRDATA = PRDATAS1;

        `PSEL_S2 : 
          PRDATA = PRDATAS2;

        `PSEL_S3 : 
          PRDATA = PRDATAS3;

        //Timers
        `PSEL_S4X0 : 
          PRDATA = PRDATAS4X0 ;
          
        `PSEL_S4X1 : 
          PRDATA = PRDATAS4X1 ;

        `PSEL_S4X2 : 
          PRDATA = PRDATAS4X2 ;
          
        `PSEL_S4X3 : 
          PRDATA = PRDATAS4X3 ;
          
        `PSEL_S4X4 : 
          PRDATA = PRDATAS4X4 ;
        
        `PSEL_S4X5 : 
          PRDATA = PRDATAS4X5 ;
          
        `PSEL_S4X6 : 
          PRDATA = PRDATAS4X6 ;          
       
        `PSEL_S4X7 : 
          PRDATA = PRDATAS4X7 ; 
        
        
            
        //`PSEL_S5 : 
        //  PRDATA = PRDATAS5;
       
        
        `PSEL_S5X0 :          //PWM0_0~PWM0_7
          PRDATA = PRDATAS5X0 ;
          
        `PSEL_S5X1 : 
          PRDATA = PRDATAS5X1 ;

        `PSEL_S5X2 : 
          PRDATA = PRDATAS5X2 ;
          
        `PSEL_S5X3 : 
          PRDATA = PRDATAS5X3 ;
          
        `PSEL_S5X4 : 
          PRDATA = PRDATAS5X4 ;
        
        `PSEL_S5X5 : 
          PRDATA = PRDATAS5X5 ;
          
        `PSEL_S5X6 : 
          PRDATA = PRDATAS5X6 ;          
       
        `PSEL_S5X7 : 
          PRDATA = PRDATAS5X7 ; 
          
       
         
        `PSEL_S6X0 :           //PWM1_0~PWM1_7
          PRDATA = PRDATAS6X0 ;
          
        `PSEL_S6X1 : 
          PRDATA = PRDATAS6X1 ;

        `PSEL_S6X2 : 
          PRDATA = PRDATAS6X2 ;
          
        `PSEL_S6X3 : 
          PRDATA = PRDATAS6X3 ;
          
        `PSEL_S6X4 : 
          PRDATA = PRDATAS6X4 ;
        
        `PSEL_S6X5 : 
          PRDATA = PRDATAS6X5 ;
          
        `PSEL_S6X6 : 
          PRDATA = PRDATAS6X6 ;          
       
        `PSEL_S6X7 : 
          PRDATA = PRDATAS6X7 ;     
          
         
          
        `PSEL_S7X0 :           //PWM2_0~PWM2_7
          PRDATA = PRDATAS7X0 ;
          
        `PSEL_S7X1 : 
          PRDATA = PRDATAS7X1 ;

        `PSEL_S7X2 : 
          PRDATA = PRDATAS7X2 ;
          
        `PSEL_S7X3 : 
          PRDATA = PRDATAS7X3 ;
          
        `PSEL_S7X4 : 
          PRDATA = PRDATAS7X4 ;
        
        `PSEL_S7X5 : 
          PRDATA = PRDATAS7X5 ;
          
        `PSEL_S7X6 : 
          PRDATA = PRDATAS7X6 ;          
       
        `PSEL_S7X7 : 
          PRDATA = PRDATAS7X7 ;     
          
          
         
        `PSEL_S8X0 :           //PWM3_0~PWM3_7
          PRDATA = PRDATAS8X0 ;
          
        `PSEL_S8X1 : 
          PRDATA = PRDATAS8X1 ;

        `PSEL_S8X2 : 
          PRDATA = PRDATAS8X2 ;
          
        `PSEL_S8X3 : 
          PRDATA = PRDATAS8X3 ;
          
        `PSEL_S8X4 : 
          PRDATA = PRDATAS8X4 ;
        
        `PSEL_S8X5 : 
          PRDATA = PRDATAS8X5 ;
          
        `PSEL_S8X6 : 
          PRDATA = PRDATAS8X6 ;          
       
        `PSEL_S8X7 : 
          PRDATA = PRDATAS8X7 ;      
        //`PSEL_S6 : 
        //  PRDATA = PRDATAS6;

        //`PSEL_S7 : 
        //  PRDATA = PRDATAS7;

        //`PSEL_S8 : 
        //  PRDATA = PRDATAS8;

        `PSEL_S9 : 
          PRDATA = PRDATAS9;

        `PSEL_S10 : 
          PRDATA = PRDATAS10;

        `PSEL_S11 : 
          PRDATA = PRDATAS11;

        `PSEL_S12 : 
          PRDATA = PRDATAS12;

        `PSEL_S13 : 
          PRDATA = PRDATAS13;

       // `PSEL_S14 : 
       //   PRDATA = PRDATAS4X0;

       // `PSEL_S15 : 
       //   PRDATA = PRDATAS15;

        default: 
          PRDATA = {4'b0000,4'b0000,4'b0000,4'b0000,
                    4'b0000,4'b0000,4'b0000,4'b0000};

      endcase
    end 


endmodule

// --================================= End ===================================--

