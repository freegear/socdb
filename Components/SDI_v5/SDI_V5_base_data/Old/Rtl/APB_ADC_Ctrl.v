// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APB_ADC_Ctrl.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : A/D Converter Controller[8 channel/ 10-bit A/D Converter
//  =============================================================================

`timescale 1ns/1ps

module APB_ADC_Ctrl 
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
ADC_Flag     ,
STBY         ,
AD_Data      ,
ADC_CKIN     ,
AIN_SEL      ,
STC_O        ,



SCANENABLE   , 
SCANINPCLK   , 
SCANOUTPCLK  

);

//Global Parameter
parameter  Cycle_Count     = 5   ;    //Conversion Cyclic Time Number
parameter  ADCDAT_Bit      = 10  ; //Digital Output Number
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
  input         ADC_Flag     ;     // Flag From A/D Converter
  input [ADCDAT_Bit-1:0]   AD_Data      ;     // A/D Converted Data From A/D Converter
  input         ADC_CKIN     ;     // A/D Coverter Clock From Power&Clock Management
  
  output        STBY         ;     //Standby Mode
  output [2:0]  AIN_SEL      ;     //AIN Select
  output        STC_O        ;     //A/D Conversion Enable
  
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
//0x1FF8C00[11:0]
//1100_0000_0000
//       -----ADDREG0
//-------EGAPBSLVREG
//C
`define EGAPBSLVREG 6'b110000

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

  //APB Signal
  wire        PCLK         ;
  wire        PRESETn      ;
  wire        PENABLE      ;
  wire        PSEL         ;
  wire        PWRITE       ;
  wire [11:2]  PADDR        ;
  wire [31:0] PWDATA       ;
  wire [31:0] PRDATA       ;
  
  // Internal Signals
  wire        Valid           ;         // Detect valid transfers
  wire        R0En            ;          // Register update enables
  wire        R1En            ;
  reg  [31:0] nextPRDATA      ;    // Mux, Register and Enable for PRDATA
  reg  [31:0] ReadRegs        ;
  reg  [31:0] iPRDATA         ;
  wire        ReadRegEn       ;  
   
  //Function Signal
  wire        ADC_Flag        ;  
  wire [ADCDAT_Bit-1:0]  AD_Data         ; 
  wire        ADC_CKIN        ;
    
  wire        Interrupt19     ;
  reg  [2:0]  AIN_SEL         ;
  wire        ADC_Clock_STBY  ;
  wire        STBY            ;
  reg         Flag_1d         ;
  reg         Flag_Neg_Det    ; //Flag Negedge Detection: ADCDAT load enable
  reg         Flag_Neg_Det_1d ; //FLAG[15] Set
 // reg         Flag_Pos_Det    ; //Flag Posedge Detection
  reg         STC_En          ;
  reg         ADC_CKIN_1d     ;
  reg         ADC_CKIN_Det    ;
  reg [2:0]   STC_Cnt         ;  
  reg         STC_O           ;
  reg         STC_Pulse       ;
  reg         STC_O_1d        ;
  
  //reg         R0_ADEN_Reg     ;
  
  wire        INV_ADK_CKIN    ;
  wire        SCANENABLE      ;
  wire        SCANINPCLK      ;
  wire        SCANOUTPCLK     ;


   
  reg  [15:0]  R0            ;            // Read/Write registers
  reg  [ADCDAT_Bit-1:0]   R1 ;

 

  


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
  
  //ADDCON
  assign R0En = ((PADDR[5:2] == `ADDRREG0) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0x00

  //ADCDAT
  assign R1En = ((PADDR[5:2] == `ADDRREG1) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x04
//==============================================================================
// Read/write registers
//==============================================================================
// When written to, these registers will hold their values.
// Register 0 : ADCCON[0x01FF_8C00]
//
// FLAG[15] | Reserved[14:6] | ASEL[5:3] | STBY[2] | READ_START[1] |ADEN[0]
//==============================================================================
//Auto Clear
always @ (posedge PCLK or negedge PRESETn)
      begin : p_R0_Pending
       if ((!PRESETn))     
         R0[0] <= 1'b0 ;
         else
          
          if (STC_Pulse) 
               R0[0] <= 1'b0 ;
          else if (R0En) begin
                R0[0] <= PWDATA[0] ;
               end
                end
                
//ADEN Real Enable
always @ (posedge PCLK or negedge PRESETn)
      begin : p_R0_ADEN
       if ((!PRESETn))     
               R0[6] <= 1'b0 ;
         else
          if (R0En) begin
                R0[6] <= PWDATA[0] ;
               end
                end                
                

                
                
always @ (posedge PCLK or negedge PRESETn)
     begin : p_R0_Seq
       if ((!PRESETn)) begin
           R0[5:1] <= 5'b0_0010 ; //ASEL|STBY|READ_START|ADEN
          
           //synopsys translate_off
           R0[14:6]  <= 9'd0 ;
           //synopsys translate_on 
                       end
           else
           
           if (R0En) begin
           R0[5:1] <= PWDATA[5:1] ;
           //R0[14:6] Reserved :9'd0 ;
           //R0[15]  <= PWDATA[15]  ;
                     end
                       end
          
//==============================================================================
// Read only registers
// FLAG[15]
//==============================================================================
//SAMSUNG
//reg STC_In    ;


always @ (posedge PCLK or negedge PRESETn)
begin : p_R0_Flag2
   if ((!PRESETn))
        R0[15]    <= 1'b0 ;
        else
        if (Flag_Neg_Det_1d) 
             R0[15]  <= 1'b1   ;
        
        else if (STC_Pulse)  
           R0[15]  <= 1'b0     ;
            end
            
/*
always @ (posedge PCLK or negedge PRESETn)
begin : p_R0_Flag1
   if ((!PRESETn))
        R0[15]  <= 1'b0  ;
        else
        if (Flag_Neg_Det_1d)
             R0[15]  <= 1'b1   ;
        else begin 
         if (STC_In)  
           R0[15]  <= 1'b0 ;
          end 
            end
*/


             
     

 //==============================================================================
// Read only registers      
// Register 1 : ADCDAT[0x01FF_8C04]
// ADCDAT[9:0]
//============================================================================== 
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1Seq
      if ((!PRESETn))
        R1 <= {10{1'b0}};
      else
        if (Flag_Neg_Det)
        R1 <= AD_Data[ADCDAT_Bit-1:0];
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
     // case (PADDR[7:6])
        case (PADDR[11:6])       
        `EGAPBSLVREG : nextPRDATA = ReadRegs;
     //   `EASPA       : nextPRDATA = ReadIDs;
        default      : nextPRDATA = {32{1'b0}};  // Read as zero default
      endcase
    end

  always @ (PADDR or R0 or R1 )
    begin : p_RdRegMuxComb
      // Determine the next value of ReadRegs
      case (PADDR[5:2])
        `ADDRREG0 : ReadRegs = {16'h0000, R0[15], 8'd0, R0[6:0] } ;
        `ADDRREG1 : ReadRegs = {22'd0, R1}   ;
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

//============Function Gen==========================
//
//==================================================
//STBY[2] : Power
//==================================================
//TSMC
 assign ADC_Clock_STBY = (~R0[2] & ADC_CKIN      );  

//SAMSUNG
 assign STBY = R0[2] ; //Power
  
//==================================================
//ADEN[0] : A/D-Converter Enable : Auto Clear
//================================================== 
//Flag Detection : 

 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Flag_Detect
      if ((!PRESETn)) begin
            Flag_1d         <= 1'b0 ;
            Flag_Neg_Det    <= 1'b0 ;
            Flag_Neg_Det_1d  <= 1'b0 ;
            end 
           else  begin
            Flag_1d         <= ADC_Flag       ;
            Flag_Neg_Det_1d <= Flag_Neg_Det   ;
           if ( Flag_1d == 1'b1 &&  ADC_Flag == 1'b0 )
                        Flag_Neg_Det <= 1'b1 ;
                   else Flag_Neg_Det <= 1'b0 ;
                   
                    end 
                     end
/*
 always @ (posedge PCLK or negedge PRESETn)
    begin : p_Flag_Detect2
      if ((!PRESETn)) begin
            Flag_1d        <= 1'b0 ;
            Flag_Neg_Det   <= 1'b0 ;
            Flag_Pos_Det   <= 1'b0 ;
            end 
           else  begin
            Flag_1d        <= ADC_Flag  ;
       
           if ( Flag_1d == 1'b1 &&  ADC_Flag == 1'b0 ) begin
                    Flag_Neg_Det <= 1'b1 ;
                    Flag_Pos_Det <= 1'b0 ;
                    end 
           else if ( Flag_1d == 1'b0 &&  ADC_Flag == 1'b1 ) begin
                    Flag_Neg_Det <= 1'b0 ;
                    Flag_Pos_Det <= 1'b1 ;         
                    end
            else begin
                    Flag_Neg_Det <= 1'b0 ;
                    Flag_Pos_Det <= 1'b0 ;            
                 end    
                  
                  end 
                   end
*/
//==================================================
//READ_START[1] : Interrupt[19] :ReadRegEn & PADDR
//================================================== 
//R0[1]
assign Interrupt19 = R0[1] ; 

//==================================================
//ASEL[5:3] : Analog Input Select 
//================================================== 
//R0[5:3],DFT Check,SAMSUNG

assign INV_ADK_CKIN = (SCANENABLE )? PCLK : ~ADC_CKIN ;
always @(posedge  INV_ADK_CKIN or  negedge PRESETn)
         begin: p_ASEL_nege
     if ((!PRESETn)) 
          AIN_SEL <= 3'b000 ;
          else
          AIN_SEL <= R0[5:3] ;
          end
            

//==================================================
//STC Generation : READ_START[1], ADEN[0], 
//==================================================
//Priority Check

always @( R0 )
   begin: p_STC_En
     if (R0[1])
       STC_En    <= 1'b1 ;
       else 
        if (R0[6])
             STC_En  <= 1'b1 ;
        else STC_En  <= 1'b0 ;
          end



always @(posedge PCLK or negedge PRESETn)
    begin : p_AD_CLKIN
        if ((!PRESETn)) begin
          ADC_CKIN_1d  <= 1'b0 ;
          ADC_CKIN_Det <= 1'b0 ;  
                        end
          else begin
          ADC_CKIN_1d <= ADC_CKIN ;
          if (ADC_CKIN & (~ADC_CKIN_1d))
                 ADC_CKIN_Det <= 1'b1 ;
            else ADC_CKIN_Det <= 1'b0 ;
             end  
               end
               
always @(posedge PCLK or negedge PRESETn)
       begin : p_STC_Count
        if ((!PRESETn))      
           STC_Cnt <= 3'b000 ;
           else begin
            if (~STC_En)
               STC_Cnt <=3'b000 ;
             else begin  
            if ( ADC_CKIN_Det) begin
              if (STC_Cnt == Cycle_Count)
                   STC_Cnt <= 3'b001 ;
              else STC_Cnt <= STC_Cnt + 1 ;   
                 end 
                   end
                    end
                     end
//STC Gen
always @(posedge PCLK or negedge PRESETn)
       begin : p_STC_Gen
        if ((!PRESETn))     
          STC_O <= 1'b0 ;
          else
          if (STC_Cnt == 3'b101 | STC_Cnt == 3'b000)
                 STC_O <= 1'b0 ;
            else STC_O <= 1'b1 ;
             end


always @(posedge PCLK or negedge PRESETn)
       begin : p_STC_Pulse_Gen
        if ((!PRESETn)) begin     
           STC_O_1d  <= 1'b0 ;
           STC_Pulse <= 1'b0 ;
            end
          else  begin     
           STC_O_1d <= STC_O ;
           if ((STC_O) && (~STC_O_1d)) 
                 STC_Pulse <= 1'b1 ;
            else STC_Pulse <= 1'b0 ;
              end  
               end
endmodule

// --================================= End ===================================--

