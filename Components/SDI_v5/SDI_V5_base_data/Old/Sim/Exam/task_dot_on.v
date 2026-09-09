task INIT ;
begin
ps                  = 1'b1  ;
c80                 = 1'b1  ;
csb                 = 1'b1  ;
dbouten             = 1'b1  ;
a0                  = 1'b1  ;
wrb                 = 1'b1  ;
rdb                 = 1'b1  ;

//Dot
IC_Test_Mode        = 1'd0  ;
Test_Se             = 1'd0  ;
Scan_in             = 1'd0  ;
Test_Clock          = 1'd0  ;
//OSACLK              = 1'd0  ;
rstb                = 1'd0  ;
soft_rst            = 1'd1  ;

displayonoff        = 1'd0  ;
displaystandbyonoff = 1'd1  ;
framerate           = 3'd2  ;
RFLAG               = 1'd1  ;

displaydirection    = 2'd0  ;

displaysizexstart   = 7'h0  ;
displaysizexend     = 7'h5F ;
displaysizeystart   = 7'h0  ;
displaysizeyend     = 7'h5F ;

memreadcolumnstart  = 7'd0  ;
memreadrowstart     = 7'd0  ;
                       
datamask            = 4'd7  ;
                       
peakpulsewidthred   = 5'd5  ;
peakpulsewidthgreen = 5'd5  ;
peakpulsewidthblue  = 5'd5  ;
peakpulsedelay      = 4'd5  ;
                      
currentlevelred     = 8'd0  ;
currentlevelgreen   = 8'd0  ;
currentlevelblue    = 8'd0  ;
                    
prechargewidth      = 8'h08 ;
preselect           = 2'd2  ;
                     
rowoverlap          = 2'd0  ;
rowscan             = 1'd0  ;
rowscansequence     = 2'd0  ;
                      
screensleeptimer    = 0     ;
screensleepstart    = 0     ;
screensteptimer     = 0     ;
screenstepunit      = 0     ;
screenboxxstart     = 0     ;
screenboxxend       = 0     ;
screenboxystart     = 0     ;
screenboxyend       = 0     ;
screenstepvaluex    = 0     ;
screenstepvaluey    = 0     ;
screencondition     = 0     ;
screenstartstop     = 0     ;
screensaverselect   = 0     ;
screencolorstage    = 0     ;
screencolorpallet0  = 0     ;
screencolorpallet1  = 0     ;
screencolorpallet2  = 0     ;
screencolorpallet3  = 0     ;
screencolorpallet4  = 0     ;
screencolorpallet5  = 0     ;
screencolorpallet6  = 0     ;
screencolorpallet7  = 0     ;  
#5000
rstb    = 1 ;
#5000       ;
end 
 endtask 



 
task Disp_ONOFF ; 
input  WriteData ;
 begin
displayonoff        = WriteData  ;
  end
   endtask 

task Disp_Standby ; 
input  WriteData ;   
 begin
displaystandbyonoff = WriteData   ;
  end 
   endtask 

task Frame_rate ; 
input  [2:0] WriteData ;   
 begin   
framerate           = WriteData  ;
end 
 endtask 


 
task Disp_Xstart ;
input [6:0] WrieData ;
begin
displaysizexstart   = WrieData ;
end
 endtask 

task Disp_Xend ;
input [6:0] WrieData ;
begin 
displaysizexend     = WrieData;
end 
 endtask 

task Disp_Ystart ;
input [6:0] WriteData ;
 begin
displaysizeystart   = WriteData  ;
  end
   endtask 
   
task Disp_Yend ;
input [6:0] WriteData ;
 begin
displaysizeyend     = WriteData ;
 end
  endtask 

task Mem_ReadCol ;
input [6:0] WriteData ;
 begin
memreadcolumnstart  = WriteData  ;
 end
  endtask 
  
task Mem_ReadRow ;
input [6:0] WriteData ;
 begin  
memreadrowstart     = WriteData  ;
 end
  endtask 
  
