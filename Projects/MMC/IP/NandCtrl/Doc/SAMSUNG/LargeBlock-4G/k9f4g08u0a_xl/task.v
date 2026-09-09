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
	    #20
		ceb = 0; web = 1; cle = 0; ale = 0;
	    #10
		cle = 1;
		web = 0;
		io  = cmd;
	    #26
		web = 1;
	    #11
		io  = 8'hzz;
	    #6
		cle = 0;
            #40
               ceb = 1;
	end
endtask


/*
// Address Latch Cycle
task	add_latch;
	input [7:0] add;

	begin
            ceb = 0;
	    #20
		cle = 0; ale = 1;
		#1
		web = 0;
	    #5
		io  = add;
  		#22
		web = 1;
		#11
		io  = 8'hzz;
	    #6
		ale = 0; ceb = 0;
	end
endtask
*/

task	add_latch;
	input [7:0] add;

	begin
            ceb = 0;
	    #20
		cle = 0; ale = 1;
//		#1
		web = 0;
	    #3
		io  = add;
  		#12
		web = 1;
		#11
		ale = 0; ceb = 0;
	    #50
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
	    	   #20
			ceb = 0;
	    	   #1
			web = 0;
	    	   #5
			io  = data + i;
	    	   #12
			web = 1;
		   #11
			io  = 8'hzz;
		end
	end
endtask


/*
// Serial Read Cycle
task	serial_read;
	input  [15:0]	cnt;

	begin
		ceb = 0; cle = 0; ale = 0; web = 1;
	    	for ( i=0; i < cnt; i = i+1) 
		begin
		   #13
			reb = 0;
	    	   #12
			reb = 1;
		end
	end
endtask
*/

task	serial_read;
	input  [15:0]	cnt;

	begin
		ceb = 0; cle = 0; ale = 0; web = 1;
	    	for ( i=0; i < cnt; i = i+1) 
		begin
		   #5
			reb = 0;
	    	   #35
			reb = 1;
		   #35;
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
                   #26
			ceb = 0;
                   #56
			ceb = 1;
                end
        end
endtask

task	status;
begin
	cmd_latch(8'h70);    // Status Check Command
        ceb = 1'b0;
        #18;
    serial_read(16'h1);
        ceb = 1'b1;
        #1000;
end
endtask

task	chip_status;
	input chip;
begin
	if (chip == 1'b0)
	begin
    cmd_latch(8'hf1);    // chip1 Status Check Command
        ceb = 1'b0;
        #18;
    serial_read(16'h1);
        ceb = 1'b1;
        #1000;
	end

	else if (chip == 1'b1)
	begin
    cmd_latch(8'hf2);    // chip2 Status Check Command
        ceb = 1'b0;
        #18;
    serial_read(16'h1);
        ceb = 1'b1;
        #1000;
	end

end
endtask
