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
  input  [7:0]  PADDR       ;     // Address (used bits only)
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

// ExampleAPBSlave local registers
//`define EGAPBSLVREG 6'b000000
`define EGAPBSLVREG 2'b00

`define ADDRREG0 4'b0000
`define ADDRREG1 4'b0001
`define ADDRREG2 4'b0010
`define ADDRREG3 4'b0011
`define ADDRREGA 4'b0100
`define ADDRREGB 4'b0101
`define ADDRREGC 4'b0110
`define ADDRREGD 4'b0111
`define ADDRREGE 4'b1000
`define ADDRREGF 4'b1001
`define ADDRREGG 4'b1010
 
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
  wire [7:0]  PADDR   ;
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
  reg  [31:0] ReadRegs   ;
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
  assign R0En = ((PADDR[5:2] == `ADDRREG0) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0x00

  //PWMCON
  assign R1En = ((PADDR[5:2] == `ADDRREG1) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x04

//------------------------------------------------------------------------------
//-- The inputs(EINT[7:0]) to the Int_Rst. 
//-- to the GTAOUTR register                       ______
//--                ________          GIE_O   --->|      \
//-- EINT[7]    >---\       \                     |       \____         ___
//--   .             \       \                    |       /            |   |
//     .             | OR     |-----> EINT_OR --->|______/        _____|   |_____ One Pulse Reset Gen
//     .             /       /
//-- EINT[0]    >---/_______/     
//------------------------------------------------------------------------------
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

  always @ (PADDR or ReadRegs)
    begin : p_ReadMuxComb
      // Determine the next value of nextPRDATA
      case (PADDR[7:6])
        `EGAPBSLVREG : nextPRDATA = ReadRegs;
     //   `EASPA       : nextPRDATA = ReadIDs;
        default      : nextPRDATA = {32{1'b0}};  // Read as zero default
      endcase
    end

  always @ (PADDR or R0 or R1 )
    begin : p_RdRegMuxComb
      // Determine the next value of ReadRegs
      case (PADDR[5:2])
        `ADDRREG0 : ReadRegs = {16'h0000,R0} ;
        `ADDRREG1 : ReadRegs = {31'd0, R1}   ;
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


 reg [9:0] SCLKDIV_Reg ;
 reg       SCLKDIV2    ;
 reg       SCLKDIV4    ;
 reg       SCLKDIV8    ;
 reg       SCLKDIV16   ;
 reg       SCLKDIV32   ;
 reg       SCLKDIV128  ;
 reg       SCLKDIV1024 ;
 reg       Sys_CLK     ;
 
 reg [3:0] R0_delay4   ;
 
 // always @ (posedge PCLK or negedge PRESETn)
   always @ (posedge OSC_CLK or negedge PRESETn)
    begin : P_SCLKDIV
      if ((!PRESETn))  begin
         SCLKDIV_Reg   <= {10{1'b0}}                 ;
         SCLKDIV2       <=  1'b0                     ;
         SCLKDIV4       <=  1'b0                     ;
         SCLKDIV8       <=  1'b0                     ;
         SCLKDIV16      <=  1'b0                     ;
         SCLKDIV32      <=  1'b0                     ;
         SCLKDIV128     <=  1'b0                     ;
         SCLKDIV1024    <=  1'b0                     ;
                      end
         else begin
         SCLKDIV2       <= SCLKDIV_Reg[0]            ;
         SCLKDIV4       <= SCLKDIV_Reg[1]            ;
         SCLKDIV8       <= SCLKDIV_Reg[2]            ;
         SCLKDIV16      <= SCLKDIV_Reg[3]            ;
         SCLKDIV32      <= SCLKDIV_Reg[4]            ;
         SCLKDIV128     <= SCLKDIV_Reg[6]            ;
         SCLKDIV1024    <= SCLKDIV_Reg[9]            ;
             
         case (R0[3:1])
         `DIV0 : begin
                 SCLKDIV_Reg<= {10{1'b0}}                     ;
                 end
                 
         `DIV2 : begin
                SCLKDIV_Reg[0]   <= SCLKDIV_Reg[0] + 1        ;
                SCLKDIV_Reg[9:1] <= {9{1'b0}}                 ;
                 end
         
         `DIV4 : begin
                 SCLKDIV_Reg[1:0] <= ( SCLKDIV_Reg[1:0] + 1 ) ; 
                 SCLKDIV_Reg[9:2] <= {8{1'b0}}                ;
                 end
          
         `DIV8 : begin
                 SCLKDIV_Reg[2:0] <= ( SCLKDIV_Reg[2:0] + 1 ) ; 
                 SCLKDIV_Reg[9:3] <= {7{1'b0}}                ;
                 end     
         
         `DIV16 : begin
                 SCLKDIV_Reg[3:0] <= ( SCLKDIV_Reg[3:0] + 1 ) ; 
                 SCLKDIV_Reg[9:4] <= {6{1'b0}}                ;
                  end       
          
         `DIV32 : begin
                 SCLKDIV_Reg[4:0] <= ( SCLKDIV_Reg[4:0] + 1 ) ; 
                 SCLKDIV_Reg[9:5] <= {5{1'b0}}                ;
                  end       
                
         `DIV128 : begin
                 SCLKDIV_Reg[6:0] <= ( SCLKDIV_Reg[6:0] + 1 ) ; 
                 SCLKDIV_Reg[9:7] <= {3{1'b0}}                ;
                   end       
       
         `DIV1024 : begin
                 SCLKDIV_Reg     <= ( SCLKDIV_Reg+ 1 )      ;
                    end       
          
          default : SCLKDIV_Reg<= {10{1'b0}} ;
             endcase
               end 
                end
                 
                 
always @ ( R0 or OSC_CLK or SCLKDIV2 or SCLKDIV4 or  SCLKDIV8 or
            SCLKDIV16 or SCLKDIV32 or SCLKDIV128 or SCLKDIV1024)
    begin : P_CLK_SEL
     case (R0[3:1])
      
      `DIV0     : Sys_CLK = OSC_CLK     ;
      `DIV2     : Sys_CLK = SCLKDIV2    ; 
      `DIV4     : Sys_CLK = SCLKDIV4    ;
      `DIV8     : Sys_CLK = SCLKDIV8    ;
       
      `DIV16    : Sys_CLK = SCLKDIV16   ;
      `DIV32    : Sys_CLK = SCLKDIV32   ;
      `DIV128   : Sys_CLK = SCLKDIV128  ;
      `DIV1024  : Sys_CLK = SCLKDIV1024 ;
     
      default   : Sys_CLK = OSC_CLK     ;
          endcase
            end
 
 always @ (posedge PCLK or negedge R0_RST)
    begin : P_Stop_Delay4
      if ((!R0_RST))  
          R0_delay4[3:0] <= {4{1'b0}};
          else begin
          R0_delay4[0] <= R0[0]        ;
          R0_delay4[1] <= R0_delay4[0] ;
          R0_delay4[2] <= R0_delay4[1] ;
          R0_delay4[3] <= R0_delay4[2] ;
              end
              end
          
 assign  Sys_CLK_O = (~R0_delay4[3] & Sys_CLK); 
 
 
 //UCLKDIV
`define UARTDIV0  2'b00 
`define UARTDIV2  2'b01
`define UARTDIV4  2'b10
`define UARTDIV8  2'b11

 reg [2:0]  UARTDIV_Reg ;
 reg        UARTCLK2    ;
 reg        UARTCLK4    ;
 reg        UARTCLK8    ;
 reg        UART_CLK    ;
  
  always @ (posedge PCLK or negedge PRESETn)
    begin : P_UARCLKDIV
      if ((!PRESETn))  begin
         UARTDIV_Reg    <=  {3{1'b0}} ;
         UARTCLK2       <=  1'b0     ;
         UARTCLK4       <=  1'b0     ;
         UARTCLK8       <=  1'b0     ;
                        end
         else begin //(PRESETn)
         
         UARTCLK2       <=  UARTDIV_Reg[0] ;
         UARTCLK4       <=  UARTDIV_Reg[1] ;
         UARTCLK8       <=  UARTDIV_Reg[2] ;
              //end ??
               
         case (R0[5:4])
         `UARTDIV0 : begin
                 UARTDIV_Reg <= {3{1'b0}} ;
                 end
                 
         `UARTDIV2 : begin
                UARTDIV_Reg[0]   <= UARTDIV_Reg[0] + 1        ;
                UARTDIV_Reg[2:1] <= {2{1'b0}}                 ;
                     end
         
         `UARTDIV4 : begin
                 UARTDIV_Reg[1:0] <= ( UARTDIV_Reg[1:0] + 1 ) ; 
                 UARTDIV_Reg[2] <= {1'b0}                ;
                     end
          
         `UARTDIV8 : begin
                 UARTDIV_Reg <=  UARTDIV_Reg + 1  ; 
                     end
          default : UARTDIV_Reg <=  {3{1'b0}} ;
           endcase     
                end     
                 end
                  
always @ ( R0 or PCLK or UARTCLK2 or UARTCLK4 or  UARTCLK8)
    begin : P_UARTCLK_SEL
     case (R0[5:4])
      `UARTDIV0     : UART_CLK = PCLK        ;
      `UARTDIV2     : UART_CLK = UARTCLK2    ; 
      `UARTDIV4     : UART_CLK = UARTCLK4    ;
      `UARTDIV8     : UART_CLK = UARTCLK8    ; 
       default      : UART_CLK = UARTCLK8    ;                                        
          endcase
           end   
  
   assign UART_CLK_O = (~R0_delay4[3] & UART_CLK ) ;         

//GIE:R0[6]
 assign GIE_O        = R0[6] ;
 assign UART_INT_SEL = R0[7] ;

//ACLKDIV    
`define AC_DIV4    8'b00000000
`define AC_DIV8    8'b00000010
`define AC_DIV16   8'b00000100
`define AC_DIV32   8'b00001000
`define AC_DIV64   8'b00010000
`define AC_DIV128  8'b00100000
`define AC_DIV256  8'b01000000
`define AC_DIV512  8'b10000000


 reg [8:0] ACLKDIV_Reg ;
 reg       AD_CLK      ;
 
 //synopsys translate_off
 wire       ACLKDIV4    = ACLKDIV_Reg[1];
 wire       ACLKDIV8    = ACLKDIV_Reg[2];
 wire       ACLKDIV16   = ACLKDIV_Reg[3];
 wire       ACLKDIV32   = ACLKDIV_Reg[4];
 wire       ACLKDIV64   = ACLKDIV_Reg[5];
 wire       ACLKDIV128  = ACLKDIV_Reg[6];
 wire       ACLKDIV256  = ACLKDIV_Reg[7];
 wire       ACLKDIV512  = ACLKDIV_Reg[8];
 //synopsys translate_on



 always @ (posedge PCLK or negedge PRESETn)
    begin : P_AD_CLK
      if ((!PRESETn))  begin
         ACLKDIV_Reg    <= {9{1'b0}}                 ;
         AD_CLK         <= 1'b0                      ;
                      end
         else  //begin
          
        
         //`AC_DIV4 : begin
         if ( R0[15:8] < `AC_DIV8) begin 
                  
                 ACLKDIV_Reg[1:0] <= ( ACLKDIV_Reg[1:0] + 1 ) ; 
                 ACLKDIV_Reg[8:2] <= {7{1'b0}}                ;
                 AD_CLK           <= ACLKDIV_Reg[1]            ;
                 end
                 
         //`AC_DIV8 : begin
         else if ( R0[15:8] >= `AC_DIV8 && R0[15:8] < `AC_DIV16  ) begin
                ACLKDIV_Reg[2:0] <= ( ACLKDIV_Reg[2:0] + 1 )  ; 
                ACLKDIV_Reg[8:3] <= {6{1'b0}}                 ;
                AD_CLK           <= ACLKDIV_Reg[2]            ;
                 end
         
         //`AC_DIV16 : begin
         else if ( R0[15:8] >= `AC_DIV16 && R0[15:8] < `AC_DIV32 ) begin
                 ACLKDIV_Reg[3:0] <= ( ACLKDIV_Reg[3:0] + 1 ) ; 
                 ACLKDIV_Reg[8:4] <= {5{1'b0}}                ;
                 AD_CLK         <= ACLKDIV_Reg[3]           ;
                 end
          
         //`AC_DIV32 : begin
         else if ( R0[15:8] >= `AC_DIV32 && R0[15:8] < `AC_DIV64 ) begin
                 ACLKDIV_Reg[4:0] <= ( ACLKDIV_Reg[4:0] + 1 ) ; 
                 ACLKDIV_Reg[8:5] <= {4{1'b0}}                ;
                 AD_CLK         <= ACLKDIV_Reg[4]           ;
                 end     
         
         //`AC_DIV64 : begin
         else if ( R0[15:8] >= `AC_DIV64 && R0[15:8] < `AC_DIV128) begin
                 ACLKDIV_Reg[5:0] <= ( ACLKDIV_Reg[5:0] + 1 ) ;
                 ACLKDIV_Reg[8:6] <= {3{1'b0}}                ;
                 AD_CLK         <= ACLKDIV_Reg[5]           ;
                  end       
          
        // `AC_DIV128 : begin
        else if ( R0[15:8] >= `AC_DIV128 && R0[15:8] < `AC_DIV256 ) begin
                 ACLKDIV_Reg[6:0] <= ( ACLKDIV_Reg[6:0] + 1 ) ;
                 ACLKDIV_Reg[8:7] <= {2{1'b0}}                ;
                 AD_CLK         <= ACLKDIV_Reg[6]           ;
                  end       
                
        // `AC_DIV256 : begin
        else if ( R0[15:8] >= `AC_DIV256 && R0[15:8] < `AC_DIV512 ) begin
                 ACLKDIV_Reg[7:0] <= ( ACLKDIV_Reg[7:0] + 1 ) ; 
                 ACLKDIV_Reg[8]   <= 1'b0                     ;
                 AD_CLK         <= ACLKDIV_Reg[7]           ;
                   end       
       
         //`AC_DIV512 : begin
           else begin
                 ACLKDIV_Reg      <= ( ACLKDIV_Reg + 1 )       ;
                 AD_CLK           <= ACLKDIV_Reg[8]          ;
                    end       
                     end 
                   


  
   assign AD_CLK_O = (~R0_delay4[3] & AD_CLK )   ;         

endmodule

// --================================= End ===================================--

