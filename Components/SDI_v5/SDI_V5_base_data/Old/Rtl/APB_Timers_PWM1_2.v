// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APB_Timers_EA.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : 16-Bit Timers ,Cental Prescaler, TCAP Detection
//  =============================================================================

`timescale 1ns/1ps

module APB_Timers_PWM1_2 
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
TCLK         ,
TCAP         ,
INT_TPOUT    ,
INT_TOF      ,
INT_TMC      ,


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
  input  [11:2] PADDR       ;     // Address (used bits only)
  input  [31:0] PWDATA      ;     // Read data
  output [31:0] PRDATA      ;     // Write data

 //Function BL
  input TCLK                 ;

  
  input  [7:0] TCAP          ;
  output       INT_TPOUT     ;
  output       INT_TOF       ;     //Overflow[16'hFFFF Interrupt
  output       INT_TMC       ;     //Match Interrupt To Interrupt 

  
  
    
 
 
 
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
//0x1FF8400[11:0]~ 0x1FF84F0[11:0]
//0100_0000_0000
//     -------ADDREG0
//-----EGAPBSLVREG
//0x400
//0x01FF_8600
//Timers :0110_0000
//                     11  8   
`define EGAPBSLVREG  4'b0110

//Timers2 
`define ADDRREG0  6'b0100_00    //0x40 
`define ADDRREG1  6'b0100_01    //0x44 
`define ADDRREG2  6'b0100_10    //0x48 
`define ADDRREG3  6'b0100_11    //0x4C 
`define ADDRREG4  6'b0101_00    //0x50 



//OMS[Operation Mode] 
`define OMSCode0 3'b000  //Interval mode
`define OMSCode1 3'b001  //Match & Overflow mode
`define OMSCode2 3'b010  //PWM mode

