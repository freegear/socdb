// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APB_Timers.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : 16-Bit Timers 
//  =============================================================================

`timescale 1ns/1ps

module APB_Timers 
(
//APB
PCLK         , 
PRESETn      , 
PENABLE      , 
PSEL         , 
PWRITE       , 
PADDR        , 
PWDATA       ,
PRDATA       ,

//Function
//TCLK[7:0]
TCLK0        ,
TCLK1        ,
TCLK2        ,
TCLK3        ,

TCLK4        ,
TCLK5        ,
TCLK6        ,
TCLK7        ,

TCAP         ,

INT_TPOUT    ,
INT_TPOUTX1  ,
INT_TPOUTX2  ,
INT_TPOUTX3  ,
INT_TPOUTX4  ,
INT_TPOUTX5  ,
INT_TPOUTX6  ,
INT_TPOUTX7  ,

INT_TOF      ,
INT_TOFX1    ,  
INT_TOFX2    ,  
INT_TOFX3    ,  
INT_TOFX4    ,  
INT_TOFX5    ,  
INT_TOFX6    ,  
INT_TOFX7    ,  

INT_TMC      ,
INT_TMCX1    ,
INT_TMCX2    ,
INT_TMCX3    ,
INT_TMCX4    ,
INT_TMCX5    ,
INT_TMCX6    ,
INT_TMCX7    ,

SCANENABLE   , 
SCANINPCLK   , 
SCANOUTPCLK  

);

//Global Parameter
//APB
  input         PCLK        ;     // APB system clock
  input         PRESETn     ;     // APB system reset
  input         PENABLE     ;     // Data valid strobe 
  input         PSEL        ;     // Module select signal
  input         PWRITE      ;     // Write/nRead signal
  input  [11:0] PADDR       ;     // Address (used bits only)
  input  [31:0] PWDATA      ;     // Read data
  output [31:0] PRDATA      ;     // Write data

 //Function BL
  input TCLK0                ;
  input TCLK1                ;
  input TCLK2                ;
  input TCLK3                ;
  input TCLK4                ;
  input TCLK5                ;
  input TCLK6                ;
  input TCLK7                ;
  
  input  [7:0] TCAP          ;
  
  output       INT_TPOUT     ;
  output       INT_TPOUTX1   ;
  output       INT_TPOUTX2   ;
  output       INT_TPOUTX3   ;
  output       INT_TPOUTX4   ;
  output       INT_TPOUTX5   ;
  output       INT_TPOUTX6   ;
  output       INT_TPOUTX7   ;
  
  output       INT_TOF       ;     //Overflow[16'hFFFF Interrupt
  output       INT_TOFX1     ;
  output       INT_TOFX2     ;
  output       INT_TOFX3     ;
  output       INT_TOFX4     ;
  output       INT_TOFX5     ;
  output       INT_TOFX6     ;
  output       INT_TOFX7     ;     
  
  output       INT_TMC       ;     //Match Interrupt To Interrupt 
  output       INT_TMCX1     ;
  output       INT_TMCX2     ;
  output       INT_TMCX3     ;
  output       INT_TMCX4     ;
  output       INT_TMCX5     ;
  output       INT_TMCX6     ;
  output       INT_TMCX7     ;
  
  
    
 
 
 
 // Scan test dummy signals; not connected until scan insertion 
  input         SCANENABLE  ;     // Scan Test Mode Enbl
  input         SCANINPCLK  ;     // Scan Chain Input
  output        SCANOUTPCLK ;     // Scan Chain Output  

// Module Address Map:
// Read/write 32-bit registers:
//
// Address  Read      Write
// 0x00     0 = R0    R0
// 0x04     1 = R1    R1

// ExampleAPBSlave local registers
//`define EGAPBSLVREG 6'b000000
//0x01FF_8400[11:5]
//Timers 0 :0010_000
`define EGAPBSLVREG  7'b0100_000 //40
`define EGAPBSLVREG1 7'b0100_001 //42
`define EGAPBSLVREG2 7'b0100_010 //44
`define EGAPBSLVREG3 7'b0100_011 //46
`define EGAPBSLVREG4 7'b0100_100 //48
`define EGAPBSLVREG5 7'b0100_101 //4A
`define EGAPBSLVREG6 7'b0100_110 //4C
`define EGAPBSLVREG7 7'b0100_111 //4E





//00[0000_0000]
//20[0010_0000]
//40[0100_0000]
//60[0110_0000]
//80[1000_0000]
//A0[1010_0000]
//C0[1100_0000]
//E0[1110_0000]
//`define ADDRREG5  6'b0001_01_xx  //0x14
//`define ADDRREG6  6'b0001_10_xx  //0x18
//`define ADDRREG7  6'b0001_11_xx  //0x1C

//`define ADDRREG8  6'b0010_00_xx  //0x20
//`define ADDRREG9  6'b0010_01_xx  //0x24
//`define ADDRREG10 6'b0010_10_xx  //0x28
//`define ADDRREG11 6'b0010_11_xx  //0x2C

//Sub Address
`define SubADDR00  3'b0_00      //0x00
`define SubADDR04  3'b0_01      //0x04
`define SubADDR08  3'b0_10      //0x08
`define SubADDR0C  3'b0_11      //0x0C
`define SubADDR10  3'b1_00      //0x10

//Timers0 
`define ADDRREG0  6'b0000_00      //0x00
`define ADDRREG1  6'b0000_01      //0x04
`define ADDRREG2  6'b0000_10      //0x08
`define ADDRREG3  6'b0000_11      //0x0C
`define ADDRREG4  6'b0001_00      //0x10
//Timers1
`define ADDRREGX20  6'b0010_00    //0x20
`define ADDRREGX24  6'b0010_01    //0x24
`define ADDRREGX28  6'b0010_10    //0x28
`define ADDRREGX2C  6'b0010_11    //0x2C
`define ADDRREGX30  6'b0011_00    //0x30

//Timers2
`define ADDRREGX40  6'b0100_00    //0x40
`define ADDRREGX44  6'b0100_01    //0x44
`define ADDRREGX48  6'b0100_10    //0x48
`define ADDRREGX4C  6'b0100_11    //0x4C
`define ADDRREGX50  6'b0101_00    //0x50

//Timers3
`define ADDRREGX60  6'b0110_00    //0x60
`define ADDRREGX64  6'b0110_01    //0x64
`define ADDRREGX68  6'b0110_10    //0x68
`define ADDRREGX6C  6'b0110_11    //0x6C
`define ADDRREGX70  6'b0111_00    //0x70

//Timers4
`define ADDRREGX80  6'b1000_00    //0x80
`define ADDRREGX84  6'b1000_01    //0x84
`define ADDRREGX88  6'b1000_10    //0x88
`define ADDRREGX8C  6'b1000_11    //0x8C
`define ADDRREGX90  6'b1001_00    //0x90

//Timers5
`define ADDRREGXA0  6'b1010_00    //0xA0
`define ADDRREGXA4  6'b1010_01    //0xA4
`define ADDRREGXA8  6'b1010_10    //0xA8
`define ADDRREGXAC  6'b1010_11    //0xAC
`define ADDRREGXB0  6'b1011_00    //0xB0

//Timers6                                    
`define ADDRREGXC0  6'b1100_00    //0xC0     
`define ADDRREGXC4  6'b1100_01    //0xC4     
`define ADDRREGXC8  6'b1100_10    //0xC8      
`define ADDRREGXCC  6'b1100_11    //0xCC     
`define ADDRREGXD0  6'b1101_00    //0xD0     

//Timers7                                    
`define ADDRREGXE0  6'b1110_00    //0xE0     
`define ADDRREGXE4  6'b1110_01    //0xE4     
`define ADDRREGXE8  6'b1110_10    //0xE8      
`define ADDRREGXEC  6'b1110_11    //0xEC     
`define ADDRREGXF0  6'b1111_00    //0xF0     


//OMS[Operation Mode] 
`define OMSCode0 3'b000  //Interval mode
`define OMSCode1 3'b001  //Match & Overflow mode
`define OMSCode2 3'b010  //PWM mode

