/************************************************************
   Test Bench for Flash memory controller
  
   file name : Atb_fmc.v
 
   created by gtlee
 
   date : 2006.3.5
 
   note :

 ************************************************************/
`timescale 1ns/1ns

`define     CKP1  7
`define     DLY   2


module     Atb_fmc;

   reg                 clk;
   reg 				   rstb;
   
   reg 				   ahb_sel;
   wire 			   ahb_readyin;
   reg [1:0] 		   ahb_trans;
   reg [17:0] 		   ahb_addr;
   reg 				   ahb_write;
   reg [2:0] 		   ahb_size;
   
   wire [31:0] 		   ahb_rdata;
   wire 			   ahb_ready;
   wire [1:0] 		   ahb_resp;
   
   // apb
   reg 				   apb_enable;
   reg 				   apb_sel;
   reg [5:0] 		   apb_addr;
   reg 				   apb_write;
   reg [31:0] 		   apb_wdata;
   wire [31:0] 		   apb_rdata;
   
   
   // Flash Memory Test Pin
   reg 				   fmt_en;  // flash memory test enable
   reg 				   fmt_tmr;
   wire 			   fmt_vpp ;
   wire [2:0] 		   fmt_tm ;
   reg 				   fmt_mas1;
   reg 				   fmt_ifren;
   reg 				   fmt_xe;
   reg 				   fmt_ye;
   reg 				   fmt_erase;
   
   ifmc_top    Top
	 (
	  .clk                   ( clk ),
	  .apb_clk               ( clk ),
	  .rstb                  ( rstb ),
	  
	  .ahb_sel               ( ahb_sel ),
	  .ahb_readyin           ( ahb_readyin ),
	  .ahb_trans             ( ahb_trans ),
	  .ahb_addr              ( ahb_addr[17:2] ),
	  .ahb_write             ( ahb_write ),
	  .ahb_size              ( ahb_size ),
	  
	  .ahb_rdata             ( ahb_rdata ),
	  .ahb_ready             ( ahb_ready ),
	  .ahb_resp              ( ahb_resp ),
	  
	  .apb_enable            ( apb_enable ),
	  .apb_sel               ( apb_sel ),
	  .apb_addr              ( apb_addr[5:2] ),
	  .apb_write             ( apb_write ),
	  .apb_wdata             ( apb_wdata ),
	  .apb_rdata             ( apb_rdata ),
	  
	  // Flash memory test pins
	  .fmt_en                ( fmt_en ),
	  .fmt_tmr               ( fmt_tmr ),
	  .fmt_vpp               ( fmt_vpp ),
	  .fmt_tm                ( fmt_tm ),
	  .fmt_mas1              ( fmt_mas1 ),
	  .fmt_ifren             ( fmt_ifren ),
	  .fmt_xe                ( fmt_xe ),
	  .fmt_ye                ( fmt_ye ),
	  .fmt_erase             ( fmt_erase )
	  );

   
   initial     begin
	  clk = 1;
	  rstb = 0;
	  ahb_sel = 0;
//	  ahb_readyin = 1;
	  ahb_trans = 0;
	  ahb_addr = 0;
	  ahb_write = 0;
	  ahb_size = 0;

	  apb_enable = 0;
	  apb_sel = 0;
	  apb_addr = 0;
	  apb_write = 0;
	  apb_wdata = 0;
	  
	  fmt_en = 0;
	  fmt_tmr = 1;
	  fmt_mas1 = 0;
	  fmt_ifren = 0;
	  fmt_xe = 0;
	  fmt_ye = 0;
	  fmt_erase = 0;
	  
	  

	  repeat(20) @(posedge clk);
	  #`DLY rstb = 1;
   end // initial begin

   always #`CKP1      clk  <= ~clk;

   assign #3 ahb_readyin = ahb_ready;
      
   //-----------------------------------------------
   // Tasks

   //  reg write
   task reg_write;
	  input   [5:0] addr;
	  input   [31:0] data;
	  begin
		 @(posedge clk) #`DLY
		   apb_enable = 1'b0;
		 apb_sel = 1'b1;
		 apb_write = 1'b1;
		 apb_addr = addr;
		 apb_wdata = data;
		 
		 @(posedge clk) #`DLY 
		   apb_enable = 1'b1;

		 @(posedge clk) #`DLY
		   apb_enable = 1'b0;
		 apb_sel = 1'b0;
		 apb_write = 1'b0;
		 apb_wdata = 0;
		 
		 @(posedge clk) #`DLY;
	  end
   endtask // reg_write

   //  reg read
   task reg_read;
	  input   [5:0] addr;
	  begin
		 @(posedge clk) #`DLY
		   apb_enable = 1'b0;
		 apb_sel = 1'b1;
		 apb_write = 1'b0;
		 apb_addr = addr;
		 
		 @(posedge clk) #`DLY 
		   apb_enable = 1'b1;

		 @(posedge clk) #`DLY
		   apb_enable = 1'b0;
		 apb_sel = 1'b0;
		 apb_write = 1'b0;
		 apb_wdata = 0;
		 
		 @(posedge clk) #`DLY;
	  end
   endtask // reg_write

  
   // mem write
   task mem_write;
	  input [19:0] addr;
	  input [2:0] size;
	  input [31:0] data;
	  begin
		 @(posedge clk) #`DLY
		   ahb_sel = 1;
		 ahb_write = 1'b1;
		 ahb_trans = 2'h1;
		 ahb_size = size;
		 
		 if(size == 3'h0)
		   ahb_addr = addr;
		 else if(size == 3'h1)
		   ahb_addr = {addr[19:1],1'b0};
		 else 
		   ahb_addr = {addr[19:2],2'b00};
		 
		 wait(ahb_ready);
		 
		 @(posedge clk) #`DLY
		   ahb_sel = 0;
		 ahb_write = 1'b0;
		 ahb_trans = 2'h0;
		 
		 wait(ahb_ready);
	  end
   endtask // mem_write

   // mem read
   task mem_read;
	  input [19:0] addr;
	  input [2:0] size;
	  begin
		 @(posedge clk) #`DLY
		   ahb_sel = 1;
		 ahb_write = 1'b0;
		 ahb_trans = 2'h1;
		 ahb_size = size;
		 
		 if(size == 3'h0)
		   ahb_addr = addr;
		 else if(size == 3'h1)
		   ahb_addr = {addr[19:1],1'b0};
		 else 
		   ahb_addr = {addr[19:2],2'b00};
		 
		 wait(ahb_ready);
		 
		 @(posedge clk) #`DLY
		   ahb_sel = 0;
		 ahb_write = 1'b0;
		 ahb_trans = 2'h0;
		 
		 wait(ahb_ready);
	  end
   endtask // mem_write


   //======================================================
   // Simulation Sequence

   initial begin
	  wait(rstb);
	  repeat(10) @(posedge clk);

	  // ¿¬¼Ó 2¹ø read
	  
	  ahb_sel = 1;
	  ahb_write = 1'b0;
	  ahb_trans = 2'h1;
	  ahb_size = 2;
		 
	  ahb_addr = 18'h00004;
	  
	  @(posedge clk) #`DLY
		ahb_addr = 18'h00008;
	  
		 wait(ahb_ready);
		 
	  @(posedge clk) #`DLY
		ahb_sel = 0;
	  ahb_trans = 0;
	  
	  repeat(10) @(posedge clk);

	  // register write test
	  reg_write(0, 32'h12343567);
	  reg_write(0, 32'h5a5a5a5a);
	  reg_write(4, 32'h00002aa5);
	  reg_write(8, 32'h145300df);

	  repeat(5) @(posedge clk);
	  
	  // register write test
	  reg_read(0);
	  reg_read(4);
	  reg_read(8);

	  // flash memory read
	  repeat(5) @(posedge clk);
	  mem_read(0,2);
	  mem_read(4,2);
	  mem_read(16,2);

	  	  
	  // flash programming. page 0.
	  reg_write(6'h00, 32'h5a5a5a5a);   // key 
	  reg_write(6'h04, 32'h00000000);   // address register
	  reg_write(6'h08, 32'h3c3c1f00);   // data register
	  reg_write(6'h0C, {22'h000000,10'b0011001100}); // program

//	  repeat(50000/(2*`CKP1)) @(posedge clk);

	  mem_read(0,2);
	  repeat(10) @(posedge clk);

	  // flash programming. page 32.
	  reg_write(6'h00, 32'h5a5a5a5a);   // key 
	  reg_write(6'h04, 32'h00008000);   // address register
	  reg_write(6'h08, 32'h00111222);   // data register
	  reg_write(6'h0C, {22'h000000,10'b0011001100}); // program

//	  repeat(50000/(2*`CKP1)) @(posedge clk);

	  mem_read(20'h08000,2);
	  repeat(10) @(posedge clk);
	  
	  // Smart option write
	  reg_write(6'h00, 32'h5a5a5a5a);   // key 
	  reg_write(6'h04, 32'h00000E38);   // address register
	  reg_write(6'h08, 32'h0000FFFD);   // data register
	  reg_write(6'h0C, {22'h000000,10'b0011101000}); // program information area

	  repeat(50000/(2*`CKP1)) @(posedge clk);

	  // Protection option write
	  reg_write(6'h00, 32'h5a5a5a5a);   // key 
	  reg_write(6'h04, 32'h00000E3C);   // address register
	  reg_write(6'h08, 32'hFFFDFFFF);   // data register
	  reg_write(6'h0C, {22'h000000,10'b0011101000}); // program information area

	  repeat(50000/(2*`CKP1)) @(posedge clk);

	  // Page Erase. Page Num 0
	  reg_write(6'h00, 32'h5a5a5a5a);   // key 
	  reg_write(6'h04, 32'h00000000);   // address register
	  reg_write(6'h0C, {22'h000000,10'b0011001010}); // program information area

	  repeat(22000000/(2*`CKP1)) @(posedge clk);

	  // Page Erase. Page Num 32
	  reg_write(6'h00, 32'h5a5a5a5a);   // key 
	  reg_write(6'h04, 32'h00008000);   // address register
	  reg_write(6'h0C, {22'h000000,10'b0011001010}); // program information area

	  repeat(22000000/(2*`CKP1)) @(posedge clk);

	  // checking erase
	  mem_read(0,2);
	  repeat(10) @(posedge clk);

	  mem_read(20'h08000,2);
	  repeat(10) @(posedge clk);

	  // read infomation block
	  reg_write(6'h0C, {21'h000000,11'b10000000000}); // program information area

	  //          read smart option
	  mem_read({15'h000E,2'b00},2);
	  repeat(10) @(posedge clk);
	  
	  //          read protection option
	  mem_read({15'h000F,2'b00},2);
	  repeat(10) @(posedge clk);

	  // read main memory block
	  reg_write(6'h0C, {21'h000000,11'b00000000000}); // program information area
	  
	  /*
	  // flash memory erase
	  reg_write(6'h00, 32'h5a5a5a5a); // key
	  reg_write(6'h0C, {22'h000000,10'b1111001001}); // all erase
	  
	  repeat(22000000/(2*`CKP1)) @(posedge clk);
	   */
	  
	  repeat(10) @(posedge clk);
	  $display("End Simulation");
	  $stop;
	  
   end
   
endmodule // Atb_fmc

