//*****************************************************************************
//  K9F4G08U0M, 4Gbit(x8) 1st Generation NAND FLASH TIMING VECTOR
//  Programmed By NAND Flash Memory Design Team, Samsung Semiconductor Co. LTD.
//  Rev. 0.0 -- D.H.Chae -- Aug 8, 2001
//  Rev. 1.0 -- Hyun     -- Dec 2005
//*****************************************************************************

`timescale 1ns/1ps
`include "./k9f4g08u0a.v"

`define PWRUP	50000	// Wait Time : Should be longer than tR
			// for Power-up Auto Read

module nand_driver();
reg     [7:0]   io;
wire    [7:0]   i_o=io;
reg    	ceb, cle, ale, web, reb, wpb, vdd;

integer i;

k9f4g08u0a  flash(.ceb(ceb), .cle(cle), .ale(ale), 
		.web(web), .reb(reb), .io(i_o), 
		.wpb(wpb), .rbb(rbb), .vdd(vdd));

initial
begin
	$dumpvars();
	$dumpfile("tb_normal.dump");
	$shm_open ("tb_normal.shm",1,,);
	$shm_probe ("AS");
end

// Initialization : Standby
initial
begin
	vdd = 0;
	ceb = 1; cle = 0; ale = 0;
	web = 1; reb = 1; 
	io  = 8'hzz; 
	wpb = 1;
end  

`include "./task.v"


//******************************
// User Test Vector Here
//******************************

