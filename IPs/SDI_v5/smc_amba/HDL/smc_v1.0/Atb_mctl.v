/**************************************************************
   Test Bench for SMC with AHB
 
   created : 2006.2.23 
 

**************************************************************/

`timescale 1ns/1ns

`define     CKP1  30
`define     DLY   2


module    Atb_mctl;


   reg                clk; 
   reg 				  rstb; 

   reg 				  apb_enable;
   reg 				  apb_sel;
   reg [3:2] 		  apb_addr;
   reg 				  apb_write;
   reg [31:0] 		  apb_wdata;
   
   wire [31:0] 		  apb_rdata;

   reg 				  ahb_sel0;   // bank 0
   reg 				  ahb_sel1;   // bank 1
   reg 				  ahb_sel2;   // bank 2
   reg 				  ahb_sel3;   // bank 3

   reg 				  ahb_readyin;
   reg [1:0] 		  ahb_htrans;
   reg [19:0] 		  ahb_addr;
   reg 				  ahb_write;
   reg [2:0] 		  ahb_size;
   reg [31:0] 		  ahb_wdata;
   wire [31:0] 		  ahb_rdata;
   wire 			  ahb_ready;
   
   wire [ 3:0] 		  ext_cs;
   wire [ 1:0] 		  ext_be; 
   wire [19:0] 		  ext_adr; 
   wire [ 1:0] 		  ext_wbe; 
   wire 			  ext_we; 
   wire [15:0] 		  ext_wdata;
//   wire [15:0] 		  ext_rdata;
   wire 			  ext_bidoe;
   
   wire [7:0] 		  sram_data_h;
   wire [7:0] 		  sram_data_l;

   initial begin
	  clk = 1;
	  rstb = 0;
	  apb_enable = 0;
	  apb_sel = 0;
	  apb_addr = 0;
	  apb_write = 0;
	  apb_wdata = 0;

	  ahb_sel0 = 0;
	  ahb_sel1 = 0;
	  ahb_sel2 = 0;
	  ahb_sel3 = 0;
	  ahb_readyin = 1'b1;
	  ahb_htrans = 2'h0;
	  ahb_addr = 0;
	  ahb_write = 0;
	  ahb_size = 0;
	  ahb_wdata = 0;


	  repeat(20) @(posedge clk);
	  #`DLY rstb = 1;
   end // initial begin
   
   
   always #`CKP1      clk  = ~clk;


   mem_ctrl           mem_ctrl
	 ( 
	   .clk                ( clk ),
	   .resetx             ( rstb ),
	   
	   .apb_enable         ( apb_enable ),
	   .apb_sel            ( apb_sel ),
	   .apb_addr           ( apb_addr ),
	   .apb_write          ( apb_write ),
	   .apb_wdata          ( apb_wdata ),
	   .apb_rdata          ( apb_rdata ),	
	   
	   .ahb_sel0           ( ahb_sel0 ),
	   .ahb_sel1           ( ahb_sel1 ),
	   .ahb_sel2           ( ahb_sel2 ),
	   .ahb_sel3           ( ahb_sel3 ),
	   .ahb_readyin        ( ahb_readyin ),
	   .ahb_htrans         ( ahb_htrans ),
	   .ahb_addr           ( ahb_addr ),
	   .ahb_write          ( ahb_write ),
	   .ahb_size           ( ahb_size ),
	   .ahb_wdata          ( ahb_wdata ),
	   .ahb_rdata          ( ahb_rdata ),
	   .ahb_ready          ( ahb_ready ),
	   
	   .ext_cs             ( ext_cs ),
	   .ext_be             ( ext_be ),
	   .ext_adr            ( ext_adr ), 
	   .ext_wbe            ( ext_wbe ), 
	   .ext_we             ( ext_we ), 
	   .ext_oe             ( ext_oe ), 
	   .ext_wdata          ( ext_wdata ),
	   .ext_rdata          ( {sram_data_h,sram_data_l} ),
	   .ext_bidoe          ( ext_bidoe )
	   );

   sram16bit     sram16_b0
	 ( 
	   .data     ( {sram_data_h,sram_data_l} ),
	   .addr     ( ext_adr[18:1] ),
	   .wrb_0    ( ~ext_wbe[0] ),
	   .wrb_1    ( ~ext_wbe[1] ),
	   .rdb      ( ~ext_oe ),
	   .csb      ( ~ext_cs[0] )
	   );

   sram8bit      sram8_b1
	 (
	  .data      ( sram_data_l ), 
	  .addr      ( ext_adr[17:0] ), 
	  .we_n      ( ~ext_wbe[0] ), 
	  .oe_n      ( ~ext_oe ), 
	  .cs_n      ( ~ext_cs[1] )
	  );
   assign   #2 	sram_data_h = (ext_bidoe == 1'b1)? ext_wdata[15:8] : 'hz;
   assign	#2  sram_data_l = (ext_bidoe == 1'b1)? ext_wdata[7:0]  : 'hz;

  
   //-----------------------------------------------
   // Tasks

   //  reg write
   task reg_write;
	  input   [1:0] addr;
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
	  input   [1:0] addr;
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
	  input [3:0] bank;
	  input [19:0] addr;
	  input [2:0] size;
	  input [31:0] data;
	  begin
		 @(posedge clk) #`DLY
		   ahb_write = 1'b1;
		 ahb_sel0 = bank[0];
		 ahb_sel1 = bank[1];
		 ahb_sel2 = bank[2];
		 ahb_sel3 = bank[3];
		 ahb_htrans = 2'h1;
		 ahb_size = size;
		 
		 if(size == 3'h0)
		   ahb_addr = addr;
		 else if(size == 3'h1)
		   ahb_addr = {addr[19:1],1'b0};
		 else 
		   ahb_addr = {addr[19:2],2'b00};
		 
		 wait(ahb_ready);
		 
		 @(posedge clk) #`DLY
		   ahb_write = 1'b0;
		 ahb_htrans = 2'h0;
		 ahb_wdata = data;
		 
		 wait(ahb_ready);
	  end
   endtask // mem_write

   // mem read
   task mem_read;
	  input [3:0] bank;
	  input [19:0] addr;
	  input [2:0] size;
	  begin
		 @(posedge clk) #`DLY
		   ahb_write = 1'b0;
		 ahb_sel0 = bank[0];
		 ahb_sel1 = bank[1];
		 ahb_sel2 = bank[2];
		 ahb_sel3 = bank[3];
		 ahb_htrans = 2'h1;
		 ahb_size = size;
		 
		 if(size == 3'h0)
		   ahb_addr = addr;
		 else if(size == 3'h1)
		   ahb_addr = {addr[19:1],1'b0};
		 else 
		   ahb_addr = {addr[19:2],2'b00};
		 
		 wait(ahb_ready);
		 
		 @(posedge clk) #`DLY
		   ahb_write = 1'b0;
		 ahb_htrans = 2'h0;
		 
		 wait(ahb_ready);
	  end
   endtask // mem_write


   //======================================================
   // Simulation Sequence

   initial begin
	  wait(rstb);
	  repeat(10) @(posedge clk);

	  // register write test
	  // bank 0
	  reg_write(2'h0,{4'h0,2'h2,2'h1,4'h3,2'h0,6'h00,2'h0,2'h2,4'h5,2'h1,1'b0,1'b1});
	  // bank 1
	  reg_write(2'h1,{4'h0,2'h3,2'h0,4'h1,2'h1,6'h00,2'h2,2'h0,4'h4,2'h0,1'b0,1'b0});
	  // bank 2
	  reg_write(2'h2,{4'h0,2'h0,2'h3,4'ha,2'h3,6'h00,2'h3,2'h1,4'hF,2'h2,1'b0,1'b1});
	  // bank 3
	  reg_write(2'h3,{4'h0,2'h1,2'h2,4'h0,2'h2,6'h00,2'h1,2'h3,4'h8,2'h0,1'b0,1'b0});
	  
	  repeat(3) @(posedge clk);
	  
	  // register write test
	  reg_read(2'h0);
	  reg_read(2'h1);
	  reg_read(2'h2);
	  reg_read(2'h3);

	  repeat(5) @(posedge clk);
	  //--------------------------
	  // Mem access test
	  // bank 0
	  reg_write(2'h0,{4'h0,2'h1,2'h1,4'ha,2'h2,6'h00,2'h1,2'h1,4'ha,2'h1,1'b0,1'b1});
	  // bank 1
	  reg_write(2'h1,{4'h0,2'h1,2'h1,4'ha,2'h2,6'h00,2'h1,2'h1,4'ha,2'h1,1'b0,1'b0});

	  // bank 0
	  // 32bit write
	  mem_write(1,16,2,32'h12345601);
	  mem_write(1,20,2,32'habcdef02);
	  // 16bit write
	  mem_write(1,24,1,32'h03aa5a03);
	  mem_write(1,26,1,32'h9f03ffff);
	  // 8bit wirte
	  mem_write(1,28,0,32'hffffff04);
	  mem_write(1,29,0,32'hffff12ff);
	  mem_write(1,30,0,32'hff34ffff);
	  mem_write(1,31,0,32'h56ffffff);

	  repeat(15) @(posedge clk);

	  // bank 1
	  // 32bit write
	  mem_write(2,04,2,32'h12345601);
	  mem_write(2,08,2,32'habcdef02);
	  // 16bit write
	  mem_write(2,12,1,32'h03aa5a03);
	  mem_write(2,14,1,32'h9f03ffff);
	  // 8bit wirte
	  mem_write(2,40,0,32'hffffff04);
	  mem_write(2,41,0,32'hffff12ff);
	  mem_write(2,42,0,32'hff34ffff);
	  mem_write(2,43,0,32'h56ffffff);

	  repeat(15) @(posedge clk);

	  // bank 0
	  // 32bit read
	  mem_read(1,16,2);
	  mem_read(1,20,2);
	  // 16bit read
	  mem_read(1,24,1);
	  mem_read(1,26,1);
	  // 8bit wirte
	  mem_read(1,28,0);
	  mem_read(1,29,0);
	  mem_read(1,30,0);
	  mem_read(1,31,0);

	  wait(ahb_ready);
	  repeat(15) @(posedge clk);
	  
	  // bank 1
	  // 32bit read
	  mem_read(2,04,2);
	  mem_read(2,08,2);
	  // 16bit read
	  mem_read(2,12,1);
	  mem_read(2,14,1);
	  // 8bit wirte
	  mem_read(2,40,0);
	  mem_read(2,41,0);
	  mem_read(2,42,0);
	  mem_read(2,43,0);

	  wait(ahb_ready);
	  repeat(10) @(posedge clk);
	  $stop;
	  
   end // initial begin
   
endmodule // tb_mctl