`define OMSCode4 3'b100  //Capture on falling edge of TCAP3,4,5
`define OMSCode5 3'b101  //Capture on rising edge of TCAP3,4,5
`define OMSCode6 3'b110  //Capture on both edge of TCAP3,4,5

//Prescaler 
`define  Prescale_para0 7'b0000_000 //X1   : 0~1
`define  Prescale_para1 7'b0000_001 //X2   : 2~3
`define  Prescale_para2 6'b0000_01  //X4   : 4~7
`define  Prescale_para3 5'b0000_1   //X8   : 8~15
`define  Prescale_para4 4'b0001     //X16  : 16~31
`define  Prescale_para5 3'b001      //X32  : 32~63
`define  Prescale_para6 2'b01       //X64  : 64~127    
`define  Prescale_para7 1'b1        //X128 : 128~255
 

//Overflow
`define Overflow_Value 16'hFFFF 
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

  //APB Signal
  wire        PCLK            ;
  wire        PRESETn         ;
  wire        PENABLE         ;
  wire        PSEL            ;
  wire        PWRITE          ;
  wire [11:0]  PADDR          ;
  wire [31:0] PWDATA          ;
  wire [31:0] PRDATA          ;
  
  // Internal Signals
  
  wire        Valid           ;         // Detect valid transfers
  wire        R0En            ;          // Register update enables
  wire        R1En            ;
  wire        R2En            ;
  wire        R3En            ;
  wire        R4En            ;
  
  wire        R0EnX           ;          // Register update enables
  wire        R1EnX           ;
  wire        R2EnX           ;
  wire        R3EnX           ;
  wire        R4EnX           ;
  
  wire        R0EnXX          ;          // Register update enables
  wire        R1EnXX          ;
  wire        R2EnXX          ;
  wire        R3EnXX          ;
  wire        R4EnXX          ;
  
  wire        R0EnXXX         ;          // Register update enables
  wire        R1EnXXX         ;
  wire        R2EnXXX         ;
  wire        R3EnXXX         ;
  wire        R4EnXXX         ;
  
  wire        R0EnXXXX        ;          // Register update enables
  wire        R1EnXXXX        ;
  wire        R2EnXXXX        ;
  wire        R3EnXXXX        ;
  wire        R4EnXXXX        ;
  
  wire        R0EnX_XXXX      ;          // Register update enables
  wire        R1EnX_XXXX      ;
  wire        R2EnX_XXXX      ;
  wire        R3EnX_XXXX      ;
  wire        R4EnX_XXXX      ;
  
  wire        R0EnXX_XXXX     ;          // Register update enables
  wire        R1EnXX_XXXX     ;
  wire        R2EnXX_XXXX     ;
  wire        R3EnXX_XXXX     ;
  wire        R4EnXX_XXXX     ;
  
  wire        R0EnXXX_XXXX    ;          // Register update enables
  wire        R1EnXXX_XXXX    ;
  wire        R2EnXXX_XXXX    ;
  wire        R3EnXXX_XXXX    ;
  wire        R4EnXXX_XXXX    ;
  
  reg  [31:0] nextPRDATA      ;    // Mux, Register and Enable for PRDATA
 
 
  reg  [31:0] ReadRegs        ;
  reg  [31:0] ReadRegs1       ;
  reg  [31:0] ReadRegs2       ;
  reg  [31:0] ReadRegs3       ;
  reg  [31:0] ReadRegs4       ;
  reg  [31:0] ReadRegs5       ;
  reg  [31:0] ReadRegs6       ;
  reg  [31:0] ReadRegs7       ;
 
  reg  [31:0] iPRDATA         ;
  //Function BL
  wire TCLK0                  ;
  wire TCLK1                  ;
  wire TCLK2                  ;
  wire TCLK3                  ;
  wire TCLK4                  ;
  wire TCLK5                  ;
  wire TCLK6                  ;
  wire TCLK7                  ;
 
 
  
  wire        ReadRegEn       ;  
   
  //Function Signal
  wire [7:0]  TCAP            ;
  
  reg [15:0]  Timer_Cnt       ;  
  reg [15:0]  Timer_CntX1     ;
  reg [15:0]  Timer_CntX2     ;
  reg [15:0]  Timer_CntX3     ;
  
  reg [15:0]  Timer_CntX4     ;
  reg [15:0]  Timer_CntX5     ;
  reg [15:0]  Timer_CntX6     ;
  reg [15:0]  Timer_CntX7     ;
  
  reg         Timer_Match     ;
  reg         Timer_MatchX1   ;
  reg         Timer_MatchX2   ;
  reg         Timer_MatchX3   ;
  reg         Timer_MatchX4   ;
  reg         Timer_MatchX5   ;
  reg         Timer_MatchX6   ;
  reg         Timer_MatchX7   ;
  
  
  
  
  
  
  reg [7:0]   Prescale_Cnt    ;
  
  reg         Prescale_Clock    ;
  reg         Prescale_ClockX1  ;
  reg         Prescale_ClockX2  ;
  reg         Prescale_ClockX3  ;
  reg         Prescale_ClockX4  ;
  reg         Prescale_ClockX5  ;
  reg         Prescale_ClockX6  ;
  reg         Prescale_ClockX7  ;
  
  reg         Timer_Out         ;
  reg         Timer_OutX1       ;
  reg         Timer_OutX2       ;
  reg         Timer_OutX3       ;
  reg         Timer_OutX4       ;
  reg         Timer_OutX5       ;
  reg         Timer_OutX6       ;
  reg         Timer_OutX7       ;
  
  
  reg         TDx_CapEn         ;
  reg         TDX_Up            ;
  reg         TDX_CapEn_1Pd     ;
  reg [7:0]   TCAP_Reg          ;
  reg [7:0]   TCAP_Reg_1d       ;
  
  reg         INT_TPOUT         ;
  reg         INT_TPOUTX1       ;
  reg         INT_TPOUTX2       ;
  reg         INT_TPOUTX3       ;
  reg         INT_TPOUTX4       ;
  reg         INT_TPOUTX5       ;
  reg         INT_TPOUTX6       ;
  reg         INT_TPOUTX7       ;
    
  reg         Timers_OverFlow   ;
  reg         Timers_OverFlowX1 ;
  reg         Timers_OverFlowX2 ;
  reg         Timers_OverFlowX3 ;
  reg         Timers_OverFlowX4 ;
  reg         Timers_OverFlowX5 ;
  reg         Timers_OverFlowX6 ;
  reg         Timers_OverFlowX7 ;
    
  reg         PWM_Match         ;
  reg         PWM_MatchX1       ;
  reg         PWM_MatchX2       ;
  reg         PWM_MatchX3       ;
  reg         PWM_MatchX4       ;
  reg         PWM_MatchX5       ;
  reg         PWM_MatchX6       ;
  reg         PWM_MatchX7       ;
  
  reg         PWM_Out           ;
  reg         PWM_OutX1         ;
  reg         PWM_OutX2         ;
  reg         PWM_OutX3         ;
  reg         PWM_OutX4         ;
  reg         PWM_OutX5         ;
  reg         PWM_OutX6         ;
  reg         PWM_OutX7         ; 
  
  reg         PWM_Out_1d        ;
  reg         PWM_OutX1_1d      ;
  reg         PWM_OutX2_1d      ;
  reg         PWM_OutX3_1d      ;
  reg         PWM_OutX4_1d      ;
  reg         PWM_OutX5_1d      ;
  reg         PWM_OutX6_1d      ;
  reg         PWM_OutX7_1d      ;
   
  reg         PWM_Pulse         ;
  reg         PWM_PulseX1       ;
  reg         PWM_PulseX2       ;
  reg         PWM_PulseX3       ;
  reg         PWM_PulseX4       ;
  reg         PWM_PulseX5       ;
  reg         PWM_PulseX6       ;
  reg         PWM_PulseX7       ;
  
  wire [15:0] TDAT_Value        ;
  wire [15:0] TDAT_Value_X1     ;
  wire [15:0] TDAT_Value_X2     ;
  wire [15:0] TDAT_Value_X3     ;
  wire [15:0] TDAT_Value_X4     ;
  wire [15:0] TDAT_Value_X5     ;
  wire [15:0] TDAT_Value_X6     ;
  wire [15:0] TDAT_Value_X7     ;
  
  wire ICS                      ;
  wire ICSX1                    ;
  wire ICSX2                    ;
  wire ICSX3                    ;
  wire ICSX4                    ;
  wire ICSX5                    ;
  wire ICSX6                    ;
  wire ICSX7                    ;
  
  
  
  wire Timers_CLK               ;
  wire Timers_CLKX1             ;
  wire Timers_CLKX2             ;
  wire Timers_CLKX3             ;
  wire Timers_CLKX4             ;
  wire Timers_CLKX5             ;
  wire Timers_CLKX6             ;
  wire Timers_CLKX7             ;
  
  
  wire TEN                      ;
  wire TENX1                    ;
  wire TENX2                    ;
  wire TENX3                    ;
  wire TENX4                    ;
  wire TENX5                    ;
  wire TENX6                    ;
  wire TENX7                    ;
  
  
  
  wire CL_Bit                   ;
  wire CL_BitX1                 ;
  wire CL_BitX2                 ;
  wire CL_BitX3                 ;
  wire CL_BitX4                 ;
  wire CL_BitX5                 ;
  wire CL_BitX6                 ;
  wire CL_BitX7                 ;
  
  wire Timers_CLR               ;
  wire Timers_CLRX1             ;
  wire Timers_CLRX2             ;
  wire Timers_CLRX3             ;
  wire Timers_CLRX4             ;
  wire Timers_CLRX5             ;
  wire Timers_CLRX6             ;
  wire Timers_CLRX7             ;
  
  wire [2:0]  OMS               ;
  wire [2:0]  OMSX1             ;
  wire [2:0]  OMSX2             ;
  wire [2:0]  OMSX3             ;
  wire [2:0]  OMSX4             ;
  wire [2:0]  OMSX5             ;
  wire [2:0]  OMSX6             ;
  wire [2:0]  OMSX7             ;
         
  wire IVT                      ; 
  wire IVTX1                    ;
  wire IVTX2                    ;
  wire IVTX3                    ;
  wire IVTX4                    ;
  wire IVTX5                    ;
  wire IVTX6                    ;
  wire IVTX7                    ;
 

   
  wire  PWM_O                   ;
  
  wire        SCANENABLE        ;
  wire        SCANINPCLK        ;
  wire        SCANOUTPCLK       ;



  //Timers0 
  reg  [15:0]  R0            ;            
  reg  [7:0]   R1            ;
  reg  [7:0]   R2            ;
  reg  [15:0]  R3            ;  
  reg  [15:0]  R4            ;  
 
  //Timers1 
  reg  [15:0]  R0X1          ;            
  reg  [7:0]   R1X1          ;
  reg  [7:0]   R2X1          ;
  reg  [15:0]  R3X1          ;  
  reg  [15:0]  R4X1          ;

  //Timers2 
  reg  [15:0]  R0X2          ;            
  reg  [7:0]   R1X2          ;
  reg  [7:0]   R2X2          ;
  reg  [15:0]  R3X2          ;  
  reg  [15:0]  R4X2          ;
  
  //Timers3 
  reg  [15:0]  R0X3          ;            
  reg  [7:0]   R1X3          ;
  reg  [7:0]   R2X3          ;
  reg  [15:0]  R3X3          ;  
  reg  [15:0]  R4X3          ;
  
  //Timers4 
  reg  [15:0]  R0X4          ;            
  reg  [7:0]   R1X4          ;
  reg  [7:0]   R2X4          ;
  reg  [15:0]  R3X4          ;  
  reg  [15:0]  R4X4          ;
  
  //Timers5 
  reg  [15:0]  R0X5          ;            
  reg  [7:0]   R1X5          ;
  reg  [7:0]   R2X5          ;
  reg  [15:0]  R3X5          ;  
  reg  [15:0]  R4X5          ;
  
  //Timers6 
  reg  [15:0]  R0X6          ;            
  reg  [7:0]   R1X6          ;
  reg  [7:0]   R2X6          ;
  reg  [15:0]  R3X6          ;  
  reg  [15:0]  R4X6          ;
  
  //Timers7 
  reg  [15:0]  R0X7          ;            
  reg  [7:0]   R1X7          ;
  reg  [7:0]   R2X7          ;
  reg  [15:0]  R3X7          ;  
  reg  [15:0]  R4X7          ;
  
  wire         INT_TOF       ;     //Overflow[16'hFFFF Interrupt
  wire         INT_TOFX1     ;
  wire         INT_TOFX2     ;
  wire         INT_TOFX3     ;
  wire         INT_TOFX4     ;
  wire         INT_TOFX5     ;
  wire         INT_TOFX6     ;
  wire         INT_TOFX7     ;     
  
  wire         INT_TMC       ;     //Match Interrupt To Interrupt 
  wire         INT_TMCX1     ;
  wire         INT_TMCX2     ;
  wire         INT_TMCX3     ;
  wire         INT_TMCX4     ;
  wire         INT_TMCX5     ;
  wire         INT_TMCX6     ;
  wire         INT_TMCX7     ;
//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// Only respond to valid APB transfers
  assign Valid = (PSEL & (!PENABLE));
  
//------------------------------------------------------------------------------
// Internal register address decoding
//------------------------------------------------------------------------------
// The enables are set when the register is addressed and HWRITE is set.
//  By default, the register enables are all deselected.