`define OMSCode4 3'b100  //Capture on falling edge of TCAP3,4,5
`define OMSCode5 3'b101  //Capture on rising edge of TCAP3,4,5
`define OMSCode6 3'b110  //Capture on both edge of TCAP3,4,5

//Prescaler 
`define  prescale_bypass 8'b0000_0000 //X1
`define  Prescale_para0  8'b0000_0001 //X2   : 1
`define  Prescale_para1  7'b0000_001  //X4   : 2~3
`define  Prescale_para2  6'b0000_01   //X8   : 4~7
`define  Prescale_para3  5'b0000_1    //X16   : 8~15
`define  Prescale_para4  4'b0001      //X32  : 16~31
`define  Prescale_para5  3'b001       //X64  : 32~63
`define  Prescale_para6  2'b01        //X128  : 64~127    
`define  Prescale_para7  1'b1         //X256 : 128~255
 

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
  wire [11:2]  PADDR          ;
  wire [31:0] PWDATA          ;
  wire [31:0] PRDATA          ;
  
  // Internal Signals
  
  wire        Valid           ;         // Detect valid transfers
  wire        R0En            ;          // Register update enables
  wire        R1En            ;
  wire        R2En            ;
  wire        R3En            ;
  wire        R4En            ;
  
 
  reg  [31:0] nextPRDATA      ;    // Mux, Register and Enable for PRDATA
 
 
  reg  [31:0] ReadRegs        ;
  reg  [31:0] iPRDATA         ;
  wire        ReadRegEn       ; 
  //Function BL
  wire TCLK                  ;
   
   
  //Function Signal
  wire [7:0]  TCAP            ;
  
  reg [15:0]  Timer_Cnt       ;  
  reg         Timer_Match_Set ;

  
  reg [7:0]   Prescale_Cnt    ;
  reg         Prescale_Clock  ;
  reg         Timer_Out       ;

  
  reg         TDx_CapEn         ;
  reg         TDX_Up            ;
  reg         TDX_CapEn_1Pd     ;
  reg [7:0]   TCAP_Reg          ;
  reg [7:0]   TCAP_Reg_1d       ;
  reg         INT_TPOUT         ;   
  reg         Timers_OverFlow   ;

  reg         PWM_Out           ;
  wire [15:0] TDAT_Value        ;
  wire        ICS               ;
  wire        Timers_CLK        ;
  wire        TEN               ;
  wire        CL_Bit            ;

  
  wire Timers_CLR               ;
  wire [2:0]  OMS               ;
  wire IVT                      ; 
  wire [15:0] TPWM              ;
  
  wire        SCANENABLE        ;
  wire        SCANINPCLK        ;
  wire        SCANOUTPCLK       ;



  //Timers0 
  reg  [15:0]  R0            ;            
  reg  [7:0]   R1            ;
  reg  [7:0]   R2            ;
  reg  [15:0]  R3            ;  
  reg  [15:0]  R4            ;  
  wire         INT_TOF       ;     //Overflow[16'hFFFF Interrupt
  wire         INT_TMC       ;     //Match Interrupt To Interrupt 
 
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
   //synopsys translate_on                 
  //PWM end registers<CV[15:0]>
  assign R4En = ((PADDR[7:2] == `ADDRREG4) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x10               
   
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

//==============================================================================
// Timer Control Register[0x01FF_8408]    
// TCONx[7:0]:0x00
// TEN[7]|CL[6]|OMS[5:3]|ICS[2]|IVT[1]|Reserved
//============================================================================== 
 
 //Timers0
  always @(posedge PCLK or negedge PRESETn)
    begin : p_Reg2Seq
      if ((!PRESETn))
        R2 <= 8'h00;
      else
        if (R2En)
        R2 <= PWDATA[7:0];
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
     
//==============================================================================
// PWM end register[0x01FF_8410]    
// TPWM[15:0]:0x00FF
// Current PWM's end count value during PWM operation
//============================================================================== 
//Timers 0
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg4Seq
      if ((!PRESETn))
        R4 <= 16'h00FF;
      else
        if (R4En)
        R4 <= PWDATA[15:0] ;
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

  always @ (PADDR or ReadRegs )
    begin : p_ReadMuxComb
      // Determine the next value of nextPRDATA
      case (PADDR[11:8]) 
        `EGAPBSLVREG  : nextPRDATA = ReadRegs  ;             
     //   `EASPA       : nextPRDATA = ReadIDs;
        default      : nextPRDATA = {32{1'b0}};  // Read as zero default
      endcase
    end


 always @ (PADDR or R0 or R1 or R2 or R3 or R4 )
          begin : p_RdRegMuxComb
      // Determine the next value of ReadRegs0
      case (PADDR[7:2])
       // case (PADDR[4:2]) 
        `ADDRREG0 : ReadRegs  = {{16{1'b0}},  R0  };
        `ADDRREG1 : ReadRegs  = {24'd0, R1        };
        `ADDRREG2 : ReadRegs  = {24'd0, R2        };
        `ADDRREG3 : ReadRegs  = {16'd0, R3        };
        `ADDRREG4 : ReadRegs  = {16'd0, R4        };
         default  : ReadRegs   = {32{1'b0}}        ;  // Read as zero default
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
         if (~TEN)
              Prescale_Cnt <= {8{1'b0}};
         else Prescale_Cnt <=  Prescale_Cnt + 1 ; 
            end
             end
//Prescaler 
//`define  prescale_bypass 8'b0000_0000 //X1
//`define  Prescale_para0  8'b0000_0001 //X2   : 1
//`define  Prescale_para1  7'b0000_001  //X4   : 2~3
//`define  Prescale_para2  6'b0000_01   //X8   : 4~7
//`define  Prescale_para3  5'b0000_1    //X16   : 8~15
//`define  Prescale_para4  4'b0001      //X32  : 16~31
//`define  Prescale_para5  3'b001       //X64  : 32~63
//`define  Prescale_para6  2'b01        //X128  : 64~127    
//`define  Prescale_para7  1'b1         //X256 : 128~255

//Timers0
always @ (R1 or Prescale_Cnt or PCLK)
 begin : p_Prescale_Clock
        
        if (R1 == `prescale_bypass )
           Prescale_Clock = PCLK             ;
    else if (R1 == `Prescale_para0) 
           Prescale_Clock = Prescale_Cnt[0]  ;  //X2
       
    else if (R1[7:1] == `Prescale_para1)
           Prescale_Clock = Prescale_Cnt[1]  ;  //X4
       
    else if (R1[7:2] == `Prescale_para2)
           Prescale_Clock = Prescale_Cnt[2]  ;  //X8  

    else if (R1[7:3] == `Prescale_para3)
           Prescale_Clock = Prescale_Cnt[3]  ;  //X16
       
    else if (R1[7:4] == `Prescale_para4)
           Prescale_Clock = Prescale_Cnt[4]  ;  //X32  
      
    else if (R1[7:5] == `Prescale_para5 )
           Prescale_Clock = Prescale_Cnt[5]  ;  //X64
      
    else if (R1[7:6] == `Prescale_para6)
           Prescale_Clock = Prescale_Cnt[6]   ;  //X128            
     else  Prescale_Clock = Prescale_Cnt[7]   ;  //X256
              end
                                             
//==============================================================================
// R2:Timer Control Register[0x01FF_8408]    
// TCONx[7:0]:0x00
// TEN[7]|CL[6]|OMS[5:3]|ICS[2]|IVT[1]|Reserved
//==============================================================================                    
  
assign ICS      = R2[2]     ;
assign TEN      = R2[7]     ;
assign CL_Bit   = R2[6]     ;
assign OMS      = R2[5:3]   ;

  
//DFT Check: Select 1-2
//1
//assign Timers_CLK = (SCANENABLE )? TCLK0    : (ICS? TCLK0: Prescale_Clock) ; 
//2
//Timers 0
assign Timers_CLK = (SCANENABLE )? PCLK    : ( ICS     ? TCLK: Prescale_Clock) ;  
assign Timers_CLR = (SCANENABLE )? PRESETn : ( PRESETn & (~CL_Bit) )            ;

//=======================================================================================
// 16-Bit Timer Counter
//=======================================================================================

//Timers 0
always @ (posedge Timers_CLK or negedge Timers_CLR)
    begin : p_Timers_Count //4
     if ((!Timers_CLR))
      Timer_Cnt <= {16{1'b0}};
      else begin 
        if (~TEN) 
         Timer_Cnt <= {16{1'b0}}; 
      else begin 
       if (OMS == `OMSCode0  ) begin  //Internal Mode
      if (Timer_Cnt == TDAT_Value-1  )
             Timer_Cnt <=  {16{1'b0}}; 
       else  Timer_Cnt <= Timer_Cnt + 1 ;
                               end
       else if (OMS == `OMSCode2  ) begin
         if (Timer_Cnt == TPWM-1)  
              Timer_Cnt <= {16{1'b0}}    ;
         else Timer_Cnt <= Timer_Cnt + 1 ;
                                    end
            else  begin
            Timer_Cnt <= Timer_Cnt + 1  ;                   
              end
         end 
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

//Timer 0 ~ 7                         
assign INT_TOF   = Timers_OverFlow   ;                       

//-------------------------------------------------------------
// Tout Mode Timing Match
//-------------------------------------------------------------
//Timers 0                  
always @(posedge Timers_CLK or negedge Timers_CLR)
          begin : p_Timer_Match_Gen
         if ((!Timers_CLR)) 
                Timer_Match_Set <= 1'b0 ; 
            else begin
                if ( Timer_Cnt == TDAT_Value - 2 ) 
                        Timer_Match_Set <= 1'b1 ;
                  else  Timer_Match_Set <= 1'b0 ;                         
                       end
                          end       
assign INT_TMC  = Timer_Match_Set   ; 

//----------------------------------------------------------
// Time Out
//----------------------------------------------------------
always @(posedge Timers_CLK or negedge Timers_CLR)
          begin : p_Interval
         if ((!Timers_CLR))
            
                 Timer_Out <= 1'b0 ;
              else begin
               if ( OMS != `OMSCode0 )
                   Timer_Out <= 1'b0 ;
               else begin
               if (Timer_Match_Set)
                   Timer_Out <=  Timer_Out + 1 ;   
                     end              
                    end 
                     end       

                                                               
//==============================================================================
// PWM end register[0x01FF_8410]    
// TPWM[15:0]:0x00
// Current PWM's end count value during PWM operation
//============================================================================== 
assign TPWM = R4 ;
always @(posedge Timers_CLK or negedge Timers_CLR)
          begin : p_PWM_O
          if ((!Timers_CLR))
              PWM_Out <= 1'b1 ;
              else begin
              if ( OMS != `OMSCode2 ) 
                  PWM_Out <= 1'b1 ;
                  else begin
                 if (Timer_Cnt > TDAT_Value-2 && Timer_Cnt < TPWM-1 )  
                   PWM_Out <=  1'b0 ;
              else PWM_Out <=  1'b1 ;
                        end  
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

//-------------------------------------------
// Tout/PWMout/INT_TMC/Edge
//-------------------------------------------

//Timer 0
always @(OMS or IVT or Timer_Out or Timer_Match_Set or TDx_CapEn or PWM_Out)
 begin: p_TOUT_SEL
   case (OMS) 
    `OMSCode0 : begin
     if (~IVT) 
           INT_TPOUT = Timer_Out  ;
      else INT_TPOUT = ~Timer_Out ;
      end 
    
    `OMSCode1 : INT_TPOUT = Timer_Match_Set ;  
    `OMSCode2 : begin
      if (~IVT) 
           INT_TPOUT =  PWM_Out     ;
      else INT_TPOUT = ~PWM_Out     ;
                end
    `OMSCode4 : INT_TPOUT = TDx_CapEn ;
    `OMSCode5 : INT_TPOUT = TDx_CapEn ;
    `OMSCode6 : INT_TPOUT = TDx_CapEn ; 
     default  : INT_TPOUT = Timer_Out ;
    
        endcase
          end
          
endmodule

// --================================= End ===================================--

