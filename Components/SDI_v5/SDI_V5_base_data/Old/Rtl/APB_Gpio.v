// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APB_Gpio.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : Gpio
//  =============================================================================

`timescale 1ns/1ps

module APB_Gpio 
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
Gpio_IN0     ,
Gpio_IN1     ,
Gpio_IN2     ,
Gpio_IN3     ,

Tout         ,
MEM_ADR      ,
MEM_BE       ,  
POUT         ,
UART_RXD     ,
UART_TXD     ,
IrDA_RXD     ,
IrDA_TXD     ,
MEM_WBE      ,
MEM_CS       ,

//output
GPIO_En0     ,
GPIO_En1     ,
GPIO_En2     ,
GPIO_En3     ,

Mux_Out0     ,
Mux_Out1     ,
Mux_Out2     ,
Mux_Out3     ,

SCANENABLE   , 
SCANINPCLK   , 
SCANOUTPCLK  

);
//APB
  input          PCLK        ;     // APB system clock
  input          PRESETn     ;     // APB system reset
  input          PENABLE     ;     // Data valid strobe 
  input          PSEL        ;     // Module select signal
  input          PWRITE      ;     // Write/nRead signal
  input  [11:2]  PADDR       ;     // Address (used bits only)
  input  [31:0]  PWDATA      ;     // Read data
  output [31:0]  PRDATA      ;     // Write data

 //Function BL
  input  [7:0]   Gpio_IN0    ;     //EINT[7:0]
  input  [7:0]   Gpio_IN1    ;     //TCAP[7:0]
  input  [7:0]   Gpio_IN2    ;     //GPIO
  input  [7:0]   Gpio_IN3    ;     //TCLK[7:0]
  
  input  [7:0]   Tout        ;     //Inernal Time_Out
  input  [19:17] MEM_ADR     ;
  input  [1:0]   MEM_BE      ;
  input  [7:0]   POUT        ;
  input          UART_RXD    ;
  input          UART_TXD    ;
  input          IrDA_RXD    ;
  input          IrDA_TXD    ;
  input  [1:0]   MEM_WBE     ;
  input  [2:1]   MEM_CS      ;
  
  output [7:0]   GPIO_En0    ;
  output [7:0]   GPIO_En1    ;
  output [7:0]   GPIO_En2    ;
  output [7:0]   GPIO_En3    ;
  
  output [7:0]   Mux_Out0    ;
  output [7:0]   Mux_Out1    ;
  output [7:0]   Mux_Out2    ;
  output [7:0]   Mux_Out3    ;
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
//0x1FF8A00[11:0]
//1010_0000_0000
//       -----ADDREG0
//-------EGAPBSLVREG
//A
`define EGAPBSLVREG 6'b101000

