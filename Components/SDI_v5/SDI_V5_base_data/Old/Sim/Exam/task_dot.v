task INIT ;

begin
RSTB    = 0 ;
PS      = 1 ;
C80     = 1 ;
CSB     = 1 ;
A0      = 0 ;
RDB_E   = 0 ;
WRB_RW  = 0 ;
dbin    = 0 ;
IC_TEST = 0 ;
#5000
RSTB    = 1 ;
#5000       ;
end 
 endtask 
 
 task ComandWrite68 ;
    input [15:0] WriteData ;
    begin
CSB=0;
dbouten = 0;
A0=1'b0;
WRB_RW=1'b0;
//Command
dbin[15:0] = WriteData ;

RDB_E=1'b0;
#50
RDB_E=1'b1;
#50
RDB_E=1'b0;
#50
A0         =1'b1;
   end
    endtask
    

task  ParameterWR1 ;
input [15:0] WriteData ;
 begin
 
//Parameter
dbin[15:0] = WriteData;
RDB_E      =1'b0;
#50
RDB_E      =1'b1;
#50
RDB_E      =1'b0;
#50
CSB=1;
#50;    
end 
 endtask           
   
task ParameterWR2 ;
input [15:0] WriteData ;
 begin
 // 2nd Parameter    
A0         = 1'b1      ;
dbin[15:0] = WriteData ;
RDB_E      = 1'b0      ;
#50
RDB_E      = 1'b1      ;
#50
RDB_E      = 1'b0      ;
#50
CSB        = 1          ;
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
                 	RDB_E=1'b0;
                 	#50
                 	RDB_E=1'b1;
                 	#50
                 	RDB_E=1'b0;
		 	#50;
			end
		end
		CSB=1;
		#50;
		end
          endtask

