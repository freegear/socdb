// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APB_Timers_EAX0.v --> timer_pwm.v
// File Revision       : 1.0
//			                 1.1 gated clock are modfied by kwoly
//                           perscaling modified
//                       1.2 Output clock 4 clock delay 
//                           The width of Interrupt clock are modified
//                              counter ==> PCLK 1clock 
//                       1.3 gated reset remove
//                       1.4 TCAP are separated
//
//  -----------------------------------------------------------------------------
//  Purpose            : 16-Bit Timers ,Cental Prescaler, TCAP Detection
//  =============================================================================

`timescale 1ns/1ps

module timer_pwm 
(
//APB
PCLK         , 
PRESETn      , 
PENABLE      , 
PSEL         , 
PWRITE       , 
PADDR        , // [4:2] are used and otehr pins not connect
PWDATA       , // [15:0] are used and other pins not connect
PRDATA       ,

//Function
INT_TMC

);

//Global Parameter
//APB
  input         PCLK        ;     // APB system clock
  input         PRESETn     ;     // APB system reset
  input         PENABLE     ;     // Data valid strobe 
  input         PSEL        ;     // Module select signal
  input         PWRITE      ;     // Write/nRead signal
  input  [3:2] PADDR       ;     // Address (used bits only)

  //input  [31:0] PWDATA      ;     // Read data
  input  [31:0] PWDATA      ;     // Read data Ver 1.1
  output [31:0] PRDATA      ;     // Write data

  output       INT_TMC       ;     //Match Interrupt To Interrupt 

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
//0x01FF_8400
//Timers :0100_0000
//                     11  8   


//`define EGAPBSLVREG  4'b0100
//`define EGAPBSLVREG  7'b0100_000 //40
//`define EGAPBSLVREG1 7'b0100_001 //42
//`define EGAPBSLVREG2 7'b0100_010 //44
//`define EGAPBSLVREG3 7'b0100_011 //46
//`define EGAPBSLVREG4 7'b0100_100 //48
//`define EGAPBSLVREG5 7'b0100_101 //4A
//`define EGAPBSLVREG6 7'b0100_110 //4C
//`define EGAPBSLVREG7 7'b0100_111 //4E


//Timers0 
//ver 1.1
/*
`define ADDRREG0  6'b000000      //0x00
`define ADDRREG1  6'b000001      //0x04
`define ADDRREG2  6'b000010      //0x08
`define ADDRREG3  6'b000011      //0x0C
`define ADDRREG4  6'b000100      //0x10
*/

`define ADDRREG0  3'b00      //0x00
`define ADDRREG1  3'b01      //0x04
`define ADDRREG2  3'b10      //0x08
`define ADDRREG3  3'b11      //0x0C


//OMS[Operation Mode] 
`define OMSCode0 1'b0  //Interval mode
`define OMSCode1 1'b1  //Match & Overflow mode

//Prescaler 

/*
`define  prescale_bypass 8'b0000_0000 //X1
`define  Prescale_para0  8'b0000_0001 //X2   : 1
`define  Prescale_para1  7'b0000_001  //X4   : 2~3
`define  Prescale_para2  6'b0000_01   //X8   : 4~7
`define  Prescale_para3  5'b0000_1    //X16   : 8~15
`define  Prescale_para4  4'b0001      //X32  : 16~31
`define  Prescale_para5  3'b001       //X64  : 32~63
`define  Prescale_para6  2'b01        //X128  : 64~127    
`define  Prescale_para7  1'b1         //X256 : 128~255
*/

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

  //APB Signal
  wire        PCLK            ;
  //wire        PRESETn         ; ver1.3
  wire        PENABLE         ;
  wire        PSEL            ;
  wire        PWRITE          ;
  wire [3:2]  PADDR          ;
  wire [31:0] PWDATA          ; //ver 1.1 31->15
  wire [31:0] PRDATA          ;
  
  // Internal Signals
  
  wire        Valid           ;         // Detect valid transfers
  wire        R0En            ;          // Register update enables
  wire        R1En            ;
  wire        R2En            ;

  // Add Ver1.1
  //synopsys translate_off           
  // syplify notice the warning Ver1.1
  //wire        R3En            ;

  // Add Ver1.1
  //synopsys translate_on              

  reg  [31:0] nextPRDATA      ;    // Mux, Register and Enable for PRDATA
 
 
  reg  [31:0] ReadRegs        ;
  
  //reg  [31:0] iPRDATA         ; Ver 1.1
  reg  [31:0] iPRDATA         ;
  wire        ReadRegEn       ; 
   
   
  reg [31:0]  Timer_Cnt       ;  
  reg         Timer_Match_Set ;
  
  //reg [7:0]   Prescale_Cnt    ; 
  //reg         Prescale_Clock  ; Ver1.1

  reg [9:0]   Prescale_Cnt    ; 
  reg         Timer_Out       ;
  
  wire [31:0] TDAT_Value        ;
  //wire        Timers_CLK        ; // Ver1.1
  wire        TEN               ;
  wire        CL_Bit            ;

  
  //wire PRESETn               ;
  wire         Mode;
  
  //Timers0 
  reg  [31:0]  R0            ;            
  //reg  [7:0]   R1            ;
  reg  [9:0]   R1            ; // Ver1.1
  reg  [2:0]   R2            ;
  reg  [31:0]  R3            ;  
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

