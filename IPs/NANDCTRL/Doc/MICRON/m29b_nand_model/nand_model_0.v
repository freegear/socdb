/*******************************************************************************
*
*    File Name:  nand_model.V
*        Model:  BUS Functional
*    Simulator:  ModelSim

* Dependencies:  parameters.v
*
*        Email:  modelsupport@micron.com
*      Company:  Micron Technology, Inc.
*  Part Number:  MT29F
*
*  Description:  Micron NAND Verilog Model
*
*   Limitation:
*
*         Note:
*
*   Disclaimer:  THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY
*                WHATSOEVER AND MICRON SPECIFICALLY DISCLAIMS ANY
*                IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR
*                A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
*
*                Copyright © 2005 Micron Semiconductor Products, Inc.
*                All rights researved
*
* Rev  Author          Date        Changes
* ---  --------------- ----------  -------------------------------
* 1.0  SH              02/12/2004  - Initial release
*
* 1.1  NB              06/21/2004  - Changed read so returns 'z' when
*                                    address exceeds 2112 in page mode
* 2.0  dritz           01/25/2005  - Major overhaul.  All latch tasks new
* 2.1  dritz           03/28/2005  - added 70->00-> feature from page_read
* 2.2  dritz           09/21/2005  - Fixed to accept 70 during FF
*                                    Internal ready busy now tracked
*                                    Model now releases bus when ce_n = 1. 
* 2.3  dritz           12/06/2005  - Bugfix 80-85-85-10 did not reset col_addr.
*                                    Added wrapper for dual die support (two Ce_n's)
* 2.4  smk             09/05/2006  - Fixed Preload bug, now allows status during erase
*******************************************************************************/
`timescale 1ns / 1ns

module nand_model_0 (Io, Cle, Ale, Ce_n, We_n, Re_n, Wp_n, Pre, Rb_n);

    `include "parameters.v"

    // Device Parameters
    parameter PAGESIZE  =num_col;

    parameter read_id_byte0     =  8'h2c;   // Micron Manufacturer ID

`ifdef G2
   `ifdef V33     
      `ifdef x8    // 2Gig 3.3V by 8
         parameter read_id_byte1     =  8'hda;
      `endif
      `ifdef x16   // 2Gig 3.3V by 16
         parameter read_id_byte1     =  8'hca;
      `endif
   `else
      `ifdef x8    // 2Gig 1.8V by 8
         parameter read_id_byte1     =  8'haa;
      `endif
      `ifdef x16   // 2Gig 1.8V by 16
         parameter read_id_byte1     =  8'hba;
      `endif
   `endif