task Data_Mask ;
input [3:0] WriteData ;
 begin                         
datamask            = WriteData ;
 end
  endtask

task PulseWidth_Red ;
input [4:0] WriteData ;
 begin                                       
peakpulsewidthred   = WriteData  ;
 end 
  endtask 
  
task PulseWidth_Green ;
input [4:0] WriteData ;
 begin                
peakpulsewidthgreen = WriteData  ;
 end
  endtask 

task PulseWidth_Blue ;
input [4:0] WriteData ;
 begin                  
peakpulsewidthblue  = WriteData  ;
 end
  endtask 
  

task Pulse_Delay ;
input [3:0] WriteData ;
 begin                  
peakpulsedelay      = WriteData  ;
 end 
  endtask 
  
task Current_Red ;
input [7:0] WriteData ;
 begin                                       
currentlevelred     = WriteData  ;
 end 
  endtask 

task Current_Green ;
input [7:0] WriteData ;
 begin                     
currentlevelgreen   = WriteData  ;
 end
  endtask 
  
task Current_Blue ;
input [7:0] WriteData ;
 begin                 
currentlevelblue    = WriteData  ;
 end 
  endtask
  
task PreCh_Width ;
input [7:0] WriteData ;
 begin                                     
prechargewidth      = WriteData ;
 end
  endtask 

task PreCh_Sel ;
input [1:0] WriteData ;
 begin               
preselect           = WriteData ;
  end
   endtask 
   
task Row_Overlap ;
input [1:0] WriteData ;
 begin                                    
rowoverlap          = WriteData  ;
 end
  endtask 
  
  
task Row_Sequence ;
input [1:0] WriteData ;
 begin                        
rowscansequence     = WriteData  ;
 end
  endtask 

task Row_Direction ;
input [1:0] WrieData ;
begin
displaydirection    =  WrieData ;
end
 endtask   


task Row_Scan17H ;
input  WrieData ;
begin
displaydirection    =  WrieData ;
end
 endtask   



task Soft_Reset ;
input  WrieData ;
begin
soft_rst    =  WrieData ;
end
 endtask   
 
task ComandWrite68 ;
 input [15:0] WriteData ;
 
begin
csb=0;
dbouten = 0;
a0=1'b0;
wrb=1'b0;
//Command
dbin[15:0] = WriteData ;

rdb=1'b0;
#50
rdb=1'b1;
#50
rdb=1'b0;
#50
a0         =1'b1;
   end
    endtask

task  ParameterWR1 ;
input [15:0] WriteData ;
 begin
 
//Parameter
dbin[15:0] = WriteData;
rdb      =1'b0;
#50
rdb      =1'b1;
#50
rdb      =1'b0;
#50
csb      =1;
#50;    
end 
 endtask           
     

   
task MemWR ;
integer i ;
integer j ;
//input [15:0] WriteData ;
begin
		for(j = 0; j < 96; j = j + 1 )
		begin
		 for(i = 0; i < 96 ; i = i + 1 )
		 begin
		 //******* data insert ********
		 //dbin[15:11] = dbin[15:11] + 1 ;	        //red
		 //dbin[10:5]  = dbin[10:5]  + 1 ;		//green 
		 //dbin[4:0]   = dbin[4:0]   + 1 ;		//blue  
		 
		// dbin[15:11] = dbin[15:11] + 1 ;	        //red
		// dbin[10:5]  = 6'h3F           ;		//green //44h(03h:Selective Data Test)
		// dbin[4:0]   = dbin[4:0]   + 1 ;		//blue  
		 	
		  dbin = dbin + 1 ; //Normal
		  //dbin[15:8] = 8'h00        ; //8Bit Mode
		  //dbin[7:0] = dbin[7:0] + 1 ; //8Bit Mode(0Dh) 
                 //******* data insert end ********
                 	rdb =1'b0;
                 	#50
                 	rdb=1'b1;
                 	#50
                 	rdb=1'b0;
		 	#50;
			end
		end
		csb=1;
		#50;
		end
          endtask