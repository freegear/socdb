    // Initial Conditions
    initial begin
        Pre  = 1'b0;
        Cle  = 0;
        Ce_n = 0;
        We_n = 1;
        Ale  = 0;
        Re_n = 1;
        Wp_n = 1;
        Io = {data_bits{1'bz}};
    end

    // Test Vectors
    initial begin
    $display ("START TEST VECTOR");

	// read data from preload
        #1000;
	latch_read;
	latch_read;
	latch_read;
	latch_read;
	latch_read;
	

        erase_block (1'b0); // erase_block waits for rb_n to come high before return
	reset;
	check_ready;
	status_read;
        latch_read_status;
	latch_read;
        #200

        program_page (0,0,0,8'h00, num_col, 2'b01); // block, page, col, data, size, pattern
        page_read (0,0,0, num_col); // block, page, col, size

       $display("At time %t: SIMULATION ENDING NORMALLY", $time);

    end
