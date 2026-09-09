`timescale 1ns/1ps
module Sync_RST1
  (
   PCLK            ,
   PRESETn         ,
   Flag_Neg_Det_1d ,
   STC_Pulse       ,
   Reg0
    );

input   PCLK            ;
input   PRESETn         ;  
input   Flag_Neg_Det_1d ;
input   STC_Pulse       ;
output  Reg0            ;

reg     Reg0            ;

always @ (posedge PCLK or negedge PRESETn)
begin : p_R0_Flag2
   if ((!PRESETn))
        Reg0    <= 1'b1 ;
        else begin
        if (Flag_Neg_Det_1d) begin 
             Reg0  <= 1'b1   ;
              end 
         if (STC_Pulse) begin  //STC_PulSe Priority 0
             Reg0  <= 1'b0 ;
          end 
            end
             end
      
endmodule         
             