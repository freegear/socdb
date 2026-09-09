
`timescale 1ns/1ps

// Top level - no I/O
module TB_AD_Conv ();

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
//  `define PERIOD 40   //  25.0 MHz
`define PERIOD 400  //   2.5 Mhz
`define PHASETIME (`PERIOD / 2)
    
reg        STBY   ;
reg  [7:0] AIN    ;
reg        AD_CLK ;
reg  [2:0] ASEL   ;
reg        STC    ;

wire       EOC    ;
wire [9:0] AD_OUT ;

`include "./task_ADC.v" 
AD_Conv10 AD_Conv10
(
.STBY    ,//(STBY   ),
.AIN     ,//(AIN    ),
.AD_CLK  ,//(AD_CLK ),
.ASEL    ,//(ASEL   ),
.STC     ,//(STC    ),
         //
.EOC    , //(EOC    ),
.AD_OUT	 //(AD_OUT )       
);
    
/*  if (StringLength > 0)
        begin
          Display(Outfile, TubeString, StringLength);
        end
        $display("TUBE: Program exit");
        $finish;
      end    
*/     
//External Stimulus
initial begin
Init_task                ;
Sel_AIN_Push (11'b000_zzzz_zzz1);
STC_Push(8'd1) ;
Sel_AIN_Push (11'b001_zzzz_zz1z);
STC_Push(8'd2) ;
/*Sel_AIN_Push (11'b000_zzzz_zzz1); //10bit:SEL:AIN
Sel_AIN_Push (11'b001_zzzz_zz1z); //10bit:SEL:AIN
Sel_AIN_Push (11'b010_zzzz_z1zz); //10bit:SEL:AIN
Sel_AIN_Push (11'b011_zzzz_1zzz); //10bit:SEL:AIN
Sel_AIN_Push (11'b100_zzz1_zzzz); //10bit:SEL:AIN
*/
end     
     
always 
    begin : p_ClockGenComb
      AD_CLK <= 1'b0;
      #`PHASETIME;
      AD_CLK <= 1'b1;
      #`PHASETIME;
    end
 
 endmodule  