initial
begin
	#1000
    vdd = 1'b1;
	#`PWRUP
    ceb = 1'b0;
    serial_read(16'h840); // Power-up Auto Read
   
// Read operation
    cmd_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h40); // Reading the 1st block's 1st page.
	#1000;
    status;             // status
   // chip_status (1'b0); // chip1 status
   // chip_status (1'b1); // chip2 status

    cmd_latch(8'h00);
    ceb = 1'b0;
	#3;
    serial_read(16'h40); // Continue Reading
	#5000;

// Random data out
    cmd_latch(8'h05);
    add_latch(8'h20);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'hE0);
    ceb = 1'b0;
	#3;
    serial_read(16'h40); // Random Data Out
	ceb = 1'b1;
#1000;

    cmd_latch(8'h05);
    add_latch(8'h00);
    add_latch(8'h01);
    cmd_latch(8'hE0);
    ceb = 1'b0;
	#3
    serial_read(16'h40); // Random Data Out

    ceb = 1'b1;
	#1000
	
// Read operation
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 2nd block's 1st page.
    ceb = 1'b1;
	
        #1000

// ID Read
    cmd_latch(8'h90);
    add_latch(8'h00);
        #100
    serial_read(16'h9);
        #1000

// Erase 1st Block
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'hD0);
    #10000;
    status;             // status
    //chip_status (1'b0); // chip1 status
    //chip_status (1'b1); // chip2 status
    @(posedge rbb) #100
    status;             // status
    //chip_status (1'b0); // chip1 status
    //chip_status (1'b1); // chip2 status
        ceb = 1'b1;
        #1000 

// Read 1st Page
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.	
    ceb = 1'b1;
	#1000
// Program
    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);	
    add_latch(8'h00);	
    data_latch(10'h100,8'h00);
    cmd_latch(8'h10);
    ceb = 1'b0;
    #10000;
    status;             // status
//    chip_status (1'b0); // chip1 status
//    chip_status (1'b1); // chip2 status

    @(posedge rbb) #100

    
// 2X Program 
    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);	
    add_latch(8'h00);	
    data_latch(10'h100,8'h00);

    cmd_latch(8'h11);
	#500;
    cmd_latch(8'h81);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);	
    add_latch(8'h00);	
    data_latch(10'h100,8'h00);

    cmd_latch(8'h10);
    ceb = 1'b0;
    @(posedge rbb) #100
    #10000;
    status;             // status
    //chip_status (1'b0); // chip1 status
    //chip_status (1'b1); // chip2 status
    ceb = 1'b1;
	#1000

// Read 1st Page
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.	
    ceb = 1'b1;
	#1000

// Read 10th Page
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h0A);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 10th page.	
    ceb = 1'b1;
	#1000

// Program with Random Data In : 10th Page
    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h0A);
    add_latch(8'h00);	
    add_latch(8'h00);	
    data_latch(10'h100,8'h00);
    cmd_latch(8'h85);
    add_latch(8'h30);
    add_latch(8'h00);
    data_latch(10'h20,8'h10);
    cmd_latch(8'h10);
    ceb = 1'b0;
    @(posedge rbb) #100
    status;             // status
    //chip_status (1'b0); // chip1 status
    //chip_status (1'b1); // chip2 status
        #100000;
    ceb = 1'b1;
	#1000

// Read 10th Page
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h0A);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 10th page.	
    ceb = 1'b1;
	#1000

// Read 1st Page
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.	
    ceb = 1'b1;
	#1000

// Read 2nd Page
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h01);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 2nd page.	
    ceb = 1'b1;
	#1000

// Read 3rd Page
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h02);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 3rd page.	
    ceb = 1'b1;
	#1000

// Read 4th Page
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h03);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 4th page.	
    ceb = 1'b1;
	#1000

// Read 5th Page
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 5th page.	
    ceb = 1'b1;
	#1000

//-----------
// Page Copy
//-----------

// Read Source Page
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.	
    ceb = 1'b1;
	#1000

// Read Destination Page
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h20);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 33rd page.	
    ceb = 1'b1;
	#1000

// Page Copy
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h35);	// Inverse Read the Source Page
    ceb = 1'b0;
    @(posedge rbb) #100
    cmd_latch(8'h85);
    add_latch(8'h00);
    add_latch(8'h01);
    add_latch(8'h20);
    add_latch(8'h00);	
    add_latch(8'h00);	
    data_latch(16'h100,8'h00);
    cmd_latch(8'h10);	// Copy Back
    ceb = 1'b0;
    #10000
    cmd_latch(8'h7B);
	#3
    serial_read(16'h1);
    @(posedge rbb) #100
  //  cmd_latch(8'h70);    // Status Check Command 
    cmd_latch(8'h7B);    // Status Check Command 
        ceb = 1'b0;
	#18
    serial_read(16'h1);
    ceb = 1'b1;
	#1000

// Read Destination Page
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h20);
    add_latch(8'h00);	
    add_latch(8'h00);	
    cmd_latch(8'h30);
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 33rd page.	
    ceb = 1'b1;
	#1000



// Block Erase
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'hd0);
    #10000;
    status;             // status
    //chip_status (1'b0); // chip1 status
    //chip_status (1'b1); // chip2 status
    
    @(posedge rbb) #100
    status;             // status
    //chip_status (1'b0); // chip1 status
    //chip_status (1'b1); // chip2 status
    

    #1000;

    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h02);
    add_latch(8'h00);
    add_latch(8'h00);//modified
    cmd_latch(8'h30);   // Read the Source Page After Block Erase
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'd100);

    #1000;

    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h02);
    add_latch(8'h00);
    add_latch(8'h00);
    data_latch(16'd100,8'h00);
    cmd_latch(8'h10);   // Program the sorce Page
    @(posedge rbb) #100

    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h02);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'h30);   // Read the Source Page After Page Prgram
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'd100);

    #1000;
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h03);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'h30);   // Read the Target Page Before Copy Program
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'd100);

    #1000;


    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h02);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'h35);   // Copy Read the Source Page 
    ceb = 1'b0;
    @(posedge rbb) #100

    cmd_latch(8'h85);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h03);
    add_latch(8'h00);	
    add_latch(8'h00);
    data_latch(16'd100,8'haa); // data in for Copy Program the Target Page

    cmd_latch(8'h85);
    add_latch(8'h10);
    add_latch(8'h01);
    data_latch(16'd100,8'h00); // Random data in during Copy Program (change column address)

    cmd_latch(8'h10);	// Copy Program the Target Page 
    ceb = 1'b0;
    @(posedge rbb) #100

    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h03);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'h30);   // Read the Source Page
    ceb = 1'b0;
    @(posedge rbb) #100
    serial_read(16'd110);
    ceb = 1'b0;
	#100;
    cmd_latch(8'h05); // random data out
    add_latch(8'h10);
    add_latch(8'h01);
    cmd_latch(8'he0);
    ceb = 1'b0;
    serial_read(16'd110); // Read changed column address

    #1000;

// 2X Erase
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'h60);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'hD0);
    @(posedge rbb) #100
    #1000;

  $finish;
end
endmodule  