`else `ifdef G4
   `ifdef V33     
      `ifdef x8    // 4Gig 3.3V by 8
         parameter read_id_byte1     =  8'hdc;
      `endif
      `ifdef x16   // 4Gig 3.3V by 16
         parameter read_id_byte1     =  8'hcc;
      `endif
   `else
      `ifdef x8    // 4Gig 1.8V by 8
         parameter read_id_byte1     =  8'hac;
      `endif
      `ifdef x16   // 4Gig 1.8V by 16
         parameter read_id_byte1     =  8'hbc;
      `endif
   `endif
`else `ifdef G8
   `ifdef V33     
      `ifdef x8    // 8Gig 3.3V by 8
         parameter read_id_byte1     =  8'hdc;   // this is not intuitive but not a bug, see datasheet note
      `endif
   `endif
`endif `endif `endif

    parameter read_id_byte2     =  8'h69;   // Dont care
    `ifdef x8    
       parameter read_id_byte3     =  8'h15;
    `else `ifdef x16
       parameter read_id_byte3     =  8'h55;
    `endif `endif    

    // Ports Declaration
    inout  [data_bits - 1 : 0] Io;
    input                      Cle;
    input                      Ale;
    input                      Ce_n;
    input                      We_n;
    input                      Re_n;
    input                      Wp_n;
    input                      Pre;
    output                     Rb_n;

    reg                        Rb_n;

    reg                        PowerUp_Complete;

    reg    [data_bits - 1 : 0] Io_buf;
    assign                     Io = Io_buf;

    // Memory Array
    reg [data_bits - 1 : 0] data_reg  [0 : num_col - 1];
    reg [data_bits - 1 : 0] cache_reg [0 : num_col - 1];
    reg [data_bits - 1 : 0] mem_array [0 : (num_col * num_row) - 1];
    reg [data_bits - 1 : 0] special_array [0 : num_col - 1];   //Special array for Read_ID_2 and Read_Unique

    // Command Decode
    reg cmnd_00h, cmnd_05h, cmnd_10h, cmnd_15h, cmnd_30h, cmnd_31h, cmnd_35h, cmnd_3Fh, cmnd_60h;
    reg cmnd_65h, cmnd_70h, cmnd_80h, cmnd_85h, cmnd_90h, cmnd_D0h, cmnd_E0h, cmnd_FFh;
    reg saw_cmnd_65h;    // flag
    reg saw_cmnd_00h;    // flag
    reg do_read_id_2;    // flag
    reg do_read_unique;  // flag
    reg cmnd_31h_first_time;  // flag
    reg intRb_state;
    wire debug = 0;
    wire command_debug = 0;

    // Address Decode
    reg [col_bits - 1 : 0] col_addr;
    reg [row_bits - 1 : 0] row_addr;

    // Read Status (70h)
    reg [data_bits - 1 : 0] status_register;

    // Valid Status
    reg col_valid, row_valid, data_valid, cache_valid;

    // Counter
    reg [12 : 0] col_counter, cache_counter;
    integer addr_start, addr_stop;
    integer delay;
    integer j, k, erablk;

    // Initialization
    initial begin
        PowerUp_Complete = 1'b0;
        // Initialize FLASH MEMORY to all FFs
        for (j = 0; j <= num_row - 1; j = j + 1) begin
        	for (k = 0; k <= num_col - 1; k = k + 1) begin
            		mem_array [(j*num_col)+k] = {data_bits{1'b1}};
        	end
	end
        `ifdef x8
        $readmemh ("data.8.init", mem_array);
        $readmemh ("read_unq.8.init", special_array);
        `else 
        $readmemh ("data.16.init", mem_array);
        $readmemh ("read_unq.16.init", special_array);
        `endif
        status_register [6:0] = 7'b1100000;  // DEFAULT:  ready, ready, 0 0 0, success, success
        `ifdef x16
        status_register [15:8] = 8'h00;  // DEFAULT
        `endif
        if (Wp_n == 1'b1) begin
            status_register [7] = 1'b1;
            end
        Io_buf = {data_bits{1'bz}}; 
        if (debug) $display("Io_buf Trigger 1"); 
        cmnd_reset (1'b0);  // power-on-reset initialization (Hard reset)
        //PowerOn Auto Read
        if (Pre === 1) begin
           if(debug) $display("At time %0t : PO_read starting", $time);
           if (Rb_n === 1'b0) begin
               wait (Rb_n === 1'bz);
           end
           //while (col_counter < num_col) begin
               //if (Re_n === 1) begin    
               //   wait (Re_n === 0);
               //end else if (Re_n === 0) begin
               //    wait (Re_n === 1);
		//   wait (Re_n === 0);
               //end
               //Io_buf <= #({$random} % 3) data_reg [col_addr + col_counter];
               //if (debug) $display("-----------------\nIo_buf Trigger 2"); 
               //if (debug) $display("At time %0t : PO_Data Read col=%d col_ctr=%d element = %h", $time, col_addr, col_counter, data_reg[col_addr + col_counter]);
               //col_counter = col_counter + 1;
           //end
        end 
        //wait (Re_n === 1);
        //Io_buf <= #({$random} % 3) {data_bits{1'bz}};
        if (debug) $display("Io_buf Trigger 3"); 
        PowerUp_Complete = 1'b1;
	col_counter = 0;
	data_valid = 1;
	row_valid = 1;
	col_valid = 1;
        if(debug) $display("At time %0t : PO_read complete", $time);
    end   

    // Clear Data Register
    task clear_data_register;
        reg [col_bits - 1: 0] i;
    begin
        for (i = 0; i <= num_col - 1; i = i + 1) begin
           data_reg [i] = {data_bits {1'b1}};  //clear == F's in flash
        end
    end
    endtask

    // Clear Cache Register
    task clear_cache_register;
        reg [col_bits - 1: 0] i;
    begin
        for (i = 0; i <= num_col - 1; i = i + 1) begin
           cache_reg [i] = {data_bits {1'b1}};
        end
    end
    endtask

    // Load Register
    // 0 = Load data register
    // 1 = Load cache register
    task load_register;
        input Cached;
        reg [col_bits -1 : 0] i;
        reg [col_bits -1 : 0] loadaddr;
    begin
        // Random Delay For RB# (tWB)
        if(debug) $display("ENTRY load_register");
        #tWB_max
        Rb_n = 1'b0;
        intRb_state = 1'b0;
        data_valid = 1'b0;
        status_register [6 : 5] = 2'b00;

        // Read From Memory Array
	if (Cached==0) loadaddr=0;
	if ((Cached==1) && (col_addr==0)) loadaddr=0;
	if ((Cached==1) && (col_addr>0)) loadaddr=col_addr;
        for (i = loadaddr; i <= num_col - 1; i = i + 1) begin
            if(debug) $display("Read mem_array[%d]=%h", (row_addr*num_col)+i, mem_array[(row_addr*num_col)+i]);
            if (~(&mem_array [(row_addr*num_col)+i])) begin  
                case (Cached)
                    1'b0 : begin
			       	//normal read 0 -> 30
                               	data_reg [i] = mem_array [(row_addr*num_col)+i];
                               	if(debug) $display("load_register NON_CACHED i=%d", i);
                           end
                    1'b1 : begin
			       	//read start for data cache 0 -> 30 -> 31
                               	if (cmnd_31h) begin
                                   cache_reg [i] = mem_array [((row_addr+1)*num_col)+i];
                                   if(debug) $display("load_register load cache with NEXT page CACHED-31h i=%d", i);
                               	end else begin		
			       	   //copy back read 0 -> 35
                                   cache_reg [i] = mem_array [(row_addr*num_col)+i];
                                   if(debug) $display("load_register load_register load cache with NEXT page CACHED-OTHER i=%d", i);
                               	end
                           end
                endcase
                if(debug) $display("load_register %d : %d = %h", row_addr, i, data_reg [i]);
            end
        end

        // Delay for RB# (tR)
        if (cmnd_31h || cmnd_3Fh) begin
            if (cmnd_31h_first_time === 1'b1) begin
                delay = (tDCBSYR1_min + ({$random} % (tDCBSYR1_max - tDCBSYR1_min)));
            end else begin
                delay = (tDCBSYR2_min + ({$random} % (tDCBSYR2_max - tDCBSYR2_min)));
            end
        end else if (cmnd_30h || cmnd_35h) begin
                delay = (tDCBSYR2_min + ({$random} % (tDCBSYR2_max - tDCBSYR2_min)));
        end else begin
            if (~cache_valid) begin
                delay = (tDCBSYR1_min + ({$random} % (tDCBSYR1_max - tDCBSYR1_min)));
            end else begin
                delay = (tDCBSYR2_min + ({$random} % (tDCBSYR2_max - tDCBSYR2_min)));
            end
        end

        while (delay) begin
            delay = delay - 1;
            if (Cle && ~We_n && ~Ale && Re_n && ~Ce_n) begin
                if (Io [7 : 0] === 8'h70) begin
                    if(debug) $display ("STATUS READ WHILE BUSY : MODE = STATUS");
                    cmnd_70h = 1'b1;
                end else if (Io [7 : 0] === 8'hFF) begin
                    if(debug) $display ("RESET WHILE BUSY - ABORT");
                    delay = 1'b0;
                    cmnd_FFh = 1'b1;
                end
            end else if (~Re_n && ~Ce_n && We_n && cmnd_70h) begin
                Io_buf = status_register;
            end
            #1;
        end

        Rb_n = 1'bz;
        intRb_state = 1'b1;
        status_register [6 : 5] = 2'b11;
        if (~Re_n && ~Ce_n && We_n && cmnd_70h) begin
            Io_buf = status_register;
        end
        if (cmnd_FFh) begin
            cmnd_reset(1);
        end
    end
    endtask

    // Erase Block
    task erase_block;
    begin
        // Random Delay For RB# (tWB)
        #tWB_max;
        Rb_n = 1'b0;   // Go busy
        intRb_state = 1'b0;
        status_register [6 : 5] = 2'b00;
	
	// Get the block & load FF to the next 64 pages  
	erablk=row_addr/num_page;		// get page 0 of the start block
        if(debug) $display("At time %0t : Erase Block = %0h", $time, erablk);
	//Load FF to the next 64 pages
        for (j = 0; j < num_page; j = j + 1) begin
        	for (k = 0; k <= num_col - 1; k = k + 1) begin
            		mem_array [(((erablk*num_page)+j)*num_col)+k] = {data_bits{1'b1}};
        	end
	end

       // Random Delay for RB# (tBERS)
       delay = (tBERS_min + ({$random} % (tBERS_max - tBERS_min)));
       while (delay) begin 
                    delay = delay - 1;
                    if (Cle && ~We_n && ~Ale && Re_n && ~Ce_n) begin
                        if (Io [7 : 0] === 8'h70) begin
                            if(debug) $display ("STATUS READ WHILE BUSY : MODE = STATUS");
                            cmnd_70h = 1'b1;
                        end else if (Io [7 : 0] === 8'hFF) begin
                            if(debug) $display ("RESET WHILE BUSY - ABORT");
                            delay = 1'b0;
                            cmnd_FFh = 1'b1;
                        end
                    end else if (~Re_n && ~Ce_n && We_n && cmnd_70h) begin
                        Io_buf = status_register;
                    end
                    #1;
                end
          
        Rb_n = 1'bz;   // not busy anymore
        intRb_state = 1'b1;
        cmnd_D0h = 1'b0;
        status_register [6 : 5] = 2'b11;
    end
    endtask

    // Program Page
    // 0 = normal program
    // 1 = internal data move
    task program_page;
        input move;
        reg [col_bits - 1: 0] i;
    begin
        // Random Delay For RB# (tWB)
        if(debug) $display("ENTRY program_page");
        #tWB_max;
        Rb_n = 1'b0;
        intRb_state = 1'b0;
        status_register [6 : 5] = 2'b00;

        // Write to Memory Array
        if (~move) begin		//For 80h ->10h or 15h command & For 85 -> 10 alone
           for (i = col_addr; i <= num_col - 1; i = i + 1) begin
            	if(debug) $display("Write mem_array[%d]=%h", (row_addr*num_col)+i, mem_array[(row_addr*num_col)+i]);
            	if(~(&data_reg [i])) begin
               	  mem_array [(row_addr*num_col)+i] = data_reg [i] & mem_array[(row_addr*num_col)+i];
             	if(debug) $display("At time %0t : Program from Data Register1 (%0h : %0h : %0h) = %0h", $time, row_addr [16 : 6], row_addr [5 : 0], i, data_reg [i]);
                end
	   end
	end

        if (move) begin 		//For 0 ->35 -> 85h ->10h command 
           for (i = 0; i <= num_col - 1; i = i + 1) begin
               	if(~(&cache_reg [i])) begin
                  mem_array [(row_addr*num_col)+i] = cache_reg [i] & mem_array[(row_addr*num_col)+i];
                if(debug) $display("At time %0t : Program from Cache Register (%0h : %0h : %0h) = %0h", $time, row_addr [16 : 6], row_addr [5 : 0], i, cache_reg [i]);
                end
            end
        end

        // Random Delay for RB# (tPROG)
        if (cmnd_10h || cmnd_15h) begin
                if (cmnd_10h) begin
                    delay = (tPROG_typ + ({$random} % (tPROG_max - tPROG_typ)));
                end else if (cmnd_15h) begin
                    delay = (tCBSY_min + ({$random} % (tCBSY_max - tCBSY_min)));
                end

                while (delay) begin 
                    delay = delay - 1;
                    if (Cle && ~We_n && ~Ale && Re_n && ~Ce_n) begin
                        if (Io [7 : 0] === 8'h70) begin
                            if(debug) $display ("STATUS READ WHILE BUSY : MODE = STATUS");
                            cmnd_70h = 1'b1;
                        end else if (Io [7 : 0] === 8'hFF) begin
                            if(debug) $display ("RESET WHILE BUSY - ABORT");
                            delay = 1'b0;
                            cmnd_FFh = 1'b1;
                        end
                    end else if (~Re_n && ~Ce_n && We_n && cmnd_70h) begin
                        Io_buf = status_register;
                    end
                    #1;
                end
                if (cmnd_10h) begin 
                    cmnd_10h = 1'b0;
                end else if (cmnd_15h) begin
                    cmnd_15h = 1'b0;
                end
                Rb_n = 1'bz; // Device Ready
                intRb_state = 1'b1;
                status_register [6 : 5] = 2'b11;
                if (~Re_n && ~Ce_n && We_n && cmnd_70h) begin
                    Io_buf = status_register;
                end
                if (cmnd_FFh) begin
                    cmnd_reset(1);
                end
            end 
        end
    endtask

    // Command Reset
    // 0 = power on reset
    // 1 = soft reset
    task cmnd_reset;
        input reset;
    begin

        // Read Status
        status_register [6 : 5] = 2'b00;
        Rb_n = 1'b0;
        intRb_state = 1'b0;     

        // Delay For RB# (tWB)
        if (~reset) begin
            delay = tWB_max;
            for (col_counter = 0; col_counter <= num_col - 1; col_counter = col_counter + 1) begin
                data_reg [col_counter] = mem_array [{17'b0, col_counter}];
                //$display ("reset loading first page %0h = %0h", col_counter, data_reg [col_counter]);
            end
            if (Pre) begin
                // Ready for Auto Read
                delay = tRPRE1_max;
            end

        end else begin
            // Delay for RB# (tRST)
            if (cmnd_00h || cmnd_30h || cmnd_05h) begin
                delay = tRST_read;
            end else if (cmnd_80h || cmnd_85h || cmnd_10h) begin
                delay = tRST_prog;
            end else if (cmnd_60h || cmnd_D0h) begin
                delay = tRST_erase;
            end else begin
                delay = tRST_read;
            end
        end

        // Reset Command
        cmnd_00h = 1'b0;
        cmnd_05h = 1'b0;
        cmnd_10h = 1'b0;
        cmnd_15h = 1'b0;
        cmnd_30h = 1'b0;
        cmnd_31h = 1'b0;
        cmnd_35h = 1'b0;
        cmnd_3Fh = 1'b0;
        cmnd_60h = 1'b0;
        cmnd_65h = 1'b0;
        cmnd_70h = 1'b0;
        cmnd_80h = 1'b0;
        cmnd_85h = 1'b0;
        cmnd_90h = 1'b0;
        cmnd_D0h = 1'b0;
        cmnd_E0h = 1'b0;
        cmnd_FFh = 1'b0;

        // Reset Flags
        col_valid = 1'b0;
        col_addr = 0;
        row_valid = 1'b0;
        row_addr = 0;
        data_valid = 1'b0;
        cache_valid = 1'b0;
        saw_cmnd_00h = 1'b0;
        saw_cmnd_65h = 1'b0;
        do_read_id_2 = 1'b0;
        do_read_unique = 1'b0;
        cmnd_31h_first_time = 1'b0;
        addr_start = 0;
        addr_stop = 0;
        Io_buf <= {data_bits{1'bz}};

        while (delay != 0) begin
            delay = delay - 1;
            if (Cle && ~We_n && ~Ale && Re_n && ~Ce_n) begin
                if (Io [7 : 0] === 8'h70) begin
                    if(debug) $display ("STATUS READ WHILE BUSY : MODE = STATUS");
                    cmnd_70h = 1'b1;
                end else if (Io [7 : 0] === 8'hFF) begin
                    if(debug) $display ("RESET WHILE BUSY - ABORT");
                    delay = 1'b0;
                    cmnd_FFh = 1'b1;
                end
            end else if (~Re_n && ~Ce_n && We_n && cmnd_70h) begin
                Io_buf = status_register;
            end
            #1;
        end

        // Ready
        Rb_n = 1'bz;
        intRb_state = 1'b1;     

        // Read Status
        status_register [6 : 5] = 2'b11;

        if(~Re_n && ~Ce_n && We_n && cmnd_70h) begin
        Io_buf = status_register;				// *** After releasing Rb_n,  
	end							// *** the device needs to update 
								// *** the status register 0xe0 also. 
        if(debug) $display("At time %0t : Power-On / Reset : AUTO READ = Ready", $time);

    // PO Read Enable
    `ifdef V33
       if (Pre) begin
           col_addr = 0;
           row_addr = 0;
           col_counter = 0;
           col_valid = 1'b1;
           row_valid = 1'b1;
           data_valid = 1'b1;
       end
    `endif

    end
    endtask

    // Address Latch
    always @ (posedge We_n) begin
        if (command_debug) $display ("At time %0t : We_n posedge Address Latch", $time);
        if (~Cle && Ale && ~Ce_n && We_n && Re_n) begin
            if (saw_cmnd_00h) begin
                saw_cmnd_00h = 1'b0;
                col_valid = 1'b0;
                row_valid = 1'b0;
                data_valid = 1'b0;
                addr_start = 1;
                addr_stop = 5;
            end 
        end 
        if (~Cle && Ale && ~Ce_n && We_n && Re_n) begin
            // Latch Column
            if (addr_start <= 2 && addr_start <= addr_stop && ~col_valid) begin
                case (addr_start)
                    1 : col_addr [7 : 0] = Io [7 : 0];
                    2 : col_addr [col_bits - 1 : 8] = Io [16 - col_bits - 1 : 0];
                endcase

                if (addr_start >= 2) begin
                    col_valid = 1'b1;
                end
            end

            // Latch Row
            if (addr_start >= 3 && addr_start <= addr_stop && ~row_valid) begin
                case (addr_start)
                    3 : row_addr [7 : 0] = Io [7 : 0];
                    4 : row_addr [15 : 8] = Io [7 : 0];
                    5 : row_addr [16] = Io [0];
                endcase

                if (addr_start >= 5) begin
                    row_valid = 1'b1;
                end
            end

            if(debug) $display ("At time %0t : Latch Address (%0h) = %0h", $time, addr_start, Io [7 : 0]);

            // Increase Address Counter
            addr_start = addr_start + 1;
        end
    end

    // Latch Wp_n
    always @ (Wp_n) begin
        status_register [7] = Wp_n;
    end

    // Command Latch 
    always @ (posedge We_n) begin
        if (command_debug) $display ("At time %0t : We_n posedge Command Latch", $time);
        if ((intRb_state === 1'b1)) begin
            if (command_debug) $display ("At time %0t : Command Latch Unlock 1", $time);
            if (Cle && ~Ale && ~Ce_n && We_n && Re_n) begin
                if (command_debug) $display ("At time %0t : Command Latch Unlock 2", $time);
                // Command (00h)
                if (Io [7 : 0] === 8'h00) begin
                    if (command_debug) $display ("At time %0t : Latch Command = 00h", $time);

                    // This chunk should not execute after 00 -> 30 -> "busy-no-data" -> 70 -> unbusy -> [00] -> data
                    // But it SHOULD execute after 70 -> [00]
                    // cant have ~cmnd_30h here, 
                    // cant have ~cmnd_70h here, 
                    // if (~cmnd_00h && (Rb_n === 1'bz)) begin
                        if (command_debug) $display ("At time %0t : Latch Command 00h B", $time);
                        cmnd_00h = 1'b1;
                        saw_cmnd_00h = 1'b1;
                        //col_valid = 1'b0;
                        //row_valid = 1'b0;
                        //data_valid = 1'b0;
                        //addr_start = 1;
                        //addr_stop = 5;
                    //end

                    // Command (30h -> 65h -> [00h] -> 30h)
                    if (cmnd_65h) begin
                        if (command_debug) $display ("At time %0t : Latch Command 00h C", $time);
                        cmnd_65h = 1'b0;
                        cmnd_00h = 1'b1;
                        saw_cmnd_00h = 1'b1;
                        col_valid = 1'b0;
                        row_valid = 1'b0;
                        data_valid = 1'b0;
                        addr_start = 1;
                        addr_stop = 5;
                    end
    
                    // Terminate Command (60h -> D0h)
                    if (cmnd_60h) begin
                        if (command_debug) $display ("At time %0t : Latch Command 00h D", $time);
                        cmnd_60h = 1'b0;
                    end
    
                    // Terminate Command (70h)
                    if (cmnd_70h) begin
                        if (command_debug) $display ("At time %0t : Latch Command 00h E", $time);
                        cmnd_70h = 1'b0;
                    end
    
                    // Terminate Command (80h -> [85h] -> 10h)
                    if (cmnd_80h || cmnd_85h) begin
                        if (command_debug) $display ("At time %0t : Latch Command 00h F", $time);
                        cmnd_80h =1'b0;
                        cmnd_85h = 1'b0;
                    end
    
                    // Terminate Command (90h)
                    if (cmnd_90h) begin
                        if (command_debug) $display ("At time %0t : Latch Command 00h G", $time);
                        cmnd_90h = 1'b0;
                    end

                    // Terminate Command (05h)
                    if (cmnd_05h) begin
                        if (command_debug) $display ("At time %0t : Latch Command 00h H", $time);
                        cmnd_05h = 1'b0;
                    end
                end
    
                // Command (05h)
                else if (Io [7 : 0] === 8'h05) begin

                    if (command_debug) $display ("At time %0t : Latch Command = 05h", $time);
    
                    // Command (00h -> 30h -> 05h -> E0h)
                    if (cmnd_30h && row_valid && (intRb_state === 1'b1)) begin
                        cmnd_05h = 1'b1;
                        col_valid = 1'b0;
                        data_valid = 1'b0;
                        addr_start = 1;
                        addr_stop = 2;
                    end

                    // Terminate Command (90h)
                    if (cmnd_90h) begin
                        cmnd_90h = 1'b0;
                    end
                end
    
                // Command (10h) 
                else if (Io [7 : 0] === 8'h10) begin

                    if (command_debug) $display ("At time %0t : Latch Command = 10h", $time);
    
                    // Read Status
                    //yyystatus_register [7] = Wp_n;
    
                    // Command (00h -> 35h -> 85h -> 10h: Program from Cache Register)
                    if ((cmnd_35h && cmnd_85h) && row_valid && (intRb_state === 1'b1)) begin
                        cmnd_10h = 1'b1;
                        cmnd_35h = 1'b0;
                        cmnd_85h = 1'b0;
                        program_page (1'b1);
                    end
    
                    // Command (85h -> 10h alone: Program from Data Register) 
                    if (cmnd_85h && (cmnd_35h==0) && row_valid && (intRb_state === 1'b1)) begin
                        cmnd_10h = 1'b1;
                        cmnd_85h = 1'b0;
                        col_addr = 0;
                        program_page (1'b0);
                    end 

                   else

                    // Command (80h -> 10h: Program from Data Register)
                    if (cmnd_80h && row_valid && (intRb_state === 1'b1)) begin
                        cmnd_10h = 1'b1;
                        cmnd_80h = 1'b0;
                        program_page (1'b0);
                    end
                end
    
                // Command (15h)
                else if (Io [7 : 0] === 8'h15) begin

                    if (command_debug) $display ("At time %0t : Latch Command = 15h", $time);
    
                    // Command (80h -> 15h: Program from Data Register)
                    if (cmnd_80h && row_valid) begin
                        cmnd_80h = 1'b0;
                        cmnd_15h = 1'b1;
                        program_page (1'b0);
                    end
    
                    // Terminate Command (80h)
                    if (cmnd_80h && ~row_valid) begin
                        cmnd_80h = 1'b0;
                    end
                end
    
                // Command (30h)
                else if (Io [7 : 0] === 8'h30) begin

                    if (command_debug) $display ("At time %0t : Latch Command = 30h", $time);

                    cmnd_30h = 1'b1;

                    // Command (00h -> [30h] -> 05h -> E0h)
                    if (cmnd_00h && row_valid && (intRb_state === 1'b1) && ~saw_cmnd_65h) begin
                        if(command_debug) $display ("Command = 30h A");
                        cmnd_00h = 1'b0;
                        cmnd_30h = 1'b1;
                        col_counter = 0;
                        clear_data_register;
                        load_register (1'b0);
                        data_valid = 1'b1;
                        cache_valid = 1'b0;
                    end 

                    // Command (30h -> 65h -> 00 -> [30h]) 
                    if (cmnd_00h && row_valid && (intRb_state === 1'b1) && saw_cmnd_65h) begin
                        if(command_debug) $display ("Command = 30h B");
                        cmnd_30h = 1'b1;
                        if (col_addr == 512) begin  // hex 200 (LSB of second Column Address = 02h
                            do_read_id_2 = 1'b1;
                            `ifdef x8
                                col_counter = 512;  // Byte 512 for x8
                            `else
                                col_counter = 256;  // Byte 512 for x16
                            `endif
                            if(command_debug) $display ("At time %0t : Latch last 30h command for do_read_id_2", $time);
                        end else if (col_addr == 0) begin
                            do_read_unique = 1'b1;
                            col_counter = 0;
                            if(command_debug) $display ("At time %0t : Latch last 30h command for do_read_unique", $time);
                        end else begin
                            if(command_debug)$display ("At time %0t : ERROR invalid col_addr when attemping read_id_2 or read_unique", $time);
                            if(command_debug) $display ("At time %0t : ERROR col_addr = %hh", $time, col_addr);
                        end
                        saw_cmnd_65h = 1'b0; 
                    end

                    // Terminate Command (00h)
                    if (cmnd_00h && ~row_valid) begin
                        if(command_debug) $display ("Command = 30h C");
                        cmnd_00h = 1'b0;
                    end

                    // Terminate Command (90h)
                    if (cmnd_90h) begin
                        if(command_debug) $display ("Command = 30h D");
                        cmnd_90h = 1'b0;
                    end
                end
    
                // Command (31h)
                else if (Io [7 : 0] === 8'h31) begin

                    if (command_debug) $display ("At time %0t : Latch Command = 31h", $time);
    
                    // Command (00h -> 30h -> 31h -> 3Fh)
                    if (cmnd_30h && row_valid) begin
                        // Reset Column Address
                        col_addr = 0;
                        col_counter = 0;
    
                        // Command (00h -> 30h -> [31h] -> 3Fh)
                        if (~cmnd_31h) begin // If this is the first 31h command
                            cmnd_31h = 1'b1;
                            clear_cache_register;  // Clear cache
                            load_register (1'b1);  // Load cache
                        // Command (00h -> 30h -> 31h -> [31h] -> 3Fh)
                        end else begin  // subsequint 31h commands
                            for (cache_counter = 0; cache_counter <= num_col - 1; cache_counter = cache_counter + 1) begin
                                data_reg [cache_counter] = cache_reg [cache_counter];
                            end
    
                            row_addr = {row_addr [16 : 6], (row_addr [5 : 0] + 1'b1)};
                            clear_cache_register;  // Clear cache
                            load_register (1'b1);  // Load cache
                        end
    
                        cache_valid = 1'b1;
                        cmnd_31h_first_time = cmnd_31h_first_time + 1 ; 
                        data_valid = 1'b1;
                    end
    
                    // Terminate Command
                    if (cmnd_30h  && ~row_valid) begin
                        cmnd_30h = 1'b0;
                    end

                    // Terminate Command (90h)
                    if (cmnd_90h) begin
                        cmnd_90h = 1'b0;
                    end
                end
    
                // Command (35h)
                else if (Io [7 : 0] === 8'h35) begin

                    if (command_debug) $display ("At time %0t : Latch Command = 35h", $time);
    
                    // Command (00h -> 35h -> 85h -> 10h)
                    if (cmnd_00h && row_valid && (intRb_state === 1'b1)) begin
                        cmnd_00h = 1'b0;
                        cmnd_35h = 1'b1;
                        col_valid = 1'b0;
                        row_valid = 1'b0;
                        clear_cache_register;
                        load_register (1'b1);
                    end
    
                    // Terminate Command (00h)
                    if (cmnd_00h && ~row_valid) begin
                        cmnd_00h = 1'b0;
                    end
                end
    
                // Command (3Fh)
                else if (Io [7 : 0] === 8'h3F) begin

                    if (command_debug) $display ("At time %0t : Latch Command = 3Fh", $time);
    
                    // Command (00h -> 30h -> 31h -> 3Fh)
                    if (cmnd_30h && cmnd_31h) begin
                        cmnd_3Fh = 1'b1;
                        col_counter = 0;
                        for (cache_counter = 0; cache_counter <= num_col - 1; cache_counter = cache_counter + 1) begin
                            data_reg [cache_counter] = cache_reg [cache_counter];
                        end
    
                        row_addr = {row_addr [16 : 6], (row_addr [5 : 0] + 1'b1)};
                        clear_cache_register;
                        load_register (1'b1); 
                        cmnd_30h = 1'b0;
                        cmnd_31h = 1'b0;
                        cache_valid = 1'b0;
                        data_valid = 1'b1;
                    end

                    // Terminate Command (90h)
                    if (cmnd_90h) begin
                        cmnd_90h = 1'b0;
                    end
                end
    
                // Command (60h)
                else if (Io [7 : 0] === 8'h60) begin

                    if (command_debug) $display ("At time %0t : Latch Command = 60h", $time);
    
                    if (~cmnd_60h && Wp_n && (intRb_state === 1'b1)) begin
                        cmnd_60h = 1'b1;
                        row_valid = 1'b0;
                        addr_start = 3;
                        addr_stop = 5;
                    end
    
                    // Terminate Command (00h -> 30h -> [05h] - [E0h])
                    if (cmnd_30h || cmnd_05h) begin
                        cmnd_30h = 1'b0;
                        cmnd_05h = 1'b0;
                        data_valid = 1'b0;
                    end
    
                    // Terminate Command (70h)
                    if (cmnd_70h) begin
                        cmnd_70h = 1'b0;
                    end
    
                    // Terminate Command (80h -> [85h] -> 10h)
                    if (cmnd_80h || cmnd_85h) begin
                        cmnd_80h =1'b0;
                        cmnd_85h = 1'b0;
                    end
    
                    // Terminate Command (90h)
                    if (cmnd_90h) begin
                        cmnd_90h = 1'b0;
                    end
                end
    
                // Command (65h)
                else if (Io [7 : 0] === 8'h65) begin

                    if (command_debug) $display ("At time %0t : Latch Command = 65h", $time);
    
                    // Terminate Command (30h -> 65h -> [00h])
                    if (cmnd_30h) begin
                        if(command_debug) $display ("Command = 65h A");
                        cmnd_30h = 1'b0;
                        cmnd_65h = 1'b1;
                        saw_cmnd_65h = 1'b1;
                    end
    
                    // Terminate Command (60h -> D0h)
                    if (cmnd_60h) begin
                        if(command_debug) $display ("Command = 65h B");
                        cmnd_60h = 1'b0;
                    end
    
                    // Terminate Command (80h -> [85h] -> 10h)
                    if (cmnd_80h || cmnd_85h) begin
                        if(command_debug) $display ("Command = 65h C");
                        cmnd_80h = 1'b0;
                        cmnd_85h = 1'b0;
                    end
                end

                // Command (70h)
                else if (Io [7 : 0] === 8'h70) begin

                    if (command_debug) $display ("At time %0t : Latch Command1 = 70h", $time);
    
                    // Status
                    cmnd_70h = 1'b1;
    
                    // Terminate Command (00h -> 30h -> [05h] - [E0h])
                    //if (cmnd_30h || cmnd_05h) begin
                    if (cmnd_05h) begin
                        cmnd_30h = 1'b0;
                        cmnd_05h = 1'b0;
                        data_valid = 1'b0;
                    end
    
                    // Terminate Command (60h -> D0h)
                    if (cmnd_60h) begin
                        cmnd_60h = 1'b0;
                    end
    
                    // Terminate Command (80h -> [85h] -> 10h)
                    if (cmnd_80h || cmnd_85h) begin
                        cmnd_80h =1'b0;
                        cmnd_85h = 1'b0;
                    end
    
                    // Terminate Command (90h)
                    if (cmnd_90h) begin
                        cmnd_90h = 1'b0;
                    end
               end
    
                // Command (80h)
                else if (Io [7 : 0] === 8'h80) begin

                    if (command_debug) $display ("At time %0t : Latch Command = 80h", $time);
    
                    // Read Status
                    //yyystatus_register [7] = Wp_n;
    
                    // Command (80h)
                    if (~cmnd_80h && (intRb_state === 1'b1)) begin
                        if (command_debug) $display ("At time %0t : 80h A", $time);
                        cmnd_80h = 1'b1;
                        col_valid = 1'b0;
                        row_valid = 1'b0;
                        addr_start = 1'b1;
                        addr_stop = 5;
                        col_counter = 0;
                        clear_data_register;
                    end
    
                    // Terminate Command (00h -> 30h -> 05h -> E0h)
                    if (cmnd_00h || cmnd_30h || cmnd_05h) begin
                        if (command_debug) $display ("At time %0t : 80h B", $time);
                        cmnd_00h = 1'b0;
                        cmnd_30h = 1'b0;
                        cmnd_05h = 1'b0;
                        data_valid = 1'b0;
                    end
    
                    // Terminate Command (00h -> 35h -> 85h -> 10h)
                    if (cmnd_35h || cmnd_85h) begin
                        if (command_debug) $display ("At time %0t : 80h C", $time);
                        cmnd_35h = 1'b0;
                        cmnd_85h = 1'b0;
                    end
    
                    // Terminate Command (60h -> D0h)
                    if (cmnd_60h) begin
                        if (command_debug) $display ("At time %0t : 80h D", $time);
                        cmnd_60h = 1'b0;
                    end
    
                    // Terminate Command (70h)
                    if (cmnd_70h) begin
                        if (command_debug) $display ("At time %0t : 80h E", $time);
                        cmnd_70h = 1'b0;
                    end
    
                    // Terminate Command (90h)
                    if (cmnd_90h) begin
                        if (command_debug) $display ("At time %0t : 80h F", $time);
                        cmnd_90h = 1'b0;
                    end
                end
    
                // Command (85h)
                else if (Io [7 : 0] === 8'h85) begin

                    if (command_debug) $display ("At time %0t : Latch Command = 85h", $time);
    
                    // Read Status
                    //yyystatus_register [7] = Wp_n;
    
                    // Command (00h -> 35h -> 85h -> 10h)
                    if (cmnd_35h && Wp_n && (intRb_state === 1'b1)) begin
                        if (~cmnd_85h) begin
                            cmnd_85h = 1'b1;
                            col_valid = 1'b0;
                            row_valid = 1'b0;
                            addr_start = 1;
                            addr_stop = 5;
                            col_counter = 0;
                            clear_data_register;
                        end else begin
                            col_valid = 1'b0;
                            addr_start = 1;
                            addr_stop = 2;
                            col_counter = 0;
                        end
                    end
    
                    // Command (80h -> 85h -> 10h)
                    if (cmnd_80h && row_valid && Wp_n && (intRb_state === 1'b1)) begin
                        cmnd_85h = 1'b1;
                        col_valid = 1'b0;
                        addr_start = 1;
                        addr_stop = 2;
                        col_counter = 0;
                    end
    
                    // Terminate Command (80h -> 85h -> 10h)
                    if (cmnd_80h && ~row_valid) begin
                        cmnd_80h = 1'b0;
                    end
    
                    // Terminate Command (90h)
                    if (cmnd_90h) begin
                        cmnd_90h = 1'b0;
                    end
                end
    
                // Command (90h)
                else if (Io [7 : 0] === 8'h90) begin

                    if (command_debug) $display ("At time %0t : Latch Command = 90h", $time);
    
                    // Command (90h)
                    if (~cmnd_90h) begin
                        cmnd_90h = 1'b1;
                        col_valid = 1'b0;
                        row_valid = 1'b0;
                        addr_start = 1;
                        addr_stop = 0;
                        col_counter = 0;
                    end
    
                    // Terminate Command (00h -> 30h -> 05h -> E0h)
                    if (cmnd_00h || cmnd_30h || cmnd_05h) begin
                        cmnd_00h = 1'b0;
                        cmnd_30h = 1'b0;
                        cmnd_05h = 1'b0;
                        data_valid = 1'b0;
                    end
    
                    // Terminate Command (00h -> 35h -> 85h -> 10h)
                    if (cmnd_35h || cmnd_85h) begin
                        cmnd_35h = 1'b0;
                        cmnd_85h = 1'b0;
                    end
    
                    // Terminate Command (60h -> D0h)
                    if (cmnd_60h) begin
                        cmnd_60h = 1'b0;
                    end
    
                    // Terminate Command (70h)
                    if (cmnd_70h) begin
                        cmnd_70h = 1'b0;
                    end
    
                    // Terminate Command (80h -> 85h -> 10h)
                    if (cmnd_80h || cmnd_85h) begin
                        cmnd_80h = 1'b0;
                        cmnd_85h = 1'b0;
                    end
                end
    
                // Command (D0h)
                else if (Io [7 : 0] === 8'hD0) begin

                    if (command_debug) $display ("At time %0t : Latch Command = D0h", $time);
    
                    // Read Status
                    //yyystatus_register [7] = Wp_n;
    
                    // Command (60h -> D0h)
                    if (cmnd_60h && row_valid && Wp_n && (intRb_state === 1'b1)) begin
                        cmnd_60h = 1'b0;
                        cmnd_D0h = 1'b1;
                        erase_block;
                    end
    
                    // Terminate Command (60h -> D0h)
                    if (cmnd_60h && ~row_valid) begin
                        cmnd_60h = 1'b0;
                    end
                end
    
                // Command (E0h)
                else if (Io [7 : 0] === 8'hE0) begin

                    if (command_debug) $display ("At time %0t : Latch Command = E0h", $time);
    
                    // Command (00h -> 30h -> 05h -> E0h)
                    if (cmnd_05h && col_valid) begin
                        data_valid = 1'b1;
                        col_counter = 0;
                    end
    
                    // Terminate Command (00h -> 30h -> 05h -> E0h)
                    if (cmnd_05h && ~col_valid) begin
                        cmnd_30h = 1'b0;
                        cmnd_05h = 1'b0;
                        data_valid = 1'b0;
                    end
                end
    
                // Command (FFh) Reset Command
                else if (Io [7 : 0] === 8'hFF) begin

                    if (command_debug) $display ("At time Reset Command %0t : Latch Command = FFh", $time);
    
                    // Read Status
                    //yyystatus_register [7] = Wp_n;
                    cmnd_reset (1'b1);
                end
            end
        end if (intRb_state == 1'b0) begin  // even when buzy we need to do status and reset
            if(command_debug) $display ("caught we_n posedge with Rb_n low");
            if (Cle && ~Ale && ~Ce_n && We_n && Re_n) begin 
                // Command (70h)
                if (Io [7 : 0] === 8'h70) begin
                    if (command_debug) $display ("At time %0t : Latch Command2 = 70h", $time);
                    // Status
                    cmnd_70h = 1'b1;
                end
                // Command (FFh) Reset Command
                else if (Io [7 : 0] === 8'hFF) begin
    
                    if (command_debug) $display ("At time Reset Command %0t : Latch Command2 = FFh", $time);
                    // Read Status
                    //yyystatus_register [7] = Wp_n;
                    cmnd_reset (1'b1);
                end
            end
        end
    if (command_debug) $display ("At time %0t : Command Latch Lock", $time);
    end

    // Data Input 
    always @ (posedge We_n) begin
        if (debug) $display ("At time %0t : We_n posedge Data Input", $time);
        if (~Cle && ~Ale && ~Ce_n && We_n && Re_n && Wp_n) begin
            if (col_valid && row_valid && (col_addr + col_counter <= num_col - 1)) begin

               if(debug) $display ("At time %0t : Latch Data (%0h : %0h : %0h + %0h) = %0h",
                 $time, row_addr [16 : 6], row_addr [5 : 0], col_addr, col_counter, Io);

               // Load Io data to Cache Register
               if((cmnd_35h && cmnd_85h) && row_valid && (intRb_state === 1'b1)) 
                 cache_reg [col_addr + col_counter] = Io;

               // Load Io data to Data Register
               if((cmnd_80h || cmnd_85h) && (cmnd_35h==0) && row_valid && (intRb_state === 1'b1))
                 data_reg [col_addr + col_counter] = Io;

               // Increase Column Counter
               col_counter = col_counter + 1;
            end
        end
    end

    // Data Output
    always @ (negedge Re_n) begin
        if (PowerUp_Complete === 1'b1) begin
            if (saw_cmnd_00h) begin
                saw_cmnd_00h = 1'b0;
            end
            if (~Cle && ~Ale && ~Ce_n && We_n && ~Re_n && (intRb_state === 1'b1)) begin
                // Normal Page Read
                if (~cmnd_70h && col_valid && row_valid && data_valid && (col_addr + col_counter <= num_col - 1)) begin
                    // Data Buffer
                    Io_buf <= #({$random} % 3) data_reg [col_addr + col_counter];
                    if (debug) $display("Io_buf Trigger 4"); 
    
                    if(debug) $display ("At time %0t : Data Read (%0h : %0h : %0h + %0h) = %0h",
                        $time, row_addr [16 : 6], row_addr [5 : 0], col_addr, col_counter, data_reg [col_addr + col_counter]);
    
                    // Increase Column Counter
                    col_counter = col_counter + 1;
                // extra case to drive data bus high z after column boundary is reached
                end else if (~cmnd_70h && col_valid && row_valid && data_valid && (col_addr + col_counter > num_col - 1)) begin
                    Io_buf <= #({$random} % 3) {data_bits{1'bz}};
                    if (debug) $display("Io_buf Trigger 5 - col_addr=%h, col_counter=%h, num_col=%h", col_addr, col_counter, num_col); 
    
                // Status Read
                end else if (cmnd_70h) begin
                    Io_buf <= #({$random} % 3) status_register;
                    if (debug) $display("Io_buf Trigger 6"); 
    
                    if(debug) $display ("At time %0t : Status Read %0h", $time, status_register);
    
    
                // Read ID 2 
                end else if (do_read_id_2) begin

                    if(debug) $display ("At time %0t : ReadID2 (%0h)", $time, col_counter);
    
                    Io_buf <= #({$random} % 3) special_array[col_counter];
                    if (debug) $display("Io_buf Trigger 7id2"); 

                    // Advance counter
                    col_counter = col_counter + 1;

                // Read Unique 
                end else if (do_read_unique) begin

                    if(debug) $display ("At time %0t : ReadUnique (%0h)=%h", $time, col_counter, special_array[col_counter]);
    
                    Io_buf <= #({$random} % 3) special_array[col_counter];
                    if (debug) $display("Io_buf Trigger 7uniq"); 

                    // Advance counter
                    col_counter = col_counter + 1;

                // Read ID
                end else if (cmnd_90h) begin
    
                    // Reset Counter
                    if (col_counter > 3) begin
                        col_counter = 0;
                    end

                    case (col_counter)
                          0 : begin
                                  Io_buf <= #({$random} % 3) read_id_byte0;
                                  if (debug) $display("Io_buf Trigger 71"); 
                              end
                          1 : begin
                                  Io_buf <= #({$random} % 3) read_id_byte1;
                                  if (debug) $display("Io_buf Trigger 72"); 
                              end
                          2 : begin
                                  Io_buf <= #({$random} % 3) read_id_byte2;
                                  if (debug) $display("Io_buf Trigger 73"); 
                              end
                          3 : begin
                                  Io_buf <= #({$random} % 3) read_id_byte3;
                                  if (debug) $display("Io_buf Trigger 74"); 
                              end
                    endcase
    
                    if(debug) $display ("At time %0t : Read ID (%0h)", $time, col_counter);
    
                    // Advance counter
                    col_counter = col_counter + 1;
    
    
                // Out of bounds or unknown
                end else begin
                    Io_buf <= #({$random} % 3) {data_bits{1'bz}};
                    if(debug) $display("Error: DATA NOT Transfered on Re_n Trigger 8"); 
                end
            end else begin
                Io_buf <= #({$random} % 3) {data_bits{1'bz}};
                if (debug) $display("Io_buf Trigger 9"); 
                end
        end 
    end

    always @ (posedge Re_n) begin
        if ((~Cle && ~Ale && ~Ce_n && We_n && Re_n) || Ce_n) begin
            Io_buf <= #(({$random} % 5)+5) {data_bits{1'bz}};
            if (debug) $display("Io_buf Trigger 10"); 
        end
    end
endmodule