`define ADDRREG0 4'b0000 //0x00 
`define ADDRREG1 4'b0001 //0x04
`define ADDRREG2 4'b0010 //0x08
`define ADDRREG3 4'b0011 //0x0C
`define ADDRREGA 4'b0100 //0x10
`define ADDRREGB 4'b0101 //0x14
`define ADDRREGC 4'b0110 //0x18
`define ADDRREGD 4'b0111 //0x1C
`define ADDRREGE 4'b1000 //0x20
`define ADDRREGF 4'b1001 //0x24
`define ADDRREGG 4'b1010 //0x28
 
  integer      i           ;     //Internal Loop  
//  integer      j           ;     //Internal Loop  


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

  //APB Signal
  wire        PCLK         ;
  wire        PRESETn      ;
  wire        PENABLE      ;
  wire        PSEL         ;
  wire        PWRITE       ;
  wire [11:2]  PADDR       ;
  wire [31:0] PWDATA       ;
  wire [31:0] PRDATA       ;
  
  // Internal Signals
  wire        Valid        ; // Detect valid transfers
  wire        R0En         ; // Register update enables
  wire        R1En         ;
  wire        R2En         ;
  wire        R3En         ;
  wire        R4En         ;
  wire        R5En         ;
  wire        R6En         ;
  wire        R7En         ;
  
  reg  [7:0]  R0           ;            
  reg  [7:0]  R1           ;
  reg  [7:0]  R2           ;
  reg  [7:0]  R3           ;  
  
  reg  [15:0] R4           ;
  reg  [15:0] R5           ;
  reg  [15:0] R6           ;
  reg  [15:0] R7           ;  
    
  reg  [31:0] nextPRDATA   ; // Mux, Register and Enable for PRDATA
  reg  [31:0] ReadRegs     ;
  reg  [31:0] iPRDATA      ;
  wire        ReadRegEn    ;  
   
  //Function Signal
  wire [7:0]   Gpio_IN0    ;     //EINT[7:0]
  wire [7:0]   Gpio_IN1    ;     //TCAP[7:0]
  wire [7:0]   Gpio_IN2    ;     //GPIO
  wire [7:0]   Gpio_IN3    ;     //TCLK[7:0]
  
  wire [7:0]   Tout        ;     //Inernal Time_Out
  wire [19:17] MEM_ADR     ;
  wire [1:0]   MEM_BE      ;
  wire [7:0]   POUT        ;
  wire         UART_RXD    ;
  wire         UART_TXD    ;
  wire         IrDA_RXD    ;
  wire         IrDA_TXD    ;
  wire [1:0]   MEM_WBE     ;
  wire [2:1]   MEM_CS      ;
  

  reg  [7:0]   GPIO_En0    ;     //Bi-PAD Enable
  reg  [7:0]   GPIO_En1    ;     //Bi-PAD Enable
  reg  [7:0]   GPIO_En2    ;     //Bi-PAD Enable
  reg  [7:0]   GPIO_En3    ;     //Bi-PAD Enable
  
  wire [7:0]   MEM_ADR_BE  ;
  reg  [7:0]   Mux_Out0    ;
  reg  [7:0]   Mux_Out1    ;
  reg  [7:0]   Mux_Out2    ;
  reg  [7:0]   Mux_Out3    ;
  wire [7:0]   UART_MEMBC  ;
 
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

 
  assign R0En = ((PADDR[5:2] == `ADDRREG0) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0x00
 
  assign R1En = ((PADDR[5:2] == `ADDRREG1) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x04
  
  assign R2En = ((PADDR[5:2] == `ADDRREG2) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x08
                
  assign R3En = ((PADDR[5:2] == `ADDRREG3) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x0C
  
  assign R4En = ((PADDR[5:2] == `ADDRREGA) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x10               
 
  assign R5En = ((PADDR[5:2] == `ADDRREGB) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x14  
  
  assign R6En = ((PADDR[5:2] == `ADDRREGC) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x18
  
  assign R7En = ((PADDR[5:2] == `ADDRREGD) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x1C                              
                                                        
//==============================================================================
// Read/write registers
//==============================================================================
// When written to, these registers will hold their values.
// Register  PDATn : GPIO_DATA0[0x01FF_8A00]
//                   GPIO_DATA1[0x01FF_8A04]
//                   GPIO_DATA2[0x01FF_8A08]
//                   GPIO_DATA3[0x01FF_8A0C]
// PDATn[7:0] GPIO PortX
//==============================================================================
 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg0Seq
    if ((!PRESETn))     
        R0 <= {8{1'b0}} ;
      else       
      for (i = 7; i >= 0; i = i - 1) begin
      if (GPIO_En0[i] == 1'b1) //Input          
           R0[i] <= Gpio_IN0[i] ;
           
        else if (R0En)
           R0 <= PWDATA[7:0];
             end
              end  
              
 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1Seq
      if ((!PRESETn))
        R1 <= {8{1'b0}};
      else
      for (i = 7; i >= 0; i = i - 1) begin
      if (GPIO_En1[i] == 1'b1) //Input 
           R1[i] <= Gpio_IN1[i] ;
      else if (R1En)
        R1 <= PWDATA[7:0];
          end                
           end
           
 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg2Seq
      if ((!PRESETn))
        R2 <= {8{1'b0}};
      else
       for (i = 7; i >= 0; i = i - 1) begin
      if (GPIO_En2[i] == 1'b1) //Input 
           R2[i] <= Gpio_IN2[i] ;
       else if (R2En)
        R2 <= PWDATA[7:0];
         end                          
          end
          
          
 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg3Seq
      if ((!PRESETn)) 
        R3 <= {8{1'b0}};
      else
       for (i = 7; i >= 0; i = i - 1) begin
        if (GPIO_En3[i] == 1'b1) //Input 
           R3[i] <= Gpio_IN3[i] ;
       else if (R3En)
           R3 <= PWDATA[7:0];
          end                          
           end

//==============================================================================
// When written to, these registers will hold their values.
// Register  CONx :  GPIO_CON0[0x01FF_8A10]
//                   GPIO_CON1[0x01FF_8A14]
//                   GPIO_CON2[0x01FF_8A18]
//                   GPIO_CON3[0x01FF_8A1C]
//==============================================================================
 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg4Seq
      if ((!PRESETn))
        R4 <= {16{1'b0}};
      else
        if (R4En)
        R4 <= PWDATA[15:0];
    end                          
    

 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg5Seq
      if ((!PRESETn))
        R5 <= {16{1'b0}};
      else
        if (R5En)
        R5 <= PWDATA[15:0];
    end                          


 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg6Seq
      if ((!PRESETn))
        R6 <= {16{1'b0}};
      else
        if (R6En)
        R6 <= PWDATA[15:0];
    end                          


 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg7Seq
      if ((!PRESETn))
        R7 <= {16{1'b0}};
      else
        if (R7En)
        R7 <= PWDATA[15:0];
    end                          
    
//------------------------------------------------------------------------------
// PRDATA generation
//------------------------------------------------------------------------------


  always @ (PADDR or ReadRegs)
    begin : p_ReadMuxComb
        case (PADDR[11:6])       
        `EGAPBSLVREG : nextPRDATA = ReadRegs;
        default      : nextPRDATA = {32{1'b0}};  // Read as zero default
      endcase
    end

  always @ (PADDR or R0 or R1 or R2 or R3 or R4 or R5 or R6 or R7)
    begin : p_RdRegMuxComb
      // Determine the next value of ReadRegs
      case (PADDR[5:2])
        `ADDRREG0 : ReadRegs = {{24{1'b0}}, R0 } ;
        `ADDRREG1 : ReadRegs = {{24{1'b0}}, R1 } ;
        `ADDRREG2 : ReadRegs = {{24{1'b0}}, R2 } ;
        `ADDRREG3 : ReadRegs = {{24{1'b0}}, R3 } ;
        
        `ADDRREGA : ReadRegs = {{16{1'b0}}, R4 } ;
        `ADDRREGB : ReadRegs = {{16{1'b0}}, R5 } ;
        `ADDRREGC : ReadRegs = {{16{1'b0}}, R6 } ;
        `ADDRREGD : ReadRegs = {{16{1'b0}}, R7 } ;
        default   : ReadRegs = {32{1'b0}};  // Read as zero default
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

//============Function Gen======================================================
//==============================================================================
// When written to, these registers will hold their values.
// Register GPIO_CON0[15:0]: 0x01FF_8A10 
// 00 : EINT[7:0]
// 01 : Gpio In[7:0]
// 10 : Gpio Out[7:0]
// 11 : TOUT[7:0]                          
// Bi-Direction Control & Data Output Select
//==============================================================================
//GPIO_EnX[i] == 1'b1 => Input Mode else Output Mode

always @(R4)
begin : p_Gpio_En0
  for (i = 7; i >= 0; i = i - 1)
    GPIO_En0[i] = ~(R4[i*2+1]) ;
end 

always @(R4 or R0 or Tout )
begin : p_Mux_Out0_Sel
 for (i = 7; i >= 0; i = i - 1) begin 
    if ({R4[i*2+1],R4[i*2]} == 2'b11)
        Mux_Out0[i] <= Tout[i]   ;
   else Mux_Out0[i] <= R0[i]     ; 
    end
     end
     

//==============================================================================
// When written to, these registers will hold their values.
// Register GPIO_CON1[15:0]: 0x01FF_8A14 
// 00 : Gpio In[7:0]
// 01 : Gpio Out[7:0]
// 10 : TCAP[7:0]
// 11 : Out Mode[MEM_ADR[19:17],MEM_BE[1:0],Zero[2:0]]        
// Bi-Direction Control & Data Output Select                 
//==============================================================================

always @(R5)
begin : p_Gpio_En1
  for (i = 7; i >= 0; i = i - 1)
    GPIO_En1[i] = ~(R5[i*2]) ;
end 

assign MEM_ADR_BE = {MEM_ADR[19:17],MEM_BE[1:0],3'b000} ;

always @(R5 or R1 or MEM_ADR_BE )
begin : p_Mux_Out1_Sel
 for (i = 7; i >= 0; i = i - 1) begin 
  if ({R5[i*2+1],R5[i*2]} == 2'b11)
        Mux_Out1[i] <= MEM_ADR_BE[i]   ;
   else Mux_Out1[i] <= R1[i]           ; 
    end
     end

     
//==============================================================================
// When written to, these registers will hold their values.
// Register GPIO_CON2[15:0]: 0x01FF_8A18 
// 00 : POUT[7:0]
// 01 : TOUT[7:0]
// 10 : Gpio In[7:0]
// 11 : Gpio Out[7:0] 
// Bi-Direction Control & Data Output Select                            
//==============================================================================
always @(R6)
begin : p_Gpio_En2
 for (i = 7; i >= 0; i = i - 1) begin 
  if ({R6[i*2+1],R6[i*2]} == 2'b10)
        GPIO_En2[i] <= 1'b1 ;
   else GPIO_En2[i] <= 1'b0 ; 
    end
     end

always @(R6 or R2 or  POUT or Tout )
begin : p_Mux_Out2_Sel
 for (i = 7; i >= 0; i = i - 1) begin 
  if ({R6[i*2+1],R6[i*2]} == 2'b11)
        Mux_Out2[i] <= R2[i]     ;
   else if ({R6[i*2+1],R6[i*2]} == 2'b01) 
        Mux_Out2[i] <= Tout[i]   ; 
   else Mux_Out2[i] <= POUT[i]   ;      
    end
     end


     
//==============================================================================
// When written to, these registers will hold their values.
// Register GPIO_CON3[15:0]: 0x01FF_8A1C 
// 00 : Gpio_In[7:0]
// 01 : Gpio_Out[7:0]
// 10 : TCLK[7:0]
// 11 : Out Mode[UART RXD,UART TXD, IrDA RXD, irDA TXD, MEM_WBE[1:0],MEM_CS[2:1]]                        
//==============================================================================
always @(R7)
begin : p_Gpio_En3
  for (i = 7; i >= 0; i = i - 1)
    GPIO_En3[i] = ~(R7[i*2]) ;
end 

assign UART_MEMBC = {UART_RXD,UART_TXD, IrDA_RXD, IrDA_TXD, MEM_WBE[1:0],MEM_CS[2:1]};

always @(R7 or R3 or UART_MEMBC )
begin : p_Mux_Out3_Sel
 for (i = 7; i >= 0; i = i - 1) begin 
  if ({R7[i*2+1],R7[i*2]} == 2'b11)
        Mux_Out3[i] <= UART_MEMBC[i]   ;
   else Mux_Out3[i] <= R3[i]           ; 
    end
     end
         
endmodule

