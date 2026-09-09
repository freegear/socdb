/*
 Test Bench for internal SMC for AHB
 
 
 */

`timescale 1ns/1ns

`define    CKP1  30
`define    DLY   2

module         Atb_ismc;

   parameter               ADDR_WIDTH = 15;
   parameter 			   DATA_WIDTH = 32;

   
   reg 					   rstb; 
   reg 					   clk; 
   
   reg 					   ahb_sel;
   reg 					   ahb_readyin;
   reg [1:0] 			   ahb_htrans;
   reg [ADDR_WIDTH-1:0]    ahb_addr;
   reg 					   ahb_write;
   reg [2:0] 			   ahb_size;
   reg [DATA_WIDTH-1:0]    ahb_wdata;
   wire [DATA_WIDTH-1:0]   ahb_rdata;
   wire 				   ahb_ready;
   wire [1:0] 			   ahb_resp;
   
   // Sync. SRAM interface
   wire 				   sram_csb;
   wire [ADDR_WIDTH-3:0]   sram_addr;
   wire [3:0] 			   sram_wrb;
   wire 				   sram_oeb;
   wire [DATA_WIDTH-1:0]   sram_dout;
   wire [DATA_WIDTH-1:0]   sram_din;

   //reg 					   dphase;
   
   
   initial begin
	  rstb  = 0;
	  clk   = 0;

	  repeat(20) @(posedge clk);
	  #`DLY rstb = 1;
	  
   end
   
   always #`CKP1      clk = ~clk;

   
   ismc_ahb       ismc_ahb
	 (
	  .clk              ( clk ),
	  
	  .rstb             ( rstb ),
	  
	  .ahb_sel          ( ahb_sel ),
	  .ahb_readyin      ( ahb_readyin ),
	  .ahb_htrans       ( ahb_htrans ),
	  .ahb_addr         ( ahb_addr ),
	  .ahb_write        ( ahb_write ),
	  .ahb_size         ( ahb_size ),
	  .ahb_wdata        ( ahb_wdata ),
	  .ahb_rdata        ( ahb_rdata ),
	  .ahb_ready        ( ahb_ready ),
	  .ahb_resp         ( ahb_resp ),
	  
	  .sram_csb         ( sram_csb ),
	  .sram_addr        ( sram_addr ),
	  .sram_wrb         ( sram_wrb ),
	  .sram_oeb         ( sram_oeb ),
	  .sram_dout        ( sram_dout ),
	  .sram_din         ( sram_din )
	  
//	  .sram_octrl       ( ~rstb )
	  );
   

   RA1SH6144x32_8    inter_sram_24k
	 (
	  .Q             ( sram_dout ),
	  .CLK           ( clk ),
	  .CEN           ( sram_csb ),
	  .WEN           ( sram_wrb ),
	  .A             ( sram_addr ),
	  .D             ( sram_din ),
	  .OEN           ( sram_oeb )
	  );

   
   //---------------------------------------------------------
   initial begin
	  ahb_sel = 0;
	  ahb_htrans = 0;
	  ahb_write = 0;
	  ahb_addr = 15'h0000;
	  ahb_size = 0; // 32bit
	  ahb_wdata = 0;
	  ahb_readyin = 1'b1;
	  
	  wait(rstb);
	  repeat(20) @(posedge clk);

	  //=============================================================
	  // write test
	  //=============================================================
	  
	  //***************************
	  @(posedge clk) #`DLY
	  //-------------------
	  //   address : 0x0010, 32bit, data : 0x0000_3456
		ahb_sel = 1;
	  ahb_htrans = 2'h1;
	  ahb_write = 1;
	  ahb_addr = 15'h0010;
	  ahb_size = 2; // 32bit
	  
	  //***************************
	  @(posedge clk) #`DLY
				 ahb_wdata = 32'h00003456;

	  //-------------------
	  //   address : 0x0018, 32bit, data : 0x1289_0000
	  ahb_sel = 1;
	  ahb_write = 1;
	  ahb_addr = 15'h0018;
	  ahb_size = 2; // 32bit
	  wait(ahb_ready);
	  
	  //***************************
	  @(posedge clk) #`DLY
				 ahb_wdata = 32'h12890000;

	  //-------------------
	  //   address : 0x011a, 16bit, data : 0xabfe_0110
	  ahb_sel = 1;
	  ahb_write = 1;
	  ahb_addr = 15'h011a;
	  ahb_size = 1; // 16bit
	  wait(ahb_ready);
	  
	  //***************************
	  @(posedge clk) #`DLY
				 ahb_wdata = 32'habfe0110;

	  //-------------------
	  //   address : 0x011c, 16bit, data : 0xfffe_0416
	  ahb_sel = 1;
	  ahb_write = 1;
	  ahb_addr = 15'h011c;
	  ahb_size = 1; // 16bit
	  wait(ahb_ready);
	  
	  //***************************
	  @(posedge clk) #`DLY
				 ahb_wdata = 32'hfffe0416;

	  //-------------------
	  //   address : 0x011e, 8bit, data : 0x015a_3290
	  ahb_sel = 1;
	  ahb_write = 1;
	  ahb_addr = 15'h011e;
	  ahb_size = 0; // 8bit
	  wait(ahb_ready);
	  
	  //***************************
	  @(posedge clk) #`DLY
				 ahb_wdata = 32'h015a3290;

	  //-------------------
	  //   address : 0x011f, 8bit, data : 0x39aa_3196
	  ahb_sel = 1;
	  ahb_write = 1;
	  ahb_addr = 15'h011f;
	  ahb_size = 0; // 8bit
	  wait(ahb_ready);
	  
	  //***************************
	  @(posedge clk) #`DLY
				 ahb_wdata = 32'h39aa3196;
	  ahb_sel = 0;
	  ahb_write = 0;
	  ahb_htrans = 0;
	  
	  repeat(6) @(posedge clk);

	  //========================================================
	  // read test
	  //========================================================
	  
	  //***************************
	  @(posedge clk) #`DLY
	  //-------------------
	  //   address : 0x0010, 32bit, data : 0x0000_3456
		ahb_sel = 1;
	  ahb_htrans = 2'h1;
	  ahb_write = 0;
	  ahb_addr = 15'h0010;
	  ahb_size = 2; // 32bit
	  
	  //***************************
	  @(posedge clk) #`DLY;

	  
	  //-------------------
	  //   address : 0x0018, 32bit, data : 0x1289_0000
	  ahb_sel = 1;
	  ahb_write = 0;
	  ahb_addr = 15'h0018;
	  ahb_size = 2; // 32bit
	  wait(ahb_ready);
	  
	  //***************************
	  @(posedge clk) #`DLY;

	  
	  //-------------------
	  //   address : 0x011a, 16bit, data : 0xabfe_0110
	  ahb_sel = 1;
	  ahb_write = 0;
	  ahb_addr = 15'h011a;
	  ahb_size = 1; // 16bit
	  wait(ahb_ready);
	  
	  //***************************
	  @(posedge clk) #`DLY;
	  

	  //-------------------
	  //   address : 0x011c, 16bit, data : 0xfffe_0416
	  ahb_sel = 1;
	  ahb_write = 0;
	  ahb_addr = 15'h011c;
	  ahb_size = 1; // 16bit
	  wait(ahb_ready);
	  
	  //***************************
	  @(posedge clk) #`DLY;
	  
	  //-------------------
	  //   address : 0x011e, 8bit, data : 0x015a_3290
	  ahb_sel = 1;
	  ahb_write = 0;
	  ahb_addr = 15'h011e;
	  ahb_size = 0; // 8bit
	  wait(ahb_ready);
	  
	  //***************************
	  @(posedge clk) #`DLY;
	  

	  //-------------------
	  //   address : 0x011f, 8bit, data : 0x39aa_3196
	  ahb_sel = 1;
	  ahb_write = 0;
	  ahb_addr = 15'h011f;
	  ahb_size = 0; // 8bit
	  wait(ahb_ready);
	  
	  //***************************
	  @(posedge clk) #`DLY;
	  ahb_sel = 0;
	  ahb_htrans = 0;
	  
	  repeat(5) @(posedge clk);
	  
	  //==========================================================
	  // read after write cycle
	  //==========================================================
	  
	  #`DLY ahb_sel = 1;
  	  ahb_htrans = 2'h1;
	  ahb_write = 1;
	  ahb_addr = 15'h0204;
	  ahb_size = 2; // 32bit
	  //***************************
	  @(posedge clk) #`DLY
	  			 ahb_wdata = 32'h12345670;

	  #`DLY ahb_sel = 1;
	  ahb_write = 1;
	  ahb_addr = 15'h0200;
	  ahb_size = 2; // 32bit
	  wait(ahb_ready);
	  //***************************
	  @(posedge clk) #`DLY
	  			 ahb_wdata = 32'h005affc1;
	  
	  ahb_write = 0; // read command
	  ahb_addr = 15'h0204;
	  ahb_size = 2;
	  wait(ahb_ready);
	  //***************************
	  @(posedge clk) #`DLY;
  	  ahb_htrans = 2'h0;
	  
	  wait(ahb_ready);
	  ahb_sel = 0;

	  repeat(5) @(posedge clk);

	  $stop;
	  
   end // initial begin
   
   
endmodule // Atb_ismc


