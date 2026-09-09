// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : adc_LTR9200.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose            : 8-Channel/10-bit A/D - Converter verilog Model
//                        
//  --========================================================================--

`timescale 1ns/1ps
module adc_LTR9200
(
  SHDN    ,
  AIN     ,
  AD_CLK  ,
  ASEL    ,
  SOC     ,

  EOC     ,
  DOUT	

);

parameter  Cycle_Time  = 16  ; //Conversion Cyclic Time Number
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


input                 SHDN      ; //Power Save
input  [AIN_Bit-1:0]  AIN       ; //Analog Input
input	              AD_CLK      ; //CLKIN DI
input  [Ch_Sel-1:0]   ASEL      ; //Channel Select DI
input                 SOC       ; //Start of Conversion signal

output                EOC       ; //End of Conversion Singal
output [DOU_Bit-1:0]  DOUT      ; //Digital output

wire   [AIN_Bit-1:0]  AIN       ;
wire                  AD_CLK    ;
wire   [Ch_Sel-1:0]   ASEL      ;
wire                  EOC       ;
wire                  SHDN      ;
wire                  SOC       ;

reg    [DOU_Bit-1:0]  DOUT    ;
reg   [DOU_Bit-1:0]   AD_O_nude ; 

//reg                   SHDN_1d   ;
//reg                   SHDN_Rst  ;
     


reg [Cycle_Time-3:0] Conv_Cnt ;


//Power Reset
/*always @ (negedge AD_CLK )
  begin : p_Cnt_init
    begin
    SHDN_1d  <= SHDN  ;
    SHDN_Rst = 1'b1 ;
    if ((SHDN_1d )& (~SHDN))
          SHDN_Rst <= 1'b0 ;
     else SHDN_Rst <= 1'b1 ;
     end 
       end
*/     
      

//TSMC 
/*
always @ (negedge AD_CLK or negedge SHDN_Rst)
    begin : p_Conv_Cnt
      if ((!SHDN_Rst))
        Conv_Cnt   <= 0;
        else begin
        if (SHDN)
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
always @(negedge AD_CLK or posedge SHDN)
    begin : p_Conv_Cnt
      if ((SHDN))
        Conv_Cnt   <= 0;
        else begin
        //if (SOC) begin
        if (!SOC) begin
      if (Conv_Cnt == Cycle_Time - 1 )
            Conv_Cnt <= 0 ;
       else Conv_Cnt <= Conv_Cnt + 1 ; 
          end 
          
          else Conv_Cnt <= 0 ;
           end   
            end


      
 always @(ASEL or AIN)
  begin :p_Channel_Sel
   case (ASEL[Ch_Sel-1:0])
      `AINS0    : begin 
       AD_O_nude = A0       ;
     
                  end
                  
      `AINS1    : begin
       AD_O_nude = A1       ;
      
                  end
                  
      `AINS2    : begin
       AD_O_nude = A2       ;
      
                  end
                  
      `AINS3    : begin
       AD_O_nude = A3       ;
      
                  end
                  
      `AINS4    : begin 
       AD_O_nude = A4       ;
      
                  end
                  
      `AINS5    : begin
       AD_O_nude = A5       ;
       
                  end
                  
      `AINS6    : begin
       AD_O_nude = A6       ;
        
                  end
                  
      `AINS7    : begin
       AD_O_nude = A7       ;
       
                  end
                  
       default  : begin
       AD_O_nude = A_hiz    ;
        
                  end                                       
          endcase 
           end
//assign #(`Output_Delay) EOC   = (Conv_Cnt == Cycle_Time - 1 & AD_CLK)?  1'b1 :  1'b0 ;

assign #(`Output_Delay) EOC   = 
          (Conv_Cnt == Cycle_Time - 1)?  1'b1 :  1'b0 ;


//reg EOC_S ;

//initial begin
//EOC_S = #5 EOC ;
//end

always @(EOC or AD_O_nude)
  begin
  if (EOC) begin
   DOUT =  AD_O_nude ;
     end 
      end

always @(SOC) begin
    if (SOC)            
         $display("AD Conversion Processing");
    else $display("AD Conversion Finish or Initial");
         end
//assign  fosc = en & clock;
//always begin
//        #50000 clock=1;     
//        #50000 clock=0;  
//end

endmodule
