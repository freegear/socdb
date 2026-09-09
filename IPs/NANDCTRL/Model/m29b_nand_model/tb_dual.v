///////////////////////////////////////////////////////////////////////////////////////////
//
//   Disclaimer   This software code and all associated documentation, comments or other 
//  of Warranty:  information (collectively "Software") is provided "AS IS" without 
//                warranty of any kind. MICRON TECHNOLOGY, INC. ("MTI") EXPRESSLY 
//                DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
//                TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMPLIED WARRANTIES 
//                OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. MTI DOES NOT 
//                WARRANT THAT THE SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE 
//                OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. 
//                FURTHERMORE, MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
//                THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS, 
//                ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT OF USE 
//                OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO EVENT SHALL MTI, 
//                ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, 
//                INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR SPECIAL DAMAGES (INCLUDING, 
//                WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, 
//                OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE 
//                THE SOFTWARE, EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
//                DAMAGES. Because some jurisdictions prohibit the exclusion or 
//                limitation of liability for consequential or incidental damages, the 
//                above limitation may not apply to you.
//
//                Copyright 2003 Micron Technology, Inc. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ns

module tb_dual;

`include "parameters.v"

    // Ports Declaration
    reg  [data_bits - 1 : 0] Io;
    reg                      Cle;
    reg                      Ale;
    reg                      Ce_n;
    reg                      Ce_n2;
    reg                      Re_n;
    reg                      We_n;
    reg                      Wp_n;
    reg                      Pre;   //3.3V only

    tri1                     Rb_n;  // pullup
    tri1                     Rb_n2;  // pullup

    wire [data_bits - 1 : 0] IO = Io;

    // Instantiate Device
    nand_model_0 uut_0  (IO, Cle, Ale, Ce_n,  We_n, Re_n, Wp_n, Pre, Rb_n );
    nand_model_1 uut_1  (IO, Cle, Ale, Ce_n2, We_n, Re_n, Wp_n, Pre, Rb_n2);


    // Check Ready
    task check_ready;
    begin
        #1;
        if (Rb_n === 0) begin
            wait (Rb_n === 1);
            #tRR_min;
        end
    end
    endtask

    // Wait Ready
    task wait_ready;
    begin
        #1;
        //Io = {data_bits{1'bz}};
        if (Rb_n === 1) begin
            wait (Rb_n === 0);
            wait (Rb_n === 1);
        end else if (Rb_n === 0) begin
            wait (Rb_n === 1);
        end
        #tRR_min;
    end
    endtask

    /////////////////////////////
    // Power-on Page Read      //
    /////////////////////////////
    task PO_read;
        reg   [12 : 0] i;
    begin
        check_ready;  // 
        //Cle  = 0;
        //Ce_n = 0;
        //We_n = 1;
        //Ale = 0;
        //Io = {data_bits{1'bz}};
        #10 
        for (i = 0; i <= (num_col - 1) ; i = i + 1) begin
           #(tRC_min/2);
           Re_n = 0;
           #(tRC_min/2)
           Re_n = 1;
        end

    end
    endtask

    ///////////////////////////////////
    // NEW  Serial Latch Read Status //
    ///////////////////////////////////
    // Ignores busy
    task latch_read_status;
    begin
        Ce_n = 0;
        Cle = 0;
        Ale = 0;
        //check_ready;
        //Io = {data_bits{1'bz}};
      Re_n = 0;
        #(tRC_min/2);
      Re_n = 1;
        #(tRC_min/2);
    end
    endtask



    /////////////////////////////
    // NEW  Serial Latch Read  //
    /////////////////////////////
    task latch_read;
    begin
        Ce_n = 0;
        Cle = 0;
        Ale = 0;
        check_ready;
        //Io = {data_bits{1'bz}};
      Re_n = 0;
        #(tRC_min/2);
      Re_n = 1;
        #(tRC_min/2);
    end
    endtask

    /////////////////////////////
    // NEW  Latch Address      //
    /////////////////////////////
    task latch_address;
        input [data_bits - 1 : 0] addr_in;
    begin
        check_ready;
        Ce_n = 0;
        We_n = 0;
        Re_n = 1;  // 0 active
        Wp_n = 1;  // 0 active
        #(tCS_min-tCLS_min);  // 5 ns
        Cle = 0;
      Ale = 1;
        Io[7:0] = addr_in;
        `ifdef x16
            Io[15:8] = 8'b0;
        `endif
        #tCLS_min;      // 10 ns
        We_n = 1;
        #9;   // 9 debug
        #tDH_min;       // 5 ns
        Io = {data_bits{1'bz}};
      Ale = 0;
    end
    endtask

    /////////////////////////////
    // NEW  Latch Command      //
    /////////////////////////////
    // IGNORES BUSY
    task reset_latch_command;
        input [data_bits - 1 : 0] data_in;
    begin
        Ce_n = 0;
        #(tCS_min-tWP_min);   // 0-10 ns
     We_n = 0;
        #(tCS_min-tCLS_min);  // 5-10 ns
        Ale = 0;
        Cle = 1;
        Io = data_in;
        #tDS_min;       // 10 ns
        `ifdef x8
        `else
            #5;  // Some assumptions have to be made
        `endif
     We_n = 1;
        `ifdef x8
            #9;  // Some assumptions have to be made
        `else
            #19;  // Some assumptions have to be made
        `endif
        #tCLH_min;       // 5 ns
        Cle = 0;
        Io = {data_bits{1'bz}};
    end
    endtask

    /////////////////////////////
    // NEW  Latch Command      //
    /////////////////////////////
    task latch_command_ignore_busy;
        input [data_bits - 1 : 0] data_in;
    begin
        Ce_n = 0;
        #(tCS_min-tWP_min);   // 0-10 ns
     We_n = 0;
        #(tCS_min-tCLS_min);  // 5-10 ns
        Ale = 0;
        Cle = 1;
        Io = data_in;
        #tDS_min;       // 10 ns
        `ifdef x8
        `else
            #5;  // Some assumptions have to be made
        `endif
     We_n = 1;
        `ifdef x8
            #9;  // Some assumptions have to be made
        `else
            #19;  // Some assumptions have to be made
        `endif
        #tCLH_min;       // 5 ns
        Cle = 0;
        Io = {data_bits{1'bz}};
    end
    endtask



    /////////////////////////////
    // NEW  Latch Command      //
    /////////////////////////////
    task latch_command;
        input [data_bits - 1 : 0] data_in;
    begin
        Ce_n = 0;
        check_ready;
        #(tCS_min-tWP_min);   // 0-10 ns
     We_n = 0;
        #(tCS_min-tCLS_min);  // 5-10 ns
        Ale = 0;
        Cle = 1;
        Io = data_in;
        #tDS_min;       // 10 ns
        `ifdef x8
        `else
            #5;  // Some assumptions have to be made
        `endif
     We_n = 1;
        `ifdef x8
            #9;  // Some assumptions have to be made
        `else
            #19;  // Some assumptions have to be made
        `endif
        #tCLH_min;       // 5 ns
        Cle = 0;
        Io = {data_bits{1'bz}};
    end
    endtask

    /////////////////////////////
    // NEW  Input Latch Data   //
    /////////////////////////////
    task latch_data;
        input [data_bits - 1 : 0] data_in;
    begin
        check_ready;
      We_n = 0;
        #(tWP_min-tALS_min);  // 5 ns 
        Ale = 0;
        #(tALS_min-tDS_min);  // 0 ns
        Io = data_in;
        #tDS_min;       // 10 ns
      We_n = 1;
        `ifdef x16
            #9;
        `endif
        #tDH_min;
        Io = {data_bits{1'bz}};
        #(tWH_min-tDH_min);
    end
    endtask

    // Status Read (70h)
    task status_read;
    begin
        $display ("tb.status_read at time %t", $time);
      //latch_command (8'h70);
        //check_ready;
        Ale = 0;
        Ce_n = 0;
        #(tCS_min-tWP_min);   // 0-10 ns
        We_n = 0;
        #(tCS_min-tCLS_min);  // 5-10 ns
        Cle = 1;
        #(tCLS_min-tDS_min);  // 0-5 ns
        Io[7:0] = 8'h70;
        #tDS_min;       // 10 ns
        We_n = 1;
        #tCLH_min;       // 5 ns
        Cle = 0;
        //`ifdef x16
            //Io[15:8] = 8'b0;
        //`endif
        Io  = {data_bits{1'bz}};
      //status_read;
        #(tWHR_min-tDH_min);       // 5 ns
        Re_n = 0;
        #tRP_min;
        //Re_n = 1;
        #(tREA_max-tRP_min);
        #(tRHZ_max-(tREA_max-tRP_min));
        Io = {data_bits{1'bz}};
    end
    endtask


    // Erase Block (60h -> D0h)
    task erase_block;
        input [blck_bits - 1 : 0] blck_addr;

        reg   [data_bits - 1 : 0] row_addr_1;
        reg   [data_bits - 1 : 0] row_addr_2;
        reg   [data_bits - 1 : 0] row_addr_3;
    begin
        $display ("Erasing block %d at time %t", blck_addr, $time);
        // Decode Address
        row_addr_1 [7 : 0] = {blck_addr [1 : 0], 6'b0};
        row_addr_2 [7 : 0] = blck_addr [9 : 2];
        row_addr_3 [7 : 0] = {7'b0, blck_addr [10]};

        // Decode Command
        latch_command (8'h60);
        latch_address (row_addr_1);
        latch_address (row_addr_2);
        latch_address (row_addr_3);
        latch_command (8'hD0);
        $display ("WAITING FOR completion of Erasing block %d at time %t", blck_addr, $time);
        wait_ready;
        $display ("Erasing block %d COMPLETE at time %t", blck_addr, $time);
        #tRR_min;
    end
    endtask

    // Multi Read
    // size = number of serial data units to read
    task PO_multi_read;
        input [col_bits  - 1 : 0] size;
        reg   [col_bits  - 1 : 0] i;
    begin
        check_ready;

        // multi Read
        for (i = 0; i <= size - 1; i = i + 1) begin
            latch_read;
        end
        #tRR_min;
    end
    endtask


    // Multi Read
    // size = number of serial data units to read
    task multi_read;
        input [col_bits  - 1 : 0] size;
        reg   [col_bits  - 1 : 0] i;
    begin
        check_ready;

        // multi Read
        for (i = 0; i <= size - 1; i = i + 1) begin
            latch_read;
        end
        #tRR_min;
    end
    endtask

    // Page Read (00h -> 30h)
    // blck_addr = block address
    // page_addr = page address
    //  col_addr = column address
    //      size = number of serial data to be read
    task page_read;
        input [blck_bits - 1 : 0] blck_addr;
        input [page_bits - 1 : 0] page_addr;
        input [col_bits - 1 : 0] col_addr;
        input [12  : 0]           size;

        reg   [data_bits - 1 : 0] col_addr_1;
        reg   [data_bits - 1 : 0] col_addr_2;
        reg   [data_bits - 1 : 0] row_addr_1;
        reg   [data_bits - 1 : 0] row_addr_2;
        reg   [data_bits - 1 : 0] row_addr_3;
        reg   [12 : 0]            i;
    begin
        // Decode Address
        col_addr_1 [7 : 0] = col_addr [7 : 0];
        col_addr_2 [7 : 0] = {4'b0, col_addr [11 : 8]};
        row_addr_1 [7 : 0] = {blck_addr [1 : 0], page_addr [5 : 0]};
        row_addr_2 [7 : 0] = blck_addr [9 : 2];
        row_addr_3 [7 : 0] = {7'b0, blck_addr [10]};

        // Decode Command
        latch_command (8'h00);
        latch_address (col_addr_1);
        latch_address (col_addr_2);
        latch_address (row_addr_1);
        latch_address (row_addr_2);
        latch_address (row_addr_3);
        latch_command (8'h30);
        wait_ready;
        #tRR_min;

        // Serial Read
    $display ("LATCH READ size=%h", size);
    for (i = 0; i <= size - 1; i = i + 1) begin
            latch_read;
        end
        #tRR_min;
    end
    endtask


    // Page Read (00h -> 30h)
    // blck_addr = block address
    // page_addr = page address
    //  col_addr = column address
    //      size = number of serial data to be read
    task page_read_nobusy;
        input [blck_bits - 1 : 0] blck_addr;
        input [page_bits - 1 : 0] page_addr;
        input [col_bits - 1 : 0] col_addr;
        input [12  : 0]           size;

        reg   [data_bits - 1 : 0] col_addr_1;
        reg   [data_bits - 1 : 0] col_addr_2;
        reg   [data_bits - 1 : 0] row_addr_1;
        reg   [data_bits - 1 : 0] row_addr_2;
        reg   [data_bits - 1 : 0] row_addr_3;
        reg   [12 : 0]            i;
    begin
        // Decode Address
        col_addr_1 [7 : 0] = col_addr [7 : 0];
        col_addr_2 [7 : 0] = {4'b0, col_addr [11 : 8]};
        row_addr_1 [7 : 0] = {blck_addr [1 : 0], page_addr [5 : 0]};
        row_addr_2 [7 : 0] = blck_addr [9 : 2];
        row_addr_3 [7 : 0] = {7'b0, blck_addr [10]};

        // Decode Command
        latch_command (8'h00);
        latch_address (col_addr_1);
        latch_address (col_addr_2);
        latch_address (row_addr_1);
        latch_address (row_addr_2);
        latch_address (row_addr_3);
        latch_command (8'h30);
        #200;
        status_read;
        #100;
        latch_read_status;
        #100;
        latch_read_status;
        #100;
        latch_read_status;
        Re_n = 0;
        wait_ready;
        #100;
        Re_n = 1;
        #100;
        latch_command_ignore_busy (8'h00);
        //Re_n = 1;
        //#100000;
        
        check_ready;
        #tRR_min;

        // Serial Read
    $display ("LATCH READ size=%h", size);
    for (i = 0; i <= size - 1; i = i + 1) begin
            latch_read;
        end
        #tRR_min;
    end
    endtask

    // Random Page Read (00h -> 30h -> 05h -> E0h)
    task random_page_read;
        // First Read Location
        input [blck_bits - 1 : 0] blck_addr;
        input [page_bits - 1 : 0] page_addr;
        input  [col_bits - 1 : 0] col_addr;
        input  [col_bits - 1 : 0] size;
        // Random Read Location
        input  [col_bits - 1 : 0] new_col_addr;
        input  [col_bits - 1 : 0] new_size;
        // Counter
        reg   [data_bits - 1 : 0] col_addr_1;
        reg   [data_bits - 1 : 0] col_addr_2;
        reg   [data_bits - 1 : 0] row_addr_1;
        reg   [data_bits - 1 : 0] row_addr_2;
        reg   [data_bits - 1 : 0] row_addr_3;
        reg   [data_bits - 1 : 0] new_col_addr_1;
        reg   [data_bits - 1 : 0] new_col_addr_2;
        reg   [col_bits  - 1 : 0] i;
    begin
        // Decode First Address
        col_addr_1 [7 : 0] = col_addr [7 : 0];
        col_addr_2 [7 : 0] = {4'b0, col_addr [11 : 8]};
        row_addr_1 [7 : 0] = {blck_addr [1 : 0], page_addr [5 : 0]};
        row_addr_2 [7 : 0] = blck_addr [9 : 2];
        row_addr_3 [7 : 0] = {7'b0, blck_addr [10]};

        // Decode Random Address
        new_col_addr_1 [7 : 0] = new_col_addr [7 : 0];
        new_col_addr_2 [7 : 0] = {4'b0, new_col_addr [11 : 8]};

        // Decode Command
        latch_command (8'h00);
        latch_address (col_addr_1);
        latch_address (col_addr_2);
        latch_address (row_addr_1);
        latch_address (row_addr_2);
        latch_address (row_addr_3);
        latch_command (8'h30);
        wait_ready;

        for (i = 0; i <= size - 1; i = i + 1) begin
            latch_read;
        end

        latch_command (8'h05);
        latch_address (new_col_addr_1);
        latch_address (new_col_addr_2);
        latch_command (8'hE0);

        for (i = 0; i <= new_size - 1; i = i + 1) begin
            latch_read;
        end
        #tRR_min;
    end
    endtask



    // Cashed Page Read (00h -> 30h -> 31h)
    task cached_page_read;
        // First Read Location
        input [blck_bits - 1 : 0] blck_addr;
        input [page_bits - 1 : 0] page_addr;
        input  [col_bits - 1 : 0] col_addr;
        input  [col_bits - 1 : 0] size;
        input  [col_bits - 1 : 0] num_pages;
        // Counter
        reg   [data_bits - 1 : 0] col_addr_1;
        reg   [data_bits - 1 : 0] col_addr_2;
        reg   [data_bits - 1 : 0] row_addr_1;
        reg   [data_bits - 1 : 0] row_addr_2;
        reg   [data_bits - 1 : 0] row_addr_3;
        reg   [col_bits  - 1 : 0] i;
        reg   [col_bits  - 1 : 0] x;
    begin
        // Decode First Address
        col_addr_1 [data_bits - 1 : 0] = col_addr [7 : 0];
        col_addr_2 [data_bits - 1 : 0] = {4'b0, col_addr [11 : 8]};
        row_addr_1 [data_bits - 1 : 0] = {blck_addr [1 : 0], page_addr [5 : 0]};
        row_addr_2 [data_bits - 1 : 0] = blck_addr [9 : 2];
        row_addr_3 [data_bits - 1 : 0] = {7'b0, blck_addr [10]};

        // Decode Random Address

        // Decode Command
        latch_command (8'h00);
        latch_address (col_addr_1);
        latch_address (col_addr_2);
        latch_address (row_addr_1);
        latch_address (row_addr_2);
        latch_address (row_addr_3);
        latch_command (8'h30);
        wait_ready;

        // NOT THE LAST PAGE - ALL OTHERS
        for (x = 1; x <= (num_pages - 1) ; x = x + 1) begin
            latch_command (8'h31);
            wait_ready;
            for (i = 0; i <= size - 1; i = i + 1) begin
                latch_read;
            end
        end

        // THE LAST PAGE
        latch_command (8'h3f);
        wait_ready;
        for (i = 0; i <= size - 1; i = i + 1) begin
            latch_read;
        end
    end
    endtask


    // Program Page (80h -> 10h)
    // blck_addr = block address
    // page_addr = page address
    //  col_addr = column address
    //      data = your first data value
    //      size = number of serial data to be written
    //   pattern = modify data pattern
    //        00 = no change
    //        01 = inc
    //        10 = dec
    //        11 = random
    task program_page;
        input [blck_bits - 1 : 0] blck_addr;
        input [page_bits - 1 : 0] page_addr;
        input [col_bits  - 1 : 0] col_addr;
        input [data_bits - 1 : 0] data;
        input [col_bits  - 1 : 0] size;
        input             [1 : 0] pattern;

        reg   [data_bits - 1 : 0] col_addr_1;
        reg   [data_bits - 1 : 0] col_addr_2;
        reg   [data_bits - 1 : 0] row_addr_1;
        reg   [data_bits - 1 : 0] row_addr_2;
        reg   [data_bits - 1 : 0] row_addr_3;
        reg   [col_bits  - 1 : 0] i;
    begin
        // Decode Address
        col_addr_1 [7 : 0] = col_addr [7 : 0];
        col_addr_2 [7 : 0] = {4'b0, col_addr [11 : 8]};
        row_addr_1 [7 : 0] = {blck_addr [1 : 0], page_addr [5 : 0]};
        row_addr_2 [7 : 0] = blck_addr [9 : 2];
        row_addr_3 [7 : 0] = {7'b0, blck_addr [10]};

        // Decode Command
        latch_command (8'h80);
        latch_address (col_addr_1);
        latch_address (col_addr_2);
        latch_address (row_addr_1);
        latch_address (row_addr_2);
        latch_address (row_addr_3);

        // Decode Pattern
        for (i = 0; i <= size - 1; i = i + 1) begin
            case (pattern)
                2'b00 : latch_data (data);
                2'b01 : latch_data (data + i);
                2'b10 : latch_data (data - i);
                2'b11 : latch_data ({$random} % {data_bits{1'b1}});
            endcase
        end

        // Done Program
        latch_command (8'h10);
        wait_ready;
    end
    endtask

    // Random Program Page (80h -> 85h -> 10h)
    task random_program_page;
        // First Program Location
        input [blck_bits - 1 : 0] blck_addr;
        input [page_bits - 1 : 0] page_addr;
        input  [col_bits - 1 : 0] col_addr;
        input [data_bits - 1 : 0] data;
        input  [col_bits - 1 : 0] size;
        input             [1 : 0] pattern;
        // Random Program Location 1
        input  [col_bits - 1 : 0] new_col_addr1;
        input [data_bits - 1 : 0] new_data1;
        input  [col_bits - 1 : 0] new_size1;
        input             [1 : 0] new_pattern1;
        // Random Program Location 2
        input  [col_bits - 1 : 0] new_col_addr2;
        input [data_bits - 1 : 0] new_data2;
        input  [col_bits - 1 : 0] new_size2;
        input             [1 : 0] new_pattern2;

        reg   [col_bits  - 1 : 0] i0;

        // Counter 1
        reg   [data_bits - 1 : 0] col_addr1_1;
        reg   [data_bits - 1 : 0] col_addr1_2;
        reg   [data_bits - 1 : 0] row_addr1_1;
        reg   [data_bits - 1 : 0] row_addr1_2;
        reg   [data_bits - 1 : 0] row_addr1_3;
        reg   [data_bits - 1 : 0] new_col_addr1_1;
        reg   [data_bits - 1 : 0] new_col_addr1_2;
        reg   [col_bits  - 1 : 0] i1;
        // Counter 2
        reg   [data_bits - 1 : 0] col_addr2_1;
        reg   [data_bits - 1 : 0] col_addr2_2;
        reg   [data_bits - 1 : 0] row_addr2_1;
        reg   [data_bits - 1 : 0] row_addr2_2;
        reg   [data_bits - 1 : 0] row_addr2_3;
        reg   [data_bits - 1 : 0] new_col_addr2_1;
        reg   [data_bits - 1 : 0] new_col_addr2_2;
        reg   [col_bits  - 1 : 0] i2;
    begin
        // Decode First Address
        col_addr1_1 [7 : 0] = col_addr [7 : 0];
        col_addr1_2 [7 : 0] = {4'b0, col_addr [11 : 8]};
        row_addr1_1 [7 : 0] = {blck_addr [1 : 0], page_addr [5 : 0]};
        row_addr1_2 [7 : 0] = blck_addr [9 : 2];
        row_addr1_3 [7 : 0] = {7'b0, blck_addr [10]};

        // Decode Random Address 1
        new_col_addr1_1 [7 : 0] = new_col_addr1 [7 : 0];
        new_col_addr1_2 [7 : 0] = {4'b0, new_col_addr1 [11 : 8]};

        // Decode Random Address 1
        new_col_addr2_1 [7 : 0] = new_col_addr2 [7 : 0];
        new_col_addr2_2 [7 : 0] = {4'b0, new_col_addr2 [11 : 8]};

        // Decode Command
        latch_command (8'h80);
        latch_address (col_addr1_1);
        latch_address (col_addr1_2);
        latch_address (row_addr1_1);
        latch_address (row_addr1_2);
        latch_address (row_addr1_3);

        for (i0 = 0; i0 <= size - 1; i0 = i0 + 1) begin
            case (pattern)
                2'b00 : latch_data (data);
                2'b01 : latch_data (data + i0);
                2'b10 : latch_data (data - i0);
                2'b11 : latch_data ({$random} % {data_bits{1'b1}});
            endcase
        end

        latch_command (8'h85);
        latch_address (new_col_addr1_1);
        latch_address (new_col_addr1_2);

        for (i1 = 0; i1 <= new_size1 - 1; i1 = i1 + 1) begin
            case (new_pattern1)
                2'b00 : latch_data (new_data1);
                2'b01 : latch_data (new_data1 + i1);
                2'b10 : latch_data (new_data1 - i1);
                2'b11 : latch_data ({$random} % {data_bits{1'b1}});
            endcase
        end

        latch_command (8'h85);
        latch_address (new_col_addr2_1);
        latch_address (new_col_addr2_2);

        for (i2 = 0; i2 <= new_size2 - 1; i2 = i2 + 1) begin
            case (new_pattern2)
                2'b00 : latch_data (new_data2);
                2'b01 : latch_data (new_data2 + i2);
                2'b10 : latch_data (new_data2 - i2);
                2'b11 : latch_data ({$random} % {data_bits{1'b1}});
            endcase
        end

        latch_command (8'h10);
        wait_ready;
    end
    endtask


    // Cached Program Page (80h -> 15h)
    // blck_addr = block address
    // page_addr = page address
    //  col_addr = column address
    //      data = your first data value
    //      size = number of serial data to be written
    //   pattern = modify data pattern
    //        00 = no change
    //        01 = inc
    //        10 = dec
    //        11 = random
    task cached_program_page;
        input [blck_bits - 1 : 0] blck_addr;
        input [page_bits - 1 : 0] page_addr;
        input [col_bits  - 1 : 0] col_addr;
        input [data_bits - 1 : 0] data;
        input [col_bits  - 1 : 0] size;
        input             [1 : 0] pattern;

        reg   [data_bits - 1 : 0] col_addr_1;
        reg   [data_bits - 1 : 0] col_addr_2;
        reg   [data_bits - 1 : 0] row_addr_1;
        reg   [data_bits - 1 : 0] row_addr_2;
        reg   [data_bits - 1 : 0] row_addr_3;
        reg   [col_bits  - 1 : 0] i;
    begin
        // Decode Address
        col_addr_1 [data_bits - 1 : 0] = col_addr [7 : 0];
        col_addr_2 [data_bits - 1 : 0] = {4'b0, col_addr [11 : 8]};
        row_addr_1 [data_bits - 1 : 0] = {blck_addr [1 : 0], page_addr [5 : 0]};
        row_addr_2 [data_bits - 1 : 0] = blck_addr [9 : 2];
        row_addr_3 [data_bits - 1 : 0] = {7'b0, blck_addr [10]};

        // Decode Command
        latch_command (8'h80);
        latch_address (col_addr_1);
        latch_address (col_addr_2);
        latch_address (row_addr_1);
        latch_address (row_addr_2);
        latch_address (row_addr_3);

        // Decode Pattern
        for (i = 0; i <= size - 1; i = i + 1) begin
            case (pattern)
                2'b00 : latch_data (data);
                2'b01 : latch_data (data + i);
                2'b10 : latch_data (data - i);
                2'b11 : latch_data ({$random} % {data_bits{1'b1}});
            endcase
        end

        // Done Program
        latch_command (8'h15);
        //wait_ready;
    end
    endtask


    // Internal Data Move (00h -> 35h -> 85h -> 10h)
    task internal_data_move;
        // First Program Location
        input [blck_bits - 1 : 0] blck_addr;
        input [page_bits - 1 : 0] page_addr;
        input  [col_bits - 1 : 0] col_addr;
        // Random Program Location
        input [blck_bits - 1 : 0] new_blck_addr;
        input [page_bits - 1 : 0] new_page_addr;
        input  [col_bits - 1 : 0] new_col_addr;
        // Task variables
        reg   [data_bits - 1 : 0] col_addr_1;
        reg   [data_bits - 1 : 0] col_addr_2;
        reg   [data_bits - 1 : 0] row_addr_1;
        reg   [data_bits - 1 : 0] row_addr_2;
        reg   [data_bits - 1 : 0] row_addr_3;
        reg   [data_bits - 1 : 0] new_col_addr_1;
        reg   [data_bits - 1 : 0] new_col_addr_2;
        reg   [data_bits - 1 : 0] new_row_addr_1;
        reg   [data_bits - 1 : 0] new_row_addr_2;
        reg   [data_bits - 1 : 0] new_row_addr_3;
    begin
        // Decode First Address
        col_addr_1 [7 : 0] = col_addr [7 : 0];
        col_addr_2 [7 : 0] = {4'b0, col_addr [11 : 8]};
        row_addr_1 [7 : 0] = {blck_addr [1 : 0], page_addr [5 : 0]};
        row_addr_2 [7 : 0] = blck_addr [9 : 2];
        row_addr_3 [7 : 0] = {7'b0, blck_addr [10]};

        // Decode New Address
        new_col_addr_1 [7 : 0] = new_col_addr [7 : 0];
        new_col_addr_2 [7 : 0] = {4'b0, new_col_addr [11 : 8]};
        new_row_addr_1 [7 : 0] = {new_blck_addr [1 : 0],new_page_addr [5 : 0]};
        new_row_addr_2 [7 : 0] = new_blck_addr [9 : 2];
        new_row_addr_3 [7 : 0] = {7'b0, new_blck_addr [10]};

        // Decode Command (00h -> 35h)
        latch_command (8'h00);
        latch_address (col_addr_1);
        latch_address (col_addr_2);
        latch_address (row_addr_1);
        latch_address (row_addr_2);
        latch_address (row_addr_3);
        latch_command (8'h35);
        wait_ready;

        // Decode Command (85h -> 10h)
        latch_command (8'h85);
        latch_address (new_col_addr_1);
        latch_address (new_col_addr_2);
        latch_address (new_row_addr_1);
        latch_address (new_row_addr_2);
        latch_address (new_row_addr_3);
        latch_command (8'h10);
        wait_ready;
    end
    endtask

    // Random Internal Data Move (00h -> 35h -> 85h -> 10h)
    task random_internal_data_move;
        // First Program Location
        input [blck_bits - 1 : 0] blck_addr;
        input [page_bits - 1 : 0] page_addr;
        input  [col_bits - 1 : 0] col_addr;
        // Random Program Location
        input [blck_bits - 1 : 0] new_blck_addr;
        input [page_bits - 1 : 0] new_page_addr;
        input  [col_bits - 1 : 0] new_col_addr;
        input [data_bits - 1 : 0] data;
        input  [col_bits - 1 : 0] size;
        input             [1 : 0] pattern;
        // Task variables
        reg   [data_bits - 1 : 0] col_addr_1;
        reg   [data_bits - 1 : 0] col_addr_2;
        reg   [data_bits - 1 : 0] row_addr_1;
        reg   [data_bits - 1 : 0] row_addr_2;
        reg   [data_bits - 1 : 0] row_addr_3;
        reg   [data_bits - 1 : 0] new_col_addr_1;
        reg   [data_bits - 1 : 0] new_col_addr_2;
        reg   [data_bits - 1 : 0] new_row_addr_1;
        reg   [data_bits - 1 : 0] new_row_addr_2;
        reg   [data_bits - 1 : 0] new_row_addr_3;
        reg   [col_bits  - 1 : 0] i;
    begin
        // Decode First Address
        col_addr_1 [7 : 0] = col_addr [7 : 0];
        col_addr_2 [7 : 0] = {4'b0, col_addr [11 : 8]};
        row_addr_1 [7 : 0] = {blck_addr [1 : 0], page_addr [5 : 0]};
        row_addr_2 [7 : 0] = blck_addr [9 : 2];
        row_addr_3 [7 : 0] = {7'b0, blck_addr [10]};

        // Decode New Address
        new_col_addr_1 [7 : 0] = new_col_addr [7 : 0];
        new_col_addr_2 [7 : 0] = {4'b0, new_col_addr [11 : 8]};
        new_row_addr_1 [7 : 0] = {new_blck_addr [1 : 0],new_page_addr [5 : 0]};
        new_row_addr_2 [7 : 0] = new_blck_addr [9 : 2];
        new_row_addr_3 [7 : 0] = {7'b0, new_blck_addr [10]};

        // Decode Command (00h -> 35h)
        latch_command (8'h00);
        latch_address (col_addr_1);
        latch_address (col_addr_2);
        latch_address (row_addr_1);
        latch_address (row_addr_2);
        latch_address (row_addr_3);
        latch_command (8'h35);
        wait_ready;

        // Decode Command (85h -> 10h)
        latch_command (8'h85);
        latch_address (new_col_addr_1);
        latch_address (new_col_addr_2);
        latch_address (new_row_addr_1);
        latch_address (new_row_addr_2);
        latch_address (new_row_addr_3);

        for (i = 0; i <= size - 1; i = i + 1) begin
            case (pattern)
                2'b00 : latch_data (data);
                2'b01 : latch_data (data + i);
                2'b10 : latch_data (data - i);
                2'b11 : latch_data ({$random} % {data_bits{1'b1}});
            endcase
        end

        latch_command (8'h10);
        wait_ready;
    end
    endtask

    // Initial Conditions
    initial begin
        Pre  = 1;
        Cle  = 0;
        Ce_n = 0;
        Ce_n2 = 1;
        We_n = 1;
        Ale  = 0;
        Re_n = 1;
        Wp_n = 1;
        //Io = {data_bits{1'bz}};
    end

    // Test Vectors
    initial begin
    $display ("START TEST VECTOR");

        #1000;
        $display ("Starting power-on auto read for 3.3 Volt part");
        PO_read; 

        //#200
        page_read (0, 0, 0, 1056);
        #200
        page_read_nobusy (0, 0, 0, 1056);
        #200

        // RANDOM PROGRAM PAGE //////////////////////////////////////////////////////////////
        random_program_page(1,1,0,0,num_col,1, 3,3,3,2, 6,0,2,1);

        // First Program Location
        //input [blck_bits - 1 : 0] blck_addr;
        //input [page_bits - 1 : 0] page_addr;
        //input  [col_bits - 1 : 0] col_addr;
        //input [data_bits - 1 : 0] data;
        //input  [col_bits - 1 : 0] size;
        //input             [1 : 0] pattern;

        // Random Program Location 1
        //input  [col_bits - 1 : 0] new_col_addr;
        //input [data_bits - 1 : 0] new_data;
        //input  [col_bits - 1 : 0] new_size;
        //input             [1 : 0] new_pattern;

        // Random Program Location 2
        //input  [col_bits - 1 : 0] new_col_addr;
        //input [data_bits - 1 : 0] new_data;
        //input  [col_bits - 1 : 0] new_size;
        //input             [1 : 0] new_pattern;

        page_read(1, 1, 0, num_col); //starting_blck_addr, starting_page_addr, col_addr, size;

        // END RANDOM PROGRAM PAGE //////////////////////////////////////////////////////////////

        //cached_page_read(0, 0, 0, num_col, 3); //starting_blck_addr, starting_page_addr, col_addr, size, #ofPages;
        //#200
        //status_read;
        //latch_read_status;
        //#200
        //erase_block (1'b0); // erase_block waits for rb_n to come high before return
        //#80
        //status_read;
        //latch_read_status;
        //#80
        //cached_page_read(0, 0, 0, num_col, 3); //starting_blck_addr, starting_page_addr, col_addr, size, #ofPages;
        //#80
////
        //status_read;
        //latch_read_status;
        //#80
        //program_page (0, 0, 0, 8'h00, num_col, 2'b01);
        //#80
        //status_read;
        //latch_read_status;
        //#80
        //program_page (0, 1, 0, 8'h00, num_col, 2'b10);
        //#80
////
        //cached_page_read(0, 0, 0, num_col, 3); //starting_blck_addr, starting_page_addr, col_addr, size, #ofPages;
////
        //cached_program_page(4, 1, 0, 8'hff, num_col, 2'b10); //blck_addr; page_addr; col_addr; data; size; pattern; 
        //#100
        //status_read;
        //wait_ready;
        ////latch_read_status;
        //#60
        //reset;
////
        //cached_program_page(4, 1, 0, 8'hff, num_col, 2'b10); //blck_addr; page_addr; col_addr; data; size; pattern; 
        //#100
        //status_read;
//
        //latch_read_status;
        //#80
        //latch_read_status;
        //#1180
        //latch_read_status;
        //#580
        //wait_ready;
        #580

       $display("At time %t: SIMULATION ENDING NORMALLY", $time);

    end

    // reset (FFh) - 
    task reset;
    begin
        reset_latch_command (8'hFF);
        wait_ready;
    end
    endtask

    // Read ID (90h) - 
    task read_id;
    begin
        latch_command (8'h90);
        latch_address (0);
        #tWHR_min
        latch_read;   // Byte 0
        latch_read;   // Byte 1
        latch_read;   // Byte 2
        latch_read;   // Byte 3
        //latch_read;   // Byte 4
        //latch_read;   // Byte 5
    end
    endtask

    // Read ID UNIQUE
    task read_unique;  // Not inherited from read_id, rather from page_read
    reg [12:0] i;
    begin
        latch_command (8'h30);
        latch_command (8'h65);
        latch_command (8'h00);
        latch_address (0);
        latch_address (0);
        latch_address (2);
        latch_address (0);
        latch_address (0);
        latch_command (8'h30);
        check_ready;
        #tRR_min;
        // Serial Read
        for (i = 0; i <= 255; i = i + 1) 
           begin
              latch_read;   // Byte 0
           end
        #tRR_min;
    end
    endtask


endmodule
