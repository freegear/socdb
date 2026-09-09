/************************************************************
   GPU test bench
  
   file name : Atb_v8_base.v
 
   created by gtlee
 
   date : 2006.6.20
 
   note :
        
   history :
 
 ************************************************************/
`timescale 1ns/10ps

`define     CKP1  7
`define     DLY   2

`define     ROM_LENGTH 100

module  Atb_v8_base;

   parameter                ADDRWIDTH = 16;
   parameter 				CDATAWIDTH = 8;
   parameter 				PDATAWIDTH = 32;

   reg 						clk;
   reg 						rstb;
   
   reg 						set_addr;
   reg [ADDRWIDTH-1:0] 		acc_addr;

   reg 						write; // assert when PENABLE actived at write
   reg [CDATAWIDTH-1:0] 	wdata;
   
   reg 						read; // assert when PSEL actived at read
   wire [CDATAWIDTH-1:0] 	rdata;
   
   reg 						run;   // sub processor run/stop

   wire [CDATAWIDTH-1:0] 	romdata;
   reg [13:0] 				addr; // rom address
   

   
   initial begin
	  clk = 1;
	  rstb = 0;
	  
	  repeat(20) @(posedge clk);
	  #`DLY rstb = 1;
   end // initial


   always #`CKP1      clk  <= ~clk;

  
   v8_base_top    v8_base_top
	 (
	  .clk              ( clk ),
	  .rstb             ( rstb ),
	  
	  .set_addr         ( set_addr ),
	  .acc_addr         ( acc_addr ),
	  
	  .write            ( write ),
	  .wdata            ( wdata ),
	  
	  .read             ( read ),
	  .rdata            ( rdata ),
	  
	  .run              ( run )
	  );


   irom   rom
	 (
	  .clk       ( clk ),
	  .addr      ( addr ),
	  .oeb       ( 1'b0 ),
	  .csb       ( 1'b0 ),
	  .romdata   ( romdata )
	  );


  
   
   initial begin
	  set_addr = 0;
	  acc_addr = 0;
	  write = 0;
	  wdata = 0;
	  read = 0;
	  run = 0;
   end // initial
   
   // set address
   task set_address;
	  input [ADDRWIDTH-1:0] init_addr;
	  begin
		 set_addr = 0;
		 acc_addr = init_addr;
		 @(posedge clk) #`DLY
		   set_addr = 1;
		 addr = 0;
		 @(posedge clk) #`DLY
		   set_addr = 0;
	  end
   endtask // set_addr

   task write_data;
	  begin
		 // read rom
		 write = 0;
		 @(posedge clk) #`DLY
		   wdata = romdata;
		 // set write signal
		 write = 1;
		 @(posedge clk) #`DLY
		   write = 0;
		 addr = addr + 1;
	  end
   endtask // write_data
   
   task read_data;
	  begin
		 read = 0;
		 @(posedge clk) #`DLY
		   read = 1;
		 @(posedge clk) #`DLY
		   read = 0;
	  end
   endtask // read_data
   
   //======================================================
   // Simulation Sequence
   integer   i;
   
   initial begin
	  wait(rstb);
	  repeat(10) @(posedge clk);

	  // force set download
	  run = 0;
	  
	  // address reset
	  set_address(0);

	  // write code
	  for(i=0;i<`ROM_LENGTH;i=i+1) begin
		write_data();
	  end

	  repeat(10) @(posedge clk);
	  
	  // address reset
	  set_address(0);

	  // read code
	  for(i=0;i<`ROM_LENGTH;i=i+1) begin
		read_data();
	  end

	  repeat(10) @(posedge clk);

	  // force set run
	  run = 1;
	  
   end // initial begin
   
   
   
endmodule // Atb_v8_base
