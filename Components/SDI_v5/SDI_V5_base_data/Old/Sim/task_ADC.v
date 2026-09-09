//1us = 1000    ns
//1ms = 1000000 ns
//#(`PHASETIME*10); 
// `define PERIOD 400  //   2.5 Mhz
//  `define PHASETIME (`PERIOD / 2)
//  `define PERIOD 40   //  25.0 MHz

task Init_task ;
begin
STBY      = 1'b1         ;
STC       = 1'b0         ;
ASEL      = 3'b00        ;
AIN       = 8'dz         ;
#(`PERIOD/4 )            ;
STBY      = 1'b0         ;
#(`PERIOD + `PERIOD/2)   ;
end 
 endtask 
		

task  Sel_AIN_Push ;
input [10:0] writedata ;
begin
ASEL      = writedata[10:8] ;
AIN       = writedata[7:0]  ;
 end
 endtask			
 
task  STC_Push	    ;
input [7:0] writedata   ;
integer i ;
begin
 for(i = 0; i < writedata ; i = i + 1 )
begin

STC	= 1'b1	;
#(`PERIOD*4);
STC     = 1'b0 ;
#(`PERIOD);
end
 end
 endtask				
				