//------------------------------------------------------------------------------  
//Timer 0
//------------------------------------------------------------------------------
//Timer Data register<TDATx[15:0]>
  assign R0En = ((PADDR[7:2] == `ADDRREG0) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0x00

  //Timer Prescaler register<TPREx[7:0]>
  assign R1En = ((PADDR[7:2] == `ADDRREG1) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x04
 
  //Timer Control register<TCONx[7:0]>
  assign R2En = ((PADDR[7:2] == `ADDRREG2) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x08
   //synopsys translate_off               
  //Timer Count Register<CV[15:0]>
  assign R3En = ((PADDR[7:2] == `ADDRREG3) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x0C
                
  //PWM end registers<CV[15:0]>
  assign R4En = ((PADDR[7:2] == `ADDRREG4) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x10               
   //synopsys translate_on 

//------------------------------------------------------------------------------   
//Timer 1
//------------------------------------------------------------------------------
//Timer Data register<TDATx[15:0]>
  assign R0EnX = ((PADDR[7:2] == `ADDRREGX20) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0x20

  //Timer Prescaler register<TPREx[7:0]>
  assign R1EnX = ((PADDR[7:2] == `ADDRREGX24) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x24
 
  //Timer Control register<TCONx[7:0]>
  assign R2EnX = ((PADDR[7:2] == `ADDRREGX28) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x28
  
  //synopsys translate_off              
  //Timer Count Register<CV[15:0]>
  assign R3EnX = ((PADDR[7:2] == `ADDRREGX2C) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x2C
                
  //PWM end registers<CV[15:0]>
  assign R4EnX = ((PADDR[7:2] == `ADDRREGX30) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x30               
  //synopsys translate_on 

//------------------------------------------------------------------------------
//Timer 2
//------------------------------------------------------------------------------
//Timer Data register<TDATx[15:0]>
  assign R0EnXX = ((PADDR[7:2] == `ADDRREGX40) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0x40

  //Timer Prescaler register<TPREx[7:0]>
  assign R1EnXX = ((PADDR[7:2] == `ADDRREGX44) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x44
 
  //Timer Control register<TCONx[7:0]>
  assign R2EnXX = ((PADDR[7:2] == `ADDRREGX48) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x48
  
  //synopsys translate_off              
  //Timer Count Register<CV[15:0]>
  assign R3EnXX = ((PADDR[7:2] == `ADDRREGX4C) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x4C
                
  //PWM end registers<CV[15:0]>
  assign R4EnXX = ((PADDR[7:2] == `ADDRREGX50) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x50               
  //synopsys translate_on 

//------------------------------------------------------------------------------
//Timer 3
//------------------------------------------------------------------------------
//Timer Data register<TDATx[15:0]>
  assign R0EnXXX = ((PADDR[7:2] == `ADDRREGX60) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0x60

  //Timer Prescaler register<TPREx[7:0]>
  assign R1EnXXX = ((PADDR[7:2] == `ADDRREGX64) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x64
 
  //Timer Control register<TCONx[7:0]>
  assign R2EnXXX = ((PADDR[7:2] == `ADDRREGX68) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x68
  
  //synopsys translate_off              
  //Timer Count Register<CV[15:0]>
  assign R3EnXXX = ((PADDR[7:2] == `ADDRREGX6C) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x6C
                
  //PWM end registers<CV[15:0]>
  assign R4EnXXX = ((PADDR[7:2] == `ADDRREGX70) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x70               
  //synopsys translate_on 


//------------------------------------------------------------------------------
//Timer 4
//------------------------------------------------------------------------------
//Timer Data register<TDATx[15:0]>
  assign R0EnXXXX = ((PADDR[7:2] == `ADDRREGX80) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0x80

  //Timer Prescaler register<TPREx[7:0]>
  assign R1EnXXXX = ((PADDR[7:2] == `ADDRREGX84) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x84
 
  //Timer Control register<TCONx[7:0]>
  assign R2EnXXXX = ((PADDR[7:2] == `ADDRREGX88) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x88
  
  //synopsys translate_off              
  //Timer Count Register<CV[15:0]>
  assign R3EnXXXX = ((PADDR[7:2] == `ADDRREGX8C) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x8C
                
  //PWM end registers<CV[15:0]>
  assign R4EnXXXX = ((PADDR[7:2] == `ADDRREGX90) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x90               
  //synopsys translate_on 

//------------------------------------------------------------------------------
//Timer 5
//------------------------------------------------------------------------------
//Timer Data register<TDATx[15:0]>
  assign R0EnX_XXXX = ((PADDR[7:2] == `ADDRREGXA0) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0xA0

  //Timer Prescaler register<TPREx[7:0]>
  assign R1EnX_XXXX = ((PADDR[7:2] == `ADDRREGXA4) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0xA4
 
  //Timer Control register<TCONx[7:0]>
  assign R2EnX_XXXX = ((PADDR[7:2] == `ADDRREGXA8) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0xA8
  
  //synopsys translate_off              
  //Timer Count Register<CV[15:0]>
  assign R3EnX_XXXX = ((PADDR[7:2] == `ADDRREGXAC) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0xAC
                
  //PWM end registers<CV[15:0]>
  assign R4EnX_XXXX = ((PADDR[7:2] == `ADDRREGXB0) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0xB0               
  //synopsys translate_on 

//------------------------------------------------------------------------------
//Timer 6
//------------------------------------------------------------------------------
//Timer Data register<TDATx[15:0]>
  assign R0EnXX_XXXX = ((PADDR[7:2] == `ADDRREGXC0) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0xC0

  //Timer Prescaler register<TPREx[7:0]>
  assign R1EnXX_XXXX = ((PADDR[7:2] == `ADDRREGXC4) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0xC4
 
  //Timer Control register<TCONx[7:0]>
  assign R2EnXX_XXXX = ((PADDR[7:2] == `ADDRREGXC8) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0xC8
  
  //synopsys translate_off              
  //Timer Count Register<CV[15:0]>
  assign R3EnXX_XXXX = ((PADDR[7:2] == `ADDRREGXCC) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0xCC
                
  //PWM end registers<CV[15:0]>
  assign R4EnXX_XXXX = ((PADDR[7:2] == `ADDRREGXD0) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0xD0               
  //synopsys translate_on 

//------------------------------------------------------------------------------
//Timer 7
//------------------------------------------------------------------------------
//Timer Data register<TDATx[15:0]>
  assign R0EnXXX_XXXX = ((PADDR[7:2] == `ADDRREGXE0) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0xE0

  //Timer Prescaler register<TPREx[7:0]>
  assign R1EnXXX_XXXX = ((PADDR[7:2] == `ADDRREGXE4) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0xE4
 
  //Timer Control register<TCONx[7:0]>
  assign R2EnXXX_XXXX = ((PADDR[7:2] == `ADDRREGXE8) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0xE8
  
  //synopsys translate_off              
  //Timer Count Register<CV[15:0]>
  assign R3EnXXX_XXXX = ((PADDR[7:2] == `ADDRREGXEC) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0xEC
                
  //PWM end registers<CV[15:0]>
  assign R4EnXXX_XXXX = ((PADDR[7:2] == `ADDRREGXF0) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0xF0               
  //synopsys translate_on 
    
//==============================================================================
// Read/write registers
//==============================================================================
// When written to, these registers will hold their values.
// Register 0 : Timer Data register[0x01FF_8400]
// TDATx[15:0][Initial Value<0xFFFF>]
// 
//==============================================================================

//Timers0
always @ (posedge PCLK or negedge PRESETn)
      begin : p_R0_Update
       if ((!PRESETn))     
         R0 <= 16'hFFFF ;
         else
           if (R0En)
               R0 <= PWDATA[15:0] ;
           else if (TDX_Up)
               R0 <= Timer_Cnt ;
               end

//Timers1
always @ (posedge PCLK or negedge PRESETn)
      begin : p_R0X1_Update
       if ((!PRESETn))     
         R0X1 <= 16'hFFFF ;
         else
           if (R0EnX)
               R0X1 <= PWDATA[15:0] ;
           else if (TDX_Up)
               R0X1 <= Timer_CntX1 ;
               end

//Timers2
always @ (posedge PCLK or negedge PRESETn)
      begin : p_R0X2_Update
       if ((!PRESETn))     
         R0X2 <= 16'hFFFF ;
         else
           if (R0EnXX)
               R0X2 <= PWDATA[15:0] ;
           else if (TDX_Up)
               R0X2 <= Timer_CntX2 ;
               end
                                  

//Timers3
always @ (posedge PCLK or negedge PRESETn)
      begin : p_R0X3_Update
       if ((!PRESETn))     
         R0X3 <= 16'hFFFF ;
         else
           if (R0EnXXX)
               R0X3 <= PWDATA[15:0] ;
           else if (TDX_Up)
               R0X3 <= Timer_CntX3 ;
               end
                       
//Timers4
always @ (posedge PCLK or negedge PRESETn)
      begin : p_R0X4_Update
       if ((!PRESETn))     
         R0X4 <= 16'hFFFF ;
         else
           if (R0EnXXXX)
               R0X4 <= PWDATA[15:0] ;
           else if (TDX_Up)
               R0X4 <= Timer_CntX4 ;
               end                       

//Timers5
always @ (posedge PCLK or negedge PRESETn)
      begin : p_R0X5_Update
       if ((!PRESETn))     
         R0X5 <= 16'hFFFF ;
         else
           if (R0EnX_XXXX)
               R0X5 <= PWDATA[15:0] ;
           else if (TDX_Up)
               R0X5 <= Timer_CntX5 ;
               end                       

//Timers6
always @ (posedge PCLK or negedge PRESETn)
      begin : p_R0X6_Update
       if ((!PRESETn))     
         R0X6 <= 16'hFFFF ;
         else
           if (R0EnXX_XXXX)
               R0X6 <= PWDATA[15:0] ;
           else if (TDX_Up)
               R0X6 <= Timer_CntX6 ;
               end                       
                        
//Timers7
always @ (posedge PCLK or negedge PRESETn)
      begin : p_R0X7_Update
       if ((!PRESETn))     
         R0X7 <= 16'hFFFF ;
         else
           if (R0EnXXX_XXXX)
               R0X7 <= PWDATA[15:0] ;
           else if (TDX_Up)
               R0X7 <= Timer_CntX7 ;
               end                                              

                        
//==============================================================================
// Timer prescale registers[0x01FF_8404]    
// Pre-Scale[7:0]:0xFF
// 
//============================================================================== 

//Timers0
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1Seq
      if ((!PRESETn))
        R1 <= 8'hFF;
      else
        if (R1En)
        R1 <= PWDATA[7:0];
    end

//Timers1
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1X1Seq
      if ((!PRESETn))
        R1X1 <= 8'hFF;
      else
        if (R1EnX)
        R1X1 <= PWDATA[7:0];
    end

//Timers2
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1X2Seq
      if ((!PRESETn))
        R1X2 <= 8'hFF;
      else
        if (R1EnXX)
        R1X2 <= PWDATA[7:0];
    end

//Timers3
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1X3Seq
      if ((!PRESETn))
        R1X3 <= 8'hFF;
      else
        if (R1EnXXX)
        R1X3 <= PWDATA[7:0];
    end

//Timers4
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1X4Seq
      if ((!PRESETn))
        R1X4 <= 8'hFF;
      else
        if (R1EnXXXX)
        R1X4 <= PWDATA[7:0];
    end

//Timers5
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1X5Seq
      if ((!PRESETn))
        R1X5 <= 8'hFF;
      else
        if (R1EnX_XXXX)
        R1X5 <= PWDATA[7:0];
    end

//Timers6
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1X6Seq
      if ((!PRESETn))
        R1X6 <= 8'hFF;
      else
        if (R1EnXX_XXXX)
        R1X6 <= PWDATA[7:0];
    end

//Timers7
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1X7Seq
      if ((!PRESETn))
        R1X7 <= 8'hFF;
      else
        if (R1EnXXX_XXXX)
        R1X7 <= PWDATA[7:0];
    end
//==============================================================================
// Timer Control Register[0x01FF_8408]    
// TCONx[7:0]:0x00
// TEN[7]|CL[6]|OMS[5:3]|ICS[2]|IVT[1]|Reserved
//============================================================================== 
 
 //Timers0
  always @(posedge PCLK or negedge PRESETn)
    begin : p_Reg2Seq
      if ((!PRESETn))
        R2 <= 8'hFF;
      else
        if (R2En)
        R2 <= PWDATA[7:0];
    end

 //Timers1
  always @(posedge PCLK or negedge PRESETn)
    begin : p_Reg2X1Seq
      if ((!PRESETn))
        R2X1 <= 8'hFF;
      else
        if (R2EnX)
        R2X1 <= PWDATA[7:0];
    end

 //Timers2
  always @(posedge PCLK or negedge PRESETn)
    begin : p_Reg2X2Seq
      if ((!PRESETn))
        R2X2 <= 8'hFF;
      else
        if (R2EnXX)
        R2X2 <= PWDATA[7:0];
    end

 //Timers3
  always @(posedge PCLK or negedge PRESETn)
    begin : p_Reg2X3Seq
      if ((!PRESETn))
        R2X3 <= 8'hFF;
      else
        if (R2EnXXX)
        R2X3 <= PWDATA[7:0];
    end


 //Timers4
  always @(posedge PCLK or negedge PRESETn)
    begin : p_Reg2X4Seq
      if ((!PRESETn))
        R2X4 <= 8'hFF;
      else
        if (R2EnXXXX)
        R2X4 <= PWDATA[7:0];
    end

 //Timers5
  always @(posedge PCLK or negedge PRESETn)
    begin : p_Reg2X5Seq
      if ((!PRESETn))
        R2X5 <= 8'hFF;
      else
        if (R2EnX_XXXX)
        R2X5 <= PWDATA[7:0];
    end

 //Timers6
  always @(posedge PCLK or negedge PRESETn)
    begin : p_Reg2X6Seq
      if ((!PRESETn))
        R2X6 <= 8'hFF;
      else
        if (R2EnXX_XXXX)
        R2X6 <= PWDATA[7:0];
    end

 //Timers7
  always @(posedge PCLK or negedge PRESETn)
    begin : p_Reg2X7Seq
      if ((!PRESETn))
        R2X7 <= 8'hFF;
      else
        if (R2EnXXX_XXXX)
        R2X7 <= PWDATA[7:0];
    end



//==============================================================================
// Timer counter Register[0x01FF_840C]    
// TCNTx<CV>[15:0]:0x00
// Current Timer's count value
//============================================================================== 
  //Timers 0
  always @(posedge PCLK or negedge PRESETn)
    begin : p_Reg3Seq
      if ((!PRESETn))
        R3 <= 16'h0000;
      else
        //if (R3En)
        //R3 <= PWDATA[15:0];
        R3 <= Timer_Cnt ;
    end

 //Timers 1
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg3X1Seq
      if ((!PRESETn))
        R3X1 <= 16'h0000;
      else
        R3X1 <= Timer_CntX1 ;
    end
    
 //Timers 2
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg3X2Seq
      if ((!PRESETn))
        R3X2 <= 16'h0000;
      else
        R3X2 <= Timer_CntX2 ;
    end

 //Timers 3
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg3X3Seq
      if ((!PRESETn))
        R3X3 <= 16'h0000;
      else
        R3X3 <= Timer_CntX3 ;
    end
    
 //Timers 4
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg3X4Seq
      if ((!PRESETn))
        R3X4 <= 16'h0000;
      else
        R3X4 <= Timer_CntX4 ;
    end
    
  //Timers 5
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg3X5Seq
      if ((!PRESETn))
        R3X5 <= 16'h0000;
      else
        R3X5 <= Timer_CntX5 ;
    end
    
  //Timers 6
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg3X6Seq
      if ((!PRESETn))
        R3X6 <= 16'h0000;
      else
        R3X6 <= Timer_CntX6 ;
    end
    
  //Timers 7
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg3X7Seq
      if ((!PRESETn))
        R3X7 <= 16'h0000;
      else
        R3X7 <= Timer_CntX7 ;
    end
        
        
    
     
//==============================================================================
// PWM end register[0x01FF_8410]    
// TCNTx[15:0]:0x00
// Current PWM's end count value during PWM operation
//============================================================================== 

//Timers 0
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg4Seq
      if ((!PRESETn))
        R4 <= 16'hFFFF;
      else
        //if (R4En)
        if(PWM_Pulse)
        R4 <= Timer_Cnt;
    end

//Timers 1
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg4X1Seq
      if ((!PRESETn))
        R4X1 <= 16'hFFFF;
      else
        if(PWM_PulseX1)
        R4X1 <= Timer_CntX1;
    end


//Timers 2
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg4X2Seq
      if ((!PRESETn))
        R4X2 <= 16'hFFFF;
      else
        if(PWM_PulseX2)
        R4X2 <= Timer_CntX2;
    end
           

//Timers 3
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg4X3Seq
      if ((!PRESETn))
        R4X3 <= 16'hFFFF;
      else
        if(PWM_PulseX3)
        R4X3 <=Timer_CntX3;
    end
           

//Timers 4
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg4X4Seq
      if ((!PRESETn))
        R4X4 <= 16'hFFFF;
      else
        if(PWM_PulseX4)
        R4X4 <= Timer_CntX3;
    end
           

//Timers 5
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg4X5Seq
      if ((!PRESETn))
        R4X5 <= 16'hFFFF;
      else
        if(PWM_PulseX5)
        R4X5 <= Timer_CntX5;
    end
           

//Timers 6
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg4X6Seq
      if ((!PRESETn))
        R4X6 <= 16'hFFFF;
      else
        if(PWM_PulseX6)
        R4X6 <= Timer_CntX6;
    end
           

//Timers 7
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg4X7Seq
      if ((!PRESETn))
        R4X7 <= 16'hFFFF;
      else
        if(PWM_PulseX7)
        R4X7 <= Timer_CntX7;
    end
           
                                                                             
//------------------------------------------------------------------------------
// PRDATA generation
//------------------------------------------------------------------------------
// Generates the read data from the internal register values.
//  Uses combinational logic to select the read data from the current data
//  held in the registers and passes this to the output register.
// Selection of read data from Peripheral and PrimeCell ID registers is 
//  separated from the nextPRDATA mux to reduce the depth of mux needed for
//  the registered data.

  always @ (PADDR or ReadRegs or ReadRegs1 or ReadRegs2 or ReadRegs3 or ReadRegs4 or 
                    ReadRegs5 or ReadRegs6 or ReadRegs7  
                    )
    begin : p_ReadMuxComb
      // Determine the next value of nextPRDATA
      case (PADDR[11:5]) 
        `EGAPBSLVREG  : nextPRDATA = ReadRegs  ;
        `EGAPBSLVREG1 : nextPRDATA = ReadRegs1 ;
        `EGAPBSLVREG2 : nextPRDATA = ReadRegs2 ;
        `EGAPBSLVREG3 : nextPRDATA = ReadRegs3 ;
        
        `EGAPBSLVREG4 : nextPRDATA = ReadRegs4 ;
        `EGAPBSLVREG5 : nextPRDATA = ReadRegs5 ;
        `EGAPBSLVREG6 : nextPRDATA = ReadRegs6 ;
        `EGAPBSLVREG7 : nextPRDATA = ReadRegs7 ;
                     
     //   `EASPA       : nextPRDATA = ReadIDs;
        default      : nextPRDATA = {32{1'b0}};  // Read as zero default
      endcase
    end



  always @ (PADDR or R0 or R1 or R2 or R3 or R4 or 
                     R0X1 or R0X2 or R0X3 or R0X4 or R0X5 or R0X6 or R0X7 or
                     R1X1 or R1X2 or R1X3 or R1X4 or R1X5 or R1X6 or R1X7 or
                     R2X1 or R2X2 or R2X3 or R2X4 or R2X5 or R2X6 or R2X7 or
                     R3X1 or R3X2 or R3X3 or R3X4 or R3X5 or R3X6 or R3X7 or
                     R4X1 or R4X2 or R4X3 or R4X4 or R4X5 or R4X6 or R4X7   )
                     
    begin : p_RdRegMuxComb
      // Determine the next value of ReadRegs0
      //case (PADDR[7:2])
        case (PADDR[4:2]) 
        //`ADDRREG0 : ReadRegs = {{16{1'b0}}, R0 } ;
        //`ADDRREG1 : ReadRegs = {24'd0, R1}     ;
        //`ADDRREG2 : ReadRegs = {24'd0, R2}     ;
        //`ADDRREG3 : ReadRegs = {16'd0, R3}     ;
        //`ADDRREG4 : ReadRegs = {16'd0, R4}     ;
       
        `SubADDR00 : begin
          ReadRegs  = {{16{1'b0}},  R0  } ;
          ReadRegs1 = {{16{1'b0}}, R0X1 } ;
          ReadRegs2 = {{16{1'b0}}, R0X2 } ;
          ReadRegs3 = {{16{1'b0}}, R0X3 } ;
          ReadRegs4 = {{16{1'b0}}, R0X4 } ;
          ReadRegs5 = {{16{1'b0}}, R0X5 } ;
          ReadRegs6 = {{16{1'b0}}, R0X6 } ;
          ReadRegs7 = {{16{1'b0}}, R0X7 } ;
                     end
          
        `SubADDR04 : begin
          ReadRegs  = {24'd0, R1  }       ;
          ReadRegs1 = {24'd0, R1X1}       ;
          ReadRegs2 = {24'd0, R1X2}       ;
          ReadRegs3 = {24'd0, R1X3}       ;
          ReadRegs4 = {24'd0, R1X4}       ;
          ReadRegs5 = {24'd0, R1X5}       ;
          ReadRegs6 = {24'd0, R1X6}       ;
          ReadRegs7 = {24'd0, R1X7}       ;
                     end
                     
        `SubADDR08 : begin 
          ReadRegs   = {24'd0, R2  }      ;
          ReadRegs1  = {24'd0, R2X1}      ;
          ReadRegs2  = {24'd0, R2X2}      ;
          ReadRegs3  = {24'd0, R2X3}      ;
          ReadRegs4  = {24'd0, R2X4}      ;
          ReadRegs5  = {24'd0, R2X5}      ;
          ReadRegs6  = {24'd0, R2X6}      ;
          ReadRegs7  = {24'd0, R2X7}      ;
                     end
        `SubADDR0C : begin
          ReadRegs   = {16'd0, R3  }      ;
          ReadRegs1  = {16'd0, R3X1}      ;
          ReadRegs2  = {16'd0, R3X2}      ;
          ReadRegs3  = {16'd0, R3X3}      ;
          ReadRegs4  = {16'd0, R3X4}      ;
          ReadRegs5  = {16'd0, R3X5}      ;
          ReadRegs6  = {16'd0, R3X6}      ;
          ReadRegs7  = {16'd0, R3X7}      ;
                    end
        `SubADDR10 : begin
          ReadRegs   = {16'd0, R4  }      ;
          ReadRegs1  = {16'd0, R4X1}      ;
          ReadRegs2  = {16'd0, R4X2}      ;
          ReadRegs3  = {16'd0, R4X3}      ;
          ReadRegs4  = {16'd0, R4X4}      ;
          ReadRegs5  = {16'd0, R4X5}      ;
          ReadRegs6  = {16'd0, R4X6}      ;
          ReadRegs7  = {16'd0, R4X7}      ;
                     end
        default   : begin
          ReadRegs   = {32{1'b0}}         ;  // Read as zero default
          ReadRegs1  = {32{1'b0}}         ; 
          ReadRegs2  = {32{1'b0}}         ; 
          ReadRegs3  = {32{1'b0}}         ; 
          ReadRegs4  = {32{1'b0}}         ; 
          ReadRegs5  = {32{1'b0}}         ; 
          ReadRegs6  = {32{1'b0}}         ; 
          ReadRegs7  = {32{1'b0}}         ; 
               end
 
      endcase
    end 



// The data presented on PRDATA is registered to reduce output delay.
//  Register contents are retained when the slave is not selected and also
//  when not being read.
  assign ReadRegEn = (Valid & (~PWRITE));

// APB Read Data Register
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_PrdataSeq
      if ((!PRESETn))
        iPRDATA <= {16{1'b0}};
      else
        if (ReadRegEn)
          iPRDATA <= nextPRDATA[15:0]; 
    end
 
// Drive output f?:UEDS:&aring;?:UEDS:&Agrave;rom internal register
  assign PRDATA = {16'd0, iPRDATA};

//============Function Gen==========================
//
//==================================================
// Register 0 : Timer Data register[0x01FF_8400]
// TDATx[15:0][Initial Value<0xFFFF>]
//==================================================
assign TDAT_Value    = R0   ;
assign TDAT_Value_X1 = R0X1 ;
assign TDAT_Value_X2 = R0X2 ;
assign TDAT_Value_X3 = R0X3 ;
assign TDAT_Value_X4 = R0X4 ;
assign TDAT_Value_X5 = R0X5 ;
assign TDAT_Value_X6 = R0X6 ; 
assign TDAT_Value_X7 = R0X7 ;   
//==================================================
// R1 :Timer prescale registers[0x01FF_8404]    
// Pre-Scale[7:0]:0xFF
//==================================================
//Common Prescaler
always @ (posedge PCLK or negedge PRESETn)
    begin : p_Prescale
     if ((!PRESETn))
         Prescale_Cnt <= {8{1'b0}};
         else begin
        Prescale_Cnt <=  Prescale_Cnt + 1 ;
           end 
            end

//Prescaler 
//`define  Prescale_para0 7'b0000_000 //X2   : 0~1
//`define  Prescale_para1 7'b0000_001 //X4   : 2~3
//`define  Prescale_para2 6'b0000_01  //X8   : 4~7
//`define  Prescale_para3 5'b0000_1   //X16   : 8~15
//`define  Prescale_para4 4'b0001     //X32  : 16~31
//`define  Prescale_para5 3'b001      //X64  : 32~63
//`define  Prescale_para6 2'b01       //X128  : 64~127    
//`define  Prescale_para7 1'b1        //X256 : 128~255

//Timers0
always @ (R1 or Prescale_Cnt )
    begin : p_Prescale_Clock
    
     if (R1[7:1] == `Prescale_para0) 
           Prescale_Clock = Prescale_Cnt[0]  ;  //X2
       
    else if (R1[7:1] == `Prescale_para1)
           Prescale_Clock = Prescale_Cnt[1] ;  //X4
       
    else if (R1[7:2] == `Prescale_para2)
           Prescale_Clock = Prescale_Cnt[2] ;  //X8  

    else if (R1[7:3] == `Prescale_para3)
           Prescale_Clock = Prescale_Cnt[3] ;  //X16
       
    else if (R1[7:4] == `Prescale_para4)
           Prescale_Clock = Prescale_Cnt[4] ;  //X32  
      
    else if (R1[7:5] == `Prescale_para5 )
           Prescale_Clock = Prescale_Cnt[5] ;  //X64
      
    else if (R1[7:6] == `Prescale_para6)
           Prescale_Clock = Prescale_Cnt[6] ;  //X128            
     else Prescale_Clock = Prescale_Cnt[7]   ;  //X256
              end

//Timers 1
always @ (R1X1 or Prescale_Cnt )
    begin : p_PrescaleX1_Clock
    
     if (R1X1[7:1] == `Prescale_para0)
           Prescale_ClockX1 = Prescale_Cnt[0]  ;  //X2
       
    else if (R1X1[7:1] == `Prescale_para1)
           Prescale_ClockX1 = Prescale_Cnt[1] ;  //X4
       
    else if (R1X1[7:2] == `Prescale_para2)
           Prescale_ClockX1 = Prescale_Cnt[2] ;  //X8  

    else if (R1X1[7:3] == `Prescale_para3)
           Prescale_ClockX1 = Prescale_Cnt[3] ;  //X16
       
    else if (R1X1[7:4] == `Prescale_para4)
           Prescale_ClockX1 = Prescale_Cnt[4] ;  //X32  
      
    else if (R1X1[7:5] == `Prescale_para5 )
           Prescale_ClockX1 = Prescale_Cnt[5] ;  //X64
      
    else if (R1X1[7:6] == `Prescale_para6)
           Prescale_ClockX1 = Prescale_Cnt[6] ;  //X128
        
    else Prescale_ClockX1 = Prescale_Cnt[7]   ;  //X256
              end

//Timers 2
always @ (R1X2 or Prescale_Cnt )
    begin : p_PrescaleX2_Clock
    
     if (R1X2[7:1] == `Prescale_para0)
           Prescale_ClockX2 = Prescale_Cnt[0]  ;  //2
       
    else if (R1X2[7:1] == `Prescale_para1)
           Prescale_ClockX2 = Prescale_Cnt[1] ;  //4
       
    else if (R1X2[7:2] == `Prescale_para2)
           Prescale_ClockX2 = Prescale_Cnt[2] ;  //8  

    else if (R1X2[7:3] == `Prescale_para3)
           Prescale_ClockX2 = Prescale_Cnt[3] ;  //16
       
    else if (R1X2[7:4] == `Prescale_para4)
           Prescale_ClockX2 = Prescale_Cnt[4] ;  //32  
      
    else if (R1X2[7:5] == `Prescale_para5 )
           Prescale_ClockX2 = Prescale_Cnt[5] ;  //64
      
    else if (R1X2[7:6] == `Prescale_para6)
           Prescale_ClockX2 = Prescale_Cnt[6] ;  //128
        
    else Prescale_ClockX2 = Prescale_Cnt[7]   ;  //256
              end              
        

//Timers 3
always @ (R1X3 or Prescale_Cnt )
    begin : p_PrescaleX3_Clock
    
     if (R1X3[7:1] == `Prescale_para0)
           Prescale_ClockX3 = Prescale_Cnt[0]  ;  //2
       
    else if (R1X3[7:1] == `Prescale_para1)
           Prescale_ClockX3 = Prescale_Cnt[1] ;  //4
       
    else if (R1X3[7:2] == `Prescale_para2)
           Prescale_ClockX3 = Prescale_Cnt[2] ;  //8  

    else if (R1X3[7:3] == `Prescale_para3)
           Prescale_ClockX3 = Prescale_Cnt[3] ;  //16
       
    else if (R1X3[7:4] == `Prescale_para4)
           Prescale_ClockX3 = Prescale_Cnt[4] ;  //32  
      
    else if (R1X3[7:5] == `Prescale_para5 )
           Prescale_ClockX3 = Prescale_Cnt[5] ;  //64
      
    else if (R1X3[7:6] == `Prescale_para6)
           Prescale_ClockX3 = Prescale_Cnt[6] ;  //128
        
    else Prescale_ClockX3 = Prescale_Cnt[7]   ;  //256
              end

//Timers 4
always @ (R1X4 or Prescale_Cnt )
    begin : p_PrescaleX4_Clock
    
     if (R1X4[7:1] == `Prescale_para0)
           Prescale_ClockX4 = Prescale_Cnt[0]  ;  //2
       
    else if (R1X4[7:1] == `Prescale_para1)
           Prescale_ClockX4 = Prescale_Cnt[1] ;  //4
       
    else if (R1X4[7:2] == `Prescale_para2)
           Prescale_ClockX4 = Prescale_Cnt[2] ;  //8  

    else if (R1X4[7:3] == `Prescale_para3)
           Prescale_ClockX4 = Prescale_Cnt[3] ;  //16
       
    else if (R1X4[7:4] == `Prescale_para4)
           Prescale_ClockX4 = Prescale_Cnt[4] ;  //32  
      
    else if (R1X4[7:5] == `Prescale_para5 )
           Prescale_ClockX4 = Prescale_Cnt[5] ;  //64
      
    else if (R1X4[7:6] == `Prescale_para6)
           Prescale_ClockX4 = Prescale_Cnt[6] ;  //128
        
    else Prescale_ClockX4 = Prescale_Cnt[7]   ;  //256
              end


//Timers 5
always @ (R1X5 or Prescale_Cnt )
    begin : p_PrescaleX5_Clock
    
     if (R1X5[7:1] == `Prescale_para0)
           Prescale_ClockX5 = Prescale_Cnt[0]  ;  //2
       
    else if (R1X5[7:1] == `Prescale_para1)
           Prescale_ClockX5 = Prescale_Cnt[1] ;  //4
       
    else if (R1X5[7:2] == `Prescale_para2)
           Prescale_ClockX5 = Prescale_Cnt[2] ;  //8  

    else if (R1X5[7:3] == `Prescale_para3)
           Prescale_ClockX5 = Prescale_Cnt[3] ;  //16
       
    else if (R1X5[7:4] == `Prescale_para4)
           Prescale_ClockX5 = Prescale_Cnt[4] ;  //32  
      
    else if (R1X5[7:5] == `Prescale_para5 )
           Prescale_ClockX5 = Prescale_Cnt[5] ;  //64
      
    else if (R1X5[7:6] == `Prescale_para6)
           Prescale_ClockX5 = Prescale_Cnt[6] ;  //128
        
    else Prescale_ClockX5 = Prescale_Cnt[7]   ;  //256
              end

//Timers 6
always @ (R1X6 or Prescale_Cnt )
    begin : p_PrescaleX6_Clock
    
     if (R1X6[7:1] == `Prescale_para0)
           Prescale_ClockX6 = Prescale_Cnt[0]  ;  //2
       
    else if (R1X6[7:1] == `Prescale_para1)
           Prescale_ClockX6 = Prescale_Cnt[1] ;  //4
       
    else if (R1X6[7:2] == `Prescale_para2)
           Prescale_ClockX6 = Prescale_Cnt[2] ;  //8  

    else if (R1X6[7:3] == `Prescale_para3)
           Prescale_ClockX6 = Prescale_Cnt[3] ;  //16
       
    else if (R1X6[7:4] == `Prescale_para4)
           Prescale_ClockX6 = Prescale_Cnt[4] ;  //32  
      
    else if (R1X6[7:5] == `Prescale_para5 )
           Prescale_ClockX6 = Prescale_Cnt[5] ;  //64
      
    else if (R1X6[7:6] == `Prescale_para6)
           Prescale_ClockX6 = Prescale_Cnt[6] ;  //128
        
    else Prescale_ClockX6 = Prescale_Cnt[7]   ;  //256
              end


//Timers 7
always @ (R1X7 or Prescale_Cnt )
    begin : p_PrescaleX7_Clock
    
     if (R1X7[7:1] == `Prescale_para0)
           Prescale_ClockX7 = Prescale_Cnt[0]  ;  //2
       
    else if (R1X7[7:1] == `Prescale_para1)
           Prescale_ClockX7 = Prescale_Cnt[1] ;  //4
       
    else if (R1X7[7:2] == `Prescale_para2)
           Prescale_ClockX7 = Prescale_Cnt[2] ;  //8  

    else if (R1X7[7:3] == `Prescale_para3)
           Prescale_ClockX7 = Prescale_Cnt[3] ;  //16
       
    else if (R1X7[7:4] == `Prescale_para4)
           Prescale_ClockX7 = Prescale_Cnt[4] ;  //32  
      
    else if (R1X7[7:5] == `Prescale_para5 )
           Prescale_ClockX7 = Prescale_Cnt[5] ;  //64
      
    else if (R1X7[7:6] == `Prescale_para6)
           Prescale_ClockX7 = Prescale_Cnt[6] ;  //128
        
    else Prescale_ClockX7 = Prescale_Cnt[7]   ;  //256
              end

                                             
//==============================================================================
// R2:Timer Control Register[0x01FF_8408]    
// TCONx[7:0]:0x00
// TEN[7]|CL[6]|OMS[5:3]|ICS[2]|IVT[1]|Reserved
//==============================================================================                    
  
assign ICS      = R2[2]     ;
assign ICSX1    = R2X1[2]   ;
assign ICSX2    = R2X2[2]   ;
assign ICSX3    = R2X3[2]   ;
assign ICSX4    = R2X4[2]   ;
assign ICSX5    = R2X5[2]   ;
assign ICSX6    = R2X6[2]   ;
assign ICSX7    = R2X7[2]   ;


assign TEN      = R2[7]     ;
assign TENX1    = R2X1[7]   ;
assign TENX2    = R2X2[7]   ;
assign TENX3    = R2X3[7]   ;
assign TENX4    = R2X4[7]   ;
assign TENX5    = R2X5[7]   ;
assign TENX6    = R2X6[7]   ;
assign TENX7    = R2X7[7]   ;


assign CL_Bit   = R2[6]     ;
assign CL_BitX1 = R2X1[6]   ;
assign CL_BitX2 = R2X2[6]   ;
assign CL_BitX3 = R2X3[6]   ;
assign CL_BitX4 = R2X4[6]   ;
assign CL_BitX5 = R2X5[6]   ;
assign CL_BitX6 = R2X6[6]   ;
assign CL_BitX7 = R2X7[6]   ;


assign OMS      = R2[5:3]   ;
assign OMSX1    = R2X1[5:3] ;
assign OMSX2    = R2X2[5:3] ;
assign OMSX3    = R2X3[5:3] ;
assign OMSX4    = R2X4[5:3] ;
assign OMSX5    = R2X5[5:3] ;
assign OMSX6    = R2X6[5:3] ;
assign OMSX7    = R2X7[5:3] ;
  
//DFT Check: Select 1-2
//1
//assign Timers_CLK = (SCANENABLE )? TCLK0    : (ICS? TCLK0: Prescale_Clock) ; 
//2
//Timers 0
assign Timers_CLK = (SCANENABLE )? PCLK    : ( ICS     ? TCLK0: Prescale_Clock) ;  
assign Timers_CLR = (SCANENABLE )? PRESETn : ( PRESETn & (~CL_Bit) )            ;

//Timers 1
assign Timers_CLKX1 = (SCANENABLE )? PCLK    : ( ICSX1    ? TCLK1: Prescale_ClockX1) ;  
assign Timers_CLRX1 = (SCANENABLE )? PRESETn : ( PRESETn & (~CL_BitX1) )              ;

//Timers 2
assign Timers_CLKX2 = (SCANENABLE )? PCLK    : ( ICSX2    ? TCLK2: Prescale_ClockX2) ;  
assign Timers_CLRX2 = (SCANENABLE )? PRESETn : ( PRESETn & (~CL_BitX2) )              ;

//Timers 3
assign Timers_CLKX3 = (SCANENABLE )? PCLK    : ( ICSX3     ? TCLK3: Prescale_ClockX3) ;  
assign Timers_CLRX3 = (SCANENABLE )? PRESETn : ( PRESETn & (~CL_BitX3) )              ;

//Timers 4
assign Timers_CLKX4 = (SCANENABLE )? PCLK    : ( ICSX4     ? TCLK4: Prescale_ClockX4) ;  
assign Timers_CLRX4 = (SCANENABLE )? PRESETn : ( PRESETn & (~CL_BitX4) )              ;

//Timers 5
assign Timers_CLKX5 = (SCANENABLE )? PCLK    : ( ICSX1     ? TCLK5: Prescale_ClockX5) ;  
assign Timers_CLRX5 = (SCANENABLE )? PRESETn : ( PRESETn & (~CL_BitX5) )              ;

//Timers 6
assign Timers_CLKX6 = (SCANENABLE )? PCLK    : ( ICSX6     ? TCLK0: Prescale_ClockX6) ;  
assign Timers_CLRX6 = (SCANENABLE )? PRESETn : ( PRESETn & (~CL_BitX6) )              ;

//Timers 6
assign Timers_CLKX7 = (SCANENABLE )? PCLK    : ( ICSX7     ? TCLK0: Prescale_ClockX7) ;  
assign Timers_CLRX7 = (SCANENABLE )? PRESETn : ( PRESETn & (~CL_BitX7) )              ;

//-------------------------------------------------------
// OverFlow
//-------------------------------------------------------          
                                                                    
//Timers 0                       
/*always @ (posedge Timers_CLK or negedge Timers_CLR)
          begin : p_Overflow
          if ((!Timers_CLR))
                Timers_OverFlow      <= 1'b0 ;
               else begin
                 if ( Timer_Cnt == `Overflow_Value)
                      Timers_OverFlow <= 1'b1 ;
                 else Timers_OverFlow <= 1'b0 ;
                    end 
                     end
*/                     
//---------------------------------------------------------------------------------------
// 16-Bit Timer Counter
//---------------------------------------------------------------------------------------

//Timers 0
always @ (posedge Timers_CLK or negedge Timers_CLR)
    begin : p_Timers_Count
     if ((!Timers_CLR))
      Timer_Cnt <= {16{1'b0}};
      else begin
        if (~TEN) 
         Timer_Cnt <= {16{1'b0}}; 
      else begin //2
       if (OMS == `OMSCode0  ) begin 
      if (Timer_Cnt == TDAT_Value   )
             Timer_Cnt <=  {16{1'b0}}; 
       else  Timer_Cnt <= Timer_Cnt + 1 ;
                              end
         else begin//1
             Timer_Cnt <= Timer_Cnt + 1 ;                     
         end //1
         end //2
          end 
           end


//Timers 1
always @ (posedge Timers_CLKX1 or negedge Timers_CLRX1)
    begin : p_TimersX1_Count
     if ((!Timers_CLRX1))
      Timer_CntX1 <= {16{1'b0}};
      else begin
        if (~TENX1) 
         Timer_CntX1 <= {16{1'b0}}; 
      else begin //2
       if (OMSX1 == `OMSCode0  ) begin 
      if (Timer_CntX1 == TDAT_Value_X1   )
             Timer_CntX1 <=  {16{1'b0}}; 
       else  Timer_CntX1 <= Timer_CntX1 + 1 ;
                              end
         else begin//1
             Timer_CntX1 <= Timer_CntX1 + 1 ;                     
         end //1
         end //2
          end 
           end

//Timers 2
always @ (posedge Timers_CLKX2 or negedge Timers_CLRX2)
    begin : p_TimersX2_Count
     if ((!Timers_CLRX2))
      Timer_CntX2 <= {16{1'b0}};
      else begin
        if (~TENX2) 
         Timer_CntX2 <= {16{1'b0}}; 
      else begin //2
       if (OMSX2 == `OMSCode0  ) begin 
      if (Timer_CntX2 == TDAT_Value_X2   )
             Timer_CntX2 <=  {16{1'b0}}; 
       else  Timer_CntX2 <= Timer_CntX2 + 1 ;
                              end
         else begin//1
             Timer_CntX2 <= Timer_CntX2 + 1 ;                     
         end //1
         end //2
          end 
           end


//Timers 3
always @ (posedge Timers_CLKX3 or negedge Timers_CLRX3)
    begin : p_TimersX3_Count
     if ((!Timers_CLRX3))
      Timer_CntX3 <= {16{1'b0}};
      else begin
        if (~TENX3) 
         Timer_CntX3 <= {16{1'b0}}; 
      else begin //2
       if (OMSX3 == `OMSCode0  ) begin 
      if (Timer_CntX3 == TDAT_Value_X3   )
             Timer_CntX3 <=  {16{1'b0}}; 
       else  Timer_CntX3 <= Timer_CntX3 + 1 ;
                              end
         else begin//1
             Timer_CntX3 <= Timer_CntX3 + 1 ;                     
         end //1
         end //2
          end 
           end

//Timers 4
always @ (posedge Timers_CLKX4 or negedge Timers_CLRX4)
    begin : p_TimersX4_Count
     if ((!Timers_CLRX4))
      Timer_CntX4 <= {16{1'b0}};
      else begin
        if (~TENX4) 
         Timer_CntX4 <= {16{1'b0}}; 
      else begin //2
       if (OMSX4 == `OMSCode0  ) begin 
      if (Timer_CntX4 == TDAT_Value_X4   )
             Timer_CntX4 <=  {16{1'b0}}; 
       else  Timer_CntX4 <= Timer_CntX4 + 1 ;
                              end
         else begin//1
             Timer_CntX4 <= Timer_CntX4 + 1 ;                     
         end //1
         end //2
          end 
           end

           
//Timers 5
always @ (posedge Timers_CLKX5 or negedge Timers_CLRX5)
    begin : p_TimersX5_Count
     if ((!Timers_CLRX5))
      Timer_CntX5 <= {16{1'b0}};
      else begin
        if (~TENX5) 
         Timer_CntX5 <= {16{1'b0}}; 
      else begin //2
       if (OMSX5 == `OMSCode0  ) begin 
      if (Timer_CntX5 == TDAT_Value_X5   )
             Timer_CntX5 <=  {16{1'b0}}; 
       else  Timer_CntX5 <= Timer_CntX5 + 1 ;
                              end
         else begin//1
             Timer_CntX5 <= Timer_CntX5 + 1 ;                     
         end //1
         end //2
          end 
           end           

//Timers 6
always @ (posedge Timers_CLKX6 or negedge Timers_CLRX6)
    begin : p_TimersX6_Count
     if ((!Timers_CLRX6))
      Timer_CntX6 <= {16{1'b0}};
      else begin
        if (~TENX6) 
         Timer_CntX6 <= {16{1'b0}}; 
      else begin //2
       if (OMSX6 == `OMSCode0  ) begin 
      if (Timer_CntX6 == TDAT_Value_X6   )
             Timer_CntX6 <=  {16{1'b0}}; 
       else  Timer_CntX6 <= Timer_CntX6 + 1 ;
                              end
         else begin//1
             Timer_CntX6 <= Timer_CntX6 + 1 ;                     
         end //1
         end //2
          end 
           end

//Timers 7
always @ (posedge Timers_CLKX7 or negedge Timers_CLRX7)
    begin : p_TimersX7_Count
     if ((!Timers_CLRX7))
      Timer_CntX7 <= {16{1'b0}};
      else begin
        if (~TENX7) 
         Timer_CntX7 <= {16{1'b0}}; 
      else begin //2
       if (OMSX7 == `OMSCode0  ) begin 
      if (Timer_CntX7 == TDAT_Value_X7   )
             Timer_CntX7 <=  {16{1'b0}}; 
       else  Timer_CntX7 <= Timer_CntX7 + 1 ;
                              end
         else begin//1
             Timer_CntX7 <= Timer_CntX7 + 1 ;                     
         end //1
         end //2
          end 
           end

//---------------------------------------------------
// OverFlow           
//---------------------------------------------------
//Timers 0                       
always @ (posedge Timers_CLK or negedge Timers_CLR)
          begin : p_Overflow
          if ((!Timers_CLR))
                Timers_OverFlow      <= 1'b0 ;
               else begin
                 if ( Timer_Cnt == `Overflow_Value)
                      Timers_OverFlow <= 1'b1 ;
                 else Timers_OverFlow <= 1'b0 ;
                    end 
                     end

//Timers 1                       
always @ (posedge Timers_CLKX1 or negedge Timers_CLRX1)
          begin : p_OverflowX1
          if ((!Timers_CLRX1))
                Timers_OverFlowX1      <= 1'b0 ;
               else begin
                 if ( Timer_CntX1 == `Overflow_Value)
                      Timers_OverFlowX1 <= 1'b1 ;
                 else Timers_OverFlowX1 <= 1'b0 ;
                    end 
                     end                     

//Timers 2                       
always @ (posedge Timers_CLKX2 or negedge Timers_CLRX2)
          begin : p_OverflowX2
          if ((!Timers_CLRX2))
                Timers_OverFlowX2      <= 1'b0 ;
               else begin
                 if ( Timer_CntX2 == `Overflow_Value)
                      Timers_OverFlowX2 <= 1'b1 ;
                 else Timers_OverFlowX2 <= 1'b0 ;
                    end 
                     end                     
                                          

//Timers 3                       
always @ (posedge Timers_CLKX3 or negedge Timers_CLRX3)
          begin : p_OverflowX3
          if ((!Timers_CLRX3))
                Timers_OverFlowX3      <= 1'b0 ;
               else begin
                 if ( Timer_CntX3 == `Overflow_Value)
                      Timers_OverFlowX3 <= 1'b1 ;
                 else Timers_OverFlowX3 <= 1'b0 ;
                    end 
                     end                     

//Timers 4                       
always @ (posedge Timers_CLKX4 or negedge Timers_CLRX4)
          begin : p_OverflowX4
          if ((!Timers_CLRX4))
                Timers_OverFlowX4      <= 1'b0 ;
               else begin
                 if ( Timer_CntX4 == `Overflow_Value)
                      Timers_OverFlowX4 <= 1'b1 ;
                 else Timers_OverFlowX4 <= 1'b0 ;
                    end 
                     end                     
                     
//Timers 5                       
always @ (posedge Timers_CLKX5 or negedge Timers_CLRX5)
          begin : p_OverflowX5
          if ((!Timers_CLRX5))
                Timers_OverFlowX5      <= 1'b0 ;
               else begin
                 if ( Timer_CntX5 == `Overflow_Value)
                      Timers_OverFlowX5 <= 1'b1 ;
                 else Timers_OverFlowX5 <= 1'b0 ;
                    end 
                     end                     

//Timers 6                       
always @ (posedge Timers_CLKX6 or negedge Timers_CLRX6)
          begin : p_OverflowX6
          if ((!Timers_CLRX6))
                Timers_OverFlowX6      <= 1'b0 ;
               else begin
                 if ( Timer_CntX6 == `Overflow_Value)
                      Timers_OverFlowX6 <= 1'b1 ;
                 else Timers_OverFlowX6 <= 1'b0 ;
                    end 
                     end                     

//Timers 7                       
always @ (posedge Timers_CLKX7 or negedge Timers_CLRX7)
          begin : p_OverflowX7
          if ((!Timers_CLRX7))
                Timers_OverFlowX7      <= 1'b0 ;
               else begin
                 if ( Timer_CntX7 == `Overflow_Value)
                      Timers_OverFlowX7 <= 1'b1 ;
                 else Timers_OverFlowX7 <= 1'b0 ;
                    end 
                     end                     


//Timer 0 ~ 7                         
assign INT_TOF   = Timers_OverFlow   ;                       
assign INT_TOFX1 = Timers_OverFlowX1 ; 
assign INT_TOFX2 = Timers_OverFlowX2 ; 
assign INT_TOFX3 = Timers_OverFlowX3 ; 
assign INT_TOFX4 = Timers_OverFlowX4 ; 
assign INT_TOFX5 = Timers_OverFlowX5 ;
assign INT_TOFX6 = Timers_OverFlowX6 ;
assign INT_TOFX7 = Timers_OverFlowX7 ;  


//-------------------------------------------------------------
// PWM Mode Timing Match
//-------------------------------------------------------------
// PWM_Out
// PWM Mode Timing Match          : PWM_Match       
// Interval mode Match Signla Gen : Timer_Match
// one Clock Delay
//-------------------------------------------------------------

//Timers 0                  
always @(posedge Timers_CLK or negedge Timers_CLR)
          begin : p_PWM_Gen
         if ((!Timers_CLR)) begin
                PWM_Out     <= 1'b1 ;
                Timer_Match <= 1'b0 ; 
                end
               else begin
               if (TDAT_Value == {16{1'b0}}) begin
                    PWM_Out     <= 1'b1 ;
                    Timer_Match <= 1'b0 ;
                    end
                    else  begin //TDAT >= 1
                if ( Timer_Cnt == TDAT_Value - 1   ) begin
                    PWM_Out     <= 1'b0 ;
                    Timer_Match <= 1'b1 ;
                    end     
               else if ( Timer_Cnt < TDAT_Value - 1   ) begin
                     PWM_Out     <= 1'b1 ;
                     Timer_Match <= 1'b0 ;
                     end 
               else  begin  // Timer_Cnt > TDAT_Value - 1       
                     PWM_Out     <= 1'b0 ; 
                     PWM_Match   <= 1'b0 ;
                      end
                       end //TDAT >= 1 
                        end //CLK
                         end

//Timers 1                  
always @(posedge Timers_CLKX1 or negedge Timers_CLRX1)
          begin : p_PWMX1_Gen
         if ((!Timers_CLRX1)) begin
                PWM_OutX1     <= 1'b1 ;
                Timer_MatchX1 <= 1'b0 ; 
                end
               else begin
               if (TDAT_Value_X1 == {16{1'b0}}) begin
                    PWM_OutX1     <= 1'b1 ;
                    Timer_MatchX1 <= 1'b0 ;
                    end
                    else  begin //TDAT >= 1
                if ( Timer_CntX1 == TDAT_Value_X1 - 1   ) begin
                    PWM_OutX1     <= 1'b0 ;
                    Timer_MatchX1 <= 1'b1 ;
                    end     
               else if ( Timer_CntX1 < TDAT_Value_X1 - 1   ) begin
                     PWM_OutX1     <= 1'b1 ;
                     Timer_MatchX1 <= 1'b0 ;
                     end 
               else  begin  // Timer_Cnt > TDAT_Value - 1       
                     PWM_OutX1     <= 1'b0 ; 
                     PWM_MatchX1   <= 1'b0 ;
                      end
                       end //TDAT >= 1 
                        end //CLK
                         end

//Timers 2                  
always @(posedge Timers_CLKX2 or negedge Timers_CLRX2)
          begin : p_PWMX2_Gen
         if ((!Timers_CLRX2)) begin
                PWM_OutX2     <= 1'b1 ;
                Timer_MatchX2 <= 1'b0 ; 
                end
               else begin
               if (TDAT_Value_X2 == {16{1'b0}}) begin
                    PWM_OutX2     <= 1'b1 ;
                    Timer_MatchX2 <= 1'b0 ;
                    end
                    else  begin //TDAT >= 1
                if ( Timer_CntX2 == TDAT_Value_X2 - 1   ) begin
                    PWM_OutX2     <= 1'b0 ;
                    Timer_MatchX2 <= 1'b1 ;
                    end     
               else if ( Timer_CntX2 < TDAT_Value_X2 - 1   ) begin
                     PWM_OutX2     <= 1'b1 ;
                     Timer_MatchX2 <= 1'b0 ;
                     end 
               else  begin  // Timer_Cnt > TDAT_Value - 1       
                     PWM_OutX2     <= 1'b0 ; 
                     PWM_MatchX2   <= 1'b0 ;
                      end
                       end //TDAT >= 1 
                        end //CLK
                         end

//Timers 3                  
always @(posedge Timers_CLKX3 or negedge Timers_CLRX3)
          begin : p_PWMX3_Gen
         if ((!Timers_CLRX3)) begin
                PWM_OutX3     <= 1'b1 ;
                Timer_MatchX3 <= 1'b0 ; 
                end
               else begin
               if (TDAT_Value_X3 == {16{1'b0}}) begin
                    PWM_OutX3     <= 1'b1 ;
                    Timer_MatchX3 <= 1'b0 ;
                    end
                    else  begin //TDAT >= 1
                if ( Timer_CntX3 == TDAT_Value_X3 - 1   ) begin
                    PWM_OutX3     <= 1'b0 ;
                    Timer_MatchX3 <= 1'b1 ;
                    end     
               else if ( Timer_CntX3 < TDAT_Value_X3 - 1   ) begin
                     PWM_OutX3     <= 1'b1 ;
                     Timer_MatchX3 <= 1'b0 ;
                     end 
               else  begin  // Timer_Cnt > TDAT_Value - 1       
                     PWM_OutX3     <= 1'b0 ; 
                     PWM_MatchX3   <= 1'b0 ;
                      end
                       end //TDAT >= 1 
                        end //CLK
                         end
                         
//Timers 4                  
always @(posedge Timers_CLKX4 or negedge Timers_CLRX4)
          begin : p_PWMX4_Gen
         if ((!Timers_CLRX4)) begin
                PWM_OutX4     <= 1'b1 ;
                Timer_MatchX4 <= 1'b0 ; 
                end
               else begin
               if (TDAT_Value_X4 == {16{1'b0}}) begin
                    PWM_OutX4     <= 1'b1 ;
                    Timer_MatchX4 <= 1'b0 ;
                    end
                    else  begin //TDAT >= 1
                if ( Timer_CntX4 == TDAT_Value_X4 - 1   ) begin
                    PWM_OutX4     <= 1'b0 ;
                    Timer_MatchX4 <= 1'b1 ;
                    end     
               else if ( Timer_CntX4 < TDAT_Value_X4 - 1   ) begin
                     PWM_OutX4     <= 1'b1 ;
                     Timer_MatchX4 <= 1'b0 ;
                     end 
               else  begin  // Timer_Cnt > TDAT_Value - 1       
                     PWM_OutX4     <= 1'b0 ; 
                     PWM_MatchX4   <= 1'b0 ;
                      end
                       end //TDAT >= 1 
                        end //CLK
                         end
                         

//Timers 5                  
always @(posedge Timers_CLKX5 or negedge Timers_CLRX5)
          begin : p_PWMX5_Gen
         if ((!Timers_CLRX5)) begin
                PWM_OutX5     <= 1'b1 ;
                Timer_MatchX5 <= 1'b0 ; 
                end
               else begin
               if (TDAT_Value_X5 == {16{1'b0}}) begin
                    PWM_OutX5     <= 1'b1 ;
                    Timer_MatchX5 <= 1'b0 ;
                    end
                    else  begin //TDAT >= 1
                if ( Timer_CntX5 == TDAT_Value_X5 - 1   ) begin
                    PWM_OutX5     <= 1'b0 ;
                    Timer_MatchX5 <= 1'b1 ;
                    end     
               else if ( Timer_CntX5 < TDAT_Value_X5 - 1   ) begin
                     PWM_OutX5     <= 1'b1 ;
                     Timer_MatchX5 <= 1'b0 ;
                     end 
               else  begin  // Timer_Cnt > TDAT_Value - 1       
                     PWM_OutX5     <= 1'b0 ; 
                     PWM_MatchX5   <= 1'b0 ;
                      end
                       end //TDAT >= 1 
                        end //CLK
                         end

//Timers 6                  
always @(posedge Timers_CLKX6 or negedge Timers_CLRX6)
          begin : p_PWMX6_Gen
         if ((!Timers_CLRX6)) begin
                PWM_OutX6     <= 1'b1 ;
                Timer_MatchX6 <= 1'b0 ; 
                end
               else begin
               if (TDAT_Value_X6 == {16{1'b0}}) begin
                    PWM_OutX6     <= 1'b1 ;
                    Timer_MatchX6 <= 1'b0 ;
                    end
                    else  begin //TDAT >= 1
                if ( Timer_CntX6 == TDAT_Value_X6 - 1   ) begin
                    PWM_OutX6     <= 1'b0 ;
                    Timer_MatchX6 <= 1'b1 ;
                    end     
               else if ( Timer_CntX6 < TDAT_Value_X6 - 1   ) begin
                     PWM_OutX6     <= 1'b1 ;
                     Timer_MatchX6 <= 1'b0 ;
                     end 
               else  begin  // Timer_Cnt > TDAT_Value - 1       
                     PWM_OutX6     <= 1'b0 ; 
                     PWM_MatchX6   <= 1'b0 ;
                      end
                       end //TDAT >= 1 
                        end //CLK
                         end


//Timers 7                  
always @(posedge Timers_CLKX7 or negedge Timers_CLRX7)
          begin : p_PWMX7_Gen
         if ((!Timers_CLRX7)) begin
                PWM_OutX7     <= 1'b1 ;
                Timer_MatchX7 <= 1'b0 ; 
                end
               else begin
               if (TDAT_Value_X7 == {16{1'b0}}) begin
                    PWM_OutX7     <= 1'b1 ;
                    Timer_MatchX7 <= 1'b0 ;
                    end
                    else  begin //TDAT >= 1
                if ( Timer_CntX7 == TDAT_Value_X7 - 1   ) begin
                    PWM_OutX7     <= 1'b0 ;
                    Timer_MatchX7 <= 1'b1 ;
                    end     
               else if ( Timer_CntX7 < TDAT_Value_X7 - 1   ) begin
                     PWM_OutX7     <= 1'b1 ;
                     Timer_MatchX7 <= 1'b0 ;
                     end 
               else  begin  // Timer_Cnt > TDAT_Value - 1       
                     PWM_OutX7     <= 1'b0 ; 
                     PWM_MatchX7   <= 1'b0 ;
                      end
                       end //TDAT >= 1 
                        end //CLK
                         end
                                                           
//Timers 0~7                                              
assign INT_TMC     = Timer_Match   ;
assign INT_TMCX1   = Timer_MatchX1 ;
assign INT_TMCX2   = Timer_MatchX2 ;
assign INT_TMCX3   = Timer_MatchX3 ;
assign INT_TMCX4   = Timer_MatchX4 ;
assign INT_TMCX5   = Timer_MatchX5 ;
assign INT_TMCX6   = Timer_MatchX6 ;
assign INT_TMCX7   = Timer_MatchX7 ;


//----------------------------------------------------------
// Time Out
//----------------------------------------------------------

//Timers 0
always @(posedge Timers_CLK or negedge Timers_CLR)
          begin : p_Timer_O
          if ((!Timers_CLR))
              Timer_Out <= 1'b0 ;
              else begin
              if (Timer_Match)
              Timer_Out <= Timer_Out + 1 ;
                  end  
                    end

//Timers 1
always @(posedge Timers_CLKX1 or negedge Timers_CLRX1)
          begin : p_TimerX1_O
          if ((!Timers_CLRX1))
              Timer_OutX1 <= 1'b0 ;
              else begin
              if (Timer_MatchX1)
              Timer_OutX1 <= Timer_OutX1 + 1 ;
                  end  
                    end

//Timers 2
always @(posedge Timers_CLKX2 or negedge Timers_CLRX2)
          begin : p_TimerX2_O
          if ((!Timers_CLRX2))
              Timer_OutX2 <= 1'b0 ;
              else begin
              if (Timer_MatchX2)
              Timer_OutX2 <= Timer_OutX2 + 1 ;
                  end  
                    end

//Timers 3
always @(posedge Timers_CLKX3 or negedge Timers_CLRX3)
          begin : p_TimerX3_O
          if ((!Timers_CLRX3))
              Timer_OutX3 <= 1'b0 ;
              else begin
              if (Timer_MatchX3)
              Timer_OutX3 <= Timer_OutX3 + 1 ;
                  end  
                    end

//Timers 4
always @(posedge Timers_CLKX4 or negedge Timers_CLRX4)
          begin : p_TimerX4_O
          if ((!Timers_CLRX4))
              Timer_OutX4 <= 1'b0 ;
              else begin
              if (Timer_MatchX4)
              Timer_OutX4 <= Timer_OutX4 + 1 ;
                  end  
                    end
                    
//Timers 5
always @(posedge Timers_CLKX5 or negedge Timers_CLRX5)
          begin : p_TimerX5_O
          if ((!Timers_CLRX5))
              Timer_OutX5 <= 1'b0 ;
              else begin
              if (Timer_MatchX5)
              Timer_OutX5 <= Timer_OutX5 + 1 ;
                  end  
                    end
//Timers 6
always @(posedge Timers_CLKX6 or negedge Timers_CLRX6)
          begin : p_TimerX6_O
          if ((!Timers_CLRX6))
              Timer_OutX6 <= 1'b0 ;
              else begin
              if (Timer_MatchX6)
              Timer_OutX6 <= Timer_OutX6 + 1 ;
                  end  
                    end

//Timers 7
always @(posedge Timers_CLKX7 or negedge Timers_CLRX7)
          begin : p_TimerX7_O
          if ((!Timers_CLRX7))
              Timer_OutX7 <= 1'b0 ;
              else begin
              if (Timer_MatchX7)
              Timer_OutX7 <= Timer_OutX7 + 1 ;
                  end  
                    end                                                             
                    
//----------------------------------------------------------
// PWM End Count Enable
//----------------------------------------------------------                    
//Timers 0
always @(posedge Timers_CLK or negedge Timers_CLR)
        begin : p_PWM_End_Count
         if ((!Timers_CLR)) begin
            PWM_Pulse  <= 1'b0 ;
            PWM_Out_1d <= 1'b1 ;
             end
            else begin
            if (PWM_Out && (~PWM_Out_1d ))
                 PWM_Pulse <= 1'b1 ;
            else PWM_Pulse <= 1'b0 ;
                 end
                  end

//Timers 1
always @(posedge Timers_CLKX1 or negedge Timers_CLRX1)
        begin : p_PWMX1_End_Count
         if ((!Timers_CLRX1)) begin
            PWM_PulseX1  <= 1'b0 ;
            PWM_OutX1_1d <= 1'b1 ;
             end
            else begin
            if (PWM_OutX1 && (~PWM_OutX1_1d ))
                 PWM_PulseX1 <= 1'b1 ;
            else PWM_PulseX1 <= 1'b0 ;
                 end
                  end
                  
//Timers 2
always @(posedge Timers_CLKX2 or negedge Timers_CLRX2)
        begin : p_PWMX2_End_Count
         if ((!Timers_CLRX2)) begin
            PWM_PulseX2  <= 1'b0 ;
            PWM_OutX2_1d <= 1'b1 ;
             end
            else begin
            if (PWM_OutX2 && (~PWM_OutX2_1d ))
                 PWM_PulseX2 <= 1'b1 ;
            else PWM_PulseX2 <= 1'b0 ;
                 end
                  end
                  
//Timers 3
always @(posedge Timers_CLKX3 or negedge Timers_CLRX3)
        begin : p_PWMX3_End_Count
         if ((!Timers_CLRX3)) begin
            PWM_PulseX3  <= 1'b0 ;
            PWM_OutX3_1d <= 1'b1 ;
             end
            else begin
            if (PWM_OutX3 && (~PWM_OutX3_1d ))
                 PWM_PulseX3 <= 1'b1 ;
            else PWM_PulseX3 <= 1'b0 ;
                 end
                  end                  
                       
//Timers 4
always @(posedge Timers_CLKX4 or negedge Timers_CLRX4)
        begin : p_PWMX4_End_Count
         if ((!Timers_CLRX4)) begin
            PWM_PulseX4  <= 1'b0 ;
            PWM_OutX4_1d <= 1'b1 ;
             end
            else begin
            if (PWM_OutX4 && (~PWM_OutX4_1d ))
                 PWM_PulseX4 <= 1'b1 ;
            else PWM_PulseX4 <= 1'b0 ;
                 end
                  end

//Timers 5
always @(posedge Timers_CLKX5 or negedge Timers_CLRX5)
        begin : p_PWMX5_End_Count
         if ((!Timers_CLRX5)) begin
            PWM_PulseX5  <= 1'b0 ;
            PWM_OutX5_1d <= 1'b1 ;
             end
            else begin
            if (PWM_OutX5 && (~PWM_OutX5_1d ))
                 PWM_PulseX5 <= 1'b1 ;
            else PWM_PulseX5 <= 1'b0 ;
                 end
                  end

//Timers 6
always @(posedge Timers_CLKX6 or negedge Timers_CLRX6)
        begin : p_PWMX6_End_Count
         if ((!Timers_CLRX6)) begin
            PWM_PulseX6  <= 1'b0 ;
            PWM_OutX6_1d <= 1'b1 ;
             end
            else begin
            if (PWM_OutX6 && (~PWM_OutX6_1d ))
                 PWM_PulseX6 <= 1'b1 ;
            else PWM_PulseX6 <= 1'b0 ;
                 end
                  end

//Timers 7
always @(posedge Timers_CLKX7 or negedge Timers_CLRX7)
        begin : p_PWMX7_End_Count
         if ((!Timers_CLRX7)) begin
            PWM_PulseX7  <= 1'b0 ;
            PWM_OutX7_1d <= 1'b1 ;
             end
            else begin
            if (PWM_OutX7 && (~PWM_OutX7_1d ))
                 PWM_PulseX7 <= 1'b1 ;
            else PWM_PulseX7 <= 1'b0 ;
                 end
                  end
                  
                  
                  
//------------------------------------------------------------                     
//External Edge Detection
//------------------------------------------------------------
always @(posedge Timers_CLK or negedge Timers_CLR)
          begin : p_TCAP
          if ((!Timers_CLR)) begin
             TCAP_Reg    <= {7{1'b0}};
             TCAP_Reg_1d <= {7{1'b0}};
                          end
             else  begin
             TCAP_Reg    <= TCAP     ;
             TCAP_Reg_1d <= TCAP_Reg ;
                  end
                   end

 
always @(posedge Timers_CLK or negedge Timers_CLR)
          begin : p_TCAP_Det
          if ((!Timers_CLR)) 
             TDx_CapEn <= 1'b0 ;
             else begin
             case (OMS)
             `OMSCode4 : begin
               if ((TCAP_Reg[5:3] == {3{1'b0}}) && ( TCAP_Reg_1d[5:3] == {3{1'b1}}) )
                   TDx_CapEn <= 1'b1 ;
              else TDx_CapEn <= 1'b0 ;
                       end
            
             `OMSCode5 : begin
               if ((TCAP_Reg[5:3] == {3{1'b1}}) && ( TCAP_Reg_1d[5:3] == {3{1'b0}}) ) 
                   TDx_CapEn <= 1'b1 ;
              else TDx_CapEn <= 1'b0 ;
                       end           

             `OMSCode6 : begin
             if ((TCAP_Reg[5:3] == {3{1'b0}}) && ( TCAP_Reg_1d[5:3] == {3{1'b1}}))
                   TDx_CapEn <= 1'b1 ;
             else  if ((TCAP_Reg[5:3] == {3{1'b1}}) && ( TCAP_Reg_1d[5:3] == {3{1'b0}}))              
                   TDx_CapEn <= 1'b1 ;
             else  TDx_CapEn <= 1'b0 ;
               end
             
             default :  TDx_CapEn <= 1'b0 ;
                endcase
                     end  
                      end



always @(posedge PCLK or negedge PRESETn)
    begin : p_TDX_Upload
     if ((!PRESETn)) begin 
        TDX_Up        <= 1'b0 ;
        TDX_CapEn_1Pd <= 1'b0 ;
                    end
         else begin
         TDX_CapEn_1Pd <= TDx_CapEn ;
         if (~TDX_CapEn_1Pd && TDx_CapEn )
                  TDX_Up        <= 1'b1 ;
            else  TDX_Up        <= 1'b0 ;
             end
              end        

//Polarity
assign IVT   = R2[1]   ;
assign IVTX1 = R2X1[1] ;
assign IVTX2 = R2X2[1] ;
assign IVTX3 = R2X3[1] ;
assign IVTX4 = R2X4[1] ;
assign IVTX5 = R2X5[1] ;
assign IVTX6 = R2X6[1] ;
assign IVTX7 = R2X7[1] ;

//-------------------------------------------
// Tout/PWMout/INT_TMC/Edge
//-------------------------------------------

//Timer 0
always @(OMS or IVT or Timer_Out or Timer_Match or TDx_CapEn or PWM_Out)
 begin: p_TOUT_SEL
   case (OMS) 
    `OMSCode0 : begin
     if (~IVT) 
           INT_TPOUT = Timer_Out  ;
      else INT_TPOUT = ~Timer_Out ;
      end 
    
    `OMSCode1 : INT_TPOUT = Timer_Match ;  
    `OMSCode2 : begin
      if (~IVT) 
           INT_TPOUT = PWM_Out      ;
      else INT_TPOUT = ~PWM_Out     ;
                end
    `OMSCode4 : INT_TPOUT = TDx_CapEn ;
    `OMSCode5 : INT_TPOUT = TDx_CapEn ;
    `OMSCode6 : INT_TPOUT = TDx_CapEn ; 
     default  : INT_TPOUT = Timer_Out ;
    
        endcase
          end
          

//Timer 1
always @(OMSX1 or IVTX1 or Timer_OutX1 or Timer_MatchX1 or TDx_CapEn or PWM_OutX1)
 begin: p_TOUTX1_SEL
   case (OMSX1) 
    `OMSCode0 : begin
     if (~IVTX1) 
           INT_TPOUTX1 =  Timer_OutX1 ;
      else INT_TPOUTX1 = ~Timer_OutX1 ;
      end 
    
    `OMSCode1 : INT_TPOUTX1 = Timer_MatchX1 ;  
    `OMSCode2 : begin
      if (~IVTX1) 
           INT_TPOUTX1 =  PWM_OutX1       ;
      else INT_TPOUTX1 = ~PWM_OutX1       ;
                end
    `OMSCode4 : INT_TPOUTX1 = TDx_CapEn   ;
    `OMSCode5 : INT_TPOUTX1 = TDx_CapEn   ;
    `OMSCode6 : INT_TPOUTX1 = TDx_CapEn   ; 
     default  : INT_TPOUTX1 = Timer_OutX1 ;
    
        endcase
          end     

//Timer 2
always @(OMSX2 or IVTX2 or Timer_OutX2 or Timer_MatchX2 or TDx_CapEn or PWM_OutX2)
 begin: p_TOUTX2_SEL
   case (OMSX2) 
    `OMSCode0 : begin
     if (~IVTX2) 
           INT_TPOUTX2 =  Timer_OutX2 ;
      else INT_TPOUTX2 = ~Timer_OutX2 ;
      end 
    
    `OMSCode1 : INT_TPOUTX2 = Timer_MatchX2 ;  
    `OMSCode2 : begin
      if (~IVTX2) 
           INT_TPOUTX2 =  PWM_OutX2       ;
      else INT_TPOUTX2 = ~PWM_OutX2       ;
                end
    `OMSCode4 : INT_TPOUTX2 = TDx_CapEn   ;
    `OMSCode5 : INT_TPOUTX2 = TDx_CapEn   ;
    `OMSCode6 : INT_TPOUTX2 = TDx_CapEn   ; 
     default  : INT_TPOUTX2 = Timer_OutX2 ;
    
        endcase
          end     
          
//Timer 3
always @(OMSX3 or IVTX3 or Timer_OutX3 or Timer_MatchX3 or TDx_CapEn or PWM_OutX3)
 begin: p_TOUTX3_SEL
   case (OMSX3) 
    `OMSCode0 : begin
     if (~IVTX3) 
           INT_TPOUTX3 =  Timer_OutX3 ;
      else INT_TPOUTX3 = ~Timer_OutX3 ;
      end 
    
    `OMSCode1 : INT_TPOUTX3 = Timer_MatchX3 ;  
    `OMSCode2 : begin
      if (~IVTX3) 
           INT_TPOUTX3 =  PWM_OutX3       ;
      else INT_TPOUTX3 = ~PWM_OutX3       ;
                end
    `OMSCode4 : INT_TPOUTX3 = TDx_CapEn   ;
    `OMSCode5 : INT_TPOUTX3 = TDx_CapEn   ;
    `OMSCode6 : INT_TPOUTX3 = TDx_CapEn   ; 
     default  : INT_TPOUTX3 = Timer_OutX3 ;
    
        endcase
          end               

//Timer 4
always @(OMSX4 or IVTX4 or Timer_OutX4 or Timer_MatchX4 or TDx_CapEn or PWM_OutX4)
 begin: p_TOUTX4_SEL
   case (OMSX4) 
    `OMSCode0 : begin
     if (~IVTX4) 
           INT_TPOUTX4 =  Timer_OutX4 ;
      else INT_TPOUTX4 = ~Timer_OutX4 ;
      end 
    
    `OMSCode1 : INT_TPOUTX4 = Timer_MatchX4 ;  
    `OMSCode2 : begin
      if (~IVTX4) 
           INT_TPOUTX4 =  PWM_OutX4       ;
      else INT_TPOUTX4 = ~PWM_OutX4       ;
                end
    `OMSCode4 : INT_TPOUTX4 = TDx_CapEn   ;
    `OMSCode5 : INT_TPOUTX4 = TDx_CapEn   ;
    `OMSCode6 : INT_TPOUTX4 = TDx_CapEn   ; 
     default  : INT_TPOUTX4 = Timer_OutX4 ;
    
        endcase
          end     

//Timer 5
always @(OMSX5 or IVTX5 or Timer_OutX5 or Timer_MatchX5 or TDx_CapEn or PWM_OutX5)
 begin: p_TOUTX5_SEL
   case (OMSX5) 
    `OMSCode0 : begin
     if (~IVTX5) 
           INT_TPOUTX5 =  Timer_OutX5 ;
      else INT_TPOUTX5 = ~Timer_OutX5 ;
      end 
    
    `OMSCode1 : INT_TPOUTX5 = Timer_MatchX5 ;  
    `OMSCode2 : begin
      if (~IVTX5) 
           INT_TPOUTX5 =  PWM_OutX5       ;
      else INT_TPOUTX5 = ~PWM_OutX5       ;
                end
    `OMSCode4 : INT_TPOUTX5 = TDx_CapEn   ;
    `OMSCode5 : INT_TPOUTX5 = TDx_CapEn   ;
    `OMSCode6 : INT_TPOUTX5 = TDx_CapEn   ; 
     default  : INT_TPOUTX5 = Timer_OutX5 ;
    
        endcase
          end     
          

//Timer 6
always @(OMSX6 or IVTX6 or Timer_OutX6 or Timer_MatchX6 or TDx_CapEn or PWM_OutX6)
 begin: p_TOUTX6_SEL
   case (OMSX6) 
    `OMSCode0 : begin
     if (~IVTX6) 
           INT_TPOUTX6 =  Timer_OutX6 ;
      else INT_TPOUTX6 = ~Timer_OutX6 ;
      end 
    
    `OMSCode1 : INT_TPOUTX6 = Timer_MatchX6 ;  
    `OMSCode2 : begin
      if (~IVTX6) 
           INT_TPOUTX6 =  PWM_OutX6       ;
      else INT_TPOUTX6 = ~PWM_OutX6       ;
                end
    `OMSCode4 : INT_TPOUTX6 = TDx_CapEn   ;
    `OMSCode5 : INT_TPOUTX6 = TDx_CapEn   ;
    `OMSCode6 : INT_TPOUTX6 = TDx_CapEn   ; 
     default  : INT_TPOUTX6 = Timer_OutX6 ;
    
        endcase
          end     

//Timer 7
always @(OMSX7 or IVTX7 or Timer_OutX7 or Timer_MatchX7 or TDx_CapEn or PWM_OutX7)
 begin: p_TOUTX7_SEL
   case (OMSX7) 
    `OMSCode0 : begin
     if (~IVTX7) 
           INT_TPOUTX7 =  Timer_OutX7 ;
      else INT_TPOUTX7 = ~Timer_OutX7 ;
      end 
    
    `OMSCode1 : INT_TPOUTX7 = Timer_MatchX7 ;  
    `OMSCode2 : begin
      if (~IVTX7) 
           INT_TPOUTX7 =  PWM_OutX7       ;
      else INT_TPOUTX7 = ~PWM_OutX7       ;
                end
    `OMSCode4 : INT_TPOUTX7 = TDx_CapEn   ;
    `OMSCode5 : INT_TPOUTX7 = TDx_CapEn   ;
    `OMSCode6 : INT_TPOUTX7 = TDx_CapEn   ; 
     default  : INT_TPOUTX7 = Timer_OutX7 ;
    
        endcase
          end     
                    
          
                         
endmodule

// --================================= End ===================================--

