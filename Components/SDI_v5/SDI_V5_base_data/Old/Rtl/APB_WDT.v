// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APB_WDT.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : Watch Dog Timer
//  =============================================================================

`timescale 1ns/1ps

module APB_WDT 
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
//WDOGCLK      ,  // Watchdog clock
//WDOGCLKEN    ,  // Watchdog clock enable 
WDOGRESn     ,  // Watchdog clock reset  
WDOGINT      ,  // Watchdog interrupt    
WDOGRES      ,  // Watchdog timeout reset



SCANENABLE   , 
SCANINPCLK   , 
SCANOUTPCLK  

);


//APB
  input         PCLK        ;     // APB system clock
  input         PRESETn     ;     // APB system reset
  input         PENABLE     ;     // Data valid strobe 
  input         PSEL        ;     // Module select signal
  input         PWRITE      ;     // Write/nRead signal
  input  [11:2] PADDR       ;     // Address (used bits only)
  input  [31:0] PWDATA      ;     // Read data
  output [31:0] PRDATA      ;     // Write data

 //Function BL
//  input         WDOGCLK     ;  // Watchdog clock          
//  input         WDOGCLKEN   ;  // Watchdog clock enable   
  input         WDOGRESn    ;  // Watchdog clock reset    
  output        WDOGINT     ;  // Watchdog interrupt      
  output        WDOGRES     ;  // Watchdog timeout reset  
  
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
//0x1FF8900[11:0]
//1001_0000_0000
//       -----ADDREG0
//-------EGAPBSLVREG
//9
`define EGAPBSLVREG 6'b100100

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
  
  reg  [15:0]  R0          ;            
  reg  [15:0]  R1          ;
  reg  [15:0]  R2          ;
  reg  [15:0]  R3          ;  
  reg  [15:0]  R4          ;  
    
  reg  [31:0] nextPRDATA   ; // Mux, Register and Enable for PRDATA
  reg  [31:0] ReadRegs     ;
  reg  [31:0] iPRDATA      ;
  wire        ReadRegEn    ;  
   
  //Function Signal
  reg [15:0]  WDT_Cnt        ;
  reg         WDTISR         ;
  reg [15:0]  PS_Cnt         ;
  reg  [6:0]  Div_Cnt        ;
  wire [5:4]  DIV            ;

  wire        CLKSEL         ;
  wire        INTEN          ;
  wire        RSTEN          ;
  wire        WDTEN          ;
  wire [15:0] PRS_Val        ;
  reg         PS_Match       ;
  reg         Div_Match      ;
  wire [15:0] WDTLDR         ;
  reg         R2En_1d        ;
  reg         R4En_1d        ;
  reg         WDTISR_Clr     ;
  wire        WDOGINT        ;
  reg         nRESTOUT_Reg   ;
  wire        nRESTOUT       ;
  wire        WDOGRES        ;
  
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
//synopsys translate_off  
  assign R3En = ((PADDR[5:2] == `ADDRREG3) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x0C
//synopsys translate_on
  
  assign R4En = ((PADDR[5:2] == `ADDRREGA) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x10                            
//==============================================================================
// Read/write registers
//==============================================================================
// When written to, these registers will hold their values.
// Register 0 : WDTCR[0x01FF_8900]
//
// Reserved[15:6] | DIV[5:4] | CLKSEL[3]] | INTEN[2] | RSTEN[1] |WDTEN[0]
//==============================================================================
 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg0Seq
      if ((!PRESETn))
        R0 <= 16'h0030;
      else
        if (R0En)
        R0 <= PWDATA[15:0];
    end

                
//==============================================================================
// When written to, these registers will hold their values.
// Register 1 : WDTPSR[0x01FF_8904]:Prescaler value[0x0000 ~ 0xFFFF]
//
//==============================================================================
 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1Seq
      if ((!PRESETn))
        R1 <= {16{1'b1}};
      else
        if (R1En)
        R1 <= PWDATA[15:0];
    end                


//==============================================================================
// When written to, these registers will hold their values.
// Register 2 : WDTLDR[0x01FF_8908]:Load Count Register[0x0001 ~ 0xFFFF]
//
//==============================================================================
 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg2Seq
      if ((!PRESETn))
        R2 <= {16{1'b1}};
      else
        if (R2En)
        R2 <= PWDATA[15:0];
    end                          

//==============================================================================
// Read Only Register
// Register 3 : WDTVLR[0x01FF_890C]:WDT Current Count Value
//
//==============================================================================
 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg3Seq
      if ((!PRESETn))
        R3 <= {16{1'b1}};
      else
        R3 <= WDT_Cnt;
    end                          

//==============================================================================
// When written to, these registers will hold their values.
// Register 2 : WDTIST[0x01FF_8910]:Interrupt Status Register[0x0000]
//
//==============================================================================
 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg4Seq
      if ((!PRESETn))
        R4 <= {16{1'b0}};
      else
        if (R4En)
             R4 <= {16{1'b0}};
       else  R4 <= { {15{1'b0}},WDTISR }; 
      //   else  R4 <= { {15{1'b0}},1'b1 };
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
        case (PADDR[11:6])       
        `EGAPBSLVREG : nextPRDATA = ReadRegs;
        default      : nextPRDATA = {32{1'b0}};  // Read as zero default
      endcase
    end

  always @ (PADDR or R0 or R1 or R2 or R3 or R4)
    begin : p_RdRegMuxComb
      // Determine the next value of ReadRegs
      case (PADDR[5:2])
        `ADDRREG0 : ReadRegs = {{16{1'b0}}, R0 } ;
        `ADDRREG1 : ReadRegs = {{16{1'b0}}, R1 } ;
        `ADDRREG2 : ReadRegs = {{16{1'b0}}, R2 } ;
        `ADDRREG3 : ReadRegs = {{16{1'b0}}, R3 } ;
        `ADDRREGA : ReadRegs = {{16{1'b0}}, R4 } ;
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
// Register 0 : WDTCR[0x01FF_8900]
//
// Reserved[15:6] | DIV[5:4] | CLKSEL[3]] | INTEN[2] | RSTEN[1] |WDTEN[0]
//==============================================================================

assign DIV    = R0[5:4] ;
assign CLKSEL = R0[3]   ;
assign INTEN  = R0[2]   ;
assign RSTEN  = R0[1]   ;
assign WDTEN  = R0[0]   ;

//Divider
//7'b000_0000
always @ (posedge PCLK or negedge PRESETn)
    begin : p_Div_Cnt
     if ((!PRESETn)) 
         Div_Cnt <= {7{1'b0}};
         else 
         if (~WDTEN)
         Div_Cnt <= {7{1'b0}};
         else begin
         if (PS_Match) 
         Div_Cnt <=  Div_Cnt + 1 ; 
            end
             end

always @ (DIV or Div_Cnt or PS_Match)
   begin : p_Div_Match         
         case (DIV)
         2'b00: begin
         if (Div_Cnt[3:0] == 4'b1111   ) //X16
               Div_Match <= PS_Match ;
          else Div_Match <= 1'b0     ;
           end
        
         2'b01: begin
          if (Div_Cnt[4:0] == 5'b11111 ) //X32
               Div_Match <= PS_Match ;
          else Div_Match <= 1'b0     ;
           end               
         
         2'b10: begin
          if (Div_Cnt[5:0] == 6'b11_1111  ) //X64
               Div_Match <= PS_Match ;
          else Div_Match <= 1'b0     ;
           end
           
         default: begin
          if (Div_Cnt[6:0] == 7'b111_1111  ) //X128
               Div_Match <= PS_Match ;
          else Div_Match <= 1'b0     ; 
            end
            endcase
          
           end
           
assign WDT_CLKEN = CLKSEL ?  PS_Match : Div_Match ;

              
//==================================================================
// Register 1 : WDTPSR[0x01FF_8904]:Prescaler value[0x0000 ~ 0xFFFF]
// Timing Sim : One Clock Delay:Prescale_Clock=> Prescale_Clock_1d
//==================================================================
assign PRS_Val = R1 ;
//Common Prescaler
always @ (posedge PCLK or negedge PRESETn)
    begin : p_Prescale
     if ((!PRESETn))
         PS_Cnt <= {16{1'b0}};
         else begin
         if (~WDTEN) 
          PS_Cnt <= {16{1'b0}};
          else begin
         if (PS_Cnt == PRS_Val )
              PS_Cnt <= {16{1'b0}};
         else PS_Cnt <=  PS_Cnt + 1 ; 
             end
              end
               end
                
always @ (posedge PCLK or negedge PRESETn)
          begin : p_PRS_Val
         if ((!PRESETn)) 
                PS_Match <= 1'b0 ; 
            else begin
                if ( PS_Cnt == PRS_Val - 1 ) 
                        PS_Match <= 1'b1 ;
                  else  PS_Match <= 1'b0 ;                         
                       end
                         end       


//assign WDT_CLK = (SCANENABLE )? PCLK : ( CLKSEL ? Prescale_Clock: Div_CLK)  ;
    
//==============================================================================
// When written to, these registers will hold their values.
// Register 2 : WDTLDR[0x01FF_8908]:Load Count Register[0x0001 ~ 0xFFFF]
//
//==============================================================================

assign WDTLDR = R2 ;

always @ (posedge PCLK or negedge WDOGRESn)
 begin : p_WDT_Cnt
     if ((!WDOGRESn)) begin
//Test
//always @ (posedge PCLK or negedge PRESETn)  
//    begin : p_WDT_Cnt
//     if ((!PRESETn)) begin
         WDT_Cnt <= {16{1'b1}};
         R2En_1d <= 1'b0      ;
         end
         else begin
          R2En_1d <= R2En ;
         if (R2En_1d)
          WDT_Cnt <= WDTLDR ;  
       else begin
         if (WDT_CLKEN )begin
         if ( WDT_Cnt == {16{1'b0}})
              WDT_Cnt <= WDTLDR ;
         else WDT_Cnt <=  WDT_Cnt - 1 ; 
            end
             end
              end
               end


//Interrupt Gen

always @ (posedge PCLK or negedge WDOGRESn)
  begin: p_WDISR_RW
      if ((!WDOGRESn)) begin
//Test
//always @ (posedge PCLK or negedge PRESETn)
//  begin: p_WDISR_RW
//      if ((!PRESETn)) begin
           R4En_1d    <= 1'b0 ;
           WDTISR_Clr <= 1'b0 ;
           end
         else begin
         R4En_1d      <=   R4En            ;
         WDTISR_Clr   <= ( R4En_1d | R4En );
            end
             end
//Test
always @ (posedge PCLK or negedge WDOGRESn)  
    begin : p_WDTISR
      if ((!WDOGRESn))         
//always @ (posedge PCLK or negedge PRESETn)  
//    begin : p_WDTISR
//      if ((!PRESETn))
       WDTISR <= 1'b0 ;
       else begin
        if (WDTISR_Clr)
            WDTISR <= 1'b0 ;
      else if (WDT_Cnt == {16{1'b0}} && Div_Match ) //Reload
            WDTISR <= 1'b1 ;
            end
              end

assign  WDOGINT = (INTEN & WDTEN &  WDTISR );        

//SAMSUNG: nRESETOUT , WDOGRES:ARM
//Test
always @ (posedge PCLK or negedge WDOGRESn)  
    begin : p_WDOGRES_Timeout
      if ((!WDOGRESn))

//always @ (posedge PCLK or negedge PRESETn)  
//    begin : p_WDOGRES_Timeout
//      if ((!PRESETn))
        nRESTOUT_Reg <= 1'b1;
        else
        if (~WDTISR) 
           nRESTOUT_Reg <= 1'b1 ;
        else if (WDT_Cnt == {16{1'b0}} && Div_Match )
           //nRESTOUT_Reg <= ~nRESTOUT_Reg ;
            nRESTOUT_Reg <= 1'b0 ; 
            end
             
             
assign nRESTOUT = ( RSTEN && WDTEN  ) ? nRESTOUT_Reg  : 1'b1 ;
assign WDOGRES  = ~nRESTOUT ;
         
endmodule

// --================================= End ===================================--