/*
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
*/

  assign R0En = ((PADDR[3:2] == `ADDRREG0) && Valid && PWRITE) ? 1'b1 
                : 1'b0;  // Offset 0x00

  //Timer Prescaler register<TPREx[7:0]>
  assign R1En = ((PADDR[3:2] == `ADDRREG1) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x04
 
  //Timer Control register<TCONx[7:0]>
  assign R2En = ((PADDR[3:2] == `ADDRREG2) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x08

  //synopsys translate_off              
  
  //Timer Count Register<CV[15:0]>
  //
  // syplify notice the warning Ver1.1
  /*
  assign R3En = ((PADDR[4:2] == `ADDRREG3) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x0C
  */

   //synopsys translate_on                 
  
//==============================================================================
   
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
        R0 <= 32'hFFFFFFFF ;
    else
    begin
        if(CL_Bit) //ver 1.3
            R0 <= 32'hFFFFFFFF;
        else if (R0En)
            R0 <= PWDATA[31:0] ;
    end
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
        R1 <= 10'h3FF;
    else
    begin
        if(CL_Bit)
            R1 <= 10'h3FF;
        else if (R1En)
            R1 <= PWDATA[9:0];
    end
end

//==============================================================================
// Timer Control Register[0x01FF_8408]    
// TCONx[2:0]:0x00
// Mode[2]|CL[1]|TEN[0]
//============================================================================== 
 
//Timers0
always @(posedge PCLK or negedge PRESETn)
begin : p_Reg2Seq
    if ((!PRESETn))
        R2 <= 3'b000;
    else
    begin
        if(CL_Bit)
            R2 <= 3'b000;
        else if (R2En)
            R2 <= PWDATA[2:0];
    end
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
        R3 <= 32'h00000000;
    else
        //if (R3En)
        //R3 <= PWDATA[15:0];
        if(CL_Bit)
            R3 <= 32'h00000000;
        else
            R3 <= Timer_Cnt ;
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

/*
  always @ (PADDR or ReadRegs )
    begin : p_ReadMuxComb
      // Determine the next value of nextPRDATA
      case (PADDR[11:8]) 
        `EGAPBSLVREG  : nextPRDATA = ReadRegs  ;             
     //   `EASPA       : nextPRDATA = ReadIDs;
        //default      : nextPRDATA = {32{1'b0}};  // Read as zero default
        default      : nextPRDATA = ReadRegs;  // Read as zero default
      endcase
    end
*/

always @ (PADDR or ReadRegs )
begin : p_ReadMuxComb
    nextPRDATA = ReadRegs;  // Read as zero default
end


always @ (PADDR or R0 or R1 or R2 or R3)
begin : p_RdRegMuxComb

    // Determine the next value of ReadRegs0
    //case (PADDR[7:2])ver1.1
    case (PADDR[3:2]) 
       
        //synopsys parallel_case
        `ADDRREG0 : ReadRegs  = R0;
        `ADDRREG1 : ReadRegs  = {24'd0, R1        };
        `ADDRREG2 : ReadRegs  = {29'd0, R2        };
        `ADDRREG3 : ReadRegs  = R3;
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
        iPRDATA <= {32{1'b0}};
    else
        if (CL_Bit)
            iPRDATA <= {32{1'b0}};
        else if (ReadRegEn)
            iPRDATA <= nextPRDATA[31:0]; 
end
 
// Drive output f?:UEDS:&aring;?:UEDS:&Agrave;rom internal register
//assign PRDATA = {16'd0, iPRDATA};  ver1.1

assign PRDATA = (PSEL) ? iPRDATA:32'd0;

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
//Common Prescaler Ver1.1
//

/*
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
*/

always @(posedge PCLK or negedge PRESETn)
begin
    if ((!PRESETn))
        Prescale_Cnt <= {10{1'b0}};
    else begin
        if(CL_Bit) // ver 1.3
            Prescale_Cnt <= {10{1'b0}};
	    else if(R1 == 10'd0 || !TEN ) // When R1==10'd0 , bypassing the clock
            Prescale_Cnt <= {10{1'b0}};
	    else
	    begin
	        if((Prescale_Cnt == R1))
                Prescale_Cnt <= {10{1'b0}};
            else
	   	        Prescale_Cnt <= Prescale_Cnt + 10'd1;
	    end
     end
end


wire	FLAG_PREC = (Prescale_Cnt == 10'd0) ? ((TEN) ? 1'b1:1'b0):1'b0;


//Timers0 Ver1.1
/*
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
*/


                                             
//==============================================================================
// R2:Timer Control Register[0x01FF_8408]    
// TCONx[7:0]:0x00
// Mode[2]|CL[1]|TEN[0]
//==============================================================================                    
  
assign TEN      = R2[0]     ;
assign CL_Bit   = R2[1]     ;
assign Mode      = R2[2]   ;

  
// Ver. 1.1

wire	FLAG_TIMER;

//ver 1.1 
// define the signal to use bypass clock 
assign 	FLAG_TIMER = FLAG_PREC; //Ver1.2
			    	

//assign PRESETn = (SCANENABLE )? PRESETn : ( PRESETn & (~CL_Bit) )            ; Ver 1.1
//assign PRESETn = ( PRESETn & (~CL_Bit) )            ; //Ver 1.1

//Ver 1.3 remove gated reset


//---------------------------------------------------------------------------------------
// 16-Bit Timer Counter
//---------------------------------------------------------------------------------------
//Timers 0


//always @ (posedge Timers_CLK or negedge PRESETn) 
always @ (posedge PCLK or negedge PRESETn)
/*
    begin : p_Timers_Count //4
     if ((!PRESETn))
      Timer_Cnt <= {16{1'b0}};
      else
      begin //3
        if (~TEN) 
           Timer_Cnt <= {16{1'b0}}; 
        else
        begin //2
           if (OMS == `OMSCode0  ) begin  //Internal Mode
             if (Timer_Cnt == TDAT_Value-1  )
               Timer_Cnt <=  {16{1'b0}}; 
             else  Timer_Cnt <= Timer_Cnt + 1 ;
           end
           else if (OMS == `OMSCode2  ) begin//1
             if (Timer_Cnt == TPWM-1)  
               Timer_Cnt <= {16{1'b0}}    ;
             else Timer_Cnt <= Timer_Cnt + 1 ;
           end
           else  begin
             Timer_Cnt <= Timer_Cnt + 1  ;                   
           end
        end //2
       end //3
      end //4
*/ //Ver 1.1

begin : p_Timers_Count //4

    if ((!PRESETn))
        Timer_Cnt <= 32'h00000000;
    else
    begin //3
        if (CL_Bit)
            Timer_Cnt <= {32{1'b0}};
        else if (~TEN) 
            Timer_Cnt <= {32{1'b0}}; 
        else if(FLAG_TIMER && TEN)
        begin //2
            if (Mode == `OMSCode0  ) begin  //Internal Mode
                //if (Timer_Cnt == TDAT_Value-1  ) Ver1.1
                if (Timer_Cnt == TDAT_Value)
                    Timer_Cnt <=  {32{1'b0}}; 
                else  Timer_Cnt <= Timer_Cnt + 1 ;
            end
            else  begin
                Timer_Cnt <= Timer_Cnt + 1  ;                   
            end
        end //2
    end //3
end //4


// Ver1.1
always @(posedge PCLK or negedge PRESETn)
begin : p_Timer_Match_Gen
    if ((!PRESETn)) 
        Timer_Match_Set <= 1'b0 ; 
    else begin
        if(CL_Bit)
            Timer_Match_Set <= 1'b0 ; 
        //if ( Timer_Cnt == TDAT_Value - 2 ) 
        if ( Timer_Cnt == TDAT_Value ) 
            Timer_Match_Set <= 1'b1 ;
        else
            Timer_Match_Set <= 1'b0 ;                         
    end
end       

//Timers 0~7                                              
assign INT_TMC     = (Prescale_Cnt == 9'd0 ) ? Timer_Match_Set : 1'b0 ;    //Ver 1.2

//----------------------------------------------------------
// Time Out
//----------------------------------------------------------
/*
always @(posedge Timers_CLK or negedge PRESETn)
begin : p_Interval
         if ((!PRESETn))
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
*/ //ver 1.1
       
always @(posedge PCLK or negedge PRESETn)
begin : p_Interval
    if ((!PRESETn))
        Timer_Out <= 1'b0 ;
    else 
    begin 
        if(CL_Bit)
            Timer_Out <= 1'b0 ;
        else if(FLAG_TIMER)
        begin
            if (Timer_Match_Set)
               Timer_Out <=  Timer_Out + 1 ;   
	    end
    end              
end 

endmodule

//================================= End ===================================--

