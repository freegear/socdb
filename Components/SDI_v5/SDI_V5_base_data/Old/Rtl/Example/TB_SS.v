
`timescale 1ns/1ps

// Top level - no I/O
module TB_SS ();

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
//  `define PERIOD 40   //  25.0 MHz
`define PERIOD 40  //   25 Mhz
`define PHASETIME (`PERIOD / 2)
    
reg   PCLK            ;
reg   PRESETn         ;  
reg   Flag_Neg_Det_1d ;
reg   STC_Pulse       ;
wire  Reg0            ;
`include "./task_SS.v" 
 Sync_RST2 RTS2
  (
   PCLK            ,
   PRESETn         ,
   Flag_Neg_Det_1d ,
   STC_Pulse       ,
   Reg0
    );

/* Sync_RST1 RTS1
  (
   PCLK            ,
   PRESETn         ,
   Flag_Neg_Det_1d ,
   STC_Pulse       ,
   Reg0
    );
*/    
//External Stimulus
initial begin
//Diff_LOC ; 
Same_Loc ;
end 

     
always 
    begin : p_ClockGenComb
      PCLK <= 1'b0;
      #`PHASETIME;
      PCLK <= 1'b1;
      #`PHASETIME;
    end
 
 endmodule  