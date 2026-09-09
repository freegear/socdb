
//*****************************************************************************
//  K9F4G08U0M, 4Gbit(x8) 1st Generation NAND FLASH TIMING VECTOR
//  Programmed By NAND Flash Memory Design Team, Samsung Semiconductor Co. LTD.
//  Rev. 0.0 -- Hyun -- Dec 2005
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
	$dumpvars ();
	$dumpfile("./tb_interleave.dump");
	$shm_open ("./tb_interleave.shm");
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

	#1000;
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'h30);

    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.
    ceb = 1'b1;

 # 1000;


    status;             // status 
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
#1000;

// Erase 1st Block chip1
$display ("2X Erase 1st Block chip1");
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);

    cmd_latch(8'h60);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'hD0);

	#100000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
	#100000;
//    cmd_latch(8'hff);

@(posedge rbb);

	#100000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
	#100000;

// Erase 1st Block chip2
$display ("2X Erase 1st Block chip2");
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);

    cmd_latch(8'h60);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h04);
    cmd_latch(8'hD0);

        #10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

	#10000;
//    cmd_latch(8'hff);

    @(posedge rbb) 
	#10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
	#10000;

// 2X Erase Chip interleave
 $display ("2X Erase chip interleave");
// Erase 1st Block chip1_mat1
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
// Erase 1st Block chip1_mat2
    cmd_latch(8'h60);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'hD0);

    #500000;
// Erase 1st Block chip2_mat1
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
// Erase 1st Block chip2_mat2
    cmd_latch(8'h60);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h04);
    cmd_latch(8'hD0);

    @(posedge rbb) #100
        #1000

    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
#10000;

// Erase 1st Block chip1
$display ("2X Erase 1st Block chip1");
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);

    cmd_latch(8'h60);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'hD0);

	#100000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

@(posedge rbb);

	#100000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
	#100000;

// Erase 1st Block chip2
$display ("2X Erase 1st Block chip2");
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);

    cmd_latch(8'h60);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h04);
    cmd_latch(8'hD0);

        #10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

//	#500000;
 //   cmd_latch(8'hff);

    @(posedge rbb) 
	#10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
	#10000;


// Read chip1 mat1
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'h30);

    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.
    ceb = 1'b1;
        #1000

// Read chip1 mat2
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'h30);

    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.
    ceb = 1'b1;
        #1000
// Read chip2 mat1
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
    cmd_latch(8'h30);

    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.
    ceb = 1'b1;
        #1000

// Read chip2 mat2
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h04);
    cmd_latch(8'h30);

    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.
    ceb = 1'b1;
        #1000


// Erase 1st Block chip1
 $display ("Erase chip interleave");
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'hD0);

	#500000;

// Erase 1st Block chip2
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
    cmd_latch(8'hD0);

    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.
        #1000

    status;             // status

#10000;

// 2X Erase Chip interleave
 $display ("2X Erase chip interleave");
// Erase 1st Block chip1_mat1
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
// Erase 1st Block chip1_mat2
    cmd_latch(8'h60);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'hD0);

    #500000;
// Erase 1st Block chip2_mat1
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
// Erase 1st Block chip2_mat2
    cmd_latch(8'h60);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h04);
    cmd_latch(8'hD0);

	#10000;
//    cmd_latch(8'hff);
    @(posedge rbb) #100
        #1000

    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
#10000;
// Erase 1st Block chip1
 $display ("Erase chip interleave");
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'hD0);

	#500000;

// Erase 1st Block chip2
    cmd_latch(8'h60);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
    cmd_latch(8'hD0);

    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

	#100000;
  //  cmd_latch(8'hff);
    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.
        #1000



#10000;


// Program on the 1st Page chip1
 $display ("2X Program chip1");
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
	#100000;
//    cmd_latch(8'hff);

    @(posedge rbb)	
	#10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

	#10000;

// Program on the 1st Page chip2
 $display ("2X Program chip2");
    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h11);
        #500;
    cmd_latch(8'h81);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);
    //add_latch(8'hff);
    add_latch(8'h04);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h10);
        
        #10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

	#80000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
	#100000;
    //cmd_latch(8'hff);

    @(posedge rbb)
    	#10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

        #10000;

// Program on the 1st Page chip1
 $display ("2X Program chip interleave");
    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h11);
        #10000;
    cmd_latch(8'h81);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h00);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h10);
	
	#10000;

    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h11);
        #10000;
    cmd_latch(8'h81);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h04);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h10);
	
	#10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
	#100000;
    //cmd_latch(8'hff);

@(posedge rbb);
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
	#10000;

// Program on the 1st Page chip1
 $display ("2X Program chip1");
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
	#100000;
//    cmd_latch(8'hff);

    @(posedge rbb)	
	#10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

	#10000;

// Program on the 1st Page chip2
 $display ("2X Program chip2");
    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h11);
        #500;
    cmd_latch(8'h81);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);
    //add_latch(8'hff);
    add_latch(8'h04);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h10);
        
        #10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

	#80000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

    @(posedge rbb)
    	#10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

        #10000;

// Read chip1 mat1
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'h30);

    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.
    ceb = 1'b1;
        #1000

// Read chip1 mat2
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h00);
    cmd_latch(8'h30);

    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.
    ceb = 1'b1;
        #1000
// Read chip2 mat1
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
    cmd_latch(8'h30);

    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.
    ceb = 1'b1;
        #1000

// Read chip2 mat2
    cmd_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h04);
    cmd_latch(8'h30);

    @(posedge rbb) #100
    serial_read(16'h840); // Reading the 1st block's 1st page.
    ceb = 1'b1;
        #1000

// Program interleave
 $display ("Program chip interleave");
    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h10);

	#10000;

    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h10);

        #10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

    @(posedge rbb) #100

	#10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
#10000;

// Program on the 1st Page chip1
 $display ("2X Program chip interleave");
    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h11);
        #10000;
    cmd_latch(8'h81);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h00);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h10);
	
	#10000;

    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
    data_latch(10'h100,8'h00);
	#100000;
//    cmd_latch(8'hff);

    cmd_latch(8'h11);
        #10000;
    cmd_latch(8'h81);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h40);
    add_latch(8'h00);
    add_latch(8'h04);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h10);
	
	#10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

@(posedge rbb);
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
	#10000;

// Program interleave
 $display ("Program chip interleave");
    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h10);

	#10000;

    cmd_latch(8'h80);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h00);
    add_latch(8'h04);
    data_latch(10'h100,8'h00);

    cmd_latch(8'h10);

        #10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status

    @(posedge rbb) #100

	#10000;
    chip_status (1'b0); // chip1 status
    chip_status (1'b1); // chip2 status
#10000;

	

  $finish;
end
endmodule  
