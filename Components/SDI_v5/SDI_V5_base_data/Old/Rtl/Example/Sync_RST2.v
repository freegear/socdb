`timescale 1ns/1ps
module Sync_RST2
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

//Flag_Neg_Det_1d Priority

always @ (posedge PCLK or negedge PRESETn)
begin : p_R0_Flag2
   if ((!PRESETn))
        Reg0    <= 1'b0 ;
        else 
        if (Flag_Neg_Det_1d) 
             Reg0  <= 1'b1   ;
         else 
         if (STC_Pulse)  
             Reg0  <= 1'b0 ;
              end

/*always @ (posedge PCLK or negedge PRESETn)
begin : p_R0_Flag2
   if ((!PRESETn))
        Reg0    <= 1'b0 ;
        else begin
        if (Flag_Neg_Det_1d) 
             Reg0  <= 1'b1   ;
         else begin
         if (STC_Pulse) begin 
             Reg0  <= 1'b0 ;
          end 
            end
             end
              end
*/                            
  endmodule           