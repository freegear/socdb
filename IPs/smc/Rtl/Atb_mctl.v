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
   wire [1:0] 		  ahb_resp;
   
   wire [ 3:0] 		  ext_csb;
   wire [ 3:0] 		  ext_beb; 
   wire [19:0] 		  ext_adr; 
   wire [ 3:0] 		  ext_wbeb; 
   wire 			  ext_web; 
   wire 			  ext_oeb;
   wire [31:0] 		  ext_wdata;
//   wire [15:0] 		  ext_rdata;
   wire 			  ext_bidoe;
   
   wire [7:0] 		  sram_data_0;
   wire [7:0] 		  sram_data_1;
   wire [7:0] 		  sram_data_2;
   wire [7:0] 		  sram_data_3;

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

   always #10         ahb_readyin = ahb_ready;
   
/*
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
	   .ahb_resp           ( ahb_resp ),
	   
	   .ext_csb            ( ext_csb ),
	   .ext_beb            ( ext_beb ),
	   .ext_adr            ( ext_adr ), 
	   .ext_wbeb           ( ext_wbeb ), 
	   .ext_web            ( ext_web ), 
	   .ext_oeb            ( ext_oeb ), 
	   .ext_wdata          ( ext_wdata ),
	   .ext_rdata          ( {sram_data_h,sram_data_l} ),
	   .ext_bidoe          ( ext_bidoe )
	   );
*/
   
   SMC_top   SMC_top 
	 (
	  //AHB SIGNAL
	  .HCLK             ( clk ),
	  .HRESETn          ( rstb ),
	  .HADDR            ( ahb_addr ),
	  .HTRANS           ( ahb_htrans ),
	  .HWRITE           ( ahb_write ),
	  .HSIZE	        ( ahb_size ),
	  .HWDATA           ( ahb_wdata ),
	  .HSEL0            ( ahb_sel0 ),
	  .HSEL1            ( ahb_sel1 ),
	  .HSEL2            ( ahb_sel2 ),
	  .HSEL3            ( ahb_sel3 ),
	  .HREADY_in        ( ahb_readyin ),
	  .HREADY_out       ( ahb_ready ),
	  .HRESP            ( ahb_resp ),
	  .HRDATA           ( ahb_rdata ),
	  
	  //APB SIGNAL
	  .PCLK             ( clk ),
	  .PRESETn          ( rstb ),
	  .PADDR            ( apb_addr ),
	  .PSEL             ( apb_sel ),
	  .PENABLE          ( apb_enable ),
	  .PWRITE           ( apb_write ),
	  .PWDATA           ( apb_wdata ),
	  .PRDATA           ( apb_rdata ),

	  .EXT_ADDR         ( ext_adr ),
	  .EXT_WDATA        ( ext_wdata ),
	  .EXT_RDATA        ( {sram_data_3,sram_data_2,sram_data_1,sram_data_0} ),
	  .EXT_CSb          ( ext_csb ),
	  .EXT_OEb          ( ext_oeb ),
	  .EXT_WEb          ( ext_web ),
	  .EXT_BEb          ( ext_beb ),
	  .EXT_WBEb         ( ext_wbeb ),
	  .EXT_BIDEN        ( ext_bidoe )
	  );

   assign   #2 	sram_data_3 = (ext_bidoe == 1'b1)? ext_wdata[31:24] : 8'hzz;
   assign	#2  sram_data_2 = (ext_bidoe == 1'b1)? ext_wdata[23:16] : 8'hzz;
   assign   #2 	sram_data_1 = (ext_bidoe == 1'b1)? ext_wdata[15:8]  : 8'hzz;
   assign	#2  sram_data_0 = (ext_bidoe == 1'b1)? ext_wdata[7:0]   : 8'hzz;


   sram16bit     sram16_b0
	 ( 
	   .data     ( {sram_data_1,sram_data_0} ),
	   .addr     ( ext_adr[18:1] ),
	   .ble_n    ( ext_beb[0] ),
	   .bhe_n    ( ext_beb[1] ),
	   .we_n     ( ext_web ),
	   .oe_n     ( ext_oeb ),
	   .cs_n     ( ext_csb[0] )
	   );

   sram8bit      sram8_b1
	 (
	  .data      ( sram_data_0 ), 
	  .addr      ( ext_adr[17:0] ), 
	  .we_n      ( ext_web ),
	  .oe_n      ( ext_oeb ), 
	  .cs_n      ( ext_csb[1] )
	  );

   sram32bit     sram32_b2
	 ( 
	   .data     ( {sram_data_3,sram_data_2,sram_data_1,sram_data_0} ),
	   .addr     ( ext_adr[17:0] ),
	   .be0_n    ( ext_beb[0] ),
	   .be1_n    ( ext_beb[1] ),
	   .be2_n    ( ext_beb[2] ),
	   .be3_n    ( ext_beb[3] ),
	   .oe_n     ( ext_oeb ),
	   .we_n     ( ext_web ),
	   .cs_n     ( ext_csb[2] )
	   );
  
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

		 ahb_addr = addr;
		 
		 /*
		 if(size == 3'h0)
		   ahb_addr = addr;
		 else if(size == 3'h1)
		   ahb_addr = {addr[19:1],1'b0};
		 else 
		   ahb_addr = {addr[19:2],2'b00};
		 */
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

		 ahb_addr = addr;		 
		 /*
		 if(size == 3'h0)
		   ahb_addr = addr;
		 else if(size == 3'h1)
		   ahb_addr = {addr[19:1],1'b0};
		 else 
		   ahb_addr = {addr[19:2],2'b00};
		 */
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
	  reg_write(2'h0,{11'h000,3'h2,3'h1,4'he,3'h0,3'h2,2'h1,2'h0});
	  // bank 1
	  reg_write(2'h1,{11'h000,3'h0,3'h7,4'hf,3'h3,3'h0,2'h3,2'h1});
	  // bank 2
	  reg_write(2'h2,{11'h000,3'h5,3'h0,4'ha,3'h1,3'h7,2'h0,2'h3});
	  // bank 3
	  reg_write(2'h3,{11'h000,3'hf,3'h7,4'h7,3'h6,3'h5,2'h2,2'h0});
	  
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
	  reg_write(2'h0,{11'h000,3'h7,3'h1,4'h1,3'h2,3'h2,2'h1,2'h0});

	  // bank 1
	  reg_write(2'h1,{11'h000,3'h2,3'h3,4'h5,3'h1,3'h2,2'h0,2'h0});

	  // bank 2
	  reg_write(2'h2,{11'h000,3'h0,3'h0,4'h0,3'h0,3'h0,2'h2,2'h2});

	  // bank 0
	  // 32bit write
	  mem_write(1,16,2,32'h12345601);
	  mem_write(1,22,2,32'habcdef02);
	  // 16bit write
	  mem_write(1,25,1,32'h03aa5a03);
	  mem_write(1,26,1,32'h9f03ffff);
	  // 8bit write
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
	  // 8bit write
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
	  // 8bit read
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
	  // 8bit read
	  mem_read(2,40,0);
	  mem_read(2,41,0);
	  mem_read(2,42,0);
	  mem_read(2,43,0);

	  wait(ahb_ready);
	  repeat(10) @(posedge clk);

	  // bank 2
	  // 8bit
	  mem_write(4,20'h00100,0,32'h00000067);
	  mem_write(4,20'h00101,0,32'h00004500);
	  mem_write(4,20'h00102,0,32'h00230000);
	  mem_write(4,20'h00103,0,32'h01000000);
	  // 16bit
	  mem_write(4,20'h00104,1,32'h00003d3d);
	  mem_write(4,20'h00106,1,32'h5a5a0000);
	  // 32bit
	  mem_write(4,20'h00108,1,32'h5a5a0000);

	  // read
	  // 8bit
	  mem_read(4,20'h00100,0);
	  mem_read(4,20'h00101,0);
	  mem_read(4,20'h00102,0);
	  mem_read(4,20'h00103,0);

	  mem_read(4,20'h00104,0);
	  mem_read(4,20'h00105,0);
	  mem_read(4,20'h00106,0);
	  mem_read(4,20'h00107,0);

	  mem_read(4,20'h00108,0);
	  mem_read(4,20'h00109,0);
	  mem_read(4,20'h0010a,0);
	  mem_read(4,20'h0010b,0);

	  // 16bit
	  mem_read(4,20'h00100,1);
	  mem_read(4,20'h00102,1);

	  mem_read(4,20'h00104,1);
	  mem_read(4,20'h00106,1);
	  
	  mem_read(4,20'h00108,1);
	  mem_read(4,20'h0010a,1);
	  
	  // 32bit
	  mem_read(4,20'h00100,2);
	  mem_read(4,20'h00104,2);
	  mem_read(4,20'h00108,2);

	  $stop;
	  
   end // initial begin
   
endmodule // tb_mctl


   
