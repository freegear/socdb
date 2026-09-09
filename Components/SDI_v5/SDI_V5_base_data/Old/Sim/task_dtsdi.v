//1us = 1000    ns
//1ms = 1000000 ns
//#(`PHASETIME*10); 
task INIT ;
integer i ;
begin
TEST_MODE = 1'b0  ;
EINT      = 8'b0  ;
POCLK     = 1'b0  ; 
EINT      = 8'd0  ;
AIN       = 8'bzzzz_zzzz  ;
TCAP      = 8'h00 ;
BOOT_MODE = 1'b0  ;

GPAD_En0  = 1'b0  ;
//GPAD_En1  = 1'b1  ;
GPAD_En1[7] = 1'b1 ;
GPAD_En1[6] = 1'b0 ;
GPAD_En1[5] = 1'b1 ;
GPAD_En1[4] = 1'b0 ;
GPAD_En1[3] = 1'b1 ;
GPAD_En1[2] = 1'b0 ;
GPAD_En1[1] = 1'b1 ;
GPAD_En1[0] = 1'b0 ;


 
GPAD_En2  = 1'b0  ;
GPAD_En3  = 1'b1  ;

GPADatain0 = 8'h00 ;
GPADatain1 = 8'h00 ;
GPADatain2 = 8'h00 ;
GPADatain3 = 8'h00 ;

SMDATAIN  = 32'd0 ;    // Data from Memory to SMC   
#(`PERIOD )       ;        
end 
 endtask 

task    EINT_push	;
input [7:0] writedata   ;
begin
EINT	= writedata	;
#(`PERIOD*1000);
end
 endtask
		
task  AIN_Push          ;
input [7:0] writedata   ;
begin
AIN   = writedata[7:0]  ;
#(`PERIOD*60);
 end
 endtask	


//Input
/*task Gpio_EINT          ;
input [7:0] writedata   ;
begin
GPAD_En0   = 1'b1       ;
GPADatain0 = writedata  ;
#(`PERIOD*50);
//GPAD_En0   = 1'b0       ;
#(`PERIOD*50)           ;      
end
endtask
*/

//Output
task Gpio_EINT          ;
input [7:0] writedata   ;
begin
GPAD_En0   = 1'b0       ;
GPADatain0 = writedata  ;
#(`PERIOD*50);
//GPAD_En0   = 1'b0       ;
#(`PERIOD*50)           ;      
end
endtask


task Gpio_TCAP          ;
input [7:0] writedata   ;
begin
//GPAD_En1   = 1'b1       ;
GPADatain1 = writedata  ;
#(`PERIOD*150);
//GPAD_En1   = 1'b0       ;
#(`PERIOD*150)          ;      
end
endtask


task Gpio_PWM          ;
input [7:0] writedata   ;
begin
GPAD_En2   = 1'b0       ;
GPADatain2 = writedata  ;
#(`PERIOD*250);
//GPAD_En2   = 1'b0       ;
#(`PERIOD*250)          ;      
end
endtask

task Gpio_UART          ;
input [7:0] writedata   ;
begin
GPAD_En3   = 1'b1       ;
GPADatain3 = writedata  ;
#(`PERIOD*350);
//GPAD_En3   = 1'b0       ;
#(`PERIOD*350)          ;      
end
endtask




     