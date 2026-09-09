// =========================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APB_PowerManager.v
// File Revision       : 1.0
//  ------------------------------------------------------------------------
//  Purpose             : Power & Clock Management
//  ========================================================================

`timescale 1ns/1ps

module APB_PowerManager 
(
//synopsys translate_off
Int_Clrn     ,
//synopsys translate_on

OSC_CLK      ,
EINT         ,

PCLK         , 
PRESETn      , 
PENABLE      , 
PSEL         , 
PWRITE       , 
PADDR        , 
PWDATA       ,
PRDATA       ,
Sys_CLK_O    ,
UART_CLK_O   ,
GIE_O        ,
UART_INT_SEL ,
AD_CLK_O     ,

SCANENABLE   , 
SCANINPCLK   , 
SCANOUTPCLK  

);

//synopsys translate_off
  output        Int_Clrn    ;
//synopsys translate_on

  //External Clock
  input         OSC_CLK     ;     //External Clock
  input [7:0]   EINT        ;     //External Interrupt
   
  input         PCLK        ;     // APB system clock
  input         PRESETn     ;     // APB system reset
  input         PENABLE     ;     // Data valid strobe 
  input         PSEL        ;     // Module select signal
  input         PWRITE      ;     // Write/nRead signal
  input  [ 7:2] PADDR       ;     // Address (used bits only)
  input  [31:0] PWDATA      ;     // Read data
  output [31:0] PRDATA      ;     // Write data

   // Scan test dummy signals; not connected until scan insertion 
  input         SCANENABLE  ;     // Scan Test Mode Enbl
  input         SCANINPCLK  ;     // Scan Chain Input
  output        SCANOUTPCLK ;     // Scan Chain Output  

 //Function BL
  output        Sys_CLK_O    ;     //System Clock [HCLK/PCLK]
  output        UART_CLK_O   ;     //UART Clock
  output        GIE_O        ;
  output        UART_INT_SEL ;     //UART Interrupt Select
  output        AD_CLK_O     ;     //ADC Clock
// Module Address Map:
// Read/write 32-bit registers:
//
// Address  Read      Write
// 0x00     0 = R0    R0
// 0x04     1 = R1    R1

`define ADDRREG0 6'b000000
`define ADDRREG1 6'b000001
 
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire        OSC_CLK ;
  wire [7:0]  EINT    ; 
  //APB Signal
  wire        PCLK    ;
  wire        PRESETn ;
  wire        PENABLE ;
  wire        PSEL    ;
  wire        PWRITE  ;
  wire [ 7:2] PADDR   ;
  wire [31:0] PWDATA  ;
  wire [31:0] PRDATA  ;
  
  //Function Signal
  wire       Sys_CLK_O    ;
  wire       GIE_O        ;
  wire       UART_INT_SEL ;
  wire       UART_CLK_O   ;
  wire       AD_CLK_O     ;
  
  wire        SCANENABLE ;
  wire        SCANINPCLK ;
  wire        SCANOUTPCLK ;

// Internal Signals
  wire        Valid;         // Detect valid transfers
  wire        R0En;          // Register update enables
  wire        R1En;
   
  reg  [15:0] R0 ;            // Read/Write registers
  reg         R1 ;

  reg  [31:0] nextPRDATA ;    // Mux, Register and Enable for PRDATA
  reg  [31:0] iPRDATA    ;
  wire        ReadRegEn  ;  
  wire        EINT_OR    ;   
  wire        R0_RST     ;

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
  
  //SYSCON
  assign R0En = ((PADDR[7:2] == `ADDRREG0) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0x00

  //PWMCON
  assign R1En = ((PADDR[7:2] == `ADDRREG1) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x04

 assign EINT_OR = ( (EINT[7]|EINT[6]|EINT[5]|EINT[4]|EINT[3]|EINT[2]|EINT[1]|EINT[0]) & GIE_O);
 
reg Int_Rst_1d ;
reg Int_Rst_2d ;
reg Int_Clr    ;

always @ (posedge OSC_CLK or negedge PRESETn)
      begin : P_EINT_Pulse
      if ((!PRESETn)) begin
          Int_Rst_1d    <= 1'b0 ;
          Int_Rst_2d    <= 1'b0 ;
          Int_Clr       <= 1'b0 ;
          end
          else begin//
          Int_Rst_1d    <= EINT_OR     ;
          Int_Rst_2d    <= Int_Rst_1d ;
          
          if (Int_Rst_1d == 1'b1 && Int_Rst_2d == 1'b0)
                  Int_Clr <= 1'b1 ;
             else Int_Clr <= 1'b0 ;
             end 
               end

//------------------------------------------------------------------------------
// Read/write registers
//------------------------------------------------------------------------------
// When written to, these registers will hold their values.
// Register 0
//SYSCON
//ACLKDIV[15:8]|UART_INT_SEL[7]|GIE[6]|UCLKDIV[5:4]|SCLKDIV[3:1]|STOP[0]
assign R0_RST = (~Int_Clr & PRESETn );

//synopsys translate_off
wire Int_Clrn ;
assign Int_Clrn = ~Int_Clr ;
//synopsys translate_on

always @ (posedge PCLK or negedge R0_RST)
     begin : p_Reg0Seq
       if ((!R0_RST))
         R0[0] <= 1'b0;
        
       else 
         if (R0En)
         R0[0] <= PWDATA[0]; 
           end 

always @ (posedge PCLK or negedge PRESETn)
     begin : p_Reg0_0_Seq
       if ((!PRESETn))
           R0[15:1] <= 15'b0001_0000_0111_000 ; //0x1070
           else
           if (R0En)
           R0[15:1] <= PWDATA[15:1] ;
           end

// Register 1
//PWMCON
//STOP[0]
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1Seq
      if ((!PRESETn))
        R1 <= 1'b0;
      else
        if (R1En)
        R1 <= PWDATA[0];
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

  always @ (PADDR or R0 or R1 )
    begin : p_RdRegMuxComb
      // Determine the next value of nextPRDATA
      case (PADDR[7:2])
        `ADDRREG0 : nextPRDATA = {16'h0000,R0} ;
        `ADDRREG1 : nextPRDATA = {31'd0, R1}   ;
        default   : nextPRDATA = {32{1'b0}};  // Read as zero default
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
 
// Drive output from internal register
  assign PRDATA = {16'd0, iPRDATA};

//Function Gen
//R0[0]   : STOP
//R0[3:1] : SCLKDIV[System Clock Divider Select]
//R0[5:4] : UCLKDIV

//SCLKDIV
`define DIV0    3'b000
`define DIV2    3'b001
`define DIV4    3'b010
`define DIV8    3'b011
`define DIV16   3'b100
`define DIV32   3'b101
`define DIV128  3'b110
`define DIV1024 3'b111

reg [9:0] SCLKDIVCnt ;
 
always @ (posedge OSC_CLK or negedge PRESETn)
   if (!PRESETn) SCLKDIVCnt <= {10{1'b0}};
   else          SCLKDIVCnt <= SCLKDIVCnt + 1'b1;

reg SysClk;
always @ (R0 or OSC_CLK or SCLKDIVCnt)
  case (R0[3:1])
   
   `DIV0     : SysClk = OSC_CLK     ;
   `DIV2     : SysClk = SCLKDIVCnt[0]; 
   `DIV4     : SysClk = SCLKDIVCnt[1];
   `DIV8     : SysClk = SCLKDIVCnt[2];
    
   `DIV16    : SysClk = SCLKDIVCnt[3];
   `DIV32    : SysClk = SCLKDIVCnt[4];
   `DIV128   : SysClk = SCLKDIVCnt[6];
   `DIV1024  : SysClk = SCLKDIVCnt[9];
  
    default  : SysClk = OSC_CLK;
  endcase
          
 assign  Sys_CLK_O = (SysClk); 
 
 
 //UCLKDIV
`define UARTDIV0  2'b00 
`define UARTDIV2  2'b01
`define UARTDIV4  2'b10
`define UARTDIV8  2'b11

reg [2:0] UCLKDIVCnt ;
 
always @ (posedge OSC_CLK or negedge PRESETn)
begin : P_UCLKDIV
   if (!PRESETn) UCLKDIVCnt <= {3{1'b0}};
   else          UCLKDIVCnt <= UCLKDIVCnt + 1'b1;
end

reg UartClk;
always @ (R0 or OSC_CLK or SCLKDIVCnt)
  case (R0[5:4])
   
   `UARTDIV0 : UartClk = OSC_CLK     ;
   `UARTDIV2 : UartClk = UCLKDIVCnt[0]; 
   `UARTDIV4 : UartClk = UCLKDIVCnt[1];
   `UARTDIV8 : UartClk = UCLKDIVCnt[2];
    
    default  : UartClk = OSC_CLK;
  endcase
  
   assign UART_CLK_O = (UartClk ) ;         

//GIE:R0[6]
 assign GIE_O        = R0[6] ;
 assign UART_INT_SEL = R0[7] ;

//ACLKDIV    
`define ADCDIV4    8'b00000000
`define ADCDIV8    8'b00000010
`define ADCDIV16   8'b00000100
`define ADCDIV32   8'b00001000
`define ADCDIV64   8'b00010000
`define ADCDIV128  8'b00100000
`define ADCDIV256  8'b01000000
`define ADCDIV512  8'b10000000

reg [8:0] ACLKDIVCnt ;
 
always @ (posedge OSC_CLK or negedge PRESETn)
   if (!PRESETn) ACLKDIVCnt <= {9{1'b0}};
   else          ACLKDIVCnt <= ACLKDIVCnt + 1'b1;

reg AdcClk;
always @ (R0 or ACLKDIVCnt)
  case (R0[15:8])
   
   `ADCDIV4    : AdcClk = ACLKDIVCnt[1];
   `ADCDIV8    : AdcClk = ACLKDIVCnt[2]; 
   `ADCDIV16   : AdcClk = ACLKDIVCnt[3];
   `ADCDIV32   : AdcClk = ACLKDIVCnt[4];
   `ADCDIV64   : AdcClk = ACLKDIVCnt[5];
   `ADCDIV128  : AdcClk = ACLKDIVCnt[6];
   `ADCDIV256  : AdcClk = ACLKDIVCnt[7];
   `ADCDIV512  : AdcClk = ACLKDIVCnt[8];
  
    default    : AdcClk = ACLKDIVCnt[5];
  endcase
  
   assign AD_CLK_O = (AdcClk )   ;         

endmodule

// --================================= End ===================================--

