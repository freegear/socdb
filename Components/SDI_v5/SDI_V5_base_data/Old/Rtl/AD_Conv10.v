// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : AD_Conv10.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose            : 8-Channel/10-bit A/D - Converter verilog Model
//                        
//  --========================================================================--

`timescale 1ns/1ps
module AD_Conv10
(
STBY    ,
AIN     ,
AD_CLK  ,
ASEL    ,
STC     ,

EOC     ,
AD_OUT	
);

parameter  Cycle_Time  = 5   ; //Conversion Cyclic Time Number
parameter  AIN_Bit     = 8   ; //Analog Input Number
parameter  DOU_Bit     = 10  ; //Digital Output Number
parameter  Ch_Sel      = 3   ;
//Virtual Digital Output
parameter  A0          = 10'd0 ,
           A1          = 10'd1 ,
           A2          = 10'd2 ,
           A3          = 10'd3 ,
           A4          = 10'd4 ,
           
           A5          = 10'd5 ,
           A6          = 10'd6 ,
           A7          = 10'd7 ,         
           A_hiz       = 10'bzz_zzzz_zzzz ;


//Output_Delay parameter
`define  Output_Delay  25
//Analog Relative value
`define  AINS0        3'd0
`define  AINS1        3'd1
`define  AINS2        3'd2
`define  AINS3        3'd3
`define  AINS4        3'd4
`define  AINS5        3'd5
`define  AINS6        3'd6
`define  AINS7        3'd7


input                 STBY      ; //Power Save
input  [AIN_Bit-1:0]  AIN       ; //Analog Input
input	              AD_CLK    ; //CLKIN DI
input  [Ch_Sel-1:0]   ASEL      ; //Channel Select DI
input                 STC       ; //Start of Conversion signal

output                EOC       ; //End of Conversion Singal
output [DOU_Bit-1:0]  AD_OUT    ; //Digital output

wire   [AIN_Bit-1:0]  AIN       ;
wire                  AD_CLK    ;
wire   [Ch_Sel-1:0]   ASEL      ;
wire                  EOC       ;
wire                  STBY      ;
wire                  STC       ;

reg    [DOU_Bit-1:0]  AD_OUT    ;
reg   [DOU_Bit-1:0]   AD_O_nude ; 

//reg                   STBY_1d   ;
//reg                   STBY_Rst  ;
     


reg [Cycle_Time-3:0] Conv_Cnt ;


//Power Reset
/*always @ (negedge AD_CLK )
  begin : p_Cnt_init
    begin
    STBY_1d  <= STBY  ;
    STBY_Rst = 1'b1 ;
    if ((STBY_1d )& (~STBY))
          STBY_Rst <= 1'b0 ;
     else STBY_Rst <= 1'b1 ;
     end 
       end
*/     
      

//TSMC 
/*
always @ (negedge AD_CLK or negedge STBY_Rst)
    begin : p_Conv_Cnt
      if ((!STBY_Rst))
        Conv_Cnt   <= 0;
        else begin
        if (STBY)
          Conv_Cnt <= 0 ;
      else begin
      if (Conv_Cnt == Cycle_Time - 1 )
            Conv_Cnt <= 0 ;
       else Conv_Cnt <= Conv_Cnt + 1 ; 
         
          end   
           end
            end
*/ 
 
//SAMSUNG 
always @(negedge AD_CLK or posedge STBY)
    begin : p_Conv_Cnt
      if ((STBY))
        Conv_Cnt   <= 0;
        else begin
        if (STC) begin
      if (Conv_Cnt == Cycle_Time - 1 )
            Conv_Cnt <= 0 ;
       else Conv_Cnt <= Conv_Cnt + 1 ; 
          end 
          
          else Conv_Cnt <= 0 ;
           end   
            end


      
 always @(ASEL or AIN or STBY)
  begin :p_Channel_Sel
  if (~STBY) begin
   case (ASEL[Ch_Sel-1:0])
      `AINS0    : AD_O_nude = A0       ;
      `AINS1    : AD_O_nude = A1       ;
      `AINS2    : AD_O_nude = A2       ;
      `AINS3    : AD_O_nude = A3       ;
      `AINS4    : AD_O_nude = A4       ;
      `AINS5    : AD_O_nude = A5       ;
      `AINS6    : AD_O_nude = A6       ;
      `AINS7    : AD_O_nude = A7       ;
       default  : AD_O_nude = A_hiz    ;
        endcase 
           end else
                  AD_O_nude = A_hiz    ;   
                 end
                 
assign #(`Output_Delay) EOC   = (Conv_Cnt == Cycle_Time - 1 & AD_CLK & (~STBY))?  1'b1 :  1'b0 ;


always @(EOC or AD_O_nude or STBY)
  begin
  if (EOC & (~STBY)) begin
   AD_OUT =  AD_O_nude ;
     end 
      end

always @(STC or STBY) begin
   
   if (STBY) begin
        $display("A/D Converter Power Check!!");
        end 
        else  begin
    if (STC)            
         $display("A/D Conversion Processing");
    else $display("A/D Conversion Finished or Not Yet");
         end
           end
//assign  fosc = en & clock;
//always begin
//        #50000 clock=1;     
//        #50000 clock=0;  
//end

endmodule