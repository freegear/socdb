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

module WatchDog (
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
	WDOGRESn     ,  // Watchdog clock reset  
	WDOGINT      ,  // Watchdog interrupt    
	WDOGRES
);


//APB
  input         PCLK        ;     // APB system clock
  input         PRESETn     ;     // APB system reset
  input         PENABLE     ;     // Data valid strobe 
  input         PSEL        ;     // Module select signal
  input         PWRITE      ;     // Write/nRead signal
  input  [ 7:2] PADDR       ;     // Address (used bits only)
  input  [31:0] PWDATA      ;     // Read data
  output [31:0] PRDATA      ;     // Write data

 //Function BL
  input         WDOGRESn    ;  // Watchdog clock reset    
  output        WDOGINT     ;  // Watchdog interrupt      
  output        WDOGRES     ;  // Watchdog timeout reset  
  
// Module Address Map:
// Read/write 32-bit registers:
//
// Address  Read      Write
// 0x00     0 = R0    R0
// 0x04     1 = R1    R1

//0x1FF8900
parameter ADDRREG0 = 6'b000000; //0x000 
parameter ADDRREG1 = 6'b000001; //0x004
parameter ADDRREG2 = 6'b000010; //0x008
parameter ADDRREG3 = 6'b000011; //0x00C
parameter ADDRREGA = 6'b000100; //0x010

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

  //APB Signal
  wire        PCLK         ;
  wire        PRESETn      ;
  wire        PENABLE      ;
  wire        PSEL         ;
  wire        PWRITE       ;
  wire [ 7:2] PADDR       ;
  wire [31:0] PWDATA       ;
  
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
    
  reg  [31:0] ReadRegs     ;
  reg  [31:0] PRDATA      ;
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
  
  assign R0En = ((PADDR[7:2] == ADDRREG0) && Valid && PWRITE) ? 1'b1 : 1'b0;  // Offset 0x00
 
  assign R1En = ((PADDR[7:2] == ADDRREG1) && Valid && PWRITE) ? 1'b1 : 1'b0;  // Offset 0x04
  
  assign R2En = ((PADDR[7:2] == ADDRREG2) && Valid && PWRITE) ? 1'b1 : 1'b0;  // Offset 0x08

//synopsys translate_off  
  assign R3En = ((PADDR[7:2] == ADDRREG3) && Valid && PWRITE) ? 1'b1 : 1'b0;  // Offset 0x0C
//synopsys translate_on
  
  assign R4En = ((PADDR[7:2] == ADDRREGA) && Valid && PWRITE) ? 1'b1 : 1'b0;  // Offset 0x10                            
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

  always @ (PADDR or R0 or R1 or R2 or R3 or R4)
    begin : p_RdRegMuxComb
      // Determine the next value of ReadRegs
      case (PADDR[7:2])
        ADDRREG0 : ReadRegs = {{16{1'b0}}, R0 } ;
        ADDRREG1 : ReadRegs = {{16{1'b0}}, R1 } ;
        ADDRREG2 : ReadRegs = {{16{1'b0}}, R2 } ;
        ADDRREG3 : ReadRegs = {{16{1'b0}}, R3 } ;
        ADDRREGA : ReadRegs = {{16{1'b0}}, R4 } ;
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
        PRDATA <= {32{1'b0}};
      else
        if (ReadRegEn)
          PRDATA <= ReadRegs; 
    end
 
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
         if (&Div_Cnt[3:0]) //X16
               Div_Match <= PS_Match ;
          else Div_Match <= 1'b0     ;
           end
        
         2'b01: begin
          if (&Div_Cnt[4:0]) //X32
               Div_Match <= PS_Match ;
          else Div_Match <= 1'b0     ;
           end               
         
         2'b10: begin
          if (&Div_Cnt[5:0]) //X64
               Div_Match <= PS_Match ;
          else Div_Match <= 1'b0     ;
           end
           
         default: begin
          if (&Div_Cnt[6:0]) //X128
               Div_Match <= PS_Match ;
          else Div_Match <= 1'b0     ; 
            end
            endcase
          
           end

/*
reg DivOut, DivOutD1, DivOutD2;
always @(DIV or Div_Cnt) 
  case(DIV)  // synopsys parallel_case
    2'b00   : DivOut = Div_Cnt[3];
    2'b01   : DivOut = Div_Cnt[4];
    2'b10   : DivOut = Div_Cnt[5];
    default : DivOut = Div_Cnt[6];
  endcase

always @(negedge PRESETn or posedge PCLK) 
  if (!PRESETn) DivOutD1 <= 1'b0;
  else          DivOutD1 <= DivOut;

always @(negedge PRESETn or posedge PCLK) 
  if (!PRESETn) DivOutD2 <= 1'b0;
  else          DivOutD2 <= DivOutD1;

wire CntEn = ~DivOutD1 & DivOutD2;
*/

wire WDT_CLKEN = CLKSEL ?  PS_Match : Div_Match ;

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

//==============================================================================
// When written to, these registers will hold their values.
// Register 2 : WDTLDR[0x01FF_8908]:Load Count Register[0x0001 ~ 0xFFFF]
//
//==============================================================================

assign WDTLDR = R2 ;

wire ReLoad = (WDT_Cnt == {16{1'b0}}) ? 1'b1 : 1'b0;

//always @ (posedge PCLK or negedge WDOGRESn)
// begin : p_WDT_Cnt
//     if ((!WDOGRESn)) begin
//Test
always @ (posedge PCLK or negedge PRESETn)  
    begin : p_WDT_Cnt
     if ((!PRESETn)) begin
         WDT_Cnt <= {16{1'b1}};
         R2En_1d <= 1'b0      ;
         end
         else begin
          R2En_1d <= R2En ;
         if (R2En_1d)
          WDT_Cnt <= WDTLDR ;  
       else begin
         if (WDT_CLKEN )begin
         if (ReLoad)
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
           R4En_1d    <= 1'b0 ;
           WDTISR_Clr <= 1'b0 ;
           end
         else begin
         R4En_1d      <=   R4En            ;
         WDTISR_Clr   <= ( R4En_1d | R4En );
            end
             end

always @ (posedge PCLK or negedge WDOGRESn)  
    begin : p_WDTISR
      if ((!WDOGRESn))
       WDTISR <= 1'b0 ;
       else begin
        if (WDTISR_Clr)
            WDTISR <= 1'b0 ;
      else if (ReLoad && WDT_CLKEN ) //Reload
            WDTISR <= 1'b1 ;
            end
              end

assign  WDOGINT = (INTEN & WDTEN &  WDTISR );        

//SAMSUNG: nRESETOUT , WDOGRES:ARM
always @ (posedge PCLK or negedge WDOGRESn)  
    begin : p_WDOGRES_Timeout
      if ((!WDOGRESn))
        nRESTOUT_Reg <= 1'b1;
        else
        if (~WDTISR) 
           nRESTOUT_Reg <= 1'b1 ;
        else if (ReLoad && WDT_CLKEN )
           //nRESTOUT_Reg <= ~nRESTOUT_Reg ;
            nRESTOUT_Reg <= 1'b0 ; 
            end
             
             
assign nRESTOUT = ( RSTEN && WDTEN  ) ? nRESTOUT_Reg  : 1'b1 ;
assign WDOGRES  = ~nRESTOUT ;
         
endmodule

// --================================= End ===================================--

