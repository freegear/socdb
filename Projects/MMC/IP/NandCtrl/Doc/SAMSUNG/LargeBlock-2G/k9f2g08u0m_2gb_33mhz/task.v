//*****************************************************************************
//  K9F1G08U0M, 1Gbit(x8) 1st Generation NAND FLASH TIMING VECTOR
//  Programmed By NAND Flash Memory Design Team, Samsung Semiconductor Co. LTD.
//  Task Definitions
//  Rev. 0.0 -- D.H.Chae -- Aug 8, 2001
//*****************************************************************************

// Command Latch Cycle
task	cmd_latch;
	input [7:0] cmd;

	begin
            #5
		web = 1; cle = 0; ale = 0;
		ceb = 0;
            #5
		web = 0;
		cle = 1;
	    #5 
		io  = cmd;
	    #10
		web = 1;
	    #5 
		io  = 8'hzz;
		cle = 0;
                ceb = 1;
	end
endtask



// Address Latch Cycle
task	add_latch;
	input [7:0] add;

	begin
                ceb = 0;
	    #10
		cle = 0; 
		web = 0;
		ale = 1;
	    #5
		io  = add;
            #10		
		web = 1;
            #5		
		ale = 0; ceb = 0;
		io  = 8'hzz;
	end
endtask

// Data Latch Cycle
task	data_latch;
	input [15:0] cnt;
	input [7:0] data;

	begin
		for (i=0; i < cnt; i=i+1)
		begin
	    	   #10
			ceb = 0;
			web = 0;
	    	   #5
			io  = data + i;
	    	   #10
			web = 1;
		   #5  
			io  = 8'hzz;
		end
	end
endtask


// Serial Read Cycle
task	serial_read;
	input  [15:0]	cnt;

	begin
		ceb = 0; cle = 0; ale = 0; web = 1;
	    	for ( i=0; i < cnt; i = i+1) 
		begin
		   #15;
			reb = 0;
		   #15;
			reb = 1;
		end
	end
endtask

// Serial Read Cycle (/CE Toggle)
task    serial_read1;
        input  [15:0]   cnt1;

        begin
                cle = 0; ale = 0; web = 1; ceb = 1;
		   #1
			reb = 0;
                for ( i=0; i < cnt1; i = i+1)
                begin
		   #14;
			ceb = 0;
		   #15;
			ceb = 1;
                end
        end
endtask
